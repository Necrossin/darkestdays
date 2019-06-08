ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT


if SERVER then
	AddCSLuaFile("shared.lua")
end

local tp = Sound("physics/body/body_medium_break2.wav")

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner._efGhosting) then
		if SERVER then
			self.EntOwner._efGhosting:Remove()
		end
		self.EntOwner._efGhosting = nil
	end
	
	self.EntOwner._efGhosting = self.Entity
	
	if SERVER then
		self.Entity:DrawShadow(false)
		self.EntOwner:DrawWorldModel( false )
		WorldSound(tp,self:GetPos(),100,math.random(110,140)) 
	end
	
	self.EntOwner:SetRenderMode( RENDERMODE_NONE )
	
	if CLIENT then
		if IsValid( self.Entity:GetOwner() ) then
			hook.Run( "PlayerTransparencyChanged", self.Entity:GetOwner(), 0 )
		end
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
		ParticleEffectAttach("ghosting_effect",PATTACH_POINT_FOLLOW,self.EntOwner,self.EntOwner:LookupAttachment("chest") or self.EntOwner:LookupAttachment("anim_attachment_LH"))
	end
	
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner._efGhosting = nil
		self.EntOwner:SetRenderMode(RENDERMODE_NORMAL)
		if SERVER then 
			self.EntOwner:DrawWorldModel(true) 
			self.EntOwner._NextGhosting = CurTime() + 0.5
			WorldSound(tp,self:GetPos(),100,math.random(110,140)) 
		end
	end
	-- just in case
	if CLIENT then
		if IsValid( self.Entity:GetOwner() ) then
			hook.Run( "PlayerTransparencyChanged", self.Entity:GetOwner(), 1 )
		end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

function ENT:Think()
	
	if IsValid( self.EntOwner ) then
		self.EntOwner:SetRenderMode(RENDERMODE_NONE)
	end

	self.EntOwner._efCantCast = CurTime() + 2
	
	if !IsValid(self.EntOwner) or not self.EntOwner:Alive() or !self.EntOwner:KeyDown( IN_SPEED ) or self.EntOwner:GetMana() < 3 then
			if IsValid(self.EntOwner) then
				if SERVER then
					//WorldSound(tp,self:GetPos(),100,math.random(110,140)) 
				end
				if CLIENT then
					if not self.Particle then
						ParticleEffectAttach("ghosting_effect",PATTACH_POINT_FOLLOW,self.EntOwner,self.EntOwner:LookupAttachment("chest") or self.EntOwner:LookupAttachment("anim_attachment_LH"))
						self.Particle = true
					end
				end
			end
			
			if SERVER then
				self:Remove()
			end
			return
	end
				
	self.NextTick = self.NextTick or 0
	if SERVER then
		self.EntOwner._NextManaRegen = CurTime() + 2
	end
		
	if self.NextTick < CurTime() then
		local am = 3
		if SERVER then
			self.EntOwner:SetMana(math.Clamp(self.EntOwner:GetMana()-am,0,self.EntOwner:GetMana()))	
		end	
		self.NextTick = CurTime() + 0.175
	end
end

if CLIENT then
function ENT:Draw()
	
end
end