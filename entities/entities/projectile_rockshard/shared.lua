ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.Models = {
	"models/props_wasteland/rockcliff01k.mdl",
	"models/props_wasteland/rockcliff01b.mdl",
	"models/props_wasteland/rockcliff01c.mdl",
	"models/props_wasteland/rockcliff01e.mdl",
}

local util = util
local math = math

for _,mdl in ipairs(ENT.Models) do
	util.PrecacheModel(mdl)
end

util.PrecacheModel("models/props_debris/concrete_spawnplug001a.mdl")


ENT.HP = 25

local lastgibtime = 0

function ENT:Initialize()

	
	if SERVER then
		self:SetModel(self.Models[math.random(1,#self.Models)])
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		//self:SetMoveType(MOVETYPE_NONE) 
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(false)		
		
		self:EmitSound("Boulder.ImpactHard")
		
		
		//self.Entity:SetModelScale(math.Rand(0.4,0.6),0)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
		end

	end	
	if CLIENT then
		//self:SetNoDraw(true)
	end
	self:SetDTFloat(0, CurTime()+3)
	
	
	self:SetDTFloat(1, self.HP)
	
	self:SetDTFloat(2, CurTime()+0.01)
	
end

function ENT:Think()
	local ct = CurTime()
	if SERVER then
		//self.ActualPos = self.ActualPos or self:GetPos()
		
		//self.ActualPos.z = math.Approach(self.ActualPos.z,self:GetDTVector(0).z,0.1)
		//self:SetPos(self.ActualPos)
		if self:GetDTFloat(0) and self:GetDTFloat(0) < ct then
			self.Entity:TakeDamage(999,nil,nil)
			if IsValid(self.Entity) then
				self.Entity:Remove()
			end
		end
	end
	//self:NextThink(ct)
end

function ENT:OnRemove()
	if SERVER then
		local e = EffectData()
		//e:SetOrigin(self:GetPos()+vector_up*60)
		//e:SetStart(self:GetPos()+vector_up*math.random(40,60))
		//util.Effect("Impact",e,true,true)
		if lastgibtime and lastgibtime >= CurTime() then return end
		
		lastgibtime = CurTime()+1
		
		local gibs = ents.Create("prop_dynamic_override")
		gibs:SetModel("models/props_debris/concrete_spawnplug001a.mdl")
		gibs:SetPos(self:GetPos()+vector_up*60)
		gibs:Spawn()
		gibs:Fire("break","0")
	end
end


for i=3,5 do
	util.PrecacheSound("weapons/explode"..i..".wav")
end

if SERVER then

function ENT:OnTakeDamage( dmginfo )
	
	//if dmginfo:GetAttacker().Team and dmginfo:GetAttacker().Team() ~= self:Team() then
		local dmg = dmginfo:GetDamage()

		self:SetDTFloat(1, self:GetDTFloat(1)-dmg)
		
		self:EmitSound("Breakable.Concrete")
		
		if self:GetDTFloat(1) <= 0 then
			self.Entity:Remove()
		end
		
	//end

end

function ENT:PhysicsCollide( Data, Phys ) 
	
	/*if self.Entity._Telekinesis then return end
	
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
		
	end*/
	
	

end
end

if CLIENT then
function ENT:Draw()
	
	if self:GetDTFloat(2) >= CurTime() then
		return
	end
	
	local pos = self:GetPos() - vector_up*60
	
	if not self.ActualPos then  
		self.ActualPos = pos
	end
		
	self.ActualPos.z = math.Approach(self.ActualPos.z,self:GetDTVector(0).z,FrameTime()*400)
	self:SetPos(self.ActualPos)


	self:DrawModel()
end
end
