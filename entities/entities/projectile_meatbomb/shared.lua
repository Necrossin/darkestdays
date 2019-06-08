ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

local util = util
local math = math

util.PrecacheModel("models/props_junk/watermelon01.mdl")

for i=1,4 do
	util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard"..i..".wav")
end

for i=1,2 do
	util.PrecacheSound("npc/barnacle/barnacle_bark"..i..".wav")
end

util.PrecacheSound("physics/gore/bodysplat.wav")
util.PrecacheSound("ambient/explosions/explode_7.wav")


function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/props_junk/watermelon01.mdl")

		self:SetModelScale(1.6,0)
		
		self:DrawShadow(false)
		self:SetMaterial("models/flesh")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		self:SetTrigger(true)
		
		
		self:EmitSound("npc/barnacle/barnacle_bark"..math.random(1,2)..".wav",120,math.random(90,110))
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(2)
			phys:EnableDrag(false)
			phys:SetMaterial("zombieflesh")
		end	
	end	
	if CLIENT then
	//	self.Sound = CreateSound(self, "ambient/fire/fire_big_loop1.wav")
	end
	
	self:SetDTFloat(0, CurTime()+2.4)
	
	
end

function ENT:Think()	
	if SERVER then
		if self:GetDTFloat(0) and self:GetDTFloat(0) < CurTime() then
			self:Explode()
			self.Entity:Remove()
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
		 
		sound.Play("physics/gore/bodysplat.wav",self:GetPos(),120,math.random(110,135))
		//sound.Play("ambient/explosions/explode_7.wav",self:GetPos(),75,math.random(110,135))
	end
end

local attach_sound = Sound( "npc/headcrab_poison/ph_poisonbite2.wav" )

if SERVER then
	function ENT:Explode()
		if self.Exploded then return end
		self.Exploded = true
		
		self:SetDTFloat(0, 0)
		
		hitpos = self:GetPos()

		local effectdata = EffectData()
			effectdata:SetEntity(self)
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetNormal(self:GetVelocity():GetNormal())
			effectdata:SetScale(0)
		util.Effect( "gib_player", effectdata, true, true )
		
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetNormal(self:GetVelocity():GetNormal())
			effectdata:SetScale(4)
			effectdata:SetMagnitude(5)
		util.Effect( "Explosion", effectdata, true, true )

		local owner = self.EntOwner
		if not IsValid(owner) then owner = self end
		
		self:SetMoveType(MOVETYPE_NONE)

		ExplosiveDamage(owner, hitpos, 220, 220, 1, 0.4, 0, self, DMG_BLAST)
				
		self:NextThink(CurTime())
	end
	
	function ENT:PhysicsCollide( data, physobj )	
		
		if ( data.Speed > 20 && data.DeltaTime > 0.2 ) then
			sound.Play( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", self:GetPos(), 125, math.random( 90, 120 ), math.Clamp( data.Speed / 150, 0, 1 ) )
		end
		
		
		local normal = data.OurOldVelocity:GetNormal()
		local dotpr = data.HitNormal:Dot(normal * -1)

		physobj:SetVelocityInstantaneous((3*dotpr*data.HitNormal+normal)*data.Speed*0.6)
		
		util.Decal("Blood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
	
	end
	
	function ENT:StartTouch( ent )
		
		if IsValid(ent) and ent:IsPlayer() and ent ~= self:GetOwner() and ent:IsTeammate(self:GetOwner()) and not self.Attached then
			
			self.Attached = true
			
			self:SetParent( ent )
			self:SetMoveType( MOVETYPE_NONE )
			
			self:EmitSound( attach_sound, 75, math.random( 110, 120 ) )
			
		end
		
	end
	
end



if CLIENT then
function ENT:Draw()
	if not self.Particle then
		ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	

	self:DrawModel()

end
end
