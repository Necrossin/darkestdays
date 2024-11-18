
GM.Gametypes = {}
GM.Gametypes["koth"] = { Name = "King of the Hill", TranslateName = "koth_name" }
GM.Gametypes["tdm"] = { Name = "Team Deathmatch", TranslateName = "tdm_name" }
//GM.Gametypes["conquest"] = {Name = "Conquest"}
GM.Gametypes["htf"] = { Name = "Hold the Flag", TranslateName = "htf_name" }
//GM.Gametypes["assault"] = {Name = "Assault (still wip)"}
GM.Gametypes["ffa"] = { Name = "Free for All", TranslateName = "ffa_name" }
GM.Gametypes["ts"] = { Name = "Punchpocalypse", TranslateName = "ts_name" }


//Stats!

PLAYER_DEFAULT_HEALTH = 125
PLAYER_DEFAULT_MANA = 60
PLAYER_DEFAULT_SPEED = 210
PLAYER_DEFAULT_RUNSPEED_BONUS = 50
PLAYER_DEFAULT_JUMPPOWER = 200
PLAYER_DEFAULT_BULLETBLOCK_POWER = 175
PLAYER_DEFAULT_MELEE_BONUS = 0
PLAYER_DEFAULT_MELEE_SPEED_BONUS = 0
PLAYER_DEFAULT_DODGE_BONUS = 0
PLAYER_DEFAULT_MELEE_VAMPIRISM_BONUS = 0
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
SKILL_STRENGTH_VAMPIRISM_PER_LEVEL = 0.6
SKILL_AGILITY_SPEED_PER_LEVEL = 3.2
SKILL_AGILITY_DAMAGE_PER_LEVEL = 0.5
SKILL_MAGIC_DAMAGE_PER_LEVEL = 3
SKILL_MAGIC_CHANNELING_PER_LEVEL = 0.03//0.024
SKILL_BULLET_FALLOFF_PER_LEVEL = 1.2//0.03
SKILL_BULLET_CONSUME_PER_LEVEL = 0.0135
SKILL_BULLET_SCAVENGER_PER_LEVEL = 0.046
SKILL_BULLET_STEADYAIM_BONUS = 0.8

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
			
			if swep.Primary.Delay + swep.SwingTime >= MaxMeleeStats[2] then
				MaxMeleeStats[2] = swep.Primary.Delay + swep.SwingTime
			end
			
			if swep.MeleeRange >= MaxMeleeStats[3] then
				MaxMeleeStats[3] = swep.MeleeRange
			end
			
			
			tbl.Stats = { 
				[1] = {"loadout_stats_damage", swep.MeleeDamage, Color(254,2,1,255)},
				[2] = {"loadout_stats_speed", swep.Primary.Delay + swep.SwingTime, Color(0,255,0,255),true},
				[3] = {"loadout_stats_reach", swep.MeleeRange, Color(254,254,0,255)}
			}
			
		else
			
			local swep = weapons.Get(wep)
			
			//Define max stats
			if swep.Primary.Damage * swep.Primary.NumShots >= MaxRangedStats[1] then
				MaxRangedStats[1] = math.Clamp(swep.Primary.Damage * swep.Primary.NumShots,0,60)
			end
			
			if swep.Primary.Delay and 60 / swep.Primary.Delay >= MaxRangedStats[2] then
				MaxRangedStats[2] = 60 / swep.Primary.Delay
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
				[1] = {"loadout_stats_damage", swep.Primary.Damage * swep.Primary.NumShots, Color(254,2,1,255)},
				[2] = {"loadout_stats_rof", math.ceil(60 / (swep.Primary.Delay or 1)), Color(0,255,0,255)},
				[3] = {"loadout_stats_accuracy", swep.Primary.Cone or 0, Color(254,254,0,255), true},
				[4] = {"loadout_stats_range", swep.Caliber and CaliberFalloffDistance[swep.Caliber] and math.ceil(CaliberFalloffDistance[swep.Caliber] * 0.0254) or 0, Color(254,254,0,255)},
				[5] = {"loadout_stats_recoil", swep.IsShotgun and 0 or ( swep.Primary.Recoil + swep.Primary.Recoil * ( swep.Primary.RecoilKick or 0.1 ) ) or 0, Color(254,254,0,255)},
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
				[1] = {"loadout_stats_mana", spell.Mana, color_white},
				[2] = {"loadout_stats_spell_damage", spell.Damage or 0, color_white},
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
		
		if tbl.Mana then
			if tbl.Mana >= MaxSpellStats[1] then
				MaxSpellStats[1] = tbl.Mana
			end
			
			tbl.Perk = true
			
			tbl.Stats = {
				[1] = {"loadout_stats_mana", tbl.Mana, color_white},
				//[2] = {"loadout_stats_spell_damage", spell.Damage or 0, color_white},
			}
		end
		
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
	[15] = "grit",

}

//aka Gun Mastery
Skills["agility"] = {

	[1] = "gmbasic",
	[5] = "fastreload",
	[10] = "steadyaim",
	[15] = "grenade",

}

Abilities = {

	//Agility
	//["ledgeroll"] = {Name = "Ledge Grabbing/Roll", Pr = "Ability to pull yourself onto small\nledges\nAbility to negate some fall damage\nby rolling",Description = "\nPress 'E' while standing under ledge\nto pull yourself onto it.\nWhile falling, crouch before hitting\nthe ground to roll!", OnSet = function(pl) pl._SkillLedgeGrab = true pl._SkillRoll = true end, OnReset = function(pl) pl._SkillLedgeGrab = false pl._SkillRoll = false end  },
	//["walljumpslide"] = {Name = "Wall Jump/Slide", Pr = "Ability to wall-jump\nJump power is based on your velocity\n\nAbility to slide when sprinting", Description = "\nDouble press jump button near a wall\nto perform a wall-jump.\nHold 'E' while facing a wall to perform\na wall-jump with 180 degrees turn.\n\nCrouch when sprinting to slide.", OnSet = function(pl) pl._SkillWJ = true; pl._SkillSlide = true end, OnReset = function(pl) pl._SkillWJ = false; pl._SkillSlide = false end},
	//["wallrun"] = {Name = "Wall Run", Pr = "Ability to sprint on wall surfaces\nWallrun power is based on your velocity",Description = "\nJump near wall while sprinting\nto start wall running.", OnSet = function(pl) pl:SetEffect("wallrun") end},

	
	//Gun Mastery
	["gmbasic"] = {
		Name = "player_ability_gun1",
		PrTr = "player_ability_gun1_pr",
		Co = "",
		Description = "",
		OnSet = function(pl) end,
		OnReset = function(pl) end
	},
	["fastreload"] = {
		Name = "player_ability_gun2", 
		PrTr = "player_ability_gun2_pr", 
		PrForm = function() return 70 end,
		CoTr = "player_ability_gun2_co",
		Description = "",
		OnSet = function(pl) 
			pl._SkillFastReload = true; 
			if SERVER then 
				pl:SendLua("LocalPlayer()._FastReload = true") 
			end
		end,
		OnReset = function(pl) 
			pl._SkillFastReload = false; 
			pl:SendLua("LocalPlayer()._FastReload = nil")
		end
	},
	["steadyaim"] = {
		Name = "player_ability_gun3",
		PrTr = "player_ability_gun3_pr",
		PrForm = function() return 20 end,
		Description = "",
		OnSet = function(pl) 
			pl._SkillSteadyAim = true;
			if SERVER then 
				pl:SendLua("LocalPlayer()._SkillSteadyAim = true")
			end
		end,
		OnReset = function(pl)
			pl._SkillSteadyAim = false;
			pl:SendLua("LocalPlayer()._SkillSteadyAim = nil")
		end,
		PassiveDesc = function( p )
			return translate.Format("player_ability_gun_passive", p * SKILL_BULLET_SCAVENGER_PER_LEVEL * 100)
		end
	},
	//["scavenger"] = {Name = "Scavenger", Pr = "- Restore small amount of ammo on kill",Description = "",OnSet = function(pl) pl._SkillScavenger = true end, OnReset = function(pl) pl._SkillScavenger = false end, PassiveDesc = function( p ) return string.format("BONUS: %i%% of clip on kill", p*SKILL_BULLET_SCAVENGER_PER_LEVEL*100) end},
	["grenade"] = {
		Name = "player_ability_gun4",
		Mat = Material( "darkestdays/hud/grenade.png" ),
		PrTr = "player_ability_gun4_pr",
		PrForm = function() return 12 end,
		Co = "",
		Description = "",
		OnSet = function(pl)
			if SERVER then
				pl:SetEffect("grenade")
			end
		end
	},
	
	
	//Magic
	["mbasic"] = {
		Name = "player_ability_magic1", 
		PrTr = "player_ability_magic1_pr",
		Co = "",
		Description = "",
		OnSet = function(pl) end, 
		OnReset = function(pl) end
	},
	["qmanaregen"] = {
		Name = "player_ability_magic2",
		PrTr = "player_ability_magic2_pr",
		OnSet = function(pl)
			pl._SkillQuickRegen = true
		end, 
		OnReset = function(pl)
			pl._SkillQuickRegen = false
		end
	},
	["manachannel"] = {
		Name = "player_ability_magic3",
		PrTr = "player_ability_magic3_pr",
		OnSet = function(pl)
			pl._SkillManaCh = true
		end,
		OnReset = function(pl)
			pl._SkillManaCh = false
		end,
		PassiveDesc = function( p )
			return translate.Format("player_ability_magic_passive", p * SKILL_MAGIC_CHANNELING_PER_LEVEL * 100)
		end
	},
	["magicshield"] = {
		Name = "player_ability_magic4",
		PrTr = "player_ability_magic4_pr",
		PrForm = function() return 35, 30 end,
		CoTr = "player_ability_magic4_co",
		CoForm = function() return 25 end,
		OnSet = function(pl)
			pl:SetEffect("magic_shield")
		end
	},

	//Defense (unused)
	["healthregen"] = {Name = "Health Regeneration", Pr = "Ability to slowly regenerate\nyour health", Description = "Regeneration rate is increased while\nstanding still.",OnSet = function(pl) pl._SkillHPRegen = true end, OnReset = function(pl) pl._SkillHPRegen = false end},
	["bloodpact"] = {Name = "Blood Pact", Pr = "Killing an enemy restores some\nhealth for nearby allies", Description = "",OnSet = function(pl) pl._SkillBloodPact = true end, OnReset = function(pl) pl._SkillBloodPact = false end},

	
	//Strength
	["stbasic"] = {
		Name = "player_ability_strength1",
		PrTr = "player_ability_strength1_pr",
		CoTr = "player_ability_strength1_co",
		Description = "",
		OnSet = function(pl) end,
		OnReset = function(pl) end
	},
	["bulletblock"] = {
		Name = "player_ability_strength2",
		PrTr = "player_ability_strength2_pr",
		PrForm = function() return PLAYER_DEFAULT_BULLETBLOCK_POWER, 10 end,
		Co = "",
		Description = "player_ability_strength2_desc",
		OnSet = function(pl)
			pl._SkillBulletBlock = true;
			pl._DefaultHealth = pl._DefaultHealth + 10;
			if SERVER then
				pl:SendLua("LocalPlayer()._SkillBulletBlock = true")
			end
		end,
		OnReset = function(pl)
			pl._SkillBulletBlock = false;
			if SERVER then
				pl:SendLua("LocalPlayer()._SkillBulletBlock = false")
			end
		end
	},
	["bloodthirst"] = {
		Name = "player_ability_strength3",
		PrTr = "player_ability_strength3_pr",
		PrForm = function() return 15 end,
		CoTr = "player_ability_strength3_co",
		Description = "player_ability_strength3_desc",
		OnSet = function(pl)
			pl._SkillBloodThirst = true;
			pl._DefaultSpeed = pl._DefaultSpeed + 15;
		end,
		OnReset = function(pl)
			pl._SkillBloodThirst = false
		end,
		PassiveDesc = function( p )
			return translate.Format("player_ability_strength_passive", p * SKILL_STRENGTH_VAMPIRISM_PER_LEVEL)
		end
	},
	//["rage"] = {Name = "Rage", Pr = "- Increases melee damage as player\ngets injured",Co = "- Works only at below 50% of health",OnSet = function(pl) pl._SkillRage = true end, OnReset = function(pl) pl._SkillRage = false end},
	["grit"] = {
		Name = "player_ability_strength4",
		PrTr = "player_ability_strength4_pr",
		PrForm = function() return 20, 25 end,
		CoTr = "player_ability_strength4_co",
		Description = "",
		OnSet = function(pl)
			pl._SkillGrit = true;
			pl._DefaultHealth = pl._DefaultHealth + 25;
		end, 
		OnReset = function(pl)
			pl._SkillGrit = false
		end
	},
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
	[CAL_11_20] = 18,
	[CAL_12_GAUGE] = 20,

}


//Weapons

Weapons = {

	["dd_m3super90"] = {
		Name = "weapon_m3_name",
		Mat = Material( "VGUI/gfx/VGUI/m3" ),
		CoTr = "att_max_speed",
		CoForm = function() return -25 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25; end
	},
	["dd_riot"] = {
		Name = "weapon_riot_name",
		Mat = Material( "vgui/gfx/vgui/xm1014" ),
		Special = "weapon_riot_special",
		Pr = "+%s",
		PrForm = function() return translate.Format("att_clip_size", 33) end,
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", -25), translate.Format("att_pellets_perc", -10) end,
		Description = "weapon_riot_desc",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25; end
	},
	["dd_mp5"] = {
		Name = "weapon_mp5_name",
		Mat = Material( "VGUI/gfx/VGUI/mp5" ),
		//Pr = "+10 max speed on wearer\nIncreased accuracy and fire rate\nwhen diving",
		Pr = "+%s\n%s",
		PrForm = function() return translate.Format("att_max_speed", 10), translate.Get( "att_diving_buff" ) end,
		//Co = "-15 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -15 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_m4"] = {
		Name = "weapon_m4_name",
		Mat = Material( "VGUI/gfx/VGUI/m4a1" ),
		//Co = "-20 max speed on wearer\n-30 max mana on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", -20), translate.Format("att_max_mana", -30) end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20; pl._DefaultMana = pl._DefaultMana - 30 end
	},
	["dd_ak47"] = {
		Name = "weapon_ak47_name",
		Mat = Material( "VGUI/gfx/VGUI/ak47" ),
		//Co = "-30 max speed on wearer\n-35 max mana on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", -30), translate.Format("att_max_mana", -35) end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 30; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["dd_usp"] = {
		Name = "weapon_usp_name",
		Secondary = true,
		Mat = Material( "VGUI/gfx/VGUI/usp45" ),
		//Pr = "+10 max speed on wearer",
		Pr = "+%s",
		PrForm = function() return translate.Format("att_max_speed", 10) end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10 end
	},
	["dd_sparkler"] = {
		Name = "weapon_sparkler_name",
		Mat = Material( "VGUI/gfx/VGUI/fiveseven" ),
		//Pr = "Uses mana instead of bullets\nNo reload required\n+15 max mana on wearer",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Get( "att_sparkler_pr" ), translate.Format("att_max_mana", 15) end,
		//Co = "-20 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -20 end,
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana + 15; pl._DefaultHealth = pl._DefaultHealth - 20 end
	},
	["dd_revolver"] = {
		Name = "weapon_revolver_name",
		Mat = Material( "darkestdays/icons/revolver_256x128.png", "smooth" ),
		Secondary = true,
		Description = ""
	},
	["dd_elites"] = {
		Name = "weapon_elites_name",
		Secondary = true,
		AdminFree = true,
		Mat = Material( "VGUI/gfx/VGUI/elites" ),
		//Pr = "Can attack when sprinting\n+20% damage done when sprinting\n+50% damage done when diving\nIncreased accuracy when diving\n+10 max speed on wearer",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Format( "att_elites_pr", 20, 50 ), translate.Format("att_max_speed", 10) end,
		//Co = "-15 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -15 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_p90"] = {
		Name = "weapon_p90_name",
		Mat = Material( "VGUI/gfx/VGUI/p90" ),
		//Pr = "+10 max speed on wearer",
		Pr = "+%s",
		PrForm = function() return translate.Format("att_max_speed", 10) end,
		//Co = "-15 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -15 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_launcher"] = {
		Name = "weapon_launcher_name",
		Mat = Material( "darkestdays/icons/tube_256x128.png", "smooth" ),
		//Co = "-35 max speed on wearer",
		CoTr = "att_max_speed",
		CoForm = function() return -35 end,
		Description = "weapon_launcher_desc",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 35 end
	},
	["dd_ump"] = {
		Name = "weapon_ump_name",
		Mat = Material( "VGUI/gfx/VGUI/ump45" ),
		//Pr = "+10 max speed on wearer\nFire rate increases as remaining\nbullets decrease",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Get( "att_clip_rpm_buff" ), translate.Format("att_max_speed", 10) end,
		//Co = "-15 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -15 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed + 10; pl._DefaultHealth = pl._DefaultHealth - 15 end
	},
	["dd_xbow"] = {
		Name = "weapon_xbow_name", 
		Mat = Material( "darkestdays/icons/xbow_256x128.png", "smooth" ),
		//Pr = "Fires high velocity bolts\nGains up to 5x damage based\non distance travelled",
		PrTr = "att_xbow_pr",
		PrForm = function() return 5 end,
		//Co = "-15 max speed on wearer",
		CoTr = "att_max_speed",
		CoForm = function() return -15 end,
		Description = "weapon_xbow_desc",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15 end
	},
	["dd_spas12"] = {
		Name = "weapon_spas12_name",
		Mat = Material( "darkestdays/icons/boomstick_256x128.png", "smooth" ),
		//Co = "-30% clip size",
		CoTr = "att_clip_size",
		CoForm = function() return -30 end,
		Description = "",
		//OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 35; end
	},
	["dd_dsword"] = {
		Name = "weapon_dsword_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/dsword_256x128.png", "smooth" ), 
		//Pr = "Restores 10 mana on successful hit",
		PrTr = "att_mana_on_hit",
		PrForm = function() return 10 end,
		//Co = "-15 max mana on wearer",
		CoTr = "att_max_mana",
		CoForm = function() return -15 end,
		Special = "weapon_dsword_special",
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana - 15 end
	},
	["dd_crowbar"] = {
		Name = "weapon_crowbar_name",
		Melee = true,
		//Pr = "+50% extra damage done to enemies\nthat are above 50% of health", 
		PrTr = "att_crowbar_pr",
		PrForm = function() return 50, 50 end,
		Mat = Material( "darkestdays/icons/crowbar_256x128.png", "smooth" ),
		Description = "weapon_crowbar_desc"
	},
	["dd_rebar"] = {
		Name = "weapon_rebar_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/rebar_256x128.png", "smooth" ),
		//Pr = "+160% damage done on first hit", 
		PrTr = "att_rebar_pr",
		PrForm = function() return 160 end,
		//Co = "-20 max speed on wearer",
		CoTr = "att_max_speed",
		CoForm = function() return -20 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20 end
	},
	["dd_axe"] = {
		Name = "weapon_axe_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/axe_256x128.png", "smooth" ),
		//Pr = "+35% extra damage when owner is\nbelow 50% of max health",
		Description = ""
	},
	["dd_fists"] = {
		Name = "weapon_fists_name",
		Melee = true,
		//Pr = "Chance to deal critical damage\n+25 max sprint speed",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Get( "att_fists_pr" ), translate.Format("att_max_sprint", 25) end,
		CoTr = "att_fists_co",
		Description = "",
		OnSet = function(pl) pl._DefaultRunSpeedBonus = pl._DefaultRunSpeedBonus + 25 end
	},
	["dd_cleaver"] = {
		Name = "weapon_cleaver_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/cleaver_256x128.png", "smooth" ),
		PrTr = "att_cleaver_pr",
		//Co = "-15 max health on wearer\n-20% block power",
		Co = "%s\n%s",
		CoForm = function() return translate.Format( "att_max_health", -15 ), translate.Format("att_block_power", -20) end,
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; end
	},
	["dd_trafficlight"] = {
		Name = "weapon_trafficlight_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/trafficlight_256x128.png", "smooth" ),
		//Pr = "+50% extra damage done to\nsprinting enemies",
		PrTr = "att_traffic_pr",
		PrForm = function() return 100 end,
		//Co = "-20 max speed on wearer",
		CoTr = "att_max_speed",
		CoForm = function() return -20 end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 20 end
	},
	["dd_wand"] = {
		Name = "weapon_wand_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/wand_256x128.png", "smooth" ), 
		//Pr = "50% of bonus magic damage\nreturned as health\n+45 max mana on wearer\nSlightly increased mana regen",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Format( "att_wand_pr", 50 ), translate.Format("att_max_mana", 45) end,
		//Co = "Limits primary weapon to 1 clip\nNo blocking\n-25 max health on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Get( "att_wand_co" ), translate.Format("att_max_health", -25) end,
		Special = "weapon_wand_special",
		OnSet = function(pl) pl._DefaultMagicRegenBonus = pl._DefaultMagicRegenBonus + 0.1 ;pl._DefaultMana = pl._DefaultMana + 45; pl._DefaultHealth = pl._DefaultHealth - 25; pl:RemoveAllAmmo() end
	}, 
	["dd_eyelander"] = {
		Name = "weapon_eyelander_name",
		Mat = Material( "darkestdays/icons/highlander_256x128.png", "smooth" ), 
		Melee = true,
		//Pr = "Kills grant movement speed stacks\n+10 speed per stack\nStacks go up to 4 max",
		PrTr = "att_eyelander_pr",
		PrForm = function() return 10, 4 end,
		//Co = "-30 max health on wearer\n-10 max speed on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Format( "att_max_health", -30 ), translate.Format("att_max_speed", -10) end,
		Description = "",
		Special = "weapon_eyelander_special",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 30; pl._DefaultSpeed = pl._DefaultSpeed - 10 end
	},
	["dd_katana"] = {
		Name = "weapon_katana_name", 
		Mat = Material( "darkestdays/icons/katana_256x128.png", "smooth" ),
		Melee = true,
		//Pr = "Temporary speed boost on kill\n+15 max speed on wearer",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Get( "att_katana_pr" ), translate.Format("att_max_speed", 15) end,
		//Co = "-20 max health on wearer",
		CoTr = "att_max_health",
		CoForm = function() return -20 end,
		Description = "",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed + 15 end
	},
	--["dd_zweihander"] = {Name = "Zweihander",Mat = Material("backpack/weapons/c_models/c_claidheamohmor/c_claidheamohmor_large"), Melee = true,Pr = "+15% melee power", Co = "-20 max health on wearer\n-25 max speed on wearer",Description = "",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed - 25 end},
	["dd_striker"] = {
		Name = "weapon_striker_name",
		Mat = Material( "darkestdays/icons/striker_256x128.png", "smooth" ),
		//Pr = "It is a pretty big gun",
		PrTr = "att_striker_pr",
		//Co = "Cannot use spells\n-65 max speed on wearer\nUnable to sprint\n-70% magic shield capacity",
		Co = "%s\n%s\n%s",
		CoForm = function() return translate.Get( "att_striker_co" ), translate.Format("att_max_speed", -65), translate.Format("att_magic_shield", -70) end,
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 65; pl._DefaultRunSpeedBonus = 0 end
	},
	["dd_sledge"] = {
		Name = "weapon_sledge_name",
		Melee = true,
		Mat = Material( "darkestdays/icons/sledge_256x128.png", "smooth" ),
		//Pr = "Can deal some damage through blocks",
		PrTr = "att_sledge_pr",
		//Co = "-25 max speed on wearer\n25% slower speed when swinging\n30% slower speed when blocking",
		Co = "%s\n%s",
		CoForm = function() return translate.Format( "att_sledge_co", 25, 30 ), translate.Format("att_max_speed", -25) end,
		Description = "",
		Special = "weapon_sledge_special",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 25 end
	},
	["dd_aug"] = {
		Name = "weapon_aug_name",
		Mat = Material( "VGUI/gfx/VGUI/aug" ),
		//Co = "-15 max speed on wearer\n-35 max mana on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", -15), translate.Format("att_max_mana", -35) end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["dd_basher"] = {
		Name = "weapon_basher_name",
		Mat = Material( "darkestdays/icons/bat_256x128.png", "smooth" ),
		Melee = true,
		//Pr = "+40% damage done to Thugs\nDrains 15 enemy mana on hit\nStrong knockback",
		PrTr = "att_basher_pr",
		PrForm = function() return 40, 15 end,
		//Co = "-25 max mana on wearer",
		CoTr = "att_max_mana",
		CoForm = function() return -25 end,
		Description = "",
		OnSet = function(pl) pl._DefaultMana = pl._DefaultMana - 25 end
	},
	--["dd_inquisitor"] = {Name = "Inquisitor", Mat = Material("backpack/weapons/c_models/c_scout_sword/c_scout_sword_large"),Melee = true, Pr = "+10 max health on wearer", Co = "-30 max mana on wearer",Description = "", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 10; pl._DefaultMana = pl._DefaultMana - 30; end},
	["dd_famas"] = {
		Name = "weapon_famas_name",
		Mat = Material( "VGUI/gfx/VGUI/famas" ),
		//Pr = "Accuracy increases as remaining\nbullets decrease",
		PrTr = "att_clip_acc_buff",
		//Co = "-30 max speed on wearer\n-35 max mana on wearer",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", -30), translate.Format("att_max_mana", -35) end,
		Description = "",
		OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 30; pl._DefaultMana = pl._DefaultMana - 35 end
	},
	["empty"] = {
		Name = "weapon_noprimary",
		Co = "",
		Description = "",
		OnSet = function(pl) end
	},

	//["dd_swordgun"] = {Name = "Sword Gun",Pr = "Shoots fast-travelling knives", Co = "-50% clip size",Description = "\"You always appreciate my work\""},
}

//Spells

Spells = {
	["firebolt"] = {Name = "spell_firebolt_name",Mat = Material( "darkestdays/hud/firebolt.png" ), PrTr = "spell_firebolt_pr", Co = "", Description = ""},
	["electrobolt"] = {Name = "spell_ebolt_name",Mat = Material( "darkestdays/hud/ebolt.png" ), PrTr = "spell_ebolt_pr", Co = "", Description = ""},
	["aerodash"] = {Name = "spell_aerodash_name",Mat = Material( "darkestdays/hud/aerodash.png" ), PrTr = "spell_aerodash_pr", CoTr = "spell_aerodash_co", Description = ""},
	["teleportation"] = {Name = "spell_teleportation_name",Mat = Material( "darkestdays/hud/teleportation.png" ), PrTr = "spell_teleportation_pr", CoTr = "spell_teleportation_co", Description = ""},
	["cyclonetrap"] = {Name = "spell_cyclonetrap_name",Mat = Material( "darkestdays/hud/cyclonetrap.png" ), PrTr = "spell_cyclonetrap_pr", CoTr = "spell_cyclonetrap_co", Description = ""},
	["winterblast"] = {Name = "spell_winterblast_name",Mat = Material( "darkestdays/hud/winterblast.png" ), PrTr = "spell_winterblast_pr", CoTr = "spell_winterblast_co", Description = ""},
	["toxicbreeze"] = {Name = "spell_toxic_name",Mat = Material( "darkestdays/hud/toxicbreeze.png" ), PrTr = "spell_toxic_pr", CoTr = "spell_toxic_co", Description = ""},
	["telekinesis"] = {Name = "spell_telekinesis_name",Mat = Material( "darkestdays/hud/telekinesis.png" ), PrTr = "spell_telekinesis_pr", CoTr = "spell_telekinesis_co",Description = ""},
	["bloodtrap"] = {Name = "spell_bloodtrap_name",Mat = Material( "darkestdays/hud/bloodtrap.png" ), PrTr = "spell_bloodtrap_pr", CoTr = "spell_bloodtrap_co", Description = ""},
	["firebolt2"] = {Name = "spell_flamethrower_name",Mat = Material( "darkestdays/hud/firebolt2.png" ), PrTr = "spell_flamethrower_pr", CoTr = "spell_flamethrower_co", Description = ""},
	["scorn"] = {Name = "spell_scorn_name",Mat = Material( "darkestdays/hud/scorn.png" ), PrTr = "spell_scorn_pr", Co = "",Description = ""},
	["murderofcrows"] = {Name = "spell_murder_name",Mat = Material( "darkestdays/hud/murderofcrows.png" ), PrTr = "spell_murder_pr", CoTr = "spell_murder_co", Description = ""},
	["cursedflames"] = {Name = "spell_cursedflames_name",Mat = Material( "darkestdays/hud/cursedflames.png" ), PrTr = "spell_cursedflames_pr", CoTr = "spell_cursedflames_co", Description = ""},
	["barrier"] = {Name = "spell_barrier_name",Mat = Material( "darkestdays/hud/barrier.png" ), PrTr = "spell_barrier_pr", CoTr = "spell_barrier_co", Description = ""},
	["raiseundead"] = {Name = "spell_undead_name",Mat = Material( "darkestdays/hud/raiseundead.png" ), PrTr = "spell_undead_pr", CoTr = "spell_undead_co",Description = ""},
	["gravitywell"] = {Name = "spell_gravitywell_name",Mat = Material( "darkestdays/hud/gravitywell.png" ), PrTr = "spell_gravitywell_pr", Co = "",Description = ""},
	["cure"] = {Name = "spell_cure_name",Mat = Material( "darkestdays/hud/cure.png" ), PrTr = "spell_cure_pr", CoTr = "spell_cure_co",Description = ""},
	["meatbomb"] = {Name = "spell_meatbomb_name",Mat = Material( "darkestdays/hud/meatbomb.png" ), PrTr = "spell_meatbomb_pr",Description = ""},
}

Perks = {
	["hpregen"] = {
		Name = "perk_regen_name",
		//Pr = "Ability to slowly regenerate\nyour health\n+15 health on wearer",
		Pr = "%s\n%+s",
		PrForm = function() return translate.Get( "perk_regen_pr" ), translate.Format("att_max_health", 15) end,
		//Co = "-25 max speed\n-50% healing from health orbs",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", 25), translate.Format("att_orb_healing", -50) end,
		Description = "perk_regen_desc",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 15; pl._DefaultSpeed = pl._DefaultSpeed - 25;  end
	},
	//["bff"] = {Name = "BFF", Pr = "Killing an enemy restores some\nhealth for nearby allies", Co = "-50% health gained from orbs\n-15 max speed",OnSet = function(pl) pl._DefaultSpeed = pl._DefaultSpeed - 15 end},
	["thug"] = {
		Name = "perk_thug_name",
		AdminFree = true,
		Special = "perk_thug_special",
		//Pr = "Become the mighty thug!\nDeal 3x fall damage to anything\nyou land on",
		PrTr = "perk_thug_pr",
		//Co = "-20 max speed\nLimited parkour\nCan not carry flag\n-50% healing from health orbs",
		Co = "%s\n%s\n%s",
		CoForm = function() return translate.Format("att_max_speed", 20), translate.Format("att_orb_healing", -50), translate.Get( "perk_thug_co" ) end,
		Description = "perk_thug_desc",
		OnSet = function(pl) pl:SetEffect("thug") end
	},
	//["fireandfury"] = {Name = "Fire and Fury", PrColor = Color(235,93,0,255), Pr = "+5%(+15%) fire damage done\n(+20%) damage resistance\n20% chance to light yourself on fire\nwhen dealing fire damage", Co = "+10% bullet damage taken\n+120% cold damage taken", Description = "Values in (brackets) when owner is\non fire"},
	//["berserker"] = {Name = "Berserker", Pr = "+10% magic damage resistance\n+3% more melee damage", Co = "-20 max mana\n-25% bullet damage done", Description = "",OnSet = function(pl) pl._DefaultMResBonus = pl._DefaultMResBonus + 10; pl._DefaultMeleeBonus = pl._DefaultMeleeBonus + 3; pl._DefaultMana = pl._DefaultMana - 20 end},
	//["houdini"] = {Name = "Houdini", Pr = "+66% Ghosting duration\nNo speed reduction while Ghosting\n+15 max speed", Co = "-20 max health", Description = "",OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20; pl._DefaultSpeed = pl._DefaultSpeed + 15; end},
	["ghosting"] = {
		Name = "perk_ghosting_name", 
		Mat = Material( "darkestdays/hud/ghosting.png" ),
		//Pr = "Hold sprint button to become invisible\n+50% more speed when invisible",
		PrTr = "perk_ghosting_pr",
		PrForm = function() return 50 end,
		//Co = "Drains mana when active\n-20 max health",
		Co = "%s\n%s",
		CoForm = function() return translate.Get("perk_ghosting_co"), translate.Format("att_max_health", -20) end,
		Description = "",
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20 end
	},
	["adrenaline"] = {
		Name = "perk_gadrenaline_name",
		PrTr = "perk_adrenaline_pr",
		CoTr = "att_no_orbs",
		OnSet = function(pl) end
	},
	["blank"] = {
		Name = "perk_empty_name",
		Description = "perk_empty_desc"
	},
	["martialarts"] = {
		Name = "perk_martial_name",
		Special = "perk_martial_special",
		PrTr = "perk_martial_pr",
		CoTr = "perk_martial_co",
		Description = "perk_martial_desc",
		OnSet = function(pl) if SERVER then pl:SendLua("LocalPlayer()._MartialArts = true") end end, OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._MartialArts = nil") end end
	},
	["dash"] = {
		Name = "perk_dash_name",
		Mana = 25,
		Special = "perk_dash_special",
		PrTr = "perk_dash_pr",
		//Co = "Costs 25% of your mana per dash\nCosts even more mana per dash attack\n-15 max health",
		Co = "%s\n%s",
		CoForm = function() return translate.Format("perk_dash_co", 25, 50), translate.Format("att_max_health", -15) end,
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = 4 LocalPlayer()._ShiftCap = 25") end end, 
		OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = nil LocalPlayer()._ShiftCap = nil") end end
	},
	["crow"] = {
		Name = "perk_crow_name",
		Mana = 40,
		Mat = Material( "darkestdays/hud/cotn.png" ),
		Special = "perk_crow_special",
		PrTr = "perk_crow_pr",
		//Co = "Costs 50% of your mana\nYou can die in cramped areas\nCan not regenerate mana\nwhilst in crow form",
		CoTr = "perk_crow_co",
		CoForm = function() return 50 end,
		OnSet = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = 2 LocalPlayer()._ShiftCap = 40") end end,
		OnReset = function(pl) if SERVER then pl:SendLua("LocalPlayer()._ShiftUses = nil LocalPlayer()._ShiftCap = nil") end end
	},
	["transcendence"] = {
		Name = "perk_transcendence_name",
		//Pr = "Doubles Magic Shield absorption\nReduces Magic Shield recharge time\ndown to 10 seconds\n50% of max mana as energy",
		PrTr = "perk_transcendence_pr",
		PrForm = function() return 10, 50 end,
		//Co = "-20 max health",
		CoTr = "att_max_health",
		CoForm = function() return -20 end,
		OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 20 end
	},
}

//Small class-like presets
Builds = {
	["default"] = {Name = "player_build_default", Pr = "player_build_default_pr", Co = "player_build_default_co", OnSet = function(pl) end},
	["healthy"] = {Name = "player_build_healthy", Pr = "player_build_healthy_pr", Co = "player_build_healthy_co", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth + 15; pl._DefaultSpeed = pl._DefaultSpeed - 15; pl._DefaultMana = pl._DefaultMana - 15 end},// pl._DefaultHealth = pl._DefaultHealth + 20;
	["agile"] = {Name = "player_build_agile", Pr = "player_build_agile_pr", Co = "player_build_agile_co", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; pl._DefaultSpeed = pl._DefaultSpeed + 15;  pl._DefaultMana = pl._DefaultMana - 15; end},//pl._DefaultHealth = pl._DefaultHeatlh - 10;
	["arcane"] = {Name = "player_build_arcane", Pr = "player_build_arcane_pr", Co = "player_build_arcane_co", OnSet = function(pl) pl._DefaultHealth = pl._DefaultHealth - 15; pl._DefaultMana = pl._DefaultMana + 15;  pl._DefaultSpeed = pl._DefaultSpeed - 15; end},//pl._DefaultHealth = pl._DefaultHeatlh - 10;
}

Achievements = {
	["hditworks"] = {Name = "ach_hditworks_name", Description = "ach_hditworks_desc"},
	["shgib"] = {Name = "ach_shgib_name", Description = "ach_shgib_desc"},
	["slippery"] = {Name = "ach_slippery_name", Description = "ach_slippery_desc"},
	["wetfl"] = {Name = "ach_wetfl_name", Description = "ach_wetfl_desc"},
	["scrow"] = {Name = "ach_scrow_name", Description = "ach_scrow_desc"},
	["punch"] = {Name = "ach_punch_name", Description = "ach_punch_desc"},
	["fwin"] = {Name = "ach_fwin_name", Description = "ach_fwin_desc"},
	["fkill"] = {Name = "ach_fkill_name", Description = "ach_fkill_desc"},
	["fdefeat"] = {Name = "ach_fdefeat_name", Description = "ach_fdefeat_desc"},
	["dodgethis"] = {Name = "ach_dodgethis_name", Description = "ach_dodgethis_desc"},
	["ripper"] = {Name = "ach_ripper_name", Description = "ach_ripper_desc"},
	["carkill"] = {Name = "ach_carkill_name", Description = "ach_carkill_desc"},
	["ballkill"] = {Name = "ach_ballkill_name", Description = "ach_ballkill_desc"},
	["damnbirds"] = {Name = "ach_damnbirds_name", Description = "ach_damnbirds_desc"},
	["weaklings"] = {Name = "ach_weaklings_name", Description = "ach_weaklings_desc"},
	["hunter"] = {Name = "ach_hunter_name", Description = "ach_hunter_desc"},
	["redcolor"] = {Name = "ach_redcolor_name", Description = "ach_redcolor_desc"},
	["xray"] = {Name = "ach_xray_name", Description = "ach_xray_desc"},
	["bldtrpkill"] = {Name = "ach_bldtrpkill_name", Description = "ach_bldtrpkill_desc"},
	["elbkillstr"] = {Name = "ach_elbkillstr_name", Description = "ach_elbkillstr_desc"},
	["powerup"] = {Name = "ach_powerup_name", Description = "ach_powerup_desc"},
	["garbage"] = {Name = "ach_garbage_name", Description = "ach_garbage_desc"},
	["sprandpr"] = {Name = "ach_sprandpr_name", Description = "ach_sprandpr_desc"},
	["sucker"] = {Name = "ach_sucker_name", Description = "ach_sucker_desc"},
	["stompkill"] = {Name = "ach_stompkill_name", Description = "ach_stompkill_desc"},
	["bee"] = {Name = "ach_bee_name", Description = "ach_bee_desc"},
	["dfabove"] = {Name = "ach_dfabove_name", Description = "ach_dfabove_desc"},
	["breaking"] = {Name = "ach_breaking_name", Description = "ach_breaking_desc"},
	["adkill"] = {Name = "ach_adkill_name", Description = "ach_adkill_desc"},
	["thinkbig"] = {Name = "ach_thinkbig_name", Description = "ach_thinkbig_desc"},
	["pingpong"] = {Name = "ach_pingpong_name", Description = "ach_pingpong_desc"},
	["ffawin"] = {Name = "ach_ffawin_name", Description = "ach_ffawin_desc"},
	["intox"] = {Name = "ach_intox_name", Description = "ach_intox_desc"},
	["gunslinger"] = {Name = "ach_gunslinger_name", Description = "ach_gunslinger_desc"},
	["meatshower"] = {Name = "ach_meatshower_name", Description = "ach_meatshower_desc"},
	["bulletdef"] = {Name = "ach_bulletdef_name", Description = "ach_bulletdef_desc"},
	["nesevil"] = {Name = "ach_nesevil_name", Description = "ach_nesevil_desc"},
	["wandkills"] = {Name = "ach_wandkills_name", Description = "ach_wandkills_desc"},
}

/*if SERVER then 
for k,v in pairs(Achievements) do
	//print("LANGUAGE.ach_"..k.."_name                = \""..v.Name.."\"")
	//print("LANGUAGE.ach_"..k.."_desc                = \""..v.Description.."\"")
	//print("[\""..k.."\"] = {Name = \"ach_"..k.."_name\", Description = \"ach_"..k.."_desc\"},")
end
end*/

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

Radio = Radio or {}
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
		
		if !file.Exists( "sound/"..v[1], "GAME" ) then
			Radio[k] = nil
		end
	end
	table.Resequence(Radio)
end

//Some help stuff
HelpPage = {}

HelpPage[1] = {
	ButtonName = "help_page1_title",
	Text = "help_page1_content",
}

HelpPage[2] = {
	ButtonName = "help_page2_title",
	Text = "help_page2_content",
}

HelpPage[3] = {
	ButtonName = "help_page3_title",
	Text = "help_page3_content",
}

HelpPage[4] = {
	ButtonName = "help_page4_title",
	Text = "help_page4_content",
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


