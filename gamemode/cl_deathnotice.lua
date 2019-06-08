local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice" )

// These are our kill icons
local Color_Icon = Color(231,231,231,255)//Color( 255, 255, 255, 255 ) 
local NPC_Color = Color( 250, 50, 50, 255 ) 

killicon.AddFont( "prop_physics", 		"HL2MPTypeDeath", 	"9", 	Color_Icon )
killicon.AddFont( "prop_physics_multiplayer", 		"HL2MPTypeDeath", 	"9", 	Color_Icon )
killicon.AddFont( "weapon_smg1", 		"HL2MPTypeDeath", 	"/",	Color_Icon )
killicon.AddFont( "weapon_357", 		"HL2MPTypeDeath", 	".", 	Color_Icon )
killicon.AddFont( "weapon_ar2", 		"HL2MPTypeDeath", 	"2", 	Color_Icon )
killicon.AddFont( "crossbow_bolt", 		"HL2MPTypeDeath", 	"1", 	Color_Icon )
killicon.AddFont( "weapon_shotgun", 	"HL2MPTypeDeath", 	"0", 	Color_Icon )
killicon.AddFont( "rpg_missile", 		"HL2MPTypeDeath", 	"3", 	Color_Icon )
killicon.AddFont( "npc_grenade_frag", 	"HL2MPTypeDeath", 	"4", 	Color_Icon )
killicon.AddFont( "weapon_pistol", 		"HL2MPTypeDeath", 	"-", 	Color_Icon )
killicon.AddFont( "prop_combine_ball", 	"HL2MPTypeDeath", 	"8", 	Color_Icon )
killicon.AddFont( "grenade_ar2", 		"HL2MPTypeDeath", 	"7", 	Color_Icon )
killicon.AddFont( "weapon_stunstick", 	"HL2MPTypeDeath", 	"!", 	Color_Icon )
killicon.AddFont( "weapon_slam", 		"HL2MPTypeDeath", 	"*", 	Color_Icon )
killicon.AddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color_Icon )

killicon.AddFont( "worldspawn", "Bison_30", "obliterated", Color(231, 231, 231, 255 ) ) 

AddSpellIcon("projectile_bloodtrap","bloodtrap")

language.Add("worldspawn","Cruel World")

local Deaths = {}

local function PlayerIDOrNameToString( var )

	if ( type( var ) == "string" ) then 
		if ( var == "" ) then return "" end
		return "#"..var 
	end
	
	local ply = Entity( var )
	
	if (ply == NULL) then return "NULL!" end
	
	return ply:Name()
	
end


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
	GAMEMODE:AddDeathNotice( nil, 0, "suicide", victim:Name(), victim:Team() )

end)
	

net.Receive( "PlayerKilled", function( len )

	local victim 	= net.ReadEntity();
	local inflictor	= net.ReadString();
	local attacker 	= "#" .. net.ReadString();
			
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end)
	

local function RecvPlayerKilledNPC( message )

	local victimtype = message:ReadString();
	local victim 	= "#" .. victimtype;
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();
			
	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim, -1 )
	
	local bIsLocalPlayer = (IsValid(attacker) && attacker == MySelf)
	
	local bIsEnemy = IsEnemyEntityName( victimtype )
	local bIsFriend = IsFriendEntityName( victimtype )
	
	if ( bIsLocalPlayer && bIsEnemy ) then
		achievements.IncBaddies();
	end
	
	if ( bIsLocalPlayer && bIsFriend ) then
		achievements.IncGoodies();
	end
	
	if ( bIsLocalPlayer && (!bIsFriend && !bIsEnemy) ) then
		achievements.IncBystander();
	end

end
	
usermessage.Hook( "PlayerKilledNPC", RecvPlayerKilledNPC )


local function RecvNPCKilledNPC( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
			
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1 )

end
	
usermessage.Hook( "NPCKilledNPC", RecvNPCKilledNPC )




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
		Death.left = nil
		Death.icon = "suicide"
	end
	
	table.insert( Deaths, Death )

end
local grad = surface.GetTextureID( "gui/center_gradient" )
local hud_bg4 = Material( "darkestdays/hud/hud_bg4.png" )
local math = math
local function DrawDeath( x, y, death, hud_deathnotice_time )

	local w, h = killicon.GetSize( death.icon )
	
	if IsSpellIcon(death.icon) then
		w,h = GetSpellIconSize()
	end
	
	surface.SetFont("Bison_30")
	local lw,lh = surface.GetTextSize(death.left or "test")
	local rw,rh = surface.GetTextSize(death.left or "test")
	
	local gw,gh = math.max(lw,rw),math.max(lh,rh)
	
	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()
	
	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	death.color1.a = alpha
	death.color2.a = alpha
	
	//surface.SetTexture(grad)
	surface.SetMaterial(hud_bg4)
	surface.SetDrawColor(0, 0, 0, math.Clamp( fadeout * 200, 0, 200 ) )//255
	local bW = 200//gw+w+32
	local bH = bW/3
	surface.DrawTexturedRectRotated(x,y,bW,bH,0)
	
	// Draw Icon
	if IsSpellIcon(death.icon) then
		DrawSpellIcon( x, y, death.icon, alpha )
	else
		killicon.Draw( x, y-8, death.icon, alpha )
	end
		
	// Draw KILLER
	if (death.left) then
		draw.SimpleText( death.left, 	"Bison_30", x - (w/2) - 16, y, 		death.color1, 	TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER )
	end
	
	// Draw VICTIM
	draw.SimpleText( death.right, 		"Bison_30", x + (w/2) + 16, y, 		death.color2, 	TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )
	
	return (y + h*0.70)

end


function GM:DrawDeathNotice( x, y )

	if not DD_HUD then return end
	
	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()
	
	// Draw
	for k, Death in pairs( Deaths ) do

		if (Death.time + hud_deathnotice_time > CurTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
		
	end
	
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time > CurTime()) then
			return
		end
	end
	
	Deaths = {}

end
