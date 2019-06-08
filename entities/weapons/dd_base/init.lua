AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

/*function SWEP:Think()
	local act = ACT_VM_IDLE
	if self.IdleAnim then
		act = self.IdleAnim
	end
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(act)
	end
	if self.Owner:IsDurationSpell() then
		if self:IsCasting() and self:GetSpellEnd() <= CurTime() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:StopCasting()
		end
	else
		if self:IsCasting() and self:GetSpellEnd() <= CurTime() then
			self:StopCasting()
		end
	end
end*/
