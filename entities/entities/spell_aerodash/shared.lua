ENT.Name = "Aero Dash"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 30
ENT.Damage = 30

ENT.FullChargeTime = 1

ENT.CastGesture = ACT_GMOD_GESTURE_BOW

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	AddSpellIcon("spell_aerodash","aerodash")
end

util.PrecacheSound("ambient/machines/thumper_dust.wav")
util.PrecacheSound("npc/zombie/zombie_pound_door.wav")

PrecacheParticleSystem( "v_aerodash2" )
PrecacheParticleSystem( "aerodash2" )
PrecacheParticleSystem( "aerodash_effect" )

for i=1,3 do
	util.PrecacheSound("physics/glass/glass_sheet_break"..i..".wav")
end

local util = util
local math = math

function ENT:OnInitialize()
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
		self.ChargeSound = CreateSound( self, "weapons/physcannon/energy_sing_loop4.wav" ) //ambient/fire/fire_big_loop1.wav
	end
	//requires to hold down mouse button!
	self:SetDTBool(2,true)	
	-- power
	self:SetDTFloat(2,0)
end

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	if not self:GetDTBool(3) then
		self:StartCharging()
	end

end

function ENT:StartCharging()
	
	self:SetDTFloat( 2, CurTime() + self.FullChargeTime )
	self:SetDTBool( 3, true )
	
end

function ENT:IsCharging()
	return self:GetDTFloat( 2 ) >= CurTime()
end

function ENT:GetChargePower()
	
	--if !self:GetDTBool( 3 ) then return 0 end
	
	local delta = math.Clamp( 1 - ( self:GetDTFloat( 2 ) - CurTime() ) / self.FullChargeTime, 0, 1 )
	
	return delta
	
end

function ENT:GetManaCost()
	return self:GetChargePower() * self.Mana
end

function ENT:DoDash()
	
	self.EntOwner._efCantCast = CurTime() + 2
	
	self:SetDTBool(3,false)
	
	if CLIENT then
		if self.ChargeSound then
			self.ChargeSound:Stop()
		end
	end
	
	local pow = 1200
	
	if self.EntOwner:IsCarryingFlag() or GAMEMODE:GetGametype() == "ts" or self.EntOwner:GetActiveWeapon() and self.EntOwner:GetActiveWeapon().AerodashPenalty then
		pow = 600
	end
	
	pow = pow * self:GetChargePower()

	local vec = self.EntOwner:GetAngles():Forward()*pow
	
	vec.z = 140 * self:GetChargePower()
	
	if self:GetChargePower() >= 0.5 then
		self:SetDTFloat(1,CurTime()+1.2)
		self.EntOwner._WallJumpBonus = CurTime()+2
		--self.EntOwner:PlayGesture( ACT_GMOD_GESTURE_BOW )
	end
	
	if self:GetChargePower() >= 0.75 then
		if ValidEntity(self.EntOwner._efElectrocuted) then
			if SERVER then
				self.EntOwner._efElectrocuted:Remove()
			end
			self.EntOwner._efElectrocuted = nil
		end
		
		if ValidEntity(self.EntOwner._efAfterburn) then
			if SERVER then
				self.EntOwner._efAfterburn:Remove()
			end
			self.EntOwner._efAfterburn = nil
		end
		
		if ValidEntity(self.EntOwner._efFrozen) then
			if SERVER then
				self.EntOwner._efFrozen:Remove()
			end
			self.EntOwner._efFrozen = nil
		end
	end
	
	if SERVER then
		--self:UseDefaultMana()
		self:UseMana( self:GetManaCost() )
		self.EntOwner:EmitSound("ambient/machines/thumper_dust.wav",130,math.random(110,140))
	end

	self.EntOwner:SetGroundEntity(NULL)
	self.EntOwner:SetLocalVelocity(vec)

	
	
end

local trace = { mask = MASK_PLAYERSOLID }

function ENT:OnThink()
	
	if self:GetDTBool( 3 ) and ( !self.EntOwner:KeyDown( IN_ATTACK2 ) or !self.EntOwner:CanCast( self, self:GetManaCost() ) or self.EntOwner:IsSprinting() ) then --!self:IsCharging() or 
		self:DoDash()
	end
	
	if self:GetDTBool( 3 ) then
		if CLIENT then
			if self.ChargeSound then
				self.ChargeSound:PlayEx(1, 70 + 40 * ( self:GetChargePower() or 0 ))
			end
		end
	else
		if CLIENT then
			if self.ChargeSound then
				self.ChargeSound:Stop()
			end
		end
	end
	
	if SERVER then
	
		if self:GetDTFloat(1) >= CurTime() then
	
			local aimvec = self.EntOwner:GetAimVector()

			trace.start = self.EntOwner:GetShootPos()
			trace.endpos = self.EntOwner:GetShootPos() + aimvec * 16
			trace.mins = Vector(-8,-8,-14)
			trace.maxs = Vector(8,8,8)
			trace.filter = self.EntOwner
				
			trace = util.TraceHull(trace)
	
			if IsValid(trace.Entity) and trace.Entity:IsPlayer() and not self.EntOwner:IsTeammate(trace.Entity) then//trace.Entity:Team() ~= self.EntOwner:Team() then
				self:SetDTFloat(1,0)
				
				local damage = math.random(30,35)
				
				if ValidEntity(trace.Entity._efFrozen) then
					damage = math.random(90,100)
					trace.Entity:EmitSound("physics/glass/glass_sheet_break"..math.random(1,3)..".wav",math.random(90,110),math.random(90,110))
				end
				
				trace.Entity:EmitSound("npc/zombie/zombie_pound_door.wav",math.random(90,110),math.random(90,110))
				trace.Entity:SetGroundEntity(NULL)
				trace.Entity:SetLocalVelocity(self.EntOwner:GetAngles():Forward()*1000)
				if not trace.Entity:IsDefending() then
					local dmginfo = DamageInfo()
						dmginfo:SetDamagePosition( self.EntOwner:GetShootPos() )
						dmginfo:SetDamage( damage )
						dmginfo:SetAttacker( self.EntOwner )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageType( DMG_CRUSH )
						dmginfo:SetDamageForce( self.EntOwner:GetAngles():Forward()*500 )
					trace.Entity:TakeDamageInfo( dmginfo )
						
					--trace.Entity:TakeDamage(damage,self.EntOwner,self)	
				end				
			end
		end
	end

end

if CLIENT then

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
	if self.ChargeSound then
		self.ChargeSound:Stop()
	end
end

function ENT:OnDraw()

	local owner = self.EntOwner
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) > CurTime() and (MySelf ~= owner or GAMEMODE.ThirdPerson) then
		self.LastEmit = self.LastEmit or 0
		
		if self.LastEmit > CurTime() then return end
		
		self.LastEmit = self:GetDTFloat(1) 
		
		ParticleEffectAttach("aerodash_effect",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		
	end	
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("aerodash2",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)
	
	
	if point and not point.Particle then
		ParticleEffectAttach("v_aerodash2",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
end
end





