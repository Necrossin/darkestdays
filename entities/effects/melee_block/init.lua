//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	norm.r = math.random(-90,90)

	
	ParticleEffect("impact_melee_block",pos,norm,self.Entity)
	
	self.DieTime = CurTime() + math.random(2,3)	
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end

function EFFECT:Render()

end