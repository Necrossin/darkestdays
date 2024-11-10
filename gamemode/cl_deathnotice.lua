local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice" )

local Color_Icon = Color(231,231,231,255)
local NPC_Color = Color( 250, 50, 50, 255 )

local surface = surface
local Msg = Msg
local Color = Color
local Material = Material

local draw_SimpleText = draw.SimpleText

local def = Material("HUD/killicons/default")

local Icons = {}
local TYPE_FONT = 0
local TYPE_MATERIAL = 1
local TYPE_SPELL = 2

function GM:KilliconAddFont( name, font, character, color, translate, heightScale )

	if font == "CSKillIcons" then
		heightScale = 0.35
	end

	if font == "HL2MPTypeDeath" then
		heightScale = 0.5
	end
	
	Icons[name] = {
		type		= TYPE_FONT,
		font		= font,
		character	= character,
		color		= color or Color( 255, 80, 0 ),

		translate 	= translate,
		heightScale = heightScale
	}

end

function GM:KilliconAddFontTranslated( name, font, character, color, heightScale )

	self:KilliconAddFont( name, font, character, color, true, heightScale )

end


function GM:KilliconAdd( name, material, color )

	Icons[name] = {
		type		= TYPE_MATERIAL,
		material	= Material( material ),
		color		= color or Color( 255, 255, 255 )
	}

end

function GM:KilliconAddSpell( name, alias )

	Icons[name] = {
		type		= TYPE_SPELL,
		material	= Spells[alias] and Spells[alias].Mat or def,
		color		= Color( 255, 255, 255 )
	}

end

function GM:KilliconAddAlias( name, alias )

	Icons[name] = Icons[alias]

end

function GM:KilliconExists( name )

	return Icons[name] != nil

end

local function KilliconGetSize( name, dontEqualizeHeight )

	if ( !Icons[name] ) then
		Msg( "Warning: killicon not found '" .. name .. "'\n" )
		Icons[name] = Icons["default"]
	end

	local t = Icons[name]

	if ( t.size ) then

		if ( !dontEqualizeHeight ) then return t.size.adj_w, t.size.adj_h end

		return t.size.w, t.size.h
	end

	local w, h = 0, 0

	if ( t.type == TYPE_FONT ) then

		surface.SetFont( t.font )
		w, h = surface.GetTextSize( t.translate and  translate.Get( t.character ) or t.character )

		if ( t.heightScale ) then h = h * t.heightScale end

	elseif ( t.type == TYPE_MATERIAL ) then

		w, h = t.material:Width(), t.material:Height()

	elseif ( t.type == TYPE_SPELL ) then

		w = 50
		h = 50

	end

	t.size = {}
	t.size.w = w or 32
	t.size.h = h or 32

	if ( t.type == TYPE_FONT ) then
		t.size.adj_w, t.size.adj_h = surface.GetTextSize( t.translate and translate.Get( t.character ) or t.character )
	else
		surface.SetFont( "HL2MPTypeDeath" )
		local _, fh = surface.GetTextSize( "0" )
		fh = fh * 0.75

		t.size.adj_w = w * ( fh / h )
		t.size.adj_h = fh
	end

	if ( !dontEqualizeHeight ) then return t.size.adj_w, t.size.adj_h end

	return w, h

end

local function KilliconDrawInternal( x, y, name, alpha, noCorrections, dontEqualizeHeight )

	alpha = alpha or 255

	if ( !Icons[name] ) then
		Msg( "Warning: killicon not found '" .. name .. "'\n" )
		Icons[name] = Icons["default"]
	end

	local t = Icons[name]

	local w, h = KilliconGetSize( name, dontEqualizeHeight )

	if ( !noCorrections ) then x = x - w * 0.5 end

	if ( t.type == TYPE_FONT ) then

		if ( noCorrections and !dontEqualizeHeight ) then
			local _, h2 = KilliconGetSize( name, !dontEqualizeHeight )
			y = y + ( h - h2 ) / 2
		end

		if ( !noCorrections ) then y = y - h * 0.1 end

		surface.SetTextPos( x, y )
		surface.SetFont( t.font )
		surface.SetTextColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawText( t.translate and translate.Get( t.character ) or t.character )

	end

	if ( t.type == TYPE_MATERIAL ) then

		if ( !noCorrections ) then y = y - h * 0.3 end

		surface.SetMaterial( t.material )
		surface.SetDrawColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawTexturedRect( x, y, w, h )

	end

	if ( t.type == TYPE_SPELL ) then

		if ( !noCorrections ) then y = y - h * 0.3 end

		//x = x - w * 0.5
		//y = y - h * 0.5

		surface.SetMaterial( t.material )
		surface.SetDrawColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawTexturedRect( x, y, w, h )

	end

end

-- Reset this when language is changed
function GM:ResetKilliconSizeData()

	for name, data in pairs( Icons ) do
		Icons[ name ].size = nil
	end

end

function GM:KilliconDraw( x, y, name, alpha )

	KilliconDrawInternal( x, y, name, alpha )

end

function GM:KilliconRender( x, y, name, alpha, dontEqualizeHeight )

	KilliconDrawInternal( x, y, name, alpha, true, dontEqualizeHeight )

end

GM:KilliconAdd( "default", "HUD/killicons/default", Color( 255, 80, 0, 255 ) )
//GM:KilliconAddAlias( "suicide", "default" )

GM:KilliconAddFont( "prop_physics", 		"HL2MPTypeDeath", 	"9", 	Color_Icon )
GM:KilliconAddFont( "prop_physics_multiplayer", 		"HL2MPTypeDeath", 	"9", 	Color_Icon )
GM:KilliconAddFont( "weapon_smg1", 		"HL2MPTypeDeath", 	"/",	Color_Icon )
GM:KilliconAddFont( "weapon_357", 		"HL2MPTypeDeath", 	".", 	Color_Icon )
GM:KilliconAddFont( "weapon_ar2", 		"HL2MPTypeDeath", 	"2", 	Color_Icon )
GM:KilliconAddFont( "crossbow_bolt", 		"HL2MPTypeDeath", 	"1", 	Color_Icon )
GM:KilliconAddFont( "weapon_shotgun", 	"HL2MPTypeDeath", 	"0", 	Color_Icon )
GM:KilliconAddFont( "rpg_missile", 		"HL2MPTypeDeath", 	"3", 	Color_Icon )
GM:KilliconAddFont( "npc_grenade_frag", 	"HL2MPTypeDeath", 	"4", 	Color_Icon )
GM:KilliconAddFont( "weapon_pistol", 		"HL2MPTypeDeath", 	"-", 	Color_Icon )
GM:KilliconAddFont( "prop_combine_ball", 	"HL2MPTypeDeath", 	"8", 	Color_Icon )
GM:KilliconAddFont( "grenade_ar2", 		"HL2MPTypeDeath", 	"7", 	Color_Icon )
GM:KilliconAddFont( "weapon_stunstick", 	"HL2MPTypeDeath", 	"!", 	Color_Icon )
GM:KilliconAddFont( "weapon_slam", 		"HL2MPTypeDeath", 	"*", 	Color_Icon )
GM:KilliconAddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color_Icon )

GM:KilliconAddFontTranslated( "worldspawn", "Bison_30", "killicon_worldspawn", Color(231, 231, 231, 255 ) )
GM:KilliconAddFontTranslated( "trigger_hurt", "Bison_30", "killicon_trigger_hurt", Color(231, 231, 231, 255 ) )
GM:KilliconAddFontTranslated( "suicide", "Bison_30", "killicon_self", Color(231, 231, 231, 255 ) )

GM:KilliconAddSpell( "projectile_bloodtrap", "bloodtrap" )

local EntityTranslate = {
	["worldspawn"] = "hud_death_worldspawn",
	["trigger_hurt"] = "hud_death_trigger",
}

//language.Add("worldspawn","Cruel World")
//language.Add("trigger_hurt","Deadly Trigger")

local Deaths = {}


net.Receive( "PlayerKilledByPlayer", function( len )

	local victim 	= net.ReadEntity();
	local inflictor	= net.ReadString();
	local attacker 	= net.ReadEntity();

	if !IsValid(attacker) or !IsValid(victim) then return end

	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team() )

end)


net.Receive( "PlayerKilledSelf", function( len )

	local victim 	= net.ReadEntity()
	if ( !IsValid( victim ) ) then return end
	GAMEMODE:AddDeathNotice( victim:Name(), victim:Team(), "suicide", "", victim:Team() )

end)


net.Receive( "PlayerKilled", function( len )

	local victim 	= net.ReadEntity();
	local inflictor	= net.ReadString();
	local attacker 	= net.ReadString();

	if EntityTranslate[ attacker ] then
		attacker = translate.Get( EntityTranslate[ attacker ] )
	end

	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end)
	

net.Receive( "PlayerKilledNPC", function()

	local victimtype = net.ReadString()
	local inflictor = net.ReadString()
	local attacker = net.ReadEntity()

	--
	-- For some reason the killer isn't known to us, so don't proceed.
	--
	if ( !IsValid( attacker ) ) then return end

	hook.Run( "AddDeathNotice", attacker:Name(), attacker:Team(), inflictor, "#" .. victimtype, -1, 0 )

	local bIsLocalPlayer = ( IsValid( attacker ) && attacker == LocalPlayer() )
	if ( bIsLocalPlayer ) then
		HandleAchievements( victimtype )
	end

end )

net.Receive( "NPCKilledNPC", function()

	local victim	= "#" .. net.ReadString()
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()

	hook.Run( "AddDeathNotice", attacker, -1, inflictor, victim, -1, 0 )

end )




/*---------------------------------------------------------
   Name: gamemode:AddDeathNotice( Victim, Attacker, Weapon )
   Desc: Adds an death notice entry
---------------------------------------------------------*/
function GM:AddDeathNotice( Victim, team1, Inflictor, Attacker, team2 )

	local Death = {}
	Death.victim 	= 	Victim
	Death.attacker	=	Attacker
	Death.time		=	CurTime()

	Death.left		= 	Victim
	Death.right		= 	Attacker
	Death.icon		=	Inflictor

	if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color )
	else Death.color1 = table.Copy( team.GetColor( team1 ) ) end

	if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color )
	else Death.color2 = table.Copy( team.GetColor( team2 ) ) end

	if (Death.left == Death.right) then
		Death.right = nil
		Death.icon = "suicide"
	end

	table.insert( Deaths, Death )

end


local hud_bg4 = Material( "darkestdays/hud/hud_bg4.png" )
local math = math
local function DrawDeath( x, y, death, hud_deathnotice_time )

	local w, h = KilliconGetSize( death.icon )

	surface.SetFont("Bison_30")

	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()

	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	death.color1.a = alpha
	death.color2.a = alpha

	surface.SetMaterial(hud_bg4)
	surface.SetDrawColor(0, 0, 0, math.Clamp( fadeout * 200, 0, 200 ) )

	local bW = 200
	local bH = bW / 3

	surface.DrawTexturedRectRotated( x, y + h / 2, bW, bH, 0 )

	GAMEMODE:KilliconRender( x - w / 2, y, death.icon, alpha )

	// Draw KILLER
	if (death.left) then
		draw.SimpleText( death.left, 	"Bison_30", x - (w/2) - 16, y + h / 2, 		death.color1, 	TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER )
	end

	// Draw VICTIM
	draw.SimpleText( death.right, 		"Bison_30", x + (w/2) + 16, y + h / 2, 		death.color2, 	TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )

	return (y + h * 0.70)

end


function GM:DrawDeathNotice( x, y )

	if not DD_HUD then return end
	
	local hud_deathnotice_time_val = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()
	
	// Draw
	for k, Death in pairs( Deaths ) do

		if (Death.time + hud_deathnotice_time_val > CurTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time_val )
		
		end
		
	end
	
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time_val > CurTime()) then
			return
		end
	end
	
	Deaths = {}

end
