ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IsSpell = true
ENT.FuseTime = 0.7

game.AddParticles("particles/water_impact.pcf" )
PrecacheParticleSystem( "water_splash_01" )
PrecacheParticleSystem( "cyclonetrap_projectile" )
PrecacheParticleSystem( "cyclonetrap_projectile_fire" )
PrecacheParticleSystem( "cyclonetrap_projectile_snow" )
PrecacheParticleSystem( "cyclonetrap_projectile_electricity" )

if SERVER then
	AddCSLuaFile("shared.lua")
	

end

util.PrecacheSound("ambient/levels/labs/electric_explosion1.wav")
util.PrecacheSound("ambient/fire/gascan_ignite1.wav")
util.PrecacheSound("player/pl_fallpain1.wav")
for i=1,3 do
	util.PrecacheSound("ambient/water/water_splash"..i..".wav")
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
		self.Entity:SetMoveType(MOVETYPE_NONE)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
		self.Entity:DrawShadow(false)
		self:SetTrigger(true)
	end
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
			phys:SetMaterial("ice")
		end
	
	self.TrapHealth = 40
	//self:SetDTFloat(0,35)
	
	local tr = util.TraceLine({start = self:GetPos(), endpos = self:GetPos()+vector_up*300, filter = {self,player.GetAll()}})
	if tr.Hit and tr.HitWorld then
		self.HasCeilings = true
	end
	
	if CLIENT then
		self.Emitter = ParticleEmitter(self:GetPos())
		ParticleEffect("water_splash_01",self:GetPos()+vector_up*8,Angle(0,0,0),nil)
	end
	
	self.ReadyTime = CurTime() + self.FuseTime
	
end

function ENT:OnRemove()
	if CLIENT then
		local e = EffectData()
		e:SetOrigin(self:GetPos()+vector_up*3)
		e:SetNormal(vector_up)
		util.Effect("watersplash",e)
		ParticleEffect("water_splash_01",self:GetPos()+vector_up*3,Angle(0,0,0),nil)
		for i=1,math.random(10,25) do
			local particle = self.Emitter:Add(math.random(1,3) == 1 and "sprites/heatwave" or "effects/splashwake1", self:GetPos() +VectorRand()*math.random(0,20))
			particle:SetVelocity(VectorRand()*math.random(-10,10)+vector_up*4*i)
			particle:SetDieTime(math.Rand(0.8, 3))
			particle:SetStartAlpha(125)
			particle:SetStartSize(math.Rand(2, i*4))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(vector_up*math.Rand(-10,1))
			particle:SetCollide(true)
			particle:SetAirResistance(5)
		end
	end
	if SERVER then
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

if SERVER then
	
	function ENT:StartTouch( ent )
		if ent:IsValid() and (ent:IsPlayer() and ent:Alive() and (ent == self.EntOwner or not ent:IsTeammate(self.EntOwner)) or ent:IsNPC() ) and self.ReadyTime <= CurTime() then
			ent:SetGroundEntity(NULL)
			ent:SetLocalVelocity(vector_up*math.random(500,600))
			
			if self:GetDTBool(0) then
				ent:TakeDamage(math.random(90,100),self.EntOwner,self)
				//local e = EffectData()
				//e:SetEntity(ent)
				//util.Effect("electrocution",e,true,true)
				ent:SetEffect("electrocuted")
				WorldSound("ambient/levels/labs/electric_explosion1.wav",ent:GetPos(),90,math.random(95,130))
			end
			
			if self:GetDTBool(1) then
				ent:TakeDamage(math.random(50,60),self.EntOwner,self)
				//ent:SetEffect("afterburn")
				WorldSound("ambient/fire/gascan_ignite1.wav",ent:GetPos(),90,math.random(90,110))
			end
			
			if self:GetDTBool(2) then
				ent:TakeDamage(math.random(40,55),self.EntOwner,self)
				ent:SetEffect("frozen")
			end
			
			if self.HasCeilings then
				ent:TakeDamage(math.random(30,50),self.EntOwner,self)
				ent:EmitSound("player/pl_fallpain1.wav")
			end
			
			self:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav",130,math.random(95,110))
			
			self:Remove()
		end
	end
	
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and not self.EntOwner:IsTeammate(dmginfo:GetAttacker()) then//:Team() ~= self.EntOwner:Team() then
			//self:SetDTFloat(0,self:GetDTFloat(0) - dmginfo:GetDamage())
			self.TrapHealth = self.TrapHealth - dmginfo:GetDamage()
		
			if self.TrapHealth <= 0 then
				self:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav",130,math.random(95,110))
				self:Remove()
			end
		end
	end
	
end

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		
	end
end

if CLIENT then
local mat = Material( "sprites/rollermine_shock" )
function ENT:Draw()
	//self:DrawModel()
	
	//if self:GetPos():Distance(EyePos()) > 990 then return end
	
	if not self.Particle then
		self.Particle = "error"
	end
	
	if self:GetDTBool(0) then
		if self.Particle ~= "elec" then
			self:StopParticles()
			ParticleEffectAttach("cyclonetrap_projectile_electricity",PATTACH_ABSORIGIN_FOLLOW,self,0)
			self.Particle = "elec"
		end
	elseif self:GetDTBool(1) then
		if self.Particle ~= "fire" then
			self:StopParticles()
			ParticleEffectAttach("cyclonetrap_projectile_fire",PATTACH_ABSORIGIN_FOLLOW,self,0)
			self.Particle = "fire"
		end
	elseif self:GetDTBool(2) then
		if self.Particle ~= "snow" then
			self:StopParticles()
			ParticleEffectAttach("cyclonetrap_projectile_snow",PATTACH_ABSORIGIN_FOLLOW,self,0)
			self.Particle = "snow"
		end
	else
		if self.Particle ~= "normal" then
			self:StopParticles()
			ParticleEffectAttach("cyclonetrap_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
			self.Particle = "normal"
		end
	end
	
	/*local pos = self:GetPos()+vector_up*4
	local ang = self:GetAngles()
	self.WParticles = self.WParticles or {}
	
	self.NextEmit = self.NextEmit or 0
	
	
	
	if self.NextEmit < CurTime() then 
		
		for num=0,3 do
			self.WParticles[num] = {}
					
			for i=1, 4 do
				self.WParticles[num][i] = self.Emitter:Add("sprites/heatwave", pos )
			end
		
		end
		
		self.NextEmit = CurTime() + 0.1
					
	end
	
	for num=0,3 do

		self.WParticles[num] = self.WParticles[num] or {}			
				
		local radius = 30-9*num

		for i=1, #self.WParticles[num] do

			local rad = math.random(0,10)+10*num		
			local particle = self.WParticles[num][i] --self.Emitter:Add("sprites/heatwave", pos+ang:Forward()*3 +VectorRand()*1.4 )
			particle:SetPos(pos+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
			particle:SetDieTime(math.Rand(0.8, 2))
			particle:SetStartAlpha(125)
			particle:SetStartSize(math.Rand(4, 10.5-num*1.5))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(vector_up*math.Rand(3,6))
			particle:SetCollide(true)
			particle:SetAirResistance(12)
		end
	end
	
	//charged (ebolt)
	if self:GetDTBool(0) then
		for num=1,10 do
			render.SetMaterial( mat ) 
				render.StartBeam( 4 )
				render.AddBeam( pos , 2, 0, Color( 255, 255, 255, 255 ) )
				for i=1, 2 do
					local rand = VectorRand() * num*3
					rand.z = math.random(-1,4)
					local curpos = pos + rand
					render.AddBeam( curpos , 2, CurTime() + i/2, Color( 255, 255, 255, 255 ) )
				end
					
				render.AddBeam( pos+ VectorRand() * math.Rand(3,8) , 2, 1, Color( 255, 255, 255, 255 ) )
			render.EndBeam()
		end
	end
	
	//charged (fire)
	if self:GetDTBool(1) then
		self.NextTick = self.NextTick or 0
		
		if self.NextTick < CurTime() then
			self.NextTick = CurTime() + 0.07
			
			for i=1,math.random(2,4) do 
				local rand = VectorRand()*math.random(0,30)
				rand.z = math.Rand(-1,1)
				local particle = self.Emitter:Add("effects/fire_cloud"..math.random(1,2), pos+rand )
				--particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(1, 1.5))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(4, 11))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector(0,0,30))
				particle:SetCollide(true)
				particle:SetLighting(math.random(1,3) == 3 and true or false)
				particle:SetAirResistance(12)
			end
		end
	end
	
	//charged (snow)
	if self:GetDTBool(2) then
		self.NextTick = self.NextTick or 0
		
		if self.NextTick < CurTime() then
			self.NextTick = CurTime() + 0.07
			
				for i=1,math.random(2,4) do 
					local rand = VectorRand()*math.random(0,30)
					rand.z = math.Rand(-1,1)
					local particle = self.Emitter:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", pos+rand )
					--particle:SetVelocity(owner:GetVelocity())
					particle:SetDieTime(math.Rand(1, 1.5))
					particle:SetStartAlpha(255)
					local rand = math.random(130,245)
					particle:SetColor(rand,rand,255)
					particle:SetStartSize(math.Rand(7, 11))
					particle:SetEndSize(math.Rand(7, 11))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetGravity(VectorRand()*math.random(-40,40))
					particle:SetCollide(true)
					--particle:SetLighting(true)
					particle:SetAirResistance(12)
				end
		end
	end
	*/
end
end

if SERVER then

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
end