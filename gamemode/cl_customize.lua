
local grad = surface.GetTextureID( "gui/center_gradient" )
PreviewModels = {}
ClientEquipment = {}
CMenuSlot = {}
CMenuContext = {}
CreateClientConVar("_dd_previewrotation", 35, true, false)


DD_TELEPORT_MARKER = util.tobool( CreateClientConVar("_dd_teleportmarker", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_teleportmarker", function(cvar, oldvalue, newvalue)
	DD_TELEPORT_MARKER = util.tobool( newvalue )
end)

DD_DRAWSUITS = util.tobool( CreateClientConVar("_dd_drawsuits", 1, true, false):GetInt() )
cvars.AddChangeCallback("_dd_drawsuits", function(cvar, oldvalue, newvalue)
	DD_DRAWSUITS = util.tobool( newvalue )
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





local render = render
local draw = draw
local gui = gui
local vgui = vgui
local surface = surface
local table = table
local pairs = pairs
local ClientsideModel = ClientsideModel
local util = util
local file = file


function CustomizationMenu()
	if !ENABLE_OUTFITS then return end
	local w,h = ScrW(),ScrH()
	
	local CMw,CMh = math.max(w/2.1, 500),h*0.7
	
	if CMMenu then
		CMMenu:Remove()
		CMMenu = nil
	end
	
	CMMenu = vgui.Create("DFrame")
	CMMenu:SetSize(CMw,CMh)
	//CMMenu:SetPos(0,0)
	CMMenu:Center()
	CMMenu:SetDraggable ( false )
	CMMenu:SetTitle("")
	CMMenu:ShowCloseButton (false)
	CMMenu.Paint = function(self,fw,fh) 
		
		draw.RoundedBox( 8,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 8,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
		
		draw.SimpleText( "Outfit", "Bison_40", self:GetWide()/2, 30, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	CMMenu.Think = function ()
		gui.EnableScreenClicker(true)
	end
	
	
	CreatePlayerModel()
	CreateEquipmentMenu()
	UpdateModelPanel()
end

RenderOrder = nil

local function GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		
		if (tab.rel and tab.rel != "") then
		
			local v = basetab[tab.rel]
			
			if (!v) then return end
			

			pos, ang = GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
		end
		
		return pos, ang
end

function DrawModels(self)
	
	if (!self.Equipment) then return end
		
		if (!RenderOrder) then

			RenderOrder = {}

			for k, v in pairs( self.Equipment ) do
				if (v.type == "Model") then
					table.insert(RenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(RenderOrder, k)
				end
			end

		end
		
		if (ValidEntity(self.Entity)) then
			bone_ent = self.Entity
		end
		
		for k, name in pairs( RenderOrder ) do
		
			local v = self.Equipment[name]
			if (!v) then RenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = GetBoneOrientation( self.Equipment, v, bone_ent )
			else
				pos, ang = GetBoneOrientation( self.Equipment, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then
				
				if v.seq then
					model:FrameAdvance( (RealTime()-(model.LastPaint or 0)) * 1 )	
				end
				
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local size = (v.size.x+v.size.y+v.size.z)/3
				
				if model.UseNewScaling then
					model:SetModelScaleOld(v.size)
				else
					model:SetModelScale(size,0)
				end
				
				
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				local skin = v.skin
				if ValidEntity(MySelf) then
					skin = MySelf:Team() == TEAM_BLUE and v.skin+1 or v.skin
				end
				
				//if (v.skin and v.skin != model:GetSkin()) then
				if skin and skin ~= model:GetSkin() then
					model:SetSkin(skin)
				end
				//end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
				//	render.SuppressEngineLighting(true)
				end
				

				model:DrawModel()

				
				if (v.surpresslightning) then
				//	render.SuppressEngineLighting(false)
				end
				
				if v.seq then
					model.LastPaint = RealTime()
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			end
			
		end
	
end

function CreateModels(self)
	RenderOrder = nil
	
	self.Equipment = self.Equipment or {}

	for k, v in pairs( self.Equipment ) do
		if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
	end
	self.Equipment = nil  
	
	local temp = {}
	local temp2 = {}
	local counter = 1
	
	for i=1,4 do
		if CMenuSlot[i] and CMenuSlot[i].Item then
			local item = CMenuSlot[i].Item
			local tbl = tempEquipment[CMenuSlot[i].Item]
			if tbl then
				local tblitems = tbl.props
				if tblitems then
					for _,minitable in pairs(tblitems) do
						local t = table.Copy(minitable)
						if minitable.rel and minitable.rel ~= "" then
								t.rel = item.."_"..minitable.rel
						end
						temp[item.."_".._] = t
					end
				end
			end
		end
	end
	
	self.Equipment = table.Copy(temp) or {}
	
	for k, v in pairs( self.Equipment ) do
			if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
			
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self.Entity:GetPos())
					v.modelEnt:SetAngles(self.Entity:GetAngles())
					v.modelEnt:SetParent(self.Entity)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
					v.modelEnt.SuitProp = true
					v.modelEnt:SetLegacyTransform( true )
					if v.Str then
						v.modelEnt.UseNewScaling = true
					end
					if v.seq then
						v.modelEnt:SetSequence(v.modelEnt:LookupSequence( v.seq ))
						v.modelEnt.LastPaint = 0
					end
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
	
	
	
end

local anims = { 
"walk_all", "pose_standing_01", "pose_standing_02"
 }

function CreatePlayerModel()
	
	local w,h = ScrW(),ScrH()
	//local MySelf = LocalPlayer()
	
	ModelPanel = vgui.Create( "DModelPanel", CMMenu )
	ModelPanel:SetSize(CMMenu:GetTall(),CMMenu:GetTall())
	ModelPanel:SetPos(3*CMMenu:GetWide()/4-ModelPanel:GetWide()/2,0)
	ModelPanel.Angles = Angle( 0, 35, 0 )
	
	ModelPanel.Seq = anims[ math.random( 1, #anims ) ]
	
	ModelPanel.SetModel = function( self, strModelName, seq )

		if ( IsValid( self.Entity ) ) then
				self.Entity:Remove()
				self.Entity = nil              
		end

		if ( !ClientsideModel ) then return end
	 
		self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
		if ( !IsValid(self.Entity) ) then return end
	 
		self.Entity:SetNoDraw( true )
		
		CreateModels(self)
	 
		local iSeq = MySelf:GetSequence() or 0
		if seq then
			iSeq = self.Entity:LookupSequence( seq )
		end
		if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( seq ) end
	 
		if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
		
	end
	--Paint
	ModelPanel.Paint = function(self)
		
		if ( !IsValid( self.Entity ) ) then return end
	
		local x, y = self:LocalToScreen( 0, 0 )
		
		self:LayoutEntity( self.Entity )
		
		cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetSize() )
		cam.IgnoreZ( true )
		
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a/255 )
		
		for i=0, 6 do
			local col = self.DirectionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end
			
		self.Entity:DrawModel()
		
		DrawModels(self)
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
		cam.End3D()
		
		self.LastPaint = RealTime()
	
	end
	
	ModelPanel:SetFOV( 65 )
	ModelPanel:SetAnimSpeed( -0.5 )
	local mdl = MySelf:GetModel()
	ModelPanel:SetModel(mdl)
	//ModelPanel.LayoutEntity = function(self,Entity)
		//Entity:SetAngles( Angle( 0, GetConVarNumber("_dd_previewrotation") or 35, 0) )
	//end
	
	function ModelPanel:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function ModelPanel:DragMouseRelease() self.Pressed = false end

	function ModelPanel:LayoutEntity( Entity )
		if ( self.Pressed ) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
			
			self.PressX, self.PressY = gui.MousePos()
		end

		Entity:SetAngles( self.Angles )
	end
	
	
	/*local slider_lab = vgui.Create("DPanel",ModelPanel)
	slider_lab:SetSize(CMMenu:GetWide()/4,40)
	slider_lab:Dock( BOTTOM )
	slider_lab:DockMargin( ModelPanel:GetWide()/4, 0,ModelPanel:GetWide()/4, 15 )
	slider_lab.Paint = function(self,fw,fh)
		draw.RoundedBox( 4,0,0, fw, fh, COLOR_DESELECTED_BRIGHT)
	end
	
	local slider = vgui.Create("DNumSlider",slider_lab)
	slider:Dock( FILL )
	slider:DockMargin( 5,5,5,5 )
	slider:SetDecimals(0)
	slider:SetMinMax(-180, 180)
	slider:SetConVar("_dd_previewrotation")
	slider:SetText("Rotate preview")
	slider:SizeToContents()*/
	
end

function UpdateModelPanel()
	local mdl = MySelf:GetDTString(0) or MySelf:GetModel()
	ModelPanel:SetModel(mdl,ModelPanel.Seq or "walk_all")
	local col = team.GetColor(MySelf:Team())
	ModelPanel.Entity.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
end

function CreateEquipmentMenu()
	
	local filename = "darkestdays/loadouts/equipment.txt"
		if file.Exists (filename,"DATA") then
			local tbl = util.JSONToTable(file.Read(filename,"DATA"))
			if tbl then
				ClientEquipment = table.Copy(tbl)
				for _,v in pairs (ClientEquipment) do
					--if not MySelf:HasUnlocked(v) then
					--	table.remove( Loadout, _ )  just a note for unlockable stuff
					--end
				end
			else
				ClientEquipment = {}
			end
		else
			ClientEquipment = {}
		end
	
	local w,h = ScrW(),ScrH()
	//local MySelf = LocalPlayer()
	
	local stuff = {"none","none","none","none"}
	
	local count = 1
	
	for k, v in pairs(ClientEquipment) do
		if Equipment[v] and Equipment[v].slot and Equipment[v].slot == "hat" then
			stuff[1] = v
			break
		end
	end
	
	for k, v in pairs(ClientEquipment) do
		if Equipment[v] and Equipment[v].slot and Equipment[v].slot == "misc" then
			count = count + 1
			stuff[count] = v
			if count >= 4 then
				break
			end
		end
	end
	
	ClientEquipment = {}
	
	local x,y = 15,15+45//w/3.3,h*0.25
	
	local step = 0
	
	local btn_w,btn_h = CMMenu:GetWide()/4.7,CMMenu:GetTall()/7
	
	CreateCMenuSlot(x,y+step,btn_w,btn_h,stuff[1],1,"hat")
	step = step+30+btn_h
	CreateCMenuSlot(x,y+step,btn_w,btn_h,stuff[2],2,"misc")
	step = step+15+btn_h
	CreateCMenuSlot(x,y+step,btn_w,btn_h,stuff[3],3,"misc")
	step = step+15+btn_h
	CreateCMenuSlot(x,y+step,btn_w,btn_h,stuff[4],4,"misc")
	step = step+ScaleH(70)+ScaleH(100)
	
	local close = vgui.Create("DButton",CMMenu)
	close:SetText("")
	close:SetSize (btn_w,btn_h) 
	close:SetPos (15, CMMenu:GetTall()-15-btn_h)
	
	close.OnCursorEntered = function() 
		close.Overed = true
	end
			
	close.OnCursorExited = function () 
		close.Overed = false
	end
	close.DoClick = function ()
		SaveEquipment()
		gui.EnableScreenClicker(false)
		CMMenu:Close()
	end
	
	close.Paint = function(self)
		
			
		if self.Overed then
			draw.RoundedBox( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT )
			draw.SimpleText ( "SAVE & CLOSE","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else

			draw.RoundedBox( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT )
			draw.SimpleText ( "SAVE & CLOSE","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
	end
	

end

function CreateCMenuSlot(x,y,ww,hh,class,num,slot)

	CMenuSlot[num] = vgui.Create("DButton",CMMenu)
	CMenuSlot[num]:SetText("")
	CMenuSlot[num]:SetSize (ww, hh) 
	CMenuSlot[num]:SetPos (x, y)
	
	
	CMenuSlot[num].Item = class

		
		
		CMenuSlot[num].OnCursorEntered = function() 
			CMenuSlot[num].Overed = true 

			for i=1, 4 do
				if i == num then
					CMenuSlot[num].Active = true 
					
					if not CMenuContext[num] then
						DrawCMenuContext(15+ww+15,15+45,ww*1.7,hh*4+30+15*2,num,slot)
					else
						CMenuContext[i]:Remove()
						CMenuContext[i] = nil
					end
				else
					CMenuSlot[i].Active = false
					if CMenuContext[i] then
						CMenuContext[i]:Remove()
						CMenuContext[i] = nil
					end
				end
			end
			
			
		end
		CMenuSlot[num].OnCursorExited = function () 
			CMenuSlot[num].Overed = false
		end
		CMenuSlot[num].OnMousePressed = function ()
			CMenuSlot[num].Item = "none"
			UpdateModelPanel()
		end
		
		CMenuSlot[num].Paint = function(self,fw,fh)
			if self.Overed or self.Active then
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_SELECTED_BRIGHT, true, true, true, true )
				
				if self.Item == "none" then
					draw.SimpleText ( "NO ITEM","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText ( Equipment[CMenuSlot[num].Item] and Equipment[CMenuSlot[num].Item].name or "ERROR!","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

			else
				draw.RoundedBoxEx( 8,0,0, self:GetWide(), self:GetTall(), COLOR_DESELECTED_BRIGHT, true, true, true, true )
				
				if self.Item == "none" then
					draw.SimpleText ( "NO ITEM","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText ( Equipment[CMenuSlot[num].Item] and Equipment[CMenuSlot[num].Item].name or "ERROR!","Arial_Bold_Scaled_23", self:GetWide()/2, self:GetTall()/2, COLOR_BACKGROUND_DARK , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
			
		end

end

function DrawCMenuContext(x,y,ww,hh,num,slot)

		CMenuContext[num] = vgui.Create( "DPanelList", CMMenu )
		CMenuContext[num]:SetPos( x,y )
		CMenuContext[num]:SetSize(ww,hh)
		CMenuContext[num]:SetSpacing( 1 )
		CMenuContext[num]:SetPadding(0)
		CMenuContext[num]:EnableHorizontal( true )
		CMenuContext[num]:EnableVerticalScrollbar( true )
		CMenuContext[num].Paint = function ()

			
		end
		
		local ItemLabel = {}
		
		for item,tab in pairs(Equipment) do
			if tab.slot == slot then
		
				ItemLabel[item] = vgui.Create("DLabel")
				ItemLabel[item]:SetText("")
				ItemLabel[item]:SetSize(ww/2,hh/11) 
				ItemLabel[item].OnCursorEntered = function() 
					ItemLabel[item].Overed = true 
				end
				ItemLabel[item].OnCursorExited = function () 
					ItemLabel[item].Overed = false
				end
									
				ItemLabel[item].OnMousePressed = function () 
					if CMenuSlot[num] then
						
						for i=1,4 do
							if CMenuSlot[i].Item == item and i~=num then
								CMenuSlot[i].Item = CMenuSlot[num].Item
							end
						end
						
						CMenuSlot[num].Item = item
						UpdateModelPanel()
						--LoadoutSlot[j][num].Item = item
						CMenuContext[num]:Remove()
						CMenuContext[num] = nil
					end
				end
				
				ItemLabel[item].Paint = function(self,fw,fh)
					if ItemLabel[item].Overed then
						draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT_OUTLINE, true, true, true, true )
						draw.RoundedBoxEx( 4,2,2, self:GetWide()-4, self:GetTall()-4, COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
					else
						draw.RoundedBoxEx( 4,0,0, self:GetWide(), self:GetTall(), COLOR_MISC_SELECTED_BRIGHT, true, true, true, true )
					end
						
					if item == "none" then
						surface.SetDrawColor( 255, 255, 255, 255) 
						draw.SimpleText( "NO ITEM", "Arial_Bold_Scaled_18", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						return
					else
						draw.SimpleText( Equipment[item] and Equipment[item].name or "ERROR!", "Arial_Bold_Scaled_18",self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
				
				
				
				
				CMenuContext[num]:AddItem(ItemLabel[item])	
			end
		end

end

function SaveEquipment()
	
	
		local filename = "darkestdays/loadouts/equipment.txt"
		
		if CMenuSlot then
			for i=1,4 do
				if CMenuSlot[i] and CMenuSlot[i].Item ~= "none" then
					table.insert(ClientEquipment,CMenuSlot[i].Item)
				end
			end
		end
		
		local tbl = util.TableToJSON(ClientEquipment)
		file.Write(filename,tbl)
	
	RunConsoleCommand ("_applyequipment",unpack( ClientEquipment ) )
	
end

function CheckEquipment()

	local filename = "darkestdays/loadouts/equipment.txt"
		if file.Exists (filename,"DATA") then
			local tbl = util.JSONToTable(file.Read(filename,"DATA"))
			if tbl then
				ClientEquipment = table.Copy(tbl)
				for _,v in pairs (ClientEquipment) do
					--if not MySelf:HasUnlocked(v) then
					--	table.remove( Loadout, _ )
					--end
				end
			else
				ClientEquipment = {}
			end
		else
			ClientEquipment = {}
		end
	
	local stuff = {"none","none","none","none"}
	
	local count = 1
	
	for k, v in pairs(ClientEquipment) do
		if Equipment[v] and Equipment[v].slot and Equipment[v].slot == "hat" then
			stuff[1] = v
			break
		end
	end
	
	for k, v in pairs(ClientEquipment) do
		if Equipment[v] and Equipment[v].slot and Equipment[v].slot == "misc" then
			count = count + 1
			stuff[count] = v
			if count >= 4 then
				break
			end
		end
	end
	
	ClientEquipment = {}
	
	for i=1,4 do
		if stuff[i] and stuff[i] ~= "none" then
			table.insert(ClientEquipment,stuff[i])
		end
	end
	
	RunConsoleCommand ("_applyequipment",unpack(ClientEquipment))
end

//Options!------------------------------------------------------------------
local matLine = Material("VGUI/gradient-r")
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
		draw.SimpleText( "Options", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	OpList = vgui.Create( "DScrollPanel", OpMenu )
	OpList:Dock( FILL )
	OpList.Paint = function(self,fw,fh)
		draw.RoundedBox( 6,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
		draw.RoundedBox( 6,1,1, fw-2,fh-2, COLOR_BACKGROUND_DARK)
	end
	
	
	local RadioLabel = vgui.Create("DPanel",OpList)
	RadioLabel:SetText("")
	RadioLabel:SetTall(40)
	RadioLabel:Dock( TOP )
	RadioLabel:DockMargin( 0,2,0,0 )
	RadioLabel.Paint = function()
		draw.SimpleText("In-game music", "Arial_Bold_25", 15,RadioLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local RadioButton = vgui.Create("DButton",RadioLabel)
	RadioButton:SetText("")
	RadioButton.Text = util.tobool(GetConVarNumber("_dd_enableradio")) and "TURN OFF" or "TURN ON"
	RadioButton:SetSize(110,23)
	RadioButton:Dock( RIGHT )
	RadioButton:DockMargin( 2,2,5,2 )

	RadioButton.DoClick = function()
		if util.tobool(GetConVarNumber("_dd_enableradio")) then
			RunConsoleCommand("dd_enableradio","0")
			RadioButton.Text = "TURN ON"
		else
			RunConsoleCommand("dd_enableradio","1")
			RadioButton.Text = "TURN OFF"
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
		draw.SimpleText( self.Text or "", "Arial_Bold_16", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	
	local VoiceLabel = vgui.Create("DPanel",OpList)
	VoiceLabel:SetText("")
	VoiceLabel:SetTall(40)
	VoiceLabel:Dock( TOP )
	VoiceLabel:DockMargin( 0,2,0,0 )
	VoiceLabel.Paint = function()
		draw.SimpleText("Voice Commands", "Arial_Bold_25", 15,VoiceLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
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
		draw.SimpleText("Throw Grenade", "Arial_Bold_25", 15,GrenadeLabel:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
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
		draw.SimpleTextOutlined("Crosshair preview","Arial_Bold_13",CrosshairPr:GetWide()/2,13,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		//draw.SimpleText(" {  } ","HL2_80",CrosshairPr:GetWide()/2,CrosshairPr:GetTall()/4,CrosshairMix:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		//draw.SimpleText(" [  ] ","HL2_80",CrosshairPr:GetWide()/2,3*CrosshairPr:GetTall()/4,CrosshairMix:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		local r,g,b = DD_CROSSHAIR_R or 255,DD_CROSSHAIR_G or 255,DD_CROSSHAIR_B or 255
		local a = DD_CROSSHAIR_A or 100
		
		local crs_length = DD_CROSSHAIR_LENGTH or 12
		local crs_thickness = DD_CROSSHAIR_THICKNESS or 2
		local crs_gap = DD_CROSSHAIR_GAP or 6
		
		local x = CrosshairPr:GetWide()/2
		local y = CrosshairPr:GetTall()/2
	
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
		
	end
	
	
	CrosshairMix:Dock ( FILL )
	CrosshairPanel:DockMargin( 5,0,0,0 )
	
	local sliderLength = vgui.Create("DNumSlider",OpList)
	sliderLength:Dock( TOP )
	sliderLength:DockMargin( 5,2,5,0 )
	sliderLength:SetDecimals(0)
	sliderLength:SetMinMax(1, 30)
	sliderLength:SetConVar("_dd_crosshairL")
	sliderLength:SetText("Crosshair line length")
	sliderLength:SizeToContents()
	
	local sliderThickness = vgui.Create("DNumSlider",OpList)
	sliderThickness:Dock( TOP )
	sliderThickness:DockMargin( 5,2,5,0 )
	sliderThickness:SetDecimals(0)
	sliderThickness:SetMinMax(2, 10)
	sliderThickness:SetConVar("_dd_crosshairT")
	sliderThickness:SetText("Crosshair line thickness")
	sliderThickness:SizeToContents()
	
	local sliderGap = vgui.Create("DNumSlider",OpList)
	sliderGap:Dock( TOP )
	sliderGap:DockMargin( 5,2,5,0 )
	sliderGap:SetDecimals(0)
	sliderGap:SetMinMax(0, 30)
	sliderGap:SetConVar("_dd_crosshairGap")
	sliderGap:SetText("Crosshair gap size")
	sliderGap:SizeToContents()
	
	/*local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Draw hats and outfits" )
	c:SetConVar( "_dd_drawsuits" )
	c:SetValue( GetConVarNumber("_dd_drawsuits") )
	c:SizeToContents()*/
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Disable bullet impact particles (More FPS)" )
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
	tp:SetText( "Enable Teleportation marker" )
	tp:SetConVar( "_dd_teleportmarker" )
	tp:SetValue( GetConVarNumber("_dd_teleportmarker") )
	tp:SizeToContents()
	
	local hud = vgui.Create( "DCheckBoxLabel",OpList )
	hud:Dock( TOP )
	hud:DockMargin( 5,2,5,0 )
	hud:SetText( "Enable HUD" )
	hud:SetConVar( "_dd_hud" )
	hud:SetValue( GetConVarNumber("_dd_hud") )
	hud:SizeToContents()
	
	
	local nhud = vgui.Create( "DCheckBoxLabel",OpList )
	nhud:Dock( TOP )
	nhud:DockMargin( 5,2,5,0 )
	nhud:SetText( "Numeric health and mana" )
	nhud:SetConVar( "_dd_numerichud" )
	nhud:SetValue( GetConVarNumber("_dd_numerichud") )
	nhud:SizeToContents()
	

	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( "Free spectator mode on death" )
	sp:SetConVar( "_dd_spectatemode" )
	sp:SetValue( GetConVarNumber("_dd_spectatemode") )
	sp:SizeToContents()
	
	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( "Disable first person death view" )
	sp:SetConVar( "_dd_thirdpersondeath" )
	sp:SetValue( GetConVarNumber("_dd_thirdpersondeath") )
	sp:SizeToContents()
	
	local sp = vgui.Create( "DCheckBoxLabel",OpList )
	sp:Dock( TOP )
	sp:DockMargin( 5,2,5,0 )
	sp:SetText( "Draw spell effects on hand in first person" )
	sp:SetConVar( "_dd_drawhandspells" )
	sp:SetValue( GetConVarNumber("_dd_drawhandspells") )
	sp:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable body awareness instead of thirdperson" )
	c:SetConVar( "_dd_fullbody" )
	c:SetValue( GetConVarNumber("_dd_fullbody") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable blood stains on viewmodels" )
	c:SetConVar( "_dd_bloodymodels" )
	c:SetValue( GetConVarNumber("_dd_bloodymodels") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable ledge grabbing with spacebar" )
	c:SetConVar( "_dd_spacebargrab" )
	c:SetValue( GetConVarNumber("_dd_spacebargrab") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable teammate indication circles" )
	c:SetConVar( "_dd_friendlycircle" )
	c:SetValue( GetConVarNumber("_dd_friendlycircle") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable immersive view for sliding" )
	c:SetConVar( "_dd_immersiveslide" )
	c:SetValue( GetConVarNumber("_dd_immersiveslide") )
	c:SizeToContents()
	
	local c = vgui.Create( "DCheckBoxLabel",OpList )
	c:Dock( TOP )
	c:DockMargin( 5,2,5,0 )
	c:SetText( "Enable hitmarker sounds" )
	c:SetConVar( "_dd_hitsounds" )
	c:SetToolTip( "Use 'sound/dd_hitsound.wav' file for custom sound" )
	c:SetValue( GetConVarNumber("_dd_hitsounds") )
	c:SizeToContents()
	
	local vm_slider = vgui.Create("DNumSlider",OpList)
	vm_slider:Dock( TOP )
	vm_slider:DockMargin( 5,2,5,0 )
	vm_slider:SetDecimals(1)
	vm_slider:SetMinMax(-10, 0)
	vm_slider:SetConVar("_dd_viewmodelZ")
	vm_slider:SetText("Viewmodel Z pos")
	vm_slider:SizeToContents()
	
	local sliderX = vgui.Create("DNumSlider",OpList)
	sliderX:Dock( TOP )
	sliderX:DockMargin( 5,2,5,0 )
	sliderX:SetDecimals(0)
	sliderX:SetMinMax(10, 80)
	sliderX:SetConVar("_dd_thirdpersonX")
	sliderX:SetText("Thirdperson X pos")
	sliderX:SizeToContents()
	
	local sliderY = vgui.Create("DNumSlider",OpList)
	sliderY:Dock( TOP )
	sliderY:DockMargin( 5,2,5,0 )
	sliderY:SetDecimals(0)
	sliderY:SetMinMax(-70, 70)
	sliderY:SetConVar("_dd_thirdpersonY")
	sliderY:SetText("Thirdperson Y pos")
	sliderY:SizeToContents()
	
	local sliderZ = vgui.Create("DNumSlider",OpList)
	sliderZ:Dock( TOP )
	sliderZ:DockMargin( 5,2,5,0 )
	sliderZ:SetDecimals(0)
	sliderZ:SetMinMax(-30, 30)
	sliderZ:SetConVar("_dd_thirdpersonZ")
	sliderZ:SetText("Thirdperson Z pos")
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
		draw.SimpleText( "Player info: "..(MySelf:Nick() or "error"), "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		draw.SimpleText( "Achievements", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	for key,stuff in pairs(Achievements) do
		local Lab = vgui.Create("DLabel", AchList)
		Lab:SetText("")
		Lab:Dock ( TOP )
		Lab:SetTall((AchList:GetTall())/4)
		Lab:SetZPos(CachedAchievements and CachedAchievements[key] == true and -100 or 100)
		Lab.Paint = function(self,fw,fh)
			local unl = CachedAchievements and CachedAchievements[key] == true

			draw.RoundedBox( 4,0,0, fw, fh, COLOR_BACKGROUND_OUTLINE)
			draw.RoundedBox( 4,1,1, fw-2,fh-2, COLOR_BACKGROUND_INNER)
			draw.SimpleText(stuff.Name, "Bison_30", 5,fh/4, unl and Color(50,215,50,255)  or Color(255,70,70,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(stuff.Description, "Arial_Bold_Scaled_20", 5,3*fh/4, COLOR_TEXT_SOFT_BRIGHT, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
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
		draw.SimpleText( "Help", "Bison_40", fw/2, fh/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
			draw.SimpleText( HelpPage[i].ButtonName, "Arial_Bold_20", self:GetWide()/2, self:GetTall()/2, COLOR_TEXT_SOFT_BRIGHT , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but[i].DoClick = function()
			if HContent then
				//HContent:SetFont("Arial_Bold_18")
				HContent:SetText(HelpPage[i].Text)
				HContent.Page = i
				//HContent:SizeToContents()
				//surface.SetFont("Arial_Bold_18")
				//local tw,th = surface.GetTextSize(HelpPage[i].Text)
				//HContent:SetTall(th)
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
	HContent:SetText(HelpPage[1].Text)//
	HContent.Page = 1
	//HContent:SizeToContents()
	//HContent:Dock( FILL )
	HContent:SetDrawBackground( false )
	HContent.Think = function(self)
		surface.SetFont("Arial_Bold_18")
		local tw,th = surface.GetTextSize(HelpPage[self.Page].Text)
		self:SetTall(th*1.4)
		self:SetWide(HContentPanel:GetWide()-20)
	end	
	
end
