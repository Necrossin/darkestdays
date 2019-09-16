local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:GetMana()
	return self:GetDTInt(0)
end

function meta:GetMaxMana()
	return self:GetDTInt(1)
end

function meta:GetCurSpellInd()
	return self:GetDTInt(2)
end

function meta:GetMaxHealthClient()
	return self:GetDTInt(3)
end

function meta:CastSpell()
	if self:IsJuggernaut() then return end
	if self:IsCrow() then return end
	if self:IsSprinting() then return end
	if self:IsDefending() then return end
	if self:IsGhosting() then return end //new
	local sp = self:GetCurrentSpell()
	if sp and sp:IsValid() then
		sp:Cast()
		if SERVER and self._SkillQuickRegen and (not self._efCantCast or self._efCantCast and self._efCantCast <= CurTime()) then
			self._NextManaRegen = CurTime() + 1 // 1.5
		end
	end
end

function meta:PlayGesture(name)

	self:AnimRestartGesture(GESTURE_SLOT_GRENADE, name, true)
	
end

net.Receive("PlayGesture", function(len)

	local ent = net.ReadEntity()
	local name = net.ReadInt( 32 )
	
	if IsValid(ent) then
		ent:PlayGesture(name)
	end
	
end)

function meta:IsJuggernaut()
	return self:GetDTBool(3)
end


function meta:GetVoiceSet()
	if VoiceSetTranslate[self:GetModel()] then
		return VoiceSetTranslate[self:GetModel()]
	end

	return "male"
end

function meta:CanCast(spell,am)
	if am then
		return self:GetMana() >= am
	else
		return self:GetMana() >= spell.Mana
	end
end

function meta:GetCurrentSpell()
	--if self.CurrentSpells then
	--	if self.CurrentSpells[self:GetCurSpellInd()] then
			--return self.CurrentSpells[self:GetCurSpellInd()]
	--	end
	--end
	return self:GetDTEntity(self:GetCurSpellInd())
end

function meta:IsDurationSpell()
	if self:GetCurrentSpell() then
		if IsValid(self:GetCurrentSpell()) then
			if not self:GetCurrentSpell().DurationSpell then
				self:GetCurrentSpell().DurationSpell = self:GetCurrentSpell():GetDTBool(2) or false
			end
			return self:GetCurrentSpell().DurationSpell //self:GetCurrentSpell():GetDTBool(2) or false
		end
	end
	return false
end

function meta:IsGhosting()
	/*if self:GetCurrentSpell() then
		if IsValid(self:GetCurrentSpell()) and self:GetCurrentSpell():GetClass() == "spell_ghosting" then
			return self:GetCurrentSpell():GetDTBool(0)
		end
	end*/
	//return false
	return self._efGhosting and IsValid(self._efGhosting)
end

function meta:IsGhostingWithPerk()
	if self:GetCurrentSpell() then
		if IsValid(self:GetCurrentSpell()) and self:GetCurrentSpell():GetClass() == "spell_ghosting" then
			return self:GetCurrentSpell():GetDTBool(3)
		end
	end
	return false
end

function meta:HasAdrenaline()
	return self._efAdrenaline and IsValid(self._efAdrenaline)
end

function meta:IsDashing()
	return self._efDash and IsValid(self._efDash)
end

function meta:IsCrow()
	return self._efCOTN and IsValid(self._efCOTN)
end

function meta:GetMagicShield()
	return IsValid(self._efMagShield) and self._efMagShield 
end

function meta:IsRolling()
	return self._efRoll and IsValid(self._efRoll)
end

function meta:IsSliding()
	return self._efSlide and IsValid(self._efSlide)
end

function meta:IsWallrunning()
	return IsValid(self._efWallRun) and self._efWallRun.IsActive and self._efWallRun:IsActive() == true
end

/*function meta:IsSprinting()
	local walk_spd = self:GetWalkSpeed()
	--return self:GetVelocity():LengthSqr() >= ( walk_spd * walk_spd + PLAYER_DEFAULT_RUNSPEED_BONUS_SQR - 100 ) and (self:KeyDown( IN_SPEED ) and self:OnGround() and !self:IsDashing()) and !IsValid(self._efSlide)
	return self:IsRunning() and (self:KeyDown( IN_SPEED ) and self:OnGround() and !self:IsDashing()) and !IsValid(self._efSlide)
end*/
/*
function meta:IsSprinting()
	return self:GetVelocity():Length() >= (self:GetWalkSpeed()+PLAYER_DEFAULT_RUNSPEED_BONUS-10) and (self:KeyDown( IN_SPEED ) and self:OnGround() and !self:IsDashing()) and !IsValid(self._efSlide)
end*/

//but not sprinting!
function meta:IsRunning()
	local walk_spd = self:GetWalkSpeed()
	return self:GetVelocity():LengthSqr() >= ( math.pow( walk_spd, 2 )  + PLAYER_DEFAULT_RUNSPEED_BONUS_SQR - 100 )
end
/*
function meta:IsRunning()
	return self:GetVelocity():Length() >= (self:GetWalkSpeed()+PLAYER_DEFAULT_RUNSPEED_BONUS-10)
end*/

local ViewHullMins = Vector(-8, -8, -8)
local ViewHullMaxs = Vector(8, 8, 8)
function meta:GetThirdPersonCrowCameraPos(origin, angles)
	local allplayers = player.GetAll()
	local tr = util.TraceHull({start = origin, endpos = origin + angles:Forward() * -math.max(59, self:BoundingRadius()), mask = MASK_SHOT, filter = allplayers, mins = ViewHullMins, maxs = ViewHullMaxs})
	return tr.HitPos + tr.HitNormal* 5
end

function meta:GetVoiceSet()
	return self:GetDTString( 1 ) or "male"
end

function meta:GetThirdPersonCameraPosAng(origin, angles)
	
	//local allplayers = {player.GetAll(),ents.FindByClass("htf_flag")}
	local tr = util.TraceHull({start = origin + angles:Right()*DD_THIRDPERSON_Y/2, endpos = origin + angles:Right()*DD_THIRDPERSON_Y+ angles:Up()*DD_THIRDPERSON_Z + self:GetAimVector() * -math.max(DD_THIRDPERSON_X, self:BoundingRadius()), mask = MASK_PLAYERSOLID_BRUSHONLY, filter = self, mins = ViewHullMins, maxs = ViewHullMaxs})
	local hit = self:GetEyeTrace().HitPos
	local aimang = (hit - (tr.HitPos + tr.HitNormal* 5)):GetNormalized():Angle()
	
	return tr.HitPos + tr.HitNormal* 5, angles
end

function meta:CanJoinTeam(t)
	
	local otherteam = TEAM_RED
	
	if t == TEAM_RED then
		otherteam = TEAM_BLUE
	end
	
	if self:Team() == otherteam then
		return team.NumPlayers(t) < team.NumPlayers(otherteam)	
	else
		return team.NumPlayers(t) <= team.NumPlayers(otherteam)	
	end
end

function meta:HasUnlocked(stuff)
	
	local unl = true
	
	/*if Weapons[stuff] and Weapons[stuff].Level then
		if self:GetLevel() >= Weapons[stuff].Level then
			return true
		else
			if not Unlocks[stuff] then
				unl = false
			end
		end
	end
	
	if Spells[stuff] and Spells[stuff].Level then
		if self:GetLevel() >= Spells[stuff].Level then
			return true
		else
			if not Unlocks[stuff] then
				unl = false
			end
		end
	end
	
	if Perks[stuff] and Perks[stuff].Level then
		if self:GetLevel() >= Perks[stuff].Level then
			return true
		else
			if not Unlocks[stuff] then
				unl = false
			end
		end
	end
	
	if Unlocks[stuff] then
		for _,ach in ipairs(Unlocks[stuff]) do
			if SERVER then
				if self.Stats and self.Stats["achievements"] then
					if self.Stats["achievements"][ach] ~= true then
						unl = false
						break
					end
				end
			end
			if CLIENT then
				if Stats and Stats["achievements"] then
					if Stats["achievements"][ach] ~= true then
						unl = false
						break
					end
				end
			end
		end
	end*/
	
	if Weapons[stuff] and Weapons[stuff].AdminOnly and not self:IsAdmin() then
		unl = false
	end
	
	if Perks[stuff] and Perks[stuff].AdminOnly and not self:IsAdmin() then
		unl = false
	end
	
	if Weapons[stuff] and Weapons[stuff].AdminFree and self:IsAdmin() then
		unl = true
	end
	
	if Perks[stuff] and Perks[stuff].AdminFree and self:IsAdmin() then
		unl = true
	end
	
	return unl
end

function meta:GetHandsModel()

	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	local cl_playermodel = self:GetInfo( "cl_playermodel" )
	return player_manager.TranslatePlayerHands( cl_playermodel )

end

function meta:IsCarryingFlag()
	return IsValid(GetHillEntity()) and GetHillEntity().GetCarrier and IsValid(GetHillEntity():GetCarrier()) and GetHillEntity():GetCarrier() == self
end

function meta:IsThug()
	return IsValid(self._efThug)
end

//function meta:IsTeammate( pl )
//	if GAMEMODE:GetGametype() == "ffa" then return self == pl end
//	return self:Team() == pl:Team()
//end

function meta:TraceLine ( distance, _mask, filter )
	local vStart = self:GetShootPos()
	if filter then 
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask, filter = filter })
	else
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask })
	end
end

function meta:GetMeleeFilter()
	if GAMEMODE:GetGametype() == "ffa" then
		return { self }
	end
	return team.GetPlayers(self:Team())
end

function meta:TraceHull(distance, mask, size, filter, start)
	start = start or self:GetShootPos()
	return util.TraceHull({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask, mins = Vector(-size, -size, -size), maxs = Vector(size, size, size)})
end

function meta:DoubleTrace(distance, mask, size, mask2, filter)
	local tr1 = self:TraceLine(distance, mask, filter)
	if tr1.Hit then return tr1 end
	if mask2 then
		local tr2 = self:TraceLine(distance, mask2, filter)
		if tr2.Hit then return tr2 end
	end

	local tr3 = self:TraceHull(distance, mask, size, filter)
	if tr3.Hit then return tr3 end
	if mask2 then
		local tr4 = self:TraceHull(distance, mask2, size, filter)
		if tr4.Hit then return tr4 end
	end

	return tr1
end

function meta:MeleeViewPunch(damage)
	local maxpunch = (damage + 25) * 0.5
	local minpunch = -maxpunch
	self:ViewPunch(Angle(math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch)))
end


function meta:MeleeTrace(distance, size, filter, start)
	return self:TraceHull(distance,MASK_SHOT, size, filter, start)//MASK_SOLID
end

local trace = { mask = MASK_SHOT }
local function InsertTBL(tbl, stuff)
    tbl[#tbl + 1] = stuff
end
function meta:PenetratingMeleeTrace(distance, size, filter, swipe)
	
	local start = self:GetShootPos()
		
	local t = {}
	trace.start = start
	
	if swipe then
		//trace.endpos = start + self:GetAimVector() * distance / 3
		trace.mins = Vector(-size, -size, -size )
		trace.maxs = Vector(size, size, size)
	else
		trace.endpos = start + self:GetAimVector() * distance
		trace.mins = Vector(-size, -size, -size )
		trace.maxs = Vector(size, size, size)
	end

	trace.filter = filter or { self }

	/*if not swipe then
		debugoverlay.Box( trace.start, trace.mins, trace.maxs, 5, Color( 255, 255, 255, 100) )
		debugoverlay.Line( trace.start, trace.endpos, 5, Color( 255, 255, 255, 100), false )
		debugoverlay.Box( trace.endpos, trace.mins, trace.maxs, 5, Color( 255, 255, 255, 100) )
	else
		debugoverlay.Box( trace.start, trace.mins, trace.maxs, 5, Color( 255, 255, 255, 100) )
	end*/
	
	local dist = 0
	
	for i=1, 10 do
	
		if swipe then
			
			if i < 5 then
				dist = dist + 1
			end
			
			if i > 5 then
				dist = dist - 1
			end
			
			trace.endpos = start + self:GetAimVector() * distance * ( 0.5 + 0.2 * ( dist/4 ) ) - self:GetAimVector():Angle():Right() * size/1.6 * 5 + self:GetAimVector():Angle():Right() * size/1.6 * i
			//debugoverlay.Line( trace.start, trace.endpos, 5, Color( 255, 255, 255, 100), false )
			//debugoverlay.Box( trace.endpos, trace.mins, trace.maxs, 5, Color( 255, 255, 255, 100) )
		end
	
		local tr = util.TraceHull(trace)
		
		//if not tr.Hit then break end

		local ent = tr.Entity
		
		if ent and ent:IsValid() then
			if not ent.IgnoreTracing then
				--table.insert(t, tr)
				InsertTBL( t, tr )
			end
			InsertTBL( trace.filter, ent )
			--table.insert(trace.filter, ent)
		else
			if tr.HitWorld then
				--table.insert(t, tr)
				InsertTBL( t, tr )
				break
			end
		end
	end
	
	return t
end

function meta:IsDefending( override )
	local wep = self:GetActiveWeapon()
	local block = wep and wep.IsBlocking and wep:IsBlocking()
	if block and wep.OverrideBlock then
		if not override then
			return false
		end
	end
	return block
end

function meta:IsParrying()
	local wep = self:GetActiveWeapon()
	local parry = wep and wep.IsParrying and wep:IsParrying() and self:KeyDown(IN_RELOAD)
	return parry
end

function meta:SyncAngles()
	local ang = self:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end

function meta:GetXP()
	if SERVER then
		return self.Skills and self.Skills.XP or 0
	end
	if CLIENT then
		return PlayerSkills and PlayerSkills.XP or 0
	end
end

function meta:GetLevel()
	if SERVER then
		return self.Skills and self.Skills.Lvl or 0
	end
	if CLIENT then
		return PlayerSkills and PlayerSkills.Lvl or 0
	end
end

function meta:GetTotalPoints()
	if SERVER then
		return self.Skills and self.Skills.Total or 0
	end
	if CLIENT then
		return PlayerSkills and PlayerSkills.Total or SKILL_XP_START
	end
end

function meta:GetAvalaiblePoints()
	if SERVER then
		return self.Skills and self.Skills.ToSpend or 0
	end
	if CLIENT then
		return PlayerSkills and PlayerSkills.ToSpend or 0
	end
end

function meta:GetRequiredXP()
	
	local exp = 0
	
	for i=0, self:GetLevel() do//math.max(self:GetTotalPoints()-SKILL_XP_START,1)self:GetTotalPoints()-SKILL_XP_START
		local mul = 1
	
		if i + SKILL_XP_START >= SKILL_MAX_TOTAL then
			mul = SKILL_XP_MULTIPLIER
		end
		exp = exp + SKILL_XP_INITIAL + SKILL_XP_INCREASE_BY * (i) * mul
	end
	
	return exp or SKILL_XP_INITIAL
end

if CLIENT then 

function meta:GetPerk(prk)
	return self.Perks and self.Perks == prk
end

function meta:GetClosestPoint()
	if not ConquestPoints then return end
	
	for _,p in ipairs(ConquestPoints) do
		if p and IsValid(p) and self:GetPos():Distance(p:GetPos()) <= p:GetRadius() and p:CheckZ(self,p) then
			return p
		end
	end
	
end

function meta:FastWeaponSwitch()
	
	if !self:Alive() then return true end
	local weps = self:GetWeapons() 
	if #weps < 2 then return true end
	if #weps > 2 then return false end
	
	self.NextWeaponSwitch = self.NextWeaponSwitch or 0
	
	if self.NextWeaponSwitch >= CurTime() then return end
	self.NextWeaponSwitch = CurTime() + 0.01
	
	local active = self:GetActiveWeapon()
	
	for i=1, #weps do
		if weps[i] and weps[i]:IsValid() and weps[i] ~= active then
			//self:SelectWeapon( weps[i]:GetClass() )
			self.SwitchToWeapon = weps[i]
			break
		end
	end
	return true
end

function meta:AddBloodyStuff()
	
	if !DD_BLOODYMODELS then return end
	
	local wep = self:GetActiveWeapon()
	local hands = self:GetHands()
	
	self.NextBlood = self.NextBlood or 0
	
	if self.NextBlood > CurTime() then return end
	self.NextBlood = CurTime() + 0.15
		
	if wep and wep:IsValid() and wep.AddBlood then
		wep:AddBlood()
	end
	
	if hands and hands:IsValid() then
		hands.BloodScale = hands.BloodScale or math.Rand( 1.1, 7 )
		hands.Bloody = hands.Bloody or 0
		if hands.Bloody < 5 then
			hands.Bloody = hands.Bloody + 1
		end
	end
	
end


end

local meta = FindMetaTable( "Entity" )
if (!meta) then return end

local OldSequenceDuration = meta.SequenceDuration
function meta:SequenceDuration(seqid)
	return OldSequenceDuration(self, seqid) or 0
end

function meta:IsTeammate( pl )
	if GAMEMODE:GetGametype() == "ffa" then return self == pl end
	if not pl.Team then return false end
	return self.Team and self:Team() == pl:Team() or false
end

/*meta.OldGetAttachment = meta.GetAttachment

function meta:GetAttachment(id)
	if id == -1 then
		return {Pos = self:GetPos(),Ang = self:GetAngles()}
	end
	 
	return self:OldGetAttachment(id)
end*/

/*local OldGetBoneCount = meta.GetBoneCount
function meta:GetBoneCount()
	return OldGetBoneCount(self) or 0
end*/

function meta:ResetBones(onlyscale)
	local v = Vector(1, 1, 1)
	if onlyscale then
		for i=0, self:GetBoneCount() - 1 do
			self:ManipulateBoneScale(i, v)
		end
	else
		local a = Angle(0, 0, 0)
		for i=0, self:GetBoneCount() - 1 do
			self:ManipulateBoneScale(i, v)
			self:ManipulateBoneAngles(i, a)
			self:ManipulateBonePosition(i, vector_origin)
		end
	end
end

if CLIENT then

local bones = {}
bones["v_weapon.Right_Arm"] = "Bone02"
bones["v_weapon.Right_Hand"] = "Bone03"

bones["v_weapon.Right_Thumb01"] = "Bone20"
bones["v_weapon.Right_Thumb02"] = "Bone21"
bones["v_weapon.Right_Thumb03"] = "Bone22"

bones["v_weapon.Right_Index01"] = "Bone04"
bones["v_weapon.Right_Index02"] = "Bone05"
bones["v_weapon.Right_Index03"] = "Bone06"

bones["v_weapon.Right_Middle01"] = "Bone08"
bones["v_weapon.Right_Middle02"] = "Bone09"
bones["v_weapon.Right_Middle03"] = "Bone10"

bones["v_weapon.Right_Ring01"] = "Bone12"
bones["v_weapon.Right_Ring02"] = "Bone13"
bones["v_weapon.Right_Ring03"] = "Bone14"

/*
meta.OldLookupBone = meta.LookupBone

function meta:LookupBone(b)
	return bones[b] and self:OldLookupBone(bones[b]) or self:OldLookupBone(b)	
end*/


function meta:SetModelScaleOld(scale)
		
	local bbp = self.BuildBonePositions
	
	if self._LastScale and self._LastScale == scale then return end
	
	local sz = (math.min(scale.x,scale.y,scale.z) + (scale.x+scale.y+scale.z)/3)/2
	
	self:SetModelScale(sz,0)
	
	local newbbp = function(s)
		
		local name = s:GetBoneName(0)
		if name then
			if s:LookupBone(name) then
				local m = s:GetBoneMatrix(bone)
				if m then
					m:Scale(Vector(scale.x,scale.y,scale.z)/sz or Vector(1,1,1))
					s:SetBoneMatrix(bone, m)
				end
			end
		end
			
	end
	
	if not self._LastBBP then
		self._LastBBP = newbbp
	
		self.BuildBonePositions = function(...)
			if bbp then
				bbp(...)
			end
			self._LastBBP(...)
		end
	
	end
	
	if self._LastBBP and self._LastBBP ~= newbbp then
		self._LastBBP = newbbp
	end
	
	self._LastScale = scale
	
end

end