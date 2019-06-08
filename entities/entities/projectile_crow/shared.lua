ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = false

ENT.IsSpell = true

if SERVER then
AddCSLuaFile("shared.lua")
end

local rndCrow = {
	"npc/crow/alert2.wav",
	"npc/crow/alert3.wav",
	"npc/crow/pain1.wav",
	"npc/crow/pain2.wav",
	"npc/crow/die1.wav",
	"npc/crow/die2.wav",
}

for _,snd in pairs(rndCrow) do
	util.PrecacheSound(snd)
end


ENT.Target = NULL

local c_maxbound = Vector(3, 3, 3)
local c_minbound = c_maxbound * -1

local player_GetAll = player.GetAll

if SERVER then
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/crow.mdl")
	
	self:PhysicsInitSphere(6)
	self:SetCollisionBounds( c_maxbound, c_minbound )
	--self:PhysicsInit(SOLID_VPHYSICS)

	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)//COLLISION_GROUP_PROJECTILE
	
	self:SetTrigger( true )
	
	//self.Entity:SetSequence(self.Entity:LookupSequence("Fly01"))
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end

	self.DeathTime = CurTime() + math.random(7,9)
end

function ENT:Think()
	if self.PhysicsData then
		self:Attack(self.PhysicsData.HitEntity,self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end
	
	if !ValidEntity(self:GetOwner()) or not self:GetOwner():Alive() then
		self:Remove()
		return
	end

	if self.DeathTime <= CurTime() or self.PhysicsData and (!IsValid(self.Target) or IsValid(self.Target) and (!self.Target:Alive() or self.Target:IsGhosting())) then
		self:Remove()
	else
		local target = self.Target
		if IsValid(target) and target:Alive() and not target:IsGhosting() then
			local mypos = self:GetPos()
			local nearest = (target:NearestPoint(mypos) + target:LocalToWorld(target:OBBCenter()) * 0.6) / 1.6
			local vHeading = (nearest - mypos):GetNormalized()
			local aOldHeading = self:GetVelocity():Angle()

			self:SetAngles(aOldHeading)
			local diffang = self:WorldToLocalAngles(vHeading:Angle())

			local ft = FrameTime()*math.Rand(1,13)// * math.max(3, math.min(7, 7 - nearest:Distance(mypos) * 0.97))
			aOldHeading:RotateAroundAxis(aOldHeading:Up(), (diffang.yaw + math.Rand(-10, 10))* ft)
			aOldHeading:RotateAroundAxis(aOldHeading:Right(), (diffang.pitch + math.Rand(-40, 40))* -ft)

			local vNewHeading = aOldHeading:Forward()
			self:GetPhysicsObject():SetVelocityInstantaneous(vNewHeading * math.random(220,330))
		else
			local mypos = self:GetPos()
			for _, ent in ipairs(player_GetAll()) do
				if ent:IsPlayer() and not ent:IsTeammate(self:GetOwner()) /*ent:Team() ~= self:GetOwner():Team()*/ and ent:Alive() and ent:GetPos():Distance(mypos) <= 256 and TrueVisible(mypos, ent:NearestPoint(mypos)) then
					self.Target = ent
					break
				end
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetAttacker():IsPlayer() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:Touch( obj )
	self:Attack(obj,self:GetPos(), vector_up)
end

function ENT:Attack(obj,hitpos, hitnormal)
	self.NextAttack = self.NextAttack or 0
	
	if obj and obj:IsPlayer() and not self.EntOwner:IsTeammate(obj) then//obj:Team() ~= self.EntOwner:Team() then
		if self.NextAttack < CurTime() then
			self.NextAttack = CurTime() + math.Rand(0.75,0.95)//0.74
			local Dmg = DamageInfo()
			Dmg:SetAttacker(self.EntOwner or self.Entity)
			Dmg:SetInflictor(self.Entity)
			Dmg:SetDamage(math.random(1,2) * ( self.EntOwner:GetPerk( "crow" ) and 2 or 1 ))
			Dmg:SetDamageType(DMG_SLASH)
			Dmg:SetDamagePosition(hitpos)	
								
			obj:TakeDamageInfo(Dmg)
			
			//util.Decal("Blood", hitpos + hitnormal*10, hitpos - hitnormal*10)
			
			local e = EffectData()
			e:SetOrigin(hitpos)
			e:SetScale(10)
			util.Effect("BloodImpact",e,nil,true)
			
			self.Entity:EmitSound(rndCrow[math.random(1,#rndCrow)])
		end
	end
	
	
	
	self:NextThink(CurTime())
end

end

if CLIENT then

function ENT:Initialize()
	WorldSound("npc/crow/die"..math.random(1,2)..".wav",self:GetPos(),100,math.random(80,110),1)
	
	self.FlySound = CreateSound( self, "NPC_Crow.Flap" )
		
	self.PlaybackRate = math.Rand( 1, 3 )
	--self:SetPlaybackRate( self.PlaybackRate )
	
	--self:ResetSequenceInfo()
	--self:ResetSequence( 0 )
	
end

local maxbound = Vector(3, 3, 3)
local minbound = maxbound * -1

local function gib_callback( self, data )
	
	local hitpos = data.HitPos
	local hitnormal = data.HitNormal
	
	self.Decal = self.Decal or 0
	
	if self.BigDecal and self.Decal < 1  then
		util.Decal("BloodHuge"..math.random(5), hitpos + hitnormal, hitpos - hitnormal)
	else
		if self.Decal < 5 then
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
	end
	
	self.Decal = self.Decal + 1
	
end

function ENT:OnRemove()
	
	local norm = self:GetForward()
	for i=1, math.random(1, 2) do
		local dir = (norm * 2 + VectorRand()) / 3
		dir:Normalize()

		local ent = ClientsideModel("models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE)
		if ent:IsValid() then
			ent:SetMaterial("models/flesh")
			ent:SetModelScale(math.Rand(0.2, 0.7), 0)
			ent:SetPos(self:GetPos() + dir * 6)
			ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)
			
			ent:AddCallback( "PhysicsCollide", gib_callback )

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("zombieflesh")
				phys:SetVelocityInstantaneous(dir * math.Rand(30, 80))
				phys:AddAngleVelocity(VectorRand() * 20)
			end

			SafeRemoveEntityDelayed(ent, math.Rand(3, 5))
		end
	end
	
	sound.Play("physics/flesh/flesh_bloody_break.wav",self:GetPos(),90, math.random(90,110), 1)
	
	if self.FlySound then
		self.FlySound:Stop()
	end
end

function ENT:Think()
	
	if self.FlySound then
		self.FlySound:Play()
	end
	
	--self.NextSeq = self.NextSeq or 0
	--self.Entity:SetPlaybackRate( self.PlaybackRate or 3 )
	--if self.NextSeq <= CurTime() then
		--self.Entity:ResetSequence( 0 ) //self.Entity:LookupSequence("Fly01")
		--self.NextSeq = CurTime() + self.Entity:SequenceDuration( )/4//0.18//self.Entity:SequenceDuration( )/2
	--end

	--self:NextThink(CurTime())
end

function ENT:DrawTranslucent()

	self.NextSeq = self.NextSeq or 0
	self.Entity:SetPlaybackRate( self.PlaybackRate or 3 )
	if self.NextSeq <= CurTime() then
		self.Entity:ResetSequence( 0 )
		self.NextSeq = CurTime() + self.Entity:SequenceDuration( )/( self.PlaybackRate or 3 )
	end

	self:FrameAdvance( ( RealTime() - ( self.LastRender or 0 ) ) * ( 1 ) )
	--self:SetPlaybackRate( self.PlaybackRate or 3 )
	self:DrawModel()
	self.LastRender = RealTime()
	
end
end