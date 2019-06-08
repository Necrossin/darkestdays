//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	local col = math.Round(data:GetScale())

	WorldSound("physics/surfaces/underwater_impact_bullet"..math.random(1, 3)..".wav", pos, math.random(70,80), math.random(100, 115))
	
	ParticleEffect(col == 0 and "dd_magic_shield_impact" or "dd_magic_shield_impact_red",pos,norm,nil)
end

function EFFECT:Think( )
return false
end

function EFFECT:Render()

end