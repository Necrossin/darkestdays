ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end


util.PrecacheSound("ambient/energy/electric_loop.wav")


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efRoll) then
		if SERVER then
			self.EntOwner._efRoll:Remove()
		end
		self.EntOwner._efRoll = nil
	end
	
	self.EntOwner._efRoll = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)		
	end
	
	self.DieTime = CurTime() + 0.8
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efRoll = nil
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
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end	
	end
end


if CLIENT then
function ENT:Draw()
end

function ENT:UseCalcView(pos,ang)
	local ct = CurTime()
	
	local delta = self.DieTime - ct
	local mul = math.Clamp(1-delta,0,1)
	
	ang:RotateAroundAxis(ang:Right(),-360*mul)
	return pos, ang
end

end