ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

game.AddParticles("particles/blood_impact.pcf" )
PrecacheParticleSystem( "vomit_barnacle" )

PrecacheParticleSystem( "bloodtrap_projectile" )

if SERVER then
	AddCSLuaFile("shared.lua")
	

end
for i=2,4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end
util.PrecacheSound("physics/flesh/flesh_bloody_break.wav")
for i=1,2 do
	util.PrecacheSound("npc/barnacle/barnacle_digesting"..i..".wav")
end

util.PrecacheModel("models/props_trainstation/trainstation_clock001.mdl")

local table = table
local pairs = pairs

function ENT:Initialize()

	--self.EntOwner = self.Entity:GetOwner()
	self.Team = function()
		return self.EntOwner:Team()
	end
	
	if SERVER then
		self:SetModel("models/props_trainstation/trainstation_clock001.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
		self.Entity:DrawShadow(false)
		self:SetTrigger(true)
		
		self:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",140,math.random(95,110))
	end
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
			phys:SetMaterial("zombieflesh")
		end
	
	self:SetDTFloat(0,75)
	
	self:SetDTBool(0,false)
	
	if CLIENT then
		//self.Emitter = ParticleEmitter(self:GetPos())
		self:SetRenderBounds(Vector(-40, -40, -200), Vector(40, 40, 20))
	end
	
end

if SERVER then
	
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and not self.EntOwner:IsTeammate(dmginfo:GetAttacker()) then//dmginfo:GetAttacker():Team() ~= self.EntOwner:Team() then
			self:SetDTFloat(0,self:GetDTFloat(0) - dmginfo:GetDamage())
		
			if self:GetDTFloat(0) <=0 then
				self:EmitSound("physics/flesh/flesh_bloody_break.wav",140,math.random(95,110))
				self:Remove()
			end
		end
	end
	
	function ENT:OnRemove()
		if IsValid(self:GetDTEntity(0)) then
			local ent = self:GetDTEntity(0)
			if ent.Traps then
				for i,v in pairs(ent.Traps) do
					if v == self.Entity then
						ent.Traps[i] = nil
						table.Resequence(ent.Traps)
					end
				end
			end
		end
	end
	
end

local tracedown = {}
local trace = {}
local player_GetAll = player.GetAll
function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime and self.DieTime < CurTime() then
			self:Remove()
			return
		end
		
		
		tracedown.start = self:GetPos()+vector_up*-3
		tracedown.endpos = self:GetPos()+vector_up*-150
		tracedown.filter = {self.Entity,player_GetAll()}
		
		local trdown = util.TraceLine( tracedown )
		
		local dist = trdown.HitPos:Distance(self:GetPos()+vector_up*-20)
		
		
		trace.start = trdown.HitPos +vector_up*2
		trace.endpos = trdown.HitPos +vector_up*2
		trace.mins = Vector(-20,-20,0)
		trace.maxs = Vector(20,20,math.ceil(dist))
		trace.filter = {self.Entity,GetWorldEntity()}
		//trace.mask = MASK_PLAYERSOLID
		
		local tr = util.TraceHull( trace )
		
		self.NextDmg = self.NextDmg or 0
		
		if ValidEntity(tr.Entity) and tr.Entity:IsPlayer() and (tr.Entity == self.EntOwner or not self.EntOwner:IsTeammate(tr.Entity)) then//tr.Entity:Team() ~= self.EntOwner:Team() ) then
			
			local pl = tr.Entity
			if pl:GetGroundEntity() ~= NULL then
				pl:SetGroundEntity(NULL)
			end
			pl:SetLocalVelocity(vector_up*300)
			
			if self.NextDmg < CurTime() then
				self.NextDmg = CurTime() + 0.015
				pl:TakeDamage(math.random(2,4),self.EntOwner,self)
			end
			
			if !self:GetDTBool(0) then
				if math.random(1,100) ~= 1 then
					self:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav",140,math.random(95,110))
				else
					self:EmitSound("vo/SandwichEat09.wav",140,math.random(95,100))
				end
				self:SetDTBool(0,true)
				self.DieTime = CurTime() + 4
			end
			pl._BeingSucked = CurTime() + 1
		end
		
		
		
	end
end

if CLIENT then

local function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true

		local pos = hitpos + hitnormal

		util.Decal("Blood", pos, hitpos - hitnormal)

		particle:SetDieTime(0)
	end
end

function ENT:OnRemove()
	local emitter = ParticleEmitter(self:GetPos())
	if emitter then
		for i=1,math.random(10,14) do
			local particle = emitter:Add("Decals/Blood"..math.random(1,7).."", self:GetPos() + Vector(math.Rand(-30,30),math.Rand(-30,30),0) )
			particle:SetDieTime(math.Rand(2, 3))
			particle:SetStartAlpha(125)
			particle:SetStartSize(math.Rand(4, 14.5))
			particle:SetEndSize(math.Rand(4, 14.5))
			particle:SetGravity(Vector(0, 0, -500))
			particle:SetCollide(true)
			particle:SetAirResistance(0)
			particle:SetCollideCallback(CollideCallback)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	//if self.Emitter then
	//	self.Emitter:Finish()
	//end
end

function ENT:Draw()
	--self:DrawModel()
	
	local pos = self:GetPos()+vector_up*-4
	
	if not self.Particle then
		ParticleEffect("bloodtrap_projectile",pos,Angle(0,0,0),self.Entity)
		self.Particle = true
	end
	
	//if self:GetPos():Distance(EyePos()) > 990 then return end
	
	/*
	local ang = self:GetAngles()
	self.WParticles = self.WParticles or {}
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit < CurTime() then 
		
		for num=0,3 do
			self.WParticles[num] = {}
					
			for i=1, 6 do
				self.WParticles[num][i] = self.Emitter:Add("Decals/Blood"..math.random(1,7).."", pos )
			end
		
		end
		
		self.NextEmit = CurTime() + 0.1
					
	end
	
	for num=0,3 do

		self.WParticles[num] = self.WParticles[num] or {}			
				
		local radius = 30-9*num

		for i=1, #self.WParticles[num] do

			local LightColor = render.GetLightColor( pos ) * 255
			LightColor.r = math.Clamp( LightColor.r, 70, 255 )
			
			local rad = math.random(0,10)+10*num		
			local particle = self.WParticles[num][i]
			particle:SetPos(pos+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
			particle:SetDieTime(math.Rand(0.8, 2))
			particle:SetStartAlpha(125)
			particle:SetStartSize(math.Rand(4, 17.5-num*1.5))
			particle:SetEndSize(0)
			--particle:SetColor( LightColor.r*0.5, 0, 0 )
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(vector_up*math.Rand(-6,-3))
			particle:SetCollide(true)
			particle:SetAirResistance(12)
		end
	end	*/
	
	//active effect
	if self:GetDTBool(0) then
	
		if not self.StartedParticle then
			ParticleEffect("vomit_barnacle",self:GetPos()+vector_up*-5,Angle(0,0,0),self.Entity)
			self.StartedParticle = true
		end
		
		self.ANextEmit = self.ANextEmit or 0
		
		if self.ANextEmit > CurTime() then return end
		
		self.ANextEmit = CurTime() + 0.005
		
		local emitter = ParticleEmitter(self:GetPos())
		
		if emitter then
			local particle = emitter:Add("Decals/Blood"..math.random(1,7).."", pos + Vector(math.Rand(-30,30),math.Rand(-30,30),0) )
			particle:SetDieTime(math.Rand(0.8, 2))
			particle:SetStartAlpha(125)
			particle:SetStartSize(math.Rand(4, 14.5))
			particle:SetEndSize(math.Rand(4, 14.5))
			--particle:SetRoll(math.Rand(0, 360))
			--particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0, 0, math.Rand(-300, -150)))
			particle:SetCollide(true)
			particle:SetAirResistance(0)
			particle:SetCollideCallback(CollideCallback)
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end
	
end
end

if SERVER then

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
end