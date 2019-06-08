ENT.Name = "Ghosting"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 3

if SERVER then
	AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "v_ghosting" )
PrecacheParticleSystem( "ghosting" )
PrecacheParticleSystem( "ghosting_effect" )

util.PrecacheSound("ambient/levels/citadel/portal_beam_shoot5.wav")
local tp = Sound("physics/body/body_medium_break2.wav")

function ENT:OnInitialize()
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end

	self:SetDTBool(0,false)
	//requires to hold down mouse button!
	self:SetDTBool(2,true)
	
	self:SetDTBool(3,false)
	
	//shows that we are casting
	self:SetDTFloat(1,0)
end

function ENT:DoCast()
	
	self:SetDTFloat(1,CurTime()+0.12)

end

function ENT:Cast()
	
	self:DoCast()
		
end

function ENT:DoGhosting(bl)
	if self:GetDTBool(0) == bl then return end
	self:SetDTBool(0,bl)
	if SERVER then
		if self.EntOwner:GetPerk("houdini") then
			self:SetDTBool(3,bl)
		end
	end
	self.EntOwner._efGhosting = bl
	--self.EntOwner._GhostingEnt = bl and self.Entity or nil
	self.EntOwner:SetDTEntity(0,bl and self.Entity or nil)
	if SERVER then self.EntOwner:DrawWorldModel(!bl) end
	self.EntOwner:SetRenderMode(bl and RENDERMODE_NONE or RENDERMODE_NORMAL)
	if SERVER then 
		local vol = 100
		//if self.EntOwner:GetPerk("houdini") then
		//	vol = 50
		//end
		WorldSound(tp,self:GetPos(),vol,math.random(110,140)) 
	end
	self:SetDTFloat(0,CurTime()+0.1)
end

function ENT:OnThink()
	
	if CLIENT then

	end
	--if SERVER then
	if self:GetDTBool(0) then
		self.EntOwner:SetRenderMode(RENDERMODE_NONE)
	end
	
	self.NextGhosting = self.NextGhosting or 0
	
	if self:GetDTFloat(1) > CurTime() and self.EntOwner:CanCast(self) then
		if !self:GetDTBool(0) then
			if self.NextGhosting < CurTime() then
				self:DoGhosting(true)
				self.NextGhosting = CurTime() + 2
			end
		end
	else
		if self:GetDTBool(0) then
			self:DoGhosting(false)
			if !self.EntOwner:CanCast(self) then
				self.EntOwner._efCantCast = CurTime() + 3
			end
		end
	end
	
	
	self.NextTick = self.NextTick or 0
	
	if self:GetDTBool(0) then
		
		if self.EntOwner:GetCurSpellInd() ~= self:GetDTInt(0) then
			self:DoGhosting(false)
		end
		
		//if self.EntOwner:CanCast(self) then 
			if self.NextTick < CurTime() then
				if SERVER then self:UseDefaultMana() end	
				self.NextTick = CurTime() + (self:GetDTBool(3) and 0.375 or 0.125)
			end
		//else
			//self:DoGhosting(false)
			//self.EntOwner._efCantCast = CurTime() + 3
		//end
	end

	
end


function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.EntOwner) then
			self.EntOwner:StopParticles()
		end
	end
	if ValidEntity(self.EntOwner) then
		self.EntOwner:SetRenderMode(RENDERMODE_NORMAL)
		self.EntOwner._efGhosting = false
		self.EntOwner:SetDTEntity(0,nil)
		if SERVER then self.EntOwner:DrawWorldModel(true) end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

if CLIENT then
function ENT:OnDraw()
	
	local owner = self.EntOwner
	
	if self:GetDTFloat(0) and self:GetDTFloat(0) > CurTime() then
		self.LastEmit = self.LastEmit or 0
		
		if self.LastEmit > CurTime() then return end
		
		self.LastEmit = self:GetDTFloat(0) 
		
		ParticleEffectAttach("ghosting_effect",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("chest") or owner:LookupAttachment("anim_attachment_LH"))//owner:LookupAttachment("anim_attachment_LH")
	end
	
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) or self:GetDTBool(0) then
		if self.Particle then
			self.Particle = nil
			if self:GetDTBool(0) or MySelf == owner and not GAMEMODE.ThirdPerson then
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
		if not self:GetDTBool(0) then
			ParticleEffectAttach("ghosting",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
			self.Particle = true
		end
	end
	
end

function ENT:HandDraw(owner,reverse,point)

	
	if point and not point.Particle then
		ParticleEffectAttach("v_ghosting",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
end
end





