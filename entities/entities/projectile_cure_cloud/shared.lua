ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

ENT.IsSpell = true

util.PrecacheSound("npc/vort/health_charge.wav")

local table = table
local util = util
local player = player
local ents = ents
//sneaky remake of my power well

local player_GetAll = player.GetAll

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(4,7)
	self.Radius = 75
	self.HealRate = 0.018
	self.HealAmount = 3
	
	--self.EntOwner = self.Entity:GetOwner()
	if SERVER then
		self.Entity:DrawShadow(false)
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
		self.WooshSound = CreateSound( self, "npc/vort/health_charge.wav" ) 
	end
	
end


function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		self.NextHit = self.NextHit or 0
		
		if self.NextHit > CurTime() then return end
		
		self.NextHit = CurTime() + self.HealRate

		local players = ents.FindInSphere( self:GetPos()+vector_up*30, self.Radius )
		
		local is_ffa = GAMEMODE:GetGametype() == "ffa"

		for k, guy in pairs(players) do
			if guy:IsPlayer() and ( is_ffa and true or (guy ~= self.EntOwner and guy:IsTeammate(self.EntOwner))) then
			
				local ppl = player_GetAll()
				local filterplayers = {}
					
				for _,dude in ipairs(ppl) do
					if guy != dude then 
						table.insert(filterplayers,dude)
					end
				end
				
				table.insert(filterplayers,self)
				table.insert(filterplayers,GetHillEntity() or self)
				
				local trace = {}
				trace.start = self:GetPos()+vector_up*40
				trace.endpos = guy:GetPos()+vector_up*40
				trace.filter = filterplayers
				local tr = util.TraceLine( trace )
				
				if IsValid(tr.Entity) and tr.Entity == guy then
					guy:RefillHealth(self.HealAmount)
					if IsValid(self.EntOwner) and !is_ffa then
						self.EntOwner.Healed = self.EntOwner.Healed or 0
						
						self.EntOwner.Healed = self.EntOwner.Healed + 1
						
						self.EntOwner:RefillHealth(math.random(0,1))
						
						if self.EntOwner.Healed >= 250 then
							self.EntOwner:UnlockAchievement( "heal1" )
							if self.EntOwner.Healed >= 500 then
								self.EntOwner:UnlockAchievement( "heal2" )
								if self.EntOwner.Healed >= 750 then
									self.EntOwner:UnlockAchievement( "heal3" )
									if self.EntOwner.Healed >= 1250 then
										self.EntOwner:UnlockAchievement( "heal4" )
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if CLIENT then
		if self.WooshSound then
			local vol = self.DieTime - math.max(0,self.DieTime - CurTime())
			local addvol = math.Clamp(vol/self.DieTime,.1,.7)
			self.WooshSound:PlayEx(addvol, 85 + math.sin(RealTime())*5)
		end
	end
end

function ENT:OnRemove()
	if SERVER then
		--self.Entity:EmitSound("ambient/levels/citadel/portal_beam_shoot5.wav",math.random(70,110),80)	
	end
	if CLIENT then
		if self.WooshSound then
			self.WooshSound:Stop()
		end
		if self.Emitter then
			self.Emitter:Finish()
		end
	end
end

if CLIENT then
function ENT:Draw()
	
	local vec = Vector(self.Radius,self.Radius,50)
	self.Entity:SetRenderBounds( vec, -vec)
	
	self.Pos = self:GetPos()// + Vector(0,0,30)

	
	
	if not self.Particle then
		
		local effect = "cure_projectile_big"
		local r,g,b = 50, 255, 50
		
		if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():Team() ~= TEAM_FFA then
			
			effect = self:GetOwner():Team() == TEAM_RED and "cure_projectile_big_red" or "cure_projectile_big_blue"
			local col = team.GetColor(self:GetOwner():Team())
			r,g,b = col.r, col.g, col.b
		
		end
	
		ParticleEffect(effect,self.Pos,Angle(0,0,0),self.Entity)
		self.Particle = true
	end
	
	/*local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = r
			dlight.g = g
			dlight.b = b
			dlight.Brightness = 1
			dlight.Size = 150
			dlight.Decay = 150 * 5
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0
		end*/
end

end

