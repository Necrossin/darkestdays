ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

local util = util
local math = math

util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
PrecacheParticleSystem( "firebolt_explosion" ) 

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")	

		self:DrawShadow(false)
		self:SetColor(Color(255, 125, 75, 255))
		self:SetMaterial("models/props_wasteland/rockcliff04a")
		
		
		local size = 4
		
		self:PhysicsInitSphere( size )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetTrigger(true)

		
		//self:SetTrigger(true)
		
		WorldSound("ambient/fire/mtov_flame2.wav",self:GetPos(),90,math.random(90,110),1)
		//WorldSound("ambient/fire/gascan_ignite1.wav",self:GetPos(),90,math.random(90,110))
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			//phys:SetMass(20)
			phys:EnableDrag(false)
			phys:SetDamping(1,0.1)
			phys:EnableGravity(false)
		end	
	end	
	if CLIENT then
		self.Sound = CreateSound(self, "ambient/fire/fire_big_loop1.wav")
	end
	
	self.DieTime = CurTime()+12
	
	//self:SetDTFloat(0, CurTime()+12)
	
	
end

function ENT:Think()	
	if SERVER then
		if self.PhysicsData then
			self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal,self.PhysicsData.HitEntity)
		end
		if self.DieTime and self.DieTime < CurTime() then
			self.Entity:Remove()
		elseif 0 < self:WaterLevel() then
			self:Explode()
		end
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Play()
		end
	end
end

function ENT:OnRemove()
	if CLIENT then
		//ParticleEffect("firebolt_explosion",self:GetPos(),self:GetAngles(),nil)
		if self.Sound then
			self.Sound:Stop()
		end
		//WorldSound("ambient/fire/gascan_ignite1.wav",self:GetPos(),75,math.random(90,110))
		sound.Play("ambient/explosions/explode_8.wav",self:GetPos(),75,math.random(110,135))

	end
end

if SERVER then
	function ENT:Explode(hitpos, hitnormal,ent)
		if self.Exploded then return end
		self.Exploded = true
		
		self.DieTime = 0
		
		hitpos = hitpos or self:GetPos()
		hitnormal = hitnormal or Vector(0, 0, 1)

		local e = EffectData()
		e:SetOrigin(hitpos)
		e:SetNormal(hitnormal)
		util.Effect("fire_explosion",e,nil,true)

		local owner = self.EntOwner
		if not IsValid(owner) then owner = self end
		
		self:SetMoveType(MOVETYPE_NONE)

		//ExplosiveDamage(owner, hitpos, 84, 84, 1, 0.35, 10, self)
		ExplosiveDamage(owner, hitpos, 60, 84, 1, 0.41, 3, self )
		
		//if ent == game.GetWorld() then 
			util.Decal("Scorch", hitpos + hitnormal, hitpos - hitnormal)				
		//end
		
		if IsValid(ent) then
			if ent:GetClass() == "projectile_cyclonetrap" and ent:Team() == self.EntOwner:Team() and not (ent:GetDTBool(0) or ent:GetDTBool(2)) then
				ent:SetDTBool(1,true)
			end
		end
		
		self:NextThink(CurTime())
	end
	
	function ENT:PhysicsCollide( data, physobj )	
		if data and data.HitEntity and not data.HitEntity:IsPlayer() then
			self.PhysicsData = data
			self:NextThink(CurTime())
		end
	end
	
	function ENT:StartTouch( ent )
		
		if self.Exploded then return end
		
		if IsValid( ent ) and ( ent:IsPlayer() and not ent:IsTeammate( self.EntOwner ) ) or ent:IsNPC() then
			local nearest = ent:NearestPoint( self:GetPos() )
			self:Explode( nearest, ( nearest - self:GetPos() ):GetNormal(), ent )
		end
		
	end
	
end



if CLIENT then
function ENT:Draw()
	if not self.Particle then
		ParticleEffectAttach("firebolt_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
	self:SetModelScale(0.4,0)
	self:DrawModel()
end
end
