
if not SERVER then return end

TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.Restrictions = {}
TIIP.URM.Limits = {}
TIIP.URM.Loadouts = {}
TIIP.URM.AdvLimits = {}

TIIP.URM.DataDirectory = "urm/"
TIIP.URM.ULXAccessString = "ulx urm_menu"
TIIP.URM.XGUIAccessString = "xgui urm"

TIIP.URM.OVERRIDE = "OVERRIDE" 
TIIP.URM.DENY = "DENY"
TIIP.URM.ALLOW = "ALLOW"
TIIP.URM.RESTRICTED = "RESTRICTED"

TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
function TIIP.URM.LoadAll()
	for k,v in pairs(TIIP.URM.LoadTable) do
		include(v)
	end
end

function TIIP.URM.Log(...)
	local args = { ... }
	local msg = ""
	msg, args = TIIP.URM.ExtractValue(args)
	if args then
		msg = TIIP.URM.SafeFormat(msg,args)
	end
	ulx.logSpawn( msg )  
end
TIIPURMLog = TIIP.URM.Log

function TIIP.URM.ExtractValue(args)
	local value = args[1]
	table.remove(args,1)
	return value,args
end

function TIIP.URM.SafeFormat(msg,args)
	if not args then return string.format(msg,"NO_ARGS") end
	if (table.Count(args) == 1) then
		args[1] = args[1] or "NO_DATA"
		msg = string.format(msg,args[1])
	else
		for k,v in pairs(args) do
			if not v then
				args[k] = "NO_DATA"
			end
		end
		msg = string.format(msg,unpack(args))
	end
	return msg
end

function TIIP.URM.LoadAllData()
	TIIP.URM.LoadRestrictions()
	TIIP.URM.LoadLimits()
	TIIP.URM.LoadLoadouts()
	
	TIIP.URM.SaveRestrictions()
	TIIP.URM.SaveLimits()
	TIIP.URM.SaveLoadouts()
end
TIIP.URM.Loaded = true
TIIP.URM.LoadAll()
TIIP.URM.LoadAllData()
