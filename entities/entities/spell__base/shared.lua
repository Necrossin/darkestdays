ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IsSpell = true

ENT.Mana = 5

if SERVER then
	AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	if SERVER then
		self.Entity:DrawShadow(false)
	end
	
	self:OnInitialize()
	
end

if SERVER then
function ENT:UseMana(am)
	if self.EntOwner:GetPerk("manasaver") then
		local newam = math.Clamp(math.Round(am*0.85),2,am)
		am = newam
	end
	self.EntOwner:SetMana(math.Clamp(self.EntOwner:GetMana()-am,0,self.EntOwner:GetMana()))
end

function ENT:UseDefaultMana()
	self:UseMana(self.Mana or 0)
end
end

function ENT:CanCast()
	return self.EntOwner:GetMana() >= self.Mana
end

function ENT:OnInitialize()
end

function ENT:SetSpellIndex(n)
	self:SetDTInt(0,n)
end

function ENT:GetSpellIndex()
	self:GetDTInt(0)
end


function ENT:OnRemove()
end 

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		--self:SetParent(self.EntOwner)
	end
	
	self:OnThink()
	
	self:NextThink( CurTime() )
	return true
	
end

function ENT:Cast()
	
end

function ENT:OnThink()
end


if CLIENT then
function ENT:Draw()
	if IsValid(self:GetOwner()) and self:GetOwner():IsThug() then 
		if self.Particle then
			self.Particle = nil
			self:GetOwner():StopParticles()
		end
		return 
	end
	
	if self:GetOwner():IsGhosting() then
		if self.Particle then
			self.Particle = nil
			self:GetOwner():StopParticles()
		end
		return
	end
	
	if MySelf:EyePos():DistToSqr( self:GetOwner():GetPos() ) > 360000 then
		if self.Particle then
			self.Particle = nil
			self:GetOwner():StopParticles()
		end
		return
	end
	
	self:OnDraw()
end
end

function ENT:OnDraw()

end

if SERVER then
--	function ENT:UpdateTransmitState()
	--	return TRANSMIT_PVS
--	end
end


