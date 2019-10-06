PrecacheParticleSystem( "fx_impact_concrete" )
PrecacheParticleSystem( "fx_impact_dirt" )
PrecacheParticleSystem( "fx_impact_glass" )
PrecacheParticleSystem( "fx_impact_metal" )
PrecacheParticleSystem( "fx_impact_wood" )
PrecacheParticleSystem( "fx_impact_computer" )

SWEP.MatToParticle = {
	
	[MAT_CONCRETE] = {"fx_impact_concrete","Impact.Concrete",{ Sound("physics/concrete/concrete_impact_bullet1.wav"),Sound("physics/concrete/concrete_impact_bullet2.wav"),Sound("physics/concrete/concrete_impact_bullet3.wav"),Sound("physics/concrete/concrete_impact_bullet4.wav")}},//Sound("Concrete.BulletImpact")
	[MAT_DIRT] = {"fx_impact_dirt","Impact.Concrete",{Sound("physics/surfaces/sand_impact_bullet1.wav"),Sound("physics/surfaces/sand_impact_bullet2.wav"),Sound("physics/surfaces/sand_impact_bullet3.wav"),Sound("physics/surfaces/sand_impact_bullet4.wav")}},//Sound("Dirt.BulletImpact")
	[MAT_GLASS] = {"fx_impact_glass","Impact.Glass",{Sound("physics/glass/glass_impact_bullet1.wav"),Sound("physics/glass/glass_impact_bullet2.wav"),Sound("physics/glass/glass_impact_bullet3.wav"),Sound("physics/glass/glass_impact_bullet4.wav")}},//Sound("Glass.BulletImpact")
	[MAT_METAL] = {"fx_impact_metal","Impact.Metal",{Sound("physics/metal/metal_solid_impact_bullet1.wav"),Sound("physics/metal/metal_solid_impact_bullet2.wav"),Sound("physics/metal/metal_solid_impact_bullet3.wav"),Sound("physics/metal/metal_solid_impact_bullet4.wav")}},//Sound("SolidMetal.BulletImpact")
	[MAT_WOOD] = {"fx_impact_wood","Impact.Concrete",{Sound("physics/wood/wood_solid_impact_bullet1.wav"),Sound("physics/wood/wood_solid_impact_bullet2.wav"),Sound("physics/wood/wood_solid_impact_bullet3.wav"),Sound("physics/wood/wood_solid_impact_bullet4.wav"),Sound("physics/wood/wood_solid_impact_bullet5.wav")}},//Sound("Wood.BulletImpact")
	[MAT_COMPUTER] = {"fx_impact_computer","Impact.Concrete",{Sound("physics/glass/glass_impact_bullet1.wav"),Sound("physics/glass/glass_impact_bullet2.wav"),Sound("physics/metal/metal_computer_impact_bullet1.wav"),Sound("physics/metal/metal_computer_impact_bullet2.wav"),Sound("physics/metal/metal_computer_impact_bullet3.wav"),Sound("physics/plastic/plastic_box_impact_bullet1.wav"),Sound("physics/plastic/plastic_box_impact_bullet2.wav"),Sound("physics/plastic/plastic_box_impact_bullet3.wav")}},//Sound("Computer.BulletImpact")
	[MAT_TILE] = {"fx_impact_concrete","Impact.Concrete",{Sound("physics/surfaces/tile_impact_bullet1.wav"),Sound("physics/surfaces/tile_impact_bullet2.wav"),Sound("physics/surfaces/tile_impact_bullet3.wav"),Sound("physics/surfaces/tile_impact_bullet4.wav")}},//Sound("Tile.BulletImpact")
}

SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""


SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.RecoilKick = 0.1
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01

SWEP.Primary.Cone			= 0.005
SWEP.Primary.ConeMoving		= 0.01
SWEP.Primary.ConeCrouching	= 0.002
SWEP.Primary.Delay			= 0.8

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.Tracer 				= "Tracer"//"Tracer"//""
SWEP.ShellEjectAttachment	= 2
SWEP.ShellEffect			= "none"
SWEP.MuzzleAttachment		= 1//"1"
SWEP.MuzzleEffect			= "none"

SWEP.IronSightMultiplier    = 0.5

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.SpellTime = 0.55//0.66//1.1

PrecacheParticleSystem( "gun_smoke_small" )
PrecacheParticleSystem( "gun_smoke_small_2" )
PrecacheParticleSystem( "dd_muzzleflash" )
PrecacheParticleSystem( "dd_tracer" )
PrecacheParticleSystem( "dd_tracer_cursed" )
PrecacheParticleSystem( "bullet_tracer01" )


function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound("sound/buttons/weapon_confirm.wav")
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {}
	self.VElements = {}
	self.WElements = {} 	
end

function SWEP:InitializeClientsideModels_Additional( spell_1, spell_2 )

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

	
	self.AddElements["spell_winterblast"] = {
		["shard2"] = { type = "Model", model = "models/props_wasteland/rockcliff01J.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.374, -0.45, 0.588), angle = Angle(0, 5.697, -71.83), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard6+"] = { type = "Model", model = "models/props_wasteland/prison_wallpile002a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.701, -0.438, 0.875), angle = Angle(14.506, -4.098, 121.434), size = Vector(0.029, 0.029, 0.029), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard3"] = { type = "Model", model = "models/props_wasteland/rockgranite02c.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.224, -0.482, -0.339), angle = Angle(-40.554, -9.688, 180), size = Vector(0.019, 0.019, 0.019), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard6"] = { type = "Model", model = "models/props_wasteland/prison_wallpile002a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.82, -0.513, 0.634), angle = Angle(13.585, 3.055, -70.419), size = Vector(0.029, 0.029, 0.029), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard4"] = { type = "Model", model = "models/props_wasteland/rockgranite02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.592, -0.741, -0.611), angle = Angle(8.965, -88.266, 1.773), size = Vector(0.013, 0.013, 0.013), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard5"] = { type = "Model", model = "models/props_wasteland/rockcliff01f.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.479, -0.774, 0), angle = Angle(-1.795, 2.854, -99.517), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["shard1"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.177, -0.737, 0.957), angle = Angle(-125.693, -38.737, -123.223), size = Vector(0.009, 0.009, 0.009), color = Color(230, 230, 230, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
	}
	
	self.AddElements["spell_teleportation"] =	{
		//["nest2"] = { type = "Model", model = "models/props_hive/nest_lrg_flat.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.131, -0.174, 0), angle = Angle(16.874, -3.192, -77.976), size = Vector(0.012, 0.012, 0.012), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["nest3"] = { type = "Model", model = "models/props_hive/nest_extract.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.066, -0.153, -0.304), angle = Angle(159.414, 0.275, -96.054), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["nest1"] = { type = "Model", model = "models/props_hive/nest_sm_flat.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.352, -0.042, -1.142), angle = Angle(0, -0.706, -92.506), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
	for spell,stuff in pairs(self.AddElements) do
		for elname, eltbl in pairs(stuff) do
			self.AddElements[spell][elname].Spell = spell
		end
	end
		
	if self.VElements then
		if spell_1 and IsValid( spell_1 ) and spell_1:GetClass() and self.AddElements[ spell_1:GetClass() ] then
			table.Add( self.VElements, self.AddElements[ spell_1:GetClass() ] )
		end
		if spell_2 and IsValid( spell_2 ) and spell_2:GetClass() and self.AddElements[ spell_2:GetClass() ] then
			table.Add( self.VElements, self.AddElements[ spell_2:GetClass() ] )
		end
	end

end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	//self:SetDeploySpeed(1.1)

	if CLIENT then
	
		local spell_1, spell_2
		
		if self.Owner and self.Owner:IsValid() then
			spell_1, spell_2 = self.Owner:GetDTEntity( 1 ), self.Owner:GetDTEntity( 2 )
		end
	
		self:InitializeClientsideModels()
		self:InitializeClientsideModels_Additional( spell_1, spell_2 )
		self:CreateViewModelElements()
		self:CreateWorldModelElements()  
		
    end
	
	self:OnInitialize() 
	
end

function SWEP:CreateViewModelElements()
	
	local toadd = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Right_Hand", rel = "", pos = Vector(0.864, -0.072, -0.68), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point_reversed"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Left_Hand", rel = "", pos = Vector(1.417, -0.566, -0.689), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	if self.VElements then
		//table.Merge(self.VElements,toadd)
	end
	
	//PrintTable(self.VElements)
	
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

	//MakeNewArms(self)
	
end

local vec_norm = Vector(1, 1, 1)
local vec_zero = Vector(0, 0, 0)
local ang_zero = Angle(0, 0, 0)

/*local allbones
local hasGarryFixedBoneScalingYet = true

function SWEP:UpdateBonePositions(vm)

	if self.ViewModelBoneMods then

		if (!vm:GetBoneCount()) then return end

		
		local loopthrough = self.ViewModelBoneMods
		if (!hasGarryFixedBoneScalingYet) then
			allbones = {}
			for i=0, vm:GetBoneCount() do
				local bonename = vm:GetBoneName(i)
				if (self.ViewModelBoneMods[bonename]) then
					allbones[bonename] = self.ViewModelBoneMods[bonename]
				else
					allbones[bonename] = {
						scale = Vector(1,1,1),
						pos = Vector(0,0,0),
						angle = Angle(0,0,0)
					}
				end
			end

			loopthrough = allbones
		end
	

		for k, v in pairs( loopthrough ) do
			local bone = vm:LookupBone(k)
			if (!bone) then continue end

			
			local s = Vector(v.scale.x,v.scale.y,v.scale.z)
			local p = Vector(v.pos.x,v.pos.y,v.pos.z)
			local ms = Vector(1,1,1)
			if (!hasGarryFixedBoneScalingYet) then
				local cur = vm:GetBoneParent(bone)
				while(cur >= 0) do
					local pscale = loopthrough[vm:GetBoneName(cur)].scale
					ms = ms * pscale
					cur = vm:GetBoneParent(cur)
				end
			end

			s = s * ms

			if vm:GetManipulateBoneScale(bone) != s then
				vm:ManipulateBoneScale( bone, s )
			end
			if vm:GetManipulateBoneAngles(bone) != v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) != p then
				vm:ManipulateBonePosition( bone, p )
			end
		end
	else
		self:ResetBonePositions(vm)
	end

end*/


function SWEP:UpdateBonePositions(vm)
	
	if self.ViewModelBoneMods then //MySelf:GetActiveWeapon() == self and 
		if not self.ViewModelBoneModsSorted then
			self.ViewModelBoneModsSorted = {}
			for k, v in pairs( self.ViewModelBoneMods ) do
				table.insert( self.ViewModelBoneModsSorted, k )
			end
		end
		
		local bonemods = self.ViewModelBoneMods
		local sorted = self.ViewModelBoneModsSorted
		
		for i = 1, #sorted do
			local name = sorted[ i ]
			if not bonemods[name] then continue end
					
			local v = bonemods[name]

			local bone
			
			if v.cached_bone then
				bone = v.cached_bone
			else
				bone = vm:LookupBone(name)
				v.cached_bone = bone
			end

			if (!bone) then continue end
			
			if v.cur_scale ~= v.scale then
				vm:ManipulateBoneScale( bone, v.scale )
				v.cur_scale = v.scale
			end
			if v.cur_angle ~= v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
				v.cur_angle = v.angle
			end
			if v.cur_pos ~= v.pos then
				vm:ManipulateBonePosition( bone, v.pos )
				v.cur_pos = v.pos
			end
			
			/*if vm:GetManipulateBoneScale(bone) ~= v.scale then
				vm:ManipulateBoneScale( bone, v.scale )
			end
			if vm:GetManipulateBoneAngles(bone) ~= v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) ~= v.pos then
				vm:ManipulateBonePosition( bone, v.pos )
			end*/
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

/*function SWEP:UpdateBonePositions(vm)
	
	if MySelf:GetActiveWeapon() == self and self.ViewModelBoneMods then
		for k, v in pairs( self.ViewModelBoneMods ) do
			local bone = vm:LookupBone(k)
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
	else
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
	end
	
end*/
function SWEP:ResetBonePositions()
	
	if !IsValid(self.Owner) then return end
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
	if !self.VElements then// or !self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:InitializeClientsideModels_Additional()
			self:CreateViewModelElements()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:CheckWorldModelElements()
	if !self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:OnInitialize()

end

function SWEP:PrimaryAttack()

	if SERVER and self.Owner.SpawnProtection and self.Owner.SpawnProtection > CurTime() then
		self.Owner.SpawnProtection = 0
	end
	
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() and not ( self.IgnoreSprint or self.Owner:IsSliding() ) then 
		self.Owner.NextSprint = CurTime() + 0.5
		return 
	end
	if self.Owner:IsWallrunning() and not self.IgnoreSprint then 
		self.Owner.NextSprint = CurTime() + 0.5
		return 
	end
	if not ( self.IgnoreSprint or self.Owner:IsSliding() ) then
		self.Owner.NextSprint = CurTime() + 0.2
	end
	if not self:CanPrimaryAttack() then return end	

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay * self:GetPrimaryDelayModifier() )
	self:EmitFireSound()

	self:TakeAmmo()
	
	local Owner = self.Owner
	
	if self.Primary.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		Owner:ViewPunch(Angle(r * -self.Primary.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Primary.Recoil))
		
		if ( ( game.SinglePlayer() and SERVER ) or ( ( not game.SinglePlayer() ) and CLIENT and IsFirstTimePredicted() ) ) then
			local eyeang = self:GetOwner():EyeAngles()
			local recoil = self.Primary.Recoil
			eyeang.pitch = eyeang.pitch - recoil * ( self.Primary.RecoilKick or 0.1 )
			self:GetOwner():SetEyeAngles( eyeang )
		end
	end
	//Owner:ViewPunch( Angle(self.Primary.Recoil * -0.1, 0, math.Rand(-0.05,0.05) * self.Primary.Recoil) )

	//if Owner.ViewPunch then Owner:ViewPunch( Angle(self.Primary.Recoil * -0.1, math.Rand(-0.05,0.05) * self.Primary.Recoil, 0) ) end
	/*if ( ( SinglePlayer() && SERVER ) || ( !SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = self.Primary.Recoil//math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil*0.1
		self.Owner:SetEyeAngles( eyeang )
	end*/
	
	if self.IsShotgun then
		self.Owner:PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN )
	end
	
	self:FireBullet()

	self.IdleAnimation = CurTime() + ( self:SequenceDuration() or 0 )
	
	--if CLIENT then
		--self.NextAttack = CurTime()+self:SequenceDuration()+0.5
		self:SetNextAttack(CurTime()+(self:SequenceDuration() or 0)+0.5)
	--end
	
	self:OnPrimaryAttack()
end

function SWEP:OnPrimaryAttack()

end

function SWEP:GetPrimaryDelayModifier()
	return 1
end

function SWEP:Think()
	
	if not self.IsShotgun and self:IsReloading() and self:GetReloadEnd() <= CurTime() then
		self:ActualReload()
		self:SetReloadEnd( 0 )
	end
	
	if self.Owner:IsDurationSpell() and self.Owner:KeyDown(IN_ATTACK2) and ( not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() ) and not self:IsReloading() then
		self.Owner:CastSpell()
		--if not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() then
			self:SetSpellEnd(CurTime() + self.SpellTime)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.SpellTime)
		--end
	end
	
	if self.Owner:IsDurationSpell() then
		if self:IsCasting() and ( (self:GetSpellEnd()-self.SpellTime*0.4) <= CurTime() and not self.Owner:KeyDown(IN_ATTACK2) or self:IsReloading() ) then
			self:StopCasting()
		end
	else
		if self:IsCasting() and self:GetSpellEnd() <= CurTime() then
			self:StopCasting()
		end
	end
	
	self:OnThink()

	self:NextThink(CurTime())
	return true
end

function SWEP:OnThink()
end

function SWEP:FireBullet()

	if self.Owner:GetVelocity():Length() > 30 then
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.ConeMoving)
	else
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.ConeCrouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)

	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end
end

function SWEP:Deploy()

	if self.Owner and self.Owner:IsValid() and !self.Owner:Alive() then return true end

	self:SetNextReload(0)
	self:SetIronsights(false)
	

	local anim// = ACT_VM_DRAW
	if self.DrawAnim then
		anim = self.DrawAnim
		self.Weapon:SendWeaponAnim( anim )
	end
		
	self.IdleAnimation = CurTime() + self.Weapon:SequenceDuration()
	
	if not self.IgnoreDeploy then
		self:SetDeployTime(CurTime() + self.Weapon:SequenceDuration())
	end
	
	if CLIENT then
		self:ResetBonePositions()
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			vm:StopParticles()
		end
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	self:OnDeploy()
	
	return true
end

function SWEP:OnDeploy()
//MakeNewArms(self)
end

function SWEP:Holster()

	if CLIENT then
		if IsValid(self.CastPoint) then
			self.CastPoint:StopParticles()
			self.CastPoint.Particle = nil
			
		end
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			vm:StopParticles()
		end
		//RestoreViewmodel(self.Owner)
		self:ResetBonePositions()
    end
	
	self:StopCasting()
	
	self:OnHolster()
	
	self:SetReloadEnd( 0 )
	
	if self.RestrictHolster then
		return false
	end
	
	return CurTime() >= self:GetSpellEnd() and !self.Owner:IsCrow()
end

function SWEP:OnHolster()

end

function SWEP:OnRemove()
	self:StopCasting()
  
    if CLIENT then
        self:RemoveModels()
		self:ResetBonePositions()
		--RestoreViewmodel(self.Owner)		
    end
     
end

function SWEP:Equip ( NewOwner )
end

function SWEP:OnDrop()

end

function SWEP:TranslateActivity(act)
	if self:GetIronsights() and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end

	return self.ActivityTranslate[act] or -1
end

function SWEP:TakeAmmo()
	if SERVER then
		local totake = 1
		if self.Owner and self.Owner._DefaultBulletConsumeBonus > 0 then// and !self.IsShotgun then
			if math.Rand(0,1) <= self.Owner._DefaultBulletConsumeBonus then
				totake = 0
			end
		end
		self:TakePrimaryAmmo(totake)
	end
end

SWEP.CurReload = 0
SWEP.TotalReload = 0

function SWEP:Reload()
	
	local fast_reload = false
	
	if SERVER and self.Owner._SkillFastReload then
		fast_reload = true
	end
	
	if CLIENT and self.Owner._FastReload then
		fast_reload = true
	end

	self:FastReload( fast_reload and 1.7 or 1 )
	
	/*local act = ACT_VM_RELOAD
	if self.ReloadAnim then
		act = self.ReloadAnim
	end
	if self:IsCasting() then return end
	if self.Owner:IsCrow() then return end
	if self:GetNextReload() <= CurTime() and self:DefaultReload(act) then
		if not self.ReloadDuration then
			self.ReloadDuration = self:SequenceDuration()
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(CurTime() + (self.ReloadDuration or self:SequenceDuration()))
		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
		self:OnReload()
		
		self.TotalReload = CurTime() + self.ReloadDuration
		
		self.Owner.FastReload = CurTime() + self.ReloadDuration
	end*/
end

function SWEP:ActualReload()
	
	if CLIENT then return end
	
	local owner = self.Owner
	
	if owner and owner:IsValid() then
		
		local am = math.min( self.Primary.ClipSize - self:Clip1(), owner:GetAmmoCount( self:GetPrimaryAmmoType() )  )
		self:SetClip1( self:Clip1() + am )
		owner:RemoveAmmo( am, self:GetPrimaryAmmoType() )
	
	end
	
end

function SWEP:FastReload( rate )

	if self:IsReloading() then return end
	if self:Clip1() >= self.Primary.ClipSize then return end
	local am = math.min( self.Primary.ClipSize - self:Clip1(), self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )  )
	if am == 0 then return end
	
		
	local seq = self:SelectWeightedSequence( self.ReloadAnim or ACT_VM_RELOAD ) 
		
	local vm = self.Owner:GetViewModel()
			
	local seq2, dur = self:LookupSequence( self:GetSequenceName( seq ) )
		
	local time = dur / rate
	
	vm:SetCycle( 0 )
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate )
	
	self:SetSequence( seq )
	
	self.Owner:DoReloadEvent()
	
	self:SetReloadEnd( CurTime() + time )
	
end

function SWEP:OnReload()

end

function SWEP:GetIronsights()
	return self:GetDTBool(0) or false
end

function SWEP:TakePrimaryAmmo( num )
 
	// Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then
		if ( self:Ammo1() <= 0 ) then return end
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	return end

	self.Weapon:SetClip1( self.Weapon:Clip1() - num )
 
end 

function SWEP:CanPrimaryAttack()
	
	if self.Owner:IsGhosting() then return false end

	if self:Clip1() <= 0 and !self:IsReloading() then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload() 

		return false
	end

	return !self:IsReloading()
end

function SWEP:SecondaryAttack()
	
	if SERVER and self.Owner.SpawnProtection and self.Owner.SpawnProtection > CurTime() then
		self.Owner.SpawnProtection = 0
	end
	if self:IsReloading() then return end

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

function SWEP:IsShooting()
	return (self:GetNextAttack() or 0) > CurTime()
end

function SWEP:IsDeploying()
	return (self:GetDeployTime() or 0) > CurTime()
end

/*function SWEP:IsReloading()
	return (self:GetNextReload() or 0) > CurTime()
end*/


function SWEP:IsReloading()
	return self:GetReloadEnd() > 0
end

function SWEP:SetReloadEnd( rel )
	self:SetDTFloat( 3, rel )
end

function SWEP:GetReloadEnd()
	return self:GetDTFloat( 3 )
end

function SWEP:StopCasting()
	self:SetSpellEnd(0)
end

function SWEP:IsCasting()
	return self:GetSpellEnd() > 0
end

function SWEP:SetSpellEnd(spellend)
	self:SetDTFloat(0, spellend)
	if CLIENT then
		self.SpellCastingTime = spellend
	end
end

function SWEP:GetSpellEnd()
	return self:GetDTFloat(0)
end


function SWEP:OnRestore()
	self:SetIronsights(false)
	self:StopCasting()
end

local tempknockback
function SWEP:StartBulletKnockback()
	tempknockback = {}
end

function SWEP:EndBulletKnockback()
	tempknockback = nil
end

function SWEP:DoBulletKnockback()
	for ent, prevvel in pairs(tempknockback) do
		local curvel = ent:GetVelocity()
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.5 + prevvel)
	end
end

function SWEP:AdditionalCallback(attacker, tr, dmginfo)	

end

local fleshsound ={
			"physics/gore/flesh_impact_bullet1.wav",
			"physics/gore/flesh_impact_bullet2.wav",
			"physics/gore/flesh_impact_bullet3.wav",
			"physics/gore/flesh_impact_bullet4.wav",
			"physics/gore/flesh_impact_bullet5.wav",
		}

function SWEP:DoImpactEffect( tr, dmg ) 

	local ent = tr.Entity
	if IsValid(ent) then
		if ent:IsPlayer() then
			local block = tr.Normal:Dot(ent:GetAimVector()) <= -0.3 and ent:IsDefending() or false
			if block then
				return true
			end
		end
	end
	
	if ent and ent.NoImpactEffect then return true end
	
	if CLIENT and not DD_NOIMPACTFX then
		local mat = tr.MatType
		if self.MatToParticle[mat] then
			ParticleEffect(self.MatToParticle[mat][1],tr.HitPos,tr.HitNormal:Angle(),nil)
		end
	end
	
	return false
	
end

function GenericBulletCallback(attacker, tr, dmginfo)//function GenericBulletCallback(attacker, tr, dmginfo)
	if SERVER then
		if attacker:GetActiveWeapon().Tracer ~= "" then			
			local e = EffectData()
			e:SetOrigin(tr.HitPos)
			e:SetEntity(attacker:GetActiveWeapon())
			if attacker:GetActiveWeapon().UseCursedTracer then
				e:SetScale(1)
			else
				e:SetScale(2)
			end
			util.Effect("dd_effect_tracer",e,nil,true)
		end
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetStart(tr.StartPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("RagdollImpact", effectdata)
	
	local ent = tr.Entity
	if IsValid(ent) then
		if ent:IsPlayer() then
			if ent.Team and attacker.Team and not attacker:IsTeammate(ent) /*ent:Team() ~= attacker:Team()*/ and tempknockback then
				tempknockback[ent] = ent:GetVelocity()
			end
			local block = tr.Normal:Dot(ent:GetAimVector()) <= -0.5 and ent:IsDefending() or false
			if not block then
				if SERVER then
					//hacky way to keep shotguns to have this bodyshot effect
					if attacker:GetActiveWeapon().IsShotgun then
						
						//more hacky stuff
						if tr.HitGroup == HITGROUP_HEAD or tr.HitGroup == HITGROUP_LEFTARM or tr.HitGroup == HITGROUP_RIGHTARM or tr.HitGroup == HITGROUP_RIGHTLEG or tr.HitGroup == HITGROUP_LEFTLEG then
							ent.LastHitGrNormal = tr.HitGroup
						end
						
						--if tr.HitGroup == HITGROUP_HEAD then
							--ent.LastHitBoxBone = tr.HitBoxBone
						--end
						
						if tr.HitGroup == HITGROUP_CHEST or tr.HitGroup == HITGROUP_STOMACH then//or tr.HitGroup == HITGROUP_GENERIC
							ent.LastHitBox = tr.HitBox
							ent.LastHitGr = tr.HitGroup
							ent.LastHitPos = tr.HitPos
						else
							//ent.LastHitBox = nil
							//ent.LastHitGr = nil
							//ent.LastHitPos = nil
						end
					else
						ent.LastHitBox = tr.HitBox
						ent.LastHitGr = tr.HitGroup
						ent.LastHitPos = tr.HitPos
						--ent.LastHitBoxBone = tr.HitBoxBone
					end
					
				end
				util.Decal("Blood", tr.HitPos + tr.HitNormal*10, tr.HitPos - tr.HitNormal*10)
				util.Decal("Blood", tr.HitPos + tr.HitNormal*10, tr.HitPos - tr.HitNormal*10)
				util.Decal("Blood", tr.HitPos-vector_up*3 + tr.HitNormal*10, tr.HitPos-vector_up*3 - tr.HitNormal*10)
				if CLIENT then
					if tr.HitGroup == HITGROUP_HEAD then
						local e = EffectData()
						e:SetOrigin(tr.HitPos)
						e:SetNormal(tr.HitNormal)
						util.Effect("melee_blood_hit",e)
					end
				end
				local inflictor = dmginfo:GetInflictor()
				--if !(inflictor and inflictor:IsValid() and inflictor:IsPlayer() and inflictor:GetActiveWeapon() and inflictor:GetActiveWeapon():IsValid() and inflictor:GetActiveWeapon().IsShotgun) then
					--sound.Play(fleshsound[math.random(1,5)],tr.HitPos,120, 100,1)//fleshsound[math.random(1,5)]"DD.FleshImpactBullet"
				--end
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end
	end
end


function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:FireAnimationEvent( pos, ang, event )
	if (event == 20) then return true end
	
	if ( event == 5001 or event == 5011 or event == 5021 or event == 5031 ) then
		return true
	end

	
end

//SWEP.BulletCallback = GenericBulletCallback

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self.Owner
	--self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SendWeaponAnimation()
	owner:SetAnimation(PLAYER_ATTACK1)
	self:StartBulletKnockback()
	owner:FireBullets({Num = numbul, 
					Src = owner:GetShootPos(), 
					Dir = owner:GetAimVector(), 
					Spread = Vector(cone, cone, 0), 
					Tracer = 1, TracerName = "",//self.Tracer,//"dd_effect_tracer",//self.Tracer, 
					Force = dmg/(numbul or 1), 
					Damage = dmg, 
					Callback = GenericBulletCallback,//function(attacker, tr, dmginfo)////self.BulletCallback//function(...)//

						//GenericBulletCallback(attacker, tr, dmginfo)
						//self:BulletCallback(...)
						//self:AdditionalCallback(...)
					//end
					})
	self:DoBulletKnockback()
	self:EndBulletKnockback()
	
	if CLIENT then
		self.NextGunSmoke = self.NextGunSmoke or 0
		
		if self.Owner then
			if self.Owner == MySelf then
				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					if self.NextGunSmoke < CurTime() and (math.random(15) == 15 or self.Weapon:Clip1() == 0) and not self.NoSmoke then 
						vm:StopParticles()
						ParticleEffectAttach("gun_smoke_small_2",PATTACH_POINT_FOLLOW,vm,1)
						if self.Dual then
							ParticleEffectAttach("gun_smoke_small_2",PATTACH_POINT_FOLLOW,vm,2)
						end
						self.NextGunSmoke = CurTime() + 3
					end
					local att = "1"
					if self.MuzzleAttachment then
						att = self.MuzzleAttachment
					end
				end	
			end
		end
	end
	self:ShootCustomEffects()
end

function SWEP:ShootCustomEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	if not IsFirstTimePredicted() then return end
	
	
	if self.MuzzleEffect ~= "none" then
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
		fx:SetNormal(PlayerAim)
		fx:SetAttachment(self.MuzzleAttachment)//
		util.Effect(self.MuzzleEffect,fx)
	end
	
	if self.ShellEffect ~= "none" then
		if self.ShellEffect then
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(PlayerAim)
			fx:SetAttachment(self.ShellEjectAttachment)
			util.Effect(self.ShellEffect,fx)
		end
	end
	
end
