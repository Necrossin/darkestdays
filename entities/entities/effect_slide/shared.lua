ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

util.PrecacheSound("physics/body/body_medium_scrape_smooth_loop1.wav")

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efSlide) then
		if SERVER then
			self.EntOwner._efSlide:Remove()
		end
		self.EntOwner._efSlide = nil
	end
	
	self.EntOwner._efSlide = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
		self.EntOwner:SetVelocity(self.EntOwner:GetVelocity() * 0.3)
		
		//self:DoBones()
		
		//self.BoneTime = CurTime() + 1
		
	end
	
	if CLIENT then
		self.Sound = CreateSound(self.Entity, "physics/body/body_medium_scrape_smooth_loop1.wav")
		self.Emitter = ParticleEmitter(self:GetPos())
	end
	
end

function ENT:DoBones()
	for i=1, 3 do
		local bone = self.EntOwner:LookupBone("ValveBiped.Bip01_Pelvis")
		if bone then
			self.EntOwner:ManipulateBoneAngles( bone, Angle(0,0,-20)  )
			self.EntOwner:ManipulateBonePosition( bone, vector_up*-30  )
		end
		local bone = self.EntOwner:LookupBone("ValveBiped.Bip01_Spine4")
		if bone then
			self.EntOwner:ManipulateBoneAngles( bone, Angle(0,20,0)  )
		end
	end
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner:ResetBones()
		self.EntOwner._efSlide = nil
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Stop()
		end
		if self.Emitter then
			self.Emitter:Finish()
		end
	end
end

function ENT:Think()
	if SERVER then
		
		if ENDROUND then
			self:Remove()
			return
		end
		
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		
		if self.EntOwner._NextKick and self.EntOwner._NextKick > CurTime() and self.EntOwner:GetVelocity():Length() > 100 then// and !self.EntOwner:OnGround() then
			//basically player is forced to slide for the duration of kick effect, otherwise obey the normal sliding rules
		else
			if self.EntOwner:KeyDown(IN_JUMP) or not self.EntOwner:KeyDown(IN_DUCK) or self.EntOwner:GetVelocity():Length() < 200 then
				self:Remove()
				return
			end
		end
		
		//if self.BoneTime and self.BoneTime > CurTime() then
		//	self:DoBones()
		//end
			
		//if self.DieTime <= CurTime() then
			//self:Remove()
		//end	
	end
	if CLIENT then
		if self.Sound and IsValid(self.EntOwner) and self.EntOwner:OnGround() then
			self.Sound:PlayEx(0.8,120)
		end
	end
end


if CLIENT then
function ENT:Draw()
	
	self.NextEffect = self.NextEffect or 0
	
	if self.NextEffect > CurTime() then return end
	
	self.NextEffect = CurTime() + 0.01
	
	if self.EntOwner and !self.EntOwner:OnGround() then return end
	
	if self.Emitter then
		self.Emitter:SetPos(self.EntOwner:GetPos())
	end
	
	local rand = VectorRand()
	rand.z = 0
	local pos = self.EntOwner:GetPos() + vector_up*math.Rand(2,4) + rand*math.Rand(0,10)
	
	for i=1, 5 do
		local particle = self.Emitter:Add("particle/smokestack", pos)
		particle:SetVelocity(math.Rand(0.5, 1.4)*self.EntOwner:GetVelocity():Length()/4*VectorRand()+vector_up*math.random(30))
		particle:SetDieTime(math.Rand(0.5, 1))
		particle:SetStartAlpha(70)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(7)
		particle:SetRoll(math.Rand(-180, 180))
		particle:SetColor(100, 100, 100)
		particle:SetCollide(true)
		particle:SetBounce(0.1)
		particle:SetAirResistance(15)
		particle:SetGravity(vector_up*-25)
	end


end

/*function ENT:UseCalcView(pos,ang)
	local ct = CurTime()
	
	local delta = self.DieTime - ct
	local mul = math.Clamp(1-delta,0,1)
	
	ang:RotateAroundAxis(ang:Right(),-360*mul)
	return pos, ang
end*/

end