local dismemberment = Sound( "physics/gore/dismemberment.wav" )

local DismemberTable = {
	[HITGROUP_HEAD] = {"ValveBiped.Bip01_Head1"},
	[HITGROUP_LEFTARM] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger1",
							"ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger4","ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02",
							"ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger21","ValveBiped.Bip01_L_Finger22",
							"ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Ulna",
							"ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Elbow"

						},
	[HITGROUP_RIGHTARM] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger1",
							"ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger4","ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02",
							"ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger21","ValveBiped.Bip01_R_Finger22",
							"ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42", "ValveBiped.Bip01_R_Ulna",
							"ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow"
							},
	[HITGROUP_LEFTLEG] = {"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"},
	[HITGROUP_RIGHTLEG] = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"},
}

local random_dism = {}

for k,v in pairs(DismemberTable) do
	table.insert( random_dism, k )
end

function EFFECT:Init( data )
	self.ent = data:GetEntity()
	self.dism = math.Round(data:GetScale()) or 0
	self.DieTime = CurTime() + 5
	
	if self.dism == -1 then
		self.dism = random_dism[ math.random( #random_dism ) ]
	end
	
	self.IsThug = math.Round(data:GetMagnitude()) == 1
	
	self.Entity:SetModel("models/props_junk/PopCan01a.mdl")
	
	if IsValid(self.ent) then
		//sound.Play("physics/flesh/flesh_bloody_break.wav",self.ent:GetPos()+vector_up*60,100, 100, 1)
		
		//local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity() or self.ent
		
		//if rag then
			if self.dism == 1 then
				sound.Play("physics/gore/headshot"..math.random(1,3)..".wav",self.ent:GetPos()+vector_up*50,150,100,1)
			else
				sound.Play(dismemberment,self.ent:GetPos()+vector_up*50,150,100,1)
			end
		//end
		//self.Emitter = ParticleEmitter(self.ent:GetPos())	
		
		--self:StartDeath()
		
		if MySelf:EyePos():DistToSqr( self.ent:GetPos() ) < 8100 then
			//AddBloodSplat( 3 )
			//AddBloodSplat( 3 )
			MySelf:AddBloodyStuff()		
		end
		
	end
end

local deathbones = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_L_Upperarm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Upperarm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_L_Thigh",	
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
}

function EFFECT:StartDeath()
	
	self.SavePhys = {}
	
	local rag = IsValid(self.ent) and self.ent:GetRagdollEntity()
	
	if !IsValid( rag ) then return end
	
	for i=0,rag:GetPhysicsObjectCount()-1 do
		local phys = rag:GetPhysicsObjectNum(i)
		if phys then
			self.SavePhys[i] = {phys:GetSpeedDamping(), phys:GetRotDamping(), phys:GetMass()}				
			//phys:SetDamping(math.random(200,1200), math.random(100,2000))
			phys:SetMass(phys:GetMass() * math.Rand(1,60))
		end
	end
	
	self.StopDeathTime = CurTime() + math.Rand(0.3,0.8)
	
end

function EFFECT:StopDeath()
	
	local rag = IsValid(self.ent) and self.ent:GetRagdollEntity()
	
	if !IsValid( rag ) then return end
	
	for k,v in pairs(self.SavePhys or {}) do
		local phys = rag:GetPhysicsObjectNum(k)
		//phys:SetDamping(v[1], v[2])
		phys:SetMass(v[3])
	end
	
end

function EFFECT:Think( )
	
	if IsValid(self.ent) then
		//self.Entity:SetPos(self.ent:GetPos())
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		
		if self.StopDeathTime and self.StopDeathTime <= CurTime() then
			--self:StopDeath()
			self.StopDeathTime = nil
		end
		
		if CurTime() > ( self.DieTime - 2 ) then
			if self.BloodParticle then
				self.BloodParticle:StopEmission( false, false ) --StopEmissionAndDestroyImmediately() 
			end
		end
		
	end
	return CurTime() < self.DieTime or IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity())
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

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
	
		particle.HitAlready = true
		
		if math.random(1, 10) == 3 then
			WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
		end
		local rand = math.random(10)
		if rand ~= 1 then
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
		particle:SetDieTime(0)
	end	
end

local vector_zero = Vector( 0, 0, 0 )
local vector_tiny = Vector( 0.01, 0.01, 0.01 )

local function DoScaling( ent, bonecount )
	
	if ent.dism and DismemberTable[ent.dism] then
		
		if not ent.HideToBone then
            ent.HideToBone = ent:LookupBone( DismemberTable[ent.dism][1] )
        end
		
		if ent.HideToBone then
			local m_to = ent:GetBoneMatrix( ent.HideToBone )
            if m_to then 
				for _, bone_name in pairs( DismemberTable[ent.dism] ) do
					if _ == 1 then continue end
					
					local bone = ent:LookupBone( bone_name )
					
					if bone then
						local m1 = ent:GetBoneMatrix( bone )
						if m1 then
							m1:SetScale( vector_zero )
							m1:SetTranslation( m_to:GetTranslation() )
							ent:SetBoneMatrix( bone, m1 )
						end
					
						for k, v in pairs( ent:GetChildBones( bone ) ) do
							local m2 = ent:GetBoneMatrix( v )
							if m2 then
								m2:SetScale( vector_zero )
								m2:SetTranslation( m_to:GetTranslation() )
								ent:SetBoneMatrix( v, m2 )
							end
						end
					end
				end
				--if ent.dism ~= 1 then
					m_to:SetScale( vector_zero )
					ent:SetBoneMatrix( ent.HideToBone, m_to )
				--end
			end
		end
		
	end
	
end

local maxbound = Vector(3, 3, 3)
local minbound = maxbound * -1

function EFFECT:Render()


	local rag = IsValid(self.ent) and IsValid(self.ent:GetRagdollEntity()) and self.ent:GetRagdollEntity()
	
	if rag and IsValid(rag) then
	
		if self.dism and DismemberTable[self.dism] then
		
			local bone
			
			if not self.CachedBone then
				self.CachedBone = rag:LookupBone( DismemberTable[self.dism][1] )
			end
			
			bone = self.CachedBone

			
			if bone then	
				local pos, ang = rag:GetBonePosition(bone)

				self.Entity:SetPos(pos+ang:Forward()*3)
				self.Entity:SetAngles(ang)
			
				rag.dism = self.dism
			
				if not self.Done then
				

					rag:AddCallback( "BuildBonePositions", DoScaling )
				
					if self.dism == 1 then
						ParticleEffectAttach("dd_blood_headshot_2",PATTACH_POINT_FOLLOW,self.Entity,0)
						self.BloodParticle = CreateParticleSystem( self.Entity, "dd_blood_gib_trail", PATTACH_ABSORIGIN_FOLLOW, 0 ) 
						--ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
												
						-- tiny snippet from zs headshot effect 
						local norm = ang:Forward()
						for i=1, math.random(5, 8) do
							local dir = (norm * 2 + VectorRand()) / 3
							dir:Normalize()

							local ent = ClientsideModel("models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE)
							if ent:IsValid() then
								ent:SetMaterial("models/flesh")
								ent:SetModelScale(math.Rand(0.2, 0.5), 0)
								ent:SetPos(pos + dir * 6)
								ent:PhysicsInitBox(minbound, maxbound)
								ent:SetCollisionBounds(minbound, maxbound)

								local phys = ent:GetPhysicsObject()
								if phys:IsValid() then
									phys:SetMaterial("zombieflesh")
									phys:SetVelocityInstantaneous(dir * math.Rand(50, 300))
									phys:AddAngleVelocity(VectorRand() * 2000)
								end

								SafeRemoveEntityDelayed(ent, math.Rand(6, 10))
							end
						end
						
					else
						ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
					end
					self.Done = true
				end
				
				
				self.NextDrip = self.NextDrip or 0
						
				if self.NextDrip <= CurTime() then
					self.NextDrip = CurTime() + 0.045
					
					local emitter = ParticleEmitter(rag:GetPos())	
					if emitter then
						local delta = math.max(0, self.DieTime - CurTime() - 3)
						if 0 < delta then
							emitter:SetPos(pos)
									
							for i=1, math.random(1, 3) do
								local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
								local force = math.min(1.5, delta) * math.Rand(115, 200)
										
								particle:SetVelocity(force * ang:Forward() + 0.35 * force * VectorRand())
								particle:SetDieTime(math.Rand(2.25, 3))
								particle:SetStartAlpha(0)
								particle:SetEndAlpha(0)
								particle:SetStartSize(math.random(1, 8))
								particle:SetEndSize(0)
								particle:SetRoll(math.Rand(0, 360))
								particle:SetRollDelta(math.Rand(-40, 40))
								particle:SetColor(255, 0, 0)
								particle:SetAirResistance(5)
								particle:SetBounce(0)
								particle:SetGravity(Vector(0, 0, -600))
								particle:SetCollide(true)
								particle:SetCollideCallback(CollideCallbackSmall)
								particle:SetLighting(true)
							end
									
						end	
						emitter:Finish() emitter = nil collectgarbage("step", 64)
					end
				end
			end
						
			if !rag:IsPlayer() then
				if not rag.RemoveSuit then
					rag.RemoveSuit = true
				end
			end
			
			
			if self.IsThug then
				if not self.DoneThug then
					for k, v in pairs( bones ) do
						local bone = rag:LookupBone(k)
						if (!bone) then continue end
						if not table.HasValue(DismemberTable[self.dism],k) then
							rag:ManipulateBoneScale( bone, v.scale  )
						end
						rag:ManipulateBoneAngles( bone, v.angle  )
						rag:ManipulateBonePosition( bone, v.pos  )
					end
					self.DoneThug = true
				end
				
				if not rag.HandleDraw then
					rag.HandleDraw = self
				end
				if rag.HandleDraw and rag.HandleDraw == self then
					rag:DrawModel()
				end
				
			end
			
		end
	end
	
end


/*function EFFECT:Render()

	local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()// or self.ent
	
	if rag and IsValid(rag) then
		if self.dism and DismemberTable[self.dism] then
			
			for _,bonename in pairs(DismemberTable[self.dism]) do
				local bone = rag:LookupBone(bonename)
				if bone then	
					local pos, ang = rag:GetBonePosition(bone)
					if pos and ang then
						if _ == 1 then
							self.Entity:SetPos(pos+ang:Forward()*3)
							self.Entity:SetAngles(ang)
						end
						if not self.Done then
							if self.dism == 1 then
								ParticleEffectAttach("dd_blood_headshot_2",PATTACH_POINT_FOLLOW,rag,rag:LookupAttachment("eyes"))
								//ParticleEffectAttach("dd_blood_headshot_2",PATTACH_POINT_FOLLOW,self.Entity,0)
								ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
								for i = 1, math.random(4) do
									local effectdata = EffectData()
										effectdata:SetOrigin( pos + VectorRand() * 2 )
										effectdata:SetNormal( ang:Forward() )
										effectdata:SetMagnitude(math.random(70,110))
										effectdata:SetScale(1)
										effectdata:SetRadius( 0 )
									util.Effect( "gib", effectdata )
								end
							else
								ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
							end
							//ParticleEffectAttach("dd_blood_headshot_2",PATTACH_POINT_FOLLOW,rag,rag:LookupAttachment("eyes"))
							self.Done = true
						end
						self.NextDrip = self.NextDrip or 0
						
						if self.NextDrip <= CurTime() then
							self.NextDrip = CurTime() + 0.045
							self.Emitter = ParticleEmitter(rag:GetPos())	
							if self.Emitter then
								local delta = math.max(0, self.DieTime - CurTime())
								if 0 < delta then
									self.Emitter:SetPos(pos)
									
									for i=1, math.random(1, 3) do
										local particle = self.Emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
										local force = math.min(1.5, delta) * math.Rand(115, 200)
										
										particle:SetVelocity(force * ang:Forward() + 0.35 * force * VectorRand())
										particle:SetDieTime(math.Rand(2.25, 3))
										particle:SetStartAlpha(0)
										particle:SetEndAlpha(0)
										particle:SetStartSize(math.random(1, 8))
										particle:SetEndSize(0)
										particle:SetRoll(math.Rand(0, 360))
										particle:SetRollDelta(math.Rand(-40, 40))
										particle:SetColor(255, 0, 0)
										particle:SetAirResistance(5)
										particle:SetBounce(0)
										particle:SetGravity(Vector(0, 0, -600))
										particle:SetCollide(true)
										particle:SetCollideCallback(CollideCallbackSmall)
										particle:SetLighting(true)
									end
									
								end	
								self.Emitter:Finish()
							end
						end
						
						if !rag:IsPlayer() then
							rag:ManipulateBoneScale( bone, Vector(0, 0, 0) )	
							if not rag.RemoveSuit then
								rag.RemoveSuit = true
							end
						end
					end	
				end
			end
			
			if self.IsThug then
				for k, v in pairs( bones ) do
					local bone = rag:LookupBone(k)
					if (!bone) then continue end
					if not table.HasValue(DismemberTable[self.dism],k) then
						rag:ManipulateBoneScale( bone, v.scale  )
					end
					rag:ManipulateBoneAngles( bone, v.angle  )
					rag:ManipulateBonePosition( bone, v.pos  )
				end
			end
			
		end
	end
	
end
*/