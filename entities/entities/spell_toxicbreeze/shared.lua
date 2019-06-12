ENT.Name = "Toxic Breeze"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 40
ENT.Damage = 95

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("projectile_toxiccloud","toxicbreeze")
end

PrecacheParticleSystem( "v_toxicbreeze" )
PrecacheParticleSystem( "toxicbreeze" )
PrecacheParticleSystem( "toxicbreeze_projectile" )

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 800, filter = {self.EntOwner, GetHillEntity()}})
	
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
	
	/*if owner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	if LocalPlayer() == owner then return end
	
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Forearm")
		
		self.WParticles = self.WParticles or {}
		
		if bone then
			local pos, ang = owner:GetBonePosition(bone)
			self.NextEmit = self.NextEmit or 0
		
			if self.NextEmit < CurTime() then 
			
				for num=0,6 do
					self.WParticles[num] = {}
			
					for i=1, 7 do
						self.WParticles[num][i] = self.Emitter:Add("particles/smokey", pos )
					end
					
				end
				self.NextEmit = CurTime() + 0.06
				
			end
			for num=0,6 do
				--print("Num "..num)
				self.WParticles[num] = self.WParticles[num] or {}
				
				local radius = math.Rand(1.6,2.4)
				--self.NextEmit = CurTime() + 0.01
				for i=1, #self.WParticles[num] do
					local rad = math.random(-10,10)+15*num		
					local particle = self.WParticles[num][i] --self.Emitter:Add("sprites/heatwave", pos+ang:Forward()*3 +VectorRand()*1.4 )
					particle:SetPos(pos+ang:Forward()*(3+num*1.5)+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
					particle:SetDieTime(math.Rand(0.8, 1.1))
					particle:SetVelocity(owner:GetVelocity())
					particle:SetStartAlpha(155)
					particle:SetStartSize(math.Rand(1, 2.5))
					particle:SetEndSize(0)
					local rand = math.random(50,100)
					particle:SetColor(rand,200,rand)
					--particle:SetRoll(math.Rand(0, 360))
					--particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetGravity(vector_up*math.Rand(3,6))
					particle:SetCollide(true)
					particle:SetLighting(true)
					particle:SetAirResistance(12)
				end
			end
		end
	*/
end

function ENT:HandDraw(owner,reverse,point)	
	
	if point and not point.Particle then
		ParticleEffectAttach("v_toxicbreeze",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*
	local bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Right_Arm"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Forearm","v_weapon.Left_Arm"}
	end

	self.HParticles = self.HParticles or {}
	local firstbone = false
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			self.HParticles = self.HParticles or {}
		
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				if !firstbone then
					local dlight = DynamicLight( vm:EntIndex() )
					if ( dlight ) then
						dlight.Pos = pos+ang:Forward()*2
						dlight.r = math.random(30,45)
						dlight.g = 200
						dlight.b = math.random(30,45)
						dlight.Brightness = 1
						dlight.Size = 20
						dlight.Decay = 20 * 5
						dlight.DieTime = CurTime() + 1
						dlight.Style = 0
					end
					firstbone = true
				end
				
				self.HNextEmit = self.HNextEmit or 0
			
				if self.HNextEmit < CurTime() then 
				
					for num=0,6 do
						self.HParticles[num] = {}
				
						for i=1, 4 do
							self.HParticles[num][i] = self.Emitter2:Add("particles/smokey", pos )
						end
						
					end
					self.HNextEmit = CurTime() + 0.07
					
				end
				for num=0,6 do
					--print("Num "..num)
					self.HParticles[num] = self.HParticles[num] or {}
					
					local radius = math.Rand(0.5,1.5)
					--self.NextEmit = CurTime() + 0.01
					for i=1, #self.HParticles[num] do
						local rad = math.random(-10,10)+15*num		
						local particle = self.HParticles[num][i] --self.Emitter:Add("sprites/heatwave", pos+ang:Forward()*3 +VectorRand()*1.4 )
						particle:SetPos(pos+ang:Forward()*1+ang:Forward()*(num*1.5)+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
						particle:SetDieTime(math.Rand(0.8, 1.1))
						particle:SetVelocity(owner:GetVelocity())
						particle:SetStartAlpha(155)
						particle:SetStartSize(math.Rand(0.8, 1.5))
						particle:SetEndSize(0)
						local rand = math.random(50,100)
						particle:SetColor(rand,200,rand)
						--particle:SetRoll(math.Rand(0, 360))
						--particle:SetRollDelta(math.Rand(-1, 1))
						particle:SetGravity(vector_up*math.Rand(3,6))
						particle:SetCollide(true)
						particle:SetLighting(true)
						particle:SetAirResistance(12)
					end
				end
			end
		end
	end
*/
end
end





