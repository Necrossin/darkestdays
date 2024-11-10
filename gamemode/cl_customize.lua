
local grad = surface.GetTextureID( "gui/center_gradient" )
PreviewModels = {}
CMenuSlot = {}
CMenuContext = {}
CreateClientConVar("_dd_previewrotation", 35, true, false)


DD_TELEPORT_MARKER = util.tobool( CreateClientConVar("_dd_teleportmarker", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_teleportmarker", function(cvar, oldvalue, newvalue)
	DD_TELEPORT_MARKER = util.tobool( newvalue )
end)

DD_NOIMPACTFX = util.tobool( CreateClientConVar("_dd_noimpactfx", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_noimpactfx", function(cvar, oldvalue, newvalue)
	DD_NOIMPACTFX = util.tobool( newvalue )
end)

DD_NOMUZZLEFX = util.tobool( CreateClientConVar("_dd_nomuzzleflash", 0, true, false):GetInt() )
cvars.AddChangeCallback("_dd_nomuzzleflash", function(cvar, oldvalue, newvalue)
	DD_NOMUZZLEFX = util.tobool( newvalue )
end)

DD_FULLBODY = util.tobool( CreateClientConVar("_dd_fullbody", 0, true, false):GetInt() )
cvars.AddChangeCallback("_dd_fullbody", function(cvar, oldvalue, newvalue)
	DD_FULLBODY = util.tobool( newvalue )
end)

DD_THIRDPERSONDEATH = util.tobool( CreateClientConVar("_dd_thirdpersondeath", 0, true, false):GetInt() )
cvars.AddChangeCallback("_dd_thirdpersondeath", function(cvar, oldvalue, newvalue)
	DD_THIRDPERSONDEATH  = util.tobool( newvalue )
end)

DD_DRAWHANDSPELLS = util.tobool( CreateClientConVar("_dd_drawhandspells", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_drawhandspells", function(cvar, oldvalue, newvalue)
	DD_DRAWHANDSPELLS = util.tobool( newvalue )
end)

DD_CROSSHAIR_R = CreateClientConVar("_dd_crosshairR", 255, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairR", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_R = tonumber( newvalue )
end)

DD_CROSSHAIR_G = CreateClientConVar("_dd_crosshairG", 255, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairG", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_G = tonumber( newvalue )
end)

DD_CROSSHAIR_B = CreateClientConVar("_dd_crosshairB", 255, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairB", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_B = tonumber( newvalue )
end)

DD_CROSSHAIR_A = CreateClientConVar("_dd_crosshairA", 220, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairA", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_A = tonumber( newvalue )
end)

DD_CROSSHAIR_LENGTH = CreateClientConVar("_dd_crosshairL", 12, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairL", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_LENGTH = math.Clamp( tonumber( newvalue ), 1, 30 )
end)

DD_CROSSHAIR_GAP = CreateClientConVar("_dd_crosshairGap", 6, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairGap", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_GAP = math.Clamp( tonumber( newvalue ), 0, 30 )
end)

DD_CROSSHAIR_THICKNESS = CreateClientConVar("_dd_crosshairT", 2, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairT", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_THICKNESS = math.Clamp( tonumber( newvalue ), 2, 10 )
end)

DD_CROSSHAIR_MELEE = CreateClientConVar("_dd_crosshairM", 7, true, true):GetInt()
cvars.AddChangeCallback("_dd_crosshairM", function(cvar, oldvalue, newvalue)
	DD_CROSSHAIR_MELEE = math.Clamp( tonumber( newvalue ), 2, 24 )
end)

DD_THIRDPERSON_X = CreateClientConVar("_dd_thirdpersonX", 50, true, true):GetInt()
cvars.AddChangeCallback("_dd_thirdpersonX", function(cvar, oldvalue, newvalue)
	DD_THIRDPERSON_X = tonumber( newvalue )
end)

DD_THIRDPERSON_Y = CreateClientConVar("_dd_thirdpersonY", 30, true, true):GetInt()
cvars.AddChangeCallback("_dd_thirdpersonY", function(cvar, oldvalue, newvalue)
	DD_THIRDPERSON_Y = tonumber( newvalue )
end)

DD_THIRDPERSON_Z = CreateClientConVar("_dd_thirdpersonZ", 0, true, true):GetInt()
cvars.AddChangeCallback("_dd_thirdpersonZ", function(cvar, oldvalue, newvalue)
	DD_THIRDPERSON_Z = tonumber( newvalue )
end)

DD_SPECTATEMODE = util.tobool( CreateClientConVar("_dd_spectatemode", 0, true, true):GetInt() )
cvars.AddChangeCallback("_dd_spectatemode", function(cvar, oldvalue, newvalue)
	DD_SPECTATEMODE = util.tobool( newvalue )
end)

DD_VOICEBUTTON = CreateClientConVar("_dd_voicebutton", KEY_V, true, false):GetInt()
cvars.AddChangeCallback("_dd_voicebutton", function(cvar, oldvalue, newvalue)
	DD_VOICEBUTTON = tonumber( newvalue )
end)

DD_GRENADEBUTTON = CreateClientConVar("_dd_grenadebutton", KEY_G, true, true):GetInt()
cvars.AddChangeCallback("_dd_grenadebutton", function(cvar, oldvalue, newvalue)
	DD_GRENADEBUTTON = tonumber( newvalue )
end)

DD_BLOODYMODELS = util.tobool( CreateClientConVar("_dd_bloodymodels", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_bloodymodels", function(cvar, oldvalue, newvalue)
	DD_BLOODYMODELS = util.tobool( newvalue )
end)

DD_SPACEBARGRAB = util.tobool( CreateClientConVar("_dd_spacebargrab", 1, true, true):GetInt() )
cvars.AddChangeCallback("_dd_spacebargrab", function(cvar, oldvalue, newvalue)
	DD_SPACEBARGRAB = util.tobool( newvalue )
end)

DD_USEKEYDIVE = util.tobool( CreateClientConVar("_dd_usekeydive", 1, true, true):GetInt() )
cvars.AddChangeCallback("_dd_usekeydive", function(cvar, oldvalue, newvalue)
	DD_USEKEYDIVE = util.tobool( newvalue )
end)

DD_TEAMMATECIRCLES = util.tobool( CreateClientConVar("_dd_friendlycircle", 1, true, true):GetInt() )
cvars.AddChangeCallback("_dd_friendlycircle", function(cvar, oldvalue, newvalue)
	DD_TEAMMATECIRCLES = util.tobool( newvalue )
end)

DD_HITSOUNDS = util.tobool( CreateClientConVar("_dd_hitsounds", 0, true, true):GetInt() )
cvars.AddChangeCallback("_dd_hitsounds", function(cvar, oldvalue, newvalue)
	DD_HITSOUNDS = util.tobool( newvalue )
end)

DD_IMMERSIVESLIDE = util.tobool( CreateClientConVar("_dd_immersiveslide", 1, true, true):GetInt() )
cvars.AddChangeCallback("_dd_immersiveslide", function(cvar, oldvalue, newvalue)
	DD_IMMERSIVESLIDE = util.tobool( newvalue )
end)

DD_VIEWMODEL_Z = CreateClientConVar("_dd_viewmodelZ", 0, true, true):GetFloat()
cvars.AddChangeCallback("_dd_viewmodelZ", function(cvar, oldvalue, newvalue)
	DD_VIEWMODEL_Z = math.Clamp( tonumber( newvalue ), -10, 0 )
end)


local draw = draw
local vgui = vgui
local surface = surface
local pairs = pairs
local util = util
local file = file


//Options!------------------------------------------------------------------
local matLine = Material("VGUI/gradient-r")
local matCircle = Material("sgm/playercircle")
function OptionsMenu()

	local w,h = ScrW(),ScrH()
	local Ow,Oh = math.max(w/4.2, 380),h/1.4
	
	if InLobby then return end
	
	if OpMenu then
		OpMenu:Remove()
		OpMenu = nil
	end
	
	OpMenu = vgui.Create("DFrame")
	OpMenu:SetSize(Ow,Oh)
	OpMenu:SetPos(w/2-Ow/2,h/2-Oh/2)
	OpMenu:SetDraggable ( false )
	OpMenu:SetTitle("")
	OpMenu:ShowCloseButton (true)
	OpMenu:MakePopup()
	OpMenu.Paint = function()

	end
	
	local name = vgui.Create("DLabel",OpMenu)
	name:SetTall(50)
	name:SetText("")
	name:Dock( TOP )
	name:DockMargin( 0,0,0,10 )
	name.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		draw.SimpleText( translate.Get( "scoreboard_options" ), "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	OpList = vgui.Create( "DScrollPanel", OpMenu )
	OpList:Dock( FILL )
	OpList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	local LangLabel = vgui.Create("DPanel",OpList)
	LangLabel:SetText("")
	LangLabel:SetTall(40)
	LangLabel:Dock( TOP )
	LangLabel:DockMargin( 0,2,0,0 )
	LangLabel.Paint = function( self )
		draw.SimpleText(translate.Get( "option_language" ), "Arial_Bold_25", 15, self:GetTall() / 2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	local LangButton = vgui.Create("DComboBox",LangLabel)
	LangButton:SetSize(110,23)
	LangButton:Dock( RIGHT )
	LangButton:DockMargin( 2,2,5,2 )
	LangButton:AddChoice( translate.Get( "option_language_auto" ), "auto" )

	for k, v in pairs( translate.GetLanguages() ) do
		LangButton:AddChoice( v, k )
	end

	LangButton:SetValue( LangButton:GetOptionTextByData( GetConVar("dd_language"):GetString() ) )

	LangButton.OnSelect = function( self, index, value )
		RunConsoleCommand( "dd_language", self:GetOptionData( index ) )
		
		timer.Simple( 1, function()  
			if OpMenu then
				OpMenu:Remove()
				OpMenu = nil
			end
			OptionsMenu()
		end)
		
	end

	local RadioLabel = vgui.Create("DPanel",OpList)
	RadioLabel:SetText("")
	RadioLabel:SetTall(40)
	RadioLabel:Dock( TOP )
	RadioLabel:DockMargin( 0,2,0,0 )
	RadioLabel.Paint = function()
		draw.SimpleText(translate.Get( "option_music" ), "Arial_Bold_25", 15,RadioLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local RadioButton = vgui.Create("DButton",RadioLabel)
	RadioButton:SetText("")
	RadioButton.Text = tobool(GetConVarNumber("_dd_enableradio")) and "option_music_off" or "option_music_on"
	RadioButton:SetSize(110,23)
	RadioButton:Dock( RIGHT )
	RadioButton:DockMargin( 2,2,5,2 )

	RadioButton.DoClick = function()
		if tobool(GetConVarNumber("_dd_enableradio")) then
			RunConsoleCommand("dd_enableradio","0")
			RadioButton.Text = "option_music_on"
		else
			RunConsoleCommand("dd_enableradio","1")
			RadioButton.Text = "option_music_off"
		end
	end
	RadioButton.OnCursorEntered = function(self)
		self.Overed = true
	end
	RadioButton.OnCursorExited = function(self)
		self.Overed = false
	end
	RadioButton.Paint = function(self,fw,fh)
		if self.Overed then
			draw.RoundedBox( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT_OUTLINE )
			draw.RoundedBox( 4,2,2, self:GetWide()-4, self:GetTall()-4, COLOR_MISC_SELECTED_BRIGHT)
		else
			draw.RoundedBox( 4,2,2, self:GetWide()-4, self:GetTall()-4, COLOR_MISC_SELECTED_BRIGHT)
		end
		draw.SimpleText( translate.Get( self.Text ) or "", "Arial_Bold_16", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	
	local VoiceLabel = vgui.Create("DPanel",OpList)
	VoiceLabel:SetText("")
	VoiceLabel:SetTall(40)
	VoiceLabel:Dock( TOP )
	VoiceLabel:DockMargin( 0,2,0,0 )
	VoiceLabel.Paint = function()
		draw.SimpleText( translate.Get( "option_voice" ), "Arial_Bold_25", 15,VoiceLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local VoiceButton = vgui.Create("DBinder",VoiceLabel)
	VoiceButton:SetSize(110,23)
	VoiceButton:Dock( RIGHT )
	VoiceButton:DockMargin( 2,2,5,2 )
	VoiceButton:SetValue(GetConVarNumber("_dd_voicebutton"))
	VoiceButton.OldSetValue = VoiceButton.SetValue
	VoiceButton.SetValue = function(self,num)
		self:OldSetValue( num )
		RunConsoleCommand("_dd_voicebutton",tostring(num))
	end
	
	local GrenadeLabel = vgui.Create("DPanel",OpList)
	GrenadeLabel:SetText("")
	GrenadeLabel:SetTall(40)
	GrenadeLabel:Dock( TOP )
	GrenadeLabel:DockMargin( 0,2,0,0 )
	GrenadeLabel.Paint = function()
		draw.SimpleText( translate.Get( "option_grenade" ), "Arial_Bold_25", 15,GrenadeLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local GrenadeButton = vgui.Create("DBinder",GrenadeLabel)
	GrenadeButton:SetSize(110,23)
	GrenadeButton:Dock( RIGHT )
	GrenadeButton:DockMargin( 2,2,5,2 )
	GrenadeButton:SetValue(GetConVarNumber("_dd_grenadebutton"))
	GrenadeButton.OldSetValue = GrenadeButton.SetValue
	GrenadeButton.SetValue = function(self,num)
		self:OldSetValue( num )
		RunConsoleCommand("_dd_grenadebutton",tostring(num))
	end

	
	local CrosshairPanel = vgui.Create( "DPanel", OpList )	
	CrosshairPanel:SetTall(200)
	CrosshairPanel:Dock( TOP )
	CrosshairPanel:DockMargin( 0,2,0,0 )
	CrosshairPanel.Paint = function() end
	
	local CrosshairMix = vgui.Create("DColorMixer",CrosshairPanel)
	CrosshairMix:SetConVarR("_dd_crosshairR")
	CrosshairMix:SetConVarG("_dd_crosshairG")
	CrosshairMix:SetConVarB("_dd_crosshairB")
	CrosshairMix:SetConVarA("_dd_crosshairA")
	
	local CrosshairPr = vgui.Create("DLabel",CrosshairPanel)
	CrosshairPr:SetText("")
	CrosshairPr:Dock ( RIGHT )
	CrosshairPr:SetSize(100,200)
	CrosshairPr.Paint = function()
		draw.SimpleTextOutlined( translate.Get( "option_crosshair" ), "Arial_Bold_13", CrosshairPr:GetWide() / 2, 13, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255) )
		//draw.SimpleText(" {  } ","HL2_80",CrosshairPr:GetWide()/2,CrosshairPr:GetTall()/4,CrosshairMix:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		//draw.SimpleText(" [  ] ","HL2_80",CrosshairPr:GetWide()/2,3*CrosshairPr:GetTall()/4,CrosshairMix:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		local r,g,b = DD_CROSSHAIR_R or 255,DD_CROSSHAIR_G or 255,DD_CROSSHAIR_B or 255
		local a = DD_CROSSHAIR_A or 100
		
		local crs_length = DD_CROSSHAIR_LENGTH or 12
		local crs_thickness = DD_CROSSHAIR_THICKNESS or 2
		local crs_gap = DD_CROSSHAIR_GAP or 6
		
		local melee_size = DD_CROSSHAIR_MELEE or 7
		
		local x = CrosshairPr:GetWide()/2
		local y = CrosshairPr:GetTall()/4
	
		local col = CrosshairMix:GetColor()
		col.a = col.a / 2
	
		surface.SetMaterial( matLine )
		surface.SetDrawColor( col )

		surface.DrawTexturedRectRotated( x + crs_gap / 2 + crs_length/2, y, crs_length, crs_thickness, 0 )
		surface.DrawTexturedRectRotated( x + crs_gap / 2 + crs_length/2, y, crs_length, crs_thickness, 180 )
		
		surface.DrawTexturedRectRotated( x, y + crs_gap / 2 + crs_length/2, crs_length, crs_thickness, 270 )
		surface.DrawTexturedRectRotated( x, y + crs_gap / 2 + crs_length/2, crs_length, crs_thickness, 90 )
		
		surface.DrawTexturedRectRotated( x - crs_gap / 2 - crs_length/2, y, crs_length, crs_thickness, 180 )
		surface.DrawTexturedRectRotated( x - crs_gap / 2 - crs_length/2, y, crs_length, crs_thickness, 0 )
		
		surface.DrawTexturedRectRotated( x, y - crs_gap / 2 - crs_length/2, crs_length, crs_thickness, 90 )
		surface.DrawTexturedRectRotated( x, y - crs_gap / 2 - crs_length/2, crs_length, crs_thickness, 270 )
		
		y = CrosshairPr:GetTall()/4 * 3
		
		col = CrosshairMix:GetColor()
		
		surface.SetMaterial( matCircle )
		surface.SetDrawColor( col )
		surface.DrawTexturedRectRotated( x, y, melee_size, melee_size, 0 )
		
	end
	
	
	CrosshairMix:Dock ( FILL )
	CrosshairPanel:DockMargin( 5,0,0,0 )
	
	local sliderLength = vgui.Create("DNumSlider",OpList)
	sliderLength:Dock( TOP )
	sliderLength:DockMargin( 5,2,5,0 )
	sliderLength:SetDecimals(0)
	sliderLength:SetMinMax(1, 30)
	sliderLength:SetConVar("_dd_crosshairL")
	sliderLength:SetText( translate.Get( "option_crosshair_len" ) )
	sliderLength:SizeToContents()
	
	local sliderThickness = vgui.Create("DNumSlider",OpList)
	sliderThickness:Dock( TOP )
	sliderThickness:DockMargin( 5,2,5,0 )
	sliderThickness:SetDecimals(0)
	sliderThickness:SetMinMax(2, 10)
	sliderThickness:SetConVar("_dd_crosshairT")
	sliderThickness:SetText( translate.Get( "option_crosshair_thc" ) )
	sliderThickness:SizeToContents()
	
	local sliderGap = vgui.Create("DNumSlider",OpList)
	sliderGap:Dock( TOP )
	sliderGap:DockMargin( 5,2,5,0 )
	sliderGap:SetDecimals(0)
	sliderGap:SetMinMax(0, 30)
	sliderGap:SetConVar("_dd_crosshairGap")
	sliderGap:SetText( translate.Get( "option_crosshair_gap" ) )
	sliderGap:SizeToContents()
	
	local sliderMelee = vgui.Create("DNumSlider",OpList)
	sliderMelee:Dock( TOP )
	sliderMelee:DockMargin( 5,2,5,0 )
	sliderMelee:SetDecimals(0)
	sliderMelee:SetMinMax(2, 24)
	sliderMelee:SetConVar("_dd_crosshairM")
	sliderMelee:SetText( translate.Get( "option_crosshair_melee" ) )
	sliderMelee:SizeToContents()
	
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_no_impact_fx" ) )
	c:SetConVar( "_dd_noimpactfx" )
	c:SetValue( GetConVarNumber("_dd_noimpactfx") )
	c:SizeToContents()
	
	/*local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Disable weapon muzzleflash (More FPS)" )
	c:SetConVar( "_dd_nomuzzleflash" )
	c:SetValue( GetConVarNumber("_dd_nomuzzleflash") )
	c:SizeToContents()*/
	
	local tp = vgui.Create( "DCheckBoxLabel",OpList )
	tp:Dock( TOP )
	tp:DockMargin( 5,2,5,0 )
	tp:SetText( translate.Get( "option_teleport" ) )
	tp:SetConVar( "_dd_teleportmarker" )
	tp:SetValue( GetConVarNumber("_dd_teleportmarker") )
	tp:SizeToContents()
	
	local hud = vgui.Create( "DCheckBoxLabel",OpList )
	hud:Dock( TOP )
	hud:DockMargin( 5,2,5,0 )
	hud:SetText( translate.Get( "option_hud" ) )
	hud:SetConVar( "_dd_hud" )
	hud:SetValue( GetConVarNumber("_dd_hud") )
	hud:SizeToContents()
	
	
	local nhud = vgui.Create( "DCheckBoxLabel",OpList )
	nhud:Dock( TOP )
	nhud:DockMargin( 5,2,5,0 )
	nhud:SetText( translate.Get( "option_hud_numbers" ) )
	nhud:SetConVar( "_dd_numerichud" )
	nhud:SetValue( GetConVarNumber("_dd_numerichud") )
	nhud:SizeToContents()
	

	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( translate.Get( "option_free_spectator" ) )
	sp:SetConVar( "_dd_spectatemode" )
	sp:SetValue( GetConVarNumber("_dd_spectatemode") )
	sp:SizeToContents()
	
	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( translate.Get( "option_fp_death" ) )
	sp:SetConVar( "_dd_thirdpersondeath" )
	sp:SetValue( GetConVarNumber("_dd_thirdpersondeath") )
	sp:SizeToContents()
	
	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( translate.Get( "option_fp_spells" ) )
	sp:SetConVar( "_dd_drawhandspells" )
	sp:SetValue( GetConVarNumber("_dd_drawhandspells") )
	sp:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_body_awareness" ) )
	c:SetConVar( "_dd_fullbody" )
	c:SetValue( GetConVarNumber("_dd_fullbody") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_bloodstains" ) )
	c:SetConVar( "_dd_bloodymodels" )
	c:SetValue( GetConVarNumber("_dd_bloodymodels") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_spacebar_grab" ) )
	c:SetConVar( "_dd_spacebargrab" )
	c:SetValue( GetConVarNumber("_dd_spacebargrab") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_dive" ) )
	c:SetConVar( "_dd_usekeydive" )
	c:SetValue( GetConVarNumber("_dd_usekeydive") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_teammate_aura" ) )
	c:SetConVar( "_dd_friendlycircle" )
	c:SetValue( GetConVarNumber("_dd_friendlycircle") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_immersive_slide" ) )
	c:SetConVar( "_dd_immersiveslide" )
	c:SetValue( GetConVarNumber("_dd_immersiveslide") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( translate.Get( "option_hitmarker_snd" ) )
	c:SetConVar( "_dd_hitsounds" )
	c:SetToolTip( translate.Get( "option_hitmarker_snd_tip" ) )
	c:SetValue( GetConVarNumber("_dd_hitsounds") )
	c:SizeToContents()
	
	local vm_slider = vgui.Create("DNumSlider",OpList)
	vm_slider:Dock( TOP )
	vm_slider:DockMargin( 5,2,5,0 )
	vm_slider:SetDecimals(1)
	vm_slider:SetMinMax(-10, 0)
	vm_slider:SetConVar("_dd_viewmodelZ")
	vm_slider:SetText( translate.Get( "option_viewmodel_zpos" ) )
	vm_slider:SizeToContents()
	
	local sliderX = vgui.Create("DNumSlider",OpList)
	sliderX:Dock( TOP )
	sliderX:DockMargin( 5,2,5,0 )
	sliderX:SetDecimals(0)
	sliderX:SetMinMax(10, 80)
	sliderX:SetConVar("_dd_thirdpersonX")
	sliderX:SetText( translate.Get( "option_thirdperson_x" ) )
	sliderX:SizeToContents()
	
	local sliderY = vgui.Create("DNumSlider",OpList)
	sliderY:Dock( TOP )
	sliderY:DockMargin( 5,2,5,0 )
	sliderY:SetDecimals(0)
	sliderY:SetMinMax(-70, 70)
	sliderY:SetConVar("_dd_thirdpersonY")
	sliderY:SetText( translate.Get( "option_thirdperson_y" ) )
	sliderY:SizeToContents()
	
	local sliderZ = vgui.Create("DNumSlider",OpList)
	sliderZ:Dock( TOP )
	sliderZ:DockMargin( 5,2,5,0 )
	sliderZ:SetDecimals(0)
	sliderZ:SetMinMax(-30, 30)
	sliderZ:SetConVar("_dd_thirdpersonZ")
	sliderZ:SetText( translate.Get( "option_thirdperson_z" ) )
	sliderZ:SizeToContents()
	

	//to be continued
	
	
end

//Achievements!---------------------------------------------------------
function AchievementsMenu()

	local w,h = ScrW(),ScrH()
	local Ow,Oh = math.max(w/3, 530),h/1.25 //2.2,1.25
	
	if InLobby then return end
	
	if AchMenu then
		AchMenu:Remove()
		AchMenu = nil
	end
	
	AchMenu = vgui.Create("DFrame")
	AchMenu:SetSize(Ow,Oh)
	AchMenu:SetPos(w/2-Ow/2,h-Oh*1.05)
	AchMenu:SetDraggable ( false )
	AchMenu:SetTitle("")
	AchMenu:ShowCloseButton (true)
	AchMenu:MakePopup()
	AchMenu.Paint = function()

	end
	
	local name = vgui.Create("DLabel",AchMenu)
	name:SetTall(50)
	name:SetText("")
	name:Dock( TOP )
	name:DockMargin( 0,0,0,10 )
	name.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		//draw.SimpleText( "Player info: "..(MySelf:Nick() or "error"), "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText( translate.Get( "ach_menu_player_info" ) .. ": " .. (MySelf:Nick() or "error"), "Bison_40", fw / 2, fh / 2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local temp = vgui.Create("DPanel",AchMenu)
	temp:Dock( FILL )
	temp.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	/*local left = vgui.Create("DPanel",temp)
	left:SetWide(AchMenu:GetWide()/2)
	left:Dock( LEFT )
	left.Paint = function(self,fw,fh)

	end
	
	local right = vgui.Create("DPanel",temp)
	right:SetWide(AchMenu:GetWide()/2)
	right:Dock( LEFT )
	right.Paint = function(self,fw,fh)

	end
	
	local plpanel = vgui.Create("DPanel",left)
	plpanel:SetTall( 128 )
	plpanel:Dock( TOP )
	plpanel.Paint = function(self,fw,fh) end
	
	local avatardummy = vgui.Create( "DPanel", plpanel )
	avatardummy:SetSize( 128, 128 )
	avatardummy:Dock( LEFT )
	avatardummy:DockMargin( 5,5,5,0 )
	
	local avatar = vgui.Create( "AvatarImage", avatardummy )
	avatar:SetPos(0,0)
	avatar:SetSize( 128, 128 )
	avatar:SetPlayer( MySelf, 128 )
	avatar:SetMouseInputEnabled( false )	
	
	StList = vgui.Create( "DScrollPanel", plpanel )
	StList:SetTall( 96 )
	StList:Dock( FILL )
	StList:DockMargin( 5,5,5,0 )
	StList.Paint = function() 

	end

	
	local st = Stats and Stats["stats"]
	
	if st then
		for key,stuff in pairs(st) do
			local nm = RandomData[key] and RandomData[key].Name or key
			local show = stuff
			
			local secs, mins, hours
			if key == "time" or key == "Name" then
				continue
			end
			
			local Lab = vgui.Create("DLabel",StList)
			Lab:SetText("")
			Lab:SetTall(24)
			Lab:Dock ( TOP )
			Lab.Paint = function(self,fw,fh)
				draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
				draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
				draw.SimpleText(nm..":", "Arial_Bold_Scaled_20", 5,fh/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(show, "Arial_Bold_Scaled_20", fw-5,fh/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end			
		end
	end
	*/

	local CachedAchievements = {}
	
	if Stats and Stats[ "achievements" ] then
		for _, ach in pairs( Stats[ "achievements" ] ) do
			if Achievements[ ach ] then
				CachedAchievements[ ach ] = true
			end
		end
	end
	
	AchList = vgui.Create( "DScrollPanel", temp )
	AchList:SetTall( Oh/2.6)
	AchList:Dock( FILL )
	AchList:DockMargin( 5,5,5,5 )
		
	local headerH = 50
	
	local achheader = vgui.Create("DLabel",AchList)
	achheader:Dock( TOP )
	achheader:SetText("")
	achheader:SetTall(headerH)
	achheader:SetZPos(-1500)
	achheader.Paint = function(self,fw,fh)
		draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
		draw.SimpleText( translate.Get("scoreboard_achievements"), "Bison_40", fw / 2, fh / 2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	for key,stuff in pairs(Achievements) do
		local Lab = vgui.Create("DLabel", AchList)
		Lab:SetText("")
		Lab:Dock ( TOP )
		Lab:SetTall((AchList:GetTall())/5)
		Lab:SetZPos(CachedAchievements and CachedAchievements[key] == true and -100 or 100)
		Lab.Paint = function(self,fw,fh)
			local unl = CachedAchievements and CachedAchievements[key] == true

			draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
			draw.SimpleText(translate.Get(stuff.Name), "Bison_30", 5,fh/3, unl and Color(50,215,50,255)  or Color(255,70,70,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(translate.Get(stuff.Description), "Arial_Bold_Scaled_20", 5,3*fh/4, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
				
	end
	
	/*UnlList = vgui.Create( "DScrollPanel", left )
	UnlList:Dock( FILL )
	UnlList:DockMargin( 5,5,5,5 )
	
	local headerH = 50
	
	local unlheader = vgui.Create("DLabel",UnlList)
	unlheader:Dock( TOP )
	unlheader:SetText("")
	unlheader:SetTall(headerH)
	unlheader:SetZPos(-1500)
	unlheader.Paint = function(self,fw,fh)
		draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
		draw.SimpleText( "Unlocks", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	for key,stuff in pairs(Unlocks) do
		local Lab = vgui.Create("DLabel",UnlList)
		Lab:Dock( TOP )
		Lab:SetText("")
		Lab:SetTall((UnlList:GetTall()-headerH)/4)
		Lab:SetZPos(MySelf:HasUnlocked(key) and -100 or 100)
		Lab.Think = function()
			Lab:SetTall((UnlList:GetTall()-headerH)/4)
		end
		Lab.Paint = function(self,fw,fh)
			local unl = MySelf:HasUnlocked(key)
			local tp = IsSpell(key) and "Spell:" or IsPerk(key) and "Perk:" or "Weapon:"
			local unltbl = IsSpell(key) and Spells[key] or IsPerk(key) and Perks[key] or IsWeapon(key) and Weapons[key] or {}
			local tounlock = "Requires: "
			for _,ach in ipairs(stuff) do
				if Achievements[ach] then
					tounlock = tounlock..""..(_ == 1 and "" or ", " )..Achievements[ach].Name
				end
			end

			draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
			
			local mat = false
			
			if unltbl.Mat then
				local mw,mh = unltbl.Mat:Width(),unltbl.Mat:Height()
				local div = 1.05
				if IsSpell(key) then
					div = 2
				end
				local dif = (110/div)/mw
				
				surface.SetMaterial( unltbl.Mat )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 5,self:GetTall()/1.5-(mh*dif)/2, math.Clamp(mw*dif,0,110/div), mh*dif)
				//surface.DrawTexturedRect( 5+110/2,self:GetTall()/1.5, math.Clamp(mw*dif,0,110/div), mh*dif)
				mat = true
			end
			
			draw.SimpleText(tp.." "..(unltbl.Name or "error"), "Bison_30", 5,5+15, unl and Color(50,215,50,255)  or Color(255,70,70,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			//draw.SimpleText(tounlock, "Arial_Bold_18", 5,2*fh/3, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText("REQUIRES:", "Arial_Bold_Scaled_23", fw-5,5+10, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			
			local add = 0
			
			for _,ach in ipairs(stuff) do
				if Achievements[ach] then
					
					surface.SetFont("Arial_Bold_Scaled_23")
					local tw,th = surface.GetTextSize(Achievements[ach].Name)
					tw = tw + 10
					
					local tx,ty = fw-5,fh/4 + 20 + add
					
					draw.RoundedBox( 4,tx-tw,ty-th/2, tw, th, COLOR_BACKGROUND_OUTLINE)
					draw.RoundedBox( 4,tx-tw+1,ty-th/2+1, tw-2,th-2, COLOR_BACKGROUND_INNER)
					draw.SimpleText(Achievements[ach].Name, "Arial_Bold_Scaled_23", tx-5,ty, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
					
					
					add = add + th
					
				end
			end
			
		end
				
	
	end*/

end

function HelpMenu()

	local w,h = ScrW(),ScrH()
	local Ow,Oh = math.max(w/3.5,460),h/1.7
	
	if InLobby then return end
	
	if HMenu then
		HMenu:Remove()
		HMenu = nil
	end
	
	HMenu = vgui.Create("DFrame")
	HMenu:SetSize(Ow,Oh)
	HMenu:SetPos(w/2-Ow/2,h/2-Oh/2)
	HMenu:SetDraggable ( false )
	HMenu:SetTitle("")
	HMenu:ShowCloseButton (true)
	HMenu:MakePopup()
	HMenu.Paint = function()

	end
	
	local name = vgui.Create("DLabel",HMenu)
	name:SetTall(50)
	name:SetText("")
	name:Dock( TOP )
	name:DockMargin( 0,0,0,10 )
	name.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		draw.SimpleText( translate.Get("help_title"), "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	HList = vgui.Create( "DPanel", HMenu )
	HList:Dock( FILL )
	HList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	
	local bpanel = vgui.Create( "DPanel", HList )
	bpanel:SetTall(50)
	bpanel:Dock( TOP )
	bpanel:DockMargin( 2,2,2,2 )
	bpanel.Paint = function(self,fw,fh)
		//draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		//draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
	end
	
	local but = {}
	
	for i=1, #HelpPage do
		but[i] = vgui.Create( "DButton", bpanel )
		but[i]:Dock( LEFT )
		but[i]:SetText("")
		but[i].OnCursorEntered = function(self)
			self.Overed = true
		end
		but[i].OnCursorExited = function(self)
			self.Overed = false
		end
		but[i].Paint = function(self,fw,fh)
			if self.Overed then
				
				draw.RoundedBox( 6,0,0, fw, fh, COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
				draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
			else
				draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
				draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
			end
			draw.SimpleText( translate.Get( HelpPage[i].ButtonName ), "Arial_Bold_20", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but[i].DoClick = function()
			if HContent then
				HContent:SetText( translate.Get( HelpPage[i].Text ) )
				HContent.Page = i
			end
		end
		but[i].Think = function(self)
			self:SetWide(self:GetParent():GetWide()/#HelpPage)
		end
		
	end

	
	local HContentPanel = vgui.Create( "DScrollPanel", HList )
	HContentPanel:Dock( FILL )
	HContentPanel:DockMargin( 2,2,2,2 )
	HContentPanel.Paint = function() end
	
	HContent = vgui.Create( "DTextEntry", HContentPanel )
	HContent:SetFont("Arial_Bold_18")
	HContent:SetTextColor(COLOR_TEXT_SOFT_BRIGHT)
	HContent:SetMultiline( true )
	HContent:SetEditable(false)
	HContent:SetText( translate.Get( HelpPage[1].Text ) )
	HContent.Page = 1
	//HContent:SizeToContents()
	//HContent:Dock( FILL )
	HContent:SetDrawBackground( false )
	HContent.Think = function(self)
		surface.SetFont("Arial_Bold_18")
		local tw,th = surface.GetTextSize( translate.Get( HelpPage[self.Page].Text ) )
		self:SetTall(th*1.4)
		self:SetWide(HContentPanel:GetWide()-20)
	end	
	
end

// mapcycle thingy

MapCycle_cl = nil

local function ConfirmMapcycle( txt )
	
	if txt then
		
		local raw_data = string.gsub( txt, " ", "" )
		local compressed = util.Compress( raw_data )
		local len = string.len( compressed )
		
		net.Start( "SendMapCycleToServer" )
			net.WriteInt( len, 32 )
			net.WriteData( compressed, len )
		net.SendToServer()
		
	end
	
end

function MapManagerMenu()

	local w,h = ScrW(),ScrH()
	local Ow,Oh = 300,h/1.4
	
	if InLobby then return end
	
	if MapMenu then
		MapMenu:Remove()
		MapMenu = nil
	end
	
	MapMenu = vgui.Create("DFrame")
	MapMenu:SetSize(Ow,Oh)
	MapMenu:SetPos(w/2-Ow/2,h/2-Oh/2)
	MapMenu:SetDraggable ( false )
	MapMenu:SetTitle("")
	MapMenu:ShowCloseButton (true)
	MapMenu:MakePopup()
	MapMenu.Paint = function()

	end
	
	local name = vgui.Create("DLabel",MapMenu)
	name:SetTall(50)
	name:SetText("")
	name:Dock( TOP )
	name:DockMargin( 0,0,0,10 )
	name.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		draw.SimpleText( "Map Cycle", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local saveBtn = vgui.Create( "DButton", MapMenu )
	saveBtn:SetTall( 30 )
	saveBtn:Dock( BOTTOM )
	saveBtn:DockMargin( 0,10,0,0 )
	saveBtn:SetText("")
	saveBtn.OnCursorEntered = function(self)
		self.Overed = true
	end
	saveBtn.OnCursorExited = function(self)
		self.Overed = false
	end
	saveBtn.Paint = function(self,fw,fh)
		if self.Overed then
			draw.RoundedBox( 6,0,0, fw, fh, COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
			draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
		else
			draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
		end
		draw.SimpleText( "SAVE MAPCYCLE", "Arial_Bold_20", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	MapList = vgui.Create( "DScrollPanel", MapMenu )
	MapList:Dock( FILL )
	MapList:DockMargin( 4, 2, 4, 2 )
	MapList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	MapText = vgui.Create( "DTextEntry", MapList )
	MapText:SetFont( "Arial_Bold_18" )
	//MapText:SetTextColor( COLOR_TEXT_SOFT_BRIGHT )
	//MapText:SetCursorColor( COLOR_TEXT_SOFT_BRIGHT )
	MapText:SetMultiline( true )
	MapText:SetEditable( true )
	MapText:SetWide( Ow - 8 )
	MapText:SetText( MapCycle_cl or "Loading map cycle...")//
	if MapCycle_cl then
		MapText.GotMapCycle = true
	end
	//MapText:SetDrawBackground( false )
	MapText:SetDrawBorder( true )
	MapText.Think = function( self )
	
		if not self.GotMapCycle and MapCycle_cl then
			self:SetText( MapCycle_cl )
			self.GotMapCycle = true
		end
	
		surface.SetFont("Arial_Bold_18")
		local tw,th = surface.GetTextSize( self:GetValue() or "" )
		self:SetTall( math.max( th*1.1, MapList:GetTall() ) )
	end	
	
	saveBtn.DoClick = function()
		if MapCycle_cl and MapText:GetValue() ~= "" then
			surface.PlaySound("buttons/button9.wav")
			ConfirmMapcycle( MapText:GetValue() )
		end
	end
	
	//MapText:Dock( FILL )
	
end

local Points_cl = nil
local Exploits_cl = nil

local function LookupClientsidePoints()
	local a, b = file.Find("darkestdays/koth_points/*.txt", "DATA")	
	return a or {}
end

local function LookupClientsideExploits()
	local a, b = file.Find("darkestdays/exploits/*.txt", "DATA")	
	return a or {}
end

local function ConfirmPointsFile( name )
	
	if name then
		
		local txt = file.Read( "darkestdays/koth_points/"..name..".txt", "DATA" )
		
		if txt then
		
			local compressed = util.Compress( txt ) 
			local len = string.len( compressed )
			
			net.Start( "SendMapPointsToServer" )
				net.WriteString( name )
				net.WriteInt( len, 32 )
				net.WriteData( compressed, len )
			net.SendToServer()
			
		end
		
	end
	
end

local function ConfirmExploitsFile( name )
	
	if name then
		
		local txt = file.Read( "darkestdays/exploits/"..name..".txt", "DATA" )
		
		if txt then
		
			local compressed = util.Compress( txt ) 
			local len = string.len( compressed )
			
			net.Start( "SendMapExploitsToServer" )
				net.WriteString( name )
				net.WriteInt( len, 32 )
				net.WriteData( compressed, len )
			net.SendToServer()
			
		end
		
	end
	
end

function MapProfilerMenu()

	local w,h = ScrW(),ScrH()
	local Ow,Oh = 720,h/1.4
	
	if InLobby then return end
	
	if ProfilerMenu then
		ProfilerMenu:Remove()
		ProfilerMenu = nil
	end
	
	ProfilerMenu = vgui.Create("DFrame")
	ProfilerMenu:SetSize(Ow,Oh)
	ProfilerMenu:SetPos(w/2-Ow/2,h/2-Oh/2)
	ProfilerMenu:SetDraggable ( false )
	ProfilerMenu:SetTitle("")
	ProfilerMenu:ShowCloseButton (true)
	ProfilerMenu:MakePopup()
	ProfilerMenu.Paint = function()

	end
	
	local name = vgui.Create("DLabel",ProfilerMenu)
	name:SetTall(50)
	name:SetText("")
	name:Dock( TOP )
	name:DockMargin( 0,0,0,10 )
	name.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		draw.SimpleText( "Map Profiler", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local list_parent = vgui.Create( "DPanel", ProfilerMenu )
	list_parent:Dock( FILL )
	list_parent:DockMargin( 4, 2, 4, 2 )
	list_parent.Paint = function(self,fw,fh)
		//draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		//draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
		
	local PointsList = vgui.Create( "DScrollPanel", list_parent )
	PointsList:Dock( LEFT )
	PointsList:SetWide( ProfilerMenu:GetWide() / 2 - 16 )
	PointsList:DockMargin( 0, 2, 4, 2 )
	PointsList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	local ExploitList = vgui.Create( "DScrollPanel", list_parent )
	ExploitList:Dock( RIGHT )
	ExploitList:SetWide( ProfilerMenu:GetWide() / 2 - 16 )
	ExploitList:DockMargin( 0, 2, 4, 2 )
	ExploitList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	
	-- fill points list
	
	for _, profile in pairs( LookupClientsidePoints() ) do
		
		if profile then
		
			local Btn = vgui.Create( "DButton", PointsList )
			Btn:SetTall( 30 )
			Btn:Dock( TOP )
			Btn:DockMargin( 0,0,0,2 )
			Btn:SetText("")
			Btn.FileName = profile
			Btn.MapName = string.gsub( Btn.FileName, ".txt", "" )
			Btn.OnCursorEntered = function(self)
				self.Overed = true
			end
			Btn.OnCursorExited = function(self)
				self.Overed = false
			end
			Btn.Paint = function(self,fw,fh)
				if self.Overed then
					draw.RoundedBox( 6,0,0, fw, fh, COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
					draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
				else
					draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
					draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
				end
				draw.SimpleText( "[PNT] "..self.MapName, "Arial_Bold_16", 4, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if Points_cl and Points_cl[ Btn.FileName ] or Btn.SentToServer then
					draw.SimpleText( "[ON SERVER]", "Arial_Bold_16", self:GetWide() - 4, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end
			Btn.DoClick = function( self )
				if not self.SentToServer and self.MapName then
					surface.PlaySound("buttons/button9.wav")
					ConfirmPointsFile( self.MapName )
					self.SentToServer = true
				end
			end
		
		end

	end
	
	-- same but for exploits
	
	for _, profile in pairs( LookupClientsideExploits() ) do
		
		if profile then
		
			local Btn = vgui.Create( "DButton", ExploitList )
			Btn:SetTall( 30 )
			Btn:Dock( TOP )
			Btn:DockMargin( 0,0,0,2 )
			Btn:SetText("")
			Btn.FileName = profile
			Btn.MapName = string.gsub( Btn.FileName, ".txt", "" )
			Btn.OnCursorEntered = function(self)
				self.Overed = true
			end
			Btn.OnCursorExited = function(self)
				self.Overed = false
			end
			Btn.Paint = function(self,fw,fh)
				if self.Overed then
					draw.RoundedBox( 6,0,0, fw, fh, COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
					draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
				else
					draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
					draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
				end
				draw.SimpleText( "[EXP] "..self.MapName, "Arial_Bold_16", 4, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if Exploits_cl and Exploits_cl[ Btn.FileName ] or Btn.SentToServer then
					draw.SimpleText( "[ON SERVER]", "Arial_Bold_16", self:GetWide() - 4, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end
			Btn.DoClick = function( self )
				if not self.SentToServer and self.MapName then
					surface.PlaySound("buttons/button9.wav")
					ConfirmExploitsFile( self.MapName )
					self.SentToServer = true
				end
			end
		
		end

	end
	
	
	
end

net.Receive( "SendMapCycleToClient", function( len )

	MapCycle_cl = nil

	local data_len = net.ReadInt( 32 )
	local data = net.ReadData( data_len )
	local decompressed = util.Decompress( data )
	
	MapCycle_cl = decompressed
	
	MapManagerMenu()
	
end)

net.Receive( "SendMapProfilesToClient", function( len )

	Points_cl = nil
	Exploits_cl = nil

	local data_len = net.ReadInt( 32 )
	local data = net.ReadData( data_len )
	local decompressed = util.Decompress( data )
	
	local points_temp = string.Explode( " ", decompressed )
	
	Points_cl = {}
	for k, v in pairs( points_temp ) do
		if v and v ~= "" then
			Points_cl[ v ] = true
		end
	end
	
	local data_len2 = net.ReadInt( 32 )
	local data2 = net.ReadData( data_len2 )
	local decompressed2 = util.Decompress( data2 )
	
	local exploits_temp = string.Explode( " ", decompressed2 )
	
	Exploits_cl = {}
	for k, v in pairs( exploits_temp ) do
		if v and v ~= "" then
			Exploits_cl[ v ] = true
		end
	end
	
	MapProfilerMenu()
	
end)