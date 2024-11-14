
local grad = surface.GetTextureID( "gui/center_gradient" )
local gradright = surface.GetTextureID( "VGUI/gradient-r" )
local gradleft = surface.GetTextureID( "gui/gradient" )
local logo = Material( "darkestdays/hud/logo.png" )
local logo_bg = Material( "darkestdays/hud/logo_bg.png" )

CreateClientConVar("_dd_selectedbuild", "default", true, true)


LoadoutSlot = {}
MenuSlot = {}
SkillSlot = nil
Loadout = Loadout or {{},{},{}}
SelectedLoadout = SelectedLoadout or 1
CachedItems = {}

SelectedIcon = SelectedIcon or nil
SelectedItem = SelectedItem or nil
SelectedText = SelectedText or nil

SelectedBuild = GetConVarString("_dd_selectedbuild")

LoadoutSlotItems = {{},{},{}}

local player_tbl = {}
local dummy = {}
dummy.SetEffect = function() end
dummy.RemoveAllAmmo = function() end
dummy.GetMagicShield = function() return end

local function InvestInSkill( name )
	
	if not name then return end
	if name == "defense" then return end
	if not GetPlayerSkills( SelectedLoadout ) then return end
	if not Skills[name] or not GetPlayerSkills( SelectedLoadout )[name] then return end
	if GetPlayerSkills( SelectedLoadout ).ToSpend < 1 then return end
	if GetPlayerSkills( SelectedLoadout )[name] >= SKILL_MAX_PER_TREE then return end
	
	Stats["player_stuff"][SelectedLoadout]["skills"][name] = Stats["player_stuff"][SelectedLoadout]["skills"][name] + 1
	Stats["player_stuff"][SelectedLoadout]["skills"].ToSpend = Stats["player_stuff"][SelectedLoadout]["skills"].ToSpend - 1
			
end

local function RemoveFromSkill(name)
	
	if not name then return end
	if name == "defense" then return end
	if not GetPlayerSkills( SelectedLoadout ) then return end
	if not Skills[name] or not GetPlayerSkills( SelectedLoadout )[name] then return end
	if GetPlayerSkills( SelectedLoadout )[name] < 1 then return end
	
	Stats["player_stuff"][SelectedLoadout]["skills"][name] = Stats["player_stuff"][SelectedLoadout]["skills"][name] - 1
	Stats["player_stuff"][SelectedLoadout]["skills"].ToSpend = Stats["player_stuff"][SelectedLoadout]["skills"].ToSpend + 1
	
end

local function ResetSkills()
	
	if not GetPlayerSkills( SelectedLoadout ) then return end
	
	for name,v in pairs(Skills) do
		Stats["player_stuff"][SelectedLoadout]["skills"][name] = 0
	end
	
	local toset = Stats["player_stuff"][SelectedLoadout]["skills"].Total
	
	Stats["player_stuff"][SelectedLoadout]["skills"].ToSpend = toset
		
end

local function GetPlayerText()

	player_tbl.Pr = ""
	player_tbl.Stats = player_tbl.Stats or {}
	
	
	dummy = dummy or {}

	dummy._DefaultHealth = 0
	dummy._DefaultMana = 0
	dummy._DefaultSpeed = 0
	dummy._DefaultRunSpeedBonus = 0
	dummy._DefaultJumpPower = 0
	dummy._DefaultMeleeBonus = 0
	dummy._DefaultMeleeSpeedBonus = 0
	dummy._DefaultMResBonus = 0
	dummy._DefaultLightWeaponryBonus = 0
	dummy._DefaultHeavyWeaponryBonus = 0
	dummy._DefaultMagicBonus = 0
	dummy._DefaultMagicRegenBonus = 0
	
	for i=1,2 do
		if LoadoutSlotItems[SelectedLoadout][i] and Weapons[LoadoutSlotItems[SelectedLoadout][i]] and Weapons[LoadoutSlotItems[SelectedLoadout][i]].OnSet then
			Weapons[LoadoutSlotItems[SelectedLoadout][i]].OnSet( dummy )
		end
	end

	if LoadoutSlotItems[SelectedLoadout][5] and Perks[LoadoutSlotItems[SelectedLoadout][5]] and Perks[LoadoutSlotItems[SelectedLoadout][5]].OnSet then
		Perks[LoadoutSlotItems[SelectedLoadout][5]].OnSet( dummy )
	end
		
	if Builds[SelectedBuild] and Builds[SelectedBuild].OnSet then
		Builds[SelectedBuild].OnSet( dummy )
	end
	
	for skill, abil_tbl in pairs( Skills ) do
		local p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )[skill] or 0
		if p and p~= 0 then
			for points, ability in pairs( abil_tbl ) do
				if p >= points then
					if ability and Abilities[ability] and Abilities[ability].OnSet then
						Abilities[ability].OnSet( dummy )
					end
				end
			end
		end
	end
	
	local p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )["defense"] or 0
	
	if p and p~= 0 then
		//player_tbl.Pr = "+"..math.Round(((p*SKILL_DEFENSE_HEALTH_PER_LEVEL)/PLAYER_DEFAULT_HEALTH)*100).."% more health\n"
		//player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_DEFENSE_DAMAGE_PER_LEVEL).."% dmg bonus for assault rifles\n"
	end
	player_tbl.Stats[1] = { "player_stats_health", PLAYER_DEFAULT_HEALTH + dummy._DefaultHealth}
	
	
	
	p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )["magic"] or 0
	
	if p and p~=0 then
		player_tbl.Pr = player_tbl.Pr or ""
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_MAGIC_DAMAGE_PER_LEVEL)..""..translate.Get("player_stats_magic_dmg").."\n"
		if p >= 10 then
			player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_STRENGTH_DODGE_PER_LEVEL*100)..""..translate.Get("player_stats_magic_chn").."\n"
		end
	end
	player_tbl.Stats[2] = { "player_stats_mana", PLAYER_DEFAULT_MANA + SKILL_MAGIC_MANA_PER_LEVEL * (p or 0) + dummy._DefaultMana}
	
	
	
	p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )["agility"] or 0
	
	if p and p~=0 then
		player_tbl.Pr = player_tbl.Pr or ""
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_BULLET_CONSUME_PER_LEVEL*100)..""..translate.Get("player_stats_ammo_chn").."\n"
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_BULLET_FALLOFF_PER_LEVEL)..""..translate.Get("player_stats_bullet_dmg").."\n"
	end
	player_tbl.Stats[3] = { "player_stats_speed", PLAYER_DEFAULT_SPEED + dummy._DefaultSpeed}//+ SKILL_AGILITY_SPEED_PER_LEVEL * (p or 0)
	
	
	
	p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )["strength"] or 0
	
	if p and p~=0 then
		player_tbl.Pr = player_tbl.Pr or ""
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_STRENGTH_DAMAGE_PER_LEVEL)..""..translate.Get("player_stats_melee_dmg").."\n"
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_STRENGTH_MAGIC_RESISTANCE_PER_LEVEL)..""..translate.Get("player_stats_magic_res").."\n"
		player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_STRENGTH_MELEE_SPEED_PER_LEVEL*100)..""..translate.Get("player_stats_melee_spd").."\n"
		if p >= 5 then
			//player_tbl.Pr = player_tbl.Pr.."+"..(p*SKILL_STRENGTH_DODGE_PER_LEVEL*100).."% chance to dodge bullets\n"
		end
	end
	
	if not MySelf._DefaultMeleeSpeedBonus then
		MySelf._DefaultMeleeSpeedBonus = dummy._DefaultMeleeSpeedBonus
	end
	
	if MySelf._DefaultMeleeSpeedBonus and MySelf._DefaultMeleeSpeedBonus ~= dummy._DefaultMeleeSpeedBonus then
		MySelf._DefaultMeleeSpeedBonus = dummy._DefaultMeleeSpeedBonus
	end
	
	return player_tbl

end

net.Receive( "Client:ShowLobby", function( len )
	timer.Simple( 0.2, function() DrawLobby() end )
end)

function DrawLobby()


	w,h = ScrW(), ScrH()
	//local MySelf = LocalPlayer()
	
	local gradH = ScaleH(800)
	
	InLobby = true
	
	TeamCount = {}
	TeamCount[TEAM_RED] = 0
	TeamCount[TEAM_BLUE] = 0
	
	if InvisiblePanel then
		InvisiblePanel:Remove()
		InvisiblePanel = nil
	end
	
	if LoadoutSwitcher then
		LoadoutSwitcher:Remove()
		LoadoutSwitcher = nil
	end
	
	if EndMenu then
		VotePoints = {}
		Votemaplist = {}
		EndMenu:Remove()
		EndMenu = nil
	end
	
	tListW,tListH= ScaleW(200), ScaleH(500)
	
	InvisiblePanel = vgui.Create("DFrame")
	InvisiblePanel:SetSize(w,h)
	InvisiblePanel:SetPos(0,0)
	InvisiblePanel:SetDraggable ( false )
	InvisiblePanel:SetTitle("")
	InvisiblePanel:ShowCloseButton (false)
	InvisiblePanel.Paint = function() 
		
		/*surface.SetTexture(grad)
		surface.SetDrawColor(0, 0, 0, 210 )//255
		surface.DrawTexturedRectRotated(w/2,h/2,w,gradH,0)
		surface.DrawTexturedRectRotated(w/2-w/4,h/2,w,gradH,0)
		surface.DrawTexturedRectRotated(w/2+w/4,h/2,w,gradH,0)
		
		draw.SimpleTextOutlined ( "1. Customise all 3 loadouts!", "Arial_Bold_23", ScaleW(250),h/2-ScaleH(300+(math.Clamp(math.sin(RealTime()*4)*40,20,40))), Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined ( "2. Select your team!", "Arial_Bold_23", w-ScaleW(150)-tListW*2,h/2-tListH/2-ScaleH(0+(math.Clamp(math.sin(RealTime()*4)*40,20,40))), Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))*/
	end
	InvisiblePanel.Think = function ()
		gui.EnableScreenClicker(true)
		
		InvisiblePanel.NextRefresh = InvisiblePanel.NextRefresh or CurTime() + 0.01
		
		if InvisiblePanel.NextRefresh <= CurTime() then
			InvisiblePanel.NextRefresh = CurTime() + 0.01
		//	UpdateTeamLists()
		end


		
	end
	
	TeamLists = {}
	TeamButtons = {}
	local offset = 0
	tListW,tListH= ScaleW(200), ScaleH(500)
	
	MakeTeamSelection()
	
	MakeGentleOffer()
	
	
end
//concommand.Add("open_lobby",DrawLobby)


function MakeGentleOffer()
	
	local convar1 = GetConVarNumber( "gmod_mcore_test" )
	local convar2 = GetConVarNumber( "cl_threaded_bone_setup" )
	
	if convar1 == 1 and convar2 == 1 then return end
	
	local w,h = ScrW(), ScrH()
	
	local tW,tH = math.max(w/4,400) - 10 ,50
	
	local mcore = InvisiblePanel:Add("DButton")
	mcore:SetSize(tW,tH)
	mcore:SetPos( w / 2 - mcore:GetWide() / 2, h * 0.8 )
	mcore:SetText("")
	mcore.OnCursorEntered = function(self) 
		self.Overed = true 
	end
	mcore.OnCursorExited = function(self) 
		self.Overed = false
	end
	
	mcore.DoClick = function(self)
		RunConsoleCommand("gmod_mcore_test", "1")
		RunConsoleCommand("cl_threaded_bone_setup", "1")
		surface.PlaySound( "misc/achievement_earned.wav" )
		MySelf:ChatPrint( translate.Get("multicore_success") )
		local e = EffectData()
			e:SetOrigin( MySelf:GetPos() )
		util.Effect( "achievement_unlock", e )
		self:SetDisabled( true )
		self:SetVisible( false )
	end
	
	mcore.Paint = function(self,fw,fh)
				
		draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		if self.Overed and not self:GetDisabled() then
					
			draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT, true, true, true, true )
			draw.SimpleText ( translate.Get("multicore_ask"),"Arial_Bold_Scaled_34", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
		else
			draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT, true, true, true, true )
			draw.SimpleText ( translate.Get("multicore_ask"),"Arial_Bold_Scaled_34", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		end
	end
	
end

function MakeTeamSelection()
	
	local w,h = ScrW(), ScrH()
	
	local tW,tH = math.max(w/4,400),h/2.5
	
	
	Intro = vgui.Create("DFrame",InvisiblePanel)
	Intro:SetSize(tW,tH)
	//Intro:SetPos(w/2-tW/1.3/2,h/2-tH*1.3)
	Intro:Center()
	Intro:SetBackgroundBlur( true )
	Intro:SetDraggable ( false )
	Intro:SetTitle("")
	Intro:ShowCloseButton (false)
	Intro.Paint = function() end
	Intro.Delay = CurTime() + 3
	
	local logo = Intro:Add("DPanel")
	logo:SetSize(tW-10,tH/1.8)
	logo:Dock( TOP )
	logo.Paint = function(self, fw,fh)
		draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)//Color(247, 235, 198, 220)
		draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		//Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		local mw,mh = logo_bg:Width(),logo_bg:Height()
		
		local dif = (fh/1.1)/mh
		
		//draw.SimpleTextOutlined("by NECROSSIN", "Arial_Bold_23", Intro:GetWide()-30,Intro:GetTall()/3.8, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		surface.SetMaterial( logo_bg );
		surface.SetDrawColor( Color(255, 255, 255, 255) );
		surface.DrawTexturedRectRotated(fw/2,fh/2,mw*dif,math.Clamp(mh*dif,0,fh),0)
		
		local ran1 = math.random(120)
		local shake1 = ran1 == 1 and math.random(-4,4) or 0
		local shake2 = ran1 == 1 and math.random(-4,4) or 0
		
		local ran2 = math.random(120)
		local shake3 = ran2 == 1 and math.random(-4,4) or 0
		local shake4 = ran2 == 1 and math.random(-4,4) or 0
		
		local ran3 = math.random(180)
		local shake5 = ran3 == 1 and math.random(-4,4) or 0
		local shake6 = ran3 == 1 and math.random(-4,4) or 0
		
		
		draw.SimpleText ( "Darkest","Bison_Scaled_80", fw/3.5+shake1, fh/3+shake2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText ( "Days","Bison_Scaled_80", fw/2.3+shake3, fh/1.5+shake4, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText ( GAMEMODE.Version,"Bison_Scaled_45", fw/1.25+shake4, fh/3+shake6, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText ( translate.Format("by_author", "Necrossin"),"Bison_Scaled_35", fw/1.25, fh/1.5, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	end
	
	local TeamButton = {}
	
	if GAMEMODE:GetGametype() == "ffa" then
		
		local tm = TEAM_FFA
		
		TeamButton[tm] = Intro:Add("DButton")
		TeamButton[tm]:SetSize(logo:GetWide(),tH/3)
		TeamButton[tm]:Dock(LEFT)
		TeamButton[tm]:DockMargin( 0, 2,0, 0 )
		TeamButton[tm]:SetText("")
		TeamButton[tm].OnCursorEntered = function(self) 
			self.Overed = true 
		end
		TeamButton[tm].OnCursorExited = function(self) 
			self.Overed = false
		end
		TeamButton[tm].Think = function(self)
			if !IsValid(MySelf) then return end
			local canjoin = true//LocalPlayer():CanJoinTeam(tm)
			self:SetEnabled(canjoin)
			self:SetDisabled(!canjoin)
				
			if MySelf:Team() == TEAM_FFA then
					if Info then
						Info:Close()
					end
					if Intro then
						Intro:Close()
					end
					CreateLoadoutMenu(true)
				end
			end
			TeamButton[tm].DoClick = function(self)
				RunConsoleCommand("lobby_teamselect",tostring(tm))
				Intro.Delay = CurTime() + 0.5
			end
			TeamButton[tm].Paint = function(self,fw,fh)
				
				draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)//Color(247, 235, 198, 220)
				draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
				local tw = 2.5//2.8
				local bw = (fw-4)-(fw-4)/5+2
				if self.Overed and not self:GetDisabled() then
					
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get("ffa_name"),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_DESELECTED_BRIGHT, false, true, false, true )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get("ffa_name"),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_BACKGROUND_DARK, false, true, false, true )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
				end
			end
			
	elseif GAMEMODE:GetGametype() == "ts" then
		
		local tm = TEAM_BLUE
		
		TeamButton[tm] = Intro:Add("DButton")
		TeamButton[tm]:SetSize(logo:GetWide(),tH/3)
		TeamButton[tm]:Dock(LEFT)
		TeamButton[tm]:DockMargin( 0, 2,0, 0 )
		TeamButton[tm]:SetText("")
		TeamButton[tm].OnCursorEntered = function(self) 
			self.Overed = true 
		end
		TeamButton[tm].OnCursorExited = function(self) 
			self.Overed = false
		end
		TeamButton[tm].Think = function(self)
			if !IsValid(MySelf) then return end
			local canjoin = true//LocalPlayer():CanJoinTeam(tm)
			self:SetEnabled(canjoin)
			self:SetDisabled(!canjoin)
				
			if MySelf:Team() == TEAM_BLUE or MySelf:Team() == TEAM_THUG then
					if Info then
						Info:Close()
					end
					if Intro then
						Intro:Close()
					end
					CreateLoadoutMenu(true)
				end
			end
			TeamButton[tm].DoClick = function(self)
				RunConsoleCommand("lobby_teamselect",tostring(tm))
				Intro.Delay = CurTime() + 0.5
			end
			TeamButton[tm].Paint = function(self,fw,fh)
				
				draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)//Color(247, 235, 198, 220)
				draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
				local tw = 2.5//2.8
				local bw = (fw-4)-(fw-4)/5+2
				if self.Overed and not self:GetDisabled() then
					
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get("ts_name"),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_DESELECTED_BRIGHT, false, true, false, true )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get("ts_name"),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_BACKGROUND_DARK, false, true, false, true )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
				end
			end
	
	else
		
		for tm=TEAM_RED,TEAM_BLUE do
		
			TeamButton[tm] = Intro:Add("DButton")
			TeamButton[tm]:SetSize(logo:GetWide()/2-1,tH/3)
			//TeamButton[tm]:SetPos(x,y)
			TeamButton[tm]:Dock(tm==TEAM_RED and LEFT or RIGHT)
			TeamButton[tm]:DockMargin( tm==TEAM_BLUE and 2 or 0, 2, tm==TEAM_RED and 2 or 0, 0 )
			TeamButton[tm]:SetText("")
			TeamButton[tm].OnCursorEntered = function(self) 
				self.Overed = true 
			end
			TeamButton[tm].OnCursorExited = function(self) 
				self.Overed = false
			end
			TeamButton[tm].Think = function(self)
				if !IsValid(MySelf) then return end
				local canjoin = IsValid(MySelf) and MySelf:CanJoinTeam(tm)
				self:SetEnabled(canjoin)
				self:SetDisabled(!canjoin)
				
				if MySelf:Team() == TEAM_RED or MySelf:Team() == TEAM_BLUE and Intro.Delay < CurTime() then
					if Info then
						Info:Close()
					end
					if Intro then
						Intro:Close()
					end
					//TeamSelection:Close()
					CreateLoadoutMenu(true)
				end
			end
			TeamButton[tm].DoClick = function(self)
				RunConsoleCommand("lobby_teamselect",tostring(tm))
				Intro.Delay = CurTime() + 0.5
			end
			TeamButton[tm].Paint = function(self,fw,fh)
				
				draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)//Color(247, 235, 198, 220)
				draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
				local tw = tm == TEAM_RED and 2.8 or 1.7
				local bw = tm == TEAM_RED and (fw-4)-(fw-4)/5+2 or 2
				if self.Overed and not self:GetDisabled() then
					
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get(GAMEMODE.TranslateTeamNameByID[tm]),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_DESELECTED_BRIGHT, tm ~= TEAM_RED, tm == TEAM_RED, tm ~= TEAM_RED, tm == TEAM_RED )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.RoundedBoxEx( 8,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT, true, true, true, true )
					draw.SimpleText ( translate.Get(GAMEMODE.TranslateTeamNameByID[tm]),"Arial_Bold_Scaled_34", fw/tw, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.RoundedBoxEx( 8,bw,2, (fw-4)/5, fh-4, COLOR_BACKGROUND_DARK, tm ~= TEAM_RED, tm == TEAM_RED, tm ~= TEAM_RED, tm == TEAM_RED )
					draw.SimpleText ( team.NumPlayers(tm),"Arial_Bold_Scaled_30", bw+((fw-4)/5)/2, fh/2, COLOR_DESELECTED_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
				
				end
			
			end
			
			x = tW/2
			
		end
	end

end

function MakeTeamSelectionOld()
	
	
	
	w,h = ScrW(), ScrH()
	
	local tW,tH = w/2,h/3
	
	Intro = vgui.Create("DFrame",InvisiblePanel)
	Intro:SetSize(tW/1.3,tH/1.3)
	Intro:SetPos(w/2-tW/1.3/2,h/2-tH*1.3)
	Intro:SetDraggable ( false )
	Intro:SetTitle("")
	Intro:ShowCloseButton (false)
	
	
	
	Intro.Paint = function() 
		surface.SetTexture(grad)
		surface.SetDrawColor(0, 0, 0, 190 )
		surface.DrawTexturedRectRotated(Intro:GetWide()/2,Intro:GetTall()/2,Intro:GetWide(),Intro:GetTall(),0)	

		local mw,mh = logo:Width(),logo:Height()
		
		local dif = 1//(Intro:GetTall())/mh
		
		draw.SimpleTextOutlined("by NECROSSIN", "Arial_Bold_23", Intro:GetWide()-30,Intro:GetTall()/3.8, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		surface.SetMaterial( logo );
		surface.SetDrawColor( Color(255, 255, 255, 255) );
		surface.DrawTexturedRectRotated(Intro:GetWide()/2.4,Intro:GetTall()/2,mw*dif,math.Clamp(mh*dif,0,Intro:GetTall()),0)
		
		draw.SimpleTextOutlined("(Alpha version)", "Arial_Bold_16", Intro:GetWide()-70,Intro:GetTall()-Intro:GetTall()/3.8, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
	end
	
	
	
	TeamSelection = vgui.Create("DFrame",InvisiblePanel)
	TeamSelection:SetSize(tW,tH)
	TeamSelection:SetPos(w/2-tW/2,h/2-tH/2)
	TeamSelection:SetDraggable ( false )
	TeamSelection:SetTitle("")
	TeamSelection:ShowCloseButton (false)
	TeamSelection.Delay = CurTime() + 3
	
	--tW,tH = w/2,h/1.9
	
	TeamSelection.Paint = function() 
		//surface.SetDrawColor( 0, 0, 0, 110 )
		//surface.DrawRect( 0, 0, tW,tH)
		surface.SetTexture(grad)
		surface.SetDrawColor(0, 0, 0, 250 )
		surface.DrawTexturedRectRotated(tW/2,(tH/3)/2,tW,tH/3.5,0)
		draw.SimpleTextOutlined("SELECT YOUR TEAM", "Arial_Bold_50", tW/2,(tH/3)/2, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	local TeamButton = {}
	
	local x,y = 0,tH/3
	
	for tm=TEAM_RED,TEAM_BLUE do
	
		TeamButton[tm] = vgui.Create("DButton",TeamSelection)
		TeamButton[tm]:SetSize(tW/2,2*tH/3)
		TeamButton[tm]:SetPos(x,y)
		TeamButton[tm]:SetText("")
		TeamButton[tm].OnCursorEntered = function() 
			TeamButton[tm].Overed = true 
		end
		TeamButton[tm].OnCursorExited = function () 
			TeamButton[tm].Overed = false
		end
		TeamButton[tm].Think = function()
			local canjoin = MySelf:CanJoinTeam(tm)
			TeamButton[tm]:SetEnabled(canjoin)
			TeamButton[tm]:SetDisabled(!canjoin)
			
			if MySelf:Team() == TEAM_RED or MySelf:Team() == TEAM_BLUE and TeamSelection.Delay < CurTime() then
				if Info then
					Info:Close()
				end
				if Intro then
					Intro:Close()
				end
				TeamSelection:Close()
				CreateLoadoutMenu(true)
			end
		end
		TeamButton[tm].DoClick = function()
			RunConsoleCommand("lobby_teamselect",tostring(tm))
			TeamSelection.Delay = CurTime() + 1
			/*timer.Simple(1,function()
				if LocalPlayer():Team() ~= TEAM_SPECTATOR then
					TeamSelection:Close()
					CreateLoadoutMenu(true)
				end
			end)*/
		end
		TeamButton[tm].Paint = function()
			surface.SetTexture(tm==TEAM_RED and gradright or gradleft)
			if TeamButton[tm].Overed and not TeamButton[tm]:GetDisabled() then
				surface.SetDrawColor(60, 60, 60, 250 )
			else
				surface.SetDrawColor(0, 0, 0, 250 )
			end
			surface.DrawTexturedRect(0,0,TeamButton[tm]:GetWide(),TeamButton[tm]:GetTall())
			
			draw.SimpleTextOutlined("Join "..team.GetName(tm), "Arial_Bold_40", TeamButton[tm]:GetWide()/2,TeamButton[tm]:GetTall()/2.5, team.GetColor(tm), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			draw.SimpleTextOutlined("Players: "..team.NumPlayers(tm), "Arial_Bold_32", TeamButton[tm]:GetWide()/2,TeamButton[tm]:GetTall()/1.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
		
		x = tW/2
		
	end	

end


function UpdateTeamLists()
	
	TeamLists[TEAM_RED]:Clear()
	TeamLists[TEAM_BLUE]:Clear()
	
	for _,pl in pairs(player.GetAll()) do
		if pl:Team()==TEAM_RED or pl:Team()==TEAM_BLUE then
			local PlayerCard = vgui.Create( "DLabel")
			PlayerCard:SetSize(tListW,tListH/14)
			PlayerCard:SetText("")
			PlayerCard.Paint = function()
				if pl == MySelf then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0, PlayerCard:GetWide(), PlayerCard:GetTall())
					surface.DrawOutlinedRect( 1, 1, PlayerCard:GetWide()-2, PlayerCard:GetTall()-2 )
				end
				if ValidEntity(pl) then
					draw.SimpleTextOutlined(pl and pl:Nick() or "none" , "Arial_Bold_16", 5,PlayerCard:GetTall()/2, Color (255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
			end
			//local PlayerAvatar = vgui.Create( "AvatarImage", PlayerCard)
			//PlayerAvatar:SetSize(math.Clamp(32,8,PlayerCard:GetTall()),math.Clamp(32,8,PlayerCard:GetTall()))
			//PlayerAvatar:SetSize(2,PlayerCard:GetTall()/2-PlayerAvatar:GetTall()/2)
			TeamLists[pl:Team()]:AddItem(PlayerCard)
		end
	end
end

function CreateLoadoutMenu(lobby)
	
	if GAMEMODE:GetGametype() == "ts" and MySelf:Team() == TEAM_THUG then
		RunConsoleCommand("lobby_spawn")
		gui.EnableScreenClicker(false)
		InvisiblePanel:Close()
		InLobby = false
		NoDeathHUD = CurTime() + 5
		return
	end
	
	//if not lobby then RunConsoleCommand("update_skills") end
	
	w,h = ScrW(), ScrH()
	local tW,tH = w,h
	
	if LoadoutSelection then
		LoadoutSelection:Remove()
		LoadoutSelection = nil
	end
	
	LoadoutSelection = vgui.Create("DFrame")
	if lobby then
		LoadoutSelection:SetParent(InvisiblePanel)
	end
	LoadoutSelection:SetSize(tW,tH)
	LoadoutSelection:SetPos(0,0)
	LoadoutSelection:SetDraggable(false)
	LoadoutSelection:SetTitle("")
	LoadoutSelection:ShowCloseButton(false)
	
	local tH1 = h/1.4
	local LoadoutW,LoadoutH = math.max(w/1.6,550), tH1
	local LoadoutX,LoadoutY = w/2-LoadoutW/2, h/2-tH1/2
	
	LoadoutSelection.Paint = function() 
		
		draw.RoundedBoxEx( 16,w/2-LoadoutW/2-1,h/2-tH1/2-1, LoadoutW+2, tH1+2, COLOR_BACKGROUND_OUTLINE, true, true, true, true )//Color(247, 235, 198, 220)
		draw.RoundedBoxEx( 16,w/2-LoadoutW/2,h/2-tH1/2, LoadoutW, tH1, COLOR_BACKGROUND_DARK, true, true, true, true )//Color(46, 41, 38, 250)
	
	end
	
	local topbuttonW,topbuttonH = LoadoutW/7, LoadoutH/7.5
	local moveX,moveY = 25,15
	
	SkillsButton = vgui.Create("DButton",LoadoutSelection)
	SkillsButton:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	SkillsButton:SetSize(topbuttonW,topbuttonH)//i == SelectedLoadout and ScaleH(50) or ScaleH(30)
	SkillsButton:SetText("")
	SkillsButton.DoClick = function() 
		for i=1, 5 do
			LoadoutSlot[i].Active = false
			if MenuSlot[i] then
				MenuSlot[i]:Remove()
				MenuSlot[i] = nil
			end
		end
		SelectedIcon = nil
		SelectedItem = MySelf:Nick()
		SelectedText = GetPlayerText()
		SkillsButton.Active = true
		CreateSkillsMenu(overlay:GetWide()/3+15,30,2*overlay:GetWide()/3-30-15,overlay:GetTall()-60)
	end
	SkillsButton.OnCursorEntered = function() 
		SkillsButton.Overed = true 
	end
	SkillsButton.OnCursorExited = function () 
		SkillsButton.Overed = false
	end
	SkillsButton.Paint = function(self)
		if SkillsButton.Overed or SkillsButton.Active then
			draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, false, false )
			draw.SimpleText ( MySelf:Name(), "Arial_Bold_16", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, false, false )
			draw.SimpleText ( MySelf:Name(), "Arial_Bold_16", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		//draw.SimpleTextOutlined ( "Loadout "..i.."  "..(i == SelectedLoadout and " <<" or ""), i == SelectedLoadout and "Arial_Bold_32" or "Arial_Bold_26", LoadoutButton[i]:GetWide()/2, LoadoutButton[i]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	moveX,moveY = 15,15+topbuttonH+LoadoutH*0.7+10
	
	if Stats and Stats[ "player_stuff" ] and Stats[ "player_stuff" ][ SelectedLoadout ] and Stats[ "player_stuff" ][SelectedLoadout]["build"] then
		SelectedBuild = Stats[ "player_stuff" ][SelectedLoadout]["build"]
		RunConsoleCommand("_dd_selectedbuild", tostring( SelectedBuild ))
	end
	
	
	local loadBtnW,loadBtnH = LoadoutW/7,LoadoutH-moveY-15
	
	//Actual loadouts
	LoadoutButton = {}
	local step = 0
	for i=1,3 do
		LoadoutButton[i] = vgui.Create("DButton",LoadoutSelection)
		LoadoutButton[i]:SetPos(LoadoutX+moveX+(loadBtnW+10)*step,LoadoutY+moveY)
		LoadoutButton[i]:SetSize(loadBtnW,loadBtnH)//i == SelectedLoadout and ScaleH(50) or ScaleH(30)
		LoadoutButton[i]:SetText("")
		LoadoutButton[i].DoClick = function() 
			SelectedLoadout = i
			if Stats and Stats[ "player_stuff" ] and Stats[ "player_stuff" ][ SelectedLoadout ] and Stats[ "player_stuff" ][SelectedLoadout]["build"] then
				SelectedBuild = Stats[ "player_stuff" ][SelectedLoadout]["build"]
			end
			SelectedText = GetPlayerText()
		end
		LoadoutButton[i].Think = function()
			//LoadoutButton[i]:SetSize(i == SelectedLoadout and ScaleW(180) or ScaleW(140),ScaleH(120))
		end
		LoadoutButton[i].OnCursorEntered = function() 
			LoadoutButton[i].Overed = true 
		end
		LoadoutButton[i].OnCursorExited = function () 
			LoadoutButton[i].Overed = false
		end
		LoadoutButton[i].Paint = function(self)
			if LoadoutButton[i].Overed or i == SelectedLoadout then
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get("player_loadout").." "..i,"Arial_Bold_26", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get("player_loadout").." "..i,"Arial_Bold_26", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		step=step+1
	end
	
	if Stats and Stats[ "player_stuff" ] then
		for i=1,3 do
			if Stats[ "player_stuff" ][i] and Stats[ "player_stuff" ][i]["loadout"] then
				Loadout[i] = table.Copy( Stats[ "player_stuff" ][i]["loadout"] )
			end
		end
	end
	
	/*for i=1,3 do
		local filename = "darkestdays/loadouts/loadout"..i..".txt"
		if file.Exists (filename,"DATA") then
			local tbl = util.JSONToTable(file.Read(filename,"DATA"))
			if tbl then
				Loadout[i] = table.Copy(tbl)
				for _,v in pairs (Loadout[i]) do
					--if not MySelf:HasUnlocked(v) then
					--	table.remove( Loadout, _ )
					--end
				end
			else
				Loadout[i] = {"dd_mp5","dd_crowbar","electrobolt","firebolt"}
			end
		else
			file.CreateDir("darkestdays/loadouts")
			Loadout[i] = {"dd_mp5","dd_crowbar","electrobolt","firebolt"}
		end
	
	end*/
	
	CreateSelectedLoadout()

	
	moveX,moveY = 25 + topbuttonW + 10,15
	
	CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH,"weps",1,Weapons,1)
	moveX = moveX + topbuttonW + 10
	CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH,"weps",2,Weapons,2)
	moveX = moveX + topbuttonW + 10
	
	CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH,"spells",3,Spells,1)
	moveX = moveX + topbuttonW + 10
	CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH,"spells",4,Spells,2)
	moveX = moveX + topbuttonW + 10
	
	CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH,"perks",5,Perks,1)
	//CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH/3+1,"perks",5,Perks,1)
	//moveY = moveY + topbuttonH/3
	//CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH/3,"perks",6,Perks,2)
	//moveY = moveY + topbuttonH/3
	//CreateLoadoutSlot(LoadoutX+moveX,LoadoutY+moveY,topbuttonW,topbuttonH/3,"perks",7,Perks,3)
	
	moveX,moveY = 15,14+topbuttonH
	
	overlay = vgui.Create("DLabel",LoadoutSelection)
	overlay:SetSize(LoadoutW-30,LoadoutH*0.7)
	overlay:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	overlay:SetText("")
	overlay.Paint = function(self)
		draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
		draw.RoundedBoxEx( 4,15,15, self:GetWide()-30, self:GetTall()-30, COLOR_BACKGROUND_INNER, true, true, true, true )
	end
	
	ItemDesc = vgui.Create("DLabel",overlay)
	ItemDesc:SetSize(overlay:GetWide()/3-30,overlay:GetTall()-60)
	ItemDesc:SetPos(30,30)
	ItemDesc:SetText("")
	//ItemDesc.PaintOver = function(self)

	//end
	ItemDesc.Paint = function(self)
		draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_BACKGROUND_INNER_DARK, false, false, false, false )
		draw.RoundedBoxEx( 8,0,self:GetTall()/3, self:GetWide(), 2*self:GetTall()/3, COLOR_MISC_SELECTED_BRIGHT, false, false, false, false )
		draw.RoundedBoxEx( 8,0,self:GetTall()/3, self:GetWide(), self:GetTall()/9, COLOR_MISC_BACKGROUND2, false, false, false, false )
		
		if SelectedItem then
			draw.SimpleText( SelectedItem or "Random Name!", "Bison_40", self:GetWide()/2, self:GetTall()/3+(self:GetTall()/9)/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		if SelectedIcon then
			local mw,mh = SelectedIcon:Width(),SelectedIcon:Height()			
			local div = 2
			if mw > mh then
				div = 1.05
			end
			local dif = (self:GetWide()/div)/mw
			
			--surface.SetMaterial( logo_bg )
			--surface.SetDrawColor( Color(255, 255, 255, 35) )
			--surface.DrawTexturedRectRotated( self:GetWide()/2,self:GetTall()/3-self:GetTall()/3/2, self:GetWide() * 0.9, self:GetTall()/2.5,0 )
			
			
			surface.SetMaterial( SelectedIcon )
			surface.SetDrawColor( Color(255, 255, 255, 255) )
			surface.DrawTexturedRectRotated( self:GetWide()/2,self:GetTall()/3-self:GetTall()/3/2, math.Clamp(mw*dif,0,self:GetWide()/div), mh*dif,0 )
		else
			if SkillSlot then
				//draw.SimpleText( PlayerSkills.XP.."/"..LocalPlayer():GetRequiredXP(), "Bison_35", self:GetWide()/2, self:GetTall()/3-self:GetTall()/3/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				/*local req = LocalPlayer():GetRequiredXP()//PlayerSkills.Total == SKILL_MAX_TOTAL and PlayerSkills.XP or 
				
				local mul = math.Clamp(PlayerSkills.XP/req,0,1)
				
				draw.RoundedBox( 2,self:GetWide()/2-self:GetWide()*0.8/2,self:GetTall()/3-self:GetTall()/3/2-10, self:GetWide()*0.8, 20, COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
				draw.RoundedBox( 2,self:GetWide()/2-self:GetWide()*0.8/2+1,self:GetTall()/3-self:GetTall()/3/2-10+1, self:GetWide()*0.8-2, 20-2, COLOR_BACKGROUND_INNER )
				
				draw.RoundedBox( 2,self:GetWide()/2-self:GetWide()*0.8/2+2,self:GetTall()/3-self:GetTall()/3/2-10+2, (self:GetWide()*0.8-4)*mul, 20-4, COLOR_MISC_SELECTED_BRIGHT_OUTLINE )
				
				draw.SimpleText( "Experience", "Bison_32", self:GetWide()/2-self:GetWide()*0.8/2, self:GetTall()/3-self:GetTall()/3/2-15, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText( "Lvl "..LocalPlayer():GetLevel(), "Bison_32", self:GetWide()/2+self:GetWide()*0.8/2, self:GetTall()/3-self:GetTall()/3/2-15, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText( PlayerSkills.XP.."/"..req, "Bison_32", self:GetWide()/2+self:GetWide()*0.8/2, self:GetTall()/3-self:GetTall()/3/2+15, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)*/
			end
		end
		
		if SelectedText then
			local moveX,moveY = 0,0
			
			if SelectedText.Caliber and CaliberIcons[SelectedText.Caliber] then
				draw.SimpleText( CaliberIcons[SelectedText.Caliber], "CSD_Scaled_70", self:GetWide()-4, self:GetTall()/3, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
			
			if SelectedText.Stats then
				
				local stW, stH = self:GetWide()-30, 18
				local stX, stY = 15,self:GetTall()/3+self:GetTall()/9+15
				
				for i=1,#SelectedText.Stats do
					
					local cur = SelectedText.Stats[i]
					
					if not cur then continue end
					if cur[2] and cur[2] == 0 then continue end
					
					local max = SelectedText.Melee and MaxMeleeStats or SelectedText.Spell and MaxSpellStats or SelectedText.Ranged and MaxRangedStats or SelectedText.Perk and MaxSpellStats or MaxPlayerStats
					
					local mul = math.Clamp((cur[2] or 0)/(max[i] or cur[2]),0,1)
					
					if cur[4] then
						mul = 1 - mul
					end

					
					draw.RoundedBox( 2,stX, stY+moveY, stW, stH, COLOR_MISC_SELECTED_BRIGHT_OUTLINE )
					draw.RoundedBox( 2,stX+1, stY+1+moveY, stW-2, stH-2, COLOR_MISC_BACKGROUND2 )
					
					draw.SimpleText( string.format(translate.Get( cur[1] ),cur[2]), "Arial_Bold_Scaled_18", self:GetWide()/2, stY+stH/2+moveY, COLOR_MISC_SELECTED_BRIGHT_OUTLINE , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					render.SetStencilWriteMask(0xFF)
					render.SetStencilTestMask(0xFF)
					render.SetStencilCompareFunction(STENCIL_ALWAYS)
					render.SetStencilPassOperation(STENCIL_KEEP)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_KEEP)
					render.ClearStencil()
					
					render.SetStencilEnable( true )
					
					render.SetStencilReferenceValue( 1 )
					render.SetStencilPassOperation( STENCIL_REPLACE )
					
					draw.RoundedBox( 2,stX+2,stY+2+moveY, (stW-4)*mul, stH-4, COLOR_MISC_SELECTED_BRIGHT_OUTLINE )

					render.SetStencilCompareFunction(STENCIL_EQUAL)
					
					draw.SimpleText( string.format(translate.Get( cur[1] ),cur[2]), "Arial_Bold_Scaled_18", self:GetWide()/2, stY+stH/2+moveY, COLOR_BACKGROUND_INNER , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					render.SetStencilEnable( false )

					moveY = moveY + stH + 4
				
				end
				
				
				
				//draw.RoundedBox( 2,self:GetWide()/2-self:GetWide()*0.8/2+2,self:GetTall()/3-self:GetTall()/3/2-10+2, (self:GetWide()*0.8-4)*mul, 20-4, COLOR_MISC_SELECTED_BRIGHT_OUTLINE )
				
			end
			
			if SelectedText.Special then
				local t = translate.Get(SelectedText.Special)
				draw.DrawText( t or "", "Arial_Bold_Scaled_Italic_20", 15, self:GetTall()/3+self:GetTall()/9+15+moveY, Color(15,255,255,255) , TEXT_ALIGN_LEFT, nil)
				surface.SetFont( "Arial_Bold_Scaled_Italic_20" )
				local tX,tY = surface.GetTextSize( t )
				moveY = moveY + tY
			end

			local pr = SelectedText.Pr
			if SelectedText.PrTr then
				pr = translate.Get(SelectedText.PrTr)
				if SelectedText.PrForm then
					pr = translate.Format( SelectedText.PrTr, SelectedText.PrForm() )
				end
			else
				if SelectedText.PrForm then
					pr = string.format( SelectedText.Pr, SelectedText.PrForm() )
				end
			end

			if pr then
				draw.DrawText( pr or "", "Arial_Bold_Scaled_20", 15, self:GetTall()/3+self:GetTall()/9+15+moveY, SelectedText.PrColor or Color(131,204,255,255) , TEXT_ALIGN_LEFT, nil)
				surface.SetFont( "Arial_Bold_Scaled_20" )
				local tX,tY = surface.GetTextSize(pr)
				moveY = moveY + tY
			end

			local co = SelectedText.Co
			if SelectedText.CoTr then
				co = translate.Get(SelectedText.CoTr)
				if SelectedText.CoForm then
					co = translate.Format( SelectedText.CoTr, SelectedText.CoForm() )
				end
			else
				if SelectedText.CoForm then
					co = string.format( SelectedText.Co, SelectedText.CoForm() )
				end
			end

			if co then
				surface.SetFont( "Arial_Bold_Scaled_20" )
				draw.DrawText( co or "", "Arial_Bold_Scaled_20", 15, self:GetTall()/3+self:GetTall()/9+15+moveY, Color(230,80,80,255) , TEXT_ALIGN_LEFT, nil)//230,60,60,255
				local tX,tY = surface.GetTextSize(co)
				moveY = moveY + tY
			end

			local desc = SelectedText.Description
			if desc and desc != "" then
				desc = translate.Get(desc)
				if SelectedText.DescForm then
					desc = translate.Format( SelectedText.Description, SelectedText.DescForm() )
				end
			end

			if desc then
				draw.DrawText( desc or "", "Arial_Bold_Scaled_20", 15, self:GetTall()/3+self:GetTall()/9+15+moveY, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, nil)
			end
		end
		
	end

	overlay2 = vgui.Create("DFrame",LoadoutSelection)
	overlay2:SetSize(LoadoutW-30,LoadoutH*0.7)
	overlay2:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	overlay2:SetDraggable ( false )
	overlay2:SetTitle ("")
	overlay2:ShowCloseButton (false)
	overlay2:SetDraggable ( false )
	overlay2:SetSizable(false)
	overlay2.Paint = function(self)

	end
	
	moveX,moveY = LoadoutW-loadBtnW-15,15+topbuttonH+LoadoutH*0.7+10
	
	local SpawnButton = vgui.Create("DButton",LoadoutSelection)
	SpawnButton:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	SpawnButton:SetSize(loadBtnW,loadBtnH)
	SpawnButton:SetText("")
	SpawnButton.OnCursorEntered = function() 
		SpawnButton.Overed = true 
	end
	SpawnButton.OnCursorExited = function () 
		SpawnButton.Overed = false
	end
	if lobby then
		SpawnButton.DoClick = function()
			if MySelf:Team() ~= TEAM_SPECTATOR then
				SaveLoadouts()
				RunConsoleCommand("lobby_spawn")
				gui.EnableScreenClicker(false)
				InvisiblePanel:Close()
				InLobby = false
				NoDeathHUD = CurTime() + 5
			else
				DrawLobby()
			end
		end
		SpawnButton.Paint = function(self)
			if SpawnButton.Overed then
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get("player_spawn_button"),"Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get("player_spawn_button"),"Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	else
		SpawnButton.DoClick = function()
			if MySelf:Team() ~= TEAM_SPECTATOR then
				SaveLoadouts()
				gui.EnableScreenClicker(false)
				LoadoutSelection:Close()
			end
		end
		SpawnButton.Paint = function(self)
			if SpawnButton.Overed then
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get( "player_loadout_save" ),"Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, true, true )
				draw.SimpleText ( translate.Get( "player_loadout_save" ),"Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	
	moveX = moveX-loadBtnW*1.5-15
	
	local points = vgui.Create("DLabel",LoadoutSelection)
	points:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	points:SetSize(loadBtnW*1.5,loadBtnH)
	points:SetText("")
	points.Paint = function(self)
		local text = translate.Get( "player_loadout_points" )
		text = string.Explode("\n", text)
		draw.SimpleText ( text[1] or "","Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/3, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText ( (text[2] or "")..": "..(GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout ).ToSpend or 0),"Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/3*2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	moveX = moveX-loadBtnW*0.8-15
	
	local skills = vgui.Create("DButton",LoadoutSelection)
	skills:SetPos(LoadoutX+moveX,LoadoutY+moveY)
	skills:SetSize(loadBtnW*0.8,loadBtnH)
	skills:SetText("")
	skills.DoClick = function()
		ResetSkills()
		//RunConsoleCommand("dd_resetskill")
	end
	skills.OnCursorEntered = function() 
		skills.Overed = true 
	end
	skills.OnCursorExited = function () 
		skills.Overed = false
	end
	skills.Paint = function(self)	
		local text = translate.Get( "player_loadout_respec" )
		text = string.Explode("\n", text)
		
		if self.Overed then
			draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
			draw.SimpleText ( text[1] or "","Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/3, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText ( text[2] or "","Arial_Bold_Scaled_34", self:GetWide()/2, 2*self:GetTall()/3, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, true, true )
			draw.SimpleText ( text[1] or "","Arial_Bold_Scaled_34", self:GetWide()/2, self:GetTall()/3, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText ( text[2] or "","Arial_Bold_Scaled_34", self:GetWide()/2, 2*self:GetTall()/3, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	SkillsButton:DoClick()
	
end

function CreateSelectedLoadout()
	
	CachedItems = {}
	
	for i=1,3 do
		CachedItems[i] = {weps={},spells={},perks={}}
		
		for j=1,2 do
			CachedItems[i].weps[j] = "none"
			CachedItems[i].spells[j] = "none"
		end
		
		for k=1,1 do
			CachedItems[i].perks[k] = "none"
		end
		
		local count = 0
		
		for k, v in pairs(Loadout[i]) do
			if Weapons[v] and MySelf:HasUnlocked(v) and not Weapons[v].Melee and not Weapons[v].Secondary then
				count = count + 1
				CachedItems[i].weps[count] = v
				if count >= 1 then
					break
				end
			end
		end
		
		for k, v in pairs(Loadout[i]) do
			if Weapons[v] and MySelf:HasUnlocked(v) and (Weapons[v].Melee or Weapons[v].Secondary) then
				count = count + 1
				CachedItems[i].weps[count] = v
				if count >= 1 then
					break
				end
			end
		end
		
		local count = 0
		for k, v in pairs(Loadout[i]) do
			if Spells[v] and MySelf:HasUnlocked(v) then
				count = count + 1
				CachedItems[i].spells[count] = v
				if count >= 2 then
					break
				end
			end
		end
		
		local count = 0
		for k, v in pairs(Loadout[i]) do
			if Perks[v] and MySelf:HasUnlocked(v) then
				count = count + 1
				CachedItems[i].perks[count] = v
				if count >= 1 then
					break
				end
			end
		end
		
		
	end
	
	
	
	//store in table!
	for i=1,3 do
		local count = 1
		for j=1,2 do
			LoadoutSlotItems[i][j] = CachedItems[i].weps[count]
			count = count + 1
		end
		local count = 1
		for j=3,4 do
			LoadoutSlotItems[i][j] = CachedItems[i].spells[count]
			count = count + 1
		end
		local count = 1
		for j=5,5 do
			LoadoutSlotItems[i][j] = CachedItems[i].perks[count]
			count = count + 1
		end
	end

	//print("Cached Table")
	//PrintTable(CachedItems)
	//print("Global Table")
	//PrintTable(LoadoutSlotItems)
	
	Loadout = {{},{},{}}
	
end


function CreateLoadoutSlot(x,y,ww,hh,class,num,tbl,classind)

	LoadoutSlot[num] = vgui.Create("DButton",LoadoutSelection)
	LoadoutSlot[num]:SetText("")
	LoadoutSlot[num]:SetSize (ww, hh) 
	LoadoutSlot[num]:SetPos (x, y)
	
	if class == "none" then
		LoadoutSlotItems[SelectedLoadout][num] = class
	else
		LoadoutSlotItems[SelectedLoadout][num] = CachedItems[SelectedLoadout][class][classind]
	end
		
		
		LoadoutSlot[num].OnCursorEntered = function() 
			LoadoutSlot[num].Overed = true			
		end
		LoadoutSlot[num].OnCursorExited = function () 
			LoadoutSlot[num].Overed = false
		end
		LoadoutSlot[num].OnMousePressed = function () 
			SkillsButton.Active = false
			RemoveSkillsMenu()
			for i=1, 5 do
				if i == num then

					if not MenuSlot[num] then
						LoadoutSlot[num].Active = true 
						DrawContextMenu(overlay:GetWide()/3+15,30,2*overlay:GetWide()/3-30-15,overlay:GetTall()-60,num,tbl)
					else
						LoadoutSlot[i].Active = false
					
						MenuSlot[i]:Remove()
						MenuSlot[i] = nil
						
						SelectedIcon = nil
						SelectedItem = nil
						SelectedText = nil
					end
				else
					LoadoutSlot[i].Active = false
					if MenuSlot[i] then
						MenuSlot[i]:Remove()
						MenuSlot[i] = nil
					end
					
					SelectedIcon = nil
					SelectedItem = nil
					SelectedText = nil
				end
			end
		end
		
		LoadoutSlot[num].Paint = function(self)

			local col = COLOR_TEXT_SOFT_BRIGHT
			if LoadoutSlot[num].Overed or LoadoutSlot[num].Active then
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, num<6, num<6, false, false )
				col = COLOR_TEXT_SOFT_BRIGHT
			else
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, num<6, num<6, false, false )
				col = COLOR_BACKGROUND_DARK
			end
			
			if LoadoutSlotItems[SelectedLoadout][num] == "none" then
				draw.SimpleText( translate.Get("player_loadout_noitem "), "Arial_Bold_18", ww/2, hh/2, col , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				return
			else
				local mat = false
				local item = LoadoutSlotItems[SelectedLoadout][num]
				if tbl[item] and tbl[item].Mat then
					
					local mw,mh = tbl[item].Mat:Width(),tbl[item].Mat:Height()
					local div = 1.05
					if num == 3 or num == 4 or num == 5 then// or num == 2
						div = 2
					end
					local dif = (self:GetWide()/div)/mw
					
					surface.SetMaterial( tbl[item].Mat )
					surface.SetDrawColor( col )//Color(255, 255, 255, 255)
					surface.DrawTexturedRectRotated( self:GetWide()/2,self:GetTall()/2.5, math.Clamp(mw*dif,0,self:GetWide()/div), mh*dif,0 );
					mat = true
				end
				draw.SimpleText ( tbl[LoadoutSlotItems[SelectedLoadout][num]] and tbl[LoadoutSlotItems[SelectedLoadout][num]].Name and translate.Get( tbl[LoadoutSlotItems[SelectedLoadout][num]].Name ) or "ERROR!", "Arial_Bold_16", ww/2, mat and 4*hh/5 or hh/2, col , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

end

local SkillIcons = {
	["defense"] = {Mat = Material( "darkestdays/hud/shield.png" ), Name = "Defense"}, //unused
	["magic"] = {Mat = Material( "darkestdays/hud/magic.png" ), Name = "player_skill_magic"},
	["strength"] = {Mat = Material( "darkestdays/hud/swords.png" ), Name = "player_skill_strength"},
	["agility"] = {Mat = Material( "darkestdays/hud/scope.png" ), Name = "player_skill_gun"},
	}

function CreateSkillsMenu(x,y,ww,hh)
	
	RemoveSkillsMenu()
	
	SkillSlot = vgui.Create( "DScrollPanel", overlay2 )
	SkillSlot:SetPos( x,y )
	SkillSlot:SetSize(ww,hh)
	SkillSlot:SetText("")
	SkillSlot.Paint = function(self)
		//draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
	end
	SkillSlot.Panel = {}
	
	for skillname,stuff in pairs(Skills) do
		SkillSlot.Panel[skillname] = vgui.Create( "DScrollPanel" )//SkillSlot:Add( "DLabel" )
		SkillSlot.Panel[skillname]:SetSize( ww, hh/4.3 )
		SkillSlot.Panel[skillname]:Dock( TOP )
		SkillSlot.Panel[skillname]:DockMargin( 0, 0, 0, 10 )
		SkillSlot.Panel[skillname]:SetText("")
		SkillSlot.Panel[skillname].Paint = function(self)
			draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
			//draw.RoundedBoxEx( 4,self:GetTall()+10,0, self:GetWide()-self:GetTall()-10, self:GetTall(), COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
		end
		
		local CurPanel = SkillSlot.Panel[skillname]
		
		CurPanel.Icon = CurPanel:Add( "DLabel" )
		CurPanel.Icon:SetSize(CurPanel:GetTall(),CurPanel:GetTall())
		CurPanel.Icon:Dock( LEFT )
		CurPanel.Icon:SetText("")
		CurPanel.Icon:DockMargin( 0, 0, 10, 0 )
		CurPanel.Icon.Paint = function(self,sw,sh)
			draw.RoundedBoxEx( 4,1,1, self:GetWide()-2, self:GetTall()-2, COLOR_MISC_SELECTED_BRIGHT_OUTLINE, true, true, true, true )
			draw.RoundedBoxEx( 4,3,3, self:GetWide()-6, self:GetTall()-6, COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
			surface.SetMaterial( SkillIcons[skillname].Mat );
			surface.SetDrawColor( Color(255, 255, 255, 255) );
			surface.DrawTexturedRectRotated( sw/2,sh/2,sw-2,sh-2,0 );
		end
		
		CurPanel:AddItem(CurPanel.Icon)
		
		CurPanel.Name = CurPanel:Add( "DLabel" )
		CurPanel.Name:SetSize(CurPanel:GetWide()-CurPanel:GetTall()-10,2*CurPanel:GetTall()/5)//
		CurPanel.Name:Dock( TOP )
		//CurPanel.Icon:DockMargin( 0, 0, 0, 0 )
		CurPanel.Name:SetText("")
		CurPanel.Name.Paint = function(self,sw,sh)
			draw.SimpleText(translate.Get(SkillIcons[skillname].Name) , "Bison_32", 0, sh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
			local p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )[skillname] or 0
			
			for _, v in pairs( Skills[skillname] ) do
				if Abilities[v] and Abilities[v].PassiveDesc and p >= _ then
					draw.SimpleText( Abilities[v].PassiveDesc( p ), "Bison_Scaled_35", sw-10, sh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)//Abilities[v].PassiveDesc( p )
					break
				end
			end
			
		end
		
		CurPanel:AddItem(CurPanel.Name)
		
		CurPanel.Bars = CurPanel:Add( "DPanel" )
		CurPanel.Bars:SetSize(CurPanel:GetWide()-CurPanel:GetTall()-10,3*CurPanel:GetTall()/5)
		CurPanel.Bars:Dock( BOTTOM )
		
		CurPanel.Bars:SetText("")
		CurPanel.Bars.Paint = function(self,sw,sh)
			//draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), Color(100, 100,100, 255), true, true, true, true )
		end
		
		CurPanel.Bars.Bar = {}
		
		local avwide = (CurPanel.Bars:GetWide()-(SKILL_MAX_PER_TREE-1)*2)/SKILL_MAX_PER_TREE
		
		local Bar = CurPanel.Bars.Bar
		for i=1, SKILL_MAX_PER_TREE do
			local ab = Skills[skillname] and Skills[skillname][i]
			Bar[i] = CurPanel.Bars:Add( "DButton" )
			Bar[i]:SetSize(avwide,ab and CurPanel.Bars:GetTall() or avwide)
			Bar[i]:SetText("")
			Bar[i]:Dock( LEFT )
			Bar[i]:DockMargin( 0, ab and 2 or (CurPanel.Bars:GetTall()-avwide)/2, 2, ab and 2 or (CurPanel.Bars:GetTall()-avwide)/2 )
			Bar[i].OnMousePressed = function(self, enum) 
				if enum == MOUSE_LEFT then
					InvestInSkill( skillname )
					//RunConsoleCommand("dd_investskill",tostring(skillname))
				elseif enum == MOUSE_RIGHT then
					RemoveFromSkill( skillname )
					//RunConsoleCommand("dd_removeskill",tostring(skillname))
				end
				if not ab then
					SelectedText = GetPlayerText()
				end
			end
			Bar[i].OnCursorEntered = function() 
				Bar[i].Overed = true	
				if ab then
					SelectedIcon = nil
					SelectedItem = Abilities[ab] and Abilities[ab].Name and translate.Get(Abilities[ab].Name) or ""
					SelectedText = Abilities[ab] or nil
				end
			end
			Bar[i].OnCursorExited = function () 
				Bar[i].Overed = false
				SelectedIcon = nil
				SelectedItem = MySelf:Nick()
				SelectedText = GetPlayerText()//nil
			end
			Bar[i].Paint = function(self,sw,sh)
				local p = GetPlayerSkills( SelectedLoadout ) and GetPlayerSkills( SelectedLoadout )[skillname] or 0
				
				if self.Overed then//ab or
					draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT_OUTLINE, true, true, true, true )
					draw.RoundedBoxEx( 4,1,1, self:GetWide()-2, self:GetTall()-2, COLOR_BACKGROUND_INNER, true, true, true, true )
				else
					
					local highlight = false
					
					for _, v in pairs( Skills[skillname] ) do
						if Abilities[v] and Abilities[v].PassiveDesc and _ == i then
							highlight = true
							break
						end
					end
					
					if highlight then
						draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
						draw.RoundedBoxEx( 4,1,1, self:GetWide()-2, self:GetTall()-2, COLOR_BACKGROUND_INNER, true, true, true, true )
					else
						draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_BACKGROUND_INNER, true, true, true, true )
					end
					
					

				end
				
				if p >= i then
					draw.RoundedBoxEx( 4,2,2, self:GetWide()-4, self:GetTall()-4, COLOR_MISC_SELECTED_BRIGHT_OUTLINE, true, true, true, true )
				end
				
			end
			//Bar[i]:InvalidateLayout()
			//CurPanel.Bars:AddItem(Bar[i])
		end
		CurPanel:AddItem(CurPanel.Bars)
		
		SkillSlot:AddItem(CurPanel)
	end
	
	SkillSlot.Panel["builds"] = vgui.Create( "DScrollPanel" )
	SkillSlot.Panel["builds"]:SetSize( ww, hh/4.3 )
	SkillSlot.Panel["builds"]:Dock( TOP )
	SkillSlot.Panel["builds"]:DockMargin( 0, 0, 0, 10 )
	SkillSlot.Panel["builds"]:SetText("")
	SkillSlot.Panel["builds"].Paint = function(self)
		//draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
	end
	
	local CurPanel = SkillSlot.Panel["builds"]
	
	CurPanel.Builds = {}
	
	local Bar = CurPanel.Builds
	
	for name, stuff in pairs(Builds) do
		Bar[name] = CurPanel:Add( "DButton" )
		Bar[name]:SetSize(ww/4-1.5,hh/4.3)
		Bar[name]:SetText("")
		Bar[name]:Dock( LEFT )
		Bar[name]:DockMargin( 0, 0, 2, 0 )
		
		Bar[name].OnMousePressed = function(self, enum)
			//RunConsoleCommand("_dd_selectedbuild", tostring(name))
			SelectedBuild = name
			if Stats and Stats[ "player_stuff" ] and Stats[ "player_stuff" ][ SelectedLoadout ] and Stats[ "player_stuff" ][SelectedLoadout]["build"] then
				Stats[ "player_stuff" ][SelectedLoadout]["build"] = name
			end
			SelectedText = GetPlayerText()
		end
		
		Bar[name].OnCursorEntered = function(self) 
			self.Overed = true
		end
		
		Bar[name].OnCursorExited = function(self) 
			self.Overed = false
		end
		
		Bar[name].Paint = function(self)
			if self.Overed or SelectedBuild == name then
				draw.RoundedBox( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT_OUTLINE)
				draw.RoundedBox( 4,2,2, self:GetWide()-4, self:GetTall()-4, COLOR_MISC_SELECTED_BRIGHT)
			else
				draw.RoundedBox( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT)
			end
			
			draw.SimpleText(translate.Get(stuff.Name) or name , "Bison_30", self:GetWide()/2, self:GetTall()/4, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			local moveY = 0
			
			if stuff.Pr then
				draw.DrawText( translate.Get(stuff.Pr) or "", "Arial_Bold_Scaled_21", self:GetWide()/2, self:GetTall()/2+moveY, Color(131,204,255,255) , TEXT_ALIGN_CENTER, nil)
				local tX,tY = surface.GetTextSize(stuff.Pr)
				moveY = moveY + tY
			end
			if stuff.Co then
				draw.DrawText( translate.Get(stuff.Co) or "", "Arial_Bold_Scaled_21", self:GetWide()/2, self:GetTall()/2+moveY, Color(230,80,80,255) , TEXT_ALIGN_CENTER, nil)
				local tX,tY = surface.GetTextSize(stuff.Co)
				moveY = moveY + tY
			end
			
		end
	end
	
	SkillSlot:AddItem(CurPanel)
	
end

function RemoveSkillsMenu()
	if SkillSlot then
		SkillSlot:Remove()
		SkillSlot = nil
	end
end

function DrawContextMenu(x,y,ww,hh,num,tbl)

		MenuSlot[num] = vgui.Create( "DPanelList", overlay2 )
		MenuSlot[num]:SetPos( x,y )
		MenuSlot[num]:SetSize(ww,hh)
		MenuSlot[num]:SetSpacing(10)
		MenuSlot[num]:SetPadding(0)
		MenuSlot[num]:EnableHorizontal( true )
		MenuSlot[num]:EnableVerticalScrollbar( true )
		MenuSlot[num].Paint = function ()
			
		end
		
		local ItemLabel = {}
		
		for item,tab in pairs(tbl) do
			
			if !MySelf:HasUnlocked(item) and not tab.Level then continue end
			if num == 1 and (tab.Melee or tab.Secondary) then continue end
			if num == 2 and not (tab.Melee or tab.Secondary) then continue end
			
			local lock = !MySelf:HasUnlocked(item) and tab.Level
			
			ItemLabel[item] = vgui.Create("DLabel")
			ItemLabel[item]:SetText("")
			ItemLabel[item]:SetSize(ww/2.15,hh/5.5) //ww/2.15,hh/4.3
			ItemLabel[item].OnCursorEntered = function() 
				ItemLabel[item].Overed = true 
					//ItemDesc.PaintOver = function()
						//draw.DrawText( tab.Description, "Arial_Bold_25", 0, 0/*ItemDesc:GetTall()/2*/, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, nil)
					//end
					if tab.Mat then
						SelectedIcon = tab.Mat
					end
					if tab.Name then
						SelectedItem = tab.Name
						if string.find( tab.Name, "weapon_" ) or string.find( tab.Name, "spell_" ) or string.find( tab.Name, "perk_" ) then
							SelectedItem = translate.Get( tab.Name )
						end
					end
					//if tab.Description then
						SelectedText = tab//tab.Description
					//end
			end
			ItemLabel[item].OnCursorExited = function () 
				ItemLabel[item].Overed = false
					//ItemDesc.PaintOver = function()
						
					//end
					SelectedIcon = nil
					SelectedItem = nil
					SelectedText = nil
			end
								
			ItemLabel[item].OnMousePressed = function () 
				if LoadoutSlot[num] then
					if lock then return end
					for i=1,5 do
						/*if LoadoutSlot[i].Item == item and i~=num then
							LoadoutSlot[i].Item = LoadoutSlot[num].Item
						end*/
						if LoadoutSlotItems[SelectedLoadout][i] == item and i~=num then
							LoadoutSlotItems[SelectedLoadout][i] = LoadoutSlotItems[SelectedLoadout][num]
						end
					end
					
					LoadoutSlotItems[SelectedLoadout][num] = item
					--LoadoutSlot[j][num].Item = item
					//MenuSlot[num]:Remove()
					//MenuSlot[num] = nil
				end
			end
								
			ItemLabel[item].Paint = function(self)
				if ItemLabel[item].Overed then
					draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT_OUTLINE, true, true, true, true )
					draw.RoundedBoxEx( 4,2,2, self:GetWide()-4, self:GetTall()-4, lock and COLOR_MISC_BACKGROUND2 or COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
				else
					draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), lock and COLOR_MISC_BACKGROUND2 or COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
				end
				
				local pos = ItemLabel[item]:GetTall()/2
				
				if tbl[item] and tbl[item].Mat then
					
					local mw,mh = tbl[item].Mat:Width(),tbl[item].Mat:Height()
					--local max = math.max( mw, mh )
					--local ratio = mw / mh
					
					local div = 1.5//1.4
					if num == 3 or num == 4 or num == 5 then
						div = 3//2.5
					end
					local dif = (ItemLabel[item]:GetWide()/div)/mw
					
					surface.SetMaterial( tbl[item].Mat );
					surface.SetDrawColor( lock and COLOR_BACKGROUND_DARK or Color(255, 255, 255, 255) );
					surface.DrawTexturedRectRotated( ItemLabel[item]:GetWide()/4,ItemLabel[item]:GetTall()/2, math.Clamp(mw*dif,0,ItemLabel[item]:GetWide()/div), mh*dif,0 );
					
					pos = ItemLabel[item]:GetTall()/2
					
				end
				
				
				
				if item == "none" then
					surface.SetDrawColor( 255, 255, 255, 255) 
					draw.SimpleText( translate.Get("player_loadout_noitem"), "WeaponNames", ItemLabel[item]:GetWide()/1.5, pos, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					return
				else
					draw.SimpleText( tbl[item] and tbl[item].Name and translate.Get(tbl[item].Name) or "ERROR!", "Bison_32",ItemLabel[item]:GetWide()/1.5, pos, lock and COLOR_BACKGROUND_DARK or COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					if lock then
						draw.SimpleText( tbl[item] and tbl[item].Level or "ERROR!", "Bison_55",ItemLabel[item]:GetWide()/4, pos, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText( tbl[item] and tbl[item].Level or "ERROR!", "Bison_50",ItemLabel[item]:GetWide()/4, pos, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
			
			MenuSlot[num]:AddItem(ItemLabel[item])	
		end

end

function SaveLoadouts()
	
	if Stats and Stats[ "player_stuff" ] then
	
		for j=1,3 do
			if LoadoutSlotItems[j] then
				for i=1,5 do
					if LoadoutSlotItems[j][i] and LoadoutSlotItems[j][i] ~= "none" then
						table.insert(Loadout[j],LoadoutSlotItems[j][i])
					end
				end
			end
			if Stats[ "player_stuff" ][j] and Stats[ "player_stuff" ][j]["loadout"] then
				Stats[ "player_stuff" ][j]["loadout"] = table.Copy( Loadout[j] )
			end
		end
	end
	
	SaveStats()
	
	/*for j=1,3 do
	
		local filename = "darkestdays/loadouts/loadout"..j..".txt"
		
		if LoadoutSlotItems[j] then
			for i=1,5 do
				if LoadoutSlotItems[j][i] and LoadoutSlotItems[j][i] ~= "none" then
					table.insert(Loadout[j],LoadoutSlotItems[j][i])
				end
			end
		end
		
		local tbl = util.TableToJSON(Loadout[j])
		file.Write(filename,tbl)
	end*/
	
	local skill_points = {}
	skill_points[1] = GetPlayerSkills( SelectedLoadout )["strength"]
	skill_points[2] = GetPlayerSkills( SelectedLoadout )["magic"]
	skill_points[3] = GetPlayerSkills( SelectedLoadout )["agility"]
	
	if Stats and Stats[ "player_stuff" ] and Stats[ "player_stuff" ][ SelectedLoadout ] and Stats[ "player_stuff" ][SelectedLoadout]["build"] then
		SelectedBuild = Stats[ "player_stuff" ][SelectedLoadout]["build"]
	end
	
	//use selected loadout
	RunConsoleCommand ("_applyloadout",unpack( Loadout[SelectedLoadout]) )
	RunConsoleCommand ("_applyskills",unpack( skill_points ) )
	RunConsoleCommand("_dd_selectedbuild", tostring( SelectedBuild ))
end

function ApplyLoadout(num)
	
	Loadout = {{},{},{}}
	
	for j=1,3 do
		if LoadoutSlotItems[j] then
			for i=1,5 do
				if LoadoutSlotItems[j][i] and LoadoutSlotItems[j][i] ~= "none" then
					table.insert(Loadout[j],LoadoutSlotItems[j][i])
				end
			end
		end
	end
	
	local skill_points = {}
	skill_points[1] = GetPlayerSkills( num )["strength"]
	skill_points[2] = GetPlayerSkills( num )["magic"]
	skill_points[3] = GetPlayerSkills( num )["agility"]
	
	if Stats and Stats[ "player_stuff" ] and Stats[ "player_stuff" ][ SelectedLoadout ] and Stats[ "player_stuff" ][SelectedLoadout]["build"] then
		SelectedBuild = Stats[ "player_stuff" ][SelectedLoadout]["build"]
	end
	
	//use selected loadout
	RunConsoleCommand ("_applyloadout",unpack( Loadout[num]) )
	RunConsoleCommand ("_applyskills",unpack( skill_points ) )
	RunConsoleCommand("_dd_selectedbuild", tostring( SelectedBuild ))
end

//And why not to make a small panel to choose loadout

function LoadoutMenu()
	
	if GAMEMODE:GetGametype() == "ts" and MySelf:Team() == TEAM_THUG then return end
	
	local w,h = ScrW(),ScrH()
	
	local tW,tH = w/2.2,h/1.9//w/2.7,h/1.9
	
	if LoadoutSwitcher then
		LoadoutSwitcher:Remove()
		LoadoutSwitcher = nil
	end
	
	LoadoutSwitcher = vgui.Create("DFrame")
	LoadoutSwitcher:SetSize(tW,tH)
	LoadoutSwitcher:SetPos(w/2-tW/2,h/3)
	//LoadoutSwitcher:Center()
	LoadoutSwitcher:SetDraggable ( false )
	LoadoutSwitcher:SetTitle("")
	LoadoutSwitcher:ShowCloseButton (false)
	LoadoutSwitcher.Paint = function() end
	
	LoadoutSwitcher.Think = function ()
		gui.EnableScreenClicker(true)
		if MySelf:Alive() then
			gui.EnableScreenClicker(false)
			if LoadoutSwitcher then
				LoadoutSwitcher:Remove()//Close()
				LoadoutSwitcher = nil
			end
		end
	end
	
	local LoadoutEdit = vgui.Create("DButton",LoadoutSwitcher)
	LoadoutEdit:SetSize(LoadoutSwitcher:GetWide(),LoadoutSwitcher:GetTall()/7)
	LoadoutEdit:SetText("")
	LoadoutEdit:Dock( BOTTOM )
	LoadoutEdit:DockMargin(0,135,0,0)
	LoadoutEdit.DoClick = function() 
		LoadoutSwitcher:Close()
		CreateLoadoutMenu()
	end
	LoadoutEdit.OnCursorEntered = function(self) 
		self.Overed = true 
	end
	LoadoutEdit.OnCursorExited = function(self) 
		self.Overed = false
	end
	LoadoutEdit.Paint = function(self,fw,fh)
		draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		
		local text = translate.Get("player_loadout_edit")
		
		if self.Overed then
			draw.RoundedBox( 4,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT )
			draw.SimpleText ( text,"Arial_Bold_28", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox( 4,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT)
			draw.SimpleText ( text,"Arial_Bold_28", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	LoadoutPreview = vgui.Create("DPanel",LoadoutSwitcher)
	LoadoutPreview:Dock( BOTTOM )
	LoadoutPreview:DockMargin(0,2,0,0)
	LoadoutPreview:SetSize(LoadoutSwitcher:GetWide(),LoadoutSwitcher:GetTall()/5)
	LoadoutPreview.Paint = function(self,fw,fh)
		draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	
	
	LoadoutPreview.Item = {}
	
	for i=1,5 do
		LoadoutPreview.Item[i] = vgui.Create("DLabel",LoadoutPreview)
		LoadoutPreview.Item[i]:SetSize(LoadoutPreview:GetWide()/5-4,LoadoutPreview:GetTall()-2)
		LoadoutPreview.Item[i]:Dock( LEFT )
		LoadoutPreview.Item[i]:SetText("")
		LoadoutPreview.Item[i]:DockMargin(2,2,0,2)
		LoadoutPreview.Item[i].Paint = function(self,fw,fh)
			draw.RoundedBox( 4,0,0, fw, fh, COLOR_SELECTED_BRIGHT)
		end
	end
		
	
	for i=1,3 do
		local LoadoutButton = vgui.Create("DButton",LoadoutSwitcher)
		LoadoutButton:Dock( LEFT )//i == 1 and LEFT or i == 2 and BOTTOM or RIGHT
		//LoadoutButton:DockMargin(0,0,0,LoadoutSwitcher:GetTall()/2.2)
		LoadoutButton:SetSize(LoadoutSwitcher:GetWide()/3-3,LoadoutSwitcher:GetTall()/1.8)
		LoadoutButton:SetText("")
		LoadoutButton.DoClick = function() 
			SelectedLoadout = i //make sure to select proper loadout in case if we go to menu
			ApplyLoadout(i)
			gui.EnableScreenClicker(false)
			LoadoutSwitcher:Close()
		end
		LoadoutButton.OnCursorEntered = function() 
			LoadoutButton.Overed = true 
			for j=1,5 do
				local tbl = (j == 1 or j == 2) and Weapons or (j == 3 or j == 4 ) and Spells or Perks
				LoadoutPreview.Item[j].Paint = function(self,fw,fh)
					draw.RoundedBox( 4,0,0, fw, fh, COLOR_SELECTED_BRIGHT)
					local mat = false
					local item = LoadoutSlotItems[i][j]
					if tbl[item] and tbl[item].Mat then
						
						local mw,mh = tbl[item].Mat:Width(),tbl[item].Mat:Height()
						local div = 1.05
						if j == 3 or j == 4 or j == 5 then
							div = 2
						end
						local dif = (self:GetWide()/div)/mw
						
						surface.SetMaterial( tbl[item].Mat )
						surface.SetDrawColor( color_white )
						surface.DrawTexturedRectRotated( self:GetWide()/2,self:GetTall()/2.5, math.Clamp(mw*dif,0,self:GetWide()/div), mh*dif,0 );
						mat = true
					end
					draw.SimpleText ( tbl[item] and tbl[item].Name and translate.Get(tbl[item].Name) or translate.Get("player_loadout_empty"),"Arial_Bold_18", fw/2, mat and fh*4/5 or fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
		LoadoutButton.OnCursorExited = function () 
			LoadoutButton.Overed = false
			for j=1,5 do
				LoadoutPreview.Item[j].Paint = function(self,fw,fh)
					draw.RoundedBox( 4,0,0, fw, fh, COLOR_SELECTED_BRIGHT)
				end
			end
		end
		LoadoutButton.Paint = function(self,fw,fh)
			draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
			local text = translate.Get("player_loadout")
			if self.Overed then
				draw.RoundedBox( 4,2,2, fw-4, fh-4, COLOR_SELECTED_BRIGHT )
				draw.SimpleText ( text.." "..i,"Arial_Bold_34", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox( 4,2,2, fw-4, fh-4, COLOR_DESELECTED_BRIGHT)
				draw.SimpleText ( text.." "..i,"Arial_Bold_34", fw/2, fh/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

