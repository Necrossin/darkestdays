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

util.PrecacheSound("ambient/levels/citadel/pod_open1.wav")
util.PrecacheSound("weapons/stunstick/alyx_stunner1.wav")


for i=3,4 do
	util.PrecacheSound("ambient/machines/teleport"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		if GAMEMODE.ConquestPoints and #GAMEMODE.ConquestPoints < 1 then
			self:SetMainPoint()
			game.GetWorld():SetDTEntity(0,self.Entity)
		end
		
		table.insert(GAMEMODE.ConquestPoints,self)
		
		self:SetPos(self:GetPos()+vector_up*2)
	
		self.Entity:DrawShadow(false)
		
		self:SetCaptureTimer(1,0)
		self:SetCaptureTimer(2,0)
		
		if self:IsMainPoint() then
			
			local dummy = ents.Create("conquest_manager")
			dummy:SetPos(self:GetPos())
			dummy:Spawn()
			dummy:Activate()
			
			self:SetDTEntity(0,dummy)
			
			dummy:SetDTInt(self:TeamToHill(TEAM_RED),CONQUEST_TICKETS)
			dummy:SetDTInt(self:TeamToHill(TEAM_BLUE),CONQUEST_TICKETS)

			//game.GetWorld():SetDTInt(self:TeamToHill(TEAM_RED),CONQUEST_TICKETS)
			//game.GetWorld():SetDTInt(self:TeamToHill(TEAM_BLUE),CONQUEST_TICKETS)

			self:SetStartTime(CurTime() + 10)//80
		end
	end
	
	if CLIENT then 
		self.Emitter = ParticleEmitter(self:GetPos())
		self.Emitter:SetNoDraw()
	end
	
end

function ENT:OnRemove()
	if CLIENT then
		if self.Emitter then
			self.Emitter:Finish()
		end
	end
end

function ENT:Think()
	
	if not self:IsActive() then return end
		
	local red,blue = self:GetPlayersOnPoint()
		
	if SERVER then	
	
		if red > 0 and blue == 0 then
			self:CheckCapture(TEAM_RED)
		elseif red == 0 and blue > 0 then
			self:CheckCapture(TEAM_BLUE)
		else
			self:CheckCapture()
		end
		
		if self:IsMainPoint() then
			
			local ct = CurTime()
			
			self.NextTick = self.NextTick or 0
			
			if self.NextTick > ct then return end
			
			self.NextTick = ct + CONQUEST_TICKET_DRAIN_TIME//self:GetTickAmount(self:GetHoldingTeam())
			
			local redpoints,bluepoints = 0,0
			local wintm = 0
			
			for _, point in ipairs(GAMEMODE.ConquestPoints or {}) do
				if point and IsValid(point) then
					if point:IsBeingHeld() then
						if point:GetHoldingTeam() == 1 then
							redpoints = redpoints + 1
						elseif point:GetHoldingTeam() == 2 then
							bluepoints = bluepoints + 1
						end
					end
				end
			end
			
			if redpoints >= math.Round((#GAMEMODE.ConquestPoints or 3)/2) then
				wintm = 2
			elseif bluepoints >= math.Round((#GAMEMODE.ConquestPoints or 3)/2) then
				wintm = 1
			end
			
			if wintm ~= 0 then
				GAMEMODE:DrainTickets(wintm)
			end
			
		end
		
		--print("Red "..ToMinutesSeconds( self:GetTeamTimer(1) ).." | Blue "..ToMinutesSeconds( self:GetTeamTimer(2) ))
		
		--print("Red "..red.." | Blue "..blue)
	end
end

function ENT:CheckZ(p,hill)
	local result = false
	if p:GetPos().z >= hill:GetPos().z - 50 and p:GetPos().z <= hill:GetPos().z + 80 then
		result = true
	end
	return result
end

function ENT:GetPlayersOnPoint()
	
	local all = player.GetAll()
	
	local players = {}
	players[TEAM_RED] = 0
	players[TEAM_BLUE] = 0
	
	for _,p in ipairs(all) do
		if IsValid(p) and p:Alive() and !p:IsCrow() and self:GetPos():Distance(p:GetPos()) <= self:GetRadius() and self:CheckZ(p,self.Entity) and (p:Team() == TEAM_RED or p:Team() == TEAM_BLUE) then
			players[p:Team()] = players[p:Team()] + 1
		end
	end
	
	return players[TEAM_RED], players[TEAM_BLUE]
	
end

function ENT:CheckCapture(tm)
	
	
	local t = 0
	if tm then 
		t = self:TeamToHill(tm)
	end
		
	//if t == 0 then return end
	if t == self:GetHoldingTeam() and self:GetCaptureTimer(t) == CONQUEST_CAPTURE_TIME then return end
	
	local enemytm = t == 1 and 2 or t == 2 and 1 or 1
	
	self.NextCap = self.NextCap or 0
	
	
	
	local ct = CurTime()
	
	if self.NextCap >= ct then return end
	
	if t == 0 then
		
		if self:GetHoldingTeam() == 0 then
			if self:GetCaptureTimer(1) > 0 then
				self:SetCaptureTimer(1,self:GetCaptureTimer(1)-1)
			end
			if self:GetCaptureTimer(2) > 0 then
				self:SetCaptureTimer(2,self:GetCaptureTimer(2)-1)
			end
			
			self.NextCap = ct + 1
		end
		
		return
	end
	
	
	if self:GetCaptureTimer(t) == CONQUEST_CAPTURE_TIME and t ~= self:GetHoldingTeam() then
		self:SetHoldingTeam(tm)
		sound.Play("ambient/levels/citadel/pod_open1.wav",self:GetPos(),140,100,1)
	end
	
	self.NextCap = ct + 1
	
	if self:GetCaptureTimer(enemytm) > 0 and self:GetHoldingTeam() == enemytm then
		self:SetCaptureTimer(enemytm,self:GetCaptureTimer(enemytm)-1)
	end
	
	if self:GetCaptureTimer(1) == 0 and self:GetCaptureTimer(2) == 0 and self:GetHoldingTeam() ~= 0 then
		self:SetHoldingTeam()
		sound.Play("weapons/stunstick/alyx_stunner1.wav",self:GetPos(),140,100,1)
	end
	
	if self:GetCaptureTimer(t) <= CONQUEST_CAPTURE_TIME and self:GetCaptureTimer(enemytm) == 0 then
		self:SetCaptureTimer(t,self:GetCaptureTimer(t)+1)
		//self:SetCaptureTimer(enemytm,self:GetCaptureTimer(enemytm)-1)
	end
	
	
	
end

if CLIENT then
function ENT:Draw()
	
	
	
	local vec = Vector(self:GetRadius()*1.6,self:GetRadius()*1.6,50)
	self.Entity:SetRenderBounds( vec, -vec) 

	
	
	local r,g,b = 255,255,255
	
	if self:IsBeingHeld() then
		if self:GetHoldingTeam() == 1 then
			r,g,b = 250,50,50
			elseif self:GetHoldingTeam() == 2 then
			r,g,b = 50,50,250
		end
	end
	
	local dlight = DynamicLight( self:EntIndex() )
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
	end
	
	if not self.Emitter then
		self.Emitter = ParticleEmitter(self:GetPos())
		self.Emitter:SetNoDraw()
	end
	
	cam.IgnoreZ(true)
		self.Emitter:Draw()
	cam.IgnoreZ(false)
	
	local pos = self:GetPos()+vector_up*12
	
	local trace = {}
	trace.start = self:GetPos()+vector_up*30
	trace.endpos = self:GetPos()+vector_up*-150
	trace.filter = {self.Entity,player.GetAll()}
	trace.mask = MASK_SOLID_BRUSHONLY
	
	trace = util.TraceLine(trace)
	
	local norm = vector_up
	
	if trace.HitNormal then
		norm = trace.HitNormal
	end
	
	
	local ang = norm:Angle()//self:GetAngles()
	
	self.Particles = self.Particles or {}
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit < CurTime() then 
		
		for i=1, 6 do
			self.Particles[i] = self.Emitter:Add("particle/smokestack", pos )
		end
		
		self.NextEmit = CurTime() + 0.012
		
	end
		
	local radius = self:GetRadius()

	for i=1, #self.Particles do	
		local rad = 60*i		
		local particle = self.Particles[i]
		particle:SetPos(pos+ang:Right()*math.sin( CurTime()+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()+math.rad( rad*i ) ) * radius)
		particle:SetDieTime(math.Rand(0.8, 1.5))
		particle:SetStartAlpha(125)
		particle:SetStartSize(math.Rand(4, 17.5-i*1.5))
		particle:SetEndSize(0)
		
		if self:IsBeingHeld() then
			
			if self:GetHoldingTeam() == 1 then
				particle:SetColor( 250,50,50 )
			elseif self:GetHoldingTeam() == 2 then
				particle:SetColor( 50,50,250 )
			end
			
		end
		
		--particle:SetColor( LightColor.r*0.5, 0, 0 )
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(vector_up*math.Rand(-6,-3))
		particle:SetCollide(true)
		particle:SetAirResistance(12)
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

function ENT:SetCaptureTimer(tm,time)
	self:SetDTInt(tm,math.Clamp(time,0,CONQUEST_CAPTURE_TIME))
end

function ENT:GetCaptureTimer(tm)
	return self:GetDTInt(tm)
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
	self:SetDTInt(3,am)
end

function ENT:GetRadius(a)
	return self:GetDTInt(3)
end

function ENT:IsActive()
	local ent = IsValid(GetHillEntity()) and GetHillEntity():GetDTEntity(0)//SERVER and game.GetWorld() or CLIENT and Entity(0)
	return ent and IsValid(ent) and ent:GetDTFloat(3) < CurTime() or false
end

function ENT:SetStartTime(time)
	GetHillEntity():GetDTEntity(0):SetDTFloat(3,time) 
	//game.GetWorld():SetDTFloat(3,time) 
end

function ENT:SetMainPoint()
	self:SetDTBool(0,true)
end

function ENT:IsMainPoint()
	return self:GetDTBool(0)
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

