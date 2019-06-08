

function EFFECT:Init( data )
	//models/props_debris/concrete_spawnplug001a.mdl
	local pos = data:GetOrigin()
	local norm = data:GetNormal():Angle()
	norm:RotateAroundAxis(norm:Right(),90)
	
	ParticleEffect("dd_explosion_medium",pos,norm,nil)
	
	
	
	/*local hole = math.Round(data:GetMagnitude())
	
	ParticleEffect("smoke_small_01",pos+vector_up*3,Angle(0,0,0),self.Entity)
	ParticleEffect("fire_small_flameouts",pos+vector_up*3,Angle(0,0,0),self.Entity)
	//ParticleEffect("grenade_explosion_01",pos+vector_up*3,Angle(0,0,0),self.Entity)
	
	
	self.Hole = hole
	
	if self.Hole == 1 then 
		self.DieTime = CurTime() + math.random(7,9)
		
		self.Entity:SetModel("models/props_debris/plaster_floor003a.mdl")
		self.Entity:SetPos(norm)
		self.Entity:SetRenderMode(RENDERMODE_TRANSALPHA) 

	end
	
	local emitter = ParticleEmitter( pos, true )
	
		for i=1, math.random(18,22) do
		
			local vec = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) )
		
			local particle = emitter:Add( "particles/balloon_bit", pos+vec*math.random(5,9) )
			if (particle) then
				
				particle:SetVelocity( vec * 300 )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.random(3,6) )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )
				
				particle:SetStartSize( math.Rand( 1, 3 ) )
				particle:SetEndSize( 0 )
				
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				
				particle:SetAirResistance( 100 )
				particle:SetGravity( Vector(0,0,70) )
				
				particle:SetColor( math.random(210,230),math.random(55,65),0 )
				
				particle:SetCollide( true )
				
				particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) ) 
				
				particle:SetBounce( 1 )
				particle:SetLighting( true )
				
			end
			
		end
	
	for i=1, math.random(10,17) do
		
			local particle = emitter:Add( "Effects/fleck_cement"..math.random(1,2), pos+vector_up*math.random(1,2) )
			if (particle) then
				
				local vec = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) )
				
				particle:SetVelocity( vec * 100 + vector_up*200 )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.random(4,6) )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )
				
				particle:SetStartSize( math.Rand( 2, 5 ) )
				particle:SetEndSize( 0 )
				
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				
				particle:SetAirResistance( 100 )
				particle:SetGravity( Vector(0,0,-600) )
				
				--particle:SetColor( math.random(210,230),math.random(55,65),0 )
				
				particle:SetCollide( true )
				
				particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) ) 
				
				particle:SetBounce( 1 )
				particle:SetLighting( true )
				
			end
			
		end
		
	emitter:Finish()
	
	for i= 0, math.random(3,6) do
				
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( (VectorRand() + Vector(0,0,math.random(0,1))):GetNormal() )
		util.Effect( "explosion_trail", effectdata )
					
	end
	*/
end

function EFFECT:Think( )
	/*if self.Hole != 1 then
		if self.Entity then
			self.Entity:StopParticles()
		end
		return false 
	end*/
	return false //CurTime() < self.DieTime
end

function EFFECT:Render()

	/*if self.Hole != 1 then return end
	self.Entity:SetModelScale(0.4,0)
	self.Entity:SetColor(Color(255,255,255,math.Clamp((self.DieTime-CurTime())*30,0,255)))
	self.Entity:DrawModel()*/
	
end