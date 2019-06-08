ENT.Type = "anim"
--ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

ENT.IgnoreTracing = true

OrbsTable = OrbsTable or {}

PrecacheParticleSystem( "dd_mana_orb" )
PrecacheParticleSystem( "dd_mana_orb_pickup" )
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
			//ParticleEffectAttach("dd_mana_orb_pickup",PATTACH_POINT_FOLLOW,self:GetDTEntity(0),self:GetDTEntity(0):LookupAttachment("chest"))
		//end
	end
end

if SERVER then
	
	function ENT:StartTouch( ent )
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() then
			if ent:IsJuggernaut() then return end
			if ent:IsCrow() then return end
			if ent:IsCarryingFlag() then return end
			
			if ent:GetPerk("adrenaline") then return end
			
			local restore = ent:RestoreSomeMana()
			if restore then
				ent:EmitSound("items/battery_pickup.wav",100,math.random(100,120))
				//if ent:GetPerk("cureall") then
				//	ent:SetMana(math.Clamp(ent:GetMana()+math.random(10,15),0,ent:GetMaxMana()))
				//end
				//self:SetDTEntity(0,ent)
				local e = EffectData()
				e:SetOrigin(ent:GetPos())
				e:SetEntity(ent)
				e:SetScale(2)
				util.Effect("orb_pickup",e,nil,true)
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
	//self:DrawModel()
	if not self.Particle then
		ParticleEffectAttach("dd_mana_orb",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.Particle = true
	end	
	
	/*local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 0
		dlight.g = 90
		dlight.b = 255
		dlight.Brightness = 1
		dlight.Size = 30
		dlight.Decay = 30 * 5
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
	end*/
	
end
end