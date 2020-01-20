EFFECT.BoneCountToRemove = 3

local string_Replace = string.Replace
local vector_origin = vector_origin

local slicesound = Sound( "physics/gore/bodysplat2.wav" )
local slicesound2 = Sound( "physics/gore/dismemberment.wav" )

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
				local particle = emitter:Add( "Decals/flesh/Blood"..math.random(1,5), pos )
				particle:SetVelocity( VectorRand() * 46 )
				particle:SetDieTime( 2 )
				particle:SetStartAlpha( 0 )
				particle:SetStartSize( 2 )
				particle:SetEndSize( 2 )
				particle:SetRoll( 180 )
				particle:SetColor( 255, 0, 0 )
				particle:SetLighting( true )
				particle:SetCollide( true)
				particle:SetAirResistance( 12 )
				particle:SetGravity( vector_up * - 400 )
				particle:SetCollideCallback( CollideCallbackSmall )
			end	
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	sound.Play( slicesound, self.Origin, 75, math.random( 100, 120 ), 1 )
	self:EmitSound( slicesound2, 100, math.random( 100, 120 ) )
	
	self:CreateRagdoll()

end

function EFFECT:CreateRagdoll()
	
	self.ShrinkToTable1 = {}
	self.ShrinkToTable2 = {}
	
	self.FinalBones1 = {}
	self.FinalBones2 = {}
	
	self.FleshyParts = {}
	self.FleshyPartsSimple = {}
	
	self.ShrinkBones = {}
	self.ShrinkBones.Names = {}
	
	self.ShrinkBones.Ragdoll1 = {} // ragdoll entity
	self.ShrinkBones.Ragdoll2 = {} // clientside ent
	
	self.ObsoleteBones = {}
	
	self.ClipPlaneData = {}
	
	local rag = self.ent:GetRagdollEntity()
	
	self.Ragdoll = rag:BecomeRagdollOnClient()
	self.Ragdoll:SetOwner( self.ent )
	self.Ragdoll:SetPos( rag:GetPos() )
	self.Ragdoll:SetAngles( rag:GetAngles() )
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
		
	
		if !string.find( rag:GetBoneName( k ), "Finger" ) then
			count_parent[ parent ] = ( count_parent[ parent ] or 0 ) + 1
		end
		
		self.FinalBones1[ parent ][ k ] = true

	end
	
	for k, v in pairs( count_parent ) do
		if self.FinalBones1[ k ] and v < self.BoneCountToRemove then
			//print( "Removing   "..k )
			for _, argh in pairs( self.FinalBones1[ k ] ) do
				self.ObsoleteBones[ _ ] = true
			end
			self.FinalBones1[ k ] = nil
		end
	end
	
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
		
		if !string.find( rag:GetBoneName( k ), "Finger" ) then
			count_parent[ parent ] = ( count_parent[ parent ] or 0 ) + 1
		end
		
		self.FinalBones2[ parent ][ k ] = true
	end
	
	for k, v in pairs( count_parent ) do
		if self.FinalBones2[ k ] and v < self.BoneCountToRemove then
			//print( "Removing   "..k )
			for _, argh in pairs( self.FinalBones2[ k ] ) do
				self.ObsoleteBones[ _ ] = true
			end
			self.FinalBones2[ k ] = nil
		end
	end

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
			
			//PrintTable( ent.BoneCountTable )
			
		end
		
	end
	
end


local vec_1_1 = Vector( 1.2, 1.02, 1.02 )
local vec_1_9 = Vector( 2.4, 1.9, 1.9 )
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
							VM_SetTranslation( m, VM_GetTranslation( m_shrinkto ) + normal * 6 )
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
				//self.FleshyPartsSimple[ part.ShrinkTo ] = true
			else
				self.FleshyPartsSimple[ part.ShrinkTo ] = true
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
				//self.FleshyPartsSimple[ part.ShrinkTo ] = true
			else
				self.FleshyPartsSimple[ part.ShrinkTo ] = true
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
	
	//print"////////"
	//PrintTable( self.FleshyPartsSimple )
	
	self.FleshyPartsReference = {}
	
	for k, v in pairs( self.FleshyParts ) do
		
		//bonemerged stuff
		
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
							
			part2.SolidBone2 = self.Ragdoll:GetBoneParent( k )

			part2:SetNoDraw( true )
				
			part2:AddCallback( "BuildBonePositions", BodyPartBBP2 )
				
			self.BodyParts[ 2 ][ #self.BodyParts[ 2 ] + 1 ] = part2
			self.FleshyPartsReference[ #self.FleshyPartsReference + 1 ] = part2
		end			
	
	end
	
	
	for k, v in pairs( self.FleshyPartsSimple ) do

		local invisible = fleshy_bones[ rag:GetBoneName( k ) ]
	
		if k == 0 then continue end
		if fleshy_bones[ rag:GetBoneName( k ) ] then continue end
		if self.ObsoleteBones[ k ] then continue end
		if string.find( rag:GetBoneName( k ), "arm" ) then continue end
		if string.find( rag:GetBoneName( k ), "Finger" ) then continue end
		if string.find( rag:GetBoneName( k ), "Hand" ) then continue end
				
		//if self.FinalBones1[ k ] or self.FinalBones2[ k ] then
		
			local part = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_BOTH )
				
			if part:IsValid() then
					
				part:SetPos( self:GetPos() )
				part:SetAngles( self:GetAngles() )
				//part:SetModelScale( math.Rand( 0.4, 0.5 ), 0 )
				part.Scale = Vector( math.Rand( 0.2, 0.4 ), math.Rand( 0.2, 0.3 ), math.Rand( 0.3, 0.5 ) )
				part.Scale = part.Scale * 1.2
				part:SetParent( rag )
				part:SetCollisionGroup( COLLISION_GROUP_NONE )
				part:SetMoveType( MOVETYPE_NONE )
				part.SolidBone = k	
				part.FleshBit = true
				part.SimpleFleshBit = true
				part.DoBlood = true
				if invisible then
					part.Invisible = true
				end
				
				//if not empty_1 then
					//part.SolidBoneParent = rag:GetBoneParent( k )
				//end
					
				part:SetNoDraw( true )
					
				self.BodyParts[ 1 ][ #self.BodyParts[ 1 ] + 1 ] = part
				self.FleshyPartsReference[ #self.FleshyPartsReference + 1 ] = part
			end
		//end
		
		//if self.FinalBones1[ k ] or self.FinalBones2[ k ] then
		
			local part = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_BOTH )
				
			if part:IsValid() then
										
				part:SetPos( self:GetPos() )
				part:SetAngles( self:GetAngles() )
				//part:SetModelScale( math.Rand( 0.4, 0.5 ), 0 )
				part.Scale = Vector( math.Rand( 0.2, 0.4 ), math.Rand( 0.2, 0.3 ), math.Rand( 0.3, 0.5 ) )
				part.Scale = part.Scale * 1.2
				part:SetParent( self.Ragdoll )
				part:SetCollisionGroup( COLLISION_GROUP_NONE )
				part:SetMoveType( MOVETYPE_NONE )
				part.SolidBone = k	
				part.FleshBit = true
				part.SimpleFleshBit = true
				part.InverseAngles = true
				if invisible then
					part.Invisible = true
				end
				//part.DoBlood = true

				part.SolidBoneParent = rag:GetBoneParent( k )
					
				part:SetNoDraw( true )
					
				self.BodyParts[ 2 ][ #self.BodyParts[ 2 ] + 1 ] = part
				self.FleshyPartsReference[ #self.FleshyPartsReference + 1 ] = part
			end
			
		//end
		
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
			phys:SetVelocity( phys:GetVelocity() + self.Normal:GetNormal() * 200 + VectorRand() * 10 )
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
			phys:SetVelocity( phys:GetVelocity() + self.Normal:GetNormal() * -200 + VectorRand() * 10 )
		end
	end

end


local function RagBuildBonePositions( ent, bonecount )

	if ent.ThugBoneBBP then
		
		for bone, v in pairs( ent.ThugBoneBBP ) do
		
			local m = ent:GetBoneMatrix( bone )
			if m then
				
				m:Translate( v.pos )
				m:Rotate( v.angle )
				m:Scale( v.scale )
			
				ent:SetBoneMatrix( bone, m )
			end
		end	
		
	else
	
		ent.ThugBoneBBP = {}
	
		for k, v in pairs( bones ) do
			local bone = ent:LookupBone( k )
			if (!bone) then continue end
			
			ent.ThugBoneBBP[ bone ] = { pos = v.pos, angle = v.angle, scale = v.scale }
			
			local m = ent:GetBoneMatrix( bone )
			if m then
				
				m:Translate( v.pos )
				m:Rotate( v.angle )
				m:Scale( v.scale )
			
				ent:SetBoneMatrix( bone, m )
			end
		end	
	end
end

function EFFECT:MakeBuildBonePositions()

	local rag = self.ent:GetRagdollEntity()
	if self.IsThug and RagBuildBonePositions then
		rag:AddCallback("BuildBonePositions", function( ent, bones ) RagBuildBonePositions( ent, bones ) end)
		self.Ragdoll:AddCallback("BuildBonePositions", function( ent, bones ) RagBuildBonePositions( ent, bones ) end)
	end

end

function EFFECT:Think( )
	
	local ent = self.ent
	local rag = ent and ent:IsValid() and ent:GetRagdollEntity()
	local fake_rag = self.Ragdoll
	
	if rag and rag:IsValid() then

	else
		local bodyparts = self.BodyParts
		if bodyparts then
			if bodyparts[ 1 ] then
				for k, v in pairs( bodyparts[ 1 ] ) do
					local gib = v
					if gib and gib:IsValid() then
						gib:Remove()
					end
				end
			end
			if bodyparts[ 2 ] then
				for k, v in pairs( bodyparts[ 2 ] ) do
					local gib = v
					if gib and gib:IsValid() then
						gib:Remove()
					end
				end
			end
		end
		
		if fake_rag and fake_rag:IsValid() then
			fake_rag:Remove()
			return false
			//SafeRemoveEntity( self.Ragdoll )
		end
	end

	return ent and ent:IsValid() and rag and rag:IsValid()
end


function EFFECT:Render()
		
	if self.BodyParts then
		
		blood_overlay:SetFloat( "$detailscale", self.SplatterScale or 2 )
		
		for i=1, 2 do 
		
			local tbl = self.BodyParts[i]
			
			for k, v in pairs( tbl ) do
				if IsValid( v ) then
					
					if v.FleshBit then
						
						local parent = IsValid( v:GetParent() ) and v:GetParent()
					
						if v.SimpleFleshBit and v.SolidBone and parent then
							
							local v_pos, v_ang
							local m = parent:GetBoneMatrix( v.SolidBone )
							if m then
								v_pos, v_ang = m:GetTranslation(), m:GetAngles()
							else
								v_pos, v_ang = parent:GetBonePosition( v.SolidBone )
							end
							
							if v_pos and v_ang then
								
								if v.SolidBoneParent then
									
									local v_pos2, v_ang2
									local m2 = parent:GetBoneMatrix( v.SolidBoneParent )
									if m2 then
										v_pos2, v_ang2 = m2:GetTranslation(), m2:GetAngles()
									else
										v_pos2, v_ang2 = parent:GetBonePosition( v.SolidBoneParent )
									end
									
									if v_ang2 then
										v_ang = v_ang2 * 1
									end
									
								end
								
								
								v:SetPos( v_pos )
								v:SetAngles( v_ang * ( v.InverseAngles and -1 or 1 ) )

							end
							
							if not v.Particle and v.DoBlood then
								v.Particle = CreateParticleSystem( v, "dd_blood_headshot_2", PATTACH_POINT_FOLLOW, 0 ) //"dd_blood_headshot_2"
							end
							
							
							if v.Scale then
								local m = Matrix()
								m:Scale( v.Scale )
								v:EnableMatrix( "RenderMultiply", m )
							end
							
							if v.Invisible then render.SetBlend( 0 ) end
							render.ModelMaterialOverride( flesh )
								v:DrawModel()
							render.ModelMaterialOverride(  )
							if v.Invisible then render.SetBlend( 1 ) end
						
						else
						
							/*v:SetModel( zombie )
							
							render.ModelMaterialOverride( flesh )
								v:DrawModel()
							render.ModelMaterialOverride(  )*/
							
							
							v:SetModel( self:GetModel() )
							
							render.ModelMaterialOverride( flesh )
								v:DrawModel()
							render.ModelMaterialOverride(  )
							
							if not self.Particle and self.Origin then
								ParticleEffect( "dd_blood_big_gibsplash", self.Origin, self.Normal:Angle(), self.Entity )
								self.Particle = true
							end
							
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
end