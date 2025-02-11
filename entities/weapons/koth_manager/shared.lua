if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

SWEP.ViewModel	= Model ( "models/weapons/c_toolgun.mdl" )
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

function SWEP:TryLoadingKOTHPoints()
	if KOTHPoints and #KOTHPoints > 0 and IsValid( self:GetOwner() ) then
		
		print("-- Loading existing points from map\n")

		for k, v in pairs( KOTHPoints ) do
			self:SpawnPoint( v.Pos, v.R )
		end

	end
end


function SWEP:SpawnPoint( override_pos, override_radius )
	local trace = self:GetOwner():GetEyeTrace()

	local pos = override_pos or trace.HitPos + vector_up * 2
	local radius = override_radius or self:GetDTInt(0)

	local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( pos )
	ent:SetModel ( "models/props_combine/combine_mine01.mdl" )
	ent:SetColor ( Color( 0, 255, 0, 200 ) )
	ent:SetMaterial( "models/debug/debugwhite" )
	ent:SetDTInt( 0, radius )
	ent.Point = true
	ent:Spawn()

	self:DeleteOnRemove( ent )

	local effectdata = EffectData()
		effectdata:SetEntity( ent )
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetRadius( radius )
	util.Effect("koth_manager_entity", effectdata, true, true)
	
	local Phys = ent:GetPhysicsObject()
	if ValidEntity ( Phys ) then
		Phys:EnableMotion ( false )
	end

	local PosTable = { Pos = { pos.x, pos.y, pos.z }, R = radius }

	table.insert ( self.PointsTable2, ent )
	table.insert ( self.PointsTable, PosTable )

	print( override_pos and  "-- Loaded point:" or  "-- Added point:")
	print("-- Position: "..tostring( pos )..", Radius: ".. tostring( radius ) )

end

function SWEP:RemovePoint(ent)

	local ind = 0
	
	for i,pk in pairs(self.PointsTable2) do
		if pk == ent then
			ind = i
		end
	end
	
	print("-- Removing Point index: "..ind)
	
	ent:Remove()
	
	self.PointsTable2[ind] = nil
	self.PointsTable[ind] = nil
	
	table.Resequence ( self.PointsTable )
	table.Resequence ( self.PointsTable2 )
		
end

function SWEP:Think()

end


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
			Derma_Query("Are you sure you want to save all points to file?", "Warning!","Yes", function() RunConsoleCommand( "map_savepoints" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the points to garrysmod/data/darkestdays/koth_points/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self:GetOwner():GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		
		if Ent and IsValid(Ent) and Ent.Point then
			self:RemovePoint(Ent)
		else
			self:SpawnPoint()
		end

		self:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + 0.0001 )
	
	if SERVER then
		if self:GetOwner():KeyDown( IN_USE ) then
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
		local owner = self:GetOwner()
		local e = EffectData()
		e:SetEntity(owner)
		e:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
		util.Effect("koth_manager_ghost", e, true, true)

		if not self.SentPointsToOwner then
			self.SentPointsToOwner = true

			self:TryLoadingKOTHPoints()
		end

	end
	
	self:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 

if CLIENT then

function SWEP:DrawHUD()
	if not self.Owner:Alive() then return end
	if ENDROUND then return end
	
	local Description = "Left mouse to place/remove. Radius: "..self:GetDTInt(0).."\nRMB to increase radius, RMB +  USE key will decrease radius\nPress Reload button to save"

	surface.SetFont( "Arial_Bold_20" )
	local tw, th = surface.GetTextSize( Description )

	draw.RoundedBox( 2, ScrW() / 2 - tw / 2 - 8, ScrH() * 0.75 - 8, tw + 16, th + 16, Color( 0,0,0, 140 ) )
	draw.DrawText( Description, "Arial_Bold_20", ScrW() / 2, ScrH() * 0.75, Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER )
	
end

effects.Register(
            {
                Init = function(self, data)
				
					self.Ent = data:GetEntity()
					self.Radius = data:GetRadius()

                end,
 
                Think = function( self )
					
					return IsValid( self.Ent )
				
				end,
 
                Render = function(self)
					
					if !IsValid( self.Particle ) then
						self.Particle = CreateParticleSystem( self.Ent, "hill_neutral", PATTACH_ABSORIGIN_FOLLOW )
						self.Particle:SetControlPoint( 2, Vector( self.Radius, 0, 0 ) )
					end

					if self.Radius then
						
						local pos = self:GetPos() + vector_up * 60
						local ang = ( pos - EyePos() ):GetNormalized():Angle()

						ang:RotateAroundAxis( ang:Up(), -90 )
						ang:RotateAroundAxis( ang:Forward(), 90 )

						local txt = "KOTH Point, Radius: "..tostring( math.Round( self.Radius ) )
						surface.SetFont( "Arial_Bold_40" )
						local tw, th = surface.GetTextSize( txt )

						cam.IgnoreZ( true )
						cam.Start3D2D( pos, ang, 0.5)
							draw.SimpleText( txt, "Arial_Bold_40", -tw / 2, 0, color_white )
						cam.End3D2D()
						cam.IgnoreZ( false )

					end
				
				end
            },
 
            "koth_manager_entity"
        )

end