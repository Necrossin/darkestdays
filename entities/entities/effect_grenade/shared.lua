ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
	AddCSLuaFile()
end

ENT.Damage = 145
ENT.Radius = 280
ENT.RechargeTime = 12

util.PrecacheSound("weapons/slam/throw.wav" )

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	self.EntOwner._efGrenade = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)	

		self:SetReady( true )
		self.NextRechargeTime = 0
	end
	
end

function ENT:SetReady( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsReady()
	return self:GetDTBool( 0 )
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efGrenade = nil
	end
end

if CLIENT then ENT.NextTap = 0 end

if SERVER then
local function ThrowNade(pl,cmd,args)
	if !IsValid(pl) then return end
	if !pl:Alive() then return end
	
	if !IsValid(pl._efGrenade) then return end
	
	local nade = pl._efGrenade
	
	if nade and nade.ThrowGrenade and nade.IsReady and nade:IsReady() then
		nade:ThrowGrenade()
	end
end
concommand.Add("dd_thrownade",ThrowNade)

hook.Add("PlayerButtonDown", "CheckGrenadeInput", function( pl, btn )

	if pl:Alive() and IsValid(pl._efGrenade) and btn == pl:GetInfoNum( "_dd_grenadebutton", KEY_G ) and not pl:IsTyping() then
	
		local nade = pl._efGrenade
		
		if ( nade.NextTap or 0 ) >= CurTime() then return end
	
		if nade and nade.ThrowGrenade and nade.IsReady and nade:IsReady() then
			nade:ThrowGrenade()
		end
	
		
		nade.NextTap = CurTime() + 2
		
	end

end)

end
function ENT:Think()
	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() or self.EntOwner:IsThug() then
			self:Remove()
			return
		end	
		
		if not self:IsReady() then
			if self.NextRechargeTime and self.NextRechargeTime < CurTime() then
				self:SetReady( true )
			end
		end
		
	end	
end


function ENT:ThrowGrenade()
	
	local wep = self.EntOwner:GetActiveWeapon()
	
	if self.EntOwner:IsCrow() then return end
	if !self:IsReady() then return end
	
	if IsValid(wep) then
		if self.EntOwner:IsSprinting() then return end
		if wep.IsCasting and wep:IsCasting() then return end
		if wep.IsReloading and wep:IsReloading() then return end
		if wep.GetNextReload and wep:GetNextReload() > CurTime() then return end
		if wep.IsAttacking and wep:IsAttacking() then return end
		if wep.IsBlocking and wep:IsBlocking() then return end
		
		if wep.SetSpellEnd then
			wep:SetSpellEnd(CurTime() + 0.65)
		end
	end

	local ent = ents.Create("npc_grenade_frag")
	if IsValid(ent) then
		local v = self.EntOwner:GetShootPos()
		v = v + self.EntOwner:GetForward() * 5
		v = v + self.EntOwner:GetRight() * -8
		v = v + self.EntOwner:GetUp() * -4
		ent:SetPos(v)
		local ang = self.EntOwner:GetAngles()
		ent:SetAngles(ang)
		ent:SetOwner(self.EntOwner)
		ent:Activate()
		ent:Spawn()
		ent:SetSaveValue("m_hThrower", self.EntOwner )
		local col = team.GetColor(self.EntOwner:Team())
		col.a = 255
		local trail = util.SpriteTrail(ent, ent:LookupAttachment( "fuse" ), col, true, 8, 1, 0.5, 1/(8+1)*0.5, "sprites/bluelaser1.vmt")
				
		ent:SetMaterial("models/shiny")
		ent:SetColor(col)
				
		ent:SetSaveValue("m_pGlowTrail", trail )
		ent:SetSaveValue("m_pMainGlow", trail )
				
		ent:SetSaveValue("m_flDamage", self.Damage )
		ent:SetSaveValue("m_DmgRadius", self.Radius )
				
		//ent:Fire("SetTimer",2.5,0)
		ent:Fire("SetTimer",1.8,0)
		
		ent:SetModelScale( 1.1, 0 )
				
				
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocity(self.EntOwner:GetVelocity()+self.EntOwner:GetAimVector() * 900)
			phys:AddAngleVelocity(Vector(600,math.random(-1200,1200),0))
		end
							
		self.EntOwner:PlayGesture(ACT_GMOD_GESTURE_ITEM_DROP)
		
		ent:EmitSound( "weapons/slam/throw.wav" )

		self:SetReady( false )
		self.NextRechargeTime = CurTime() + self.RechargeTime
	end
end


if CLIENT then
//it gets called faster, I guess?
function ENT:Draw() 
	if CLIENT then
		/*if input.IsKeyDown( KEY_G ) and not self.EntOwner:IsTyping() and self.EntOwner == MySelf then
			if self.NextTap >= CurTime() then return end
			self.NextTap = CurTime() + 10
			RunConsoleCommand("dd_thrownade")
		end*/
	end
end

/*hook.Add("PlayerButtonDown", "CheckGrenadeInput", function( pl, btn )
	if pl:Alive() and IsValid(pl._efGrenade) and btn == KEY_G and not pl:IsTyping() then
		if ( pl._efGrenade.NextTap or 0 ) >= CurTime() then return end
		pl._efGrenade.NextTap = CurTime() + 2
		RunConsoleCommand("dd_thrownade")
	end

end)*/

/*hook.Add("Think", "CheckGrenadeInput", function()
	
	if MySelf:Alive() and IsValid(MySelf._efGrenade) and input.IsKeyDown( KEY_G ) and not MySelf:IsTyping() then
		if MySelf._efGrenade.NextTap >= CurTime() then return end
		MySelf._efGrenade.NextTap = CurTime() + 10
		RunConsoleCommand("dd_thrownade")
	end

end)*/

end