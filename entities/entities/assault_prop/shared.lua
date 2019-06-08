ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Team = function()
	return TEAM_BLUE
end

ENT.MaxHealth = 5000

local TeamOfHill = {}
TeamOfHill[TEAM_RED] = 1
TeamOfHill[TEAM_BLUE] = 2

local HillOfTeam = {}
HillOfTeam[1] = TEAM_RED
HillOfTeam[2] = TEAM_BLUE

local util = util
local team = team
local game = game
local player = player
local ipairs = ipairs
local math = math

if SERVER then
	AddCSLuaFile("shared.lua")
end

for i=3,4 do
	//util.PrecacheSound("ambient/machines/teleport"..i..".wav")
end

util.PrecacheModel("models/props_c17/FurnitureFridge001a.mdl")



local tr = {}

local checkpos = {
	Vector(1,0,0),
	Vector(-1,0,0),
	Vector(0,1,0),
	Vector(0,-1,0),
	Vector(1,1,0),
	Vector(1,-1,0),
	Vector(-1,1,0),
	Vector(-1,-1,0)
}

function ENT:Initialize()

	
	if SERVER then
		
		table.Shuffle(checkpos)
		
		self:SetModel("models/props_c17/FurnitureFridge001a.mdl")
		
		self:SetMoveType(MOVETYPE_NONE)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		
		self:SetColor(team.GetColor(self:Team()))
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		
		self:SetPos(self:GetPos()+vector_up*50)
		
		tr.start = self:GetPos()
		tr.endpos = self:GetPos()
		tr.mins = self:OBBMins()
		tr.maxs = self:OBBMaxs()
		tr.filter = self.Entity
		
		local trhull = util.TraceHull( tr )
		local newpos
		//blocked
		if trhull.Hit then
			for _, vec in pairs(checkpos) do
				for i=1,(self:OBBMaxs().y-self:OBBMins().y)*80 do
					tr.start = self:GetPos()+vec*i*4
					tr.endpos = self:GetPos()+vec*i*4
					trhull = util.TraceHull( tr )
					if !trhull.Hit then
						newpos = tr.endpos
						break
					end
				end
				if newpos then
					break
				end
			end
			
			
		end
		
		if newpos then
			self:SetPos(newpos)
		end
		
		
		//self.Entity:SetSolid(SOLID_NONE)
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			//phys:Wake()
			phys:EnableMotion( false ) 
		end
		
	
		self.Entity:DrawShadow(false)
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTimer(ASSAULT_TIME)// - (GAMEMODE.DeathMatchMap and 100 or 0)
		self.MaxHealth = self.MaxHealth// + (GAMEMODE.DeathMatchMap and 1500 or 0)
		self:SetFridgeHealth(self.MaxHealth)
		
		self:SetStartTime(CurTime() + 80)
		
		self:SetDTBool(0,false)

	end
	
	
end

function ENT:OnRemove()

end

if SERVER then
function ENT:OnTakeDamage(dmginfo)
	if not self:IsActive() then return end
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().Team and dmginfo:GetAttacker():Team() ~= self:Team() then
		self:SetFridgeHealth(math.Clamp(self:GetHealth()-dmginfo:GetDamage(),0,self.MaxHealth))
		
		self:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav",100, math.Rand(95, 130)) 
		
		if self:GetHealth() <= 0 then
			local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetScale(10)
			e:SetMagnitude(10)
			util.Effect("Explosion",e,nil,true)
			self:SetDTBool(0,true)
		end
	end
end
end

function ENT:Think()
	if SERVER then	
		if not self:IsActive() then return end
				
		local ct = CurTime()
				
		self.NextTick = self.NextTick or 0
			
		if self.NextTick <= ct then

			self:DrainTimer()
			
			self.NextTick = ct + 1//self:GetTickAmount(self:GetHoldingTeam())
		end
	end
end

if CLIENT then
local mat = Material( "models/shiny" )
function ENT:Draw()
	
	local vec = Vector(148,148,148)
	self.Entity:SetRenderBounds( vec, -vec) 

	if not self:GetDTBool(0) then

		render.SuppressEngineLighting( true )
			render.ModelMaterialOverride( mat )
				render.SetColorModulation( 0, 121 / 255, 250 / 255 )
				render.SetBlend(0.35)
					cam.IgnoreZ(true)
					self:SetModelScale( 1.02,0 )
					self:DrawModel()
					cam.IgnoreZ(false)
				render.SetColorModulation( 1, 1, 1 )
				render.SetBlend(1)
			render.ModelMaterialOverride( nil )	   
		render.SuppressEngineLighting( false )

		self:SetModelScale( 1,0 )
		render.SetColorModulation( 0, 121 / 255, 250 / 255 )
			self:DrawModel()
		render.SetColorModulation( 1, 1, 1 )
	end
				
end
end

function ENT:TeamToHill(tm)
	return TeamOfHill[tm]
end

function ENT:HillToTeam(htm)
	return HillOfTeam[htm]
end

function ENT:SetTimer(time)
	self:SetDTFloat(1,time)
end

function ENT:GetTimer()
	return self:GetDTFloat(1)
end

function ENT:SetFridgeHealth(hp)
	self:SetDTFloat(2,hp)
end

function ENT:GetHealth()
	return self:GetDTFloat(2)
end

function ENT:DrainTimer()
	self:SetTimer(math.Clamp(self:GetTimer() - 1, 0,999999))
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time) 
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

