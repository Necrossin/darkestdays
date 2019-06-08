local math = math
local util = util
local render = render

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	--self.Entity:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	
	self.PickupModels = {
		[1] = {mdl = "models/items/HealthKit.mdl", ent = "pickup_medkit"},
		[2] = {mdl = "models/Weapons/w_package.mdl", ent = "pickup_manapack"},
		[3] = {mdl = "models/Items/BoxMRounds.mdl", ent = "pickup_ammo"},
	}
	
end

function EFFECT:Think()
	
	if !ValidEntity(self.EfOwner) then return false end
	if !ValidEntity(self.EfOwner:GetActiveWeapon()) then return false end
	if self.EfOwner:GetActiveWeapon():GetClass() ~= "pickup_spawner" then return false end
	if not self.EfOwner:Alive() then return false end
	
	local ent = self.Entity
	
	local wep = self.EfOwner:GetActiveWeapon()
	local pk = wep:GetDTInt(0) or 1
	
	if self.Entity:GetModel() ~= self.PickupModels[pk].mdl then
		self.Entity:SetModel(self.PickupModels[pk].mdl)
	end
	
	local trace = self.EfOwner:GetEyeTrace()

	self.Entity:SetPos(trace.HitPos+vector_up*6)
	
	ent:SetColor (Color(0,255,0,200))

	
	return (self and self.EfOwner and IsValid(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "pickup_spawner" and self.EfOwner:Alive())
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
end
