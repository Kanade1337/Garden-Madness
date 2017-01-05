
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("flicons/wep_lazor")
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Instructions	= "Click Left to shoot the lazor!"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.PrintName		= "LAZOR"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.ProvocationSound		= "flowermod/provocation.wav"
SWEP.Allahsound				= "flowermod/yalala.wav"
SWEP.LazorSound				= "flowermod/iamfiringmahlaser.wav"
SWEP.ShootingLazorSound		= "flowermod/blahhhhh.wav"
SWEP.Delay					= 2 // 1 default
SWEP.LazorDelay				= 2.05 // 2.05 default
SWEP.LaserShootDelay		= 12 // 12 default
SWEP.Radius					= 190 // 190 default


SWEP.Used = false
SWEP.NeedLazor = false
SWEP.UsedLazor = false
SWEP.HaveLazor = true


function SWEP:Initialize()
end

function SWEP:Think()
	if self.NeedLazor == true then
		self:ShootLazor()
	elseif self.NeedLazor == false then
		if self.Used then
			if SERVER then
				self.Owner:StripWeapon(self:GetClass())
			end
		end
	end
end

function SWEP:Reload()
end

function SWEP:Holster( wep )
	if self.NeedLazor or self.UsedLazor then
		return false
	else
		return true
	end
end

function SWEP:ShootLazor()
	local trace = self.Owner:GetEyeTrace()
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetStart( self.Owner:GetShootPos() - Vector(0,0,30) + Vector(math.random(-15,15),math.random(-15,15),math.random(-15,15)) )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
	local force = 0.125
	self.Owner:ViewPunch(Angle(math.random(-force,force),math.random(-force,force),math.random(-force,force)))
	util.Effect( "ToolTracer", effectdata )
	if postround then return end
	if SERVER then
		if self.Owner:GetEyeTrace().Entity:IsPlayer() then
			local plyr = self.Owner:GetEyeTrace().Entity
			if plyr:GetGTeam() == 2 then
				local bullet = {}
				bullet.Num 	= 1
				bullet.Src 	= self.Owner:GetShootPos()
				bullet.Dir 	= self.Owner:GetAimVector()
				bullet.Spread 	= Vector( aimcone, aimcone, 0 )
				bullet.Damage	= 100
				bullet.AmmoType = ""
				
				self.Owner:FireBullets( bullet )
				
				local ent = ents.Create( "env_explosion" )
				ent:SetPos( plyr:GetPos() )
				ent:SetOwner( self.Owner )
				ent:Spawn()
				ent:SetKeyValue( "iMagnitude", "1" )
				ent:Fire( "Explode", 0, 0 )
				ent:EmitSound( "siege/big_explosion.wav", 150, 1 )
				util.BlastDamage( self.Owner, self.Owner, plyr:GetPos(), self.Radius, 25 )
				if plyr:Health() < 1 then
					ColouredMsg(gteams.GetColor(TEAM_FLOWERS), self.Owner:Nick(), color_white, " destroyed ", gteams.GetColor(TEAM_GARDEN), plyr:Nick(), color_white, " with a lazor!")
				end
			end
		end
	end
end

// BOOM BOOM
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if flowerscanattack == false then return end
	if not IsFirstTimePredicted() then return end
	if self.UsedLazor then return end
	if self.HaveLazor == false then return end
	self.UsedLazor = true
	self.Owner:EmitSound(self.LazorSound, 511, 100, 0.4 )
	timer.Create("LaserDelay" .. self.Owner:SteamID(), self.LazorDelay, 1, function()
		self.NeedLazor = true
		if IsValid(self) == false then return end
		if IsValid(self.Owner) == false then return end
		self.Owner:EmitSound( self.ShootingLazorSound, 511, 100, 0.4 )
	end)
	timer.Create("LaserShoot" .. self.Owner:SteamID(), self.LaserShootDelay, 1, function()
		if IsValid(self) == false then return end
		if IsValid(self.Owner) == false then return end
		self.NeedLazor = false
		self.Used = true
	end)
end

// Provocation
function SWEP:CanSecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	return true
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if ( !self:CanSecondaryAttack() ) then return end
	if preparing or postround then return end
	if flowerscanattack == false then return end
	if self.Used == true then return end
	if self.NeedLazor == true then return end
	if timer.TimeLeft("LaserDelay" .. self.Owner:SteamID()) == 0 then return end
	self:EmitSound(self.ProvocationSound)
end
