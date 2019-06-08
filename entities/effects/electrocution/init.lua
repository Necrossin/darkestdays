function EFFECT:Init(data)
	self.DieTime = CurTime() + 3

	self.ent = data:GetEntity()
end

function EFFECT:Think()
	if IsValid(self.ent) then
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		self.Entity:SetPos(self.ent:GetPos())
		
		if IsValid(self.ent:GetRagdollEntity()) then
			local rag = self.ent:GetRagdollEntity()
			for i = 0, rag:GetPhysicsObjectCount() do
				local phys = rag:GetPhysicsObjectNum(i)
				if phys and phys:IsValid() then
					phys:Wake()
					phys:AddVelocity( VectorRand()*math.Rand(-140,140) + vector_up*math.Rand(-10,-80) )
				end
			end
		end
		
	end
	return CurTime() < self.DieTime
end
local mat = Material( "sprites/rollermine_shock" )
function EFFECT:Render()

	if !ValidEntity(self.ent) then return end
	local obj = IsValid( self.ent:GetRagdollEntity() ) and self.ent:GetRagdollEntity() or self.ent
		for i=0, 25, 1 do
			local bone = obj:GetBoneMatrix(i)
			if bone then
				local pos = bone:GetTranslation()
				render.SetMaterial( mat ) 
					render.StartBeam( 4 )
					render.AddBeam( pos , 2, 0, Color( 255, 255, 255, 255 ) )
					for i=1, 2 do
						local curpos = pos + VectorRand() * math.Rand(4,8)
						render.AddBeam( curpos , 2, CurTime() + i/2, Color( 255, 255, 255, 255 ) )
					end
					
					render.AddBeam( pos+ VectorRand() * math.Rand(3,8) , 2, 1, Color( 255, 255, 255, 255 ) )
				render.EndBeam()
				
				if math.random(3) == 3 then
					render.SetMaterial( mat ) 
						render.StartBeam( 4 )
						render.AddBeam( pos , 2, 0, Color( 255, 255, 255, 255 ) )
						local curpos = pos + VectorRand() * math.Rand(3,10)
						for i=1, 2 do
							curpos = curpos + VectorRand() * math.Rand(2,10)
							render.AddBeam( curpos , 2, CurTime() + i/2, Color( 255, 255, 255, 255 ) )
						end
						
						render.AddBeam( curpos+ VectorRand() * math.Rand(3,10) , 2, 1, Color( 255, 255, 255, 255 ) )
					render.EndBeam()
				end
			end				
	end
	

end
