// Meta player functions

TEAM_FLOWERS = 1
TEAM_GARDEN = 2
TEAM_DEAD = 3

local metaply = FindMetaTable( "Player" )

function ColouredMsg(...)
	local args = {...}
	net.Start("SendColoredMessage")
		net.WriteTable(args)
	net.Broadcast()
end

function metaply:ColouredMsg(...)
	local args = {...}
	net.Start("SendColoredMessage")
		net.WriteTable(args)
	net.Send(self)
end

function metaply:IsPremium()
	return self.Premium
end

function metaply:SetGardener()
	local modeltable = {
		("models/player/riot.mdl"),
		("models/player/gasmask.mdl"),
		("models/player/urban.mdl"),
		("models/player/swat.mdl"),
		("models/player/phoenix.mdl"),
		("models/player/arctic.mdl"),
		("models/player/guerilla.mdl"),
		("models/player/leet.mdl")
	}
	self:SetModel(table.Random(modeltable))
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetWalkSpeed(250)
	self:SetRunSpeed(250)
	self:SetCrouchedWalkSpeed(0.3)
	self:SetJumpPower(165)
	self:StripWeapons()
	self:Give("weapon_gma_pistol")
	self:Give("weapon_crowbar")
	self:RemoveAllAmmo()
	self:GiveAmmo(self:GetActiveWeapon().Primary.DefaultClip, self:GetActiveWeapon():GetPrimaryAmmoType(), false)
	self:SetGTeam(TEAM_GARDEN)
	self:SetCustomCollisionCheck( true )
	self:AllowFlashlight( true )
end

function metaply:SetFlower( class )
	self:SetHealth(100)
	self:SetMaxHealth(125)
	self:SetWalkSpeed(200)
	self:SetRunSpeed(380)
	self:SetCrouchedWalkSpeed(0.4)
	self:SetJumpPower(175)
	self:StripWeapons()
	self:Give("weapon_plant_classic")
	//self:SetModel("models/props_foliage/shrub_small.mdl")
	self:SetModel("models/props_foliage/mall_grass_bush01.mdl")
	self.Class = "classic"
	self:SetCustomCollisionCheck( true )
	self:SetGTeam(TEAM_FLOWERS)
	self:RemoveAllAmmo()
	self:AllowFlashlight( false )
end
