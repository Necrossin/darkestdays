ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

local util = util
local math = math

util.PrecacheModel("models/props_junk/sawblade001a.mdl")

for i=1,3 do
	util.PrecacheSound("npc/manhack/grind_flesh"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/props_junk/sawblade001a.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		
		self.Entity:SetModelScale(0.55,0)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end	
	end	
	
	self:SetDTBool(0,false)
	self:SetDTFloat(0, CurTime()+14)
	
end

function ENT:Think()	
	if SERVER then
		if self:GetDTFloat(0) and self:GetDTFloat(0) < CurTime() then
			self.Entity:Remove()
		end
	end
end

function ENT:OnRemove()

end


for i=3,5 do
	util.PrecacheSound("weapons/explode"..i..".wav")
end

if SERVER then

function ENT:PhysicsCollide( Data, Phys ) 
	
	if self.Entity._Telekinesis then return end
	
	if Data.HitEntity == game.GetWorld() and not self:GetDTBool(0) then
		self:SetDTBool(0,true)
		if Data.HitPos then
			local phys = self.Entity:GetPhysicsObject()
			--if (phys:IsValid()) then
				--phys:EnableMotion(false)
			--end
			self:SetPos(self:GetPos()+self:GetForward()*16)
			self:SetMoveType(MOVETYPE_NONE)
			self:EmitSound("Metal.SawbladeStick")
			local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetNormal(self:GetForward():GetNormal()*-1)
			util.Effect("ManhackSparks",e,true,true)
		end
		self:SetDTFloat(0, CurTime()+3)
	else
		
		local ent = Data.HitEntity
		
		if ent:IsPlayer() and ent:Team() ~= self:GetOwner():Team() then
			ent:EmitSound("npc/manhack/grind_flesh"..math.random(1,3)..".wav")
			ent:TakeDamage(50,self:GetOwner(), self)
			self.Entity:Remove()
		else
			self:SetDTFloat(0, CurTime()+3)
			
			if IsValid(ent) and not (ent:IsPlayer() and ent:Team() == self:GetOwner():Team()) then
				self:SetDTBool(0,true)
				
				self:SetPos(self:GetPos()+self:GetForward()*16)
				self:SetParent(ent)
				self:SetCollisionGroup(COLLISION_GROUP_NONE)
				self:EmitSound("Metal.SawbladeStick")
				ent:TakeDamage(math.random(85,100),self:GetOwner(), self)
				local e = EffectData()
				e:SetOrigin(self:GetPos())
				e:SetNormal(self:GetForward():GetNormal()*-1)
				util.Effect("ManhackSparks",e,true,true)
			else
				self.Entity:Remove()
			end
			
		end
		
	end
	
	

end
end

if CLIENT then
function ENT:Draw()
	
	if not self:GetDTBool(0) then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(),math.NormalizeAngle(ang.r-FrameTime()*900))
		self:SetAngles(ang)
	end
	
	self:DrawModel()
end
end
