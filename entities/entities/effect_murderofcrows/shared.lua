ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

local rndCrow = {
	"npc/crow/alert2.wav",
	"npc/crow/alert3.wav",
	"npc/crow/pain1.wav",
	"npc/crow/pain2.wav",
	"npc/crow/die1.wav",
	"npc/crow/die2.wav",
}

for _,snd in pairs(rndCrow) do
	util.PrecacheSound(snd)
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efMrdrOfCrows) then
		if SERVER then
			self.EntOwner._efMrdrOfCrows:Remove()
		end
		self.EntOwner._efMrdrOfCrows = nil
	end
	
	self.EntOwner._efMrdrOfCrows = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
		
		local e = EffectData()
		e:SetOrigin(self.EntOwner:GetPos())
		e:SetEntity(self.EntOwner)
		util.Effect("crows_attack",e,true,true)
		
		//if ValidEntity(self.EntAttacker) and self.EntAttacker:IsPlayer() and self.EntAttacker ~= self.EntOwner then
			//if self.EntAttacker:GetPerk("elementalist") then
				//self.EntAttacker:SetMana(self.EntAttacker:GetMana()+math.random(9,12),0,self.EntAttacker:GetMaxMana())
			//end
		//end
		
	end
	if CLIENT then
		-- self.Sound = CreateSound( self,  "ambient/fire/fire_med_loop1.wav" ) 
	end
	
	self.DieTime = CurTime() + 6
	
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efMrdrOfCrows = nil
	end
	if CLIENT then
		if self.Sound then
			--self.Sound:Stop() 
		end
	end
end

function ENT:Think()
	
	if CLIENT then
		if self.Sound then
			self.Sound:PlayEx(0.7, 95 + math.sin(RealTime())*5) 
		end
	end

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		self.NextTick = self.NextTick or 0
		
		if self.NextTick < CurTime() then
			self.NextTick = CurTime() + 0.27
			
			
			local Dmg = DamageInfo()
			Dmg:SetAttacker(self.EntAttacker or self.Entity)
			Dmg:SetInflictor(self.Entity)
			Dmg:SetDamage(math.random(2,3))
			Dmg:SetDamageType(DMG_SLASH)
			Dmg:SetDamagePosition(self.EntOwner:GetPos()+vector_up*32)	
						
			self.EntOwner:TakeDamageInfo(Dmg)
			
			self.EntOwner:EmitSound(rndCrow[math.random(1,#rndCrow)])
			
		end
		
	end
end

if CLIENT then
function ENT:Draw()
end
end