
items = {}

ALLITEMS = {
	{
		name = "SMG",
		class = "weapon_gma_smg",
		cost = 25,
		premium = false,
		icon = "flicons/icon_smg.png",
		team = TEAM_GARDEN
	},
	{
		name = "Revolver",
		class = "weapon_gma_revolver",
		cost = 50,
		premium = false,
		icon = "flicons/icon_357.png",
		team = TEAM_GARDEN
	},
	{
		name = "AR2",
		class = "weapon_gma_ar2",
		cost = 75,
		premium = false,
		icon = "flicons/icon_ar2.png",
		team = TEAM_GARDEN
	},
	{
		name = "MP5",
		class = "weapon_gma_mp5",
		cost = 35,
		premium = false,
		icon = "flicons/icon_mp5.png",
		team = TEAM_GARDEN
	},
	{
		name = "Deagle",
		class = "weapon_gma_deagle",
		cost = 55,
		premium = false,
		icon = "flicons/icon_deagle.png",
		team = TEAM_GARDEN
	},
	{
		name = "SG552",
		class = "weapon_gma_sg552",
		cost = 70,
		premium = false,
		icon = "flicons/icon_sg552.png",
		team = TEAM_GARDEN
	},
	{
		name = "AWP",
		class = "weapon_gma_awp",
		cost = 85,
		premium = false,
		icon = "flicons/icon_awp.png",
		team = TEAM_GARDEN
	},
	{
		name = "Lazor",
		class = "weapon_plant_lazor",
		cost = 100,
		premium = false,
		icon = "flicons/icon_lazor.png",
		team = TEAM_FLOWERS
	},
	{
		name = "Nuke",
		class = "weapon_plant_nuke",
		cost = 150,
		premium = false,
		icon = "flicons/nuke.png",
		team = TEAM_FLOWERS
	}
}

function items.Add(name, class, cost, premium, customcheck, customcheckfailmsg)
	table.ForceInsert(ALLITEMS, {name,class,cost,premium,customcheck,customcheckfailmsg})
end

function items.ValidWeapon(class)
	for k,v in pairs(ALLITEMS) do
		if v["class"] == class then
			return true
		end
	end
	return false
end

function items.RemoveByName(name)
	for k,v in pairs(ALLITEMS) do
		if v["name"] == name then
			table.remove(ALLITEMS, k)
		end
	end
end

function items.RemoveByClass(class)
	for k,v in pairs(ALLITEMS) do
		if v["class"] == class then
			table.remove(ALLITEMS, k)
		end
	end
end

function items.Redeem(ply, class)
	for k,v in pairs(ALLITEMS) do
		if v["class"] == class then
			ply:Give(class)
			ply:PrintMessage(HUD_PRINTTALK, "You have sucefully bought " .. v["name"] .. ".")
			ply:SetFrags(ply:Frags() - v["cost"])
		end
	end
end

function items.CanBuy(ply, class)
	if ply:Alive() == false then
		ply:PrintMessage(HUD_PRINTTALK, "You can not buy weapons when you are dead.")
		return false
	end
	if GetGlobalInt("FLMode") == MODE_COMP then
		ply:PrintMessage(HUD_PRINTTALK, "You can not buy weapons in competetive mode.")
		return false
	end
	if ply:GetGTeam() == TEAM_DEAD then
		ply:PrintMessage(HUD_PRINTTALK, "You can not buy weapons when you are a spectator.")
		return false
	end
	for k,v in pairs(ply:GetWeapons()) do
		if v:GetClass() == class then
			ply:PrintMessage(HUD_PRINTTALK, "You already have this item.")
			return false
		end
	end
	if preparing == false then
		if GetGlobalInt("FLMode") == MODE_ARCADE then
			ply:PrintMessage(HUD_PRINTTALK, "You can only buy weapons in preparing phase.")
			return false
		end
	end
	for k,v in pairs(ALLITEMS) do
		if v["class"] == class then
			if ply:GetGTeam() == TEAM_GARDEN then
				if v["team"] == TEAM_FLOWER then
					ply:PrintMessage(HUD_PRINTTALK, "This weapon is for plants only.")
					return false
				end
			elseif ply:GetGTeam() == TEAM_FLOWER then
				if v["team"] == TEAM_FLOWER then
					ply:PrintMessage(HUD_PRINTTALK, "This weapon is for gardeners only.")
					return false
				end
			end
			if v["cost"] > ply:Frags() then
				ply:PrintMessage(HUD_PRINTTALK, "You need more money to buy " .. v["name"] .. ".")
				return false
			end
			if v["premium"] then
				print(ply:IsPremium())
				// premium
				if ply:IsPremium() == false then
					ply:PrintMessage(HUD_PRINTTALK, "You need to have a premium account to buy ".. v["name"] ..".")
					return false
				end
				if v["customcheck"] != nil then
					if v["customcheck"](ply) == true then
						return true
					else
						ply:PrintMessage(HUD_PRINTTALK, v["customcheckfailmsg"])
						return false
					end
				else
					return true
				end
			else
				// not premium
				if v["customcheck"] != nil then
					if v["customcheck"](ply) == true then
						return true
					else
						ply:PrintMessage(HUD_PRINTTALK, v["customcheckfailmsg"])
						return false
					end
				else
					return true
				end
			end
		end
	end
end

