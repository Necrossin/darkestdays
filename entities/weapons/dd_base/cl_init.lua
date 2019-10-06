include("shared.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false//true
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = true
SWEP.BobScale = 2
SWEP.SwayScale = 1.5
SWEP.ShowViewModel = true

SWEP.UseHands = true

SWEP.SelectFont = "CSSelectIcons"
SWEP.IconLetter = "p"

surface.CreateFont("CSKillIcons",{font="csd",size= ScreenScale(30),weight= 500,additive= true,antialias= true} )
surface.CreateFont("CSSelectIcons",{font="csd",size= ScreenScale(60),weight= 500,additive= true,antialias= true})

SWEP.IronsightsMultiplier = 0.6

CreateClientConVar("_dd_clhands", 0, true, false)


//function SWEP:TranslateFOV(fov)
//	return GAMEMODE.FOVLerp * fov
//end

function SWEP:AdjustMouseSensitivity()
	if self.Owner and self.Owner._efSlide then return 0.55 end
end

local math = math
local CurTime = CurTime
local FrameTime = FrameTime
local Vector, Angle = Vector, Angle
local render = render
local pairs = pairs
local ipairs = ipairs
local LerpVector = LerpVector
local LerpAngle = LerpAngle

local vec_zero = Vector( 0, 0, 0 )
local ang_zero = Angle( 0, 0, 0 )


function SWEP:DrawHUD()
	self:DrawCrosshair()	
end

function SWEP:GetIronsightsDeltaMultiplier()
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
end

local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	
	--if IsFirstTimePredicted() then
		lerp = math.Approach(lerp, ((self.Owner:IsSprinting() or self.Owner:IsWallrunning() ) and not self.IgnoreSprint and not self.Owner:IsSliding() and 1) or 0, RealFrameTime()*1*((lerp + 1) ^ 2.5))
	--end
	
	if self.SprintPos and self.SprintAng then
		local rot = self.SprintAng
		local offset = self.SprintPos
			
		ang = Angle(ang.pitch, ang.yaw, ang.roll)
			
		ang:RotateAroundAxis(ang:Right(), rot.pitch * lerp)
		ang:RotateAroundAxis(ang:Up(), rot.yaw * lerp)
		ang:RotateAroundAxis(ang:Forward(), rot.roll * lerp)
			
		pos = pos + offset.x * lerp * ang:Right() + offset.y * lerp * ang:Forward() + offset.z * lerp * ang:Up()
	else
		ang:RotateAroundAxis(ang:Right(), (self.IsPistol and 1.5 or -1) * 12 * lerp)
	end
	
	//pos = pos + ang:Up()*0.5 + ang:Right()*(self.ViewModelFlip and 0.7 or -0.7)
	
	local plang = MySelf:EyeAngles()
	
	if self.ViewmodelOffset then
		pos = pos + self.ViewmodelOffset.x * plang:Right() + self.ViewmodelOffset.y * plang:Forward() + self.ViewmodelOffset.z * plang:Up()
	end
	
	pos = pos + ( DD_VIEWMODEL_Z or 0 ) * plang:Up()
	
	return pos, ang
end 

local function CosineInterpolation(y1, y2, mu)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

function SWEP:CalculateHandMovement()

	local bonemods = self.ViewModelBoneMods
	local sorted = self.ViewModelBoneModsSorted
	local default = self.DefaultViewModelBoneMods
	local action = self.ActionMods


	if bonemods and sorted then
			
		local check = false//self:IsReloading() or (self:IsShooting() and !self.OneHandAnim) or self.Owner:IsSprinting() //self:IsDeploying() or 

		for i = 1, #sorted do
		
			local bone = sorted[ i ]
			if not bonemods[bone] then continue end
			
			local offset = vec_zero
			local rot = ang_zero
			
			local defoffset = offset
			local defrot = rot
			
			if default and default[bone] then
				defoffset = default[bone].pos
				defrot = default[bone].angle
			end

			if self.SpellCastingTime and self.SpellCastingTime > 0 and action[bone] then//self:IsCasting()
				if check then
					rot = defrot
					offset = defoffset
				else
					offset = action[bone].pos
					rot = action[bone].angle
				end
			else
				rot = defrot
				offset = defoffset
			end
			
			if bonemods[bone].angle ~= rot then
				bonemods[bone].angle = LerpAngle( 0.1, bonemods[bone].angle, rot )
			end
			if bonemods[bone].pos ~= offset then
				bonemods[bone].pos = LerpVector( 0.1, bonemods[bone].pos, offset )
			end	
		end
	end
					
end

function SWEP:CosineInterpolation(mu,y1,y2)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

function SWEP:LerpVec(delta,from, to)
	
	--from.x = self:CosineInterpolation( delta, from.x, to.x )
	--from.y = self:CosineInterpolation( delta, from.y, to.y )
	--from.z = self:CosineInterpolation( delta, from.z, to.z )
	
	return from
end

function SWEP:LerpAng(delta,from, to)
		
	--from.p = self:CosineInterpolation( delta, from.p, to.p )
	--from.y = self:CosineInterpolation( delta, from.y, to.y )
	--from.r = self:CosineInterpolation( delta, from.r, to.r )
	
	return from
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
end

function SWEP:HUDShouldDraw(element)
	return element ~= "CHudSecondaryAmmo"
end 

local blood_mat = Material( "models/flesh" )

function SWEP:AddBlood()
	self.Bloody = self.Bloody or 0
	if self.Bloody > 5 then return end
		
	self.Bloody = self.Bloody + 1
	self.BloodScale = self.BloodScale or math.Rand( 1.1, 7 )
end

local vec_norm = Vector(1, 1, 1)
local vec_zero = Vector(0, 0, 0)
local ang_zero = Angle(0, 0, 0)

local col_255_1 = Color(255,255,255,1)
local col_255_180 = Color(255,255,255,180)
local col_255_255 = Color(255,255,255,255)

SWEP.vRenderOrder = nil
function SWEP:ViewModelDrawn()
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		
		local vm = self.Owner:GetViewModel()
		if !ValidEntity(vm) then return end
		
		
		if not self.OldViewModelFlip then
			self.OldViewModelFlip = self.ViewModelFlip or false
		end
		
		if self.Owner:IsCrow() then 
			vm:SetColor( col_255_1 ) 
			vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
			return 
		end
		
			
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			if self.Owner:IsGhosting() then
				vm:SetColor(col_255_180)
			else
				vm:SetColor(col_255_255)
			end
			if vm:GetMaterial() == "Debug/hsv" then 
				--vm:SetMaterial("")	
			end
		else
			vm:SetColor(col_255_1) 
			vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
		end
		
		if self.CheckModelElements then
			self:CheckModelElements()	
		end
		
		if not self._ResetBoneMods then
			self:ResetBonePositions()
			self._ResetBoneMods = true
		end
		
		self:CalculateHandMovement()

		self:UpdateBonePositions(vm)
		
		local point = self.VElements and self.VElements["cast_point"..(self.ReverseCastHand and "_reversed" or "")] and self.VElements["cast_point"..(self.ReverseCastHand and "_reversed" or "")].modelEnt
		
		if not self.CastPoint then
			self.CastPoint = point
		end
		
		local sp = self.Owner:GetCurrentSpell()
		if sp and sp:IsValid() and point then
			if sp.HandDraw then
				if DD_DRAWHANDSPELLS then
					if point.LastSpell ~= sp then
						point:StopParticles()
						point.LastSpell = sp
						point.Particle = nil
					end
					sp:HandDraw(self.Owner,self.ReverseCastHand and true or false,point)
				else
					if point.Particle then
						point:StopParticles()
						point.Particle = nil
					end
					if sp.CanIgnorePassive then
						sp:HandDraw( self.Owner, self.ReverseCastHand and true or false, point, true)
					end
				end
			end
		end
		
		if self.OnDrawViewModel then
			self:OnDrawViewModel()
		end
		
		if (!self.VElements) then return end
		
		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for i = 1, #self.vRenderOrder do
			
			local name = self.vRenderOrder[ i ]
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if model.Spell and IsValid( self.Owner:GetCurrentSpell() ) and self.Owner:GetCurrentSpell().ClassName ~= model.Spell then continue end
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				model:SetRenderOrigin(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				
				if name == "cast_point" and IsValid(self.Owner) then
					ang = self.Owner:GetAimVector():Angle()
				else
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				end
				
				-- this should fix "lagging behind" for spell particles
				if name == "cast_point" then
					model:SetParent( vm )
				end
				
				model:SetAngles(ang)
				
				local size = (v.size.x + v.size.y + v.size.z)/3
				
				if v.fix_scale or self.FixScale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end
				//model:SetModelScaleOld(v.size)
				
				if wtf then
					if not model.tex then
						local ind = math.random( 1, 10 )
						model.tex = wtf_tbl[ ind ]
						model:SetMaterial( model.tex:GetName() )
					end
				else
					if (v.material == "") then
						model:SetMaterial("")
					elseif (model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				
				if v.Bonemerge then	
					model:AddEffects( EF_BONEMERGE ) 
					model:SetParent( vm )
				end
				
				if model.Spell then
					/*local sp = self.Owner:GetCurrentSpell()
					if sp and IsValid(sp) and not self.Owner:IsJuggernaut() then
						if sp.ClassName == model.Spell then*/
							--model:SetupBones()
							model:DrawModel()
					//	end
					//end
				else
					--model:SetupBones()
					model:DrawModel()
					
					if DD_BLOODYMODELS and self.Bloody then
						
						if self.BloodScale then
							GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailscale", self.BloodScale )
						end
						
						GAMEMODE.WeaponBloodMaterial:SetFloat( "$detailblendfactor", self.Bloody * 1.5 )
						
						render.SetBlend( 1 )
						render.SetColorModulation(0.5, 0, 0)
						render.MaterialOverride( GAMEMODE.WeaponBloodMaterial )
						
						model:SetupBones()
						model:DrawModel()

						render.MaterialOverride( nil )
						render.SetColorModulation(1, 1, 1)
						render.SetBlend(1)
					end
					
				end
				
				if v.Bonemerge then	
					model:RemoveEffects( EF_BONEMERGE )
				end
				
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
				model:SetRenderOrigin()
				//model:SetRenderAngles()
				
				--model:DisableMatrix( "RenderMultiply" )
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
		
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if self.Owner and self.Owner:IsGhosting() then return end
		//if self.Owner._efGhosting == true then return end
		if self.Owner:IsCrow() then return end
		
		local switchworldwodel = self.SwitchWorldModel and GAMEMODE.ThirdPerson and MySelf == self.Owner and DD_FULLBODY
		
		if !switchworldwodel then
			if(self.ShowWorldModel == nil or self.ShowWorldModel) then
				if wtf and not self.tex then
					local ind = math.random( 1, 10 )
					self.tex = wtf_tbl[ ind ]
				end
				if self.tex and not self.applytex then
					self:SetMaterial( self.tex:GetName() )
					self.applytex = true
				end
				self:DrawModel()
			end
		end
		
		if self.CheckWorldModelElements then
			self:CheckWorldModelElements()	
		end
		
		if self.OnDrawWorldModel then
			self:OnDrawWorldModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (ValidEntity(self.Owner)) then
			if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
				bone_ent = self.Owner:GetRagdollEntity()
			else
				bone_ent = self.Owner
			end
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in ipairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				
				if name == "cast" and IsValid(self.Owner) then
					ang = self.Owner:GetAimVector():Angle()
				else
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				end

				model:SetAngles(ang)
				
				local size = (v.size.x + v.size.y + v.size.z)/3
				
				if v.fix_scale or self.FixScale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end

				
				if wtf then
					if not model.tex then
						local ind = math.random( 1, 10 )
						model.tex = wtf_tbl[ ind ]
						model:SetMaterial( model.tex:GetName() )
					end
				else
					if (v.material == "") then
						model:SetMaterial("")
					elseif (model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				if model.WorldModel then
					if switchworldwodel then 
						model:SetupBones()
						model:DrawModel()
					end
				else
					model:DrawModel()
				end
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
				
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	
	
	
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end
			

			if (!bone) then return end
			
			pos, ang = vec_zero, ang_zero
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDERGROUP_VIEWMODEL_TRANSLUCENT )
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:SetLegacyTransform( true )
					v.createdModel = v.model
				
					if v.Spell then
						v.modelEnt.Spell = v.Spell
					end
					
					if v.WorldModel then
						v.modelEnt.WorldModel = true
					end
					
				
					
					//set bonemods
					if self.ElementsBoneMods and self.ElementsBoneMods[k] then
						for bn,tbl in pairs(self.ElementsBoneMods[k]) do
							local bone = v.modelEnt:LookupBone(bn)
							if (!bone) then continue end
							v.modelEnt:ManipulateBoneScale( bone, tbl.scale )
							v.modelEnt:ManipulateBoneAngles( bone, tbl.angle )
							v.modelEnt:ManipulateBonePosition( bone, tbl.pos )
							//twice
							v.modelEnt:ManipulateBoneScale( bone, tbl.scale )
							v.modelEnt:ManipulateBoneAngles( bone, tbl.angle )
							v.modelEnt:ManipulateBonePosition( bone, tbl.pos )
						end
					end
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
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

	function SWEP:OnRemove()
		self:RemoveModels()		
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

