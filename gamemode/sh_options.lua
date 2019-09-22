
GM.Gametypes = {}
GM.Gametypes["koth"] = {Name = "King of the Hill"}
GM.Gametypes["tdm"] = {Name = "Team Deathmatch"}
//GM.Gametypes["conquest"] = {Name = "Conquest"}
GM.Gametypes["htf"] = {Name = "Hold the Flag"}
//GM.Gametypes["assault"] = {Name = "Assault (still wip)"}
GM.Gametypes["ffa"] = {Name = "Free for All"}
GM.Gametypes["ts"] = {Name = "Punchpocalypse"}//,Hidden = true


//Stats!

PLAYER_DEFAULT_HEALTH = 125
PLAYER_DEFAULT_MANA = 60
PLAYER_DEFAULT_SPEED = 210
PLAYER_DEFAULT_RUNSPEED_BONUS = 50
PLAYER_DEFAULT_JUMPPOWER = 200
PLAYER_DEFAULT_MELEE_BONUS = 0
PLAYER_DEFAULT_MELEE_SPEED_BONUS = 0
PLAYER_DEFAULT_DODGE_BONUS = 0
PLAYER_DEFAULT_MAGIC_RESISTANCE_BONUS = 0
PLAYER_DEFAULT_AGILITY_DMG_BONUS = 0
PLAYER_DEFAULT_DEFENSE_DMG_BONUS = 0
PLAYER_DEFAULT_MAGIC_DMG_BONUS = 0
PLAYER_DEFAULT_MAGIC_CHANNELING_BONUS = 0
PLAYER_DEFAULT_MAGIC_REGEN_BONUS = 0
PLAYER_DEFAULT_BULLET_FALLOFF_BONUS = 0
PLAYER_DEFAULT_BULLET_CONSUME_BONUS = 0
PLAYER_DEFAULT_BULLET_SCAVENGER_BONUS = 0

//do not touch these
PLAYER_DEFAULT_RUNSPEED_BONUS_SQR = PLAYER_DEFAULT_RUNSPEED_BONUS ^ 2


SKILL_MAX_PER_TREE = 15
SKILL_MAX_TOTAL = 20

SKILL_XP_PER_KILL = 5
SKILL_XP_PER_VICTORY = 145

SKILL_XP_START = 20//5 //how much player has from start

SKILL_XP_INITIAL = 35
SKILL_XP_INCREASE_BY = 30
SKILL_XP_MULTIPLIER = 22//25
SKILL_XP_GAIN_MULTIPLIER = 4//2.5

LEVEL_MAX = 30



/*local exp = 0
local total = 0
for i=1,SKILL_MAX_TOTAL-SKILL_XP_START do
	exp = exp + SKILL_XP_INITIAL + SKILL_XP_INCREASE_BY*(i-1)
	total = total + exp
	//print("For "..i.." points = "..exp.." experience")
end*/
//print("Overall you need "..total.." experience")
//print("In other words it counts as: "..total/SKILL_XP_PER_KILL.." kills or "..total/SKILL_XP_PER_VICTORY.." rounds won")

local function test( lvl ) 
	
	local exp = 0
	
	for i=0, lvl do//math.max(self:GetTotalPoints()-SKILL_XP_START,1)self:GetTotalPoints()-SKILL_XP_START
		local mul = 1
	
		if i + SKILL_XP_START >= SKILL_MAX_TOTAL then
			mul = SKILL_XP_MULTIPLIER
		end
		exp = exp + SKILL_XP_INITIAL + SKILL_XP_INCREASE_BY * (i) * mul
	end
	
	return exp or SKILL_XP_INITIAL

end

for i = 0, LEVEL_MAX do
	
	//print("From Level "..(i).." to "..(i+1).." = "..test(i).. " XP required")

end


SKILL_DEFENSE_HEALTH_PER_LEVEL = 3
SKILL_DEFENSE_DAMAGE_PER_LEVEL = 0.75
SKILL_MAGIC_MANA_PER_LEVEL = 5
SKILL_STRENGTH_DAMAGE_PER_LEVEL = 1//1.75//0.65
SKILL_STRENGTH_MAGIC_RESISTANCE_PER_LEVEL = 2.35
SKILL_STRENGTH_MELEE_SPEED_PER_LEVEL = 0.02 //0.01
SKILL_STRENGTH_DODGE_PER_LEVEL = 0.027
SKILL_AGILITY_SPEED_PER_LEVEL = 3.2
SKILL_AGILITY_DAMAGE_PER_LEVEL = 0.5
SKILL_MAGIC_DAMAGE_PER_LEVEL = 3
SKILL_MAGIC_CHANNELING_PER_LEVEL = 0.03//0.024
SKILL_BULLET_FALLOFF_PER_LEVEL = 1.2//0.03
SKILL_BULLET_CONSUME_PER_LEVEL = 0.0135
SKILL_BULLET_SCAVENGER_PER_LEVEL = 0.046

//Fast reload
FAST_RELOAD_MIN = 0.32 //min/max fraction of actual reload time
FAST_RELOAD_MAX = 0.42


--Bullet damage
BULLET_DAMAGE_MIN = 0.5//0.45
BULLET_DAMAGE_BASE = 1
BULLET_DAMAGE_MAX = 1

BULLET_DISTANCE_FALLOFF_MIN = 0
BULLET_DISTANCE_FALLOFF_MAX = 1024

SILENCER_REDUCTION = 0.85

MaxRangedStats = {0,0,0,0,0} //damage,rof,accuracy, range,recoil
MaxMeleeStats = {0,0,0} //damage,speed,reach
MaxSpellStats = {0,0}//mana, damage

MaxPlayerStats = {
	PLAYER_DEFAULT_HEALTH + SKILL_DEFENSE_HEALTH_PER_LEVEL * SKILL_MAX_PER_TREE,
	185,//PLAYER_DEFAULT_MANA + SKILL_MAGIC_MANA_PER_LEVEL * SKILL_MAX_PER_TREE,
	PLAYER_DEFAULT_SPEED + SKILL_AGILITY_SPEED_PER_LEVEL * SKILL_MAX_PER_TREE,
}



hook.Add("Initialize","SetupSomeStuff",function()
	/*local basewep = weapons.Get("dd_crowbar")

	if basewep then
		MELEE_BASE_DAMAGE = basewep.MeleeDamage
		MELEE_BASE_RANGE = basewep.MeleeRange
		MELEE_BASE_SPEED = basewep.Primary.Delay
	end*/
	
	//MeleeStats = {}
	
	for wep,tbl in pairs(Weapons) do
	
		if wep == "empty" then continue end
		
		if tbl.Melee then
			local swep = weapons.Get(wep)
			
			//Define max stats
			if swep.MeleeDamage >= MaxMeleeStats[1] then
				MaxMeleeStats[1] = swep.MeleeDamage
			end
			
			if swep.Primary.Delay+swep.SwingTime >= MaxMeleeStats[2] then
				MaxMeleeStats[2] = swep.Primary.Delay+swep.SwingTime
			end
			
			if swep.MeleeRange >= MaxMeleeStats[3] then
				MaxMeleeStats[3] = swep.MeleeRange
			end
			
			
			tbl.Stats = { 
				[1] = {"Damage: %G", swep.MeleeDamage, Color(254,2,1,255)}, 
				[2] = {"Speed", swep.Primary.Delay+swep.SwingTime, Color(0,255,0,255),true}, 
				[3] = {"Reach", swep.MeleeRange, Color(254,254,0,255)}
			}
			
		else
			
			local swep = weapons.Get(wep)
			
			//Define max stats
			if swep.Primary.Damage * swep.Primary.NumShots >= MaxRangedStats[1] then
				MaxRangedStats[1] = math.Clamp(swep.Primary.Damage * swep.Primary.NumShots,0,60)
			end
			
			if swep.Primary.Delay and 60/swep.Primary.Delay >= MaxRangedStats[2] then
				MaxRangedStats[2] = 60/swep.Primary.Delay
			end
			
			if swep.Primary.Cone and swep.Primary.Cone >= MaxRangedStats[3] then
				MaxRangedStats[3] = swep.Primary.Cone
			end
			
			if swep.Caliber and CaliberFalloffDistance[swep.Caliber] and math.ceil(CaliberFalloffDistance[swep.Caliber]*0.0254) >= MaxRangedStats[4] then
				MaxRangedStats[4] = math.ceil(CaliberFalloffDistance[swep.Caliber]*0.0254)
			end
			
			if not swep.IsShotgun and swep.Primary.Recoil and swep.Primary.Recoil * ( swep.Primary.RecoilKick or 0.1 ) >= MaxRangedStats[5] then
				MaxRangedStats[5] = swep.Primary.Recoil + swep.Primary.Recoil * ( swep.Primary.RecoilKick or 0.1 )
			end
			
			tbl.Ranged = true
			
			tbl.Stats = { 
				[1] = {"Damage: %G", swep.Primary.Damage * swep.Primary.NumShots, Color(254,2,1,255)}, 
				[2] = {"Rate of fire: %i RPM", math.ceil(60/(swep.Primary.Delay or 1)), Color(0,255,0,255)}, 
				[3] = {"Accuracy", swep.Primary.Cone or 0, Color(254,254,0,255), true},
				[4] = {"Range: %i meters", swep.Caliber and CaliberFalloffDistance[swep.Caliber] and math.ceil(CaliberFalloffDistance[swep.Caliber]*0.0254) or 0, Color(254,254,0,255)},
				[5] = {"Recoil", swep.IsShotgun and 0 or ( swep.Primary.Recoil + swep.Primary.Recoil * ( swep.Primary.RecoilKick or 0.1 ) ) or 0, Color(254,254,0,255)},
			}
			
			if swep.Caliber then
				tbl.Caliber = swep.Caliber
			end

		end
		
		for i=0, table.maxn(LevelUnlocks) do
			if LevelUnlocks[i] then
				for _,v in pairs(LevelUnlocks[i]) do
					if wep == v then
						tbl.Level = i
						break
					end
				end
			end
		end

	end
	
	for sp,tbl in pairs(Spells) do
		local spell = scripted_ents.Get("spell_"..sp)
		
		if spell.Mana then
			
			if spell.Mana >= MaxSpellStats[1] then
				MaxSpellStats[1] = spell.Mana
			end
			
			if spell.Damage and spell.Damage >= MaxSpellStats[2] then
				MaxSpellStats[2] = spell.Damage
			end
			
			tbl.Spell = true
			
			tbl.Stats = { 
				[1] = {"Mana: %i", spell.Mana, color_white},
				[2] = {"Base damage: %i", spell.Damage or 0, color_white},
			}
		
			/*local add = "Mana: "..spell.Mana
			if tbl.Description then
				tbl.Description = add.."\n"..tbl.Description
			else
				tbl.Description = add
			end*/
		end
		
		for i=0, table.maxn(LevelUnlocks) do
			if LevelUnlocks[i] then
				for _,v in pairs(LevelUnlocks[i]) do
					if sp == v then
						tbl.Level = i
						break
					end
				end
			end
		end
		
	end
	
	for p,tbl in pairs(Perks) do
		for i=0, table.maxn(LevelUnlocks) do
			if LevelUnlocks[i] then
				for _,v in pairs(LevelUnlocks[i]) do
					if p == v then
						tbl.Level = i
						break
					end
				end
			end
		end	
	end
	
	
end)



Skills = {}

/*Skills["defense"] = {
	[5] = "healthregen",
	[10] = "bloodpact",
	[15] = "grit",
}*/

Skills["magic"] = {
	
	[1] = "mbasic",
	[5] = "qmanaregen",
	[10] = "manachannel",
	[15] = "magicshield",

}

Skills["strength"] = {
	
	[1] = "stbasic",
	[5] = "bulletblock",
	[10] = "bloodthirst",
	[15] = "grit",//"rage",

}

//aka Gun Mastery
Skills["agility"] = {
	
	[1] = "gmbasic",
	[5] = "fastreload",
	[10] = "scavenger",
	[15] = "grenade",

	//[5] = "walljumpslide",
	//[10] = "ledgeroll",
	//[15] = "wallrun",
}

Abilities = {
	
	//Agility
	//["ledgeroll"] = {Name = "Ledge Grabbing/Roll", Pr = "Ability to pull yourself onto small\nledges\nAbility to negate some fall damage\nby rolling",Description = "\nPress 'E' while standing under ledge\nto pull yourself onto it.\nWhile falling, crouch before hitting\nthe ground to roll!", OnSet = function(pl) pl._SkillLedgeGrab = true pl._SkillRoll = true end, OnReset = function(pl) pl._SkillLedgeGrab = false pl._SkillRoll = false end  },
	//["walljumpslide"] = {Name = "Wall Jump/Slide", Pr = "Ability to wall-jump\nJump power is based on your velocity\n\nAbility to slide when sprinting", Description = "\nDouble press jump button near a wall\nto perform a wall-jump.\nHold 'E' while facing a wall to perform\na wall-jump with 180 degrees turn.\n\nCrouch when sprinting to slide.", OnSet = function(pl) pl._SkillWJ = true; pl._SkillSlide = true end, OnReset = function(pl) pl._SkillWJ = false; pl._SkillSlide = false end},
	//["wallrun"] = {Name = "Wall Run", Pr = "Ability to sprint on wall surfaces\nWallrun power is based on your velocity",Description = "\nJump near wall while sprinting\nto start wall running.", OnSet = function(pl) pl:SetEffect("wallrun") end},
	
	//Gun Mastery
	["gmbasic"] = {Name = "Unlock Gun Mastery", Pr = "- Grants chance not to consume ammo\n- Increased bullet damage for\nsmgs/rifles/pistols/shotguns", Co = "",Description = "",OnSet = function(pl) end, OnReset = function(pl) end},
	["fastreload"] = {Name = "Fast Reload", Pr = "- 70% faster reload speed", Co = "- Only works with pistols/smgs/rifles",Description = "",OnSet = function(pl) pl._SkillFastReload = true; if SERVER then pl:SendLua("LocalPlayer()._FastReload = true") end end, OnReset = function(pl) pl._SkillFastReload = false; pl:SendLua("LocalPlayer()._FastReload = nil") end},
	["scavenger"] = {Name = "Scavenger", Pr = "- Restore small amount of ammo on kill",Description = "",OnSet = function(pl) pl._SkillScavenger = true end, OnReset = function(pl) pl._SkillScavenger = false end, PassiveDesc = function( p ) return string.format("BONUS: %i%% of clip on kill", p*SKILL_BULLET_SCAVENGER_PER_LEVEL*100) end},
	["grenade"] = {Name = "Grenade", Mat = Material( "darkestdays/hud/grenade.png" ), Pr = "- Throw a grenade by pressing 'G'\n- Grenade recharges after 12 seconds", Co = "", Description = "",OnSet = function(pl) if SERVER then pl:SetEffect("grenade") end end},
	
	
	//Magic
	["mbasic"] = {Name = "Unlock Advanced Magic", Pr = "- Increased magic damage\n- Increased mana pool", Co = "",Description = "",OnSet = function(pl) end, OnReset = function(pl) end},
	["qmanaregen"] = {Name = "Rapid Mana Regen", Pr = "- Ability to rapidly regenerate mana\nafter casting a spell",OnSet = function(pl) pl._SkillQuickRegen = true end, OnReset = function(pl) pl._SkillQuickRegen = false end},
	["manachannel"] = {Name = "Mana Channeling", Pr = "- Returns some of magic damage done\nas mana", OnSet = function(pl) pl._SkillManaCh = true end, OnReset = function(pl) pl._SkillManaCh = false end, PassiveDesc = function( p ) return string.format("BONUS: %i%% of magic damage returned as mana", p*SKILL_MAGIC_CHANNELING_PER_LEVEL*100) end},
	["magicshield"] = {Name = "Magic Shield", Pr = "- Uses 35% of mana as energy\n- Absorbs 30% of incoming non-melee\ndamage",Co = "- Does NOT absorbs self-damage\n- Has 25 seconds cooldown, once\ndepleted",OnSet = function(pl) pl:SetEffect("magic_shield") end},
	
	//Defense
	["healthregen"] = {Name = "Health Regeneration", Pr = "Ability to slowly regenerate\nyour health", Description = "Regeneration rate is increased while\nstanding still.",OnSet = function(pl) pl._SkillHPRegen = true end, OnReset = function(pl) pl._SkillHPRegen = false end},
	["bloodpact"] = {Name = "Blood Pact", Pr = "Killing an enemy restores some\nhealth for nearby allies", Description = "",OnSet = function(pl) pl._SkillBloodPact = true end, OnReset = function(pl) pl._SkillBloodPact = false end},
	
	//Strength
	["stbasic"] = {Name = "Unlock Strength", Pr = "- Increased melee damage\n- Grants resistance to magic damage\n- Increased melee speed", Co = "- Works only when you wield melee",Description = "",OnSet = function(pl) end, OnReset = function(pl) end},
	["bulletblock"] = {Name = "Bullet Blocking", Pr = "- Gives 80% chance to block incoming\nbullet damage with your melee weapons\n- Unlocks passive Dodge ability\n- Grants a chance to avoid bullets when\nyou sprint with melee\n- Also increases your health by 10",Co = "", Description = "Hold 'Reload' button to block incoming\nbullets.",OnSet = function(pl) pl._SkillBulletBlock = true; pl._DefaultHealth = pl._DefaultHealth + 10; end, OnReset = function(pl) pl._SkillBulletBlock = false end, PassiveDesc = function( p ) return string.format("BONUS: %i%% chance to dodge bullets", p*SKILL_STRENGTH_DODGE_PER_LEVEL*100) end},
	["bloodthirst"] = {Name = "Blood Thirst", Pr = "- Restore small amount of health\nby dealing melee damage\n- Also increases your speed by 15",Co = "- Does not stack with damage", Description = "\"Berzerking!\"",OnSet = function(pl) pl._SkillBloodThirst = true; pl._DefaultSpeed = pl._DefaultSpeed + 15; end, OnReset = function(pl) pl._SkillBloodThirst = false end},
	//["rage"] = {Name = "Rage", Pr = "- Increases melee damage as player\ngets injured",Co = "- Works only at below 50% of health",OnSet = function(pl) pl._SkillRage = true end, OnReset = function(pl) pl._SkillRage = false end},
	["grit"] = {Name = "Grit", Pr = "- 20% chance to ignore damage that\n would otherwise kill you\n- Also increases your health by 25", Co = "- Not applied to self-damage\n- Works only when you wield melee", Description = "",OnSet = function(pl) pl._SkillGrit = true; pl._DefaultHealth = pl._DefaultHealth + 25; end, OnReset = function(pl) pl._SkillGrit = false end},

}


//calibers
/*
5.56 mm: M4A1 8 Damage
5.7 mm: P90 8.2 Damage
7.62 mm: ak47, AUG 9 Damage
9 mm: MP5, Dual elites 11 Damage
11.43 mm: UMP, USP 13 Damage
11.20 mm: Magnum 35 Damage
*/

/*
Max damage (60-70) = 157
Desired damage  ( ? ) = add stuff

*/

//Caliber
CAL_5_56 = 1
CAL_5_7 = 2
CAL_7_62 = 3
CAL_9 = 4
CAL_11_43 = 5
CAL_11_20 = 6
CAL_12_GAUGE = 7

CaliberDamage = {
	[CAL_5_56] = 17,
	[CAL_5_7] = 10,
	[CAL_7_62] = 19,
	[CAL_9] = 13,
	[CAL_11_43] = 18,
	[CAL_11_20] = 60,
	[CAL_12_GAUGE] = 7,
}

// Faloff distance
CaliberFalloffDistance = {
	
	[CAL_5_56] = 1024,
	[CAL_5_7] = 200,
	[CAL_7_62] = 900,
	[CAL_9] = 300,
	[CAL_11_43] = 300,
	[CAL_11_20] = 1000,
	[CAL_12_GAUGE] = 50,//110
	
}

CaliberIcons = {

	[CAL_5_56] = "N",
	[CAL_5_7] = "S",
	[CAL_7_62] = "V",
	[CAL_9] = "R",
	[CAL_11_43] = "M",
	[CAL_11_20] = "T",
	[CAL_12_GAUGE] = "J",
	
}

//I really should've made a single table

CaliberAmmo = {

	[CAL_5_56] = 110,
	[CAL_5_7] = 100,
	[CAL_7_62] = 90,
	[CAL_9] = 150,
	[CAL_11_43] = 90,
	[CAL_11_20] = 30,
	[CAL_12_GAUGE] = 20,
	
}


//Weapons

Weapons = {
	
	["dd_m3super90"] = {
		Name = "M3",
		Mat = Material( "VGUI/gfx/VGUI/m3" ),
		Co = "-25 max speed on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25; end
	},
	["dd_riot"] = {
		Name = "\"Riot\" Shotgun",
		Mat = Material( "vgui/gfx/vgui/xm1014" ),
		Special = "\"Four Days Grace\"",Pr = "+33% clip size", 
		Co = "-25 max speed on wearer\n-10% less pellets", 
		Description = "Now with full-auto mode!",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25; end
	},
	["dd_mp5"] = {
		Name = "MP5",
		Mat = Material( "VGUI/gfx/VGUI/mp5" ),
		Pr = "+10 max speed on wearer\nIncreased accuracy and fire rate\nwhen diving", Co = "-15 max health on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_m4"] = {
		Name = "M4A1",
		Mat = Material( "VGUI/gfx/VGUI/m4a1" ),
		Co = "-20 max speed on wearer\n-30 max mana on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20; pl._DefaultMana = pl._DefaultMana - 30 end
	},
	["dd_ak47"] = {
		Name = "AK-47",
		Mat = Material( "VGUI/gfx/VGUI/ak47" ),
		Co = "-30 max speed on wearer\n-35 max mana on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 30; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["dd_usp"] = {
		Name = "USP",
		Secondary = true,
		Mat = Material( "VGUI/gfx/VGUI/usp45" ), 
		Pr = "+10 max speed on wearer",Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10 end
	},
	["dd_sparkler"] = {
		Name = "Sparkler",
		Mat = Material( "VGUI/gfx/VGUI/fiveseven" ), 
		Pr = "Uses mana instead of bullets\nNo reload required\n+15 max mana on wearer",
		Co = "-20 max health on wearer", 
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana + 15; pl._DefaultHealth = pl._DefaultHealth - 20 end
	},
	["dd_revolver"] = {
		Name = "Revolver",
		Mat = Material( "darkestdays/icons/revolver_256x128.png", "smooth" ), 
		Secondary = true,
		Description = ""
	},
	["dd_elites"] = {
		Name = "Dual Elites",
		Secondary = true,
		AdminFree = true,
		Mat = Material( "VGUI/gfx/VGUI/elites" ), 
		Pr = "Can attack when sprinting\n+20% damage done when sprinting\n+50% damage done when diving\n+10 max speed on wearer",
		Co = "-15 max health on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_p90"] = {
		Name = "P90",
		Mat = Material( "VGUI/gfx/VGUI/p90" ),
		Pr = "+10 max speed on wearer", 
		Co = "-15 max health on wearer",
		Description = "",OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_launcher"] = {
		Name = "Lil' Tube",
		Mat = Material( "darkestdays/icons/tube_256x128.png", "smooth" ), 
		Co = "-35 max speed on wearer", 
		Description = "CAUTION: Keep away from 12-year\nold kids",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 35 end
	},
	["dd_ump"] = {
		Name = "UMP-45",
		Mat = Material( "VGUI/gfx/VGUI/ump45" ),
		Pr = "+10 max speed on wearer",Co = "-15 max health on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15 end
	},
	["dd_xbow"] = {
		Name = "XBOW", 
		Mat = Material( "darkestdays/icons/xbow_256x128.png", "smooth" ), 
		Pr = "Fires high velocity bolts\nGains up to 5x damage based\non distance travelled",
		Co = "Slow rate of fire\n-15 max speed on wearer", 
		Description = "Hold Reload button to zoom", 
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15 end
	},
	["dd_spas12"] = {
		Name = "Boomstick", 
		Mat = Material( "darkestdays/icons/boomstick_256x128.png", "smooth" ), 
		Co = "-30% clip size\n-35 max speed on wearer", 
		Description = "SPAS-12, that acts like\na double-barrele dshotgun,\nfor whatever reason.",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 35; end
	},
	["dd_dsword"] = {
		Name = "Damascus Sword",
		Melee = true,
		Mat = Material( "darkestdays/icons/dsword_256x128.png", "smooth" ), 
		Co = "-15 max mana on wearer",
		Special = "\"Sword goes in - guts come out\"",
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana - 15 end
	},
	["dd_crowbar"] = {
		Name = "Crowbar",
		Melee = true,
		Pr = "+50% extra damage done to enemies\nthat are above 50% of health", 
		Mat = Material( "darkestdays/icons/crowbar_256x128.png", "smooth" ), 
		Description = "If only you could hunt down the owner"
	},
	["dd_rebar"] = {
		Name = "Rebar",
		Melee = true,
		Mat = Material( "darkestdays/icons/rebar_256x128.png", "smooth" ),
		Pr = "+160% damage done on first hit", 
		Co = "-35% damage done on rest\n-20 max speed on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20 end
	},
	["dd_axe"] = {
		Name = "Axe",
		Melee = true,
		Mat = Material( "darkestdays/icons/axe_256x128.png", "smooth" ),
		Pr = "+35% extra damage when owner is\nbelow 50% of max health",
		Description = "Perfect for cutting zombies."
	},
	["dd_fists"] = {
		Name = "Fists",
		Melee = true,
		Pr = "Chance to deal critical damage\n+25 max sprint speed", 
		Co = "Can only block fists", 
		Description = "", 
		OnSet = function(pl) pl._DefaultRunSpeedBonus = pl._DefaultRunSpeedBonus + 25 end
	},
	["dd_cleaver"] = {
		Name = "Cleaver",
		Melee = true,
		Mat = Material( "darkestdays/icons/cleaver_256x128.png", "smooth" ),
		Pr = "Triple damage on backstab", 
		Co = "-15 max health on wearer\n-20% block power",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_trafficlight"] = {
		Name = "Traffic Light",
		Melee = true,
		Mat = Material( "darkestdays/icons/trafficlight_256x128.png", "smooth" ), 
		Pr = "+50% extra damage done to\nsprinting enemies",
		Co = "-20 max speed on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20 end
	},
	["dd_wand"] = {
		Name = "Magic Wand",
		Melee = true,
		Mat = Material( "darkestdays/icons/wand_256x128.png", "smooth" ), 
		Pr = "50% of bonus magic damage\nreturned as health\n+45 max mana on wearer\nSlightly increased mana regen", 
		Co = "Limits primary weapon to 1 clip\nNo blocking\n-25 max health on wearer",
		Special = "\"I'm a WHAT?!\"",
		OnSet = function(pl) pl._DefaultMagicRegenBonus = pl._DefaultMagicRegenBonus + 0.1 ;pl._DefaultMana = pl._DefaultMana + 45; pl._DefaultHealth = pl._DefaultHealth - 25; pl:RemoveAllAmmo() end
	}, 
	["dd_eyelander"] = {
		Name = "Highlander",
		Mat = Material( "darkestdays/icons/highlander_256x128.png", "smooth" ), 
		Melee = true,
		Pr = "Temporary speed boost on kill", 
		Co = "-30 max health on wearer\n-20 max speed on wearer",
		Description = "",
		Special = "\"Don't you guys have swords?\"",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 30; pl._DefaultSpeed = pl._DefaultSpeed - 20 end
	},
	["dd_katana"] = {
		Name = "Katana", 
		Mat = Material( "darkestdays/icons/katana_256x128.png", "smooth" ), 
		Melee = true,
		Pr = "+15 max speed on wearer", 
		Co = "-20 max health on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed + 15 end
	},
	--["dd_zweihander"] = {Name = "Zweihander",Mat = Material("backpack/weapons/c_models/c_claidheamohmor/c_claidheamohmor_large"), Melee = true,Pr = "+15% melee power", Co = "-20 max health on wearer\n-25 max speed on wearer",Description = "",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed - 25 end},
	["dd_striker"] = {
		Name = "\"Striker\" Minigun",
		Mat = Material( "darkestdays/icons/striker_256x128.png", "smooth" ),
		Pr = "It is a pretty big gun", 
		Co = "Cannot use spells\n-65 max speed on wearer\nUnable to sprint\n-70% magic shield capacity",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 65; pl._DefaultRunSpeedBonus = 0 end
	},
	["dd_sledge"] = {
		Name = "Mr Sledge 3.0", 
		Melee = true,
		Mat = Material( "darkestdays/icons/sledge_256x128.png", "smooth" ), 
		Pr = "Can deal some damage through blocks", 
		Co = "-25 max speed on wearer\n25% slower speed when swinging\n30% slower speed when blocking",
		Description = "",
		Special = "\"Size does not matter\"",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25 end
	},
	["dd_aug"] = {
		Name = "AUG",
		Mat = Material( "VGUI/gfx/VGUI/aug" ),
		Co = "-15 max speed on wearer\n-35 max mana on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["dd_basher"] = {
		Name = "Baseball Bat", 
		Mat = Material( "darkestdays/icons/bat_256x128.png", "smooth" ), 
		Melee = true, 
		Pr = "+40% damage done to Thugs\nDrains 15 enemy mana on hit\nStrong knockback",
		Co = "-25 max mana on wearer",
		Description = "",
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana - 25 end
	},
	--["dd_inquisitor"] = {Name = "Inquisitor", Mat = Material("backpack/weapons/c_models/c_scout_sword/c_scout_sword_large"),Melee = true, Pr = "+10 max health on wearer", Co = "-30 max mana on wearer",Description = "", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 10; pl._DefaultMana = pl._DefaultMana - 30; end},
	["dd_famas"] = {
		Name = "FAMAS",
		Mat = Material( "VGUI/gfx/VGUI/famas" ),
		Co = "-30 max speed on wearer\n-35 max mana on wearer", 
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 30; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["empty"] = {
		Name = "No primary",
		Co = "", 
		Description = "",
		OnSet = function(pl) end
	},

	//["dd_swordgun"] = {Name = "Sword Gun",Pr = "Shoots fast-travelling knives", Co = "-50% clip size",Description = "\"You always appreciate my work\""},
}

//Spells

Spells = {
	
	["firebolt"] = {Name = "Fire Bolt",Mat = Material( "darkestdays/hud/firebolt.png" ), Pr = "- Can ignite cyclone traps", Co = "", Description = ""},
	["electrobolt"] = {Name = "Electro Bolt",Mat = Material( "darkestdays/hud/ebolt.png" ), Pr = "- Can electrocute cyclone traps", Co = "", Description = ""},
	["aerodash"] = {Name = "Aero Dash",Mat = Material( "darkestdays/hud/aerodash.png" ), Pr = "- Charge up to launch yourself\n- Enemies take blunt damage\non hit at full charge\n- More damage against frozen enemies", Co = "- 50% less travel distance with\nheavy weapons equipped\nor in Punchpocalypse", Description = ""},
	["teleportation"] = {Name = "Teleportation",Mat = Material( "darkestdays/hud/teleportation.png" ), Pr = "- Teleport yourself on short\ndistance\n- Teleport upwards by looking\nat ceilings", Co = "- Drains mana over distance", Description = ""},
	["cyclonetrap"] = {Name = "Cyclone Trap",Mat = Material( "darkestdays/hud/cyclonetrap.png" ), Pr = "- Launches victim upwards\n- Increased damage if victim hits ceilings\n- Can be charged by some spells", Co = "- Has a 0.7 seconds fuse time\n- Owner is not immune to the trap", Description = ""},
	["winterblast"] = {Name = "Winter Blast",Mat = Material( "darkestdays/hud/winterblast.png" ), Pr = "- Slows down victim\n- Frozen enemies will take more damage\n- Can charge cyclone traps", Co = "- Frozen enemies will not drop orbs", Description = ""},
	["toxicbreeze"] = {Name = "Toxic Breeze",Mat = Material( "darkestdays/hud/toxicbreeze.png" ), Pr = "- Creates a cloud of toxic gas\n- Gas rapidly damages anyone within\nthe cloud", Co = "- Owner is not immune to the gas", Description = ""},
	//["ghosting"] = {Name = "Ghosting",Mat = Material( "darkestdays/hud/ghosting.png" ), Pr = "- Grants temporary invisibility\n- Works as long as you hold RMB", Co = "", Description = ""},
	["telekinesis"] = {Name = "Telekinesis",Mat = Material( "darkestdays/hud/telekinesis.png" ), Pr = "- Pickup and throw objects", Co = "- Drains mana over time",Description = ""},
	["bloodtrap"] = {Name = "Blood Trap",Mat = Material( "darkestdays/hud/bloodtrap.png" ), Pr = "- Creates a nasty trap on ceilings", Co = "- Requires low ceilings\n- Owner is not immune to the trap", Description = ""},
	["firebolt2"] = {Name = "Flame Stream",Mat = Material( "darkestdays/hud/firebolt2.png" ), Pr = "- Portable flamethrower\n- Can ignite cyclone traps", Co = "- High usage of mana", Description = ""},
	["scorn"] = {Name = "Scorn",Mat = Material( "darkestdays/hud/scorn.png" ), Pr = "- Creates a ball of dark energy\n- Ball will bounce off walls\n - Accumulates damage via bouncing\n- Can penetrate 1 target", Co = "",Description = ""},
	//["cotn"] = {Name = "Curse of the Night",Mat = Material( "darkestdays/hud/cotn.png" ), Pr = "- Become a crow for few seconds", Co = "- You will die in cramped areas",Description = ""},
	["murderofcrows"] = {Name = "Murder of Crows",Mat = Material( "darkestdays/hud/murderofcrows.png" ), Pr = "- Summon a flock of 6 crow companions\n- Crows will attack all nearby enemies", Co = "- Only one active flock at a time\n- Crows dissapear after 20 seconds\n- Crows will die from ANY damage", Description = ""},
	["cursedflames"] = {Name = "Cursed Flames",Mat = Material( "darkestdays/hud/cursedflames.png" ), Pr = "- Create 4 small homing fireballs", Co = "- No damage done on first half a second\n- Owner is not immune to damage", Description = ""},
	["barrier"] = {Name = "Barrier",Mat = Material( "darkestdays/hud/barrier.png" ), Pr = "- Deploy 3 magic barriers for 6 seconds\n- Caster is able to shoot through\n- Barrier absorbs all incoming damage", Co = "- Doesn't blocks player movement",Description = ""},
	["raiseundead"] = {Name = "Raise Undead",Mat = Material( "darkestdays/hud/raiseundead.png" ), Pr = "- Raise an undead AntGuard for\nfew seconds", Co = "- Necromancy: Requires an orb to cast",Description = ""},
	["gravitywell"] = {Name = "Gravity Well",Mat = Material( "darkestdays/hud/gravitywell.png" ), Pr = "- Pulls nearby props towards\nyour enemies", Co = "",Description = ""},
	["cure"] = {Name = "Cure",Mat = Material( "darkestdays/hud/cure.png" ), Pr = "- Creates a healing cloud\n- Owner gains health per\neach healed teammate", Co = "- Owner cant be healed directly\nby cloud (except in ffa)",Description = ""},
	["meatbomb"] = {Name = "Meat Bomb",Mat = Material( "darkestdays/hud/meatbomb.png" ), Pr = "- Throw a bouncing ball of meat\nthat explodes after a while\n-Can be attached to teammates",Description = ""},
}

Perks = {
	["hpregen"] = {Name = "Health Regeneration",Pr = "Ability to slowly regenerate\nyour health\n+15 health on wearer", Co = "-25 max speed\n-50% healing from health orbs", Description = "Regeneration rate is increased while\nstanding still.", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 15; pl._DefaultSpeed = pl._DefaultSpeed - 25;  end},
	//["bff"] = {Name = "BFF", Pr = "Killing an enemy restores some\nhealth for nearby allies", Co = "-50% health gained from orbs\n-15 max speed",OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15 end},
	["thug"] = {Name = "Thug",AdminFree = true,Special = "Class mod: Overrides skill trees/loadout\nGains changes from builds", Pr = "Become the mighty thug!\n200% max health\nDeal 3x fall damage to anything\nyou land on", Co = "-20 max speed\nLimited parkour\nCan not carry flag\n-50% healing from health orbs", Description = "Hold RMB for a charge attack!\nPress jump button to launch\nyourself upwards when charging!", OnSet = function(pl) pl:SetEffect("thug") end},
	//["fireandfury"] = {Name = "Fire and Fury", PrColor = Color(235,93,0,255), Pr = "+5%(+15%) fire damage done\n(+20%) damage resistance\n20% chance to light yourself on fire\nwhen dealing fire damage", Co = "+10% bullet damage taken\n+120% cold damage taken", Description = "Values in (brackets) when owner is\non fire"},
	//["berserker"] = {Name = "Berserker", Pr = "+10% magic damage resistance\n+3% more melee damage", Co = "-20 max mana\n-25% bullet damage done", Description = "",OnSet = function(pl) pl._DefaultMResBonus = pl._DefaultMResBonus + 10; pl._DefaultMeleeBonus = pl._DefaultMeleeBonus + 3; pl._DefaultMana = pl._DefaultMana - 20 end},
	//["houdini"] = {Name = "Houdini", Pr = "+66% Ghosting duration\nNo speed reduction while Ghosting\n+15 max speed", Co = "-20 max health", Description = "",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed + 15; end},
	["ghosting"] = {Name = "Ghosting", Mat = Material( "darkestdays/hud/ghosting.png" ), Pr = "Hold sprint button to become invisible\n+50% more speed when invisible", Co = "Drains mana when active\n-20 max health", Description = "",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20 end},
	["adrenaline"] = {Name = "Adrenaline", Pr = "Get adrenaline orbs on kills\nOrbs restore some hp/mana and\n provide temporary damage boost", Co = "Can't pick up health/mana orbs",OnSet = function(pl) end},
	["blank"] = {Name = "No perk", Description = "If you dont need any perk"},
	["martialarts"] = {Name = "Martial Arts", Special = "Weapon mod: Augments your fists and\nbreaks your fingers", Pr = "Cut people with bare hands\nDropkicks to the face", Co = "Vulnerability after dropkick", Description = "Attack when sprint-jumping to perform\na drop kick.", OnSet = function(pl) if SERVER then pl:SendLua("LocalPlayer()._MartialArts = true") end end, OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._MartialArts = nil") end end},
	["dash"] = {Name = "Dash", Special = "Press sprint to dash in any direction\nMANA SICKNESS: Requires at least 25\nactive mana per dash\n", Pr = "Two-Handed weapons: press attack\nwhile dashing forward, to perform\na dash attack", Co = "Costs 25% of your mana per dash\nCosts even more mana per dash attack\n-15 max health",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = 4 LocalPlayer()._ShiftCap = 25") end end, OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = nil LocalPlayer()._ShiftCap = nil") end end},
	["crow"] = {Name = "Crow Master",Mat = Material( "darkestdays/hud/cotn.png" ), Special = "Press sprint to become a crow\nfor a few seconds\nMANA SICKNESS: Requires at least 40\nactive mana per use\n", Pr = "Doubles damage of Murder of Crows", Co = "Costs 50% of your mana\nYou can die in cramped areas\nCan not regenerate mana\nwhilst in crow form",OnSet = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = 2 LocalPlayer()._ShiftCap = 40") end end, OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = nil LocalPlayer()._ShiftCap = nil") end end},
	["transcendence"] = {Name = "Transcendence", Pr = "Doubles Magic Shield absorption\nReduces Magic Shield recharge time\ndown to 10 seconds\n50% of max mana as energy", Co = "-20 max health",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20 end},
}

//Small class-like presets
Builds = {
	["default"] = {Name = "Default", Pr = "No downsides", Co = "No bonuses", OnSet = function(pl) end},
	["healthy"] = {Name = "Healthy", Pr = "More health", Co = "Less speed/mana", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 15; pl._DefaultSpeed = pl._DefaultSpeed - 15; pl._DefaultMana = pl._DefaultMana - 15 end},// pl._DefaultHealth = pl._DefaultHealth + 20;
	["agile"] = {Name = "Agile", Pr = "More speed", Co = "Less health/mana", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; pl._DefaultSpeed = pl._DefaultSpeed + 15;  pl._DefaultMana = pl._DefaultMana - 15; end},//pl._DefaultHealth = pl._DefaultHeatlh - 10;
	["arcane"] = {Name = "Arcane", Pr = "More mana", Co = "Less health/speed", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; pl._DefaultMana = pl._DefaultMana + 15;  pl._DefaultSpeed = pl._DefaultSpeed - 15; end},//pl._DefaultHealth = pl._DefaultHeatlh - 10;
}

Achievements = {
	["fkill"] = {Name = "Getting started", Description = "Get your first kill."},
	["wetfl"] = {Name = "Wet floor", Description = "Kill an enemy with Cyclone Trap."},
	["carkill"] = {Name = "Honk, honk motherfuckers", Description = "Kill 3 enemies with a single car!"},
	["adkill"] = {Name = "I like to break the ice", Description = "Kill a frozen enemy with Aero Dash."},
	["scrow"] = {Name = "Scarecrow", Description = "Kill a cursed crow."},
	["elbkillstr"] = {Name = "Short circuit", Description = "Kill 3 enemies with E-Bolt in one life."},
	["pingpong"] = {Name = "Ping pong", Description = "Kill 2 enemies with Scorn within 8 seconds!"},
	//["hrevenge"] = {Name = "Hot revenge", Description = "Burn an enemy to death while being dead."},
	["fwin"] = {Name = "That was easy", Description = "Win a round for the first time."},
	["bldtrpkill"] = {Name = "Afraid of ceilings", Description = "Kill 2 enemies with Blood Trap in one life."},
	["powerup"] = {Name = "Power up!", Description = "Kill an enemy with charged Cyclone Trap!"},
	["xray"] = {Name = "XRay", Description = "Kill a Ghosting enemy."},
	["dfabove"] = {Name = "Death from above", Description = "Kill an enemy with Telekinesis while being in mid-air."},
	["hditworks"] = {Name = "How does it work?", Description = "Figure out how to use Teleportation."},
	["damnbirds"] = {Name = "Damn birds", Description = "Kill an enemy within 5 seconds after being a crow."},
	//["fridge"] = {Name = "In the Fridge", Description = "Freeze an enemy to death while being frozen."},
	["intox"] = {Name = "Intoxication", Description = "Get 4 kills with Toxic Cloud in one life."},
	["dodgethis"] = {Name = "Dodge this", Description = "Crush a normal enemy to death with Aero Dash."},
	["shgib"] = {Name = "That was delicious", Description = "Blast an enemy into giblets with a shotgun."},
	//["plstealth"] = {Name = "Playing stealth", Description = "Kill 3 enemies with silenced USP in one life."},
	//["killsmil1"] = {Name = "Getting stronger", Description = "Kill 50 enemies in total."},
	//["killsmil2"] = {Name = "Tough guy", Description = "Kill 100 enemies in total."},
	//["killsmil3"] = {Name = "Really tough guy", Description = "Kill 250 enemies in total."},
	//["killsmil4"] = {Name = "Stronger than you think", Description = "Kill 500 enemies in total."},
	//["killsmil5"] = {Name = "I just killed 1000 dudes...", Description = "Kill 1000 enemies in total."},
	//["killsmil6"] = {Name = "I'm a monster.", Description = "Kill 5000 enemies in total."},
	//["killsmil7"] = {Name = "I'm still here!", Description = "Kill 10000 enemies in total."},
	//["killsmil8"] = {Name = "...", Description = "Kill 20000 enemies in total."},
	//["rndmil1"] = {Name = "Playing fair", Description = "Win 10 rounds in total."},
	//["rndmil2"] = {Name = "Playing good", Description = "Win 30 rounds in total."},
	//["rndmil3"] = {Name = "It's addicting!", Description = "Win 100 rounds in total."},
	//["rndmil4"] = {Name = "Still playing!", Description = "Win 250 rounds in total."},
	//["rndmil5"] = {Name = "500 rounds!", Description = "Win 500 rounds in total."},
	["sprandpr"] = {Name = "Spray and pray", Description = "Kill 3 enemies with AK-47 within 12 seconds."},
	["fdefeat"] = {Name = "It aint over yet", Description = "You were defeated for the first time."},
	["ripper"] = {Name = "Ripper", Description = "Kill 7 enemies with a sword in one life."},
	["bulletdef"] = {Name = "Deflector", Description = "Block 250 bullets in one round with melee."},
	["garbage"] = {Name = "Garbage Day", Description = "Kill 2 enemies with shotgun within 2 seconds."},
	["nesevil"] = {Name = "Nessesary Evil", Description = "Kill 5 enemies with Cursed Flames in one life."},
	["hunter"] = {Name = "Hunter", Description = "Get 4 kills with Crossbow in one life."},
	//["kothr1"] = {Name = "My Hill!", Description = "Win 15 KOTH rounds."},
	//["kothr2"] = {Name = "Highlander", Description = "Win 30 KOTH rounds."},
	//["kothr3"] = {Name = "Can I just stay here?", Description = "Win 100 KOTH rounds."},
	//["kothr4"] = {Name = "Great Scott", Description = "Win 250 KOTH rounds."},
	//["htfr1"] = {Name = "Balls of Steel", Description = "Win 15 HTF rounds."},
	//["htfr2"] = {Name = "Dog on the balls", Description = "Win 30 HTF rounds."},
	//["htfr3"] = {Name = "Balls, balls, balls!", Description = "Win 100 HTF rounds."},
	//["htfr4"] = {Name = "No more balls jokes?", Description = "Win 250 HTF rounds."},
	["wandkills"] = {Name = "Watch, what you're doing!", Description = "Poke 4 enemies to death in single life."},
	["gunslinger"] = {Name = "Gunslinger", Description = "Get 7 kills with normal USP in one life!"},
	["ballkill"] = {Name = "Get back here", Description = "Kill 10 ball carriers in one round."},
	//["heal1"] = {Name = "Taste of medicine", Description = "Heal 250 hp in one round."},
	//["heal2"] = {Name = "Proud ally", Description = "Heal 500 hp in one round."},
	//["heal3"] = {Name = "Not a real doctor", Description = "Heal 750 hp in one round."},
	//["heal4"] = {Name = "Medical license", Description = "Heal 1250 hp in one round."},
	["meatshower"] = {Name = "Meat Shower", Description = "Gib 4 enemies in one life."},
	["bee"] = {Name = "Bee", Description = "Kill 4 enemies in one life while having speed boost."},
	//["hammer"] = {Name = "Gun in a hammer fight", Description = "Win a round, using ONLY melee."},
	["redcolor"] = {Name = "Red Color", Description = "Kill a charging thug."},
	["sucker"] = {Name = "Sucker", Description = "Slice an enemy who is being sucked into Blood Trap."},
	["ffawin"] = {Name = "Are you not entertained?", Description = "Win a FFA round."},
	["slippery"] = {Name = "Slippery, when wet", Description = "Get a kill while sliding."},
	["thinkbig"] = {Name = "Think Big", Description = "Kill a Thug with your ordinary fists."},
	["punch"] = {Name = "Tiger mask", Description = "Kill 5 players in one life barehanded."},
	["breaking"] = {Name = "Breaking badly", Description = "Destroy 7 players in one life as Thug."},
	["weaklings"] = {Name = "Weaklings!", Description = "\"I stepped on a sliding guy with my huge shoe!\""},
	["stompkill"] = {Name = "Worth the Weight", Description = "Kill an enemy by landing on top of them as thug."},
}

Unlocks = {
	/*["murderofcrows"] = {"damnbirds","scrow","killsmil2"},
	["houdini"] = {"plstealth","xray","killsmil2"},
	["dd_bowie"] = {"adkill","dodgethis"},
	["berserker"] = {"killsmil1","ripper","bulletdef"},
	["dd_spas12"] = {"garbage","shgib","rndmil2"},
	["raiseundead"] = {"pingpong","killsmil2"},
	["dd_eyelander"] = {"kothr2","ripper"},
	["fireandfury"] = {"nesevil","htfr2"},
	["gravitywell"] = {"carkill","rndmil3"},
	["dd_elites"] = {"ballkill","gunslinger"},
	["dd_elites_silenced"] = {"ballkill","gunslinger"},
	["meatbomb"] = {"meatshower","intox"},
	["thug"] = {"hammer","sucker"},
	["dd_striker"] = {"killsmil5", "ffawin", "meatshower"},
	["dd_sledge"] = {"kothr4", "punch"},
	["dd_basher"] = {"meatshower", "breaking"},*/
}

LevelUnlocks = {
	/*[10] = {"dd_launcher"},
	[15] = {"dd_inquisitor","dd_aug","dd_famas"},
	[16] = {"thug"},
	[17] = {"berserker"},
	[18] = {"dd_bowie"},
	[19] = {"houdini"},
	[20] = {"dd_elites","dd_elites_silenced"},
	[21] = {"fireandfury"},
	[22] = {"raiseundead"},
	[23] = {"dd_spas12"},
	[24] = {"murderofcrows"},
	[25] = {"meatbomb"},
	[26] = {"dd_basher"},
	[27] = {"dd_eyelander"},
	[28] = {"dd_striker"},
	[29] = {"gravitywell"},
	[30] = {"dd_sledge"},*/
}

RandomData = {
	/*["kills"] = {Name = "Kills"},
	["meleekills"] = {Name = "Melee kills"},
	["time"] = {Name = "Time played"},
	["rndwon"] = {Name = "Rounds won"},
	["rndlost"] = {Name = "Rounds lost"},
	["kothwon"] = {Name = "KOTH rounds won"},
	["kothlost"] = {Name = "KOTH rounds lost"},
	["htfwon"] = {Name = "HTF rounds won"},
	["htflost"] = {Name = "HTF rounds lost"},*/
}

function IsSpell(name)
	return Spells[name]
end

function IsPerk(name)
	return Perks[name]
end

function IsWeapon(name)
	return Weapons[name]
end

Radio = {}
Radio[1] = {"music/VLVX_song22.mp3", 195}
Radio[2] = {"music/VLVX_song23.mp3", 167}
Radio[3] = {"music/VLVX_song24.mp3", 127}
Radio[4] = {"music/VLVX_song25.mp3", 167}
Radio[5] = {"music/VLVX_song27.mp3", 211}
Radio[6] = {"music/HL2_song14.mp3", 159}
Radio[7] = {"music/HL2_song15.mp3", 69}
Radio[8] = {"music/HL2_song16.mp3", 170}
Radio[9] = {"music/HL2_song20_submix0.mp3", 103}
Radio[10] = {"music/HL1_song10.mp3", 105}
Radio[11] = {"music/HL1_song15.mp3", 121}
Radio[12] = {"music/HL2_song12_long.mp3", 73}
Radio[13] = {"music/VLVX_song11.mp3", 80}
Radio[14] = {"music/VLVX_song18.mp3", 187}
Radio[15] = {"music/VLVX_song21.mp3", 172}
Radio[16] = {"music/HL2_song29.mp3", 137}
Radio[17] = {"music/HL2_song3.mp3", 92}
Radio[18] = {"music/HL2_song31.mp3", 100}
Radio[19] = {"music/HL2_song4.mp3", 67}
Radio[20] = {"music/VLVX_song0.mp3", 67}
Radio[21] = {"music/VLVX_song12.mp3", 122}
Radio[22] = {"music/VLVX_song28.mp3", 195}
Radio[23] = {"music/VLVX_song4.mp3", 102}
Radio[24] = {"music/VLVX_song9.mp3", 76}
Radio[25] = {"music/HL1_song17.mp3", 123}
Radio[26] = {"music/HL1_song19.mp3", 115}
Radio[27] = {"music/HL1_song24.mp3", 75}
Radio[28] = {"music/HL2_intro.mp3", 74}
Radio[29] = {"music/HL2_song0.mp3", 40}
Radio[30] = {"music/HL2_song1.mp3", 98}
Radio[31] = {"music/HL2_song19.mp3", 115}
Radio[32] = {"music/HL2_song20_submix4.mp3", 140}
Radio[33] = {"music/HL2_song26.mp3", 69}
Radio[34] = {"music/HL2_song33.mp3", 83}
Radio[35] = {"music/HL2_song8.mp3", 59}


if CLIENT then
	for k, v in pairs(Radio) do
		if (v[2] == 60) then
			v[2] = 0.1
		end
	end
end




//Hats and stuff

HolsterWeapons = {
	["dd_mp5"] = { type = "Model", model = "models/weapons/w_smg_mp5.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(1.437, 3.663, -4.545), angle = Angle(35.036, -180, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_revolver"] = { type = "Model", model = "models/weapons/W_357.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(3.224, 0.328, 2.615), angle = Angle(2.611, 7.137, 96.074), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_ak47"] = { type = "Model", model = "models/weapons/w_rif_ak47.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.839, 3.663, -3.434), angle = Angle(21.591, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_m3super90"] = { type = "Model", model = "models/weapons/w_shot_m3super90.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.839, 3.663, -3.434), angle = Angle(21.591, -180, 0), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_m4"] = { type = "Model", model = "models/weapons/w_rif_m4a1.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-5.338, 3.875, -1.948), angle = Angle(26.247, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_m4_silenced"] = { type = "Model", model = "models/weapons/w_rif_m4a1_silencer.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-5.338, 3.875, -1.948), angle = Angle(26.247, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_p90"] = { type = "Model", model = "models/weapons/w_smg_p90.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0.252, 3.721, -4.617), angle = Angle(26.247, 180, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_spas12"] = { type = "Model", model = "models/Weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-0.389, 4.662, -1.446), angle = Angle(140.735, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_xbow"] = { type = "Model", model = "models/Weapons/W_crossbow.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.185, 4.192, -4.652), angle = Angle(148.712, -174.887, -101.362), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(2.576, 3.411, 0.374), angle = Angle(-62.145, -180, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_bowie"] = { type = "Model", model = "models/player/items/heavy/pn2_knife_canteen.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.668, 0.199, -26.667), angle = Angle(24.625, 19.781, 0.528), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_cleaver"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.8039999008179, -3.5230000019073, 1.8079999685287), angle = Angle(24.92799949646, 86.758003234863, 20.738000869751), size = Vector(0.75400000810623, 0.75400000810623, 0.75400000810623), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, fix_scale = true },
	["dd_crowbar"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-1.369, 3.407, -1.732), angle = Angle(-22.549, -180, -36.716), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_dsword"] = { type = "Model", model = "models/weapons/w_dsword.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(27.778, 10.987, -8.046), angle = Angle(21.402, -178.82, -85.848), size = Vector(0.915, 0.915, 0.915), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["dd_eyelander"] = { type = "Model", model = "models/weapons/c_models/c_claymore/c_claymore.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(15.822, 3.332, -6.067), angle = Angle(0, 90, -67.93), size = Vector(0.915, 0.915, 0.915), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["dd_katana"] = { type = "Model", model = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.458, 3.793, -5.626), angle = Angle(0, 86.302, -57.378), size = Vector(0.847, 0.847, 0.847), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {} },
	--["dd_zweihander"] = { type = "Model", model = "models/weapons/c_models/c_claidheamohmor/c_claidheamohmor.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(17.325, 3.49, -3.902), angle = Angle(-15.914, 0, -90), size = Vector(0.703, 0.703, 0.703), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_usp"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.072, 2.654, -3.148), angle = Angle(15.991, -82.685, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_usp_silenced"] = { type = "Model", model = "models/weapons/w_pist_usp_silencer.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.072, 0.356, -3.148), angle = Angle(15.991, -82.685, 0), size = Vector(0.925, 0.925, 0.925), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_trafficlight"] = { type = "Model", model = "models/props/cs_assault/stoplight.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(22.603, 4.283, -11.162), angle = Angle(0, 90, -61.285), size = Vector(0.409, 0.409, 0.409), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["dd_riot"] = { type = "Model", model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(10.526, 4.084, -2.382), angle = Angle(57.437+90, 0, 0), size = Vector(0.79, 0.79, 0.79), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_elites"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.275, 2.321, 0.143), angle = Angle(80.029, -90, 0), size = Vector(0.925, 0.925, 0.925), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_elites_silenced"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.275, 2.321, 0.143), angle = Angle(80.029, -90, 0), size = Vector(0.925, 0.925, 0.925), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_ump"] = { type = "Model", model = "models/weapons/w_smg_ump45.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-1.532, 3.618, -4.667), angle = Angle(26.312, -180, 0), size = Vector(0.964, 0.964, 0.964), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["dd_sledge"] = { type = "Model", model = "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(9.69, 3.894, -3.28), angle = Angle(68.074, 0, 0), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_aug"] = { type = "Model", model = "models/weapons/w_rif_aug.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-6.913, 3.493, 0), angle = Angle(23.774, 180, 0), size = Vector(0.922, 0.922, 0.922), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["dd_basher"] = { type = "Model", model = "models/weapons/c_models/c_boston_basher/c_boston_basher.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.6, 3.319, 4.857), angle = Angle(58.366, -143.543, 150.445), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["dd_inquisitor"] = { type = "Model", model = "models/weapons/c_models/c_scout_sword/c_scout_sword.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-7.217, -4.757, 3.95), angle = Angle(-130.864, -96.131, 0), size = Vector(0.871, 0.871, 0.871), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dd_famas"] = { type = "Model", model = "models/weapons/w_rif_famas.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-7.29, 3.184, -0.946), angle = Angle(30.017, -180, 0), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}
	






Equipment = {
	
	//Hats
	["bandana"] = {
		key = 1,
		name = "Bandana",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/heavy_bandana.mdl",Str = true, bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-77, 24.443, -0), angle = Angle(0, -74.151, -90), size = Vector(1, 1.075, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["jaw"] = {
		key = 2,
		name = "Steel Jaw",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/big_jaw.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.842, -0.907, 0), angle = Angle(0, -90, -90), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["skyrimhelm"] = {
		key = 3,
		name = "Skyrim Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/skyrim_helmet.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.538, -0.031, 0), angle = Angle(0, -76.056, -90), size = Vector(0.936, 1, 0.986), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["desmarauder"] = {
		key = 4,
		name = "Desert Marauder",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/desert_marauder.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.863, 1.575, 0), angle = Angle(0, -81.113, -90), size = Vector(0.861, 0.861, 0.861), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pro_hat"] = {
		key = 5,
		name = "I am Leon",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/pro_hat.mdl",Str = true, bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-77.5, 18.667, 0), angle = Angle(-4.17, -79.657, -90), size = Vector(1.019, 1.1, 1.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["witcher_hair"] = {
		key = 6,
		name = "Witcher's Hair",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/scout_hair.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.676, 0.837, 0), angle = Angle(0, -82.663, -90), size = Vector(1.194, 1.162, 1.167), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["assasins_cowl"] = {
		key = 7,
		name = "Assasin's Cowl",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/acr_assassins_cowl.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-80, 28.424, 0), angle = Angle(0, -72.276, -90), size = Vector(1.125, 1.125, 1.125), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["brink_hood"] = {
		key = 8,
		name = "Brink Hoodie",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/c_bet_brinkhood.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.606, 0.662, 0), angle = Angle(-0.406, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["sultan"] = {
		key = 9,
		name = "Sultan's Hat",
		slot = "hat",
		props = {
				["1"] = { type = "Model", model = "models/player/items/demo/demo_sultan_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.463, -0.75, 0), angle = Angle(0, -90, -90), size = Vector(0.95, 0.95, 0.95), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["hazmat"] = {
		key = 10,
		name = "Hazmat Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/pyro_hazmat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.063, 2.413, 0), angle = Angle(0, -70.681, -90), size = Vector(1.419, 1.325, 1.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["earphones"] = {
		key = 12,
		name = "Safe'n'Sound",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/engy_earphones.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-62.113, 31.33, 0), angle = Angle(0, -65.332, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["weldingmask"] = {
		key = 13,
		name = "Welding Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/weldingmask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-39.031, -57.838, 0), angle = Angle(0, -143.532, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["ushanka"] = {
		key = 14,
		name = "Ushanka",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/heavy_ushanka.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.431, -1.05, 0), angle = Angle(0, -75.551, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["boxinghelm"] = {
		key = 15,
		name = "Boxing Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/pugilist_protector.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-76.919, 22.674, 0), angle = Angle(0, -75.388, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pilothelm"] = {
		key = 16,
		name = "Pilot Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/pilot_protector.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.63, -0.058, 0), angle = Angle(0, -86.406, -90), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["officerhat"] = {
		key = 17,
		name = "Officer's Cap",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/soldier_officer.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.125, -0.387, 0), angle = Angle(0, -80.875, -90), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["ninjamask"] = {
		key = 18,
		name = "Ninja Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/hero_academy_spy.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-80.938, 22.082, 0), angle = Angle(0, -76.544, -90), size = Vector(1.111, 1.111, 1.111), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["hallmark"] = {
		key = 19,
		name = "Hustler's Hallmark",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/demo/hallmark.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.393, 0, 0), angle = Angle(0, -75.812, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["eljefe"] = {
		key = 20,
		name = "El Jefe",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/rebel_cap.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.136, 0.449, 0), angle = Angle(0, -77.475, -90), size = Vector(1.093, 1.093, 1.093), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["scfedora"] = {
		key = 21,
		name = "Fed Fightin' Fedora",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/pep_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-72.437, 0.63, 0), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["dreads"] = {
		key = 22,
		name = "Dreads",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/demo/demo_dreads.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.782, -0.662, 0), angle = Angle(0, -81.47, -90), size = Vector(1.037, 1.037, 1.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["tophat"] = {
		key = 23,
		name = "Top Hat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/engineer_top_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, -0.719, 0), angle = Angle(0, -84.112, -90), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["brhair"] = {
		key = 24,
		name = "Brainiac's Hair",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/drg_brainiac_hair.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, -0.406, 0), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["tghguy"] = {
		key = 25,
		name = "Tough guy",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/heavy_stocking_cap.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.094, 2.469, 0), angle = Angle(0, -83.769, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["footballhelm"] = {
		key = 26,
		name = "Football Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/football_helmet.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-78.306, 21.267, 0), angle = Angle(0, -76.644, -90), size = Vector(1, 1.006, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pyromancer"] = {
		key = 27,
		name = "Pyromancer's Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/pyro_pyromancers_mask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.143, 1.111, 0), angle = Angle(0, -80.695, -90), size = Vector(0.869, 0.869, 0.869), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["cap"] = {
		key = 28,
		name = "Summer Cap",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/fwk_scout_cap.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, -0.489, 0), angle = Angle(0, -90, -90), size = Vector(1.11, 1.11, 1.11), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["jarheadband"] = {
		key = 29,
		name = "Jarate Headband",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/jarate_headband.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-83.306, 5.063, 0), angle = Angle(0, -89.281, -90), size = Vector(1.093, 1.093, 1.093), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["serghat"] = {
		key = 30,
		name = "Sergeant Hat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/soldier_sargehat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-67.28, 34.819, 0), angle = Angle(0, -64.138, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["invis"] = {
		key = 31,
		name = "Invisible Man",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/hwn_spy_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-76.334, 22.794, 0), angle = Angle(0, -75.314, -90), size = Vector(1.059, 1.059, 1.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["vrgoogles"] = {
		key = 32,
		name = "Virtual Reality",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/fwk_engineer_cranial.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.649, -0.076, 0), angle = Angle(0, -72.963, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["mafiahat"] = {
		key = 33,
		name = "Mafia Hat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/capones_capper.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.308, -0.727, 0), angle = Angle(0, -80.302, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["bill"] = {
		key = 34,
		name = "Bill's Hat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/heavy_bill.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-79.099, 12.293, 0), angle = Angle(0, -82.776, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["spartan"] = {
		key = 35,
		name = "Spartan's Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/soldier_spartan.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, -79.151, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["warpig"] = {
		key = 36,
		name = "War Pig",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/soldier_warpig_s2.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.48, 0.994, 0), angle = Angle(0, -78.919, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["roboengi"] = {
		key = 37,
		name = "Robo-Hardhat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/engineer/robo_engy_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-67.082, 15.192, 0), angle = Angle(0, -78.245, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["roboush"] = {
		key = 38,
		name = "Robo-Ushanka",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/heavy/robo_ushanka.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-76.131, 22.306, 0), angle = Angle(0, -75.676, -90), size = Vector(0.986, 0.986, 0.986), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["robocap"] = {
		key = 39,
		name = "Robo-Cap",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/scout/robo_cap.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-68.6, 31.662, 0), angle = Angle(0, -67.169, -90), size = Vector(1, 1.075, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["robohelmet"] = {
		key = 40,
		name = "Robo-Helmet",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/soldier/robot_helmet_bullet.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-65.737, 7.637, 0), angle = Angle(0, -84.225, -90), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["fibmask"] = {
		key = 41,
		name = "Fiber Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/spy_dishonored.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-77.863, 20.419, 0), angle = Angle(0, -77.35, -90), size = Vector(1.069, 1.069, 1.069), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["bothead"] = {
		key = 42,
		name = "Broken Bot Head",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/engineer/fob_h_wrench.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-23.275, -0.357, 3.775), angle = Angle(-11.138, -90.551, -96.732), size = Vector(1.084, 1.084, 1.084), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["botheadg"] = {
		key = 43,
		name = "Golden Bot Head",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/engineer/fob_h_wrench.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-23.275, -0.357, 3.775), angle = Angle(-11.138, -90.551, -96.732), size = Vector(1.084, 1.084, 1.084), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {} }
		}
	},
	["botmask"] = {
		key = 44,
		name = "Bot Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/spy/fob_h_knife.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-13.313, 9.005, 0), angle = Angle(-90, -58.343, -90), size = Vector(4.156, 4.156, 4.156), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["botmaskg"] = {
		key = 45,
		name = "Golden Bot Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/spy/fob_h_knife.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-13.313, 9.005, 0), angle = Angle(-90, -58.343, -90), size = Vector(4.156, 4.156, 4.156), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {} }
		}
	},
	["sphood"] = {
		key = 46,
		name = "Spooky Hood",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/hwn_pyro_spookyhood.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-69.254, 17.511, 0), angle = Angle(0, -73.433, -90), size = Vector(0.996, 0.996, 0.996), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["brain"] = {
		key = 47,
		name = "My Brain!",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/engineer_brain.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.572, -1.593, 0), angle = Angle(0, -71.642, -90), size = Vector(1.019, 1.019, 1.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["witch"] = {
		key = 48,
		name = "Witch Hat",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/witchhat_demo.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.572, 0, 0), angle = Angle(0, -66.269, -90), size = Vector(0.879, 0.879, 0.879), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["ironmask"] = {
		key = 49,
		name = "Iron Mask",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/bio_fireman.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.313, -0.515, 0), angle = Angle(0, -62.195, -90), size = Vector(0.962, 0.962, 0.962), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	
	//Misc
	
	["robro"] = {
		key = 50,
		name = "Robro",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/pet_robro.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(1.705, -3.125, 9.6), angle = Angle(0, 90, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["archimedes"] = {
		key = 51,
		name = "Archimedes!",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/archimedes.mdl", bone = "ValveBiped.Bip01_R_Clavicle", rel = "", pos = Vector(6.256, -1.295, 0), angle = Angle(-90, 123.061, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }		
		}
	},
	["eye1"] = {
		key = 52,
		name = "Mad Eye",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/mad_eye.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.088, -0.556, 0), angle = Angle(0, -79.995, -89.043), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }		
		}
	},
	["eye2"] = {
		key = 53,
		name = "Mad Eyes!",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/mad_eye.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.088, -0.556, 0), angle = Angle(0, -79.995, -89.043), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["1+"] = { type = "Model", model = "models/player/items/engineer/mad_eye.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.861, -1.512, 0), angle = Angle(0, -79, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }			
		}
	},
	["blueprints"] = {
		key = 54,
		name = "Blueprints",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/engineer_blueprints_back.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-6.711, -0.295, 0.356), angle = Angle(0, 90, 96.861), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["brainiac"] = {
		key = 55,
		name = "Brainiac's Goggles",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/drg_brainiac_goggles.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.737, -0.9, 0), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["phantom"] = {
		key = 56,
		name = "Party Phantom",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/spy_party_phantom.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.287, -0.631, 0), angle = Angle(0, -79.362, -90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["toothneck"] = {
		key = 57,
		name = "Tooth Necklace",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/fwk_sniper_necklace.mdl", bone = "ValveBiped.Bip01_Neck1", rel = "", pos = Vector(-63.612, 34.467, 0), angle = Angle(0, -66.1, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["soccerscarf"] = {
		key = 58,
		name = "Soccer Scarf",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/scarf_soccer.mdl", bone = "ValveBiped.Bip01_Neck1", rel = "", pos = Vector(-61.232, 40.473, 0), angle = Angle(0, -61, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["deusspecs"] = {
		key = 59,
		name = "Deus Specs",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/dex_glasses_scout.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.832, 0.737, 0), angle = Angle(0, -73.044, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pyrogoogles"] = {
		key = 60,
		name = "Pyrovision Goggles",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/pyrovision_goggles_sniper.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["copglasses"] = {
		key = 61,
		name = "Cop Glasses",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/heavy/cop_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.244, -0.419, 0), angle = Angle(0, -71.531, -90), size = Vector(1, 0.962, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["guitar"] = {
		key = 62,
		name = "Guitar",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/guitar.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-1.538, 3.575, 3.18), angle = Angle(33.993, 180, -90), size = Vector(0.824, 0.824, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["medic_mask"] = {
		key = 63,
		name = "Medic's mask",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/medic_mask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-75.388, 9.468, 0), angle = Angle(0, -83.651, -90), size = Vector(1.00, 1.00, 1.00), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["blightedbeak"] = {
		key = 64,
		name = "Blighted Beak",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/medic_blighted_beak.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.63, -0.763, 0), angle = Angle(0, -81.212, -90), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["cigar"] = {
		key = 65,
		name = "Cigar",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/cigar.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.93, -0.127, -0.681), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, particle = {"drg_pipe_smoke"}, particleatt = "cig_drg_smoke" }
		}
	},
	["hachimaki"] = {
		key = 66,
		name = "Japan Hachimaki",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/japan_hachimaki.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.787, -0.644, 0), angle = Angle(0, -90, -90), size = Vector(1.013, 1.013, 1.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["summershades"] = {
		key = 67,
		name = "Summer Shades",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/summer_shades.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.613, 0.824, 0), angle = Angle(0, -66.337, -90), size = Vector(0.981, 0.981, 0.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pspeks"] = {
		key = 68,
		name = "Professor's Speks",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/soldier/professor_speks.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.482, -0.013, 0), angle = Angle(0, -72.457, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["plgoogles"] = {
		key = 69,
		name = "Planeswalker Goggles",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/scout_mtg.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.35, 1.161, 0), angle = Angle(0, -67.344, -90), size = Vector(1.062, 1.062, 1.062), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["bonkboy"] = {
		key = 70,
		name = "Bonk Boy",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/bonk_mask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.742, 0.887, 0), angle = Angle(0, -73.931, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["rose"] = {
		key = 71,
		name = "Rose",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/spy_rose.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-58.6, -5.082, 0.544), angle = Angle(180, -91.156, -90), size = Vector(0.887, 0.887, 0.887), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["readingglasses"] = {
		key = 72,
		name = "Reading Glasses",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/fwk_spy_specs.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.35, -2.119, 0), angle = Angle(0, -90, -90), size = Vector(1.105, 1.105, 1.105), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["cambeard"] = {
		key = 73,
		name = "Camera Beard",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/spy_camera_beard.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.7, 1.162, 0), angle = Angle(0, -90, -90), size = Vector(0.936, 0.936, 0.936), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pipboy"] = {
		key = 74,
		name = "Pip-Boy",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/engineer/bet_pb.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(25.768, -8.518, -28.445), angle = Angle(180, 113.524, -119.358), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["bombinomicon"] = {
		key = 75,
		name = "Bombinomicon",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/bombonomicon.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0.007, -6.52, -2.731), angle = Angle(-163.894, -111.151, -93.37), size = Vector(0.762, 0.762, 0.762), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pipe"] = {
		key = 76,
		name = "Pipe",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/medic_smokingpipe2.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-74.564, 0, 0), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["evilglasses"] = {
		key = 77,
		name = "Evil Glasses",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/hwn_medic_misc1.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-74.363, 13.262, 0), angle = Angle(0, -80.325, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	/*["monocle"] = {
		key = 78,
		name = "Monocle",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/pyro_monocle.mdl", Str = true, bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-70.788, 5.168, 0), angle = Angle(0, -82.439, -90), size = Vector(1,1 , 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},*/
	["moneybag"] = {
		key = 79,
		name = "Money Bag",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/scout/pep_bag.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-56.445, -2.027, 10.826), angle = Angle(-180, -85.612, -80.426), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["dotagoogles"] = {
		key = 80,
		name = "Dota Goggles",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/dotasniper_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.357, 0.837, 0), angle = Angle(0, -79.064, -90), size = Vector(1, 1.031, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["robmask"] = {
		key = 81,
		name = "Robber's Mask",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/sniper/kerch.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.774, -0.445, 0), angle = Angle(0, 0, -90), size = Vector(1.058, 1.058, 1.058), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["pilotgoogles"] = {
		key = 82,
		name = "Pilot's Goggles",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/spy/hwn_spy_misc1.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-77.713, 14.218, 0), angle = Angle(0, -81.156, -90), size = Vector(1.055, 1.055, 1.055), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["demobeard"] = {
		key = 83,
		name = "Demoman's beard",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/demo/demo_beardpipe.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.32, 1.054, 0), angle = Angle(0, -74.849, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["gasmask"] = {
		key = 84,
		name = "Gas Mask",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/medic_gasmask.mdl", Str = true,bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.43, 2.232, 0.081), angle = Angle(0, -73.826, -90), size = Vector(1.125, 1.156, 1.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["bowtie"] = {
		key = 85,
		name = "Bowtie",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/bowtie.mdl", bone = "ValveBiped.Bip01_Neck1", rel = "", pos = Vector(-63.994, 33.526, 0), angle = Angle(0, -64.583, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["firewbag"] = {
		key = 87,
		name = "Bag with Fireworks",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/pyro/pyro_fireworksbag.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-51.431, -5.994, 0.669), angle = Angle(-180, -93.926, -90), size = Vector(0.824, 0.787, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["robomed"] = {
		key = 88,
		name = "Robo-Medpack",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/mvm_loot/medic/robo_backpack.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-61.356, -4.237, 2.974), angle = Angle(180, -91.306, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["botlaunch"] = {
		key = 89,
		name = "lil' Bot",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/Weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.524, 5.236, -11.044), angle = Angle(27.562, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["bot"] = { type = "Model", model = "models/player/items/mvm_loot/sniper/fob_h_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(37.68, 0.675, 3.362), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["botlaunchd"] = {
		key = 90,
		name = "Diamond lil' Bot",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/Weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.524, 5.236, -11.044), angle = Angle(27.562, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["bot"] = { type = "Model", model = "models/player/items/mvm_loot/sniper/fob_h_sniperrifle_diamond.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(37.68, 0.675, 3.362), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["oculus"] = {
		key = 91,
		name = "Playing with power",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/player/items/all_class/all_class_oculus_medic_on.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.014, 0.559, 0), angle = Angle(0, -73.028, -90), size = Vector(0.931, 0.931, 0.931), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["skullhead"] = {
		key = 92,
		name = "Skull Head",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/demo/skull_horns_b2.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.156, 0.162, 0), angle = Angle(0, 104.589, -90), size = Vector(0.987, 0.987, 0.987), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["gonz"] = {
		key = 93,
		name = "German Gonzilla",
		slot = "hat",
		props = {
			["1"] = { type = "Model", model = "models/player/items/medic/medic_german_gonzila.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.075, -1.214, 0), angle = Angle(0, -82.547, -90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	/*["katana"] = {
		key = 94,
		name = "Katana",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.458, 3.793, -5.626), angle = Angle(0, 86.302, -57.378), size = Vector(0.847, 0.847, 0.847), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {}, ShouldHide = function(p) return IsValid(p) and p:IsPlayer() and IsValid(p:GetActiveWeapon()) and p:GetActiveWeapon():GetClass() == "dd_katana" end }
		}
	},*/
	["medhead"] = {
		key = 95,
		name = "Medic Head",
		slot = "misc",
		props = {
			["ooohmoney"] = { type = "Model", model = "models/bots/gibs/medicbot_gib_head.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-83.325, 22.514, 0.002), angle = Angle(0, -75.234, -90), size = Vector(1.128, 1.128, 1.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["spyhead"] = {
		key = 96,
		name = "Spy Head",
		slot = "misc",
		props = {
			["gentlemen"] = { type = "Model", model = "models/bots/gibs/spybot_gib_head.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-80.076, 12.619, 0.146), angle = Angle(0, -82.788, -90), size = Vector(1.072, 1.072, 1.072), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["roboarm"] = {
		key = 97,
		name = "Robotic Arm",
		slot = "misc",
		props = {
			["thing1"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_chest2.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(29.971, 0.33, 7.85), angle = Angle(-108.769, 180, 0), size = Vector(0.634, 0.634, 0.634), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_arm2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23.52, 17.448, 3.733), angle = Angle(-76.766, -15.551, -180), size = Vector(0.787, 0.787, 0.787), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["thing3"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_chest.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(23.583, 2.102, -0.463), angle = Angle(86.263, -0.124, -6.553), size = Vector(0.574, 0.574, 0.574), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["shoulder"] = { type = "Model", model = "models/bots/gibs/demobot_gib_arm1.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(26.856, 2.953, 13.864), angle = Angle(-12.02, -87.863, 110.986), size = Vector(0.658, 0.658, 0.658), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["thing2"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_pelvis.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(23.92, 3.47, 2.098), angle = Angle(-1.979, -101.749, 93.523), size = Vector(0.495, 0.495, 0.495), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["arm"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_arm1.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(36.862, -3.475, -22.337), angle = Angle(-180, -87.989, 113.864), size = Vector(0.591, 0.591, 0.591), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["upperarm"] = { type = "Model", model = "models/bots/gibs/demobot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(24.958, 2.686, -6.165), angle = Angle(7.863, 79.262, -82.287), size = Vector(0.547, 0.547, 0.547), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["rustarmor"] = {
		key = 98,
		name = "Rusty Armor",
		slot = "misc",
		props = {
			["thing"] = { type = "Model", model = "models/bots/gibs/heavybot_gib_boss_arm.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(38.087, 18.266, -23.411), angle = Angle(20.288, -89.239, 70.072), size = Vector(0.648, 0.648, 0.648), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["chest"] = { type = "Model", model = "models/bots/gibs/heavybot_gib_chest.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-31.868, -0.264, 0.6), angle = Angle(4.821, 96.464, 90), size = Vector(0.76, 0.76, 0.76), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["chest3"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_chest.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-51.961, -15.594, -0.621), angle = Angle(0.912, 77.299, 88.346), size = Vector(0.912, 0.912, 0.912), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["chest2"] = { type = "Model", model = "models/bots/gibs/demobot_gib_boss_pelvis.mdl", bone = "ValveBiped.Bip01_Spine1", rel = "", pos = Vector(-43.211, 1.921, 0), angle = Angle(-1.102, 98.254, 90), size = Vector(0.662, 0.662, 0.662), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["metmask"] = {
		key = 99,
		name = "Metal Mask",
		slot = "misc",
		props = {
			["exp2"] = { type = "Model", model = "models/props_combine/stalkerpod_lid.mdl", bone = "ValveBiped.Bip01_Head1", rel = "exp", pos = Vector(0.207, 0, -0.046), angle = Angle(96.43, 0, 0), size = Vector(0.455, 0.455, 0.455), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["exp"] = { type = "Model", model = "models/props_combine/stalkerpod_lid.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.407, 4.591, 0), angle = Angle(0, 173.432, -90), size = Vector(0.709, 0.709, 0.709), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	["crow"] = {
		key = 100,
		name = "Crow",
		slot = "misc",
		props = {
			["1"] = { type = "Model", model = "models/crow.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(2.398, -2.799, 5.05), angle = Angle(7.484, 68.125, 66.424), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, seq = "Idle01", UseHead = true }
		}
	},
	
	
	["rlegs"] = {
		key = 101,
		name = "Robotic Legs",
		slot = "misc",
		props = {
			["feet1+"] = { type = "Model", model = "models/buildables/gibs/teleporter_gib1.mdl", bone = "ValveBiped.Bip01_L_Foot", rel = "", pos = Vector(-2.938, 1.468, 0), angle = Angle(-96.312, 155.126, 86.05), size = Vector(0.681, 0.681, 0.681), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["feet1"] = { type = "Model", model = "models/buildables/gibs/teleporter_gib1.mdl", bone = "ValveBiped.Bip01_R_Foot", rel = "", pos = Vector(-2.938, 1.468, 0), angle = Angle(-98.304, 155.126, 86.05), size = Vector(0.681, 0.681, 0.681), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["legback1"] = { type = "Model", model = "models/bots/gibs/demobot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Calf", rel = "", pos = Vector(32.035, 2.888, -4.435), angle = Angle(-18.859, 82.101, -86.766), size = Vector(0.62, 0.62, 0.62), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["leg1+"] = { type = "Model", model = "models/bots/gibs/heavybot_gib_arm.mdl", bone = "ValveBiped.Bip01_L_Calf", rel = "", pos = Vector(-23.063, 13.805, 25.52), angle = Angle(-16.909, -88.954, -114.332), size = Vector(0.825, 0.825, 0.825), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["leg1"] = { type = "Model", model = "models/bots/gibs/heavybot_gib_arm.mdl", bone = "ValveBiped.Bip01_R_Calf", rel = "", pos = Vector(-22.958, 11.942, 26.573), angle = Angle(-13.502, -88.954, -114.332), size = Vector(0.825, 0.825, 0.825), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["legback1+"] = { type = "Model", model = "models/bots/gibs/demobot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_L_Calf", rel = "", pos = Vector(32.035, 2.888, -5.494), angle = Angle(-15.997, 82.101, -86.766), size = Vector(0.62, 0.62, 0.62), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["leg2"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_boss_arm3.mdl", bone = "ValveBiped.Bip01_R_Thigh", rel = "", pos = Vector(64.401, -26.705, -38.218), angle = Angle(3.785, 109.64, -67.871), size = Vector(0.824, 0.824, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["leg2+"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_boss_arm3.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(66.935, -28.069, -35.639), angle = Angle(3.964, 109.825, -71.487), size = Vector(0.824, 0.824, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},
	/*["scr"] = {
		key = 100,
		name = "Mr Scratch",
		slot = "misc",
		props =  {
			["hand_1_1+"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_stuff", pos = Vector(6.486, -10.66, 22.903), angle = Angle(-125.252, -134.032, -6.828), size = Vector(0.372, 0.372, 0.372), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["forearm2_thing"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_pelvis.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "forearm2", pos = Vector(5.762, -0.786, 67.552), angle = Angle(-149.305, -79.583, 31.243), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_1_2+"] = { type = "Model", model = "models/bots/gibs/scoutbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_1_1++", pos = Vector(-7.772, 2.789, 2.013), angle = Angle(-65.045, -13.483, -18.392), size = Vector(0.321, 0.321, 0.321), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_1_2"] = { type = "Model", model = "models/bots/gibs/scoutbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_1_1", pos = Vector(-7.772, 2.789, 2.013), angle = Angle(-65.045, -13.483, -18.392), size = Vector(0.321, 0.321, 0.321), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_stuff"] = { type = "Model", model = "models/bots/gibs/heavybot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-13.455, 4.973, -4.184), angle = Angle(-45.338, 90.128, 82.098), size = Vector(0.574, 0.574, 0.574), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_1_1"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_stuff", pos = Vector(0.586, 5.993, 22.319), angle = Angle(-122.551, 95.416, -6.014), size = Vector(0.372, 0.372, 0.372), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["shoulder2"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_pelvis.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(-18.05, 0.439, 1.325), angle = Angle(-40.354, 92.273, 95.289), size = Vector(0.69, 0.69, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["forearm2"] = { type = "Model", model = "models/bots/gibs/pyrobot_gib_boss_arm3.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "shoulder2", pos = Vector(30.031, 22.82, -11.775), angle = Angle(23.913, -96.495, 27.176), size = Vector(0.698, 0.698, 0.698), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_1_2++"] = { type = "Model", model = "models/bots/gibs/scoutbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_1_1+", pos = Vector(-7.772, 2.789, 2.013), angle = Angle(-65.045, -13.483, -18.392), size = Vector(0.321, 0.321, 0.321), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["hand_1_1++"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_leg2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand_stuff", pos = Vector(-7.136, -9.91, 22.502), angle = Angle(-125.252, -44.5, -6.828), size = Vector(0.372, 0.372, 0.372), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["gas_thingy"] = { type = "Model", model = "models/buildables/gibs/dispenser_gib3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "real_forearm", pos = Vector(-4.23, 13.067, 34.669), angle = Angle(-29.659, 58.58, -9.594), size = Vector(0.449, 0.449, 0.449), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["real_forearm"] = { type = "Model", model = "models/bots/gibs/soldierbot_gib_boss_arm1.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(40.497, -8.999, 22.336), angle = Angle(147.108, 86.046, -65.625), size = Vector(0.625, 0.625, 0.625), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	},*/
	

}

local t = table.Copy(Equipment)

tempEquipment = table.Copy(t)

EquipmentKeys = {}

for name,tbl in pairs(Equipment) do
	if tbl and tbl.key then
		EquipmentKeys[tbl.key] = name
	end
end

for k, v in pairs( Equipment ) do
	for _,tbl in pairs(v.props) do
		if tbl.model then
			util.PrecacheModel(tbl.model)
		end
	end
end


//Some help stuff
HelpPage = {}

HelpPage[1] = {
	ButtonName = "About",
	Text = [[
		Darkest Days is a mix of HL2:DM, BioShock, Dishonored and few other games.
		
		Based on the code from Infected Wars.
		
				
		-- Some additional thanks and credits --
		
		Clavus - SWEP Construction Kit
		JetBoom - Lua Animations API and weapon base from ZS
		Ywa - For hosting original server
		Original modeller of Damascus Sword
		_Kilburn - For helping out with some things
		Fray - Some SCK designs
		Xerxes - For fixing up sword viewmodel
		All the players that joined the server for playtesting
	]],

}

HelpPage[2] = {
	ButtonName = "Basics",
	Text = [[
		Goal of gamemode depends of current gametype:

		> King of the Hill - Stand on the highlighted point until timer runs out.
		  
		> Hold the Flag - Pick up a flag and hold it until timer runs out.
		  
		> Team Deathmatch - Kill or be killed. Whoever gets required amount of kills - wins the round.
		  
		> Punchpocalypse - Survive against thugs, that really want you to
		  become beefy.
		  
		> Free for All - Simple deathmatch. Whoever gets the biggest score wins.
		
		
		You can get access to skills/loadout menu by right clicking when you are dead.
		
		There are achievements as well (F3).
	]],

}

HelpPage[3] = {
	ButtonName = "Combat",
	Text = [[
		>> Magic/Spells:
		
		> Q or C button - switch between equipped spells.
		> Right Mouse Button - cast equipped spell.
		> You can restore mana by regenerating it or collecting blue orbs from dead players.
		  
		>> Melee:
		
		> Hold "Reload" button to block with your melee.
		> Melee swings are based on your movement's direction.
		  
		>> Health:
		
		> You can restore your health by using specified abilities/perks or by collecting green orbs from dead players.
		
		>> Parkour:
		
		> Jump and sprint near closest wall to wallrun.
		> Jump against a wall to perform a walljump.
		> Sprint and hold crouch to perform a slide.
		> Crouch when falling to perform a roll.
		> Press "Use" button or spacebar to climb over small ledges.
		> Press "Walk" or "Use" button (if enabled) to perform a dive.
	]],

}

HelpPage[4] = {
	ButtonName = "Misc",
	Text = [[
		F2 - Change player's outfit (if enable by server)
		F3 - Open achievements menu
		F4 - Options
		Zoom key - Enable/disable thirdperson mode
		
		You can enable/disable HUD and tweak thirdperson mode in Options menu (F4)
	]],
}



Voice = {}
VoiceAdvanced = {}

Voice["male"] = {}
VoiceAdvanced["male"] = {}

Voice["male"].OnKill = {
	"vo/npc/male01/gotone02.wav",
	"vo/npc/male01/likethat.wav",
	"vo/npc/male01/notthemanithought01.wav",
	"vo/npc/Barney/ba_laugh01.wav",
	"vo/npc/male01/vquestion01.wav",
	"vo/npc/male01/question30.wav",
	"vo/npc/male01/gordead_ans07.wav",
	"vo/npc/male01/gordead_ques17.wav"
}

Voice["male"].OnPain = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
}

VoiceAdvanced["male"].OnPain = {
	[HITGROUP_LEFTARM] = {
		Sound("vo/npc/male01/myarm01.wav"),
		Sound("vo/npc/male01/myarm02.wav"),
	},
	[HITGROUP_RIGHTARM] = {
		Sound("vo/npc/male01/myarm01.wav"),
		Sound("vo/npc/male01/myarm02.wav"),
	},
	[HITGROUP_LEFTLEG] = {
		Sound("vo/npc/male01/myleg01.wav"),
		Sound("vo/npc/male01/myleg02.wav"),
	},
	[HITGROUP_RIGHTLEG] = {
		Sound("vo/npc/male01/myleg01.wav"),
		Sound("vo/npc/male01/myleg02.wav"),
	},
	[HITGROUP_STOMACH] = {
		Sound("vo/npc/male01/hitingut01.wav"),
		Sound("vo/npc/male01/hitingut02.wav"),
		Sound("vo/npc/male01/mygut02.wav"),
	},

}

VoiceAdvanced["male"].Commands = {
	
	//yes
	["agree"] = {
		Sound("vo/npc/male01/ok01.wav"),
		Sound("vo/npc/male01/ok02.wav"),
		Sound("vo/npc/male01/squad_affirm02.wav"),
		Sound("vo/npc/male01/squad_affirm03.wav"),
		Sound("vo/npc/male01/yeah02.wav"),
	},
	["disagree"] = {
		Sound("vo/npc/male01/answer21.wav"),
		Sound("vo/npc/male01/answer37.wav"),
		Sound("vo/npc/male01/gordead_ans12.wav"),
		Sound("vo/npc/male01/vanswer13.wav"),
	},
	["follow"] = {
		Sound("vo/npc/male01/squad_follow02.wav"),
		Sound("vo/npc/male01/squad_follow03.wav"),
		Sound("vo/npc/male01/squad_away01.wav"),
		Sound("vo/npc/male01/squad_away03.wav"),
		Sound("vo/npc/male01/overhere01.wav"),
		Sound("vo/coast/odessa/male01/stairman_follow01.wav"),
	},
	["sorry"] = {
		Sound("vo/npc/male01/sorry01.wav"),
		Sound("vo/npc/male01/sorry02.wav"),
		Sound("vo/npc/male01/sorry03.wav"),
		Sound("vo/npc/male01/sorrydoc02.wav"),
		Sound("vo/npc/male01/excuseme01.wav"),
		Sound("vo/npc/male01/excuseme02.wav"),
	},
	["help"] = {
		Sound("vo/npc/male01/help01.wav"),
		Sound("vo/Streetwar/sniper/male01/c17_09_help01.wav"),
		Sound("vo/Streetwar/sniper/male01/c17_09_help02.wav"),
		Sound("vo/Streetwar/sniper/male01/c17_09_help03.wav"),
		Sound("vo/Citadel/br_ohshit.wav")
	},
	["taunt"] = {
		Sound("vo/npc/male01/vquestion01.wav"),
		Sound("vo/npc/male01/notthemanithought01.wav"),
		Sound("vo/npc/male01/gordead_ans07.wav"),
		Sound("vo/ravenholm/monk_blocked01.wav"),
		Sound("vo/ravenholm/madlaugh01.wav"),
		Sound("vo/ravenholm/madlaugh02.wav"),
		Sound("vo/ravenholm/madlaugh03.wav"),
		Sound("vo/ravenholm/madlaugh04.wav"),
	},
	


}



Voice["male"].OnDeath = {
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
}

Voice["male"].OnLevelUp = {
	"vo/npc/male01/fantastic01.wav",
	"vo/npc/male01/fantastic02.wav",
	"vo/npc/male01/nice.wav",
	"vo/npc/male01/thislldonicely01.wav",
}

for k,v in pairs(Voice["male"]) do
	if v then
		for _,snd in pairs(v) do
			util.PrecacheSound(snd)
		end
	end
end

Voice["female"] = {}
VoiceAdvanced["female"] = {}

Voice["female"].OnKill = {
	"vo/npc/female01/gotone02.wav",
	"vo/npc/female01/likethat.wav",
	"vo/npc/female01/notthemanithought01.wav",
	"vo/npc/female01/vquestion01.wav",
	"vo/npc/female01/question30.wav",
	"vo/npc/female01/gordead_ans07.wav",
	"vo/npc/female01/gordead_ques17.wav"
}

Voice["female"].OnPain = {
	"vo/npc/female01/pain01.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
}

VoiceAdvanced["female"].OnPain = {
	[HITGROUP_LEFTARM] = {
		Sound("vo/npc/female01/myarm01.wav"),
		Sound("vo/npc/female01/myarm02.wav"),
	},
	[HITGROUP_RIGHTARM] = {
		Sound("vo/npc/female01/myarm01.wav"),
		Sound("vo/npc/female01/myarm02.wav"),
	},
	[HITGROUP_LEFTLEG] = {
		Sound("vo/npc/female01/myleg01.wav"),
		Sound("vo/npc/female01/myleg02.wav"),
	},
	[HITGROUP_RIGHTLEG] = {
		Sound("vo/npc/female01/myleg01.wav"),
		Sound("vo/npc/female01/myleg02.wav"),
	},
	[HITGROUP_STOMACH] = {
		Sound("vo/npc/female01/hitingut01.wav"),
		Sound("vo/npc/female01/hitingut02.wav"),
	},

}

VoiceAdvanced["female"].Commands = {
	
	//yes
	["agree"] = {
		Sound("vo/npc/female01/ok01.wav"),
		Sound("vo/npc/female01/ok02.wav"),
		Sound("vo/npc/female01/squad_affirm02.wav"),
		Sound("vo/npc/female01/squad_affirm03.wav"),
		Sound("vo/npc/female01/yeah02.wav"),
	},
	["disagree"] = {
		Sound("vo/npc/female01/answer21.wav"),
		Sound("vo/npc/female01/answer37.wav"),
		Sound("vo/npc/female01/gordead_ans12.wav"),
		Sound("vo/npc/female01/vanswer13.wav"),
	},
	["follow"] = {
		Sound("vo/npc/female01/squad_follow02.wav"),
		Sound("vo/npc/female01/squad_follow03.wav"),
		Sound("vo/npc/female01/squad_away01.wav"),
		Sound("vo/npc/female01/squad_away02.wav"),
		Sound("vo/npc/female01/squad_away03.wav"),
		Sound("vo/npc/female01/overhere01.wav"),
	},
	["sorry"] = {
		Sound("vo/npc/female01/sorry01.wav"),
		Sound("vo/npc/female01/sorry02.wav"),
		Sound("vo/npc/female01/sorry03.wav"),
		Sound("vo/npc/female01/sorrydoc02.wav"),
		Sound("vo/npc/female01/excuseme01.wav"),
		Sound("vo/npc/female01/excuseme02.wav"),
	},
	["help"] = {
		Sound("vo/npc/female01/help01.wav"),
	},
	["taunt"] = {
		Sound("vo/npc/female01/vquestion01.wav"),
		Sound("vo/npc/female01/notthemanithought01.wav"),
		Sound("vo/npc/female01/gordead_ans07.wav"),
		Sound("vo/npc/female01/vquestion04.wav"),
	},
	


}

Voice["female"].OnDeath = {
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav",
}

Voice["female"].OnLevelUp = {
	"vo/npc/female01/fantastic01.wav",
	"vo/npc/female01/fantastic02.wav",
	"vo/npc/female01/nice01.wav",
	"vo/npc/female01/nice02.wav",
	"vo/npc/female01/thislldonicely01.wav",
}

for k,v in pairs(Voice["female"]) do
	if v then
		for _,snd in pairs(v) do
			util.PrecacheSound(snd)
		end
	end
end

Voice["combine"] = {}
VoiceAdvanced["combine"] = {}

Voice["combine"].OnKill = {
	"npc/metropolice/vo/chuckle.wav",
	"npc/metropolice/vo/isdown.wav",
	"npc/metropolice/takedown.wav",
}

Voice["combine"].OnPain = {
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav",
	"npc/metropolice/pain4.wav",
}

Voice["combine"].OnDeath = {
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav",
}

Voice["combine"].OnLevelUp = {
	"npc/metropolice/vo/gotoneaccomplicehere.wav",
	"npc/metropolice/vo/needanyhelpwiththisone.wav",
}

VoiceAdvanced["combine"].Commands = {
	
	//yes
	["agree"] = {
		Sound("npc/combine_soldier/vo/affirmative.wav"),
		Sound("npc/combine_soldier/vo/affirmative2.wav"),
		Sound("npc/metropolice/vo/affirmative.wav"),
		Sound("npc/metropolice/vo/affirmative2.wav"),
		Sound("npc/combine_soldier/vo/copy.wav"),
		Sound("npc/combine_soldier/vo/copythat.wav"),
	},
	["disagree"] = {
		Sound("vo/trainyard/ba_noimgood.wav"),
	},
	["follow"] = {
		Sound("npc/metropolice/vo/keepmoving.wav"),
		Sound("npc/metropolice/vo/move.wav"),
		Sound("npc/metropolice/vo/moveit.wav"),
	},
	/*["sorry"] = {
		Sound("vo/npc/male01/sorry01.wav"),
		Sound("vo/npc/male01/sorry02.wav"),
		Sound("vo/npc/male01/sorry03.wav"),
		Sound("vo/npc/male01/sorrydoc02.wav"),
		Sound("vo/npc/male01/excuseme01.wav"),
		Sound("vo/npc/male01/excuseme02.wav"),
	},*/
	["help"] = {
		Sound("npc/combine_soldier/vo/coverme.wav"),
		Sound("npc/combine_soldier/vo/coverhurt.wav"),
		Sound("npc/metropolice/vo/backmeupimout.wav"),
		Sound("npc/metropolice/vo/watchit.wav"),
		Sound("npc/metropolice/vo/shit.wav")
	},
	["taunt"] = {
		Sound("npc/metropolice/vo/thisisyoursecondwarning.wav"),
		Sound("npc/metropolice/vo/putitinthetrash1.wav"),
		Sound("npc/metropolice/vo/putitinthetrash2.wav"),
		Sound("npc/metropolice/vo/movebackrightnow.wav"),
		Sound("npc/metropolice/vo/lookingfortrouble.wav"),
	},
	


}

for k,v in pairs(Voice["combine"]) do
	if v then
		for _,snd in pairs(v) do
			util.PrecacheSound(snd)
		end
	end
end

util.PrecacheModel( "models/Gibs/Antlion_gib_small_1.mdl" )
util.PrecacheModel( "models/props_foliage/driftwood_clump_03a.mdl" )
util.PrecacheModel( "models/props_foliage/driftwood_03a.mdl" )
util.PrecacheModel( "models/props_debris/concrete_spawnplug001a.mdl" )
util.PrecacheModel( "models/props_canal/rock_riverbed02b.mdl" )
util.PrecacheModel( "models/props_canal/rock_riverbed01d.mdl" )
util.PrecacheModel( "models/props_junk/Rock001a.mdl" )
util.PrecacheModel( "models/Gibs/Shield_Scanner_Gib6.mdl" )
util.PrecacheModel( "models/props_debris/broken_pile001a.mdl" )
util.PrecacheModel( "models/Gibs/Antlion_gib_Large_3.mdl" )
util.PrecacheModel( "models/Gibs/gunship_gibs_midsection.mdl" )
util.PrecacheModel( "models/Gibs/Shield_Scanner_Gib1.mdl" )
util.PrecacheModel( "models/props_wasteland/rockcliff01J.mdl" )
util.PrecacheModel( "models/props_wasteland/prison_wallpile002a.mdl" )
util.PrecacheModel( "models/props_wasteland/rockgranite02c.mdl" )
util.PrecacheModel( "models/props_wasteland/prison_wallpile002a.mdl" )
util.PrecacheModel( "models/props_wasteland/rockgranite02a.mdl" )
util.PrecacheModel( "models/props_wasteland/rockcliff01f.mdl" )
util.PrecacheModel( "models/props_wasteland/rockgranite02c.mdl" )
util.PrecacheModel( "models/props_hive/nest_extract.mdl" )

GM.BotPlayerModels = {
	"models/player/alyx.mdl",
	"models/player/barney.mdl",
	"models/player/breen.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/soldier_stripped.mdl",
	"models/player/eli.mdl",
	"models/player/gman_high.mdl",
	"models/player/Kleiner.mdl",
	"models/player/monk.mdl",
	"models/player/magnusson.mdl",
	"models/player/mossman.mdl",
	"models/player/odessa.mdl",
	"models/player/police.mdl",
	"models/player/arctic.mdl",
	"models/player/leet.mdl",
	"models/player/guerilla.mdl",
	"models/player/phoenix.mdl",
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl",
	"models/player/urban.mdl",
	"models/player/Hostage/Hostage_01.mdl",
	"models/player/Hostage/Hostage_02.mdl",
	"models/player/Hostage/hostage_03.mdl",
	"models/player/Hostage/hostage_04.mdl",
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/Male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/Male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/corpse1.mdl",
}


