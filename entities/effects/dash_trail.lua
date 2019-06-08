function EFFECT:Init( data )

	local pos = data:GetOrigin()
	self.ent = data:GetEntity()
	
	if !IsValid(self.ent) then return end
	
	self:SetModel( self.ent:GetModel() )
	
	self:SetParent( self.ent )
	self:AddEffects( EF_BONEMERGE )
	
	self.particle = "dash_red"
	
	if self.ent:Team() == TEAM_BLUE then
		self.particle = "dash_blue"
	end
	
	
end

function EFFECT:Think( )
	
	if !IsValid( self.ent ) then return false end
	
	if self.ent and not self.DieTime and !self.ent:IsDashing() then
		self.DieTime = CurTime() + 0.4
	end
	
	if self.ent and !self.ent:Alive() then
		self.DieTime = 0
	end
	
	if self.DieTime and self.DieTime < CurTime() then
		if self.ent and self.ent:IsValid() then
			self.ent:StopParticlesNamed( self.particle or "dash_red" )
		end
		return false
	else
		return true
	end

end

local mat = Material( "models/spawn_effect2" )

function EFFECT:Render()
	
	if self.ent and self.ent:IsValid() then
		
		
		render.MaterialOverride( mat )
		if self.ent:Team() == TEAM_BLUE then
			render.SetColorModulation( 0.1, 0.1, 1 )
		else
			render.SetColorModulation( 1, 0.1, 0.1 )
		end
		render.SetBlend( 0.5 )

		self:SetModelScale( 1.2, 0 )
			
		self:DrawModel()
			
		render.SetBlend( 1 )
		render.SetColorModulation( 1, 1, 1 )		
		render.MaterialOverride( nil )
		
		/*if not self.Particle then
			ParticleEffectAttach(self.particle or "dash_red",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)
			ParticleEffectAttach(self.particle or "dash_red",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)
			//ParticleEffectAttach("dash_red",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)
			self.Particle = true
		end*/
		
	end

end