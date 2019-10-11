ENT.Name = "Scorn"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 90
ENT.Damage = 30

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("projectile_scorn","scorn")
end

PrecacheParticleSystem( "v_scorn2" )
PrecacheParticleSystem( "scorn2" )


local table = table
local pairs = pairs

if SERVER then
function ENT:OnInitialize()
	--self.Traps = {}
end
end

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	if SERVER then
		self:UseDefaultMana()
		self:CreateProjectile()
	end
	
	/*if trace.Hit and trace.HitWorld and not trace.HitSky and SERVER and trace.HitNormal.z < -0.5 then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos)
	else
		self.EntOwner._efCantCast = CurTime() + 1
	end*/
	

end

function ENT:CreateProjectile()
	
	local trap = ents.Create("projectile_scorn")
	local v = self.EntOwner:GetShootPos()
	v = v + self.EntOwner:GetForward() * 8
	v = v + self.EntOwner:GetRight() * -3
	v = v + self.EntOwner:GetUp() * -3
	trap:SetPos(v)
	--trap:SetAngles(Angle(90,0,0))
	--trap:SetOwner(self.EntOwner)
	trap.EntOwner = self.EntOwner
	--trap:SetDTEntity(0,self.Entity)
	trap:Spawn()
	
	local phys = trap:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(false)
		phys:SetVelocity((self.EntOwner:GetAimVector()) * 600)
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
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("scorn2",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_scorn2",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end

end
end





