ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end


util.PrecacheSound("ambient/energy/electric_loop.wav")

ENT.SpeedBonus = 55

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	local playsound = true
	
	if ValidEntity(self.EntOwner._efSpeedBoost) then
		if SERVER then
			self.EntOwner._efSpeedBoost:Remove()
		end
		playsound = false
		self.EntOwner._efSpeedBoost = nil
	end
	
	self.EntOwner._efSpeedBoost = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)	
		self._OldSpeed = self.EntOwner._DefaultSpeed
		//self.EntOwner:SetTotalSpeed(self._OldSpeed+self.SpeedBonus,self._OldSpeed+self.SpeedBonus+self.EntOwner._DefaultRunSpeedBonus)
		if playsound then
			self.EntOwner:EmitSound("NPC_Antlion.MeleeAttackSingle", 70)
		end
	end
	
	self.DieTime = CurTime() + 10
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efSpeedBoost = nil
		if SERVER then
			//self.EntOwner:SetTotalSpeed(self._OldSpeed,self._OldSpeed+(self.EntOwner._DefaultRunSpeedBonus or 50))
		end
	end
end

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() or self.EntOwner:IsCrow() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			if IsValid(self.EntOwner) then
				self.EntOwner:EmitSound("NPC_Antlion.Pain", 70)
			end
			self:Remove()
		end	
	end
end


if CLIENT then
function ENT:Draw()
end
end