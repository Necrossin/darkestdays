ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.IsSpell = true

if SERVER then
AddCSLuaFile("shared.lua")
end

local util = util
local math = math

util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")

PrecacheParticleSystem( "winterblast_projectile" )
PrecacheParticleSystem( "winterblast_explosion" )
PrecacheParticleSystem( "frozen_death" )
PrecacheParticleSystem( "frozenplayer" )

util.PrecacheSound("npc/waste_scanner/grenade_fire.wav")

function ENT:Initialize()

	
	if SERVER then
		//self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")		
		self.Entity:DrawShadow(false)
		
		
		local size = math.random(10,16)
		
		self:PhysicsInitSphere( size )
		
		self:SetCollisionBounds(Vector( -size, -size, -size ), Vector( size, size, size ))
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		self:SetTrigger(true)
		
		//WorldSound("npc/waste_scanner/grenade_fire.wav",self:GetPos(),math.random(100,120),math.random(100,130))
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end	
	end	
	
	self.DieTime = CurTime()+12
	
	//self:SetDTFloat(0, CurTime()+12)
	
	
end

function ENT:Think()	
	if SERVER then
		if self.DieTime and self.DieTime < CurTime() then
			self.Entity:Remove()
		end
	end
end

function ENT:OnRemove()
	if CLIENT then
		ParticleEffect("winterblast_explosion",self:GetPos(),Angle(0,0,0),nil)
	end
end

if SERVER then
	function ENT:StartTouch( ent )
		
		if IsValid(ent) then
			
			if ent == game.GetWorld() then 
				//self:Remove()
				return 
			end
			
			if not (ent:IsPlayer() and ent:IsTeammate(self.EntOwner)) then
			
				local Dmg = DamageInfo()
				Dmg:SetAttacker(self.EntOwner)
				Dmg:SetInflictor(self.Entity)
				Dmg:SetDamage(math.random(5,10))
				Dmg:SetDamageType(DMG_DROWN)
				Dmg:SetDamagePosition(self:GetPos())
				
				if ent:IsPlayer() then
					local fire = ent:SetEffect("frozen")
					fire.EntAttacker = self.EntOwner
				end
				
				ent:TakeDamageInfo(Dmg)
				
				self:Remove()
			end
			
		end
		
	end
	
	function ENT:PhysicsCollide( data, physobj )	
		
		local ent = data.HitEntity
		
		local hitpos = data.HitPos
		local hitnormal = data.HitNormal
		if hitpos and hitnormal and ent == game.GetWorld() then
			util.Decal("PaintSplatBlue", hitpos + hitnormal, hitpos - hitnormal)//"GlassBreak"
		end
		
		self:EmitSound("physics/glass/glass_impact_bullet"..math.random( 3 )..".wav",70,math.random(130,140))

		if ent then
			
			ExplosiveEffect(hitpos, 25, 10, DMG_DROWN)
			
			if ent == game.GetWorld() then 
				physobj:SetVelocity( vector_origin )
				self.DieTime = 0
				return 
			end
			
			if ent:GetClass() == "projectile_cyclonetrap" and ent:Team() == self.EntOwner:Team() and not (ent:GetDTBool(0) or ent:GetDTBool(1)) then
				ent:SetDTBool(2,true)
				self:Remove()
				return 
			end
			
			/*if not (ent:IsPlayer() and ent:Team() == self.EntOwner:Team()) then
			
				local Dmg = DamageInfo()
				Dmg:SetAttacker(self.EntOwner)
				Dmg:SetInflictor(self.Entity)
				Dmg:SetDamage(math.random(30,35))
				Dmg:SetDamageType(DMG_BURN)
				Dmg:SetDamagePosition(self:GetPos())
				
				if ent:IsPlayer() then
					local fire = ent:SetEffect("afterburn")
					fire.EntAttacker = self.EntOwner
				end
				
				ent:TakeDamageInfo(Dmg)
				
				self:Remove()
			end*/
			
		end
		self:NextThink(CurTime())
		return true
	end
	
end



if CLIENT then
function ENT:Draw()
	if not self.Particle then
		ParticleEffectAttach("winterblast_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
end
end
