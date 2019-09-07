local grad = surface.GetTextureID( "gui/center_gradient" )
Votemaplist = {}
VotePoints = {}
VotePointsGM = {}
ShowRestart = true

local LockedGM = {}

local maps = {}
local mapFiles = file.Find( "maps/*.bsp", "GAME" )
local cleanname
for _,mapname in pairs(mapFiles) do
	cleanname = string.sub(mapname, 1, -5)
	if file.Exists("maps/"..cleanname..".png", "GAME") then
		maps[cleanname] = Material("../maps/"..cleanname..".png")
	end
end

local function ReceiveVotemaps ( len )
	
	if GAMEMODE:GetGametype() == "ffa" then
		ROUNDWINNER = net.ReadEntity()
	else
		ROUNDWINNER = net.ReadString()
	end

	ShowRestart = util.tobool(net.ReadBit())
	
	Votemaplist = {}
	
	for i = 1,MAX_VOTEMAPS do
		Votemaplist[i] = net.ReadString()
	end
	
	LockedGM = table.Copy( net.ReadTable() )
	
	PrintTable( LockedGM )
	
	PrintTable ( Votemaplist )
end
net.Receive("RecVotemaps", ReceiveVotemaps)


local function ReceiveVotePoints ( len ) 
	for i = 1,MAX_VOTEMAPS do
		VotePoints[i] = net.ReadInt( 32 )
	end
	
	if ShowRestart then
		VotePoints[MAX_VOTEMAPS+1] = net.ReadInt( 32 )
	end
	
end
net.Receive("RecVoteChange",ReceiveVotePoints)

local function ReceiveVotePointsGM ( len ) 
	
	for k,v in pairs(GAMEMODE.Gametypes) do
		if not v.Hidden then
			VotePointsGM[k] = net.ReadInt( 32 )
		end
	end
end
net.Receive("RecVoteChangeGM",ReceiveVotePointsGM)

local function MaxResult(tbl)
	
	local MaximumPoint = -100
	Winner = ""
	for k,v in pairs (tbl) do
		local CurrentPoint = v
		if CurrentPoint > MaximumPoint then
			MaximumPoint = CurrentPoint
			Winner = k ~= ( MAX_VOTEMAPS + 1 ) and Votemaplist[k] or "restart"
		end
	end
	
	return Winner
	
end

local function MaxResultGM(tbl)
	
	local MaximumPoint = -100
	Winner = GAMEMODE.Gametypes["koth"].Name//""
	for k,v in pairs (tbl) do
		local CurrentPoint = v
		if CurrentPoint > MaximumPoint then
			MaximumPoint = CurrentPoint
			Winner = GAMEMODE.Gametypes[k] and GAMEMODE.Gametypes[k].Name or GAMEMODE.Gametypes["koth"].Name
		end
	end
	
	return Winner
	
end

local function CallEndRound ( len ) 

	local time = net.ReadInt( 32 )
	DrawEndround( time )

end
net.Receive("CallDrawEndRound",CallEndRound)

function DrawEndround(time)
	
	local w,h = ScrW(),ScrH()
	
	if EndMenu then
		EndMenu:Remove()
		EndMenu = nil
	end
	
	if CMMenu then
		SaveEquipment()
		CMMenu:Remove()
		CMMenu = nil
	end

	ENDROUND = true
	
	MySelf.Voted = nil
	MySelf.VotedGameType = nil
	
	local tW,tH = math.max(w/2.3,600),h/2
	
	EndMenu = vgui.Create("DFrame")
	EndMenu:SetSize(tW,tH)
	EndMenu:Center()//SetPos(0,0)
	EndMenu:SetDraggable ( false )
	EndMenu:SetTitle("")
	EndMenu:ShowCloseButton (false)
	EndMenu.Paint = function() end
	EndMenu.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	//dont click by accident
	//gui.SetMousePos( w/2, 0 )
	
	local wincol = COLOR_TEXT_SOFT_BRIGHT
	
	for i=3,5 do
		if ROUNDWINNER ~= "Noone" and team.GetName(i) == ROUNDWINNER or type(ROUNDWINNER) == "Player" and ROUNDWINNER:Team() == i then
			wincol = team.GetColor(i)
			break
		end
	end
	
	local winner = vgui.Create("DLabel",EndMenu)
	winner:SetTall(70)
	winner:SetText("")
	winner:Dock( TOP )
	winner:DockMargin( 0,0,0,10 )
	winner.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		local todraw = type(ROUNDWINNER) == "Player" and IsValid(ROUNDWINNER) and ROUNDWINNER.Name and ROUNDWINNER:Name() or tostring(ROUNDWINNER)
		if GAMEMODE:GetGametype() == "ts" then
			if todraw == team.GetName(TEAM_BLUE) then
				if #team.GetPlayers(TEAM_BLUE) < 1 then
					draw.SimpleText( "Humans have failed the round!", "Bison_45", fw/2, fh/2, team.GetColor(TEAM_RED) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText( "Humans have won the round!", "Bison_45", fw/2, fh/2, team.GetColor(TEAM_BLUE) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			draw.SimpleText( (todraw or "Noone").." won the round!", "Bison_45", fw/2, fh/2, wincol , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	local restartsize = 60
	
	local mappanel = vgui.Create("DPanel",EndMenu)
	mappanel:SetWide(tW/2-2)
	mappanel:Dock( LEFT )
	mappanel:DockMargin( 0,0,2,0 )
	mappanel.Paint = function() end
	
	local stuffpanel = vgui.Create("DPanel",EndMenu)
	stuffpanel:SetWide(tW/2-10)
	stuffpanel:Dock( LEFT )
	//mappanel:DockMargin( 2,2,0,0 )
	stuffpanel.Paint = function() end
	
	if ShowRestart then
		local restartbtn = vgui.Create("DButton",mappanel)
		restartbtn:Dock( BOTTOM )//i < 3 and LEFT or RIGHT
		restartbtn:SetTall(restartsize)
		restartbtn:SetText("")
		restartbtn.DoClick = function()
			if MySelf.Voted ~= ( MAX_VOTEMAPS + 1 ) then
				RunConsoleCommand ( "VoteAddMap", tostring( MAX_VOTEMAPS + 1 ) )
				MySelf.Voted = MAX_VOTEMAPS + 1
			end
		end
		restartbtn.OnCursorEntered = function() 
			restartbtn.Overed = true 
		end
		restartbtn.OnCursorExited = function () 
			restartbtn.Overed = false
		end
		restartbtn.Paint = function(self,fw,fh)
			draw.RoundedBox( 2,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 2,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
			if self.Overed then
				draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT )
				draw.SimpleText ( "Restart current map","Arial_Bold_20", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.RoundedBox( 2,fw-fh+2,2,fh-4,fh-4, COLOR_DESELECTED_BRIGHT)
				draw.SimpleText ( VotePoints[MAX_VOTEMAPS + 1] or 0,"Arial_Bold_20", fw-fh/2-2,fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT)
				draw.SimpleText ( "Restart current map","Arial_Bold_20", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.RoundedBox( 2,fw-fh+2,2,fh-4,fh-4, COLOR_BACKGROUND_DARK)
				draw.SimpleText ( VotePoints[MAX_VOTEMAPS + 1] or 0,"Arial_Bold_20", fw-fh/2-2,fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			//draw.SimpleTextOutlined ( name.." "..((VotePoints[i] and VotePoints[i] > 0 and ("| Votes: "..VotePoints[i])) or ""), "Arial_Bold_23", MapButton:GetWide()/2, MapButton:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
		
	end
	
	
	local ideal = mappanel:GetTall()/2-((ShowRestart and restartsize) or 0)
	local ideal2 = mappanel:GetTall()/2+((ShowRestart and restartsize) or 0)
	
	local mappanel_l = vgui.Create("DPanel",mappanel)
	mappanel_l:SetWide(mappanel:GetWide()/2)
	//mappanel_up:SetTall(mappanel:GetTall()/2)
	mappanel_l:Dock( LEFT )
	mappanel_l.Paint = function(self,fw,fh)
		//draw.RoundedBox( 8,0,0, fw, fh, Color(155,0,0,255))
	end
	
	local mappanel_r = vgui.Create("DPanel",mappanel)
	mappanel_r:SetWide(mappanel:GetWide()/2)
	//mappanel_bo:SetTall(ideal2)
	mappanel_r:Dock( RIGHT )
	mappanel_r.Paint = function(self,fw,fh)
		//draw.RoundedBox( 8,0,0, fw, fh, Color(255,0,0,255))
	end
	
	for i=1,MAX_VOTEMAPS do
	
		local name = Votemaplist[i] or "no name"
	
		local MapButton = vgui.Create("DButton",i <= ( MAX_VOTEMAPS / 2 ) and mappanel_l or mappanel_r)
		MapButton:Dock( TOP )
		MapButton:SetZPos(math.random(-2,2))
		MapButton:SetWide(mappanel:GetWide()/2)
		MapButton:SetText("")
		MapButton.Think = function(self)
			self:SetTall(mappanel_l:GetTall()/(MAX_VOTEMAPS/2))
		end
		MapButton.DoClick = function()
			if MySelf.Voted ~= i then
				RunConsoleCommand ( "VoteAddMap", tostring(i) )
				MySelf.Voted = i
			end
		end
		MapButton.OnCursorEntered = function() 
			MapButton.Overed = true 
		end
		MapButton.OnCursorExited = function () 
			MapButton.Overed = false
		end
		MapButton.Paint = function(self,fw,fh)
			//local min = math.min(fw,fh)
			
			local len = string.len( name )
			
			draw.RoundedBox( 2,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 2,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
			
			if self.Overed then
				draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT )
				if maps[name] then
					surface.SetDrawColor(color_white)
					surface.SetMaterial(maps[name])
					surface.DrawTexturedRectRotated(fw/2,fh/2,fw-4,fh-4,0)
				end
				
				draw.RoundedBoxEx( 2,2,fh*4/5-2,fw-4,fh/5, COLOR_DESELECTED_BRIGHT, false, false, true, true )
				draw.SimpleText ( name, len > 20 and "Arial_Bold_16" or "Arial_Bold_20", fw/2, fh*4/5-2 + fh/5/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.RoundedBox( 2,fw-2-fh/5,2,fh/5,fh/5, COLOR_DESELECTED_BRIGHT)
				draw.SimpleText ( VotePoints[i] or 0,"Arial_Bold_20", fw-2-fh/5/2, 2+fh/5/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT)
				if maps[name] then
					surface.SetDrawColor(COLOR_DESELECTED_BRIGHT)//
					surface.SetMaterial(maps[name])
					surface.DrawTexturedRectRotated(fw/2,fh/2,fw-4,fh-4,0)
				end
				
				draw.RoundedBoxEx( 2,2,fh*4/5-2,fw-4,fh/5, COLOR_BACKGROUND_DARK, false, false, true, true )
				draw.SimpleText ( name, len > 20 and "Arial_Bold_16" or "Arial_Bold_20", fw/2, fh*4/5-2 + fh/5/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.RoundedBox( 2,fw-2-fh/5,2,fh/5,fh/5, COLOR_BACKGROUND_DARK)
				draw.SimpleText ( VotePoints[i] or 0,"Arial_Bold_20", fw-2-fh/5/2, 2+fh/5/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				//draw.SimpleText ( "Loadout "..i,"Arial_Bold_30", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			//draw.SimpleTextOutlined ( name.." "..((VotePoints[i] and VotePoints[i] > 0 and ("| Votes: "..VotePoints[i])) or ""), "Arial_Bold_23", MapButton:GetWide()/2, MapButton:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
	end
	

	
	local bottompanel = vgui.Create("DPanel",stuffpanel)
	//bottompanel:SetWide(stuffpanel:GetWide())
	//bottompanel:SetTall(100)
	bottompanel:Dock( BOTTOM )
	bottompanel.Think = function()
		bottompanel:SetTall(stuffpanel:GetTall()/3)
	end
	bottompanel.Paint = function(self,fw,fh)
		//draw.RoundedBox( 8,0,0, fw, fh, Color(155,0,0,255))
		draw.RoundedBox( 2,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 2,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		
		local result = "Next map "..(Votemaplist[1] or "cs_assault").." in "..math.Clamp(math.floor(time-CurTime()),0,9999)
		local winmap = MaxResult(VotePoints)
		local wingm = MaxResultGM(VotePointsGM)
		
		if winmap == "restart" then
			result = "Restarting map in "..math.Clamp(math.floor(time-CurTime()),0,9999)
		else
			if winmap ~= "" then
				result = "Next map: "..winmap.." in "..math.Clamp(math.floor(time-CurTime()),0,9999)
			end
		end
		
		local len = string.len( result )
		
		draw.SimpleText( result, len > 35 and "Arial_Bold_18" or "Arial_Bold_23", 10, fh/4, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText( "Next gametype: "..wingm, "Arial_Bold_20", 10, fh*3/4, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
	end
	
	local gametypepanel = vgui.Create("DPanel",stuffpanel)
	//gametypepanel:SetWide(mappanel:GetWide()/2)
	//gametypepanel:SetTall(100)
	gametypepanel:Dock( FILL )
	gametypepanel.Paint = function(self,fw,fh)
		draw.RoundedBox( 2,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 2,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	local count = 0
	for k,v in pairs(GAMEMODE.Gametypes) do
		if not v.Hidden then
			count = count + 1
		end
	end
	
	for k,v in pairs(GAMEMODE.Gametypes) do
		if v.Hidden then continue end
		
		local gm = vgui.Create("DButton",gametypepanel)
		gm:Dock( TOP )//i < 3 and LEFT or RIGHT
		//gm:SetTall(gametypepanel:GetTall()/2)
		gm:SetText("")
		gm:SetZPos(math.random(-3,3))
		if LockedGM[k] then
			gm:SetDisabled( true )
			gm:SetCursor( "arrow" )
		end
		gm.Think = function(self)
			self:SetTall(gametypepanel:GetTall()/count)
		end
		gm.DoClick = function()
			if MySelf.VotedGameType ~= k then
				RunConsoleCommand ( "VoteAddGametype", tostring(k) )
				MySelf.VotedGameType =k
			end
		end
		gm.OnCursorEntered = function() 
			if not LockedGM[k] then
				gm.Overed = true 
			end
		end
		gm.OnCursorExited = function () 
			if not LockedGM[k] then
				gm.Overed = false
			end
		end
		gm.Paint = function(self,fw,fh)
			//local min = math.min(fw,fh)
			
			draw.RoundedBox( 2,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 2,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
			
			if self.Overed then
				draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT )
				draw.SimpleText ( LockedGM[k] and ("Unlocks in "..LockedGM[k].." rounds") or v.Name or k,"Arial_Bold_25", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				if not LockedGM[k] then
					draw.RoundedBoxEx( 2,fw*5/6-2,2,fw/6,fh-4, COLOR_DESELECTED_BRIGHT, false, false, true, true )
					draw.SimpleText (  VotePointsGM[k] or 0,"Arial_Bold_25", fw*5/6-2+fw/6/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				//draw.RoundedBox( 2,fw-2-fh/5,2,fh/5,fh/5, COLOR_DESELECTED_BRIGHT)
				//draw.SimpleText ( VotePoints[i] or 0,"Arial_Bold_20", fw-2-fh/5/2, 2+fh/5/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				if LockedGM[k] then
					
					draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_BACKGROUND_DARK)
					draw.SimpleText ( LockedGM[k] and ("Unlocks in "..LockedGM[k].." rounds") or v.Name or k,"Arial_Bold_25", fw/2, fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				else
				
					draw.RoundedBox( 2,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT)
					draw.SimpleText ( LockedGM[k] and ("Unlocks in "..LockedGM[k].." rounds") or v.Name or k,"Arial_Bold_25", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
					draw.RoundedBox( 2,fw*5/6-2,2,fw/6,fh-4, COLOR_BACKGROUND_DARK )
					draw.SimpleText (  VotePointsGM[k] or 0,"Arial_Bold_25", fw*5/6-2+fw/6/2, fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				end

			end
		end
		
	end
	
	end



function DrawEndroundOld(time)
	
	local w,h = ScrW(),ScrH()
	
	if EndMenu then
		EndMenu:Remove()
		EndMenu = nil
	end
	
	/*if InvisiblePanel then
		InvisiblePanel:Remove()
		InvisiblePanel = nil
	end*/
	
	if CMMenu then
		SaveEquipment()
		CMMenu:Remove()
		CMMenu = nil
	end
	
	if LoadoutSelection then

	end
	
	ENDROUND = true
	
	MySelf.Voted = false
	
	EndMenu = vgui.Create("DFrame")
	EndMenu:SetSize(w,h)
	EndMenu:SetPos(0,0)
	EndMenu:SetDraggable ( false )
	EndMenu:SetTitle("")
	EndMenu:ShowCloseButton (false)
	EndMenu.Paint = function() 
		
		surface.SetTexture(grad)
		surface.SetDrawColor(0, 0, 0, 220 )
		surface.DrawTexturedRectRotated(EndMenu:GetWide()/2,EndMenu:GetTall()/2,EndMenu:GetWide(),EndMenu:GetTall()*0.85,0)
		
		
		local result = "Next map will be "..(Votemaplist[1] or "cs_assault").." in "..math.Clamp(math.floor(time-CurTime()),0,9999)
		local win = MaxResult(VotePoints)
		
		if win == "restart" then
			result = "Restarting current map in "..math.Clamp(math.floor(time-CurTime()),0,9999)
		else
			if win ~= "" then
				result = "Next map will be "..win.." in "..math.Clamp(math.floor(time-CurTime()),0,9999)
			end
		end
		
		local col = Color(255, 255, 255, 255)
		
		for i=3,4 do
			if ROUNDWINNER ~= "Noone" and team.GetName(i) == ROUNDWINNER then
				col = team.GetColor(i)
				break
			end
		end
		
	
		
		draw.SimpleTextOutlined ( (ROUNDWINNER or "Noone").." won the round!", "Arial_Bold_60", EndMenu:GetWide()/2, EndMenu:GetTall()*1/5, col , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		draw.SimpleTextOutlined ( result, "Arial_Bold_23", EndMenu:GetWide()/2, EndMenu:GetTall()*4/5, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	end
	EndMenu.Think = function ()
		gui.EnableScreenClicker(true)
	end
	
	local lW,lH = ScaleW(230),ScaleH(60)
	local lX,lY = w/2-lW/2,h/3
	
	local step = 0
	for i=1,(ShowRestart and ( MAX_VOTEMAPS + 1 ) or MAX_VOTEMAPS) do
		
		local Restart = ( i == ( MAX_VOTEMAPS + 1 ) ) and ShowRestart
		
		local addstep = 2
		if Restart then
			addstep = lH
		end
		
		local name = Votemaplist[i] or "Error!"
		
		if Restart then
			name = "Restart current map"
		end
		
		local MapButton = vgui.Create("DButton",EndMenu)
		MapButton:SetPos(lX,lY+step*(lH+6)+addstep)
		MapButton:SetSize(lW,lH)
		MapButton:SetText("")
		MapButton.DoClick = function()
			if not MySelf.Voted then
				RunConsoleCommand ( "VoteAddMap", tostring(i) )
				MySelf.Voted = true
			end
		end
		MapButton.OnCursorEntered = function() 
			MapButton.Overed = true 
		end
		MapButton.OnCursorExited = function () 
			MapButton.Overed = false
		end
		MapButton.Paint = function()
			surface.SetTexture(grad)
			if MapButton.Overed then
				surface.SetDrawColor(60, 60, 60, 200 )
			else
				surface.SetDrawColor(0, 0, 0, 220 )
			end
			surface.DrawTexturedRectRotated(MapButton:GetWide()/2,MapButton:GetTall()/2,MapButton:GetWide(),MapButton:GetTall(),0)
			draw.SimpleTextOutlined ( name.." "..((VotePoints[i] and VotePoints[i] > 0 and ("| Votes: "..VotePoints[i])) or ""), "Arial_Bold_23", MapButton:GetWide()/2, MapButton:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
		
		step = step + 1
	end

end

function CloseEndround()
	if EndMenu then
		gui.EnableScreenClicker(false)
		EndMenu:Remove()
		EndMenu = nil
	end
	VotePoints = {}
	Votemaplist = {}
	VotePointsGM = {}
	
	
	ENDROUND = false
end