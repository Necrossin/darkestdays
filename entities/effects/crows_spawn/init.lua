local util = util
local math = math
ClientsideModel = ClientsideModel

function EFFECT:Init(data)
	self.DieTime = CurTime() + 0.3

	
	self.ent = data:GetEntity()
	
	if IsValid(self.ent) then
		self.start = self.ent:GetShootPos()+self.ent:GetAimVector()*math.random(30,35)
	else
		self.start = data:GetOrigin()
	end
	
	self.gib = math.Round(data:GetMagnitude()) or 1
	
	self.to = data:GetOrigin()
		
	self.Crows = ClientsideModel("models/crow.mdl", RENDERGROUP_TRANSLUCENT)
	self.Crows:AddEffects(EF_NODRAW)
	
	self.rad = math.random(30,70)
	
	WorldSound("npc/crow/hop1.wav",self.start,100,100,1)
	WorldSound("npc/crow/hop2.wav",self.start,100,100,1)
	WorldSound("npc/crow/die1.wav",self.start,100,math.random(70,100),1)
	WorldSound("npc/crow/die2.wav",self.start,100,math.random(70,100),1)
end

local function VecEqual(v1,v2)
	local res = false
	
	local x = math.floor(v1.x) == math.floor(v2.x)
	local y = math.floor(v1.y) == math.floor(v2.y)
	local z = math.floor(v1.z) == math.floor(v2.z)

	if x and y and z then
		res = true
	end
	
	return res
end

function EFFECT:Think()

	self.Entity:SetRenderBounds(Vector(-528, -528, -528), Vector(528, 528, 528))
	self.Crows:SetCycle((self.Crows:GetCycle() + RealFrameTime( ) / self.Crows:SequenceDuration()) % 1)	
	
	self.CurPos = self.CurPos or self.start
	
	local norm = (self.to - self.start):GetNormal()
	
	self.CurPos = LerpVector(FrameTime()*7,self.CurPos,self.to)//self.CurPos + norm

	if VecEqual(self.CurPos,self.to) or CurTime() > self.DieTime then
		SafeRemoveEntity(self.Crows)
		
		if self.gib == 1 then			
			local effectdata = EffectData()
			effectdata:SetEntity(self.Entity)
			effectdata:SetOrigin(self.CurPos or self.to )
			effectdata:SetNormal(norm)
			effectdata:SetScale(0)
			effectdata:SetRadius( 0 )
			util.Effect( "gib_player", effectdata, true, true )
		end
		return false
	end
	
	return true
end

function EFFECT:Render()


	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	
	local norm = (self.to - self.start):GetNormal():Angle()
			
	if not self.NextSeq then self.NextSeq = {} end
	
	self.CurPos = self.CurPos or self.start
	
	local pos = self.CurPos
	
	for i=1,7 do
		
		self.NextSeq[i] = self.NextSeq[i] or 0
		self.Crows:SetPlaybackRate( 1+i*0.12 )
		if self.NextSeq[i] <= CurTime() then
			self.Crows:SetSequence(self.Crows:LookupSequence(math.random(2) == 1 and "Takeoff" or "Fly01")) 
			self.NextSeq[i] = CurTime() + self.Crows:SequenceDuration( )
		end
		
		
		local rad = (self.rad or 40)*i

		self.Crows:SetPos(pos+norm:Forward()*(-30+4*i)+norm:Right()*math.sin( math.rad( rad*i ) ) * 20+norm:Up()*math.cos( math.rad( rad*i ) ) * 12)
		self.Crows:SetAngles(norm)


		self.Crows:SetupBones()
		self.Crows:SetModelScale(0.8,0)
		self.Crows:DrawModel()
			
	end

	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)

end

