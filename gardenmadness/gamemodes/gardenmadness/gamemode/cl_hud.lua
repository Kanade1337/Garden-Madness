
MODE_COMP = 0
MODE_CASUAL = 1
MODE_ARCADE = 2

local flowerslogomat = Material( "materials/flicons/flowerlogo.png" )
flowerslogomat = Material( "flicons/killicon_flower" )
local gardenerslogomat = Material( "materials/flicons/gardenerslogo2.png" )

hook.Add( "HUDPaint", "FlowersHUD", function()
	local t_time = "00:00"
	if time != nil then
		t_time = string.ToMinutesSeconds(tostring(time))
	end
	local fscore = tostring(GetGlobalInt("FlowersScore"))
	local gscore = tostring(GetGlobalInt("GardenersScore"))
	local fplayers = gteams.GetPlayers(TEAM_FLOWERS)
	local gplayers = gteams.GetPlayers(TEAM_GARDEN)
	
	draw.RoundedBox( 2, ScrW() / 2 - 64, 0, 100, 36, Color(112, 112, 112, 230) )
	draw.DrawText( t_time, "HUD_Score_Blur", ScrW() / 2 - 13, 2, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER )
	draw.DrawText( t_time, "HUD_Score", ScrW() / 2 - 14, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	// FLOWERS - SCORE
	draw.RoundedBox( 2, ScrW() / 2 - 11, 42, 47, 37, Color(112, 222, 75, 220) )
	draw.DrawText( fscore, "HUD_Score_Blur", ScrW() / 2 + 13, 46, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER )
	draw.DrawText( fscore, "HUD_Score", ScrW() / 2 + 12, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	// GARDENERS - SCORE
	draw.RoundedBox( 2, ScrW() / 2 - 64, 42, 47, 37, Color(222, 112, 75, 230) )
	draw.DrawText( gscore, "HUD_Score_Blur", ScrW() / 2 - 40, 46, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER )
	draw.DrawText( gscore, "HUD_Score", ScrW() / 2 - 42, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	// FLOWERS - NUMBER OF PLAYERS
	draw.RoundedBox( 2, ScrW() / 2 + 40, 0, 80, 80, Color(112, 222, 75, 220) )
	surface.SetMaterial( flowerslogomat	)
	surface.DrawTexturedRect( ScrW() / 2 + 40, 0, 80, 80 )
	draw.DrawText( #fplayers, "HUD_Logos_Blur", ScrW() / 2 + 81, 12, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( #fplayers, "HUD_Logos", ScrW() / 2 + 79, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	// GARDENERS - NUMBER OF PLAYERS
	draw.RoundedBox( 2, ScrW() / 2 - 148, 0, 80, 80, Color(222, 112, 75, 230) )
	surface.SetMaterial( gardenerslogomat )
	surface.DrawTexturedRect( ScrW() / 2 - 148, 0, 80, 80 )
	draw.DrawText( #gplayers, "HUD_Logos_Blur", ScrW() / 2 - 106, 13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( #gplayers, "HUD_Logos", ScrW() / 2 - 108, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	// Health
	local cl = Color(255, 2555, 255, 230)
	if LocalPlayer():GetGTeam() == TEAM_GARDEN then
		cl = Color(222, 90, 50, 230)
	elseif LocalPlayer():GetGTeam() == TEAM_FLOWERS then
		cl = Color(90, 230, 50, 230)
	end
	
	if LocalPlayer():Health() > 0 then
		draw.DrawText( tostring(LocalPlayer():Health()), "HUD_Health_Blur", 80, ScrH() / 1.1, cl, TEXT_ALIGN_CENTER )
		draw.DrawText( tostring(LocalPlayer():Health()), "HUD_Health", 80, ScrH() / 1.1, cl, TEXT_ALIGN_CENTER )
	end
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ) != nil and LocalPlayer():GetActiveWeapon():Clip1() != nil then
			local ammo1 = LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() )
			local clip1 = LocalPlayer():GetActiveWeapon():Clip1()
			if clip1 > -1 then
				draw.DrawText( clip1 .. "/" .. ammo1, "HUD_Health_Blur", ScrW() - 220, ScrH() / 1.1, cl, TEXT_ALIGN_CENTER )
				draw.DrawText( clip1 .. "/" .. ammo1, "HUD_Health", ScrW() - 220, ScrH() / 1.1, cl, TEXT_ALIGN_CENTER )
			end
		end
	end
end)

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudSecondaryAmmo = true,
	CHudWeapon = true,
	CHudAmmo = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )
