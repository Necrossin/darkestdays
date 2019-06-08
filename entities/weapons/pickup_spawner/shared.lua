if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"	
end

SWEP.ViewModel	= Model ( "models/weapons/v_toolgun.mdl" )
SWEP.WorldModel	= Model ( "models/weapons/w_toolgun.mdl" )

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

if CLIENT then

	SWEP.PrintName = "Pickup Spawner"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= ""
	SWEP.Slot = 4
	SWEP.SlotPos = 4
	SWEP.Contact = ""
    SWEP.Purpose = ""
    SWEP.Instructions = ""
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.01
SWEP.NextReload = 3

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.01

SWEP.Primary.Sound = Sound( "buttons/button15.wav" )

SWEP.PickupModels = {
	[1] = {mdl = "models/items/HealthKit.mdl", ent = "pickup_medkit"},
	[2] = {mdl = "models/Weapons/w_package.mdl", ent = "pickup_manapack"},
	[3] = {mdl = "models/Items/BoxMRounds.mdl", ent = "pickup_ammo"},
}

SWEP.PickupTable = {}
SWEP.PickupTable2 = {}


SWEP.SpawnsTable = {}

function SWEP:Initialize()
	self:SetDTInt ( 0, 1 )
end

function SWEP:SpawnPickup()
	local trace = self.Owner:GetEyeTrace()
	
	local pos = trace.HitPos + vector_up*6
	
	local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( pos )
	ent:SetModel ( self.PickupModels[self:GetDTInt(0)].mdl )
	ent:SetColor (Color(0,255,0,200))
	ent:SetMaterial("models/debug/debugwhite")
	ent.Pickup = true
	ent:Spawn()
	
	local Phys = ent:GetPhysicsObject()
	if ValidEntity ( Phys ) then
		Phys:EnableMotion ( false )
	end
	


	local PosTable = { Pos = {pos.x,pos.y,pos.z},Type = self.PickupModels[self:GetDTInt(0)].ent }
	//self.AmmoBoxTable2[#self.AmmoBoxTable+1] = ent
	//self.AmmoBoxTable[ent.CrateIndex] = PosTableSupply
	table.insert ( self.PickupTable2, ent )
	table.insert ( self.PickupTable, PosTable )
	print("Added-------------------------")
	PrintTable(self.PickupTable)
end

function SWEP:RemovePickup(ent)

	local ind = 0
	
	for i,pk in pairs(self.PickupTable2) do
		if pk == ent then
			ind = i
		end
	end
	
	print("Removing Pickup index: "..ind)
	
	ent:Remove()
	
	self.PickupTable2[ind] = nil
	self.PickupTable[ind] = nil
	
	table.Resequence ( self.PickupTable )
	table.Resequence ( self.PickupTable2 )
	
	print("Removed-------------------------")
	PrintTable(self.PickupTable)
end

function SWEP:Think()

end

----------------------------------------------------------------------------------*/
local function SavePickups ( pl, cmd, args )
	if not pl:IsAdmin() then return end
	
	local filename = "darkestdays/pickups/".. game.GetMap() ..".txt"
	
	local Tool = pl:GetWeapon ( "pickup_spawner" )
	if Tool == nil then return end
		
	file.Write( filename,util.TableToJSON(Tool.PickupTable or {}) )
end
if SERVER then concommand.Add( "map_savepickups", SavePickups ) end

local function GivePickupSpawner(pl,cmg,args)
	if not pl:IsAdmin() then return end
	
	pl:Give("pickup_spawner")
	
end
if SERVER then concommand.Add( "map_givepickupspawner", GivePickupSpawner ) end


function SWEP:Reload()
	if self.NextReload > CurTime() then return end
	
	if CLIENT then		
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save all pickups to file?", "Warning!","Yes", function() RunConsoleCommand( "map_savepickups" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the pickups to gmod/data/darkestdays/pickups/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		
		if Ent and IsValid(Ent) and Ent.Pickup then
			self:RemovePickup(Ent)
		else
			self:SpawnPickup()
		end
		
		//Weapon animation
		self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	local max = #self.PickupModels
	
	if SERVER then
		local num = 1
		if self:GetDTInt ( 0 ) == max then
			num = -1*(max-1)
		end
		self:SetDTInt ( 0 , self:GetDTInt ( 0 ) + num ) 
	
	end
		
end

if CLIENT then
	function SWEP:DrawHUD()
	end
end

function SWEP:Holster( weapon )
	return true
end 

function SWEP:OwnerChanged ( Owner )

end

function SWEP:Deploy()

	if SERVER then
		local owner = self.Owner
		local effectdata = EffectData()
		effectdata:SetEntity(owner)
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
		util.Effect("pickup_spawner_ghost", effectdata, true, true)
		
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 