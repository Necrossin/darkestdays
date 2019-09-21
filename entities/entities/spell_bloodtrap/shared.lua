ENT.Name = "Blood Trap"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 40
ENT.Damage = 65

ENT.CastGesture = ACT_SIGNAL_FORWARD

if SERVER then
	AddCSLuaFile("shared.lua")
end

local table = table
local pairs = pairs

PrecacheParticleSystem( "v_bloodtrap" )
PrecacheParticleSystem( "bloodtrap" )

if SERVER then
function ENT:OnInitialize()
	self.Traps = {}
end
end

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine(
		{
			start = self.EntOwner:GetShootPos(), 
			endpos = self.EntOwner:GetShootPos() + aimvec * 600, 
			filter = self.EntOwner:GetMeleeFilter()
		}
	)
	
	if trace.Hit and trace.HitWorld and not trace.HitSky and SERVER and trace.HitNormal.z < -0.5 then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos)
	else
		self.EntOwner._efCantCast = CurTime() + 1
	end
	

end

function ENT:CreateTrap(pos)
	
	local count = #self.Traps
	
	if count >= 4 then
		local toremove = self.Traps[1]
		if toremove and IsValid(toremove) then
			toremove:Remove()
			self.Traps[1] = nil
			table.Resequence(self.Traps)
		end
	end
	
	local trap = ents.Create("projectile_bloodtrap")
	trap:SetPos(pos+vector_up*-2)
	trap:SetAngles(Angle(90,0,0))
	trap.EntOwner = self.EntOwner
	trap:SetOwner( self.EntOwner )
	trap:SetDTEntity(0,self.Entity)
	trap:Spawn()
	
	table.insert(self.Traps,trap)
	
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnThink()
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
end

function ENT:OnDraw()
	//if self:GetPos():Distance(EyePos()) > 1190 then return end
	local owner = self.EntOwner

	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("bloodtrap",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
	/*
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	if LocalPlayer() == owner then return end
	
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Forearm")
		
		self.NextEmit = self.NextEmit or 0
		
		if self.NextEmit > CurTime() then return end
		
		self.NextEmit = CurTime() + 0.005
		
		if bone then
			local pos, ang = owner:GetBonePosition(bone)	
			
			local LightColor = render.GetLightColor( pos ) * 255
			LightColor.r = math.Clamp( LightColor.r, 70, 255 )
			
			for i=1,math.random(2,3) do
				local particle = self.Emitter:Add("particle/smokestack", pos+ang:Forward()*math.Rand(2,10) +VectorRand()*2.6 )
				particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.8, 1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(1, 1.5))
				particle:SetColor(math.random(50,115), 0, 0)
				particle:SetEndSize(math.Rand(0,1.5))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(VectorRand()*(math.sin(RealTime()*1)*20)+vector_up*-20)
				particle:SetLighting(true)
				particle:SetCollide(true)
				particle:SetAirResistance(12)	
			end

			if math.random(1,2) == 1 then
				local particle = self.Emitter:Add("effects/blooddrop", pos+ang:Forward()*math.Rand(2,10) +VectorRand()*2.4 )
				particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(1, 3))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(1)
				particle:SetColor( LightColor.r*0.5, 0, 0 )
				particle:SetGravity(Vector(0, 0, math.Rand(-300, -150)))
				particle:SetCollide(true)
				particle:SetAirResistance(12)
				particle:SetCollideCallback(CollideCallbackSmall)
			end
		end
	*/
end

function ENT:HandDraw(owner,reverse,point)

	
	if point and not point.Particle then
		ParticleEffectAttach("v_bloodtrap",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*
	local bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Right_Arm"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Left_Arm"}
	end
	
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
		
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				self.HNextEmit = self.HNextEmit or 0
		
				if self.HNextEmit > CurTime() then return end
				
				self.HNextEmit = CurTime() + 0.005
				
				local LightColor = render.GetLightColor( pos ) * 255
				LightColor.r = math.Clamp( LightColor.r, 70, 255 )
				
				for i=1,math.random(2,3) do
					local particle = self.Emitter2:Add("particle/smokestack", pos+ang:Forward()*math.Rand(2,10) +VectorRand()*2.6 )
					particle:SetDieTime(math.Rand(0.8, 1))
					particle:SetVelocity(owner:GetVelocity())
					particle:SetStartAlpha(255)
					particle:SetStartSize(math.Rand(1, 1.5))
					particle:SetColor(math.random(50,115), 0, 0)
					particle:SetEndSize(math.Rand(0,1.5))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetGravity(VectorRand()*(math.sin(RealTime()*1)*20)+vector_up*-20)
					particle:SetLighting(true)
					particle:SetCollide(true)
					particle:SetAirResistance(12)	
				end
				
				if math.random(1,2) == 1 then
					local particle = self.Emitter2:Add("effects/blooddrop", pos+ang:Forward()*math.Rand(2,10) +VectorRand()*3 )
					particle:SetDieTime(math.Rand(1, 3))
					particle:SetVelocity(owner:GetVelocity())
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(255)
					particle:SetStartSize(1)
					particle:SetColor( LightColor.r*0.5, 0, 0 )
					particle:SetGravity(Vector(0, 0, math.Rand(-300, -150)))
					particle:SetCollide(true)
					particle:SetAirResistance(12)
					particle:SetCollideCallback(CollideCallbackSmall)
				end
				
			end
		end
	end
*/
end
end





