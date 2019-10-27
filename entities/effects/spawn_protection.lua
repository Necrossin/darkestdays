local mat_overlay = Material( "models/spawn_effect2" )
local string_Replace = string.Replace
local bounds = Vector(128, 128, 128)

function EFFECT:GetNiceModel( str )
	return string_Replace( str, "models/models/", "models/" ) 
end

function EFFECT:Init( data )
	
	self.ent = data:GetEntity()
	self.time = data:GetRadius() or 1
	
	if !IsValid(self.ent) then return end

	self:SetModel( self:GetNiceModel( self.ent:GetModel() ) ) 
	self:SetParent( self.ent._efThug or self.ent )
	self:AddEffects( EF_BONEMERGE )
	
	self.DieTime = CurTime() + self.time
	
	self.Entity:SetRenderBounds( bounds * -1, bounds )
	
	self.IgnorePress = CurTime() + 0.1
	
end

function EFFECT:Think()
	
	if IsValid( self.ent ) then
		if ( self.ent:KeyDown( IN_ATTACK ) or self.ent:KeyDown( IN_ATTACK2 ) ) and self.IgnorePress and self.IgnorePress < CurTime() then
			return false
		end
	end
	
	return self.ent and self.ent:IsValid() and self.ent.Alive and self.ent:Alive() and self.DieTime and ( self.DieTime > CurTime() )
	
end

function EFFECT:Render()
	
	if self.ent and self.ent:IsValid() and self.ent.Alive and self.ent:Alive() and not self.ent:IsCrow() then
		
		if self.ent == MySelf and !GAMEMODE.ThirdPerson then return end
	
		self:SetParent( self.ent._efThug or self.ent )
		self:AddEffects( EF_BONEMERGE )
		
		if not self.RenderCol then
			self.RenderCol = team.GetColor( self.ent:Team() )
		end
	
		render.SuppressEngineLighting( true )
			render.MaterialOverride( mat_overlay )
			render.SetColorModulation( self.RenderCol.r / 255, self.RenderCol.g / 255, self.RenderCol.b / 255 )

			self:DrawModel()
								
			render.SetColorModulation( 1, 1, 1 )
			render.MaterialOverride( nil )
		render.SuppressEngineLighting( false )
	
	end
	
end



