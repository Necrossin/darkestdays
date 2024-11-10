//POWERED BY IW ENGINE :v

local string = string
local file = file
local util = util
local player = player
local table = table
local ipairs = ipairs
local pairs = pairs
local tostring = tostring

util.AddNetworkString( "SendStatsToClient" )
util.AddNetworkString( "AchievementNotify" )
util.AddNetworkString( "UpdateScore" )
util.AddNetworkString( "UpdateStatsQuick" )

local meta = FindMetaTable( "Player" )
if (!meta) then return end

//small function to keep shit updated
function meta:QuickStatsUpdate()
	
	/*if not self.Stats then return end
	if not self.Stats["stats"] then return end
	
	self.Stats["stats"]["time"] = math.max(0,math.floor(self.Stats["stats"]["time"]+CurTime()-(self.StartTime or CurTime())))
	
	net.Start( "UpdateStatsQuick" )
		net.WriteTable(self.Stats["stats"])
	net.Send( self )*/

end


function meta:AddScore( key, am )
	/*if not self.Stats then return end
	if not self.Stats["stats"] then return end
	
	if #player.GetAll() < 3 then return end
	
	self.Stats["stats"][key] = self.Stats["stats"][key] + am
	
	//net.Start( "UpdateScore" )
	//	net.WriteString(tostring(key))
	//	net.WriteDouble(am)
	//net.Send( self )
	
	self:CheckScoreAchievements()*/
	
end

function meta:AddXP(am)
	
	/*if not self.Skills then return end
	if not self.Skills.Total then return end
	if not self.Skills.XP then return end
	//if self.Skills.Total >= SKILL_MAX_TOTAL then return end
		
	if DOUBLE_XP then am = am * 2 end
	
	am = self:GetLevel() >= 15 and math.Round(am * SKILL_XP_GAIN_MULTIPLIER) or am
		
	self.Skills.XP = self.Skills.XP + am
	
	if self.Skills.Total >= SKILL_MAX_TOTAL then 
		if self:GetXP() >= self:GetRequiredXP() and self:GetLevel() < LEVEL_MAX then
			self.Skills.Lvl = self.Skills.Lvl + 1
		
			self:OnLevelUpSpeech()
			
			self:ChatPrint("Congratulations! You have reached level "..self:GetLevel().."!")
		end
	else
		if self:GetXP() >= self:GetRequiredXP() then
			if self:GetLevel() < LEVEL_MAX then
				self.Skills.Lvl = self.Skills.Lvl + 1
				self:ChatPrint("Congratulations! You have reached level "..self:GetLevel().."!")
			end
		
			self.Skills.Total = self.Skills.Total + 1
			self.Skills.ToSpend = self.Skills.ToSpend + 1
			
			self:OnLevelUpSpeech()
			
			net.Start( "SendSkillsToClient" )
				net.WriteTable(self.Skills)
			net.Send( self )
			
			self:ChatPrint("You have earned an additional skill point!")
		end
	end*/
	
	
end

/*local function RequestSkills(pl,con,args)
	
	if not IsValid(pl) then return end
	if not pl.Skills then return end
	if pl:GetAvalaiblePoints() >= SKILL_MAX_TOTAL then return end
	
	net.Start( "SendSkillsToClient" )
		net.WriteTable(pl.Skills)
	net.Send( pl )
	
end
concommand.Add("update_skills",RequestSkills)*/

function meta:GetScore(key)
	if not self.Stats then return 0 end
	if not self.Stats["stats"] then return 0 end
	
	return self.Stats["stats"][key] or 0
end

function meta:CheckScoreAchievements()
	
	//kills
	if self:GetScore("kills") >= 50 then
		self:UnlockAchievement( "killsmil1" )
		if self:GetScore("kills") >= 100 then
			self:UnlockAchievement( "killsmil2" )
			if self:GetScore("kills") >= 250 then
				self:UnlockAchievement( "killsmil3" )
				if self:GetScore("kills") >= 500 then
					self:UnlockAchievement( "killsmil4" )
					if self:GetScore("kills") >= 1000 then
						self:UnlockAchievement( "killsmil5" )
						if self:GetScore("kills") >= 5000 then
							self:UnlockAchievement( "killsmil6" )
							if self:GetScore("kills") >= 10000 then
								self:UnlockAchievement( "killsmil7" )
								if self:GetScore("kills") >= 20000 then
									self:UnlockAchievement( "killsmil8" )
								end
							end
						end
					end
				end
			end
		end
	end
	//rounds
	if self:GetScore("rndwon") >= 10 then
		self:UnlockAchievement( "rndmil1" )
		if self:GetScore("rndwon") >= 30 then
			self:UnlockAchievement( "rndmil2" )
			if self:GetScore("rndwon") >= 100 then
				self:UnlockAchievement( "rndmil3" )
				if self:GetScore("rndwon") >= 250 then
					self:UnlockAchievement( "rndmil4" )
					if self:GetScore("rndwon") >= 500 then
						self:UnlockAchievement( "rndmil5" )
					end
				end
			end
		end
	end
	//koth rounds
	if self:GetScore("kothwon") >= 15 then
		self:UnlockAchievement( "kothr1" )
		if self:GetScore("kothwon") >= 30 then
			self:UnlockAchievement( "kothr2" )
			if self:GetScore("kothwon") >= 100 then
				self:UnlockAchievement( "kothr3" )
				if self:GetScore("kothwon") >= 250 then
					self:UnlockAchievement( "kothr4" )
				end
			end
		end
	end
	//htf rounds
	if self:GetScore("htfwon") >= 15 then
		self:UnlockAchievement( "htfr1" )
		if self:GetScore("htfwon") >= 30 then
			self:UnlockAchievement( "htfr2" )
			if self:GetScore("htfwon") >= 100 then
				self:UnlockAchievement( "htfr3" )
				if self:GetScore("htfwon") >= 250 then
					self:UnlockAchievement( "htfr4" )
				end
			end
		end
	end
	
end

util.AddNetworkString( "RequestAchievements" )
util.AddNetworkString( "ReceiveAchievements" )

function meta:RequestAchievements()

	if self.UpdatedAchievements then return end
	self.UpdatedAchievements = true

	GAMEMODE.PlayerAchievements[ tostring(self:SteamID()) ] = {}

	net.Start( "RequestAchievements" )
		net.WriteInt( self:EntIndex(), 32 )
	net.Send( self )

end

net.Receive( "ReceiveAchievements", function( len, target )

	local pl = Entity( net.ReadInt( 32 ) )
	local tbl = net.ReadTable()

	if pl and pl:IsValid() and pl:IsPlayer() then

		//slightly change the structure, so I dont have to call table.HasValue every time I want to check achievements o nserver

		for _, ach in pairs( tbl ) do
			if Achievements[ ach ] and GAMEMODE.PlayerAchievements[ tostring(pl:SteamID()) ] then
				GAMEMODE.PlayerAchievements[ tostring(pl:SteamID()) ][ ach ] = true
			end
		end

		//GAMEMODE.PlayerAchievements[ tostring(pl:SteamID()) ] = table.Copy( tbl )

	end

		
end)

util.AddNetworkString( "ClientUnlockAchievement" )

function meta:UnlockAchievement( key )

	//if #player.GetAll() < 6 then return end
	if not Achievements[key] then return end
	if not GAMEMODE.PlayerAchievements[ tostring(self:SteamID()) ] then return end
	//if table.HasValue( GAMEMODE.PlayerAchievements[ tostring(self:SteamID()) ], key ) then return end
	if GAMEMODE.PlayerAchievements[ tostring(self:SteamID()) ][ key ] then return end

	GAMEMODE.PlayerAchievements[ tostring(self:SteamID()) ][ key ] = true

	net.Start( "AchievementNotify" )
		net.WriteString( tostring( key ) )
	net.Send( self )

	for _,pl in ipairs( player.GetAll() ) do
		//pl:ChatPrint( "Player "..self:Name().." got the achievement: "..Achievements[key].Name.."!" )
		pl:ChatPrint( translate.ClientFormat(pl, "ach_chat_unlocked", self:Name(), translate.ClientGet(pl, Achievements[key].Name) ) )
	end

	self._AchSound = self._AchSound or 0

	if self._AchSound > CurTime() then return end

	local e = EffectData()
	e:SetOrigin( self:GetPos() )
	e:SetEntity( self )
	util.Effect( "achievement_unlock", e, true, true )

	self._AchSound = CurTime() + 0.2
	self:EmitSound( "weapons/physcannon/physcannon_charge.wav", math.random(105,120), math.random(95,110) )

	/*if #player.GetAll() < 6 then return end
	
	if not self.Stats then return end
	if not self.Stats["achievements"] then return end
	if not self.Stats["achievements"][key] then return end
	
	if self.Stats["achievements"][key] and self.Stats["achievements"][key] == true then return end
	
	self.Stats["achievements"][key] = true
	
	net.Start( "AchievementNotify" )
		net.WriteString(tostring(key))
	net.Send( self )
	
	for _,pl in ipairs(player.GetAll()) do
		pl:ChatPrint("Player "..self:Name().." got the achievement: "..Achievements[key].Name.."!")
	end	
	
	self._AchSound = self._AchSound or 0
	
	if self._AchSound > CurTime() then return end
	
	local e = EffectData()
	e:SetOrigin(self:GetPos())
	e:SetEntity(self)
	util.Effect("achievement_unlock",e,true,true)
	
	self._AchSound = CurTime() + 0.2
	self:EmitSound("weapons/physcannon/physcannon_charge.wav",math.random(105,120),math.random(95,110))*/
	
end

function meta:GetBlankStats()

	local tbl = {}
	tbl["stats"] = {}
	tbl["achievements"] = {}
	tbl["skills"] = {
		Total = SKILL_XP_START,
		ToSpend = SKILL_XP_START,
		["defense"] = 0,
		["magic"] = 0,
		["strength"] = 0,
		["agility"] = 0,
		XP = 0,
		Lvl = 0,
	}
	
	
	tbl["stats"].Name = self:Name()
	
	for key,d in pairs(RandomData) do
		tbl["stats"][key] = 0
	end
	
	for key,d in pairs(Achievements) do
		tbl["achievements"][key] = false
	end
	
	return tbl

end

function meta:WriteBlankStats()
	
	local hasfolder = file.IsDir( "darkestdays/player_stats", "DATA" )
	
	if not hasfolder then
		file.CreateDir( "darkestdays/player_stats" )
	end
	
	local path = "darkestdays/player_stats/player_"..string.Replace( string.sub(self:SteamID(), 9), ":", "-" )..".txt"
	local stats = util.TableToJSON(self:GetBlankStats())
	
	file.Write( path, stats )
	
end

util.AddNetworkString( "Client:ReadStats" )
function meta:ReadStats()
	
	net.Start( "Client:ReadStats" )
	net.Send( self )	
	
	self.Stats = {}
	
	/*local path = "darkestdays/player_stats/player_"..string.Replace( string.sub(self:SteamID(), 9), ":", "-" )..".txt"
	if not file.Exists( path, "DATA" ) then
		self:WriteBlankStats()
	end

	local filestats = util.JSONToTable(file.Read( path ))
	
	self.Stats = table.Copy(self:GetBlankStats())
	table.Merge( self.Stats, filestats )

	self.Skills = self.Stats["skills"]*/

	//net.Start( "SendStatsToClient" )
	//	net.WriteTable(self.Stats)
	//net.Send( self )	
	
	//print("--> Got stats for player "..self:Name())
	//PrintTable(self.Stats)

end

function meta:SaveStats()
	
	/*if not self.Stats then return end
	
	self.Stats["stats"]["time"] = math.max(0,math.floor(self.Stats["stats"]["time"]+CurTime()-(self.StartTime or CurTime())))
	
	self.Stats["stats"].Name = self:Name()
	
	self.Stats["skills"] = self.Skills
	
	local path = "darkestdays/player_stats/player_"..string.Replace( string.sub(self:SteamID(), 9), ":", "-" )..".txt"
	local stats = util.TableToJSON(self.Stats)
	
	file.Write( path, stats )
	
	print("--> Saved stats for player "..self:Name())*/
	
end

------------------------------------------------------------------------------------------------
local SpellToAch = {}
SpellToAch["projectile_cyclonetrap"] = {ach = "wetfl"}
SpellToAch["spell_aerodash"] = {ach = "adkill", callback = function(pl,vic) return IsValid(vic._efFrozen) end}
SpellToAch["spell_winterblast"] = {ach = "fridge", callback = function(pl,vic) return IsValid(pl._efFrozen) end}
SpellToAch["dd_fists"] = {ach = "thinkbig", callback = function(pl,vic) return vic:IsThug() end}
SpellToAch["dd_thugfists"] = {ach = "weaklings", callback = function(pl,vic) return IsValid(vic._efSlide) end}

local SpellToAchMul = {}
SpellToAchMul["spell_telekinesis"] = {ach = "carkill",am = 3,time = 3}
SpellToAchMul["projectile_scorn"] = {ach = "pingpong",am = 2,time = 8}
SpellToAchMul["dd_ak47"] = {ach = "sprandpr",am = 3,time = 12}
SpellToAchMul["dd_m3super90"] = {ach = "garbage",am = 2,time = 2}

local SpellToAchKillstreak = {}
SpellToAchKillstreak["spell_electrobolt"] = {ach = "elbkillstr", am = 3}
SpellToAchKillstreak["projectile_bloodtrap"] = {ach = "bldtrpkill", am = 2}
SpellToAchKillstreak["projectile_toxiccloud"] = {ach = "intox", am = 4}
SpellToAchKillstreak["dd_usp_silenced"] = {ach = "plstealth", am = 3}
SpellToAchKillstreak["dd_dsword"] = {ach = "ripper", am = 7}
SpellToAchKillstreak["dd_katana"] = {ach = "ripper", am = 7}
SpellToAchKillstreak["dd_zweihander"] = {ach = "ripper", am = 7}
SpellToAchKillstreak["dd_eyelander"] = {ach = "ripper", am = 7}
SpellToAchKillstreak["projectile_cursedflames"] = {ach = "nesevil", am = 5}
SpellToAchKillstreak["crossbow_bolt"] = {ach = "hunter", am = 4}
SpellToAchKillstreak["dd_wand"] = {ach = "wandkills", am = 4}
SpellToAchKillstreak["dd_usp"] = {ach = "gunslinger", am = 7}
SpellToAchKillstreak["dd_fists"] = {ach = "punch", am = 5}
SpellToAchKillstreak["dd_thugfists"] = {ach = "breaking", am = 7}

//Kill with X get Y
function CheckAchievementSimpleKills(pl,victim,spell)
	
	local inflictor = spell
	spell = spell and spell:GetClass() or "none"
	
	pl:AddScore( "kills", 1 )
	
	if inflictor.IsMelee then
		pl:AddScore( "meleekills", 1 )
	end
	
	pl:UnlockAchievement("fkill")
	
	if SpellToAch[spell] then
		if SpellToAch[spell].callback ~= nil then
			if SpellToAch[spell].callback(pl,victim) == true then
				pl:UnlockAchievement(SpellToAch[spell].ach)
			end
		else
			pl:UnlockAchievement(SpellToAch[spell].ach)
		end
	end
	
	if victim:IsCrow() then
		pl:UnlockAchievement("scrow")
	end
	
	if IsValid(pl._efSlide) then
		pl:UnlockAchievement("slippery")
	end
	
	if spell == "progectile_firebolt" and !pl:Alive() then
		pl:UnlockAchievement("hrevenge")
	end
	
	if spell == "projectile_cyclonetrap" and (IsValid(victim._efAfterburn) or IsValid(victim._efFrozen) or IsValid(victim._efElectrocuted)) then
		pl:UnlockAchievement("powerup")
	end
	
	if victim:IsGhosting() then
		pl:UnlockAchievement("xray")
	end
	
	if spell == "spell_telekinesis" and !pl:OnGround() and (pl:GetVelocity().z > 20 or pl:GetVelocity().z < -20) then
		pl:UnlockAchievement("dfabove")
	end
	
	if pl._COTNAch and pl._COTNAch > CurTime() then
		pl:UnlockAchievement("damnbirds")
	end
	
	if spell == "spell_aerodash" and !IsValid(victim._efFrozen) then
		pl:UnlockAchievement("dodgethis")
	end

	if spell == "dd_m3super90" and victim.Gibbed then
		pl:UnlockAchievement("shgib")
	end
	
	if victim.Gibbed then
		pl.GibKills = pl.GibKills or 0
		pl.GibKills = pl.GibKills + 1
		if pl.GibKills >= 4 then
			pl:UnlockAchievement("meatshower")
		end
	end
	
	if pl._efSpeedBoost then
		pl.SpeedBoostKills = pl.SpeedBoostKills or 0
		pl.SpeedBoostKills = pl.SpeedBoostKills + 1
		if pl.SpeedBoostKills >= 4 then
			pl:UnlockAchievement("bee")
		end
	end
	
	if victim:IsCarryingFlag() then
		pl.BallCarriers = pl.BallCarriers + 1
		if pl.BallCarriers >= 10 then
			pl:UnlockAchievement("ballkill")
		end
	end
	
	if inflictor and inflictor.CanSlice then
		if victim._BeingSucked and victim._BeingSucked >= CurTime() then
			pl:UnlockAchievement("sucker")
		end
	end
	
	if spell == "effect_thug" then
		pl:UnlockAchievement("stompkill")
	end
	
	if victim:IsThug() then
		local wep = victim:GetActiveWeapon()
		if IsValid(wep) and wep.IsChargeAttacking then
			if wep:IsChargeAttacking() then
				pl:UnlockAchievement("redcolor")
			end
		end
	end
	
end


//Killstreaks
function CheckAchievementKillStreaks(pl,victim,spell)
	
	pl.Killstreaks = pl.Killstreaks or {}
	
	if spell._Telekinetic and spell._Telekinetic >= CurTime() then
		spell = "spell_telekinesis"
	else
		spell = spell and spell:GetClass() or "none"
	end
	
	if SpellToAchKillstreak[spell] then
		if not pl.Killstreaks[spell] then
			pl.Killstreaks[spell] = 0
		end
		
		pl.Killstreaks[spell] = pl.Killstreaks[spell] + 1
		
		if pl.Killstreaks[spell] >= SpellToAchKillstreak[spell].am then
			pl:UnlockAchievement(SpellToAchKillstreak[spell].ach)
		end
		
	end
	
end

//Multikills with each weapon
function CheckAchievementMultiKills(pl,victim,spell)
	
	pl.MultiKills = pl.MultiKills or {}
	
	
	if spell._Telekinetic and spell._Telekinetic >= CurTime() then
		spell = "spell_telekinesis"
	else
		spell = spell and spell:GetClass() or "none"
	end
	
	if SpellToAchMul[spell] then
		if not pl.MultiKills[spell] then
			pl.MultiKills[spell] = {}
		end
		
		table.insert(pl.MultiKills[spell],{victim,CurTime()})
		
		if (#pl.MultiKills[spell] > SpellToAchMul[spell].am) then
			table.remove(pl.MultiKills[spell],1)
		end
		
		if #pl.MultiKills[spell] >= SpellToAchMul[spell].am and pl.MultiKills[spell][SpellToAchMul[spell].am][2]-pl.MultiKills[spell][1][2] <= SpellToAchMul[spell].time then
			pl:UnlockAchievement(SpellToAchMul[spell].ach)
			table.Empty(pl.MultiKills[spell])
		end		

	end
	
end


function CheckAchievementKillsGlobal(pl,victim,inflictor)
	
	CheckAchievementSimpleKills(pl,victim,inflictor)
	CheckAchievementMultiKills(pl,victim,inflictor)
	CheckAchievementKillStreaks(pl,victim,inflictor)
	
end


