ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_NONE

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.MaxSpeedMultiplier = 1.2
ENT.SpeedBoost = 1//1.1
ENT.DecayDuration = 1

if SERVER then
	AddCSLuaFile("shared.lua")
end


for i=5,9 do
	util.PrecacheSound("weapons/fx/nearmiss/bulletLtoR0"..i..".wav")
end


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efWallRun) then
		if SERVER then
			self.EntOwner._efWallRun:Remove()
		end
		self.EntOwner._efWallRun = nil
	end
	
	self.EntOwner._efWallRun = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)		
	end
	
	self:SetWallRun( false )
	//self:SetDTInt(0,0)
	
	//self.DieTime = CurTime() + 0.8
	
end

function ENT:SetWallRun( bl )
	self:SetDTBool(0,bl)
end

function ENT:IsActive()
	return self:GetDTBool(0)
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner._efWallRun = nil
	end
end

local walltrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 15)}
local tr
local nextstep = 0
local step = true

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		/*local owner = self.EntOwner		
		
		
		if not owner:OnGround() and owner:KeyDown(IN_SPEED) and not IsValid(owner._efSlide) and owner:IsSprinting() and owner._DefaultRunSpeedBonus and owner._DefaultRunSpeedBonus > 0 then
			--and owner._DefaultRunSpeedBonus and owner._DefaultRunSpeedBonus > 0 and owner:GetVelocity():LengthSqr() >= math.pow(owner:GetWalkSpeed()+PLAYER_DEFAULT_RUNSPEED_BONUS-10, 2) then
			local right = false
			local left = false
			
			local ang = owner:SyncAngles()
			local pos = owner:GetShootPos()
			
			walltrace.start = pos - vector_up * 40
			walltrace.endpos = pos + ang:Right() * 30
			
			tr = util.TraceHull(walltrace)
			
			if not tr.Hit then
				walltrace.endpos = pos + ang:Right() * -30
				tr = util.TraceHull(walltrace)
			else
				right = true
			end
			
			
			
			if tr.Hit and not tr.HitSky and tr.HitNormal.z < 0.3 and tr.HitNormal.z > -0.3 then
				if not right then left = true end
				
				local prevvelvec = owner:GetVelocity()
				local prevvel = prevvelvec:Length()
				local prevvel_2d_sqr = prevvelvec:Length2DSqr() 
				local max_speed = owner:GetMaxSpeed() * self.MaxSpeedMultiplier
			
				
				if prevvel > 160 and prevvelvec.z < 190 and prevvel_2d_sqr > 2500 then
					
					if not self:IsActive() then
						self:SetWallRun( true )
						self.DecayTime = CurTime() + self.DecayDuration
						owner:SetLuaAnimation(right and "wallrun_right" or "wallrun_left")
					end
					
					local decay = math.Clamp( ( self.DecayTime - CurTime() ) / self.DecayDuration, 0, 1 )
					
					--prevvelvec = Vector( math.Clamp( prevvelvec.x * self.SpeedBoost, -max_speed, max_speed ), math.Clamp( prevvelvec.y * self.SpeedBoost, -max_speed, max_speed ), math.Clamp( prevvelvec.z, -42, 120 ) )
					
					--local boost = math.abs( prevvelvec.z * 0.2 ) * decay --0
					
					--if owner:KeyDown(IN_JUMP) then
						--boost = math.abs( prevvelvec.z * 0.2 ) * decay
					--end
					
					--owner:SetLocalVelocity( prevvelvec + vector_up * boost ) -- + vector_up * math.abs(prevvelvec.z/1.42)
					
					--prevvelvec = Vector(math.Clamp(prevvelvec.x,-400,400),math.Clamp(prevvelvec.y,-400,400),math.Clamp(prevvelvec.z,owner:KeyDown(IN_JUMP) and 30 or -22,120))
					--owner:SetLocalVelocity(prevvelvec*1.065+vector_up*math.abs(prevvelvec.z/1.42))
					
					--prevvelvec = Vector( math.Clamp( prevvelvec.x * self.SpeedBoost, -max_speed, max_speed ), math.Clamp( prevvelvec.y * self.SpeedBoost, -max_speed, max_speed ), math.Clamp( prevvelvec.z, -42, 120 ) )
					
					prevvelvec = Vector(math.Clamp(prevvelvec.x,-400,400),math.Clamp(prevvelvec.y,-400,400),math.Clamp(prevvelvec.z,owner:KeyDown(IN_JUMP) and ( -152 + 183 * decay )  or -152,120))
					
					local boost = math.abs(prevvelvec.z/5) * decay
					
					owner:SetLocalVelocity(prevvelvec * 1.015 + vector_up * boost )
					
					if CurTime() >= nextstep then
						if step then
							owner:EmitSound("Default.StepRight")
						else
							owner:EmitSound("Default.StepLeft")
						end
						step = !step
						nextstep = CurTime() + 0.12
					end
				else
					if self:IsActive() then
						self:SetWallRun( false )
						self.DecayTime = nil
					end
				end
				
			else
				if self:IsActive() then
					self:SetWallRun( false )
					self.DecayTime = nil
				end
			end
		else
			if self:IsActive() then
				self:SetWallRun( false )
				self.DecayTime = nil
			end
		end*/
			
	end
	self:NextThink(CurTime())
	return true
end

local vector_up = vector_up
local util_TraceHull = util.TraceHull
local math_Clamp = math.Clamp 
local math_abs = math.abs
local Vector = Vector
local CurTime = CurTime

function ENT:Move( mv )

	local owner = self.EntOwner		
		
	if not owner:OnGround() and owner:KeyDown( IN_SPEED ) and not IsValid(owner._efSlide) and owner:IsSprinting() and owner._DefaultRunSpeedBonus and owner._DefaultRunSpeedBonus > 0 and !owner:HasWeapon( "dd_striker" )  then
		
		local right = false
		local left = false
			
		local ang = owner:SyncAngles()
		local pos = owner:GetShootPos()
			
		walltrace.start = pos - vector_up * 40
		walltrace.endpos = pos + ang:Right() * 30
			
		tr = util_TraceHull( walltrace )
			
		if not tr.Hit then
			walltrace.endpos = pos + ang:Right() * -30
			tr = util_TraceHull( walltrace )
		else
			right = true
		end

		if tr.Hit and not tr.HitSky and tr.HitNormal.z < 0.3 and tr.HitNormal.z > -0.3 then
			if not right then left = true end
				
			local prevvelvec = mv:GetVelocity()
			local prevvel = prevvelvec:Length()
			local prevvel_2d_sqr = prevvelvec:Length2DSqr() 
			local max_speed = mv:GetMaxSpeed() * self.MaxSpeedMultiplier

			if prevvel > 160 and prevvelvec.z < 190 and prevvel_2d_sqr > 2500 then

				if not self:IsActive() then
					if SERVER then
						self:SetWallRun( true )
						owner:SetLuaAnimation( right and "wallrun_right" or "wallrun_left" )
					end	
					self.DecayTime = CurTime() + self.DecayDuration
				end
					
				local decay = math_Clamp( ( self.DecayTime - CurTime() ) / self.DecayDuration, 0, 1 )
			
				prevvelvec = Vector( math_Clamp( prevvelvec.x, -400, 400 ), math_Clamp( prevvelvec.y, -400, 400 ), math_Clamp( prevvelvec.z, owner:KeyDown( IN_JUMP ) and ( -100 + 130 * decay )  or -100, 120 ) )
					
				local boost = math_abs( prevvelvec.z / 5 ) * decay
					
				mv:SetVelocity( prevvelvec * 1.035 + vector_up * boost )
				
				
				if SERVER and CurTime() >= nextstep then
					if step then
						owner:EmitSound( "Default.StepRight" )
					else
						owner:EmitSound( "Default.StepLeft" )
					end
					step = !step
					nextstep = CurTime() + 0.12
				end
				
			else
				if self:IsActive() then
					if SERVER then
						self:SetWallRun( false )
						self.DecayTime = nil
					end
				end
			end	
		else
			if self:IsActive() then
				if SERVER then
					self:SetWallRun( false )
				end
				self.DecayTime = nil
			end
		end
	else
		if self:IsActive() then
			if SERVER then
				self:SetWallRun( false )
			end
			self.DecayTime = nil
		end
	end

end


if CLIENT then
function ENT:Draw()
end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end

