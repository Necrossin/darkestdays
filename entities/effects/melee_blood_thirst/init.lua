function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	
	if MySelf:EyePos():DistToSqr( pos ) > 250000 then
		return		
	end
	
	if !IsValid(ent) then return end
	
	ParticleEffectAttach("melee_health_drain",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("anim_attachment_RH"))	
end

function EFFECT:Think( )
end

function EFFECT:Render()

end