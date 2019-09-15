//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	
	if MySelf:EyePos():DistToSqr( pos ) > 360000 then
		return		
	end
	
	ParticleEffect("electrobolt_splash",pos,norm,nil)
end

function EFFECT:Think( )
end

function EFFECT:Render()

end