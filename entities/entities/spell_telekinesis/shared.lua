ENT.Name = "Telekinesis"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 3

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	AddSpellIcon("spell_telekinesis","telekinesis")
end

util.PrecacheSound("weapons/physcannon/superphys_launch1.wav")

PrecacheParticleSystem( "v_telekinesis" )
PrecacheParticleSystem( "telekinesis" )

function ENT:ValidEnt()
	return self:GetDTInt(1) ~= 0 and IsValid(Entity(self:GetDTInt(1)))
end

function ENT:OnInitialize()
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end

	self:SetDTEntity(1,nil)
	self:SetDTInt(1,0)
	//requires to hold down mouse button!
	self:SetDTBool(2,true)
	
	//shows that we are casting
	self:SetDTFloat(1,0)
end



function ENT:DoCast()
	
	self:SetDTFloat(1,CurTime()+0.08)

end

function ENT:Cast()
	
	self:DoCast()
end

function ENT:CanCast()
	
	local result = false
	
	if self.EntOwner:CanCast(self) then
		if !self:ValidEnt() and self.EntOwner:CanCast(self,15) or self:ValidEnt() then
			result = true
		end
	end

	return result
end

local trace = {}
function ENT:GrabProp()
	
	local aimvec = self.EntOwner:GetAimVector()
	--local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 300, filter = self.EntOwner})
	
	trace.start = self.EntOwner:GetShootPos()
	trace.endpos = self.EntOwner:GetShootPos() + aimvec * 350
	trace.mins = Vector(-7,-7,-7)
	trace.maxs = Vector(7,7,7)
	trace.filter = self.EntOwner
	
	trace = util.TraceHull(trace)
	
	
	if ValidEntity(trace.Entity) and (string.sub(trace.Entity:GetClass(), 1, 12) == "prop_physics" or trace.Entity:GetClass() == "func_physbox" or trace.Entity:GetClass() == "npc_grenade_frag" or trace.Entity:GetClass() == "projectile_meatbomb") and not trace.Entity._Telekinesis and trace.Entity:GetPhysicsObject():IsValid() then// and trace.Entity:GetPhysicsObject():IsMoveable() then
		
		if !trace.Entity:GetPhysicsObject():IsMoveable() then
			trace.Entity:GetPhysicsObject():EnableMotion( true )
		end
		
		self:SetDTEntity(1,trace.Entity)
		--self:SetDTInt(1,trace.Entity:EntIndex())
		local ent = self:GetDTEntity(1)//Entity(self:GetDTInt(1))
		
		if ent:IsValid() then//
			ent._Telekinesis = true
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				/*if phys:GetMass() < 140 and ( ent:OBBMins():Length() + ent:OBBMaxs():Length() ) < 100 then
					ent._Mass = phys:GetMass()

					phys:EnableGravity(false)
					phys:SetMass(10)
				end*/
			end
		end
		
	end
	
end

function ENT:DropProp(throw)
	
	local ent = self:GetDTEntity(1)//Entity(self:GetDTInt(1))//
	
	if IsValid(ent) then//self:ValidEnt()
		ent._Telekinesis = nil
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			if ent._Mass then
				phys:SetMass(ent._Mass)
				ent._Mass = nil
			end
			phys:EnableGravity(true)
			
			if throw and ValidEntity(self.EntOwner) then
				if SERVER then 
					self:UseMana(math.min(self.EntOwner:GetMaxMana()/1.6,self.EntOwner:GetMana()))
					phys:SetVelocity(self.EntOwner:GetAimVector()*1500) 
					ent:SetPhysicsAttacker(self.EntOwner)
					ent._Telekinetic = CurTime()+4
					if self.EntOwner:GetPerk("arsonist") then
						ent:Ignite(6,0)
					end
					WorldSound("weapons/physcannon/superphys_launch1.wav",self:GetPos(),70,math.random(110,140))
				end
			end
			if throw then
				self.EntOwner._efCantCast = CurTime() + 2
			else
				self.EntOwner._efCantCast = CurTime() + 0.2
			end
		end
		
		//self:SetDTInt(1,0)
		self:SetDTEntity(1,nil)
	end
	
end

local ShadowParams = {secondstoarrive = 0.002, maxangular = 1000, maxangulardamp = 10000, maxspeed = 800, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 0}

function ENT:Think()

	local ct = CurTime()
	
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end
	
	if CLIENT then
		
	end	
	
	if self:GetDTFloat(1) > CurTime() and self.EntOwner:CanCast(self) then
		if !IsValid(self:GetDTEntity(1)) and self.EntOwner:CanCast(self,15) then//!self:ValidEnt()
			self:GrabProp()
		end
	else
		--print(type(self:GetDTEntity(0)))
		if IsValid(self:GetDTEntity(1)) then//and self:ValidEnt()
			if !self.EntOwner:CanCast(self) then
				self:DropProp(false)
				self.EntOwner._efCantCast = CurTime() + 2
			else
				self:DropProp(true)
			end
		end
	end
	
	
	self.NextTick = self.NextTick or 0
	
	if IsValid(self:GetDTEntity(1)) then//self:ValidEnt()
		
		if self.EntOwner:GetCurSpellInd() ~= self:GetDTInt(0) then
			self:DropProp(false)
		end
		
		if self.EntOwner:CanCast(self,10) then 
			if self.NextTick < ct then
				if SERVER then self:UseDefaultMana() end	
				self.NextTick = CurTime() + 0.4
			end
		else
			self:DropProp(false)
			self.EntOwner._efCantCast = ct + 2
		end
	end
	
	if SERVER then 
	
		local ent = self:GetDTEntity(1)//Entity(self:GetDTInt(1))
		if !IsValid(ent) then return end//!ValidEntity(ent)
		
		local frametime = ct - (self.LastThink or ct)
		self.LastThink = ct
		
		local shootpos = self.EntOwner:GetShootPos()
		
		local phys = ent:GetPhysicsObject()
		if ent:GetMoveType() ~= MOVETYPE_VPHYSICS or not phys:IsValid() or self.EntOwner:GetGroundEntity() == ent then
			self:DropProp(false)
			self.EntOwner._efCantCast = ct + 2
			return
		end
		
		if self.EntOwner:KeyDown(IN_ATTACK) then
			self:DropProp(false)
			return
		end
		
		if !phys:IsMoveable() then
			self:DropProp(false)
			return
		end
		
		phys:Wake()
		
		if not self.ObjectPosition or not self.EntOwner:KeyDown(IN_SPEED) then
			local obbcenter = ent:OBBCenter()
			local obbmaxs = ent:OBBMaxs()
			local objectpos = shootpos + self.EntOwner:GetAimVector() * math.max( 70, obbmaxs[1], obbmaxs[2], obbmaxs[3] )
			objectpos = objectpos - obbcenter.z * ent:GetUp()
			objectpos = objectpos - obbcenter.y * ent:GetRight()
			objectpos = objectpos - obbcenter.x * ent:GetForward()
			self.ObjectPosition = objectpos
			self.ObjectAngles = ent:GetAngles()
		end

		ShadowParams.pos = self.ObjectPosition
		ShadowParams.angle = self.ObjectAngles
		ShadowParams.deltatime = frametime
		phys:ComputeShadowControl(ShadowParams)

		ent:SetPhysicsAttacker(self.EntOwner)
	
	
	
	end
	
	

	self:NextThink(ct)
	return true	
	
end

function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.EntOwner) then
			self.EntOwner:StopParticles()
		end
	end
	if IsValid(self:GetDTEntity(1)) then//ValidEntity()
		self:DropProp(false)
	end
end

if CLIENT then
local mat_overlay = Material( "models/spawn_effect2" )
function ENT:OnDraw()
	--if self:GetPos():Distance(EyePos()) > 1190 then return end
	local owner = self.EntOwner
	
	local ent = self:GetDTEntity(1)
	
	if ent and ent:IsValid() and ent.GetModel and ent:GetModel() then
		
		if self:GetModel() ~= ent:GetModel() then
			self:SetModel( ent:GetModel() )
			self:SetModelScale( 1.05, 0 )
		end
		
		render.MaterialOverride( mat_overlay )
		--render.SetColorModulation( 0.3, 0.3, 0.3 )
		render.SetBlend( 0.1 )
		self:SetRenderOrigin( ent:GetPos() )
		--self:SetPos( ent:GetPos() )
		--self:SetAngles( ent:GetAngles() )
		self:SetRenderAngles( ent:GetAngles() )
		self:DrawModel()
		--self:SetRenderOrigin( )
		--self:SetRenderAngles( )
		render.SetBlend( 1 )
		--render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride()
		self.ChangedRenderOrigin = true
	else
		if self.ChangedRenderOrigin then
			self.ChangedRenderOrigin = false
			self:SetRenderOrigin( )
			self:SetRenderAngles( )
		end
	end
	
	
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
	

	
	
	
	
	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_telekinesis",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end



