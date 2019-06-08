function EFFECT:Init( data )
	
	self.ent = data:GetEntity()
	self.seq = math.Round( data:GetMagnitude() or 1 )
	self.speed = data:GetScale() or 1
	self.RagdollSpeed = math.Rand( 0.05, 0.15 )
	self.ang = data:GetAngles()
	
	if !IsValid(self.ent) then return end
	
	local rag = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	if !IsValid(rag) then return end

	self:SetModel( self.ent:GetModel() )
	self:SetAngles( self.ang )
	--self:SetAngles( self.ent:GetAngles() )

	self:SetSequence( self.seq )

	self:SetPlaybackRate( self.speed )
	
	self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
	
	self.DieTime = (self:SequenceDuration()*0.95)/self.speed + CurTime()
	
	self.LastRender = 0
	
end


function EFFECT:Think()

	local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
		
	if rag and IsValid(rag) then
				
		for i = 0, rag:GetPhysicsObjectCount() do
			local translate = self:TranslatePhysBoneToBone(i)
			if translate and 0 < translate then
			local pos, ang = self:GetBonePosition(translate)
				if pos and ang then
					local phys = rag:GetPhysicsObjectNum(i)
					if phys and phys:IsValid() then
						phys:Wake()
						if math.random(3) == 3 then
							phys:ComputeShadowControl({secondstoarrive = self.RagdollSpeed or 0.05, pos = pos, angle = ang, maxangular = 1000, maxangulardamp = 1000, maxspeed = 1000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 200, deltatime = RealFrameTime()})
						end
					end
				end
			end
		end
		
		self:SetNextClientThink( CurTime() )

	end
	
	return self.DieTime and self.DieTime > CurTime()
end

function EFFECT:Render()
	
	self:FrameAdvance( ( RealTime() - ( self.LastRender or 0 ) ) * 1 )
		
	self.LastRender = RealTime()
	
end