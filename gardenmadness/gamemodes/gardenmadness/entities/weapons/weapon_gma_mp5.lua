AddCSLuaFile()

if CLIENT then
	killicon.AddFont( "weapon_gma_mp5", "csd", "x", Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/gfx/vgui/mp5")
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "smg"
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel		= "models/weapons/w_smg_mp5.mdl"
SWEP.PrintName		= "MP5"
SWEP.Base			= "weapon_gma_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 2

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0.023
SWEP.Primary.Delay			= 0.0875

SWEP.DeploySpeed			= 1
SWEP.Damage					= 10
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX		 = true

SWEP.DrawCustomCrosshair	= true

