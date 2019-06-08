ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.IsSpell = true

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.Target = NULL

local player_GetAll = player.GetAll

if SERVER then
function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:DrawShadow(false)
	self:PhysicsInitSphere(4)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end

	self.DeathTime = CurTime() + 7
	self.SpawnTime = CurTime() + 1//0.6
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end
	
	if !ValidEntity(self:GetOwner()) or not self:GetOwner():Alive() then
		self:Explode()
	end

	if self.DeathTime <= CurTime() or self.Exploded then
		self:Remove()
	elseif 0 < self:WaterLevel() then
		self:Explode()
	else
		//if not self.Trailed then
			//self.Trailed = true
			//util.SpriteTrail(self, 0, Color(255, 255, 120, 160), false, 22, 16, 1, one42, "trails/smoke.vmt")
		//end

		local target = self.Target
		if IsValid(target) and target:Alive() and not target:IsGhosting() then
			local mypos = self:GetPos()
			local nearest = (target:NearestPoint(mypos) + target:LocalToWorld(target:OBBCenter()) * 0.6) / 1.6
			local vHeading = (nearest - mypos):GetNormalized()
			local aOldHeading = self:GetVelocity():Angle()

			self:SetAngles(aOldHeading)
			local diffang = self:WorldToLocalAngles(vHeading:Angle())

			local ft = FrameTime() * math.max(3, math.min(7, 7 - nearest:Distance(mypos) * 0.97))
			aOldHeading:RotateAroundAxis(aOldHeading:Up(), (diffang.yaw + math.Rand(-20, 20)) * ft)
			aOldHeading:RotateAroundAxis(aOldHeading:Right(), (diffang.pitch + math.Rand(-20, 20)) * -ft)

			local vNewHeading = aOldHeading:Forward()
			self:GetPhysicsObject():SetVelocityInstantaneous(vNewHeading * 340)
		else
			local myteam = IsValid(self:GetOwner()) and self:GetOwner():Team() or TEAM_RED
			local mypos = self:GetPos()
			for _, ent in ipairs(player_GetAll()) do
				if ent:IsPlayer() and not ent:IsTeammate(self:GetOwner()) and ent:Alive() and ent:GetPos():Distance(mypos) <= 256 and TrueVisible(mypos, ent:NearestPoint(mypos)) then
					self.Target = ent
					break
				end
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or Vector(0, 0, 1)
	
	util.Decal("SmallScorch", hitpos + hitnormal, hitpos - hitnormal)	

	local owner = self.EntOwner
	if not IsValid(owner) then owner = self end

	if self.SpawnTime <= CurTime() then
		
		local bonus = 15 * ( 1 - math.Clamp( (self.DeathTime - CurTime()) / 7, 0, 1 ) )
	
		ExplosiveDamage(owner, hitpos, 40 + bonus, 40 + bonus, 0.5, 0.31, 1, self)
	end
	
	self:EmitSound("npc/fast_zombie/wake1.wav",90,math.random(100,115))
	

	self:NextThink(CurTime())
end

end

if CLIENT then

function ENT:Initialize()
	//WorldSound("npc/crow/die"..math.random(1,2)..".wav",self:GetPos(),100,math.random(80,110),1)
	
	self.FlySound = CreateSound( self, "NPC_HeadCrab.Burning" )
end

function ENT:OnRemove()
	if self.FlySound then
		self.FlySound:Stop()
	end
	sound.Play("ambient/explosions/explode_9.wav",self:GetPos(),75,math.random(110,135))
end

function ENT:Think()
	
	if self.FlySound then
		self.FlySound:Play()//Ex(0.8,1)
	end
end

function ENT:Draw()
		if not self.Particle then
		ParticleEffectAttach("cursedflames_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
	self:DrawModel()
	
		/*local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = 50
			dlight.g = 255
			dlight.b = 50
			dlight.Brightness = 1
			dlight.Size = 90
			dlight.Decay = 90 * 5
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0
		end*/
end
end