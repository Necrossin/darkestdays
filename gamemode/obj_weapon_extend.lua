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
	
	
	if DD_HITSOUNDS and next_hitsound < CurTime() then
		next_hitsound = CurTime() + 0.1
		if custom_hitsound then
			surface.PlaySound( "dd_hitsound.wav" )
		else
			surface.PlaySound( "physics/gore/flesh_impact_bullet"..math.random( 5 )..".wav" )
		end
	end

end)

function meta:DrawCrosshair()
	//self:DrawCrosshairCross()
	//self:DrawCrosshairDot()
	if ENDROUND then return end
	if not DD_HUD then return end
	local owner = self.Owner

	if !ValidEntity(owner) then return end
	if owner:IsCrow() then return end
	
	local text = " {  } "
	
	local sp = owner:GetCurrentSpell()
	
	if ValidEntity(sp) then
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
	
	//hitmarker
	if hittime and hittime >= CurTime() then
		surface.SetDrawColor(Color(r,g,b,a))
		
		local length = 36
		length = math.sqrt(length)
		local gap = 5
		
		surface.DrawLine(x-gap-length,y-gap-length,x-gap,y-gap)
		surface.DrawLine(x-gap-length,y+gap+length,x-gap,y+gap)
		surface.DrawLine(x+gap+length,y-gap-length,x+gap,y-gap)
		surface.DrawLine(x+gap+length,y+gap+length,x+gap,y+gap)
	end
	
	draw.SimpleText(text,"HL2_90",x,y-10,Color(r,g,b,a),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	/*//stuff for some perks
	if owner._ShiftUses then
		
		local text = " [   ] "
		
		draw.SimpleText(text,"HL2_100",x,y-12,Color(r,g,b,a),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
	end*/
	
	if self.IsMelee then return end
	draw.SimpleText("Q","HL2_50",x-.5,y-.5,Color(r,g,b,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
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