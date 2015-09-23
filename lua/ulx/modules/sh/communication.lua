
if SERVER then
 
	TIIP = TIIP or {}
	TIIP.URM = TIIP.URM or {}
	TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
	if not TIIP.URM.Loaded then
		table.insert(TIIP.URM.LoadTable,"ulx/modules/sh/communication.lua")
		return
	end
	
	TIIP.URM.StringTable = {}
	
	local current = {}
	local timeout_default = 50
	local timeout = 50
	function TIIP.URM.UpdateTable(lua,id)
		current[id] = lua
		timeout = timeout_default
	end
	
	function TIIP.URM.SendUpdate(tbl)
		for k,v in pairs (tbl) do
			xgui.sendDataTable(player.GetAll(),k,true)
		end
	end
	
	local function CheckSendTable()
		if (table.Count(current) < 1) then return end
		if timeout > 0 then
			timeout = timeout - 1
		else
			TIIP.URM.StringTable = current
			TIIP.URM.SendUpdate(current)
			current = {}
		end
	end
	hook.Add( "Think", "TIIPURMThink", CheckSendTable )
	
	util.AddNetworkString( "TIIPURMCommandStream" )
	function TIIP.URM.onRecieveTable(len,ply)
		local tbl = net.ReadTable()
		if ULib.ucl.query( ply, tbl[1] ) then
			TIIP.URM.Functions[tbl[1]](ply,unpack(tbl[2]))
		else
			ULib.tsayError( ply, "You do not have access to this!", true  )
		end
	end
	net.Receive( "TIIPURMCommandStream", TIIP.URM.onRecieveTable )


elseif CLIENT then

	TIIP = TIIP or {}
	TIIP.URM = TIIP.URM or {}

	function TIIP.URM.SendCommand(cmd,...)
		local tbl = {cmd,{...}}
		net.Start( "TIIPURMCommandStream" )
			net.WriteTable(tbl)
		net.SendToServer()
	end
	
end