AddCSLuaFile("performance/buffthefps.lua")
AddCSLuaFile("performance/nixthelag.lua")
AddCSLuaFile("performance/rewrite_entity_index.lua")
AddCSLuaFile("performance/rewrite_player_index.lua")
AddCSLuaFile("performance/rewrite_weapon_index.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("animations.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_endround.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_voice.lua")
AddCSLuaFile("cl_customize.lua")
AddCSLuaFile("cl_deathnotice.lua")
AddCSLuaFile("cl_lobby.lua")
AddCSLuaFile("obj_weapon_extend.lua")
AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("sh_options.lua")
AddCSLuaFile("sh_server_options.lua")

include("shared.lua")
include("sv_maps.lua")
include("sv_pickups.lua")
include("anti_map_exploit.lua")
include("obj_weapon_extend.lua")
include("sv_obj_player_extend.lua")
include("sv_playerstats.lua")


include("boneanimlib_v2/sh_boneanimlib.lua")
include("boneanimlib_v2/boneanimlib.lua")

hook.Remove("PlayerTick","TickWidgets")

local M_Player = FindMetaTable("Player")

local P_Team = M_Player.Team
local P_Alive = M_Player.Alive
local player_GetAll = player.GetAll

//Content

function GM:AddResources()

	local a,b = file.Find("materials/darkestdays/hud/*.png" , "GAME")

	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/darkestdays/hud/"..string.lower(filename))
	end
	
	local a,b = file.Find("materials/darkestdays/icons/*.png" , "GAME")

	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/darkestdays/icons/"..string.lower(filename))
	end

	local a,b = file.Find("materials/darkestdays/blood/*.png" , "GAME")

	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/darkestdays/blood/"..string.lower(filename))
	end

	//local a,b = file.Find("materials/effects/*.*" , "GAME") //gamemodes/darkestdays/content/
	//for _, filename in pairs(a) do
		//resource.AddFile("materials/effects/"..string.lower(filename))
	//end

	resource.AddSingleFile("materials/effects/cig_smoke.vmt")
	resource.AddSingleFile("materials/effects/cig_smoke.vtf")
	resource.AddSingleFile("materials/effects/conc_normal.vtf")
	resource.AddSingleFile("materials/effects/conc_warp.vmt")
	resource.AddSingleFile("materials/effects/electric1.vmt")
	resource.AddSingleFile("materials/effects/electric1.vtf")
	resource.AddSingleFile("materials/effects/glowdrip.vmt")
	resource.AddSingleFile("materials/effects/glowdrip.vtf")
	resource.AddSingleFile("materials/effects/glowdrip_add.vmt")
	resource.AddSingleFile("materials/effects/healsign.vmt")
	resource.AddSingleFile("materials/effects/healsign.vtf")
	resource.AddSingleFile("materials/effects/largesmoke.vmt")
	resource.AddSingleFile("materials/effects/largesmoke.vtf")
	resource.AddSingleFile("materials/effects/largesmoke_add.vmt")
	resource.AddSingleFile("materials/effects/softglow.vmt")
	resource.AddSingleFile("materials/effects/softglow.vtf")

	local a,b = file.Find("materials/particle/flamethrowerfire/*.*" , "GAME") //gamemodes/darkestdays/content/
	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/particle/flamethrowerfire/"..string.lower(filename))
	end

	local a,b = file.Find("materials/particle/fluidExplosions/*.*" , "GAME") //gamemodes/darkestdays/content/
	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/particle/fluidExplosions/"..string.lower(filename))
	end

	//local a,b = file.Find("particles/*.*" , "GAME") //gamemodes/darkestdays/content/
	//for _, filename in pairs(a) do
		resource.AddSingleFile("particles/darkestdays_v10.pcf")
	//end

	//local a,b = file.Find("materials/sprites/*.*" , "GAME") //gamemodes/darkestdays/content/
	//for _, filename in pairs(a) do
		//resource.AddFile("materials/sprites/"..string.lower(filename))
	//end
	resource.AddSingleFile("materials/sprites/smoke_trail.vtf")
	resource.AddSingleFile("materials/sprites/smoke_trail.vmt")

	local a,b = file.Find("materials/models/weapons/v_models/dsword/*.*" , "GAME") //gamemodes/darkestdays/content/
	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/models/weapons/v_models/dsword/"..string.lower(filename))
	end

	//local a,b = file.Find("resource/fonts/*.*" , "GAME") //gamemodes/darkestdays/content/
	//for _, filename in pairs(a) do
	resource.AddSingleFile("resource/fonts/bison.ttf")
	resource.AddSingleFile("cache/workshop/resource/fonts/bison.ttf") //just to see if it will fix broken fonts if hosted on dedicated server
	//end

	//local a,b = file.Find("models/weapons/*.*" , "GAME") //gamemodes/darkestdays/content/
	//for _, filename in pairs(a) do
	//	resource.AddFile("models/weapons/"..string.lower(filename))
	//end

	resource.AddSingleFile("models/weapons/c_dsword2.mdl")
	resource.AddSingleFile("models/weapons/c_dsword2.vvd")
	resource.AddSingleFile("models/weapons/c_dsword2.dx80.vtx")
	resource.AddSingleFile("models/weapons/c_dsword2.dx90.vtx")
	resource.AddSingleFile("models/weapons/c_dsword2.sw.vtx")
	resource.AddSingleFile("models/weapons/w_dsword.mdl")
	resource.AddSingleFile("models/weapons/w_dsword.vvd")
	resource.AddSingleFile("models/weapons/w_dsword.dx80.vtx")
	resource.AddSingleFile("models/weapons/w_dsword.dx90.vtx")
	resource.AddSingleFile("models/weapons/w_dsword.sw.vtx")


	local a,b = file.Find("sound/weapons/dsword/*.*" , "GAME") //gamemodes/darkestdays/content/
	for _, filename in pairs(a) do
		resource.AddSingleFile("sound/weapons/dsword/"..string.lower(filename))
	end

	local a,b = file.Find("sound/physics/gore/*.*" , "GAME") //gamemodes/darkestdays/content/
	for _, filename in pairs(a) do
		resource.AddSingleFile("sound/physics/gore/"..string.lower(filename))
	end
end

GM.Gametype = CreateConVar("dd_gametype", "koth", FCVAR_ARCHIVE + FCVAR_NOTIFY, ""):GetString()
cvars.AddChangeCallback("dd_gametype", function(cvar, oldvalue, newvalue)
	GAMEMODE.Gametype = newvalue
end)

GM.SavedRestarts = CreateConVar("dd_saverestarts", -1, FCVAR_ARCHIVE, ""):GetInt()
cvars.AddChangeCallback("dd_saverestarts", function(cvar, oldvalue, newvalue)
	GAMEMODE.SavedRestarts = tonumber( newvalue )
end)


util.AddNetworkString( "ShowFirstHelp" )

GM.ModelBlacklist = {
	Model( "models/player/skeleton.mdl" ),
	Model( "models/player/charple.mdl" ),
	Model( "models/player/zombie_soldier.mdl" ),
	Model( "models/player/zombie_fast.mdl" ),
	Model( "models/player/zombie_classic.mdl" ),
}

//Main stuff

ROUND_NUMBER = 1

ROUNDSTATE_IDLE = 1
ROUNDSTATE_PLAY = 2
ROUNDSTATE_END = 3

ENDROUND = false
ROUNDWINNER = 0

local team = team
local table = table
local player = player
local umsg = umsg
local math = math
local timer = timer
local pairs = pairs
local tostring = tostring
local ents = ents

GM.DeadPeople = {}
GM.PlayerAchievements = {}

function GM:InitializeVars()

	ROUNDTIME = ROUNDLENGTH+CurTime()
	CHANGELEVEL = 25*60 + CurTime()
	self.GameState = ROUNDSTATE_IDLE

	ENDROUND = false
	ROUNDWINNER = 0
	
	team.SetScore(TEAM_RED,0)
	team.SetScore(TEAM_BLUE,0)
	
	VotePointTable = {}
	for i = 1,( MAX_VOTEMAPS + 1 ) do
		VotePointTable[i] = 0
	end
	
	GameTypeVotePointTable = {}
	for k,v in pairs(GAMEMODE.Gametypes) do
		GameTypeVotePointTable[k] = 0
	end
		
		
	//self:SetNight( true )
	self:SetNight( self:GetGametype() == "ts" and TS_NIGHTMODE )
	
end

function GM:RestartRound( change_map )

	
	ROUND_NUMBER = ROUND_NUMBER+1
	
	
	if change_map then
		game.ConsoleCommand( "dd_saverestarts "..tostring(ROUND_NUMBER).."\n" )
		timer.Simple(1,function() game.ConsoleCommand("changelevel "..game.GetMap().."\n") end)
		return
	end
	
	self.DeadPeople = {}
	
	game.CleanUpMap()
	self:InitializeVars()
	self:InitPostEntity()
	
	//net.Start( "CheckNight" )
	//	net.WriteBool( self:IsNight() )
	//net.Broadcast()
	
	for k, v in ipairs(player_GetAll()) do
		v:StopAllLuaAnimations()
		self:PlayerInitialSpawn(v)
		v:Spawn()
	end
	
end

//Unused
function GM:RoundTimeLeft()
	return( math.Clamp( ROUNDTIME - CurTime() , 0, ROUNDLENGTH) )
end

function GM:SynchronizeTime( pl )
	umsg.Start("SendTime", pl)
		umsg.Short(ROUNDLENGTH)
		umsg.Long(ROUNDTIME)
	umsg.End()	
end

function GM:Initialize( )
	RunConsoleCommand( "sv_alltalk", "1" )
	RunConsoleCommand( "sv_sticktoground", "0" ) //we dont need turtles
	self:InitializeVars()
	self:AddResources()
	self.Gametype = GetConVarString("dd_gametype")
end

local function ProceedLobbyTeam(ply,commandName,args)
	
	if not ply.FirstSpawn then return end
	if not args[1] then return end
	
	local tm = tonumber(args[1])
	
	if GAMEMODE:GetGametype() == "ffa" then
		ply:SetTeam(TEAM_FFA)
	elseif GAMEMODE:GetGametype() == "ts" then
		if GAMEMODE.DeadPeople[tostring(ply:SteamID())] or IsValid(GetHillEntity()) and GetHillEntity():GetTimer() <= TS_TIME * (1 - TS_DEADLINE) then
			ply:SetTeam(TEAM_THUG)
		else
			ply:SetTeam(TEAM_BLUE)
		end
	else
		if ply:CanJoinTeam(tm) then
			ply:SetTeam(tm)
		end
	end

end
concommand.Add("lobby_teamselect",ProceedLobbyTeam) 

local function ProceedLobbySpawn(ply,commandName,args)
	
	if not ply.FirstSpawn then return end
	if P_Team( ply ) == TEAM_SPECTATOR then return end
	
	if GAMEMODE:GetGametype() == "ts" then
		if GAMEMODE.DeadPeople[tostring(ply:SteamID())] or IsValid(GetHillEntity()) and GetHillEntity():GetTimer() <= TS_TIME * (1 - TS_DEADLINE) then
			ply:SetTeam(TEAM_THUG)
		else
			ply:SetTeam(TEAM_BLUE)
		end
	end
	
	ActualSpawn(ply,"actual_spawn")

end
concommand.Add("lobby_spawn",ProceedLobbySpawn) 

local function GetPlayerByID( id )
	
	if not id then return end
	
	local target = NULL
	
	for _, guy in pairs( player_GetAll() ) do
		if IsValid( guy ) and Entity( tonumber( id ) ) == guy then
			target = guy
			break
		end
	end 
	
	return target
	
end

//give swep construction kit so its easier to make new stuff in-game
local function GiveSCK(p,c,a)
	if !p:IsSuperAdmin() then return end
	
	p:Give("swep_construction_kit")	
end
concommand.Add("admin_givesck",GiveSCK)

local function AdminSlay(p,c,a)
	if !ADMIN_MENU then return end
	if !p:IsAdmin() then return end
	if not a then return end
	
	local id = a[1]
	if not id then return end
	
	local target = player.GetByID( tonumber( id ) )//GetPlayerByID( id )
	
	if target and IsValid(target) then
		
		target:TakeDamage( 9999, nil, nil)
		target:ChatPrint( "You have been slayed by admin "..p:Name() )
		
	end
	
end
concommand.Add("admin_slay",AdminSlay)

local function AdminKick(p,c,a)
	if !ADMIN_MENU then return end
	if !p:IsAdmin() then return end
	if not a then return end
	
	local id = a[1]
	if not id then return end
	
	local target = player.GetByID( tonumber( id ) )//GetPlayerByID( id )
	
	if target and IsValid(target) then
		target:Kick( "Kicked by "..p:Name().." (Reason: "..(a[2] and tostring(a[2]) or "No reason given.")..")." )
	end
	
end
concommand.Add("admin_kick",AdminKick)

local function AdminMute(p,c,a)
	if !ADMIN_MENU then return end
	if !p:IsAdmin() then return end
	if not a then return end
	
	local id = a[1]
	if not id then return end
	
	local target = player.GetByID( tonumber( id ) )//GetPlayerByID( id )
	
	if target and IsValid(target) then
		target.Muted = target.Muted or false
		target.Muted = !target.Muted
		target:ChatPrint( "You have been muted/unmuted by admin "..p:Name() )
	end
	
end
concommand.Add("admin_mute",AdminMute)

local function AdminGag(p,c,a)
	if !ADMIN_MENU then return end
	if !p:IsAdmin() then return end
	if not a then return end
	
	local id = a[1]
	if not id then return end
	
	local target = player.GetByID( tonumber( id ) )//GetPlayerByID( id )
	
	if target and IsValid(target) then
		target.Gagged = target.Gagged or false
		target.Gagged = !target.Gagged
		target:ChatPrint( "You have been gagged/ungagged by admin "..p:Name() )
	end
	
end
concommand.Add("admin_gag",AdminGag)

local function AdminTest(p,c,a)
	if !ADMIN_MENU then return end
	if !p:IsAdmin() then return end
	if not a then return end
	
	local id = a[1]
	if not id then return end
	
	local target = player.GetByID( tonumber( id ) )
	
	if target and IsValid(target) then
		if target.NextSpawnTime <= CurTime() then
			target.NextSpawnTime = CurTime() + 9999999
		else
			target.NextSpawnTime = 0
		end
	end
	
end
concommand.Add("admin_delayrespawn",AdminTest)

hook.Add( "PlayerSay", "GaggedPlayers", function(ply, text, team_only)
	if ply.Gagged then return "" end
end)

function ApplyLoadout(pl, com, args)

	if not ValidEntity(pl) then return end
	if not args then return end
	if #args <= 0 then return end
	
	pl.Loadout = {}
	pl.SpellsToGive = {}
	pl.Perks = nil
	pl.PerksToGive = {}
	
	local wepcount = 0
	local spellcount = 0
	local got_secondary = false
	
	for _, item in pairs(args) do
		if pl:HasUnlocked( item ) or pl:SteamID() == "BOT" then
			if Weapons[item] and wepcount < 2 then
				
				if Weapons[item].Secondary or Weapons[item].Melee then
					if !got_secondary then
						wepcount = wepcount + 1
						table.insert(pl.Loadout,item)
						got_secondary = true
					end
				else
					wepcount = wepcount + 1
					table.insert(pl.Loadout,item)
				end
			
				
			end
			if Spells[item] and spellcount < 2 then
				spellcount = spellcount + 1
				table.insert(pl.SpellsToGive,item)
			end
			if Perks[item] then
				table.insert(pl.PerksToGive,item)
			end
		end
	end	
end
concommand.Add("_applyloadout",ApplyLoadout)

//in that order: strength, magic, gun stuff
//it would be silly not to check clients if their points are actually legit
function ApplySkills(pl, com, args)

	if not IsValid(pl) then return end
	if not args then return end
	if #args <= 0 then return end
	
	for _,skill in pairs(Abilities) do
		if skill.OnReset then
			skill.OnReset(pl)
		end
	end
	
	local tree_points_cap = SKILL_MAX_PER_TREE
	local total_points_cap = 20
	
	local cur_used_points = 0
	
	local str_points = args[1] and tonumber(args[1]) or 0
	
	if pl.Skills["strength"] and str_points then
		pl.Skills["strength"] = math.Clamp( str_points, 0, tree_points_cap )
		cur_used_points = cur_used_points + pl.Skills["strength"]
	end
	
	local mgc_points = args[2] and tonumber(args[2]) or 0
	
	if pl.Skills["magic"] and mgc_points then
		pl.Skills["magic"] = math.Clamp( mgc_points, 0, tree_points_cap )
		cur_used_points = cur_used_points + pl.Skills["magic"]
	end
	
	local gun_points = args[3] and tonumber(args[3]) or 0
	
	if pl.Skills["agility"] and gun_points then
		pl.Skills["agility"] = math.Clamp( gun_points, 0, tree_points_cap )
		cur_used_points = cur_used_points + pl.Skills["agility"]
	end
	
	if cur_used_points > total_points_cap then
		pl.Skills["strength"] = 0
		pl.Skills["magic"] = 0
		pl.Skills["agility"] = 0
		pl.Skills.ToSpend = 20
		pl.Skills.Total = 20
	else	
		pl.Skills.ToSpend = math.Clamp( 20 - cur_used_points, 0, 20 )
		pl.Skills.Total = 20
	end
		
end
concommand.Add("_applyskills",ApplySkills)

function ApplyEquipment(pl, com, args)

	if not ValidEntity(pl) then return end
	if not args then return end
	if not ENABLE_OUTFITS then return end
	if #args <= 0 then 
	
	pl.Suit = {}
	pl:SpawnSuit(pl.Suit)
	
	return end
	
	pl.Suit = {}
	
	local gothat = false
	local count = 0	
	for _, item in pairs(args) do
		--if pl:HasUnlocked( item ) then
			if Equipment[item] and Equipment[item].slot and Equipment[item].slot == "hat" and not gothat then
				table.insert(pl.Suit,item)
				gothat = true
			end
			if Equipment[item] and Equipment[item].slot and Equipment[item].slot == "misc" then
				count = count + 1
				table.insert(pl.Suit,item)
				if count >=3 then
					break
				end
			end
		--end
	end	
	pl:SpawnSuit(pl.Suit)
	
end
concommand.Add("_applyequipment",ApplyEquipment)

function ActualSpawn(ply,commandName,args)
	if not ply.FirstSpawn then return end
	
	ply.FirstSpawn = false

	if ( ply:SteamID() == "BOT" ) then
		if GAMEMODE:GetGametype() == "ffa" then
			ply:SetTeam(TEAM_FFA)
		elseif GAMEMODE:GetGametype() == "ts" then
			if GAMEMODE.DeadPeople[tostring(ply:SteamID())] or IsValid(GetHillEntity()) and GetHillEntity():GetTimer() <= TS_TIME * (1 - TS_DEADLINE) then
				ply:SetTeam(TEAM_THUG)
			else
				ply:SetTeam(TEAM_BLUE)
			end
		else
			ply:SetTeam(ply:CanJoinTeam(TEAM_RED) and TEAM_RED or TEAM_BLUE)
		end
	end
	
	ply:UnLock()
	ply:Spawn()
	
	if not ENDROUND then
	
	//net.Start("ShowFirstHelp")
	//net.Send(ply)
	
	end

end
concommand.Add("actual_spawn",ActualSpawn) 

function SwitchSpells(pl,cmd,args)
	if !P_Alive( pl ) then return end
	
	pl:SwitchSpell()
	
end
concommand.Add("spell_switch",SwitchSpells) 

THUG_MODE = false
function thugmode(pl,cmd,args)
	if !pl:IsAdmin() then return end
	
	THUG_MODE = not THUG_MODE
	
	if THUG_MODE then
		pl:ChatPrint("Thuggin!")
	else
		pl:ChatPrint("Not so thuggin!")
	end
end
concommand.Add("thuggin",thugmode)

//for events and shit
DOUBLE_XP = util.tobool(CreateConVar("dd_doublexp", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable or disable double experience gain."):GetInt())
cvars.AddChangeCallback("dd_doublexp", function(cvar, oldvalue, newvalue)
	DOUBLE_XP = util.tobool( newvalue )
end)

/*function doublexp(pl,cmd,args)
	if !pl:IsAdmin() then return end
	
	local var = args[1]
	if not var then return end
	
	game.ConsoleCommand("dd_doublexp "..var.."\n");
	
	if DOUBLE_XP then
		pl:ChatPrint("Double xp off.")
	else
		pl:ChatPrint("Double xp on")
	end
end
concommand.Add("admin_doublexp",doublexp)*/


function GM:ShowHelp( pl ) 
	if ENDROUND then return end
	pl:SendLua("HelpMenu()")
end

function GM:ShowTeam( pl ) 
	if ENDROUND then return end
	if !ENABLE_OUTFITS then return end
	pl:SendLua("CustomizationMenu()")
end

function GM:ShowSpare1( pl ) 
	if ENDROUND then return end
	//pl:QuickStatsUpdate()
	pl:SendLua("AchievementsMenu()")
end

function GM:ShowSpare2( pl ) 
	if ENDROUND then return end
	pl:SendLua("OptionsMenu()")
end

util.AddNetworkString( "RefreshPoints" )
util.AddNetworkString( "Client:ShowLobby" )

function GM:PlayerInitialSpawn( pl )
	
	pl:SendLua("GAMEMODE.Gametype = \""..(tostring(self.Gametype) or "koth").."\"")
	
	net.Start( "CheckNight" )
		net.WriteBool( self:IsNight() )
	net.Send( pl )
	
	pl.Stats = {}
	
	pl:ReadStats()
	
	pl:RequestAchievements()
	
	pl:SetupSkills()
	
	pl.FirstSpawn = true
	
	pl:SetTeam(TEAM_SPECTATOR)
	
	pl:SetFrags(0)
	pl:SetDeaths(0)
	
	pl.SpawnProtection = 0
	pl.NextSpawnTime = 0
	
	pl.StartTime = nil
	
	//PrintTable(pl.Skills)
	
	pl.Loadout = {}
	pl.SpellsToGive = {}
	pl.Perks = nil
	pl.Suit = {}

	if pl:SteamID() == "BOT" then
		//pl.Suit = {"rlegs","rustarmor","roboarm"}
		//pl:SpawnSuit(pl.Suit)
	end
	
	pl.BulletsBlocked = 0
	pl.BallCarriers = 0
	pl.Healed = 0
	pl.UsedOnlyMelee = true
	
	pl.Voted = nil//false
	pl.VotedGameType = nil//false
	
	//self:SynchronizeTime(pl)	
	
end

function GM:PlayerSpawn( pl )

	pl:StripWeapons()
	pl:ShouldDropWeapon( false )
	
	pl:SprintEnable()
	
	if (pl.FirstSpawn and not ENROUND) then
	
		if ( pl:SteamID() == "BOT" ) then
			ActualSpawn(pl,"actual_spawn")
			return
		end
		
		pl:KillSilent() 
		pl:Lock()				
		
		if ENDROUND then 
			pl:Lock()
			self:SendVotemaps ( pl )
			timer.Simple(0.2, function()
				if IsValid(pl) then
					//pl:SendLua("DrawEndround("..ROUNDTIME..")")
					net.Start( "CallDrawEndRound" )
						net.WriteInt( ROUNDTIME, 32 )
					net.Send( pl ) 
				end
			end)
		else
			--pl:SendLua("DrawLobby()")
			net.Start( "Client:ShowLobby" )
			net.Send( pl )
		end
		
	else				
		-- Normal spawning
		pl:UnSpectate()
		
		--net.Start("RefreshPoints")
		--	net.WriteDouble(CONQUEST_CAPTURE_TIME)
		--net.Send(pl)
				
		if ENDROUND then 
			pl:Lock()
			self:SendVotemaps ( pl )
			timer.Simple(0.2, function()
				//pl:SendLua("DrawEndround("..ROUNDTIME..")")
				net.Start( "CallDrawEndRound" )
					net.WriteInt( ROUNDTIME, 32 )
				net.Send( pl ) 
			end)
		end
		
		self.GameState = ROUNDSTATE_PLAY

		
		pl:SetupDefaultStats()
		pl:SetupSkillStats()
		

		//self:SynchronizeTime(pl)
		
		local desiredname = pl:GetInfo("cl_playermodel")
		local modelname = player_manager.TranslatePlayerModel(#desiredname == 0 and "models/player/kleiner.mdl" or desiredname)
		local lowermodelname = string.lower(modelname)
		
		--if lowermodelname == "models/player/zombie_classic.mdl" or lowermodelname == "models/player/skeleton.mdl" then
		if table.HasValue( self.ModelBlacklist, lowermodelname ) then
			lowermodelname = "models/player/kleiner.mdl"
		end
		
		pl:SetModel(lowermodelname)
		
		if pl:SteamID() == "BOT" then
			pl:SetModel( self.BotPlayerModels[ math.random( #self.BotPlayerModels ) ] )
		end
		
		local oldhands = pl:GetHands()
		if IsValid( oldhands ) then
			oldhands:Remove()
		end

		local hands = ents.Create( "dd_hands" )
		if IsValid( hands ) then
			hands:DoSetup( pl )
			hands:Spawn()
		end	

		pl:SetDTString(0,pl:GetModel())
		
		if VoiceSetTranslate[ string.lower( pl:GetModel() ) ] then
			pl:SetVoiceSet( VoiceSetTranslate[ string.lower( pl:GetModel() ) ] )
		else
			pl:SetVoiceSet( "male" )
		end
		
		self:PlayerLoadout(pl)
		
		pl.LastHitBox = nil
		pl.LastHitGr = nil
		pl.LastHitPos = nil
		pl.LastHitGrNormal = nil
		//self:PlayerSetModel(pl)
		
		if not pl:IsThug() then
			pl:SetEffect("wallrun")
			//pl:SetEffect("grenade")
		end
		
		if pl:GetModelScale() ~= 1 then
			pl:SetModelScale(1,0)
		end
		
		pl:SetDTBool(3,false)

		--pl:SetBloodColor(-1)

		local speed = pl._DefaultSpeed
		local jump = pl._DefaultJumpPower
		
		pl:SetCustomCollisionCheck( true )
		
		pl:SetJumpPower(jump)

		pl:SetTotalSpeed(speed,speed+pl._DefaultRunSpeedBonus)

		local otherteam = TEAM_RED
		
		if P_Team( pl ) == otherteam then
			otherteam = TEAM_BLUE
		end
		
		local phys = pl:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(pl:IsThug() and 280 or 80)
		end
		
		local health = pl._DefaultHealth//100
		
		
		if self:GetGametype() ~= "ffa" then
			pl.SpawnProtection = CurTime() + SPAWN_PROTECTION
			local e = EffectData()
				e:SetEntity( pl )
				e:SetRadius( SPAWN_PROTECTION )
			util.Effect( "spawn_protection", e )
		end
		
		pl:SetHealth( health )
		pl:SetMaxHealth( health )
		pl:SetMaxHealthClient( health )
		
		pl:SetRandomFace()
		
		pl:SetTeamColor()
		
		pl.Killstreaks = {}
		pl.MultiKills = {}
		
		pl.LastAttacker = nil
		
		pl.DeathSequence = nil
		
		pl.StartTime = pl.StartTime or CurTime()
		pl.Gibbed = nil
		
		pl.GibKills = 0
		pl.SpeedBoostKills = 0
		
		
		timer.Simple(0.2,function()
			if IsValid(pl) then
				pl:SetTeamColor()
			end
		end)
	end
end

function GM:PlayerLoadout( pl )
	
	pl:RemoveAllAmmo()
	
	local ToGive = {}
	
	if pl.Loadout then
		if #pl.Loadout == 2 then
			ToGive = table.Copy(pl.Loadout)
		else
			ToGive = {"dd_mp5","dd_katana"}
			//ToGive = {"dd_m4","dd_crowbar"}
			pl.Loadout = table.Copy(ToGive)
		end
	else
		ToGive = {"dd_mp5","dd_katana"}
		//ToGive = {"dd_m4","dd_crowbar"}
		pl.Loadout = table.Copy(ToGive)
	end
		
	for k,v in pairs ( ToGive ) do
		if tostring( v ) == "empty" then continue end
		pl:Give ( tostring ( v ) )
	end
	
	for _,w in pairs(Weapons) do
		if w.OnReset then
			w.OnReset(pl)
		end
	end
	
	for _,w in pairs(pl:GetWeapons()) do
		if Weapons[w:GetClass()] and Weapons[w:GetClass()].OnSet then
			Weapons[w:GetClass()].OnSet(pl)
		end
	end
	
	local ToGive = {}
	
	if pl.SpellsToGive then
		if #pl.SpellsToGive == 2 then
			ToGive = table.Copy(pl.SpellsToGive)
		else
			ToGive = {"electrobolt","winterblast"}
			pl.SpellsToGive = table.Copy(ToGive)
		end
	else
		ToGive = {"firebolt","electrobolt"}
		pl.SpellsToGive = table.Copy(ToGive)
	end
	
	

	
	if THUG_MODE or self:GetGametype() == "ts" and P_Team( pl ) == TEAM_THUG then
		pl:SetPerk("thug")
	else
		if pl.PerksToGive then
			for k,v in pairs(pl.PerksToGive) do
				pl:SetPerk(v)
			end
		else
			pl:SetPerk( "blank" )
		end
	end
	
	//if pl:IsBot() then pl:SetPerk("thug") end
	
	if Builds[pl:GetInfo("_dd_selectedbuild")] then
		Builds[pl:GetInfo("_dd_selectedbuild")].OnSet(pl)
	end
	
	pl:SetupSpells(ToGive)
	
	if not pl:IsThug() then
		pl:CheckAbilities()
	end
	
	
	//pl:RestoreAmmo()
	
end

util.AddNetworkString( "CheckNight" )

function GM:SetNight(bl)

	self.Night = bl
		
	if bl then
		local skypaints = ents.FindByClass("env_skypaint")
		
		local env_skypaint
		if #skypaints > 0 then
			env_skypaint = skypaints[1]
		else
			env_skypaint = ents.Create("env_skypaint")
			env_skypaint:Spawn()
			env_skypaint:Activate()
		end

		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
		game.ConsoleCommand("sv_skyname painted\n");
		
		timer.Simple(1,function() engine.LightStyle(0,"a") end)
	else
		
		if GetConVar( "sv_skyname" ):GetString() == "painted" then
			//game.ConsoleCommand("sv_skyname "..GetConVar( "sv_skyname" ):GetDefault() .."\n");
			game.ConsoleCommand("sv_skyname \n");
		end
		//timer.Simple(1,function() engine.LightStyle(0,"m") end)
	end
	
end

function GM:IsNight()
	return self.Night or false
end

function GM:CreateFlashLight()
	local ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetLocalPos(Vector(16000, 16000, 16000))
		ent:SetKeyValue("enableshadows", 0)
		ent:SetKeyValue("farz", 2048)
		ent:SetKeyValue("nearz", 8)
		ent:SetKeyValue("lightfov", 90)
		ent:SetKeyValue("lightcolor", "255 55 55 255")
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")

		game.GetWorld():SetDTEntity(3,ent)
	end
	
end

function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	
	if self:GetGametype() == "ts" and P_Team( ply ) == TEAM_THUG then
		return false
	end

	return true
end

function GM:PlayerDisconnected( pl )
	//pl:SaveStats()
	
	if self.Gametype == "ts" and IsValid(GetHillEntity()) then
		timer.Simple(1, function() 
			
			if #team.GetPlayers(TEAM_BLUE) < 1 then
				local winner = team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
			
		end)
	end
	
end

/*---------------------------------------------------------
   Name: gamemode:Think( )
   Desc: Called every frame
---------------------------------------------------------*/

function GM:Think( )
	
	local ct = CurTime()
	
	if (self.GameState == ROUNDSTATE_PLAY and not ENDROUND) then
		self:CheckGameGoal()
	end
	
	if not ENDROUND then
		if #player_GetAll() <= 0 then
			if CHANGELEVEL and CHANGELEVEL <= ct then
				self:CallEndRound()
				print"--> No players! Changing map!"
			end
		end
	end
	
	
	self.NextManaRegen = self.NextManaRegen or 0
	
		for _,pl in ipairs(player_GetAll()) do
			if pl:GetMana() < pl:GetMaxMana() then
				pl._NextManaRegen = pl._NextManaRegen or 0
				if pl._NextManaRegen < ct then
					if pl._SkillQuickRegen then
						pl._NextManaRegen = ct + (0.15 - pl._DefaultMagicRegenBonus) //0.18
					else
						pl._NextManaRegen = ct + (0.3 - pl._DefaultMagicRegenBonus) //0.55
					end
					pl:SetMana(pl:GetMana()+1)
				end
			end
			if pl:GetPerk("hpregen") and not pl:IsCarryingFlag() then//pl:GetPerk("hpregen")
				pl._NextHPRegen = pl._NextHPRegen or 0
				local delay = pl:OnGround() and not pl:KeyDown(IN_FORWARD) and not pl:KeyDown(IN_BACK) and not pl:KeyDown(IN_MOVERIGHT) and not pl:KeyDown(IN_MOVELEFT) and 0.52 or 1
				if pl._NextHPRegen < ct then
					pl._NextHPRegen = ct + delay
					pl:RefillHealth(1)
				end
			end
		end
	

end

function GM:CheckGameGoal()
	
	if self.Gametype == "koth" then
		if IsValid(GetHillEntity()) then
			local hill = GetHillEntity()
			if hill.GetTeamTimer and hill.TeamToHill and hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)) <= 0 or hill:GetTeamTimer(hill:TeamToHill(TEAM_BLUE)) <= 0 then
				local winner = hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)) <= 0 and team.GetName(TEAM_RED) or team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
		end
	elseif self.Gametype == "htf" then
		if IsValid(GetHillEntity()) then
			local hill = GetHillEntity()
			if hill.GetTeamTimer and hill.TeamToHill and hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)) <= 0 or hill:GetTeamTimer(hill:TeamToHill(TEAM_BLUE)) <= 0 then
				local winner = hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)) <= 0 and team.GetName(TEAM_RED) or team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
		end
	elseif self.Gametype == "conquest" and IsValid(GetHillEntity()) then
		local ent = GetHillEntity():GetDTEntity(0)
		if ent and IsValid(ent) then
			local red,blue = ent:GetDTInt(1),ent:GetDTInt(2)
			if red and blue and red <= 0 or blue <= 0 then
				local winner = blue <= 0 and team.GetName(TEAM_RED) or team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
		end
	elseif self.Gametype == "assault" and IsValid(GetHillEntity()) then
		if IsValid(GetHillEntity()) then
			local hill = GetHillEntity()
			local winner = ""
			if hill.GetTimer and hill:GetTimer() <= 0 and hill.GetHealth and hill:GetHealth() > 0 then
				winner = team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
			if hill.GetTimer and hill:GetTimer() > 0 and hill.GetHealth and hill:GetHealth() <= 0 then
				winner = team.GetName(TEAM_RED)
				self:EndRound(winner)
			end
		end
	elseif self.Gametype == "tdm" and IsValid(GetHillEntity()) then
		local hill = GetHillEntity()
		if hill.GetTimer and hill:GetTimer() <= 0 or team.GetScore(TEAM_RED) >= TDM_WIN_SCORE or team.GetScore(TEAM_BLUE) >= TDM_WIN_SCORE then
			local winner = team.GetScore(TEAM_RED) >= TDM_WIN_SCORE and team.GetName(TEAM_RED) or team.GetName(TEAM_BLUE)
			self:EndRound(winner)
		end
	elseif self.Gametype == "ts" and IsValid(GetHillEntity()) then
		if GetHillEntity().GetTimer and GetHillEntity():GetTimer() <= 0 then
			if #team.GetPlayers(TEAM_BLUE) > 0 then
				local winner = team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
		end
	elseif self.Gametype == "ffa" and IsValid(GetHillEntity()) then
		local hill = GetHillEntity()
		local winner = nil
		if hill.GetTimer and hill:GetTimer() <= 0 then
			local max = 0
			for k,v in ipairs(team.GetPlayers(TEAM_FFA)) do
				if v:Frags() >= max then
					if v:Frags() == max then
						if v:Deaths() < (winner and winner.Deaths and winner:Deaths() or 10000) then
							max = v:Frags()
							winner = v
						end
					else
						max = v:Frags()
						winner = v
					end
				end
			end
			self:EndRound(winner)
		end
	else
		//Prevent server from getting stuck by my mistake
		//if self.Gametype ~= "tdm" and !IsValid(GetHillEntity()) then
			//RunConsoleCommand( "dd_gametype", "tdm" )
			//self.Gametype = "tdm"
		//end
		//Nothing at all, nothing at all, NOTHING AT ALL
	end

	
end

function GM:CallEndRound()
	local winner = team.GetScore(TEAM_RED) > team.GetScore(TEAM_BLUE) and team.GetName(TEAM_RED) or team.GetName(TEAM_BLUE)
	self:EndRound(winner)
end

function GM:DrainTickets(tm)
	if IsValid(GetHillEntity()) and IsValid(GetHillEntity():GetDTEntity(0)) then
		GetHillEntity():GetDTEntity(0):SetDTInt(tm,math.Clamp(GetHillEntity():GetDTEntity(0):GetDTInt(tm) - 1,0,999999))
	end
end

util.AddNetworkString( "RecVotemaps" )

function GM:SendVotemaps ( to )
	local Maps = self:GetVoteMaps()
	
	if (#Maps < MAX_VOTEMAPS) then return end
	
	net.Start("RecVotemaps")
		if self:GetGametype() == "ffa" then
			net.WriteEntity(ROUNDWINNER)
		else
			net.WriteString(ROUNDWINNER)
		end
		net.WriteBit(self.CanRestart)
		for i = 1,MAX_VOTEMAPS do 
			net.WriteString ( Maps[i] )
		end
		
		local locked = {}
		
		for k,v in pairs( self.Gametypes ) do
			local lock, tounlock = self:IsGametypeLocked( k )
			if lock then
				locked[ k ] = tounlock
			end
		end
		
		net.WriteTable( locked )
		
	net.Send( to )
end

VotePointTable = {}
for i = 1,( MAX_VOTEMAPS + 1 ) do
	VotePointTable[i] = 0
end

GameTypeVotePointTable = {}
for k,v in pairs(GM.Gametypes) do
	if not v.Hidden then
		GameTypeVotePointTable[k] = 0
	end
end

function GetChosenMap( pl, cmd, args )
	if args[1] == nil then return end
	if not ValidEntity ( pl ) then return end
	
	UpdateClientVotePoints ( pl, tonumber (args[1]) )
end
concommand.Add ("VoteAddMap",GetChosenMap)

function GetChosenGameType( pl, cmd, args )
	if args[1] == nil then return end
	if not ValidEntity ( pl ) then return end
	
	if GAMEMODE.Gametypes[ args[1] ] and GAMEMODE:IsGametypeLocked( args[1] ) then return end
	
	UpdateClientGMVotePoints ( pl, args[1] )
end
concommand.Add ("VoteAddGametype",GetChosenGameType)


util.AddNetworkString( "RecVoteChangeGM" )

function UpdateClientGMVotePoints ( pl, slot )
	
	if pl.VotedGameType and pl.VotedGameType == slot then return end

	if pl.VotedGameType then 
		GameTypeVotePointTable[pl.VotedGameType] = GameTypeVotePointTable[pl.VotedGameType] - 1 	
	end
	
	GameTypeVotePointTable[slot] = GameTypeVotePointTable[slot] + 1 
	pl.VotedGameType = slot
	
	net.Start("RecVoteChangeGM")
		for k,v in pairs(GAMEMODE.Gametypes) do
			if not v.Hidden then
				net.WriteInt ( GameTypeVotePointTable[k], 32 )
			end
		end
	net.Broadcast()
end

util.AddNetworkString( "RecVoteChange" )

function UpdateClientVotePoints ( pl, slot )
	
	if pl.Voted and pl.Voted == slot then return end
	
	if pl.Voted then 
		VotePointTable[pl.Voted] = VotePointTable[pl.Voted] - 1		
	end

	VotePointTable[slot] = VotePointTable[slot] + 1 
	pl.Voted = slot
	
	net.Start ("RecVoteChange")
		for i = 1,MAX_VOTEMAPS do
			net.WriteInt ( VotePointTable[i], 32 )
		end
		if GAMEMODE.CanRestart then
			net.WriteInt ( VotePointTable[MAX_VOTEMAPS+1], 32 )
		end
	net.Broadcast()
end

util.AddNetworkString( "CallDrawEndRound" )

//dont ask me why the hell I use team name instead of actual team enumeration. It's stupid but I can't be bothered to remake it right now
function GM:EndRound(winner)

	if ENDROUND then return end
	ENDROUND = true	
		
	ROUNDTIME = CurTime() + INTERMISSIONTIME
	ROUNDWINNER = winner or "Noone"
	
	self.GameState = ROUNDSTATE_END
	
	if self.SavedRestarts ~= -1 then
		ROUND_NUMBER = self.SavedRestarts
		game.ConsoleCommand( "dd_saverestarts -1\n" )
	end
	
	self.CanRestart = true
	if ROUND_NUMBER >= MAX_ROUNDS then
		self.CanRestart = false
	end
	
	self:ManageGametypeLocking( self:GetGametype() )
	
	for _,pl in pairs(player_GetAll()) do
		self:SendVotemaps ( pl )
		pl:Lock()
		
		if team.GetName(P_Team( pl )) == winner or pl == winner then
			pl:UnlockAchievement("fwin")
			
			pl:AddScore( "rndwon", 1 )
			
			if self.Gametype == "koth" then
				pl:AddScore( "kothwon", 1 )
			end
			if self.Gametype == "htf" then
				pl:AddScore( "htfwon", 1 )
			end
			if self.Gametype == "ffa" then
				pl:UnlockAchievement("ffawin")
			end
			
			if #player_GetAll() > 1 then
				pl:AddXP(SKILL_XP_PER_VICTORY)
				if pl.UsedOnlyMelee then
					pl:UnlockAchievement("hammer")
				end
			end
		else
			pl:UnlockAchievement("fdefeat")
			
			pl:AddScore( "rndlost", 1 )
			
			if self.Gametype == "koth" then
				pl:AddScore( "kothlost", 1 )
			end
			if self.Gametype == "htf" then
				pl:AddScore( "htflost", 1 )
			end
			
			if #player_GetAll() > 1 then
				pl:AddXP(15)
			end
		end
		
		pl:SaveStats()
	end
	
	//GAMEMODE:SynchronizeTime()
	
	timer.Simple(0.2, function()
		//for _,pl in pairs(player_GetAll()) do
		//	pl:SendLua("DrawEndround("..ROUNDTIME..")")
		//end
		
		net.Start( "CallDrawEndRound" )
			net.WriteInt( ROUNDTIME, 32 )
		net.Broadcast()
		
	end)
	
	timer.Simple(INTERMISSIONTIME+1,function()
		if ENDROUND and GAMEMODE then
			GAMEMODE:ProceedEndRound()
		end
	end)

end

local function MaxResult(tbl)
	
	local Maps = GAMEMODE:GetVoteMaps()
	
	local MaximumPoint = 0
	Winner = Maps[1] or "dm_raven"
	for k,v in ipairs (tbl) do
		local CurrentPoint = v
		if CurrentPoint > MaximumPoint then
			MaximumPoint = CurrentPoint
			Winner = ( k ~= ( MAX_VOTEMAPS + 1 ) ) and Maps[k] or "restart"
		end
	end
	
	return Winner
	
end

local function MaxResultGM(tbl)
	
	local MaximumPoint = 0
	Winner = "koth"
	for k,v in pairs (tbl) do
		local CurrentPoint = v
		if CurrentPoint > MaximumPoint then
			MaximumPoint = CurrentPoint
			Winner = k//GAMEMODE.Gametypes[k] and GAMEMODE.Gametypes[k].Name or GAMEMODE.Gametypes["koth"].Name
		end
	end
	
	return Winner
	
end

function GM:ProceedEndRound()

	for _,pl in pairs(player_GetAll()) do
		pl:SendLua("CloseEndround()")
	end
	
	local Next = VoteMaps[1] or "dm_raven"
	Next = MaxResult(VotePointTable) or Next
	
	local wingm = MaxResultGM(GameTypeVotePointTable) or "koth"
	
	local oldgm = self.Gametype
	
	if self.Gametype ~= wingm then
		RunConsoleCommand( "dd_gametype", wingm )
		self.Gametype = wingm
	end
	if Next == "restart" then
	
		local change_map = false
		
		if oldgm == "ts" and self.Gametype ~= "ts" then
			change_map = true
		end
		
		if oldgm != "ts" and self.Gametype == "ts" then
			change_map = true
		end
		
		if not TS_NIGHTMODE then 
			change_map = false
		end
	
		self:RestartRound( change_map )
		timer.Simple(5,function() if ENDROUND and GAMEMODE then GAMEMODE:RestartRound( change_map ) end end)
	else
		
		game.ConsoleCommand( "dd_saverestarts -1" )
	
		for _,pl in pairs(player_GetAll()) do
			pl:ConCommand("stopsounds")
		end
		
		if Next == "" then Next = MapCycle[1] or "dm_raven" end
		
		timer.Simple(1,function() game.ConsoleCommand("changelevel "..Next.."\n") end)
		
		timer.Simple(6,function()
			for k,v in pairs(player_GetAll()) do
				v:ChatPrint("[SERVER] Hmm... Looks like its this bug again. Don't worry.")
			end
		end)
		//RunConsoleCommand( "changelevel", Next )
		//timer.Simple(10,function() 
			//RunConsoleCommand( "changelevel", "dm_raven" ) 
		//end)
	end
	
	timer.Simple(10,function() 
		if ENDROUND then
			ErrorNoHalt( "Server got stuck at round end!\n" )
			ErrorNoHalt( "Gamemode is: "..self.Gametype.."\n" )
			RunConsoleCommand( "changelevel", MapCycle[1] or "dm_raven" ) 
		end
	end)

end

function change_map(pl,cmd,args)
	
	if !pl:IsAdmin() then return end
	
	local map = args[1]
	if not map then return end
	
	local gametype = args[2]
	
	if gametype and GAMEMODE.Gametypes[gametype] then
		game.ConsoleCommand( "dd_gametype "..gametype.."\n" )
	end
	
	game.ConsoleCommand("changelevel "..map.."\n");
	//RunConsoleCommand( "changelevel", map )
	
end
concommand.Add("admin_changelevel",change_map)


/*---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Carries out actions when the player dies 		 
---------------------------------------------------------*/

local thugmsg = {
	"%s just died!",
	"Thugs just killed %s!",
	"%s is no longer a weakling!",
	"They've killed %s!",
	"%s was destroyed!",
	"Oh shit, %s is dead!",
}

local ground_trace = {mask=MASK_SOLID_BRUSHONLY}
function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	local gib = false
	local frozen = ply._efFrozenTime and ply._efFrozenTime >= CurTime()
	
	if attacker and attacker.GetClass and attacker:GetClass() == "npc_antlionguard" then
		if attacker.Owner then
			attacker = attacker.Owner
		end
	end
	
	if (dmginfo:GetDamage() >= 100 or ply:Health() < -35 or frozen) and !( dmginfo:GetInflictor() and dmginfo:GetInflictor().CanSlice ) then
		ply:Gib( dmginfo, frozen )
		gib = true
	else	
		ply:CreateRagdoll()
		
		local slice = false
		local headshot = false
						
		if attacker and attacker:IsPlayer() and dmginfo:GetInflictor() and dmginfo:GetInflictor().CanSlice then
			local ang = (attacker:GetAttachment(attacker:LookupAttachment("anim_attachment_RH")).Ang+(VectorRand()*math.random(-35,35)):Angle()):Up()
			local check_trace = attacker:GetEyeTrace()
			//local zpos = ply:GetPos().z + 10 + math.random(10,45)
			local pos = ply:NearestPoint(dmginfo:GetDamagePosition())
			local zpos = pos.z
					
			local slice_rotation = math.random( 30,130 )//math.random( -95,95 )
			local change_rotation = false
		
			if math.abs( pos.x - ply:GetPos().x ) > 6 then
				pos.x = ply:GetPos().x + math.random( -3, 3 )
				change_rotation = true
			end
			
			if math.abs( pos.y - ply:GetPos().y ) > 6 then
				pos.y = ply:GetPos().y + math.random( -3, 3 )
				change_rotation = true
			end
			
			if change_rotation then
				slice_rotation = math.random( 40,120 )
			end
		
			if zpos < ply:GetPos().z then
				zpos = ply:GetPos().z + math.random( 10, 20 )
			end
			
			if zpos > ply:GetPos().z + 60 then
				zpos = ply:GetPos().z + 60 - math.random( 15, 30 )
			end
			
			if check_trace.Entity and check_trace.Entity:IsValid() and check_trace.Entity == ply then
				pos = check_trace.HitPos
				zpos = pos.z
				slice_rotation = math.random( 30,130 )
			end
			
			if dmginfo:GetInflictor().VerticalSlice or attacker:GetGroundEntity() ~= game.GetWorld() or ply:GetGroundEntity() ~= game.GetWorld() then
				ang = attacker:GetAimVector():Angle():Right():Angle()
				ang:RotateAroundAxis( attacker:GetAimVector(), math.random( -4,4 ) )
				ang = ang:Forward()
				zpos = zpos - math.random( 10 )
			else
				ang = attacker:GetAimVector():Angle():Right():Angle()
				ang:RotateAroundAxis( attacker:GetAimVector(), slice_rotation )
				ang = ang:Forward()
			end
			
			local e = EffectData()
			e:SetEntity( ply )
			e:SetOrigin( ply:GetPos() )
			e:SetStart( pos )
			//e:SetAngles( AngleRand()*math.random(-30,30) )
			e:SetScale( zpos )
			e:SetMagnitude( ply:IsThug() and 1 or 0 )
			e:SetNormal( ang )
			e:SetRadius( 1 )
			
			util.Effect("effect_slice",e,true,true)
			
			slice = true
			
		end
		
		local hitgroup = ply:LastHitGroup()
		if dmginfo:GetInflictor() and dmginfo:GetInflictor():IsValid() and dmginfo:GetInflictor().Dismember then
			hitgroup = -1
		end
		if dmginfo:GetInflictor() and dmginfo:GetInflictor():IsPlayer() and dmginfo:GetInflictor():GetActiveWeapon() and dmginfo:GetInflictor():GetActiveWeapon():IsValid() and (dmginfo:GetInflictor():GetActiveWeapon().Dismember) then// or dmginfo:GetInflictor():GetActiveWeapon().IsShotgun
			hitgroup = -1
		end
		
		if attacker.GetActiveWeapon and attacker:GetActiveWeapon():IsValid() and attacker:GetActiveWeapon().IsShotgun and ply.LastHitGrNormal then
			hitgroup = ply.LastHitGrNormal
		end
		
		local dismember = (hitgroup ~= HITGROUP_GENERIC or hitgroup ~= HITGROUP_GEAR or hitgroup ~= HITGROUP_STOMACH) and ply.LastDism and CurTime() <= ply.LastDism + 0.12
		
		
		
		if dismember and not slice then
		
			if hitgroup == HITGROUP_HEAD and math.random( 3 ) == 3 and ply:IsOnGround() then
				ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(0.5, 1) }
			end
			
			headshot = hitgroup == HITGROUP_HEAD
		
			local e = EffectData()
			e:SetEntity(ply)
			e:SetOrigin(ply:GetPos())
			e:SetScale(hitgroup)
			e:SetMagnitude(ply:IsThug() and 1 or 0)
			util.Effect("dismemberment",e,true,true)
		end
		
		if not slice and not gib then
			
			--if not dismember then
				local e = EffectData()
				e:SetEntity(ply)
				e:SetOrigin(ply:GetPos())
				e:SetMagnitude(ply:IsThug() and 1 or 0)
				util.Effect("effect_bleed",e,true,true)
			--end
			
			local bodyshot = ply.LastHitGr == HITGROUP_CHEST or ply.LastHitGr == HITGROUP_STOMACH-- or hitgroup == HITGROUP_HEAD// or ply.LastHitGr == HITGROUP_GENERIC
			
			if bodyshot and dmginfo:IsBulletDamage() and ply.LastHitBox and ply.LastHitPos then
			
				local holetype = 2
				
				if dmginfo:GetInflictor() and dmginfo:GetInflictor():IsValid() and attacker:GetActiveWeapon():IsValid() then
					if attacker:GetActiveWeapon().IsShotgun then
						holetype = 3
						if math.random(3) == 2 then
							ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(0.8, 1) }
						end
					elseif attacker:GetActiveWeapon().IsPistol then
						if attacker:GetActiveWeapon():GetClass() == "dd_revolver" then
							holetype = 3
						else
							holetype = 1
						end
					end
				end
					
				if holetype == 3 then
				
				
					local e = EffectData()
					e:SetEntity( ply )
					e:SetOrigin( ply:GetPos() )
					e:SetNormal( dmginfo:GetDamageForce():GetNormal() ) //( ply:GetPos() - attacker:GetPos() ):GetNormal()
					e:SetStart( ply.LastHitPos )// ply:NearestPoint(dmginfo:GetDamagePosition()) + dmginfo:GetDamageForce():GetNormal() * 8
					e:SetScale( hitgroup )
					e:SetHitBox( ply.LastHitBox )
					e:SetRadius( holetype )
					e:SetMagnitude( ply:IsThug() and 1 or 0 )
					util.Effect("bulletholes",e,true,true)
				end
			end
			////////////////
			
			if dmginfo:GetDamageType() == DMG_BURN then
				local e = EffectData()
				e:SetEntity(ply:GetRagdollEntity())
				e:SetOrigin(ply:GetPos())
				ply:GetRagdollEntity():SetColor(Color(20,20,20,255))
				util.Effect("burningplayer",e,true,true)
			end
			if dmginfo:GetDamageType() == DMG_SHOCK then
				local e = EffectData()
				e:SetEntity(ply:GetRagdollEntity())
				e:SetOrigin(ply:GetPos())
				util.Effect("electrocuted",e,true,true)
			end
			if dmginfo:GetDamageType() == DMG_DROWN then
				local e = EffectData()
				e:SetEntity(ply:GetRagdollEntity())
				e:SetOrigin(ply:GetPos())
				util.Effect("frozenplayer",e,true,true)
			end
						
			if ply.DeathSequence then
				local id, duration = ply:LookupSequence( ply.DeathSequence.Anim )
				local e = EffectData()
					e:SetEntity(ply)
					e:SetOrigin(ply:GetPos())
					e:SetAngles(ply:GetAngles())
					e:SetMagnitude( id )
					e:SetRadius( duration )
					e:SetScale( ply.DeathSequence.Speed or 1 )
				util.Effect( "death_sequence", e, nil, true )
			end
			
			
		end
		
	end
	

	ground_trace.start = dmginfo:GetDamagePosition()
	ground_trace.endpos = ground_trace.start+dmginfo:GetDamageForce():GetNormal()*70
	ground_trace.filter = ply
	
	local tr = util.TraceLine(ground_trace)
	if tr.Hit then
		for i=1,8 do
			local rand = tr.HitNormal:Angle():Right()*math.random(-20,20)
			local rand2 = tr.HitNormal:Angle():Up()*math.random(-20,20)
			util.Decal("Blood", tr.HitPos + tr.HitNormal+rand+rand2, tr.HitPos - tr.HitNormal+rand+rand2)				
		end
		//util.Decal("Blood",  tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
	
	
	ply:AddDeaths( 1 )
	
	ply:OnDeathSpeech()
	
	
	if IsValid(attacker) and IsValid(ply.LastAttacker) and ply.LastAttacker ~= attacker and not ply:IsTeammate(ply.LastAttacker) and attacker == ply then
		attacker = ply.LastAttacker
	end
	
	if ( IsValid(attacker) && attacker:IsPlayer() ) then
	
		local inf = dmginfo:GetInflictor()
		if inf:GetClass() == "player" then
			inf = IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon() or dmginfo:GetInflictor()
		end
	
		if ( attacker == ply ) then
			//if GAMEMODE:GetGametype() == "ffa" then
				//attacker:AddFrags( -1 )
			//end
		else
			
			if dmginfo:GetInflictor() and dmginfo:GetInflictor():GetClass() == "dd_eyelander" then
				if ValidEntity(attacker._efSpeedBoost) then
					attacker._efSpeedBoost.DieTime = CurTime() + 10
				else
					attacker:SetEffect("speedboost")
				end
			end
			
			if attacker:GetPerk("bff") then
				for _, al in pairs(team.GetPlayers(P_Team( attacker ))) do
					if IsValid(al) and al ~= attacker and attacker:IsTeammate(al) and al:GetPos():DistToSqr(attacker:GetPos()) <= 48400 then
						al:RefillHealth(20)
						local e = EffectData()
						e:SetOrigin(al:GetPos())
						e:SetEntity(al)
						e:SetScale(1)
						util.Effect("orb_pickup",e,nil,true)
					end
				end
			end
			
			if !IsValid(ply._efFrozen) then
				ply:CreateOrb(attacker)
			end

			attacker:AddFrags( 1 )
			
			attacker:AddXP(ply:IsCarryingFlag() and SKILL_XP_PER_KILL*5 or SKILL_XP_PER_KILL)
			
			if self:GetGametype() ~= "ffa" then
				team.AddScore(P_Team( attacker ), #player_GetAll() < 9 and 2 or 1 )
			end
			
			if self:GetGametype() == "conquest" then
				local tm = P_Team( ply ) == TEAM_RED and 1 or 2
				self:DrainTickets(tm)
			end
			//attacker:RefillMana(15)
			
			if attacker._SkillScavenger then
				attacker:RestoreAmmo(true)
			end
			
			if math.random(1,13) == 1 then
				attacker:OnKillSpeech()
			end	
			attacker:OnKillAnimation()
			
			CheckAchievementKillsGlobal(attacker,ply,inf)
		end
		
	end
	
	ply:BalanceTeams()
	
	if self:GetGametype() == "ts" and P_Team( ply ) ~= TEAM_THUG then
		ply:SetTeam(TEAM_THUG)
		
		self.DeadPeople[tostring(ply:SteamID())] = true
		
		if IsValid(attacker) and attacker:IsPlayer() and attacker ~= ply then
			GAMEMODE:HUDMessage(nil, string.format( thugmsg[math.random(1,#thugmsg)], ply:Name()) , attacker, 5)
		end
		
		timer.Simple(1, function() 
			if #team.GetPlayers(TEAM_BLUE) < 1 then
				local winner = team.GetName(TEAM_BLUE)
				self:EndRound(winner)
			end
		end)
	end
	
end

function GM:AllowPlayerPickup( pl, ent)
	return false
end

function GM:PlayerDeathThink( pl )

	if util.tobool(pl:GetInfoNum("_dd_spectatemode",1)) then
		pl:Spectate(OBS_MODE_ROAMING)
	end

	if pl:KeyPressed( IN_ATTACK2 ) then 
		pl:SendLua("LoadoutMenu()")
	end

	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	if ( pl:KeyPressed( IN_ATTACK ) /*|| pl:KeyPressed( IN_JUMP ) */) or pl:SteamID() == "BOT" then
	
		pl:Spawn()
		
	end
	
end

function GM:KeyPress( pl, key )
	
	if key == IN_JUMP then 
		if not pl:KeyDown( IN_DUCK ) then
			if util.tobool( tonumber( pl:GetInfo("_dd_spacebargrab") ) ) then
				pl:GrabLedge()
			end
		end
		pl:CheckWalljump()
	end
	
	if key == IN_USE then//IN_USE
		pl:GrabLedge()
	end
	
	if key == IN_DUCK and pl:IsRunning() and pl:OnGround() then
		pl:Slide()
	end
	
	local wep = pl:GetActiveWeapon()
	
	if key == IN_ATTACK and pl:IsRunning() and !pl:OnGround() and !pl:IsWallrunning() and wep and wep:IsValid() and wep:GetClass() == "dd_fists" and pl:GetPerk( "martialarts" ) and pl:KeyDown( IN_SPEED ) then//and pl:KeyDown( IN_JUMP ) then
		wep:SetNextPrimaryFire(CurTime() + 0.5)
		pl:DropKick()
	end
	
	if P_Alive( pl ) then
	
		if key == IN_SPEED and pl:GetPerk( "ghosting" ) then
			pl:DoGhosting()
		end
		
		if key == IN_SPEED and pl:GetPerk( "dash" ) then
			pl:DoDash()
		end
		
		if key == IN_SPEED and pl:GetPerk( "crow" ) and !pl:IsCrow() then
			pl:BecomeCrow()
		end
	
	end
	
	
	end


function GM:PlayerReady(pl)
	pl:SendLua("GAMEMODE.Gametype = \""..(tostring(self.Gametype) or "koth").."\"")
end

/*---------------------------------------------------------
   Name: gamemode:PlayerDeath( )
   Desc: Called when a player dies.
---------------------------------------------------------*/

util.AddNetworkString( "PlayerKilledSelf" )
util.AddNetworkString( "PlayerKilled" )
util.AddNetworkString( "PlayerKilledByPlayer" )


function GM:PlayerDeath( Victim, Inflictor, Attacker )
	
	if ( Victim.NextSpawnTime or 0 ) >= CurTime() then
		Victim.NextSpawnTime = CurTime() + 99999999
	else
		Victim.NextSpawnTime = CurTime() + ( Victim:IsBot() and 7 or SPAWNTIME )
	end

	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
	
	end
	
	if IsValid(Victim.LastAttacker) and Attacker ~= Victim.LastAttacker then
		Attacker = Victim.LastAttacker
	end
	
	if (Attacker == Victim) then
	
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( Victim )
		net.Broadcast()
		
		
		MsgAll( Attacker:Nick() .. " suicided!\n" )
		
	return end
	
	local inf = Inflictor:GetClass()
	
	if Inflictor._Telekinetic and Inflictor._Telekinetic >= CurTime() then
		inf = "spell_telekinesis"
	end
	
	if Inflictor._Pushed and Inflictor._Pushed >= CurTime() then
		inf = "spell_gravitywell"
	end

	if ( Attacker:IsPlayer() ) then
	
		net.Start( "PlayerKilledByPlayer" )
		
			net.WriteEntity( Victim )
			net.WriteString( inf )
			net.WriteEntity( Attacker )
			
		net.Broadcast()
		
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. inf .. "\n" )
		
	return end
	
	
	net.Start( "PlayerKilled" )
		
		net.WriteEntity( Victim )
		net.WriteString( inf )
		net.WriteString( Attacker:GetClass() )
			
	net.Broadcast()
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
	
end


local RollSound = Sound("ambient/voices/citizen_punches4.wav")
function GM:EntityTakeDamage( ent,dmginfo )
		
	local inflictor = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()
	
	if ent:GetClass() == "npc_grenade_frag" then
		dmginfo:SetDamage(0)
		return
	end
	
	if attacker:IsPlayer() and dmginfo:IsBulletDamage() then
		if attacker.GetActiveWeapon and IsValid(attacker:GetActiveWeapon()) then
			inflictor = attacker:GetActiveWeapon()
		end
	end
	
	if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == "crossbow_bolt" then
		inflictor = dmginfo:GetInflictor()
	end
	
	if inflictor and inflictor.Damage then
		dmginfo:SetDamage(inflictor.Damage)
	end
		
	//crossbow damage over distance
	if inflictor and inflictor:GetClass() == "crossbow_bolt" then
	
		local start_pos = inflictor.StartPos
		local end_pos = dmginfo:GetDamagePosition()
		
		local dist = end_pos:Distance( start_pos )
		
		local dmg = inflictor.Damage
				
		local newdmg = math.Clamp( ( dist/600 ) * dmg, dmg, dmg*5 )
		
		dmginfo:SetDamage( newdmg )
		
	end
	
	local ct = CurTime()
	if ent:IsPlayer() then	
		
		local wep = IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon()
		
		if attacker:GetClass() == "npc_antlionguard" then
			dmginfo:ScaleDamage(4)
			if attacker.Owner then
				inflictor = attacker
				attacker = attacker.Owner
			end
		end
			
		if attacker:IsPlayer() then
			if dmginfo:IsBulletDamage() then
				
				if attacker._DefaultBulletFalloffBonus and attacker._DefaultBulletFalloffBonus > 0 then
					if inflictor and (inflictor.IsLight or inflictor.IsHeavy) then
						dmginfo:ScaleDamage(1+attacker._DefaultBulletFalloffBonus/100)
					end
				end
				
			end
			
			if inflictor and inflictor.IsSpell then
								
				//Magic stuff
				if attacker._DefaultMagicBonus and attacker._DefaultMagicBonus > 0 then
					dmginfo:ScaleDamage(1+attacker._DefaultMagicBonus/100)
				end
				
			end
			
			if not ent.LastAttacker or ent.LastAttacker and ent.LastAttacker ~= attacker and attacker ~= ent then
				ent.LastAttacker = not attacker:IsTeammate(ent) and attacker or nil
			end
			
		end
	
	
		if ent.SpawnProtection and ent.SpawnProtection >= ct then
			dmginfo:SetDamage(0)
			return
		end

		if inflictor and not inflictor.IsMelee then
			if attacker.UsedOnlyMelee then
				attacker.UsedOnlyMelee = false
			end
		end
		
		
		local norm = dmginfo:GetDamageForce( ):GetNormal()

		if (inflictor._Telekinetic and inflictor._Telekinetic >= CurTime() or inflictor._Pushed and inflictor._Pushed >= CurTime()) and norm:Dot(ent:GetAimVector()) <= -0.5 and ent:IsDefending() then
			local norm = dmginfo:GetDamageForce( ):GetNormal()
			local force = dmginfo:GetDamage()
			dmginfo:SetDamage(0)
			ent:SetGroundEntity(NULL)
			ent:SetLocalVelocity(norm*force*2)
			return
		end
		
		if attacker:GetClass() == "projectile_launchergrenade" or attacker:GetClass() == "projectile_saw" then
			dmginfo:SetDamage(0)
			return
		end

		//crossbow bolts
		if inflictor and inflictor:GetClass() == "crossbow_bolt" then
			if ent:GetAttachment(1) then
				if (dmginfo:GetDamagePosition():DistToSqr( ent:GetAttachment( 1 ).Pos )) < 100 then
					dmginfo:ScaleDamage( 1.2 )
				end
			end
		end
	
		
		//Bullet blocking
		if (dmginfo:IsBulletDamage() or inflictor and inflictor:GetClass() == "crossbow_bolt") and ent._SkillBulletBlock then
			local norm = dmginfo:GetDamageForce( ):GetNormal()
			if norm:Dot(ent:GetAimVector()) <= -0.3 and ent:IsDefending() and math.Rand(0,1) <= 0.9 then//and dmginfo:GetDamagePosition().z - ent:GetPos().z >= ent:OBBMaxs().z / 3.4
				local force = dmginfo:GetDamage()
				dmginfo:SetDamage(0)
				local e = EffectData()
				e:SetOrigin(dmginfo:GetDamagePosition()+norm*-10)
				e:SetNormal(norm)
				util.Effect("melee_bullet_block",e,nil,true)
				
				ent:SetGroundEntity(NULL)
				ent:SetLocalVelocity(norm*force)
				
				ent:MeleeViewPunch(force*0.01)

				ent.BulletsBlocked = ent.BulletsBlocked or 0
				
				ent.BulletsBlocked = ent.BulletsBlocked + 1
				
				if ent.BulletsBlocked >= 250 then
					ent:UnlockAchievement("bulletdef")
				end
				
				return
			end
		end
		
		if wep and wep.IsMelee and ent._SkillBulletBlock and dmginfo:IsBulletDamage() and ent:IsSprinting() and ent._DefaultDodgeBonus and math.Rand(0,1) <= ent._DefaultDodgeBonus then
			dmginfo:SetDamage(0)
			sound.Play("weapons/fx/nearmiss/bulletLtoR0"..math.random(5,9)..".wav",ent:GetShootPos(),90,math.random(90,110))
			return true
		end
		
		
		//Frozen
		if ent._efFrozen then
			dmginfo:ScaleDamage(1.2)
		end
		
		//Crow
		if ent:IsCrow() then
			dmginfo:ScaleDamage(1.8)
		end
		
		if attacker:IsPlayer() and attacker:HasAdrenaline() and attacker ~= ent then
			dmginfo:ScaleDamage( 1.35 )
		end
		
		//Fall damage
		if dmginfo:IsFallDamage() then
			
			dmginfo:SetDamage( 0 )
			
			local speed = math.abs(ent:GetVelocity().z)
			
			local div_factor = 14
			local dmg = math.Clamp(speed/div_factor,5,200)
			
			local originaldmg = dmg
			
			if ent:KeyDown(IN_DUCK) and not (ent:IsThug() or ent:IsCrow()) then
				ent:Roll()
				if dmg < 40 then
					ent:EmitSound(RollSound,60,math.Rand(90,110))
					return true
				else
					dmg = dmg/2.5
				end
			end
			
			if ent:IsThug() then
				util.ScreenShake( ent:GetPos() + Vector(0,0,3), math.random(4,6), math.random(3,4), 1, 170 )
				sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav",ent:GetPos() + Vector(0,0,3),130,100,1)
				
				dmg = dmg/3
				
			end
			
			if game.GetMap() == "fy_highrise_09" and originaldmg > 60 then
				dmg = ent:Health() * 2
			end
			
			dmginfo:AddDamage( dmg )
		end
		
		//Magic Shield
		if ent:GetMagicShield() and ent:GetMagicShield():GetDTBool(0) and not (dmginfo:GetInflictor() and dmginfo:GetInflictor().IsMelee) and attacker ~= ent then
			local sh = ent:GetMagicShield()
			
			local norm = dmginfo:GetDamageForce( ):GetNormal()
			
			sh:DrainShield(dmginfo:GetDamage()*0.3,norm)
			dmginfo:ScaleDamage(0.7)
			
			local e = EffectData()
			e:SetOrigin(dmginfo:GetDamagePosition()+norm*-16)
			e:SetNormal(norm)
			e:SetScale(P_Team( ent ) == TEAM_BLUE and 0 or 1)
			util.Effect("magic_shield_impact",e,nil,true)
		end
		
		if wep and wep.IsMelee and ent._DefaultMResBonus and ent._DefaultMResBonus > 0 then
			if inflictor and inflictor.IsSpell then
				dmginfo:ScaleDamage(1-ent._DefaultMResBonus/100)
			end
		end
		
		
		//Butterfly perk
		if ent:GetPerk("butterfly") and dmginfo:IsBulletDamage() then
			if ent:IsSprinting() then
				if IsValid(ent._efWallRun) and ent._efWallRun.IsActive and ent._efWallRun:IsActive() then
					if math.Rand(0,1) <= 0.3 then
						dmginfo:SetDamage(0)
						sound.Play("weapons/fx/nearmiss/bulletLtoR0"..math.random(5,9)..".wav",ent:GetShootPos(),90,math.random(90,110))
						return true
					end
				else
					if math.Rand(0,1) <= 0.1 then
						dmginfo:SetDamage(0)
						sound.Play("weapons/fx/nearmiss/bulletLtoR0"..math.random(5,9)..".wav",ent:GetShootPos(),90,math.random(90,110))
						return true
					end
				end
				
			end
		end
		
		
		if attacker and attacker:IsPlayer() and attacker:GetPerk("berserker") and dmginfo:IsBulletDamage() then
			dmginfo:ScaleDamage(0.75)
		end
		
		//Fire and fury perk
		if attacker and attacker:IsPlayer() and attacker:GetPerk("fireandfury") and attacker ~= ent then
			if dmginfo:GetDamageType() == DMG_BURN and inflictor and (inflictor.IsSpell) then
				if IsValid(attacker._efAfterburn) then
					dmginfo:ScaleDamage(1.15)
				else
					dmginfo:ScaleDamage(1.05)
				end
				if math.random(5) == 1 then
					if IsValid(attacker._efAfterburn) then
						attacker._efAfterburn.DieTime = CurTime() + math.random(4,5)
					else
						attacker:SetEffect("afterburn")
					end
					sound.Play("ambient/fire/gascan_ignite1.wav",attacker:GetShootPos(),90,math.random(90,110))
				end
			end
		end
		if ent:GetPerk("fireandfury") then
			if IsValid(ent._efAfterburn) then
				dmginfo:ScaleDamage(0.8)
			end
			if dmginfo:GetDamageType() == DMG_DROWN then
				dmginfo:ScaleDamage(2.2)
			end
			if dmginfo:IsBulletDamage() then
				dmginfo:ScaleDamage(1.2)
			end
		end
			
		
		/*Deluvas: 1 / x = 0.15
		Deluvas: find x
		*/
		//mana thingy
		if attacker and attacker:IsPlayer() and attacker._SkillManaCh and attacker._DefaultMChannelingBonus then
			if inflictor and inflictor.IsSpell then
				local mana = dmginfo:GetDamage()*(attacker._DefaultMChannelingBonus or .25)
				attacker:RefillMana(mana)
			end
		end
		local attacker_wep = attacker and attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon()
		if attacker_wep and attacker_wep:GetClass() == "dd_wand" and attacker._DefaultMagicBonus and attacker._DefaultMagicBonus > 0 then
			if inflictor and inflictor.IsSpell then
				local hp = dmginfo:GetDamage()*((attacker._DefaultMagicBonus/100)*0.50)
				attacker:RefillHealth(hp)
			end
		end
		
		//grit
		if attacker ~= ent then
			if wep and wep.IsMelee and ent._SkillGrit and math.Rand(0,1) <= 0.2 and dmginfo:GetDamage() >= ent:Health() then
				local e = EffectData()
				e:SetOrigin(ent:GetPos())
				e:SetEntity(ent)
				e:SetScale(3)
				util.Effect("orb_pickup",e,nil,true)
				sound.Play("Zombie.Alert",ent:GetShootPos(),90,100)
				dmginfo:SetDamage(0)
				return
			end
		end
		
		if dmginfo:GetDamage() > 0 then
			ent:OnPainSpeech()
			ent:OnPainAnimation()
		end
		
		/*if attacker:IsPlayer() and attacker ~= ent and dmginfo:GetDamage() > 0 and ent:IsPlayer() and !ent:IsTeammate( attacker ) then
			attacker:ShowHitmarker()
		end*/
		
		local hitgroup = ent:LastHitGroup() or HITGROUP_GENERIC

		if hitgroup ~= HITGROUP_GENERIC or hitgroup ~= HITGROUP_GEAR or hitgroup ~= HITGROUP_STOMACH then
			ent.LastDism = CurTime()
		end
		
		local hs = hitgroup == HITGROUP_HEAD and (ent.LastHS or 0) <= CurTime() and dmginfo:IsBulletDamage()
		if hs then
			ent.LastHS = CurTime() + 1
			for i=1,math.random(1,3) do
				ent:EmitSound("player/headshot"..math.random(1,2)..".wav")
			end
		end
		
		if attacker:IsPlayer() and attacker ~= ent and dmginfo:GetDamage() > 0 and ent:IsPlayer() and !ent:IsTeammate( attacker ) then
			attacker:ShowHitmarker( hitgroup == HITGROUP_HEAD and dmginfo:IsBulletDamage() )
		end

	end

end

function GM:OnPlayerHitGround ( ent )
	if IsValid( ent ) then
		if ent:IsRolling() or ent:IsCrow() then 
			return true 
		end
	end
end

//this seems to be a bug or there is something wrong with my server
function GM:PlayerConnect( name, ip )
	if game.IsDedicated() then
		PrintMessage( HUD_PRINTTALK, name.. " has joined the game." )
	end
end

function GM:PlayerDeathSound()
	return true
end 


hook.Add( "PlayerShouldTaunt", "Disable Acts", function( ply )
    return false
end )


GM.NormalColorModels = {}

function GM:CheckNormalColorModels()
	
	local hasfolder = file.IsDir( "darkestdays", "DATA" )
	
	if not hasfolder then
		file.CreateDir( "darkestdays" )
	end
	
	if not file.Exists( "darkestdays/dd_colormodels.txt", "DATA" ) then
		
		local default = {
			"models/player/combine_soldier.mdl",
			"models/player/leet.mdl",
			"models/player/guerilla.mdl",
			"models/player/phoenix.mdl",
			"models/player/gasmask.mdl",
			"models/player/riot.mdl",
			"models/player/swat.mdl",
			"models/player/urban.mdl",
			"models/player/hostage/hostage_01.mdl",
			"models/player/hostage/hostage_02.mdl",
			"models/player/hostage/hostage_03.mdl",
			"models/player/hostage/hostage_04.mdl",
			"models/player/soldier_stripped.mdl",
			"models/player/zombie_fast.mdl",
			"models/player/zombie_soldier.mdl",
			"models/player/combine_soldier_prisonguard.mdl",
			"models/player/arctic.mdl",
			"models/player/dod_american.mdl",
			"models/player/dod_german.mdl",
		}
		
		local data = ""
		
		for k, v in pairs( default ) do
			if k == 1 then
				data = v
			else
				data = data.."\n"..v
			end
			self.NormalColorModels[ k ] = v
		end
		
		file.Write( "darkestdays/dd_colormodels.txt", data )
	else
		local raw_data = file.Read( "darkestdays/dd_colormodels.txt" )
		raw_data = string.gsub( raw_data, " ", "" )
			
		self.NormalColorModels = string.Explode( "\n", raw_data )
	end
	
	--PrintTable( self.NormalColorModels )
	
	
end

function GM:InitPostEntity( )	

	//self:LoadMapPickups()

	-- Destroy all unnecessary entities
	local toDestroy = ents.FindByClass("prop_ragdoll")
	
	//if LOADED_PICKUPS then
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_357"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_pistol"))
		
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_box_buckshot"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_rpg_round"))
		
		
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_crossbow"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1"))
		
		
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_box_buckshot"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthcharger"))
		
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthkit"))
		toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthvial"))
	//end
	toDestroy = table.Add(toDestroy, ents.FindByClass("trigger_weapon_strip"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1_grenade"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_battery"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_pistol_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_crate"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_item_crate"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("func_healthcharger"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("func_recharge"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_dynamic_resupply"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_357_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2_altfire"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_suitcharger"))
	//toDestroy = table.Add(toDestroy, ents.FindByClass("npc_zombie"))
	//toDestroy = table.Add(toDestroy, ents.FindByClass("npc_maker"))
	//toDestroy = table.Add(toDestroy, ents.FindByClass("npc_template_maker"))
	//toDestroy = table.Add(toDestroy, ents.FindByClass("npc_maker_template"))	
	toDestroy = table.Add(toDestroy, ents.FindByClass("game_player_equip"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_physicscannon"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_crowbar"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_stunstick"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_357"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_pistol"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_smg1"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_ar2"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_crossbow"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_shotgun"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_rpg"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_slam"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_pumpshotgun"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_ak47"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_deagle"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_fiveseven"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_glock"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_m4"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_mac10"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_mp5"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_para"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_tmp"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_frag"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_physcannon"))
	
	for _, ent in pairs(toDestroy) do
		ent:Remove()
	end
	
	-- Sort out spawnpoints
	self.RedSpawnPoints = {}
	self.RedSpawnPoints = ents.FindByClass("info_player_undead") -- Red Survival spawnpoints
	self.RedSpawnPoints = table.Add(self.RedSpawnPoints, ents.FindByClass("info_player_Red"))
	self.RedSpawnPoints = table.Add(self.RedSpawnPoints, ents.FindByClass("info_player_rebel")) -- HL2 DM spawns
	self.RedSpawnPoints = table.Add( self.RedSpawnPoints, ents.FindByClass( "info_player_axis" ) ) -- DoD spawns
	
	self.BlueSpawnPoints = {}
	self.BlueSpawnPoints = ents.FindByClass("info_player_human") -- Red Survival spawnpoints
	self.BlueSpawnPoints = table.Add( self.BlueSpawnPoints, ents.FindByClass("info_player_combine")) -- HL2 DM spawns
	self.BlueSpawnPoints = table.Add( self.BlueSpawnPoints, ents.FindByClass( "info_player_allies" ) ) -- DoD spawns
	
	local mapname = game.GetMap()
	-- Counter-Strike: Source spawnpoints
	-- In cs_ and zs_ maps, terrorist spawns are usually at the most defendable place, place Blues there
	if string.find(mapname, "cs_") or string.find(mapname, "zs_") then
		self.RedSpawnPoints = table.Add(self.RedSpawnPoints, ents.FindByClass("info_player_counterterrorist"))
		self.BlueSpawnPoints = table.Add( self.BlueSpawnPoints, ents.FindByClass("info_player_terrorist"))
	else -- In other counter-strike maps, it's the other way around most of the time
		self.RedSpawnPoints = table.Add(self.RedSpawnPoints, ents.FindByClass("info_player_terrorist"))
		self.BlueSpawnPoints = table.Add(self.BlueSpawnPoints, ents.FindByClass("info_player_counterterrorist"))
	end	
	-- Old GMod spawns
	for _, oldspawn in pairs(ents.FindByClass("gmod_player_start")) do
		if oldspawn.BlueTeam then
			table.insert(self.BlueSpawnPoints, oldspawn)
		else
			table.insert(self.RedSpawnPoints, oldspawn)
		end
	end	
	-- TF2 spawns
	for _, tf2spawn in pairs(ents.FindByClass("info_player_teamspawn")) do
		if tf2spawn:GetKeyValues().TeamNum == 3  then -- Red TF2 spawn
			table.insert(self.BlueSpawnPoints, tf2spawn)
		else -- Blue TF2 spawns and the rest with the Red
			table.insert(self.RedSpawnPoints, tf2spawn)
		end
	end	
	-- If no team spawn have been found, it's probably a deathmatch map.
	if #self.BlueSpawnPoints <= 0 then
		self.DeathMatchMap = true
		self.BlueSpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("info_player_start"))
		self.BlueSpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("info_player_deathmatch" ))
	end
	if #self.RedSpawnPoints <= 0 then
		self.DeathMatchMap = true
		self.RedSpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("info_player_start"))
		self.RedSpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("info_player_deathmatch"))
	end
	
	if #self.BlueSpawnPoints <= 0 then
		self.BlueSpawnPoints = ents.FindByClass("info_player_start")
	end
	
	if #self.RedSpawnPoints <= 0 then
		self.RedSpawnPoints = ents.FindByClass("info_player_start")
	end
	
	
	self:LoadKOTHPoints()
	self:SetExploitBoxes()
	self:SetMapList()
	self:CheckNormalColorModels()
	
	self:CreateFlashLight()
	
	
end

function GM:PlayerSelectSpawn( pl )

	if P_Team( pl ) == TEAM_RED or P_Team( pl ) == TEAM_FFA and math.random(2) == 2 then	
		local Count = #self.RedSpawnPoints
		if Count == 0 then return pl end
		if !self.DeathMatchMap then
			for i=0, 20 do
				local ChosenSpawnPoint = self.RedSpawnPoints[math.random(1, Count)]
				if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastRedSpawnPoint then
					local blocked = false
					for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
						if ent and ent:IsPlayer() then
							blocked = true
						end
					end
					if not blocked then
						LastRedSpawnPoint = ChosenSpawnPoint
						return ChosenSpawnPoint
					end
				end
			end
		else
			LastRedSpawnPoint = self:ChooseMostFarSpawn(pl)
		end
		return LastRedSpawnPoint
	else
		local Count = #self.BlueSpawnPoints
		if Count == 0 then return pl end
		for i=0, 20 do
			local ChosenSpawnPoint = self.BlueSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastBlueSpawnPoint then
				local blocked = false
				for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
					if ent and ent:IsPlayer() then
						blocked = true
					end
				end
				if not blocked then
					LastBlueSpawnPoint = ChosenSpawnPoint
					return ChosenSpawnPoint
				end
			end
		end
		return LastBlueSpawnPoint
	end
	return pl
	
end

function GM:ChooseMostFarSpawn(pl)
	local c = 0
	local vec = Vector(0,0,0)
	for k, v in pairs(team.GetPlayers(self:GetGametype() == "ffa" and TEAM_FFA or TEAM_BLUE)) do
		c = c+1
		vec = vec+v:GetPos()
	end

	if c == 0 then c = 1 end
	
	local averageteampos = vec/c
	local chosenpoint = self.RedSpawnPoints[1]
	local dis = chosenpoint:GetPos():Distance(averageteampos)
	local blocked = false
	
	for k, v in pairs(self.RedSpawnPoints) do
		if (dis < v:GetPos():Distance( averageteampos ) and v != LastRedSpawnPoint) then
			blocked = false
			for _, ent in pairs(ents.FindInBox(v:GetPos() + Vector(-48, -48, 0), v:GetPos() + Vector(48, 48, 60))) do
				if ent and ent:IsPlayer() then
					blocked = true
				end
			end
			if not blocked then
				chosenpoint = v
				dis = v:GetPos():Distance( averageteampos )
			end			
		end
	end
	
	return chosenpoint
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if dmginfo:IsBulletDamage() then
		local startpos = dmginfo:GetAttacker() and dmginfo:GetAttacker().GetShootPos and dmginfo:GetAttacker():GetShootPos() or dmginfo:GetAttacker():GetPos()
		local endpos = dmginfo:GetDamagePosition()
		
		local dist = startpos:DistToSqr(endpos)
		
		local bonus = 0//dmginfo:GetAttacker() and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker()._DefaultBulletFalloffBonus or 0
		local maxdist = IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor().Caliber and CaliberFalloffDistance[dmginfo:GetInflictor().Caliber] or BULLET_DISTANCE_FALLOFF_MAX
		
		maxdist = maxdist * maxdist
		
		local distmul = math.Clamp(dist/maxdist,0,1)
		local scale = math.Clamp(BULLET_DAMAGE_MAX - distmul,BULLET_DAMAGE_MIN + bonus ,BULLET_DAMAGE_MAX)
		
		dmginfo:ScaleDamage( scale )
		
	end
	
	
	-- More damage if we're shot in the head
	 if ( hitgroup == HITGROUP_HEAD ) then

		if !(dmginfo:IsBulletDamage() and attacker and attacker:GetActiveWeapon():IsValid() and attacker:GetActiveWeapon().IsShotgun) then
			dmginfo:ScaleDamage( 1.55 )
		end
	 
	 end
	 
	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
	 
		dmginfo:ScaleDamage( 0.5 )
	 
	 end

end

function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	
	local sv_alltalk = GetConVar( "sv_alltalk" )
	
	if pTalker.Muted then return false, false end
	
	local alltalk = sv_alltalk:GetInt()
	if ( alltalk > 0 ) then return true, alltalk == 2 end

	return P_Team( pListener ) == P_Team( pTalker ), false
	
end

function GM:CanPlayerSuicide( ply )
	
	if self:GetGametype() == "ts" and P_Team( ply ) ~= TEAM_THUG and IsValid(GetHillEntity()) and GetHillEntity().IsActive and not GetHillEntity():IsActive() then
		return false
	end
	
	return P_Team( ply ) ~= TEAM_SPECTATOR or not ply.FirstSpawn
	
end

function GM:PlayerNoClip( pl, on )
	
	if SinglePlayer() or pl:IsAdmin() then 
		return true
	end
	
	return false
	
end

function GM:PlayerUse( pl, entity )
	// door exploit prevention
	local doors = { "func_door", "prop_door_rotating", "func_door_rotating" }
	if table.HasValue(doors,entity:GetClass()) then
		if (entity.LastDoorUse and entity.LastDoorUse + 4 or 0) > CurTime() then
			return false
		end
		entity.LastDoorUse = CurTime()
	end
	return true
end

function DoPhysicsMultiplayer()
	local phys = {}
	local movetype, collision, model, vPos, aAng, Skin, Mass
	
	print("----Converting prop_physics to multiplayer!")
	local c = 0
	-- Set-up the phys table so it matches the keyvalues one
	for k,v in ipairs ( ents.FindByClass("prop_physics") ) do
		if !table.HasValue(IgnorePhysToMult,string.lower(v:GetModel())) then
			phys[v:EntIndex()] = v
			c = c + 1
		end
	end
	for k,v in ipairs ( ents.FindByClass("prop_physics_respawnable") ) do
		if !table.HasValue(IgnorePhysToMult,string.lower(v:GetModel())) then
			phys[v:EntIndex()] = v
			c = c + 1
		end
	end

	print("Found "..tostring(c).." props to convert!")
	
	c = 0
	
	for k, v in pairs(phys) do
		-- Save the original values
		local index = v:EntIndex()
		local movetype = v:GetMoveType()
		local collision = v:GetCollisionGroup()
		local model = v:GetModel()
		local vPos = v:GetPos()
		local aAng = v:GetAngles()
		local Skin = v:GetSkin()
		local Mass = nil
		local motion = true
		
		local obj= v:GetPhysicsObject()
		if obj:IsValid() then
			Mass = obj:GetMass()
			motion = obj:IsMotionEnabled() 
		end

		-- Remove the entity
		if not v:IsValid() then return end
		SafeRemoveEntity ( v )
		
		-- Respawn the entities at multiplayer physics with same properties
		local ent = ents.Create("prop_physics_multiplayer")
		if not ent:IsValid() then return end
			
		-- Add the old values
		ent:SetMoveType( movetype )
		ent:SetCollisionGroup ( collision )
				
		-- Set the new keyvalues from the table init-ed in GM:EntityKeyValue
		//for key, val in pairs ( tbKeyValues ) do
			//if key == index then
			local val = v:GetKeyValues()
				for i,j in pairs ( val ) do
					if i != "classname" then
						ent:SetKeyValue ( i, j )
					end
				end
			//end
		//end
		
		//print(model)
		//print(motion)
		
		ent:SetModel ( model )
		ent:SetPos ( vPos )
		ent:SetAngles ( aAng )	
		ent:SetSkin(Skin)
				

		ent:Spawn()
		
		local obj= ent:GetPhysicsObject()
		if obj:IsValid() then
			if Mass then
				obj:SetMass(Mass)
			end
			obj:EnableMotion( motion )
		end
		
		c = c + 1
	end
	
	print("Converted "..tostring(c).." props to prop_physics_multiplayer!")
end
//hook.Add ( "InitPostEntity","MultiplayerReplace",DoPhysicsMultiplayer )

