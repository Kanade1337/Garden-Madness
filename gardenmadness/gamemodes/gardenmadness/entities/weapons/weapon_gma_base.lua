AddCSLuaFile()

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "smg"
SWEP.ViewModel		= "models/weapons/v_smg1.mdl"
SWEP.WorldModel		= "models/weapons/w_smg1.mdl"
SWEP.PrintName		= "SMG"
SWEP.Base			= "weapon_base"
SWEP.DrawCrosshair	= false

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Sound			= Sound("Weapon_SMG1.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay			= 0.085

SWEP.ScopeSound				= Sound("Default.Zoom")

SWEP.DeploySpeed			= 1

SWEP.Damage					= 11
//SWEP.UseHands				= true

//SWEP.CSMuzzleFlashes 		= true
//SWEP.CSMuzzleX			= false

SWEP.DrawCustomCrosshair	= true

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

function SWEP:Initialize()
	self.IsSilenced = false
	self:SetHoldType( self.HoldType )
	self:SetDeploySpeed(self.DeploySpeed)
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo( 1 )
	
	local cone = 0.01
	cone = self.Primary.Cone
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, cone )
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end


if CLIENT then
	local scope = surface.GetTextureID("gmod/scope.vmt")
	
	function SWEP:DrawHUD()
		if self.DrawCustomCrosshair then
			local cone = 0.01
			cone = self.Primary.Cone
			local x = math.floor(ScrW() / 2.0)
			local y = math.floor(ScrH() / 2.0)
			local scale = math.max(0.2,  10 * cone)
			
			local LastShootTime = self:LastShootTime()
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			surface.SetDrawColor(0, 255, 0, 255)
			local gap = math.floor(20 * scale)
			local length = math.floor(gap + 25 * scale)
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )
		end
	end
end

function SWEP:Reload()
	if self:Clip1() == self.Primary.ClipSize then return end
	if self:Ammo1() == 0 then return end
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	if self.Primary.ReloadSound != nil then
		self:EmitSound(self.Primary.ReloadSound)
	end
end

function SWEP:Think()
end

function SWEP:Holster( wep )
	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetDeploySpeed(self.DeploySpeed)
	return true
end

function SWEP:ShootEffects()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:ShootBullet( damage, recoil, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 5
	bullet.Force	= 1
	bullet.Damage	= self.Damage
	bullet.AmmoType = self.Primary.Ammo
	
	self:ShootEffects()
	
	bullet.Callback = function( attacker, tr, dmginfo)
		if attacker:IsPlayer() then
			if SERVER then
				if tr.Entity:GetClass() == "prop_vehicle_prisoner_pod" or tr.Entity:IsVehicle() then
					if tr.Entity:GetDriver() ~= NULL then
						tr.Entity:GetDriver():TakeDamageInfo(dmginfo)
					end
				end
			end
			
		end
	end
	self.Owner:FireBullets( bullet )
	
   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )
   end
  
end

function SWEP:TakePrimaryAmmo( num )
	if ( self.Weapon:Clip1() <= 0 ) then 
		if ( self:Ammo1() <= 0 ) then return end
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	return end
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
end

function SWEP:CanPrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return false end
	if ( self.Weapon:Clip1() <= 0 ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:Reload()
		return false
		
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	return true
end

function SWEP:OnRemove()
	self:SetHoldType(self.HoldType)
end

function SWEP:OwnerChanged()
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end

function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

function SWEP:DoImpactEffect( tr, nDamageType )
		
	return false;
	
end
