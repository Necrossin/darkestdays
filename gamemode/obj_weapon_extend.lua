local meta = FindMetaTable("Weapon")
if not meta then return end

function meta:SetNextReload(fTime)
	self.m_NextReload = fTime
end

function meta:GetNextReload()
	return self.m_NextReload or 0
end

local CrossHairScale = 1
if CLIENT then

local hittime = 0
local next_hitsound = 0

local custom_hitsound = file.Exists( "sound/dd_hitsound.wav", "GAME" )

net.Receive("Hitmarker",function( len ) 
	
	hittime = CurTime() + 0.4
	
	local hs_bit = net.ReadBit()
	local hs = hs_bit == 1

	if DD_HITSOUNDS and next_hitsound < CurTime() then
		next_hitsound = CurTime() + 0.1
		if custom_hitsound then
			//surface.PlaySound( "dd_hitsound.wav" )
			MySelf:EmitSound( "dd_hitsound.wav", 100, hs and 80 or 100 )
		else
			MySelf:EmitSound( "physics/gore/flesh_impact_bullet"..math.random( 5 )..".wav", 100, hs and 80 or 100 )
			//surface.PlaySound( "physics/gore/flesh_impact_bullet"..math.random( 5 )..".wav" )
		end
	end

end)

local matLine = Material("VGUI/gradient-r")
local matCircle = Material("sgm/playercircle")
function meta:DrawCrosshair()
	//self:DrawCrosshairCross()
	//self:DrawCrosshairDot()
	if ENDROUND then return end
	if not DD_HUD then return end
	local owner = self.Owner

	if !IsValid(owner) then return end
	if owner:IsCrow() then return end
	
	local text = " {  } "
	
	local sp = owner:GetCurrentSpell()
	
	if IsValid(sp) then
		if sp.CanCast and sp:CanCast() then
			text = " [  ] "
		end
	end
	
	local x,y = ScrW()/2 ,ScrH()/2
	
	if GAMEMODE.ThirdPerson then
		local pos = owner:GetEyeTrace().HitPos:ToScreen()
		x,y = pos.x,pos.y
	end
	
	local r,g,b = DD_CROSSHAIR_R or 255,DD_CROSSHAIR_G or 255,DD_CROSSHAIR_B or 255
	local a = DD_CROSSHAIR_A or 100
	
	surface.SetDrawColor( Color( r, g, b, a) )
	
	//hitmarker
	if hittime and hittime >= CurTime() then
		local length = 6
		//length = 6//math.sqrt(length)
		local gap = 5
		
		surface.DrawLine(x-gap-length,y-gap-length,x-gap,y-gap)
		surface.DrawLine(x-gap-length,y+gap+length,x-gap,y+gap)
		surface.DrawLine(x+gap+length,y-gap-length,x+gap,y-gap)
		surface.DrawLine(x+gap+length,y+gap+length,x+gap,y+gap)
	end
	
	local crs_length = DD_CROSSHAIR_LENGTH or 12
	local crs_thickness = DD_CROSSHAIR_THICKNESS or 2
	local crs_gap = DD_CROSSHAIR_GAP or 6
	
	local melee_size = DD_CROSSHAIR_MELEE or 7
	
	surface.SetDrawColor( Color( r, g, b, self.IsMelee and a or a / 2 ) )
	
	if self.IsMelee then 
		
		surface.SetMaterial( matCircle )
		surface.DrawTexturedRectRotated( x, y, melee_size, melee_size, 0 )
		
		return 
	end
	
	surface.SetMaterial( matLine )

	surface.DrawTexturedRectRotated( x + crs_gap / 2 + crs_length/2, y, crs_length, crs_thickness, 0 )
	surface.DrawTexturedRectRotated( x + crs_gap / 2 + crs_length/2, y, crs_length, crs_thickness, 180 )
	
	surface.DrawTexturedRectRotated( x, y + crs_gap / 2 + crs_length/2, crs_length, crs_thickness, 270 )
	surface.DrawTexturedRectRotated( x, y + crs_gap / 2 + crs_length/2, crs_length, crs_thickness, 90 )
	
	surface.DrawTexturedRectRotated( x - crs_gap / 2 - crs_length/2, y, crs_length, crs_thickness, 180 )
	surface.DrawTexturedRectRotated( x - crs_gap / 2 - crs_length/2, y, crs_length, crs_thickness, 0 )
	
	surface.DrawTexturedRectRotated( x, y - crs_gap / 2 - crs_length/2, crs_length, crs_thickness, 90 )
	surface.DrawTexturedRectRotated( x, y - crs_gap / 2 - crs_length/2, crs_length, crs_thickness, 270 )
	
	
	/*draw.SimpleText(text,"HL2_90",x,y-10,Color(r,g,b,a),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	if self.IsMelee then return end
	draw.SimpleText("Q","HL2_50",x-.5,y-.5,Color(r,g,b,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)*/
	
end

local mat_block_bar = Material( "darkestdays/hud/bullet.png" )
local matBlock = Material( "darkestdays/hud/hud_neutral.png", "smooth" )
function meta:DrawBulletBlock( offset, alpha_mul )
	
	local off = offset or 0
	local a_mul = alpha_mul or 1
	
	local owner = self.Owner
	
	local w, h = ScrW(), ScrH()
	local x, y = w/2, h/2
	
	local r,g,b = DD_CROSSHAIR_R or 255,DD_CROSSHAIR_G or 255,DD_CROSSHAIR_B or 255
	local a = DD_CROSSHAIR_A or 100
	
	surface.SetMaterial( matBlock )	
	surface.SetDrawColor( Color( r, g, b, a * a_mul ) )
	
	//surface.DrawTexturedRectRotated( x, y, 50, 50, -90 )
	
	local bar_size = 50
	
	local max_block = math.max( 1, owner:GetMaxBulletBlockPower() )
	local cur_block = owner:GetBulletBlockPower() or 0
	
	local delta_block = math.Clamp( cur_block / max_block, 0, 1 )
	
	render.SetScissorRect( x-3-bar_size-off, y-bar_size, x-3-off, y + bar_size, true )
	surface.DrawTexturedRectRotated( x-off, y, bar_size, bar_size, 180 + 180 - 180 * delta_block )
	render.SetScissorRect( x-3-bar_size-off, y-bar_size, x-3-off, y + bar_size, false )
	
	render.SetScissorRect( x+3+off, y-bar_size, x+3+bar_size+off, y + bar_size, true )
	surface.DrawTexturedRectRotated( x+off, y, bar_size, bar_size, -1 * ( 180 - 180 * delta_block ) )
	render.SetScissorRect( x+3+off, y-bar_size, x+3+bar_size+off, y + bar_size, false )
	
	//surface.DrawTexturedRectRotated( x, y, bar_size, bar_size, 180 )
	
	
	/*local realW, realH = 93, 225
	local realBarW, realBarH = 46, 160
	
	local szW, szH = 50, 180
	
	local scaleW, scaleH = szW / realW, szH / realH -- headache prevention
	
	local barW, barH = realBarW * scaleW, realBarH * scaleH
	local x, y = w - 100 - szH/2, h - 50 - szW / 2 //w/2, h * 0.6
	
	surface.SetMaterial( mat_block_bar )	
	surface.SetDrawColor( Color( 255, 255, 255, 105 ) )
	
	surface.DrawTexturedRectRotated( x, y, szW, szH, 90 )
	
	surface.SetDrawColor( Color( 255, 255, 255, 155 ) )
	surface.DrawRect( x - barH / 2 - 16 * scaleH, y - barW / 2, barH, barW )*/
	
end

end




function meta:DrawCrosshairCross()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	local owner = self.Owner

	local cone
	if 25 < self.Owner:GetVelocity():Length() then
		cone = self.Primary.ConeMoving
	else
		if self.Owner:Crouching() then
			cone = self.Primary.ConeCrouching
		else
			cone = self.Primary.Cone
		end
	end
	
	if not cone then return end

	if cone <= 0 then return end

	cone = ScrH() / 76.8 * cone

	CrossHairScale = math.Approach(CrossHairScale, cone, FrameTime() * 5 + math.abs(CrossHairScale - cone) * 0.02)

	local scalebyheight = (h / 768) * 0.2

	local midarea = 40 * CrossHairScale
	local length = scalebyheight * 24 + midarea / 4

	surface.SetDrawColor(Color(255,255,255,255))
	surface.DrawRect(x - midarea - length, y - 1.5, length, 3)
	surface.DrawRect(x + midarea, y - 1.5, length, 3)
	surface.DrawRect(x - 1.5, y - midarea - length, 3, length)
	surface.DrawRect(x - 1.5, y + midarea, 3, length)

	surface.SetDrawColor(0, 0, 0, 110)
	surface.DrawOutlinedRect(x - midarea - length, y - 1.5, length, 3)
	surface.DrawOutlinedRect(x + midarea, y - 1.5, length, 3)
	surface.DrawOutlinedRect(x - 1.5, y - midarea - length, 3, length)
	surface.DrawOutlinedRect(x - 1.5, y + midarea, 3, length)
end

function meta:DrawCrosshairDot()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	surface.SetDrawColor(Color(255,0,0,155))
	surface.DrawRect(x - 2, y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 160)
	surface.DrawOutlinedRect(x - 2, y - 2, 4, 4)
end