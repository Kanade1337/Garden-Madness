
MUSIC = {
	{"http://cayon.pl/gm_sounds/bg1.mp3", true},
	{"http://cayon.pl/gm_sounds/bg2.mp3", true},
	{"http://cayon.pl/gm_sounds/bg3.mp3", true},
	{"http://cayon.pl/gm_sounds/bg4.mp3", true},
	{"http://cayon.pl/gm_sounds/bg5.mp3", true},
	{"http://cayon.pl/gm_sounds/bg6.mp3", true},
	{"http://cayon.pl/gm_sounds/bg7.mp3", true},
	{"http://cayon.pl/gm_sounds/bg8.mp3", true}
}

VICTORYSOUNDS = {
	flowers = {
		{"http://cayon.pl/gm_sounds/plantVictory_v1.mp3", false},
		{"http://cayon.pl/gm_sounds/plantVictory_v2.mp3", false},
		{"http://cayon.pl/gm_sounds/plantVictory_v3.mp3", false},
		{"http://cayon.pl/gm_sounds/plantVictory_v4.mp3", false}
	},
	garden = {
		{"http://cayon.pl/gm_sounds/gardenerVictory_v1.mp3", false},
		{"http://cayon.pl/gm_sounds/gardenerVictory_v2.mp3", false},
		{"http://cayon.pl/gm_sounds/gardenerVictory_v3.mp3", false},
		{"http://cayon.pl/gm_sounds/gardenerVictory_v4.mp3", false},
		{"http://cayon.pl/gm_sounds/gardenerVictory_v5.mp3", false}
	},
	noone = {
		{"http://cayon.pl/gm_sounds/nobodyVictory.mp3", false}
	}
}


function DestroyTimers()
	local tab = {"PreparingTimer", "RoundTimer", "RoundTimer", "PostroundTimer", "StartingRound", "CheckPlayers", "Victory", "BombWait", "Tip1"}
	for k,v in pairs(tab) do
		timer.Destroy(v)
	end
	for k,v in pairs(gteams.GetPlayers(TEAM_DEAD)) do
		timer.Destroy("Spawn" .. v:SteamID())
	end
end

function StopTimers()
	local tab = {"PreparingTimer", "RoundTimer", "RoundTimer", "PostroundTimer", "StartingRound", "CheckPlayers", "Victory", "BombWait", "Tip1"}
	for k,v in pairs(tab) do
		timer.Stop(v)
	end
	for k,v in pairs(gteams.GetPlayers(TEAM_DEAD)) do
		timer.Destroy("Spawn" .. v:SteamID())
	end
end

function Checkeverything()
	print("Number of players "..#player.GetAll())
	print("Number of flowers "..#gteams.GetPlayers(TEAM_FLOWERS))
	print("Number of gardeners "..#gteams.GetPlayers(TEAM_GARDEN))
	print("Number of deads "..#gteams.GetPlayers(TEAM_DEAD))
end
concommand.Add( "checkthingsxd", Checkeverything)

function GetGSpawns()
	local gardenspawns = {}
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "info_player_terrorist"
		or v:GetClass() == "info_player_counterterrorist"
		or v:GetClass() == "info_player_start" then
			table.ForceInsert(gardenspawns, v:GetPos())
		end
	end
	return gardenspawns
end

function SpawnPlayers()
	local gardenspawns = GetGSpawns()
	print("Found " .. tostring(#gardenspawns) .. " gardener spawns.")
	if #gardenspawns < #gteams.GetPlayers(TEAM_GARDEN) then
		Error( "Not enough spawns for gardeners\n" )
	end
	
	for k,v in pairs(player.GetAll()) do
		v:Spawn()
		if v.wantteam == TEAM_GARDEN then
			
			local posk = math.random(1,#gardenspawns)
			v:SetPos(gardenspawns[posk])
			table.remove(gardenspawns, posk)
			
			v:SetGardener()
			v:SetEyeAngles(Angle(-90,0,0))
		elseif v.wantteam == TEAM_FLOWERS then
			v:SetFlower(v.Class)
		end
		Unspectate( v )
	end
end

function FreezeGardeners(bool)
	for k,v in pairs(gteams.GetPlayers( TEAM_GARDEN )) do
		v:Freeze(bool)
	end
end

hook.Add("RoundEnd", "stopsoundsafterround", function()
	net.Start("StopSounds")
	net.Broadcast()
end)

hook.Add("RoundEnd_Flowers", "victorysounds_flowers", function()
	local rnds = table.Random(VICTORYSOUNDS["flowers"])
	net.Start("SendSound")
		net.WriteString(rnds[1])
		net.WriteBool(rnds[2])
	net.Broadcast()
end)

hook.Add("RoundEnd_Gardeners", "victorysounds_gardeners", function()
	local rnds = table.Random(VICTORYSOUNDS["garden"])
	net.Start("SendSound")
		net.WriteString(rnds[1])
		net.WriteBool(rnds[2])
	net.Broadcast()
end)

hook.Add("RoundEnd_Noone", "victorysounds_noone", function()
	local rnds = table.Random(VICTORYSOUNDS["noone"])
	net.Start("SendSound")
		net.WriteString(rnds[1])
		net.WriteBool(rnds[2])
	net.Broadcast()
end)

function Victory()
	if GetGlobalInt("RoundNumber") == 0 then return end
	if preparing or postround then return end
	if GetGlobalInt("FLMode") == MODE_CASUAL then
		local sstart = false
		if GetGlobalInt("FlowersScore") >= GetMaxScore() then
			ColouredMsg(color_white, "Score limit reached, ", gteams.GetColor(TEAM_FLOWERS), "PLANTS", color_white, " win!")
			PrintMessage(HUD_PRINTCENTER, "Plants win!")
			hook.Run( "RoundEnd" )
			hook.Run( "RoundEnd_Flowers" )
			for k,v in pairs(gteams.GetPlayers(TEAM_FLOWERS)) do
				v:AddFrags( 25 )
			end
			net.Start("SendEndPic")
				net.WriteString("fs")
			net.Broadcast()
			sstart = true
		elseif GetGlobalInt("GardenersScore") >= GetMaxScore() then
			ColouredMsg(color_white, "Score limit reached, ", gteams.GetColor(TEAM_GARDEN), "GARDENERS", color_white, " win!")
			PrintMessage(HUD_PRINTCENTER, "Gardeners win!")
			for k,v in pairs(gteams.GetPlayers(TEAM_GARDEN)) do
				v:AddFrags( 25 )
			end
			hook.Run( "RoundEnd" )
			hook.Run( "RoundEnd_Gardeners" )
			net.Start("SendEndPic")
				net.WriteString("gbs")
			net.Broadcast()
			sstart = true
		end
		if sstart then
			DestroyTimers()
			BroadcastLua( 'preparing = false' )
			BroadcastLua( 'postround = true' )
			preparing = false
			postround = true
			timer.Create("Victory", GetConVar("gma_posttime"):GetInt(), 1, RoundRestart)
			timer.Create("Say1timer", 1, 1, function() PrintMessage(HUD_PRINTTALK, "Next round will start in " .. tostring(GetConVar("gma_posttime"):GetInt()) .. " seconds") end)
		end
	end
	if #gteams.GetPlayers(TEAM_GARDEN) == 0 then
		ColouredMsg(color_white, "All gardeners are dead, ", gteams.GetColor(TEAM_FLOWERS), "PLANTS", color_white, " win!")
		PrintMessage(HUD_PRINTCENTER, "Plants win!")
		hook.Run( "RoundEnd" )
		hook.Run( "RoundEnd_Flowers" )
		for k,v in pairs(gteams.GetPlayers(TEAM_FLOWERS)) do
			v:AddFrags( 25 )
		end
		net.Start("SendEndPic")
			net.WriteString("fe")
		net.Broadcast()
		DestroyTimers()
		BroadcastLua( 'preparing = false' )
		BroadcastLua( 'postround = true' )
		preparing = false
		postround = true
		timer.Create("Victory", GetConVar("gma_posttime"):GetInt(), 1, RoundRestart)
		timer.Create("Say1timer", 1, 1, function() PrintMessage(HUD_PRINTTALK, "Next round will start in " .. tostring(GetConVar("gma_posttime"):GetInt()) .. " seconds") end)
		return
	end
	if #gteams.GetPlayers(TEAM_FLOWERS) == 0 then
		ColouredMsg(color_white, "All plants are dead, ", gteams.GetColor(TEAM_GARDEN), "GARDENERS", color_white, " win!")
		PrintMessage(HUD_PRINTCENTER, "Gardeners win!")
		hook.Run( "RoundEnd" )
		hook.Run( "RoundEnd_Gardeners" )
		for k,v in pairs(gteams.GetPlayers(TEAM_GARDEN)) do
			v:AddFrags( 25 )
		end
		net.Start("SendEndPic")
			net.WriteString("ge")
		net.Broadcast()
		DestroyTimers()
		BroadcastLua( 'preparing = false' )
		BroadcastLua( 'postround = true' )
		preparing = false
		postround = true
		timer.Create("Victory", GetConVar("gma_posttime"):GetInt(), 1, RoundRestart)
		return
	end
end
hook.Add("Victorycheck1", "PlayerDisconnected", Victory)

timer.Create("Checkplayers", 3, 1, Victory)

function ChangeMode()
	local flmode = GetConVar("gma_mode"):GetString()
	
	if flmode == "competetive" then
		if GetGlobalInt("FLMode") != MODE_COMP then
			SetGlobalInt("FLMode", MODE_COMP)
			ColouredMsg(Color(50,255,50), "Changed mode to competetive")
		end
	elseif flmode == "casual" then
		if GetGlobalInt("FLMode") != MODE_CASUAL then
			SetGlobalInt("FLMode", MODE_CASUAL)
			ColouredMsg(Color(50,255,50), "Changed mode to casual")
		end
	elseif flmode == "arcade" then
		if GetGlobalInt("FLMode") != MODE_ARCADE then
			SetGlobalInt("FLMode", MODE_ARCADE)
			ColouredMsg(Color(50,255,50), "Changed mode to arcade")
		end
	elseif GetGlobalInt("FLMode") != MODE_COMP then
		SetGlobalInt("FLMode", MODE_COMP)
		ColouredMsg(Color(50,255,50), "Changed mode to competetive")
	end
end

function RoundRestart()
	net.Start("StopSounds")
	net.Broadcast()
	
	local rnds = table.Random(MUSIC)
	
	net.Start("SendSound")
		net.WriteString(rnds[1])
		net.WriteBool(rnds[2])
	net.Broadcast()
	
	if ConVarExists("gma_maxrounds") then
		print("Rounds: " .. GetGlobalInt("RoundNumber") .. "/" .. GetConVar("gma_maxrounds"):GetInt())
		if GetGlobalInt("RoundNumber") >= GetConVar("gma_maxrounds"):GetInt() then
			hook.Run("MapChange")
		elseif GetConVar("gma_maxrounds"):GetInt() - 1 == GetGlobalInt("RoundNumber") then
			PrintMessage(HUD_PRINTTALK, "Map will change after this round.")
		elseif GetGlobalInt("RoundNumber") == math.floor(GetConVar("gma_maxrounds"):GetInt() / 3 ) or GetGlobalInt("RoundNumber") == math.floor(GetConVar("gma_maxrounds"):GetInt() / 1.5 ) then
			for k,v in pairs(player.GetAll()) do
				if v.wantteam == TEAM_FLOWERS then
					v.wantteam = TEAM_GARDEN
				else
					v.wantteam = TEAM_FLOWERS
				end
			end
		end
	end
	SetGlobalInt("FlowersScore", 0)
	SetGlobalInt("GardenersScore", 0)
	SetGlobalInt("RoundNumber", GetGlobalInt("RoundNumber") + 1)
	ChangeMode()
	for k,v in pairs(player.GetAll()) do
		v:Freeze(false)
	end
	gteams.SetPoints( TEAM_FLOWERS, 0 )
	gteams.SetPoints( TEAM_GARDEN, 0 )
	BroadcastLua( 'preparing = true' )
	BroadcastLua( 'postround = false' )
	preparing = true
	postround = false
	flowerscanattack = false
	BroadcastLua( 'flowerscanattack = false' )
	local time_preparing = 	GetConVar("gma_preparingtime"):GetInt()
	local time_round 	 =  GetConVar("gma_roundtime"):GetInt()
	local time_postround = 	GetConVar("gma_posttime"):GetInt()
	local time_bombwait = 	GetConVar("gma_attackinterval"):GetInt()
	DestroyTimers()
	SpawnPlayers()
	FreezeGardeners(true)
	game.CleanUpMap()
	LoadBushes()
	hook.Run( "PreparingStart" )
	local sec = tostring(time_preparing)
	ColouredMsg(color_white, "Round is starting in ", Color(220,220,0), sec, color_white, " seconds")
	timer.Create( "PreparingTimer", time_preparing, 1, function()
		ColouredMsg(color_white, "Round has started,", Color(220,220,0), " good luck!")
		timer.Create( "Tip", 1, 1, function()
			local sec = tostring(time_bombwait)
			ColouredMsg(gteams.GetColor(TEAM_FLOWERS), "Plants", color_white, " will be able to attack in ", Color(200,200,0), sec, color_white, " seconds")
		end)
		for k,v in pairs(player.GetAll()) do
			v:Freeze(false)
		end
		timer.Create( "BombWait", time_bombwait, 1, function()
			BroadcastLua( 'flowerscanattack = true' )
			flowerscanattack = true
			ColouredMsg(gteams.GetColor(TEAM_FLOWERS), "Plants", color_white, " are able to attack now, ", Color(200,200,0), "be aware gardeners!")
		end)
		BroadcastLua( 'preparing = false' )
		BroadcastLua( 'postround = false' )
		preparing = false
		postround = false
		hook.Run( "RoundStart" )
		timer.Create( "RoundTimer", time_round, 1, function()
			if GetGlobalInt("FLMode") == MODE_CASUAL then
				if gteams.GetPoints(TEAM_FLOWERS) == gteams.GetPoints(TEAM_GARDEN) then
					ColouredMsg(Color(200,200,0), "Time is up!", color_white, " Both teams had the same score!")
					hook.Run( "RoundEnd" )
					hook.Run( "RoundEnd_Noone" )
					net.Start("SendEndPic")
						net.WriteString("nt")
					net.Broadcast()
				end
				if gteams.GetPoints(TEAM_FLOWERS) > gteams.GetPoints(TEAM_GARDEN) then
					ColouredMsg(Color(200,200,0), "Time is up!", gteams.GetColor(TEAM_FLOWERS), " Plants", color_white, " win with the biggest score!")
					hook.Run( "RoundEnd" )
					hook.Run( "RoundEnd_Flowers" )
					for k,v in pairs(gteams.GetPlayers(TEAM_FLOWERS)) do
						v:AddFrags( 25 )
					end
					net.Start("SendEndPic")
						net.WriteString("ftb")
					net.Broadcast()
				end
				if gteams.GetPoints(TEAM_FLOWERS) < gteams.GetPoints(TEAM_GARDEN) then
					ColouredMsg(Color(200,200,0), "Time is up!", gteams.GetColor(TEAM_GARDEN), " Gardeners", color_white, " win with the biggest score!")
					hook.Run( "RoundEnd" )
					hook.Run( "RoundEnd_Gardeners" )
					for k,v in pairs(gteams.GetPlayers(TEAM_GARDEN)) do
						v:AddFrags( 25 )
					end
					net.Start("SendEndPic")
						net.WriteString("gtb")
					net.Broadcast()
				end
			else
				ColouredMsg(Color(200,200,0), "Time is up!", gteams.GetColor(TEAM_GARDEN), " GARDENERS", color_white, " win!")
				hook.Run( "RoundEnd" )
				hook.Run( "RoundEnd_Gardeners" )
				for k,v in pairs(gteams.GetPlayers(TEAM_GARDEN)) do
					v:AddFrags( 25 )
				end
				net.Start("SendEndPic")
					net.WriteString("gt")
				net.Broadcast()
			end
			BroadcastLua( 'preparing = false' )
			BroadcastLua( 'postround = true' )
			preparing = false
			postround = true
			hook.Run( "PostroundStart" )
			timer.Create( "PostroundTimer", time_postround, 1, function()
				RoundRestart()
			end)
		end)
	end)
end