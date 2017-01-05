include( "shared.lua" )
include( "cl_scoreboard.lua" )
include( "cl_hud.lua" )
include( "cl_deathnotice.lua" )
include( "specialweapons.lua" )

TEAM_FLOWERS = 1
TEAM_GARDEN = 2
TEAM_DEAD = 3

preparing = false
postround = false
gamestarted = false

EnableMusic = false

CreateClientConVar( "gma_music", "1", true, false )
CreateClientConVar( "gma_musicvolume", "0.5", true, false )

net.Receive( "StopSounds", function( len, ply )
	stopsounds()
end)

net.Receive( "SendSound", function( len, ply )
	local url = net.ReadString()
	local looping = net.ReadBool()
	local volume = tonumber(GetConVar("gma_musicvolume"):GetFloat())
	playsound(url, tonumber(volume), looping)
end)

surface.CreateFont( "HUD_Score", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 30,
	//size = ScreenScale(10),
	weight = 600,
	blursize = 1.25,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "HUD_Score_Blur", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 30,
	//size = ScreenScale(10),
	weight = 600,
	blursize = 1.25,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )
surface.CreateFont( "HUD_Health", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 66,
	//size = ScreenScale(22),
	weight = 600,
	blursize = 1,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "HUD_Health_Blur", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 66,
	//size = ScreenScale(22),
	weight = 600,
	blursize = 4,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "HUD_Logos", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 60,
	//size = ScreenScale(10),
	weight = 600,
	blursize = 1.25,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "HUD_Logos_Blur", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 60,
	//size = ScreenScale(10),
	weight = 600,
	blursize = 1.25,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )
surface.CreateFont( "TJM_MainText", {
	font = "CloseCaption",
	extended = false,
	size = 45,
	weight = 750,
	blursize = 1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "TJM_Text", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 30,
	weight = 600,
	blursize = 1.1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFont1", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 22.5,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFont1blur", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 22.5,
	//size = ScreenScale(7.5),
	weight = 1000,
	blursize = 4,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFont2", {
	font = "CloseCaption_Bold",
	extended = false,
	//size = (math.Round((ScrW() * ScrH())) / 85000),
	//size = ScreenScale(8),
	size = 24,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFontMain", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 39,
	//size = ScreenScale(13),
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFontMain2", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 33,
	//size = ScreenScale(11),
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFontTeams", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 51,
	//size = ScreenScale(17),
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ScoreBoardFontTeamsBlur", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 51,
	//size = ScreenScale(17),
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )
surface.CreateFont( "WM_Weapon", {
	font = "CloseCaption_Bold",
	extended = false,
	size = 25,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function playsound(url, volume, looping)
	if GetConVar("gma_music"):GetInt() == 1 then
		print("Starting playing a sound " .. url .. " with volume: " .. tostring(volume) .. " and looping is: " .. tostring(looping))
		sound.PlayURL ( url, "mono noblock", function( station )
			if ( IsValid( station ) ) then
				station:SetPos( LocalPlayer():GetPos() )
				station:SetVolume( volume )
				if looping then
					station:EnableLooping( looping )
					station:SetTime( 360 )
				end
				station:Play()
				LocalPlayer().channel = station
			end
		end )
	end
end

function stopsounds()
	if LocalPlayer().channel == nil then
		print("channel is invalid, cannot stop the sounds")
	else
		LocalPlayer().channel:EnableLooping( false )
		LocalPlayer().channel:Stop()
		LocalPlayer().channel = nil
	end
end

function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "gm_showhelp" then
		// f1
		OpenHelpMenu()
		return
	end
	if bind == "gm_showspare1" then
		// f3
		if LocalPlayer().channel != nil then
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "Sounds stopped.")
			stopsounds()
		end
		return
	end
	if bind == "gm_showspare2" then
		// f4
		return
	end
	if bind == "gm_showteam" then
		TeamJoinMenu()
		return
	end
	if bind == "+menu" then
		OpenShop()
	end
end

net.Receive("SendColoredMessage",function(len)
	local message = net.ReadTable()
	chat.AddText(unpack(message))
	chat.PlaySound()
end)

net.Receive("SendEndPic",function(len)
	local message = net.ReadString()
	local pic = nil
	if message == "gtb" then
		pic = "end_gardeners_timeisup_won"
	elseif message == "gt" then
		pic = "end_gardeners_timeisup"
	elseif message == "ge" then
		pic = "end_gardeners_enemiesdead"
	elseif message == "gs" then
		pic = "end_gardeners_biggestscore"
	elseif message == "ftb" then
		pic = "end_flowers_timeisup_won"
	elseif message == "fe" then
		pic = "end_flowers_enemiesdead"
	elseif message == "fs" then
		pic = "end_flowers_biggestscore"
	elseif message == "nt" then
		pic = "end_noone_timeisup"
	end
	ShowEndPic("flicons/endpics/" .. pic .. ".png")
end)

function ShowEndPic(pic)
	if pic == nil then
		print("error, pic is not valid")
		return
	end
	
	ReceivedPicture = vgui.Create( "DFrame" )
	//ReceivedPicture:SetSize( 1024, 256)
	//ReceivedPicture:SetSize( ScrW() / 1.875, ScrH() / 4.21875)
	//ReceivedPicture:SetSize( ScreenScale( 384 ), ScreenScale( 96 ))
	ReceivedPicture:SetSize( ScreenScale( 256 ), ScreenScale( 64 ))
	ReceivedPicture:SetTitle( "" )
	ReceivedPicture:SetDraggable( false )
	ReceivedPicture:ShowCloseButton( false )
	ReceivedPicture:SetSizable( false )
	//ReceivedPicture:SetPos(ScrW() / 4, ScrH() / 8)
	//ReceivedPicture:Center()
	ReceivedPicture:CenterHorizontal( 0.5 )
	ReceivedPicture:CenterVertical( 0.25 )
	ReceivedPicture:SetDeleteOnClose(true)
	ReceivedPicture.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color(0, 0, 0, 0 ) )
	end
	
	local image = vgui.Create( "DImage", ReceivedPicture )
	image:Dock(FILL)
	image:SetImage(pic)
end

function RTick()
	if ReceivedPicture != nil then
		if postround == false then
			ReceivedPicture:Close()
			ReceivedPicture = nil
		end
	end
end
hook.Add("Tick", "destroypic", RTick)

function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
	if ply:GetGTeam() == TEAM_DEAD then
		chat.AddText(Color(200,200,0), "[SPECTATORS] ", Color(255,255,255), ply:Nick(), color_white, ": ", text)
		return true
	end
	if teamChat then
		chat.AddText(Color(0,255,0), "[TEAM] ", gteams.GetColor(ply:GetGTeam()), ply:Nick(), color_white, ": ", text)
	else
		chat.AddText(gteams.GetColor(ply:GetGTeam()), ply:Nick(), color_white, ": ", text)
	end
	return true
end

function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end
	
	if trace.Entity:IsPlayer() then 
		if trace.Entity.GetGTeam == nil then
			player_manager.RunClass( trace.Entity, "SetupDataTables" )
		end
		if LocalPlayer():GetGTeam() == 2 then
			if trace.Entity:GetGTeam() == 1 then 
				return
			end
		end
	end
	
	local text = "ERROR"
	local font = "TargetID"
	
	if ( trace.Entity:IsPlayer() ) then
		text = trace.Entity:Nick()
	else
		return
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
	draw.SimpleText( text, font, x, y, gteams.GetColor(trace.Entity:GetGTeam()) )
	
	y = y + h + 5
	
	local text = trace.Entity:Health() .. "%"
	local font = "TargetIDSmall"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x = MouseX - w / 2
	
	draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
	draw.SimpleText( text, font, x, y, gteams.GetColor(trace.Entity:GetGTeam()) )
end

bushmodel = nil

hook.Add( "HUDPaint", "UpdateCLFlower", function()
	local ply = LocalPlayer()
	if ply.GetGTeam == nil then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if ply:GetGTeam() == TEAM_FLOWERS then
		if IsValid(bushmodel) == false then
			bushmodel = ClientsideModel("models/props_foliage/mall_grass_bush01.mdl")
		else
			bushmodel:SetPos(ply:GetPos())
		end
	elseif ply:GetGTeam() != TEAM_FLOWERS then
		if IsValid(bushmodel) then
			bushmodel:Remove()
			bushmodel = nil
		end
	end
end)

function TeamJoinMenu()
	local ply = LocalPlayer()
	local Backg = vgui.Create( "DFrame" )
	Backg:SetSize( 400, 240 )
    Backg:SetTitle( "" )
    Backg:SetVisible ( true )
    Backg:SetDraggable ( true )
    Backg:ShowCloseButton ( true )
    Backg:MakePopup()
	Backg:Center()
	Backg:SetDeleteOnClose( true )
	Backg.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color(75, 75, 75, 230 ) )
		draw.RoundedBox( 2, 55, 70, 128, 128, Color(222, 112, 75, 75) )
		draw.RoundedBox( 2, 215, 70, 128, 128, Color(112, 222, 75, 75) )
	end
	
	local MainText = vgui.Create( "DLabel", Backg )
	MainText:SetPos( 50, -25 )
	MainText:SetSize(250,100)
	MainText:SetText( "Choose Team" )
	MainText:SetFont( "TJM_MainText" )
	MainText:SetColor(Color(255,255,255,255))
	
	local G_image = vgui.Create( "DImage", Backg )
	G_image:SetPos( 55, 70 )
	G_image:SetSize(128,128)
	G_image:SetImage("flicons/gardenerslogo2.png")
	
	local G_Text = vgui.Create( "DLabel", Backg )
	G_Text:SetPos( 55, 160 )
	G_Text:SetSize(250,100)
	G_Text:SetText( "Gardeners" )
	G_Text:SetFont( "TJM_Text" )
	G_Text:SetColor(Color(222, 112, 75, 200))
	
	local G_Button = vgui.Create ( "DColorButton", Backg )
	G_Button:SetPos( 55, 70 )
	G_Button:SetSize( 128, 128 )
	G_Button:SetText( "", Color( 221,78,76 ) )
	G_Button.Paint = function( self, w, h ) end
	function G_Button:DoClick(ply)
		net.Start("ChangeTeam")
			net.WriteString("1")
		net.SendToServer()
		Backg:Close()
	end
	
	local F_image = vgui.Create( "DImage", Backg )
	F_image:SetPos( 215, 70 )
	F_image:SetSize(128,128)
	F_image:SetImage("flicons/flowerlogo.png")
	
	local F_Text = vgui.Create( "DLabel", Backg )
	F_Text:SetPos( 242, 160 )
	F_Text:SetSize(250,100)
	F_Text:SetText( "Plants" )
	F_Text:SetFont( "TJM_Text" )
	F_Text:SetColor(Color(112, 222, 75, 200))
	
	local F_Button = vgui.Create ( "DColorButton", Backg )
	F_Button:SetPos( 215, 70 )
	F_Button:SetSize( 128, 128 )
	F_Button:SetText( "", Color( 221,78,76 ) )
	F_Button.Paint = function( self, w, h ) end
	function F_Button:DoClick(ply)
		net.Start("ChangeTeam")
			net.WriteString("2")
		net.SendToServer()
		Backg:Close()
	end
end
concommand.Add( "gma_changeteam", TeamJoinMenu )

function OpenShop()
	if LocalPlayer():GetGTeam() == TEAM_DEAD then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can not buy weapons when you are a spectator.")
		return
	end
	if GetGlobalInt("FLMode") == MODE_COMP then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can not buy weapons in competetive mode.")
		return
	end
	local MainFrame = vgui.Create( "DFrame" )
	MainFrame:SetTitle( "" )
	MainFrame:SetSize( 800, 200 )
	MainFrame:Center()
	MainFrame:MakePopup()
	MainFrame:SetDeleteOnClose(true)
	MainFrame.Paint = function( self, w, h )
		if LocalPlayer():GetGTeam() == TEAM_FLOWERS then
			draw.RoundedBox( 4, 0, 0, w, h, Color(112, 222, 75, 220) )
		elseif LocalPlayer():GetGTeam() == TEAM_GARDEN then
			draw.RoundedBox( 4, 0, 0, w, h, Color(222, 112, 75, 220) )
		end
		draw.DrawText( "Weapons Shop", "WM_Weapon", 80, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local DHorizontalScroller = vgui.Create( "DHorizontalScroller", MainFrame )
	DHorizontalScroller:Dock( FILL )
	DHorizontalScroller:SetOverlap( -4 )
	
	for k,v in pairs(ALLITEMS) do
		if v["team"] == LocalPlayer():GetGTeam() then
			local Panel = vgui.Create( "DLabel", Backg )
			Panel:SetSize(128,128)
			Panel:SetText("")
			Panel:SetFont( "WM_Weapon" )
			Panel:SetColor(Color(255,255,255,255))
			Panel:SetPos(0,0)
			Panel.Paint = function( self, w, h )
				draw.RoundedBox( 2, 0, 0, w, h, Color(100, 100, 100, 210 ) )
				draw.DrawText( v["name"], "WM_Weapon", 60, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				draw.DrawText( "Cost: " .. v["cost"] .. "$", "WM_Weapon", 60, 128, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
			
			local Background = vgui.Create( "DLabel", Panel )
			Background:SetSize(90,90)
			Background:SetText("")
			Background:SetFont( "WM_Weapon" )
			Background:CenterHorizontal( 0.5 )
			Background:CenterVertical( 0.6 )
			Background.Paint = function( self, w, h )
				if v["premium"] then
					draw.RoundedBox( 2, 0, 0, w, h, Color(200, 255, 255, 210 ) )
				else
					draw.RoundedBox( 2, 0, 0, w, h, Color(200, 200, 200, 210 ) )
				end
			end
			
			local icon = vgui.Create( "DImage", Panel )
			icon:SetImage( v["icon"] )
			icon:SetSize(90,90)
			icon:CenterHorizontal( 0.5 )
			icon:CenterVertical( 0.6 )
			
			local Buy_Button = vgui.Create ( "DColorButton", Panel )
			Buy_Button:SetSize(90,90)
			Buy_Button:CenterHorizontal( 0.5 )
			Buy_Button:CenterVertical( 0.6 )
			Buy_Button:SetText( "", Color( 221,78,76 ) )
			Buy_Button.Paint = function( self, w, h ) end
			function Buy_Button:DoClick(ply)
				net.Start("BuyWeapon")
					net.WriteString(v["class"])
				net.SendToServer()
				MainFrame:Close()
			end
			DHorizontalScroller:AddPanel( Panel )
		end
	end
end
concommand.Add( "gma_shop", OpenShop )

function OpenHelpMenu()
	local ply = LocalPlayer()
	local TutMenu = vgui.Create( "DFrame" )
	TutMenu:SetSize( ScrW() * 0.8, ScrH() * 0.8 )
    TutMenu:SetTitle( "" )
    TutMenu:SetVisible ( true )
    TutMenu:SetDraggable ( true )
    TutMenu:ShowCloseButton ( true )
    TutMenu:MakePopup()
	TutMenu:Center()
	TutMenu:SetDeleteOnClose( true )
	TutMenu.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color(75, 75, 75, 230 ) )
	end

	local tabs = vgui.Create( "DPropertySheet", TutMenu )
	tabs:Dock(FILL)
	
	local tab1panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab1panel )
	icon:SetImage( "flicons/tutorials/1.png" )
	icon:Dock(FILL)
	
	local tab2panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab2panel )
	icon:SetImage( "flicons/tutorials/2.png" )
	icon:Dock(FILL)
	
	local tab3panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab3panel )
	icon:SetImage( "flicons/tutorials/3.png" )
	icon:Dock(FILL)
	
	local tab4panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab4panel )
	icon:SetImage( "flicons/tutorials/4.png" )
	icon:Dock(FILL)
	
	local tab5panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab5panel )
	icon:SetImage( "flicons/tutorials/5.png" )
	icon:Dock(FILL)
	
	local tab6panel = vgui.Create( "DPanel" )
	tab1panel:SetMouseInputEnabled( false )
	
	local icon = vgui.Create( "DImage", tab6panel )
	icon:SetImage( "flicons/tutorials/6.png" )
	icon:Dock(FILL)
	
	tabs:AddSheet( "Teams", tab1panel, "icon16/user.png", false, false, "About teams" )
	tabs:AddSheet( "Plants", tab2panel, "icon16/user.png", false, false, "About plants" )
	tabs:AddSheet( "Gardeners", tab3panel, "icon16/user.png", false, false, "About gardeners" )
	tabs:AddSheet( "How to Win", tab4panel, "icon16/user.png", false, false, "About round winning" )
	tabs:AddSheet( "Weapon Shop", tab5panel, "icon16/user.png", false, false, "About the weapon shop" )
	tabs:AddSheet( "Buttons", tab6panel, "icon16/user.png", false, false, "About all of the buttons" )
	
end
concommand.Add( "gma_help", OpenHelpMenu )
