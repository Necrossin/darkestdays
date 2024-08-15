local render = render
local surface = surface
local draw = draw
local cam = cam
local player = player
local ents = ents
local util = util
local math = math
local string = string
local gamemode = gamemode
local hook = hook
local Vector = Vector
local VectorRand = VectorRand
local Angle = Angle
local AngleRand = AngleRand
local Entity = Entity
local Color = Color
local FrameTime = FrameTime
local RealFrameTime = RealFrameTime
local RealTime = RealTime
local CurTime = CurTime
local SysTime = SysTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local tonumber = tonumber
local type = type
local ScrW = ScrW
local ScrH = ScrH
local Lerp = Lerp


local vector_up = Vector(0, 0, 1)
local vecfake = Vector(0, 0, 16000)
local col_white = color_white

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_PlaySound = surface.PlaySound
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

local render_SetBlend = render.SetBlend
local render_ModelMaterialOverride = render.ModelMaterialOverride
local render_MaterialOverride = render.MaterialOverride
local render_SetColorModulation = render.SetColorModulation
local render_SuppressEngineLighting = render.SuppressEngineLighting
local cam_IgnoreZ = cam.IgnoreZ
local render_SetMaterial = render.SetMaterial
local render_DrawQuadEasy = render.DrawQuadEasy
local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local render_FogMode = render.FogMode
local render_FogStart = render.FogStart
local render_FogEnd = render.FogEnd
local render_FogColor = render.FogColor
local render_FogMaxDensity = render.FogMaxDensity
local render_GetFogDistances = render.GetFogDistances
local render_GetFogColor = render.GetFogColor
local render_GetFogMode = render.GetFogMode

local draw_SimpleText = draw.SimpleText
local draw_GetFontHeight = draw.GetFontHeight

local math_Approach = math.Approach
local math_Round = math.Round
local math_Clamp = math.Clamp
local math_random = math.random

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team

local team_GetColor = team.GetColor


SpellIcons = {}

local def = Material("HUD/killicons/default")
function AddSpellIcon(name,alias)

	local mat = Spells[alias] and Spells[alias].Mat or def

	SpellIcons[name] = mat
	--table.insert(SpellIcons, {})
end

function IsSpellIcon(name)
	return SpellIcons[name] ~= nil
end


function DrawSpellIcon(x, y, name, alpha)

	alpha = alpha or 255

	local w = 50
	local h = 50
	
	x = x - w * 0.5
	y = y - h * 0.5
	
	local mat = SpellIcons[name]
	surface_SetMaterial( mat )
	surface_SetDrawColor( 255, 255, 255, alpha )
	surface_DrawTexturedRect( x, y, w, h )

	
end

function GetSpellIconSize()
	return 50,50
end

//Because im tired creating every single effect for each particle

function RegisterParticleEffect( name )
	 effects.Register(
            {
                Init = function(self, data)
                    local pos = data:GetOrigin()
					local norm = Angle(data:GetNormal().x,data:GetNormal().y,data:GetNormal().z)//:Angle()
					
					ParticleEffect(name,pos,norm,nil)
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            name
        )
end

function RegisterParticleEffectAttach( name , attachtype )
	
	attachtype = attachtype or PATTACH_ABSORIGIN_FOLLOW
	
	 effects.Register(
            {
                Init = function(self, data)
                    local ent = data:GetEntity()
					
					if IsValid(ent) then
						ParticleEffectAttach(name,attachtype,ent,0)
						if !ent:IsPlayer() then
							ent[name] = true
						end
					end
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            name
        )
end

effects.Register(
            {
                Init = function(self, data)
				
                    local pos = data:GetOrigin()
					local maxrange = math_Round(data:GetRadius())
					local damage = math_Round(data:GetMagnitude())
					local dmgtype = math_Round(data:GetScale())
					
					ExplosiveEffect(pos, maxrange, damage, dmgtype)
				
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            "ExplosiveEffect"
        )
		
GM.WeaponBloodMaterial = GM.WeaponBloodMaterial or CreateMaterial( "dd_weapon_blood", 
	"VertexLitGeneric", 
	{ 
		["$basetexture"] = "Models/flesh", 
		["$bumpmap"] = "models/flesh_nrm",
		["$nodecal"] = "0",
		--["$halflambert"] = 1,
		["$translucent"] = 1,
		["$model"] = 1,

		["$detail"] = "Models/flesh", 
		["$detailscale"] = 1,
		["$detailblendfactor"] = 1, 
		["$detailblendmode"] = 3,

		["$phong"] = "1",
		["$phongboost"] = "5",
		["$phongfresnelranges"] = "[2 5 10]",
		["$phongexponent"] = "500"
	} 
)

GM.PlayerBloodMaterial = GM.PlayerBloodMaterial or CreateMaterial( "dd_player_blood", 
	"VertexLitGeneric", 
	{ 
		["$basetexture"] = "Models/flesh", 
		["$bumpmap"] = "models/flesh_nrm",
		["$nodecal"] = "0",
		--["$halflambert"] = 1,
		["$translucent"] = 1,
		["$model"] = 1,

		["$detail"] = "Models/flesh", 
		["$detailscale"] = 1,
		["$detailblendfactor"] = 1, 
		["$detailblendmode"] = 3,

		["$phong"] = "1",
		["$phongboost"] = "5",
		["$phongfresnelranges"] = "[2 5 10]",
		["$phongexponent"] = "500"
	} 
)

local team_red_glow = CreateMaterial( "dd_team_red_glow", 
	"VertexLitGeneric", 
	{ 
		["$envMap"] = "darkestdays/glow",
		["$basetexture"] = "Models/shiny",
		["$bumpmap"] = "dev/bump_normal",
		
		["$envMapTint"] = "[0.98 0.156 0.156]",
		["$envMapFresnel"] = 1,
		
		["$additive"] = 1,
		["$color2"] = "[0 0 0]",
		
		["$phong"] = 1,
		["$phongBoost"] = 0,
		["$phongFresnelRanges"] = "[.0045 .7 2]"
	} 
)

local team_blue_glow = CreateMaterial( "dd_team_blue_glow", 
	"VertexLitGeneric", 
	{ 
		["$envMap"] = "darkestdays/glow",
		["$basetexture"] = "Models/shiny",
		["$bumpmap"] = "dev/bump_normal",
		
		["$envMapTint"] = "[0 0.47 0.98]",
		["$envMapFresnel"] = 1,
		
		["$additive"] = 1,
		["$color2"] = "[0 0 0]",
		
		["$phong"] = 1,
		["$phongBoost"] = 0,
		["$phongFresnelRanges"] = "[.0045 .7 2]"
	} 
)

-- just so we can use this thing
CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

include( 'shared.lua' )
include( 'cl_scoreboard.lua' )
include( 'cl_deathnotice.lua' )
include( 'cl_customize.lua' )
include( 'cl_endround.lua' )
include( 'cl_hud.lua' )
include( 'cl_lobby.lua' )
include( 'cl_voice.lua' )
include("boneanimlib_v2/cl_boneanimlib.lua")

CreateClientConVar("_dd_thirdperson", 0, true, true)

ROUNDTIME = 0
ROUNDLENGTH = 0

//colors
COLOR_BACKGROUND_DARK = Color(20,20,20,225)//Color(42, 39, 37, 255)
COLOR_BACKGROUND_OUTLINE = Color(231,231,231,15)//Color(247, 235, 198, 220)

COLOR_SELECTED_BRIGHT = Color(208,208,208,135)//Color(143, 133, 122, 255)
COLOR_DESELECTED_BRIGHT = Color(70, 70, 70,215)//Color(76, 70, 66, 255)

COLOR_BACKGROUND_INNER = Color(45, 45, 45, 255)//Color(56, 51, 44, 255)
COLOR_BACKGROUND_INNER_DARK = Color(35, 35, 35, 255)//Color(49, 44, 41, 255)

COLOR_MISC_SELECTED_BRIGHT = Color(94, 94, 94,253)//Color(97, 94, 84, 255)
COLOR_MISC_SELECTED_BRIGHT_OUTLINE = Color(231,231,231,255)//Color(240, 229, 193, 255)
COLOR_MISC_BACKGROUND2 = Color(70, 70, 70,255)//Color(70, 66, 61, 255)

COLOR_TEXT_SOFT_BRIGHT = Color(231,231,231,255)//Color(236, 227, 203, 255)

hook.Remove("PlayerTick","TickWidgets")
hook.Remove("Think","DOFThink")

BloodOverlays = {}

for i=1, 8 do
	BloodOverlays[i] = Material( "decals/blood"..i )
end

local function NewScreenScale( size )
	return math_Clamp(ScrH() / 1080, 0.6, 1) * size
end

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function()
	MySelf = LocalPlayer()

	GAMEMODE.HookGetLocal = GAMEMODE.HookGetLocal or (function(g) end)
	gamemode.Call("HookGetLocal", MySelf)
end)

function GM:OnReloaded()
	self.BaseClass.OnReloaded(self)

	self:LocalPlayerFound()
end

function GM:InitPostEntity()

	self:LocalPlayerFound()

	/*self.Think = self._Think
	self.HUDShouldDraw = self._HUDShouldDraw
	self.RenderScreenspaceEffects = self._RenderScreenspaceEffects
	self.CalcView = self._CalcView
	self.HUDPaint = self._HUDPaint
	self.HUDPaintBackground = self._HUDPaintBackground
	self.PreDrawViewModel = self._PreDrawViewModel
	self.PostDrawViewModel = self._PostDrawViewModel
	self.HUDDrawTargetID = self._HUDDrawTargetID*/
end

function GM:Think() end

GM.HUDWeaponPickedUp = GM.Think
GM.Think = GM._Think
GM.HUDShouldDraw = GM.Think
GM.HUDDrawTargetID = GM.Think
GM.CalcView = GM.Think
GM.ShouldDrawLocalPlayer = GM.Think
GM.PostDrawOpaqueRenderables = GM.Think
GM.PostDrawTranslucentRenderables = GM.Think
GM.HUDPaint = GM.Think
GM.HUDPaintBackground = GM.Think
GM.CreateMove = GM.Think
GM.PrePlayerDraw = GM.Think
GM.PostPlayerDraw = GM.Think
GM.InputMouseApply = GM.Think
GM.GUIMousePressed = GM.Think
GM.PreDrawViewModel = GM.Think
GM.PostDrawViewModel = GM.Think

function GM:LocalPlayerFound()
	
	self.Think = self._Think
	self.HUDShouldDraw = self._HUDShouldDraw
	self.CalcView = self._CalcView
	--self.ShouldDrawLocalPlayer = self._ShouldDrawLocalPlayer
	--self.PostDrawTranslucentRenderables = self._PostDrawTranslucentRenderables
	self.HUDPaint = self._HUDPaint
	self.HUDPaintBackground = self._HUDPaintBackground
	self.CreateMove = self._CreateMove
	self.GetMotionBlurValues = self._GetMotionBlurValues
	self.HUDDrawTargetID = self._HUDDrawTargetID
	self.PrePlayerDraw = self._PrePlayerDraw
	self.PostPlayerDraw = self._PostPlayerDraw
	self.PreDrawViewModel = self._PreDrawViewModel
	self.PostDrawViewModel = self._PostDrawViewModel
	
	--self.InputMouseApply = self._InputMouseApply
	--self.GUIMousePressed = self._GUIMousePressed
	--self.HUDWeaponPickedUp = self._HUDWeaponPickedUp
	--self.RenderScene = self._RenderScene
	--self.SetupSkyboxFog = self._SetupSkyboxFog
	--self.SetupWorldFog = self._SetupWorldFog
	
	if render.GetDXLevel() >= 80 then
		self.RenderScreenspaceEffects = self._RenderScreenspaceEffects
	end

end

function GM:Initialize( )	

	surface.CreateFont( "ScoreboardHead",{font = "coolvetica", size = 48,weight = 500,antialias = true})
	surface.CreateFont( "ScoreboardSub",{font = "coolvetica", size = 24,weight = 500,antialias = true})
	surface.CreateFont( "ScoreboardText",{font = "Tahoma", size = 16,weight = 1000,antialias = true})


	surface.CreateFont("HL2_15",{font = "HalfLife2", size = 15,weight = 400,antialias = true})	
	surface.CreateFont("HL2_16",{font = "HalfLife2", size = 16,weight = 700,antialias = true})	
	surface.CreateFont("HL2_50",{font = "HalfLife2", size = 50,weight = 400,antialias = true})	
	surface.CreateFont("HL2_55",{font = "HalfLife2", size = 55,weight = 400,antialias = true})	
	surface.CreateFont("HL2_65",{font = "HalfLife2", size = 65,weight = 700,antialias = true})	
	surface.CreateFont("HL2_70",{font = "HalfLife2", size = 70,weight = 500,antialias = true})	
	surface.CreateFont("HL2_80",{font = "HalfLife2", size = 80,weight = 400,antialias = true,additive = true})	
	surface.CreateFont("HL2_90",{font = "HalfLife2", size = 90,weight = 400,antialias = true})	
	surface.CreateFont("HL2_100",{font = "HalfLife2", size = 100,weight = 400,antialias = true})	
	
	surface.CreateFont("Arial_Bold_9",{font = "Arial", size = 9,weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_11",{font = "Arial", size = 11,weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_13",{font = "Arial", size = 13,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_14",{font = "Arial", size = 14,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_16",{font = "Arial", size = 16,weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_18",{font = "Arial", size = 18,weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_20",{font = "Arial", size = 20,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_23",{font = "Arial", size = 23,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_25",{font = "Arial", size = 25,weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_26",{font = "Arial", size = 26,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_30",{font = "Arial", size = 30,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_32",{font = "Arial", size = 32,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Italic_32",{font = "Arial", size = 32,weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_34",{font = "Arial", size = 34,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Italic_34",{font = "Arial", size = 34,weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_36",{font = "Arial", size = 36,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Italic_36",{font = "Arial", size = 36,weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_38",{font = "Arial", size = 38,weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_40",{font = "Arial", size = 40,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_50",{font = "Arial", size = 50,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_60",{font = "Arial", size = 60,weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_70",{font = "Arial", size = 70,weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_80",{font = "Arial", size = 80,weight = 700,antialias = true})	
	
	//Scaled Arial
	surface.CreateFont("Arial_Bold_Scaled_9",{font = "Arial", size = NewScreenScale(9),weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_Scaled_11",{font = "Arial", size = NewScreenScale(11),weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_Scaled_13",{font = "Arial", size = NewScreenScale(13),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_14",{font = "Arial", size = NewScreenScale(14),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_16",{font = "Arial", size = NewScreenScale(16),weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_Scaled_18",{font = "Arial", size = NewScreenScale(18),weight = 700,antialias = true})	
	surface.CreateFont("Arial_Bold_Scaled_Italic_20",{font = "Arial", size = NewScreenScale(20),weight = 1200,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_Scaled_20",{font = "Arial", size = NewScreenScale(20),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_21",{font = "Arial", size = NewScreenScale(21),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_23",{font = "Arial", size = NewScreenScale(23),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_25",{font = "Arial", size = NewScreenScale(25),weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_Scaled_26",{font = "Arial", size = NewScreenScale(26),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_30",{font = "Arial", size = NewScreenScale(30),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_32",{font = "Arial", size = NewScreenScale(32),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_Italic_32",{font = "Arial", size = NewScreenScale(32),weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_Scaled_34",{font = "Arial", size = NewScreenScale(34),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_Italic_34",{font = "Arial", size = NewScreenScale(34),weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_Scaled_36",{font = "Arial", size = NewScreenScale(36),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_Italic_36",{font = "Arial", size = NewScreenScale(36),weight = 700,antialias = true,italic = true})
	surface.CreateFont("Arial_Bold_Scaled_38",{font = "Arial", size = NewScreenScale(38),weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_Scaled_40",{font = "Arial", size = NewScreenScale(40),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_50",{font = "Arial", size = NewScreenScale(50),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_60",{font = "Arial", size = NewScreenScale(60),weight = 700,antialias = true})
	surface.CreateFont("Arial_Bold_Scaled_70",{font = "Arial", size = NewScreenScale(70),weight = 700,antialias = true})		
	surface.CreateFont("Arial_Bold_Scaled_80",{font = "Arial", size = NewScreenScale(80),weight = 700,antialias = true})

	surface.CreateFont("Bison_20",{font = "Bison", size = 20,weight = 500,antialias = true})
	surface.CreateFont("Bison_23",{font = "Bison", size = 23,weight = 500,antialias = true})
	surface.CreateFont("Bison_25",{font = "Bison", size = 25,weight = 500,antialias = true})
	surface.CreateFont("Bison_30",{font = "Bison", size = 30,weight = 500,antialias = true})
	surface.CreateFont("Bison_32",{font = "Bison", size = 32,weight = 500,antialias = true})
	surface.CreateFont("Bison_35",{font = "Bison", size = 35,weight = 500,antialias = true})
	surface.CreateFont("Bison_40",{font = "Bison", size = 40,weight = 500,antialias = true})
	surface.CreateFont("Bison_45",{font = "Bison", size = 45,weight = 500,antialias = true})
	surface.CreateFont("Bison_50",{font = "Bison", size = 50,weight = 500,antialias = true})	
	surface.CreateFont("Bison_55",{font = "Bison", size = 55,weight = 500,antialias = true})
	surface.CreateFont("Bison_60",{font = "Bison", size = 60,weight = 500,antialias = true})
	surface.CreateFont("Bison_65",{font = "Bison", size = 65,weight = 500,antialias = true})
	surface.CreateFont("Bison_70",{font = "Bison", size = 70,weight = 500,antialias = true})	
	surface.CreateFont("Bison_75",{font = "Bison", size = 75,weight = 500,antialias = true})	
	surface.CreateFont("Bison_80",{font = "Bison", size = 80,weight = 500,antialias = true})

	//scaled bison
	surface.CreateFont("Bison_Scaled_20",{font = "Bison", size = NewScreenScale(20),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_23",{font = "Bison", size = NewScreenScale(23),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_25",{font = "Bison", size = NewScreenScale(25),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_30",{font = "Bison", size = NewScreenScale(30),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_32",{font = "Bison", size = NewScreenScale(32),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_35",{font = "Bison", size = NewScreenScale(35),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_40",{font = "Bison", size = NewScreenScale(40),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_45",{font = "Bison", size = NewScreenScale(45),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_50",{font = "Bison", size = NewScreenScale(50),weight = 500,antialias = true})	
	surface.CreateFont("Bison_Scaled_55",{font = "Bison", size = NewScreenScale(55),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_60",{font = "Bison", size = NewScreenScale(60),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_65",{font = "Bison", size = NewScreenScale(65),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_70",{font = "Bison", size = NewScreenScale(70),weight = 500,antialias = true})	
	surface.CreateFont("Bison_Scaled_75",{font = "Bison", size = NewScreenScale(75),weight = 500,antialias = true})
	surface.CreateFont("Bison_Scaled_80",{font = "Bison", size = NewScreenScale(80),weight = 500,antialias = true})
	
	//scaled csd
	surface.CreateFont("CSD_Scaled_40",{font = "csd", size = NewScreenScale(40),weight = 500,antialias = true})
	surface.CreateFont("CSD_Scaled_60",{font = "csd", size = NewScreenScale(60),weight = 500,antialias = true})
	surface.CreateFont("CSD_Scaled_70",{font = "csd", size = NewScreenScale(70),weight = 500,antialias = true})
	
	
	if RadioOn then
		RadioPlay(math_random(1,#Radio))
	end

end

local matTeammate = Material( "SGM/playercircle" )

local mat_circle_bg = Material( "darkestdays/hud/hud_bg.png" )
local mat_circle_red = Material( "darkestdays/hud/hud_health.png" )
local mat_circle_blue = Material( "darkestdays/hud/hud_mana.png" )

local team_circles = {
	[ TEAM_RED ] = mat_circle_red,
	[ TEAM_BLUE ] = mat_circle_blue,
}

local team_outline = {
	[ TEAM_RED ] = team_red_glow,
	[ TEAM_BLUE ] = team_blue_glow,
}

local draw_outline = false
function GM:_PrePlayerDraw( pl )

end

function GM:_PostPlayerDraw( pl )
	
	if DD_TEAMMATECIRCLES and pl ~= MySelf and MySelf:IsTeammate( pl ) and self:GetGametype() ~= "ffa" then
		
		local mat = team_outline[ pl:Team() ]
		
		if mat and not draw_outline and not pl:IsThug() then
			draw_outline = true
			render_MaterialOverride( mat )
			pl:DrawModel()
			render_MaterialOverride()
			draw_outline = false
		end
		
		/*if mat then
			
			local size = 40
			local col = col_white
			
			local rot = math.NormalizeAngle( RealTime() * 20 )
			
			pos.z = pos.z + 2
			
			render_SetMaterial( mat )
			
			render_DrawQuadEasy( pos, vector_up, size, size, col, rot )
			render_DrawQuadEasy( pos, vector_up, size / 1.3, size / 1.3, col, 90 - rot )
			
			render_DrawQuadEasy( pos, vector_up, size, size, col, rot + 180 )
			render_DrawQuadEasy( pos, vector_up, size / 1.3, size / 1.3, col, 90 - rot + 180 )
			
			render_DrawQuadEasy( pos, vector_up * -1, size, size, col, rot * -1 )
			render_DrawQuadEasy( pos, vector_up * -1, size / 1.3, size / 1.3, col, 90 - rot * -1 )
			
			render_DrawQuadEasy( pos, vector_up * -1, size, size, col, rot * -1 + 180 )
			render_DrawQuadEasy( pos, vector_up * -1, size / 1.3, size / 1.3, col, 90 - rot * -1 + 180 )
			
		end*/
		
		/*local col = team_GetColor( P_Team( pl ) )
		
		pos.z = pos.z + 2
		render_SetMaterial( matTeammate )
		
		render_DrawQuadEasy( pos, vector_up, 32, 32, col )
		render_DrawQuadEasy( pos, vector_up * -1, 32, 32, col )*/
		
	end
	
end


table.Shuffle(Radio)

CreateClientConVar("_dd_enableradio", 1, true, false)
RadioOn = util.tobool(GetConVarNumber("_dd_enableradio"))

for k=1, #Radio do
	util.PrecacheSound(Radio[k][1])
end

CurSong = 1
//NextSong = 0
function GM:_Think()

	if RadioOn then
		if NextSong and NextSong < CurTime() then
		
			--RunConsoleCommand("stopsounds")
			
			if CurSong > #Radio then
				CurSong = 1
			end
			
			local toplay = CurSong

			timer.Simple(0.1,function()
				print("Switching to song "..Radio[toplay][1])
				//surface.PlaySound(Radio[toplay][1])
				//LocalPlayer():EmitSound(Radio[toplay][1])
				if MySelf._CurSong then
					MySelf._CurSong:Stop()
				end
				MySelf._CurSong = CreateSound( MySelf, Radio[toplay][1] )
				MySelf._CurSong:Play()
			end)
			
			NextSong = CurTime() + tonumber(Radio[toplay][2]) + 10
			CurSong = CurSong + 1
			
		end
	end
	
end

NextDelay = 0
function RadioPlay( nr )
	
	if NextDelay > CurTime() then return end
	
	NextDelay = CurTime() + 0.3
	
	//RunConsoleCommand("stopsounds")

	RadioOn = true
	
	if (nr >  #Radio) then
		nr = 1
	end
	
	CurSong = nr
	NextSong = 0

	
end

function ToggleRadio( pl,commandName,args )

	local Org = RadioOn
	RadioOn = util.tobool(args[1])

	if RadioOn then 
		RunConsoleCommand("_dd_enableradio","1")
		if not Org then
			MySelf:PrintMessage( HUD_PRINTTALK, "Radio on")
		end
		if MySelf._CurSong then
			MySelf._CurSong:Stop()
		end
		RadioPlay(math_random(1,#Radio))
	else 
		RunConsoleCommand("_dd_enableradio","0")
		if Org then
			MySelf:PrintMessage( HUD_PRINTTALK, "Radio off")
		end
		if MySelf._CurSong then
			MySelf._CurSong:Stop()
		end

	end
end
concommand.Add("dd_enableradio",ToggleRadio) 

ConquestPoints = {}

net.Receive( "RefreshPoints", function( len )	
	
	ConquestPoints = {}
	
	CONQUEST_CAPTURE_TIME = net.ReadDouble() or 5
	
	for _, point in ipairs(ents.FindByClass("conquest_point")) do
		table.insert(ConquestPoints,point)
	end
	
end)


function GM:PlayerDeath( ply, attacker )
end


//some shit from 1st april
wtf = nil
local draw_wtf = false
local last_wep
local tex
wtf_tbl = {
	Material( "models/gman/gman_facehirez" ),
	Material( "models/humans/male/group03/eric_facemap" ),
	Material( "models/humans/male/group03m/van_facemap" ),
	Material( "models/humans/female/group03m/joey_facemap" ),
	Material( "models/humans/female/group03m/kanisha_facemap" ),
	Material( "models/breen/breen_face" ),
	Material( "models/magnusson/magnusson_face" ),
	Material( "models/mossman/mossman_face" ),
	Material( "models/kleiner/walter_face" ),
	Material( "models/monk/grigori_head" ),
}

function GM:_PreDrawViewModel( ViewModel, Player, Weapon )

	if ( !IsValid( Weapon ) ) then return false end	

	if Weapon.PreDrawViewModel then
		Weapon:PreDrawViewModel( ViewModel, Weapon, Player )
	end
	
end

local blood_mat = Material( "models/flesh" )
local parry_mat = Material( "models/spawn_effect2" )
function GM:_PostDrawViewModel( ViewModel, Player, Weapon )
	
	if ( !IsValid( Weapon ) ) then return false end
	
	if Weapon.PostDrawViewModel then 
		Weapon:PostDrawViewModel( ViewModel, Weapon, Player )
	end
	
		
	if ( Weapon.UseHands || !Weapon:IsScripted() ) then

		local hands = Player:GetHands()
		if ( IsValid( hands ) ) then

			hands:DrawModel()	
			
			/*if Weapon.IsParrying and Weapon:IsParrying() then
				render_MaterialOverride( parry_mat )
				local col = team_GetColor( Player )
				//render_SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
				hands:DrawModel()	
				//render_SetColorModulation(1, 1, 1)
				render_MaterialOverride( )
			end*/
			
			if DD_BLOODYMODELS and hands.Bloody then
			
				if hands.BloodScale then
					GAMEMODE.PlayerBloodMaterial:SetFloat( "$detailscale", hands.BloodScale )
				end
						
				GAMEMODE.PlayerBloodMaterial:SetFloat( "$detailblendfactor", hands.Bloody * 1.5 )
			
				render_SetBlend( 1 )
				render_MaterialOverride( GAMEMODE.PlayerBloodMaterial )
				render_SetColorModulation(0.5, 0, 0)
				
				hands:SetupBones()
				hands:DrawModel()
				
				render_SetColorModulation(1, 1, 1)
				render_MaterialOverride( )
				render_SetBlend( 1 )
			end
			
			if Player:IsCarryingFlag() then
				
				local flag = GetHillEntity()
				--render_SetBlend( 1 )
				--flag:SetupBones()
				flag.HandDraw = true
				flag:DrawModel()
				flag.HandDraw = false
				--render_SetBlend( 1 )
				
			end
			
			
		end

	end

end


function ScaleW ( sizew )
	return ScrW() * ( sizew / 1280 )
end

function ScaleH ( sizeh )
	return ScrH() * (sizeh/1024) 
end

/*---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
---------------------------------------------------------*/
/*function GM:_HUDPaint()
	hook.Run( "_HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )
end*/

/*---------------------------------------------------------
   Name: gamemode:HUDPaintBackground( )
   Desc: Same as HUDPaint except drawn before
---------------------------------------------------------*/
function GM:_HUDPaintBackground()
end


local dash_lerp = 0
function GM:_GetMotionBlurValues( x, y, fwd, spin )	
	
	dash_lerp = math_Approach(dash_lerp, (MySelf:IsDashing() and 1) or 0, RealFrameTime() * ((dash_lerp + 1) ^ 1.1))
	
	if dash_lerp > 0 then
		return 0, 0, dash_lerp * 0.1, spin
	else
		return 0, 0, 0, 0
	end

end


local ghosting_lerp = 0
local adrenaline_lerp = 0
local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0

function GM:_RenderScreenspaceEffects()

	ghosting_lerp = math_Approach(ghosting_lerp, (MySelf:IsGhosting() and 1) or 0, RealFrameTime() * ((ghosting_lerp + 1) ^ 1.1))
	
	if ghosting_lerp > 0 then
		tab[ "$pp_colour_colour" ] = 1 - 0.85 * ghosting_lerp
		DrawColorModify( tab )
	end
	
	adrenaline_lerp = math_Approach(adrenaline_lerp, (MySelf:HasAdrenaline() and 1) or 0, RealFrameTime() * ((adrenaline_lerp + 1) ^ 1.6))
	
	if adrenaline_lerp > 0 then
		tab[ "$pp_colour_mulr" ] = 0.8 * adrenaline_lerp
		tab[ "$pp_colour_mulg" ] = -1 * adrenaline_lerp
		tab[ "$pp_colour_mulb" ] = -1 * adrenaline_lerp
		DrawColorModify( tab )
	end

end
/*---------------------------------------------------------
   Name: gamemode:GetTeamNumColor( num )
   Desc: returns the colour for this team num
---------------------------------------------------------*/
function GM:GetTeamNumColor( num )

	return team.GetColor( num )

end


local addroll = 0
local targetroll = 0
local shrink = false
function GM:_CalcView( pl, origin, angles, fov, znear, zfar )
		
	local ct = CurTime()
	local frt = RealFrameTime()
		
	local rag = pl:GetRagdollEntity()
	
	if GAMEMODE.ThirdPerson and pl:Alive() and DD_FULLBODY then
		local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
		if bone then
			if !shrink then
				pl:ManipulateBoneScale( bone, vector_origin  )
				pl:ManipulateBoneScale( bone, vector_origin  )
				pl:ManipulateBoneScale( bone, vector_origin  )
				shrink = true
			end
			if shrink and pl:GetManipulateBoneScale(bone) ~= vector_origin then
				pl:ManipulateBoneScale( bone, vector_origin  )
			end
		end
		
	else
		if shrink then
			local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
			if bone then
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
			end
			shrink = false
		end
	end
	
	
	if !pl:Alive() and IsValid(rag) and !pl:GetRagdollEntity().Sliced and not ( DD_SPECTATEMODE or DD_THIRDPERSONDEATH ) and not (GAMEMODE.ThirdPerson and !DD_FULLBODY) then//and pl:GetObserverMode() ~= OBS_MODE_ROAMING
		local att = rag:GetAttachment(rag:LookupAttachment("eyes"))
		if att then
			return {origin = att.Pos+att.Ang:Forward()*1, angles = att.Ang, znear = 1}
		end
	end
	
	if pl:IsRolling() and not GAMEMODE.ThirdPerson then
		local att = pl:GetAttachment(pl:LookupAttachment("eyes"))
		if att then
			return {origin = att.Pos+att.Ang:Forward()*4, angles = att.Ang, drawviewer = true}
		end
	end
	
	//same as rolling, but we have control over camera
	if pl:IsSliding() and not GAMEMODE.ThirdPerson and DD_IMMERSIVESLIDE then
		local att = pl:GetAttachment(pl:LookupAttachment("eyes"))
		if att then
			return {origin = att.Pos+att.Ang:Forward()*4, angles = angles, drawviewer = true}
		end
	end
	
	targetroll = 0
	
	if pl.RollLeft and pl.RollLeft > ct then
		targetroll = 5
		pl.RollRight = 0
	end
	
	if pl.RollRight and pl.RollRight > ct then
		targetroll = -5
		pl.RollLeft = 0
	end
	
	--addroll = math_Approach(addroll, targetroll, math.max(0.25, math.sqrt(math.abs(addroll)))*frt*30 )
	addroll = math_Approach(addroll, targetroll, frt * 25 )
	
	angles.roll = angles.roll + addroll
	
		
	if GAMEMODE.ThirdPerson and pl:Alive() and DD_FULLBODY then
		local att = pl:GetAttachment(pl:LookupAttachment("eyes"))
		if att then
			return {origin = att.Pos+att.Ang:Forward()*0.1-att.Ang:Up()*1.7, angles = (pl:IsRolling() and att.Ang) or angles, drawviewer = true, fov = fov + fov *0.11, znear = 0.1}
		end
	end
	
	if pl:IsCrow() then
		return {origin = pl:GetThirdPersonCrowCameraPos(origin, angles), angles = angles, drawviewer = true, znear = 0.1}
	end
	if GAMEMODE.ThirdPerson and pl:Alive() then
		local pos,ang = pl:GetThirdPersonCameraPosAng(origin, angles)
		return {origin = pos, angles = pl.camera_ang, drawviewer = true, znear = 0.1}		
	end
	
	return self.BaseClass.CalcView(self, pl, origin, angles, fov, znear, zfar)
	
end

function GM:_CreateMove( cmd ) 
	
	if MySelf.SwitchToWeapon and MySelf.SwitchToWeapon:IsValid() then
		
		cmd:SelectWeapon( MySelf.SwitchToWeapon )
		
		if MySelf:GetActiveWeapon() == MySelf.SwitchToWeapon then
			MySelf.SwitchToWeapon = nil
		end
		
	end
	
end


GM.ThirdPerson = false
local thirdpersonswitch = 0

function GM:PlayerBindPress(ply, bind, pressed)

	if string.find(bind, "+menu") then 
		RunConsoleCommand("spell_switch")
		return true
	end
	
	if string.find(bind, "invnext") or string.find(bind, "invprev") or string.find(bind, "slot") and pressed then 
		//RunConsoleCommand("dd_weaponswitch")
		return ply:FastWeaponSwitch()
	end
	
	if string.find ( bind, "duck" ) then
		if ply:IsCrow() then
			return true
		end
	end
	if string.find ( bind, "+zoom" ) then
		if thirdpersonswitch <= CurTime() then
			self.ThirdPerson = not self.ThirdPerson
			RunConsoleCommand("_dd_thirdperson", self.ThirdPerson and "1" or "0")
			thirdpersonswitch = CurTime() + 0.6
		end
		return true
	end
	if string.find ( bind, "speed" ) then
		if ply:IsCarryingFlag() then
			return true
		end
	end
	if string.find ( bind, "impulse 100" ) then
		if self:GetGametype() == "ts" and ply:Team() == TEAM_THUG then
			
		else
			if ply:Alive() or P_Team( ply ) ~= TEAM_SPECTATOR then
				self:FakeFlashlight()
			end
		end
		return true
	end
end


function GM:FakeFlashlight()
		
	MySelf.NextFlashlight = MySelf.NextFlashlight or 0
	MySelf.FlashlightState = MySelf.FlashlightState or false
	
	if !IsValid( self._FakeFlashlight ) then
		self._FakeFlashlight = ProjectedTexture()
		
		self._FakeFlashlight:SetTexture( "effects/flashlight001" )
		self._FakeFlashlight:SetColor( color_white )
		self._FakeFlashlight:SetEnableShadows( false ) 
		self._FakeFlashlight:SetFOV( 55 )
		self._FakeFlashlight:SetNearZ( 0 ) 
		self._FakeFlashlight:SetFarZ( 750 ) 
		self._FakeFlashlight:SetLinearAttenuation( 100 ) 
		self._FakeFlashlight:SetConstantAttenuation( 0 ) 
		self._FakeFlashlight:SetQuadraticAttenuation( 0 ) 
	end
	
	if MySelf.NextFlashlight > CurTime() then return end
	
	MySelf.FlashlightState = !MySelf.FlashlightState
	
	if MySelf.FlashlightState then
		self._FakeFlashlight:SetPos( EyePos() )
		self._FakeFlashlight:SetAngles( EyeAngles() )
		self._FakeFlashlight:SetNearZ( 4 )
	else
		self._FakeFlashlight:SetPos( EyePos() )
		self._FakeFlashlight:SetAngles( EyeAngles() )
		self._FakeFlashlight:SetNearZ( 0 )
	end
	
	MySelf:EmitSound( "buttons/lightswitch2.wav", 75, MySelf.FlashlightState and 100 or 80 )
	
	self._FakeFlashlight:Update()
	
	MySelf.NextFlashlight = CurTime() + 0.4
	
end

local flashlight_offset = Vector( 0, 0, -5 )

function GM:UpdateFakeFlashlight()
	
	if IsValid( self._FakeFlashlight ) then
		
		local ang = EyeAngles()
		local offset = ang:Forward() * flashlight_offset.x + ang:Right() * flashlight_offset.y + ang:Up() * flashlight_offset.z
		
		
		if MySelf.FlashlightState then
			
			self._FakeFlashlight:SetPos( EyePos() + offset )
			self._FakeFlashlight:SetAngles( ang )
			
			if !MySelf:Alive() or P_Team( MySelf ) == TEAM_SPECTATOR or self:GetGametype() == "ts" and P_Team( MySelf ) == TEAM_THUG then
				MySelf.FlashlightState = false
				self._FakeFlashlight:SetNearZ( 0 )
				//self._FakeFlashlight:Update()
			end
		else
			self._FakeFlashlight:SetPos( EyePos() - vector_up * 5000 )
			self._FakeFlashlight:SetAngles( ang )
			self._FakeFlashlight:SetNearZ( 0 )
		end
		
		self._FakeFlashlight:Update()
		
	end
	
	
end

function GM:PlayerButtonDown( pl, btn )
	
	if pl:Alive() and IsValid(pl._efGrenade) and btn == ( DD_GRENADEBUTTON or KEY_G ) and not pl:IsTyping() then
	
		RunConsoleCommand( "dd_thrownade" )
		
	end
	
end

function GM:ForceDermaSkin()

	//return "example"
	return nil
	
end

function GM:_HUDDrawTargetID()

	if not DD_HUD then return end

	local tr = util.GetPlayerTrace( MySelf, MySelf:GetAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "Bison_45"//"Arial_Bold_25"//"TargetID"
	
	if trace.Entity:IsPlayer() and not trace.Entity:IsGhosting() then
		text = trace.Entity:Nick()
		if not MySelf:IsTeammate(trace.Entity) then//trace.Entity:Team() ~= LocalPlayer():Team() then
			text = text.." (ENEMY)"
		end
		if self:GetGametype() == "ts" and P_Team ( trace.Entity ) == TEAM_THUG and !MySelf:IsTeammate(trace.Entity) then return end
	else
		return
		//text = trace.Entity:GetClass()
	end
	
	if trace.Entity:IsPlayer() and ValidEntity(trace.Entity:GetDTEntity(0)) then return end
	
	surface_SetFont( font )
	local w, h = surface_GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	// The fonts internal drop shadow looks lousy with AA on
	--draw_SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	--draw_SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw_SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ),nil,nil )
	
	y = y + h// + 5
	
	if not MySelf:IsTeammate(trace.Entity) then return end//trace.Entity:Team() ~= LocalPlayer():Team() then return end
	
	local text = trace.Entity:Health() .. "%"
	local font = "Bison_35"//"Arial_Bold_20"//"TargetIDSmall"
	
	surface_SetFont( font )
	local w, h = surface_GetTextSize( text )
	local x =  MouseX  - w / 2
	
	//draw_SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	//draw_SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw_SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ),nil,nil )

end

function GM:RoundTimeLeft()
	return( math_Clamp( ROUNDTIME - CurTime(), 0, ROUNDLENGTH) )
end

usermessage.Hook("ResetSpells",function(um)
	//LocalPlayer().CurrentSpells = {}
	//LocalPlayer().CurrentSpells = {}
end)


function RestoreBoneMods()
	timer.Simple(0,function() 
					if IsValid(MySelf) and IsValid(MySelf:GetActiveWeapon()) then 
						MySelf:GetActiveWeapon():ResetBonePositions()
					end
				end)
end

function ExplosiveEffect(pos, maxrange, damage, dmgtype)
	local pos2 = pos + Vector(0, 0, 12)
	for _, pl in ipairs(player.GetAll()) do
		local rag = pl:GetRagdollEntity()
		if IsValid( rag ) and (not rag.Sliced or rag.Gibbed) then
			local phys = rag:GetPhysicsObject()
			if phys:IsValid() then
				local physpos = phys:GetPos()
				local dist = physpos:Distance(pos)
				if dist < maxrange then
					for i=0, rag:GetPhysicsObjectCount() do
						local subphys = rag:GetPhysicsObjectNum(i)
						if subphys then
							subphys:Wake()
						end
					end
					if damage >= 75 then
						local frozen = rag["frozenplayer"] and 1 or 0
						local effectdata = EffectData()
							effectdata:SetEntity(pl)
							effectdata:SetOrigin(physpos)
							effectdata:SetNormal((physpos - pos):GetNormal())
							effectdata:SetScale(frozen)
						util.Effect( "gib_player", effectdata)
						rag.Gibbed = true
						//if not frozen then
							rag:SetColor(Color(0,0,0,0))
							rag:SetRenderMode(RENDERMODE_TRANSALPHA)
						//end
					else
						if dmgtype == DMG_BURN then
							phys:ApplyForceOffset(damage * 1000 * maxrange / dist * (physpos - pos):GetNormal(), pos2)
							if not rag["burningplayer"] then
								local effectdata = EffectData()
									effectdata:SetOrigin(physpos)
									effectdata:SetEntity(rag)
									rag:SetColor(Color(20,20,20,255))
								util.Effect("burningplayer", effectdata)
								rag:EmitSound("ambient/fire/mtov_flame2.wav", 50, math_random(105, 110))
							end
						elseif dmgtype == DMG_SHOCK then
							phys:ApplyForceOffset(damage * 1000 * maxrange / dist * (physpos - pos):GetNormal(), pos2)
							if not rag["burningplayer"] then
								local effectdata = EffectData()
									effectdata:SetOrigin(physpos)
									effectdata:SetEntity(rag)
								util.Effect("electrocuted", effectdata)
							end
						elseif dmgtype == DMG_DROWN then
							phys:ApplyForceOffset(damage * 500 * maxrange / dist * (physpos - pos):GetNormal(), pos2)
							if not rag["frozenplayer"] then
								local effectdata = EffectData()
									effectdata:SetOrigin(physpos)
									effectdata:SetEntity(rag)
								util.Effect("frozenplayer", effectdata)
							end
						else
							phys:ApplyForceOffset(damage * 1000 * maxrange / dist * (physpos - pos):GetNormal(), pos2)
						end
					end
				end
			end
		end
	end
end

//--------------------------------------------------------------------------------------------------------

local function AddNightFog()

	render_FogMode( 1 ) 
	render_FogStart( 0 )
	render_FogEnd( 850  )
	render_FogMaxDensity( 1 )

	
	render_FogColor( 0.0 * 255, 0.0 * 255, 0.0 * 255 )

	return true

end

local function AddNightFogSkybox(skyboxscale)

	render_FogMode( 1 ) 
	render_FogStart( 0*skyboxscale )
	render_FogEnd( 850*skyboxscale  )
	render_FogMaxDensity( 1 )

	
	render_FogColor( 0.0 * 255, 0.0 * 255, 0.0 * 255 )

	return true

end

local col_red = Color( 255, 55, 55, 255 )
local function ThugVision()

	local todraw = MySelf and IsValid(MySelf) and MySelf:Alive() and P_Team( MySelf ) == TEAM_THUG

	if !todraw then
		if IsValid(GAMEMODE._ThugFlashlight) then
			GAMEMODE._ThugFlashlight:Remove()
			GAMEMODE._ThugFlashlight = nil
		end
		return
	end

	local pos, ang = EyePos(), EyeAngles()

	if !IsValid( GAMEMODE._ThugFlashlight ) then
		GAMEMODE._ThugFlashlight = ProjectedTexture()

		GAMEMODE._ThugFlashlight:SetTexture( "effects/flashlight001" )
		GAMEMODE._ThugFlashlight:SetColor( col_red  )
		GAMEMODE._ThugFlashlight:SetEnableShadows( false )
		GAMEMODE._ThugFlashlight:SetFOV( 90 )
		GAMEMODE._ThugFlashlight:SetNearZ( 0 )
		GAMEMODE._ThugFlashlight:SetFarZ( 6000 )
		GAMEMODE._ThugFlashlight:SetLinearAttenuation( 100 )
		GAMEMODE._ThugFlashlight:SetConstantAttenuation( 0 )
		GAMEMODE._ThugFlashlight:SetQuadraticAttenuation( 0 )
	end

	GAMEMODE._ThugFlashlight:SetPos( pos )
	GAMEMODE._ThugFlashlight:SetAngles( ang )
	GAMEMODE._ThugFlashlight:SetNearZ( 8 )

	GAMEMODE._ThugFlashlight:Update()

end

local is_night = false
local redownloaded_lightmaps = false

net.Receive( "CheckNight", function( len )

	local server_night = net.ReadBool()

	//enable
	if server_night and !is_night then
		hook.Add( "SetupWorldFog","AddNightFog", AddNightFog )
		hook.Add( "SetupSkyboxFog","AddNightFogSkybox", AddNightFogSkybox )
		hook.Add( "HUDPaint", "AddThugVision", ThugVision )
		is_night = true

		if !redownloaded_lightmaps then
			timer.Simple(1, function()
				render.RedownloadAllLightmaps( true )
			end)
			redownloaded_lightmaps = true
		end

	end

	//remove
	if !server_night and is_night then
		hook.Remove( "SetupWorldFog","AddNightFog" )
		hook.Remove( "SetupSkyboxFog","AddNightFogSkybox" )
		hook.Remove( "HUDPaint","AddThugVision" )
		is_night = false

		if IsValid(GAMEMODE._ThugFlashlight) then
			GAMEMODE._ThugFlashlight:Remove()
			GAMEMODE._ThugFlashlight = nil
		end

	end

end)



net.Receive( "AchievementNotify", function( len )
	local key = net.ReadString()
	
	//if Stats and Stats["achievements"] then
	//	Stats["achievements"][key] = true
	//end
	
	if Stats and Stats["achievements"] then
		table.insert( Stats["achievements"], key )
		AddAchievementNotice(key)
		SaveStats()
	end
	
end)

net.Receive( "SendStatsToClient", function( len )

	local stats = net.ReadTable()
	
	if not Stats then
		Stats = {}
	end
	
	Stats = table.Copy(stats)
	
end)

net.Receive( "Client:ReadStats", function( len )
	
	ReadStats()
	
end)

net.Receive( "UpdateScore", function( len )

	local key = net.ReadString()
	local am = net.ReadDouble()
	
	if Stats and Stats["stats"] and Stats["stats"][key] then
		Stats["stats"][key] = Stats["stats"][key] + am
	end
	
end)

net.Receive( "UpdateStatsQuick", function( len )

	local stats = net.ReadTable()
	
	if Stats and Stats["stats"] then
		for key,stuff in pairs(stats) do
			if Stats["stats"][key] then
				Stats["stats"][key] = stuff
			end
		end
	end
	
end)

net.Receive( "SetTotalSpeed", function( len )

	local speed = net.ReadDouble()
	local runspeed = net.ReadDouble()
	
	if !IsValid(MySelf) then return end
	
	MySelf:SetWalkSpeed(speed)
	MySelf:SetRunSpeed(runspeed)
	
end)

net.Receive( "UpdateModelScale", function( len )

	local scale = net.ReadDouble()
	local ent = net.ReadEntity()
	
	if !IsValid(MySelf) then return end
	
	if IsValid(ent) then
		ent:SetModelScale(scale,0)
	end

end)

net.Receive( "SetPerk", function( len )	
	if !IsValid(MySelf) then return end
	
	local prk = net.ReadString()
	local pl = net.ReadEntity()
	
	if prk and pl then
		pl.Perks = prk
	end

end)

net.Receive( "PlayerSetupSkillStats", function( len )	
	if !IsValid( MySelf ) then return end
	
	local strength = net.ReadInt( 32 )
	local magic = net.ReadInt( 32 )
	local gunmastery = net.ReadInt( 32 )
	
	MySelf._DefaultMeleeBonus = PLAYER_DEFAULT_MELEE_BONUS * 1 + SKILL_STRENGTH_DAMAGE_PER_LEVEL * strength
	MySelf._DefaultMeleeSpeedBonus = PLAYER_DEFAULT_MELEE_SPEED_BONUS * 1 + SKILL_STRENGTH_MELEE_SPEED_PER_LEVEL * strength
	MySelf._DefaultMResBonus = PLAYER_DEFAULT_MAGIC_RESISTANCE_BONUS * 1 + PLAYER_DEFAULT_MAGIC_RESISTANCE_BONUS * strength
	MySelf._DefaultDodgeBonus = PLAYER_DEFAULT_DODGE_BONUS * 1 + SKILL_STRENGTH_DODGE_PER_LEVEL * strength
	MySelf._DefaultMeleeVampirismBonus = PLAYER_DEFAULT_MELEE_VAMPIRISM_BONUS + SKILL_STRENGTH_VAMPIRISM_PER_LEVEL * strength
	MySelf._DefaultMagicBonus = PLAYER_DEFAULT_MAGIC_DMG_BONUS * 1 + SKILL_MAGIC_DAMAGE_PER_LEVEL * magic
	MySelf._DefaultMChannelingBonus = PLAYER_DEFAULT_MAGIC_CHANNELING_BONUS * 1 + SKILL_MAGIC_CHANNELING_PER_LEVEL * magic
	MySelf._DefaultBulletFalloffBonus = PLAYER_DEFAULT_BULLET_FALLOFF_BONUS * 1 + SKILL_BULLET_FALLOFF_PER_LEVEL * gunmastery
	MySelf._DefaultBulletConsumeBonus = PLAYER_DEFAULT_BULLET_CONSUME_BONUS * 1 + SKILL_BULLET_CONSUME_PER_LEVEL * gunmastery
	MySelf._DefaultBulletScavegerBonus = PLAYER_DEFAULT_BULLET_SCAVENGER_BONUS * 1 + SKILL_BULLET_SCAVENGER_PER_LEVEL * gunmastery

end)

net.Receive( "ShowFirstHelp", function( len )	
	if !IsValid(MySelf) then return end
	
	HelpDieTime = CurTime() + 35

end)

net.Receive( "SendSkillsToClient", function( len )

	local skills = net.ReadTable()
	
	if not PlayerSkills then
		PlayerSkills = {}
	end
	
	PlayerSkills = table.Copy(skills)
	
	//PrintTable(PlayerSkills)
	
end)

local function SendAchievements( ent_ind )
	
	if Stats and Stats["achievements"] then
		
		local tbl = {}
		
		for _, ach in pairs( Stats["achievements"] ) do
			if Achievements[ach] then
				table.insert( tbl, ach )
			end
		end
		
		net.Start( "ReceiveAchievements" )
			net.WriteInt( ent_ind, 32 )
			net.WriteTable( tbl )
		net.SendToServer()
		
	end
	
end

net.Receive( "RequestAchievements", function( len )

	//just in case if LocalPlayer is not initialized yet
	local ent_ind = net.ReadInt( 32 )
	SendAchievements( ent_ind )
end)

function GetPlayerSkills( slot )
	slot = slot or 1
	return Stats and Stats["player_stuff"] and Stats["player_stuff"][slot] and Stats["player_stuff"][slot] and Stats["player_stuff"][slot]["skills"]
end

function GetBlankStats()

	local tbl = {}
	tbl["stats"] = {}
	tbl["achievements"] = {}
	tbl["player_stuff"] = {}
	for i=1, 3 do
		tbl["player_stuff"][i] = {
			["skills"] = {
				Total = SKILL_XP_START,
				ToSpend = SKILL_XP_START,
				["magic"] = 0,
				["strength"] = 0,
				["agility"] = 0,
			},
			["loadout"] = { "dd_mp5","dd_axe","electrobolt","firebolt" },
			["build"] = "default"
		}
	end
		
	for key,d in pairs(RandomData) do
		tbl["stats"][key] = 0
	end
		
	return tbl

end

function WriteBlankStats()
	
	local hasfolder = file.IsDir( "darkestdays/my_profile", "DATA" )
	
	if not hasfolder then
		file.CreateDir( "darkestdays/my_profile" )
	end
	
	local path = "darkestdays/my_profile/player.txt"
	local stats = util.TableToJSON(GetBlankStats())
	
	file.Write( path, stats )
	
end

function ReadStats()
		
	local path = "darkestdays/my_profile/player.txt"
	if not file.Exists( path, "DATA" ) then
		WriteBlankStats()
	end

	local filestats = util.JSONToTable(file.Read( path ))
	
	Stats = table.Copy(GetBlankStats())
	table.Merge( Stats, filestats )

	//self.Skills = self.Stats["skills"]

	
	print("--> Got stats for player")

end

function SaveStats()
	
	if not Stats then return end
	
	//self.Stats["stats"]["time"] = math.max(0,math.floor(self.Stats["stats"]["time"]+CurTime()-(self.StartTime or CurTime()))) //fix self.StartTime
		
	//self.Stats["skills"] = self.Skills
	
	local path = "darkestdays/my_profile/player.txt"
	local stats = util.TableToJSON(Stats)
	
	file.Write( path, stats )
		
end