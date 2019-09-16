ENT.Name = "Murder of Crows"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 75
ENT.Damage = 6 * 1

ENT.CastGesture = ACT_SIGNAL_FORWARD

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("effect_murderofcrows","murderofcrows")
	AddSpellIcon("projectile_crow","murderofcrows")
end

PrecacheParticleSystem( "v_murderofcrows" )
PrecacheParticleSystem( "murderofcrows" )

util.PrecacheSound("npc/crow/hop1.wav")
util.PrecacheSound("npc/crow/hop2.wav")
util.PrecacheSound("npc/crow/flap2.wav")

if SERVER then
function ENT:OnInitialize()
	self.Crows = {}
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
	
	
end

function ENT:CreateProjectile()
	
	if self.Crows then
		for k, v in pairs( self.Crows ) do
			if v and v:IsValid() then
				v:Remove()
				self.Crows[ k ] = nil
			end
		end
	end
	
	for i=1, 6 do
		
		local crow = ents.Create("projectile_crow")
		if IsValid( crow ) then
			
			local pos = self.EntOwner:GetShootPos()
			
			crow:SetPos( pos + VectorRand() * 4 )
			crow:SetAngles( VectorRand():Angle() )
			crow.EntOwner = self.EntOwner
			crow:SetOwner(self.EntOwner)
			crow:Spawn()
			
			local phys = crow:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:ApplyForceCenter(VectorRand() * math.random(20,30))
			end
			
			self.Crows[ #self.Crows + 1 ] = crow
		end
		
		
	end
	
	
	/*local aimang = self.EntOwner:GetAimVector():Angle()	
		
	for i=1,6 do
		local aimvec = aimang
		aimvec.yaw = aimvec.yaw + math.Rand(-2, 2)
		aimvec.pitch = aimvec.pitch + math.Rand(-2, 2)
		aimvec = aimvec:Forward()
		local trap = ents.Create("projectile_crow")
		local v = self.EntOwner:GetShootPos()
		v = v + self.EntOwner:GetForward() * math.random(3,8)
		v = v + self.EntOwner:GetRight() * math.random(-2,2)
		v = v + self.EntOwner:GetUp() * math.random(-2,2)
		trap:SetPos(v)
		trap:SetAngles(aimvec:Angle())
		trap.EntOwner = self.EntOwner
		trap:SetOwner(self.EntOwner)
		trap:Spawn()
		
		local phys = trap:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			//phys:EnableGravity(false)
			//phys:SetVelocity((self.EntOwner:GetAimVector()) * 1300)
			//phys:SetVelocityInstantaneous(self.EntOwner:GetAimVector() * 400)
			phys:ApplyForceCenter(aimvec  * math.random(450,550))
		end
	end*/
	
	
end

if CLIENT then

function ENT:OnInitialize()

end

function ENT:OnThink()
	
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

end

function ENT:OnRemove()

	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

local mat_core = Material( "effects/redflare" )
local mat_side = Material( "effects/muzzleflash1" )


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
		ParticleEffectAttach("murderofcrows",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)

	
	if point and not point.Particle then
		ParticleEffectAttach("v_murderofcrows",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*
	local bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Left_Hand"}
	end
	
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			if bone then
				local bonematr = vm:GetBoneMatrix(bone)
				
				if bonematr then
					local pos, ang = bonematr:GetTranslation(), bonematr:GetAngles()
					
					local dlight = DynamicLight( vm:EntIndex() )
					if ( dlight ) then
						dlight.Pos = pos+ang:Forward()*2
						dlight.r = math.random(220,235)//math.random(30,45)
						dlight.g = 0
						dlight.b = 0
						dlight.Brightness = 1
						dlight.Size = 20
						dlight.Decay = 20 * 5
						dlight.DieTime = CurTime() + 1
						dlight.Style = 0
					end					
				end
			end
		end
	end
	
	
	
	if self.NextHEmit and self.NextHEmit > CurTime() then return end
	
	self.NextHEmit = CurTime() + 0.006
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				local particle = self.Emitter2:Add("effects/muzzleflash"..math.random(1,3), pos+ang:Forward()*2 +VectorRand()*2 )
				particle:SetPos(pos+ang:Forward() +VectorRand()*1.5)
				particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.3, 0.5))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(1.1, 1.7))
				particle:SetEndSize(math.Rand(0.3, 0.7))
				--particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(math.random(220,235),0,0)
				particle:SetGravity(VectorRand()*(math.sin(RealTime()*3)*5)+vector_up*math.random(20,45))
				particle:SetCollide(true)
				particle:SetAirResistance(2)	
					
			end
		end
	end*/
end
end





