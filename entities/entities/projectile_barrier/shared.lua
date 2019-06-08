ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
	AddCSLuaFile("shared.lua")
end


local util = util
local math = math

local mdl = Model("models/props_borealis/borealis_door001a.mdl")

PrecacheParticleSystem( "barrier_projectile" )
PrecacheParticleSystem( "barrier_projectile_red" )
PrecacheParticleSystem( "barrier_projectile_blue" )

ENT.HP = 425

function ENT:Initialize()

	
	if SERVER then
		self.Entity:SetModel(mdl)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_NONE)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		self.Entity:DrawShadow(false)
		
		//self:EmitSound("Boulder.ImpactHard")
	end	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMaterial("slime")
		phys:EnableMotion( false ) 
	end 
	
	self:Fire( "kill", "", 6 )
	
	//self:SetDTFloat(0, CurTime()+7.5)
	//self:SetDTFloat(1, self.HP)
	
	self.NoImpactEffect = true
	
end

function ENT:Think()
	local ct = CurTime()
	if CLIENT then
		if self.Sound then
			self.Sound:Play()
		end
	end
end

function ENT:OnRemove()
	if CLIENT then
		if self.Sound then
			self.Sound:Stop()
		end
	end
end


for i=3,5 do
	util.PrecacheSound("weapons/explode"..i..".wav")
end

if SERVER then

function ENT:OnTakeDamage( dmginfo )
	
	if dmginfo:GetAttacker() and dmginfo:GetAttacker().Team and dmginfo:GetAttacker():Team() ~= self:Team() then
		local dmg = dmginfo:GetDamage()

		self.HP = self.HP - dmg
		
		//self:EmitSound("Breakable.Concrete")
		sound.Play("physics/surfaces/underwater_impact_bullet"..math.random(1, 3)..".wav", dmginfo:GetDamagePosition(), math.random(70,80), math.random(100, 115))
		
		if self.HP <= 0 then
			sound.Play("physics/glass/glass_sheet_break"..math.random(1,3)..".wav",self:GetPos(),90, 100, 1)
			self.Entity:Remove()
		end
		
	end

end

function ENT:PhysicsCollide( Data, Phys ) 

end
end

if CLIENT then

function ENT:Initialize()

	self.Sound = CreateSound( self, "d3_citadel.combine_ball_field_loop"..math.random(1,3) )

end

function ENT:Draw()
	
	if not self.Particle then
		
		local effect = "barrier_projectile"
		
		if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():Team() ~= TEAM_FFA then
			effect = self:GetOwner():Team() == TEAM_RED and "barrier_projectile_red" or "barrier_projectile_blue"
		end
	
		ParticleEffect(effect,self:GetPos()-self:GetUp()*40,self:GetAngles(),self.Entity)

		self.Particle = true
	end
	
end
end
