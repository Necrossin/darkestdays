ENT.Type = "anim"
--ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IgnoreTracing = true

OrbsTable = OrbsTable or {}

if SERVER then
	AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "dd_health_orb" )
PrecacheParticleSystem( "dd_health_orb_pickup" )
//90 255 0 255
function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		//self.Entity:PhysicsInit(SOLID_VPHYSICS)
		//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetSolidFlags( FSOLID_NOT_SOLID  )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		self:SetPos(self:GetPos()+vector_up*35)
	
		self.Entity:DrawShadow(false)
		self:SetTrigger(true)
		
		//self:SetDTFloat(0,CurTime()+6)
		
		local time = 6
		if GAMEMODE:GetGametype() == "ts" then
			time = 12
		end
		
		self.DieTime = CurTime() + time
		
		table.insert(OrbsTable,self)
		
	end
	
end

function ENT:OnRemove()
	if CLIENT then
		//if IsValid(self:GetDTEntity(0)) then
			//ParticleEffectAttach("dd_health_orb_pickup",PATTACH_POINT_FOLLOW,self:GetDTEntity(0),self:GetDTEntity(0):LookupAttachment("chest"))
		//end
	end
end

if SERVER then
	
	function ENT:StartTouch( ent )
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() then
			if ent:IsJuggernaut() then return end
			if ent:IsCrow() then return end
			if ent:IsCarryingFlag() then return end
			//if ent:IsThug() then return end
			//if GAMEMODE:GetGametype() == "ffa" and ent:IsThug() then return end
			
			local torestore = 35
			
			//if ent:GetPerk("hpregen") then return end
			if ent:GetPerk("adrenaline") then return end
			
			if ent:IsThug() or ent:GetPerk("hpregen") then
				torestore = 17
			end

			
			
			local restore = ent:RestoreSomeHealth( torestore )//ent:RestoreHealth()
			if restore then

				local wep = IsValid( ent:GetActiveWeapon() ) and ent:GetActiveWeapon()

				if wep and wep.OnOrbPickup then
					wep:OnOrbPickup()
				end

				ent:EmitSound("items/medshot4.wav",100,math.random(100,120))
				//if ent:GetPerk("cureall") then
				//	ent:SetMana(math.Clamp(ent:GetMana()+math.random(10,15),0,ent:GetMaxMana()))
				//end
				//self:SetDTEntity(0,ent)
				
				local e = EffectData()
				e:SetOrigin(ent:GetPos())
				e:SetEntity(ent)
				e:SetScale(1)
				util.Effect("orb_pickup",e,nil,true)
				
				//ent:RestoreAmmo( true )
				
				self:Remove()
			end
		end
	end
	

	
end

function ENT:Think()
	local ct = CurTime()
	if SERVER then

		if self.DieTime and CurTime() >= self.DieTime then
			
			self:Remove()
			//WorldSound("ambient/levels/citadel/weapon_disintegrate1.wav",self:GetPos(),90,100)
		end
	end
end

if CLIENT then
function ENT:Draw()
	
	if MySelf:EyePos():DistToSqr( self:GetPos() ) > 360000 then
		if self.Particle then
			self.Particle = nil
			self:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		ParticleEffectAttach("dd_health_orb",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end
	
end
end