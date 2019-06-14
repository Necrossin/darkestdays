game.AddParticles("particles/darkestdays_v10.pcf" ) //_v8

//some  particles
PrecacheParticleSystem( "muzzle_autorifles" )
PrecacheParticleSystem( "muzzle_machinegun" )
PrecacheParticleSystem( "muzzle_pistols" )
PrecacheParticleSystem( "muzzle_shotguns" )
PrecacheParticleSystem( "muzzle_smgs" )


PrecacheParticleSystem( "dd_blood_impact1" )
PrecacheParticleSystem( "dd_blood_impact2" )
PrecacheParticleSystem( "dd_blood_impact3" )
PrecacheParticleSystem( "dd_blood_headshot" )
PrecacheParticleSystem( "dd_blood_headshot_2" )
PrecacheParticleSystem( "dd_blood_big1" )
PrecacheParticleSystem( "dd_blood_big2" )
PrecacheParticleSystem( "dd_blood_big_gibsplash" )
PrecacheParticleSystem( "dd_blood_gib_trail" )
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
include("animations.lua")

TEAM_RED = 3
TEAM_BLUE = 4
TEAM_FFA = 5

TEAM_THUG = TEAM_RED

GM.Name 		= "Darkest Days"
GM.Author 		= "Necrossin"
GM.Version		= "v 14/06/2019"
GM.Email 		= ""
GM.Website 		= ""


team.SetUp(TEAM_RED, "Team Red", Color(250,40,40,255))
team.SetUp(TEAM_BLUE, "Team Blue", Color(0,121,250,192))
team.SetUp(TEAM_FFA, "Team FFA", Color(240,121,0,255))



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
	
	//if ent1:GetClass() == "projectile_crow" and ent2:GetClass() == "projectile_crow" or ent2:GetClass() == "projectile_crow" and ent1:GetClass() == "projectile_crow" then
		//return false
	//end
	
	return true
end

function GM:Move( pl, mv )
		
	if pl._efFrozen and IsValid(pl._efFrozen) then
		mv:SetMaxSpeed( math.abs( pl:GetMaxSpeed() ) * 0.75 )
	end
	
	/*if pl:IsGhosting() and not pl:IsGhostingWithPerk() then
		mv:SetMaxSpeed( math.abs( pl:GetMaxSpeed() ) * 0.75 )
	end*/
	
	if pl:IsCarryingFlag() then
		mv:SetMaxSpeed( math.abs( pl:GetMaxSpeed() ) * 0.85 )
	end
	
	if pl:IsDefending() then
		local mul = 1
		local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
		if wep and wep.BlockSpeed then
			mul = wep.BlockSpeed
		end
		local speed = math.abs( pl:GetMaxSpeed() ) * mul
		mv:SetMaxSpeed( speed )
		mv:SetMaxClientSpeed( speed )
	end
	
	if pl._efSlide and IsValid(pl._efSlide) then
		pl:SetGroundEntity(NULL)
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)
		mv:SetVelocity(mv:GetVelocity() * (1 - FrameTime() * 0.2))
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
	
	/*if pl:IsDashing() then
	
		if not pl.SaveDashVel then 
			pl.SaveDashVel = mv:GetVelocity()
		end
		
		
		local sp = 2400
		
			
		if !pl:IsOnGround() then
			sp = sp - 1200
		end
			
			
		if not pl._efDash.Normal then
				
			local norm 
				
			if math.abs( mv:GetForwardSpeed() ) < 1 and math.abs( mv:GetSideSpeed() ) < 1  then//mv:GetVelocity():Length() < 1
					norm = pl:GetForward()
			else
				norm = mv:GetVelocity():GetNormal()
			end
				
			if norm.z > 0.2 then
				norm.z = 0
			end
				
			pl._efDash.Normal = norm
		end
			
		mv:SetVelocity( pl._efDash.Normal * sp )
	else
		if pl.SaveDashVel then
			local vel = mv:GetVelocity()
			vel.z = -100//pl.SaveDashVel.z
			mv:SetVelocity( vel )
			pl.SaveDashVel = nil
		end
		
	end*/
	
end

function GM:PlayerFootstep( pl, pos, foot, snd, volume, filter ) 
	if pl:IsGhosting() or pl:IsDashing() then return true end
end

function GM:GetGametype()
	return self.Gametype or "none"
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

function TrueVisible(posa, posb)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
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

