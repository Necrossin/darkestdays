function EFFECT:Init( data )
	
	self.Velocity = (data:GetNormal() * 3/6 + VectorRand() * 1/3 + Vector(0,0,math.random(0,3)) * 1/6) *  math.random( 500, 700 )
	self.Gravity = 700

	self.LifeTime = CurTime() + math.Rand(3,5)

end

function EFFECT:Think( )

	if self.LifeTime > CurTime() then
		if self.Emitter then
			self.Emitter:Finish()
		end
		return false
	end	
	
	self.Entity:SetPos(self.Entity:GetPos()+self.Velocity*FrameTime())
	self.Velocity.z = self.Velocity.z-self.Gravity*FrameTime()
	
	local trace = {}
	trace.start 	= self.Entity:GetPos()
	trace.endpos 	= self.Entity:GetPos()+self.Velocity*FrameTime()
	trace.mask 		= MASK_NPCWORLDSTATIC
	local tr = util.TraceLine( trace )

	if (tr.Hit) then		
		return false
	end

	return true
end

local function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		particle:SetDieTime(0)
	end
end

EFFECT.NextParticle = 0

function EFFECT:Render()

	if not self.Emitter then
		self.Emitter = ParticleEmitter(self.Entity:GetPos())
	end

	if (self.NextParticle < CurTime()) then
		self.NextParticle = CurTime()+0.008+0.01*math.Rand(0,1)
		local particle = self.Emitter:Add("particle/particle_smokegrenade", self.Entity:GetPos()+VectorRand()*2)
		particle:SetVelocity(self.Velocity:GetNormal()*math.Rand(2,4)+VectorRand()*0.3)
		particle:SetDieTime(math.Rand(0.8,1.1))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(20,85))
		particle:SetEndSize(math.random(15,80))
		--particle:SetRoll(math.Rand(0,3))
		--particle:SetRollDelta(math.Rand(0,0.5))
		particle:SetColor(math.random(70,85), math.random(70,85), math.random(70,85))
		particle:SetLighting(true)
		particle:SetCollideCallback(CollideCallback)
	end
	
end



