function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
	--self.Emitter = ParticleEmitter( self.Position )
	self.DieTime = CurTime()+0.8
	
	
end


function EFFECT:Think( )
	self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
	if CurTime() > self.DieTime then
		--if self.Emitter then
		--	self.Emitter:Finish()
		--end
		return false
	end
	return true
end


function EFFECT:Render()
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit > CurTime() then return end
	
	self.NextEmit = CurTime() + 0.02
	
	local emitter = ParticleEmitter( self.Position )
	
	for i=0, math.random(2,6) do

			local pos = self.Position
			local rand = VectorRand()*math.random(0,30)
			rand.z = math.random(-1,40)
			local particle = emitter:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", pos+rand+vector_up*2*i )
			particle:SetDieTime(math.Rand(1, 2))
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(20, 34))
			particle:SetEndSize(math.Rand(20, 34))
			particle:SetEndSize(0)
			local rand = math.random(130,245)
			particle:SetColor(rand,rand,255)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(VectorRand()*math.random(130,200))
			particle:SetCollide(true)
			particle:SetAirResistance(12)
	end	
	
	for i=0, math.random(5,9) do
		local pos = self.Position
		local rand = VectorRand()*math.random(0,30)
		rand.z = math.random(-1,40)
		local particle = emitter:Add("effects/fleck_glass"..math.random(1,3), pos+rand+vector_up*2 )
		particle:SetVelocity(rand*math.random(2,10))
		particle:SetDieTime(math.Rand(1, 4))
		particle:SetStartAlpha(255)
		particle:SetStartSize(math.Rand(1, 3))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,-300))
		particle:SetCollide(true)
		particle:SetBounce(2)
		particle:SetAirResistance(74)
	end
	
	emitter:Finish() emitter = nil collectgarbage("step", 64)	
	
end





