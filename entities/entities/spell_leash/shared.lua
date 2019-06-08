ENT.Name = "Leash"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 50

if CLIENT then
ENT.Mat = Material( "sprites/rollermine_shock" )
end

if CLIENT then 
	//AddSpellIcon("spell_electrobolt","electrobolt")
end

if SERVER then
	AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "v_leash" )
PrecacheParticleSystem( "leash" )
PrecacheParticleSystem( "leash_beam" )


util.PrecacheSound("ambient/levels/labs/electric_explosion1.wav")

local endMdl = Model("models/props_junk/PopCan01a.mdl")

local tr = {}
function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	local distance = 500
	local aimvec = self.EntOwner:GetAimVector()
	
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * distance, filter = self.EntOwner})	
	

	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * distance
	tr.mins = Vector(-22,-22,-14)
	tr.maxs = Vector(22,22,14)
	tr.filter = self.EntOwner
	
	tr = util.TraceHull(tr)
	
	if tr.Hit and ValidEntity(tr.Entity) and not tr.Entity:IsWorld() then
		trace = tr
	end

	
	self:SetDTFloat(1,CurTime() + 0.2)
	self:SetDTVector(0,trace.HitPos)
	//self:SetDTFloat(2,self.EntOwner:GetShootPos():Distance(self:GetDTVector(0)))
	
	if CLIENT then
		self:SetRenderBoundsWS( self.Entity:GetPos(),self:GetDTVector(0))
		if self.End then
			self.End:SetPos(self:GetDTVector(0))
		end
	end
	
	if SERVER then
		--self:UseDefaultMana()
		
		--local targets = ents.FindInSphere( self:GetDTVector(0), 55 )
		
		--for _,pl in pairs(targets) do
		--	if pl and ValidEntity(pl) and not (trace.Entity:IsPlayer() and trace.Entity:Team() == self.EntOwner:Team()) then
				--trace.Entity = pl
				--break
		--	end
		--end
		if ValidEntity(trace.Entity) and trace.Entity:GetClass() == "projectile_cyclonetrap" and trace.Entity:Team() == self.EntOwner:Team() and not (trace.Entity:GetDTBool(1) or trace.Entity:GetDTBool(2))  then
			trace.Entity:SetDTBool(0,true)
			return 
		end
		
		if ValidEntity(trace.Entity) and not trace.Entity:IsWorld() and not (trace.Entity:IsPlayer() and trace.Entity:Team() == self.EntOwner:Team()) then

			
		end
			
		
		
	end
	
	--self:SetRenderBounds(Vector(-90, -90, -98), Vector(90, 90, 90))

	
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end


function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.EntOwner) then
			self.EntOwner:StopParticles()
		end
		if IsValid(self.End) then
			self.End:Remove()
			self.End = nil
		end
	end
end

function ENT:Think()
	
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end
	
	if CLIENT then
		if not self.End then
			self:CreateEndPos()
		end
		if self.End and self.End:GetPos() ~= self:GetDTVector(0) then
			self.End:SetPos(self:GetDTVector(0))
		end
	end
	
end

if CLIENT then
function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-90, -90, -98), Vector(90, 90, 90))
	self.Emitter = ParticleEmitter(self:GetPos())
	
	self:CreateEndPos()
	
end

function ENT:CreateEndPos()
	
	self.End = ClientsideModel(endMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE)
	if ValidEntity(self.End) then
		self.End:SetPos(self:GetPos())
		self.End:SetAngles(self:GetAngles())
		self.End:SetNoDraw(true)
	else
		self.End = nil
	end
	
end

function ENT:OnDraw()
	
	local owner = self.EntOwner
	local wep = owner:GetActiveWeapon()
	local point = wep and wep.WElements and wep.WElements["cast"] and wep.WElements["cast"].modelEnt
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() then
		
		self.LastEmit = self.LastEmit or 0
		
		if self.LastEmit > CurTime() then return end
		
		self.LastEmit = self:GetDTFloat(1) 
		
		if self.End and point and (owner ~= MySelf or GAMEMODE.ThirdPerson) then//and
			if self.End and self.End:GetPos() ~= self:GetDTVector(0) then
				self.End:SetPos(self:GetDTVector(0))
			end
			local CPoint0 = {
				["entity"] = point,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			local CPoint1 = {
				["entity"] = self.End,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			self.End:CreateParticleEffect("leash_beam",{CPoint0,CPoint1})
			//util.ParticleTracerEx( "electrobolt_main_beam", owner:GetAttachment( owner:LookupAttachment("anim_attachment_LH")).Pos,self:GetDTVector(0),true, owner:EntIndex(),owner:LookupAttachment("anim_attachment_LH") );	
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
	
	if MySelf == owner and not GAMEMODE.ThirdPerson then
		if self.Particle then
			self.Particle = nil
			owner:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("leash",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end

end

function ENT:HandDraw(owner,reverse,point)
	
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() and point then
		
		self.VLastEmit = self.VLastEmit or 0
		
		if self.VLastEmit > CurTime() then return end
		
		self.VLastEmit = self:GetDTFloat(1) 
		
		if self.EntOwner == MySelf and self.End then
			local CPoint0 = {
				["entity"] = point,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			local CPoint1 = {
				["entity"] = self.End,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			self.End:CreateParticleEffect("leash_beam",{CPoint0,CPoint1})
			//util.ParticleTracerEx( "electrobolt_main_beam", point:GetPos(),self:GetDTVector(0),true, point:EntIndex(),-1 );	//
			//ParticleEffectAttach("electrobolt_main_beam",PATTACH_ABSORIGIN_FOLLOW,point,0)
		end
	
	end
	
	if point and not point.Particle then
		ParticleEffectAttach("v_leash",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	local vm = owner:GetViewModel()
		
	if vm and vm:IsValid() and point then
	
		local dlight = DynamicLight( vm:EntIndex() )
		if ( dlight ) then
			dlight.Pos = point:GetPos()+VectorRand()*math.Rand(0,0.1)
			dlight.r = 20
			dlight.g = 100
			dlight.b = 255
			dlight.Brightness = 1
			dlight.Size = 14
			dlight.Decay = 14 * 5
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0
		end
		
	end

end

end





