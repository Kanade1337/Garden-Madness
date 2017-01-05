AddCSLuaFile()

if CLIENT then
	killicon.AddFont( "weapon_gma_deagle", "csd", "f", Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/gfx/vgui/deserteagle")
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "revolver"
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_deagle.mdl"
SWEP.PrintName		= "Deagle"
SWEP.Base			= "weapon_gma_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 1

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 35
SWEP.Primary.Sound			= Sound("Weapon_DEagle.Single")
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Cone			= 0.0001

SWEP.DeploySpeed			= 1
SWEP.Primary.Delay			= 0.225

SWEP.Damage					= 26
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX			= false

SWEP.DrawCustomCrosshair	= true
