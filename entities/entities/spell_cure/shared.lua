ENT.Name = "Cure"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 70

PrecacheParticleSystem( "cure" )
PrecacheParticleSystem( "v_cure" )
PrecacheParticleSystem( "cure_projectile_small" )
PrecacheParticleSystem( "cure_projectile_big" )
PrecacheParticleSystem( "cure_projectile_big_red" )
PrecacheParticleSystem( "cure_projectile_big_blue" )

ENT.CastGesture = ACT_GMOD_GESTURE_ITEM_DROP

 
if CLIENT then
	//AddSpellIcon("spell_firebolt","firebolt")
	//AddSpellIcon("effect_afterburn","firebolt")
	//AddSpellIcon("projectile_firebolt","firebolt")
	//RegisterParticleEffectAttach( "burningplayer" )
end

if SERVER then
	AddCSLuaFile("shared.lua")
end

local ents = ents

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	if SERVER then
		self:UseDefaultMana()
		self:CreateProjectile()
	end
end

function ENT:CreateProjectile()
	
	local trap = ents.Create("projectile_cure")
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
			phys:ApplyForceCenter(self.EntOwner:GetAimVector() * 750)
		end
	end
	
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
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("cure",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)

	if point and not point.Particle then
		ParticleEffectAttach("v_cure",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*local bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Left_Hand"}
	end
	
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				local dlight = DynamicLight( vm:EntIndex() )
				if ( dlight ) then
					dlight.Pos = pos+ang:Forward()*2
					dlight.r = 50
					dlight.g = 255
					dlight.b = 50
					dlight.Brightness = 1
					dlight.Size = 20
					dlight.Decay = 20 * 5
					dlight.DieTime = CurTime() + 1
					dlight.Style = 0
				end
			end
		end
	end*/

end

end





