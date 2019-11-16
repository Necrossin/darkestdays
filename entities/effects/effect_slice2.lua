local string_Replace = string.Replace
local vector_origin = vector_origin

local skeleton = Model( "models/player/skeleton.mdl" )
local skeleton_bloody = Material( "models/skeleton/skeleton_bloody" )
local flesh = Material( "models/flesh" )
local zombie = Model( "models/player/zombie_fast.mdl" )

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

local fleshy_bones = {
	[ "ValveBiped.Bip01_Head1"] = false,
	[ "ValveBiped.Bip01_Neck1"] = false,
	[ "ValveBiped.Bip01_Pelvis"] = true,
	[ "ValveBiped.Bip01_Spine"] = true,
	[ "ValveBiped.Bip01_Spine1"] = true,
	[ "ValveBiped.Bip01_Spine2"] = true,
	[ "ValveBiped.Bip01_Spine4"] = true,
	[ "ValveBiped.Bip01_R_Thigh"] = false,
	[ "ValveBiped.Bip01_L_Thigh"] = false,
	[ "ValveBiped.Bip01_L_Clavicle"] = true,
	[ "ValveBiped.Bip01_R_Clavicle"] = true,
}

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

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
end


function EFFECT:GetNiceModel( str )
	return string_Replace( str, "models/models/", "models/" ) 
end

function EFFECT:GetHighestParent( ent, bone, tbl, prev_bone )
	
	if bone == 0 then
		
		local spine4 = ent:LookupBone( "ValveBiped.Bip01_Spine4" )
		local spine2 = ent:LookupBone( "ValveBiped.Bip01_Spine2" )
		local spine1 = ent:LookupBone( "ValveBiped.Bip01_Spine1" )
		local spine = ent:LookupBone( "ValveBiped.Bip01_Spine" )
		
		/*if spine4 and tbl[ spine4 ] and spine2 then
			return spine2, true
		end
		
		if spine2 and tbl[ spine2 ] and spine1 then
			return spine1, true
		end
		
		if spine1 and tbl[ spine1 ] and spine then
			return spine, true
		end
		
		if spine and tbl[ spine ] then
			return 0, true
		end*/
		
		/*if spine4 and tbl[ spine4 ] then
			return spine4, true
		end
		
		if spine2 and tbl[ spine2 ] then
			return spine2, true
		end
		
		if spine1 and tbl[ spine1 ] then
			return spine1, true
		end
		
		if spine and tbl[ spine ] then
			return spine, true
		end*/
		
	end
	
	local parent = ent:GetBoneParent( bone )
	if parent and parent ~= -1 then
		if tbl[ parent ] then
			return self:GetHighestParent( ent, parent, tbl, bone )
		end
		
		return parent, false
	end
	
	
	
	return bone, bone == 0
end

function EFFECT:Init( data )

	self.ent = data:GetEntity()
	
	self.MakeSecondPart = math.Round(data:GetRadius()) == 1
	
	if !IsValid( self.ent ) then return end
	if !IsValid( self.ent:GetRagdollEntity() ) then return end
	
	if GAMEMODE:GetGametype() == "ffa" then
		local col = self.ent:GetPlayerColor()
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
	
	self.IsThug = math.Round(data:GetMagnitude()) == 1
	
	self.SplatterScale = math.Rand(2, 4)
	
	self.Up = math.ceil(data:GetScale())
	
	self.Origin.z = self.Up
	
	self.BleedOut = CurTime() + 2.2
	
	self:SetModel( self:GetNiceModel( self.ent:GetModel() ) )
	
	if IsValid( self.ent:GetRagdollEntity() ) then
		local emitter = ParticleEmitter(self.ent:GetRagdollEntity():GetPos())	
		for i=0, 25, 4 do
			local bone = self.ent:GetRagdollEntity():GetBoneMatrix(i)
			if bone and emitter then
				local pos = bone:GetTranslation()
				local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
				particle:SetVelocity(VectorRand() * 46)
				particle:SetDieTime(2)
				particle:SetStartAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(2)
				particle:SetRoll(180)
				particle:SetColor(255, 0, 0)
				particle:SetLighting(true)
				particle:SetCollide(true)
				particle:SetAirResistance(12)
				particle:SetGravity( vector_up * - 400 )
				particle:SetCollideCallback(CollideCallbackSmall)
			end	
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	
	
	self:CreateRagdoll()

end

function EFFECT:CreateRagdoll()
	
	self.ShrinkToTable1 = {}
	self.ShrinkToTable2 = {}
	
	self.FinalBones1 = {}
	self.FinalBones2 = {}
	
	self.FleshyParts = {}
	
	self.ShrinkBones = {}
	self.ShrinkBones.Names = {}
	
	self.ShrinkBones.Ragdoll1 = {} // ragdoll entity
	self.ShrinkBones.Ragdoll2 = {} // clientside ent
	
	self.ClipPlaneData = {}
	
	local rag = self.ent:GetRagdollEntity()
	
	self.Ragdoll = rag:BecomeRagdollOnClient()
	self.Ragdoll:SetOwner( self.ent )
	self.Ragdoll.RenderOverride = function( s ) end
	rag:SetNoDraw( true )
	self.Ragdoll.OverrideRagdollOwner = true
	self.Ragdoll.InverseBones = true
	
	if GAMEMODE:GetGametype() == "ffa" then
		local col = self.ent:GetPlayerColor()
		self.Ragdoll.GetPlayerColor = function() return Vector( col.x, col.y, col.z ) end
	else
		local col = team.GetColor( self.ent:Team() )
		self.Ragdoll.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
	end
	
	local dist = 99999
	local closest_bone
	
	self.ShrinkTo = nil
	
	local closest = {}
	local count = 1
	
	local rag_count_1 = 0
	local rag_count_2 = 0
	
	
	for k = 0, self.ent:GetBoneCount() - 1 do
					
		local rag_bone = rag:LookupBone( self.ent:GetBoneName( k ) )
		
		if rag_bone then
		
			local pos, ang
			local m = rag:GetBoneMatrix( rag_bone )
			if m then
				pos, ang = m:GetTranslation(), m:GetAngles()
			else
				pos, ang = rag:GetBonePosition( rag_bone )
			end
			
			if pos and ang then
				
				local dist_sqr = pos:DistToSqr( self.Origin )
				
				//local save_pos, save_ang = WorldToLocal( self.Origin, self.Normal:Angle(), pos, ang )
				
				//self.ClipPlaneData[ k ] = { SavePos = save_pos, SaveAng = save_ang }

				if self.Normal:Dot( pos - self.Origin ) > 0 and dist_sqr > 0 then 
					self.ShrinkBones.Ragdoll1[ k ] = true
					//self.ClipPlaneData[ k ].InverseNormal = true
					continue 
				end
				
				self.ShrinkBones.Ragdoll2[ k ] = true
				
			end
		end

	end
	
	local second_count = 0
	
	for k, v in pairs( self.ShrinkBones.Ragdoll2 ) do
		second_count = second_count + 1
	end
	
	if second_count < 1 then
			
			self.ShrinkBones.Ragdoll1 = {}
			
			self.Origin = self.Origin - vector_up * 20
			
			for k = 0, self.ent:GetBoneCount() - 1 do
						
			local rag_bone = rag:LookupBone( self.ent:GetBoneName( k ) )
			
			if rag_bone then
			
				local pos, ang
				local m = rag:GetBoneMatrix( rag_bone )
				if m then
					pos, ang = m:GetTranslation(), m:GetAngles()
				else
					pos, ang = rag:GetBonePosition( rag_bone )
				end
				
				if pos and ang then
					
					local dist_sqr = pos:DistToSqr( self.Origin )

					if self.Normal:Dot( pos - self.Origin ) > 0 and dist_sqr > 0 then 
						self.ShrinkBones.Ragdoll1[ k ] = true
						//self.ClipPlaneData[ k ].InverseNormal = true
						continue 
					end
					
					self.ShrinkBones.Ragdoll2[ k ] = true
					
				end
			end

		end
		
	end
	

	

	local count_parent = {}
	
	for k, v in pairs ( self.ShrinkBones.Ragdoll1 ) do
		local parent, limb = self:GetHighestParent( rag, k, self.ShrinkBones.Ragdoll1 )
				
		if limb then
			for _, children in pairs( rag:GetChildBones( k ) ) do
				self.ShrinkToTable1[ children ] = rag:GetChildBones( k )[ 1 ]
			end
		end

		
		if not self.FinalBones1[ parent ] then
			self.FinalBones1[ parent ] = {}
			//print(rag:GetBoneName( parent ))
		end
		
	
		
		count_parent[ parent ] = ( count_parent[ parent ] or 0 ) + 1
		
		self.FinalBones1[ parent ][ k ] = true

	end
	
	for k, v in pairs( count_parent ) do
		if self.FinalBones1[ k ] and v < 2 then
			//print( "Removing   "..k )
			//self.FinalBones1[ k ] = nil
		end
	end
	
	//PrintTable( self.ShrinkToTable1 )
	
	print"Final bones 1 ---------"
	PrintTable( self.FinalBones1 )
	
	local count_parent = {}
	
	for k, v in pairs ( self.ShrinkBones.Ragdoll2 ) do
		local parent, limb = self:GetHighestParent( rag, k, self.ShrinkBones.Ragdoll2 )
				
		if limb then
			for _, children in pairs( rag:GetChildBones( k ) ) do
				self.ShrinkToTable2[ children ] = rag:GetChildBones( k )[ 1 ]
			end
		end

		if not self.FinalBones2[ parent ] then
			self.FinalBones2[ parent ] = {}
			//print(rag:GetBoneName( parent ))
		end
		
		count_parent[ parent ] = ( count_parent[ parent ] or 0 ) + 1
		
		self.FinalBones2[ parent ][ k ] = true
	end
	
	for k, v in pairs( count_parent ) do
		if self.FinalBones2[ k ] and v < 2 then
			//print( "Removing   "..k )
			//self.FinalBones2[ k ] = nil
		end
	end
		
	print"Final bones 2 ---------"
	PrintTable( self.FinalBones2 )
	
	self:MakeBodyParts()
	
	self:MakeBuildBonePositions()
	
	
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

// shrink down stuff that needs to be... uh... shrinked down
local function BodyPartBBP( ent, bonecount )
	
	if ent.ShrinkTo and ent.BoneTable then

		
		if ent.BoneCountTable then
		
			for i = 1, #ent.BoneCountTable do
				
				local k = ent.BoneCountTable[ i ]
				
				local m = E_GetBoneMatrix( ent, k )
				local m_shrinkto
					
				if ent.ShrinkToTable and ent.ShrinkToTable[ k ] then
					m_shrinkto = E_GetBoneMatrix( ent, ent.ShrinkToTable[ k ] )
				else
					if ent.ShrinkTo then
						m_shrinkto = E_GetBoneMatrix( ent, ent.ShrinkTo )
					end
				end
									
				if m then
					if ent.ShrinkTo ~= k then 
						VM_SetScale( m, vector_origin )
					end
					if m_shrinkto then
						VM_SetTranslation( m, VM_GetTranslation( m_shrinkto ) )
					end
					E_SetBoneMatrix( ent, k, m )
				end
				
			end
		
		else
			
			ent.BoneCountTable = {}
			
			for k = 0, bonecount do 
				
				if ent.BoneTable[ k ] then
				
				else
					local m = E_GetBoneMatrix( ent, k )
					local m_shrinkto
					
					if ent.ShrinkToTable and ent.ShrinkToTable[ k ] then
						m_shrinkto = E_GetBoneMatrix( ent, ent.ShrinkToTable[ k ] )
					else
						if ent.ShrinkTo then
							m_shrinkto = E_GetBoneMatrix( ent, ent.ShrinkTo )
						end
					end
									
					if m then
						if ent.ShrinkTo ~= k then 
							VM_SetScale( m, vector_origin )
						end
						if m_shrinkto then
							VM_SetTranslation( m, VM_GetTranslation( m_shrinkto ) )
						end
						E_SetBoneMatrix( ent, k, m )
					end
					
					ent.BoneCountTable[ #ent.BoneCountTable + 1 ] = k
					
				end
			
			end
			
			PrintTable( ent.BoneCountTable )
			
		end
		
	end
	
end

// these will act as a part that gets the clip plane treatment and stuff
local vec_1_1 = Vector( 1.03, 1.03, 1.03 )
local vec_1_9 = Vector( 1.9, 1.9, 1.9 )
local function BodyPartBBP2( ent, bonecount )
	
	if ent.SolidBone then

		local m_shrinkto = E_GetBoneMatrix( ent, ent.SolidBone )
		local m_shrinkto2 = E_GetBoneMatrix( ent, ent.SolidBone2 )
	
		for k = 0, bonecount do 

			local m = E_GetBoneMatrix( ent, k )
				
			if m then
				if k == ent.SolidBone or k == ent.SolidBone2 then
					VM_SetScale( m, ent.IsThug and vec_1_9 or vec_1_1 )
				else
					VM_SetScale( m, vector_origin )
					if m_shrinkto then
						
						if m_shrinkto2 and VM_GetTranslation( m_shrinkto2 ) ~= vector_origin then
							local normal = ( VM_GetTranslation( m_shrinkto ) - VM_GetTranslation( m_shrinkto2 ) ):GetNormal()
							VM_SetTranslation( m, VM_GetTranslation( m_shrinkto ) + normal * 5 )
						else
							VM_SetTranslation( m, VM_GetTranslation( m_shrinkto ) )
						end
						//m:SetAngles( m_shrinkto:GetAngles( ))
					end
				end
				
				E_SetBoneMatrix( ent, k, m )
			end	
		end
		
	end

end

function EFFECT:MakeBodyParts()
	
	self.BodyParts = { [1] = {}, [2] = {} }
	
	self.RemoveCollisions1 = {}
	self.RemoveCollisions2 = {}
	
	local empty_1, empty_2 = true, true
	local count_1, count_2 = 0, 0
	
	for k, v in pairs( self.ShrinkToTable1 ) do
		count_1 = count_1 + 1
	end
	for k, v in pairs( self.ShrinkToTable2 ) do
		count_2 = count_2 + 1
	end
	
	empty_1 = count_1 < 1
	empty_2 = count_2 < 1
		
	local rag = self.ent:GetRagdollEntity()
	
	// sliced parts 1
	for k, v in pairs( self.FinalBones1 ) do
				
		local part = ClientsideModel( self:GetModel(), RENDERGROUP_BOTH )
		
		if part:IsValid() then
			
			part:SetPos( self:GetPos() )
			part:SetAngles( self:GetAngles() )
			part:SetParent( rag )
			part:AddEffects( EF_BONEMERGE )
			part:SetCollisionGroup( COLLISION_GROUP_NONE )
			part:SetMoveType( MOVETYPE_NONE )
			part.ShrinkTo = #rag:GetChildBones( k ) > 0 and rag:GetChildBones( k )[ 1 ] or k
			part.ShrinkToTable = self.ShrinkToTable1
			part.BoneTable = v
			if empty_1 and fleshy_bones[ rag:GetBoneName( part.ShrinkTo ) ] then
				self.FleshyParts[ part.ShrinkTo ] = true
			end
			
			if empty_1 then
				self.RemoveCollisions1[ k ] = true
				//self.RemoveCollisions[ part.ShrinkTo ] = true
			end
			
			part:SetNoDraw( true )
			
			part:AddCallback( "BuildBonePositions", BodyPartBBP )
			
			self.BodyParts[ 1 ][ #self.BodyParts[ 1 ] + 1 ] = part
		end
		
	end
	
	// sliced parts 2
	for k, v in pairs( self.FinalBones2 ) do
		
		local part = ClientsideModel( self:GetModel(), RENDERGROUP_BOTH )
		
		if part:IsValid() then
			
			part:SetPos( self:GetPos() )
			part:SetAngles( self:GetAngles() )
			part:SetParent( self.Ragdoll )
			part:AddEffects( EF_BONEMERGE )
			part:SetCollisionGroup( COLLISION_GROUP_NONE )
			part:SetMoveType( MOVETYPE_NONE )
			part.ShrinkTo = #self.Ragdoll:GetChildBones( k ) > 0 and self.Ragdoll:GetChildBones( k )[ 1 ] or k
			part.ShrinkToTable = self.ShrinkToTable2
			part.BoneTable = v
			
			if empty_2 and fleshy_bones[ rag:GetBoneName( part.ShrinkTo ) ] then
				self.FleshyParts[ part.ShrinkTo ] = true
			end
			
			if empty_2 then
				self.RemoveCollisions2[ k ] = true
				//self.RemoveCollisions[ part.ShrinkTo ] = true
			end
			
			part:SetNoDraw( true )
			
			part:AddCallback( "BuildBonePositions", BodyPartBBP )
			
			self.BodyParts[ 2 ][ #self.BodyParts[ 2 ] + 1 ] = part
		end
		
	end
	
	print"////////"
	//PrintTable( self.RemoveCollisions1 )
	
	self.FleshyPartsReference = {}
	
	for k, v in pairs( self.FleshyParts ) do

	
		local part2 = ClientsideModel( self:GetModel(), RENDERGROUP_BOTH )
		
		if part2:IsValid() then
			
			part2:SetPos( self:GetPos() )
			part2:SetAngles( self:GetAngles() )
			part2:SetParent( rag )
			part2:AddEffects( EF_BONEMERGE )
			part2:SetCollisionGroup( COLLISION_GROUP_NONE )
			part2:SetMoveType( MOVETYPE_NONE )
			part2.SolidBone = k	
			part2.FleshBit = true
			part2.IsThug = self.IsThug
			
			//print("fleshy part 1  "..rag:GetBoneName( k ))
			
			//part2:SetMaterial( "models/flesh" )
			
			part2.SolidBone2 = rag:GetBoneParent( k )
			
			part2:SetNoDraw( true )
			
			part2:AddCallback( "BuildBonePositions", BodyPartBBP2 )
			
			self.BodyParts[ 1 ][ #self.BodyParts[ 1 ] + 1 ] = part2
			self.FleshyPartsReference[ #self.FleshyPartsReference + 1 ] = part2
		end
		
		local part2 = ClientsideModel( self:GetModel(), RENDERGROUP_BOTH )
		
		if part2:IsValid() then
			
			part2:SetPos( self:GetPos() )
			part2:SetAngles( self:GetAngles() )
			part2:SetParent( self.Ragdoll )
			part2:AddEffects( EF_BONEMERGE )
			part2:SetCollisionGroup( COLLISION_GROUP_NONE )
			part2:SetMoveType( MOVETYPE_NONE )
			part2.SolidBone = k
			part2.FleshBit = true
			part2.IsThug = self.IsThug
			
			//print("fleshy part 2  "..rag:GetBoneName( k ))
			//part2:SetMaterial( "models/flesh" )
						
			part2.SolidBone2 = self.Ragdoll:GetBoneParent( k )
			
			
			part2:SetNoDraw( true )
			
			part2:AddCallback( "BuildBonePositions", BodyPartBBP2 )
			
			self.BodyParts[ 2 ][ #self.BodyParts[ 2 ] + 1 ] = part2
			self.FleshyPartsReference[ #self.FleshyPartsReference + 1 ] = part2
		end
	
	end
	
	for i=1, 2 do 
		local tbl = self.BodyParts[i]
		for k, v in pairs( tbl ) do
			if IsValid( v ) then
				
				if GAMEMODE:GetGametype() == "ffa" then
					local col = self.ent:GetPlayerColor()
					v.GetPlayerColor = function() return Vector( col.x, col.y, col.z ) end
				else
					local col = team.GetColor( self.ent:Team() )
					v.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
				end
				
			end
		end
	end
		
	for i = 0, rag:GetPhysicsObjectCount() - 1 do
		local phys = rag:GetPhysicsObjectNum(i)
		if IsValid( phys ) then
			if self.RemoveCollisions1[ rag:TranslatePhysBoneToBone(i) ] and not self.ShrinkBones.Ragdoll1[ rag:TranslatePhysBoneToBone(i) ] or not self.ShrinkBones.Ragdoll1[ rag:TranslatePhysBoneToBone(i) ] and not self.FinalBones1[ rag:TranslatePhysBoneToBone(i) ] then
				phys:EnableGravity( 5 )
				phys:EnableCollisions( false )
			else
				phys:SetMass( phys:GetMass() * 25 )
			end
			phys:Wake()
			phys:SetMaterial("zombieflesh")
			phys:SetVelocity( self.Normal:GetNormal() * 200 + VectorRand() * 10 )
		end
	end
	
	for i = 0, self.Ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = self.Ragdoll:GetPhysicsObjectNum(i)
		if IsValid( phys ) then
			if self.RemoveCollisions2[ rag:TranslatePhysBoneToBone(i) ] and not self.ShrinkBones.Ragdoll2[ rag:TranslatePhysBoneToBone(i) ] or not self.ShrinkBones.Ragdoll2[ self.Ragdoll:TranslatePhysBoneToBone(i) ] and not self.FinalBones2[ self.Ragdoll:TranslatePhysBoneToBone(i) ]  then
				phys:SetMass( 5 )
				phys:EnableCollisions( false )
			else
				phys:SetMass( phys:GetMass() * 25 )
			end
			phys:Wake()
			phys:SetMaterial("zombieflesh")
			phys:SetVelocity( self.Normal:GetNormal() * -200 + VectorRand() * 10 )
		end
	end
	
	

end

function EFFECT:BuildBoneTable()
	
	
	
end

function EFFECT:BuildBonePositions( ent, bonecount )
	
	for k, v in pairs( bones ) do
		local bone = ent:LookupBone( k )
		if (!bone) then continue end
		
		local m = ent:GetBoneMatrix( bone )
		if m then
			
			m:Translate( v.pos )
			m:Rotate( v.angle )
			m:Scale( v.scale )
		
			ent:SetBoneMatrix( bone, m )
		end
	end
	
	self.DoneThugRag1 = true
	
end

function EFFECT:MakeBuildBonePositions()

	local rag = self.ent:GetRagdollEntity()
	if self.IsThug then
		rag:AddCallback("BuildBonePositions", function( ent, bones ) self:BuildBonePositions( ent, bones ) end)
		self.Ragdoll:AddCallback("BuildBonePositions", function( ent, bones ) self:BuildBonePositions( ent, bones ) end)
	end

end

function EFFECT:Think( )
	
	if IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity()) then
		if not self.Frozen then
			for i = 1, self.ent:GetRagdollEntity():GetPhysicsObjectCount() do
				local bone = self.ent:GetRagdollEntity():GetPhysicsObjectNum(i)
				if bone and bone.IsValid and bone:IsValid() then
					//bone:EnableMotion(false)
				end
			end
			self.Frozen = true
		end		
	else
		if self.BodyParts then
			if self.BodyParts[ 1 ] then
				for k, v in pairs( self.BodyParts[ 1 ] ) do
					if IsValid( v ) then
						SafeRemoveEntity( v )
					end
				end
			end
			if self.BodyParts[ 2 ] then
				for k, v in pairs( self.BodyParts[ 2 ] ) do
					if IsValid( v ) then
						SafeRemoveEntity( v )
					end
				end
			end
		end
		if IsValid( self.Ragdoll ) then
			SafeRemoveEntity( self.Ragdoll )
		end
	end

	return IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity())
end

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
local meat_col = Color(135,5,5,255)

function EFFECT:Render()
	
	/*local rag = IsValid( self.ent ) and IsValid( self.ent:GetRagdollEntity() ) and self.ent:GetRagdollEntity()
	
	if rag then
		if self.IsThug and not self.DoneThugRag1 then
			for k, v in pairs( bones ) do
				local bone = rag:LookupBone(k)
				if (!bone) then continue end
				rag:ManipulateBoneScale( bone, v.scale  )
				rag:ManipulateBoneAngles( bone, v.angle  )
				rag:ManipulateBonePosition( bone, v.pos  )
				end
			self.DoneThugRag1 = true
		end
	end
	
	if self.Ragdoll and IsValid( self.Ragdoll ) then
		
		if self.IsThug and not self.DoneThugRag2 then
			for k, v in pairs( bones ) do
				local bone = self.Ragdoll:LookupBone(k)
				if (!bone) then continue end
				self.Ragdoll:ManipulateBoneScale( bone, v.scale  )
				self.Ragdoll:ManipulateBoneAngles( bone, v.angle  )
				self.Ragdoll:ManipulateBonePosition( bone, v.pos  )
				end
			self.DoneThugRag2 = true
		end
		
	end*/
	
	if not self.Particle and self.Origin then
		//ParticleEffect("dd_blood_big1", self.Origin, self.Entity:GetAngles(), self.Entity)
		//CreateParticleSystem( self.Ragdoll, "dd_blood_gib_trail", PATTACH_ABSORIGIN_FOLLOW, 0 )
		self.Particle = true
	end
	
	if self.BodyParts then
		
		blood_overlay:SetFloat( "$detailscale", self.SplatterScale or 2 )
		
		for i=1, 2 do 
		
			local tbl = self.BodyParts[i]
			
			for k, v in pairs( tbl ) do
				if IsValid( v ) then
					
					if v.FleshBit then
					
						v:SetModel( zombie )
				
						render.ModelMaterialOverride( flesh )
							v:DrawModel()
						render.ModelMaterialOverride(  )
					
						v:SetModel( self:GetModel() )
					
						render.ModelMaterialOverride( flesh )
							v:DrawModel()
						render.ModelMaterialOverride(  )
						
						if not v.Particle then
							v.Particle = CreateParticleSystem( v, "dd_blood_gib_trail", PATTACH_ABSORIGIN_FOLLOW, 0 ) 
						end
					
					else
						
						v:SetModel( self:GetModel() )
						
						v:DrawModel()
						
						render.ModelMaterialOverride( blood_overlay )
						render.SetColorModulation(0.5, 0, 0)
							v:DrawModel()
						render.SetColorModulation(1, 1, 1)
						render.ModelMaterialOverride(  )
					
					end
					
				end
			end
		end
		
	end
	
	if self.FleshyPartsReference then
		
		for k, v in pairs( self.FleshyPartsReference ) do
			
			if IsValid( v ) then
				
				//v:SetModel( self:GetModel() )
				
				//render.ModelMaterialOverride( flesh )
				//	v:DrawModel()
				//render.ModelMaterialOverride(  )
				
				/*if v.SolidBone and self.ClipPlaneData and self.ClipPlaneData[ v.SolidBone ] then
				
					local tbl = self.ClipPlaneData[ v.SolidBone ]
					
					local v_pos, v_ang
					local m = v:GetBoneMatrix( v.SolidBone )
					if m then
						v_pos, v_ang = m:GetTranslation(), m:GetAngles()
					else
						v_pos, v_ang = v:GetBonePosition( v.SolidBone )
					end
					
					if v_pos and v_ang then
					
						local pos, ang = LocalToWorld( tbl.SavePos, tbl.SaveAng, v_pos, v_ang )
						
						if pos and ang then
							local normal = ang:Forward() * -1
							
							if tbl.InverseNormal then normal = normal * -1 end
							
							local distance = normal:Dot( pos )
							
							
							if not v.MeatAng and not v.MeatPos then
					
								local meat_ang = ( normal * -1 ):Angle()
								meat_ang:RotateAroundAxis( meat_ang:Right(), -90 )
							
								local mpos, mang = WorldToLocal( pos, meat_ang, v_pos, v_ang)
								
								v.MeatAng = mang
								v.MeatPos = mpos
							end
							
							local meat_pos, meat_ang = LocalToWorld( v.MeatPos, v.MeatAng, v_pos, v_ang )
							
							//render.ClearStencil()
							//render.SetStencilEnable( true )
					
							render.EnableClipping( true )
							render.PushCustomClipPlane( normal, distance )
							
							//render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
							//render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
							//render.SetStencilZFailOperation( STENCILOPERATION_REPLACE ) -- STENCILOPERATION_KEEP
							//render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
							//render.SetStencilReferenceValue( 1 )
						
							//render.CullMode( MATERIAL_CULLMODE_CW )
							//render.ModelMaterialOverride( flesh )
							//	v:DrawModel()
							//render.ModelMaterialOverride(  )
							//render.CullMode( MATERIAL_CULLMODE_CCW )
							
						
							//render.SetStencilReferenceValue( 2 )
							//render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
							//render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
						
							v:SetModel( zombie )
						
							//render.ModelMaterialOverride( flesh )
								v:DrawModel()
							//render.ModelMaterialOverride(  )
							
							render.PopCustomClipPlane()
							render.EnableClipping( false )
							
							//render.SetStencilEnable( false )
							
							render.SetStencilEnable( true )
							render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
							render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
							render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
							render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
							
							render.SetStencilReferenceValue( 1 )
							
							cam.Start3D2D( meat_pos, meat_ang, 1 )
								surface.SetMaterial( meat3 )
								surface.SetDrawColor( meat_col )
								surface.DrawTexturedRectRotated( 0, 0, 80, 80, 0 ) 
							cam.End3D2D()
							
							render.SetStencilEnable( false )
							
						end
					
					end
				
				end*/
				
				
				/*v:SetModel( self:GetModel() )
				
				render.ModelMaterialOverride( flesh )
					v:DrawModel()
				render.ModelMaterialOverride(  )
				
				v:SetModel( zombie )
				
				render.ModelMaterialOverride( flesh )
					v:DrawModel()
				render.ModelMaterialOverride(  )*/
				
				
				//v:SetModel( self:GetModel() )
				
				//if v.SavePos then
					
				
					/*local pos = v:LocalToWorld( v.SavePos )
				
					local normal1 = v:LocalToWorld( v.NormalPos1 )
					local normal2 = v:LocalToWorld( v.NormalPos2 )
					
					local normal = ( normal2 - normal1 ):GetNormalized()
					
					if v.InverseNormal then
						normal = normal * -1
					end
					
					local distance = normal:Dot( pos )
					
					render.EnableClipping( true )
					render.PushCustomClipPlane( normal, distance )*/
					
					//render.ModelMaterialOverride( flesh )
					//v:DrawModel()
					//render.ModelMaterialOverride(  )
					
					//render.PopCustomClipPlane()
					//render.EnableClipping( false )
				
				//end
				
				/*v:SetModel( zombie )
				
				render.ModelMaterialOverride( flesh )
				v:DrawModel()
				render.ModelMaterialOverride(  )*/

			end
			
		end
		
	end

end