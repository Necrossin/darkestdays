ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

local util = util
local math = math

util.PrecacheModel("models/props_combine/combine_mine01.mdl")

for i=1,3 do
	util.PrecacheSound("npc/manhack/grind_flesh"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/props_combine/combine_mine01.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		
		self.Entity:SetModelScale(0.45,0)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end	
	end	
	
	self:SetDTBool(0,false)
	--self:SetDTFloat(0, CurTime()+14)
	
end

function ENT:Think()	
	if SERVER then
		if self:GetDTFloat(0) and self:GetDTFloat(0) < CurTime() then
			--self.Entity:Remove()
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
	
	if Data.HitEntity == game.GetWorld() and not self:GetDTBool(0) then
		self:SetDTBool(0,true)
		if Data.HitPos then
			local phys = self.Entity:GetPhysicsObject()
			--if (phys:IsValid()) then
				--phys:EnableMotion(false)
			--end
			self:SetPos(Data.HitPos)//self:GetPos()+self:GetForward()*16
			local norm = Data.HitNormal
			if norm then
				local ang = norm:Angle()
				ang:RotateAroundAxis(ang:Right(),90)
				self:SetAngles(ang)
			end
			self:SetMoveType(MOVETYPE_NONE)
			--self:EmitSound("vo/heavy_yell1.wav")
			--local e = EffectData()
			--e:SetOrigin(self:GetPos())
			--e:SetNormal(self:GetForward():GetNormal()*-1)
			--util.Effect("ManhackSparks",e,true,true)
		end
		--self:SetDTFloat(0, CurTime()+3)
	end
	
	

end
end

if CLIENT then
function ENT:Draw()
	self:DrawModel()
end
end
