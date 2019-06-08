local math = math
local table = table

function EFFECT:Init(data)
	
	self.ent = data:GetEntity()
	
	self.Entity:SetModel("models/weapons/w_knife_t.mdl")
	self.Entity:SetModelScale(3,0)
	self.Removed = false
end
local check_trace = {mask = MASK_SHOT}
function EFFECT:Think()
	if IsValid(self.ent) then
		self.Entity:SetPos(self.ent:GetPos())
		return true
	else
		if self.Lastpos then
			self.Entity:SetPos(self.Lastpos)
			self.Entity:SetAngles(self.Lastang)
			if not self.Die then
				self.Die = CurTime() + 20
				check_trace.start = self.Lastpos - self.Trueang:Forward()*30
				check_trace.endpos = self.Lastpos + self.Trueang:Forward()*30
				check_trace.filter = {player.GetAll(),self.Entity}
				
				local tr = util.TraceLine(check_trace)

				if !tr.HitWorld then
					print("remove!")
					self.Die = CurTime()
				end
				
			end
		end
	end
	return self.Die and self.Die > CurTime()//IsValid(self.ent)
end

function EFFECT:Render()
	if IsValid(self.ent) then
		local ang = self.ent:GetAngles()
		self.Trueang = ang
		ang.p=ang.p+60
		self.Entity:SetAngles(ang)
		self.Entity:SetPos(self.ent:GetPos()+self.ent:GetAngles():Up()*11-self.ent:GetAngles():Forward()*8)
		self.Lastpos = self.Entity:GetPos()
		self.Lastang = self.Entity:GetAngles()//:Forward()
		self.Entity:DrawModel()
	else
		self.Entity:DrawModel()
		//if not self.Removed then
		//	if self.Lastpos then
		//		local e = EffectData()
		//		e:SetOrigin(self.Lastpos)
		//		e:SetNormal(self.Lastnorm)
		//		util.Effect("knife_impact",e)
		//		self.Removed = true
		//	end
		//end
	end
end
