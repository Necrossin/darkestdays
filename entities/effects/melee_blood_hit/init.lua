//Simple Effect to handle particles

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
	
		particle.HitAlready = true
		
		if math.random(1, 10) == 3 then
			WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
		end
		local rand = math.random(2)
		if rand ~= 1 then
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
		particle:SetDieTime(0)
	end	
end

function EFFECT:Init( data )

	local pos = data:GetOrigin()*1
	local norm = data:GetNormal()*10
	
	ParticleEffect("dd_blood_impact2",pos,norm:Angle(),self.Entity)
	
	util.Decal("Blood", pos + norm, pos - norm)
	
	local emitter = ParticleEmitter(pos)

	for i=1, math.random(2, 3) do
		local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
		local force = math.Rand(35, 100)
										
		particle:SetVelocity(force * norm + 0.35 * force * VectorRand())
		particle:SetDieTime(math.Rand(2.25, 3))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(1, 8))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-40, 40))
		particle:SetColor(255, 0, 0)
		particle:SetAirResistance(5)
		particle:SetBounce(0)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallbackSmall)
		particle:SetLighting(true)
	end
	
	if MySelf:EyePos():DistToSqr( pos ) < 8100 then
		AddBloodSplat( 3 )
		MySelf:AddBloodyStuff()		
	end
	
	emitter:Finish()
	
	self.DieTime = CurTime() + 2
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end

function EFFECT:Render()
	
end