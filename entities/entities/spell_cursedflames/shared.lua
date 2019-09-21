ENT.Name = "Cursed Flames"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 50
ENT.Damage = 15

ENT.CastGesture = ACT_SIGNAL_FORWARD

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("projectile_cursedflames","cursedflames")
end

PrecacheParticleSystem( "v_cursedflames" )
PrecacheParticleSystem( "cursedflames" )
PrecacheParticleSystem( "cursedflames_projectile" )


function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	/*local distance = 460
	local aimvec = self.EntOwner:GetAimVector()
	
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * distance, filter = self.EntOwner})
	
	local tr = {}
	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * distance
	tr.mins = Vector(-22,-22,-14)
	tr.maxs = Vector(22,22,14)
	tr.filter = self.EntOwner
	
	tr = util.TraceHull(tr)
	
	if tr.Hit and ValidEntity(tr.Entity) and not tr.Entity:IsWorld() then
		trace = tr
	end
	
	local pos = trace.HitPos
	*/
	if SERVER then
		//self:UseDefaultMana()
		
		self:CreateProjectile()
		
		--WorldSound("npc/waste_scanner/grenade_fire.wav",trace.HitPos,105,math.random(100,130))	
		/*local gib = 1
		
		if ValidEntity(trace.Entity) and not trace.Entity:IsWorld() and not (trace.Entity:IsPlayer() and trace.Entity:Team() == self.EntOwner:Team()) then
			
			
			if trace.Entity:IsPlayer() and !trace.Entity:IsCrow() then	
				local crows = trace.Entity:SetEffect("murderofcrows")	
				crows.EntAttacker = self.EntOwner	
				gib	= 0			
			end
			
		end
		
		
		
		local e = EffectData()
		e:SetOrigin(pos)
		e:SetEntity(self.EntOwner)
		e:SetMagnitude(gib)
		util.Effect("crows_spawn",e,true,true)
		*/
	end
	
	
end

function ENT:CreateProjectile()
	
	local count = 0
	for k,v in ipairs(ents.FindByClass("projectile_cursedflames")) do
		if IsValid(v) and v.EntOwner == self.EntOwner then
			count = count + 1
		end
	end
	
	if count > 4 then return end
	
	self:UseDefaultMana()
	
	local aimang = self.EntOwner:GetAimVector():Angle()
		
	for i=1, 4 do
		local aimvec = aimang
		aimvec.yaw = aimvec.yaw + math.Rand(-5, 5)
		aimvec.pitch = aimvec.pitch + math.Rand(-2, 2)
		aimvec = aimvec:Forward()
		local trap = ents.Create("projectile_cursedflames")
		if IsValid(trap) then
			local v = self.EntOwner:GetShootPos()
			v = v + self.EntOwner:GetForward() * math.random(2,4)
			v = v + self.EntOwner:GetRight() * math.random(-2,2)
			v = v + self.EntOwner:GetUp() * math.random(-4,3)
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
				phys:ApplyForceCenter(aimvec  * 450)
			end
		end
	end
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
		ParticleEffectAttach("cursedflames",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
end

function ENT:HandDraw(owner,reverse,point)
	//self.Emitter2:Draw()
	
	if point and not point.Particle then
		ParticleEffectAttach("v_cursedflames",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	local bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
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





