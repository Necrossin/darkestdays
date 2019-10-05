if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"	
end

SWEP.ViewModel	= Model ( "models/weapons/c_toolgun.mdl" )//"models/weapons/v_toolgun.mdl"
SWEP.WorldModel	= Model ( "models/weapons/w_toolgun.mdl" )

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

SWEP.UseHands = true

if CLIENT then

	SWEP.PrintName = "KOTH Manager"
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
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.01

SWEP.Primary.Sound = Sound( "buttons/button15.wav" )

SWEP.PointsTable = {}
SWEP.PointsTable2 = {}

function SWEP:Initialize()
	self:SetDTInt ( 0, 100 )
end

function SWEP:SpawnPoint()
	local trace = self.Owner:GetEyeTrace()
	
	local pos = trace.HitPos + vector_up*2
	
	local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( pos )
	ent:SetModel ( "models/props_combine/combine_mine01.mdl" )
	ent:SetColor (Color(0,255,0,200))
	ent:SetMaterial("models/debug/debugwhite")
	ent:SetDTInt(0,self:GetDTInt(0))
	ent.Point = true
	ent:Spawn()
	
	local effectdata = EffectData()
		effectdata:SetEntity( ent )
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetRadius( self:GetDTInt(0) )
	util.Effect("koth_manager_entity", effectdata, true, true)
	
	local Phys = ent:GetPhysicsObject()
	if ValidEntity ( Phys ) then
		Phys:EnableMotion ( false )
	end
	


	local PosTable = { Pos = {pos.x,pos.y,pos.z},R = self:GetDTInt(0) }
	//self.AmmoBoxTable2[#self.AmmoBoxTable+1] = ent
	//self.AmmoBoxTable[ent.CrateIndex] = PosTableSupply
	table.insert ( self.PointsTable2, ent )
	table.insert ( self.PointsTable, PosTable )
	print("Added-------------------------")
	PrintTable(self.PointsTable)
end

function SWEP:RemovePoint(ent)

	local ind = 0
	
	for i,pk in pairs(self.PointsTable2) do
		if pk == ent then
			ind = i
		end
	end
	
	print("Removing Point index: "..ind)
	
	ent:Remove()
	
	self.PointsTable2[ind] = nil
	self.PointsTable[ind] = nil
	
	table.Resequence ( self.PointsTable )
	table.Resequence ( self.PointsTable2 )
	
	print("Removed-------------------------")
	PrintTable(self.PointsTable)
end

function SWEP:Think()

end

----------------------------------------------------------------------------------*/
local function SavePoints ( pl, cmd, args )
	if not pl:IsAdmin() then return end
	
	local filename = "darkestdays/koth_points/".. game.GetMap() ..".txt"
	
	local Tool = pl:GetWeapon ( "koth_manager" )
	if Tool == nil then return end
		
	file.Write( filename,util.TableToJSON(Tool.PointsTable or {}) )
end
if SERVER then concommand.Add( "map_savepoints", SavePoints ) end

local function GiveKOTHManager(pl,cmg,args)
	if not pl:IsAdmin() then return end
	
	pl:Give("koth_manager")
	
end
if SERVER then concommand.Add( "map_givekothmanager", GiveKOTHManager ) end


function SWEP:Reload()
	if self.NextReload > CurTime() then return end
	
	if CLIENT then		
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save all points to file?", "Warning!","Yes", function() RunConsoleCommand( "map_savepoints" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the points to gmod/data/darkestdays/koth_points/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		
		if Ent and IsValid(Ent) and Ent.Point then
			self:RemovePoint(Ent)
		else
			self:SpawnPoint()
		end
		
		//Weapon animation
		self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.0001 )
	
	if SERVER then
		if self.Owner:KeyDown( IN_USE ) then
			self:SetDTInt( 0, math.Clamp(( self:GetDTInt( 0 ) or 0 ) - 1,0,300) )
		else
			self:SetDTInt( 0, ( self:GetDTInt( 0 ) or 0 ) + 1 )
		end
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
		util.Effect("koth_manager_ghost", effectdata, true, true)
		
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 

if CLIENT then

function SWEP:DrawHUD()
	if not self.Owner:Alive() then return end
	if ENDROUND then return end
	
	local Description1 = "Left mouse to place/remove. Radius: "..self:GetDTInt(0)
	local Description2 = "USE to shrink, RMB to grow"

	surface.SetFont ( "Arial_Bold_20" )
	local DescWide1 = surface.GetTextSize ( Description1 )
	local DescWide2 = surface.GetTextSize ( Description2 )

	local BoxWide = math.max ( DescWide1, DescWide2 ) + ScaleW(50)

	draw.RoundedBox ( 8, ScaleW(673) - BoxWide * 0.5, ScaleH(761) - ScaleH(117) * 0.5, BoxWide, ScaleH(117), Color ( 1,1,1,180 ) )
	draw.SimpleTextOutlined( Description1,"Arial_Bold_20",ScaleW(673),ScaleH(726), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	draw.SimpleTextOutlined( Description2 ,"Arial_Bold_20",ScaleW(673),ScaleH(756), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255)) 
end

effects.Register(
            {
                Init = function(self, data)
				
					self.Ent = data:GetEntity()
					self.Radius = data:GetRadius()
					
					self.Particle = CreateParticleSystem( self.Ent, "hill_neutral", PATTACH_ABSORIGIN_FOLLOW )
					self.Particle:SetControlPoint( 2, Vector( self.Radius, 0, 0 ) ) 
	
				
                end,
 
                Think = function( self ) 
					
					return IsValid( self.Ent )
				
				end,
 
                Render = function(self) end
            },
 
            "koth_manager_entity"
        )

end