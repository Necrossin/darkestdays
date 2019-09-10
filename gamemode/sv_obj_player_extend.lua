local meta = FindMetaTable( "Player" )
if (!meta) then return end

local math = math
local team = team
local ents = ents
local table = table
local pairs = pairs

function meta:SetupDefaultStats()
	
	self._DefaultHealth = PLAYER_DEFAULT_HEALTH
	self._DefaultMana = PLAYER_DEFAULT_MANA
	self._DefaultSpeed = PLAYER_DEFAULT_SPEED
	self._DefaultRunSpeedBonus = PLAYER_DEFAULT_RUNSPEED_BONUS
	self._DefaultJumpPower = PLAYER_DEFAULT_JUMPPOWER
	self._DefaultMeleeBonus = PLAYER_DEFAULT_MELEE_BONUS
	self._DefaultMeleeSpeedBonus = PLAYER_DEFAULT_MELEE_SPEED_BONUS
	self._DefaultDodgeBonus = PLAYER_DEFAULT_DODGE_BONUS
	self._DefaultMResBonus = PLAYER_DEFAULT_MAGIC_RESISTANCE_BONUS
	self._DefaultMChannelingBonus = PLAYER_DEFAULT_MAGIC_CHANNELING_BONUS
	self._DefaultLightWeaponryBonus = PLAYER_DEFAULT_AGILITY_DMG_BONUS
	self._DefaultHeavyWeaponryBonus = PLAYER_DEFAULT_DEFENSE_DMG_BONUS
	self._DefaultMagicBonus = PLAYER_DEFAULT_MAGIC_DMG_BONUS
	self._DefaultMagicRegenBonus = PLAYER_DEFAULT_MAGIC_REGEN_BONUS
	self._DefaultBulletFalloffBonus = PLAYER_DEFAULT_BULLET_FALLOFF_BONUS
	self._DefaultBulletConsumeBonus = PLAYER_DEFAULT_BULLET_CONSUME_BONUS
	self._DefaultBulletScavegerBonus = PLAYER_DEFAULT_BULLET_SCAVENGER_BONUS

end

function meta:SetupSkillStats()
	
	self._DefaultHealth = self._DefaultHealth + SKILL_DEFENSE_HEALTH_PER_LEVEL * self:GetDefense()
	self._DefaultMana = self._DefaultMana + SKILL_MAGIC_MANA_PER_LEVEL * self:GetMagic()
	self._DefaultSpeed = self._DefaultSpeed + SKILL_AGILITY_SPEED_PER_LEVEL * self:GetAgility()
	self._DefaultMeleeBonus = self._DefaultMeleeBonus + SKILL_STRENGTH_DAMAGE_PER_LEVEL * self:GetStrength()
	self._DefaultMeleeSpeedBonus = self._DefaultMeleeSpeedBonus + SKILL_STRENGTH_MELEE_SPEED_PER_LEVEL * self:GetStrength()
	self._DefaultMResBonus = self._DefaultMResBonus + PLAYER_DEFAULT_MAGIC_RESISTANCE_BONUS * self:GetStrength()
	self._DefaultDodgeBonus = self._DefaultDodgeBonus + SKILL_STRENGTH_DODGE_PER_LEVEL * self:GetStrength()
	self._DefaultLightWeaponryBonus = self._DefaultLightWeaponryBonus + SKILL_AGILITY_DAMAGE_PER_LEVEL * self:GetAgility()
	self._DefaultHeavyWeaponryBonus = self._DefaultHeavyWeaponryBonus + SKILL_DEFENSE_DAMAGE_PER_LEVEL * self:GetDefense()
	self._DefaultMagicBonus = self._DefaultMagicBonus + SKILL_MAGIC_DAMAGE_PER_LEVEL * self:GetMagic()
	self._DefaultMChannelingBonus = self._DefaultMChannelingBonus + SKILL_MAGIC_CHANNELING_PER_LEVEL * self:GetMagic()
	self._DefaultBulletFalloffBonus = self._DefaultBulletFalloffBonus + SKILL_BULLET_FALLOFF_PER_LEVEL * self:GetGunMastery()
	self._DefaultBulletConsumeBonus = self._DefaultBulletConsumeBonus + SKILL_BULLET_CONSUME_PER_LEVEL * self:GetGunMastery()
	self._DefaultBulletScavegerBonus = self._DefaultBulletScavegerBonus + SKILL_BULLET_SCAVENGER_PER_LEVEL * self:GetGunMastery()
	
end

function meta:SetupSpells(arg)
	
	local mana = math.Clamp(self._DefaultMana,0,999999)//100
	
	self:SetMana(mana)
	self:SetMaxMana(mana)
	
	self:SetCurSpellInd(1)
	
	//self.CurrentSpells = {}
	
	//umsg.Start("ResetSpells",self)
	//umsg.End()
	
	local i = 1
	
	for _,name in pairs(arg) do
		if _ ~= "n" then
			local sp = self:GiveSpell(name)
			sp:SetSpellIndex(i)
			self:SetDTEntity(i,sp)
			i=i+1
		end
	end
end


function meta:CreateOrb(attacker)
	
	if !IsValid(attacker) then return end
	
	if attacker:GetPerk("adrenaline") then
		local ent = ents.Create( "pickup_evil_orb" )
		ent:SetPos( self:GetPos() )
		ent:Spawn()
		ent:Activate()
	else
		local hp = attacker:Health()/attacker:GetMaxHealth()
		local mana = attacker:GetMana()/attacker:GetMaxMana()
		
		local pickup = mana > hp and "pickup_health_orb" or "pickup_mana_orb"
		
		local ent = ents.Create( pickup )
		ent:SetPos( self:GetPos() )
		ent:Spawn()
		ent:Activate()
	end
	
end

function meta:GiveSpell(name)
	
	local ent = ents.Create("spell_"..name)
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()
		ent:Activate()
		
		--table.insert(self.CurrentSpells,{Name = name, obj = ent})
		
		return ent
	end

end

function meta:SetEffect(name)
	local ent = ents.Create("effect_"..name)
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()
		ent:Activate()
		return ent
	end
end

function meta:SwitchSpell()
	
	self._NextSpellSwitch = self._NextSpellSwitch or 0
	
	if self._NextSpellSwitch > CurTime() then return end
	
	self._NextSpellSwitch = CurTime() + 0.6
	
	local ind = self:GetCurSpellInd()
	
	if ind == 1 then ind = 2 else ind = 1 end
	
	self:SetCurSpellInd(ind)
	
end

function meta:RefillHealth(am)
	self:SetHealth(math.Clamp(self:Health()+am,0,self:GetMaxHealth()))
end

function meta:RefillMana(am)
	self:SetMana(math.Clamp(self:GetMana()+am,0,self:GetMaxMana()))
end

function meta:RestoreSomeHealth(am)
	am = am or 40
	if self:Health() < self:GetMaxHealth() then
		self:SetHealth(math.Clamp(self:Health()+am,0,self:GetMaxHealth()))
		return true
	end
	return false
end

function meta:RestoreSomeMana(am)
	am = am or 50
	if self:GetMana() < self:GetMaxMana() then
		self:SetMana(math.Clamp(self:GetMana()+am,0,self:GetMaxMana()))
		return true
	end
	return false
end

function meta:RestoreHealth()
	if self:Health() ~= self:GetMaxHealth() then
		self:SetHealth(self:GetMaxHealth())
		return true
	end
	return false
end

function meta:RestoreMana()
	if self:GetMana() ~= self:GetMaxMana() then
		self:SetMana(self:GetMaxMana())
		return true
	end
	return false
end

function meta:RestoreAmmo(reward)
	local weps = self:GetWeapons()
	
	if #weps < 1 then return end
	
	local needammo = false
	
	if not reward then
		for _,wep in pairs(weps) do
			local defclip,defam = wep.Primary.ClipSize, wep.Primary.DefaultClip
			if defclip and defam then
				local curammo = wep:Clip1() + self:GetAmmoCount(wep.Primary.Ammo)
				local defammo = defam
				
				if curammo ~= defammo then
					needammo = true
					break
				end
			end
		end
		
		if !needammo then return false end
	end
	
	if not reward then
		self:RemoveAllAmmo()
	end
	
	for _,wep in pairs(weps) do
		if wep.IsMelee then continue end
		
		if wep:GetClass() == "dd_striker" then
			local am = wep.Primary.DefaultClip - wep:Clip1()
			local amtype = wep.Primary.Ammo
			
			if reward then
				local defclip,defam = wep.Primary.ClipSize/8, wep.Primary.DefaultClip
				if defclip and defam then
					local curammo = wep:Clip1()
					local defammo = defam
					am = math.Clamp(math.ceil(defclip*(self._DefaultBulletScavegerBonus or AMMO_RESTORE)) or 1,0,(defammo-curammo))
				end
			end
			
			wep:SetClip1( math.Clamp( wep:Clip1() + am , 0, wep.Primary.ClipSize ) )
		else
			local am = wep.Primary.DefaultClip - wep:Clip1()
			local amtype = wep.Primary.Ammo
			
			if reward then
				local defclip,defam = wep.Primary.ClipSize, wep.Primary.DefaultClip
				if defclip and defam then
					local curammo = wep:Clip1() + self:GetAmmoCount(wep.Primary.Ammo)
					local defammo = defam
					am = math.Clamp(math.ceil(defclip*(self._DefaultBulletScavegerBonus or AMMO_RESTORE)) or 1,0,(defammo-curammo))
				end
			end
			
			self:GiveAmmo(am,amtype)
		end
	end
	
	
	return true
end

function meta:SetMana(am)
	self:SetDTInt(0,am)
end

function meta:SetMaxMana(am)
	self:SetDTInt(1,am)
end

function meta:SetCurSpellInd(n)
	self:SetDTInt(2,n)
end

function meta:SetMaxHealthClient(am)
	self:SetDTInt(3,am)
end


util.AddNetworkString( "SetPerk" )

function meta:SetPerk(key)
	
	if not ValidEntity (self) then return end
	if not key then return end
	
	self.Perks = key//self.Perks or {}
	
	net.Start( "SetPerk" )
		net.WriteString( key )
		net.WriteEntity( self )
	net.Broadcast()
	
	//if #self.Perks > 1 then return end
	
	//table.insert(self.Perks,key)
	
	for _,p in pairs(Perks) do
		if p.OnReset then
			p.OnReset(self)
		end
	end

	//for _,p in pairs(self.Perks) do
		if Perks[key] and Perks[key].OnSet then
			Perks[key].OnSet(self)
		end
	//end
	

end

function meta:GetPerk(prk)
	//self.Perks = self.Perks or {}
	return self.Perks and self.Perks == prk//table.HasValue(self.Perks,prk) or false
end

local string = string

function meta:SetTeamColor()
	
	if GAMEMODE:GetGametype() == "ffa" then
		local pcol = Vector(self:GetInfo("cl_playercolor"))
		pcol.x = math.Clamp(pcol.x, 0, 1)
		pcol.y = math.Clamp(pcol.y, 0, 1)
		pcol.z = math.Clamp(pcol.z, 0, 1)
		self:SetPlayerColor(pcol)
		
		local wcol = Vector(self:GetInfo("cl_weaponcolor"))
		wcol.x = math.Clamp(wcol.x, 0.01, 1)
		wcol.y = math.Clamp(wcol.y, 0.01, 1)
		wcol.z = math.Clamp(wcol.z, 0.01, 1)
		self:SetWeaponColor(wcol)
	else
		local col = team.GetColor( self:Team() )
		local mdl = self:GetModel()
		
		--if table.HasValue( NormalColor, string.lower(mdl) ) then
			--self:SetColor(Color(math.Round(col.r*1.0),math.Round(col.g*1.0),math.Round(col.b*1.0),col.a))
		if table.HasValue( GAMEMODE.NormalColorModels, string.lower( mdl ) ) then
			self:SetColor( col )
		else
			self:SetColor( color_white )
			self:SetPlayerColor( Vector( col.r/255,col.g/255,col.b/255 ) )
			self:SetWeaponColor( Vector( col.r/255,col.g/255,col.b/255 ) )
		end
	end
	
end

function meta:SpawnSuit(tbl)
	
	if !ENABLE_OUTFITS then return end
	
	tbl = tbl or {}
	
	if IsValid(self:GetDTEntity(3)) then
		//self:GetDTEntity(3):Remove()
		self:GetDTEntity(3):SetSuitTable( tbl )

	else

		local suit = ents.Create("suit")
		suit:SetOwner(self)
		suit:SetParent(self)
		suit:SetPos(self:GetPos())
		suit:SetSuitTable( tbl )
		suit:Spawn()
		
		self:SetDTEntity(3,suit)
	end
	
	
	
end

function meta:SetVoiceSet( set )
	self:SetDTString( 1, set )
end


local walltrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 15)}
function meta:CheckWalljump()
	
	if self:OnGround() then return end
	
	if self:IsThug() or self:IsCrow() then return end
	//if not self._SkillWJ then return end
	
	self._NextWallJump = self._NextWallJump or 0
	
	if self._NextWallJump >= CurTime() then return end
	if self._NextLedgeGrab and self._NextLedgeGrab >= CurTime() then return end
	
	if math.abs( self:GetVelocity().z ) > self:GetRunSpeed() * 2 then return end
	
	//local nofall = self:GetVelocity().z < self:GetVelocity().x or self:GetVelocity().z < self:GetVelocity().y
	
	//if !nofall then return end
	
	local prevvelvec = self:GetVelocity()
	prevvelvec.z = math.Clamp(prevvelvec.z,-70,70)
	local prevvel = prevvelvec:Length()
	
	if prevvel < 50 then prevvel = 50 end
	
	if self._WallJumpBonus and self._WallJumpBonus >= CurTime() then
		prevvel = math.Clamp(prevvel,-550,550)
	else
		prevvel = math.Clamp(prevvel,-260,260)
	end
	
	local forward = self:SyncAngles():Forward()
	local pos = self:GetShootPos()
	
	walltrace.start = pos - vector_up * 20
	walltrace.endpos = pos + forward * 30
	
	local tr
	local mul = 2
	local f = true
	local l = false
	
	tr = util.TraceHull(walltrace)
	
	if not tr.Hit then
		mul = 1
		f = false
		walltrace.endpos = pos + self:SyncAngles():Right() * 30
		tr = util.TraceHull(walltrace)
	end
	
	if not tr.Hit then
		l = true
		walltrace.endpos = pos + self:SyncAngles():Right() * -30
		tr = util.TraceHull(walltrace)
	end

	if tr.Hit and not tr.HitSky and tr.HitNormal.z < 0.3 and tr.HitNormal.z > -0.3 then
			
		local add = not f and prevvelvec/1.2 or vector_origin
		
		self:SetLocalVelocity(vector_origin)
		
		if f and self:KeyDown(IN_USE) then
			local ang = self:GetAimVector():Angle()
			local normang = (tr.HitNormal*-1):Angle()
			local dif = ang.y - normang.y
			local turn = 180 - dif
			if dif > 0 then
				turn = dif-180
			end
			ang:RotateAroundAxis(ang:Up(),180)
			self:ViewPunch(Angle(0,turn,0))
			self:SetEyeAngles(ang)
		end
		
		if not f and not l then
			self:ViewPunch(Angle(0,0,-3))
		end
		
		if not f and l then
			self:ViewPunch(Angle(0,0,3))
		end
		
		self:SetLocalVelocity(tr.HitNormal*prevvel*mul + vector_up*(prevvel/1.2) + add)
		
		self:EmitSound("Flesh.ImpactSoft")
		
		self._NextWallJump = CurTime() + 0.2
	end
	
end

//anims: zombie_slump_rise_01

local walltrace = {mask = MASK_SOLID, mins = Vector(-5, -5, 0), maxs = Vector(5, 5, 64)}
function meta:GrabLedge()
	
	if self:IsCrow() then return end//self:IsThug() or 
	//if not self._SkillLedgeGrab then return end
	
	self._NextLedgeGrab = self._NextLedgeGrab or 0
	
	if self._NextLedgeGrab >= CurTime() then return end
	if self._NextWallJump and self._NextWallJump >= CurTime() then return end
	
	local forward = self:SyncAngles():Forward()
	local pos = self:GetPos()
	local shootpos = self:GetShootPos()
	
	walltrace.start = pos + vector_up * 5
	walltrace.endpos = pos + forward * 30 + vector_up * 5
	walltrace.filter = player.GetAll()
	
	local trwall = util.TraceHull(walltrace)
	local trspace
	local finalpos
	
	//we are humping a wall, lets see if there is a ledge
	if trwall.Hit and not trwall.HitSky and trwall.HitNormal.z < 0.3 and trwall.HitNormal.z > -0.3 then
		for i=1,self:OBBMaxs().z,5 do
			if not trspace or trspace.Hit then
				walltrace.start = shootpos + vector_up*i
				walltrace.endpos = walltrace.start + forward * 30
				trspace = util.TraceHull(walltrace)
				if not trspace.Hit then 
					finalpos = walltrace.endpos
					break
				end
			end
		end
	end
	
	if finalpos then
		//self:SetPos(finalpos)
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(vector_up*(240+math.abs(finalpos.z-pos.z)) )
		
		self:EmitSound("Flesh.StepRight")
		
		self:ViewPunch(Angle(3,0,0))
		
		self._NextLedgeGrab = CurTime() + 1//1.5
	end	
end

function meta:Roll()
	
	if self:IsThug() or self:IsCrow() then return end
	if self:IsSliding() then return end
	//if not self._SkillRoll then return end
	
	self._NextRoll = self._NextRoll or 0
	
	if self._NextRoll >= CurTime() then return end
	
	self:SetLuaAnimation("roll")
	self:SetEffect("roll")
	local vel = self:GetVelocity()
	vel.z = 100
	self:SetGroundEntity(NULL)
	self:SetVelocity(vel+self:SyncAngles():Forward()*300)
	
	self._NextRoll = CurTime() + 2
	
end

function meta:BecomeCrow()
	
	self._NextCrow = self._NextCrow or 0
	
	if self._NextCrow >= CurTime() then return end
	
	local mana = self:GetMana()
	local maxmana = self:GetMaxMana()
	local uses = 2
	local consume = math.floor( maxmana / uses )
	
	self._NextCrow = CurTime() + 1
	
	if mana >= consume then
		self:SetMana( math.Clamp( self:GetMana() - consume, 0, self:GetMana() ) )	
	else
		return
	end
	
	self:SetEffect("cotn")
	
end

function meta:DoDash()
	
	self._NextDash = self._NextDash or 0
	
	//if !self:IsOnGround() then return end
	
	if self._NextDash >= CurTime() then return end
	
	local mana = self:GetMana()
	local maxmana = self:GetMaxMana()
	local uses = 4
	local consume = math.floor( maxmana / uses )
	local softcap = 20
	
	self._NextDash = CurTime() + 0.5
	
	if mana >= consume and mana >= softcap then
		self:SetMana( math.Clamp( self:GetMana() - consume, 0, self:GetMana() ) )	
	else
		return
	end
	
	self:EmitSound("npc/scanner/scanner_nearmiss2.wav",75,math.random(120,135), 0.7)
	self:SetEffect("dash")
	
	
end

local kick_trace = { mask = MASK_SOLID, mins = Vector( -16, -16, -40 ), maxs = Vector( 16, 16, 10 ) }
function meta:DropKick()
	
	self._NextKick = self._NextKick or 0
	
	if self._NextKick >= CurTime() then return end
	
	self._NextKick = CurTime() + 2
	self._NextSlide = 0
	self:Slide()
	
	kick_trace.start = self:GetShootPos()
	kick_trace.endpos = kick_trace.start + self:GetForward() * 72
	kick_trace.filter = self:GetMeleeFilter()
	
	local tr = util.TraceHull( kick_trace )
	
	if tr.Hit and !tr.HitWorld then
		local hitent = tr.Entity
		
		if hitent and hitent:IsValid() then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else	
				
				local dmg = 45
				dmg = dmg + (dmg*(self._DefaultMeleeBonus or 0))/100
			
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(dmg)
				dmginfo:SetAttacker(self)
				dmginfo:SetInflictor( self )
				dmginfo:SetDamageType( DMG_CRUSH )
				dmginfo:SetDamageForce( (self:GetForward() ) * 350 * dmg )
				
				self:EmitSound("NPC_Vortigaunt.Kick")
				
				hitent:SetGroundEntity( NULL )
				
				if hitent:IsPlayer() then
					hitent:SetLocalVelocity( (self:GetForward() ) * 22 * dmg )
				end
				
				hitent:TakeDamageInfo(dmginfo)
		
			end
		
		end
	end
	

	
end

function meta:DoGhosting()
	self._NextGhosting = self._NextGhosting or 0
	if self._NextGhosting >= CurTime() then return end
	
	self._NextGhosting = CurTime() + 1
	
	self:SetEffect("ghosting")
	
end

function meta:Slide()
	
	if self:IsThug() or self:IsCrow() then return end
	//if not self._SkillSlide then return end
	
	self._NextSlide = self._NextSlide or 0
	
	if self._NextSlide >= CurTime() then return end
	if IsValid(self._efSlide) then return end
	
	//self:StopAllLuaAnimations()
	
	self:SetEffect("slide")
	self:SetLuaAnimation("slide")
	
	self._NextSlide = CurTime() + 3
	
end

function meta:Gib( dmginfo, frozen )

	self.Gibbed = true
	
	frozen = frozen or self._efFrozenTime and self._efFrozenTime >= CurTime()
	
	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal( dmginfo:GetDamageForce():GetNormal() + self:GetVelocity():GetNormal())
		effectdata:SetScale( frozen and 1 or 0 )
	util.Effect( "gib_player", effectdata, nil, true )
	
end

util.AddNetworkString( "PlayGesture" )

function meta:PlayGesture(name)

	self:AnimRestartGesture(GESTURE_SLOT_GRENADE, name, true)
	
	net.Start("PlayGesture")
		net.WriteEntity(self)
		net.WriteInt(name,32)
	net.Broadcast()
	
end

util.AddNetworkString( "Hitmarker" )

function meta:ShowHitmarker( hs )

	net.Start( "Hitmarker" )
		net.WriteBit( hs and true or false )
	net.Send( self )
	
end

util.AddNetworkString( "UpdateModelScale" )

function meta:MakeJuggernaut()
	
	self:StripWeapons()
	self:RemoveAllAmmo()
	
	local scale = 1.2
	
	--self:SetModelScale(scale,0)
	
	net.Start("UpdateModelScale")
		net.WriteDouble(scale)
		net.WriteEntity(self)
	net.Broadcast()
	
	self:SetBloodColor(BLOOD_COLOR_MECH)
	
	self:Give("dd_sawlauncher")
	
	self:SetJumpPower(90)
	
	--self:SetWalkSpeed(165)
	--self:SetRunSpeed(165)	
	--GAMEMODE:SetPlayerSpeed( self, 165, 165 )
	self:SetTotalSpeed(165)
	
	local health = 1300
	
	self:SetHealth( health )
	self:SetMaxHealth( health )
	self:SetMaxHealthClient( health )
	
	self:SetDTBool(3,true)
	
end

util.AddNetworkString( "SetTotalSpeed" )

function meta:SetTotalSpeed(speed,runspeed)

	if not runspeed then runspeed = speed end
	
	self:SetWalkSpeed(speed)
	self:SetRunSpeed(runspeed)
	
	//net.Start("SetTotalSpeed")
	//	net.WriteDouble(speed)
	//	net.WriteDouble(runspeed)
	//net.Send(self)
	
end

function meta:BalanceTeams()
	if GAMEMODE:GetGametype() == "ffa" or GAMEMODE:GetGametype() == "ts" then return end
	if !TEAM_BALANCE then return end
	
	if team.NumPlayers(TEAM_SPECTATOR) >= 2 then return end
	
	local myteam = self:Team()
	local enemyteam = TEAM_RED
	if myteam == TEAM_RED then
		enemyteam = TEAM_BLUE
	end
	
	if team.NumPlayers(myteam) - team.NumPlayers(enemyteam) >= 2 then
		self:SetTeam(enemyteam)
		self:ChatPrint("You were moved into opposite team for balance!")
	end
	
end

local function PlayCommand(pl,cmd,args)
	
	if !pl:Alive() then return end
	if not args then return end
	
	local key = args[1]
	
	if not VoiceAdvanced[pl:GetVoiceSet()].Commands[key] then return end
	
	pl.NextCommand = pl.NextCommand or 0
	
	if pl.NextCommand >= CurTime() then return end
	pl.NextCommand = CurTime() + 7
	
	pl:PlaySpeech(VoiceAdvanced[pl:GetVoiceSet()].Commands[key])
	
end
concommand.Add("dd_voicecommand", PlayCommand)

/*function meta:FastWeaponSwitch()
	
	if !self:Alive() then return end
	local weps = self:GetWeapons() 
	if #weps < 2 then return end
	
	local active = self:GetActiveWeapon()
	
	for i=1, #weps do
		if weps[i] and weps[i]:IsValid() and weps[i] ~= active then
			self:SelectWeapon( weps[i]:GetClass() )
			break
		end
	end
	
end
local function FastWepSwitch(pl,cmd,args)
	
	if !pl:Alive() then return end
	
	
	pl.NextWeaponSwitch = pl.NextWeaponSwitch or 0
	
	if pl.NextWeaponSwitch >= CurTime() then return end
	pl.NextWeaponSwitch = CurTime() + 0.01
	
	pl:FastWeaponSwitch()
	
end*/
//concommand.Add("dd_weaponswitch", FastWepSwitch)

function meta:PlaySpeech(tbl)
	self:EmitSound(tbl[math.random(1,#tbl)],100,self:IsThug() and math.random(70,85) or 100)
end

function meta:OnKillSpeech()
	self:PlaySpeech(Voice[self:GetVoiceSet()].OnKill)
end

function meta:OnLevelUpSpeech()
	if Voice[self:GetVoiceSet()] and Voice[self:GetVoiceSet()].OnLevelUp then
		self:PlaySpeech(Voice[self:GetVoiceSet()].OnLevelUp)
	end
end

function meta:OnPainSpeech()
	self._NextPain = self._NextPain or 0
	if self._NextPain > CurTime() or not self:Alive() or self:IsCrow() then return end
	
	//if math.random(2) == 2 then
		self:SendLua("AddBloodSplat()")
	//end
	
	self._NextAdvPain = self._NextAdvPain or 0
	
	local hitgroup = self:LastHitGroup() or HITGROUP_GENERIC
	
	if math.random(10) == 10 and self._NextAdvPain < CurTime() and VoiceAdvanced[self:GetVoiceSet()] and VoiceAdvanced[self:GetVoiceSet()].OnPain and VoiceAdvanced[self:GetVoiceSet()].OnPain[hitgroup] then
		self:PlaySpeech(VoiceAdvanced[self:GetVoiceSet()].OnPain[hitgroup])
		self._NextAdvPain = CurTime() + 10
	else
		self:PlaySpeech(Voice[self:GetVoiceSet()].OnPain)
	end
	
	
	self._NextPain = CurTime() + 0.9
end

function meta:OnDeathSpeech()
	self:PlaySpeech(Voice[self:GetVoiceSet()].OnDeath)
end

function meta:OnKillAnimation()
	//self:SetDTFloat(0,CurTime()+6)
end

function meta:OnPainAnimation()
	//if self:GetDTFloat(1) and self:GetDTFloat(1) > CurTime() then return end
	//self:SetDTFloat(1,CurTime()+9)
end

function meta:SetRandomFace()
	
	local FlexNum = self:GetFlexNum() - 1
	if ( FlexNum <= 0 ) then return end
	
	for i=0, FlexNum-1 do
		if math.random(3) == 3 then
			self:SetFlexWeight( i, math.Rand(0,1.1) )
		end
	end
	
	self:SetFlexScale(math.random(-6,6))
	
end

function meta:SetThug()
	self:SetEffect("thug")
end




util.AddNetworkString( "SendSkillsToClient" )
function meta:SetupSkills()
	
	self.Skills = self.Skills or {
									Total = SKILL_XP_START,
									ToSpend = SKILL_XP_START,
									//["defense"] = 0,
									["magic"] = 0,
									["strength"] = 0,
									["agility"] = 0,
									XP = 0,
									Lvl = 0,
								}
								
	if self.Skills.Total > 20 then
		self.Skills = {
						Total = 20,
						ToSpend = 20,
						["magic"] = 0,
						["strength"] = 0,
						["agility"] = 0,
						XP = self.Skills.XP,
						Lvl = self.Skills.Lvl,
					}
	end
	
	if self.Skills.Total < 20 then
		self.Skills = {
						Total = 20,
						ToSpend = 20,
						["magic"] = 0,
						["strength"] = 0,
						["agility"] = 0,
						XP = self.Skills.XP,
						Lvl = self.Skills.Lvl,
					}
	end
	
	if self.Skills["magic"] and self.Skills["magic"] > SKILL_MAX_PER_TREE then
		local toremove = self.Skills["magic"]
		self.Skills.ToSpend = self.Skills.ToSpend + toremove
		self.Skills["magic"] = 0
	end
	
	if self.Skills["strength"] and self.Skills["strength"] > SKILL_MAX_PER_TREE then
		local toremove = self.Skills["strength"]
		self.Skills.ToSpend = self.Skills.ToSpend + toremove
		self.Skills["strength"] = 0
	end
	
	if self.Skills["agility"] and self.Skills["agility"] > SKILL_MAX_PER_TREE then
		local toremove = self.Skills["agility"]
		self.Skills.ToSpend = self.Skills.ToSpend + toremove
		self.Skills["agility"] = 0
	end
	
	if self.Skills.Lvl and self.Skills.Lvl == 0 and self.Skills.Total then
		self.Skills.Lvl = self.Skills.Total - SKILL_XP_START
	end
	
	//No needed anymore
	if self.Skills["defense"] and self.Skills["defense"] > 0 then
		local toremove = self.Skills["defense"]
		self.Skills.ToSpend = self.Skills.ToSpend + toremove
		self.Skills["defense"] = 0
	end
	
	//net.Start( "SendSkillsToClient" )
	//	net.WriteTable(self.Skills)
	//net.Send( self )
	
	
end

function meta:GetDefense()
	return 0//self.Skills and self.Skills.defense or 0
end

function meta:GetMagic()
	return self.Skills and self.Skills.magic or 0
end

function meta:GetStrength()
	return self.Skills and self.Skills.strength or 0
end

function meta:GetAgility()
	return 0//self.Skills and self.Skills.agility or 0
end

function meta:GetGunMastery()
	return self.Skills and self.Skills.agility or 0
end

function meta:InvestInSkill(name)
	
	if not name then return end
	if name == "defense" then return end
	if not self.Skills then return end
	if not Skills[name] or not self.Skills[name] then return end
	if self.Skills.ToSpend < 1 then return end
	if self.Skills[name] >= SKILL_MAX_PER_TREE then return end
	
	self.Skills[name] = self.Skills[name] + 1
	self.Skills.ToSpend = self.Skills.ToSpend - 1
	
	net.Start( "SendSkillsToClient" )
		net.WriteTable(self.Skills)
	net.Send( self )
	
	//PrintTable(self.Skills)
	
end

/*concommand.Add("dd_investskill",function(pl,n,args)
	
	local name = args[1]
	if not name then return end
	
	pl:InvestInSkill(name)

end)*/

function meta:RemoveFromSkill(name)
	
	if not name then return end
	if name == "defense" then return end
	if not self.Skills then return end
	if not Skills[name] or not self.Skills[name] then return end
	if self.Skills[name] < 1 then return end
	
	self.Skills[name] = self.Skills[name] - 1
	self.Skills.ToSpend = self.Skills.ToSpend + 1
	
	net.Start( "SendSkillsToClient" )
		net.WriteTable(self.Skills)
	net.Send( self )
	
	for _,skill in pairs(Abilities) do
		if skill.OnReset then
			skill.OnReset(self)
		end
	end
	
	//PrintTable(self.Skills)
	
end

/*concommand.Add("dd_removeskill",function(pl,n,args)
	
	local name = args[1]
	if not name then return end
	
	pl:RemoveFromSkill(name)

end)*/

function meta:ResetSkills()
	
	if not self.Skills then return end
	
	for name,v in pairs(Skills) do
		self.Skills[name] = 0
	end
	
	local toset = self.Skills.Total
	
	self.Skills.ToSpend = toset
	
	for _,skill in pairs(Abilities) do
		if skill.OnReset then
			skill.OnReset(self)
		end
	end
	
	net.Start( "SendSkillsToClient" )
		net.WriteTable(self.Skills)
	net.Send( self )
	
end

/*concommand.Add("dd_resetskill",function(pl,n,args)
	
	pl:ResetSkills()
	

end)*/

function meta:CheckAbilities()
	
	if not self.Skills then return end
		
	for skill,tbl in pairs(Skills) do
		
		for points,ability in pairs(tbl) do
			
			if ability and Abilities[ability] and Abilities[ability].OnSet then
				if self.Skills[skill] and self.Skills[skill] >= points then
					Abilities[ability].OnSet(self)
				end
			end
			
		end	
	end
	
	
end

//Small snippet from TeamPlay by JetBoom

function ExplosiveDamage(owner, from, maxrange, minrange, distmultiplier, dmgmultiplier, mindamage, typ, damagetype)
	local mypos
	damagetype = damagetype or DMG_BURN

	if type(from) == "Vector" then
		mypos = from
	else
		mypos = from:LocalToWorld(from:OBBCenter())
	end
	
	ExplosiveEffect(mypos, maxrange, maxrange, damagetype)

	local t = {}

	for _, ent in pairs(ents.FindInSphere(mypos, maxrange)) do
		local entpos = ent:NearestPoint(mypos)
		if TrueVisible(entpos, mypos) then
			local damage = math.max((minrange - entpos:Distance(mypos) * distmultiplier) * dmgmultiplier, mindamage)
			ent:TakeSpecialDamage(damage, damagetype, owner, typ or from, mypos)
			t[ent] = damage
		end
	end

	util.ScreenShake(mypos, minrange * 17, minrange * 10, math.Clamp(dmgmultiplier, 0.75, 2), maxrange * 2.5)

	return t
end

function ExplosiveEffect(pos, maxrange, damage, dmgtype)
	
	local e = EffectData()
		e:SetOrigin(pos)
		e:SetRadius(maxrange)
		e:SetMagnitude(damage)
		e:SetScale(dmgtype)
	util.Effect( "ExplosiveEffect", e, nil, true )
	
end

local meta = FindMetaTable( "Entity" )
if (!meta) then return end

function meta:TakeSpecialDamage(damage, damagetype, attacker, inflictor, hitpos)
	attacker = attacker or self
	if not IsValid(attacker) then attacker = self end
	inflictor = inflictor or attacker
	if not IsValid(inflictor) then inflictor = attacker end

	local dmginfo = DamageInfo()
	dmginfo:SetDamage(damage)
	dmginfo:SetAttacker(attacker)
	dmginfo:SetInflictor(inflictor)
	dmginfo:SetDamagePosition(hitpos or self:NearestPoint(inflictor:NearestPoint(self:LocalToWorld(self:OBBCenter()))))
	dmginfo:SetDamageType(damagetype)
	self:TakeDamageInfo(dmginfo)
end

/*
local keyvalues = {}
 
hook.Add("EntityKeyValue","KVFix",function(e,k,v)
 
    keyvalues[e] = keyvalues[e] or {}
    keyvalues[e][k] = v
end)
 
function meta:GetKeyValues()
 
    return keyvalues[self] or {}
end*/
