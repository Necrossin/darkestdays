ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	if SERVER then	
		self.Entity:DrawShadow(false)
	end	
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end