if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
end
SWEP.MatToParticle = {
	
	[MAT_CONCRETE] = {"fx_impact_concrete","Impact.Concrete",{ Sound("physics/concrete/concrete_impact_bullet1.wav"),Sound("physics/concrete/concrete_impact_bullet2.wav"),Sound("physics/concrete/concrete_impact_bullet3.wav"),Sound("physics/concrete/concrete_impact_bullet4.wav")}},//Sound("Concrete.BulletImpact")
	[MAT_DIRT] = {"fx_impact_dirt","Impact.Concrete",{Sound("physics/surfaces/sand_impact_bullet1.wav"),Sound("physics/surfaces/sand_impact_bullet2.wav"),Sound("physics/surfaces/sand_impact_bullet3.wav"),Sound("physics/surfaces/sand_impact_bullet4.wav")}},//Sound("Dirt.BulletImpact")
	[MAT_GLASS] = {"fx_impact_glass","Impact.Glass",{Sound("physics/glass/glass_impact_bullet1.wav"),Sound("physics/glass/glass_impact_bullet2.wav"),Sound("physics/glass/glass_impact_bullet3.wav"),Sound("physics/glass/glass_impact_bullet4.wav")}},//Sound("Glass.BulletImpact")
	[MAT_METAL] = {"fx_impact_metal","Impact.Metal",{Sound("physics/metal/metal_solid_impact_bullet1.wav"),Sound("physics/metal/metal_solid_impact_bullet2.wav"),Sound("physics/metal/metal_solid_impact_bullet3.wav"),Sound("physics/metal/metal_solid_impact_bullet4.wav")}},//Sound("SolidMetal.BulletImpact")
	[MAT_WOOD] = {"fx_impact_wood","Impact.Concrete",{Sound("physics/wood/wood_solid_impact_bullet1.wav"),Sound("physics/wood/wood_solid_impact_bullet2.wav"),Sound("physics/wood/wood_solid_impact_bullet3.wav"),Sound("physics/wood/wood_solid_impact_bullet4.wav"),Sound("physics/wood/wood_solid_impact_bullet5.wav")}},//Sound("Wood.BulletImpact")
	[MAT_COMPUTER] = {"fx_impact_computer","Impact.Concrete",{Sound("physics/glass/glass_impact_bullet1.wav"),Sound("physics/glass/glass_impact_bullet2.wav"),Sound("physics/metal/metal_computer_impact_bullet1.wav"),Sound("physics/metal/metal_computer_impact_bullet2.wav"),Sound("physics/metal/metal_computer_impact_bullet3.wav"),Sound("physics/plastic/plastic_box_impact_bullet1.wav"),Sound("physics/plastic/plastic_box_impact_bullet2.wav"),Sound("physics/plastic/plastic_box_impact_bullet3.wav")}},//Sound("Computer.BulletImpact")
	[MAT_TILE] = {"fx_impact_concrete","Impact.Concrete",{Sound("physics/surfaces/tile_impact_bullet1.wav"),Sound("physics/surfaces/tile_impact_bullet2.wav"),Sound("physics/surfaces/tile_impact_bullet3.wav"),Sound("physics/surfaces/tile_impact_bullet4.wav")}},//Sound("Tile.BulletImpact")
}

local math = math
local timer = timer
local util = util

SWEP.ViewModel = Model("models/weapons/c_dsword.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1


SWEP.MeleeDamage = 30
SWEP.MeleeRange = 65
SWEP.MeleeSize = SWEP.MeleeRange/5//math.sqrt(SWEP.MeleeRange)*1.5
//SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IsMelee = true

SWEP.UseHands = true

SWEP.HoldType = "melee"
SWEP.SwingHoldType = "grenade"
SWEP.BlockHoldType = "melee2"

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"
SWEP.HitDecal = "Impact.Concrete"

//SWEP.StartSwingingSeqMain = "full_sword_slashone1h"
SWEP.StartSwingAnimation = ACT_VM_PRIMARYATTACK

//SWEP.HitAnim = ACT_VM_PRIMARYATTACK//ACT_VM_HITCENTER
//SWEP.MissAnim = ACT_VM_PRIMARYATTACK//ACT_VM_MISSCENTER

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0,0,0)//Angle(0, -4.313, -7.307)//Angle(59.972, -2.247, -0.278)
SWEP.SwingOffset = Vector(0, 0, 0)


SWEP.BlockSound = Sound("weapons/rpg/shotdown.wav")
SWEP.ParrySound = Sound("npc/manhack/bat_away.wav")

//Determines usefulness of a swep
//If melee power is bigger than block then is adds (melee - block) damage
SWEP.MeleePower = 100
SWEP.BlockPower = 100

SWEP.SpellTime = 0.55

SWEP.ParryWindow = 0.25
SWEP.ParryBonus = 1.3

SWEP.OverrideBlock = false

SWEP.DirectionalHits = {
	Normal = 0,
	Left = 2,
	Right = 3,
}

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "Bone03", rel = "", pos = Vector(2.553, 0.226, -0.253), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {} 
	
end

function SWEP:InitializeClientsideModels_Additional()

	self.AddElements = {}
	
	self.AddElements["spell_cotn"] = {
		["claw1++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_Finger32", rel = "", pos = Vector(1.059, -0.004, -0.079), angle = Angle(0, 0, -90), size = Vector(0.17, 0.17, 0.17), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["claw1++++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_Finger42", rel = "", pos = Vector(1.22, -0.082, 0.002), angle = Angle(0, 0, -90), size = Vector(0.163, 0.163, 0.163), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["claw1+++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_Finger02", rel = "", pos = Vector(1.495, -0.317, 0.141), angle = Angle(0, 6.28, 90), size = Vector(0.24, 0.24, 0.24), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["claw1+"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_Finger22", rel = "", pos = Vector(1.22, 0.158, -0.079), angle = Angle(0, 0, -90), size = Vector(0.219, 0.219, 0.219), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["claw1"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_Finger12", rel = "", pos = Vector(1.06, 0.158, 0.002), angle = Angle(0, 0, -90), size = Vector(0.212, 0.212, 0.212), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.AddElements["spell_toxicbreeze"] = {
		["tree2+"] = { type = "Model", model = "models/props_foliage/driftwood_clump_03a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.849, -0.371, 0.465), angle = Angle(180, -9.9, -97.854), size = Vector(0.009, 0.009, 0.009), color = Color(185, 255, 185, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["tree1"] = { type = "Model", model = "models/props_foliage/driftwood_03a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.2, -0.227, -0.45), angle = Angle(-104.61, 1.735, -76.984), size = Vector(0.009, 0.009, 0.009), color = Color(185, 255, 185, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["tree2"] = { type = "Model", model = "models/props_foliage/driftwood_clump_03a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.246, -0.366, -0.45), angle = Angle(123.929, -16.365, -79.676), size = Vector(0.009, 0.009, 0.009), color = Color(185, 255, 185, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.AddElements["spell_firebolt"] = {
		["burnt3"] = { type = "Model", model = "models/props_debris/concrete_spawnplug001a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.571, -0.311, 0.001), angle = Angle(19.924, -8.315, -87.643), size = Vector(0.025, 0.025, 0.025), color = Color(191, 97, 0, 255), surpresslightning = false, material = "models/props_wasteland/rockcliff04a", skin = 0, bodygroup = {} },
		["burnt1"] = { type = "Model", model = "models/props_canal/rock_riverbed02b.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.187, -0.662, -0.625), angle = Angle(0, -4.107, -87.671), size = Vector(0.024, 0.024, 0.024), color = Color(191, 70, 10, 255), surpresslightning = false, material = "models/props_wasteland/rockcliff04a", skin = 0, bodygroup = {} },
		["burnt2"] = { type = "Model", model = "models/props_canal/rock_riverbed01d.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.15, -0.343, 0.439), angle = Angle(-142.471, -10.77, -107.873), size = Vector(0.009, 0.009, 0.009), color = Color(191, 70, 11, 255), surpresslightning = false, material = "models/props_wasteland/rockcliff04a", skin = 0, bodygroup = {} }
	}
	
	self.AddElements["spell_firebolt2"] = table.Copy(self.AddElements["spell_firebolt"])
	
	self.AddElements["spell_meatbomb"] = {
		["gib2"] = { type = "Model", model = "models/props_junk/Rock001a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.16, -0.137, -1.145), angle = Angle(13.55, -1.231, -104.656), size = Vector(0.125, 0.125, 0.125), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib1"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib6.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.151, -0.385, 0.025), angle = Angle(0.588, -107.1, -82.665), size = Vector(0.472, 0.472, 0.472), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib8"] = { type = "Model", model = "models/props_debris/broken_pile001a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.543, -0.45, 0.15), angle = Angle(-89.118, 11.038, -77.754), size = Vector(0.041, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib6+"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_L_Finger02", rel = "", pos = Vector(0.882, -0.069, 0.18), angle = Angle(-10.547, 121.476, 91.72), size = Vector(0.068, 0.068, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib4"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.327, -0.616, -0.169), angle = Angle(-15.514, -11.249, 19.662), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib5"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib6.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.052, -0.178, -0.792), angle = Angle(-11.808, 85.926, 99.021), size = Vector(0.499, 0.499, 0.499), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib7"] = { type = "Model", model = "models/Gibs/gunship_gibs_midsection.mdl", bone = "ValveBiped.Bip01_L_Finger21", rel = "", pos = Vector(0.592, -0.068, 0), angle = Angle(-4.612, 157.561, 96.444), size = Vector(0.013, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib3"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib1.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.924, 0.064, 1.014), angle = Angle(39.721, -51.547, -43.908), size = Vector(0.559, 0.559, 0.559), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["gib6"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_L_Finger32", rel = "", pos = Vector(0.449, -0.301, 0), angle = Angle(-180, 61.245, 90.449), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}

	
	self.AddElements["spell_teleportation"] =	{
		//["nest2"] = { type = "Model", model = "models/props_hive/nest_lrg_flat.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.131, -0.174, 0), angle = Angle(16.874, -3.192, -77.976), size = Vector(0.012, 0.012, 0.012), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["nest3"] = { type = "Model", model = "models/props_hive/nest_extract.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.066, -0.153, -0.304), angle = Angle(159.414, 0.275, -96.054), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["nest1"] = { type = "Model", model = "models/props_hive/nest_sm_flat.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.352, -0.042, -1.142), angle = Angle(0, -0.706, -92.506), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.AddElements["spell_winterblast"] = {
		["shard2"] = { type = "Model", model = "models/props_wasteland/rockcliff01J.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.374, -0.45, 0.588), angle = Angle(0, 5.697, -71.83), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard6+"] = { type = "Model", model = "models/props_wasteland/prison_wallpile002a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.701, -0.438, 0.875), angle = Angle(14.506, -4.098, 121.434), size = Vector(0.029, 0.029, 0.029), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard3"] = { type = "Model", model = "models/props_wasteland/rockgranite02c.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.224, -0.482, -0.339), angle = Angle(-40.554, -9.688, 180), size = Vector(0.019, 0.019, 0.019), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard6"] = { type = "Model", model = "models/props_wasteland/prison_wallpile002a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.82, -0.513, 0.634), angle = Angle(13.585, 3.055, -70.419), size = Vector(0.029, 0.029, 0.029), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard4"] = { type = "Model", model = "models/props_wasteland/rockgranite02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.592, -0.741, -0.611), angle = Angle(8.965, -88.266, 1.773), size = Vector(0.013, 0.013, 0.013), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard5"] = { type = "Model", model = "models/props_wasteland/rockcliff01f.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.479, -0.774, 0), angle = Angle(-1.795, 2.854, -99.517), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard1"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.177, -0.737, 0.957), angle = Angle(-125.693, -38.737, -123.223), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
	}

	
	for spell,stuff in pairs(self.AddElements) do
		for elname, eltbl in pairs(stuff) do
			self.AddElements[spell][elname].Spell = spell
		end
	end

	if self.VElements then
		for key,uh in pairs(self.AddElements) do
			table.Add(self.VElements,self.AddElements[key])
		end
	end

end

function SWEP:PrecacheModels()

	for k, v in pairs( self.VElements ) do
		if v.model then
			util.PrecacheModel(v.model)
		end
	end
	for k, v in pairs( self.WElements ) do
		if v.model then
			util.PrecacheModel(v.model)
		end
	end
end

function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)
end

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	self:SetWeaponHoldType(self.HoldType)
	self:SetWeaponSwingHoldType(self.SwingHoldType)
	//self:SetWeaponBlockHoldType(self.BlockHoldType)
	
	if CLIENT then
	
		self:InitializeClientsideModels()
		self:InitializeClientsideModels_Additional()
		//self:PrecacheModels()
		self:CreateViewModelElements()
		self:CreateWorldModelElements()   
		
    end
	
	self:OnInitialize() 
end

function SWEP:CreateViewModelElements()
	
	self:CreateModels(self.VElements)
	
	 self.BuildViewModelBones = function( s )
		if MySelf:GetActiveWeapon() == self and self.ViewModelBoneMods then
			for k, v in pairs( self.ViewModelBoneMods ) do
				local bone = s:LookupBone(k)
				if (!bone) then continue end
				local m = s:GetBoneMatrix(bone)
				if (!m) then continue end
				m:Scale(v.scale)
				m:Rotate(v.angle)
				m:Translate(v.pos)
				s:SetBoneMatrix(bone, m)
			end
		end
	end   

	
end

function SWEP:UpdateBonePositions(vm)
	
	if self.ViewModelBoneMods then //MySelf:GetActiveWeapon() == self and 
	
		if self.OnUpdateBonePositions then
			self:OnUpdateBonePositions( vm )
		end
	
		if not self.ViewModelBoneModsSorted then
			self.ViewModelBoneModsSorted = {}
			for k, v in pairs( self.ViewModelBoneMods ) do
				table.insert( self.ViewModelBoneModsSorted, k )
			end			
		end
		
		--for k, v in pairs( self.ViewModelBoneMods ) do
		for k, name in ipairs( self.ViewModelBoneModsSorted ) do
			if not self.ViewModelBoneMods[name] then continue end
					
			local v = self.ViewModelBoneMods[name]

			local bone
			
			if v.cached_bone then
				bone = v.cached_bone
			else
				bone = vm:LookupBone(name)
				v.cached_bone = bone
			end

			if (!bone) then continue end
			if vm:GetManipulateBoneScale(bone) ~= v.scale then
				vm:ManipulateBoneScale( bone, v.scale )
			end
			if vm:GetManipulateBoneAngles(bone) ~= v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) ~= v.pos then
				vm:ManipulateBonePosition( bone, v.pos )
			end
		end
		self.ChangedBoneMods = true
	else
		if self.ChangedBoneMods then
			for i=0, vm:GetBoneCount() do
				if vm:GetManipulateBoneScale(i) ~= vec_norm then
					vm:ManipulateBoneScale( i, vec_norm )
				end
				if vm:GetManipulateBoneAngles(i) ~= ang_zero  then
					vm:ManipulateBoneAngles( i, ang_zero  )
				end
				if vm:GetManipulateBonePosition(i) ~= vec_zero then
					vm:ManipulateBonePosition( i, vec_zero )
				end
			end
			self.ChangedBoneMods = nil
		end
	end
	
end

function SWEP:ResetBonePositions()
	
	if not self.Owner then return end
	local vm = self.Owner.GetViewModel and self.Owner:GetViewModel()
	if !IsValid(vm) then return end
	
	for i=0, vm:GetBoneCount() do
		vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
		vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
		vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
	end
	
end

function SWEP:CreateWorldModelElements()
	self:CreateModels(self.WElements)
end

function SWEP:CheckModelElements()
	if !self.VElements then//or !self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateViewModelElements()
			//self:CreateWorldModelElements()
		end)
	end
end

function SWEP:CheckWorldModelElements()
	if !self.WElements then
		timer.Simple(0,function()
			if self.InitializeClientsideModels then
				self:InitializeClientsideModels()
				self:CreateWorldModelElements()
			end
		end)
	end
end

function SWEP:OnInitialize()
		
end

function SWEP:SetWeaponBlockHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateBlock = new	
end

function SWEP:SetWeaponSwingHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateSwing = new	
end

local BlockActivityTranslate = {}
BlockActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_FIST
BlockActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_IDLE_FIST + 1
BlockActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_IDLE_FIST + 2
BlockActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_FIST + 3
BlockActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_IDLE_FIST + 4
BlockActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_IDLE_FIST + 5
BlockActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_FIST + 5
BlockActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_IDLE_FIST + 6
BlockActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_IDLE_FIST + 6
BlockActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_FIST + 7
BlockActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_FIST + 8


function SWEP:TranslateActivity(act)
	if self:GetSwingEnd() ~= 0 and self.ActivityTranslateSwing[act] ~= nil then
		return self.ActivityTranslateSwing[act]
	end
	
	if self:IsBlocking() and BlockActivityTranslate[act] ~= nil and self.BlockHoldType ~= "melee2" then
		return BlockActivityTranslate[act]
	end

	if self.ActivityTranslate[act] ~= nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

function SWEP:IsMelee()
	return true
end

function SWEP:Deploy()

	if self.Owner and self.Owner:IsValid() and !self.Owner:Alive() then return true end

	local anim = ACT_VM_DRAW
	
	if self.DrawAnim then
		anim = self.DrawAnim
	end

	if self.DrawSeq then
		self:PlaySequence(self.DrawSeq)
		self.IdleAnimation = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	else
		self.Weapon:SendWeaponAnim ( anim )
		
		//print("curtime "..tostring(CurTime()))
		//print("seqduration "..tostring(self.Weapon:SequenceDuration()))
		
		self.IdleAnimation = CurTime() + self.Weapon:SequenceDuration()
	end
	
	//self:OnDeploy()
	
	if CLIENT then
		self:ResetBonePositions()
	end
	
	self:OnDeploy()
	
	

	return true
end

function SWEP:OnDeploy()

end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:Freeze(false)
	end
	self:SetBlocking(false)
	self:StopCasting()

	if CLIENT then
		self:RemoveModels()
		self:ResetBonePositions()
	end
	
end

function SWEP:Equip ( NewOwner )

end

function SWEP:Think()

	if CLIENT then
		//if self.CheckModelElements then
			//self:CheckModelElements()	
		//end
	end
	
	if self.HoldType == "melee2" then
		self:HandleIdleAnims()
	end

	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		if self.IdleSeq then
			self:PlaySequence(self.IdleSeq)
		else
			if self.IdleAnim then
				//self:SendWeaponAnim(self.IdleAnim)
			end
		end

	end

	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
	end
	
	if self.Owner:IsDurationSpell() and self.Owner:KeyDown(IN_ATTACK2) and ( not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() ) then
		self.Owner:CastSpell()
		--if not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() then
			self:SetSpellEnd(CurTime() + self.SpellTime)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.SpellTime)
		--end
	end
	
	if self.Owner:IsDurationSpell() then
		if self:IsCasting() and (self:GetSpellEnd()-self.SpellTime*0.4) <= CurTime() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:StopCasting()
		end
	else
		if self:IsCasting() and self:GetSpellEnd() <= CurTime() then
			self:StopCasting()
		end
	end

	if self:IsBlocking() and (self.NextBlock >= CurTime() or not self.Owner:KeyDown(IN_RELOAD)) then
		self:SetBlocking(false)
	end
	
	if self:IsBlocking() and CLIENT then
		self.BlockAnim = CurTime() + 1
	end
	
	if self.OnThink then
		self:OnThink()
	end
	
end

function SWEP:HandleIdleAnims()
	
	if self.Owner:IsSprinting() then
		self:StopIdleAnims()
		return
	end
	
	if self.Owner:IsSliding() then
		self:StopIdleAnims()
		return
	end
	
	if self.Owner:IsRolling() then
		self:StopIdleAnims()
		return
	end
	
	
	if self.Owner:IsWallrunning() then
		self:StopIdleAnims()
		return
	end
		
	if self.Owner:IsDefending() then
		self:StopIdleAnims()
		return
	end
	
	if !self:GetIdleAnims() then
		self:SetIdleAnims( true )
	end
	
	
end

function SWEP:SetIdleAnims( bl )
	if bl then 
		self.Owner:SetLuaAnimation("melee_idle_2hand") 
	//else
		//self.Owner:StopLuaAnimation("melee_idle_2hand")
	end
	self.IdleAnims = bl
end

function SWEP:GetIdleAnims()
	return self.IdleAnims or false
end

function SWEP:StopIdleAnims()
	if self:GetIdleAnims() then
		self:SetIdleAnims( false )
	end
end

function SWEP:OnDeploy()

end
function SWEP:OnDrop()

end

function SWEP:PreDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(0)
end

function SWEP:PostDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(1)
end 

function SWEP:SecondaryAttack()
	
	if self.Owner:IsSprinting() then return end
	if self:IsBlocking() then return end
	if self:IsSwinging() then return end
	self.Weapon:SetNextSecondaryFire(CurTime() + self.SpellTime)
	if !self.Owner:IsDurationSpell() then
		self.Owner:CastSpell()
		if not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() then
			self:SetSpellEnd(CurTime() + self.SpellTime)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.SpellTime)
			self.Weapon:SetNextSecondaryFire(CurTime() + self.SpellTime)

			self:SetNextAttack(0)

			local cur_spell = self.Owner:GetCurrentSpell()
			
			if cur_spell and cur_spell.CastGesture then
				self.Owner:PlayGesture(cur_spell.CastGesture)
			else
				self.Owner:PlayGesture(ACT_GMOD_GESTURE_ITEM_THROW)
			end
		end
	end
end
SWEP.NextBlock = 0
function SWEP:Reload()
	if self:IsAttacking() then return end
	if self:IsCasting() then return end
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	if self.NextBlock >= CurTime() then return end
	if self:IsBlocking() then return end
	
	//if CurTime() >= self:GetSwingEnd()-0.1 then
	if not self:IsSwinging() then
		self:SetBlocking(true)
	end
	//end

	return false
end

function SWEP:SetBlocking(b)
	self:SetDTBool(0, b)
	if b then 
		self.Owner:SetLuaAnimation("melee_block")
		self:SetParryTime( CurTime() + self.ParryWindow )
	else
		self:ResetParryTime()
	end
end

function SWEP:IsBlocking()
	return self:GetDTBool(0)
end

function SWEP:GetBlockDamageMultiplier(enemy)
	
	if enemy:IsDefending() then
		local wep = enemy:GetActiveWeapon()
		if wep and wep.BlockPower then
			if self.MeleePower > wep.BlockPower then
				local mul = math.abs(self.MeleePower - wep.BlockPower)
				mul = mul/100
				return mul
			end
		end
	end
	//block all by default
	return 0
end

function SWEP:BreakBlock(enemy)
	if CLIENT then return end
	if self.OverrideBlock then return end
	if enemy:IsDefending() then
		local wep = enemy:GetActiveWeapon()
		if wep and wep.SetBlocking then
			wep.NextBlock = CurTime() + 1.5
			wep:SetBlocking(false)
			
		end
	end
	
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsGhosting() then return false end

	return not self:IsSwinging()//self:GetNextPrimaryFire() <= CurTime() and
end

local swing = Sound("npc/zombie/claw_miss1.wav")
function SWEP:PlaySwingSound()
	self:EmitSound(swing, 75, math.Rand(75, 80))
end


function SWEP:PlayStartSwingSound()
	--[[local snd = "npc/combine_soldier/gear"..math.random(6)..".wav"
	self:EmitSound(snd, 60, math.Clamp((SoundDuration(snd) / self.SwingTime) * 100, 50, 240))]]
	//self:PlaySwingSound()
end

for i=1,4 do
	util.PrecacheSound("weapons/melee/golf club/golf_hit-0"..i..".wav")
end
function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(1, 4)..".wav")
end
for i=2,4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end
function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:GenerateHitDirection()
	
	local cur = self.DirectionalHits.Normal
	
	local v = self.Owner:GetVelocity()
	local a = self.Owner:EyeAngles()
	
	local forwardvel = math.max(0, a:Forward():DotProduct(v))
	local backvel = math.max(0, (a:Forward() * -1):DotProduct(v))
	local rightvel = math.max(0, a:Right():DotProduct(v))
	local leftvel = math.max(0, (a:Right() * -1):DotProduct(v))
	
	if rightvel > 0 and forwardvel < rightvel then cur = self.DirectionalHits.Right end
	if leftvel > 0 and forwardvel < leftvel then cur = self.DirectionalHits.Left end
	
	if backvel > 0 and backvel > rightvel and backvel > leftvel then cur = self.DirectionalHits.Normal end

	self:SetHitDirection( cur )
	
end

function SWEP:SetHitDirection( dir )
	self:SetDTInt( 0, dir )
end

function SWEP:GetHitDirection()
	return self:GetDTInt( 0 )
end

function SWEP:PrimaryAttack()
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() and not self.IgnoreSprint then return end
	if self:IsBlocking() then return end
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay - self.Primary.Delay * ((self.Owner._DefaultMeleeSpeedBonus  or 0)/2))
	
	if self.Owner.DashFrames and self.Owner.DashFrames > CurTime() and self:IsTwoHanded() then
	
		self.Owner.DashFrames = nil
		self:GenerateHitDirection()
		if self:GetHitDirection() == 0 then
			self.DashBonus = true
			self:MeleeSwing()
			self.DashBonus = false
			self:SetNextPrimaryFire( CurTime() + 1 )
			if SERVER then
				self.Owner:SetMana( math.Clamp( self.Owner:GetMana() - math.ceil( self.Owner:GetMaxMana() / 2 ), 0, self.Owner:GetMana() ) )
				self.Owner._NextManaRegen = CurTime() + 1.2
			end
		end
	else
		if self.SwingTime == 0 then
			self:MeleeSwing()
		else
			self:StartSwinging()
		end
	end
	
	if not self.OverrideAttackTime then
		self:SetNextAttack(CurTime()+self:SequenceDuration()-0.3)//+0.05self:SequenceDuration()-0.1
	end
end

function SWEP:Holster()

	if CLIENT then
		if IsValid(self.CastPoint) then
			self.CastPoint:StopParticles()
			self.CastPoint.Particle = nil
		end
		self:ResetBonePositions()
		//RestoreViewmodel(self.Owner)
    end
	
	self:StopCasting()
	self:SetBlocking(false)
	
	self:StopIdleAnims()
	
	self:OnHolster()
	
	if self.RestrictHolster then
		return false
	end
	
	return CurTime() >= self:GetSwingEnd() and CurTime() >= self:GetSpellEnd() and !self.Owner:IsCrow()
end

function SWEP:IsTwoHanded()
	return self.StartSwingAnimation == ACT_VM_SECONDARYATTACK
end

function SWEP:OnHolster()

end

function SWEP:SetAnimationTime( time )
	self.CurAnimationTime = time
end

function SWEP:GetAnimationTime()
	return self.CurAnimationTime
end

function SWEP:IsPlayingAnimation()
	return self.CurAnimationTime and self.CurAnimationTime > CurTime()
end

function SWEP:StartSwinging()
	
	local swingtime = self.SwingTime - self.SwingTime * ((self.Owner._DefaultMeleeSpeedBonus or 0)/2)	
	
	if self:IsTwoHanded() then
		
		self:GenerateHitDirection()
		
		local seq = self:SelectWeightedSequence( ACT_VM_SECONDARYATTACK ) 
		
		local played_anim = false
		local anim = "melee_swing"
		
		local punch = Angle( -0.5, 0, 0 )
		
		
		if self:GetHitDirection() == 2 then
			seq = self:LookupSequence( "full_sword_slashone2h" )
			anim = "melee_swing_left"
			punch = Angle( -1, -2, 0 )
			//played_anim = true
		end
		
		if self:GetHitDirection() == 3 then
			seq = self:LookupSequence( "full_sword_slashtwo2h" )
			anim = "melee_swing_right"
			punch = Angle( 1, 2, 0 )
			//played_anim = true
		end
		
		
		local seq2, dur = self:LookupSequence( self:GetSequenceName( seq ) )
		
		local rate = 0.16 / swingtime
		
		//if tonumber( self.Owner:GetInfo("_dd_thirdperson") ) == 0 then
		//	self.Owner:ViewPunch( punch * ( 1/rate ) )
		//end
		
		local time = dur + self.SwingTime// / rate
		
		self:SetAnimationTime( CurTime() + time - 0.3 )
				
		local vm = self.Owner:GetViewModel()
		
		vm:SendViewModelMatchingSequence( seq )
		vm:SetPlaybackRate( rate )
	
		self:SetSequence( seq )
		
		if not played_anim then
			self.Owner:SetLuaAnimation( anim )
			played_anim = true
		end
		
		
	
	else
		

		if self.StartSwingingSeq then
			self:PlaySequence(self.StartSwingingSeq)
			self.IdleAnimation = CurTime() + (IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():SequenceDuration() or 0.85)
		else
			if self.StartSwingAnimation then
				self:SendWeaponAnim(self.StartSwingAnimation)
				local pbr = IsValid(self.Owner:GetViewModel()) and ((self.StartSwingAnimation == ACT_VM_SECONDARYATTACK and 0.16 or 0.17)/swingtime or 1)
				if pbr then
					self.Owner:GetViewModel():SetPlaybackRate(pbr)
				end
				
				//self.IdleAnimation = CurTime() + 1*(1/pbr or 1)+0.1//self:SequenceDuration()
			end
		end
	end
	self:PlayStartSwingSound()
			
	self:SetSwingEnd(CurTime() + swingtime)

end


function SWEP:MeleeSwing()
	local owner = self.Owner

	if self.OverrideAttackTime then
		self:SetNextAttack(CurTime()+self.OverrideAttackTime)
		self.Switch = self.Switch or false
		self.Switch = not self.Switch
	end
	
	local pbr = IsValid(owner:GetViewModel())
	if pbr then
		owner:GetViewModel():SetPlaybackRate(self.AnimSpeed or 1)
	end
	
	//owner:DoAttackEvent()
	owner:SetAnimation(PLAYER_ATTACK1)
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)
	local traces = owner:PenetratingMeleeTrace( self.MeleeRange, self.MeleeSize, filter, self:GetHitDirection() ~= 0 )
	local tr_decal = owner:TraceLine(self.MeleeRange, MASK_SOLID, filter)
	owner:LagCompensation(false)
	
	self.FirstHit = true
	
	local hit = false	
	local blood = false
	
	
	if SERVER and self:IsTwoHanded() then
		/*local trail = "melee_trail_normal"
		
		if self.DashBonus or self.Owner._efSpeedBoost or self.Owner._efAdrenaline then
			trail = "melee_trail_red"
			if self.Owner:Team() == TEAM_BLUE then
				trail = "melee_trail_blue"
			end
		end
		
		ParticleEffectAttach( trail,PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_RH"))*/
		
		local e = EffectData()
			e:SetOrigin( owner:GetPos() )
			e:SetEntity( owner )
			e:SetRadius( self.DashBonus and 1 or 0 )
		util.Effect( "melee_trail", e, nil, true )
		
		local punch = Angle( 3, 0 , 0 )
		
		if self:GetHitDirection() == 2 then
			punch = Angle( 1, 3, 0 )
		end
		
		if self:GetHitDirection() == 3 then
			punch = Angle( 1, -3, 0 )
		end
		
		if tonumber( self.Owner:GetInfo("_dd_thirdperson") ) == 0 then
			self.Owner:ViewPunchReset() 
			self.Owner:ViewPunch( punch )
		end
		
		
	end
	
	for _, tr in ipairs(traces) do

		local block = false	
		local parry_only = false
		local blockmul = 0
		
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetStart(tr.StartPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("RagdollImpact", effectdata)
		
		if tr.Hit then
						
			hit = true
			
			local hitent = tr.Entity
			local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH
			//local damage = self.MeleeDamage
				
			if SERVER then
				if not self.DefaultDamage then
					self.DefaultDamage = self.MeleeDamage
				end
				local add = 0
				if owner._SkillRage then
					add = 11*math.Clamp(1-(owner:Health()/(owner:GetMaxHealth()/2)),0,1)
				end
				//self.MeleeDamage = self.DefaultDamage + (owner._DefaultMeleeBonus or 0) + (add or 0)
				self.MeleeDamage = self.DefaultDamage + (self.DefaultDamage*(owner._DefaultMeleeBonus or 0))/100 + (add or 0)
				
				if hitent.ParryVulnerable and hitent.ParryVulnerable > CurTime() then
					self.MeleeDamage = self.MeleeDamage * self.ParryBonus
				end
				//dunno if i should keep it
				if self.DashBonus then
					self.MeleeDamage = self.MeleeDamage * 1.2
				end
				
			end
			
			
			if hitent:IsPlayer() and owner:SyncAngles():Forward():Dot(hitent:GetAimVector()) < -0.3 and hitent:IsDefending( self.OverrideBlock ) then
				block = true
				blockmul = self:GetBlockDamageMultiplier(hitent)
			end
						
			if hitent:IsPlayer() and owner:SyncAngles():Forward():Dot(hitent:GetAimVector()) < -0.3 and hitent:IsParrying() then
				block = true
			end
			
			if self.FirstHit then
				if self.HitSeq then
					self:PlaySequence(self.HitSeq)
					self.IdleAnimation = CurTime() + (IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():SequenceDuration() or 0.85)
				else
					if self.HitAnimSecond and math.random(2) == 2 then
						self.Weapon:SendWeaponAnim(self.HitAnimSecond)
					else
						if self.HitAnim then
							self.Weapon:SendWeaponAnim(self.HitAnim)
						end
					end
				end
			end	
			
			local norm = (owner:GetShootPos()-tr.HitPos):GetNormal()
			
			if block == false then
				if hitflesh then
					if tr_decal.Hit then
						util.Decal(self.BloodDecal, tr_decal.HitPos + tr_decal.HitNormal*10, tr_decal.HitPos - tr_decal.HitNormal*10)
					end
					self:PlayHitFleshSound()
					blood = true
					
					if SERVER then
						local p = tr.HitPos
						if hitent and hitent:IsValid() then
							p = hitent:NearestPoint( tr.HitPos )
						end
						local e = EffectData()
						e:SetOrigin(p)//tr.HitPos
						e:SetNormal(tr.HitNormal*-1)//owner:GetAimVector():GetNormal()
						util.Effect("melee_blood_hit",e,nil,true)
					end
					if not self.NoHitSoundFlesh then
						self:PlayHitSound()
					end
				else
					local mat = tr.MatType
					if self.MatToParticle[mat] then
						//if not hitent and hitent.NoImpactEffect then
							if CLIENT then
								ParticleEffect(self.MatToParticle[mat][1],tr.HitPos,tr.HitNormal:Angle(),nil)
								sound.Play(self.MatToParticle[mat][3][math.random(1,#self.MatToParticle[mat][3])],tr.HitPos,math.random(90, 110), math.random(90, 110))
							end
						//end
					end
					if tr_decal.Hit then
						util.Decal(self.HitDecal,  tr_decal.HitPos + tr_decal.HitNormal*10, tr_decal.HitPos - tr_decal.HitNormal*10)//
					end
					self:PlayHitSound()
				end
			end

			if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr, block) then
				//owner:LagCompensation(false)
				//return
			end

			if SERVER and hitent:IsValid() then
				if hitent:GetClass() == "func_breakable_surf" then
					hitent:Fire("break", "", 0)
				else	
					//if owner:GetPerk("fireandfury") then
						//self.DamageType = DMG_BURN
					//end
				
					local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamage(self.MeleeDamage)
					dmginfo:SetAttacker(owner)
					dmginfo:SetInflictor(self.Weapon)
					--dmginfo:SetDamageType(DMG_BULLET)
					dmginfo:SetDamageType(self.DamageType)
					
					local force_dir = owner:GetAimVector()
					
					if self:GetHitDirection() == self.DirectionalHits.Left then
						force_dir = owner:GetAimVector() * 0.1 + owner:GetAimVector():Angle():Right() * -1
					end
					
					if self:GetHitDirection() == self.DirectionalHits.Right then
						force_dir = owner:GetAimVector() * 0.1 + owner:GetAimVector():Angle():Right() * 1
					end
					
					dmginfo:SetDamageForce(self.MeleeDamage * 25 * force_dir * (self.ExtraDamageForce or 1))
								
					if hitent:IsPlayer() then
						if not hitent:IsThug() or owner:IsThug() and hitent:IsThug() then
							hitent:MeleeViewPunch(self.MeleeDamage)
						end
												
						if block then
						
							local parry = hitent:IsParrying()
							
							local e = EffectData()
							e:SetOrigin(tr.HitPos)
							e:SetNormal(owner:GetAimVector():GetNormal())
							util.Effect("melee_block",e,nil,true)
							
							if parry then
									
								//owner:EmitSound( self.ParrySound, math.random(100, 120), math.random(100, 120) )	
								WorldSound(self.ParrySound, tr.HitPos, math.random(100, 120), math.random(100, 120), 1)
								
								//negate damage 
								blockmul = 0
								
								//daze the attacker
								self.Weapon:SetNextPrimaryFire(CurTime() + 2)
								self.Weapon:SetNextSecondaryFire(CurTime() + 2)
								self.NextBlock = CurTime() + 2
								
								owner.ParryVulnerable = CurTime() + 2
								
								//owner:SetGroundEntity( NULL )
								//owner:SetLocalVelocity( owner:GetAimVector()*-400 ) 
							
							else
								
								WorldSound(self.BlockSound, tr.HitPos, math.random(90, 110), math.random(90, 110))
						
								self:BreakBlock(hitent)
								
								owner:SetGroundEntity( NULL )
								owner:SetLocalVelocity( owner:GetAimVector()*-400 ) 
								
								hitent:SetGroundEntity( NULL )
								hitent:SetLocalVelocity( owner:GetAimVector()*400 )
							
							end
							
						end
						
						//print(tostring(owner:EyeAngles():Forward():Dot(hitent:GetAngles():Forward())))
					end
					
					if block then
						if blockmul ~= 0 then
							dmginfo:SetDamage(self.MeleeDamage*blockmul)
							hitent:TakeDamageInfo(dmginfo)
						end
					else
						hitent:TakeDamageInfo(dmginfo)
						if owner._SkillBloodThirst and hitent:IsPlayer() then
							owner:RefillHealth(6)
							local e = EffectData()
							e:SetOrigin(owner:GetShootPos())
							e:SetEntity(owner)
							util.Effect("melee_blood_thirst",e,nil,true)
						end
					end


					local phys = hitent:GetPhysicsObject()
					if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
						hitent:SetPhysicsAttacker(owner)
					end
				end
			end

			if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr, block) end

		else
			if self.FirstHit then
				if self.MissSeq then
					self:PlaySequence(self.MissSeq)
					self.IdleAnimation = CurTime() + (IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():SequenceDuration() or 0.85)
				else
					if self.MissAnimSecond and math.random(2) == 2 then
						self.Weapon:SendWeaponAnim(self.MissAnimSecond)
					else
						if self.MissAnim then
							self.Weapon:SendWeaponAnim(self.MissAnim)
							//self.IdleAnimation = CurTime() + self:SequenceDuration()
						end
					end
				end
			end
			
			//self:PlaySwingSound()

			if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
		end
		
		self.FirstHit = false
	
	end
	
	if not hit then
		self:PlaySwingSound()
	end
	
	if blood and CLIENT then
		//self:AddBlood()
		self.Owner:AddBloodyStuff()
	end


end


SWEP.LastSeq = 1
function SWEP:PlaySequence(seq,userandom)


	if type(seq) == "table" then
		if userandom then
			seq = seq[math.random(1,#seq)]
		else
			if self.LastSeq == 1 then
				seq = seq[#seq]
				self.LastSeq = #seq
			else
				seq = seq[1]
				self.LastSeq = 1
			end
		end
	end

	local vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		//vm:ResetSequenceInfo()
		local toplay = vm:LookupSequence(seq)
		vm:ResetSequence(toplay)
		vm:SetCycle(0)
	end
	
	return seq
end

function SWEP:SendWeaponAnimFromSequence( seq, pbr )
	local vm = self.Owner:GetViewModel( )
	
	if type( seq ) == "string" then
		seq = vm:LookupSequence( seq )
	end
	
	vm:SetPlaybackRate( pbr or 1 )
	
	if seq > 0 then
		self:SendWeaponAnim( vm:GetSequenceActivity( seq ) )
		vm:SetPlaybackRate( pbr or 1 )
	end
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(3, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(3)
end


function SWEP:SetDeployTime(tm)
	self:SetDTFloat(1, tm)
end

function SWEP:GetDeployTime()
	return self:GetDTFloat(1)
end

function SWEP:SetNextAttack(tm)
	self:SetDTFloat(2, tm)
end

function SWEP:GetNextAttack()
	return self:GetDTFloat(2)
end

function SWEP:IsAttacking()
	return (self:GetNextAttack() or 0) > CurTime()
end

function SWEP:IsDeploying()
	return (self:GetDeployTime() or 0) > CurTime()
end

function SWEP:SetParryTime( time )
	self:SetDTFloat( 4, time )
end

function SWEP:GetParryTime()
	return self:GetDTFloat( 4 )
end

function SWEP:IsParrying()
	return self:GetParryTime() > CurTime()
end

function SWEP:ResetParryTime()
	self:SetParryTime( 0 )
end

function SWEP:StopCasting()
	self:SetSpellEnd(0)
end

function SWEP:IsCasting()
	return self:GetSpellEnd() > 0
end

function SWEP:SetSpellEnd(spellend)
	self:SetDTFloat(0, spellend)
end

function SWEP:GetSpellEnd()
	return self:GetDTFloat(0)
end

if CLIENT then

local blood_mat = Material( "models/flesh" )

	function SWEP:AddBlood()
		self.Bloody = self.Bloody or 0

		if self.Bloody > 5 then return end
				
		self.Bloody = self.Bloody + 1
		self.BloodScale = self.BloodScale or math.Rand( self.BloodScaleMin or 0.2, self.BloodScaleMax or 0.7 )
		
	end
	
	local render = render
	local table = table
	local pairs = pairs
	local cam = cam
	local math = math
	local CurTime = CurTime
	local FrameTime = FrameTime
	local Vector, Angle = Vector, Angle
	local ipairs = ipairs
	
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
				
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if self.CheckModelElements then
			self:CheckModelElements()	
		end
		
		if not self._ResetBoneMods then
			self:ResetBonePositions()
			self._ResetBoneMods = true
		end
		
		self:CalculateHandMovement()
		
		self:UpdateBonePositions(vm)
		
		local point = self.VElements and self.VElements["cast_point"..(self.ReverseCastHand and "_reversed" or "")] and self.VElements["cast_point"..(self.ReverseCastHand and "_reversed" or "")].modelEnt
		
		if not self.CastPoint then
			self.CastPoint = point
		end
		
		local sp = self.Owner:GetCurrentSpell()
		if sp and sp:IsValid() then
			if sp.HandDraw and not self.Owner:IsJuggernaut() then
				if point and point.LastSpell ~= sp then
					point:StopParticles()
					point.LastSpell = sp
					point.Particle = nil
				end
				sp:HandDraw(self.Owner,self.ReverseCastHand and true or false,point)
			end
		end

		if (!self.VElements) then return end
		
		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				if v.Spell and self.Owner and self.Owner.IsThug and self.Owner:IsThug() then continue end
			
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				if name == "cast_point" and IsValid(self.Owner) then
					ang = self.Owner:GetAimVector():Angle()
				else
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				end

				model:SetAngles(ang)
				
				local size = (v.size.x + v.size.y + v.size.z)/3
				
				if v.fix_scale or self.FixScale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end
				
				if wtf then
					if not model.tex then
						local ind = math.random( 1, 10 )
						model.tex = wtf_tbl[ ind ]
						model:SetMaterial( model.tex:GetName() )
					end
				else
					if (v.material == "") then
						model:SetMaterial("")
					elseif (model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				if model.Spell then
					local sp = self.Owner:GetCurrentSpell()
					if sp and IsValid(sp) and not self.Owner:IsJuggernaut() then
						if sp.ClassName == model.Spell then
							model:SetupBones()
							model:DrawModel()
						end
					end
				else
					model:SetupBones()
					model:DrawModel()
					
					if DD_BLOODYMODELS and self.Bloody and not v.no_blood then
						
						if self.BloodScale then
							GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailscale", self.BloodScale )
						end
						
						GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailblendfactor", self.Bloody * 1.5 )
						
						render.SetBlend( 1 )
						render.SetColorModulation(0.5, 0, 0)
						render.MaterialOverride( GAMEMODE.WeaponBloodMaterial )
						
						model:SetupBones()
						model:DrawModel()

						render.MaterialOverride( nil )
						render.SetColorModulation(1, 1, 1)
						render.SetBlend(1)
					end
					
				end
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()

		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			if wtf and not self.tex then
				local ind = math.random( 1, 10 )
				self.tex = wtf_tbl[ ind ]
			end
			if self.tex and not self.applytex then
				self:SetMaterial( self.tex:GetName() )
				self.applytex = true
			end
			self:DrawModel()
		end
		
		if self.CheckWorldModelElements then
			self:CheckWorldModelElements()	
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in ipairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				
				if name == "cast" and IsValid(self.Owner) then
					ang = self.Owner:GetAimVector():Angle()
				else
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				end

				model:SetAngles(ang)
				
				local size = (v.size.x + v.size.y + v.size.z)/3
				
				if v.fix_scale or self.FixScale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end
				
				if wtf then
					if not model.tex then
						local ind = math.random( 1, 10 )
						model.tex = wtf_tbl[ ind ]
						model:SetMaterial( model.tex:GetName() )
					end
				else
					if (v.material == "") then
						model:SetMaterial("")
					elseif (model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:SetupBones()
				model:DrawModel()
				
				if DD_BLOODYMODELS and self.Bloody and not v.no_blood then
						
					if self.BloodScale then
						GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailscale", self.BloodScale )
					end
						
					GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailblendfactor", self.Bloody * 1.5 )
						
					render.SetBlend( 1 )
					render.SetColorModulation(0.5, 0, 0)
					render.MaterialOverride( GAMEMODE.WeaponBloodMaterial )
						
					model:SetupBones()
					model:DrawModel()

					render.MaterialOverride( nil )
					render.SetColorModulation(1, 1, 1)
					render.SetBlend(1)
				end
				
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:SetLegacyTransform( true )
					v.createdModel = v.model
					
					if v.Spell then
						v.modelEnt.Spell = v.Spell
					end
									
					if self.VElementsBoneMods and self.VElementsBoneMods[k] then
						for bn,tbl in pairs(self.VElementsBoneMods[k]) do
							local bone = v.modelEnt:LookupBone(bn)
							if (!bone) then continue end
							v.modelEnt:ManipulateBoneScale( bone, tbl.scale )
							v.modelEnt:ManipulateBoneAngles( bone, tbl.angle )
							v.modelEnt:ManipulateBonePosition( bone, tbl.pos )
						end
					end
					
					if self.ElementsBoneModsScaleAll and self.ElementsBoneModsScaleAll[k] then
						for i=0, v.modelEnt:GetBoneCount() - 1 do
							//for n,bn in pairs(self.ElementsBoneModsScaleAll[k]) do
								//local bone = v.modelEnt:GetBoneName(i)
								if i ~= v.modelEnt:LookupBone("handle") then
									v.modelEnt:ManipulateBoneScale( i, vector_origin )
									v.modelEnt:ManipulateBonePosition(i,Vector(-99999*99999, 0, -99999*99999))
								end
							//end
						end
					end
					
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function SWEP:OnRemove()
		self:RemoveModels()
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

end

