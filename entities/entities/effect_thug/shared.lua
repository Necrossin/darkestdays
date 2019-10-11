ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	killicon.AddFont( "effect_thug", "Bison_30", "flattened", Color(231, 231, 231, 255 ) ) 
end

local bones = {
	["ValveBiped.Bip01_Spine2"] = { scale = Vector(2.131, 2.121, 2.131), pos = Vector(2.335, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Foot"] = { scale = Vector(1.299, 1.299, 1.299), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1.631, 1.631, 1.631), pos = Vector(0, 0, 6.666), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.824, 1.824, 1.824), pos = Vector(0.984, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1.824, 1.824, 1.824), pos = Vector(0.984, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1.751, 1.751, 1.751), pos = Vector(0.017, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1.751, 1.751, 1.751), pos = Vector(0.017, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine"] = { scale = Vector(1.651, 1.651, 1.651), pos = Vector(0, 2.019, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Bicep"] = { scale = Vector(2.104, 2.104, 2.104), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(0.347, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(0.347, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.516, 1.516, 1.516), pos = Vector(4.809, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine1"] = { scale = Vector(1.623, 1.68, 1.623), pos = Vector(3.536, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1.822, 1.822, 1.822), pos = Vector(0.393, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1.822, 1.822, 1.822), pos = Vector(0.393, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Ulna"] = { scale = Vector(2.066, 2.066, 2.066), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Thigh"] = { scale = Vector(1.269, 1.269, 1.269), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(2.273, 2.273, 2.273), pos = Vector(0.105, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(2.273, 2.273, 2.273), pos = Vector(0.105, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Toe0"] = { scale = Vector(1.401, 1.401, 1.401), pos = Vector(2.759, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Ulna"] = { scale = Vector(2.039, 2.039, 2.039), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Foot"] = { scale = Vector(1.245, 1.245, 1.245), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1.575, 1.575, 1.575), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Calf"] = { scale = Vector(1.213, 1.213, 1.213), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Thigh"] = { scale = Vector(1.302, 1.302, 1.302), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.965, 1.965, 1.965), pos = Vector(0.845, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.965, 1.965, 1.965), pos = Vector(0.845, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.562, 1.562, 1.562), pos = Vector(1.373, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Calf"] = { scale = Vector(1.273, 1.273, 1.273), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1.805, 1.805, 1.805), pos = Vector(1.605, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.805, 1.805, 1.805), pos = Vector(1.605, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Toe0"] = { scale = Vector(1.376, 1.376, 1.376), pos = Vector(2.434, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Pelvis"] = { scale = Vector(1.263, 1.215, 1.225), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1.621, 1.621, 1.621), pos = Vector(0, 0, -5.229), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.083, 1.083, 1.083), pos = Vector(4.308, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Bicep"] = { scale = Vector(2.104, 2.104, 2.104), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.57, 1.57, 1.57), pos = Vector(0.398, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(1.549, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(1.549, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1.447, 1.447, 1.447), pos = Vector(3.171, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1.753, 1.753, 1.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.83, 1.83, 1.83), pos = Vector(1.212, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.83, 1.83, 1.83), pos = Vector(1.212, 0, 0), angle = Angle(0, 0, 0) }
}

function ENT:GetNiceModel( str )
	return string.Replace( str, "models/models/", "models/" ) 
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner._efThug) then
		if SERVER then
			self.EntOwner._efThug:Remove()
		end
		self.EntOwner._efThug = nil
	end
	
	self.EntOwner._efThug = self.Entity
	self:SetModel( self:GetNiceModel( self.EntOwner:GetModel() ) )
	for k = 0, self.EntOwner:GetNumBodyGroups() - 1 do
		self:SetBodygroup( k, self.EntOwner:GetBodygroup( k ) or 0 )
	end
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(EF_BONEMERGE)// + EF_BONEMERGE_FASTCULL
	
	self.Team = function() return self.EntOwner and self.EntOwner:Team() end
	
	self.EntOwner:ResetBones()
	
	if SERVER then
		self.Entity:DrawShadow(false)
		
		self.EntOwner:StripWeapons()
		self.EntOwner:Give("dd_thugfists")
		self.EntOwner:SetupDefaultStats()
		
		self.EntOwner._DefaultHealth = PLAYER_DEFAULT_HEALTH*2 - (GAMEMODE:GetGametype() == "ffa" and 45 or GAMEMODE:GetGametype() == "ts" and 15 or 0)//self.EntOwner._DefaultHealth + 125
		self.EntOwner._DefaultSpeed = PLAYER_DEFAULT_SPEED - 20 + (GAMEMODE:GetGametype() == "ts" and math.Round(TS_SPEED_OVER_TIME * (1 - math.Clamp( GetHillEntity():GetTimer()/TS_TIME,0,1)) ) or 0)
				
		for _,skill in pairs(Abilities) do
			if skill.OnReset then
				skill.OnReset(self.EntOwner)
			end
		end
		for _,skill in pairs(Abilities) do
			if skill.OnReset then
				skill.OnReset(self.EntOwner)
			end
		end
		
	end
	if CLIENT then
		self:SetRenderBounds(Vector(-180, -180, -180), Vector(180, 180, 180))
	end
	
	self.EntOwner:SetRenderMode(RENDERMODE_NONE)
	
end

function ENT:OnRemove()
	if IsValid(self:GetOwner()) then
		self:GetOwner()._efThug = nil
		self:GetOwner():ResetBones()
		self:GetOwner():SetRenderMode(RENDERMODE_NORMAL)
	end
end

function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end

	if IsValid(self.EntOwner) and SERVER then
		if not self.Done then
			for k, v in pairs( bones ) do
				local bone = self:LookupBone(k)
				if (!bone) then continue end
				self:ManipulateBoneScale( bone, v.scale  )
				self.EntOwner:ManipulateBoneAngles( bone, v.angle  )
				self.EntOwner:ManipulateBonePosition( bone, v.pos  )
			end
			self.Done = true
		end
	end
	
	/*if IsValid(self:GetOwner()) and CLIENT then
		for k, v in pairs( bones ) do
			local bone = self:LookupBone(k)
			if (!bone) then continue end
			self:ManipulateBoneScale( bone, v.scale  )
			self:GetOwner():ManipulateBoneAngles( bone, v.angle  )
			self:GetOwner():ManipulateBonePosition( bone, v.pos  )
		end
	end*/
	
end

function ENT:GetPlayerColor()
	return self:GetOwner() and self:GetOwner().GetPlayerColor and self:GetOwner():GetPlayerColor() or Vector(1,1,1)
end 

if CLIENT then

local function flex( ent, num, tbl )										
	for i = 0, num do
		if tbl[ i ] then
			tbl[ i ] = math.Rand( -10, 10 )
		end
	end
	--return tbl
end

function ENT:DrawTranslucent()
	//self:SetRenderBoundsWS(self.EntOwner:GetRenderBounds())
	//self.EntOwner:SetRenderBounds(Vector(-180, -180, -180), Vector(180, 180, 180))
	
	if not self.Done and IsValid( self:GetOwner() ) then
		for k, v in pairs( bones ) do
			local bone = self:LookupBone(k)
			if (!bone) then continue end
			self:ManipulateBoneScale( bone, v.scale  )
			self:GetOwner():ManipulateBoneAngles( bone, v.angle  )
			self:GetOwner():ManipulateBonePosition( bone, v.pos  )
		end
		
		--self:GetOwner():AddCallback( "BuildFlexWeights", flex )
		
		self.Done = true
	end
		
	/*if #self:GetCallbacks( "BuildFlexWeights" ) <= 0 then
		self:AddCallback( "BuildFlexWeights", flex )
	end*/
	
	if not self.DoneColor then
		self:SetColor(self:GetOwner() and self:GetOwner():GetColor() or color_white)
		self.DoneColor = true
	end
	self:DrawModel()
end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end