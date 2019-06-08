function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	
	if !IsValid(ent) then return end
	
	ParticleEffectAttach("melee_health_drain",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("anim_attachment_RH"))	
end

function EFFECT:Think( )
end

function EFFECT:Render()

end