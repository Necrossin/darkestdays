local skeleton = Model( "models/player/skeleton.mdl" )
local zombie = Model( "models/player/zombie_fast.mdl" )//"models/gibs/fast_zombie_legs.mdl"
local bloody = Material( "models/skeleton/skeleton_bloody" )
local flesh = Material("models/flesh")

local gibsound1 = Sound( "physics/gore/bodysplat.wav" )
local gibsound2 = Sound( "physics/gore/bodysplat2.wav" )
local gibsound3 = Sound( "physics/gore/dismemberment.wav" )

local blood_overlay = CreateMaterial( "dd_ragdoll_blood", 
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

local HitGroupToBone = {
	[HITGROUP_HEAD] = { base = "ValveBiped.Bip01_Spine4", pos_from = "ValveBiped.Bip01_Head1"},
	[HITGROUP_RIGHTARM] = { base = "ValveBiped.Bip01_Spine4", pos_from = "ValveBiped.Bip01_R_UpperArm"},
	[HITGROUP_LEFTARM] = { base = "ValveBiped.Bip01_Spine4", pos_from = "ValveBiped.Bip01_L_UpperArm"},
	[HITGROUP_RIGHTLEG] = { base = "ValveBiped.Bip01_Pelvis", pos_from = "ValveBiped.Bip01_R_Thigh"},
	[HITGROUP_LEFTLEG] = { base = "ValveBiped.Bip01_Pelvis", pos_from = "ValveBiped.Bip01_L_Thigh"},
}

function EFFECT:Init( data )

	self.ent = data:GetEntity()
		
	if !IsValid(self.ent) then return end	
	self.HitBox = data:GetHitBox()--math.Round( data:GetScale() )
	self.Bone = self.ent:GetHitBoxBone( self.HitBox, 0 )
	self.HitGroup = math.Round( data:GetScale() )
	
	self.SplatterScale = math.Rand(2, 4)
	
	if not self.Bone then
		self.Bone = self.ent:GetHitBoxBone( self.HitBox, 1 ) //check this one as well
	end
	
	if GAMEMODE:GetGametype() == "ffa" then
		local col = self.ent:GetPlayerColor()
		self.GetPlayerColor = function() return Vector( col.x, col.y, col.z ) end
	else
		local col = team.GetColor( self.ent:Team() )
		self.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
	end
	
	if not self.Bone then return end		
	--if string.find( self.BoneName, "Head" ) then
		--self.HeadShot = true
	--end
	self.Origin = data:GetStart()
	self.Normal = data:GetNormal()
	self.Angles = self.Normal:Angle()
	self.IsThug = math.Round(data:GetMagnitude()) == 1	
	
	self.HoleType = math.Round( data:GetRadius() ) or 2
	
	
	if self.HoleType ~= 3 then
		if self.HeadShot then
			--self.Origin = self.Origin + self.Normal * 4
		else
			--self.Origin = self.Origin + self.Normal * 12 //9
		end
	else
		self.Origin = self.Origin + self.Normal * 1.5
		sound.Play(gibsound1,self.Origin,70, math.random(90,110), 0.4)
		sound.Play(gibsound3,self.Origin,70, math.random(90,110), 0.5)
	end
	
	self.BoneName = self.ent:GetBoneName( self.Bone )
	--print"------"
	--print("def bone ", self.BoneName)
	--print("hitgroup ", self.HitGroup)
	
	local rag = self.ent:GetRagdollEntity()
	
	if IsValid( rag ) then
		rag:SetNoDraw( true )
		rag:SetRenderMode( RENDERMODE_NONE )

		if HitGroupToBone[self.HitGroup] then
			self.BoneName = HitGroupToBone[self.HitGroup].base
			--print("new bone ", self.BoneName)
			if HitGroupToBone[self.HitGroup].pos_from then
				local bone = rag:LookupBone( HitGroupToBone[self.HitGroup].pos_from )
				if bone then
					local pos, ang = rag:GetBonePosition( bone )
					if pos and ang then
						local dist = self.Origin:Distance( pos )
						--local norm = ( self.Origin - pos ):GetNormal()
						if dist >= 25 then
							self.Origin = pos + VectorRand() * 2
						else
							self.Origin = ( pos + self.Origin ) / 2 ---self.Origin - norm * dist / 2
						end
					end
				end
			end
		end
		
	end
	
	self.Dummy = ClientsideModel( "models/props_junk/PopCan01a.mdl", RENDER_GROUP_OPAQUE_ENTITY )
	if self.Dummy then
		self.Dummy:SetPos( self:GetPos() )
		self.Dummy:SetAngles( self:GetAngles() )
		self.Dummy:SetParent( self )
		self.Dummy:SetNoDraw( true )
	else
		self.Dummy = nil
	end
	
	self.DieTime = CurTime() + 2
	
	if MySelf:EyePos():Distance( self.Origin ) < 90 then
		AddBloodSplat( 3 )
		AddBloodSplat( 3 )
		AddBloodSplat( 3 )
	end
	
	//ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
	
	//self:SetModel( "models/props_junk/garbage_bag001a.mdl" )//"models/props_junk/PopCan01a.mdl"

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
		
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		
	else
		//SafeRemoveEntity(self.Dummy)
	end
	
	if self.Dummy and self.Dummy:IsValid() then
		if self.DieTime and self.DieTime < CurTime() then
			self.Dummy:StopParticleEmission() 
		end
	end
	
	if IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity()) then
		return true
	else
		if self.Dummy and self.Dummy:IsValid() then
			SafeRemoveEntity( self.Dummy )
		end
		return false
	end

	//return IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity())
end

local mat = Material( "editor/wireframe" )

function EFFECT:DrawMesh( ragdoll )
	
	self.vert = self.vert or {}
	
	if mask then
		local bone = ragdoll:LookupBone("ValveBiped.Bip01_Spine2")
		local phys_bone = ragdoll:TranslateBoneToPhysBone( bone ) 
		local phys = ragdoll:GetPhysicsObjectNum(phys_bone)	
		
		if not self.BuiltHole then
			
			self.vert = phys:GetMesh()
			self.Hole = Mesh()
			
			self.Hole:BuildFromTriangles( self.vert )
			
	
		
			//PrintTable(phys:GetMeshConvexes())
			//for _,c in ipairs(phys:GetMeshConvexes()) do
				
				/*local cvx = {}
				for _,p in ipairs(c) do
					cvx[#cvx+1] = pos
				end*/
			//end
			self.BuiltHole = true
		
		end
		
		if self.Hole then
			//render.SetMaterial( mat )
			self.Hole:Draw()
		end
		
	else
	
	end
	
end

// 1 - small pistols/smgs, 2 - rifles, 3 - shotguns and magnum

EFFECT.HoleModels = {
	[1] = Model( "models/props_junk/garbage_bag001a.mdl" ),
	[2] = Model( "models/props_junk/garbage_bag001a.mdl" ),//"models/props_junk/PopCan01a.mdl"models/props_junk/garbage_glassbottle002a.mdl
	--[3] = Model( "models/props_junk/garbage_bag001a.mdl" ),
	[3] = Model( "models/gibs/antlion_gib_large_3.mdl" ),


}

function EFFECT:Hole( pos, ang, scale )

	scale = scale or Vector( 1, 1, 1 )
	
	if self.HoleType == 1 then
		
		if not self.Scale then
			self.Scale = Vector( 0.5, math.Rand( 0.3, 0.4 ), math.Rand( 0.2, 0.3 ) )
		end
		
		local m = Matrix()
		m:Scale( self.Scale * scale )
		self:EnableMatrix("RenderMultiply", m)

		self.Entity:SetPos( pos )
		ang:RotateAroundAxis( ang:Up(), 180 )
		self.Entity:SetAngles( ang )
		
		
	elseif self.HoleType == 2 then
	
		if not self.Scale then
			self.Scale = Vector( 0.6, math.Rand( 0.7, 0.8 ) ,math.Rand( 0.7, 0.8 ))
		end
		
		local m = Matrix()
		m:Scale( self.Scale * scale )
		self:EnableMatrix("RenderMultiply", m)

		self.Entity:SetPos( pos )
		ang:RotateAroundAxis( ang:Up(), 180 )
		self.Entity:SetAngles( ang )
		
	elseif self.HoleType == 3 then
		
		if not self.Scale then
			--self.Scale = Vector( math.Rand( 1, 1.6 ), math.Rand( 1, 1.6 ), 1.8)
			local rand = math.Rand( 0.3, 0.6 )
			self.Scale = Vector( math.Rand( 0.4, 0.6 ), math.Rand( 0.9, 1.1 ), math.Rand( 0.4, 0.6 ))
		end
		
		if not self.RandomAng then
			self.RandomAng = math.random( -10, 10 )
		end
		
		if not self.RandomAng2 then
			self.RandomAng2 = math.random( 40, 90 )
		end
		
		local m = Matrix()
		m:Scale( self.Scale * scale )
		self:EnableMatrix("RenderMultiply", m)

		self.Entity:SetPos( pos )
		--ang:RotateAroundAxis( ang:Up(), 180 )
		ang:RotateAroundAxis( ang:Right(), self.RandomAng )
		--ang:RotateAroundAxis( ang:Forward(), self.RandomAng2 )
		ang:RotateAroundAxis( ang:Up(), self.RandomAng2 )
		--ang:RotateAroundAxis( ang:Right(), self.RandomAng )
		self.Entity:SetAngles( ang )
		
	end

end

function EFFECT:DrawHoles( ragdoll, mask, blend, scale )

	scale = scale or Vector( 1, 1, 1 )
	
	if self.IsThug then
		scale = scale * 1.5
	end
	
	self:SetModel( self.HoleModels[ self.HoleType or 1 ] )//"models/props_junk/garbage_bag001a.mdl""models/props_junk/PopCan01a.mdl"
	//self:SetupBones()
	
	local bone = ragdoll:LookupBone( self.BoneName )//"ValveBiped.Bip01_Spine2"
	
	if not self.Offset or not self.AngOffset then
		if bone and self.ent and self.ent:IsValid() then
			local pos, ang = self.ent:GetBonePosition(bone)
			if pos and ang then

				local pos2, ang2 = WorldToLocal( self.Origin, self.Angles, pos, ang)
				self.Offset = pos2
				self.AngOffset = ang2
				
				--if self.HeadShot then
				--	self.Offset = self.Offset - self.Normal:Angle():Right() * 4
				--end
					
				if pos:DistToSqr( self.Origin ) > 900 then --30^2
					self.Offset = VectorRand() * 3
				end
					
			end
		end
	end
				
	if bone and self.Offset and self.AngOffset then
		local pos, ang = ragdoll:GetBonePosition(bone)
		if pos and ang then
			
			local pos2, ang2 = LocalToWorld( self.Offset, self.AngOffset, pos, ang)
			
			//self.Entity:SetPos(pos2)
			//ang:RotateAroundAxis( ang:Up(), 90 )
			//self.Entity:SetAngles(ang2)

			//self:SetModelScale( 1.2, 0 )
			
			self:Hole( pos2, ang2, scale )
			
			//hole
			if mask then
				
				if blend then render.SetBlend(0) end
				--self:SetupBones()
				self:DrawModel()
				if blend then render.SetBlend(1) end	

			//inside stuff
			else
				render.ModelMaterialOverride( flesh )
				render.CullMode( MATERIAL_CULLMODE_CW )
				render.SuppressEngineLighting( true ) 
				--self:SetupBones()
				self:DrawModel()
				render.SuppressEngineLighting( false ) 
				render.CullMode( MATERIAL_CULLMODE_CCW )
				render.ModelMaterialOverride( )
				
				if self.Dummy and self.Dummy:IsValid() then
					local hole_pos = self:LocalToWorld( self:OBBCenter() )
					self.Dummy:SetPos( hole_pos )
					self.Dummy:SetAngles( ang )
				end
			end			
		end
	end
end



function EFFECT:DrawSpook( ragdoll )
	
	
	--self:SetupBones()
	self:SetModel( skeleton )
	//self:SetupBones()

	self:SetParent( ragdoll )
	self:AddEffects( EF_BONEMERGE )
	
	self:SetModelScale( 1, 0 )
	render.ModelMaterialOverride( bloody )
	self:DrawModel()
	render.ModelMaterialOverride( )
	
	//self:SetupBones()
	//self:SetModel( 	zombie )
		
	//render.ModelMaterialOverride( flesh )
	//self:DrawModel()
	//render.ModelMaterialOverride( )
	
	self:SetParent()
	self:RemoveEffects( EF_BONEMERGE )
	
	
end

function EFFECT:DrawInsides( ragdoll )

	/*self:SetModel( zombie )
	
	self:SetModelScale( 1, 0 )
	render.ModelMaterialOverride( flesh )
	
	render.CullMode( MATERIAL_CULLMODE_CW )
	self:SetupBones()
	self:DrawModel()
	render.CullMode( MATERIAL_CULLMODE_CCW )
	
	self:SetupBones()
	self:DrawModel()
	render.ModelMaterialOverride( )
	
	self:SetParent()
	self:RemoveEffects( EF_BONEMERGE )*/
	
	self:SetModel( ragdoll:GetModel() )
	//self:SetupBones()

	self:SetParent( ragdoll )
	self:AddEffects( EF_BONEMERGE )
	
	self:SetModelScale( 1, 0 )
	render.ModelMaterialOverride( flesh )
	
	render.CullMode( MATERIAL_CULLMODE_CW )
	--self:SetupBones()
	self:DrawModel()
	render.CullMode( MATERIAL_CULLMODE_CCW )
	
	--self:SetupBones()
	self:DrawModel()
	render.ModelMaterialOverride( )
		
end

function EFFECT:DrawRagdollAlternate( ragdoll, setup )
	
	self:SetModel( ragdoll:GetModel() )
	
	if setup then
		//self:SetupBones()
	end
	
	self:SetParent( ragdoll )
	self:AddEffects( EF_BONEMERGE )
	
	//self:SetModelScale( 1, 0 )
	
	self:DrawModel()
	
	self:SetParent()
	self:RemoveEffects( EF_BONEMERGE )
	
	
	self:SetModel( "models/gibs/antlion_gib_large_3.mdl" )
	
end


local vec_small = Vector( 0.75, 0.75, 0.75 )
local vec_smaller = Vector( 0.45, 0.45, 0.45 )
local vec_06 = Vector( 0.6, 0.6, 0.6 )

local maxbound = Vector(5, 5, 5)
local minbound = maxbound * -1

local function gib_callback( self, data )
	
	local hitpos = data.HitPos
	local hitnormal = data.HitNormal
	
	self.Decal = self.Decal or 0
	
	if self.BigDecal and self.Decal < 1  then
		util.Decal("BloodHuge"..math.random(5), hitpos + hitnormal, hitpos - hitnormal)
	else
		if self.Decal < 5 then
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
	end
	
	self.Decal = self.Decal + 1
	
end

function EFFECT:Render()
	
	local ragdoll = self.ent and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	if IsValid( ragdoll ) and self.BoneName then
	
		local should_draw = EyePos():DistToSqr( ragdoll:GetPos() ) < 40000 --200^2
		
		if not self.ChangedOverride then
			ragdoll.RenderOverride = function( s ) end
			self.ChangedOverride = true
		end
		
		ragdoll:RemoveAllDecals()
		
		self:SetModel( "models/gibs/antlion_gib_large_3.mdl" )
		
		//self:SetupBones()
		
		ragdoll.HandleDraw = self
		
		//insides
		render.ClearStencil()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)

			render.SetStencilReferenceValue(8)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
			render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
			
			//render.OverrideDepthEnable( true, true )
			self:DrawHoles( ragdoll, true, false )
			//render.OverrideDepthEnable( false )
				

			render.SetStencilReferenceValue(8)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
			render.SetStencilPassOperation(STENCILOPERATION_KEEP)
			render.SetStencilFailOperation(STENCILOPERATION_ZERO)
			
			self:DrawHoles( ragdoll, true, true, vec_06 )
			
			render.SetStencilReferenceValue(8)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
			
			self:DrawInsides( ragdoll )
			
		render.SetStencilEnable(false)
		
		//skeleton + insides
		render.ClearStencil()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			
			render.SetStencilReferenceValue(10)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
			
			self:DrawHoles( ragdoll, true, true )
			
			render.SetStencilReferenceValue(9)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_LESS)
			
			self:DrawHoles( ragdoll, true, true, vec_smaller )
						
			render.SetStencilReferenceValue(10)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
			
			
			if should_draw then
				self:DrawSpook( ragdoll )
			end
			
			
			
		render.SetStencilEnable(false)
		
		
		render.ClearStencil()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
					
			render.SetStencilReferenceValue(4)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
						
			render.SetBlend(0)
	
			render.OverrideDepthEnable( true, true )
			
			render.CullMode( MATERIAL_CULLMODE_CW )
				//ragdoll:SetupBones()
				//ragdoll:DrawModel()	
				self:DrawRagdollAlternate( ragdoll, true )
			render.CullMode( MATERIAL_CULLMODE_CCW )
			
			render.OverrideDepthEnable( false, false )
			render.SetBlend(1)

			render.SetStencilReferenceValue(4)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			
			render.OverrideDepthEnable( false, true )
			self:DrawHoles( ragdoll, false, false )
			render.OverrideDepthEnable( false, false )
			
			
		//render.SetStencilEnable(false)
		
		-------------------------------
		
		//render.ClearStencil()
		//render.SetStencilEnable(true)
			//render.SetStencilWriteMask(255)
			//render.SetStencilTestMask(255)
			
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

			render.SetBlend(0)
			render.OverrideDepthEnable( true, true )
			render.SetStencilReferenceValue(3)
			//ragdoll:DrawModel()
			self:DrawRagdollAlternate( ragdoll )
			
			render.OverrideDepthEnable( false, false )
			render.SetBlend(1)
			
			
			
			//cut the hole
			render.SetStencilReferenceValue(2)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_LESS)

			self:DrawHoles( ragdoll, true, true )
			
			
			render.SetStencilReferenceValue(3)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SetStencilFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			
			render.CullMode( MATERIAL_CULLMODE_CW )
				render.ModelMaterialOverride( flesh )
				self:DrawRagdollAlternate( ragdoll )
				//ragdoll:DrawModel()	
				render.ModelMaterialOverride(  )
			render.CullMode( MATERIAL_CULLMODE_CCW )
			
			self:DrawRagdollAlternate( ragdoll )
			//ragdoll:DrawModel()
			
			blood_overlay:SetFloat( "$detailscale", self.SplatterScale or 2 )
			
			render.ModelMaterialOverride( blood_overlay )
			render.SetColorModulation(0.5, 0, 0)
				self:DrawRagdollAlternate( ragdoll, true )
				//ragdoll:DrawModel()
			render.SetColorModulation(1, 1, 1)
			render.ModelMaterialOverride(  )
			
			
			
		render.SetStencilEnable(false)
		
		if not self.Particle and self.HoleType ~= 1 then
			if self.Dummy and self.Dummy:IsValid() then
				//self.Effect = self.Dummy:CreateParticleEffect( "dd_blood_gib_trail", 0, { attachtype = PATTACH_ABSORIGIN_FOLLOW, entity = self.Dummy } )
				ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Dummy,0)
				
				if self.HoleType == 3 then
					ParticleEffect("dd_blood_big_gibsplash",self.Dummy:GetPos(),self.Normal:Angle(),nil)
				end
				
				if self.HoleType == 3 then
					for i = 1, math.random(3,5) do
						
						local ent = ClientsideModel( Gibs[ math.random( #Gibs ) ], RENDERGROUP_OPAQUE)
						if ent:IsValid() then
							ent:SetMaterial("models/flesh")
							ent:SetModelScale(math.Rand(0.8, 1.5), 0)
							ent:SetPos(self:GetPos() + VectorRand() * 2)
							ent:PhysicsInitBox(minbound, maxbound)
							ent:SetCollisionBounds(minbound, maxbound)
							
							ent:AddCallback( "PhysicsCollide", gib_callback )

							local phys = ent:GetPhysicsObject()
							if phys:IsValid() then
								phys:SetMaterial("bloodyflesh")
								phys:SetVelocityInstantaneous(( self.Normal or self:GetAngles():Forward()) * math.random( 50, 105 ))
								phys:AddAngleVelocity(VectorRand() * 10)
							end

							SafeRemoveEntityDelayed(ent, math.Rand(6, 10))
						end
						
						
						/*local effectdata = EffectData()
						effectdata:SetOrigin( self:GetPos() + VectorRand() * 2 )
						effectdata:SetNormal( ( self.Normal or self:GetAngles():Forward()) + VectorRand() * 0.1 )
						effectdata:SetMagnitude(math.random(50,105))
						effectdata:SetScale( self.HoleType == 3 and 0 or 1 )
						effectdata:SetRadius( 0 )
						util.Effect( "gib", effectdata )*/
						
					end
				end
				
				self.Particle = true
			end
		end

		
		
	end
	
end