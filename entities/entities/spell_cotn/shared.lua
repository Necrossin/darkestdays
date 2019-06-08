ENT.Name = "Curse of the Night"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 60

local table = table
local util = util
local math = math

if SERVER then
	AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "v_cotn3" )
PrecacheParticleSystem( "cotn3" )
PrecacheParticleSystem( "cotn2_effect" )


function ENT:OnInitialize()	
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end
end

function ENT:Cast()
	if !self.EntOwner:CanCast(self,amount) then 
		self.EntOwner._efCantCast = CurTime() + 1
		return 
	end
	if SERVER then
		self:UseDefaultMana()
		self.EntOwner:SetEffect("cotn")
	end
end

if CLIENT then

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
	
	if (MySelf == owner and not GAMEMODE.ThirdPerson) or owner:IsCrow() then
		if self.Particle then 
			self.Particle = nil
			owner:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("cotn3",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_cotn3",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
end
end





