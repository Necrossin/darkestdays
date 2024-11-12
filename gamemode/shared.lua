game.AddParticles("particles/darkestdays_v11.pcf" ) //_v8

//some  particles
PrecacheParticleSystem( "muzzle_autorifles" )
PrecacheParticleSystem( "muzzle_machinegun" )
PrecacheParticleSystem( "muzzle_pistols" )
PrecacheParticleSystem( "muzzle_shotguns" )
PrecacheParticleSystem( "muzzle_smgs" )

PrecacheParticleSystem( "dd_blood_impact" )
PrecacheParticleSystem( "dd_blood_impact2" )
PrecacheParticleSystem( "dd_blood_headshot_2" )
PrecacheParticleSystem( "dd_blood_dismemberment" )
PrecacheParticleSystem( "dd_blood_dismemberment_wound" )
PrecacheParticleSystem( "dd_blood_big_gibsplash" )
PrecacheParticleSystem( "dd_blood_gib_trail" )
PrecacheParticleSystem( "dd_blood_gib_trail_big" )
PrecacheParticleSystem( "dd_blood_gib_trail_big_alt" )
PrecacheParticleSystem( "dd_blood_guts" )
PrecacheParticleSystem( "dd_blood_big1_mist" )
PrecacheParticleSystem( "impact_melee_block" )
PrecacheParticleSystem( "melee_trail" )
PrecacheParticleSystem( "melee_trail_normal" )
PrecacheParticleSystem( "melee_trail_red" )
PrecacheParticleSystem( "melee_trail_blue" )
PrecacheParticleSystem( "melee_trail_b" )
PrecacheParticleSystem( "melee_bullet_block" )
PrecacheParticleSystem( "melee_health_drain" )
PrecacheParticleSystem( "dd_magic_shield1" )
PrecacheParticleSystem( "dd_magic_shield1_red" )
PrecacheParticleSystem( "dd_magic_shield_impact" )
PrecacheParticleSystem( "dd_magic_shield_impact_red" )
PrecacheParticleSystem( "dd_magic_shield_idle" )
PrecacheParticleSystem( "dd_magic_shield_idle_red" )
PrecacheParticleSystem( "hill_neutral" )
PrecacheParticleSystem( "hill_red" )
PrecacheParticleSystem( "hill_blue" )
PrecacheParticleSystem( "evil_eyes" )
PrecacheParticleSystem( "dd_evil_orb" )
PrecacheParticleSystem( "dd_evil_orb_pickup" )

PrecacheParticleSystem( "dash_red" )
PrecacheParticleSystem( "dash_blue" )


game.AddDecal( "BloodHuge1", "decals/bloodstain_001" )
game.AddDecal( "BloodHuge2", "decals/bloodstain_002" )
game.AddDecal( "BloodHuge3", "decals/bloodstain_003" )
game.AddDecal( "BloodHuge4", "decals/bloodstain_003b" )
game.AddDecal( "BloodHuge5", "decals/bloodstain_101" )
//game.AddDecal( "BloodHuge6", "decals/bloodstain_201" )

local M_Player = FindMetaTable("Player")

local P_Team = M_Player.Team
local P_Alive = M_Player.Alive

//Some sounds

for i=1,5 do
	util.PrecacheSound( "physics/gore/flesh_impact_bullet"..i..".wav" )
end

for i=1,3 do
	util.PrecacheSound( "physics/gore/headshot"..i..".wav" )
end

function table.Resequence ( oldtable )
	local newtable = table.Copy ( oldtable )
	local id = 0
	
	--Clear old table
	table.Empty ( oldtable )
	
	--Write the new one
	for k,v in pairs ( newtable ) do
		id = id + 1
		oldtable[id] = newtable[k]
	end
end


//some bullshit, that I should probably remove
ValidEntity = IsValid
WorldSound = sound.Play
GetWorldEntity = game.GetWorld
SinglePlayer = game.SinglePlayer

local ents = ents
local table = table
local util = util
local player = player
local string = string

include("performance/buffthefps.lua")
include("performance/nixthelag.lua")
include("performance/rewrite_entity_index.lua")
include("performance/rewrite_player_index.lua")
include("performance/rewrite_weapon_index.lua")

include("obj_player_extend.lua")
include("obj_weapon_extend.lua")
include("sh_options.lua")
include("sh_server_options.lua")
include("sh_translate.lua")
include("animations.lua")

TEAM_RED = 3
TEAM_BLUE = 4
TEAM_FFA = 5

TEAM_THUG = TEAM_RED

GM.Name 		= "Darkest Days"
GM.Author 		= "Necrossin"
GM.Version		= "v 12/11/2024"
GM.Email 		= ""
GM.Website 		= ""


team.SetUp(TEAM_RED, "Team Red", Color(250,40,40,255))
team.SetUp(TEAM_BLUE, "Team Blue", Color(0,121,250,192))
team.SetUp(TEAM_FFA, "Team FFA", Color(240,121,0,255))



GM.TranslateTeamNameByID = {
	[TEAM_RED] = "team_red",
	[TEAM_BLUE] = "team_blue",
	[TEAM_FFA] = "team_ffa",
}

GM.TranslateTeamName = {
	["Team Red"] = "team_red",
	["Team Blue"] = "team_blue",
	["Team FFA"] = "team_ffa",
}



/*---------------------------------------------------------
   Name: gamemode:PhysgunPickup( )
   Desc: Return true if player can pickup entity
---------------------------------------------------------*/
function GM:PhysgunPickup( ply, ent )
	return true
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if ( attacker.Team ) then
		if( pl:IsTeammate(attacker) and pl ~= attacker) then//pl:Team() == attacker:Team()
			return false
		end 
	end
	return true
end

/*---------------------------------------------------------
   Name: Text to show in the server browser
---------------------------------------------------------*/
function GM:GetGameDescription()
	return self.Name
end

function GM:ShouldCollide( ent1, ent2 )
	if ent1:IsPlayer() and ent2:IsPlayer() then
		local collide = !ent1:IsTeammate(ent2)//ent1:Team() != ent2:Team()
		return collide
	end
	
	return true
end

function GM:StartCommand( pl, cmd ) 
	
	/*local wep = pl:GetActiveWeapon()
	
	local attack_1 = pl:KeyDown( IN_ATTACK )
	local attack_2 = pl:KeyDown( IN_ATTACK2 )
	
	if wep and IsValid( wep ) and !wep.IgnoreSprint and ( ( attack_1 or attack_2 ) and ( pl:IsSprinting() or pl:IsWallrunning() ) or ( pl.NextSprint and pl.NextSprint >= CurTime() ) or ( wep.IsSwinging and wep:IsSwinging() ) ) then
		cmd:RemoveKey( IN_SPEED )
		if ( pl.NextSprint or 0 ) < CurTime() then
			pl.NextSprint = CurTime() + 0.5
		end
	end*/
	
	local wep = pl:GetActiveWeapon()
	
	if ( pl.NextSprint and pl.NextSprint >= CurTime() ) or ( wep and IsValid( wep ) and wep.IsSwinging and wep:IsSwinging() ) then
		cmd:RemoveKey( IN_SPEED )
	end
	
end

function GM:Move( pl, mv )
	
	local speed_mul = pl:Crouching() and pl:GetCrouchedWalkSpeed() or 1
	
	if pl._efFrozen and IsValid(pl._efFrozen) then
		mv:SetMaxSpeed( math.abs( pl:GetMaxSpeed() ) * 0.75 )
	end
	
	/*if pl:IsGhosting() and not pl:IsGhostingWithPerk() then
		mv:SetMaxSpeed( math.abs( pl:GetMaxSpeed() ) * 0.75 )
	end*/
	
	if pl:IsCarryingFlag() then
		
		local speed = math.abs( pl:GetMaxSpeed() * speed_mul ) * 0.85
		
		mv:SetMaxSpeed( speed )
		mv:SetMaxClientSpeed( speed )
	end
	
	if pl:IsDefending() then
		local mul = 1
		local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
		if wep and wep.BlockSpeed then
			mul = wep.BlockSpeed
		end

		local speed = math.abs( pl:GetMaxSpeed() * speed_mul ) * mul
		mv:SetMaxSpeed( speed )
		mv:SetMaxClientSpeed( speed )
	end
	
	if pl._efSlide and IsValid(pl._efSlide) and pl._efSlide.Move then
		pl._efSlide:Move( mv )
	end
	
	if pl._efSpeedBoost and IsValid(pl._efSpeedBoost) then
		local sp = mv:GetMaxSpeed() + pl._efSpeedBoost.SpeedBonus
		
		mv:SetMaxSpeed( sp )
		mv:SetMaxClientSpeed( sp )
	end
	
	if pl:IsGhosting() then
		local sp = mv:GetMaxSpeed() * 1.5
		
		mv:SetMaxSpeed( sp )
		mv:SetMaxClientSpeed( sp )
	end
	
	local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
	if wep and wep.Move then
		wep:Move(mv)
	end
	
	if pl:IsCrow() and pl._efCOTN and pl._efCOTN.Move then
		pl._efCOTN:Move( mv )
	end
	
	if IsValid( pl._efWallRun ) and pl._efWallRun.Move then
		pl._efWallRun:Move( mv )
	end
	
	if IsValid( pl._efWallRun ) and pl._efWallRun.Move then
		pl._efWallRun:Move( mv )
	end
	
	if IsValid(pl._efDash) and pl._efDash.Move then
		pl._efDash:Move( mv )
	end
	
end

function GM:PlayerFootstep( pl, pos, foot, snd, volume, filter ) 
	if pl:IsGhosting() or pl:IsDashing() then return true end
end

function GM:GetGametype()
	return self.Gametype or "none"
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
	
	if SERVER then
	
		if key == IN_USE then//IN_USE
			local grab = pl:GrabLedge()
			if not grab and util.tobool( tonumber( pl:GetInfo("_dd_usekeydive") ) ) then
				pl:Dive()
			end
		end
		
		if key == IN_WALK then
			pl:Dive()
		end
		
		if key == IN_DUCK and pl:IsRunning() and pl:OnGround() then
			pl:Slide()
		end
		
		local wep = pl:GetActiveWeapon()
		
		if key == IN_ATTACK and pl:IsRunning() and !pl:OnGround() and !pl:IsWallrunning() and wep and wep:IsValid() and wep:GetClass() == "dd_fists" and pl:GetPerk( "martialarts" ) then// and pl:KeyDown( IN_SPEED ) then
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
	
	
end

local rand = math.random
function table.Shuffle(t)
  local n = #t
 
  while n > 2 do

    local k = rand(n) 

    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

local TrueVisibleTrace = { mask = MASK_SHOT }
function TrueVisible(posa, posb)

	local filt = ents.FindByClass( "projectile_*" )
	filt = table.Add( filt, player.GetAll() )
	TrueVisibleTrace.start = posa
	TrueVisibleTrace.endpos = posb
	TrueVisibleTrace.filter = filt
	TrueVisibleTrace.mask = MASK_SHOT

	return not util.TraceLine(TrueVisibleTrace).Hit
end


function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60.0)
	return string.format("%0d:%02d", iMinutes, math.floor(TimeInSeconds - iMinutes*60))
end 

team.BaseGetName = team.GetName

function team.GetName(tm)
	if tm == TEAM_SPECTATOR then
		return "Lobby"
	end
	return team.BaseGetName(tm)
end


Gibs = {
	"models/props_junk/watermelon01_chunk02a.mdl",
	"models/props_junk/watermelon01_chunk02b.mdl",
	"models/props_junk/watermelon01_chunk02c.mdl",
	"models/Gibs/HGIBS.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/Gibs/Antlion_gib_medium_1.mdl",	
	"models/Gibs/Shield_Scanner_Gib6.mdl",
	//"models/Humans/Charple03.mdl",
}


PlayerGibs = {
	
	//torso
	[1] = { model = Model( "models/humans/charple03.mdl" ), bone = "ValveBiped.Bip01_Pelvis", scale = 1, offset = vector_up * -45, angle = Angle( 0, 0, 0 ), bbox = { Vector( -6, -6, 40 ), Vector( 6, 6, 80 ) }, scaledown = { "Charple3.Head" }, big_decal = true },//"models/humans/charple03.mdl"
	
	//left arm
	[2] = { model = Model( "models/gibs/antlion_gib_medium_2.mdl" ), bone = "ValveBiped.Bip01_L_UpperArm", big_decal = true },
	//right arm
	[3] = { model = Model( "models/gibs/antlion_gib_medium_2.mdl" ), bone = "ValveBiped.Bip01_R_UpperArm", big_decal = true },
	--[3] = { model = Model( "models/humans/charple02.mdl" ), bone = "ValveBiped.Bip01_Pelvis", offset = vector_up * -40, bbox = { Vector( -6, -6, 40 ), Vector( 6, 6, 80 ) }, scale_all_but = { 3, 4, 5 }, big_decal = true},
	
	//left leg
	[4] = { model = Model( "models/gibs/antlion_gib_large_3.mdl" ), bone = "ValveBiped.Bip01_L_Thigh", scale = 0.6, big_decal = true },
	//right leg
	[5] = { model = Model( "models/gibs/antlion_gib_large_3.mdl" ), bone = "ValveBiped.Bip01_R_Thigh", scale = 0.6, big_decal = true },
	
	//head (few bits)
	[6] = { model = Model( "models/props_junk/watermelon01_chunk02a.mdl" ), bone = "ValveBiped.Bip01_Head1", scale = 1.2 },
	[7] = { model = Model( "models/props_junk/watermelon01_chunk02a.mdl" ), bone = "ValveBiped.Bip01_Head1", scale = 1.2 },
	[8] = { model = Model( "models/props_junk/watermelon01_chunk02a.mdl" ), bone = "ValveBiped.Bip01_Head1", scale = 1.2 },

}



local util = util
local pairs = pairs
local file = file

for k, v in pairs( Gibs ) do
	util.PrecacheModel( string.lower(v) )
end

for _,mdl in pairs (file.Find("models/player/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/group01/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/group01/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/group03/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/group03/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/hostage/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/hostage/"..mdl )
end

util.PrecacheSound("physics/flesh/flesh_bloody_break.wav")

game.AddParticles("particles/achievement.pcf" )
PrecacheParticleSystem( "achieved" ) 

VoiceSetTranslate = {}
VoiceSetTranslate["models/player/alyx.mdl"] = "female"
VoiceSetTranslate["models/player/barney.mdl"] = "male"
VoiceSetTranslate["models/player/breen.mdl"] = "male"
VoiceSetTranslate["models/player/combine_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_soldier_prisonguard.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_super_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/eli.mdl"] = "male"
VoiceSetTranslate["models/player/gman_high.mdl"] = "male"
VoiceSetTranslate["models/player/kleiner.mdl"] = "male"
VoiceSetTranslate["models/player/monk.mdl"] = "male"
VoiceSetTranslate["models/player/mossman.mdl"] = "female"
VoiceSetTranslate["models/player/magnusson.mdl"] = "male"
VoiceSetTranslate["models/player/police.mdl"] = "combine"
VoiceSetTranslate["models/player/artic.mdl"] = "male"
VoiceSetTranslate["models/player/leet.mdl"] = "male"
VoiceSetTranslate["models/player/guerilla.mdl"] = "male"
VoiceSetTranslate["models/player/phoenix.mdl"] = "male"
VoiceSetTranslate["models/player/gasmask.mdl"] = "combine"
VoiceSetTranslate["models/player/riot.mdl"] = "male"
VoiceSetTranslate["models/player/swat.mdl"] = "male"
VoiceSetTranslate["models/player/urban.mdl"] = "male"
VoiceSetTranslate["models/player/group01/female_01.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_02.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_03.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_06.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_07.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_01.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_02.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_03.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_06.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_07.mdl"] = "female"
VoiceSetTranslate["models/player/p2_chell.mdl"] = "female"
VoiceSetTranslate["models/player/chell.mdl"] = "female"
VoiceSetTranslate["models/player/group01/male_01.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_04.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_05.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_06.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_07.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_08.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_01.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_04.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_05.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_06.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_07.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_08.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_01.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_02.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_03.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_04.mdl"] = "male"

