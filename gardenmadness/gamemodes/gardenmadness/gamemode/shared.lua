
include("class_default.lua")

GM.Name 	= "Garden Madness"
GM.Author 	= "Kanade"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

TEAM_FLOWERS = 1
TEAM_GARDEN = 2
TEAM_DEAD = 3


// Team setup
team.SetUp( 1, "PLAYERDEF", Color( 255, 255, 255 ) )

// ConVars
if !ConVarExists("gma_preparingtime") then CreateConVar( "gma_preparingtime", "15", FCVAR_NOTIFY, "Sets preparing time" ) end
if !ConVarExists("gma_roundtime") then CreateConVar( "gma_roundtime", "180", FCVAR_NOTIFY, "Sets round time" ) end
if !ConVarExists("gma_posttime") then CreateConVar( "gma_posttime", "10", FCVAR_NOTIFY, "Sets postround time" ) end
if !ConVarExists("gma_minimumplayers") then CreateConVar( "gma_minimumplayers", "2", FCVAR_NOTIFY, "Sets minimum players number to start the round" ) end
if !ConVarExists("gma_spawntime") then CreateConVar( "gma_spawntime", "10", FCVAR_NOTIFY, "Sets time players wait before they spawn" ) end
if !ConVarExists("gma_healinwater") then CreateConVar( "gma_healinwater", "1", FCVAR_NOTIFY, "Set if you want players to heal in water" ) end
if !ConVarExists("gma_attackinterval") then CreateConVar( "gma_attackinterval", "10", FCVAR_NOTIFY, "Sets time flowers will not be able to attack after preparing end" ) end
if !ConVarExists("gma_mode") then CreateConVar( "gma_mode", "arcade", FCVAR_NOTIFY, 
"There are 3 game modes here: \n" .. 
"1. Casual:\n" .. 
" - Players will spawn after their death\n" ..
" - Players can use all type of weapons\n" .. 
" - Players can suicide\n" .. 
"\n" .. 
"2. Competetive:\n" .. 
" - Players will not spawn after thier death, they will be spectators\n" .. 
" - Players can't use special weapons\n" .. 
" - Players can't suicide\n" .. 
"\n" .. 
"3.Arcade\n" .. 
" - Players will not spawn after their death, they will be spectators\n" ..
" - Players can use special weapons\n" .. 
" - Players can't suicide\n" .. 
"\n" .. 
" Change this ConVar to casual, competetive or arcade\n" .. 
" If you want to add custom gamemode, you would need to change the code, there is no easy way to do it, you can always ask the creator of the gamemode\n"
)
end
if !ConVarExists("gma_maxscore") then CreateConVar( "gma_maxscore", "50", FCVAR_NOTIFY, "Sets max score in casual mode" ) end

function GetMaxScore()
	return GetConVar("gma_maxscore"):GetInt()
end

/*
concommand.Add( "gma_chooseclass", function( ply, command, args )
	if args[1] == "classic" then
		if CLIENT then
			net.Start( "SendClass" )
			net.WriteString( "classic" )
			net.SendToServer()
		end
	end
	if args[1] == "speedy" then
		if CLIENT then
			net.Start( "SendClass" )
			net.WriteString( "speedy" )
			net.SendToServer()
		end
	end
	if args[1] == "badass" then
		if CLIENT then
			net.Start( "SendClass" )
			net.WriteString( "badass" )
			net.SendToServer()
		end
	end
end )
*/

gteams = {}
gteams.Flowers = {}
gteams.Gardeners = {}

gteams.Flowers.Points = 0
gteams.Gardeners.Points = 0

function gteams.GetColor(gteam)
	if gteam == TEAM_FLOWERS then
		return Color(112, 222, 75)
	elseif gteam == TEAM_GARDEN then
		return Color(222, 112, 75)
	else
		return nil
	end
end

function gteams.GetPlayers(num)
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.GetGTeam == nil then
			player_manager.RunClass( v, "SetupDataTables" )
		end
		if v:GetGTeam() == num then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function gteams.GetPoints(gteam)
	if gteam == TEAM_FLOWERS then
		return gteams.Flowers.Points
	elseif gteam == TEAM_GARDEN then
		return gteams.Gardeners.Points
	else
		return nil
	end
end

function gteams.AddPoints(gteam, num)
	if gteam == TEAM_FLOWERS then
		gteams.Flowers.Points = gteams.Flowers.Points + num
		SetGlobalInt("FlowersScore", gteams.Flowers.Points)
	elseif gteam == TEAM_GARDEN then
		gteams.Gardeners.Points = gteams.Gardeners.Points + num
		SetGlobalInt("GardenersScore", gteams.Gardeners.Points)
	else
		return nil
	end
end

function gteams.SetPoints(gteam, num)
	if gteam == TEAM_FLOWERS then
		gteams.Flowers.Points = num
		SetGlobalInt("FlowersScore", gteams.Flowers.Points)
	elseif gteam == TEAM_GARDEN then
		gteams.Gardeners.Points = num
		SetGlobalInt("GardenersScore", gteams.Gardeners.Points)
	else
		return nil
	end
end

function gteams.ResetPoints(gteam, num)
	if gteam == TEAM_FLOWERS then
		gteams.Flowers.Points = 0
		SetGlobalInt("FlowersScore", gteams.Flowers.Points)
	elseif gteam == TEAM_GARDEN then
		gteams.Gardeners.Points = 0
		SetGlobalInt("GardenersScore", gteams.Gardeners.Points)
	else
		return nil
	end
end


