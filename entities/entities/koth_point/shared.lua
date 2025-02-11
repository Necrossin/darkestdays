ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

//TEAM_RED is 1
//TEAM_BLUE is 2
//REMEMBER!
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
	util.PrecacheSound("ambient/machines/teleport"..i..".wav")
end

function ENT:Initialize()

	
	if SERVER then
		self:SetPos(self:GetPos()+vector_up*2)
		/*self:SetModel("models/Items/BoxMRounds.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )*/
	
		self.Entity:DrawShadow(false)
		game.GetWorld():SetDTEntity(0,self.Entity)
		
		self:SetTeamTimer(self:TeamToHill(TEAM_RED),KOTH_HILL_TIME)
		self:SetTeamTimer(self:TeamToHill(TEAM_BLUE),KOTH_HILL_TIME)
		
		self:SetStartTime(CurTime() + 80)
		self:SetPointTime(CurTime()+80+math.random(35,60))
		
		self.Swaps = 0
	end
	
end

function ENT:OnRemove()

end

function ENT:Think()
	if SERVER then
		if not self:IsActive() then 
			if self:IsBeingHeld() then
				self:SetHoldingTeam()
			end
			return
		end
		
		local ct = CurTime()
		
		self:MoveHill()
		
		--local red, blue, red_am, blue_am = self:GetPlayersOnPoint()
		local red, blue = self:GetPlayersOnPoint()
		local red_am, blue_am = #red, #blue
		
		self.CapturePoints = self.CapturePoints or 0
		
		if red_am > 0 and blue_am == 0 then
			self:SetHoldingTeam(TEAM_RED)
			if self.CapturePoints == 0 then
				self.CapturePoints = ct + 10
			end
		elseif red_am == 0 and blue_am > 0 then
			self:SetHoldingTeam(TEAM_BLUE)
			if self.CapturePoints == 0 then
				self.CapturePoints = ct + 10
			end
		else
			self:SetHoldingTeam()
			self.CapturePoints = 0
		end
		
		if self:IsBeingHeld() then
			
			self.NextTick = self.NextTick or 0
			
			if self.NextTick <= ct then
				//print("tick")
				self:DrainTeamTimer(self:GetHoldingTeam())
			
				self.NextTick = ct + self:GetTickAmount(self:GetHoldingTeam())
				//self.NextTick = ct + 1
			end
			
			if self.CapturePoints ~= 0 and self.CapturePoints <= ct and #player.GetAll() > 1 then
				if self:GetHoldingTeam() == 1 then
					--for _,p in pairs(red) do
						--if IsValid( p ) then
							--p:AddXP(8)
						--end
					--end
				end
				if self:GetHoldingTeam() == 2 then
					--if IsValid( p ) then
						--p:AddXP(8)
					--end
				end
				self.CapturePoints = ct + 10
			end
		
		end
		
		--print("Red "..ToMinutesSeconds( self:GetTeamTimer(1) ).." | Blue "..ToMinutesSeconds( self:GetTeamTimer(2) ))
		
		--print("Red "..red_am.." | Blue "..blue_am)
	end
end

local function CheckZ(p,hill)
	local result = false
	if p:GetPos().z >= hill:GetPos().z - 50 and p:GetPos().z <= hill:GetPos().z + 80 then
		result = true
	end
	return result
end

local players = {}
local player_GetAll = player.GetAll
local function InsertTBL(tbl, player)
    tbl[#tbl + 1] = player
end

function ENT:GetPlayersOnPoint()
   
    players[TEAM_RED] = {}
    players[TEAM_BLUE] = {}

   // for _, p in ipairs(player_GetAll()) do
	for i = 1, #player_GetAll() do
		local p = player_GetAll()[ i ]
        if p:IsValid() and p:Alive() and not p:IsCrow() and self:GetPos():DistToSqr(p:GetPos()) <= self:GetRadiusSqr() and CheckZ(p, self.Entity) then
            local team = p:Team()
            if (team == TEAM_RED or team == TEAM_BLUE) then
                InsertTBL(players[team], p)
            end
        end
    end

    return players[TEAM_RED], players[TEAM_BLUE]
end

/*function ENT:GetPlayersOnPoint()
	
	local all = player.GetAll()
	local red_am = 0
	local blue_am = 0
	
	if players[TEAM_RED] then
		--table.Empty(players[TEAM_RED])
	else
		players[TEAM_RED] = {}
	end
	
	if players[TEAM_BLUE] then
		--table.Empty(players[TEAM_BLUE])
	else
		players[TEAM_BLUE] = {}
	end
	
	for _,p in ipairs( all ) do
		if IsValid( p ) then
			if p:Alive() and !p:IsCrow() and self:GetPos():DistToSqr(p:GetPos()) <= self:GetRadiusSqr() and CheckZ(p,self.Entity) then
				if p:Team() == TEAM_RED then
					red_am = red_am + 1
					players[ TEAM_RED ][ p:EntIndex() ] = p
					players[ TEAM_BLUE ][ p:EntIndex() ] = nil
				end

				if p:Team() == TEAM_BLUE then
					blue_am = blue_am + 1
					players[ TEAM_BLUE ][ p:EntIndex() ] = p
					players[ TEAM_RED ][ p:EntIndex() ] = nil
				end
				--table.insert(players[p:Team()],p)
			else
				players[ p:Team() ][ p:EntIndex() ] = nil
			end
		end
	end
	
	return players[TEAM_RED], players[TEAM_BLUE], red_am, blue_am
	
end*/

function ENT:TeamToHill(tm)
	return TeamOfHill[tm]
end

function ENT:HillToTeam(htm)
	return HillOfTeam[htm]
end

function ENT:SetHoldingTeam(tm)
	local t = 0
	if tm then 
		t = self:TeamToHill(tm)
	end
	self:SetDTInt(0,t)
end

function ENT:GetHoldingTeam()
	return self:GetDTInt(0)
end

function ENT:IsBeingHeld()
	return self:GetHoldingTeam() ~= 0
end

function ENT:SetTeamTimer(tm,time)
	self:SetDTFloat(tm,time)
end

function ENT:GetTeamTimer(tm)
	return self:GetDTFloat(tm)
end

function ENT:GetTickAmount(tm)
	local am = 1
	local need = false
	
	local myteam = self:HillToTeam(tm)
	local otherteam = TEAM_RED
	if myteam == otherteam then
		otherteam = TEAM_BLUE
	end
	
	local hmyteam = self:TeamToHill(myteam)
	local hotherteam = self:TeamToHill(otherteam)
	
	if (team.NumPlayers(myteam) < team.NumPlayers(otherteam) or team.GetScore(myteam) < team.GetScore(otherteam)) and 
		self:GetTeamTimer(hmyteam) > self:GetTeamTimer(hotherteam) and self.Swaps and self.Swaps > 3 then
		am = 0.45
		need = true
	end
	
	local haste,hasteAm = self:IsHasteMode()
	if haste then
		if need then
			am = am * hasteAm
		else
			am = hasteAm
		end
	end
	
	return am or 1
	
end

function ENT:IsHasteMode()
	
	local result,am = false,1
	
	local all = player.GetAll()
	
	if #all <= 4 then
		result,am = true,0.7
		if #all <= 3 then
			result,am = true,0.6
			if #all <= 2 then
				result,am = true,0.5
				if #all <= 1 then
					result,am = true,0.4
				end
			end
		end
	end
	return result,am
end

function ENT:DrainTeamTimer(tm)
	self:SetTeamTimer(tm,math.Clamp(self:GetTeamTimer(tm) - 1, 0,999999))
end

function ENT:SetPointTime(time)
	self:SetDTFloat(0,time)
end

function ENT:GetPointTime()
	return self:GetDTFloat(0)
end

function ENT:SetRadius(am)
	self:SetDTInt(1,am)
	self:SetDTInt(2,am * am)
end

function ENT:GetRadius()
	return self:GetDTInt(1)
end

function ENT:GetRadiusSqr()
	return self:GetDTInt(2)
end

function ENT:IsActive()
	return self:GetDTFloat(3) < CurTime()
end

function ENT:SetStartTime(time)
	self:SetDTFloat(3,time)
end

function ENT:SetPointIndex( ind )
	self:SetDTInt( 3, ind )
end

function ENT:GetPointIndex()
	return self:GetDTInt( 3 )
end

function ENT:GetStartCooldown()
	return math.Round( math.Clamp( self:GetDTFloat(3) - CurTime(), 0, 100 ) ) 
end

function ENT:MoveHill()
	
	if not KOTHPoints then return end
	if #KOTHPoints < 1 then return end
	
	if self:GetPointTime() <= CurTime() then
		
		self:SetPointTime(CurTime()+math.random(35,60))
		
		local ind = math.random(1,#KOTHPoints)
		
		if ind == self.LastInd then
			if ind == #KOTHPoints then 
				ind = 1
			else
				ind = ind + 1
			end
		end
		
		local rand = KOTHPoints[ind]
		
		self:SetPos( rand.Pos )
		self:SetRadius( rand.R )
		self.LastInd = ind

		self:SetPointIndex( ind )
		
		sound.Play("ambient/machines/teleport"..math.random(3,4)..".wav",rand.Pos,140,100,1)
		
		self.Swaps = self.Swaps + 1
		
		GAMEMODE:HUDMessage(nil, "obj_koth_reset", nil, 0)
		
		self:SetStartTime(CurTime() + 10)
		self:SetHoldingTeam()
	end
	
end

function GetHillEntity()
	if SERVER then return game.GetWorld():GetDTEntity(0) end
	if CLIENT then return Entity(0):GetDTEntity(0) end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

if !CLIENT then return end

local vec_mins, vec_maxs = Vector( -300, -300, -50 ), Vector( 300, 300, 250 )
ENT.RadiusVec = Vector( 10, 0, 0 )
ENT.HoldColor = color_white
ENT.CurColor = Color( 255, 255, 255, 55 )
	
local ring = Material( "sgm/playercircle" )
	

ENT.EdgePoints = {}
ENT.Segments = 20

local ground_check = { mask = MASK_SOLID_BRUSHONLY }

function PointOnCircle( ang, radius )
    ang = math.rad( ang )
    local x = math.cos( ang ) * radius
    local y = math.sin( ang ) * radius
    return x, y
end

function ENT:BuildEdges()

	if self.EdgePoints and self.EdgePoints[ self:GetPointIndex() ] then return end

	local tbl = {}

    local center = self:GetPos() + vector_up * 15
    local radius = self:GetRadius()
    local segments = self.Segments

    local prev_pos = nil

    local ground_level = center.z

    ground_check.start = center
    ground_check.endpos = center - vector_up * 40

    local tr = util.TraceLine( ground_check )

    if tr.HitWorld then
        ground_level = (tr.HitPos + tr.HitNormal * 3).z
    end

    for a = 1, 360, 360 / segments do
        local x, y = PointOnCircle( a, radius )

        -- wall check
        ground_check.start = center
        ground_check.endpos = center + Vector( x, y, 0 )

        tr = util.TraceLine( ground_check )

        ground_check.start = center + Vector( x, y, 0 ) + vector_up * 30
       
        if tr.HitWorld and tr.HitNormal.z < 0.3 and tr.HitNormal.z > -0.3 then
            ground_check.start = tr.HitPos + tr.HitNormal * 3
        end

        ground_check.endpos = ground_check.start - vector_up * 150

        tr = util.TraceLine( ground_check )

        local pos = tr.HitPos + tr.HitNormal * 3

        if tr.HitWorld then
            table.insert( tbl, 1, pos )
        else
            if prev_pos then
                local len = math.abs( prev_pos.z - pos.z )
                ground_check.start = pos + ( pos - center ):GetNormal() * 2 + vector_up * len * 0.8
                ground_check.endpos = center

                tr = util.TraceLine( ground_check )

                if tr.HitWorld then
                    pos = tr.HitPos + tr.Normal * 2
                    pos.z = ground_level
                    table.insert( tbl, 1, pos )
                end
            end
        end

        prev_pos = pos * 1
	end

	self.EdgePoints[ self:GetPointIndex() ] = { gnd_lvl = ground_level, points = tbl, num_points = #tbl }

end

local beam_col = Color( 255, 255, 255, 255 )
function ENT:DrawBeams()
	if self.EdgePoints and !self.EdgePoints[ self:GetPointIndex() ] then return end

	local tbl = self.EdgePoints[ self:GetPointIndex() ]

	local num = tbl.num_points + 1

	beam_col.r, beam_col.g, beam_col.b = 255, 255, 255

	if self:IsBeingHeld() then
		if self:GetHoldingTeam() == 1 then
			beam_col.r, beam_col.g, beam_col.b = 250, 40, 40
		elseif self:GetHoldingTeam() == 2 then
			beam_col.r, beam_col.g, beam_col.b = 0, 121, 250
		end
	end

	local hover = ( math.sin( RealTime() * 2 ) * 2 + 4 ) * vector_up

	render.SetColorMaterial()
	render.StartBeam( num + 1 )

	for i = 1, num do
		local point = tbl.points[ i ] or tbl.points[ 1 ]
		render.AddBeam( point + hover, 3, 0, beam_col )
	end
	-- hide the seam with extra segment
	render.AddBeam( tbl.points[ 2 ] + hover, 3, 0, beam_col )

	render.EndBeam()

end

function ENT:RebuildMesh()

	if self.EdgePoints and !self.EdgePoints[ self:GetPointIndex() ] then return end

	local tbl = self.EdgePoints[ self:GetPointIndex() ]

	if !IsValid( self.Mesh ) then
		self.Mesh = Mesh()
	end

	local num = tbl.num_points + 1
	local start = self:GetPos()
	start.z = tbl.gnd_lvl

	mesh.Begin( self.Mesh, MATERIAL_POLYGON, num + 1 )

	mesh.Position( start )
	mesh.Color( beam_col.r, beam_col.g, beam_col.b, 35 )
	mesh.AdvanceVertex()

	for i = 1, num do
        mesh.Position( tbl.points[ i ] or tbl.points[ 1 ] )
        mesh.Color( beam_col.r, beam_col.g, beam_col.b, 35 )
        mesh.AdvanceVertex()
    end

    mesh.End()

end

function ENT:DrawMesh()
    
    render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	
	render.SetStencilEnable(true)
	
	render.SetStencilReferenceValue(1)
    
    render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_REPLACE )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	
	render.SetBlend(0)
	self:DrawMask( true )
	render.SetBlend(1)

    render.SetStencilReferenceValue(2)
	
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_DECR )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	
	render.SetBlend(0)
	self:DrawMask( false )
	render.SetBlend(1)

    render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilPassOperation( STENCIL_REPLACE )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	
	render.SetStencilReferenceValue(1)
    
    if IsValid( self.Mesh ) then
        render.SetColorMaterial()
        cam.IgnoreZ( true )
        self.Mesh:Draw()
        cam.IgnoreZ( false )
    end

	render.SetStencilEnable(false)
end

function ENT:DrawMask( flip )

    render.SetColorMaterial()

    local pos = self:GetPos()

    if flip then
        render.CullMode( MATERIAL_CULLMODE_CW )
    end

    render.DrawSphere( pos, self:GetRadius(), self.Segments, self.Segments, Color(255, 255, 255, 0) )

    if flip then
        render.CullMode( MATERIAL_CULLMODE_CCW )
    end
end


function ENT:Draw()

	self:SetRenderBounds( vec_mins, vec_maxs )

	self:BuildEdges()

	self:RebuildMesh()
	self:DrawMesh()

	self:DrawBeams()

end


/*function ENT:DrawRing()
	
	local col = self.HoldColor
	
	if self:IsBeingHeld() then
		if self:GetHoldingTeam() == 1 then
			col.r, col.g, col.b = 250, 40, 40
		elseif self:GetHoldingTeam() == 2 then
			col.r, col.g, col.b = 0, 121, 250
		end
	else
		col.r, col.g, col.b = 255, 255, 255
	end
	
	col.a = 55
	
	self.CurColor.r = math.Approach( self.CurColor.r, col.r, RealFrameTime() * 900 )
	self.CurColor.g = math.Approach( self.CurColor.g, col.g, RealFrameTime() * 900 )
	self.CurColor.b = math.Approach( self.CurColor.b, col.b, RealFrameTime() * 900 )
	
	self.CurColor.a = col.a
	
	render.SetMaterial( ring )
	render.DrawQuadEasy( self:GetPos(), vector_up, self:GetRadius() * 2.1, self:GetRadius() * 2.1, self.CurColor, 0 )
	
end
	
function ENT:Draw()
		
	local radius = self:GetRadius()
	self.LastRadius = self.LastRadius or radius
		
	self:SetRenderBounds( vec_mins, vec_maxs )
	
	local eff = "hill_neutral"
	
	if self:IsBeingHeld() then
		if self:GetHoldingTeam() == 1 then
			eff = "hill_red"
			elseif self:GetHoldingTeam() == 2 then
			eff = "hill_blue"
		end
	end
		
	if self.Effect ~= eff then
		self.Effect = eff
		if IsValid( self.Particle ) then
			self.Particle:StopEmissionAndDestroyImmediately()
			self.Particle = nil
		end
	end
	
	self:DrawRing()
	
	if !IsValid( self.Particle ) then
		self.Particle = self:CreateParticleEffect( self.Effect, 0, {} )
		self.Particle:SetShouldDraw( false )
		return
	end
	
	self.RadiusVec.x = self:GetRadius()
	self.Particle:SetControlPoint( 0, self:GetPos() )
	self.Particle:SetControlPoint( 2, self.RadiusVec )
	
	self.Particle:Render()
		
end*/