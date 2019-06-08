ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Duration = 0.1
ENT.Uses = 4

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
		if SERVER then
			//self.EntOwner:SetLocalVelocity( self.EntOwner:GetVelocity():GetNormal() * self.EntOwner:GetWalkSpeed() )
		end
	end
	if CLIENT then
		//if IsValid( self.EntOwner ) and self.Particle then
			//self.EntOwner:StopParticlesNamed( "dash_red" ) 
		//end
	end
end

function ENT:Think()
	if CLIENT then
		--if self.Sound then
		--	self.Sound:PlayEx(0.9, 95 + math.sin(RealTime())*5) 
		--end
	end

	if SERVER then
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		--self.EntOwner:SetLocalVelocity(vector_origin)
		
	end
end

if CLIENT then
local mat = Material( "models/spawn_effect2" )
function ENT:Draw()
	
	/*if self.Particle and MySelf == self.EntOwner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		self.EntOwner:StopParticlesNamed( "dash_red" ) 
		return
	end*/
	
	/*if !( MySelf == self.EntOwner and not GAMEMODE.ThirdPerson) then
		render.MaterialOverride( mat )
		render.SetColorModulation( 1, 0.1, 0.1 )
		render.SetBlend( 0.6 )

		self:SetModelScale( 1.2, 0 )
			
		self:SetupBones()
		self:DrawModel()
			
		render.SetBlend( 1 )
		render.SetColorModulation( 1, 1, 1 )		
		render.MaterialOverride( nil )
	end

	*/
	
	
	
	
	
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