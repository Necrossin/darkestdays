if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	if SERVER then	
		self.Entity:DrawShadow(false)
		
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTimer(FFA_TIME)
		
		self:SetStartTime(CurTime() + 55)
	end	
end


function ENT:Think()
	if SERVER then	
		if not self:IsActive() then return end
				
		local ct = CurTime()
				
		self.NextTick = self.NextTick or 0
			
		if self.NextTick <= ct then

			self:DrainTimer()
			
			self.NextTick = ct + 1
		end
	end
end

if CLIENT then
function ENT:Draw()

end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

function ENT:SetTimer(time)
	self:SetDTFloat(1,time)
end

function ENT:GetTimer()
	return self:GetDTFloat(1)
end

function ENT:DrainTimer()
	self:SetTimer(math.Clamp(self:GetTimer() - 1, 0,999999))
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time) 
end