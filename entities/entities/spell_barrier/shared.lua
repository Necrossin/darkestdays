ENT.Name = "Barrier"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 50

ENT.CastGesture = ACT_GMOD_GESTURE_ITEM_GIVE

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	//AddSpellIcon("projectile_cyclonetrap","cyclonetrap")
end

//models/props_borealis/borealis_door001a.mdl

PrecacheParticleSystem( "v_barrier" )
PrecacheParticleSystem( "barrier" )

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
			endpos = self.EntOwner:GetShootPos() + aimvec * 40, 
			filter = self.EntOwner:GetMeleeFilter()
		}
	)
	
	//if trace.Hit and trace.HitWorld and SERVER and trace.HitNormal.z > 0.5 then
		//
	if SERVER then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos-aimvec:Angle():Up()*10,aimvec)
	end
	//else
		//self.EntOwner._efCantCast = CurTime() + 1
	//end
	

end

function ENT:CreateTrap(pos,aim)

	local t = self.EntOwner:Team() or TEAM_FFA

	local trap = ents.Create("projectile_barrier")

	trap:SetPos(pos+vector_up*2)
	trap:SetAngles(self.EntOwner:EyeAngles())
	trap.EntOwner = self.EntOwner
	trap:SetDTEntity(0,self.Entity)
	trap:SetOwner(self.EntOwner)
	trap.Team = function() return t end
	trap:Spawn()
	
	local trap = ents.Create("projectile_barrier")

	local ang = self.EntOwner:EyeAngles()
	ang:RotateAroundAxis( aim:Angle():Up(), -45 )
	trap:SetPos(pos+vector_up*2+aim:Angle():Right()*40-aim:Angle():Forward()*20)
	trap:SetAngles(ang)
	trap.EntOwner = self.EntOwner
	trap:SetDTEntity(0,self.Entity)
	trap:SetOwner(self.EntOwner)
	
	trap.Team = function() return t end
	trap:Spawn()
	
	local trap = ents.Create("projectile_barrier")

	local ang = self.EntOwner:EyeAngles()
	ang:RotateAroundAxis( aim:Angle():Up(), 45 )
	trap:SetPos(pos+vector_up*2-aim:Angle():Right()*40-aim:Angle():Forward()*20)
	trap:SetAngles(ang)
	trap.EntOwner = self.EntOwner
	trap:SetDTEntity(0,self.Entity)
	trap:SetOwner(self.EntOwner)
	trap.Team = function() return t end
	trap:Spawn()
	
	//trap:SetParent( self.EntOwner )
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
	
	--if self:GetPos():Distance(EyePos()) > 1190 then return end
	
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
		ParticleEffectAttach("barrier",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_barrier",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end

end
end





