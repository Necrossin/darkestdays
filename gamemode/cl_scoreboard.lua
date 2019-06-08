local grad = surface.GetTextureID( "gui/center_gradient" )
local logo = Material( "darkestdays/hud/logo.png" )
local logo_bg = Material( "darkestdays/hud/logo_bg.png" )

local comtoname = {
	["admin_kick"] = "Kick",
}

local function CreateReasonForm( command, id )

	if not command or not id then return end
	
	local form = vgui.Create("DFrame")
	form:SetSize(300,80)
	form:Center()
	form:SetTitle((comtoname[command] or "Stop").." player "..tostring(Entity(id).Name and Entity(id):Name() or "ERROR"))
	form:ShowCloseButton(false)
	form:MakePopup()
	
	
	local reason = form:Add("DTextEntry")
	reason:SetPos(2,24)
	reason:SetSize(form:GetWide()-4, 23)
	reason:SetText("No reason given.")
	
	local conf = form:Add("DButton")
	conf:SetText("Confirm")
	conf:SetSize( form:GetWide()/2-4, 30 )
	conf:SetPos( 2, form:GetTall() - 32)
	conf.DoClick = function(self)
		RunConsoleCommand("admin_kick", tostring(id), tostring(reason:GetValue() or nil))
		form:Remove()
	end
	
	local cancel = form:Add("DButton")
	cancel:SetText("Cancel")
	cancel:SetSize( form:GetWide()/2-4, 30 )
	cancel:SetPos( form:GetWide()/2+2, form:GetTall() - 32)
	cancel.DoClick = function(self)
		form:Remove()
	end
	

end

local PLAYER_LINE = 
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar		= vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )		

		self.Name		= self:Add( "DPanel" )
		self.Name:Dock( FILL )
		//self.Name:SetFont( "ScoreboardDefault" )
		self.Name:DockMargin( 15, 0, 0, 0 )
		self.Name.Paint = function(s,fw,fh)
			draw.RoundedBoxEx( 4, 0, 0, self.Name:GetWide(), self.Name:GetTall(), Color(0,0,0,255),true,false,true,false )
			if s.IsAdmin then
				draw.SimpleText( s.Text or "","Bison_32",0,fh/2+2,s.Color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)//Color(col.r*0.6,col.g*0.6,col.b*0.6,255)
			else
				draw.SimpleText( s.Text or "","ScoreboardDefault",0,fh/2,s.Color or color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )
			end
		end
		self.Name.OnMousePressed = function( s )
			if MySelf:IsAdmin() and ADMIN_MENU then

					local AdminMenu = DermaMenu()
					//AdminMenu:AddOption("Take screenshot", function() RunConsoleCommand("scanplayer", tostring(self.Player:EntIndex())) end )
					AdminMenu:AddOption("Slay", function() RunConsoleCommand("admin_slay", tostring(self.Player:EntIndex())) end )
					AdminMenu:AddOption("Kick", function() CreateReasonForm( "admin_kick", self.Player:EntIndex() ) end )
					AdminMenu:AddOption("Mute/Unmute", function() RunConsoleCommand("admin_mute", tostring(self.Player:EntIndex())) end )
					AdminMenu:AddOption("Gag/Ungag", function() RunConsoleCommand("admin_gag", tostring(self.Player:EntIndex())) end )
					AdminMenu:AddOption("Block/Enable spawning", function() RunConsoleCommand("admin_delayrespawn", tostring(self.Player:EntIndex())) end )
					AdminMenu:Open()
				
			end
		end
		
		

		self.Mute		= self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping		= self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "ScoreboardDefault" )
		self.Ping:SetTextColor( color_white )
		self.Ping:SetContentAlignment( 5 )
		self.Ping.Paint = function()
			draw.RoundedBoxEx( 4, 0, 0, self.Ping:GetWide(), self.Ping:GetTall(), Color(0,0,0,255),false,true,false,true )
		end

		self.Deaths		= self:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 50 )
		self.Deaths:SetFont( "ScoreboardDefault" )
		self.Deaths:SetTextColor( color_white )
		self.Deaths:SetContentAlignment( 5 )
		self.Deaths.Paint = function()
			draw.RoundedBox( 0, 0, 0, self.Deaths:GetWide(), self.Deaths:GetTall(), Color(0,0,0,255))
		end

		self.Kills		= self:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 50 )
		self.Kills:SetFont( "ScoreboardDefault" )
		self.Kills:SetTextColor( color_white )
		self.Kills:SetContentAlignment( 5 )
		self.Kills.Paint = function()
			draw.RoundedBox( 0, 0, 0, self.Kills:GetWide(), self.Kills:GetTall(), Color(0,0,0,255))
		end

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )
		self.Name.Text = " "..pl:Nick() 
		self.Name.IsAdmin = pl:IsAdmin()
		self.Name.Color = team.GetColor(self.Player:Team() )
		

		self:Think( self )
		

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:Remove()
			return
		end
		
		if self.Name then
			self.Name.Color = team.GetColor(self.Player:Team() )//:SetTextColor( team.GetColor(self.Player:Team() ))
		end

		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills	=	self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths	=	self.Player:Deaths()
			self.Deaths:SetText( self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end

		
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end

		
		self:SetZPos( (self.NumKills * -50) + self.NumDeaths )

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		local col = team.GetColor(self.Player:Team())

		draw.RoundedBox( 4, 0, 0, w, h, col )
		
		if self.Player == MySelf then
			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		

	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );

--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 150 )

		self.Header.Paint = function(panel,fw,fh)
		
			//draw.RoundedBox( 4, 0, 0, self.Header:GetWide(), 140, Color( 0, 0, 0, 150 ) )
			draw.RoundedBox( 4,0,0, fw, 140, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 4,1,1, fw-2,140-2, COLOR_BACKGROUND_DARK)
		
			local mw,mh = logo:Width(),logo:Height()
			local dif = 146/mh
			
			surface.SetMaterial( logo_bg );
			surface.SetDrawColor( Color(255, 255, 255, 255) )
			surface.DrawTexturedRect( 2,2,mw*dif,math.Clamp(mh*dif,0,146))
			
			local ran1 = math.random(120)
			local shake1 = ran1 == 1 and math.random(-4,4) or 0
			local shake2 = ran1 == 1 and math.random(-4,4) or 0
			
			local ran2 = math.random(120)
			local shake3 = ran2 == 1 and math.random(-4,4) or 0
			local shake4 = ran2 == 1 and math.random(-4,4) or 0
			
			draw.SimpleText ( "Darkest","Bison_60", fw/5+shake1, 146/3+shake2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText ( "Days","Bison_60", fw/3.5+shake3, 146/1.5+shake4, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			local hostname = GetHostName()
			local font = "Arial_Bold_20"
	
			if ( string.len(hostname) > 32 ) then
				font = "Arial_Bold_16"
			end
					
			draw.SimpleText( hostname, font, self.Header:GetWide()-10, 40, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			
			draw.SimpleText( GAMEMODE.Gametypes[GAMEMODE:GetGametype()] and GAMEMODE.Gametypes[GAMEMODE:GetGametype()].Name or "King of the Hill", "Arial_Bold_30", self.Header:GetWide()-10, 35+70, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					
			
		end

		self.Help = self:Add( "Panel" )
		self.Help:Dock( BOTTOM )
		self.Help:SetHeight( 40 )
		self.Help.Paint = function()
		
		end
		
		if ENABLE_OUTFITS then
			self.Cust = vgui.Create( "DButton", self.Help )
			self.Cust:Dock( LEFT )
			//self.Cust:SetSize( self:GetWide()/3, 36 )
			self.Cust:SetWidth( 540/3-2.5 )
			self.Cust:DockMargin( 0, 2, 2, 2 )
			self.Cust:SetFont( "ScoreboardDefault" )
			self.Cust:SetTextColor( color_white )
			self.Cust:SetText("Outfit")
			self.Cust.DoClick = function() CustomizationMenu() end
			self.Cust.Paint = function(s,fw,fh)
				draw.RoundedBox( 4,0,0,self.Cust:GetWide(), self.Cust:GetTall(), Color(0, 0, 0, 150))
			end
		end
		
		self.Ach = vgui.Create( "DButton", self.Help )
		self.Ach:Dock( LEFT )
		//self.Op:SetSize( self:GetWide()/3, 36 )
		self.Ach:SetWidth( ENABLE_OUTFITS and ( 540/3-2.5 )  or ( 540/2-2.5 ) )
		self.Ach:DockMargin( ENABLE_OUTFITS and 2 or 0, 2, 2, 2 )
		self.Ach:SetFont( "ScoreboardDefault" )
		self.Ach:SetTextColor( color_white )
		self.Ach:SetText("Stats")
		self.Ach.DoClick = function() AchievementsMenu() end
		self.Ach.Paint = function(s,fw,fh)
			draw.RoundedBox( 4,0,0,self.Ach:GetWide(), self.Ach:GetTall(), Color(0, 0, 0, 150))
		end
		
		self.Op = vgui.Create( "DButton", self.Help )
		self.Op:Dock( LEFT )
		self.Op:SetWidth( ENABLE_OUTFITS and ( 540/3-2.5 )  or ( 540/2-2.5 ) )
		self.Op:DockMargin( 2, 2, 0, 2 )
		self.Op:SetFont( "ScoreboardDefault" )
		self.Op:SetTextColor( color_white )
		self.Op:SetText("Options")
		self.Op.DoClick = function() OptionsMenu() end
		self.Op.Paint = function(s,fw,fh)
			draw.RoundedBox( 4,0,0,self.Op:GetWide(), self.Op:GetTall(), Color(0, 0, 0, 150))
		end

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )
		
		

	end,

	PerformLayout = function( self )

		self:SetSize( 540, ScrH() - ScrH()/2.5 )
		self:SetPos( ScrW() / 2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )

	end,

	Paint = function( s, fw, fh )

		draw.RoundedBox( 4, 0, 150, fw, fh-192, Color( 0, 0, 0, 150 ) )
		
	end,

	Think = function( self, w, h )

		//self.Name:SetText( GetHostName() )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then continue end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			self.Scores:AddItem( pl.ScoreEntry )

		end		

	end,
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" );

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if InLobby then return end

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end
