ENT.Name = "Gravity Well"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 90

ENT.CastGesture = ACT_SIGNAL_HALT

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	GAMEMODE:KilliconAddSpell("spell_gravitywell","gravitywell")
	RegisterParticleEffect( "gravitywell_effect" )
end


PrecacheParticleSystem( "v_gravitywell" )
PrecacheParticleSystem( "gravitywell" )
PrecacheParticleSystem( "gravitywell_effect" )

local table = table
local pairs = pairs

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine(
		{
			start = self.EntOwner:GetShootPos(), 
			endpos = self.EntOwner:GetShootPos() + aimvec * 500, 
			filter = self.EntOwner:GetMeleeFilter()
		}
	)
	
	if trace.Hit and SERVER then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos + (trace.HitNormal.z > 0.5 and vector_up*30 or vector_origin))
	else
		self.EntOwner._efCantCast = CurTime() + 1
	end
	

end

function ENT:CreateTrap(pos)
	
	for k,v in pairs(ents.FindByClass("prop_physics*")) do
		if v and IsValid(v) and v:GetPos():DistToSqr(pos) <= 129600 and TrueVisible(pos, v:NearestPoint(pos)) then
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				v:SetPhysicsAttacker(self.EntOwner)
				phys:SetVelocity((v:LocalToWorld(v:OBBCenter())-pos):GetNormal()*-1000) 
				v._Pushed = CurTime() + 2
				//v._LastAttacker = self.EntOwner
			end
		end
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(vector_origin)
	util.Effect("gravitywell_effect", effectdata,nil,true)
	
	sound.Play("ambient/machines/thumper_top.wav",pos,100,math.random(90,100))
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	//self.Emitter = ParticleEmitter(self:GetPos())
	//self.Emitter2 = ParticleEmitter(self:GetPos())
	//self.Emitter2:SetNoDraw()	
end

function ENT:OnThink()
	
end

function ENT:OnRemove()

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
		ParticleEffectAttach("gravitywell",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_gravitywell",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
end
end





