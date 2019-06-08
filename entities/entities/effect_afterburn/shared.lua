ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end


util.PrecacheSound("ambient/fire/fire_med_loop1.wav")


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efAfterburn) then
		if SERVER then
			self.EntOwner._efAfterburn:Remove()
		end
		self.EntOwner._efAfterburn = nil
	end
	
	self.EntOwner._efAfterburn = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
		
		//local e = EffectData()
		//e:SetEntity(self.EntOwner)
		//util.Effect("afterburn",e,true,true)
		
		//if ValidEntity(self.EntAttacker) and self.EntAttacker:IsPlayer() and self.EntAttacker ~= self.EntOwner then
		//	if self.EntAttacker:GetPerk("elementalist") then
		//		self.EntAttacker:SetMana(self.EntAttacker:GetMana()+math.random(9,12),0,self.EntAttacker:GetMaxMana())
		//	end
		//end
		
	end
	if CLIENT then
		 self.Sound = CreateSound( self,  "ambient/fire/fire_med_loop1.wav" ) 
	end
	
	self.DieTime = CurTime() + math.random(4,5)
	
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efAfterburn = nil
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Stop() 
		end
	end
end

function ENT:Think()
	
	if CLIENT then
		if self.Sound then
			self.Sound:PlayEx(0.7, 95 + math.sin(RealTime())*5) 
		end
	end

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		self.NextTick = self.NextTick or 0
		
		if self.NextTick < CurTime() then
			self.NextTick = CurTime() + 0.25
			
			
			local Dmg = DamageInfo()
			Dmg:SetAttacker(self.EntAttacker or self.Entity)
			Dmg:SetInflictor(self.Entity)
			Dmg:SetDamage(math.random(3,4))
			Dmg:SetDamageType(DMG_BURN)
			Dmg:SetDamagePosition(self.EntOwner:GetPos()+vector_up*32)	
						
			self.EntOwner:TakeDamageInfo(Dmg)
			
		end
		
	end
end

if CLIENT then
function ENT:Draw()
	if not self.Particle then
		local CPoint0 = {
			["entity"] = self.EntOwner,
			["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
		}
		self.Entity:CreateParticleEffect("burningplayer",{CPoint0})
		self.Particle = true
	end
end
end