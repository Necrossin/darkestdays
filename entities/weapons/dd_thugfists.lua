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

//SWEP.UseHands = true

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.HoldType = "fist"
SWEP.BlockHoldType = "fist"

SWEP.MeleeDamage = 43
SWEP.MeleeRange = 50
SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)//5

SWEP.SwingTime = 0.17 

SWEP.ExtraDamageForce = 50

SWEP.BlockPos = Vector(0, -4.672, -5.304)
SWEP.BlockAng = Angle(35.176, 0, 0)

SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

SWEP.Primary.Delay = 0.75

SWEP.SwingHoldType = "fist"

SWEP.ChargeSpeed = 500

function SWEP:RunSequence()
	if self:IsChargeAttacking() then
		return "run_all_charging"
	end
	return "run_all_02" 
end

SWEP.NoHitSoundFlesh = true

SWEP.BlockSound = Sound("Boulder.ImpactHard")

SWEP.MeleePower = 80
SWEP.BlockPower = 80

SWEP.DrawSeq = "fists_draw"

SWEP.StartSwingingSeq = {"fists_right","fists_left"}
SWEP.CriticalSeq = "fists_uppercut"//"fists_uppercut","fists_right"

//SWEP.HitSeq = {"fists_right","fists_left"}
//SWEP.MissSeq = {"fists_right","fists_left"}

SWEP.IdleSeq = {"fists_idle_01","fists_idle_02"}

SWEP.ChargeWindup = 1.3

SWEP.NormalViewmodelPos = true

SWEP.UseOldSequences = true

SWEP.Dismember = true

//SWEP.OverrideAttackTime = 0.18

for i=2,3 do
	util.PrecacheSound("ambient/explosions/explode_"..i..".wav")
end

for i=1,4 do
	util.PrecacheSound("physics/concrete/boulder_impact_hard"..i..".wav")
end

//function SWEP:PlaySwingSound()
//	self:EmitSound("Weapon_Crowbar.Single")
//end

function SWEP:OnInitialize()
	if SERVER then
		//self.Windup = CreateSound(self,"ambient/alarms/train_horn2.wav")//ambient/levels/citadel/portal_open1_adpcm.wav
		//self.Ram = CreateSound(self, "ambient/machines/train_wheels_loop1.wav")//ambient/machines/train_freight_loop2.wav
	end
end

function SWEP:OnDeploy()
	if SERVER then
		--self.Windup = CreateSound(self.Owner,"ambient/alarms/train_horn2.wav")
		--self.Ram = CreateSound(self.Owner, "ambient/machines/train_wheels_loop1.wav")
	end
end


function SWEP:PlayHitSound()
	self:EmitSound(math.random(2) == 2 and "NPC_Vortigaunt.Claw" or "NPC_Vortigaunt.Kick")
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav",45, math.Rand(110, 120), 1, CHAN_AUTO)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90), 1, CHAN_AUTO) 
	self:EmitSound(math.random(2) == 2 and "NPC_Vortigaunt.Claw" or "NPC_Vortigaunt.Kick")
end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_thugfists", "Bison_30", "killicon_thugfists", Color(231, 231, 231, 255 ) )
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

local super_jump = Sound( "weapons/stinger_fire1.wav" )
local tr = {mask = MASK_PLAYERSOLID}
function SWEP:Think()
	
	if SERVER then
		if not self.Windup then
			self.Windup = CreateSound(self.Owner,"ambient/alarms/train_horn2.wav")
		end
		if not self.Ram then
			self.Ram = CreateSound(self.Owner, "ambient/machines/train_wheels_loop1.wav")
		end
	end
	
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		if self.IdleSeq then
			self:PlaySequence(self.IdleSeq,true)
		end
	end

	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
	end
	
	if self:IsCharging() and self:GetChargeEnd() <= CurTime() then
		self:StopCharging()
		self:SetChargeAttack(true)
		//self.Owner:Freeze(true)
	end
	if self:IsChargeAttacking() then
				
		if self.Owner:KeyPressed(IN_JUMP) then //and self.Owner:GetGroundEntity() ~= NULL then --and self.Owner:OnGround() then
		
			self:SetChargeAttack(false)
			
			if SERVER then
				self.Owner:Freeze(false)
				local vel = self.Owner:SyncAngles():Forward()*350+vector_up*650
				self.Owner:SetLocalVelocity(vel)
				--self.NextCharge = CurTime() + 10
				self:SetNextCharge( CurTime() + 10 )
				if self.Ram then
					self.Ram:Stop()
				end
			end
			
			self:EmitSound( super_jump, 70, math.random( 130, 150 ) )
			return
		end
		
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + self.Owner:SyncAngles():Forward() * 20
		tr.mins = self.Owner:Crouching() and Vector(-9,-9,-25) or Vector(-9,-9,-45)
		tr.maxs = Vector(9,9,9)
		tr.filter = self.Owner:GetMeleeFilter()//team.GetPlayers(self.Owner:Team())//,GetHillEntity()}
		
		local trace = util.TraceHull(tr)
		
		if trace.Hit and (trace.HitWorld or IsValid(trace.Entity) and not trace.Entity.IsSpell) then
			local dec = self.Owner:TraceLine(30, MASK_SOLID, self.Owner)//self.Owner:GetEyeTrace()
			for i=1,3 do
				util.Decal("Scorch",dec.HitPos + dec.HitNormal*10, dec.HitPos - dec.HitNormal*10)
			end
			if SERVER then
				util.ScreenShake( self.Owner:GetPos() + Vector(0,0,3), math.random(3,6), math.random(3,4), math.random(2,3), 170 )
				self:PlaySequence(self.CriticalSeq)
				self.IdleAnimation = CurTime() + (IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():SequenceDuration() or 0.85)
				self.Owner:EmitSound("NPC_AntlionGuard.HitHard")
				self:SetChargeAttack(false)
				self.Owner:Freeze(false)
				if self.Ram then
					self.Ram:Stop()
				end
				
				local explode = false
				
				if IsValid(trace.Entity) then
					local dmg = 105
					if trace.Entity:IsPlayer() then
						if not trace.Entity:IsThug() then
							trace.Entity:SetGroundEntity(NULL)
							trace.Entity:SetLocalVelocity(self.Owner:SyncAngles():Forward()*400)
						end
						if trace.Entity:IsDefending() or trace.Entity:IsThug() then
							dmg = 85
						end
						self.Owner:MeleeViewPunch(dmg*0.7)
						if trace.Entity:IsThug() and IsValid(trace.Entity:GetActiveWeapon()) and trace.Entity:GetActiveWeapon().IsChargeAttacking and trace.Entity:GetActiveWeapon():IsChargeAttacking() then
							explode = true
						end
					else
						local phys = trace.Entity:GetPhysicsObject()
						if IsValid(phys) then
							trace.Entity:SetPhysicsAttacker(self.Owner)
							phys:SetVelocity(self.Owner:SyncAngles():Forward()*1000+vector_up*150)
						end
					end
					
					if explode then
						sound.Play("ambient/explosions/explode_"..math.random(2,3)..".wav",trace.HitPos,100,math.random(100,115))
						ExplosiveDamage(self.Owner, trace.HitPos, 250, 250, 0.5, 1, 20, self)
						local e = EffectData()
							e:SetOrigin(trace.HitPos)
							e:SetNormal(vector_up)
						util.Effect("tube_explosion",e,nil,true)
					else
						trace.Entity:TakeDamage(dmg,self.Owner,self)
					end
					
				end
				self.Owner:TakeDamage(math.random(3,10),nil,nil)
				self.Owner:MeleeViewPunch(30)
			end
			--self.NextCharge = CurTime() + 10
			self:SetNextCharge( CurTime() + 10 )
		else
			//self.Owner:SetGroundEntity(NULL)
			if SERVER then
				if self.Owner:GetVelocity():LengthSqr() < 9 and not self.Owner:OnGround() then
					self:SetChargeAttack(false)
					self.Owner:Freeze(false)
					if self.Ram then
						self.Ram:Stop()
					end
				else
					/*local vel = self.Owner:SyncAngles():Forward()*600
					if not self.Owner:OnGround() then
						vel.z = -250
					end
					self.Owner:SetLocalVelocity(vel)*/
					
					if self.Ram then
						self.Ram:Play()
					end
				end
			end
		end
		
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
	
	if self:IsCharging() then
		if self.Windup then
			self.Windup:PlayEx(1,100)
		end
	end
	
	if self:IsCharging() and (not self.Owner:KeyDown(IN_ATTACK2) or not self.Owner:OnGround()) then
		self:StopCharging()
		//self:PlaySequence(self.IdleSeq)
	end
	
	if self:IsBlocking() and CLIENT then
		self.BlockAnim = CurTime() + 1
	end
	
	self:NextThink(CurTime())
	return true
end

if CLIENT then
function SWEP:AdjustMouseSensitivity()
	if self:IsChargeAttacking() then return 0.00001 end
end

function SWEP:OverrideManaBar()
	local max = 10
	local am = math.Clamp( self:GetNextCharge() - CurTime(), 0, max )
	local hide_numbers = am <= 0
	
	return max - am, max, hide_numbers
end

end

function SWEP:CalcMainActivity(vel)
	if self:IsCharging() then
		local iSeq, iIdeal = self.Owner:LookupSequence ( "seq_throw" )
		return iIdeal, iSeq
	end
	if self:IsChargeAttacking() then
		local iSeq, iIdeal = self.Owner:LookupSequence ( "run_all_charging" )
		return iIdeal, iSeq
	end
end

function SWEP:UpdateAnimation(velocity, maxseqgroundspeed)
	if self:IsCharging() then
		self.Owner:SetPlaybackRate(0.55)
		return true
	end
	
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

function SWEP:SetChargeAttack(b)
	self:SetDTBool(1, b)
end

function SWEP:IsChargeAttacking()
	return self:GetDTBool(1)
end

function SWEP:StopCasting() end
function SWEP:IsCasting() return false end

function SWEP:StopCharging()
	self:SetChargeEnd(0)
	if self.Windup then
		self.Windup:Stop()
	end
end

function SWEP:IsCharging()
	return self:GetChargeEnd() > 0
end

function SWEP:SetChargeEnd(spellend)
	self:SetDTFloat(0, spellend)
end

function SWEP:GetChargeEnd()
	return self:GetDTFloat(0)
end

function SWEP:SetNextCharge( t )
	self:SetDTFloat( 5, t )
end

function SWEP:GetNextCharge()
	return self:GetDTFloat( 5 )
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:Freeze(false)
	end
	if self.Windup then
		self.Windup:Stop()
	end
	if self.Ram then
		self.Ram:Stop()
	end
	self:SetBlocking(false)
	self:StopCasting()
	if CLIENT then
		self:RemoveModels()
		self:ResetBonePositions()
	end
	
end

SWEP.NextBlock = 0
function SWEP:Reload()
	if self:IsAttacking() then return end
	if self:IsCasting() then return end
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	if self.NextBlock >= CurTime() then return end
	if self:IsCharging() then return false end
	if self:IsChargeAttacking() then return false end
	if self:IsBlocking() then return end
	
	
	if not self:IsSwinging() then
		self:SetBlocking(true)
	end

	return false
end

function SWEP:CanPrimaryAttack()
	if self:IsCharging() then return false end
	if self:IsChargeAttacking() then return false end

	return not self:IsSwinging()
end

SWEP.NextCharge = 0
function SWEP:SecondaryAttack()
	if self:IsSwinging() then return end
	if self:IsBlocking() then return end
	if self:IsChargeAttacking() then return end
	--if self.NextCharge >= CurTime() then return end
	if self:GetNextCharge() >= CurTime() then return end
	
	self.Owner:SetCycle(0)
	self:SetChargeEnd(CurTime()+self.ChargeWindup)
end

function SWEP:Move(mv)
	if self:IsCharging() then
		mv:SetMaxSpeed( 0 )
		mv:SetMaxClientSpeed( 0 )
	end
	
	if self:IsChargeAttacking() then
		
		mv:SetMaxSpeed( self.ChargeSpeed )
		mv:SetMaxClientSpeed( self.ChargeSpeed )
		
		--self.Owner:SetGroundEntity(NULL)
		
		mv:SetForwardSpeed( self.ChargeSpeed ) 
		mv:SetSideSpeed( 0 ) 
		
		mv:AddKey( IN_FORWARD )
		
		--local vel = self.Owner:SyncAngles():Forward()*600
		--if not self.Owner:OnGround() then
		--	vel.z = -250
		--end
		--mv:SetVelocity( vel )
	end
end

local BlockActivityTranslate = {}
BlockActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_CAMERA
BlockActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_IDLE_CAMERA + 1
BlockActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_IDLE_CAMERA + 2
BlockActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CAMERA + 3
BlockActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_IDLE_CAMERA + 4
BlockActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_IDLE_CAMERA + 5
BlockActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_CAMERA + 5
BlockActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_IDLE_CAMERA + 6
BlockActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_IDLE_CAMERA + 6
BlockActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_CAMERA + 7
BlockActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_CAMERA + 8


function SWEP:TranslateActivity(act)
	if self:GetSwingEnd() ~= 0 and self.ActivityTranslateSwing[act] ~= nil then
		return self.ActivityTranslateSwing[act]
	end
	
	if self:IsBlocking() and BlockActivityTranslate[act] ~= nil then
		return BlockActivityTranslate[act]
	end

	if self.ActivityTranslate[act] ~= nil then
		return self.ActivityTranslate[act]
	end

	return -1
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
		
	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.BlockMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
	
	
	self.VElements = {
		//["bowie"] = { type = "Model", model = "models/player/items/heavy/pn2_knife_canteen.mdl", bone = "handle", rel = "", pos = Vector(17.836, -22.466, -10.707), angle = Angle(-114.008, 100.268, -121.309), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "Bone03", rel = "", pos = Vector(2.553, 0.226, -0.253), angle = Angle(-20, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.WElements = {
		//["knife"] = { type = "Model", model = "models/player/items/heavy/pn2_knife_canteen.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(26.445, 10.602, -24.864), angle = Angle(22.805, -80.135, 52.333), size = Vector(0.814, 0.814, 0.814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	
	
end