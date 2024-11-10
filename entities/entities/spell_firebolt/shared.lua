ENT.Name = "Fire Bolt"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 45
ENT.Damage = 35

game.AddParticles("particles/fire_01.pcf" )


PrecacheParticleSystem( "fire_medium_01" )

PrecacheParticleSystem( "firebolt2" )
PrecacheParticleSystem( "v_firebolt2" )
PrecacheParticleSystem( "burningplayer" )
PrecacheParticleSystem( "firebolt_projectile" )



if CLIENT then
	GAMEMODE:KilliconAddSpell("spell_firebolt","firebolt")
	GAMEMODE:KilliconAddSpell("effect_afterburn","firebolt")
	GAMEMODE:KilliconAddSpell("projectile_firebolt","firebolt")
	RegisterParticleEffectAttach( "burningplayer" )
end

if SERVER then
	AddCSLuaFile("shared.lua")
end

local ents = ents
util.PrecacheSound("ambient/fire/gascan_ignite1.wav")

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	/*local aimvec = self.EntOwner:GetAimVector()
	local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 850, filter = self.EntOwner})*/
	
	
	/*local tr = {}
	local offset = self.EntOwner:GetAimVector():Angle():Right()*8
	tr[1] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * 800, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Right()*-8
	tr[2] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * 800, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Up()*8
	tr[3] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * 800, filter = self.EntOwner})
	offset = self.EntOwner:GetAimVector():Angle():Up()*-8
	tr[4] = util.TraceLine({start = self.EntOwner:GetShootPos()+offset, endpos = self.EntOwner:GetShootPos()+offset+ aimvec * 800, filter = self.EntOwner})
	
	for i=1,4 do
		if tr[i].Hit and ValidEntity(tr[i].Entity) and not tr[i].Entity:IsWorld() then
			trace = tr[i]
			break
		end
	end*/
	
	/*local tr = {}
	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * distance
	tr.mins = Vector(-22,-22,-14)
	tr.maxs = Vector(22,22,14)
	tr.filter = self.EntOwner
	
	tr = util.TraceHull(tr)
	
	if tr.Hit and ValidEntity(tr.Entity) and not tr.Entity:IsWorld() then
		trace = tr
	end
	
	local pos = trace.HitPos
	local norm = vector_origin
	
	if trace.HitNormal then
		norm = trace.HitNormal
	end
	
	local targets = ents.FindInSphere( pos+norm*3, 30 )
	*/
	if SERVER then
		self:UseDefaultMana()
		
		
		
		self:CreateProjectile()
		
		
		/*if ValidEntity(trace.Entity) and trace.Entity:GetClass() == "projectile_cyclonetrap" and trace.Entity:Team() == self.EntOwner:Team() and not (trace.Entity:GetDTBool(0) or trace.Entity:GetDTBool(2)) then
			trace.Entity:SetDTBool(1,true)
			return 
		end
		
		for k, guy in pairs(targets) do
				if guy:IsPlayer() and (guy == self.EntOwner or guy:Team() ~= self.EntOwner:Team()) then
				
					local trace = {}
					trace.start = pos
					trace.endpos = guy:GetPos() + Vector ( 0,0,40 )
					--trace.filter = pl
					
					local tr = util.TraceLine( trace )
					
					if tr.Entity:IsValid() and tr.Entity == guy then
						local Dmg = DamageInfo()
						Dmg:SetAttacker(self.EntOwner)
						Dmg:SetInflictor(self.Entity)
						Dmg:SetDamage(math.random(45,50))
						Dmg:SetDamageType(DMG_BURN)
						Dmg:SetDamagePosition(pos)	
						
						local fire = guy:SetEffect("afterburn")
						fire.EntAttacker = self.EntOwner
						guy:TakeDamageInfo(Dmg)
						
						
					end
				end
			end
		*/
		//local e = EffectData()
		//e:SetOrigin(pos)
		//util.Effect("fire_explosion",e,true,true)
	end
end

function ENT:CreateProjectile()
	
	local trap = ents.Create("projectile_firebolt")
	local v = self.EntOwner:GetShootPos()
	v = v + self.EntOwner:GetForward() * 8
	v = v + self.EntOwner:GetRight() * -3
	v = v + self.EntOwner:GetUp() * -3
	if IsValid(trap) then
		trap:SetPos(v)
		trap.EntOwner = self.EntOwner
		trap:SetOwner(self.EntOwner)
		trap:Spawn()
		
		local phys = trap:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			//phys:EnableGravity(false)
			//phys:SetVelocity((self.EntOwner:GetAimVector()) * 900)
			phys:ApplyForceCenter(self.EntOwner:GetAimVector() * 900)
		end
	end
	
end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnThink()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

function ENT:OnDraw()
	if self:GetPos():Distance(EyePos()) > 1190 then return end
	local owner = self.EntOwner
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if self.Particle and MySelf == owner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		owner:StopParticles()
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("firebolt2",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		--point:EmitSound("ambient/fire/gascan_ignite1.wav",math.random(100,120),math.random(100,130))
		ParticleEffectAttach("v_firebolt2",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	local bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Right_Hand"}
	
	if reverse then
		bones = {"ValveBiped.Bip01_L_Hand","v_weapon.Left_Hand"}
	end
	
	/*local vm = owner:GetViewModel()
	
	if vm and vm:IsValid() then
		
		for k, v in pairs( bones ) do
			local bone = vm:LookupBone(v)
			
			if bone then
				local pos, ang = vm:GetBonePosition(bone)
				
				local dlight = DynamicLight( vm:EntIndex() )
				if ( dlight ) then
					dlight.Pos = pos+ang:Forward()*2
					dlight.r = 255
					dlight.g = 255
					dlight.b = 50
					dlight.Brightness = 1
					dlight.Size = 20
					dlight.Decay = 20 * 5
					dlight.DieTime = CurTime() + 1
					dlight.Style = 0
				end
			end
		end
	end*/

end

end





