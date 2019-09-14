local grad = surface.GetTextureID( "gui/center_gradient" )
local gradleft = surface.GetTextureID( "gui/gradient" )//
local graddown = surface.GetTextureID("VGUI/gradient_down")
local gradright = surface.GetTextureID( "VGUI/gradient-r" )


local ms_left = Material( "darkestdays/hud/ms_left.png" )
local ms_right = Material( "darkestdays/hud/ms_right.png" )

local hud_bg = Material( "darkestdays/hud/hud_bg.png" )
local hud_bg2 = Material( "darkestdays/hud/hud_bg2.png" )
local hud_bg3 = Material( "darkestdays/hud/hud_bg3.png" )
local hud_bg4 = Material( "darkestdays/hud/hud_bg4.png" )
local hud_bullet = Material( "darkestdays/hud/bullet.png" )
local hud_health = Material( "darkestdays/hud/hud_health.png" )
local hud_mana = Material( "darkestdays/hud/hud_mana.png" )

local hud_grenade = Material( "darkestdays/hud/grenade.png" )


local surface = surface
local draw = draw
local math = math
local team = team
local vgui = vgui
local render = render
local ValidEntity = IsValid
local Color = Color
local string = string

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_PlaySound = surface.PlaySound
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

local render_SetScissorRect = render.SetScissorRect

local draw_SimpleText = draw.SimpleText

local team_GetPlayers = team.GetPlayers
local team_GetColor = team.GetColor
local team_GetScore = team.GetScore
local team_NumPlayers = team.NumPlayers

local math_Round = math.Round
local math_Clamp = math.Clamp
local math_random = math.random
local math_Approach = math.Approach

local ScrW = ScrW
local ScrH = ScrH
local EF_DIMLIGHT = EF_DIMLIGHT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team

local vector_up = vector_up

local col_231_231_231_170 = Color (231, 231, 231, 170)

DD_HUD = util.tobool( CreateClientConVar("_dd_hud", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_hud", function(cvar, oldvalue, newvalue)
	DD_HUD = util.tobool( newvalue )
end)

DD_NUMERIC_HUD = util.tobool( CreateClientConVar("_dd_numerichud", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_numerichud", function(cvar, oldvalue, newvalue)
	DD_NUMERIC_HUD = util.tobool( newvalue )
end)


local VoiceMenuOpened = false
local selected = "none"
local nextopen = 0

local VoiceKeys = {
	["agree"] = "Agree",
	["disagree"] = "Disagree",
	["follow"] = "Follow me",
	["taunt"] = "Taunt",
	["help"] = "Help",
	["sorry"] = "Sorry",
}

local function ConfirmVoiceCommand(delay)
	if VoiceMenuOpened then
		VoiceMenuOpened = false
		gui.EnableScreenClicker(false) 
		if selected ~= "none" then
			RunConsoleCommand("dd_voicecommand",tostring(selected))
		end
		if delay then
			nextopen = CurTime() + delay
		end
	end
end

function DrawVoiceMenu(MySelf)

	local w,h = ScrW(), ScrH()

	if input.IsKeyDown(DD_VOICEBUTTON) and !MySelf:IsTyping() and nextopen < CurTime() then
		if not VoiceMenuOpened then
			VoiceMenuOpened = true
			gui.EnableScreenClicker(true) 
			gui.SetMousePos(w/2,h/2)
			selected = "none"
		end
	else
		ConfirmVoiceCommand(0.2)
	end
	
	if VoiceMenuOpened then
	
		local count = 0
		for k,v in pairs(VoiceAdvanced[MySelf:GetVoiceSet()].Commands or {}) do
			count = count + 1
		end
		local step = 360 / count
		
		local mx = gui.MouseX() - w/2
		local my = gui.MouseY() - h/2
	
		local msangle = math.deg(math.atan2(my,-mx)) - 270 - 180
		while (msangle < 0) do msangle = msangle + 360 end

		//draw_SimpleText(msangle ,"Default",gui.MouseX(),gui.MouseY(), Color(231, 231, 231, 170),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
		local angle = 0
		for i,item in pairs(VoiceAdvanced[MySelf:GetVoiceSet()].Commands or {}) do
				
			local x = (w/2) + (math.sin(math.rad(angle)) * 125)
			local y = (h/2) + (math.cos(math.rad(angle)) * 125)
			
			local font = "Bison_40"
			
			local min = angle - step/2
			local max = angle + step/2
			
			if angle == 0 then
				if msangle > 360-step/2 and msangle < 360 or msangle > 0 and msangle < step/2 then
					font = "Bison_55"
					selected = i
				end
			else
				if msangle > min and msangle < max then
					font = "Bison_55"
					selected = i
				end
			end
		
			local dis = Vector((w/2),(h/2),0):Distance(Vector(gui.MouseX(),gui.MouseY(),0))
			if (dis < 55) then 
				font = "Bison_40"
				selected = "none"
			end
			

			draw_SimpleText( VoiceKeys[i] or i,font,x,y, Color(231, 231, 231, 170),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )//VoiceKeys[i] or i
		
			angle = angle + step
		end
	
	end
	

end

function VoiceMenuMousePress(mc)
	ConfirmVoiceCommand(1)
end
hook.Add("GUIMousePressed","VoiceMenuMousePress",VoiceMenuMousePress)


function DrawAmmoSpells(MySelf)

	local w,h = ScrW(),ScrH()
	//local MySelf = LocalPlayer()
	
	local wep = MySelf:GetActiveWeapon()
	
	if !ValidEntity(wep) then return end
	
	local clip = wep:Clip1() or 0
	
	local tW = 140
	local tH = tW/1.333333//200
	local posX,posY = w-100-tW/2,h-50-tH/2
	
	if IsValid(MySelf._efGrenade) and MySelf._efGrenade.IsReady and MySelf._efGrenade:IsReady() then
		
		local nadeW,nadeH = 75,75
		
		surface_SetDrawColor( 255, 255, 255, 240)
		surface_SetMaterial(hud_grenade)
		
		surface_DrawTexturedRect(posX+tW/2-nadeW*1.4,posY-tH/2-nadeH*0.8,nadeW,nadeH)
		draw_SimpleText(string.upper( input.GetKeyName( DD_GRENADEBUTTON or KEY_G )  ), "Bison_45", posX+tW/2-nadeW*.4,posY-tH/2, col_231_231_231_170, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		
		
	end
	
	if clip == -1 then return end
	
	local ammo = MySelf:GetAmmoCount(wep:GetPrimaryAmmoType()) or 0
	

	
	surface_SetDrawColor( 255, 255, 255, 170)
	surface_SetMaterial(hud_bg3)
	surface_DrawTexturedRectRotated(posX,posY,tW,tH,0)
	
	local bulletH = 22	
	local bulletW = bulletH/2.419354
	
	if clip > 100 then
		bulletH = bulletH*0.8
	end
	
	surface_SetDrawColor( 255, 255, 255, 140)
	surface_SetMaterial(hud_bullet)
	
	local moveY = posY+tH/4
	local moveX = posX+tW/3
	
	for i=1,clip do		
		
		if i == 51 or i == 101 or i == 151 then//(math.fmod(i,50) == 0 and i ~= clip)
			moveX = posX+tW/3 + (bulletW+1)*(i-1)
			moveY = moveY + bulletH + 1
		end
		
		surface_DrawTexturedRectRotated(moveX-(bulletW+1)*i,moveY,bulletW,bulletH,0)
	end
	
	draw_SimpleText(clip, "Bison_50", posX-2,posY-10, col_231_231_231_170, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	draw_SimpleText("/", "Bison_50", posX+4,posY-10, col_231_231_231_170, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	draw_SimpleText(ammo, "Bison_35", posX+12,posY-10, col_231_231_231_170, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
end

local string_sub = string.sub

local col_hp = Color (249, 10, 10, 230)
local col_mana = Color (47, 155, 245, 230)
local col_mana_override = Color (147, 47, 245, 230)

function DrawHealthMana(MySelf)
	
	local w,h = ScrW(),ScrH()
	//local MySelf = LocalPlayer()
	
	local tW,tH = 150,150
	local posX,posY = 100+tW/2,h-50-tH/2
	
	surface_SetDrawColor( 255, 255, 255, 170)
	surface_SetMaterial(hud_bg)
	surface_DrawTexturedRectRotated(posX,posY,tW,tH,0)
	
	surface_SetDrawColor( 255, 255, 255, 170)
	surface_SetMaterial(hud_bg2)
	surface_DrawTexturedRectRotated(posX+37,posY,700/2.666666,500/2.666666,0)
	
	local hp = MySelf:Health()
	local maxhp = MySelf:GetMaxHealthClient()
	local am = math_Clamp(hp/maxhp,0,1)
	
	render_SetScissorRect( posX-tW/2,posY-tH/2,posX-5,posY+tH/2, true )
	surface_SetDrawColor( 255, 255, 255, 255)
	surface_SetMaterial(hud_health)
	surface_DrawTexturedRectRotated(posX,posY,tW,tH,180-math_Round(180*am))
	render_SetScissorRect( posX-tW/2,posY-tH/2,posX-5,posY+tH/2, false )
	
	--Mana
	local mana = MySelf:GetMana()
	local maxmana = MySelf:GetMaxMana()
		
	local am = math_Clamp(mana/maxmana,0,1)

	surface_SetDrawColor(68, 68, 68, 255)
		
	local sp = MySelf:GetCurrentSpell()
		
	if IsValid(sp) then
		if sp.CanCast and sp:CanCast() then
			surface_SetDrawColor(255, 255, 255, 255)
		end
	end
	
	local mana_override = false
	local hide_mana_text = false
	
	local wep = IsValid( MySelf:GetActiveWeapon() ) and MySelf:GetActiveWeapon()
	
	if wep and wep.OverrideManaBar then
		local wep_am, wep_max, wep_hidenum = wep:OverrideManaBar()
		
		if wep_am and wep_max then
			am = math_Clamp( wep_am / wep_max, 0, 1)
			
			if am >= 1 then
				surface_SetDrawColor( 255, 0, 105, 255)
			end
			
			mana = math_Round( wep_max - wep_am )
			
		end
		hide_mana_text = wep_hidenum
		mana_override = true
	end
	
	render_SetScissorRect( posX+6,posY-tH/2,posX+tW/2,posY+tH/2, true )
	//surface_SetDrawColor( 255, 255, 255, 255)
	surface_SetMaterial(hud_mana)
	surface_DrawTexturedRectRotated(posX,posY,tW,tH,-1*(180-math_Round(180*am)))
	render_SetScissorRect( posX+6,posY-tH/2,posX+tW/2,posY+tH/2, false )
	
	if DD_NUMERIC_HUD then
		draw_SimpleText(hp, "Bison_40", posX-4,posY+1, col_hp, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		if mana_override then
			if not hide_mana_text then
				draw_SimpleText(mana, "Bison_40", posX+4,posY+1, col_mana_override, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
		else
			draw_SimpleText(mana, "Bison_40", posX+4,posY+1, col_mana, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
	end
	
	local active, passive = "none", "none"
	
	for i=1,2 do
		if IsValid(MySelf:GetDTEntity(i)) then
			if MySelf:GetDTEntity(i) == MySelf:GetCurrentSpell() then
				active = string_sub(MySelf:GetDTEntity(i).ClassName,7)
			else
				passive = string_sub(MySelf:GetDTEntity(i).ClassName,7)
			end
		end
	end
	
	if active ~= "none" and Spells[active].Mat then
		surface_SetDrawColor( 225, 225, 225, 240)
		surface_SetMaterial(Spells[active].Mat)
		surface_DrawTexturedRectRotated(posX+tW/2+50,posY-tH/5,70,70,0)
	end
	
	if passive ~= "none" and Spells[passive].Mat then
		surface_SetDrawColor( 225, 225, 225, 240)
		surface_SetMaterial(Spells[passive].Mat)
		surface_DrawTexturedRectRotated(posX+tW/2+30,posY+tH/4,50,50,0)
	end
	
	--draw_SimpleText("/ Q", "Bison_35", posX+tW/2+50,posY + 25, col_231_231_231_170, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	//perk uses and shit
	
	if MySelf._ShiftUses then
				
		local bgW = 130
		local bgH = bgW/2.8
			
		local bgX,bgY = 200 + bgW/2, h - 15 - bgH/2
					
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		local mana = MySelf:GetMana()
		local maxmana = MySelf:GetMaxMana()
		local uses = MySelf._ShiftUses
		local softcap = MySelf._ShiftCap
		local consume = math.floor( maxmana / uses )
		
		if softcap then
			consume = math.max( consume, softcap )
		end
		
		local txt = ""
		
		for i = 1, uses do
			if mana >= consume * i then
				if i == 1 then
					txt = txt.."S"
				else
					txt = txt.." S"
				end
			end
		end
		
		//if softcap and mana < softcap then
		//	draw_SimpleText( txt, "HL2_50", bgX, bgY - 10, COLOR_BACKGROUND_INNER_DARK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		//else
			draw_SimpleText( txt, "HL2_50", bgX, bgY - 10, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		//end
				
	end
	
	DrawSpellStatus(MySelf)

end

function DrawHelpStuff()
	
	if HelpDieTime and HelpDieTime > CurTime() then
	
		local w,h = ScrW(),ScrH()
		//local MySelf = LocalPlayer()
		
		local leftX,leftY = 18.75,h-h/4.5
		
		surface_SetFont("Arial_Bold_34")
		draw_SimpleTextOutlined("Use spells -" , "Arial_Bold_34", leftX,leftY, Color (255, 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		local tw,th = surface_GetTextSize("Use spells -")
		
		draw.RoundedBox( 6,leftX+10+tw,leftY-(th*1.2)/2, th*1.2, th*1.2, Color(0, 0, 0, 220))
		
		surface_SetMaterial( ms_right )
		surface_SetDrawColor( Color(255, 255, 255, 255) )
		surface_DrawTexturedRectRotated( leftX+10+tw+(th*1.2)/2,leftY, th*1.2,th*1.2,0 )
		
		leftY = leftY + 50
		
		surface_SetFont("Arial_Bold_34")
		draw_SimpleTextOutlined("Switch spells -" , "Arial_Bold_34", leftX,leftY, Color (255, 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		local tw,th = surface_GetTextSize("Switch spells -")
		
		local tw1,th1 = surface_GetTextSize("Q or C")
		
		draw.RoundedBox( 6,leftX+10+tw,leftY-(th*1.2)/2, tw1*1.2, th*1.2, Color(0, 0, 0, 220))
		
		draw_SimpleTextOutlined("Q or C" , "Arial_Bold_34", leftX+10+tw+(tw1*1.2)/2,leftY, Color (255, 255, 255, 255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	end
	
end

function GM:_HUDPaint()
	
	if not DD_HUD then return end
	
	hook.Run( "HUDDrawTargetID" )
	//hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )
		
	DrawAchievementNotice(MySelf)
	
	if ENDROUND then return end
		
	if not GotTeamHud then
		GotTeamHud = true
	end
	
	if P_Team( MySelf ) ~= TEAM_SPECTATOR then
		if MySelf:Alive() then
			DrawHealthMana(MySelf)
			DrawAmmoSpells(MySelf)
			DrawVoiceMenu(MySelf)
		end
		DrawKOTHNotify(MySelf)
		DrawHUDMessages()
		DrawBloodSplats()
		//DrawHelpStuff()
	end
	
end
//hook.Add("HUDPaint","ActualHud",ActualHud)

function DrawSpellStatus(MySelf)
	
	//local MySelf = LocalPlayer()
	local w,h = ScrW(),ScrH()
	
	if MySelf:IsCrow() then
		if IsValid(MySelf._efCOTN) then
			local time = math_Round(MySelf._efCOTN:GetDTFloat(0) - CurTime())
			
			draw_SimpleText("Left click to cancel ( "..time.." )", "Bison_40", w/2,h*0.7, col_231_231_231_170, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
		end
	end
	
end

local HillText = {
	"Capture",
	"Defend",
}

local PointText = {
	"Capture the point!",
	"Defend the point!",
}

local FlagText = {
	"Capture",
	"Defend",
}

local FridgeText = {
	"Destroy",
	"Defend",
}

local function GetFFAScore(MySelf)
	
	local max = team_GetPlayers(TEAM_FFA)
	local myscore = #max
	
	for _,pl in ipairs(max) do
		if pl == MySelf then continue end
		if MySelf:Frags() >= pl:Frags() then
			if MySelf:Frags() == pl:Frags() then
				if MySelf:Deaths() < pl:Deaths() then
					myscore = myscore - 1
				end
			else
				myscore = myscore - 1
			end
		end
	end
	return myscore,#max
end

local mysize, enemysize = {},{}
function DrawKOTHNotify(MySelf)

	//local MySelf = LocalPlayer()
	local w,h = ScrW(),ScrH()

	if InLobby then return end
	
	//No idea why i put it here but whatever
	if GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout ).ToSpend and GetPlayerSkills( SelectedLoadout ).ToSpend > 0 then
		local bgW = 130
		local bgH = bgW/2
			
		local bgX,bgY = 100+bgW/2,50+bgH/2
			
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		draw_SimpleText(GetPlayerSkills( SelectedLoadout ).ToSpend.." unused point(s)", "Bison_30", bgX,bgY,COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	
	if LoadoutSelection and LoadoutSelection.IsVisible and not LoadoutSelection:IsVisible() and not MySelf:Alive() and NoDeathHUD and NoDeathHUD < CurTime() then
		if not (LoadoutSwitcher and LoadoutSwitcher.IsVisible and LoadoutSwitcher:IsVisible()) then
			if ENABLE_OUTFITS then
				draw_SimpleText("F1 - Help  |  F2 - Outfit  |  F3 - Achievements  |  F4 - Options", "Bison_50", w/2,50,COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			else
				draw_SimpleText("F1 - Help  |  F3 - Achievements  |  F4 - Options", "Bison_50", w/2,50,COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			
			if GAMEMODE:GetGametype() ~= "ts" then//and MySelf:Team() == TEAM_THUG
				draw_SimpleText("Right click to change loadouts", "Bison_50", w/2,h-h/5,COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
	end
	
	if GAMEMODE:GetGametype() == "koth" and IsValid(GetHillEntity()) then
		
		local hill = GetHillEntity()
		
		local pos = hill:GetPos()
		
		local spos = ( pos + vector_up * 90 ):ToScreen()
		
		local text = "The Hill"
		local col = Color(220,220,220,255)
		
		if hill:IsBeingHeld() then
			if hill:GetHoldingTeam() == hill:TeamToHill( P_Team( MySelf ) ) then
				text = HillText[2]
				col = team_GetColor( P_Team( MySelf ) )
			else
				text = HillText[1]
				col = team_GetColor(hill:HillToTeam(hill:GetHoldingTeam()))
			end
		else
			if hill.GetStartCooldown and hill:GetStartCooldown() > 0 then
				text = "Unlocking in: "..hill:GetStartCooldown()
				col = COLOR_TEXT_SOFT_BRIGHT
			else
				text = HillText[1]
				col = COLOR_TEXT_SOFT_BRIGHT//Color(220,220,220,255)
			end
		end
		
		draw_SimpleText(text, "Bison_55", spos.x,spos.y, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		local rscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)))
		local bscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_BLUE)))
		
		local bgW = 160
		local bgH = bgW/2
		
		local bgX,bgY = w/2, h-25-bgH/2//5+bgH/2
		
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		local hill = GetHillEntity()
		local rbig = false
		local bbig = false
		
		rbig = hill:IsBeingHeld() and hill:HillToTeam(hill:GetHoldingTeam()) == TEAM_RED
		bbig = hill:IsBeingHeld() and hill:HillToTeam(hill:GetHoldingTeam()) == TEAM_BLUE
		
		local rcol = team_GetColor(TEAM_RED)
		rcol.a = 230
		
		local bcol = team_GetColor(TEAM_BLUE)
		bcol.a = 230
		
		draw_SimpleText(rscore, rbig and "Bison_65" or "Bison_50", bgX-15,bgY, rcol, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		draw_SimpleText(bscore, bbig and "Bison_65" or "Bison_50", bgX+15,bgY, bcol, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		
		//draw_SimpleText(rscore, "Bison_40", spos.x-5,spos.y+55, team_GetColor(TEAM_RED), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		//draw_SimpleText(bscore, "Bison_40", spos.x+5,spos.y+55, team_GetColor(TEAM_BLUE), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		
		/*if hill:IsActive() then
			
			
			local w,h = ScrW(),ScrH()
				
			local nw,nh = 40,40
			local nx,ny = w/2-20,40+4+4
			
			draw.RoundedBox( 4,nx,ny, nw,nh, Color(0, 0, 0, 120))
					
			draw.RoundedBox( 4,nx+2,ny+2, nw-4,nh-4, hill:GetHoldingTeam() ~= 0 and team_GetColor(hill:HillToTeam(hill:GetHoldingTeam())) or Color(200,200,200,255))
					
			local txt = "Hold this hill!"
			
			if hill:IsHasteMode() then
				txt = "Haste Mode"
			end
			
			draw.SimpleTextOutlined(txt, "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			
		end
		
		
		if hill:IsActive() then return end
		
		local w,h = ScrW(),ScrH()
		
		local nw,nh = 120,40
		local nx,ny = w/2-nw/2,40+4+4
		
		
		surface_SetDrawColor( 0, 0, 0, 120)
		surface_DrawRect(nx,ny,nw,nh)
		
		local time = ToMinutesSeconds(hill:GetDTFloat(3) - CurTime())
		
		draw.SimpleTextOutlined(time, "Arial_Bold_38", w/2,ny+nh/2, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		draw.SimpleTextOutlined("Lockdown Mode", "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		*/
		
	end
	
	if GAMEMODE:GetGametype() == "tdm" or GAMEMODE:GetGametype() == "htf" then
		
		local bgW = 160
		local bgH = bgW/2
		
		local bgX,bgY = w/2, h-25-bgH/2//5+bgH/2
		
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		local rscore = team_GetScore(TEAM_RED).."/"..TDM_WIN_SCORE
		local bscore = team_GetScore(TEAM_BLUE).."/"..TDM_WIN_SCORE
		
		local hill = GetHillEntity()
		local rbig = false
		local bbig = false
		if GAMEMODE:GetGametype() == "htf" and IsValid(hill) then
			rscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)))
			bscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_BLUE)))
			
			rbig = hill:IsBeingHeld() and hill:HillToTeam(hill:GetHoldingTeam()) == TEAM_RED
			bbig = hill:IsBeingHeld() and hill:HillToTeam(hill:GetHoldingTeam()) == TEAM_BLUE
			
			if MySelf:IsCarryingFlag() then
				draw_SimpleText("Holding the flag","Bison_55", bgX,bgY-bgH/2-20, Color(231,231,231,230), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			
		else
			rbig = team_GetScore(TEAM_RED) > team_GetScore(TEAM_BLUE)
			bbig = team_GetScore(TEAM_RED) < team_GetScore(TEAM_BLUE)
		end
		
		local rcol = team_GetColor(TEAM_RED)
		rcol.a = 230
		
		local bcol = team_GetColor(TEAM_BLUE)
		bcol.a = 230
		
		if GAMEMODE:GetGametype() == "tdm" and IsValid(hill) and hill.GetTimer then
			draw_SimpleText(rscore, rbig and "Bison_65" or "Bison_50", bgX-15,bgY-bgH/2-20, rcol, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw_SimpleText(bscore, bbig and "Bison_65" or "Bison_50", bgX+15,bgY-bgH/2-20, bcol, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw_SimpleText(ToMinutesSeconds(hill:GetTimer()), "Bison_50", bgX,bgY, Color(231,231,231,230), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw_SimpleText(rscore, rbig and "Bison_65" or "Bison_50", bgX-15,bgY, rcol, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw_SimpleText(bscore, bbig and "Bison_65" or "Bison_50", bgX+15,bgY, bcol, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
	
	
	end
	
	if GAMEMODE:GetGametype() == "htf" and IsValid(GetHillEntity()) then
		
		local hill = GetHillEntity()
		
		local pos = hill:GetPos()
		
		local spos = (pos):ToScreen()
		
		local text = "The Flag"
		local col = Color(220,220,220,255)
		
		if hill:IsBeingHeld() then
			if hill:GetHoldingTeam() == hill:TeamToHill( P_Team( MySelf ) ) then
				if MySelf:IsCarryingFlag() then
					text = ""
				else
					text = FlagText[2]
				end
				col = team_GetColor( P_Team( MySelf ) )
			else
				text = FlagText[1]
				col = team_GetColor(hill:HillToTeam(hill:GetHoldingTeam()))
			end
		else
			if hill:GetRespawnTime() ~= 0 then
				text = "Flag resets in "..math_Clamp(math_Round(hill:GetRespawnTime()-CurTime()),0,999).." seconds!"
				col = COLOR_TEXT_SOFT_BRIGHT//Color(220,220,220,255)
			else
				if hill.GetStartCooldown and hill:GetStartCooldown() > 0 then
					text = "Unlocking in: "..hill:GetStartCooldown()
					col = COLOR_TEXT_SOFT_BRIGHT
				else
					text = FlagText[1]
					col = COLOR_TEXT_SOFT_BRIGHT//Color(220,220,220,255)
				end
			end
		end
		
		draw_SimpleText(text, "Bison_55", spos.x,spos.y, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		/*if hill:IsActive() then
			
			local w,h = ScrW(),ScrH()
				
			local nw,nh = 40,40
			local nx,ny = w/2-20,40+4+4
			
			draw.RoundedBox( 4,nx,ny, nw,nh, Color(0, 0, 0, 120))
					
			draw.RoundedBox( 4,nx+2,ny+2, nw-4,nh-4, hill:GetHoldingTeam() ~= 0 and team_GetColor(hill:HillToTeam(hill:GetHoldingTeam())) or Color(200,200,200,255))
					
			local txt = "Hold this flag!"
			
			//if hill:IsHasteMode() then
			//	txt = "Haste Mode"
			//end
			
			draw.SimpleTextOutlined(txt, "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			
		end
		
		
		if hill:IsActive() then return end
		
		local w,h = ScrW(),ScrH()
		
		local nw,nh = 120,40
		local nx,ny = w/2-nw/2,40+4+4
		
		
		surface_SetDrawColor( 0, 0, 0, 120)
		surface_DrawRect(nx,ny,nw,nh)
		
		local time = ToMinutesSeconds(hill:GetDTFloat(3) - CurTime())
		
		draw.SimpleTextOutlined(time, "Arial_Bold_38", w/2,ny+nh/2, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		draw.SimpleTextOutlined("Lockdown Mode", "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		*/
		
	end
	
	if GAMEMODE:GetGametype() == "assault" and IsValid(GetHillEntity()) then
		
		local hill = GetHillEntity()
		
		local pos = hill:GetPos()
		
		local spos = (pos):ToScreen()
		
		local text = "The Fridge"
		local col = Color(220,220,220,255)
		
		if hill:Team() == P_Team( MySelf ) then
			text = FridgeText[2]
			col = team_GetColor(TEAM_BLUE)
		else
			text = FridgeText[1]
			col = team_GetColor(TEAM_RED)
		end
		
		draw_SimpleText(text, "Bison_55", spos.x,spos.y, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		
		local bgW = 160
		local bgH = bgW/2
		
		local bgX,bgY = w/2, h-25-bgH/2//5+bgH/2
		
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		surface_DrawTexturedRectRotated(bgX,bgY-bgH/2-20,bgW*1.3,bgH,0)
		
		
		local hill = GetHillEntity()


		//if MySelf:IsCarryingFlag() then
		//	draw_SimpleText("Holding the flag","Bison_55", bgX,bgY-bgH/2-20, Color(231,231,231,230), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		//end
	
		
		local bcol = team_GetColor(TEAM_BLUE)
		bcol.a = 230
		
		local rcol = team_GetColor(TEAM_RED)
		rcol.a = 230
		
		
		
		draw_SimpleText("Fridge: "..math_Round(hill:GetHealth() or 0),"Bison_55", bgX,bgY-bgH/2-20, bcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw_SimpleText(ToMinutesSeconds(hill:GetTimer()), "Bison_50", bgX,bgY, rcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	end
	
	if GAMEMODE:GetGametype() == "ffa" and IsValid(GetHillEntity()) then
				
		local bgW = 160
		local bgH = bgW/2
		
		local bgX,bgY = w/2, h-25-bgH/2//5+bgH/2
		
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		surface_DrawTexturedRectRotated(bgX,bgY-bgH/2-20,bgW*1.3,bgH,0)
		
		
		local hill = GetHillEntity()
		
		local fcol = team_GetColor(TEAM_FFA)
		fcol.a = 230
		
		local score,max = GetFFAScore(MySelf)
		
		draw_SimpleText(score.." out of "..max,"Bison_55", bgX,bgY-bgH/2-20, fcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw_SimpleText(ToMinutesSeconds(hill:GetTimer()), "Bison_50", bgX,bgY, fcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	end
	
	if GAMEMODE:GetGametype() == "ts" and IsValid(GetHillEntity()) then
				
		local bgW = 160
		local bgH = bgW/2
		
		local bgX,bgY = w/2, h-25-bgH/2//5+bgH/2
		
		surface_SetDrawColor( 255, 255, 255, 170)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(bgX,bgY,bgW,bgH,0)
		
		surface_DrawTexturedRectRotated(bgX,bgY-bgH/2-20,bgW*1.3,bgH,0)
		
		
		local hill = GetHillEntity()
		
		local fcol = team_GetColor( P_Team( MySelf ) )
		fcol.a = 230
				
		draw_SimpleText( P_Team( MySelf ) == TEAM_THUG and "Kill all weaklings!" or "Survive","Bison_55", bgX,bgY-bgH/2-20, fcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw_SimpleText(ToMinutesSeconds(hill:GetTimer()), "Bison_50", bgX,bgY, fcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		if P_Team( MySelf ) == TEAM_THUG then
			for _,pl in ipairs(team_GetPlayers(TEAM_BLUE)) do
				if IsValid(pl) and pl:Alive() then
					local p = pl:GetShootPos():ToScreen()
					draw_SimpleText("Kill", "Bison_50", p.x,p.y, fcol, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end
			end
		end
	
	end
	
	/*if GAMEMODE:GetGametype() == "conquest" and IsValid(GetHillEntity()) then
		
		local hill = GetHillEntity()
		
		local cap = MySelf:Alive() and IsValid(MySelf:GetClosestPoint()) and MySelf:GetClosestPoint()
		if cap then
			local cx,cy = w/2,h-h/3.5
			
			local enemytm = MySelf:Team() == TEAM_RED and TEAM_BLUE or TEAM_RED
			local myteam = MySelf:Team()
			
			draw.SimpleTextOutlined(cap:GetHoldingTeam() ~= cap:TeamToHill(myteam) and "Capture this point!" or "Defend this point!", "Arial_Bold_25", cx,cy, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			
			
			
			local total = CONQUEST_CAPTURE_TIME or 5
			
			local mytime, enemytime = math_Clamp(cap:GetCaptureTimer(cap:TeamToHill(myteam)),0,total), math_Clamp(cap:GetCaptureTimer(cap:TeamToHill(enemytm)),0,total)
			
			local cw,ch = 300,40
			cx,cy = cx-cw/2,cy + 25/2
			
			surface_SetDrawColor( 0, 0, 0, 150)
			surface_DrawRect(cx,cy,cw,ch)
			surface_DrawRect(cx+3, cy+3, cw-6, ch-6)
			
			
			
			if not mysize[cap] then
				mysize[cap] = (cw-6)*math_Clamp(mytime/total,0,1)
			end
			if not enemysize[cap] then
				enemysize[cap] = (cw-6)*math_Clamp(enemytime/total,0,1)
			end
			
			mysize[cap],enemysize[cap] = math.Approach(mysize[cap],(cw-6)*math_Clamp(mytime/total,0,1),FrameTime()*60),math.Approach(enemysize[cap],(cw-6)*math_Clamp(enemytime/total,0,1),FrameTime()*60)
			
			local todr = mysize[cap]
			if enemytime > 0 then
				todr = enemysize[cap]
			end
			
			surface_SetDrawColor(enemytime > 0 and team_GetColor(enemytm) or team_GetColor(myteam))
			surface_DrawRect(cx+3, cy+3, todr, ch-6)
			
			surface_SetDrawColor(Color(200,200,200,100))
			surface_DrawRect(cx+3 + todr, cy+3, (cw-6) - todr, ch-6)
			
			surface_SetDrawColor(Color(0,0,0,255))
			surface_DrawRect(cx+3 + math_Clamp(todr - 2,0,(cw-6)), cy, 4, ch)
			
		else
			mysize, enemysize = {},{}
		end
		
		if hill:IsActive() then
			
			local w,h = ScrW(),ScrH()
		
			local count = #ConquestPoints or 3
		
			local nw,nh = 40,40
			local nx,ny = w/2-(40*count+4*(count-1))/2,40+4+4
			
			for _,p in ipairs(ConquestPoints) do
				if p and IsValid(p) then
			
					draw.RoundedBox( 4,nx,ny, nw,nh, Color(0, 0, 0, 120))
					
					draw.RoundedBox( 4,nx+2,ny+2, nw-4,nh-4, p:GetHoldingTeam() ~= 0 and team_GetColor(p:HillToTeam(p:GetHoldingTeam())) or Color(200,200,200,255))
					
					nx = nx + 40 + 4
				end
			end
			
			draw.SimpleTextOutlined("Hold all "..count.." points!", "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			
			//surface_SetDrawColor( 0, 0, 0, 120)			
			//surface_DrawRect(nx,ny,nw,nh)
			
		end
		
		if hill:IsActive() then return end
		
		local w,h = ScrW(),ScrH()
		
		local nw,nh = 120,40
		local nx,ny = w/2-nw/2,40+4+4
		
		
		surface_SetDrawColor( 0, 0, 0, 120)
		surface_DrawRect(nx,ny,nw,nh)
		
		local time = ToMinutesSeconds(hill:GetDTEntity(0):GetDTFloat(3) - CurTime())
		
		draw.SimpleTextOutlined(time, "Arial_Bold_38", w/2,ny+nh/2, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		draw.SimpleTextOutlined("Lockdown Mode", "Arial_Bold_14", w/2,ny+nh+4+7, Color(220,220,220,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		
	end*/

end

function CheckTeamHud()
	if TeamHUD then
		if InLobby then
			if TeamHUD:IsVisible() then
				TeamHUD:SetVisible(false)
			end
		else
			if !TeamHUD:IsVisible() then
				TeamHUD:SetVisible(true)
			end
		end
	end
end

local NotToDraw = { "CHudHealth","CHudBattery", "CHudSecondaryAmmo","CHudAmmo","CHudDamageIndicator","CHudVoiceSelfStatus" }//,
function GM:_HUDShouldDraw( name )

	//if(name == "CHudDamageIndicator" and not LocalPlayer():Alive()) then
		//return false
	//end
	for k,v in pairs(NotToDraw) do
		if (v == name) then 
			return false
		end
	end
	return true
end

TeamCount = {}
TeamCount[TEAM_RED] = 0
TeamCount[TEAM_BLUE] = 0

--local gradright = surface.GetTextureID( "VGUI/gradient-r" )
--local gradleft = surface.GetTextureID( "gui/gradient" )
function CreateTeamHud()
	
	local w,h = ScrW(),ScrH()
	local notdr = P_Team( MySelf ) == TEAM_SPECTATOR
	
	local Tw,Th = w*0.7,40
	
	local side = 30
	
	if (GAMEMODE:GetGametype() == "koth" or GAMEMODE:GetGametype() == "htf") and IsValid(GetHillEntity()) then
		side = 50
	end
	
	TeamHUD = vgui.Create("DPanel")
	TeamHUD:ParentToHUD()
	TeamHUD:SetSize(Tw,Th)
	TeamHUD:SetPos(w/2-Tw/2,4)
	TeamHUD.Paint = function()
		//left part
		surface.SetTexture(gradright)
		surface_SetDrawColor( 0, 0, 0, 120)
		surface_DrawTexturedRect(-2,0,TeamHUD:GetWide()/2,TeamHUD:GetTall())
		//right part
		surface.SetTexture(gradleft)
		surface_SetDrawColor( 0, 0, 0, 120)
		surface_DrawTexturedRect(Tw/2+2,0,TeamHUD:GetWide()/2,TeamHUD:GetTall())
		
		local rscore,bscore 
		
		if (GAMEMODE:GetGametype() == "koth" or GAMEMODE:GetGametype() == "htf") and IsValid(GetHillEntity()) then
			local hill = GetHillEntity() 
			rscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_RED)))
			bscore = ToMinutesSeconds(hill:GetTeamTimer(hill:TeamToHill(TEAM_BLUE)))
		elseif GAMEMODE:GetGametype() == "conquest" and IsValid(GetHillEntity()) then
			rscore = GetHillEntity():GetDTEntity(0):GetDTInt(1)
			bscore = GetHillEntity():GetDTEntity(0):GetDTInt(2)
		else
			rscore = team_GetScore(TEAM_RED)
			bscore = team_GetScore(TEAM_BLUE)
		end
		
		
		draw.SimpleTextOutlined(rscore, "Arial_Bold_38", TeamHUD:GetWide()/2-side,TeamHUD:GetTall()/2, team_GetColor(TEAM_RED), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined(bscore, "Arial_Bold_38", TeamHUD:GetWide()/2+side,TeamHUD:GetTall()/2, team_GetColor(TEAM_BLUE), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
	end
	/*TeamHUD.Think = function()
		print("Think!")
		if InLobby then
			if TeamHUD:IsVisible() then
				TeamHUD:SetVisible(false)
			end
		else
			if !TeamHUD:IsVisible() then
				TeamHUD:SetVisible(true)
			end
		end
	end*/
	
	TeamHUDList = {}
	
	local x,y = 0,0
	
	for tm=TEAM_RED,TEAM_BLUE do
		
		TeamHUDList[tm] = vgui.Create( "DPanel",TeamHUD)
		TeamHUDList[tm]:SetSize(Tw/2-side*2,Th)
		TeamHUDList[tm]:SetPos(x,y)
		TeamHUDList[tm].Paint = function() end
		TeamHUDList[tm].Cards = {}
		TeamHUDList[tm].Think = function()
			
			if (GAMEMODE:GetGametype() == "koth" or GAMEMODE:GetGametype() == "htf") and IsValid(GetHillEntity()) then
				side = 50
				TeamHUDList[tm]:SetSize(Tw/2-side*2,Th)
			end
			
			TeamHUDList[tm].NextCheck = TeamHUDList[tm].NextCheck or 0
			
			if TeamHUDList[tm].NextCheck >= CurTime() then return end
			
			TeamHUDList[tm].NextCheck = CurTime() + 0.6
			
			if TeamCount[tm] ~= team_NumPlayers(tm) then
				
				for _,c in ipairs(TeamHUDList[tm].Cards) do
					if c then
						c:Remove()
					end
				end
				
				for _,p in ipairs(team_GetPlayers(tm)) do
					if IsValid(p) then
						local Card = vgui.Create( "DLabel", TeamHUDList[tm] )
						Card:SetText("")
						Card:SetSize(Th,Th)
						Card.Paint = function()
							--if InLobby then return end
							if p == MySelf then
								surface_SetDrawColor( 160, 160, 160, 50)
							else
								surface_SetDrawColor( 0, 0, 0, 50)
							end
							surface_DrawRect(0,0,Th,Th)
							--surface_DrawRect(2, 2, Th-4, Th-4)
						end
						
						local a = Th/2-64/2
						
						local avatar = vgui.Create("AvatarImage", Card)
						avatar:SetPos(2,2)
						avatar:SetSize(Th-4, Th-5)
						avatar:SetPlayer( p, 64 )
						
						Card:Dock( tm == TEAM_RED and RIGHT or LEFT )
						Card:DockMargin( 1, 1, 1, 1 )
						
						Card:InvalidateLayout()
						
						table.insert(TeamHUDList[tm].Cards,Card)
					end
				end	
				
				TeamCount[tm] = team_NumPlayers(tm)
				
			end
		end
		
		
		
		x = Tw/2+((GAMEMODE:GetGametype() == "koth" or GAMEMODE:GetGametype() == "htf") and IsValid(GetHillEntity()) and 50 or 30)*2
	end
	
end


--Draw Achievements!------------------------------------------------------------

local AchievementsToDraw = {}

function AddAchievementNotice(key)
	
	local Notice = {}
	
	Notice.Name = Achievements[key] and Achievements[key].Name or "ERROR!"
	Notice.Description = Achievements[key] and Achievements[key].Description or "No description provided!"
	Notice.Time = CurTime()
	
	table.insert( AchievementsToDraw, Notice )
	
end

local function DrawAchievements( y, notice, notice_delay )

	local w,h = ScrW(), ScrH()
	
	local fadeout = (notice.Time + notice_delay) - CurTime()
	
	local alpha = math_Clamp( fadeout * 255, 0, 255 )
	
	local bW,bH = 250, 75
	local bX,bY = w-bW

	//surface_SetDrawColor( 0, 0, 0, math_Clamp( fadeout * 190, 0, 190 ))
	//surface.SetTexture(gradright)
	//surface_DrawTexturedRect(bX,y,bW,bH)
	
	local col = Color(231,231,231,alpha)
	
	draw_SimpleText("Achievement unlocked!", "Bison_30", w-120,y+bH/4, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	draw_SimpleText(notice.Name, "Bison_40", w-120,y+2*bH/3, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	
	//draw.SimpleTextOutlined("Achievement unlocked!", "Arial_Bold_26", w-18.75,y+bH/4, Color(50,255,50,alpha), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha))
	//draw.SimpleTextOutlined(notice.Name, "Arial_Bold_Italic_32", w-18.75,y+2*bH/3, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha))
	
	return (y - bH-5)

end

function DrawAchievementNotice(MySelf)

	if not DD_HUD then return end

	local time = 10//hud_deathnotice_time:GetFloat()

	local w,h = ScrW(), ScrH()
	local y = h-25-85-65-20-75-20
	
	// Draw
	for _, Notice in pairs( AchievementsToDraw ) do

		if (Notice.Time + time > CurTime()) then
	
			if (Notice.lerp) then
				y = y * 0.3 + Notice.lerp.y * 0.7
			end
			
			Notice.lerp = Notice.lerp or {}
			Notice.lerp.y = y
		
			y = DrawAchievements(y, Notice, time )
		
		end
		
	end
	
	for _, Notice in pairs( AchievementsToDraw ) do
		if (Notice.Time + time > CurTime()) then
			return
		end
	end
	
	AchievementsToDraw = {}

end

function ShouldDrawChat ( name ) 
	if name == "CHudChat" then
		return DD_HUD
	end
end
hook.Add("_HUDShouldDraw","ShouldDrawChat",ShouldDrawChat)


local blood_splats = {
	Material( "darkestdays/blood/blood_splat1.png" ),
	Material( "darkestdays/blood/blood_splat2.png" ),
	Material( "darkestdays/blood/blood_splat3.png" ),
	Material( "darkestdays/blood/blood_splat4.png" ),
	Material( "darkestdays/blood/blood_splat5.png" ),
}

for i=1,4 do
	util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard"..i..".wav")
end

local actual_splats = {}

function AddBloodSplat( limit )

	limit = limit or 2
	
	local splat = {}
	
	splat.mat = blood_splats[math_random(1,5)]
	splat.x = math_random(ScrW()*0.15,ScrW()*0.85)
	splat.y = math_random(ScrH()*0.15,ScrH()*0.85)
	splat.size = math_random(400,900)
	splat.time = CurTime() + math_random(3,4)
	
	if #actual_splats >= limit then return end

	table.insert(actual_splats,splat)
	
	if math_random(3) == 3 then
		surface_PlaySound("physics/flesh/flesh_squishy_impact_hard"..math_random(1,4)..".wav")
	end
	
end

function DrawBloodSplats(MySelf)

	if not DD_HUD then return end
	
	for _, splat in pairs( actual_splats ) do

		if (splat.time > CurTime()) then
			
			local fadeout = splat.time - CurTime()
	
			local alpha = math_Clamp( fadeout * 210, 0, 210 )
			
			surface_SetDrawColor(Color(205,205,205,alpha))
			surface_SetMaterial(splat.mat)
			surface_DrawTexturedRectRotated(splat.x,splat.y,splat.size,splat.size,0)
			
		end
		
	end
	
	for _, splat in pairs( actual_splats ) do
		if (splat.time > CurTime()) then
			return
		end
	end
	
	actual_splats = {}

end

//very simple hud messages

net.Receive( "HUDMessage", function( len )

	local txt = net.ReadString()
	local ent = net.ReadEntity()
	local snd = net.ReadDouble()
	
	if snd == 1 then
		if IsValid(ent) and ent:Team() ~= MySelf:Team() then
			snd = 2
		end
	end
	
	AddHUDMessage(txt,IsValid(ent) and GAMEMODE:GetTeamColor( ent ) or nil,5,snd)
	
end)

local curmsg = nil
local curcolor = Color(231,231,231,230)
local curmsgtime = 0

local NotifySounds = {
	[1] = "npc/roller/mine/rmine_taunt1.wav",//your team picked up flag
	[2] = "npc/roller/mine/rmine_predetonate.wav",//enemy team picked up flag
	[3] = "npc/roller/mine/rmine_tossed1.wav",//dropped flag
	[4] = "npc/zombie_poison/pz_alert"..math_random(1,2)..".wav",//thugs
	[5] = "ambient/creatures/town_child_scream1.wav",//thugs #2
	
}
function AddHUDMessage(txt,col,time,snd)

	curmsg = txt
	curcolor = col or Color(231,231,231,230)
	curmsgtime = CurTime() + time
	
	if snd then
		if NotifySounds[snd] then
			MySelf:EmitSound(NotifySounds[snd],45,100)
		end
	end
end

function DrawHUDMessages()
	
	if not DD_HUD then return end
	
	local w,h = ScrW(), ScrH()

	if curmsg then
	
		local fadeout = curmsgtime - CurTime()
		local alpha = math_Clamp( fadeout * 250, 0, 250 )
		local alpha2 = math_Clamp( fadeout * 170, 0, 170 )
		curcolor.a = alpha

		surface_SetDrawColor( 255, 255, 255, alpha2)
		surface_SetMaterial(hud_bg4)
		surface_DrawTexturedRectRotated(w/2,h-h/3.3,180,75,0)
		
		draw_SimpleText(curmsg,"Bison_50",w/2,h-h/3.3,curcolor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		if curmsgtime < CurTime() then
			curmsg = nil
		end
		
	end

end
