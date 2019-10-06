ENT.Name = "Teleportation"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 5

ENT.CastGesture = ACT_SIGNAL_HALT

local table = table
local util = util
local math = math

local math_sqrt = math.sqrt
local math_Clamp = math.Clamp
local math_Round = math.Round
local math_max = math.max
local math_ceil = math.ceil
local util_TraceHull = util.TraceHull

if SERVER then
	AddCSLuaFile("shared.lua")
end

for i=1,2 do
	util.PrecacheSound("npc/scanner/scanner_nearmiss"..i..".wav")
end

PrecacheParticleSystem( "v_teleportation" )
PrecacheParticleSystem( "teleportation" )
PrecacheParticleSystem( "teleportation_effect" )
PrecacheParticleSystem( "teleportation_effect2" )

function ENT:OnInitialize()
	self.Filter = {}
	self.Filter = table.Add(self.Filter, ents.FindByClass("func_breakable_surf"))
	self.Filter = table.Add(self.Filter, ents.FindByClass("npc_*"))
	--trfilter = table.Add(trfilter, ents.FindByClass("prop_vehicle_*"))
	self.Filter = table.Add(self.Filter, self)
	self.Filter = table.Add(self.Filter, player.GetAll())
	
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end

	//for exploit blocks
	self:SetDTFloat(1,0)
end

function ENT:Cast()
	
	if self.ClearSpot and self.TPPos and self:GetDTFloat(1) <= CurTime() then
		//local amount = math.Clamp(math.Round(self.Dist/8),0,math.max(100,self.EntOwner:GetMaxMana()))
		local amount = math_Clamp( math_Round( math_sqrt( self.DistSqr ) / 8 ), 0, math_max( 100, self.EntOwner:GetMaxMana() ) )
		if !self.EntOwner:CanCast(self,amount) then 
			self.EntOwner._efCantCast = CurTime() + 1
			return 
		end
		self:SetDTFloat(0,CurTime()+0.5)
		--self.Teleporting = CurTime() + 0.3
		if SERVER then
			self:UseMana(amount)
			self:TeleportTo(self.TPPos)
		end
	else
		self.EntOwner._efCantCast = CurTime() + 1
	end	
	
end

function ENT:CanCast()
	
	local result = false
	
	if self.ClearSpot and self.TPPos and self:GetDTFloat(1) <= CurTime() then
		//local amount = math.Clamp(math.Round(self.Dist/8),0,math.max(100,self.EntOwner:GetMaxMana()))//100
		local amount = math_Clamp( math_Round( math_sqrt( self.DistSqr ) / 8 ), 0, math_max( 100, self.EntOwner:GetMaxMana() ) )
		
		result = self.EntOwner:CanCast(self,amount)
	end

	return result
end

function ENT:ManaToDistance( am )
	
	return ( am or self.EntOwner:GetMana() ) * 8
	
end

local trace = {}
local mins,maxs = Vector(-3,-3,-3), Vector(3,3,3)
local tiny_vec = Vector(1,1,1)
local hull = {}
local hull2 = {}
local hull_forward = {}
local trace_forward_check = {}
local extrace = {}
local extrace_down = {}
local bit_band = bit.band
local vector_up = vector_up
function ENT:OnThink()
	
	if !IsValid(self.EntOwner) then return end
	
	
	if self.EntOwner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	self.ClearSpot = false
	self.CurPos = nil
	self.TPPos = nil
	self.Normal = nil
	self.Dist = 0
	self.DistSqr = 0
	
	
	trace.start = self.EntOwner:GetShootPos()
	trace.endpos = self.EntOwner:GetShootPos()+self.EntOwner:GetAimVector()*math_max(100,self.EntOwner:GetMaxMana())*8//800
	trace.filter = self.Filter
	trace.mask = MASK_PLAYERSOLID_BRUSHONLY// - CONTENTS_PLAYERCLIP //MASK_VISIBLE + 
	
	trace.mins = tiny_vec * -1
	trace.maxs = tiny_vec
	
	local tr = util_TraceHull( trace )//util.TraceHull( trace )
	
	if tr.MatType == 88 then return end //dunno why it doesnt knows that mat_default is 88
	if tr.HitTexture and tr.HitTexture == "TOOLS/TOOLSNODRAW" then return end
	if bit_band( tr.Contents, CONTENTS_PLAYERCLIP ) ~= 0 then return end
	
	
		if tr.Hit then
		
			local pos, norm = tr.HitPos, tr.HitNormal
			
			self.CurPos = pos
			self.Normal = norm
			//ground
			if norm.z > 0.5 then
				
				for i=0,10 do
					//trace hull
					
					hull.start = pos+tr.HitNormal*(2+i)//Vector(0,0,2+i)
					hull.endpos = pos+tr.HitNormal*(2+i)//Vector(0,0,2+i)
					hull.mins = self.EntOwner:OBBMins()
					hull.maxs = self.EntOwner:OBBMaxs()
					--hull.mask = MASK_VISIBLE + MASK_PLAYERSOLID_BRUSHONLY
					
					local trhull = util_TraceHull( hull )
					
					if !trhull.Hit then

						self.TPPos = hull.start//pos+Vector(0,0,2+i)
						self.ClearSpot = true
						//self.Dist = math.ceil(self.EntOwner:GetShootPos():Distance(self.TPPos))
						self.DistSqr = math_ceil( self.EntOwner:GetShootPos():DistToSqr( self.TPPos ) )
						
						if SERVER and (IsBlockedPosition(self.TPPos) or IsBlockedPosition(self.TPPos+vector_up*72)) then
							self:SetDTFloat(1,CurTime()+1)
						end
						break
					end
				
				end
			//ceilings
			elseif norm.z < -0.5 then
				
				for i=0,60 do
				
					
					hull2.start = pos + vector_up * 2 + vector_up * 5 * i //pos+Vector(0,0,2)+Vector(0,0,5*i)
					hull2.endpos = hull2.start //pos+Vector(0,0,2)+Vector(0,0,5*i)
					hull2.mins = self.EntOwner:OBBMins()
					hull2.maxs = self.EntOwner:OBBMaxs()
					hull2.mask = MASK_PLAYERSOLID - CONTENTS_PLAYERCLIP
					
					local trhull2 = util_TraceHull( hull2 )
					
					if !trhull2.Hit then
						
						//check for out of map shit
						
						extrace.start = pos + vector_up * 2 + vector_up * 5 * i //pos+Vector(0,0,2)+Vector(0,0,5*i)
						extrace.endpos = pos + vector_up * 2 + vector_up * 5 * i + vector_up * 300 //pos+Vector(0,0,2)+Vector(0,0,5*i)+vector_up*500
						extrace.filter = self.Filter
						
						//test
						extrace.mins = tiny_vec * -1
						extrace.maxs = tiny_vec
						
						
						extrace_down.start = pos + vector_up * 2 + vector_up * 5 * i //pos+Vector(0,0,2)+Vector(0,0,5*i)
						extrace_down.endpos = pos + vector_up * -20
						extrace_down.filter = self.Filter
						extrace_down.mask = MASK_PLAYERSOLID_BRUSHONLY - CONTENTS_PLAYERCLIP
						
						extrace_down.mins = tiny_vec * -1
						extrace_down.maxs = tiny_vec
						
						//extrace_down.mask = MASK_SHOT_PORTAL
						
						--extrace.mask = MASK_VISIBLE + MASK_PLAYERSOLID_BRUSHONLY
						
						
						local extr = util_TraceHull( extrace )
						local extr2 = util_TraceHull( extrace_down )
						
						--if SERVER then PrintTable( extr ) end
						
						if !extr.HitSky and extr2.MatType ~= 88 and extr2.HitTexture ~= "TOOLS/TOOLSNODRAW" and extr2.HitTexture ~= "PLASTER/PLASTERWALL012A" then							
							self.CurPos = pos + vector_up * 2 + vector_up * 5 * i //pos+Vector(0,0,2)+Vector(0,0,5*i)
							self.TPPos = pos + vector_up * 2 + vector_up * 5 * i //pos+Vector(0,0,2)+Vector(0,0,5*i)
							self.ClearSpot = true
							//self.Dist = math.ceil(self.EntOwner:GetShootPos():Distance(self.TPPos))
							self.DistSqr = math_ceil( self.EntOwner:GetShootPos():DistToSqr( self.TPPos ) )
							
							if SERVER and (IsBlockedPosition(self.TPPos) or IsBlockedPosition(self.TPPos+vector_up*72) or self.EntOwner:IsCarryingFlag() or GAMEMODE:GetGametype() == "ts") then
								self:SetDTFloat(1,CurTime()+1)
							end
							break
						end
					end
					
				end
			else
				//forward
				
				local possible = tr.Normal * self:ManaToDistance()
				
				if tr.StartPos:DistToSqr( tr.HitPos ) > tr.StartPos:DistToSqr( possible ) and tr.StartPos:DistToSqr( possible ) > 90000 then
					pos = possible
					norm = tr.Normal * -1
				end
				
				for i=0,10 do				
					hull_forward.start = pos + vector_up * 5 - Vector( 0, 0, 50 - 5 * i )  + norm * 30
					hull_forward.endpos = hull_forward.start //pos + vector_up * 5 + tr.HitNormal * 20 //+ Vector(0,0,32)
					hull_forward.mins = self.EntOwner:OBBMins()
					hull_forward.maxs = self.EntOwner:OBBMaxs()
					
					--hull.mask = MASK_VISIBLE + MASK_PLAYERSOLID_BRUSHONLY
						
					local trhull = util_TraceHull( hull_forward )
											
					if !trhull.Hit then

						self.TPPos = hull_forward.start//+Vector(0,0,-60)
						self.ClearSpot = true
						//self.Dist = math.ceil(self.EntOwner:GetShootPos():Distance(self.TPPos))
						self.DistSqr = math_ceil( self.EntOwner:GetShootPos():DistToSqr( self.TPPos ) )
												
						if SERVER and (IsBlockedPosition(self.TPPos) or IsBlockedPosition(self.TPPos+vector_up*72)) then
							self:SetDTFloat(1,CurTime()+1)
						end
						break
					end
				end
			
			end
		else	
			//yes we are checking it again, duh
			
			local pos, norm = tr.HitPos, tr.HitNormal
			
			local possible = tr.StartPos + tr.Normal * self:ManaToDistance()
						
			if tr.StartPos:DistToSqr( tr.HitPos ) > tr.StartPos:DistToSqr( possible ) and tr.StartPos:DistToSqr( possible ) > 90000 then
				pos = possible
				norm = tr.Normal * -1
			end
			
			//print(tostring(tr.StartPos:Distance( pos )))
				
			for i=0,10 do				
				hull_forward.start = pos + vector_up * 5 - Vector( 0, 0, 50 - 5 * i ) + norm * 30
				hull_forward.endpos = hull_forward.start //pos + vector_up * 5 + tr.HitNormal * 20 //+ Vector(0,0,32)
				hull_forward.mins = self.EntOwner:OBBMins()
				hull_forward.maxs = self.EntOwner:OBBMaxs()
					
				--hull.mask = MASK_VISIBLE + MASK_PLAYERSOLID_BRUSHONLY
						
				local trhull = util_TraceHull( hull_forward )
	
				if !trhull.Hit then

					self.TPPos = hull_forward.start//+Vector(0,0,-60)
					self.ClearSpot = true
					//self.Dist = math.ceil(self.EntOwner:GetShootPos():Distance(self.TPPos))
					self.DistSqr = math_ceil( self.EntOwner:GetShootPos():DistToSqr( self.TPPos ) )
												
					if SERVER and (IsBlockedPosition(self.TPPos) or IsBlockedPosition(self.TPPos+vector_up*72)) then
						self:SetDTFloat(1,CurTime()+1)
					end
					break
				end
			end
			
		end
		
end

if SERVER then
	
	function ENT:TeleportTo(newpos)
		local vol = math.random(95,110)
		if self.EntOwner:GetPerk("stealth") then
			vol = 28
		end
		self.EntOwner:EmitSound("npc/scanner/scanner_nearmiss"..math.random(1,2)..".wav",vol,100)//math.random(90,110)"ambient/machines/thumper_top.wav"
		self.EntOwner:SetPos(newpos)
		self:SetPos(self.EntOwner:GetPos())
		if self.EntOwner:GetVelocity().z > 30 then
			self.EntOwner:SetLocalVelocity(Vector(0,0,0))
		end
		self.EntOwner:UnlockAchievement("hditworks")
	end


end

if CLIENT then

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end
local mat = Material( "particle/Particle_Ring_Wave_AddNoFog" )//effects/select_ring
function ENT:OnDraw()
	
	local owner = self.EntOwner
	

	
	if self:GetDTFloat(0) and self:GetDTFloat(0) > CurTime() and (MySelf ~= owner or GAMEMODE.ThirdPerson) then
		self.LastEmit = self.LastEmit or 0
		
		if self.LastEmit > CurTime() then return end
		
		self.LastEmit = self:GetDTFloat(0) 
		
		ParticleEffectAttach("teleportation_effect2",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		
	end	
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if owner == MySelf and DD_TELEPORT_MARKER and not owner:IsThug() then
		if self.CurPos and self.Normal and self.Normal.z ~= 0 then
			render.SetMaterial(mat)
					
			local sin = math.sin(RealTime() * 4)*3
			local col = Color(math.random(210,255), 40, 40,255)
					
			if self:CanCast() then
				col = Color(math.random(84,155), 10, math.random(210,255),255)
			end
					
			cam.IgnoreZ(true)
				render.DrawQuadEasy(self.CurPos, self.Normal or vector_up, 40+sin, 40+sin, col)
			cam.IgnoreZ(false)
		end
	end
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end

	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("teleportation",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
	
	
	
	/*local bones = {"ValveBiped.Bip01_Pelvis","ValveBiped.Bip01_Spine1","ValveBiped.Bip01_Spine4",
					"ValveBiped.Bip01_L_UpperArm","ValveBiped.Bip01_R_UpperArm","ValveBiped.Bip01_L_Calf","ValveBiped.Bip01_R_Calf"}
	
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then return end
	
	if self:GetDTFloat(0) and self:GetDTFloat(0) > CurTime() then
		for k, v in pairs( bones ) do
			local bone = owner:LookupBone(v)
			if bone then
				local pos, ang = owner:GetBonePosition(bone)
				local particle = self.Emitter:Add("particle/smokestack", pos+VectorRand()*math.random(-10,10))
				--particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.8, 4))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(1, 5.5))
				particle:SetEndSize(2)
				particle:SetColor(math.random(30,45), 2, math.random(30,45))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector( 0, 0, -90 ))
				particle:SetLighting(true)
				particle:SetCollide(true)
				
				local particle = self.Emitter:Add("effects/blueflare1", pos+VectorRand()*math.random(-10,10))
				--particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.9,2))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(0.5,2.1))
				particle:SetEndSize(1)
				particle:SetRoll(180)
				particle:SetColor(math.random(15,25), 3, math.random(15,25))
				particle:SetCollide( true )
				particle:SetGravity( Vector( 0, 0, -90 ) ) 
				
				--particle:SetAirResistance(12)
			end
		end
	end
	if LocalPlayer() == owner then return end
	
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Hand")
		
		self.NextEmit = self.NextEmit or 0
		
		if self.NextEmit > CurTime() then return end
		
		if bone then
		
			local pos, ang = owner:GetBonePosition(bone)
			
			self.NextEmit = CurTime() + 0.01
			
			local dlight = DynamicLight( self:EntIndex() )
			if ( dlight ) then
				dlight.Pos = pos+ang:Forward()*3
				dlight.r = math.random(30,45)
				dlight.g = 2
				dlight.b = math.random(30,45)
				dlight.Brightness = 1
				dlight.Size = 20
				dlight.Decay = 20 * 5
				dlight.DieTime = CurTime() + 1
				dlight.Style = 0
			end
					
			local particle = self.Emitter:Add("particle/smokestack", pos+ang:Forward()*2 +VectorRand()*(math.sin(RealTime()*1)*1.8) )
			particle:SetVelocity(owner:GetVelocity())
			particle:SetDieTime(math.Rand(0.8, 1))
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(1, 3.5))
			particle:SetColor(math.random(30,45), 2, math.random(30,45))
			particle:SetEndSize(math.Rand(0,1.5))
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector( 0, 0, -30 ))
			particle:SetCollide(true)
			particle:SetLighting(true)
			particle:SetAirResistance(12)
			
			local particle = self.Emitter:Add("effects/blueflare1", pos+ang:Forward()*2 +VectorRand()*(math.sin(RealTime()*1)*1.8))
			particle:SetVelocity(owner:GetVelocity())
			particle:SetDieTime(math.Rand(0.9,1.3))
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(0.1,1))
			particle:SetEndSize(0)
			particle:SetRoll(180)
			particle:SetColor(math.random(15,25), 3, math.random(15,25))
			particle:SetCollide( true )
			particle:SetGravity( Vector( 0, 0, -30 ) ) 
		
		end
	*/
end


function ENT:HandDraw(owner,reverse,point)

	
	if point and not point.Particle then
		ParticleEffectAttach("v_teleportation",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	/*lif not util.tobool(GetConVarNumber("_dd_teleportmarker")) then return end
	
	if self.CurPos and self.Normal and self.Normal.z ~= 0 then
		render.SetMaterial(mat)
				
		local sin = math.sin(RealTime() * 4)*3
		local col = Color(math.random(210,255), 40, 40,255)
				
		if self:CanCast() then
			col = Color(math.random(84,155), 10, math.random(210,255),255)
		end
				
		cam.IgnoreZ(true)
			render.DrawQuadEasy(self.CurPos, self.Normal or vector_up, 40+sin, 40+sin, col)
		cam.IgnoreZ(false)
	end
	
	ocal bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Left_Hand"}
	end
	
	if self.NextHEmit and self.NextHEmit > CurTime() then return end
	
	self.NextHEmit = CurTime() + 0.003
	local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				local dlight = DynamicLight( vm:EntIndex() )
				if ( dlight ) then
					dlight.Pos = pos+ang:Forward()*2+VectorRand()*math.Rand(0.1,0.2)
					dlight.r = math.random(30,45)
					dlight.g = 2
					dlight.b = math.random(30,45)
					dlight.Brightness = 1
					dlight.Size = 20
					dlight.Decay = 20 * 5
					dlight.DieTime = CurTime() + 1
					dlight.Style = 0
				end
				
				local particle = self.Emitter2:Add("particle/smokestack", pos+ang:Forward()*2 +VectorRand()*2 )
				particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.8, 1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(1, 3))
				particle:SetColor(math.random(30,45), 2, math.random(30,45))
				particle:SetEndSize(math.Rand(0,1.5))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector( 0, 0, -30 ))
				particle:SetCollide(true)
				particle:SetLighting(true)
				particle:SetAirResistance(12)
				
				local particle = self.Emitter2:Add("effects/blueflare1", pos+ang:Forward()*2 +VectorRand()*2)
				particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.9,1.3))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(0.4,1))
				particle:SetEndSize(0)
				particle:SetRoll(180)
				particle:SetColor(math.random(15,25), 3, math.random(15,25))
				particle:SetCollide( true )
				particle:SetGravity( Vector( 0, 0, -30 ) ) 			
			end
		end
	end
	*/
end
end





