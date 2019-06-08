ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
	

end
util.PrecacheSound("ambient/levels/citadel/weapon_disintegrate1.wav")
util.PrecacheSound("items/medshot4.wav")

util.PrecacheModel("models/items/HealthKit.mdl")

function ENT:Initialize()

	
	if SERVER then
		self:SetModel("models/items/HealthKit.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
		self.Entity:DrawShadow(false)
		self:SetTrigger(true)
		
		self:SetDTBool(0,true)
		self:SetDTFloat(0,0)
		
		self.RespawnTime = PICKUP_RESPAWNTIME+10
		
	end
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion( false ) 
	end	
	
end

function ENT:OnRemove()

end

if SERVER then
	
	function ENT:StartTouch( ent )
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and self:GetDTBool(0) then
			if ent:IsJuggernaut() then return end
			if ent:IsCrow() then return end
			local restore = ent:RestoreSomeHealth()//ent:RestoreHealth()
			if restore then
				ent:EmitSound("items/medshot4.wav")
				self:SetDTBool(0,false)
				self:SetDTFloat(0,CurTime()+self.RespawnTime)
				if ent:GetPerk("cureall") then
					ent:SetMana(math.Clamp(ent:GetMana()+math.random(10,15),0,ent:GetMaxMana()))
				end
			end
		end
	end
	

	
end

function ENT:Think()
	local ct = CurTime()
	if SERVER then

		if CurTime() >= self:GetDTFloat(0) and !self:GetDTBool(0) then
			self:SetDTBool(0,true)
			WorldSound("ambient/levels/citadel/weapon_disintegrate1.wav",self:GetPos(),90,100)
			local e = EffectData()
			e:SetOrigin(self:GetPos())
			util.Effect("Sparks",e,true,true)
		end
		
		--self:SetAngles(Angle(0,math.NormalizeAngle(RealTime()*13),0))
	end
	--self:NextThink(ct+0.25)
end

if CLIENT then
local mat = Material( "white_outline" )
function ENT:Draw()
	
	if not self.Origin then
		self.Origin = self:GetPos()+vector_up*23
	end

	if self:GetDTBool(0) then

		self:SetAngles(Angle(60,math.NormalizeAngle(RealTime()*13),0))
		self:SetPos(self.Origin+vector_up*math.sin(RealTime()*3)*4)
	
		render.SuppressEngineLighting( true )
		render.SetAmbientLight( 50/255, 1, 50/255 )
		--render.SetColorModulation( 1, 1, 1 )
		   
		self:SetModelScale( 1.18,0 )
		render.MaterialOverride( mat )
		render.SetColorModulation( 50/255, 1, 50/255 )

		self:DrawModel()
		
		render.MaterialOverride( nil )
		self:SetModelScale( 1.15,0 )
					   
		render.SuppressEngineLighting( false )
		render.SetColorModulation( 1,1,1 )
	
		
	
		self:DrawModel()
	end
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self.Origin+vector_up*5
		dlight.r = 50
		dlight.g = 255
		dlight.b = 50
		dlight.Brightness = 1
		dlight.Size = 30
		dlight.Decay = 30 * 5
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
	end
end
end