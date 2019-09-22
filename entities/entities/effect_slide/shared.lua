ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

util.PrecacheSound("physics/body/body_medium_scrape_smooth_loop1.wav")
util.PrecacheSound("npc/combine_soldier/gear1.wav")
util.PrecacheSound("npc/combine_soldier/gear2.wav")

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efSlide) then
		if SERVER then
			self.EntOwner._efSlide:Remove()
		end
		self.EntOwner._efSlide = nil
	end
	
	self.EntOwner._efSlide = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)		
	end
	
	if CLIENT then
		self.Sound = CreateSound(self.Entity, "physics/body/body_medium_scrape_smooth_loop1.wav")
	end
	
	local vel = self.EntOwner:GetVelocity()
	
	if self:IsDive() then
		//if CLIENT and self.EntOwner:OnGround() then
			//self:EmitSound( "npc/combine_soldier/gear"..math.random(2)..".wav", 75, 120 )
		//end
		self.EntOwner:SetVelocity(vel * 0.5 + vector_up * 250 )
		self.EntOwner:SetGroundEntity( NULL )
		//self.IgnoreGround = CurTime() + 0.3
		//self.EntOwner:SetGravity( 0.8 ) 
	else
		self.EntOwner:SetVelocity(vel * 0.6)
		self:SetMoveX( -1 )
		self:SetMoveY( 0 )
	end
	
	self.IgnoreGround = CurTime() + 0.3
	
end

function ENT:DoBones()
	for i=1, 3 do
		local bone = self.EntOwner:LookupBone("ValveBiped.Bip01_Pelvis")
		if bone then
			self.EntOwner:ManipulateBoneAngles( bone, Angle(0,0,-20)  )
			self.EntOwner:ManipulateBonePosition( bone, vector_up*-30  )
		end
		local bone = self.EntOwner:LookupBone("ValveBiped.Bip01_Spine4")
		if bone then
			self.EntOwner:ManipulateBoneAngles( bone, Angle(0,20,0)  )
		end
	end
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner:ResetBones()
		self.EntOwner._efSlide = nil
		//self.EntOwner:SetGravity( 1 ) 
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Stop()
		end
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
	end
end

local kick_trace = { mask = MASK_SOLID, mins = Vector( -16, -16, -50 ), maxs = Vector( 16, 16, 10 ) }
function ENT:CheckDropKick()
	
	if not self.DidDropKick and self.DropKickFrames and self.DropKickFrames > CurTime() and not self.EntOwner:OnGround() then
		
		kick_trace.start = self.EntOwner:GetShootPos()
		kick_trace.endpos = kick_trace.start + self.EntOwner:GetForward() * 72
		kick_trace.filter = self.EntOwner:GetMeleeFilter()
		
		local tr = util.TraceHull( kick_trace )
	
		if tr.Hit and !tr.HitWorld then
			local hitent = tr.Entity
			
			if hitent and hitent:IsValid() then
			
				self.DidDropKick = true
				
				if self.SaveVel then
					self.EntOwner:SetLocalVelocity( self.SaveVel )
				end
			
				if hitent:GetClass() == "func_breakable_surf" then
					hitent:Fire("break", "", 0)
					
					self.EntOwner:EmitSound("NPC_Vortigaunt.Kick")
					
				else	
					
					local dmg = 45
					dmg = dmg + (dmg*(self.EntOwner._DefaultMeleeBonus or 0))/100
				
					local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamage(dmg)
					dmginfo:SetAttacker( self.EntOwner )
					dmginfo:SetInflictor( self.EntOwner )
					dmginfo:SetDamageType( DMG_CRUSH )
					dmginfo:SetDamageForce( ( self.EntOwner:GetForward() ) * 350 * dmg )
					
					self.EntOwner:EmitSound("NPC_Vortigaunt.Kick")
					
					hitent:SetGroundEntity( NULL )
					
					if hitent:IsPlayer() then
						hitent:SetLocalVelocity( ( self.EntOwner:GetForward() ) * 22 * dmg )
					end
					
					hitent:TakeDamageInfo(dmginfo)
			
				end
			
			end
		end

	end
	
	if self.DropKickFrames and self.EntOwner:OnGround() and self.IgnoreGround and self.IgnoreGround < CurTime() then
		self.IgnoreGround = nil
		self.EntOwner:SetLuaAnimation( "slide" )
	end
	
	
end

// just so we can break glass and stuff when diving
function ENT:CheckDiveBreakables()
	
	if self:IsDive() and not self.DiveHit then
		
		local normal = self.EntOwner:GetVelocity()
		normal.z = 0
		
		normal = normal:GetNormal()
		
		kick_trace.start = self.EntOwner:GetShootPos()
		kick_trace.endpos = kick_trace.start + normal * 72
		kick_trace.filter = self.EntOwner:GetMeleeFilter()
		
		local tr = util.TraceHull( kick_trace )
	
		if tr.Hit and !tr.HitWorld then
			local hitent = tr.Entity
			
			if hitent and hitent:IsValid() then
			
				self.DiveHit = true
				
				if self.SaveVel then
					self.EntOwner:SetLocalVelocity( self.SaveVel )
				end
			
				if hitent:GetClass() == "func_breakable_surf" then
					hitent:Fire("break", "", 0)
				end			
			end
		end

	end
	
end

/*
	x = 1 forward
	x = -1 backward
	y = 1 right
	y = -1 left
*/

function ENT:PickSlideAnimation()
	
	local x = self:GetMoveX()
	local y = self:GetMoveY()
	
	if x > 0 then
	
		//forward/right
		if y > x and y > 0 then
			return "slide_right"
		end
		//forward/left	
		if math.abs( y ) > x and y < 0 then
			return "slide_left"
		end
		//forward
		return "slide_back"
	
	else
	
		//back/right
		if y > math.abs( x ) and y > 0 then
			return "slide_right"
		end
		//back/left	
		if math.abs( y ) > math.abs( x ) and y < 0 then
			return "slide_left"
		end
		//backward
		return "slide"
	
	end

end

function ENT:Think()
	if SERVER then
		
		if ENDROUND then
			self:Remove()
			return
		end
		
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		//diving
		if self:IsDive() then
			
			self:CheckDiveBreakables()
			
			if self.EntOwner:OnGround() and self.IgnoreGround and self.IgnoreGround < CurTime() then
				self:SetDive( false )
				self.EntOwner._NextKick = CurTime() + 1
				//self.EntOwner:SetGravity( 1 ) 
				self.EntOwner:SetLuaAnimation( self:PickSlideAnimation() or "slide_back" )
			end
		//default sliding
		else
			if self.EntOwner._NextKick and self.EntOwner._NextKick > CurTime() and self.EntOwner:GetVelocity():LengthSqr() > 1600 then// and !self.EntOwner:OnGround() then
				//basically player is forced to slide for the duration of kick effect, otherwise obey the normal sliding rules
				if not self:ShouldForceDuck() then
					self:ForceDuck( true )
				end
			else
				if not self.EntOwner:KeyDown(IN_DUCK) or self.EntOwner:GetVelocity():LengthSqr() < 40000 then //self.EntOwner:KeyDown(IN_JUMP) or 
					self:Remove()
					return
				end
			end
			
			self:CheckDropKick()
		end
		
	end
	if CLIENT then
		if self.Sound and IsValid(self.EntOwner) and self.EntOwner:OnGround() then
			self.Sound:PlayEx(0.8,120)
		end
	end
	self:NextThink( CurTime() )
	return true
end

function ENT:SetNextJump( time )
	self:SetDTFloat( 0 , time )
end

function ENT:GetNextJump()
	return self:GetDTFloat( 0 )
end

function ENT:SetDive( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsDive()
	return self:GetDTBool( 0 )
end

//quack
function ENT:ForceDuck( bl )
	self:SetDTBool( 1, bl )
end

function ENT:ShouldForceDuck()
	return self:GetDTBool( 1 )
end

function ENT:SetMoveX( fl )
	self:SetDTFloat( 1, fl )
end

function ENT:SetMoveY( fl )
	self:SetDTFloat( 2, fl )
end

function ENT:GetMoveX( fl )
	return self:GetDTFloat( 1 )
end

function ENT:GetMoveY( fl )
	return self:GetDTFloat( 2 )
end

local vec_up = vector_up
function ENT:Move( mv )
	
	if self:IsDive() then
		
	else
	
		if self:ShouldForceDuck() then
			mv:AddKey( IN_DUCK )
		end
	
		if mv:KeyPressed( IN_JUMP ) and self.EntOwner:OnGround() and self:GetNextJump() < CurTime() then
			mv:SetVelocity( mv:GetVelocity() + vec_up * 200 )
			self:SetNextJump( CurTime() + 0.1 )
		end
		
		self.EntOwner:SetGroundEntity(NULL)
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)

		mv:SetVelocity(mv:GetVelocity() * (1 - FrameTime() * 0.2))
	end
	
end


if CLIENT then
function ENT:Draw()
	
	self.NextEffect = self.NextEffect or 0
	
	if self:GetPos():DistToSqr(MySelf:EyePos()) > 250000 then return end
	if self.NextEffect > CurTime() then return end
	
	self.NextEffect = CurTime() + 0.01
	
	if self.EntOwner and !self.EntOwner:OnGround() then return end
	
	//if self.Emitter then
	//	self.Emitter:SetPos(self.EntOwner:GetPos())
	//end
	
	local rand = VectorRand()
	rand.z = 0
	local pos = self.EntOwner:GetPos() + vector_up*math.Rand(2,4) + rand*math.Rand(0,10)
	
	local emitter = ParticleEmitter(self:GetPos())
	
	if emitter then
		for i=1, 5 do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(math.Rand(0.5, 1.4)*self.EntOwner:GetVelocity():Length()/4*VectorRand()+vector_up*math.random(30))
			particle:SetDieTime(math.Rand(0.5, 1))
			particle:SetStartAlpha(70)
			particle:SetEndAlpha(0)
			particle:SetStartSize(4)
			particle:SetEndSize(7)
			particle:SetRoll(math.Rand(-180, 180))
			particle:SetColor(100, 100, 100)
			particle:SetCollide(true)
			particle:SetBounce(0.1)
			particle:SetAirResistance(15)
			particle:SetGravity(vector_up*-25)
		end
	
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	


end

/*function ENT:UseCalcView(pos,ang)
	local ct = CurTime()
	
	local delta = self.DieTime - ct
	local mul = math.Clamp(1-delta,0,1)
	
	ang:RotateAroundAxis(ang:Right(),-360*mul)
	return pos, ang
end*/

end