ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end


//util.PrecacheSound("ambient/energy/electric_loop.wav")
util.PrecacheModel("models/crow.mdl")

for i=1,2 do
	util.PrecacheSound("npc/crow/die"..i..".wav")
end

for i=1,4 do
	util.PrecacheSound("npc/crow/idle"..i..".wav")
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	self.EntOwner._efCOTN = self.Entity
	
	self.EntOwner:SetHull(Vector(-16,-16, 0), Vector(16,16,8))
	self.EntOwner:SetViewOffset(Vector(0,0,8))
	--self.EntOwner:SetHullDuck(HULL_PLAYER[1], Vector(HULL_PLAYER[3].x,HULL_PLAYER[3].y,HULL_PLAYER[3].z*tbl.Scale))
	
	self:SetModel( "models/crow.mdl" )
	self:AddEffects( EF_BONEMERGE )
	
	if SERVER then
		self.Entity:DrawShadow(false)

		self._OldModel = self.EntOwner:GetModel()
		self.EntOwner:SetModel("models/crow.mdl")
		
		if self.EntOwner:FlashlightIsOn() then
			self.EntOwner:Flashlight(false)
		end
		
		self._OldSpeed = self.EntOwner._DefaultSpeed
		--GAMEMODE:SetPlayerSpeed( self.EntOwner, 70, 70 )
		//self.EntOwner:SetTotalSpeed(70)
		self.FlySound = CreateSound( self.EntOwner, "NPC_Crow.Flap" )
		
		self:EmitSound("npc/crow/die"..math.random(1,2)..".wav",120,math.random(80,100))
	end
	
	if CLIENT then
	--	self.Emitter = ParticleEmitter(self:GetPos())
		if IsValid( self.Entity:GetOwner() ) then
			hook.Run( "PlayerTransparencyChanged", self.Entity:GetOwner(), 0 )
		end
	end
	
	self.DieTime = CurTime() + (GAMEMODE:GetGametype() == "ts" and 3 or 6)//self:GetDTFloat(0) or 
	self:SetDTFloat(0,self.DieTime)
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		if SERVER then
			self.EntOwner:SetModel(self._OldModel)
			--GAMEMODE:SetPlayerSpeed( self.EntOwner, self._OldSpeed, self._OldSpeed )
			//self.EntOwner:SetTotalSpeed(self._OldSpeed,self._OldSpeed+(self.EntOwner._DefaultRunSpeedBonus or PLAYER_DEFAULT_RUNSPEED_BONUS))
			if self.FlySound then
				self.FlySound:Stop()
			end
			self:EmitSound("npc/crow/die"..math.random(1,2)..".wav",120,math.random(80,100))
			self.EntOwner:SetPos(self.EntOwner:GetPos()+vector_up*4)
		end
		self.EntOwner:ResetHull()
		self.EntOwner:SetViewOffset(Vector(0, 0, 64))
		self.EntOwner._efCOTN = nil
		if SERVER then
			self:CheckWorld()
			if self.EntOwner:Alive() then
				self.EntOwner._COTNAch = CurTime() + 5
			end
		end
	end
	if CLIENT then
		--if self.Emitter then
		--	self.Emitter:Finish()
		--end
		if IsValid( self.Entity:GetOwner() ) then
			hook.Run( "PlayerTransparencyChanged", self.Entity:GetOwner(), 1 )
		end
	end
end

function ENT:CheckWorld()
	
	if IsValid(self.EntOwner) and self.EntOwner:Alive() then
		local hull = {}
		hull.start = self.EntOwner:GetPos()+Vector(0,0,2)
		hull.endpos = self.EntOwner:GetPos()+Vector(0,0,2)
		hull.mins = Vector(-18,-18,0)
		hull.maxs = Vector(18,18,70)
		hull.filter = self.EntOwner
		hull.mask = MASK_PLAYERSOLID//_BRUSHONLY//+MASK_PLAYERSOLID
		
		hull = util.TraceHull(hull)
		
		if hull.Hit then
			self.EntOwner:TakeDamage(9999,self.EntOwner,self)
		end
		
	end
	
end

ENT.NextIdle = 0
function ENT:Think()
	if CLIENT then
		if self.Emitter then
			self.Emitter:SetPos(self:GetPos())
		end
	end

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		if self.EntOwner:KeyDown(IN_ATTACK) then
			local wep = self.EntOwner:GetActiveWeapon()
			if IsValid(wep) then
				wep:SetNextPrimaryFire(CurTime() + 1)
			end
			self:Remove()
			return
		end
		
		self.EntOwner._NextManaRegen = CurTime() + 1
		
		--local vel = Vector(0,0,0)
		--local push = false
		--local flying = false
		
		if self.NextIdle < CurTime() then
			self.NextIdle = CurTime() + math. random(3,8)
			self.EntOwner:EmitSound("npc/crow/idle"..math.random(1,4)..".wav")
		end
		
		/*if self.EntOwner:OnGround() then
			if self.EntOwner:KeyDown(IN_JUMP) then
				self.EntOwner:SetLocalVelocity(Vector(0,0,190))
			end
			self.FlySound:Stop()
			if flying then
				flying = false
			end
		else
			if not passenger then
				if not flying then
					flying = true
					self.FlySound:Play();
				end
				
				if self.EntOwner:KeyDown(IN_FORWARD) then
					vel = self.EntOwner:GetAimVector()*380
					push = true
				end
				if self.EntOwner:KeyDown(IN_JUMP) then
					vel.z = vel.z + 130
					push = true
				end
				if push then
					self.EntOwner:SetLocalVelocity(vel)
				end
			end
		end*/
		//self.EntOwner:SetLocalVelocity(vector_origin)
		self:NextThink(CurTime())
	end
	
end

function ENT:Move( mv )
	
	local vel = Vector(0,0,0)
	local push = false
	local flying = false
	
	mv:SetMaxSpeed( 70 )
	mv:SetMaxClientSpeed( 70 )
	
	if self.EntOwner:OnGround() then
		if self.EntOwner:KeyDown(IN_JUMP) then
			mv:SetVelocity( vector_up * 190 )
		end
		
		if self.FlySound then
			self.FlySound:Stop()
		end
		if flying then
			flying = false
		end
	else
		if not flying then
			flying = true
			if self.FlySound then
				self.FlySound:Play()
			end
		end
				
		if self.EntOwner:KeyDown(IN_FORWARD) then
			vel = self.EntOwner:GetAimVector()*380
			push = true
		end
		if self.EntOwner:KeyDown(IN_JUMP) then
			vel.z = vel.z + 130
			push = true
		end
		if push then
			mv:SetVelocity( vel )
		end
	end
	
end

if CLIENT then

local mat_overlay = Material( "models/spawn_effect2" )

function ENT:Draw()
	
	if IsValid(self.EntOwner) then
	
		--render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_overlay )
		render.SetColorModulation( 0.9, 0.1, 0.9 )
		render.SetBlend( 0.1 )
		self:DrawModel()
		render.SetBlend( 1 )
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride()
		--render.SuppressEngineLighting( false )
		
	
		self.NextEmit = self.NextEmit or 0
		
		if self.NextEmit > CurTime() then return end
		self.NextEmit = CurTime() + 0.02
		
		local emitter = ParticleEmitter( self.EntOwner:GetPos() )	
		
		if emitter then
			for i=1, math.random( 2, 3 ) do
				local pos = self.EntOwner:LocalToWorld( self.EntOwner:OBBCenter() )
				local particle = emitter:Add("effects/blueflare1", pos + VectorRand()*math.random(-i*2,i*2))
				particle:SetDieTime(math.Rand(0.6,2))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha( 0 )
				particle:SetStartSize(math.Rand(0.5,2.1))
				particle:SetEndSize(math.Rand(2,3))
				particle:SetRoll(180)
				local rand = math.random(195,255)
				particle:SetColor( rand, 3, rand )
				particle:SetAirResistance( 1200 )
				particle:SetCollide( true )
				particle:SetGravity( Vector( 0, 0, math.random(-170,170) ) ) 
			end
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end

end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end