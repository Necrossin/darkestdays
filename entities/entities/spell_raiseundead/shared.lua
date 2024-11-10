ENT.Name = "Raise Undead"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 100

ENT.CastGesture = ACT_GMOD_GESTURE_BECON

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	GAMEMODE:KilliconAddSpell("npc_antlionguard","raiseundead")
	RegisterParticleEffect( "raiseundead_spawn_effect" )
end

OrbsTable = OrbsTable or {}

//models/props_borealis/borealis_door001a.mdl

PrecacheParticleSystem( "v_raiseundead" )
PrecacheParticleSystem( "raiseundead" )
PrecacheParticleSystem( "raiseundead_spawn_effect" )

local table = table
local pairs = pairs

local antspawn = Sound("weapons/physcannon/energy_sing_explosion2.wav")
local antroar = Sound("npc/ichthyosaur/attack_growl3.wav")

util.PrecacheModel("models/antlion_guard.mdl")

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end

	local aimvec = self.EntOwner:GetAimVector()
	//local trace = util.TraceLine({start = self.EntOwner:GetShootPos(), endpos = self.EntOwner:GetShootPos() + aimvec * 40, filter = self.EntOwner})
	
	
	
	//if trace.Hit and trace.HitWorld and SERVER and trace.HitNormal.z > 0.5 then
		//
	if SERVER then
		//self:CreateTrap(trace.HitPos-aimvec:Angle():Up()*50)
		for _,orb in pairs(OrbsTable) do
			if orb and IsValid(orb) and orb:GetPos():Distance(self.EntOwner:GetPos()) <= 160 and TrueVisible(self.EntOwner:GetPos(), orb:NearestPoint(self.EntOwner:GetPos())) then
				self:UseDefaultMana()
				local ant = ents.Create ("npc_antlionguard")
				if IsValid(ant) then
					ant:SetPos(orb:GetPos() + Vector(0,0,3))
					ant:SetHealth(99999999)
					ant:SetColor( team.GetColor( self.EntOwner:Team() ) )
					ant.Owner = self.EntOwner
					//ant:SetColor(Color(40,40,40,255))
					ant:SetMaterial("models/flesh")
					ant:SetKeyValue("Start burrowed", "true") 
					ant:SetKeyValue("Ignore unseen enemies", "false") 
					ant:SetKeyValue("Allow Bark", "true") 
					ant:Spawn()
					ant:Activate()
					//ant:SetCollisionGroup(COLLISION_GROUP_WEAPON)
					ant:SetGroundEntity(NULL)
					ant:SetLocalVelocity((self.EntOwner:GetShootPos()-ant:GetPos()):GetNormal()*400)
					ant:SetModelScale(0.65,0)
					
					if GAMEMODE:GetGametype() == "ffa" then
						ant:AddEntityRelationship( self.EntOwner, D_LI, 99 )
					else
						for k, v in pairs( player.GetAll() ) do
							if v and v:Team() ~= TEAM_SPECTATOR then
								if v:Team() == self.EntOwner:Team() then
									ant:AddEntityRelationship( v, D_LI, 99 )
								else
									ant:AddEntityRelationship( v, D_HT, 99 )
								end
							end
							
						end
					end
					
					
					//ant:SetModelScale(0.9,13)
					local effectdata = EffectData()
						effectdata:SetOrigin(ant:GetPos())
						effectdata:SetNormal(vector_origin)
					util.Effect("raiseundead_spawn_effect", effectdata,nil,true)
					
					ant:Fire("unburrow","",0)
					timer.Simple(math.random(14,19),function() 
						if IsValid(ant) then 
							ant:TakeDamage(ant:Health()*2,ant,nil) 
							local dissolve = ents.Create( "env_entity_dissolver" )
							dissolve:SetPos( ant:GetPos()+vector_up*60 )
							local targname = "dis"..ant:EntIndex()
							ant:SetName(targname)
							dissolve:SetKeyValue( "target", targname )
							dissolve:SetKeyValue( "dissolvetype", 1 )
							dissolve:SetKeyValue( "magnitude", 0 )
							dissolve:Spawn()
							dissolve:Fire( "Dissolve", targname, 0 )
							dissolve:Fire( "kill", "", 1 )
						end 
					end)
					ant:EmitSound(antspawn,math.random(80,100),math.random(80,100))
					ant:EmitSound(antroar,math.random(90,240),math.random(70,100))
									
					util.ScreenShake( orb:GetPos() + Vector(0,0,3), math.random(3,6), math.random(3,4), math.random(2,3), 170 )
				end
				orb:Remove()
				break
			end
		end
	end
	//else
		//self.EntOwner._efCantCast = CurTime() + 1
	//end
	

end

if CLIENT then

function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:OnThink()
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner:StopParticles()
	end
end

function ENT:OnDraw()
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
	
	if MySelf == owner and not GAMEMODE.ThirdPerson then
		if self.Particle then
			self.Particle = nil
			owner:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("raiseundead",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end	
end

function ENT:HandDraw(owner,reverse,point)
	
	if point and not point.Particle then
		ParticleEffectAttach("v_raiseundead",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end

end
end





