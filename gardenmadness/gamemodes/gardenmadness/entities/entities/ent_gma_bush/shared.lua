 	
ENT.Type 		= "anim"
ENT.Base 		= "base_entity"

ENT.PrintName	= "Bush"
ENT.Author		= ""
ENT.Contact		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
//ENT.RenderGroup 		= RENDERGROUP_OPAQUE
ENT.Screamed			= false
ENT.IsAngry				= true
ENT.Radius				= 300

AddCSLuaFile( "shared.lua" )

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
	//self:SetModel( "models/Items/item_item_crate.mdl" )
	self:SetModel("models/props_foliage/mall_grass_bush01.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Screamed = false
	if SERVER then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(150)
			phys:Wake()
		end
	end
end

function ENT:Use( activator, caller )
    return
end

/*
function ENT:Think()
	if SERVER then
		if self.IsAngry then
			for k,v in pairs(ents.FindInSphere( self.Entity:GetPos(), self.Radius )) do
				if v:IsPlayer() then
					if v:GetGTeam() == TEAM_GARDEN then
						local pos = (self.Entity:GetPos() - v:GetPos())
						local ang = pos:Angle()
						//self.Entity:SetVelocity( Vector(0,0,0) - (ang:Forward() * 300) )
						//lua_run Entity(1):GetEyeTrace().Entity:SetVelocity( Vector(0,0,0) )
						local phys = self:GetPhysicsObject()
						if IsValid(phys) then
							phys:Wake()
							//phys:ApplyForceCenter( Vector( 0, 0, phys:GetMass()*-9.80665 ) )
							phys:ApplyForceCenter( Vector(phys:GetMass() * -pos[1], phys:GetMass() * -pos[2], phys:GetMass() * -pos[3]) )
							//phys:ApplyForceCenter( pos )
						end
					end
				end
			end
		end
	end
end
*/

function ENT:OnTakeDamage( dmginfo )
	if dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():GetGTeam() == TEAM_GARDEN then
			dmginfo:GetAttacker():TakeDamage( 5, self.Entity, self.Entity )
		end
	end
	if self.Screamed == false then
		self:EmitSound("flowermod/scream" .. math.random(1,9) .. ".wav")
		self.Screamed = true
	end
end
