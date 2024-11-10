ENT.Name = "Winter Blast"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 45
ENT.Damage = 7

ENT.CastGesture = ACT_SIGNAL_FORWARD

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	GAMEMODE:KilliconAddSpell("spell_winterblast","winterblast")
	GAMEMODE:KilliconAddSpell("projectile_winterblast","winterblast")
end

PrecacheParticleSystem( "v_winterblast" )
PrecacheParticleSystem( "winterblast" )


util.PrecacheSound("npc/waste_scanner/grenade_fire.wav")

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	/*local distance = 700
	local aimvec = self.EntOwner:GetAimVector()
	
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * distance, filter = self.EntOwner})*/
	/*
	local tr = {}
	local offset = self.EntOwner:GetAimVector():Angle():Right()*8
	tr[1] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * distance, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Right()*-8
	tr[2] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * distance, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Up()*8
	tr[3] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * distance, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Up()*-8
	tr[4] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * distance, filter = self.EntOwner})
	
	for i=1,4 do
		if tr[i].Hit and ValidEntity(tr[i].Entity) and not tr[i].Entity:IsWorld() then
			trace = tr[i]
			break
		end
	end*/
	/*local tr = {}
	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * distance
	tr.mins = Vector(-22,-22,-14)
	tr.maxs = Vector(22,22,14)
	tr.filter = self.EntOwner
	
	tr = util.TraceHull(tr)
	
	if tr.Hit and ValidEntity(tr.Entity) and not tr.Entity:IsWorld() then
		trace = tr
	end
	*/
	if SERVER then
		self:UseDefaultMana()
		self:CreateProjectile()
		//WorldSound("npc/waste_scanner/grenade_fire.wav",trace.HitPos,105,math.random(100,130))
		
		/*if ValidEntity(trace.Entity) and trace.Entity:GetClass() == "projectile_cyclonetrap" and trace.Entity:Team() == self.EntOwner:Team() and not (trace.Entity:GetDTBool(0) or trace.Entity:GetDTBool(1)) then
			trace.Entity:SetDTBool(2,true)
			return 
		end
		
		
		
		if ValidEntity(trace.Entity) and not trace.Entity:IsWorld() and not (trace.Entity:IsPlayer() and trace.Entity:Team() == self.EntOwner:Team()) then
			
			local Dmg = DamageInfo()
			Dmg:SetAttacker(self.EntOwner)
			Dmg:SetInflictor(self.Entity)
			Dmg:SetDamage(math.random(5,10))
			Dmg:SetDamageType(DMG_PARALYZE)
			Dmg:SetDamagePosition(trace.HitPos)	
			
			if trace.Entity:IsPlayer() then	
				trace.Entity:SetEffect("frozen")
				trace.Entity:TakeDamageInfo(Dmg)				
				
				if ValidEntity(self.EntOwner) and self.EntOwner:IsPlayer() then
					if self.EntOwner:GetPerk("elementalist") then
						self.EntOwner:SetMana(self.EntOwner:GetMana()+math.random(9,12),0,self.EntOwner:GetMaxMana())
					end
				end
				
			end
			
		end
		
		local e = EffectData()
		e:SetOrigin(trace.HitPos)
		util.Effect("snow_explosion",e,true,true)
		*/
	end
	
	
end

function ENT:CreateProjectile()
	
	--WorldSound("npc/waste_scanner/grenade_fire.wav",self.EntOwner:GetShootPos()+self.EntOwner:GetForward() * 8,70,math.random(170,180))
	self:EmitSound("npc/waste_scanner/grenade_fire.wav",70,math.random(185,200))
	
	for i=1, 3 do
		local trap = ents.Create("projectile_winterblast")
		if IsValid(trap) then
			local v = self.EntOwner:GetShootPos()
			v = v + self.EntOwner:GetForward() * 8
			v = v + self.EntOwner:GetRight() * math.Rand(-1,-1)
			v = v + self.EntOwner:GetUp() * math.Rand(-1,-1)
			trap:SetPos(v)
			trap.EntOwner = self.EntOwner
			trap:SetOwner(self.EntOwner)
			trap:Spawn()
			
			local phys = trap:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				//phys:EnableGravity(false)
				phys:ApplyForceCenter(self.EntOwner:GetAimVector() * 600 + VectorRand() * 10 * i + vector_up*math.random(100,200))//SetVelocity((self.EntOwner:GetAimVector()) * 2200)
			end
		end
	end
	
end

if CLIENT then

function ENT:OnInitialize()
	//self.Emitter = ParticleEmitter(self:GetPos())
	//self.Emitter2 = ParticleEmitter(self:GetPos())
	//self.Emitter2:SetNoDraw()
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
		ParticleEffectAttach("winterblast",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
	/*if LocalPlayer() == owner then return end
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	local sprites = {"particle/smokesprites0001","particle/smokesprites0002","particle/smokesprites0003",
	"particle/smokesprites0004","particle/smokesprites000","particle/smokesprites0727","particle/smokesprites0925"}
	
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Forearm")
		
		self.WParticles = self.WParticles or {}
		
		self.NextEmit = self.NextEmit or 0
		
		if bone then
		
			local pos, ang = owner:GetBonePosition(bone)
			if self.NextEmit < CurTime() then 
				
				self.WParticles = {}
				
			
				for i=1, math.random(2,3) do
					local spawnpos = pos+ang:Right()*math.sin( CurTime()*5+math.rad( math.random(0,360) ) ) * 2+ang:Up()*math.cos( CurTime()*5+math.rad( math.random(0,360) ) ) * 2
					self.WParticles[i] = self.Emitter:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", spawnpos+ang:Forward()*math.random(0,9) )
				end
					
				self.NextEmit = CurTime() + 0.011
					
			end
		
			
			--self.NextEmit = CurTime() + 0.0001
			for i=1, #self.WParticles do		
				//local spawnpos = pos+ang:Right()*math.sin( CurTime()*5+math.rad( math.random(0,360) ) ) * 2+ang:Up()*math.cos( CurTime()*5+math.rad( math.random(0,360) ) ) * 2			
				local particle = self.WParticles[i]--self.Emitter:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", spawnpos+ang:Forward()*math.random(0,9) )//
				particle:SetDieTime(math.Rand(0.8, 1.2))
				particle:SetVelocity(owner:GetVelocity())
				particle:SetStartAlpha(250)
				particle:SetStartSize(math.Rand(1, 2))
				local rand = math.random(130,245)
				particle:SetColor(rand,rand,255)
				particle:SetEndSize(math.Rand(1, 2))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(ang:Forward()*math.random(10,26)+vector_up*math.Rand(0,3))
				particle:SetCollide(true)
				particle:SetAirResistance(12)
				--particle:SetThinkFunction = function(self,)self.ParticleThink)
			end
		end
	*/
end

function ENT:HandDraw(owner,reverse,point)
	
	
	if point and not point.Particle then
		ParticleEffectAttach("v_winterblast",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*
	local bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Right_Arm"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Left_Arm"}
	end
	
	--if self.NextHEmit and self.NextHEmit > CurTime() then return end
	
	--self.NextHEmit = CurTime() + 0.0001
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				self.NextHEmit = self.NextHEmit or 0
				
				if self.NextHEmit < CurTime() then 
		
					self.HParticles = {}
					
					for i=1, math.random(2,3) do
						local spawnpos = pos+ang:Right()*math.sin( CurTime()*5+math.rad( math.random(0,360) ) ) * 2+ang:Up()*math.cos( CurTime()*5+math.rad( math.random(0,360) ) ) * 2			
						self.HParticles[i] = self.Emitter2:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", spawnpos+ang:Forward()*math.random(0,9) )//
					end
					
					self.NextHEmit = CurTime() + 0.011
					
				
				end
			
			
				
				//local spawnpos = pos+ang:Right()*math.sin( CurTime()*5+math.rad( math.random(0,360) ) ) * 2+ang:Up()*math.cos( CurTime()*5+math.rad( math.random(0,360) ) ) * 2			
				//local particle = self.Emitter2:Add(math.random(1,2) == 1 and "particle/smokesprites_000"..math.random(1,9).."" or "particle/smokesprites_00"..math.random(10,16).."", spawnpos+ang:Forward()*math.random(0,9) )//
				for i=1, #self.HParticles do
					local particle = self.HParticles[i]
					particle:SetDieTime(math.Rand(0.8, 1.2))
					particle:SetStartAlpha(250)
					particle:SetStartSize(math.Rand(1, 2))
					local rand = math.random(130,245)
					particle:SetColor(rand,rand,255)
					particle:SetEndSize(math.Rand(1, 2))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetGravity(ang:Forward()*math.random(10,26)+vector_up*math.Rand(0,3))
					particle:SetCollide(true)
					particle:SetAirResistance(12)
					particle:SetVelocity(owner:GetVelocity())
					--particle:SetThinkFunction(self.ParticleThink)
				end
			end
		end
	end
*/
end
end





