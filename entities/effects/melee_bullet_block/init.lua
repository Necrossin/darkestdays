//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	//norm.r = math.random(-90,90)

	WorldSound("weapons/fx/rics/ric"..math.random(1, 5)..".wav", pos, math.random(70,80), math.random(100, 115))
	
	ParticleEffect("melee_bullet_block",pos,norm,nil)
	
	self.DieTime = CurTime() + 1
end

function EFFECT:Think( )
return false
end

function EFFECT:Render()

end