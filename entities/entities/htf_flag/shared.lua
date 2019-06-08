ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

local TeamOfHill = {}
TeamOfHill[TEAM_RED] = 1
TeamOfHill[TEAM_BLUE] = 2

local HillOfTeam = {}
HillOfTeam[1] = TEAM_RED
HillOfTeam[2] = TEAM_BLUE

local util = util
local team = team
local game = game
local player = player
local ipairs = ipairs
local math = math

if SERVER then
	AddCSLuaFile("shared.lua")
end

for i=3,4 do
	//util.PrecacheSound("ambient/machines/teleport"..i..".wav")
end

util.PrecacheModel("models/Roller_Spikes.mdl")

local dropsound = Sound("weapons/stunstick/alyx_stunner2.wav")
local picksound = Sound("npc/roller/mine/rmine_taunt1.wav")

PrecacheParticleSystem( "flag_neutral" )


function ENT:Initialize()

	
	if SERVER then
		self:SetPos(self:GetPos()+vector_up*25)
		self:SetModel("models/Roller_Spikes.mdl")
		
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		//self.Entity:SetSolid(SOLID_NONE)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
		end
		
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		self.Entity:SetTrigger(true)
	
		self.Entity:DrawShadow(false)
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTeamTimer(self:TeamToHill(TEAM_RED),HTF_FLAG_TIME)
		self:SetTeamTimer(self:TeamToHill(TEAM_BLUE),HTF_FLAG_TIME)
		
		self:SetStartTime(CurTime() + 80)
		//self:SetPointTime(CurTime()+80+math.random(35,60))
	end
	
	if CLIENT then 
		//self.Emitter = ParticleEmitter(self:GetPos())
	end
	
end

function ENT:OnRemove()
	if CLIENT then
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
	end
end

if SERVER then
	
	function ENT:StartTouch( ent )
		if self.NextTouch and self.NextTouch >= CurTime() then return end
		if self:IsBeingHeld() then return end
		if not self:IsActive() then return end
		
		if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
			if ent:IsJuggernaut() then return end
			if ent:IsCrow() then return end
			if ent:IsThug() then return end
			if ent:IsSprinting() then return end
			if IsValid(ent._efSlide) then return end
			
			self:SetHoldingTeam(ent:Team())
			self:SetCarrier(ent)
			
			self:SetRespawnTime(0)
			
			self:EmitSound(picksound)
			
			self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			
			GAMEMODE:HUDMessage(nil, ent:Nick().." has picked up the flag!", ent, 1)
			
			local phys = self.Entity:GetPhysicsObject()
			if (phys:IsValid()) then
				phys:Wake()
				phys:EnableMotion( true ) 
			end
		end
	end
	
end

if SERVER then
hook.Add("PlayerDisconnected", "RestoreFlag", function(pl)
	if pl:IsCarryingFlag() then
		local flag = GetHillEntity()
		if IsValid(flag) and flag.DropFlag then
			flag:DropFlag()
		end
	end
end)
end

function ENT:Think()
	if SERVER then
		if !IsValid(self:GetCarrier()) and self:GetHoldingTeam() ~= 0 then
			self:DropFlag()
		end
	
		if not self:IsActive() then return end
				
		local ct = CurTime()
		
		self:CheckDroppedFlag()
		
		if self:IsBeingHeld() then
			
			if !IsValid(self:GetCarrier()) or !self:GetCarrier():Alive() or self:GetCarrier():IsCrow() then
				self:DropFlag()
			end
		
			self.NextTick = self.NextTick or 0
			
			if self.NextTick <= ct then

				self:DrainTeamTimer(self:GetHoldingTeam())
			
				self.NextTick = ct + 1//self:GetTickAmount(self:GetHoldingTeam())
			end
			
			if IsValid(self:GetCarrier()) and #player.GetAll() > 1 then
				if self:GetCarrier()._CapturePoints and self:GetCarrier()._CapturePoints <= ct then
					self:GetCarrier():AddXP(8)
					self:GetCarrier()._CapturePoints = ct + 15
				end
			end
			
		end
	
	end
end

if CLIENT then
local vec = Vector(148,148,148)
function ENT:Draw()
	
	
	self.Entity:SetRenderBounds( vec, -vec) 

	if self:GetCarrier() and IsValid(self:GetCarrier()) then
		local owner = self:GetCarrier()
		
		if self.Particle then
			self.Particle = nil
			self.Entity:StopParticles()
		end
		
		if owner == MySelf and not GAMEMODE.ThirdPerson then return end
		
		local bone = owner:LookupBone( "ValveBiped.Bip01_L_Hand" ) 
	
		if bone then  
			local pos, ang = owner:GetBonePosition(bone)
			
			//self:SetPos(pos+ang:Forward()*-2)
			
			self:SetModelScale(0.7,0)
			self:SetRenderOrigin( pos+ang:Forward()*-2)
			self:DrawModel()
			self:SetRenderOrigin()
		end

	else
		self:SetModelScale(1,0)
		self:DrawModel()
		
		if not self.Particle then
			ParticleEffectAttach("flag_neutral",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
			self.Particle = true
		end
	end						
end
end

function ENT:TeamToHill(tm)
	return TeamOfHill[tm]
end

function ENT:HillToTeam(htm)
	return HillOfTeam[htm]
end

function ENT:SetHoldingTeam(tm)
	local t = 0
	if tm then 
		t = self:TeamToHill(tm)
	end
	self:SetDTInt(0,t)
end

function ENT:GetHoldingTeam()
	return self:GetDTInt(0)
end

function ENT:IsBeingHeld()
	return self:GetHoldingTeam() ~= 0
end

function ENT:SetTeamTimer(tm,time)
	self:SetDTFloat(tm,time)
end

function ENT:GetTeamTimer(tm)
	return self:GetDTFloat(tm)
end

function ENT:SetCarrier(ent)
	if ent and ent:IsPlayer() then
		self:SetPos(ent:GetPos()+vector_up*50)
		self:SetParent(ent)
		self:SetOwner(ent)
		self:SetSolid(SOLID_NONE)
		//self.Entity:PhysicsInit(SOLID_NONE)
		self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		ent._CapturePoints = CurTime() + 15 
		
		//ent:Give("flag_carry")
		//ent:SelectWeapon("flag_carry")
		
		//if team.NumPlayers(ent:Team()) > 1 then
		//	ent:SprintDisable()
		//end
		
	else
		self:SetOwner()
		self:SetParent()
		self:SetSolid(SOLID_VPHYSICS)
	end
	self:SetDTEntity(1,ent or nil)
end

function ENT:DropFlag(reset)
	self.NextTouch = CurTime() + 0.3
	
	//if not throw then
		//self:EmitSound(dropsound)
	//end
	
	if IsValid(self:GetCarrier()) then
	//	self:GetCarrier():StripWeapon("flag_carry")
		//self:GetCarrier():SendLua("RestoreBoneMods()")
		//self:GetCarrier():SprintEnable( )
		GAMEMODE:HUDMessage(nil, self:GetCarrier():Nick().." has dropped the flag!", self:GetCarrier(), 3)
	end
	
	self:SetHoldingTeam()
	
	self:SetCarrier()
	self:SetParent()
	//self:SetMoveType(MOVETYPE_VPHYSICS)
	//self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetTrigger(true)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(true)
		phys:SetMaterial("metal_bouncy")
		//if throw then
			phys:SetVelocity(vector_up*math.random(900,1400)+VectorRand()*math.random(0,200))
		//end
	end

	self:SetRespawnTime(CurTime()+(reset and 0 or HTF_RESPAWN_TIME))
	
	
	
end

function ENT:GetCarrier()
	return self:GetDTEntity(1)
end

function ENT:GetTickAmount(tm)
	local am = 1
	local need = false
	
	local myteam = self:HillToTeam(tm)
	local otherteam = TEAM_RED
	if myteam == otherteam then
		otherteam = TEAM_BLUE
	end
	
	local hmyteam = self:TeamToHill(myteam)
	local hotherteam = self:TeamToHill(otherteam)
	
	if (team.NumPlayers(myteam) < team.NumPlayers(otherteam) or team.GetScore(myteam) < team.GetScore(otherteam)) and 
		self:GetTeamTimer(hmyteam) > self:GetTeamTimer(hotherteam)and self.Swaps and self.Swaps > 3 then
		am = 0.45
		need = true
	end
	
	local haste,hasteAm = self:IsHasteMode()
	if haste then
		if need then
		//	am = am*hasteAm
		else
		//	am = hasteAm
		end
	end
	
	return am or 1
	//No haste for now
	
end

function ENT:IsHasteMode()
	
	local result,am = false,1
	
	local all = player.GetAll()
	
	if #all <= 4 then
		result,am = true,0.7
		if #all <= 3 then
			result,am = true,0.6
			if #all <= 2 then
				result,am = true,0.5
				if #all <= 1 then
					result,am = true,0.4
				end
			end
		end
	end
	return result,am
end

function ENT:DrainTeamTimer(tm)
	self:SetTeamTimer(tm,math.Clamp(self:GetTeamTimer(tm) - 1, 0,999999))
	if self:GetTeamTimer(tm) == 60 or self:GetTeamTimer(tm) == 120 or self:GetTeamTimer(tm) == 180 then
		self:DropFlag(true)
	end
end

function ENT:SetPointTime(time)
	self:SetDTFloat(0,time)
end

function ENT:GetPointTime()
	return self:GetDTFloat(0)
end

function ENT:SetRespawnTime(am)
	self:SetDTInt(1,am)
end

function ENT:GetRespawnTime()
	return self:GetDTInt(1)
end

function ENT:CheckDroppedFlag()
	local resp = self:GetRespawnTime()
	if resp == 0 or CurTime() < resp then return end
	self:SetRespawnTime(0)

	self:ResetFlag()
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time) 
end

function ENT:ResetFlag()
	
	if not KOTHPoints then return end
	if #KOTHPoints < 1 then return end
		
	local ind = math.random(1,#KOTHPoints)
		
	local rand = KOTHPoints[ind]
		
	self:SetPos(rand.Pos+vector_up*25)
	//self:SetRadius(rand.R)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Sleep()
		phys:EnableMotion( false ) 
	end
	
		
	sound.Play("ambient/machines/teleport"..math.random(3,4)..".wav",rand.Pos,140,100,1)
	
	GAMEMODE:HUDMessage(nil, "Flag has been reset!", nil, 0)
		
	self:SetStartTime(CurTime() + 10)
	
end

if SERVER then
	--function ENT:UpdateTransmitState()
	--	return TRANSMIT_ALWAYS
	--end
end

