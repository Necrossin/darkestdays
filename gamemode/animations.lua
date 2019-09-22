
local ACT_MP_STAND_IDLE = ACT_MP_STAND_IDLE
local ACT_MP_RUN = ACT_MP_RUN
local ACT_MP_WALK = ACT_MP_WALK
local ACT_MP_JUMP = ACT_MP_JUMP
local ACT_MP_CROUCHWALK = ACT_MP_CROUCHWALK
local ACT_MP_CROUCH_IDLE = ACT_MP_CROUCH_IDLE
local GESTURE_SLOT_JUMP = GESTURE_SLOT_JUMP
local ACT_LAND = ACT_LAND
local MOVETYPE_NOCLIP = MOVETYPE_NOCLIP
local math_min = math.min
local math_max = math.max
local CLIENT = CLIENT
local PLAYERANIMEVENT_FLINCH_HEAD = PLAYERANIMEVENT_FLINCH_HEAD
local CurTime = CurTime
local IsValid = IsValid

local M_Player = FindMetaTable("Player")
local M_Entity = FindMetaTable("Entity")
local P_Team = M_Player.Team
local P_AnimRestartGesture = M_Player.AnimRestartGesture
local P_AnimRestartMainSequence = M_Player.AnimRestartMainSequence
local P_Crouching = M_Player.Crouching
local P_IsSprinting = M_Player.IsSprinting
local P_IsCrow = M_Player.IsCrow
local P_Alive = M_Player.Alive
local E_LookupSequence = M_Entity.LookupSequence
local P_GetActiveWeapon = M_Player.GetActiveWeapon
local E_OnGround = M_Entity.OnGround
local E_GetTable = M_Entity.GetTable
local E_WaterLevel = M_Entity.WaterLevel
local E_SetPlaybackRate = M_Entity.SetPlaybackRate
local E_SetCycle = M_Entity.SetCycle
local E_SetPoseParameter = M_Entity.SetPoseParameter

local M_Vector = FindMetaTable("Vector")
local V_Length2D = M_Vector.Length2D
local V_Length2DSqr = M_Vector.Length2DSqr
local V_LengthSqr = M_Vector.LengthSqr

local onground, tab, len2d, waterlevel, ideal, override, pt

function GM:CalcMainActivity( pl, velocity )

	pt = E_GetTable(pl)
	
	onground = E_OnGround(pl)

	if P_IsCrow(pl) then
	
		local iSeq, iIdeal = E_LookupSequence( pl, "Idle01" )
		
		local fVelocity = V_LengthSqr( velocity )
		
		if onground then
			if fVelocity > 1 then 
				iSeq = E_LookupSequence( pl, "Run" )
			else 
				iSeq = E_LookupSequence( pl, "Idle01" )
			end
		else
			if fVelocity > 1 then
				iSeq = E_LookupSequence( pl, "Fly01" )
			else
				iSeq = E_LookupSequence( pl, "Fly01" )
			end
		end
		
		return iIdeal, iSeq
		
	end
	
	if pl._efSlide and IsValid(pl._efSlide) then
		local iIdeal, iSeq = ACT_MP_SWIM, -1
		return iIdeal, iSeq
	end
	
	local wep = P_GetActiveWeapon( pl )
	local nosprint = IsValid(wep) and wep.IgnoreSprint
	local sequence = "run_all_charging"
	if wep.RunSequence then
		sequence = wep:RunSequence()
	end
	
	len2d = V_Length2DSqr(velocity)

	
	local is_wallrunning = pl._efWallRun and pl._efWallRun.IsActive and pl._efWallRun:IsActive()
	
	if ( P_IsSprinting( pl ) or is_wallrunning ) and len2d > 44100 then
		
		--if is_wallrunning then sequence = "run_all_02" end
		
		local iIdeal, iSeq = ACT_MP_RUN, -1
		if not nosprint then
			iSeq = E_LookupSequence( pl, sequence )
		end
		
		return iIdeal, iSeq
	end
	
	if IsValid(wep) and wep.CalcMainActivity then
		local iIdeal, iSeq = wep:CalcMainActivity(vel)
		if iIdeal and iSeq then
			return iIdeal, iSeq
		end
	end

	onground = E_OnGround(pl)
	if onground and not pt.m_bWasOnGround then
		P_AnimRestartGesture(pl, GESTURE_SLOT_JUMP, ACT_LAND, true)
		pt.m_bWasOnGround = true
	end

	waterlevel = E_WaterLevel(pl)
	if pt.m_bJumping then
		if pt.m_bFirstJumpFrame then
			pt.m_bFirstJumpFrame = false
			P_AnimRestartMainSequence(pl)
		end

		if waterlevel >= 2 or CurTime() - pt.m_flJumpStartTime > 0.2 and onground then
			pt.m_bJumping = false
			pt.m_fGroundTime = nil
			P_AnimRestartMainSequence(pl)
		else
			return ACT_MP_JUMP, -1
		end
	elseif not onground and waterlevel <= 0 then
		if not pt.m_fGroundTime then
			pt.m_fGroundTime = CurTime()
		elseif CurTime() > pt.m_fGroundTime and len2d < 0.25 then
			pt.m_bJumping = true
			pt.m_bFirstJumpFrame = false
			pt.m_flJumpStartTime = 0
		end
	end

	if P_Crouching(pl) then
		if len2d >= 1 then
			return ACT_MP_CROUCHWALK, -1
		end

		return ACT_MP_CROUCH_IDLE, -1
	end

	if not onground and waterlevel >= 2 then
		return ACT_MP_SWIM, -1
	end

	if len2d >= 22500 then
		return ACT_MP_RUN, -1
	end

	if len2d >= 1 then
		return ACT_MP_WALK, -1
	end

	return ACT_MP_STAND_IDLE, -1

end

local len
local rate
function GM:UpdateAnimation( pl, velocity, maxseqgroundspeed )

	len = V_LengthSqr( velocity )
	
	if pl._efSlide and IsValid(pl._efSlide) then
		E_SetPlaybackRate(pl, 0)
		E_SetCycle(pl, 0.2)
		//if pl._efSlide.IsDive and pl._efSlide:IsDive() then
			E_SetPoseParameter( pl, "move_x", pl._efSlide:GetMoveX() or -1 )
			E_SetPoseParameter( pl, "move_y", pl._efSlide:GetMoveY() or 0 )
		//else
			//E_SetPoseParameter( pl, "move_x", -1 )
		//end
		return true
	end
	
	local wep = P_GetActiveWeapon( pl )
	if IsValid(wep) and wep.UpdateAnimation then
		return wep:UpdateAnimation(velocity, maxseqgroundspeed)
	end

	if len > 1 then
		rate = math_min(len / maxseqgroundspeed ^ 2, 2)
	else
		rate = 1
	end

	if E_WaterLevel(pl) >= 2 then
		rate = math_max(rate, 0.5)
	end

	E_SetPlaybackRate(pl, rate)

	/*if CLIENT then
		GAMEMODE:GrabEarAnimation(pl)
		GAMEMODE:MouthMoveAnimation(pl)
	end*/

end
