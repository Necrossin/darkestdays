local math = math
local table = table

function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	self.Rag = self.Ent:GetRagdollEntity()
	
	self.IsThug = math.Round(data:GetMagnitude()) == 1//self.ent:IsThug()
	
	--self.Emitter = ParticleEmitter(self.Entity:GetPos())
	self.StopTime = CurTime() + 2.5
	self.StopTime2 = CurTime() + 0.7
end

function EFFECT:Think()
	if !IsValid(self.Rag) then
		--self.Emitter:Finish()
		return false
	else
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		self.Entity:SetPos(self.Rag:GetPos())
		
		if IsValid(self.Rag) and not self.ChangedMass then
			for i = 0, self.Rag:GetPhysicsObjectCount() do
				local phys = self.Rag:GetPhysicsObjectNum(i)
				if phys and phys:IsValid() then
					phys:SetMass(phys:GetMass()*4)
					phys:Wake()
				end
			end
			self.ChangedMass = true
		end
		
		if ValidEntity(self.Rag) and self.StopTime >= CurTime() then
			for i = 0, self.Rag:GetPhysicsObjectCount() do
				local phys = self.Rag:GetPhysicsObjectNum(i)
				if phys and phys:IsValid() then
					phys:Wake()
					phys:AddVelocity( VectorRand()*math.Rand(-46,46) )
				end
			end
		end
	end
	return true
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
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

function EFFECT:Render()
	
	if IsValid( self.Rag ) then
		
		if self.Rag:GetPhysicsObjectNum(1) and self.Rag:GetPhysicsObjectNum(1):GetVelocity():Length() > 20 and self.StopTime2 >= CurTime() then
			local emitter = ParticleEmitter(self.Rag:GetPos())	
			for i=0, 25, 4 do
				local bone = self.Rag:GetBoneMatrix(i)
				if bone and emitter then
					local pos = bone:GetTranslation()
					//local emitter = ParticleEmitter(self.Entity:GetPos())
					local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
					particle:SetVelocity(VectorRand() * 16)
					particle:SetDieTime(0.8)
					particle:SetStartAlpha(0)
					particle:SetStartSize(3)
					particle:SetEndSize(8)
					particle:SetRoll(180)
					particle:SetColor(255, 0, 0)
					particle:SetLighting(true)
					particle:SetCollide(true)
					particle:SetAirResistance(12)
					particle:SetCollideCallback(CollideCallbackSmall)
				end	
			end
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
		
		if self.IsThug then
			for k, v in pairs( bones ) do
				local bone = self.Rag:LookupBone(k)
				if (!bone) then continue end
				self.Rag:ManipulateBoneScale( bone, v.scale  )
				self.Rag:ManipulateBoneAngles( bone, v.angle  )
				self.Rag:ManipulateBonePosition( bone, v.pos  )
			end
			if not self.Rag.HandleDraw then
				self.Rag.HandleDraw = self
			end
			if self.Rag.HandleDraw and self.Rag.HandleDraw == self then
				self.Rag:DrawModel()
			end
		end
		
	end
end

