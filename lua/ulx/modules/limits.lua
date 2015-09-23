 
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
if not TIIP.URM.Loaded then
	table.insert(TIIP.URM.LoadTable,"ulx/modules/limits.lua")
	return
end

TIIP.URM.AdvLimitsReversed = {}

function TIIP.URM.LoadLimits()
	local tbl = util.JSONToTable(TIIP.Files.Read("limits.txt"))
	if not tbl then
		ServerLog("limits.txt returned empty!\n")
		return false
	end
	TIIP.URM.Limits = tbl
end

function TIIP.URM.SaveLimits()
	TIIP.URM.UpdateTable(TIIP.URM.Limits,"TIIPURMLimits")
	local str = util.TableToJSON(TIIP.URM.Limits,true)
	TIIP.Files.Write("limits.txt",str)
end

function TIIP.URM.AddLimit(group,str,limit)
	TIIP.URM.Limits[group] = TIIP.URM.Limits[group] or {}
	if tonumber(limit) ~= nil then limit = tonumber(limit) end
	str = string.lower(str)
	TIIP.URM.Limits[group][str] = limit
	TIIP.URM.SaveLimits()
end

function TIIP.URM.RemoveLimit(group,str)
	TIIP.URM.Limits[group] = TIIP.URM.Limits[group] or {}
	str = string.lower(str)
	TIIP.URM.Limits[group][str] = nil
	TIIP.URM.SaveLimits()
end

function TIIP.URM.GetLimitString(ply,ent)
	local class = ent:GetClass()
	local model = ent:GetModel()
	
	--Check if class is limited
	if TIIP.URM.Limits[ply:GetUserGroup()] then
		if TIIP.URM.Limits[ply:GetUserGroup()][class] then
			return class
		end
	end
	
	--Check if model is limited
	if TIIP.URM.Limits[ply:GetUserGroup()] then
		if TIIP.URM.Limits[ply:GetUserGroup()][class] then
			return model
		end
	end
end
 
function TIIP.URM.HasURMLimit(ply,str)
	str = string.lower(str)
	--ServerLog(string.format("TIIP.URM.HasURMLimit(%s,%s)\n",tostring(ply),str))
	if not ply then return false end
	if (string.lower(type(ply)) == "string") then return false end
	local group = ply:GetUserGroup()
	TIIP.URM.Limits[group] = TIIP.URM.Limits[group] or {}
	if TIIP.URM.Limits[group][str] then 
		return str, TIIP.URM.Limits[group][str]
	end
	return false
end

function TIIP.URM.CheckLimit(ply,str)
	str = string.lower(str)
	if not TIIP.URM.Limits[ply:GetUserGroup()] then return true end
	if not TIIP.URM.Limits[ply:GetUserGroup()][str] then return true end
	
	if (type(TIIP.URM.Limits[ply:GetUserGroup()][str]) == "string") then
		local initial_limit = TIIP.URM.Limits[ply:GetUserGroup()][str]
		local limit = initial_limit
		local limit_cache = {}
	
		while (type(limit) == "string") do
			if table.HasValue(limit_cache,limit) then return true end
			table.insert(limit_cache,limit)
			limit = TIIP.URM.Limits[ply:GetUserGroup()][limit]
		end	
		if not(type(limit) == "number") then return true end
				
		if (ply:GetCount(initial_limit) >= limit) then 
			ply:LimitHit( initial_limit, true )
			return false
		else
			return true
		end
			
	end

	if (ply:GetCount(str) >= TIIP.URM.Limits[ply:GetUserGroup()][str]) then 
		ply:LimitHit( str, true )
		return false
	end
	return true
end