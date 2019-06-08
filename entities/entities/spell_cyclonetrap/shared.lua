ENT.Name = "Cyclone Trap"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 50
ENT.Damage = 50

ENT.CastGesture = ACT_GMOD_GESTURE_ITEM_DROP

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then 
	AddSpellIcon("projectile_cyclonetrap","cyclonetrap")
end

for i=1,3 do
	util.PrecacheSound("ambient/water/water_splash"..i..".wav")
end

PrecacheParticleSystem( "v_cyclonetrap" )
PrecacheParticleSystem( "cyclonetrap" )

local table = table
local pairs = pairs

if SERVER then
function ENT:OnInitialize()
	self.Traps = {}
end
end

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 800, filter = {self.EntOwner,GetHillEntity()}})
	
	if trace.Hit and trace.HitWorld and SERVER and trace.HitNormal.z > 0.5 then
		self:UseDefaultMana()
		self:CreateTrap(trace.HitPos)
	else
		self.EntOwner._efCantCast = CurTime() + 1
	end
	

end

function ENT:CreateTrap(pos)
	
	local count = #self.Traps
	
	if count >= 4 then
		local toremove = self.Traps[1]
		if toremove and IsValid(toremove) then
			toremove:Remove()
			self.Traps[1] = nil
			table.Resequence(self.Traps)
		end
	end
	
	local trap = ents.Create("projectile_cyclonetrap")
	--trap:SetOwner(self.EntOwner)
	trap:SetPos(pos+vector_up*5)
	trap:SetAngles(Angle(90,0,0))
	trap.EntOwner = self.EntOwner
	trap:SetDTEntity(0,self.Entity)
	trap:Spawn()
	trap:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav",150,math.random(100,120))
	
	table.insert(self.Traps,trap)
	
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))	
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
		ParticleEffectAttach("telekinesis",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
	/*
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	if LocalPlayer() == owner then return end
	
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Hand")
		
		self.WParticles = self.WParticles or {}
		
		if bone then
			local pos, ang = owner:GetBonePosition(bone)
			self.NextEmit = self.NextEmit or 0
		
			if self.NextEmit < CurTime() then 
			
				self.WParticles = {}
		
				for i=1, 11 do
					self.WParticles[i] = self.Emitter:Add("sprites/heatwave", pos )
				end
				
				self.NextEmit = CurTime() + 0.06
				
			end
		
			
			local radius = math.Rand(3,4)
			--self.NextEmit = CurTime() + 0.01
			for i=1, #self.WParticles do
				local rad = math.random(0,10)		
				local particle = self.WParticles[i] --self.Emitter:Add("sprites/heatwave", pos+ang:Forward()*3 +VectorRand()*1.4 )
				particle:SetPos(pos+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
				particle:SetDieTime(math.Rand(0.8, 1.1))
				particle:SetStartAlpha(125)
				particle:SetStartSize(math.Rand(1, 2.5))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(vector_up*math.Rand(3,6))
				particle:SetCollide(true)
				particle:SetAirResistance(12)
			end
		end
	*/
end

function ENT:HandDraw(owner,reverse,point)

	if point and not point.Particle then
		ParticleEffectAttach("v_telekinesis",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*
	local bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Left_Hand"}
	end

	self.HParticles = self.HParticles or {}
	
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				self.NextHEmit = self.NextHEmit or 0
				
				if self.NextHEmit < CurTime() then 
		
					self.HParticles = {}
					
					for i=1, 11 do
						self.HParticles[i] = self.Emitter2:Add("sprites/heatwave", pos )
					end
					
					self.NextHEmit = CurTime() + 0.06
					
				
				end
								
				local radius = math.Rand(1.5,2.1)
				for i=1, #self.HParticles do
					local rad = math.random(0,10)		
					local particle = self.HParticles[i] --self.Emitter:Add("sprites/heatwave", pos+ang:Forward()*3 +VectorRand()*1.4 )
					particle:SetPos(pos+ang:Right()*math.sin( CurTime()*5+math.rad( rad*i ) ) * radius+ang:Up()*math.cos( CurTime()*5+math.rad( rad*i ) ) * radius)
					particle:SetDieTime(math.Rand(0.8, 1.1))
					particle:SetStartAlpha(125)
					particle:SetStartSize(math.Rand(0.8, 1.2))
					particle:SetEndSize(0)
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetGravity(vector_up*math.Rand(3,6))
					particle:SetCollide(true)
					particle:SetAirResistance(12)
				end
				
			end
		end
	end
*/
end
end





