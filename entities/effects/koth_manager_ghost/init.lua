local math = math
local util = util
local render = render

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	self.Entity:SetModel("models/props_combine/combine_mine01.mdl")	
	
	self.Particle = CreateParticleSystem( self.Entity, "hill_neutral", PATTACH_ABSORIGIN_FOLLOW )  //ParticleEffectAttach( "hill_neutral", PATTACH_ABSORIGIN_FOLLOW, self.Entity, 0 ) 
	
	
end

function EFFECT:Think()
	
	if !ValidEntity(self.EfOwner) then return false end
	if !ValidEntity(self.EfOwner:GetActiveWeapon()) then return false end
	if self.EfOwner:GetActiveWeapon():GetClass() ~= "koth_manager" then return false end
	if not self.EfOwner:Alive() then return false end
	
	local ent = self.Entity
	
	local wep = self.EfOwner:GetActiveWeapon()
	self.radius = wep:GetDTInt(0) or 100
	
	local trace = self.EfOwner:GetEyeTrace()
	
	if not self.Emitter then
		self.Emitter = ParticleEmitter(trace.HitPos+vector_up*2)
	end
	
	if self.Emitter then
		self.Emitter:SetPos(trace.HitPos+vector_up*2)
	end
	self.Entity:SetPos(trace.HitPos+vector_up*2)
	
	ent:SetColor (Color(0,255,0,200))

	
	return (self and self.EfOwner and IsValid(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "koth_manager" and self.EfOwner:Alive())
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
	
	local pos = self:GetPos()+vector_up*12
	
	local trace = {}
	trace.start = self:GetPos()+vector_up*30
	trace.endpos = self:GetPos()+vector_up*-150
	trace.filter = {self.Entity,player.GetAll()}
	trace.mask = MASK_SOLID_BRUSHONLY
	
	trace = util.TraceLine(trace)
	
	local norm = vector_up
	
	if trace.HitNormal then
		norm = trace.HitNormal
	end
	
	if self.Particle then
		
		self.radius = self.radius or 100
		
		self.Particle:SetControlPoint( 2, Vector( self.radius, 0, 0 ) ) 
		
	end
	
	/*if not self.Emitter then return end
	
	local ang = norm:Angle()
	
	self.Particles = self.Particles or {}
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit < CurTime() then 
		
		for i=1, 6 do
			self.Particles[i] = self.Emitter:Add("particle/smokestack", pos )
		end
		
		self.NextEmit = CurTime() + 0.01
		
	end
	
	self.radius = self.radius or 100

	for i=1, #self.Particles do	
		local rad = 60*i		
		local particle = self.Particles[i]
		particle:SetPos(pos+ang:Right()*math.sin( CurTime()+math.rad( rad*i ) ) * self.radius+ang:Up()*math.cos( CurTime()+math.rad( rad*i ) ) * self.radius)
		particle:SetDieTime(math.Rand(0.8, 2))
		particle:SetStartAlpha(125)
		particle:SetStartSize(math.Rand(4, 17.5-i*1.5))
		particle:SetEndSize(0)
		particle:SetColor( 50,250,50 )
		--particle:SetColor( LightColor.r*0.5, 0, 0 )
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(vector_up*math.Rand(-6,-3))
		particle:SetCollide(true)
		particle:SetAirResistance(12)
	end*/
end
