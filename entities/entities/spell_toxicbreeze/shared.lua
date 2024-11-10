ENT.Name = "Toxic Breeze"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 40
ENT.Damage = 95

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	GAMEMODE:KilliconAddSpell("projectile_toxiccloud","toxicbreeze")
end

PrecacheParticleSystem( "v_toxicbreeze" )
PrecacheParticleSystem( "toxicbreeze" )
PrecacheParticleSystem( "toxicbreeze_projectile" )

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine(
		{
			start = self.EntOwner:GetShootPos(), 
			endpos = self.EntOwner:GetShootPos() + aimvec * 800, 
			filter = self.EntOwner:GetMeleeFilter()
		}
	)
	
	if trace.Hit and SERVER then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos)
	end


end

function ENT:CreateTrap(pos)
	
	local trap = ents.Create("projectile_toxiccloud")
	trap:SetOwner(self.EntOwner)
	trap:SetPos(pos+vector_up*2)
	trap.EntOwner = self.EntOwner
	trap:Spawn()
	--trap:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav",150,math.random(100,120))
	
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnThink()
	
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

function ENT:OnDraw()
	//if self:GetPos():Distance(EyePos()) > 1190 then return end
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
		ParticleEffectAttach("toxicbreeze",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)	
	
	if point and not point.Particle then
		ParticleEffectAttach("v_toxicbreeze",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end

end
end





