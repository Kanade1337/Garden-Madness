AddCSLuaFile( "shared.lua" )

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("flicons/wep_nuke")
end

SWEP.Author			= "Kanade"
SWEP.Instructions	= "Click Left to BOOM and Right to provoke gardeners"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.PrintName		= "NUKE"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Ammo			= "none"
SWEP.Secondary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.ProvocationSound		= "flowermod/provocation.wav"
SWEP.BoomDelay				= 4 // 4 default
SWEP.Delay					= 2 // 1 default
SWEP.Radius					= 10000 // 25000 default
SWEP.Damage					= 5000 // 1500 default
SWEP.Used = false

function SWEP:Initialize()
end

function SWEP:Reload()
end

function SWEP:Holster( wep )
	if self.Used then
		return false
	else
		return true
	end
end

// BOOM BOOM
function SWEP:PrimaryAttack()
	//local tr = self.Owner:GetEyeTrace().Entity
	//local ang = (tr:GetPos() - self.Owner:GetPos()):Angle()
	//tr:SetVelocity( Vector(0,0,300) + (ang:Forward() * 600) )
	//if true then return end
	
	if preparing or postround then return end
	if flowerscanattack == false then return end
	if not IsFirstTimePredicted() then return end
	if self.Used == true then return end
	if self.NeedLazor == true then return end
	if timer.TimeLeft("LaserDelay" .. self.Owner:SteamID()) != nil then return end
	
	BroadcastLua('surface.PlaySound( "flowermod/tactical_nuke.wav" )')
	self.Used = true
	timer.Create("BoomDelay" .. self.Owner:SteamID(), self.BoomDelay, 1, function()
		if SERVER then
			if self == nil then return end
			if IsValid(self) == false then return end
			self:Explode()
		end
	end)
	
end

// Explode function 
function SWEP:Explode()
	if preparing or postround then return end
	
	local ent = ents.Create( "env_explosion" )
	ent:SetPos( self.Owner:GetPos() )
	ent:SetOwner( self.Owner )
	ent:Spawn()
	ent:SetKeyValue( "iMagnitude", "1" )
	ent:Fire( "Explode", 0, 0 )
	//ent:EmitSound( "siege/big_explosion.wav", 150, 1 )
	BroadcastLua('surface.PlaySound( "flowermod/nuke_explosion.wav" )')
	//util.BlastDamage( self, self.Owner, self.Owner:GetPos(), self.Radius, self.Damage )
	local killedsomeone = false
	for k,v in pairs(ents.FindInSphere(ent:GetPos(), self.Radius)) do
		if v:IsPlayer() then
			if v:GetGTeam() == 2 then
				local num = math.Clamp( self.Damage - math.Round(v:GetPos():Distance(ent:GetPos()) / 1.75), 1, 500 )
				print(self.Owner:Nick() .. " blew and damaged " .. v:Nick() .. " with " .. tostring(num) .. " damage.")
				util.BlastDamage( self, self.Owner, v:GetPos(), 5, num )
				if v:Health() < 1 then
					killedsomeone = true
					ColouredMsg(gteams.GetColor(TEAM_FLOWERS), self.Owner:Nick(), color_white, " blew up ", gteams.GetColor(TEAM_GARDEN), v:Nick(), color_white, "!")
				end
			end
		end
	end
	if killedsomeone then
		self.Owner.blown = true
	else
		self.Owner.blown = nil
	end
	self.Owner:Kill()
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