

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	norm:RotateAroundAxis(norm:Right(),90)
	
	//ExplosiveEffect(pos, 84, 35, DMG_BURN)
	
	ParticleEffect("firebolt_explosion",pos,norm,nil)
	
	
end


function EFFECT:Think( )

end


function EFFECT:Render()

end





