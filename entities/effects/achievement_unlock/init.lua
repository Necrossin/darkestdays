//Simple Effect to handle particles

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	
	ParticleEffect("achieved",pos+vector_up*11,Angle(0,0,0),self.Entity)
	
	self.DieTime = CurTime() + math.random(2,3)	
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end

function EFFECT:Render()

end