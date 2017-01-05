// Made by Kanade

TEAM_FLOWERS = 1
TEAM_GARDEN = 2
TEAM_DEAD = 3

local usergroups = {
	superadmin = "Super Admin",
	admin = "Admin",
	moderator = "Moderator",
	operator = "Operator"
}

local Frame = nil

function GM:Tick()
	 time = math.floor(GetGlobalFloat("time"))
end

function ShowScoreBoard()
	local count = 1
	local round = GetGlobalInt("RoundNumber")
	local allplayers = player.GetAll()
	local flowers = gteams.GetPlayers(TEAM_FLOWERS)
	local gardeners = gteams.GetPlayers(TEAM_GARDEN)
	local spectators = gteams.GetPlayers(TEAM_DEAD)
	local scrH = ScrH()
	local scrW = ScrW()
	local flowers_colorbackground = Color( 150, 255, 150 )
	local flowers_color = Color( 220, 220, 220 )
	local flowers_colorbluured = Color(0, 0, 0, 200)
	local flowers_playercolor = Color( 255, 255, 255, 255 )
	
	local gardeners_colorbackground = Color( 255, 168, 142 )
	local gardeners_color = Color( 220, 220, 220 )
	local gardeners_colorbluured = Color(0, 0, 0, 200)
	local gardeners_playercolor = Color( 255, 255, 255 )
	
	local spectators_colorbackground = Color(250, 250, 250, 100)
	local spectators_color = Color(250, 250, 250, 255)
	local spectators_colorbluured = Color(250, 250, 250, 200)
	local spectators_playercolor = Color(255, 255, 255, 255)
	
	Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 960, 540 )
	Frame:SetSize(scrW / 1.908, scrH / 1.5 )
	Frame:SetTitle( "" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:Center()
	Frame:MakePopup()
	Frame:SetDeleteOnClose( true )
	Frame.Paint = function( self, w, h ) draw.RoundedBox( 2, 0, 0, w, h, Color( 83, 86, 90, 120 ) ) end
	
	local dock1 = vgui.Create( "DPanel", Frame )
	dock1.Paint = function( self, w, h ) end
	dock1:Dock(FILL)
	
	local DScrollPanel = vgui.Create( "DScrollPanel", dock1 )
	DScrollPanel:Dock( FILL )
	
	local main_background = vgui.Create( "DPanel", DScrollPanel )
	main_background.Paint = function( self, w, h )
		draw.RoundedBox( 4, 0, 0, w, h, (Color(150,150,150, 150)) )
	end
	main_background:SetSize(scrW / 1.908, scrH / 12.5)
	main_background:Dock(TOP)
	
	local main_hostname = vgui.Create( "DLabel", main_background )
	main_hostname:SetText(GetHostName())
	main_hostname:SetFont("ScoreBoardFontMain")
	main_hostname:SetColor(Color(255,255,255))
	main_hostname:SetSize(scrW / 4, scrH / 25)
	main_hostname:Dock(TOP)
	main_hostname:DockMargin( 10, 0, 0, 0 )
	main_hostname:DockMargin( 10, 0, 0, 0 )
	
	local t_time = string.ToMinutesSeconds(tostring(time))
	local roundstate = ""
	if preparing then
		roundstate = "preparing"
	elseif postround then
		roundstate = "postround"
	elseif gamestarted then
		roundstate = "roundtime"
	else
		roundstate = "didnotstart"
	end
	local main_time = vgui.Create( "DLabel", main_background )
	main_time:SetFont("ScoreBoardFontMain2")
	main_time:SetColor(Color(255,255,255))
	main_time:SetSize(scrW / 1, scrH / 25)
	main_time:Dock(LEFT)
	main_time:DockMargin( 10, 0, 0, 0 )
	main_time:DockMargin( 10, 0, 0, 0 )
	main_time.Paint = function( self, w, h )
	t_time = string.ToMinutesSeconds(tostring(time))
		if roundstate == "didnotstart" then
			main_time:SetText("")
		else
			if maxround == nil then
				main_time:SetText(roundstate .. ": " .. t_time .. "  " .. "round: " .. round)
			else
				main_time:SetText(roundstate .. ": " .. t_time .. "  " .. "round: " .. round .. "/" .. maxround)
			end
		end
	end
	
	///////////////////////////////////////////// FLOWERS /////////////////////////////////////////////
	if #flowers > 0 then
		count = count + 1
		local flowers_background = vgui.Create( "DPanel", DScrollPanel )
		flowers_background.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, flowers_colorbackground )
		end
		flowers_background:SetSize(scrW / 1.908, scrH / 25)
		flowers_background:SetPos(0,count * 48)
		flowers_background:Dock(TOP)
		flowers_background:DockMargin( 0, scrH / 108, 0, 0 )
		flowers_background:DockPadding( 0, 0, 0, 0 )
		
		local flowers_textblur = vgui.Create( "DLabel", flowers_background )
		flowers_textblur:SetText("Plants")
		flowers_textblur:SetFont("ScoreBoardFontTeamsBlur")
		flowers_textblur:SetColor(flowers_colorbluured)
		flowers_textblur:SetSize(scrW / 4, scrH / 25)
		flowers_textblur:Dock(TOP)
		
		local flowers_text = vgui.Create( "DLabel", flowers_textblur )
		flowers_text:SetText("Plants")
		flowers_text:SetFont("ScoreBoardFontTeams")
		flowers_text:SetColor(flowers_color)
		flowers_text:SetSize(scrW / 4, scrH / 25)
		flowers_text:Dock(TOP)
		
		for k,v in pairs(flowers) do
			if IsValid(v) then
				count = count + 1
				local DLabel = vgui.Create( "DLabel", DScrollPanel )
				DLabel:SetText("")
				DLabel:SetHeight(scrH / 25)
				DLabel:Dock(TOP)
				DLabel:DockMargin( 0, scrH / 250, 0, 0 )
				DLabel:SetMouseInputEnabled( false )
				DLabel.Paint = function( self, w, h )
					if IsValid(v) then
						draw.RoundedBox( 2, 0, 0, w, h, flowers_colorbackground )
					end
				end
				
				local name = vgui.Create( "DLabel", DLabel )
				name:SetText(string.sub( v:Nick(), 1, 14 ))
				name:SetSize(scrW / 4.8,scrH / 36)
				name:Dock(TOP)
				name:DockMargin( scrH / 21.6, 4.5, 0, 0 )
				name:SetFont("ScoreBoardFont1")
				name.Paint = function( self, w, h ) end
				name:SetColor(flowers_playercolor)
				
				local healthicon = vgui.Create( "DImage", DLabel )
				healthicon:SetPos(scrW / 7.5, 4.5)
				healthicon:SetSize( scrH / 36, scrH / 36 )
				if v:Alive() and v:Health() > 0 then
					healthicon:SetImage( "zpicons/health.png" )
				else
					healthicon:SetImage( "zpicons/skull.png" )
				end
				
				if v:Alive() and v:Health() > 0 then
					local health = vgui.Create( "DLabel", DLabel )
					health:SetText(v:Health())
					health:SetSize(scrW / 4.8,scrH / 36)
					health:SetPos(scrW / 6.4, 4.5)
					health:SetFont("ScoreBoardFont2")
					health.Paint = function( self, w, h )
						if IsValid(v) then
							health:SetText(v:Health())
						end
					end
				end
				
				local fragsicon = vgui.Create( "DImage", DLabel )
				fragsicon:SetPos(scrW / 4.9, 4.5)
				fragsicon:SetSize( scrH / 36, scrH / 36 )
				fragsicon:SetImage( "zpicons/cash.png" )
				
				local frags = vgui.Create( "DLabel", DLabel )
				frags:SetPos(scrW / 4.517, 4.5)
				frags:SetText(v:Frags())
				frags:SetSize(scrW / 4.8,scrH / 36)
				frags:SetFont("ScoreBoardFont2")
				frags.Paint = function( self, w, h ) end
				
				local pingicon = vgui.Create( "DImage", DLabel )
				pingicon:SetPos(scrW / 2.23, 4.5)
				pingicon:SetSize( scrH / 36, scrH / 36 )
				local ping = v:Ping()
				if ping < 80 then
					if v:IsBot() == false then
						pingicon:SetImage( "zpicons/pingMax.png" )
					end
				elseif ping >= 80 and ping < 175 then
					pingicon:SetImage( "zpicons/pingGood.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingLow.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingCritical.png" )
				else
					pingicon:SetImage( "zpicons/pingCritical.png" )
				end
			
				local ping = vgui.Create( "DLabel", DLabel )
				if v:IsBot() then
					ping:SetText("BOT")
					ping:SetPos(scrW / 2.2, 4.5)
				else
					ping:SetText(v:Ping())
					ping:SetPos(scrW / 2.133, 4.5)
				end
				ping:SetSize(scrW / 4.8,scrH / 36)
				ping:SetFont("ScoreBoardFont2")
			
				if usergroups[v:GetUserGroup()] then
					local usergroup = vgui.Create( "DLabel", DLabel )
					usergroup:SetText(usergroups[v:GetUserGroup()])
					usergroup:SetSize(scrW / 4.8,scrH / 36)
					usergroup:SetPos(scrW / 3.072, 4.5)
					usergroup:SetFont("ScoreBoardFont2")
					usergroup.Paint = function( self, w, h ) end
				end
				
				local Avatar = vgui.Create( "AvatarImage", DLabel )
				Avatar:SetSize( scrH / 25, scrH / 25 )
				Avatar:SetPos( 0, 0 )
				Avatar:SetPlayer( v, 64 )
			end
		end
	end
	
	///////////////////////////////////////////// GARDENERS /////////////////////////////////////////////
	if #gardeners > 0 then
		count = count + 1
		local gardeners_background = vgui.Create( "DPanel", DScrollPanel )
		gardeners_background.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, gardeners_colorbackground )
		end
		gardeners_background:SetSize(scrW / 1.908, scrH / 25)
		gardeners_background:SetPos(0,count * 48)
		gardeners_background:Dock(TOP)
		gardeners_background:DockMargin( 0, scrH / 108, 0, 0 )
		gardeners_background:DockPadding( 0, 0, 0, 0 )
		
		local gardeners_textblur = vgui.Create( "DLabel", gardeners_background )
		gardeners_textblur:SetText("Gardeners")
		gardeners_textblur:SetFont("ScoreBoardFontTeamsBlur")
		gardeners_textblur:SetColor(gardeners_colorbluured)
		gardeners_textblur:SetSize(scrW / 4, scrH / 25)
		gardeners_textblur:Dock(TOP)
		
		local gardeners_text = vgui.Create( "DLabel", gardeners_textblur )
		gardeners_text:SetText("Gardeners")
		gardeners_text:SetFont("ScoreBoardFontTeams")
		gardeners_text:SetColor(gardeners_color)
		gardeners_text:SetSize(scrW / 4, scrH / 25)
		gardeners_text:Dock(TOP)
		
		for k,v in pairs(gardeners) do
			if IsValid(v) then
				count = count + 1
				local DLabel = vgui.Create( "DLabel", DScrollPanel )
				DLabel:SetText("")
				DLabel:SetHeight(scrH / 25)
				DLabel:Dock(TOP)
				DLabel:DockMargin( 0, scrH / 250, 0, 0 )
				DLabel.Paint = function( self, w, h )
					if IsValid(v) then
						draw.RoundedBox( 2, 0, 0, w, h, gardeners_colorbackground )
					end
				end
				
				local name = vgui.Create( "DLabel", DLabel )
				name:SetText(string.sub( v:Nick(), 1, 14 ))
				name:SetSize(scrW / 4.8,scrH / 36)
				name:Dock(TOP)
				name:DockMargin( scrH / 21.6, 4.5, 0, 0 )
				name:SetFont("ScoreBoardFont1")
				name.Paint = function( self, w, h ) end
				name:SetColor(gardeners_playercolor)
				
				local healthicon = vgui.Create( "DImage", DLabel )
				healthicon:SetPos(scrW / 7.5, 4.5)
				healthicon:SetSize( scrH / 36, scrH / 36 )
				if v:Alive() and v:Health() > 0 then
					healthicon:SetImage( "zpicons/health.png" )
				else
					healthicon:SetImage( "zpicons/skull.png" )
				end
				
				if v:Alive() and v:Health() > 0 then
					local health = vgui.Create( "DLabel", DLabel )
					health:SetText(v:Health())
					health:SetSize(scrW / 4.8,scrH / 36)
					health:SetPos(scrW / 6.4, 4.5)
					health:SetFont("ScoreBoardFont2")
					health.Paint = function( self, w, h )
						if IsValid(v) then
							health:SetText(v:Health())
						end
					end
				end
				
				local fragsicon = vgui.Create( "DImage", DLabel )
				fragsicon:SetPos(scrW / 4.9, 4.5)
				fragsicon:SetSize( scrH / 36, scrH / 36 )
				fragsicon:SetImage( "zpicons/cash.png" )
				
				local frags = vgui.Create( "DLabel", DLabel )
				frags:SetPos(scrW / 4.517, 4.5)
				frags:SetText(v:Frags())
				frags:SetSize(scrW / 4.8,scrH / 36)
				frags:SetFont("ScoreBoardFont2")
				frags.Paint = function( self, w, h ) end
				
				local pingicon = vgui.Create( "DImage", DLabel )
				pingicon:SetPos(scrW / 2.23, 4.5)
				pingicon:SetSize( scrH / 36, scrH / 36 )
				local ping = v:Ping()
				if ping < 80 then
					if v:IsBot() == false then
						pingicon:SetImage( "zpicons/pingMax.png" )
					end
				elseif ping >= 80 and ping < 175 then
					pingicon:SetImage( "zpicons/pingGood.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingLow.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingCritical.png" )
				else
					pingicon:SetImage( "zpicons/pingCritical.png" )
				end
			
				local ping = vgui.Create( "DLabel", DLabel )
				if v:IsBot() then
					ping:SetText("BOT")
					ping:SetPos(scrW / 2.2, 4.5)
				else
					ping:SetText(v:Ping())
					ping:SetPos(scrW / 2.133, 4.5)
				end
				ping:SetSize(scrW / 4.8,scrH / 36)
				ping:SetFont("ScoreBoardFont2")
			
				if usergroups[v:GetUserGroup()] then
					local usergroup = vgui.Create( "DLabel", DLabel )
					usergroup:SetText(usergroups[v:GetUserGroup()])
					usergroup:SetSize(scrW / 4.8,scrH / 36)
					usergroup:SetPos(scrW / 3.072, 4.5)
					usergroup:SetFont("ScoreBoardFont2")
					usergroup.Paint = function( self, w, h ) end
				end
			
				local Avatar = vgui.Create( "AvatarImage", DLabel )
				Avatar:SetSize( scrH / 25, scrH / 25 )
				Avatar:SetPos( 0, 0 )
				Avatar:SetPlayer( v, 64 )
			end
		end
	end
	
	///////////////////////////////////////////// SPECTATORS /////////////////////////////////////////////
	if #spectators > 0 then
		count = count + 1
		local spectators_background = vgui.Create( "DPanel", DScrollPanel )
		spectators_background.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, spectators_colorbackground )
		end
		spectators_background:SetSize(scrW / 1.908, scrH / 25)
		spectators_background:SetPos(0,count * 48)
		spectators_background:Dock(TOP)
		spectators_background:DockMargin( 0, scrH / 108, 0, 0 )
		spectators_background:DockPadding( 0, 0, 0, 0 )
		
		local spectators_textblur = vgui.Create( "DLabel", spectators_background )
		spectators_textblur:SetText("Spectators")
		spectators_textblur:SetFont("ScoreBoardFontTeamsBlur")
		spectators_textblur:SetColor(spectators_colorbluured)
		spectators_textblur:SetSize(scrW / 4, scrH / 25)
		spectators_textblur:Dock(TOP)
		
		local spectators_text = vgui.Create( "DLabel", spectators_textblur )
		spectators_text:SetText("Spectators")
		spectators_text:SetFont("ScoreBoardFontTeams")
		spectators_text:SetColor(spectators_color)
		spectators_text:SetSize(scrW / 4, scrH / 25)
		spectators_text:Dock(TOP)
		
		for k,v in pairs(spectators) do
			if IsValid(v) then
				count = count + 1
				local DLabel = vgui.Create( "DLabel", DScrollPanel )
				DLabel:SetText("")
				DLabel:SetHeight(scrH / 25)
				DLabel:Dock(TOP)
				DLabel:DockMargin( 0, scrH / 250, 0, 0 )
				DLabel.Paint = function( self, w, h )
					if IsValid(v) then
						draw.RoundedBox( 2, 0, 0, w, h, spectators_colorbackground )
					end
				end
				
				local name = vgui.Create( "DLabel", DLabel )
				name:SetText(string.sub( v:Nick(), 1, 14 ))
				name:SetSize(scrW / 4.8,scrH / 36)
				name:Dock(TOP)
				name:DockMargin( scrH / 21.6, 4.5, 0, 0 )
				name:SetFont("ScoreBoardFont1")
				name.Paint = function( self, w, h ) end
				name:SetColor(spectators_playercolor)
				
				local fragsicon = vgui.Create( "DImage", DLabel )
				fragsicon:SetPos(scrW / 4.9, 4.5)
				fragsicon:SetSize( scrH / 36, scrH / 36 )
				fragsicon:SetImage( "zpicons/cash.png" )
				
				local frags = vgui.Create( "DLabel", DLabel )
				frags:SetPos(scrW / 4.517, 4.5)
				frags:SetText(v:Frags())
				frags:SetSize(scrW / 4.8,scrH / 36)
				frags:SetFont("ScoreBoardFont2")
				frags.Paint = function( self, w, h ) end
				
				local pingicon = vgui.Create( "DImage", DLabel )
				pingicon:SetPos(scrW / 2.23, 4.5)
				pingicon:SetSize( scrH / 36, scrH / 36 )
				local ping = v:Ping()
				if ping < 80 then
					if v:IsBot() == false then
						pingicon:SetImage( "zpicons/pingMax.png" )
					end
				elseif ping >= 80 and ping < 175 then
					pingicon:SetImage( "zpicons/pingGood.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingLow.png" )
				elseif ping >= 175 and ping < 250 then
					pingicon:SetImage( "zpicons/pingCritical.png" )
				else
					pingicon:SetImage( "zpicons/pingCritical.png" )
				end
			
				local ping = vgui.Create( "DLabel", DLabel )
				if v:IsBot() then
					ping:SetText("BOT")
					ping:SetPos(scrW / 2.2, 4.5)
				else
					ping:SetText(v:Ping())
					ping:SetPos(scrW / 2.133, 4.5)
				end
				ping:SetSize(scrW / 4.8,scrH / 36)
				ping:SetFont("ScoreBoardFont2")
			
				if usergroups[v:GetUserGroup()] then
					local usergroup = vgui.Create( "DLabel", DLabel )
					usergroup:SetText(usergroups[v:GetUserGroup()])
					usergroup:SetSize(scrW / 4.8,scrH / 36)
					usergroup:SetPos(scrW / 3.072, 4.5)
					usergroup:SetFont("ScoreBoardFont2")
					usergroup.Paint = function( self, w, h ) end
				end
			
				local Avatar = vgui.Create( "AvatarImage", DLabel )
				Avatar:SetSize( scrH / 25, scrH / 25 )
				Avatar:SetPos( 0, 0 )
				Avatar:SetPlayer( v, 64 )
			end
		end
	end
	
end

function GM:ScoreboardShow()
	ShowScoreBoard()
end

function GM:ScoreboardHide()
	if IsValid(Frame) then
		Frame:Close()
	end
end