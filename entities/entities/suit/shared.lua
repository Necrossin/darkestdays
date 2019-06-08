ENT.Type = "anim"  
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_NONE

game.AddParticles("particles/cig_smoke.pcf" )

PrecacheParticleSystem( "drg_pipe_smoke" )

local USE_TF2_PARTICLES = file.Exists ("models/player/items/soldier/cigar.mdl","GAME")
 
if SERVER then
	AddCSLuaFile("shared.lua")
end 
 
function ENT:Initialize()
	
	if SERVER then
		self.Entity:DrawShadow(false)
		self.Entity:SetSolid(SOLID_NONE)
	end
	
	
	
	if CLIENT then
		self:CreateModelElements()
	end
end

function ENT:Think()
	if SERVER then
		local pl = self:GetOwner()// and self:GetOwner():GetRagdollEntity() or self:GetOwner()
		if not IsValid(pl) then self:Remove() return end
		//if ValidEntity(self:GetOwner()) and not self:GetOwner():Alive() and !ValidEntity(self:GetOwner():GetRagdollEntity()) then self:Remove() end
		self.Entity:SetPos(pl:GetPos())
	end
	if CLIENT then
		if IsValid(self:GetOwner()) then
			local owner = self:GetOwner()
			if MySelf and owner == MySelf and not IsValid(MySelf.Suit) then
				MySelf.Suit = self.Entity
			end
		end
		
		if self.CheckModelElements then
			//self:CheckModelElements()
		end
	end
end

//Remove all children 
function ENT:OnRemove()
	if CLIENT then
		self:RemoveModels()
	end
end

if SERVER then
	function ENT:SetSuitTable( tbl )		
		for i=0,3 do
			self:SetDTInt(i,0)
		end
	
		if ENABLE_OUTFITS then
			for i=0,3 do
				self:SetDTInt(i,0)
				local itemname = tbl[i+1]
				if itemname then
					local itemkey = Equipment[itemname] and Equipment[itemname].key
					if itemkey then
						self:SetDTInt(i,itemkey)
					end
				end
			end
		end
	end
end


function ENT:InitializeClientsideModels(tbl)
	
	self.Elements = {}
	if tbl then
		self.Elements = table.Copy(tbl) 
		self:CreateModels(self.Elements)
	end	
end


function ENT:CreateModelElements()
	self.ElementsKeys = {}
	
	for k=0,3 do
		self.ElementsKeys[k] = 0
	end
	
	local temp = {}
	
	if ENABLE_OUTFITS then
		local counter = 1
		for i=0,3 do
			--if self:GetDTInt(i) ~= 0 then
				local item = EquipmentKeys[self:GetDTInt(i)]
				if item then
					local tbl = tempEquipment[item]
					if tbl then
						local tblitems = tbl.props
						if tblitems then
							for _,minitable in pairs(tblitems) do
								local t = table.Copy(minitable)
								if minitable.rel and minitable.rel ~= "" then
										t.rel = item.."_"..minitable.rel
								end
								temp[item.."_".._] = t
								self.ElementsKeys[i] = self:GetDTInt(i)--item
							end
						end
					end
				end
			--end
		end
	end
	
	local count = 0
	
	
	
	if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
		for _, wep in ipairs(self:GetOwner():GetWeapons()) do
			if Weapons[wep:GetClass()] and HolsterWeapons[wep:GetClass()] then
				temp[wep:GetClass()] = table.Copy(HolsterWeapons[wep:GetClass()])
				temp[wep:GetClass()].ShouldHide = function(p,name) 
					name = name or ""
					return IsValid(p) and p:IsPlayer() and IsValid(p:GetActiveWeapon()) and p:GetActiveWeapon():GetClass() == name
				end
				count = count + 1
			end
		end
	end
	
	if count >= 2 then
		self.CanReset = true
	end
	
	if count == 0 and self.Elements then
		for k,v in pairs(self.Elements) do
			if HolsterWeapons[k] then
				self.CanReset = true
				break
			end
		end
	end
	
	self:InitializeClientsideModels(temp)
	
end

local ipairs = ipairs
function ENT:CheckModelElements()

	if !self.Elements then
			timer.Simple(0,function()
				self:CreateModelElements()
			end)
		end
	if self.Elements and self.ElementsKeys then
		for key=0,3 do
			if self.ElementsKeys[key] ~= self:GetDTInt(key) then		
				timer.Simple(0,function()
						self:RemoveModels()
					end)
				break						
			end
		end
		if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
			local count = 0
			for _, wep in ipairs(self:GetOwner():GetWeapons()) do
				if Weapons[wep:GetClass()] and (HolsterWeapons[wep:GetClass()] and not self.Elements[wep:GetClass()] or not HolsterWeapons[wep:GetClass()] and self.CanReset) then
					timer.Simple(0,function()
						self:RemoveModels()
					end)
					self.CanReset = false
					break	
				end
			end
		end
	end
end


function ENT:CheckModelElementsOld()

	if !self.Elements then
			timer.Simple(0,function()
				self:CreateModelElements()
			end)
		end
	if self.Elements and self.ElementsKeys then
		for key=0,3 do
			if self.ElementsKeys[key] ~= self:GetDTInt(key) then		
				timer.Simple(0,function()
						self:RemoveModels()
					end)
				break						
			end
			
		end
	end
end

if CLIENT then
	
	local render = render
	local table = table
	local pairs = pairs
	local cam = cam
	local string = string
	local ipairs = ipairs
	local util = util
	local LocalPlayer = LocalPlayer
	local ValidEntity = IsValid
	local GetConVarNumber = GetConVarNumber
	local Vector = Vector
	local CreateMaterial
	local vector_up = vector_up
	local TrueVisible = TrueVisible
	
	
	local function TrueVisibleSuit(posa, posb)
		return not util.TraceLine({start = posa, endpos = posb, filter = player.GetAll()}).Hit
	end
	
	ENT.RenderOrder = nil

	local ZombieOffsets = {
		["models/zombie/classic.mdl"] = {
			["ValveBiped.Bip01_Head1"] = {NewBone = "ValveBiped.Bip01_Spine4", Offset = Vector(1.7, 1.8, 0.8), Rotation = Angle(180, -25, 0)},
		},
		["models/zombie/fast.mdl"] = {
			["ValveBiped.Bip01_Head1"] = {NewBone = "ValveBiped.Bip01_Spine4", Offset = Vector(4, 0, 0), Rotation = Angle(-180, -90, 0)},
		},
		["models/zombie/poison.mdl"] = {
			["ValveBiped.Bip01_Head1"] = {NewBone = "ValveBiped.Bip01_Spine4", Offset = Vector(2.19, 0.523, -0.08), Rotation = Angle(0, 90, -90)},
		},
	}
	
	
	function ENT:StopEffects( tbl )
		for k, name in ipairs( tbl ) do
			local v = self.Elements[name]
			if (v.type == "Model" and ValidEntity(model)) then
			
			end
		end
	end
	
	local mins = Vector(-70, -70, -78)
	local maxs = Vector(70, 70, 90)
	
	function ENT:Draw()
		
		local todraw = true
		
		if EyePos():DistToSqr(self:GetPos()) >= 810000 and not TrueVisibleSuit(EyePos(), self:GetPos()+vector_up*50) then 
			todraw = false
		end
		
		if IsValid(self:GetOwner()) and not self._SetRenderBounds then
			self:SetRenderBounds(mins, maxs)
			self._SetRenderBounds = true
		end
	
		if self.CheckModelElements then
			self:CheckModelElements()
		end
		
		if self:GetOwner() == MySelf and MySelf:Alive() and not GAMEMODE.ThirdPerson then 
			todraw = false
		end
		
		if self:GetOwner():IsGhosting() then 
			todraw = false
		end
		
		if self:GetOwner():IsCrow() then 
			todraw = false
		end
		
		//if ValidEntity(self:GetOwner():GetDTEntity(0)) then 
		//	todraw = false
		//end
		
		if not self:GetOwner():Alive() and !ValidEntity(self:GetOwner():GetRagdollEntity()) then 
			todraw = false
		end
		
		if not DD_DRAWSUITS then 
			todraw = false
		end
		
		if (!self.Elements) then return end
		
		if (!self.RenderOrder) then

			self.RenderOrder = {}

			for k, v in pairs( self.Elements ) do
				if (v.type == "Model") then
					table.insert(self.RenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.RenderOrder, k)
				end
			end

		end

		
		if (ValidEntity(self:GetOwner())) then
			if ValidEntity(self:GetOwner():GetRagdollEntity()) then
				bone_ent = self:GetOwner():GetRagdollEntity()
			else
				bone_ent = self:GetOwner()
			end
		else
			bone_ent = self
		end
		
		for k, name in ipairs( self.RenderOrder ) do
		
			local v = self.Elements[name]
			if (!v) then self.RenderOrder = nil break end
			
			local pos, ang
			
			local off,rot = Vector(0,0,0), Angle(0,0,0)
			local mdl = string.lower(bone_ent:GetModel())
			local newbone

			if ZombieOffsets[mdl] and ZombieOffsets[mdl][v.bone] then
				newbone = ZombieOffsets[mdl][v.bone].NewBone
				off = ZombieOffsets[mdl][v.bone].Offset
				rot = ZombieOffsets[mdl][v.bone].Rotation
			end
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.Elements, v, bone_ent, newbone )
			else
				pos, ang = self:GetBoneOrientation( self.Elements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then

				if v.seq then
					model:FrameAdvance( (RealTime()-(model.LastPaint or 0)) * 1 )	
				end
			
				model:SetPos(pos + ang:Forward() * (v.pos.x + off.x) + ang:Right() * (v.pos.y + off.y) + ang:Up() * (v.pos.z + off.z) )
				ang:RotateAroundAxis(ang:Up(), v.angle.y+rot.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p+rot.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r+rot.r)

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
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				local skin = v.skin
				if ValidEntity(self:GetOwner()) then
					skin = self:GetOwner():Team() == TEAM_BLUE and v.skin+1 or v.skin
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
				

				if USE_TF2_PARTICLES and v.particle and v.particleatt and todraw and IsValid(self:GetOwner()) and self:GetOwner():Alive() and self:GetOwner():IsAdmin() then
					if not model.Particle then
						for _,part in pairs(v.particle) do
							ParticleEffectAttach(part,PATTACH_POINT_FOLLOW,v.modelEnt,v.modelEnt:LookupAttachment(v.particleatt))
						end
						model.Particle = true
					end
				else
					if model.Particle then
						model:StopParticles()
						model.Particle = nil
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				//local version of "todraw"
				local model_todraw = true
				
				if model.IsHeadItem and GAMEMODE.ThirdPerson and bone_ent == MySelf and DD_FULLBODY then
					model_todraw = false
				end
				
				if model.IsHeadItem and !bone_ent:IsPlayer() and !bone_ent.Sliced and not (GAMEMODE.ThirdPerson and !DD_FULLBODY) then
					model_todraw = false
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				if todraw and model_todraw and not (v.ShouldHide and v.ShouldHide(self:GetOwner(),name)) then
					if not (bone_ent.Sliced or bone_ent.RemoveSuit) then//(model.IsHeadItem and )
						model:SetupBones()
						model:DrawModel()
					end
				end
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
								
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
				if v.seq then
					model.LastPaint = RealTime()
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
	

	function ENT:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			local off,rot = Vector(0,0,0), Angle(0,0,0)
			local mdl = string.lower(ent:GetModel())
			local newbone

			if ZombieOffsets[mdl] and ZombieOffsets[mdl][v.bone] then
				newbone = ZombieOffsets[mdl][v.bone].NewBone
				off = ZombieOffsets[mdl][v.bone].Offset
				rot = ZombieOffsets[mdl][v.bone].Rotation
			end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			//pos, ang = self:GetBoneOrientation( basetab, v, ent )

			pos, ang = self:GetBoneOrientation( basetab, v, ent, newbone )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * (v.pos.x + off.x) + ang:Right() * (v.pos.y + off.y) + ang:Up() * (v.pos.z + off.z)
			ang:RotateAroundAxis(ang:Up(), v.angle.y+rot.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p+rot.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r+rot.r)
				
		else
			
			--bone = ent:LookupBone(bone_override or tab.bone)
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end
			
			if (!bone) then return end

			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
		end
		
		return pos, ang
	end

	function ENT:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
					v.modelEnt.SuitProp = true
					v.modelEnt:SetLegacyTransform( true )
					if v.Str then
						v.modelEnt.UseNewScaling = true
					end
					if v.bone == "ValveBiped.Bip01_Head1" or v.UseHead then
						v.modelEnt.IsHeadItem = true
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
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in ipairs( tocheck ) do
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

	function ENT:RemoveModels()
		if (self.Elements) then
			for k, v in pairs( self.Elements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.Elements = nil
		self.RenderOrder = nil
	end


end
