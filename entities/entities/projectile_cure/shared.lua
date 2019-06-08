ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

local util = util
local math = math

util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")

local startsound = Sound( "weapons/physcannon/energy_sing_flyby1.wav" )
local loopsound = Sound( "ambient/levels/labs/teleport_rings_loop2.wav" )

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")	

		self:DrawShadow(false)
		self:SetColor(Color(125, 255, 75, 255))
		self:SetMaterial("models/debug/debugwhite")
		
		
		local size = 4
		
		self:PhysicsInitSphere( size )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		WorldSound(startsound,self:GetPos(),90,math.random(90,110),1)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableDrag(false)
		end	
	end	
	if CLIENT then
		self.Sound = CreateSound(self, loopsound)
	end
	
	self:SetDTFloat(0, CurTime()+12)
	
	
end

function ENT:Think()	
	if SERVER then
		if self.PhysicsData then
			self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal,self.PhysicsData.HitEntity)
		end
		if self:GetDTFloat(0) and self:GetDTFloat(0) < CurTime() then
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
		sound.Play("physics/surfaces/underwater_impact_bullet"..math.random(3)..".wav",self:GetPos(),75,math.random(110,135))
	end
	if SERVER then
		local trap = ents.Create("projectile_cure_cloud")
		trap:SetOwner(self.EntOwner)
		trap:SetPos(self:GetPos()+vector_up*20)
		trap.EntOwner = self.EntOwner
		trap:Spawn()
	end
end

if SERVER then
	function ENT:Explode(hitpos, hitnormal,ent)
		if self.Exploded then return end
		self.Exploded = true
		
		self:SetDTFloat(0, 0)
		
		hitpos = hitpos or self:GetPos()
		hitnormal = hitnormal or Vector(0, 0, 1)
		
		self.HitNormal = hitnormal

		local owner = self.EntOwner
		if not IsValid(owner) then owner = self end
		
		self:SetMoveType(MOVETYPE_NONE)

		//ExplosiveDamage(owner, hitpos, 84, 84, 1, 0.55, 20, self)
		
		if ent then
			if ent == game.GetWorld() then 
				//util.Decal("SmallScorch", hitpos + hitnormal, hitpos - hitnormal)				
			end
		end
		
		self:NextThink(CurTime())
	end
	
	function ENT:PhysicsCollide( data, physobj )	
		
		self.PhysicsData = data
		self:NextThink(CurTime())
		
	end
	
end



if CLIENT then
function ENT:Draw()
	if not self.Particle then
		ParticleEffectAttach("cure_projectile_small",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
	self:SetModelScale(0.2,0)
	self:DrawModel()
	
	/*local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = 50
			dlight.g = 255
			dlight.b = 50
			dlight.Brightness = 1
			dlight.Size = 100
			dlight.Decay = 100 * 5
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0
		end*/
end
end
