function EFFECT:Init(data)	
	self.pos = data:GetOrigin()
	self.norm = data:GetNormal()
	
	self.Entity:SetModel("models/weapons/w_knife_t.mdl")
	self.Entity:SetModelScale(2,0)
	
	local ang = self.norm:Angle()
	//ang.p=ang.p+60
	self.Entity:SetAngles(ang)
	local ang = self.norm:Angle()
	self.Entity:SetPos(self.pos)//+ang:Up()*7-ang:Forward()*8
	
	self.Die = CurTime()+4
end

function EFFECT:Think()
	return self.Die > CurTime()
end

function EFFECT:Render()
	self.Entity:DrawModel()
end