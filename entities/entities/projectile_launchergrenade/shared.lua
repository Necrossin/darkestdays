ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "dd_explosion_medium" )

util.PrecacheModel("models/weapons/w_missile_closed.mdl")

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/weapons/w_missile_closed.mdl")
		//self:SetModelScale(1.5,0)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		//self.Entity:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE ) 
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		//self.Entity:SetColor(Color(10,10,10,255))
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableDrag(false)
			phys:SetDamping(1,0.1)
			phys:EnableGravity(false)
		end	
	end
	if CLIENT then
		//self.Emitter = ParticleEmitter(self:GetPos())
	end

	
end

function ENT:Think()
	if SERVER then
		if self.DoRemove then
			self.Entity:Remove()
			return
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
	if self.DoRemove then return end
	
	local dmg, rad = math.random(70,90),math.random(110,150)
	
	
	//ExplosiveDamage(self:GetOwner(), self, 140, 165, 1, 0.4, 8)
	ExplosiveDamage(self:GetOwner(), self, 100, 50, 1, 2, 8)
	
	
	
	if Data and Data.HitNormal then
		util.Decal("Scorch", Data.HitPos + Data.HitNormal, Data.HitPos - Data.HitNormal)
	end

	
	local e = EffectData()
	e:SetOrigin(Data.HitPos or self:GetPos())
	e:SetNormal(Data.HitNormal or self:GetPos())
	//e:SetMagnitude(math.Round(hole))
	util.Effect("tube_explosion",e,true,true)
	
	self:EmitSound("BaseExplosionEffect.Sound")

	
	self.DoRemove = true


end
end

if CLIENT then
function ENT:Draw()

	self:SetModelScale(1.5,0)
	self:DrawModel()
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit < CurTime() then
	
		local emitter = ParticleEmitter( self:GetPos() )
	
		if emitter then
		
			local rad = 4
		
			local pos = self:GetPos() - self:GetAngles():Forward() * 10 + self:GetAngles():Right() * math.sin( RealTime() * 4 ) * rad + self:GetAngles():Up() * math.cos( RealTime() * 4 ) * rad
			
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(VectorRand()*4)
			particle:SetDieTime(math.Rand(0.5, 1.3))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(5,8))
			particle:SetEndSize(math.random(10,13))
			particle:SetRoll(math.Rand(-180, 180))
			particle:SetColor(100, 100, 100)
			particle:SetAirResistance(45)
			
			emitter:Finish()
			
		end
		
		local effectdata = EffectData() 
		 	effectdata:SetOrigin( self:GetPos() - self:GetAngles():Forward() * 10 ) 
			effectdata:SetAngles( (self.Entity:GetVelocity():GetNormal()*-1):Angle() ) 
			effectdata:SetScale( 1.4 )
		 util.Effect( "MuzzleEffect", effectdata, nil, true ) 

		
		self.NextEmit = CurTime() + math.Rand( 0.05, 0.1 )
	end
	
	
end
end
