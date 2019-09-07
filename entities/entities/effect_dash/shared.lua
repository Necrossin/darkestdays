ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Duration = 0.5
ENT.Uses = 4

ENT.DashSpeed = 1000

if SERVER then
	AddCSLuaFile("shared.lua")
end


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner._efDash) then
		if SERVER then
			self.EntOwner._efDash:Remove()
		end
		self.EntOwner._efDash = nil
	end
	
	self:SetModel( self.Entity:GetOwner():GetModel() )
	
	//self:AddEffects( EF_BONEMERGE )
	
	self.EntOwner._efDash = self.Entity
	
	local vel = self.EntOwner:GetVelocity()
	vel.z = 0
	
	vel = vel:GetNormal()
	
	local idle = false
	
	if vel:LengthSqr() < 0.1 then
		vel = self.EntOwner:SyncAngles():Forward()
		idle = true
	end
	
	//print( vel * self.DashSpeed )
	//self.EntOwner:SetGroundEntity( NULL )
	if not self.EntOwner:OnGround() or idle then
		self.EntOwner:SetGroundEntity( NULL )
		self.EntOwner:SetLocalVelocity( vel * self.DashSpeed )
	end
	
	self.EntOwner.DashFrames = CurTime() + 0.8 //just so we have enough time to hit
	
	if SERVER then
		self.Entity:DrawShadow(false)
		
		local e = EffectData()
		e:SetOrigin( self:GetPos() )
		e:SetEntity( self.EntOwner )
		util.Effect( "dash_trail", e, nil, true )
		
	end
	
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end
	
	self.DieTime = CurTime() + self.Duration
	
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner._efDash = nil
	end

end

function ENT:Think()
	if SERVER then
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
	end
end

function ENT:Move( mv )
	
	//self.EntOwner:SetGroundEntity(NULL)	
	
	local dash_speed = self.DashSpeed * math.Clamp( ( self.DieTime - CurTime() ) / self.Duration, 0, 1 )   //(1 - FrameTime() * 0.2)
	
	local speed = mv:GetMaxSpeed() + dash_speed
	local speed_cl = mv:GetMaxClientSpeed() + dash_speed
	
	mv:SetMaxSpeed( speed )
	mv:SetMaxClientSpeed( speed_cl )	
	/*
	if not self.EntOwner:OnGround() or not ( self.EntOwner:KeyDown( IN_FORWARD ) or self.EntOwner:KeyDown( IN_BACK ) or self.EntOwner:KeyDown( IN_MOVELEFT ) or self.EntOwner:KeyDown( IN_MOVERIGHT ) ) then
	
		//self.EntOwner:SetGroundEntity(NULL)
	
		//mv:SetSideSpeed(0)
		//mv:SetForwardSpeed(0)
	
		local norm = mv:GetVelocity()
		
		if norm:Length2DSqr() < 100 then
			norm = self.EntOwner:SyncAngles():Forward()
		else
			norm.z = 0
			norm = norm:GetNormal()
		end

		mv:SetVelocity( norm * self.DashSpeed / 2 )
		
	end*/
	
	
end

if CLIENT then
local mat = Material( "models/spawn_effect2" )
function ENT:Draw()

	if not self.Particle then
		
		local part = "dash_red"
		
		if self.EntOwner:Team() == TEAM_BLUE then
			part = "dash_blue"
		end
	
		/*ParticleEffectAttach(part,PATTACH_ABSORIGIN_FOLLOW,self.EntOwner,0)
		ParticleEffectAttach(part,PATTACH_ABSORIGIN_FOLLOW,self.EntOwner,0)*/
		
		local att = self.EntOwner:LookupAttachment("eyes")
		if att then
			ParticleEffectAttach( part, PATTACH_POINT_FOLLOW, self.EntOwner, att )
		end
		
		att = self.EntOwner:LookupAttachment("chest")
		if att then
			ParticleEffectAttach( part, PATTACH_POINT_FOLLOW, self.EntOwner, att )
		end
		
		att = self.EntOwner:LookupAttachment("anim_attachment_RH")
		if att then
			ParticleEffectAttach( part, PATTACH_POINT_FOLLOW, self.EntOwner, att )
		end
		
		att = self.EntOwner:LookupAttachment("anim_attachment_LH")
		if att then
			ParticleEffectAttach( part, PATTACH_POINT_FOLLOW, self.EntOwner, att )
		end
		
		//ParticleEffectAttach("dash_red",PATTACH_POINT_FOLLOW,self.EntOwner,0)
		self.Particle = true
	end
end
end