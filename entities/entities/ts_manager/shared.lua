if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	if SERVER then	
		self.Entity:DrawShadow(false)
		
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTimer(TS_TIME)
		
		self:SetStartTime(CurTime() + 85)
		
		self.CheckedSpectators = false
	end	
end


function ENT:Think()
	if SERVER then	
		if not self:IsActive() then return end
		
		if #team.GetPlayers(TEAM_THUG) <= 0 and #team.GetPlayers(TEAM_BLUE) > 0 then
			local req = math.Round(#team.GetPlayers(TEAM_BLUE) * ( TS_THUGS / 100 ))
			
			
			if req > 0 then
				
				for i=1, req do
					
					local fresh = team.GetPlayers(TEAM_BLUE)[math.random(1,#team.GetPlayers(TEAM_BLUE))]

					if IsValid(fresh) and fresh:Alive() then
						fresh:Kill()
						fresh:ChatPrint( translate.ClientGet( fresh, "obj_ts_welcome" ) )
						fresh:Spawn()
					end
					
				end
			GAMEMODE:HUDMessage(nil, "obj_ts_begin", NULL, 4)
			end
			
		end
		
		if self:GetTimer() <= TS_TIME * (1 - TS_DEADLINE) and not self.CheckedSpectators then
			for k, pl in ipairs(team.GetPlayers(TEAM_BLUE)) do
				if IsValid(pl) and not pl:Alive() and pl.FirstSpawn then
					pl:SetTeam(TEAM_THUG)
				end
			end
			if #team.GetPlayers(TEAM_BLUE) < 1 then
				local winner = team.GetName(TEAM_BLUE)
				GAMEMODE:EndRound(winner)
			end
			self.CheckedSpectators = true
		end
		
				
		local ct = CurTime()
				
		self.NextTick = self.NextTick or 0
			
		if self.NextTick <= ct then

			self:DrainTimer()
			
			self.NextTick = ct + 1
		end
	end
end

if CLIENT then
function ENT:Draw()

end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

function ENT:SetTimer(time)
	self:SetDTFloat(1,time)
end

function ENT:GetTimer()
	return self:GetDTFloat(1)
end

function ENT:DrainTimer()
	self:SetTimer(math.Clamp(self:GetTimer() - 1, 0,999999))
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time) 
end