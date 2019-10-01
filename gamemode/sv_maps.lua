MapCycle = {}
MapCycleRaw = {}
MapCycleRawString = nil
MapCycleBackup = {}
MapCycleLimits = {}

GM.MapCyclePassword = nil
GM.AllowMapCycleEditing = GM.AllowMapCycleEditing or {}

local tab
local function AddMap( name, minpl, maxpl )
	tab = { map = name, minplayers = minpl, maxplayers = maxpl }
	table.insert(MapCycleBackup,name)
	MapCycleLimits[name] = {minplayers = minpl, maxplayers = maxpl}
end

//default list of maps
AddMap( "dm_outlying_v2", 8, 99)
AddMap( "dm_A_lesser_fate", 0, 99)
AddMap( "dm_abyss", 8, 99)
AddMap( "dm_shockstreet_b2", 6, 99)
AddMap( "dm_biohazard", 0, 99)
AddMap( "de_nightfever", 10, 99)
AddMap( "dm_filth_v1", 0, 99)
AddMap( "dm_backbone", 10, 99)
AddMap( "dm_torque", 5, 99)
AddMap( "dm_astera", 4, 99)
AddMap( "dm_datacore", 6, 99)
AddMap( "dm_zest", 0, 99)
AddMap( "dm_lockdown", 0, 99)
AddMap( "dm_7hour", 10, 99)
AddMap( "dm_raven", 0, 99)
AddMap( "dm_thorn", 0, 99)
AddMap( "dm_resistance", 5, 99)
AddMap( "dm_damage_inc", 10, 99)
AddMap( "dm_energize_b1", 8, 99)
AddMap( "dm_hell_night_v1", 10, 99)
AddMap( "ts_steel", 0, 10)
AddMap( "dm_stad", 6, 99)
AddMap( "dm_instant", 5, 99)
AddMap( "fy_highrise_09", 0, 99)
AddMap( "dm_postoffice", 0, 99)
AddMap( "dm_steamlab", 0, 99)
AddMap( "dm_sordid_b3", 0, 99)
AddMap( "cs_office", 2, 99)
AddMap( "fy_forest", 0, 99)
AddMap( "dm_phallan", 4, 99)
AddMap( "dm_villa_b3", 6, 99)
AddMap( "dm_balcony_beta4", 0, 99)
AddMap( "dm_plaza17", 8, 99)
AddMap( "dm_cloudcity", 14, 99)
AddMap( "dm_border_bust", 0, 99)
AddMap( "dm_cigaro", 0, 99)
AddMap( "dm_megawatt", 0, 99)
AddMap( "dm_dust_housing_estate4", 4, 99)
AddMap( "fy_garage", 7, 99)
AddMap( "dm_derelict_final", 5, 99)
//AddMap( "dm_clocks", 8, 99)
AddMap( "dm_detritus_v2", 0, 99)
AddMap( "dm_moil_final", 0, 99)
AddMap( "dm_hellhole_b94b", 6, 99)
AddMap( "dm_facility_beta", 0, 99)
AddMap( "dm_rebels_2", 0, 99)
AddMap( "dm_avalon", 4, 99)
AddMap( "dd_ironisle_v2", 0, 99)
AddMap( "dm_powerhouse", 11, 99)
AddMap( "dm_scepter", 0, 99)
AddMap( "dm_trainyard", 9, 99)
AddMap( "dm_3006_beta1", 6, 99)
AddMap( "dm_archt", 8, 99)
AddMap( "dm_area22", 8, 99)
AddMap( "dm_cannon_r1", 0, 99)
AddMap( "dm_casual", 8, 99)
AddMap( "dm_closecombat", 0, 99)
AddMap( "dm_corrodeb5", 6, 99)
AddMap( "dm_fallout", 4, 99)
AddMap( "dm_greenhouse", 0, 99)
AddMap( "dm_gunshotbeta4", 4, 99)
AddMap( "dm_insomnia_v1", 5, 99)
AddMap( "dm_laststop", 5, 99)
AddMap( "dm_lostarena", 0, 99)
AddMap( "dm_loststation", 4, 99)
AddMap( "dm_metro", 4, 99)
AddMap( "dm_necessity", 3, 99)
AddMap( "dm_six", 10, 99)
AddMap( "dm_suspended", 11, 99)
AddMap( "dm_thefactory", 9, 99)
AddMap( "dm_thumper", 0, 99)
AddMap( "dm_tobor", 0, 99)
AddMap( "dm_tower_arena_v2", 0, 99)
AddMap( "dm_transport", 14, 99)
AddMap( "dm_underpass", 5, 99)
AddMap( "de_nuke", 10, 99)
AddMap( "de_inferno", 5, 99)
AddMap( "de_train", 8, 99)
AddMap( "dm_bridge_b2", 16, 99)
AddMap( "dm_amplitude", 4, 99)
AddMap( "dm_downtown", 6, 99)
AddMap( "dm_graveyard", 16, 99)
AddMap( "cs_pariah", 0, 99)
AddMap( "dm_overwatch", 0, 99)
//AddMap( "dm_runoff", 3, 99)
AddMap( "cs_apartments", 4, 99)
AddMap( "fy_skystep", 4, 99)
AddMap( "de_industry", 5, 99)
AddMap( "dd_darkest_days", 0, 99)



----------------------
function GM:SetMapList()
	
	if not MapCycle then return end
	
	if not self.MapCyclePassword then
		if file.Exists( "darkestdays/dd_mapcycle_access.txt", "DATA" ) then
			local pass = file.Read( "darkestdays/dd_mapcycle_access.txt" )
			pass = string.gsub( pass, " ", "" )
			pass = string.gsub( pass, "\n", "" )
			if pass ~= "" then
				self.MapCyclePassword = pass
			end
		end
	end
	
	local hasfolder = file.IsDir( "darkestdays", "DATA" )
	
	if not hasfolder then
		file.CreateDir( "darkestdays" )
	end
	
	//no mapcycle file
	if not file.Exists( "darkestdays/dd_mapcycle.txt", "DATA" ) then
		
		local data = ""
		
		for k, v in pairs( MapCycleBackup ) do
			if k == 1 then
				data = v
			else
				data = data.."\n"..v
			end
		end
		
		file.Write( "darkestdays/dd_mapcycle.txt", data )
	end
		
	
	local raw_data = file.Read( "darkestdays/dd_mapcycle.txt" )
	raw_data = string.gsub( raw_data, " ", "" )
	
	MapCycleRawString = raw_data		
	MapCycle = string.Explode( "\n", raw_data )
		
	for k, v in pairs( MapCycle ) do
		//MapCycleRaw[ k ] = v
		if v and !file.Exists( "maps/"..v..".bsp", "GAME" ) then
			MapCycle[k] = nil
			//print( "Removing map "..v )
		end
	end
	
	if game.GetMap() == "dm_lockdown" then
		//table.Shuffle(MapCycle)
	end

	table.Resequence ( MapCycle )

end


VoteMaps = {}
function GM:GetVoteMaps()
	local map = game.GetMap()
	local players = #player.GetAll()
	
	local mappos = 0
	for k, v in pairs (MapCycle) do
		if v == map then
			mappos = k
		end
	end

	for k = 1, (#MapCycle - 1) do
		if MapCycle[mappos + 1] == nil then
			mappos = 0
		end
			
		local nextmap = MapCycle[mappos + 1]
		if #VoteMaps < MAX_VOTEMAPS then
			//if MapCycleLimits and MapCycleLimits[nextmap].minplayers <= #player.GetAll() and MapCycleLimits[nextmap].maxplayers >= #player.GetAll() or players == 0 then
				table.insert ( VoteMaps, nextmap )
			//end
		end	
		mappos = mappos + 1
	end
	
	if #VoteMaps == 0 then 
		local mappos = 0
		for k, v in pairs (MapCycle) do
			if v == map then
				mappos = k
			end
		end
		
		for k = 1, (#MapCycle - 1) do
			if MapCycle[mappos + 1] == nil then
				mappos = 0
			end
				
			local nextmap = MapCycle[mappos + 1]
			if #VoteMaps < MAX_VOTEMAPS then
				table.insert ( VoteMaps, nextmap )
			end
				
			mappos = mappos + 1
		end
	end
	
	/*if players == 0 then
		VoteMaps = {}
	
		for k,v in pairs ( MapCycle ) do
			if math.random ( 1, 2 ) == 1 and #VoteMaps < 4 then
				table.insert ( VoteMaps, v )
			end
		end
	end*/
	
	//table.Shuffle(VoteMaps)

	return VoteMaps
	
end

local function RequestMapCycleEditor( pl, cmg, args )
	
	local allow = false
	
	if pl:IsAdmin() then allow = true end
	
	if GAMEMODE.MapCyclePassword and args and args[1] and GAMEMODE.MapCyclePassword == tostring( args[1] ) then
		if not GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then
			GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] = true
		end
	end
	
	if GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then allow = true end
	
	if not allow then return end
	
	GAMEMODE:SendMapCycleToClient( pl )
	
end
concommand.Add( "dd_mapcycle", RequestMapCycleEditor )


util.AddNetworkString( "SendMapCycleToClient" )
util.AddNetworkString( "SendMapCycleToServer" )

function GM:SendMapCycleToClient( pl )

	if MapCycleRawString then
				
		local compressed = util.Compress( MapCycleRawString ) 
		local len = string.len( compressed )
		
		net.Start( "SendMapCycleToClient" )
			net.WriteInt( len, 32 )
			net.WriteData( compressed, len )
		net.Send( pl )
	
	end

end

net.Receive( "SendMapCycleToServer", function( len, pl )

	local allow = false
	
	if pl:IsAdmin() then allow = true end
	if GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then allow = true end
	
	if not allow then return end

	local data_len = net.ReadInt( 32 )
	local data = net.ReadData( data_len )
	local decompressed = util.Decompress( data )
	
	file.Write( "darkestdays/dd_mapcycle.txt", decompressed )
	
	GAMEMODE:SetMapList()
	
	pl:ChatPrint( "Map Cycle was successfully updated!" )
	
end)