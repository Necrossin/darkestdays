//Options!

//old
ROUNDLENGTH = 15*60

INTERMISSIONTIME = CreateConVar("dd_options_intermission_time", 30, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "How much voting end round should last (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_intermission_time", function(cvar, oldvalue, newvalue)
	INTERMISSIONTIME = tonumber( newvalue )
end)

SPAWNTIME = CreateConVar("dd_options_spawn_time", 4, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Player respawn time (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_spawn_time", function(cvar, oldvalue, newvalue)
	SPAWNTIME = tonumber( newvalue )
end)

MAX_ROUNDS = CreateConVar("dd_options_maxrounds", 2, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "How many round you can play on the same map."):GetInt()
cvars.AddChangeCallback("dd_options_maxrounds", function(cvar, oldvalue, newvalue)
	MAX_ROUNDS = tonumber( newvalue )
end)

//old
PICKUP_RESPAWNTIME = 20

AMMO_RESTORE = 0.5

SPAWN_PROTECTION = CreateConVar("dd_options_spawnprotection", 3.5, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Spawn protection time (in seconds)."):GetFloat()
cvars.AddChangeCallback("dd_options_spawnprotection", function(cvar, oldvalue, newvalue)
	SPAWN_PROTECTION = tonumber( newvalue )
end)

KOTH_HILL_TIME = CreateConVar("dd_options_koth_time", 5*60, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of time that you need to caprute a hill (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_koth_time", function(cvar, oldvalue, newvalue)
	KOTH_HILL_TIME = tonumber( newvalue )
end)

HTF_FLAG_TIME = CreateConVar("dd_options_htf_time", 4*60, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of time that you need to hold the flag (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_htf_time", function(cvar, oldvalue, newvalue)
	HTF_FLAG_TIME = tonumber( newvalue )
end)
HTF_RESPAWN_TIME = CreateConVar("dd_options_htf_flagrespawn", 10, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of time before HTF flag will respawn (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_htf_flagrespawn", function(cvar, oldvalue, newvalue)
	HTF_RESPAWN_TIME = tonumber( newvalue )
end)

//old
ASSAULT_TIME = 10*60

FFA_TIME = CreateConVar("dd_options_ffa_time", 10*60, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Free for All round length (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_ffa_time", function(cvar, oldvalue, newvalue)
	FFA_TIME = tonumber( newvalue )
end)

TDM_TIME = CreateConVar("dd_options_tdm_time", 12*60, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Team Deathmatch round length (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_tdm_time", function(cvar, oldvalue, newvalue)
	TDM_TIME = tonumber( newvalue )
end)

TDM_WIN_SCORE = CreateConVar("dd_options_tdm_kills", 60, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of kills to win in Team Deathmatch."):GetInt()
cvars.AddChangeCallback("dd_options_tdm_kills", function(cvar, oldvalue, newvalue)
	TDM_WIN_SCORE = tonumber( newvalue )
end)

TS_TIME = CreateConVar("dd_options_punchpocalypse_time", 8*60+30, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Punchpocalypse round length (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_punchpocalypse_time", function(cvar, oldvalue, newvalue)
	TS_TIME = tonumber( newvalue )
end)

TS_TIME = CreateConVar("dd_options_punchpocalypse_time", 8*60+30, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Punchpocalypse round length (in seconds)."):GetInt()
cvars.AddChangeCallback("dd_options_punchpocalypse_time", function(cvar, oldvalue, newvalue)
	TS_TIME = tonumber( newvalue )
end)

TS_NIGHTMODE = util.tobool(CreateConVar("dd_options_punchpocalypse_nightmode", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enable night mode for Punchpocalypse."):GetInt())
cvars.AddChangeCallback("dd_options_punchpocalypse_nightmode", function(cvar, oldvalue, newvalue)
	TS_NIGHTMODE = util.tobool( newvalue )
end)

//there is small admin menu for scoreboard by default
ADMIN_MENU = util.tobool(CreateConVar("dd_options_enable_admin_menu", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enable default admin menu in scoreboard. Disable it if you already have one, or something."):GetInt())
cvars.AddChangeCallback("dd_options_enable_admin_menu", function(cvar, oldvalue, newvalue)
	ADMIN_MENU = util.tobool( newvalue )
end)

//I'd leave this on by default, but there is always gonna be some greedy server owner bitching about how it's stopping him from stealing money from the players
ENABLE_OUTFITS = util.tobool(CreateConVar("dd_options_enable_outfits", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enable in-game hats/outfits."):GetInt())
cvars.AddChangeCallback("dd_options_enable_outfits", function(cvar, oldvalue, newvalue)
	ENABLE_OUTFITS = util.tobool( newvalue )
end)

TEAM_BALANCE = util.tobool(CreateConVar("dd_options_enable_team_balance", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enable auto team balancing, when someone leaves."):GetInt())
cvars.AddChangeCallback("dd_options_enable_team_balance", function(cvar, oldvalue, newvalue)
	TEAM_BALANCE = util.tobool( newvalue )
end)

MAX_VOTEMAPS = 6

TS_DEADLINE = 0.3 // if time <= time * (1 - deadline) then join thugs
TS_THUGS = 20 //% of people that needs to be thugs
TS_SPEED_OVER_TIME = 140

//old and unused
CONQUEST_TICKETS = 150
CONQUEST_TICKET_DRAIN_TIME = 5
CONQUEST_CAPTURE_TIME = 3
CONQUEST_MAX_POINTS = 3

ROUNDS_PER_GAMETYPE = CreateConVar("dd_options_rounds_to_lock", 3, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of rounds that can be played on same gametype, before it gets locked."):GetInt()
cvars.AddChangeCallback("dd_options_rounds_to_lock", function(cvar, oldvalue, newvalue)
	ROUNDS_PER_GAMETYPE = tonumber( newvalue )
end)

UNLOCKS_PER_GAMETYPE = CreateConVar("dd_options_rounds_to_unlock", 4, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of rounds that has to be played to unlock locked gametypes (EXCEPT FOR PUNCHPOCALYPSE)."):GetInt()
cvars.AddChangeCallback("dd_options_rounds_to_unlock", function(cvar, oldvalue, newvalue)
	UNLOCKS_PER_GAMETYPE = tonumber( newvalue )
end)

TS_UNLOCKS_PER_GAMETYPE = CreateConVar("dd_options_punchpocalypse_rounds_to_unlock", 6, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Amount of rounds that has to be played to unlock Punchpocalypse gametype."):GetInt()
cvars.AddChangeCallback("dd_options_punchpocalypse_rounds_to_unlock", function(cvar, oldvalue, newvalue)
	TS_UNLOCKS_PER_GAMETYPE = tonumber( newvalue )
end)

--ROUNDS_PER_GAMETYPE = 3
--UNLOCKS_PER_GAMETYPE = 4 //play at least one of something or dunno
		

IgnorePhysToMult = {
	"models/props_c17/lamp_standard_off01.mdl",
	"models/props_debris/concrete_spawnplug001a.mdl",
}

