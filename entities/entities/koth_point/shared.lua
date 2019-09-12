ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

//TEAM_RED is 1
//TEAM_BLUE is 2
//REMEMBER!
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
	util.PrecacheSound("ambient/machines/teleport"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetPos(self:GetPos()+vector_up*2)
		/*self:SetModel("models/Items/BoxMRounds.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )*/
	
		self.Entity:DrawShadow(false)
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTeamTimer(self:TeamToHill(TEAM_RED),KOTH_HILL_TIME)
		self:SetTeamTimer(self:TeamToHill(TEAM_BLUE),KOTH_HILL_TIME)
		
		self:SetStartTime(CurTime() + 80)
		self:SetPointTime(CurTime()+80+math.random(35,60))
		
		self.Swaps = 0
	end
	
	if CLIENT then 
		//self.Emitter = ParticleEmitter(self:GetPos())
	end
	
end

function ENT:OnRemove()
	if CLIENT then
		if self.Emitter then
			//self.Emitter:Finish()
		end
	end
end

function ENT:Think()
	if SERVER then
		if not self:IsActive() then 
			if self:IsBeingHeld() then
				self:SetHoldingTeam()
			end
			return
		end
		
		local ct = CurTime()
		
		self:MoveHill()
		
		--local red, blue, red_am, blue_am = self:GetPlayersOnPoint()
		local red, blue = self:GetPlayersOnPoint()
		local red_am, blue_am = #red, #blue
		
		self.CapturePoints = self.CapturePoints or 0
		
		if red_am > 0 and blue_am == 0 then
			self:SetHoldingTeam(TEAM_RED)
			if self.CapturePoints == 0 then
				self.CapturePoints = ct + 10
			end
		elseif red_am == 0 and blue_am > 0 then
			self:SetHoldingTeam(TEAM_BLUE)
			if self.CapturePoints == 0 then
				self.CapturePoints = ct + 10
			end
		else
			self:SetHoldingTeam()
			self.CapturePoints = 0
		end
		
		if self:IsBeingHeld() then
			
			self.NextTick = self.NextTick or 0
			
			if self.NextTick <= ct then
				//print("tick")
				self:DrainTeamTimer(self:GetHoldingTeam())
			
				self.NextTick = ct + self:GetTickAmount(self:GetHoldingTeam())
				//self.NextTick = ct + 1
			end
			
			if self.CapturePoints ~= 0 and self.CapturePoints <= ct and #player.GetAll() > 1 then
				if self:GetHoldingTeam() == 1 then
					--for _,p in pairs(red) do
						--if IsValid( p ) then
							--p:AddXP(8)
						--end
					--end
				end
				if self:GetHoldingTeam() == 2 then
					--if IsValid( p ) then
						--p:AddXP(8)
					--end
				end
				self.CapturePoints = ct + 10
			end
		
		end
		
		--print("Red "..ToMinutesSeconds( self:GetTeamTimer(1) ).." | Blue "..ToMinutesSeconds( self:GetTeamTimer(2) ))
		
		--print("Red "..red_am.." | Blue "..blue_am)
	end
end

local function CheckZ(p,hill)
	local result = false
	if p:GetPos().z >= hill:GetPos().z - 50 and p:GetPos().z <= hill:GetPos().z + 80 then
		result = true
	end
	return result
end

local players = {}
local player_GetAll = player.GetAll
local function InsertTBL(tbl, player)
    tbl[#tbl + 1] = player
end

function ENT:GetPlayersOnPoint()
   
    players[TEAM_RED] = {}
    players[TEAM_BLUE] = {}

    for _, p in ipairs(player_GetAll()) do
        if p:IsValid() and p:Alive() and not p:IsCrow() and self:GetPos():DistToSqr(p:GetPos()) <= self:GetRadiusSqr() and CheckZ(p, self.Entity) then
            local team = p:Team()
            if (team == TEAM_RED or team == TEAM_BLUE) then
                InsertTBL(players[team], p)
            end
        end
    end

    return players[TEAM_RED], players[TEAM_BLUE]
end

/*function ENT:GetPlayersOnPoint()
	
	local all = player.GetAll()
	local red_am = 0
	local blue_am = 0
	
	if players[TEAM_RED] then
		--table.Empty(players[TEAM_RED])
	else
		players[TEAM_RED] = {}
	end
	
	if players[TEAM_BLUE] then
		--table.Empty(players[TEAM_BLUE])
	else
		players[TEAM_BLUE] = {}
	end
	
	for _,p in ipairs( all ) do
		if IsValid( p ) then
			if p:Alive() and !p:IsCrow() and self:GetPos():DistToSqr(p:GetPos()) <= self:GetRadiusSqr() and CheckZ(p,self.Entity) then
				if p:Team() == TEAM_RED then
					red_am = red_am + 1
					players[ TEAM_RED ][ p:EntIndex() ] = p
					players[ TEAM_BLUE ][ p:EntIndex() ] = nil
				end

				if p:Team() == TEAM_BLUE then
					blue_am = blue_am + 1
					players[ TEAM_BLUE ][ p:EntIndex() ] = p
					players[ TEAM_RED ][ p:EntIndex() ] = nil
				end
				--table.insert(players[p:Team()],p)
			else
				players[ p:Team() ][ p:EntIndex() ] = nil
			end
		end
	end
	
	return players[TEAM_RED], players[TEAM_BLUE], red_am, blue_am
	
end*/

if CLIENT then

function ENT:Draw()
	
	local radius = self:GetRadius()
	self.LastRadius = self.LastRadius or radius
	
	if self.LastRadius ~= radius then
		local vec = Vector(radius*1.6,radius*1.6,50)
		self.Entity:SetRenderBounds( vec, -vec) 
	end
	
	local eff = "hill_neutral"

	if self:IsBeingHeld() then
		if self:GetHoldingTeam() == 1 then
			eff = "hill_red"
			elseif self:GetHoldingTeam() == 2 then
			eff = "hill_blue"
		end
	end
	
	if not self.PTable then
		self.PTable = {}
		self.PTable["base"] = {["entity"] = self.Entity,["attachtype"] = PATTACH_ABSORIGIN_FOLLOW}
		self.Effect = eff
	end
	
	/*local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 0
		dlight.Size = self:GetRadius()
		dlight.Decay = self:GetRadius() * 5
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
	end*/
	
	if self.Effect ~= eff then
		self.Effect = eff
		self.Entity:StopParticles()
		self.Particle = nil
	end
	
	if radius ~= self:GetRadius() then
		radius = self:GetRadius()
		self.Entity:StopParticles()
		self.Particle = nil
	end
	//2nd is radius
	if not self.Particle then
		self.Entity:CreateParticleEffect(self.Effect,{self.PTable["base"],{},{["position"] = Vector(self:GetRadius(),0,0)}})
		self.Particle = true
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
			am = am*hasteAm
		else
			am = hasteAm
		end
	end
	
	return am or 1
	
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
end

function ENT:SetPointTime(time)
	self:SetDTFloat(0,time)
end

function ENT:GetPointTime()
	return self:GetDTFloat(0)
end

function ENT:SetRadius(am)
	self:SetDTInt(1,am)
	self:SetDTInt(2,am * am)
end

function ENT:GetRadius()
	return self:GetDTInt(1)
end

function ENT:GetRadiusSqr()
	return self:GetDTInt(2)
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time) 
end

function ENT:GetStartCooldown()
	return math.Round( math.Clamp( self:GetDTFloat(3) - CurTime(), 0, 100 ) ) 
end

function ENT:MoveHill()
	
	if not KOTHPoints then return end
	if #KOTHPoints < 1 then return end
	
	if self:GetPointTime() <= CurTime() then
		
		self:SetPointTime(CurTime()+math.random(35,60))
		
		local ind = math.random(1,#KOTHPoints)
		
		if ind == self.LastInd then
			if ind == #KOTHPoints then 
				ind = 1 
			else
				ind = ind + 1
			end
		end
		
		local rand = KOTHPoints[ind]
		
		self:SetPos(rand.Pos)
		self:SetRadius(rand.R)
		self.LastInd = ind
		
		sound.Play("ambient/machines/teleport"..math.random(3,4)..".wav",rand.Pos,140,100,1)
		
		self.Swaps = self.Swaps +1
		
		GAMEMODE:HUDMessage(nil, "Hill has been reset!", nil, 0)
		
		self:SetStartTime(CurTime() + 10)
		self:SetHoldingTeam()
	end
	
end

function GetHillEntity()
	if SERVER then return game.GetWorld():GetDTEntity(0) end
	if CLIENT then return Entity(0):GetDTEntity(0) end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

