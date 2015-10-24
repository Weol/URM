
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {} 
if not TIIP.URM.Loaded then
	table.insert(TIIP.URM.LoadTable,"ulx/modules/restrictions.lua")
	return
end
 
function TIIP.URM.LoadRestrictions()
	local tbl = util.JSONToTable(TIIP.Files.Read("restrictions.txt"))
	if not tbl then
		ServerLog("restrictions.txt returned empty!\n")
		return false
	end
	TIIP.URM.Restrictions = tbl
end

function TIIP.URM.SaveRestrictions()
	TIIP.URM.UpdateTable(TIIP.URM.Restrictions,"TIIPURMRestrictions")
	local str = util.TableToJSON(TIIP.URM.Restrictions,true)
	TIIP.Files.Write("restrictions.txt",str)
end

function TIIP.URM.AddRestriction(group,str,type)
	TIIP.URM.Restrictions[group] = TIIP.URM.Restrictions[group] or {}
	TIIP.URM.Restrictions[group][type] = TIIP.URM.Restrictions[group][type] or {}
	str = string.lower(str)
	TIIP.URM.Restrictions[group][type][str] = TIIP.URM.RESTRICTED
	TIIP.URM.SaveRestrictions()
end

function TIIP.URM.RemoveRestriction(group,str,type)
	if not TIIP.URM.Restrictions[group] then return end
	if not TIIP.URM.Restrictions[group][type] then return end
	if not TIIP.URM.Restrictions[group][type][str] then return end
	TIIP.URM.Restrictions[group][type][str] = nil
	
	TIIP.URM.SaveRestrictions()
end

function TIIP.URM.CheckRestrictions(ply,str,type)
	str = string.lower(str); type = string.lower(type);
	if not ply:GetUserGroup() then ServerLog("NO USERGROUP SET!"); return true end
	if not TIIP.URM.Restrictions[ply:GetUserGroup()] then return true end
	if not TIIP.URM.Restrictions[ply:GetUserGroup()] then return TIIP.URM.ALLOW end
	if not TIIP.URM.Restrictions[ply:GetUserGroup()][type] then return TIIP.URM.ALLOW end
	if ply.WhiteListWeapons then
		if ply.WhiteListWeapons[str] then
			ply.WhiteListWeapons[str] = nil
			return TIIP.URM.ALLOW
		end
	end
	if (TIIP.URM.Restrictions[ply:GetUserGroup()][type][str] == TIIP.URM.OVERRIDE) then return TIIP.URM.OVERRIDE end
	if TIIP.URM.Restrictions[ply:GetUserGroup()][type][str] then return TIIP.URM.DENY end
	return TIIP.URM.ALLOW
end
