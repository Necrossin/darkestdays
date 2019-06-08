//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	local col = math.Round(data:GetScale())
	
	
	ParticleEffect(col == 0 and "dd_magic_shield1" or "dd_magic_shield1_red",pos,norm,nil)

end

function EFFECT:Think( )
return false
end

function EFFECT:Render()

end