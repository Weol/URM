
if SERVER then
 
	TIIP = TIIP or {}
	TIIP.URM = TIIP.URM or {}
	TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
	if not TIIP.URM.Loaded then
		table.insert(TIIP.URM.LoadTable,"ulx/modules/sh/communication.lua")
		return
	end
	
	TIIP.URM.DATA = {
		TIIPURMLimits = function() return TIIP.URM.Limits end,
		TIIPURMRestrictions = function() return TIIP.URM.Restrictions end,
		TIIPURMLoadouts = function() return TIIP.URM.Loadouts end	
	}
	
	TIIP.URM.StringTable = {}
	
	local current = {}
	local timeout_default = 50
	local timeout = 50
	function TIIP.URM.UpdateTable(lua,id)
		current[id] = lua
		timeout = timeout_default
	end
	
	util.AddNetworkString("TIIPURMCompressedDataStream")
	function TIIP.URM.SendCompressedTable(ply, tbl, id) 
		if not tbl then return end
		if not id then return end
		if not ply then return end
		
		local data = util.Compress(util.TableToJSON(tbl))
		if not data then return end

		net.Start("TIIPURMCompressedDataStream")
			net.WriteUInt(data:len(),32)
			net.WriteString(id)
			net.WriteBool(false)
			net.WriteData(data,data:len())
		net.Send(ply)
		
	end
	
	function TIIP.URM.SendDataTable(id)
		for _,ply in pairs (player.GetAll()) do
			if (ULib.ucl.query( ply, "xgui_urm" ) and TIIP.URM.DATA[id]) then
				TIIP.URM.SendCompressedTable(ply,TIIP.URM.DATA[id](), id)
			end
		end
	end
	
	function TIIP.URM.SendUpdate(tbl)
		for k,v in pairs (tbl) do
			TIIP.URM.SendDataTable(k)
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
	
	TIIP.URM.AwaitingData = ""
	TIIP.URM.AwaitingLen = 0
	function TIIP.URM.RecieveCompressedData(lenght)
		local len = net.ReadUInt(32)
		local id = net.ReadString()
		local await = net.ReadBool()
		local data = net.ReadData(len)
		
		--Msg(string.format("Compressed data recieved! (SIZE: %s bytes)\n",tostring(lenght)))

		if not data then return end
		if not id then return end
		if not len then return end
		
		local tbl = util.Decompress(data)
		
		if not tbl then 
			Msg("Failed to decompress data!\n")
			return
		end
		
		tbl = util.JSONToTable(tbl)
		
		urm = urm or {}
		
		if (id == "TIIPURMLimits") then
			urm.Limits = tbl 
		
			hook.Call("TIIPURMLimitsUpdate")
		elseif (id == "TIIPURMRestrictions") then
			urm.Restrictions = tbl
		
			hook.Call("TIIPURMRestrictionsUpdate")
		elseif (id == "TIIPURMLoadouts") then 			
			urm.Loadouts = tbl
			
			hook.Call("TIIPURMLoadoutsUpdate")
		end
	end
	net.Receive("TIIPURMCompressedDataStream", TIIP.URM.RecieveCompressedData)
	
end