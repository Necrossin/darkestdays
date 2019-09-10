ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

local util = util
local math = math

util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")

game.AddDecal("EnergySplashSmall2","Models/Roller/rollermine_glow")
--game.AddDecal("EnergySplashSmall3","Decals/plasmaglowfade")

util.PrecacheSound("weapons/Irifle/irifle_fire2.wav")

PrecacheParticleSystem( "scorn_projectile" )
PrecacheParticleSystem( "scorn_projectile_impact" )
if CLIENT then
	RegisterParticleEffect( "scorn_projectile_impact" )
end

for i=1,2 do
	util.PrecacheSound("weapons/physcannon/energy_bounce"..i..".wav")
	util.PrecacheSound("ambient/energy/weld"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		--self.Entity:PhysicsInit(SOLID_VPHYSICS)
		--self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		--self.Entity:SetSolid(SOLID_VPHYSICS)	
		
		self.Entity:DrawShadow(false)
		
		
		local size = 16
		
		self:PhysicsInitSphere( size, "metal_bouncy" )
		
		self:SetCollisionBounds(Vector( -size, -size, -size ), Vector( size, size, size ))
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		self:SetTrigger(true)
		
		self:EmitSound("weapons/Irifle/irifle_fire2.wav",math.random(90,110),math.random(90,110))
		
		--self.Entity:SetModelScale(0.55)
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end	
	end	
	
	if CLIENT then
		//self.Emitter = ParticleEmitter(self:GetPos())
	end
	
	self.Bounced = 0
	self.MaxBounces = 6
	self.DieTime = CurTime()+12
	
	self.Touched = 0
	
	//self:SetDTInt(0,0)
	//self:SetDTInt(1,6)
	//self:SetDTBool(0,false)
	//self:SetDTFloat(0, CurTime()+12)
	
	
end

function ENT:Think()	
	if SERVER then
		if self.DoRemove or self.DieTime and self.DieTime < CurTime() then
			self.Entity:Remove()
		end
	end
end

function ENT:OnRemove()
	if SERVER then
		sound.Play("weapons/physcannon/energy_sing_explosion2.wav",self:GetPos(),math.random(90,120), math.random(90,120), 1)
		
		//local e = EffectData()
		//e:SetOrigin(self:GetPos())
		//util.Effect("cball_explode",e,true,true)
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetNormal(vector_origin)
		util.Effect("scorn_projectile_impact", effectdata,nil,true)

	end
	if CLIENT then
		/*for i=1, math.random(15,25) do
			local particle = self.Emitter:Add("effects/strider_tracer", self:GetPos()+VectorRand()*math.random(-2,2))
			particle:SetVelocity(VectorRand()*math.random(100,200))
			particle:SetDieTime(math.Rand(1,3))
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(2,4))
			particle:SetEndSize(0)
			particle:SetColor(0, 57, math.random(240,255))
			particle:SetCollide( true )
			--particle:SetLighting(true)
			--particle:SetBounce(2)
			particle:SetGravity( Vector( 0, 0, -300 ) ) 
			particle:SetAirResistance(12)
		end*/
		/*if self.Emitter then
			self.Emitter:Finish()
		end*/
	end
end


for i=3,5 do
	--util.PrecacheSound("weapons/explode"..i..".wav")
end
local mat3 = Material( "Effects/stunstick" )
if SERVER then
	function ENT:StartTouch( ent )
		
		if self.DoRemove then return end
		
		if IsValid(ent) then
			
			if ent == game.GetWorld() then return end
			
			
			if (ent:IsPlayer() and not ent:IsTeammate(self.EntOwner)) or ent:IsNPC() then//ent:Team() ~= self.EntOwner:Team()
				local Dmg = DamageInfo()
				Dmg:SetAttacker(self.EntOwner)
				Dmg:SetInflictor(self.Entity)
				Dmg:SetDamage(30+self.Bounced*15)
				Dmg:SetDamageType(DMG_DISSOLVE)
				Dmg:SetDamagePosition(self:GetPos())
				
				ent:TakeDamageInfo(Dmg)
				
				self.Touched = self.Touched + 1
				
				if self.Touched >= 2 then
					self.DoRemove = true
					//self:Remove()
				end
			end
			
		end
		
	end
	
	function ENT:PhysicsCollide( data, physobj )	
		
		if self.DoRemove then return end
		
		if data.HitEntity == game.GetWorld() or not data.HitEntity:IsPlayer() then
			self.Bounced = self.Bounced + 1
				--util.DecalEx( mat3, self.Entity, data.HitPos, data.HitNormal, 42, 42 )
				local hitpos = data.HitPos
				local hitnormal = data.HitNormal
				util.Decal("SmallScorch", hitpos + hitnormal, hitpos - hitnormal)
				sound.Play("weapons/physcannon/energy_bounce"..math.random(1,2)..".wav",self:GetPos(),75, math.random(60,90), 1)
				
				local e = EffectData()
				e:SetOrigin(hitpos)
				e:SetNormal(hitnormal)
				util.Effect("cball_bounce",e,nil,true)
								
		end
			if self.Bounced >= self.MaxBounces then
				//self:Remove()
				self.DoRemove = true
				return
			end
			
			local NewVelocity = physobj:GetVelocity()
			NewVelocity:Normalize()
			
			--LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
			
			local TargetVelocity = NewVelocity * (400 + 130 * self:GetDTInt(0))
			
			physobj:SetVelocity( TargetVelocity )
	end
end



if CLIENT then
local mat = Material( "sprites/strider_blackball" )
local mat2 = Material( "Effects/strider_pinch_dudv" )


function ENT:Draw()

	/*local color = IsValid(self.EntOwner) and team.GetColor(self.EntOwner:Team()) or Color( 0, 57, math.random(240,255), 60 )
	color.a = 60

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = color.r//0//math.random(30,45)
		dlight.g = color.g//57
		dlight.b = color.b//math.random(240,255)
		dlight.Brightness = 1
		dlight.Size = 120
		dlight.Decay = 120 * 5
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
	end*/

	if not self.Particle then
		ParticleEffectAttach("scorn_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
	
	
end
end
