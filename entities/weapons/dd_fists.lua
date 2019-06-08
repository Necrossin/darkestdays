if SERVER then 
	AddCSLuaFile() 
end

//Melee base
SWEP.Base = "dd_meleebase"

//Models paths
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = Model ( "models/weapons/c_arms_cstrike.mdl" )//"models/weapons/v_c4.mdl"
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl"  )

//Name and fov
SWEP.PrintName = "FISTS!"
SWEP.ViewModelFOV = 50

SWEP.UseHands = true
SWEP.ShowViewModel = false

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.HoldType = "fist"
SWEP.BlockHoldType = "fist"

SWEP.MeleeDamage = 15//11
SWEP.MeleeRange = 36
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)//5

SWEP.SwingTime = 0.15 

//SWEP.ExtraDamageForce = 50

SWEP.BlockPos = Vector(0, -4.672, -5.304)
SWEP.BlockAng = Angle(35.176, 0, 0)

SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

SWEP.Primary.Delay = 0.75

SWEP.SwingHoldType = "fist"

SWEP.NoHitSoundFlesh = true

SWEP.BlockSound = Sound("Boulder.ImpactHard")

SWEP.MeleePower = 30
SWEP.BlockPower = 30

SWEP.OverrideBlock = true

SWEP.BlockSpeed = 0.9

SWEP.DrawSeq = "fists_draw"

SWEP.StartSwingingSeq = {"fists_right","fists_left"}
SWEP.CriticalSeq = "fists_uppercut"

SWEP.IdleSeq = {"fists_idle_01","fists_idle_02"}

function SWEP:RunSequence() return "run_all_02" end

SWEP.NormalViewmodelPos = true

SWEP.UseOldSequences = true

util.PrecacheSound( "NPC_Vortigaunt.Claw" )
util.PrecacheSound( "NPC_Vortigaunt.Kick" )

for i=2,3 do
	util.PrecacheSound("ambient/explosions/explode_"..i..".wav")
end

function SWEP:PlaySwingSound()
	if self:IsCritical() then
		self:EmitSound("npc/zombie/claw_miss1.wav", 75, math.Rand(75, 80))
	else
		self:EmitSound("Weapon_Crowbar.Single")
	end
end

function SWEP:PlayHitSound()
	self:EmitSound(math.random(2) == 2 and "NPC_Vortigaunt.Claw" or "NPC_Vortigaunt.Kick")
end

function SWEP:PlayHitFleshSound()
	
	local martialarts = self.Owner:GetPerk( "martialarts")//SERVER and self.Owner:GetPerk( "martialarts") or CLIENT and self.Owner._MartialArts

	if martialarts then
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(96, 100)) 
		self:EmitSound("weapons/dsword/dsword_hit"..math.random(4)..".wav", 75, math.random(105, 130))
	else
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(96, 100)) 
		self:EmitSound(math.random(2) == 2 and "NPC_Vortigaunt.Claw" or "NPC_Vortigaunt.Kick")
	end
end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	killicon.AddFont( "dd_fists", "Bison_30", "finished off", Color(231, 231, 231, 255 ) ) 
end


function SWEP:UpdateAnimation(velocity, maxseqgroundspeed)	
	self.BlockWeight = self.BlockWeight or 0
	
	if self:IsBlocking() then
		self.BlockWeight = math.Approach( self.BlockWeight, 1, FrameTime() * 5.0 )
	else
		self.BlockWeight = math.Approach( self.BlockWeight, 0, FrameTime()  * 5.0 )
	end
	
	if self.BlockWeight > 0 then
		self.Owner:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_HL2MP_FIST_BLOCK, true )
		self.Owner:AnimSetGestureWeight( GESTURE_SLOT_VCD, self.BlockWeight )
		return true
	end
end

function SWEP:StartSwinging()

	if SERVER then
		if self.Owner:GetPerk( "martialarts" ) then
			self.CanSlice = true
			self.MeleeDamage = 20
		end
	end

	self:SetCritical( false )
	if math.random(8) == 1 then
		self:SetCritical( true )
	end
	
	local seq
	
	if self.StartSwingingSeq then
		if self:IsCritical() then
			seq = self:PlaySequence(self.CriticalSeq)
		else
			seq = self:PlaySequence(self.StartSwingingSeq)
		end
		//self.IdleAnimation = CurTime() + (IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():SequenceDuration() or 0.85)
	else
		if self.StartSwingAnimation then
			self:SendWeaponAnim(self.StartSwingAnimation)
			//self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	end
	self:PlayStartSwingSound()
	
	if SERVER then
		local swingtime = self.SwingTime - self.SwingTime * ((self.Owner._DefaultMeleeSpeedBonus or 0)/2)	
		self:SetSwingEnd(CurTime() + swingtime)
		
		if seq and tonumber( self.Owner:GetInfo("_dd_thirdperson") ) == 0 then
		
			local punch
			
			if seq == "fists_right" then
				punch = Angle( 0, 0.55, 0 )
			end
			
			if seq == "fists_left" then
				punch = Angle( 0, -0.55, 0 )
			end
			
			if seq == "fists_uppercut" then
				punch = Angle( -1.5, 0.1, 0 )
			end
			
			if punch then
				self.Owner:ViewPunchReset() 
				self.Owner:ViewPunch( punch )
			end
		end
		
	end
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	if not block and hitent:IsValid() and hitent:IsPlayer() and not self.m_ChangingDamage and self:IsCritical() then
		self.m_ChangingDamage = true
		self.MeleeDamage = self.MeleeDamage * 3.5
		
		local martialarts = self.Owner:GetPerk( "martialarts")//SERVER and self.Owner:GetPerk( "martialarts") or CLIENT and self.Owner._MartialArts
		
		if not martialarts then
			self.ExtraDamageForce = 80
		else
			self.VerticalSlice = true
		end
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)
	if self.m_ChangingDamage then
		self.m_ChangingDamage = false

		self.MeleeDamage = self.MeleeDamage / 3.5
		self.ExtraDamageForce = 1
	end
	if self:IsCritical() then
	
		local martialarts = self.Owner:GetPerk( "martialarts")//SERVER and self.Owner:GetPerk( "martialarts") or CLIENT and self.Owner._MartialArts
		
		if martialarts then
			self.VerticalSlice = false
		end
	
		self:SetCritical( false )
	end
end

function SWEP:SetBlocking(b)
	self:SetDTBool(0, b)
	if b then 
		self:SetParryTime( CurTime() + self.ParryWindow )
	else
		self:ResetParryTime()
	end
end

function SWEP:SetCritical(b)
	self:SetDTBool(1, b)
end

function SWEP:IsCritical()
	return self:GetDTBool(1)
end


function SWEP:OnThink()

	if self.Owner:IsSliding() then
		self.ChangedAnim = false
		return
	end
	
	if self.Owner:IsWallrunning() then
		self.ChangedAnim = false
		return
	end
	
	if self.Owner:IsRolling() then
		self.ChangedAnim = false
		return
	end
	
	if self.Owner:IsSprinting() then
		self.ChangedAnim = false
		return
	end

	if not self.ChangedAnim then
		local martialarts = self.Owner:GetPerk( "martialarts")//SERVER and self.Owner:GetPerk( "martialarts" ) or CLIENT and self.Owner._MartialArts
		
		if martialarts then
			self.Owner:SetLuaAnimation( "martialarts" )
		end
		
		self.ChangedAnim = true
	end
end

function SWEP:OnHolster()
	self.ChangedAnim = false
end

function SWEP:PreDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(0)
end

function SWEP:PostDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(1)
end

function SWEP:InitializeClientsideModels()
	
	self.BlockMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, 5, 10) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, -10, -10) },
	}

	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -43.01, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 92.236, -4.844) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 69.866, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 80.385, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 64.401, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.738, 15.968, -2.557) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-26.407, 101.139, -13.311) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.209, 40.484, 0.187) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.964, -13.183, -9.631) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.779, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10.393, 85.157, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.138, 94.738, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.314, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 98.341, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.79, -6.579, 2.14) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		/*["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }*/
	}
	
	self.IdleModsStore = {
		["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.676, 91.281, 8.269) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 97.814, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -10.664) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.566, 99.754, -5.789) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 96.542, -16.445) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-30.664, 115.027, 12.409) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 88.783, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.856, 85.073, 0) },
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.25, 89.088, 12.46) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.643, 71.956, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.995, 100.151, 10.541) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 84.208, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 43.04) },
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 83.087, 13.8) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.81, 73.634, 6.11) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.995, 87.288, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.25, 89.146, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.016, 96.956, 8.291) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 82.628, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.457, 88.472, 23.613) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.236, 95.621, -17.473) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.59, 7.533, -13.542) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 101.511, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 70.352, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.323, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 71.295, -9.195) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.772, 81.998, -7.097) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(30.11, 9.079, 31.084) },
		
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0, -0) },
	}
	
	
	for k,tbl in pairs(self.IdleModsStore) do
		if not self.ActionMods[k] then
			self.ActionMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		end
	end


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.BlockMods) do
		--if not self.ViewModelBoneMods[k] then
			self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		--end
	end
	
	for k,tbl in pairs(self.ActionMods) do
		--if not self.ViewModelBoneMods[k] then
			self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		--end
	end		

	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	
end


function SWEP:OnUpdateBonePositions( vm )
	if not self.ChangedFists then
		if self.Owner:GetPerk( "martialarts" ) then//if self.Owner._MartialArts then
			self.IdleMods = table.Copy( self.IdleModsStore )
			--self.ViewModelBoneMods = table.Copy( self.IdleModsStore )
			self.BlockMods = {
				["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-25, 5, 20) },
				["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(40, -10, -15) },
			}
		end
		self.ChangedFists = true
	end
end