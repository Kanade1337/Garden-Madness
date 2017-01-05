AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}
PLAYER.DisplayName			= "Player"
PLAYER.WalkSpeed			= 1
PLAYER.RunSpeed				= 1
PLAYER.CrouchedWalkSpeed	= 0.3
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight		= true
PLAYER.MaxHealth			= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 0
PLAYER.DropWeaponOnDie		= false
PLAYER.TeammateNoCollide	= false
PLAYER.AvoidPlayers			= true
PLAYER.UseVMHands			= true

function PLAYER:Loadout()
	
end

function PLAYER:SetupDataTables()
	//print("Setting up datatables for "..self.Player:Nick())
	local pl = self.Player
	pl:NetworkVar( "Int", 0, "GTeam" )
	
	if SERVER then
		if GetConVar("gma_mode"):GetString() == "competetive" and postround == false then
			pl:SetGTeam(3)
			pl:Spawn()
			Spectate(pl)
		end
	end
end

player_manager.RegisterClass( "class_default", PLAYER, "player_default" )
