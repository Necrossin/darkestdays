function EFFECT:Init( data )

	local pos = data:GetOrigin()
	self.ent = data:GetEntity()
	local glow = math.Round( data:GetRadius() ) == 1
	
	if !IsValid(self.ent) then return end
	
	if self.ent == MySelf and !GAMEMODE.ThirdPerson then return end

	self.particle = "melee_trail_normal"
	
	if glow or self.ent._efSpeedBoost or self.ent._efAdrenaline then
		self.particle = "melee_trail_red"
		if self.ent:Team() == TEAM_BLUE then
			self.particle = "melee_trail_blue"
		end
	end
	
	ParticleEffectAttach( self.particle,PATTACH_POINT_FOLLOW, self.ent, self.ent:LookupAttachment("anim_attachment_RH") )
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end