ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

local util = util
local math = math

util.PrecacheModel("models/Items/CrossbowRounds.mdl")
util.PrecacheModel("models/crossbow_bolt.mdl")

util.PrecacheSound("physics/metal/sawblade_stick1.wav")
util.PrecacheSound("physics/metal/sawblade_stick2.wav")
util.PrecacheSound("physics/metal/sawblade_stick3.wav")
util.PrecacheSound("weapons/crossbow/hitbod1.wav")
util.PrecacheSound("weapons/crossbow/hitbod2.wav")

util.PrecacheSound("npc/manhack/mh_blade_snick1.wav")

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Items/CrossbowRounds.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetTrigger(true)
		
		self:EmitSound("npc/manhack/mh_blade_snick1.wav",70,math.random(100,110))
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(1)
			phys:SetBuoyancyRatio(0.01)
			phys:EnableDrag(false)
			phys:Wake()
		end
		self.Touched = {}
	end	
	
	if CLIENT then
		//self:SetNoDraw(true)
		//self:SetModel("models/crossbow_bolt.mdl")
	end
	
	self:SetDTFloat(0, CurTime()+12)
	
	
end

function ENT:Think()	
	if SERVER then
		if self:GetDTFloat(0) and self:GetDTFloat(0) < CurTime() then
			self.Entity:Remove()
		end
	end
end
if SERVER then

function ENT:PhysicsCollide(data, phys)
	if self.Stuck then return end
	self.Stuck = true

	phys:EnableMotion(false)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
	self.DieTime = CurTime() + 8

	self:SetPos(data.HitPos)
	self:SetAngles(data.HitNormal:Angle())

	local hitent = data.HitEntity
	if hitent and hitent:IsValid() then
		local hitphys = hitent:GetPhysicsObject()
		if hitphys:IsValid() and hitphys:IsMoveable() then
			self:SetParent(hitent)
		end
	end
end

function ENT:StartTouch(ent)
	if not self.Stuck and not self.Touched[tostring(ent)] and ent:IsValid() and #self.Touched < 2 then
		local owner = self:GetOwner()
		if not owner:IsValid() then owner = self end

		if ent ~= owner and not (ent:IsPlayer() and ent:Team() == self.Team) then
			ent:TakeDamage(60, owner, self)
			ent:EmitSound("weapons/crossbow/hitbod"..math.random(1,2)..".wav")
			self.Touched[tostring(ent)] = true
		end
	end
end

end


if CLIENT then

function ENT:Draw()

	local ang = self:GetAngles()

	self:SetModel("models/crossbow_bolt.mdl")
	
	//if not self.Ang then
		//self.Ang = self:GetAngles()
		//self.Ang:RotateAroundAxis(self.Ang:Up(),180)
	//end
	
	//local ang = self:GetAngles()
	//if self.Ang then
	self:SetAngles(ang)
	//end


	
	//self:SetupBones()
	self:DrawModel()
	
end
end
