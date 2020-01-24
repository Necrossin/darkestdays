ENT.Type = "anim"
--ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IgnoreTracing = true

OrbsTable = OrbsTable or {}

if SERVER then
	AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
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
	end
end

if SERVER then
	
	function ENT:StartTouch( ent )
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() then
			if ent:IsJuggernaut() then return end
			if ent:IsCrow() then return end
			if ent:IsCarryingFlag() then return end
			if ent:IsThug() then return end
			if GAMEMODE:GetGametype() == "ffa" and ent:IsThug() then return end
			
			if ent:GetPerk("hpregen") then return end
			
			//ent:RestoreAmmo( true )
			ent:RestoreSomeHealth( 15 )
			ent:RestoreSomeMana( 15 )
			
			if ent._efAdrenaline and ent._efAdrenaline:IsValid() then
				ent._efAdrenaline.DieTime = CurTime() + ent._efAdrenaline.Duration
			else
				ent:SetEffect( "adrenaline" )
				ent:EmitSound("npc/antlion_guard/angry"..math.random(1,3)..".wav",120,math.random(100,120))
			end

				
			local e = EffectData()
			e:SetOrigin(ent:GetPos())
			e:SetEntity(ent)
			e:SetScale(3)
			util.Effect("orb_pickup",e,nil,true)
				
			self:Remove()
		end
	end
	

	
end

function ENT:Think()
	local ct = CurTime()
	if SERVER then

		if self.DieTime and CurTime() >= self.DieTime then
			
			self:Remove()
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
		ParticleEffectAttach("dd_evil_orb",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	

	
end
end