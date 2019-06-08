ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efFnF) then
		if SERVER then
			self.EntOwner._efFnF:Remove()
		end
		self.EntOwner._efFnF = nil
	end
	
	self.EntOwner._efFnF = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
	end
	if CLIENT then
		self:SetRenderBounds(Vector(-90, -90, -98), Vector(90, 90, 90))
	end
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efFnF = nil
	end
end

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end
end

if CLIENT then
function ENT:Draw()
	if not (self.EntOwner:IsCrow() or self.EntOwner:IsGhosting()) and (self.EntOwner ~= MySelf or GAMEMODE.ThirdPerson) then
		if not self.Particle then
			local CPoint0 = {
				["entity"] = self.EntOwner,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			self.Entity:CreateParticleEffect("burningplayer",{CPoint0})
			self.Particle = true
		end
	else
		if self.Particle then
			self.Entity:StopParticles()
			self.Particle = nil
		end
	end
	
end
end
