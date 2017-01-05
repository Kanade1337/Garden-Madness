AddCSLuaFile()

if CLIENT then
	killicon.AddFont( "weapon_gma_awp", "csd", "r", Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/awp")
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.Slot			= 2
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel		= "models/weapons/w_snip_awp.mdl"
SWEP.PrintName		= "AWP"
SWEP.Base			= "weapon_gma_base"
SWEP.DrawCrosshair	= false

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SniperRound"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 1.5
SWEP.IsScoping				= false
SWEP.ZoomFov				= 20
SWEP.BaseCone				= 0.03

SWEP.ScopeSound				= Sound("Default.Zoom")

SWEP.DeploySpeed			= 1

SWEP.Damage					= 90
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX			= false

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

function SWEP:CanSecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return false end
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	return true
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetNextSecondaryFire() > CurTime() then return end
	timer.Destroy("needtoscope" .. self.Owner:SteamID())
	if self.IsScoping then
		self.IsScoping = false
		if SERVER then
			self.Owner:SetFOV(90, 0.2)
		else
			self:EmitSound(self.ScopeSound)
		end
	else
		self.IsScoping = true
		if SERVER then
			self.Owner:SetFOV(self.ZoomFov, 0.2)
		else
			self:EmitSound(self.ScopeSound)
		end
	end
end

if CLIENT then
	local scope = surface.GetTextureID("gmod/scope.vmt")
	
	function SWEP:DrawHUD()
		if self.IsScoping then
			surface.SetDrawColor( 0, 0, 0, 255 )
			
			local scrW = ScrW()
			local scrH = ScrH()
			local x = scrW / 2.0
			local y = scrH / 2.0
			local length = scrH
			
			surface.DrawLine( x - length, y, x, y )
			surface.DrawLine( x + length, y, x, y )
			surface.DrawLine( x, y - length, x, y )
			surface.DrawLine( x, y + length, x, y )
			length = 50
			
			local sh = scrH / 2
			local w = (x - sh) + 2
			surface.DrawRect(0, 0, w, scrH)
			surface.DrawRect(x + sh - 2, 0, w, scrH)
			surface.DrawLine( 0, 0, scrW, 0 )
			surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )
			surface.SetDrawColor(255, 0, 0, 255)
			surface.SetTexture(scope)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRectRotated(x, y, ScrW() / 1.5, ScrH(), 0)
		elseif self.DrawCustomCrosshair then
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
	
	function SWEP:AdjustMouseSensitivity()
		if self.IsScoping then
			return 0.2
		else
			return nil
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
	if self.IsScoping then
		if self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 and self:Clip1() < self.Primary.ClipSize then 
			timer.Create("needtoscope" .. self.Owner:SteamID(), self.Owner:GetViewModel():SequenceDuration(), 1, function()
				self.IsScoping = true
				self.Owner:SetFOV(self.ZoomFov, 0.2)
			end)
			self.IsScoping = false
			self.Owner:SetFOV(90, 0.2)
		end
	end
end

function SWEP:Think()
	if self.IsScoping then
		self.Primary.Cone = 0.0001
	else
		self.Primary.Cone = self.BaseCone
	end
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
