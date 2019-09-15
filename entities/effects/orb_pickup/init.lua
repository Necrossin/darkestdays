function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	local t = math.Round(data:GetScale())
	
	if !IsValid(ent) then return end
	
	if MySelf:EyePos():DistToSqr( pos ) > 250000 then
		return		
	end
	
	local eff = t == 1 and "dd_health_orb_pickup" or t == 2 and "dd_mana_orb_pickup" or "dd_evil_orb_pickup"
	
	ParticleEffectAttach(eff,PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("chest"))	
end

function EFFECT:Think( )
end

function EFFECT:Render()

end