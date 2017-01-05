
function PF()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.wantteam == TEAM_FLOWERS then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function PG()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.wantteam == TEAM_GARDEN then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function CheckPremium(ply)
	http.Fetch( "http://steamcommunity.com/groups/gmspremium/memberslistxml/?xml=1",
		function(body) -- On Success
		local playerIDStartIndex = string.find( tostring(body), "<steamID64>"..ply:SteamID64().."</steamID64>" )
			if playerIDStartIndex == nil then
				print("Player does not have a premium account")
			else
				print(ply:Nick() .. " does have a premium account")
				ply.Premium = true
			end
	end,
	function() -- On fail
		print("Couldn't get it the data from the Premium Steam Group. Rewards are unavailable!")
	end
	)
end

function GM:PlayerInitialSpawn( ply )
	ply.Premium = false
	CheckPremium(ply)
	ply:SetTeam(1)
	ply:SetNoCollideWithTeammates(true)
	player_manager.SetPlayerClass( ply, "class_default" )
	ply.Class = "classic"
	ply.freshspawn = true
	if GetGlobalInt("FLMode") != MODE_CASUAL then
		ply.willspawnasscpec = true
	end
	local fpl = #PF()
	local gpl = #PG()
	if fpl == gpl then
		ply.wantteam = TEAM_FLOWERS
	elseif fpl < gpl then
		ply.wantteam = TEAM_FLOWERS
	else
		ply.wantteam = TEAM_GARDEN
	end
	
	print("canstartthegame: (need 3 true to start)")
	print("- " .. tostring(#player.GetAll() >= GetConVar("gma_minimumplayers"):GetInt()))
	print("- " .. tostring(gamestarted == false))
	print("- " .. tostring(gamestarting == false))
	
	if #player.GetAll() >= GetConVar("gma_minimumplayers"):GetInt() and gamestarted == false and gamestarting == false then
		gamestarting = true
		timer.Create("CheckPlayers", 5, 1, function()
			ColouredMsg(color_white, "Starting game in ", Color(220,220,0), "5", color_white, " seconds...")
			gamestarted = true
			gamestarting = false
			BroadcastLua( 'gamestarted = true' )
			timer.Destroy("CheckPlayers")
			timer.Create("StartingRound", 5, 1, function()
				RoundRestart()
			end)
		end)
	end
end

function PlyDisconnected( ply )
	local allplayers = {}
	local shouldend = false
	for k,v in pairs(player.GetAll()) do
		if v != ply then
			table.ForceInsert(allplayers, v)
		else
			print("missing " .. ply:Nick())
		end
	end
	if GetGlobalInt("FLMode") != MODE_CASUAL then
		if ply:GetGTeam() == TEAM_FLOWERS then
			if #gteams.GetPlayers(TEAM_FLOWERS) - 1 < 1 then
				ColouredMsg(color_white, ply:Nick() .. " disconnected, ", gteams.GetColor(TEAM_GARDEN), "GARDENERS", color_white, " win!")
				shouldend = true
			end
		elseif ply:GetGTeam() == TEAM_GARDEN then
			if #gteams.GetPlayers(TEAM_GARDEN) - 1 < 1 then
				ColouredMsg(color_white, ply:Nick() .. " disconnected, ", gteams.GetColor(TEAM_FLOWERS), "PLANTS", color_white, " win!")
				shouldend = true
			end
		end
	end
	//end
	if shouldend == true then
		StopTimers()
		if #allplayers < GetConVar("gma_minimumplayers"):GetInt() then
			timer.Create("EndingGame", 5, 1, function()
				game.CleanUpMap()
				for k,v in pairs(player.GetAll()) do
					gamestarted = false
					BroadcastLua( 'gamestarted = false' )
					v:Spawn()
					v:StripWeapons()
					v:RemoveAllAmmo()
					Spectate(v)
				end			
			end)
		else
			DestroyTimers()
			BroadcastLua( 'preparing = false' )
			BroadcastLua( 'postround = true' )
			preparing = false
			postround = true
			timer.Create("Victory", GetConVar("gma_posttime"):GetInt(), 1, function()
				if #player.GetAll() < GetConVar("gma_minimumplayers"):GetInt() then
					gamestarted = false
					BroadcastLua( 'gamestarted = false' )
					for k,v in pairs(player.GetAll()) do
						v:Spawn()
						v:StripWeapons()
						v:RemoveAllAmmo()
						Spectate(v)
					end
				else
					RoundRestart()
				end
			end)
			timer.Create("Say1timer", 1, 1, function()
			PrintMessage(HUD_PRINTTALK, "Next round will start in " .. tostring(GetConVar("gma_posttime"):GetInt()) .. " seconds") end)
			shouldend = true
		end
	end
	//Spectate(ply)
end
hook.Add("PlayerDisconnected", "PlayerDisconnectedhook", PlyDisconnected)

function Spectate( ply )
	ply:Spectate(OBS_MODE_ROAMING)
	ply:SetNoDraw(true)
	ply:SetGTeam(TEAM_DEAD)
end

function Unspectate( ply )
	ply:Spectate(OBS_MODE_NONE)
	ply:UnSpectate()
	ply:SetNoDraw(false)
end

function GM:PlayerLoadout( ply )
	return true
end

function GM:PlayerSpawn( ply )
	ply:SetCustomCollisionCheck(true)
	
	if ply.willspawnasscpec then
		ply.willspawnasscpec = false
		Spectate( ply )
	end
	if ply.freshspawn then
		ply.freshspawn = false
		if GetGlobalInt("FLMode") == MODE_CASUAL then
			if ply.wantteam == TEAM_FLOWERS then
				ply:SetFlower()
				ply:SetPos(table.Random(mapexamples[game.GetMap()]))
			else
				ply:SetGardener()
				ply:SetPos(table.Random(GetGSpawns()))
			end
		end
	end
	ply:SetupHands()
end

function GM:PlayerDeathThink( ply )
	if (CurTime() >= ply.nextspawn) then
		if GetGlobalInt("FLMode") == MODE_CASUAL then
			ply:Spawn()
			ply:Freeze(false)
			if ply.wantteam == TEAM_FLOWERS then
				ply:SetFlower(ply.Class)
			elseif ply.wantteam == TEAM_GARDEN then
				ply:SetGardener()
			end
			if ply:GetGTeam() == TEAM_FLOWERS then
				ply:SetPos(table.Random(mapexamples[game.GetMap()]))
			end
		else
			ply:Spawn()
			Spectate(ply)
			ply:SetGTeam(TEAM_DEAD)
			ply:Freeze(false)
		end
		ply.nextspawn = math.huge
	end
end

function GM:PlayerDeath( victim, inflictor, attacker )
	victim.nextspawn = CurTime() + GetConVar("gma_spawntime"):GetInt()
	local mode = GetGlobalInt("FLMode")
	
	if victim:GetGTeam() == TEAM_GARDEN then
		if mode == "competetive" then
			victim:EmitSound( "vo/npc/male01/pain0".. tostring(1,9) ..".wav", 75, 100, 1 )
		else
			victim:EmitSound( "flowermod/wilhelm.wav", 75, 100, 1 )
		end
	end
	
	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end
	
	// player suicided / was slayed / killed by the gravity
	if attacker:IsWorld() or attacker:IsPlayer() == false or (attacker == victim) then
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( victim )
		net.Broadcast()
		if victim.blown == nil then
			if victim.blownhimself then
				victim.blownhimself = nil
				ColouredMsg(gteams.GetColor(victim:GetGTeam()), victim:Nick(), color_white, " blew up himself.")
			else
				ColouredMsg(gteams.GetColor(victim:GetGTeam()), victim:Nick(), color_white, " suicided.")
			end
		end
		if victim:GetGTeam() == TEAM_GARDEN then
			if #gteams.GetPlayers(TEAM_GARDEN) - 1 == 1 then
				ColouredMsg(gteams.GetColor(TEAM_GARDEN), gteams.GetPlayers(TEAM_GARDEN)[1]:Nick(), color_white, " is the last gardener! ", Color(220,220,0), "Plants, go get him!")
			end
		elseif victim:GetGTeam() == TEAM_FLOWERS then
			if #gteams.GetPlayers(TEAM_FLOWERS) - 1 == 1 then
				ColouredMsg(gteams.GetColor(TEAM_FLOWERS), gteams.GetPlayers(TEAM_FLOWERS)[1]:Nick(), color_white, " is the last plant! ", Color(220,220,0), "Gardeners, go get him!")
			end
		end
		if mode != MODE_CASUAL then victim:SetGTeam(TEAM_DEAD) end
	// player was killed by another player - flower victim
	elseif victim:GetGTeam() == TEAM_FLOWERS and attacker:GetGTeam() == TEAM_GARDEN then
		ColouredMsg(gteams.GetColor(TEAM_FLOWERS), victim:Nick(), color_white, " was killed by ", gteams.GetColor(TEAM_GARDEN), attacker:Nick())
		if mode != MODE_CASUAL then victim:SetGTeam(TEAM_DEAD) end
		if victim.blown == nil then
			gteams.AddPoints( TEAM_GARDEN, 1 )
		end
		if #gteams.GetPlayers(TEAM_FLOWERS) == 1 then
			ColouredMsg(gteams.GetColor(TEAM_FLOWERS), gteams.GetPlayers(TEAM_FLOWERS)[1]:Nick(), color_white, " is the last flower! ", Color(220,220,0), "Gardeners, go get him!")
		end
		net.Start( "PlayerKilledByPlayer" )
			net.WriteEntity( victim )
			net.WriteString( attacker:GetActiveWeapon():GetClass() )
			net.WriteEntity( attacker )
		net.Broadcast()
	// player was killed by another player - flower attacker
	elseif victim:GetGTeam() == TEAM_GARDEN and attacker:GetGTeam() == TEAM_FLOWERS then
		if mode != MODE_CASUAL then victim:SetGTeam(TEAM_DEAD) end
		if #gteams.GetPlayers(TEAM_GARDEN) == 1 then
			ColouredMsg(gteams.GetColor(TEAM_GARDEN), gteams.GetPlayers(TEAM_GARDEN)[1]:Nick(), color_white, " is the last gardener! ", Color(220,220,0), "Flowers, go get him!")
		end
		gteams.AddPoints( TEAM_FLOWERS, 1 )
		net.Start( "PlayerKilledByPlayer" )
			net.WriteEntity( victim )
			net.WriteString( attacker:GetActiveWeapon():GetClass() )
			net.WriteEntity( attacker )
		net.Broadcast()
	end
	if victim.blown then
		victim.blown = nil
	end
	if mode == MODE_CASUAL then
		print("flowers: " .. gteams.GetPoints(TEAM_FLOWERS))
		print("gardeners: " .. gteams.GetPoints(TEAM_GARDEN))
		Victory()
		return
	end
	if #gteams.GetPlayers(TEAM_FLOWERS) == 1 and #gteams.GetPlayers(TEAM_GARDEN) == 1 then
		ColouredMsg(Color(220,220,0), "1V1! ", gteams.GetColor(TEAM_FLOWERS), gteams.GetPlayers(TEAM_FLOWERS)[1]:Nick(), color_white, " versus ", gteams.GetColor(TEAM_GARDEN), gteams.GetPlayers(TEAM_GARDEN)[1]:Nick())
	end
	Victory()
end

function GM:CanPlayerSuicide( ply )
	if ply:GetGTeam() == TEAM_DEAD then return end
	if GetGlobalInt("FLMode") == MODE_CASUAL then
		return true
	end
	ply:PrintMessage(HUD_PRINTCONSOLE, "You can't suicide in competetive and arcade mode.")
	return false
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	
	if ply:GetGTeam() == TEAM_GARDEN then
		ply:AddDeaths(1)
	end
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker != ply ) then
			attacker:AddFrags( 5 )
		end
	end
end
 
function playershouldtakedamage(victim, attacker)
	if preparing then return false end
	if postround then return false end
	
	if victim == attacker then return true end
	if attacker:IsWorld() then return true end
	if attacker:IsPlayer() == false then
		return true
	end
	if victim:GetGTeam() == attacker:GetGTeam() then return false end
	return true
end
hook.Add( "PlayerShouldTakeDamage", "playershouldtakedamage", playershouldtakedamage)


function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	dmginfo:ScaleDamage( 1 )
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if listener:GetGTeam() != TEAM_DEAD and talker:GetGTeam() == TEAM_DEAD then
		return false
	end
	return true
end

function GM:PlayerCanSeePlayersChat( text, teamOnly, listener, speaker )
	if teamOnly then
		if listener:GetGTeam() == speaker:GetGTeam() then
			return true
		else
			return false
		end
	end
	if listener:GetGTeam() != TEAM_DEAD and speaker:GetGTeam() == TEAM_DEAD then
		return false
	end
	return true
end

function GM:PlayerDeathSound()
	return false
end

