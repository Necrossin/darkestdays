ENT.Name = "Fire Bolt 2"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 1
ENT.Damage = 2

ENT.TickRate = 0.02

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("spell_firebolt2","firebolt2")
end

PrecacheParticleSystem( "firebolt2_stream" )
PrecacheParticleSystem( "v_firebolt2_stream" )

util.PrecacheSound( "weapons/flame_thrower_loop.wav" )

local util = util

function ENT:OnInitialize()
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
		
		self.FireSound = CreateSound( self, "weapons/flame_thrower_loop.wav" ) //ambient/fire/fire_big_loop1.wav
	end
	//requires to hold down mouse button!
	self:SetDTBool(2,true)
	
	//shows that we are casting
	self:SetDTFloat(1,0)
end

function ENT:DoCast()
	
	self:SetDTFloat(1,CurTime()+0.08)

end

function ENT:Cast()
	
	self:DoCast()
end


function ENT:StartFlames()
	
	self:SetDTBool(0,true)
	
end

local tr = {}
local temp_vel = {}
function ENT:CastFlames()
	
	if CLIENT then
		if self.FireSound then
			self.FireSound:PlayEx(1, 85 + math.sin(RealTime())*5)
		end
	end
	
	if not SERVER then return end
	self.NextDamage = self.NextDamage or 0
	
	if self.NextDamage > CurTime() then return end
	
	self.NextDamage = CurTime() + self.TickRate
	
	local aimvec = self.EntOwner:GetAimVector()
	--local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 300, filter = self.EntOwner})
	
	local range = 220
	local range_sqr = 48400
	
	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * range
	tr.mins = Vector(-10,-10,-10)
	tr.maxs = Vector(10,10,10)
	tr.filter = self.EntOwner
	
	local trace = util.TraceHull(tr)
	
	//local dec = self.EntOwner:GetEyeTrace()
	
	if trace.Hit then
		//util.Decal( "Scorch", dec.HitPos + dec.HitNormal, dec.HitPos - dec.HitNormal )
	end
	
	if IsValid(trace.Entity) and trace.Entity:GetClass() == "projectile_cyclonetrap" and trace.Entity:Team() == self.EntOwner:Team() and not (trace.Entity:GetDTBool(0) or trace.Entity:GetDTBool(2)) then
		trace.Entity:SetDTBool(1,true)
		return 
	end
	
	if IsValid(trace.Entity) then
	
		local damage = self.Damage
		
		local dist_sqr = self.EntOwner:GetPos():DistToSqr( trace.Entity:GetPos() )
		local mul = math.Clamp( 1 - dist_sqr / range_sqr, 0.3, 1 )
		
		local Dmg = DamageInfo()
		Dmg:SetAttacker(self.EntOwner)
		Dmg:SetInflictor(self.Entity)
		Dmg:SetDamage( damage * mul )
		Dmg:SetDamageType(DMG_BURN)
		Dmg:SetDamagePosition(trace.HitPos)
		
		if trace.Entity:IsPlayer() and not self.EntOwner:IsTeammate(trace.Entity) then
			temp_vel[ trace.Entity ] = trace.Entity:GetVelocity()
			trace.Entity:TakeDamageInfo(Dmg)
			if temp_vel[ trace.Entity ] then
				trace.Entity:SetLocalVelocity( temp_vel[ trace.Entity ] )
				temp_vel[ trace.Entity ] = nil
			end
		end
		
		if !trace.Entity:IsPlayer() then
			trace.Entity:TakeDamageInfo(Dmg)	
		end
						
	end
	
	
	
	
	
end

function ENT:StopFlames()
	
	self:SetDTBool(0,false)
	if CLIENT then
		if self.FireSound then
			self.FireSound:Stop()
		end
	end
	
end

function ENT:Think()

	local ct = CurTime()
	
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end

	
	if self:GetDTFloat(1) > CurTime() and self.EntOwner:CanCast(self,13) then
		self:StartFlames()
	else
		if !self.EntOwner:CanCast(self) then
			self:StopFlames()
			self.EntOwner._efCantCast = CurTime() + 2
		else
			self:StopFlames()
		end
	end
	
	
	self.NextTick = self.NextTick or 0
	
	if self:GetDTBool(0) then
	
		if self.EntOwner:GetCurSpellInd() ~= self:GetDTInt(0) then
			self:StopFlames()
		end
			
		if self.EntOwner:CanCast(self) then 
			if self.NextTick < ct then
				if SERVER then self:UseDefaultMana() end	
				self.NextTick = CurTime() + self.TickRate
			end
		else
			self:StopFlames()
			self.EntOwner._efCantCast = ct + 2
		end
	
	end
	
	if self:GetDTBool(0) then
			
		self:CastFlames()
		
	end
	
	self:NextThink( CurTime() )
	return true

end

function ENT:OnRemove()
	if CLIENT then

		if IsValid(self.EntOwner) then
			self.EntOwner:StopParticles()
		end
	end
	self:StopFlames()
end

if CLIENT then
local math = math
local pairs = pairs
function ENT:OnDraw()

	local owner = self.EntOwner
	local wep = owner:GetActiveWeapon()
	local point = wep and wep.WElements and wep.WElements["cast"] and wep.WElements["cast"].modelEnt
		
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then // 
		if point then
			point:StopParticles()
		end
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if MySelf == owner and not GAMEMODE.ThirdPerson then
		if self.Particle then
			self.Particle = nil
			owner:StopParticles()
		end
		if point then
			point:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		if point then
			point:StopParticles()
			//ParticleEffectAttach("firebolt2_stream",PATTACH_ABSORIGIN_FOLLOW,point,0)
		end
		
		ParticleEffectAttach("firebolt2",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
		self.WFlame = nil
	end
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() and (self:GetDTFloat(1) - CurTime() <= 0.15) and self:GetDTBool(0) then
		if not self.WFlame and point then
			ParticleEffectAttach("firebolt2_stream",PATTACH_ABSORIGIN_FOLLOW,point,0)
			self.WFlame = true
		end
	else
		if self.WFlame and point then
			point:StopParticles()
			self.WFlame = nil
		end
	end

end

function ENT:HandDraw(owner,reverse,point)
	//self.Emitter2:Draw()
	
	if point and not point.Particle then
		ParticleEffectAttach("v_firebolt2",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
		self.Flame = nil
		--point:EmitSound("ambient/fire/gascan_ignite1.wav",math.random(100,120),math.random(100,130))
	end
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() /*and (self:GetDTFloat(1) - CurTime() <= 0.15)*/ and self:GetDTBool(0) then
		if not self.Flame and point then
			//point:StopParticles()
			ParticleEffectAttach("v_firebolt2_stream",PATTACH_ABSORIGIN_FOLLOW,point,0)
			self.Flame = true
		end
	else
		if self.Flame and point then
			point:StopParticles()
			ParticleEffectAttach("v_firebolt2",PATTACH_ABSORIGIN_FOLLOW,point,0)
			self.Flame = nil
		end
	end
	
end
end





