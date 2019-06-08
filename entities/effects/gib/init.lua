local math = math
local table = table

local points = { 
	Vector( -16,-10,0 ), Vector( 16,-10,0 ), Vector( 16,10,0 ), Vector( -16,10,0 ),
	Vector( -16,-10,50 ), Vector( 16,-10,50 ), Vector( 16,10,50 ), Vector( -16,10,50 ),
  }

function EFFECT:Init(data)

	local id = math.Round( data:GetRadius() )
	local ph = SOLID_VPHYSICS
	
	
	if id ~= 0 and PlayerGibs[ id ] then
		
		self.Entity:SetModel(PlayerGibs[ id ].model)
		if PlayerGibs[ id ].ph then
			ph = PlayerGibs[ id ].ph
		end
	else
		local modelid = table.Count( Gibs )
		self.Entity:SetModel(Gibs[ math.random( modelid ) ])
	end
	
	if data:GetAngles() and id ~= 1 then
		self:SetAngles( data:GetAngles() )
	end
	

	if PlayerGibs[ id ] and PlayerGibs[ id ].bbox then
		self:PhysicsInitBox( PlayerGibs[ id ].bbox[1], PlayerGibs[ id ].bbox[2] ) 
	else
		self.Entity:PhysicsInit( ph )
	end
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	//self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )

	--if modelid < 4 then
		self.Entity:SetMaterial("models/flesh")
	--end
	
	local power = data:GetMagnitude() or 300
	local scale = math.Round(data:GetScale()) or 0
	
	if scale == 1 then 
		self.Entity:SetModelScale(math.Rand(0.5,1),0)
	elseif scale == 2 then
		self.Entity:SetModelScale(math.Rand(2,3.3),0)
	else
		self.Entity:SetModelScale(math.Rand(1,2),0)
	end
	
	if PlayerGibs[ id ] and PlayerGibs[ id ].scale then
		self.Entity:SetModelScale( PlayerGibs[ id ].scale, 0 )
	end
	
	self.BigDecal = false
	
	if PlayerGibs[ id ] and PlayerGibs[ id ].big_decal then
		self.BigDecal = true
	end
	
	if PlayerGibs[ id ] and PlayerGibs[ id ].scaledown then
		for k, v  in pairs( PlayerGibs[ id ].scaledown ) do
			local bone = self:LookupBone( v )
			if bone then
				self:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
				self:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
				self:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
			end
		end
	end
	
	if PlayerGibs[ id ] and PlayerGibs[ id ].scale_all_but then
		for i = 0, self:GetBoneCount() - 1 do
			if table.HasValue(PlayerGibs[ id ].scale_all_but,i) then continue end
			self:ManipulateBoneScale( i, Vector( 0, 0, 0 ) )
			self:ManipulateBoneScale( i, Vector( 0, 0, 0 ) )
			self:ManipulateBoneScale( i, Vector( 0, 0, 0 ) )
		end
	end
	
	//self.Entity:SetModelScale(math.Round(scale) == 1 and math.Rand(0.5,1) or math.Rand(1,2),0)

	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
		
		phys:Wake()
		//phys:EnableMotion(false)
		phys:SetMaterial("gmod_silent")//"zombieflesh"
		//phys:SetAngles( Angle( math.random(0,359), math.random(0,359), math.random(0,359) ) )
		phys:SetVelocityInstantaneous( data:GetNormal()*power*2 + VectorRand() * math.random(-power/2,power/2) + vector_up *  math.random( power/2, power ) )
		
	end
	self.Time = CurTime() + math.random(8, 15)
	--self.Emitter = ParticleEmitter(self.Entity:GetPos())
	
	
	--ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)

	
end

function EFFECT:PhysicsCollide( data, collider ) 
	self.NextSnd = self.NextSnd or 0
	
	self.Decal = self.Decal or 0
	
	if self.Decal < 3 then
		local hitpos = data.HitPos
		local hitnormal = data.HitNormal
		
		if self.BigDecal then
			util.Decal("BloodHuge"..math.random(1,5), hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
		self.Decal = self.Decal + 1
	end
	
	if self.NextSnd > CurTime() then return end
	
	if math.random(4) == 4 then
		sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", self:GetPos(), 80, math.random(75, 110))
	else
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", self:GetPos(), 80, math.random(95, 110))
	end

	self.NextSnd = CurTime() + math.Rand(0.3, 0.7)
	
	
	
end

function EFFECT:Think()
	if CurTime() > self.Time then
		--self.Emitter:Finish()
		return false
	end
	return true
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
end

function EFFECT:Render()
	if IsValid(self.Entity) then
		self.Entity:DrawModel()
		/*if self.Entity:GetVelocity():Length() > 20 then
			local emitter = ParticleEmitter(self.Entity:GetPos())
			local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), self.Entity:GetPos())
				particle:SetVelocity(VectorRand() * 16)
				particle:SetDieTime(0.8)
				particle:SetStartAlpha(0)
				particle:SetStartSize(10)
				particle:SetEndSize(3)
				particle:SetRoll(180)
				particle:SetColor(255, 0, 0)
				particle:SetLighting(true)
				particle:SetCollide(true)
				particle:SetAirResistance(12)
				particle:SetCollideCallback(CollideCallbackSmall)
			emitter:Finish() emitter = nil collectgarbage("step", 64)	
		end*/
	end
end
