local math = math
local util = util

local gibsound = Sound( "physics/gore/bodysplat.wav" )

local NextEffect = 0

local function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		--util.Decal(math.random(3) == 3 and "BloodHuge"..math.random(5) or "Blood", hitpos + hitnormal, hitpos - hitnormal)
		util.Decal(particle.Frozen and "PaintSplatBlue" or "Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
end

local function gib_callback( self, data )
	
	local hitpos = data.HitPos
	local hitnormal = data.HitNormal
	
	self.Decal = self.Decal or 0
	
	if self.Frozen then
		if self.Decal < 3 then
			util.Decal("PaintSplatBlue", hitpos + hitnormal, hitpos - hitnormal)
		end
	else	
		if self.BigDecal and self.Decal < 1  then
			util.Decal("BloodHuge"..math.random(5), hitpos + hitnormal, hitpos - hitnormal)
		else
			if self.Decal < 5 then
				util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
			end
		end
	end
	
	
	self.Decal = self.Decal + 1
	
end

local bounds = Vector(128, 128, 128)
local collision_bounds = Vector( 5, 5, 5 )
function EFFECT:Init( data )
	local ent = data:GetEntity()
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	local frozen = math.Round(data:GetScale())
	self.Frozen = frozen == 1 
	
	self.Entity:SetRenderBounds( bounds * -1, bounds )
	
	if ent.GetRagdollEntity and IsValid(ent:GetRagdollEntity()) then
		ent:GetRagdollEntity().Gibbed = true
	end
	
	/*if frozen == 1 then
		if ent then
			--ParticleEffectAttach("frozen_death",PATTACH_ABSORIGIN_FOLLOW,ent,0)
			//ParticleEffect("frozen_death",Pos,Angle(0,0,0),ent)
			sound.Play("physics/glass/glass_sheet_break"..math.random(1,3)..".wav",Pos,90, 100, 1)
			
			if IsValid(ent:GetRagdollEntity()) then
				ent:GetRagdollEntity().Gibbed = true
				ent:GetRagdollEntity():SetColor(Color(0, 0, 0, 0))//SafeRemoveEntity(ent:GetRagdollEntity())
				ent:GetRagdollEntity():SetRenderMode(RENDERMODE_TRANSALPHA)
			end
		end
		return
	end*/
	
	//if CurTime() < NextEffect then return end
	//NextEffect = CurTime() + 0.1
	
	if ent:IsPlayer() then
		//if ent.GetRagdollEntity and ent:GetRagdollEntity():IsValid() then
		//	ent = ent:GetRagdollEntity()
		//end
		if IsValid(ent:GetRagdollEntity()) then
			ent = ent:GetRagdollEntity()
			ent.Gibbed = true
		end
		
		for i = 1, #PlayerGibs do
			local bone = ent:LookupBone( PlayerGibs[i].bone )
			local power = i == 1 and math.random(80,120) or math.random(90,140)
			if bone then
				local pos, ang = ent:GetBonePosition( bone )
				if pos and ang then
					
					local gib_normal = ((ent.GetShootPos and ent:GetShootPos() or ent:LocalToWorld( ent:OBBCenter() )) - pos):GetNormal() + VectorRand() * 0.2 + Normal

					local gib = ClientsideModel(PlayerGibs[ i ].model, RENDERGROUP_OPAQUE)
					local ph = SOLID_VPHYSICS
					
					if gib:IsValid() then
						gib.Frozen = self.Frozen
						gib:SetMaterial( self.Frozen and "models/shiny" or "models/flesh" )
						
						if PlayerGibs[ i ] and PlayerGibs[ i ].scale then
							gib:SetModelScale( PlayerGibs[ i ].scale, 0 )
						end
						gib:SetPos(pos + ( PlayerGibs[i].offset or VectorRand() * 3 ))
						gib:SetAngles( ang + ( PlayerGibs[i].angle or Angle( 0, 0, 0 ) ) )
						
						if PlayerGibs[ i ] and PlayerGibs[ i ].bbox then
							gib:PhysicsInitBox( PlayerGibs[ i ].bbox[1], PlayerGibs[ i ].bbox[2] ) 
							gib:SetCollisionBounds( PlayerGibs[ i ].bbox[1], PlayerGibs[ i ].bbox[2] )
						else
							gib:PhysicsInitBox( collision_bounds * -1, collision_bounds )
							gib:SetCollisionBounds( collision_bounds * -1, collision_bounds )
							//gib:PhysicsInit( ph )
						end
						if PlayerGibs[ i ] and PlayerGibs[ i ].big_decal then
							gib.BigDecal = true
						end
						
						gib:AddCallback( "PhysicsCollide", gib_callback )

						gib:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
						gib:SetMoveType(MOVETYPE_VPHYSICS)
						
						if PlayerGibs[ i ] and PlayerGibs[ i ].scaledown then
							for k, v  in pairs( PlayerGibs[ i ].scaledown ) do
								local bone = gib:LookupBone( v )
								if bone then
									gib:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
									gib:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
									gib:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
								end
							end
						end
						
						if PlayerGibs[ i ] and PlayerGibs[ i ].scale_all_but then
							for i2 = 0, gib:GetBoneCount() - 1 do
								if table.HasValue(PlayerGibs[ i ].scale_all_but,i2) then continue end
								gib:ManipulateBoneScale( i2, Vector( 0, 0, 0 ) )
								gib:ManipulateBoneScale( i2, Vector( 0, 0, 0 ) )
								gib:ManipulateBoneScale( i2, Vector( 0, 0, 0 ) )
							end
						end
						
						--ent:PhysicsInitBox(minbound, maxbound)
						--ent:SetCollisionBounds(minbound, maxbound)

						local normal
						
						local phys = gib:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetMaterial( self.Frozen and "glass" or "bloodyflesh")
							phys:SetVelocityInstantaneous( gib_normal * power * 2 + VectorRand() * math.random(-power/2,power/2) + vector_up *  math.random( power/2, power ) )
						end
						
						if i == 1 then
							if self.Frozen then
								ParticleEffectAttach("winterblast_projectile",PATTACH_ABSORIGIN_FOLLOW,gib,0)
							else
								ParticleEffectAttach("dd_blood_gib_trail",PATTACH_ABSORIGIN_FOLLOW,gib,0)
							end
						end

						SafeRemoveEntityDelayed(gib, math.Rand(6, 10))
					end
					
					
					/*local effectdata = EffectData()
						effectdata:SetOrigin( pos + ( PlayerGibs[i].offset or VectorRand() * 3 ) ) 
						effectdata:SetAngles( ang + ( PlayerGibs[i].angle or Angle( 0, 0, 0 ) ) )
						effectdata:SetNormal( ((ent.GetShootPos and ent:GetShootPos() or ent:LocalToWorld( ent:OBBCenter() )) - pos):GetNormal() + VectorRand() * 0.2 + Normal )
						effectdata:SetMagnitude( i == 1 and math.random(80,120) or math.random(90,140))
						effectdata:SetRadius( i )
					util.Effect( "gib", effectdata )*/
				end
			end
		end
	
	else
		
		local power = math.random(120,170)
	
		for i = 1, math.random(6,13) do
		
			local gib_normal = Normal+vector_up*0.5

			local gib = ClientsideModel(Gibs[ math.random( #Gibs )], RENDERGROUP_OPAQUE)
			local ph = SOLID_VPHYSICS
					
			if gib:IsValid() then
					
				gib:SetMaterial("models/flesh")
				gib:SetModelScale(math.Rand(2,2.3),0)
				gib:SetPos(Pos + i * Vector(0,0,6) + VectorRand() * 3)
				gib:SetAngles( VectorRand():Angle() )
				
				//gib:PhysicsInit( ph )
				gib:PhysicsInitBox( collision_bounds * -1, collision_bounds )
				gib:SetCollisionBounds( collision_bounds * -1, collision_bounds )
						
				gib:AddCallback( "PhysicsCollide", gib_callback )

				gib:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
				gib:SetMoveType(MOVETYPE_VPHYSICS)
						
				
				local phys = gib:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetMaterial("bloodyflesh")
					phys:SetVelocityInstantaneous( gib_normal * power * 2 + VectorRand() * power/2 + vector_up *  math.random( power/4, power/2 ) )
				end

				SafeRemoveEntityDelayed(gib, math.Rand(6, 10))
			end
		
			/*local effectdata = EffectData()
				effectdata:SetOrigin( Pos + i * Vector(0,0,6) + VectorRand() * 3 )
				effectdata:SetNormal( Normal+vector_up*0.5 )
				effectdata:SetMagnitude(math.random(70,170))
				effectdata:SetScale( 2 )
				effectdata:SetRadius( 0 )
			util.Effect( "gib", effectdata )*/
		end
	
	end
	
	
	--self.Emitter = ParticleEmitter(self.Entity:GetPos())
	local emitter = ParticleEmitter( self.Entity:GetPos() )

	for i=1, math.random(9,13) do
		local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), Pos+Vector(0,0,10)+Vector(0,0,4)*i+VectorRand()*9)//"decals/Blood"..math.random(1,8)
		particle:SetVelocity(VectorRand()*math.random(-460,460)+Vector(0,0,-10)*math.Rand(0.1,1))
		particle:SetDieTime(math.Rand(4,6))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(5,11))
		particle:SetEndSize(math.random(3,14))
		particle:SetRoll(math.Rand(0,3))
		particle:SetRollDelta(math.Rand(0,0.5))
		particle:SetColor(math.random(100,255), 0, 0)
		particle:SetLighting(true)
		particle:SetCollide(true)
		particle:SetAirResistance(1)
		particle:SetGravity(vector_up*-400)
		particle.Frozen = self.Frozen
		particle:SetCollideCallback(CollideCallback)
	end
	
	emitter:Finish() emitter = nil collectgarbage("step", 64)
	
	if self.Frozen then
		ParticleEffect("frozen_death",Pos+vector_up*math.random(20,30),Angle(0,0,0),nil)
	else
		ParticleEffect("dd_blood_big_gibsplash",Pos+vector_up*math.random(20,30),Angle(0,0,0),nil)
	end
	
	if IsValid(ent) then
		if self.Frozen then
			sound.Play("physics/glass/glass_sheet_break"..math.random(3)..".wav",ent:GetPos(),90, 100, 1)
		else
			sound.Play(gibsound,ent:GetPos(),70, math.random(90,110), 1)	
		end
	end
	
	if MySelf:EyePos():DistToSqr( Pos ) < 8100 then
		AddBloodSplat( 3 )
		AddBloodSplat( 3 )
		AddBloodSplat( 3 )
		MySelf:AddBloodyStuff()		
	end
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
