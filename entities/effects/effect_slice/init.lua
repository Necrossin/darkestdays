local slicesound = Sound( "physics/gore/dismemberment.wav" )
local gibsound = Sound( "physics/gore/bodysplat.wav" )

local skeleton = Model( "models/player/skeleton.mdl" )

local blood_overlay = CreateMaterial( "dd_ragdoll_blood2", 
	"VertexLitGeneric", 
	{ 
		["$basetexture"] = "Models/flesh", 
		["$bumpmap"] = "models/flesh_nrm",
		["$nodecal"] = "0",
		--["$halflambert"] = 1,
		["$translucent"] = 1,
		["$model"] = 1,

		["$detail"] = "Models/flesh", 
		["$detailscale"] = 2,
		["$detailblendfactor"] = 7, 
		["$detailblendmode"] = 3,

		["$phong"] = "1",
		["$phongboost"] = "5",
		["$phongfresnelranges"] = "[2 5 10]",
		["$phongexponent"] = "500"
	} 
)

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

local LocalToWorld = LocalToWorld
local WorldToLocal = WorldToLocal
local string_Replace = string.Replace


function EFFECT:GetNiceModel( str )
	return string_Replace( str, "models/models/", "models/" ) 
end

function EFFECT:Init( data )

	self.ent = data:GetEntity()
	
	self.MakeSecondPart = math.Round(data:GetRadius()) == 1
	
	if !IsValid(self.ent) then return end
	
	
	if GAMEMODE:GetGametype() == "ffa" then
		local col = self.ent:GetPlayerColor() //self.ent:GetInfo( "cl_playercolor" )
		self.GetPlayerColor = function() return Vector( col.x, col.y, col.z ) end
	else
		local col = team.GetColor( self.ent:Team() )
		self.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
	end
	
	self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))

	self.Origin = data:GetOrigin()

	self.Ang = data:GetNormal()
	self.Ang2 = self.Ang:Angle():Forward() * 20
	
	self.Normal = ( self.Ang2 - self.Ang ):GetNormalized()
	
	//self.DamagePos = data:GetNormal()
	
	self.IsThug = math.Round(data:GetMagnitude()) == 1
	
	self.SplatterScale = math.Rand(0.3, 4)
	
	self.Up = math.ceil(data:GetScale())
	
	self.Origin.z = self.Up
	
	self.BleedOut = CurTime() + 2.2
	
	if self.MakeSecondPart then
		sound.Play(slicesound,self.Origin,100, math.random(110,140), 1)
		
		local e = EffectData()
			e:SetEntity(self.ent)
			e:SetOrigin(self.Origin)
			//e:SetAngles(self.Ang)
			e:SetStart(self.Origin)
			e:SetScale(self.Up)
			e:SetMagnitude(self.IsThug and 1 or 0)
			e:SetNormal(self.Ang)
			e:SetRadius( 0 )
				
		util.Effect("effect_slice",e,nil,nil)
	end
	
	if IsValid(self.ent) then
		if IsValid(self.ent:GetRagdollEntity()) then
			
			self.ent:GetRagdollEntity():SetNoDraw(true)
			
			local rag = self.ent:GetRagdollEntity()
			
			rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
						
			self.transform = {}
	
			local pos, ang = rag:GetPos(), rag:GetAngles()
			for i=0, rag:GetPhysicsObjectCount()-1 do
				local phys = rag:GetPhysicsObjectNum(i)
				if IsValid(phys) then
					local pos2, ang2 = WorldToLocal(phys:GetPos(), phys:GetAngles(), pos, ang)
					
					self.transform[i] = {pos = pos2, ang = ang2}
				end
			end
						
			
			self:CreateDummy()
			
			
		end
	end
	


end

// extremely huge thanks to _Kilburn for this nice "statue" code
local mins = Vector(math.huge, math.huge, math.huge)
local maxs = Vector(-math.huge, -math.huge, -math.huge)
function EFFECT:CreateDummy()

	local rag = self.ent:GetRagdollEntity()
	
	self:SetModel( self:GetNiceModel( rag:GetModel() ) )
	self:SetPos( rag:GetPos() + vector_up * 3 )
	self:SetAngles( rag:GetAngles() )
	
	local convexes = {}
	local mass = 0
	self.PhysBoneTransforms = {}
	self.BoneTransforms = {}
	self.BoneReference = nil
	
	for i=0, rag:GetPhysicsObjectCount()-1 do	
		local helper = self.transform[i]
		local phys = rag:GetPhysicsObjectNum(i)	
		
		local M = Matrix()
		
		self.PhysBoneTransforms[i] = {pos = helper.pos, ang = helper.ang}
		self.BoneTransforms[rag:TranslatePhysBoneToBone(i)] = self.PhysBoneTransforms[i]
		
		M:Translate(helper.pos)
		M:Rotate(helper.ang)
		
		if !self.MakeSecondPart and self.Normal:Dot(phys:GetPos() - self.Origin) > 0 and phys:GetPos():Distance( self.Origin ) > 13 then continue end
		if self.MakeSecondPart and self.Normal:Dot(phys:GetPos() - self.Origin) < 0 and phys:GetPos():Distance( self.Origin ) > 13 then continue end
		
		mass = mass + phys:GetMass()
		
		
		for _,c in ipairs(phys:GetMeshConvexes()) do
			local cvx = {}
			//reduce amount of vertices to prevent small stuttering
			local max_vertices = 12
			local min = math.min(max_vertices, #c)
			local dif = math.ceil(#c/min)
			
			for _,p in ipairs(c) do
			
				if _ % dif ~= 0 then continue end
			
				local M1 = Matrix() * M
				M1:Translate(p.pos)
				
				local pos = M1:GetTranslation()
				
				cvx[#cvx+1] = pos
				
				OrderVectors(mins, pos*1)
				OrderVectors(pos*1, maxs)
				
			end
			convexes[#convexes+1] = cvx
		end
	end
	
	self:PhysicsInitMultiConvex(convexes)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		//phys:EnableMotion(false)
		phys:Wake()
		phys:SetMass(mass)
		phys:SetMaterial("zombieflesh")
		phys:SetVelocity( self.Normal:GetNormal() * ( self.MakeSecondPart and 100 or -100 ) + VectorRand() * 50 + vector_up * 20 )
	end
	
	self:EnableCustomCollisions(true)
		
	self.SavePos = self:WorldToLocal( self.Origin )
	self.NormalPos1 = self:WorldToLocal( self.Ang )
	self.NormalPos2 = self:WorldToLocal( self.Ang2 )
	
	if not rag.ReferencePoseTable then
		rag.ReferencePoseTable = {}
		
		/*for k, v in pairs( bones ) do
			local bone = rag:LookupBone(k)
			if (!bone) then continue end
			rag:ManipulateBoneScale( bone, v.scale  )
			rag:ManipulateBoneAngles( bone, v.angle  )
			rag:ManipulateBonePosition( bone, v.pos  )
		end*/
		
		for k = 0, self.ent:GetBoneCount() - 1 do
			local m = self.ent:GetBoneMatrix( k )
			if m then
				local pos, ang = m:GetTranslation(), m:GetAngles()
				local local_pos, local_ang = WorldToLocal( pos, ang, rag:GetPos(), rag:GetAngles())
				
				rag.ReferencePoseTable[ k ] = { pos = local_pos, ang = local_ang }
			else
				-- for some reason GetBoneMatrix does not works on thugs, so we can use this as backup plan
				local pos, ang = self.ent:GetBonePosition( k )
				if pos and ang then
					local local_pos, local_ang = WorldToLocal( pos, ang, rag:GetPos(), rag:GetAngles())
					rag.ReferencePoseTable[ k ] = { pos = local_pos, ang = local_ang }
				end
			end

		end
	end
	
	/*self.Dummy = ClientsideModel( skeleton, RENDER_GROUP_OPAQUE_ENTITY )
	if self.Dummy then
		self.Dummy:SetPos( self:GetPos() )
		self.Dummy:SetAngles( self:GetAngles() )
		self.Dummy:SetParent( self )
		self.Dummy:AddEffects( EF_BONEMERGE )
		self.Dummy:SetNoDraw( true )
	else
		self.Dummy = nil
	end*/

	
end


local function MatrixWorldToLocal(refMat, worldMat)
	local pos, ang = WorldToLocal(refMat:GetTranslation(), refMat:GetAngles(), worldMat:GetTranslation(), worldMat:GetAngles())
	local localM = Matrix()
	localM:Translate(pos)
	localM:Rotate(ang)
	
	return localM
end

function EFFECT:CaptureReferencePose()
	local old_BuildBonePositions = self.BuildBonePositions
	
	self.BuildBonePositions = function(self, n)
		self.BoneReference = {}
		
		local function processChildBones(parent, parentMat)
			local children
			if parent then
				children = self:GetChildBones(parent)
			else
				children = {0}
			end
			
			for _,child in ipairs(children) do
				local childName = self:GetBoneName(child)
				if childName then
					local childMat = self:GetBoneMatrix(child)
					self.BoneReference[childName] = MatrixWorldToLocal(childMat, parentMat)
					processChildBones(child, childMat)
				end
			end
		end
		
		local rootMat = Matrix()
		processChildBones(nil, rootMat)
	end
	self:SetupBones()
	
	self.BuildBonePositions = old_BuildBonePositions
end


function EFFECT:PropagateBoneTransform(parent, parentMat)
	local children
	if parent then
	
		local bonecount = self:GetBoneCount()
		if ( bonecount == 0 || bonecount < parent ) then return end

		for k = 0, bonecount - 1 do
			if ( self:GetBoneParent( k ) != parent ) then continue end
			
			local child = k
			if not self.BoneTransforms[child] then
				local childName = self:GetBoneName(child)
				if childName and self.BoneReference[childName] then
					local childMat = parentMat * self.BoneReference[childName]
					if self.BoneTransforms and self.BoneTransforms[childName] then
						local tr = self.BoneTransforms[childName]
						childMat:Translate(tr.pos)
						childMat:Rotate(tr.ang)
					end
					
					--local ang = self:GetManipulateBoneAngles(child)
					--childMat:Rotate(ang)
					
					self:SetBoneMatrix(child, childMat)
					self:PropagateBoneTransform(child, childMat)
				end
			end
			
		end
	
		/*children = self:GetChildBones(parent)
		
		for i=1, #children do
			local child = children[i]
			if not self.BoneTransforms[child] then
				local childName = self:GetBoneName(child)
				if childName and self.BoneReference[childName] then
					local childMat = parentMat * self.BoneReference[childName]
					if self.BoneTransforms and self.BoneTransforms[childName] then
						local tr = self.BoneTransforms[childName]
						childMat:Translate(tr.pos)
						childMat:Rotate(tr.ang)
					end
					
					--local ang = self:GetManipulateBoneAngles(child)
					--childMat:Rotate(ang)
					
					self:SetBoneMatrix(child, childMat)
					self:PropagateBoneTransform(child, childMat)
				end
			end
		end*/
		
	else
		/*local child = 0
		
		if not self.BoneTransforms[child] then
			local childName = self:GetBoneName(child)
			if childName and self.BoneReference[childName] then
				local childMat = parentMat * self.BoneReference[childName]
				if self.BoneTransforms and self.BoneTransforms[childName] then
					local tr = self.BoneTransforms[childName]
					--childMat:Translate(tr.pos)
					--childMat:Rotate(tr.ang)
				end
				
				--local ang = self:GetManipulateBoneAngles(child)
				--childMat:Rotate(ang)
				
				--self:SetBoneMatrix(child, childMat)
				--self:PropagateBoneTransform(child, childMat)
			end
		end*/
		
	end
	
	
end

local m_vec_zero = Vector( 0, 0, 0 )
local m_ang_zero = Angle( 0, 0, 0 )
local m_scale_zero = Vector( 1, 1, 1 )

function EFFECT:BuildBonePositions(nbones)
	if self.BoneTransforms and self.BoneReference then
			
		self.BoneTransformsStore = self.BoneTransformsStore or {}
		
		self.MaxN = self.MaxN or table.maxn( self.BoneTransforms )
		
		//for b, tr in pairs(self.BoneTransforms) do
		for i = 0, self.MaxN do
			
			if not self.BoneTransforms[i] then continue end
			
			local b = i
			local tr = self.BoneTransforms[i]
			
			local M0 = self:GetBoneMatrix(b)
			
			if M0 then
			
				if not self.BoneTransformsStore[b] then
					self.BoneTransformsStore[b] = Matrix()
				end
			
				local M = self.BoneTransformsStore[b]//Matrix()
				
				M:SetTranslation( m_vec_zero )
				M:SetAngles( m_ang_zero )
				M:SetScale( m_scale_zero )
				
				M:Translate(self:GetPos())
				M:Rotate(self:GetAngles())
				M:Translate(tr.pos)
				M:Rotate(tr.ang)
				self:SetBoneMatrix(b, M)
				self:PropagateBoneTransform(b, M)
			end
		end
	end
end

local M_Entity = FindMetaTable("Entity")
local M_VMatrix = FindMetaTable("VMatrix")

local VM_SetTranslation = M_VMatrix.SetTranslation
local VM_GetTranslation = M_VMatrix.GetTranslation
local VM_GetAngles = M_VMatrix.GetAngles
local VM_SetAngles = M_VMatrix.SetAngles
local VM_SetScale = M_VMatrix.SetScale

local E_GetBoneMatrix = M_Entity.GetBoneMatrix
local E_SetBoneMatrix = M_Entity.SetBoneMatrix

function EFFECT:BuildBonePositions2( nbones )
	
	local ragdoll = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	for bone, tbl in pairs( ragdoll.ReferencePoseTable ) do
		
		local m = E_GetBoneMatrix( self, bone )--self:GetBoneMatrix( bone )
		
		if m then
			local pos, ang = LocalToWorld( tbl.pos, tbl.ang, self:GetPos(), self:GetAngles() )
			
			VM_SetTranslation( m, pos )
			VM_SetAngles( m, ang )
			
			E_SetBoneMatrix( self, bone, m )
			
			--m:SetTranslation( pos )
			--m:SetAngles( ang )
			
			--self:SetBoneMatrix( bone, m )
			
		end	
	end
	
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
			
		if math.random(1, 10) == 3 then
			WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
		end
		//util.Decal(math.random(15) == 15 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		local rand = math.random(3)
		if rand ~= 1 then
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
		local vel = particle.StartVelocity
		
		particle:SetDieTime(0)

end

function EFFECT:Think( )
	
	if IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity()) then
		if not self.Frozen then
			for i = 1, self.ent:GetRagdollEntity():GetPhysicsObjectCount() do
				local bone = self.ent:GetRagdollEntity():GetPhysicsObjectNum(i)
				if bone and bone.IsValid and bone:IsValid() then
					bone:EnableMotion(false)
				end
			end
			self.Frozen = true
		end
		
		--self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		
	else
		--SafeRemoveEntity(self.Dummy)
	end
	
	

	return IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity())
end

local flesh = Material("models/flesh")
local meat = CreateMaterial( "Meat", "UnlitGeneric", { [ "$basetexture" ] = "models/flesh" } )
local meat2 = CreateMaterial( "Meat2", "UnlitGeneric", { [ "$basetexture" ] = "models/skeleton/skeleton_bloody" } )
local meat3 = CreateMaterial( "Meat3", 
	"UnlitGeneric", 
	{ 
		["$basetexture"] = "models/skeleton/skeleton_bloody", 
		["$bumpmap"] = "models/flesh_nrm",

		["$detail"] = "Models/flesh", 
		["$detailscale"] = 1,
		["$detailblendfactor"] = 7, 

		["$phong"] = "1",
		["$phongboost"] = "5",
		["$phongfresnelranges"] = "[2 5 10]",
		["$phongexponent"] = "500"
	} )
local mat = Material( "white_outline" )
local skeleton_bloody = Material( "models/skeleton/skeleton_bloody" )

local meat_col = Color(135,5,5,255)
local vec_grav = Vector( 0, 0, -600 )

local maxbound = Vector(5, 5, 5)
local minbound = maxbound * -1

function EFFECT:Render()
	local rag = self
	local ct = CurTime()
	

	
	if self and self:IsValid() then
	
		/*if not self.InitBuildBonePositions or not self.BoneReference then
			self:AddCallback("BuildBonePositions", function(self, nbones) self:BuildBonePositions(nbones) end)
			self:CaptureReferencePose()
			self.InitBuildBonePositions = true
			self:SetupBones()
		end	*/
		
		//self:DrawModel()
	end
	
	local ragdoll = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	if ragdoll and IsValid(ragdoll) then
		
		--ragdoll:DrawModel()
		
		/*if self.IsThug and not ragdoll.DoneThug then
			for k, v in pairs( bones ) do
				local bone = ragdoll:LookupBone(k)
				if (!bone) then continue end
				ragdoll:ManipulateBoneScale( bone, v.scale  )
				ragdoll:ManipulateBoneAngles( bone, v.angle  )
				ragdoll:ManipulateBonePosition( bone, v.pos  )
			end
			ragdoll.DoneThug = true
		end*/
		
		if not self.InitBuildBonePositions and ragdoll.ReferencePoseTable then
			self:AddCallback("BuildBonePositions", function(self, nbones) self:BuildBonePositions2(nbones) end)
			self.InitBuildBonePositions = true
			self:SetupBones()
		end	
		
		if not ragdoll.Sliced then
			ragdoll.Sliced = true
		end
	end
	
	if rag and IsValid(rag) then	
						
				if self.IsThug and not self.DoneThug then
					for k, v in pairs( bones ) do
						local bone = rag:LookupBone(k)
						if (!bone) then continue end
						rag:ManipulateBoneScale( bone, v.scale  )
						rag:ManipulateBoneAngles( bone, v.angle  )
						rag:ManipulateBonePosition( bone, v.pos  )
					end
					self.DoneThug = true
				end
						
				
				if not self.SavePos then return end
				
				local pos = self:LocalToWorld( self.SavePos )
				
				local normal1 = self:LocalToWorld( self.NormalPos1 )
				local normal2 = self:LocalToWorld( self.NormalPos2 )
				
				local normal = ( normal2 - normal1 ):GetNormalized()
								
				if !self.MakeSecondPart then
					normal = normal * -1
				end
				
				local distance = normal:Dot( pos )
				
				--rag:SetupBones()
				if not rag.OriginalModel then
					rag.OriginalModel = self:GetNiceModel( rag:GetModel() )
				end
				rag:SetModel( rag.OriginalModel )
								
				
				render.ClearStencil()
				render.SetStencilEnable( true )
				
				render.EnableClipping( true )
				render.PushCustomClipPlane( normal, distance )

				render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
				render.SetStencilZFailOperation( STENCILOPERATION_REPLACE ) -- STENCILOPERATION_KEEP
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
				render.SetStencilReferenceValue( 1 )
				
			
				--render.ModelMaterialOverride( meat )
					render.CullMode( MATERIAL_CULLMODE_CW )
					--render.SetBlend( 0 )
					rag:DrawModel()
					--render.SetBlend( 1 )
					render.CullMode( MATERIAL_CULLMODE_CCW )
				--render.ModelMaterialOverride(  )
			
				render.SetStencilReferenceValue( 2 )
				render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
				render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
				
				
				rag:DrawModel()
				
				blood_overlay:SetFloat( "$detailscale", self.SplatterScale or 2 )
			
				render.ModelMaterialOverride( blood_overlay )
				render.SetColorModulation(0.5, 0, 0)
					rag:DrawModel()
				render.SetColorModulation(1, 1, 1)
				render.ModelMaterialOverride(  )
				
				render.PopCustomClipPlane()
				render.EnableClipping( false )
				
				/*render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
				render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
				
				render.SetStencilReferenceValue( 1 )
				
				
				if not self.MeatAng and not self.MeatPos then
					
					local meat_ang = ( normal * -1 ):Angle()
					meat_ang:RotateAroundAxis( meat_ang:Right(), -90 )
				
					local mpos, mang = WorldToLocal( pos, meat_ang, self:GetPos(), self:GetAngles())
					
					self.MeatAng = mang
					self.MeatPos = mpos
				end
				
				local meat_pos, meat_ang = LocalToWorld( self.MeatPos, self.MeatAng, self:GetPos(), self:GetAngles())
				
				--render.OverrideDepthEnable( true, true )
				
				cam.Start3D2D( meat_pos, meat_ang, 1 )
					surface.SetMaterial( meat3 )
					surface.SetDrawColor( meat_col )
					surface.DrawTexturedRectRotated( 0, 0, 80, 80, 0 ) 
				cam.End3D2D()
				
				--render.OverrideDepthEnable( false )
				*/
				render.SetStencilEnable( false )
				
				
				if MySelf:EyePos():DistToSqr( pos ) < 160000 then -- 400^2
				
					//stay calm, skeleton
					local distance = normal:Dot( pos - normal * ( self.MakeSecondPart and 1.3 or 1 ) )
									
					render.EnableClipping( true )
					render.PushCustomClipPlane( normal, distance )
					
					local distance = (normal*-1):Dot( pos + normal * 2 )
					render.PushCustomClipPlane( normal*-1, distance )
									
					
					rag:SetModel( skeleton )
					
					render.ModelMaterialOverride( skeleton_bloody )
						--rag:SetupBones()
						rag:DrawModel()
						--self.Dummy:SetupBones()
						--self.Dummy:DrawModel()
						
						render.CullMode( MATERIAL_CULLMODE_CW )
						--self.Dummy:DrawModel()
						rag:DrawModel()
						render.CullMode( MATERIAL_CULLMODE_CCW )
						
					render.ModelMaterialOverride( )
					
					render.PopCustomClipPlane()
					render.PopCustomClipPlane()
					render.EnableClipping( false )
				end
				
				
				render.SetStencilEnable( true )
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
				render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
				
				render.SetStencilReferenceValue( 1 )
				
				
				if not self.MeatAng and not self.MeatPos then
					
					local meat_ang = ( normal * -1 ):Angle()
					meat_ang:RotateAroundAxis( meat_ang:Right(), -90 )
				
					local mpos, mang = WorldToLocal( pos, meat_ang, self:GetPos(), self:GetAngles())
					
					self.MeatAng = mang
					self.MeatPos = mpos
				end
				
				local meat_pos, meat_ang = LocalToWorld( self.MeatPos, self.MeatAng, self:GetPos(), self:GetAngles())
				
				--render.OverrideDepthEnable( true, true )
				
				cam.Start3D2D( meat_pos, meat_ang, 1 )
					surface.SetMaterial( meat3 )
					surface.SetDrawColor( meat_col )
					surface.DrawTexturedRectRotated( 0, 0, 80, 80, 0 ) 
				cam.End3D2D()
				
				--render.OverrideDepthEnable( false )
				
				render.SetStencilEnable( false )
				
				
				
				local ang = (normal*-1):Angle()
				ang.p = ang.p + 90
				
				local rnd = ang:Right() * math.Rand(-2,2) + ang:Forward() * math.Rand(-2,2)
				
				--if self.Dummy and self.Dummy:IsValid() then
				--	self.Dummy:SetPos( pos + rnd )
				--	self.Dummy:SetAngles( ang )
				--end
				
				
				if not self.Particle then
					local ang = (normal*-1):Angle()
					ang.p = ang.p + 90
					
					//ParticleEffect("dd_blood_big1",pos,ang,self.Entity)
					--ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
						
									
					if self.MakeSecondPart then
						for i = 1, math.random(2,4) do
						
							local ent = ClientsideModel( Gibs[ math.random( #Gibs ) ], RENDERGROUP_OPAQUE)
							if ent:IsValid() then
								ent:SetMaterial("models/flesh")
								ent:SetModelScale(math.Rand(0.8, 1.5), 0)
								ent:SetPos(pos+VectorRand()*4)
								ent:PhysicsInitBox(minbound, maxbound)
								ent:SetCollisionBounds(minbound, maxbound)

								local phys = ent:GetPhysicsObject()
								if phys:IsValid() then
									phys:SetMaterial("zombieflesh")
									phys:SetVelocityInstantaneous(VectorRand()*4)
									phys:AddAngleVelocity(VectorRand() * 10)
								end

								SafeRemoveEntityDelayed(ent, math.Rand(6, 10))
							end
							
							/*local effectdata = EffectData()
							effectdata:SetOrigin( pos+VectorRand()*4 )
							effectdata:SetNormal( ang:Up() )
							effectdata:SetMagnitude(60)
							effectdata:SetRadius( 0 )
							util.Effect( "gib", effectdata )*/
							
						end
					end
					
					self.Particle = true
				end
				
				self.NextDrip = self.NextDrip or 0
						
				if self.NextDrip <= ct and MySelf:EyePos():DistToSqr( pos ) < 250000 then
					self.NextDrip = ct + 0.055
					local emitter = ParticleEmitter( self:GetPos() )	
					if emitter then
						local delta = math.max(0, self.BleedOut - ct)
						if 0 < delta then
							emitter:SetPos(pos + rnd*3)
									
							for i=1, math.random(1, 3) do
								local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
								local force = math.Rand(165, 400)//math.min(1.5, delta) * math.Rand(65, 200)
										
								particle:SetVelocity(force * ang:Up() + VectorRand()*20)
								particle:SetDieTime(math.Rand(2.25, 3))
								particle:SetStartAlpha(0)
								particle:SetEndAlpha(0)
								particle:SetStartSize(15)
								particle:SetEndSize(15)
								particle:SetRoll(math.Rand(0, 360))
								particle:SetRollDelta(math.Rand(-40, 40))
								particle:SetColor(255, 0, 0)
								particle:SetAirResistance(5)
								particle:SetBounce(0)
								particle:SetGravity(vec_grav)
								particle:SetCollide(true)
								particle:SetCollideCallback(CollideCallbackSmall)
								particle:SetLighting(true)
								particle.StartVelocity = particle:GetVelocity()
								particle.Hits = 0
								//particle.MaxHits = math.random(3,5)
							end
									
						end	
						emitter:Finish() emitter = nil collectgarbage("step", 64)
					end
				end
	end
	
	
end