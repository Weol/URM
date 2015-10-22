  
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {} 
if not TIIP.URM.Loaded then
	table.insert(TIIP.URM.LoadTable,"ulx/modules/loadouts.lua")
	return
end
 
function TIIP.URM.LoadLoadouts()
	local tbl = util.JSONToTable(TIIP.Files.Read("loadouts.txt"))
	if not tbl then
		ServerLog("loadouts.txt returned empty!\n")
		return false
	end
	TIIP.URM.Loadouts = tbl
end

function TIIP.URM.SaveLoadouts()
	TIIP.URM.UpdateTable(TIIP.URM.Loadouts,"TIIPURMLoadouts")
	local str = util.TableToJSON(TIIP.URM.Loadouts,true)
	TIIP.Files.Write("loadouts.txt",str)
end

function TIIP.URM.AddLoadoutWeapon(group,str,pri,sec)
	TIIP.URM.Loadouts[group] = TIIP.URM.Loadouts[group] or {}
	str = string.lower(str)
	TIIP.URM.Loadouts[group][str] = {primary = pri,secondary = sec}
	TIIP.URM.SaveLoadouts()
end

function TIIP.URM.SetLoadout(group,tbl)
	TIIP.URM.Loadouts[group] = tbl
end

function TIIP.URM.SetLoadoutPrimary(group,str)
	TIIP.URM.Loadouts[group] = TIIP.URM.Loadouts[group] or {}
	if not TIIP.URM.Loadouts[group][str] then return end
	str = string.lower(str)
	
	if (TIIP.URM.Loadouts[group][str].spawn) then
		TIIP.URM.Loadouts[group][str].spawn = nil
		TIIP.URM.SaveLoadouts()
		return  
	end
	
	for class,tbl in pairs(TIIP.URM.Loadouts[group]) do
		if (tbl.spawn) then tbl.spawn = nil end
	end
	
	TIIP.URM.Loadouts[group][str].spawn = true
	TIIP.URM.SaveLoadouts()
end

function TIIP.URM.DeleteLoadout(group)
	TIIP.URM.Loadouts[group] = nil
	TIIP.URM.SaveLoadouts()
end

function TIIP.URM.RemoveLoadoutWeapon(group,str)
	TIIP.URM.Loadouts[group] = TIIP.URM.Loadouts[group] or {}
	str = string.lower(str)
	if TIIP.URM.Loadouts[group][str] then TIIP.URM.Loadouts[group][str] = nil end
	TIIP.URM.SaveLoadouts()
end

function TIIP.URM.SetPlayerLoadout(ply)
	if not TIIP.URM.Loadouts[ply:GetUserGroup()] then return end
	if table.Count(TIIP.URM.Loadouts[ply:GetUserGroup()]) < 1 then return end
	ply:StripWeapons()
	
	ply.WhiteListWeapons = {}
	for k,v in pairs(TIIP.URM.Loadouts[ply:GetUserGroup()]) do
		ply.WhiteListWeapons[k] = true
		ply:Give(k)
	end
	
	ply:StripAmmo()
	for k,v in pairs(TIIP.URM.Loadouts[ply:GetUserGroup()]) do
		local weapon = ply:GetWeapon(k)
		if (weapon:GetPrimaryAmmoType() > - 1) or (weapon:GetSecondaryAmmoType() > -1) then
			local primary_default = math.abs((v.primary - weapon:Clip1())-v.primary)
			local secondary_default = math.abs((v.secondary - weapon:Clip1())-v.secondary)
			if (v.primary <= primary_default) then
				ply:GetWeapon(k):SetClip1(math.abs(v.primary))
			else
				local primary = v.primary - primary_default
				if (weapon:GetPrimaryAmmoType() > - 1) then
					ply:GiveAmmo(primary,weapon:GetPrimaryAmmoType())
				end
			end
			
			if (v.secondary <= secondary_default) then
				ply:GetWeapon(k):SetClip2(math.abs(v.secondary))
			else
				local secondary = v.secondary - secondary_default
				if (weapon:GetSecondaryAmmoType() > -1) then			
					ply:GiveAmmo(secondary,weapon:GetSecondaryAmmoType())
				end
			end
		end
		if v.spawn then
			ply:SelectWeapon(k)
		end
	end
	return false
end