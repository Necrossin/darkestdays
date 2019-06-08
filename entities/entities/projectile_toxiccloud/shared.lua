ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

util.PrecacheSound("ambient/gas/steam2.wav")

local table = table
local util = util
local player = player
local ents = ents
//sneaky remake of my power well

local player_GetAll = player.GetAll

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(4,7)
	self.Radius = 65
	self.DamageRate = 0.008
	self.DamageAmount = 4.8
	
	--self.EntOwner = self.Entity:GetOwner()
	if SERVER then
		self.Entity:DrawShadow(false)
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
		self.WooshSound = CreateSound( self, "ambient/gas/steam2.wav" ) 
	end
	
end

local vec_0_0_40 = Vector(0,0,40)

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		self.NextHit = self.NextHit or 0
		
		if self.NextHit > CurTime() then return end
		
		self.NextHit = CurTime() + self.DamageRate

		local players = ents.FindInSphere( self:GetPos()+vec_0_0_40, self.Radius )

		for k, guy in pairs(players) do
			if guy:IsPlayer() and (guy == self.EntOwner or not guy:IsTeammate(self.EntOwner)) or guy:IsNPC() then//guy:Team() ~= self.EntOwner:Team()) then
			
				local ppl = player_GetAll()
				local filterplayers = {}
					
				for _,dude in pairs(ppl) do
					if guy != dude then 
						table.insert(filterplayers,dude)
					end
				end
				
				table.insert(filterplayers,self)
				table.insert(filterplayers,GetHillEntity() or self)
				
				local trace = {}
				trace.start = self:GetPos() + vec_0_0_40
				trace.endpos = guy:GetPos() + vec_0_0_40
				trace.filter = filterplayers
				local tr = util.TraceLine( trace )
				
				if IsValid(tr.Entity) and tr.Entity == guy then
					guy:TakeDamage(self.DamageAmount,self.EntOwner,self)
				end
			end
		end
	end
	if CLIENT then
		if self.WooshSound then
			local vol = self.DieTime - math.max(0,self.DieTime - CurTime())
			local addvol = math.Clamp(vol/self.DieTime,.1,.7)
			self.WooshSound:PlayEx(addvol, 85 + math.sin(RealTime())*5)
		end
	end
end

function ENT:OnRemove()
	if SERVER then
		--self.Entity:EmitSound("ambient/levels/citadel/portal_beam_shoot5.wav",math.random(70,110),80)	
	end
	if CLIENT then
		if self.WooshSound then
			self.WooshSound:Stop()
		end
		if self.Emitter then
			self.Emitter:Finish()
		end
	end
end

if CLIENT then
function ENT:Draw()
	
	local vec = Vector(self.Radius,self.Radius,50)
	self.Entity:SetRenderBounds( vec, -vec)
	
	self.Pos = self:GetPos()// + Vector(0,0,30)

	if not self.Particle then
		ParticleEffect("toxicbreeze_projectile",self.Pos,Angle(0,0,0),self.Entity)
		self.Particle = true
	end
	
	//draw circling effect
	
	/*local emitter = self.Emitter
	
	self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit > CurTime() then return end
	
	self.NextEmit = CurTime() + 0.09
	
	for num=0,5 do
		
		local radius = self.Radius*(num/5)
		
		for i=1, math.random(4,11) do
				local rad = math.random(0,35)+15*num	
				local particle = emitter:Add("particle/smokestack", self.Pos)
					particle:SetPos(Vector(self.Pos.x +  math.sin( CurTime()*5+math.rad( rad*i ) ) * radius,self.Pos.y + math.cos( CurTime()*5+math.rad( rad*i ) ) * radius,self.Pos.z+math.random(-45,25)))
					--particle:SetVelocity(VectorRand()*math.random(1,8))
					particle:SetStartAlpha(155)
					particle:SetDieTime(math.Rand(1, 3))
					particle:SetStartSize(math.random(5, 20))
					particle:SetEndSize(0)
					particle:SetLighting(true)
					particle:SetGravity(vector_up*2*i)
					//particle:SetRoll(math.Rand(0, 360))
					//particle:SetRollDelta(math.Rand(-40, 40))
					local rand = math.random(50,100)
					particle:SetColor(rand,200,rand)
					particle:SetAirResistance(12)
					
					
					particle:SetCollide(true)
			end
	end*/
end

end

