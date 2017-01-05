AddCSLuaFile()

if CLIENT then
	killicon.AddFont( "weapon_gma_sg552", "csd", "A", Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/gfx/vgui/sg552")
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_sg552.mdl"
SWEP.PrintName		= "SG552"
SWEP.Base			= "weapon_gma_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 2

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0.021
SWEP.Primary.Delay			= 0.095

SWEP.DeploySpeed			= 1
SWEP.Damage					= 12
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX		 = true

SWEP.DrawCustomCrosshair	= true

