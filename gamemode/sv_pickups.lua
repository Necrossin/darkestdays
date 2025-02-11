MapPickups = {}

GM.ConquestPoints = {}

GM.GametypeRounds = {}

LOADED_PICKUPS = false


function GM:LoadMapPickups()
	
	local filename = "darkestdays/pickups/".. game.GetMap() ..".txt"
	
	if file.Exists(filename,"DATA") then
		--local tbl = Json.Decode(file.Read(filename,"DATA"))
		local tbl = util.JSONToTable(file.Read(filename,"DATA"))
		
		MapPickups = table.Copy(tbl)
		
		for i,pickup in pairs(MapPickups) do
			local tblpos = pickup.Pos
			local pos = Vector(tblpos[1],tblpos[2],tblpos[3])
			local pk = pickup.Type
			
			local ent = ents.Create(pk)
			ent:SetPos(pos)
			ent:Spawn()
			ent:Activate()
			
		end
		
		LOADED_PICKUPS = true
		
		print("--> Loaded Map Pickups!")
	end
	
end

KOTHPoints = {}

local function AddPointsToPVS( pl )
	
	for _, pos in ipairs(KOTHPoints) do
		AddOriginToPVS( pos.Pos )
	end
end

function GM:LoadKOTHPoints()
	
	self.ConquestPoints = {}
	
	local hasfolder = file.IsDir( "darkestdays/koth_points", "DATA" )
	
	if not hasfolder then
		file.CreateDir( "darkestdays/koth_points" )
	end
	
	local filename = "darkestdays/koth_points/".. game.GetMap() ..".txt"
	
	local stuff_exists = false
	local to_check

	print"-- Checking KOTH Points"
	
	if file.Exists(filename,"DATA") then
		to_check = file.Read(filename,"DATA")
		stuff_exists = true
		print"File exists, using file"
	else
		if self.DefaultKOTHPoints and self.DefaultKOTHPoints[game.GetMap()] then
			to_check = self.DefaultKOTHPoints[game.GetMap()]
			stuff_exists = true
			print"No file, but table exists, using table"
		else
			--look for data_static folder (workshop_support)
			filename = "data_static/"..filename
			if file.Exists(filename,"GAME") then
				to_check = file.Read(filename,"GAME")
				stuff_exists = true
				print"File exists in 'data_static' folder, loading this one"
			end
		end
	end
	
	if stuff_exists and to_check then

		local tbl = util.JSONToTable( to_check )
				
		for i,p in ipairs(tbl) do
			local tblpos = p.Pos
			local pos = Vector(tblpos[1],tblpos[2],tblpos[3])
			
			table.insert ( KOTHPoints, {Pos = pos, R = p.R} )
		end
		
		if self:GetGametype() == "koth" then
			local ind = math.random(1,#KOTHPoints)
			local rand = KOTHPoints[ind]
			
			local ent = ents.Create("koth_point")
			ent:SetPos(rand.Pos)
			ent:SetRadius(rand.R)
			ent.LastInd = ind
			ent:Spawn()
			ent:Activate()
		end
		
		if self:GetGametype() == "conquest" then
			
			local am = math.min(#KOTHPoints,CONQUEST_MAX_POINTS)
			
			if am == 0 then return end
			
			table.Shuffle(KOTHPoints)
			
			for i=1,am do				
				local rand = KOTHPoints[i]
				
				local ent = ents.Create("conquest_point")
				ent:SetPos(rand.Pos)
				ent:SetRadius(rand.R)
				ent:Spawn()
				ent:Activate()				
			end
			hook.Remove("SetupPlayerVisibility", "AddPointsToPVS")
			hook.Add( "SetupPlayerVisibility", "AddPointsToPVS", AddPointsToPVS )
			
		end
		
		if self:GetGametype() == "htf" then
			local ind = math.random(1,#KOTHPoints)
			local rand = KOTHPoints[ind]
			
			local ent = ents.Create("htf_flag")
			ent:SetPos(rand.Pos)
			ent:Spawn()
			ent:Activate()
		end
		
		if self:GetGametype() == "assault" then
			
			local points = KOTHPoints
			local hostages = ents.FindByClass("hostage_entity")
			local bombplaces = ents.FindByClass("func_bomb_target")
		
			/*if #hostages > 0 then
				points = hostages
				local ind = math.random(1,#points)
				local rand = points[ind]
					
				local ent = ents.Create("assault_prop")
				ent:SetPos(rand:GetPos())
				ent:SetAngles(Angle(0,90*math.random(-2,2),0))
				ent:Spawn()
				ent:Activate()
			else*/if #bombplaces > 0 then
				points = bombplaces
				local ind = math.random(1,#points)
				local rand = points[ind]
				
				local aa, bb = rand:WorldSpaceAABB()

				local ent = ents.Create("assault_prop")
				ent:SetPos(Vector((aa.x + bb.x) / 2, (aa.y + bb.y) / 2, aa.z))
				ent:SetAngles(Angle(0,90*math.random(-2,2),0))
				ent:Spawn()
				ent:Activate()
			else
				points = KOTHPoints
				
				local maxdistance = 10000000000000000
				local choose = math.random(1,#points)
				
				for _, bluespawn in ipairs(self.BlueSpawnPoints) do
					for num,pnt in pairs(points) do
						if maxdistance > pnt.Pos:Distance(bluespawn:GetPos()) then
							maxdistance = pnt.Pos:Distance(bluespawn:GetPos())
							choose = num
						end
					end
				end
				
				//local ind = math.random(1,#points)
				local rand = points[choose]
					
				local ent = ents.Create("assault_prop")
				ent:SetPos(rand.Pos)
				ent:SetAngles(Angle(0,90*math.random(-2,2),0))
				ent:Spawn()
				ent:Activate()
			end
			
			
			
		end
		
		if self:GetGametype() == "ffa" then
			local ind = math.random(1,#KOTHPoints)
			local rand = KOTHPoints[ind]
			
			local ent = ents.Create("ffa_manager")
			ent:SetPos(rand.Pos)
			ent:Spawn()
			ent:Activate()
		end
		
		if self:GetGametype() == "tdm" then
			local ind = math.random(1,#KOTHPoints)
			local rand = KOTHPoints[ind]
			
			local ent = ents.Create("tdm_manager")
			ent:SetPos(rand.Pos)
			ent:Spawn()
			ent:Activate()
		end
		
		if self:GetGametype() == "ts" then
			local ind = math.random(1,#KOTHPoints)
			local rand = KOTHPoints[ind]
			
			local ent = ents.Create("ts_manager")
			ent:SetPos(rand.Pos)
			ent:Spawn()
			ent:Activate()
		end
		
		print("--> Loaded Points Locations!")
		
	else
	
		if self:GetGametype() == "assault" then
			
			local points = {}
			local hostages = ents.FindByClass("hostage_entity")
			local bombplaces = ents.FindByClass("func_bomb_target")
		
			if #hostages > 0 then
				points = hostages
				local ind = math.random(1,#points)
				local rand = points[ind]
					
				local ent = ents.Create("assault_prop")
				ent:SetPos(rand:GetPos())
				ent:SetAngles(Angle(0,90*math.random(-2,2),0))
				ent:Spawn()
				ent:Activate()
			elseif #bombplaces > 0 then
				points = bombplaces
				local ind = math.random(1,#points)
				local rand = points[ind]
				
				local aa, bb = rand:WorldSpaceAABB()

				local ent = ents.Create("assault_prop")
				ent:SetPos(Vector((aa.x + bb.x) / 2, (aa.y + bb.y) / 2, aa.z))
				ent:SetAngles(Angle(0,math.random(-180,180),0))
				ent:Spawn()
				ent:Activate()
			else
				RunConsoleCommand( "dd_gametype", "tdm" )
				self.Gametype = "tdm"
		
				print("--> No KOTH points! Switching to TDM!")
			end
			
		elseif self:GetGametype() == "ffa" then
			local ent = ents.Create("ffa_manager")
			ent:SetPos(vector_origin)
			ent:Spawn()
			ent:Activate()
		elseif self:GetGametype() == "tdm" then
			local ent = ents.Create("tdm_manager")
			ent:SetPos(vector_origin)
			ent:Spawn()
			ent:Activate()
		elseif self:GetGametype() == "ts" then
			local ent = ents.Create("ts_manager")
			ent:SetPos(vector_origin)
			ent:Spawn()
			ent:Activate()
		else
			RunConsoleCommand( "dd_gametype", "ffa" )
			self.Gametype = "ffa"
			
			local ent = ents.Create("ffa_manager")
			ent:SetPos(vector_origin)
			ent:Spawn()
			ent:Activate()
		
			print("--> No KOTH points! Switching to FFA!")
		end
	end
	
	local gm = "darkestdays/dd_gametypes.txt"

	if file.Exists(gm,"DATA") then
		local tbl = util.JSONToTable( file.Read( gm, "DATA" ) )
		
		self.GametypeRounds = table.Copy( tbl )
		
		//check for new gamemodes
		local rewrite = false
		for k, v in pairs( self.Gametypes ) do
			if not self.GametypeRounds[ k ] then
				self.GametypeRounds[ k ] = { played = 0, tounlock = 0 }
				rewrite = true
			end
		end
		
		if rewrite then
			file.Write( gm, util.TableToJSON( self.GametypeRounds ) )
		end
		
	else	
		for k, v in pairs( self.Gametypes ) do
			self.GametypeRounds[ k ] = { played = 0, tounlock = 0 }
		end
		file.Write( gm, util.TableToJSON( self.GametypeRounds ) )
	end
	
end

function GM:ManageGametypeLocking( current )
	
	if self.GametypeRounds[ current ] and current ~= "koth" then
		self.GametypeRounds[ current ].played = self.GametypeRounds[ current ].played + 1
		if self.GametypeRounds[ current ].played >= ROUNDS_PER_GAMETYPE then
			self.GametypeRounds[ current ].tounlock = ( current == "ts" and TS_UNLOCKS_PER_GAMETYPE ) or UNLOCKS_PER_GAMETYPE //because constant punchpocalypse is nono
		end
	end
	
	for k,v in pairs( self.GametypeRounds ) do
		if k ~= current and v.played >= ROUNDS_PER_GAMETYPE and v.tounlock > 0 then
			self.GametypeRounds[ k ].tounlock = self.GametypeRounds[ k ].tounlock - 1
			if self.GametypeRounds[ k ].tounlock < 1 then
				self.GametypeRounds[ k ].played = 0
			end
		end
	end
	
	local gm = "darkestdays/dd_gametypes.txt"
	file.Write( gm, util.TableToJSON( self.GametypeRounds ) )
	
end

function GM:IsGametypeLocked( gm )
	return self.GametypeRounds[ gm ] and self.GametypeRounds[ gm ].played >= ROUNDS_PER_GAMETYPE, self.GametypeRounds[ gm ].tounlock
end

local function RequestMapProfiler( pl, cmg, args )
	
	local allow = false
	
	if pl:IsAdmin() then allow = true end
	
	if GAMEMODE.MapCyclePassword and args and args[1] and GAMEMODE.MapCyclePassword == tostring( args[1] ) then
		if not GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then
			GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] = true
		end
	end
	
	if GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then allow = true end
	
	if not allow then return end
	
	GAMEMODE:SendMapProfilesToClient( pl )
	
end
concommand.Add( "dd_mapprofiler", RequestMapProfiler )

util.AddNetworkString( "HUDMessage" )
util.AddNetworkString( "HUDMessagePlayer" )
util.AddNetworkString( "SendMapProfilesToClient" )
util.AddNetworkString( "SendMapPointsToServer" )
util.AddNetworkString( "SendMapExploitsToServer" )

function GM:SendMapProfilesToClient( pl )

	local a, b = file.Find("darkestdays/koth_points/*.txt", "DATA")	
	local a2, b2 = file.Find("darkestdays/exploits/*.txt", "DATA")	
	
	a = a or {}
	a2 = a2 or {}
	
	if a and a2 then
		
		local data = table.concat( a, " " )
		local compressed = util.Compress( data ) 
		local len = string.len( compressed )
		
		net.Start( "SendMapProfilesToClient" )
			net.WriteInt( len, 32 )
			net.WriteData( compressed, len )
		
		local data2 = table.concat( a2, " " )
		local compressed2 = util.Compress( data2 ) 
		local len2 = string.len( compressed2 )
		
			net.WriteInt( len2, 32 )
			net.WriteData( compressed2, len2 )
		net.Send( pl )
		
	end

end

net.Receive( "SendMapPointsToServer", function( len, pl )

	local allow = false
	
	if pl:IsAdmin() then allow = true end
	if GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then allow = true end
	
	if not allow then return end

	local map_name = net.ReadString()
	local data_len = net.ReadInt( 32 )
	local data = net.ReadData( data_len )
	local decompressed = util.Decompress( data )
	
	local check = util.JSONToTable( decompressed )
	
	if check then
	
		local hasfolder = file.IsDir( "darkestdays/koth_points", "DATA" )
	
		if not hasfolder then
			file.CreateDir( "darkestdays/koth_points" )
		end
	
		file.Write( "darkestdays/koth_points/"..map_name..".txt", decompressed )
		pl:ChatPrint( "Successfully uploaded 'darkestdays/koth_points/"..map_name..".txt' file!" )
	end
	
end)

net.Receive( "SendMapExploitsToServer", function( len, pl )

	local allow = false
	
	if pl:IsAdmin() then allow = true end
	if GAMEMODE.AllowMapCycleEditing[ tostring( pl:SteamID() ) ] then allow = true end
	
	if not allow then return end

	local map_name = net.ReadString()
	local data_len = net.ReadInt( 32 )
	local data = net.ReadData( data_len )
	local decompressed = util.Decompress( data )
	
	local check = util.JSONToTable( decompressed )
	
	if check then
	
		local hasfolder = file.IsDir( "darkestdays/exploits", "DATA" )
	
		if not hasfolder then
			file.CreateDir( "darkestdays/exploits" )
		end
	
		file.Write( "darkestdays/exploits/"..map_name..".txt", decompressed )
		pl:ChatPrint( "Successfully uploaded 'darkestdays/exploits/"..map_name..".txt' file!" )
	end
	
end)

function GM:HUDMessage(to, txt, about, snd)

	net.Start( "HUDMessage" )
		net.WriteString( txt or "" )
		net.WriteEntity( about or NULL )
		net.WriteDouble( snd or 0 )
	if to and type( to ) == "player" then
		net.Send( to )
	else
		net.Broadcast()
	end

end

function GM:HUDMessagePlayer(to, txt, txt_player, about, snd)

	net.Start( "HUDMessagePlayer" )
		net.WriteString( txt or "" )
		net.WriteString( txt_player or "" )
		net.WriteEntity( about or NULL )
		net.WriteDouble( snd or 0 )
	if to and type( to ) == "player" then
		net.Send( to )
	else
		net.Broadcast()
	end

end



//imported map profiles from my server, since workshop doesnt allows the use of txt files. They WILL be overriden if you decide to use exploits/point tool and do some changes
//and I bet you thought this was some sort of backdoor at first glimpse :v

GM.DefaultKOTHPoints = {
	["dm_bridge_b2"] = [[ {"1":{"R":121,"Pos":{"1":-3556.02,"2":-2.6759,"3":430.031}},"2":{"R":186,"Pos":{"1":-4894.62,"2":-303.578,"3":417.745}},"3":{"R":157,"Pos":{"1":-2155.63,"2":-271.043,"3":420.231}},"4":{"R":253,"Pos":{"1":-3319.6,"2":346.172,"3":422.031}},"5":{"R":224,"Pos":{"1":-5834.56,"2":2.1637,"3":430.031}},"6":{"R":165,"Pos":{"1":-1268.11,"2":-0.3778,"3":430.031}}} ]],
	["dm_abyss"] = [[ {"1":{"R":129,"Pos":{"1":-367.2,"2":-2766.39,"3":98.0313}},"2":{"R":82,"Pos":{"1":820.443,"2":-922.266,"3":234.031}},"3":{"R":100,"Pos":{"1":27.8931,"2":-111.203,"3":18.0313}},"4":{"R":112,"Pos":{"1":-94.5042,"2":-1233.21,"3":104.031}}} ]],
	["dm_thumper"] = [[ {"1":{"R":100,"Pos":{"1":656.842,"2":-250.398,"3":370.031}},"2":{"R":100,"Pos":{"1":591.691,"2":230.158,"3":370.031}},"3":{"R":100,"Pos":{"1":895.024,"2":38.8122,"3":370.031}}} ]],
	["de_nuke"] = [[ {"1":{"R":123,"Pos":{"1":753.237,"2":-1135.12,"3":-413.969}},"2":{"R":123,"Pos":{"1":650.064,"2":-1948.15,"3":-413.969}},"3":{"R":123,"Pos":{"1":608.125,"2":31.6395,"3":-413.969}}} ]],
	["dm_detritus_v2"] = [[ {"1":{"R":100,"Pos":{"1":-272.674,"2":-844.039,"3":2.0313}},"2":{"R":100,"Pos":{"1":210.095,"2":259.249,"3":2.0313}},"3":{"R":100,"Pos":{"1":-99.2818,"2":-384.719,"3":210.031}}} ]],
	["dm_cigaro"] = [[ {"1":{"R":100,"Pos":{"1":660.254,"2":14.5753,"3":-237.969}},"2":{"R":100,"Pos":{"1":796.963,"2":-873.852,"3":-476.78}},"3":{"R":100,"Pos":{"1":1223.61,"2":-249.612,"3":-237.969}}} ]],
	["dm_dust_housing_estate4"] = [[ {"1":{"R":89,"Pos":{"1":-1109.15,"2":327.35,"3":130}},"2":{"R":89,"Pos":{"1":-783.557,"2":598.009,"3":130}},"3":{"R":89,"Pos":{"1":-382.283,"2":277.978,"3":130}}} ]],
	["de_nightfever"] = [[ {"1":{"R":114,"Pos":{"1":750.811,"2":1453.17,"3":34.0313}},"2":{"R":114,"Pos":{"1":824.663,"2":2077.7,"3":34.0313}}} ]],
	["dm_torque"] = [[ {"1":{"R":117,"Pos":{"1":9.9543,"2":-359.656,"3":75.3446}},"2":{"R":105,"Pos":{"1":532.135,"2":-335.045,"3":146.031}},"3":{"R":156,"Pos":{"1":-1670.01,"2":-63.4885,"3":0}},"4":{"R":99,"Pos":{"1":294.308,"2":88.3625,"3":442.031}}} ]],
	["dm_metro"] = [[ {"1":{"R":99,"Pos":{"1":198.223,"2":-323.821,"3":66.0313}},"2":{"R":99,"Pos":{"1":-1338.47,"2":-1031.52,"3":183.03}},"3":{"R":87,"Pos":{"1":-45.9865,"2":-1117.77,"3":74.0313}}} ]],
	["dd_darkest_days"] = [[ {"1":{"R":172,"Pos":{"1":-2888.5,"2":-4.5911,"3":64.6786}},"2":{"R":213,"Pos":{"1":340.655,"2":0.919,"3":98.0313}},"3":{"R":68,"Pos":{"1":-1661.98,"2":315.866,"3":194.031}},"4":{"R":87,"Pos":{"1":-2171.61,"2":326.545,"3":338.031}},"5":{"R":159,"Pos":{"1":-1664.72,"2":-673.751,"3":66.0313}},"6":{"R":179,"Pos":{"1":-1409.21,"2":0.0732,"3":60.0312}},"7":{"R":88,"Pos":{"1":-899.248,"2":-325.436,"3":194.031}},"8":{"R":88,"Pos":{"1":-2174.46,"2":-349.896,"3":68.0313}},"9":{"R":296,"Pos":{"1":0.2221,"2":-1031.77,"3":58.0312}},"10":{"R":160,"Pos":{"1":-1649.18,"2":-817.143,"3":770.031}},"11":{"R":201,"Pos":{"1":-503.13,"2":-479.153,"3":514.031}},"12":{"R":170,"Pos":{"1":-2134.86,"2":307.07,"3":514.031}},"13":{"R":225,"Pos":{"1":-1638.31,"2":-1204.32,"3":58.0313}},"14":{"R":225,"Pos":{"1":-2507.41,"2":-1183.35,"3":58.0313}}} ]],
	["dm_area22"] = [[ {"1":{"R":100,"Pos":{"1":-362.596,"2":-709.36,"3":130.031}},"2":{"R":100,"Pos":{"1":126.773,"2":-182.745,"3":178.031}},"3":{"R":100,"Pos":{"1":-459.837,"2":-829.842,"3":-303.969}}} ]],
	["dm_thefactory"] = [[ {"1":{"R":100,"Pos":{"1":-719.023,"2":268.058,"3":-251.653}},"2":{"R":100,"Pos":{"1":-1200.45,"2":266.266,"3":-382.624}},"3":{"R":100,"Pos":{"1":239.952,"2":-107.073,"3":-254}}} ]],
	["dm_raven"] = [[ {"1":{"R":128,"Pos":{"1":172.401,"2":222.472,"3":66.0313}},"2":{"R":119,"Pos":{"1":437.841,"2":-399.508,"3":68.0313}},"3":{"R":104,"Pos":{"1":690.988,"2":502.269,"3":346.031}}} ]],
	["dm_7hour"] = [[ {"1":{"R":100,"Pos":{"1":-880.762,"2":-666.537,"3":-125.969}},"2":{"R":100,"Pos":{"1":-908.19,"2":-1301.71,"3":-125.969}},"3":{"R":100,"Pos":{"1":-1767.15,"2":-589.75,"3":-45.9688}}} ]],
	["dm_biohazard"] = [[ {"1":{"R":111,"Pos":{"1":1629.55,"2":-141.465,"3":-21.9688}},"2":{"R":107,"Pos":{"1":952.397,"2":345.241,"3":-189.969}},"3":{"R":107,"Pos":{"1":2374.96,"2":363.591,"3":-69.9688}},"4":{"R":104,"Pos":{"1":1542.29,"2":494.558,"3":162.031}}} ]],
	["dm_cloudcity"] = [[ {"1":{"R":150,"Pos":{"1":8654.59,"2":6215.09,"3":226.031}},"2":{"R":127,"Pos":{"1":8739.43,"2":6446.1,"3":546.031}},"3":{"R":116,"Pos":{"1":7175.26,"2":5095.75,"3":226.031}},"4":{"R":128,"Pos":{"1":9166.55,"2":6822.17,"3":66.0313}},"5":{"R":128,"Pos":{"1":9944.85,"2":6640.22,"3":546.031}}} ]],
	["dm_lostarena"] = [[ {"1":{"R":100,"Pos":{"1":-203.989,"2":715.145,"3":-253.969}},"2":{"R":114,"Pos":{"1":933.949,"2":-340.182,"3":-253.969}},"3":{"R":114,"Pos":{"1":-570.479,"2":-920.793,"3":-253.969}}} ]],
	["fy_highrise_09"] = [[ {"1":{"R":88,"Pos":{"1":-850.389,"2":-95.099,"3":282.031}},"2":{"R":88,"Pos":{"1":789.073,"2":451.08,"3":282.031}},"3":{"R":88,"Pos":{"1":84.7303,"2":504.812,"3":66.0313}}} ]],
	["dm_villa_b3"] = [[ {"1":{"R":100,"Pos":{"1":128.976,"2":-640.619,"3":-112.239}},"2":{"R":73,"Pos":{"1":-155.11,"2":-528.294,"3":-348.745}},"3":{"R":81,"Pos":{"1":107.122,"2":-227.303,"3":142.031}}} ]],
	["dm_trainyard"] = [[ {"1":{"R":127,"Pos":{"1":-1251.34,"2":-2367.75,"3":-21.9688}},"2":{"R":127,"Pos":{"1":-580.752,"2":-1359.02,"3":-23}},"3":{"R":140,"Pos":{"1":1116.36,"2":-2056.4,"3":-22.9687}},"4":{"R":140,"Pos":{"1":-1398.81,"2":-1912.42,"3":-21.9688}},"5":{"R":147,"Pos":{"1":57.3511,"2":-1163.64,"3":-23}},"6":{"R":134,"Pos":{"1":-159.907,"2":-1809.47,"3":-23}}} ]],
	["de_train"] = [[ {"1":{"R":60,"Pos":{"1":529.784,"2":226.844,"3":-64.7955}},"2":{"R":84,"Pos":{"1":514.91,"2":29.8274,"3":-213.969}},"3":{"R":84,"Pos":{"1":1871.13,"2":204.338,"3":-213.969}},"4":{"R":84,"Pos":{"1":-250.065,"2":21.2747,"3":-213.969}}} ]],
	["dm_border_bust"] = [[ {"1":{"R":127,"Pos":{"1":-31.4003,"2":-338.736,"3":-461.969}},"2":{"R":127,"Pos":{"1":-13.0985,"2":-1566.7,"3":-173.969}},"3":{"R":106,"Pos":{"1":-547.526,"2":281.016,"3":130.031}}} ]],
	["dm_megawatt"] = [[ {"1":{"R":113,"Pos":{"1":8.553,"2":722.675,"3":66.0313}},"2":{"R":121,"Pos":{"1":69.1268,"2":-551.126,"3":2.0313}},"3":{"R":61,"Pos":{"1":633.98,"2":-152.079,"3":66.0313}},"4":{"R":61,"Pos":{"1":-645.854,"2":576.012,"3":130.031}},"5":{"R":82,"Pos":{"1":216.738,"2":571.947,"3":322.031}}} ]],
	["dm_downtown"] = [[ {"1":{"R":100,"Pos":{"1":-1423.84,"2":-1001.98,"3":2.0313}},"2":{"R":100,"Pos":{"1":-2118.68,"2":-938.368,"3":2.0313}},"3":{"R":100,"Pos":{"1":-515.521,"2":-938.329,"3":2.0313}},"4":{"R":100,"Pos":{"1":-1576.51,"2":-1036.3,"3":394.031}}} ]],
	["dm_plaza17"] = [[ {"1":{"R":109,"Pos":{"1":4362.17,"2":1965.58,"3":-773.969}},"2":{"R":109,"Pos":{"1":3122.9,"2":300.328,"3":-765.969}},"3":{"R":109,"Pos":{"1":2992.74,"2":1640.47,"3":-773.969}},"4":{"R":109,"Pos":{"1":2831.29,"2":833.443,"3":-778}}} ]],
	["dm_gunshotbeta4"] = [[ {"1":{"R":128,"Pos":{"1":49.7319,"2":87.9902,"3":17.7608}},"2":{"R":111,"Pos":{"1":-1405.66,"2":-11.8061,"3":-133.969}},"3":{"R":111,"Pos":{"1":-1521.69,"2":816.275,"3":-133.969}}} ]],
	["dm_instant"] = [[ {"1":{"R":165,"Pos":{"1":-348.275,"2":633.286,"3":2.0313}},"2":{"R":165,"Pos":{"1":-724.028,"2":1426.2,"3":-135.928}},"3":{"R":180,"Pos":{"1":-350.733,"2":2210.83,"3":-139.969}},"4":{"R":143,"Pos":{"1":-395.718,"2":-51.8193,"3":2.0313}},"5":{"R":121,"Pos":{"1":-1.2955,"2":611.737,"3":2.0313}},"6":{"R":87,"Pos":{"1":-230.68,"2":387.714,"3":-125.969}}} ]],
	["dm_greenhouse"] = [[ {"1":{"R":100,"Pos":{"1":-1184.06,"2":-635.829,"3":9.0818}},"2":{"R":100,"Pos":{"1":-772.279,"2":-433.653,"3":2.0313}},"3":{"R":100,"Pos":{"1":-771.537,"2":-879.557,"3":258.031}},"4":{"R":100,"Pos":{"1":-582.223,"2":-902.176,"3":450.031}}} ]],
	["cs_pariah"] = [[ {"1":{"R":100,"Pos":{"1":-135.546,"2":-537.416,"3":-213.969}},"2":{"R":100,"Pos":{"1":-456.835,"2":-412.973,"3":109.031}},"3":{"R":100,"Pos":{"1":451.034,"2":-430.458,"3":-153.969}}} ]],
	["dm_casual"] = [[ {"1":{"R":116,"Pos":{"1":-550.545,"2":348.837,"3":632.031}},"2":{"R":91,"Pos":{"1":118.309,"2":79.4635,"3":106.031}},"3":{"R":91,"Pos":{"1":-129.715,"2":269.322,"3":362.031}}} ]],
	["dm_damage_inc"] = [[ {"1":{"R":100,"Pos":{"1":-215.968,"2":-242.403,"3":2.0313}},"2":{"R":100,"Pos":{"1":-635.745,"2":861.627,"3":130.031}},"3":{"R":100,"Pos":{"1":1151.14,"2":-880.496,"3":2.0313}}} ]],
	["ts_steel"] = [[ {"1":{"R":109,"Pos":{"1":-69.1072,"2":-507.257,"3":106.031}},"2":{"R":109,"Pos":{"1":-570.793,"2":-240.484,"3":-21.9688}},"3":{"R":106,"Pos":{"1":287.943,"2":-299.388,"3":-21.9688}}} ]],
	["dm_postoffice"] = [[ {"1":{"R":64,"Pos":{"1":-101.193,"2":502.829,"3":298.031}},"2":{"R":64,"Pos":{"1":-852.635,"2":631.955,"3":130.031}},"3":{"R":64,"Pos":{"1":-790.882,"2":165.393,"3":98.0313}}} ]],
	["dm_laststop"] = [[ {"1":{"R":76,"Pos":{"1":677.757,"2":218.749,"3":-317.969}},"2":{"R":76,"Pos":{"1":416.337,"2":478.482,"3":90.0313}},"3":{"R":76,"Pos":{"1":-110.327,"2":202.356,"3":-53.9688}}} ]],
	["dm_fallout"] = [[ {"1":{"R":100,"Pos":{"1":134.859,"2":-257.543,"3":-132.9}},"2":{"R":80,"Pos":{"1":527.649,"2":-318.379,"3":2.0313}},"3":{"R":87,"Pos":{"1":635.651,"2":108.332,"3":274.031}}} ]],
	["dm_shockstreet_b2"] = [[ {"1":{"R":100,"Pos":{"1":3255.26,"2":-2918.99,"3":81.6256}},"2":{"R":100,"Pos":{"1":2562.08,"2":-2412.21,"3":66.0313}},"3":{"R":100,"Pos":{"1":3788.42,"2":-3197.57,"3":258.031}}} ]],
	["dd_ironisle_v2"] = [[ {"1":{"R":138,"Pos":{"1":-321.05,"2":-3.306,"3":-509.969}},"2":{"R":158,"Pos":{"1":0.2814,"2":-3.7983,"3":-861.969}},"3":{"R":97,"Pos":{"1":-315.958,"2":385.441,"3":-253.969}},"4":{"R":205,"Pos":{"1":-284.723,"2":-0.5303,"3":2.0313}},"5":{"R":129,"Pos":{"1":573.722,"2":-2.0719,"3":-125.969}},"6":{"R":143,"Pos":{"1":324.712,"2":-0.7517,"3":-701.969}},"7":{"R":127,"Pos":{"1":-318.771,"2":350.281,"3":-509.969}}} ]],
	["dm_avalon"] = [[ {"1":{"R":123,"Pos":{"1":-182.053,"2":157.714,"3":1059}},"2":{"R":59,"Pos":{"1":888.474,"2":1390.95,"3":606.414}},"3":{"R":87,"Pos":{"1":-345.526,"2":-54.9676,"3":663.687}},"4":{"R":119,"Pos":{"1":91.4155,"2":-1099.38,"3":69.2367}}} ]],
	["dm_insomnia_v1"] = [[ {"1":{"R":100,"Pos":{"1":639.987,"2":80.5339,"3":-1021.97}},"2":{"R":100,"Pos":{"1":-239.981,"2":629.053,"3":-1021.97}},"3":{"R":100,"Pos":{"1":-408.765,"2":-364.124,"3":-1021.97}}} ]],
	["dm_A_lesser_fate"] = [[ {"1":{"R":76,"Pos":{"1":-129.76,"2":2.1337,"3":358.031}},"2":{"R":109,"Pos":{"1":-26.8994,"2":0.5195,"3":-221.969}}} ]],
	["dm_energize_b1"] = [[ {"1":{"R":114,"Pos":{"1":107.093,"2":1180.8,"3":2.0313}},"2":{"R":129,"Pos":{"1":1006.57,"2":1052.57,"3":-125.969}},"3":{"R":119,"Pos":{"1":1581.34,"2":-145.802,"3":-125.969}}} ]],
	["dm_filth_v1"] = [[ {"1":{"R":136,"Pos":{"1":-257.3225,"2":704.5719,"3":-253.9687}},"2":{"R":130,"Pos":{"1":-245.2803,"2":705.1342,"3":-381.9688}},"3":{"R":89,"Pos":{"1":-1088.9731,"2":1312.5721,"3":-381.9688}},"4":{"R":135,"Pos":{"1":449.1354,"2":123.3948,"3":-252.473}}} ]],
	["dm_balcony_beta4"] = [[ {"1":{"R":100,"Pos":{"1":450.615,"2":-367.181,"3":90.0313}},"2":{"R":89,"Pos":{"1":-433.172,"2":-439.657,"3":130.031}},"3":{"R":89,"Pos":{"1":-966.481,"2":-332.033,"3":130.031}}} ]],
	["dm_3006_beta1"] = [[ {"1":{"R":100,"Pos":{"1":877.898,"2":2348.92,"3":98.0313}},"2":{"R":100,"Pos":{"1":-97.3047,"2":418.672,"3":-1.5247}},"3":{"R":100,"Pos":{"1":224.3,"2":1993.36,"3":706.031}}} ]],
	["de_inferno"] = [[ {"1":{"R":100,"Pos":{"1":172.529,"2":597.144,"3":75.1765}},"2":{"R":100,"Pos":{"1":729.797,"2":2709.04,"3":130}},"3":{"R":94,"Pos":{"1":335.121,"2":-60.7863,"3":57.5351}}} ]],
	["dm_astera"] = [[ {"1":{"R":100,"Pos":{"1":-1566.62,"2":1094.07,"3":3056.1}},"2":{"R":82,"Pos":{"1":-865.551,"2":1209.04,"3":3362.03}},"3":{"R":108,"Pos":{"1":-978.599,"2":307.706,"3":3042.03}}} ]],
	["dm_backbone"] = [[ {"1":{"R":88,"Pos":{"1":664.492,"2":-121.832,"3":2.0313}},"2":{"R":99,"Pos":{"1":1478.33,"2":-714.15,"3":2.0313}},"3":{"R":74,"Pos":{"1":840.217,"2":-686.201,"3":130.031}}} ]],
	["dm_loststation"] = [[ {"1":{"R":73,"Pos":{"1":-1702.23,"2":1464.06,"3":313.031}},"2":{"R":110,"Pos":{"1":-1712.92,"2":1101.52,"3":56.1694}},"3":{"R":110,"Pos":{"1":-2129.9,"2":563.984,"3":258.031}},"4":{"R":110,"Pos":{"1":-1150.32,"2":2033.33,"3":62.0312}}} ]],
	["dm_facility_beta"] = [[ {"1":{"R":71,"Pos":{"1":1027.5,"2":-446.002,"3":-117.969}},"2":{"R":59,"Pos":{"1":620.019,"2":-197.571,"3":-117.969}}} ]],
	["dm_moil_final"] = [[ {"1":{"R":111,"Pos":{"1":150.397,"2":-293.723,"3":-385.969}},"2":{"R":100,"Pos":{"1":117.743,"2":841.062,"3":-381.969}},"3":{"R":100,"Pos":{"1":-2.2885,"2":292.406,"3":-541.969}}} ]],
	["dm_steamlab"] = [[ {"1":{"R":100,"Pos":{"1":-2372.58,"2":1799.11,"3":1034.03}},"2":{"R":96,"Pos":{"1":-2208.26,"2":2736.74,"3":826.031}},"3":{"R":136,"Pos":{"1":-3032.69,"2":2517.21,"3":890.031}},"4":{"R":143,"Pos":{"1":-1103.35,"2":2331.28,"3":890.031}}} ]],
	["dm_cannon_r1"] = [[ {"1":{"R":100,"Pos":{"1":600.854,"2":967.411,"3":-685.969}},"2":{"R":100,"Pos":{"1":579.429,"2":104.353,"3":-285.969}}} ]],
	["dm_archt"] = [[ {"1":{"R":84,"Pos":{"1":-229.397,"2":455.145,"3":2.0313}},"2":{"R":84,"Pos":{"1":492.018,"2":1030.81,"3":82.0313}},"3":{"R":84,"Pos":{"1":1024.56,"2":340.248,"3":82.0313}}} ]],
	["dm_stad"] = [[ {"1":{"R":122,"Pos":{"1":-338.075,"2":540.511,"3":3.0313}},"2":{"R":122,"Pos":{"1":-344.655,"2":1482.79,"3":3.0312}},"3":{"R":122,"Pos":{"1":993.857,"2":1440.76,"3":3.0313}}} ]],
	["fy_skystep"] = [[ {"1":{"R":114,"Pos":{"1":2061.3,"2":374.298,"3":-165.969}},"2":{"R":114,"Pos":{"1":2748.56,"2":354.753,"3":-165.969}},"3":{"R":114,"Pos":{"1":2830.56,"2":-161.339,"3":-165.969}},"4":{"R":114,"Pos":{"1":2056.05,"2":894.576,"3":-165.969}}} ]],
	["cs_office"] = [[ {"1":{"R":85,"Pos":{"1":954.745,"2":-502.424,"3":-157.969}},"2":{"R":83,"Pos":{"1":669.902,"2":88.8078,"3":-157.969}},"3":{"R":83,"Pos":{"1":94.8725,"2":107.881,"3":-157.969}}} ]],
	["fy_forest"] = [[ {"1":{"R":120,"Pos":{"1":-10.1772,"2":-6.5174,"3":68.1711}}} ]],
	["dm_necessity"] = [[ {"1":{"R":100,"Pos":{"1":530.598,"2":-106.236,"3":98.0313}},"2":{"R":91,"Pos":{"1":-787.25,"2":-137.753,"3":154.031}},"3":{"R":84,"Pos":{"1":-80.5974,"2":-97.1633,"3":-181.952}}} ]],
	["dm_transport"] = [[ {"1":{"R":122,"Pos":{"1":-1281.08,"2":-1588.81,"3":-333.969}},"2":{"R":122,"Pos":{"1":-27.042,"2":-1610.49,"3":-333.969}},"3":{"R":122,"Pos":{"1":-13.8745,"2":-241.97,"3":-241.089}}} ]],
	["dm_zest"] = [[ {"1":{"R":100,"Pos":{"1":-520.378,"2":-100.662,"3":-29.9687}},"2":{"R":61,"Pos":{"1":-571.568,"2":-156.621,"3":258.031}}} ]],
	["cs_apartments"] = [[ {"1":{"R":91,"Pos":{"1":-566.235,"2":645.793,"3":2.0312}},"2":{"R":91,"Pos":{"1":-1258.43,"2":-2.0577,"3":-61.9687}},"3":{"R":91,"Pos":{"1":-1938.62,"2":905.561,"3":2.0313}}} ]],
	["dm_closecombat"] = [[ {"1":{"R":100,"Pos":{"1":-208.988,"2":-1374.01,"3":1.5034}},"2":{"R":100,"Pos":{"1":-547.993,"2":-613.798,"3":1.5347}},"3":{"R":100,"Pos":{"1":-817.629,"2":218.751,"3":1.5034}}} ]],
	["dm_tobor"] = [[ {"1":{"R":68,"Pos":{"1":298.27,"2":-319.743,"3":642.031}},"2":{"R":78,"Pos":{"1":368.36,"2":75.3994,"3":642.031}},"3":{"R":85,"Pos":{"1":-241.322,"2":230.406,"3":770.031}}} ]],
	["dm_overwatch"] = [[ {"1":{"R":108,"Pos":{"1":6777.07,"2":6446.82,"3":386.031}},"2":{"R":106,"Pos":{"1":6622.13,"2":6556.92,"3":194.031}},"3":{"R":104,"Pos":{"1":5473.21,"2":6153.25,"3":-1.9688}},"4":{"R":109,"Pos":{"1":7948.58,"2":6908.78,"3":-1.9688}}} ]],
	["dm_scepter"] = [[ {"1":{"R":100,"Pos":{"1":-696.427,"2":-216.895,"3":-2.9688}},"2":{"R":100,"Pos":{"1":-385.563,"2":639.869,"3":-37.9688}},"3":{"R":100,"Pos":{"1":-1263.94,"2":152.359,"3":2.0313}}} ]],
	["dm_derelict_final"] = [[ {"1":{"R":100,"Pos":{"1":-806.074,"2":320.605,"3":130.031}},"2":{"R":100,"Pos":{"1":-826.634,"2":691.244,"3":130.031}},"3":{"R":87,"Pos":{"1":-740.862,"2":772.066,"3":386.031}},"4":{"R":87,"Pos":{"1":-1304.44,"2":378.534,"3":534.031}}} ]],
	["dm_datacore"] = [[ {"1":{"R":183,"Pos":{"1":1229.19,"2":-319.453,"3":146.031}},"2":{"R":183,"Pos":{"1":2234.73,"2":222.406,"3":2.0312}},"3":{"R":183,"Pos":{"1":219.12,"2":503.076,"3":2.0313}},"4":{"R":110,"Pos":{"1":1020.66,"2":593.369,"3":-61.9688}},"5":{"R":118,"Pos":{"1":270.122,"2":-224.021,"3":2.0313}},"6":{"R":118,"Pos":{"1":1225.15,"2":-92.0557,"3":-29.9687}},"7":{"R":97,"Pos":{"1":1118.25,"2":-752.023,"3":-81.9688}}} ]],
	["dm_suspended"] = [[ {"1":{"R":100,"Pos":{"1":-308.968,"2":-345.736,"3":98.0313}},"2":{"R":65,"Pos":{"1":363.133,"2":-417.271,"3":-239.103}},"3":{"R":65,"Pos":{"1":-542.983,"2":-176.34,"3":-246}}} ]],
	["dm_rebels_2"] = [[ {"1":{"R":100,"Pos":{"1":-846.661,"2":161.913,"3":-9.9688}},"2":{"R":70,"Pos":{"1":-1106.61,"2":-68.7545,"3":137.031}},"3":{"R":92,"Pos":{"1":-1123.44,"2":-762.099,"3":-10.9688}}} ]],
	["dm_powerhouse"] = [[ {"1":{"R":161,"Pos":{"1":-47.7737,"2":-2050.11,"3":34.0313}},"2":{"R":123,"Pos":{"1":-48.551,"2":-75.7998,"3":34.0312}},"3":{"R":111,"Pos":{"1":-46.4374,"2":-72.5318,"3":346.031}},"4":{"R":128,"Pos":{"1":-111.713,"2":-1545.41,"3":194.031}},"5":{"R":113,"Pos":{"1":908.221,"2":-863.354,"3":194.031}}} ]],
	["dm_sordid_b3"] = [[ {"1":{"R":105,"Pos":{"1":-425.485,"2":785.03,"3":-733.969}},"2":{"R":105,"Pos":{"1":-194.025,"2":-473.579,"3":-765.969}},"3":{"R":105,"Pos":{"1":-904.628,"2":-319.657,"3":-701.969}}} ]],
	["dm_hell_night_v1"] = [[ {"1":{"R":126,"Pos":{"1":831.357,"2":-1105.44,"3":2.0313}},"2":{"R":126,"Pos":{"1":-152.92,"2":-12.6409,"3":2.0312}},"3":{"R":121,"Pos":{"1":527.777,"2":903.702,"3":8.0312}}} ]],
	["dm_corrodeb5"] = [[ {"1":{"R":100,"Pos":{"1":412.843,"2":827.145,"3":-61.9688}},"2":{"R":100,"Pos":{"1":1036.66,"2":948.166,"3":-61.9688}},"3":{"R":100,"Pos":{"1":151.435,"2":1107.54,"3":202.031}}} ]],
	["dm_graveyard"] = [[ {"1":{"R":100,"Pos":{"1":-4682.28,"2":-558.504,"3":261.031}},"2":{"R":100,"Pos":{"1":-4415.65,"2":611.746,"3":66}},"3":{"R":100,"Pos":{"1":-3320.88,"2":38.7504,"3":66.0313}},"4":{"R":100,"Pos":{"1":-4411.58,"2":-1610.09,"3":29.3705}},"5":{"R":100,"Pos":{"1":-5221.93,"2":-189.683,"3":27.0313}}} ]],
	["dm_hellhole_b94b"] = [[ {"1":{"R":100,"Pos":{"1":-1361.6,"2":259.873,"3":-981.969}},"2":{"R":105,"Pos":{"1":-3888.24,"2":272.918,"3":-981.969}},"3":{"R":105,"Pos":{"1":534.099,"2":247.926,"3":-1035.97}},"4":{"R":105,"Pos":{"1":-1814.88,"2":248.212,"3":-663.969}},"5":{"R":105,"Pos":{"1":481.327,"2":139.596,"3":-663.969}}} ]],
	["dm_phallan"] = [[ {"1":{"R":106,"Pos":{"1":540.209,"2":-666.042,"3":578.031}},"2":{"R":106,"Pos":{"1":184.43,"2":202.858,"3":450.031}},"3":{"R":105,"Pos":{"1":-252.777,"2":-502.916,"3":642.031}},"4":{"R":99,"Pos":{"1":-52.0685,"2":-517.873,"3":258.031}}} ]],
	["fy_garage"] = [[ {"1":{"R":100,"Pos":{"1":1972.47,"2":-625.503,"3":66.0312}},"2":{"R":100,"Pos":{"1":1068.78,"2":-904.332,"3":66.0313}},"3":{"R":100,"Pos":{"1":1254.4,"2":-412.709,"3":66.0313}}} ]],
	["de_industry"] = [[ {"1":{"R":100,"Pos":{"1":166.471,"2":1159.92,"3":-17.9688}},"2":{"R":100,"Pos":{"1":1211.02,"2":890.216,"3":-9.9688}},"3":{"R":91,"Pos":{"1":-1456.68,"2":894.414,"3":-5.9688}}} ]],
	["dm_tower_arena_v2"] = [[ {"1":{"R":100,"Pos":{"1":266.123,"2":-365.007,"3":642.031}},"2":{"R":100,"Pos":{"1":-318.313,"2":-27.2516,"3":450.031}},"3":{"R":109,"Pos":{"1":245.242,"2":-87.7585,"3":130.031}}} ]],
	["dm_underpass"] = [[ {"1":{"R":100,"Pos":{"1":-397.942,"2":-910.99,"3":2.0313}},"2":{"R":85,"Pos":{"1":-960.613,"2":-1888.21,"3":-45.9688}},"3":{"R":85,"Pos":{"1":-409.627,"2":-2495.62,"3":-429.969}},"4":{"R":85,"Pos":{"1":-646.87,"2":-1399.9,"3":-514.753}}} ]],
	["dm_amplitude"] = [[ {"1":{"R":110,"Pos":{"1":1513.98,"2":-1035.58,"3":386.031}},"2":{"R":110,"Pos":{"1":2009.64,"2":-800.796,"3":73.6498}},"3":{"R":110,"Pos":{"1":1030.9,"2":-1209.67,"3":-9.706}}} ]],
	["dm_outlying_v2"] = [[ {"1":{"R":136,"Pos":{"1":503.597,"2":-211.82,"3":-934.969}},"2":{"R":111,"Pos":{"1":96.4858,"2":160.053,"3":-1179.97}},"3":{"R":111,"Pos":{"1":717.268,"2":-1047.95,"3":-934.969}},"4":{"R":128,"Pos":{"1":961.993,"2":142.351,"3":-1179.97}},"5":{"R":105,"Pos":{"1":-486.634,"2":-340.529,"3":-710.68}}} ]],
	["dm_resistance"] = [[ {"1":{"R":99,"Pos":{"1":49.6016,"2":1087.21,"3":-1213.97}},"2":{"R":124,"Pos":{"1":-367.345,"2":-834.754,"3":-1210.07}},"3":{"R":109,"Pos":{"1":-217.733,"2":-210.345,"3":-957.969}},"4":{"R":87,"Pos":{"1":175.376,"2":331.29,"3":-1213.97}}} ]],
	["dm_thorn"] = [[ {"1":{"R":100,"Pos":{"1":71.9254,"2":-1389.9,"3":18}},"2":{"R":100,"Pos":{"1":153.655,"2":-795.605,"3":20.5935}},"3":{"R":67,"Pos":{"1":12.4776,"2":-1022.23,"3":258.031}}} ]],
	["dm_lockdown"] = [[ {"1":{"R":103,"Pos":{"1":-3017.04,"2":2402.74,"3":-0.325}},"2":{"R":119,"Pos":{"1":-2939.11,"2":4331.7,"3":2.0312}},"3":{"R":91,"Pos":{"1":-3470.41,"2":5444.44,"3":2.0313}}} ]],
	["dm_six"] = [[ {"1":{"R":90,"Pos":{"1":-652.741,"2":91.6861,"3":2.0313}},"2":{"R":90,"Pos":{"1":-886.326,"2":-694.98,"3":-29.9688}},"3":{"R":90,"Pos":{"1":-772.301,"2":-325.399,"3":514.031}}} ]],
}

//should've put these into exploitboxes file, but whatever
GM.DefaultExploitBoxes = {
	["dm_abyss"] = [[ [{"bsize":111,"origin":[-241.537,-2200.9648,591.0313]},{"bsize":111,"origin":[-250.0717,-2007.3474,591.0313]},{"bsize":177,"origin":[1714.9818,376.1376,264.7579]},{"bsize":177,"origin":[2060.9524,374.8287,265.9194]},{"bsize":358,"origin":[2425.4851,414.7114,444.0312]},{"bsize":211,"origin":[-1682.0227,-312.2166,312.31]},{"bsize":211,"origin":[-2091.4194,-325.2221,303.0313]},{"bsize":304,"origin":[-2255.9231,-317.3531,396.0313]},{"bsize":355,"origin":[-482.376,-2087.4644,1172.3492]}] ]],
	["de_nuke"] = [[ {"1":{"bsize":51,"origin":{"1":-2645.54,"2":-881.376,"3":-255.886}},"2":{"bsize":60,"origin":{"1":-2647.47,"2":-763.488,"3":-246.886}},"3":{"bsize":47,"origin":{"1":-2547.37,"2":-876.388,"3":-259.886}},"4":{"bsize":47,"origin":{"1":-2546.98,"2":-756.442,"3":-259.886}},"5":{"bsize":144,"origin":{"1":2242.84,"2":-2140.28,"3":-52.2074}},"6":{"bsize":144,"origin":{"1":2243.03,"2":-1852.45,"3":-52.2629}},"7":{"bsize":82,"origin":{"1":2776.62,"2":-658.033,"3":22.5003}},"8":{"bsize":100,"origin":{"1":811.206,"2":178.432,"3":35.2251}},"9":{"bsize":99,"origin":{"1":1060.16,"2":-73.3405,"3":-38.9688}},"10":{"bsize":99,"origin":{"1":1059.97,"2":125.017,"3":-38.9688}},"11":{"bsize":99,"origin":{"1":1060.03,"2":323.219,"3":-38.9688}},"12":{"bsize":99,"origin":{"1":1060.53,"2":521.383,"3":-38.9688}},"13":{"bsize":99,"origin":{"1":1060.69,"2":719.362,"3":-38.9688}},"14":{"bsize":99,"origin":{"1":203.616,"2":732.337,"3":-38.9687}},"15":{"bsize":99,"origin":{"1":201.897,"2":535.056,"3":-38.9688}},"16":{"bsize":99,"origin":{"1":201.355,"2":336.281,"3":-38.9688}},"17":{"bsize":99,"origin":{"1":200.348,"2":138.27,"3":-38.9688}},"18":{"bsize":99,"origin":{"1":198.975,"2":-59.9723,"3":-38.9688}},"19":{"bsize":99,"origin":{"1":198.439,"2":-161.548,"3":-38.9688}},"20":{"bsize":99,"origin":{"1":387.169,"2":-168.236,"3":-38.9688}},"21":{"bsize":99,"origin":{"1":584.164,"2":-169.304,"3":-38.9687}},"22":{"bsize":99,"origin":{"1":781.928,"2":-170.017,"3":-38.9687}},"23":{"bsize":99,"origin":{"1":892.53,"2":-169.659,"3":-38.9687}},"24":{"bsize":100,"origin":{"1":1058.62,"2":-151.231,"3":-37.9688}},"25":{"bsize":271,"origin":{"1":1524.82,"2":-2167.31,"3":189.28}},"26":{"bsize":51,"origin":{"1":-2645.54,"2":-881.376,"3":-255.886}},"27":{"bsize":60,"origin":{"1":-2647.47,"2":-763.488,"3":-246.886}},"28":{"bsize":47,"origin":{"1":-2547.37,"2":-876.388,"3":-259.886}},"29":{"bsize":47,"origin":{"1":-2546.98,"2":-756.442,"3":-259.886}},"30":{"bsize":144,"origin":{"1":2242.84,"2":-2140.28,"3":-52.2074}},"31":{"bsize":144,"origin":{"1":2243.03,"2":-1852.45,"3":-52.2629}},"32":{"bsize":82,"origin":{"1":2776.62,"2":-658.033,"3":22.5003}},"33":{"bsize":100,"origin":{"1":811.206,"2":178.432,"3":35.2251}},"34":{"bsize":99,"origin":{"1":1060.16,"2":-73.3405,"3":-38.9688}},"35":{"bsize":99,"origin":{"1":1059.97,"2":125.017,"3":-38.9688}},"36":{"bsize":99,"origin":{"1":1060.03,"2":323.219,"3":-38.9688}},"37":{"bsize":99,"origin":{"1":1060.53,"2":521.383,"3":-38.9688}},"38":{"bsize":99,"origin":{"1":1060.69,"2":719.362,"3":-38.9688}},"39":{"bsize":99,"origin":{"1":203.616,"2":732.337,"3":-38.9687}},"40":{"bsize":99,"origin":{"1":201.897,"2":535.056,"3":-38.9688}},"41":{"bsize":99,"origin":{"1":201.355,"2":336.281,"3":-38.9688}},"42":{"bsize":99,"origin":{"1":200.348,"2":138.27,"3":-38.9688}},"43":{"bsize":99,"origin":{"1":198.975,"2":-59.9723,"3":-38.9688}},"44":{"bsize":99,"origin":{"1":198.439,"2":-161.548,"3":-38.9688}},"45":{"bsize":99,"origin":{"1":387.169,"2":-168.236,"3":-38.9688}},"46":{"bsize":99,"origin":{"1":584.164,"2":-169.304,"3":-38.9687}},"47":{"bsize":99,"origin":{"1":781.928,"2":-170.017,"3":-38.9687}},"48":{"bsize":99,"origin":{"1":892.53,"2":-169.659,"3":-38.9687}},"49":{"bsize":100,"origin":{"1":1058.62,"2":-151.231,"3":-37.9688}},"50":{"bsize":283,"origin":{"1":1550.16,"2":-1754.6,"3":208.88}},"51":{"bsize":283,"origin":{"1":2086.41,"2":-1809.79,"3":212.309}},"52":{"bsize":283,"origin":{"1":2083.96,"2":-2223.95,"3":213.046}}} ]],
	["dm_dust_housing_estate4"] = [[ {"1":{"bsize":74,"origin":{"1":-1508.97,"2":547.927,"3":320.031}},"2":{"bsize":74,"origin":{"1":-1510.32,"2":695.706,"3":320.031}},"3":{"bsize":74,"origin":{"1":-1366.62,"2":696.761,"3":320.031}},"4":{"bsize":74,"origin":{"1":-1361.58,"2":548.519,"3":320.031}},"5":{"bsize":74,"origin":{"1":-1212.67,"2":717.995,"3":320.031}},"6":{"bsize":74,"origin":{"1":-1206.08,"2":558.335,"3":320.031}},"7":{"bsize":74,"origin":{"1":-1064.52,"2":539.366,"3":320.031}},"8":{"bsize":74,"origin":{"1":-1065.06,"2":687.995,"3":320.031}},"9":{"bsize":38,"origin":{"1":-1078.28,"2":819.161,"3":284.031}},"10":{"bsize":38,"origin":{"1":-1028.31,"2":797.325,"3":284.031}},"11":{"bsize":94,"origin":{"1":1078.39,"2":917.02,"3":500.031}},"12":{"bsize":94,"origin":{"1":1079.31,"2":727.957,"3":500.031}},"13":{"bsize":94,"origin":{"1":1076.72,"2":538.577,"3":500.031}}} ]],
	["de_nightfever"] = [[ [{"bsize":22,"origin":[2006.87,1464.26,452.651]},{"bsize":22,"origin":[2061.3999,1370.09,454.12]},{"bsize":64,"origin":[-1071.9688,1178.9341,544.9247]},{"bsize":64,"origin":[-1068.1753,1176.4247,416.0313]},{"bsize":64,"origin":[-1071.9688,1582.0964,549.1359]},{"bsize":64,"origin":[-1071.9688,1579.2227,417.9947]},{"bsize":64,"origin":[-1027.9688,1562.3818,656.3957]},{"bsize":64,"origin":[-1071.9688,1185.1235,684.1007]},{"bsize":71,"origin":[-24.213,1133.603,525.0313]},{"bsize":79,"origin":[125.104,1138.6108,533.0313]},{"bsize":79,"origin":[-30.1714,1122.9514,405.0313]},{"bsize":79,"origin":[128.6802,1123.3569,405.0313]},{"bsize":79,"origin":[-23.8349,1151.9688,666.6642000000001]},{"bsize":79,"origin":[133.3139,1151.9688,666.7378]},{"bsize":91,"origin":[-1161.2676,877.5750000000001,627.9293]},{"bsize":453,"origin":[1852.8099,2758.6519,899.0313]},{"bsize":453,"origin":[1813.1465,3652.5828,883.0313]}] ]],
	["dm_torque"] = [[ [{"bsize":300,"origin":[-131.426,449.969,897.845]},{"bsize":77,"origin":[544.127,403.474,355.031]},{"bsize":77,"origin":[698.199,402.913,355.031]},{"bsize":77,"origin":[852.035,404.011,355.031]},{"bsize":77,"origin":[1006.49,404.202,355.031]},{"bsize":61,"origin":[529.933,264.966,339.031]},{"bsize":61,"origin":[650.313,264.782,339.031]},{"bsize":61,"origin":[772.295,264.583,339.031]},{"bsize":61,"origin":[895.846,266.363,339.031]},{"bsize":61,"origin":[1017.5,266.037,339.031]},{"bsize":551,"origin":[-1861.073,239.9997,1117.0313]},{"bsize":163,"origin":[767.8022,615.7344000000001,441.0313]}] ]],
	["dm_raven"] = [[ {"1":{"bsize":137,"origin":{"1":120.117,"2":-333.28,"3":370.645}},"2":{"bsize":137,"origin":{"1":101.722,"2":-576.504,"3":354.953}},"3":{"bsize":137,"origin":{"1":70.4824,"2":-811.071,"3":390.619}},"4":{"bsize":55,"origin":{"1":285.802,"2":-271.125,"3":372.344}},"5":{"bsize":55,"origin":{"1":386.467,"2":-278.004,"3":379.606}},"6":{"bsize":55,"origin":{"1":488.925,"2":-278.824,"3":380.471}},"7":{"bsize":55,"origin":{"1":590.995,"2":-278.008,"3":379.61}},"8":{"bsize":55,"origin":{"1":715.096,"2":-273.647,"3":375.006}},"9":{"bsize":186,"origin":{"1":-12.538,"2":-870.88,"3":522.021}},"10":{"bsize":223,"origin":{"1":491.828,"2":-628.381,"3":485.031}},"11":{"bsize":137,"origin":{"1":120.117,"2":-333.28,"3":370.645}},"12":{"bsize":137,"origin":{"1":101.722,"2":-576.504,"3":354.953}},"13":{"bsize":137,"origin":{"1":70.4824,"2":-811.071,"3":390.619}},"14":{"bsize":55,"origin":{"1":285.802,"2":-271.125,"3":372.344}},"15":{"bsize":55,"origin":{"1":386.467,"2":-278.004,"3":379.606}},"16":{"bsize":55,"origin":{"1":488.925,"2":-278.824,"3":380.471}},"17":{"bsize":55,"origin":{"1":590.995,"2":-278.008,"3":379.61}},"18":{"bsize":55,"origin":{"1":715.096,"2":-273.647,"3":375.006}},"19":{"bsize":186,"origin":{"1":-12.538,"2":-870.88,"3":522.021}},"20":{"bsize":223,"origin":{"1":491.828,"2":-628.381,"3":485.031}},"21":{"bsize":88,"origin":{"1":257.713,"2":-218.382,"3":526.031}},"22":{"bsize":203,"origin":{"1":476.173,"2":-149.581,"3":641.031}}} ]],
	["dm_biohazard"] = [[ [{"bsize":77,"origin":[937.521,-703.013,199.031]},{"bsize":632,"origin":[1832.11,-216.565,1014.03]},{"bsize":77,"origin":[937.521,-703.013,199.031]},{"bsize":632,"origin":[1832.11,-216.565,1014.03]},{"bsize":63,"origin":[975.56,-261.04,-138.969]},{"bsize":63,"origin":[880.2140000000001,-260.907,-138.969]},{"bsize":77,"origin":[937.521,-703.013,199.031]},{"bsize":632,"origin":[1832.11,-216.565,1014.03]},{"bsize":77,"origin":[937.521,-703.013,199.031]},{"bsize":632,"origin":[1832.11,-216.565,1014.03]},{"bsize":63,"origin":[975.56,-261.04,-138.969]},{"bsize":63,"origin":[880.2140000000001,-260.907,-138.969]},{"bsize":63,"origin":[981.734,-102.605,-138.969]},{"bsize":63,"origin":[977.175,-149.986,-138.969]},{"bsize":63,"origin":[892.404,-93.07980000000001,-138.969]},{"bsize":63,"origin":[891.61,-190.222,-138.969]},{"bsize":117,"origin":[744.1215999999999,-694.8757000000001,239.0313]},{"bsize":117,"origin":[743.4357,-570.9233,239.0313]}] ]],
	["dm_cloudcity"] = [[ {"1":{"bsize":481,"origin":{"1":9253.63,"2":6567.97,"3":1496.46}},"2":{"bsize":481,"origin":{"1":9608.97,"2":6166.09,"3":1495.03}},"3":{"bsize":481,"origin":{"1":9378.08,"2":5323.32,"3":1431.03}}} ]],
	["dm_megawatt"] = [[ {"1":{"bsize":694,"origin":{"1":-230.298,"2":-180.305,"3":1228.03}},"2":{"bsize":694,"origin":{"1":-233.02,"2":1013.93,"3":1228.03}}} ]],
	["dm_greenhouse"] = [[ {"1":{"bsize":320,"origin":{"1":-1088.0601,"2":-2278.8,"3":1174.03}},"2":{"bsize":320,"origin":{"1":-1252.97,"2":-2241.76,"3":1174.03}},"3":{"bsize":505,"origin":{"1":723.085,"2":-35.9956,"3":943.0313}},"4":{"bsize":505,"origin":{"1":724.5389,"2":-1043.7012,"3":943.0313}},"5":{"bsize":505,"origin":{"1":748.3268000000001,"2":-1778.4963,"3":1071.0313}},"6":{"bsize":505,"origin":{"1":-11.9444,"2":-2003.0654,"3":1071.0313}},"7":{"bsize":373,"origin":{"1":-582.2728,"2":-2139.146,"3":939.0313}}} ]],
	["ts_steel"] = [[ {"1":{"bsize":383,"origin":{"1":-765.195,"2":-419.182,"3":621.031}},"2":{"bsize":383,"origin":{"1":163.536,"2":289.257,"3":731.031}},"3":{"bsize":383,"origin":{"1":-430.966,"2":493.474,"3":731.031}},"4":{"bsize":383,"origin":{"1":-274.27,"2":-50.2046,"3":729.244}},"5":{"bsize":176,"origin":{"1":-150.189,"2":-604.528,"3":570.031}},"6":{"bsize":176,"origin":{"1":-237.467,"2":-608.515,"3":539.112}},"7":{"bsize":176,"origin":{"1":294.878,"2":-262.889,"3":570.031}},"8":{"bsize":176,"origin":{"1":294.854,"2":-491.654,"3":570.031}},"9":{"bsize":175,"origin":{"1":797.031,"2":-588.176,"3":377.119}},"10":{"bsize":273,"origin":{"1":816.534,"2":-560.031,"3":399.716}},"11":{"bsize":140,"origin":{"1":-586.663,"2":289.461,"3":344.031}},"12":{"bsize":140,"origin":{"1":-572.358,"2":93.995,"3":288.837}}} ]],
	["dm_laststop"] = [[ {"1":{"bsize":32,"origin":{"1":352.784,"2":219.708,"3":-19.228}},"2":{"bsize":32,"origin":{"1":379.969,"2":218.823,"3":-20.5481}},"3":{"bsize":42,"origin":{"1":341.944,"2":211.808,"3":-17.9688}},"4":{"bsize":42,"origin":{"1":238.82,"2":214.152,"3":-0.7664}}} ]],
	["dm_energize_b1"] = [[ {"1":{"bsize":672,"origin":{"1":1503.62,"2":-33.233,"3":958.031}},"2":{"bsize":515,"origin":{"1":266.329,"2":-247.285,"3":721.031}},"3":{"bsize":308,"origin":{"1":96.3064,"2":384.007,"3":530.031}},"4":{"bsize":247,"origin":{"1":503.995,"2":-437.363,"3":377.031}},"5":{"bsize":247,"origin":{"1":684.313,"2":-436.673,"3":377.031}},"6":{"bsize":278,"origin":{"1":1375.6,"2":-797.345,"3":412.031}},"7":{"bsize":236,"origin":{"1":-369.803,"2":1560.69,"3":384.476}},"8":{"bsize":236,"origin":{"1":-359.469,"2":1087.32,"3":394.89}},"9":{"bsize":236,"origin":{"1":-359.786,"2":775.41,"3":395.144}},"10":{"bsize":236,"origin":{"1":-323.836,"2":589.775,"3":434.661}},"11":{"bsize":276,"origin":{"1":104.389,"2":1884.46,"3":542.031}},"12":{"bsize":206,"origin":{"1":775.243,"2":1688.94,"3":241.619}},"13":{"bsize":206,"origin":{"1":1189.72,"2":1683.71,"3":247.002}},"14":{"bsize":241,"origin":{"1":1373.59,"2":1659.64,"3":290.282}},"15":{"bsize":241,"origin":{"1":1856.84,"2":1657.37,"3":298.592}},"16":{"bsize":241,"origin":{"1":2326.1,"2":1668.49,"3":280.54}},"17":{"bsize":123,"origin":{"1":1809.03,"2":1433.12,"3":177.031}},"18":{"bsize":297,"origin":{"1":2083.44,"2":819.72,"3":191.031}},"19":{"bsize":297,"origin":{"1":2101.02,"2":1412.85,"3":191.031}}} ]],
	["dm_filth_v1"] = [[ {"1":{"bsize":824,"origin":{"1":308.1088,"2":192.0312,"3":825.0801}},"2":{"bsize":580,"origin":{"1":-1045.4823,"2":-102.3824,"3":570.0313}},"3":{"bsize":580,"origin":{"1":-1023.9688,"2":1062.9723,"3":578.1664}},"4":{"bsize":849,"origin":{"1":-960.0313,"2":182.4601,"3":820.4934}},"5":{"bsize":849,"origin":{"1":-1216.0313,"2":915.6954,"3":821.6118}},"6":{"bsize":849,"origin":{"1":439.0177,"2":185.4274,"3":821.8067}},"7":{"bsize":500,"origin":{"1":-1147.4514,"2":1122.48,"3":472.8067}}} ]],
	["dm_moil_final"] = [[ {"1":{"bsize":207,"origin":{"1":724.542,"2":-295.369,"3":230.031}},"2":{"bsize":225,"origin":{"1":710.779,"2":-571.439,"3":317.251}},"3":{"bsize":225,"origin":{"1":893.712,"2":-1147.34,"3":239.031}}} ]],
	["dm_steamlab"] = [[ [{"bsize":83,"origin":[-1106.5587158203,3006.7470703125,961.03125]},{"bsize":77,"origin":[-1403.8455810547,1341.3696289063,963.65509033203]},{"bsize":76,"origin":[-1406.7523193359,1191.2999267578,962.03125]},{"bsize":38,"origin":[-2568.9868164063,3003.5056152344,916.03125]},{"bsize":38,"origin":[-2569.0239257813,3079.3444824219,916.03125]},{"bsize":38,"origin":[-2531.0727539063,3079.400390625,916.03125]},{"bsize":38,"origin":[-2531.2214355469,3003.578125,916.03125]},{"bsize":37,"origin":[-1851.96875,3372.1313476563,1082.1063232422]},{"bsize":51,"origin":[-1909.7431640625,3295.9536132813,1049.8850097656]},{"bsize":51,"origin":[-1909.6888427734,3204.3781738281,1049.8894042969]},{"bsize":37,"origin":[-1895.7310791016,3340.6535644531,1083.03125]}] ]],
	["dm_zest"] = [[ {"1":{"bsize":110,"origin":{"1":-715.413,"2":191.46,"3":620.031}},"2":{"bsize":110,"origin":{"1":-496.256,"2":186.748,"3":620.031}},"3":{"bsize":110,"origin":{"1":-310.58,"2":153.816,"3":620.031}},"4":{"bsize":110,"origin":{"1":-715.413,"2":191.46,"3":620.031}},"5":{"bsize":110,"origin":{"1":-496.256,"2":186.748,"3":620.031}},"6":{"bsize":110,"origin":{"1":-310.58,"2":153.816,"3":620.031}},"7":{"bsize":643,"origin":{"1":-352.973,"2":111.969,"3":1045.85}}} ]],
	["cs_apartments"] = [[ [{"bsize":90,"origin":[-1014.2869,1007.9688,536.2079]},{"bsize":90,"origin":[-1015.869,843.6064,535.9132]},{"bsize":90,"origin":[-1016.084,716.2378,536.1282]},{"bsize":90,"origin":[-860.0164,711.6954,531.6143]},{"bsize":90,"origin":[-813.7003,673.3869999999999,509.7445]},{"bsize":90,"origin":[-813.7612,507.2019,509.8054]},{"bsize":55,"origin":[-972.4452,751.5826,457.4894]},{"bsize":55,"origin":[-972.0044,859.7876,457.0485]},{"bsize":55,"origin":[-972.2941,969.0426,457.3383]},{"bsize":55,"origin":[-972.4772,1079.6545,457.5214]},{"bsize":55,"origin":[-877.5428000000001,747.4801,453.6728]},{"bsize":55,"origin":[-804.2167,747.8049,453.2831]}] ]],
	["dm_overwatch"] = [[ [{"bsize":79,"origin":[5989.9467773438,6404.30078125,549.03125]},{"bsize":79,"origin":[5989.7094726563,6295.00390625,549.03125]},{"bsize":38,"origin":[6216.193359375,6316.4038085938,412.03125]},{"bsize":38,"origin":[6216.3657226563,6272.9838867188,412.03125]},{"bsize":38,"origin":[6105.99609375,6311.017578125,480.04013061523]},{"bsize":38,"origin":[6107.021484375,6274.623046875,479.35659790039]},{"bsize":137,"origin":[6719.748046875,6329.6064453125,887.03125]},{"bsize":146,"origin":[6458.2514648438,6334.9272460938,896.03125]},{"bsize":323,"origin":[6201.9672851563,6470.7485351563,1073.03125]},{"bsize":238,"origin":[7252.2719726563,6205.1591796875,772.013671875]},{"bsize":238,"origin":[6972.9638671875,6274.5561523438,796.03125]},{"bsize":238,"origin":[6718.0434570313,6272.7666015625,796.03125]},{"bsize":238,"origin":[6465.26953125,6271.7255859375,796.03125]},{"bsize":167,"origin":[6980.958984375,6644.9418945313,725.03125]},{"bsize":167,"origin":[6711.96875,6630.5693359375,720.58178710938]},{"bsize":167,"origin":[6464.2880859375,6642.5517578125,725.03125]}] ]],
	["dm_datacore"] = [[ {"1":{"bsize":132,"origin":{"1":1175.97,"2":-315.875,"3":750.434}}} ]],
	["dm_rebels_2"] = [[ {"1":{"bsize":303,"origin":{"1":-1139.23,"2":279.586,"3":554.031}},"2":{"bsize":303,"origin":{"1":-1140.3,"2":-325.971,"3":554.031}},"3":{"bsize":303,"origin":{"1":-129.103,"2":-362.964,"3":621.031}},"4":{"bsize":303,"origin":{"1":-129.002,"2":242.26,"3":621.031}},"5":{"bsize":296,"origin":{"1":-137.668,"2":546.705,"3":614.031}},"6":{"bsize":296,"origin":{"1":-135.291,"2":717.836,"3":614.031}}} ]],
	["dm_phallan"] = [[ [{"bsize":91,"origin":[507.7309,-255.8919,849.0313]},{"bsize":91,"origin":[257.8416,-126.8722,849.0313]},{"bsize":132,"origin":[380.7781,-224.9812,890.0313]}] ]],
	["dm_underpass"] = [[ {"1":{"bsize":32,"origin":{"1":-1179.86,"2":-2155.4,"3":-23.9688}},"2":{"bsize":78,"origin":{"1":-1277.98,"2":-2170.27,"3":20.0313}},"3":{"bsize":33,"origin":{"1":-706.945,"2":-2306.64,"3":25.0313}},"4":{"bsize":118,"origin":{"1":-1049.29,"2":-2408.19,"3":60.0313}},"5":{"bsize":118,"origin":{"1":-916.399,"2":-2408.04,"3":60.0313}},"6":{"bsize":40,"origin":{"1":-434.528,"2":-1676.97,"3":354.031}},"7":{"bsize":140,"origin":{"1":-450.633,"2":-1856.74,"3":454.031}}} ]],
	["dm_outlying_v2"] = [[ [{"bsize":174,"origin":[950.9399,-1293.4784,1289.0313]},{"bsize":220,"origin":[2082.168,-951.1095,-463.2892]},{"bsize":220,"origin":[2224.1733,-925.0507,-485.4439]},{"bsize":244,"origin":[2673.6885,-616.4246000000001,-333.9688]},{"bsize":206,"origin":[2793.9688,-207.6191,-352.9237]}] ]],
	["dm_resistance"] = [[ [{"bsize":133,"origin":[-280.92071533203,-566.03363037109,-636.1767578125]},{"bsize":133,"origin":[-320.67797851563,-692.21636962891,-658.34497070313]},{"bsize":62,"origin":[-206.35499572754,-472.81433105469,-173.03045654297]},{"bsize":62,"origin":[141.27067565918,-480.03063964844,-379.66845703125]},{"bsize":62,"origin":[525.59448242188,-492.40756225586,-379.66845703125]},{"bsize":133,"origin":[143.26229858398,569.37756347656,-820.96875]},{"bsize":226,"origin":[387.33975219727,514.78094482422,-807.96875]},{"bsize":133,"origin":[-280.92071533203,-566.03363037109,-636.1767578125]},{"bsize":133,"origin":[-320.67797851563,-692.21636962891,-658.34497070313]},{"bsize":62,"origin":[-206.35499572754,-472.81433105469,-173.03045654297]},{"bsize":62,"origin":[141.27067565918,-480.03063964844,-379.66845703125]},{"bsize":62,"origin":[525.59448242188,-492.40756225586,-379.66845703125]},{"bsize":133,"origin":[143.26229858398,569.37756347656,-820.96875]},{"bsize":226,"origin":[387.33975219727,514.78094482422,-807.96875]},{"bsize":105,"origin":[-21.017148971558,355.68267822266,-864.96875]}] ]],
	["dm_lockdown"] = [[ [{"bsize":113,"origin":[-3468.1001,6049.7798,103.031]},{"bsize":113,"origin":[-3243.6599,6049.8501,103.031]},{"bsize":113,"origin":[-3158.8501,6049.6499,103.031]},{"bsize":113,"origin":[-3642.98,6049.6802,103.031]},{"bsize":343,"origin":[-3897.23,2977.53,605.031]},{"bsize":343,"origin":[-3896.0901,2291.6399,605.031]},{"bsize":343,"origin":[-3556.4199,2293.03,605.031]},{"bsize":343,"origin":[-3553.1101,2979.3501,605.031]},{"bsize":210,"origin":[-3473.1001,3575.75,472.031]},{"bsize":32,"origin":[-3085.0405,5740.0186,24.0313]},{"bsize":32,"origin":[-3085.1829,5800.6348,24.0313]},{"bsize":32,"origin":[-3081.9988,5847.9688,27.3479]},{"bsize":32,"origin":[-3137.615,5827.0527,24.0313]},{"bsize":32,"origin":[-3181.8696,5826.9385,24.0313]},{"bsize":32,"origin":[-3222.4121,5826.8447,24.0312]}] ]],
	["fy_highrise_09"] = [[ [{"bsize":557,"origin":[-1.9484,1066.3876,-4156.9688]},{"bsize":557,"origin":[-1.392,-48.0957,-4156.9688]},{"bsize":557,"origin":[0.5341,-1143.1761,-4156.9688]}] ]],
	["dm_shockstreet_b2"] = [[ [{"bsize":245,"origin":[2612.0771,-2029.4413,705.0313]},{"bsize":245,"origin":[3008.2649,-1956.0115,937.0313]},{"bsize":245,"origin":[2677.2288,-1651.8726,937.0313]},{"bsize":245,"origin":[3108.8811,-1954.7305,937.0313]},{"bsize":257,"origin":[3572.2175,-1760.0313,991.6725]},{"bsize":126,"origin":[3425.3281,-2096.4507,586.0313]},{"bsize":126,"origin":[3425.1721,-1844.9847,586.0313]},{"bsize":19,"origin":[3641.967,-2122.0051,456.9945]},{"bsize":19,"origin":[3605.5659,-2117.9409,455.3779]},{"bsize":19,"origin":[3567.4104,-2116.7156,455.0062]},{"bsize":19,"origin":[3542.342,-2122.9851,457.4937]},{"bsize":410,"origin":[3919.4224,-2473.4678,1064.0313]},{"bsize":410,"origin":[3987.3669,-3190.4392,1016.0313]},{"bsize":410,"origin":[3690.7983,-3192.9324,1016.0313]},{"bsize":469,"origin":[2963.623,-4387.0151,1187.0313]},{"bsize":469,"origin":[3270.9336,-4396.666,1187.0313]},{"bsize":469,"origin":[3822.6487,-4317.5088,1395.0313]},{"bsize":469,"origin":[1759.2928,-3560.9661,1099.0313]},{"bsize":469,"origin":[1832.4916,-2731.4368,1107.0313]},{"bsize":469,"origin":[1827.5583,-2079.3403,1107.0313]},{"bsize":51,"origin":[1725.0131,-3099.4368,409.7271]},{"bsize":245,"origin":[1699.9938,-3130.9912,748.0354]},{"bsize":238,"origin":[4722.6567,-3814.9094,700.0313]},{"bsize":238,"origin":[4529.9902,-4163.0474,910.8433]},{"bsize":315,"origin":[4343.2959,-4936.9561,361.0313]},{"bsize":105,"origin":[4137.4922,-4584.6685,155.0313]},{"bsize":105,"origin":[4344.644,-4581.3564,151.0313]},{"bsize":105,"origin":[4451.9194,-4608.856,181.3725]},{"bsize":105,"origin":[4535.9688,-4116.3501,600.6312]},{"bsize":105,"origin":[4535.9688,-4326.3218,600.437]},{"bsize":105,"origin":[4535.9688,-4534.7041,600.8511]},{"bsize":443,"origin":[5279.0698,-3895.9688,1307.6915]},{"bsize":443,"origin":[5229.7388,-3302.3901,1025.0313]},{"bsize":443,"origin":[4777.0342,-2832.0313,1206.7075]},{"bsize":189,"origin":[4072.0313,-4903.9297,1036.8798]},{"bsize":189,"origin":[4125.1187,-4922.5986,958.3506]},{"bsize":510,"origin":[5104.0313,-5594.2578,732.6902]},{"bsize":510,"origin":[4540.1118,-5310.7778,556.0313]},{"bsize":328,"origin":[4686.8589,-2832.0313,1007.8936]},{"bsize":250,"origin":[2433.9426,-1581.2338,919.0477]},{"bsize":66,"origin":[1880.1986,-3914.9946,589.048]},{"bsize":66,"origin":[2030.0472,-3910.0332,594.0095]}] ]],
	["dm_backbone"] = [[ [{"bsize":116,"origin":[541.1144000000001,-391.5228,708.2032]},{"bsize":116,"origin":[583.532,588.7128,660.312]},{"bsize":116,"origin":[221.1565,-237.7011,647.7632]}] ]],
	["dm_astera"] = [[ [{"bsize":1069,"origin":[-935.082,685.0168,4771.0313]},{"bsize":1071,"origin":[-936.7601,1744.9146,4773.0313]},{"bsize":151,"origin":[-852.2258000000001,2073.9756,3757.0313]},{"bsize":185,"origin":[-14.4333,175.1474,3535.0313]},{"bsize":185,"origin":[-94.0603,-82.92959999999999,3535.0313]},{"bsize":185,"origin":[-461.3978,-83.2992,3535.0313]}] ]],
	["dm_lostarena"] = [[ [{"bsize":1341,"origin":[30.1461,51.9702,1515.7067]}] ]],
}



//only used to gather latest map profiles from the server
local function GatherMapStuff( pl )
	
	
	local data = "GM.DefaultKOTHPoints = {\n"
	
	for k, v in pairs( MapCycle ) do
		if file.Exists( "darkestdays/koth_points/"..v..".txt", "DATA" ) then
			data = data.."	[\""..v.."\"] = [[ "..file.Read( "darkestdays/koth_points/"..v..".txt" ).." ]],\n"
		end
	end
	
	data = data.."}\n\n"
	
	data = data.."GM.DefaultExploitBoxes = {\n"
	
	for k, v in pairs( MapCycle ) do
		if file.Exists( "darkestdays/exploits/"..v..".txt", "DATA" ) then
			data = data.."	[\""..v.."\"] = [[ "..file.Read( "darkestdays/exploits/"..v..".txt" ).." ]],\n"
		end
	end
	
	data = data.."}\n\n"
	
	
	file.Write( "darkestdays/dd_mapdata.txt", data )
end
//concommand.Add( "dd_gathermapdata", GatherMapStuff )
