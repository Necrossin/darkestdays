ENT.Name = "Raise Undead"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 80
ENT.Damage = 88

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	AddSpellIcon("spell_meatbomb","meatbomb")
	AddSpellIcon("projectile_meatbomb","meatbomb")
end

OrbsTable = OrbsTable or {}

//models/props_borealis/borealis_door001a.mdl

PrecacheParticleSystem( "v_meatbomb" )
PrecacheParticleSystem( "meatbomb" )
local table = table
local pairs = pairs

local explode = Sound("ambient/explosions/explode_7.wav")

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	//local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 40, filter = self.EntOwner})
	
	
	
	//if trace.Hit and trace.HitWorld and SERVER and trace.HitNormal.z > 0.5 then
		//
	if SERVER then
		self:UseDefaultMana()
		self:CreateProjectile()
	end
	

end

function ENT:CreateProjectile()
	
	local trap = ents.Create("projectile_meatbomb")
	local v = self.EntOwner:GetShootPos()
	v = v + self.EntOwner:GetForward() * 8
	v = v + self.EntOwner:GetRight() * -3
	v = v + self.EntOwner:GetUp() * -3
	if IsValid(trap) then
		trap:SetPos(v)
		trap.EntOwner = self.EntOwner
		trap:SetOwner(self.EntOwner)
		trap:Spawn()
		
		local phys = trap:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(self.EntOwner:GetAimVector() * 350+vector_up*50)
		end
	end
	
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnThink()
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

function ENT:OnDraw()
	local owner = self.EntOwner
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
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
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("meatbomb",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_meatbomb",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end

end
end





