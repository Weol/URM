
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
if not TIIP.URM.Loaded then 
	table.insert(TIIP.URM.LoadTable,"ulx/modules/files.lua")
	return
end
--Msg("Files added\n")

local Files = {}

function Files.Initialize()

	--Create Data folder
	Files.CreateDir(TIIP.URM.DataDirectory)

end
	
function Files.CreateDir(dir)
	if not file.IsDir(dir, "DATA") then
		file.CreateDir(dir)
	end
end

function Files.Append(path,text)
	local f = file.Exists(TIIP.URM.DataDirectory..path,"DATA")
	if (not f) then
		Files.Write(TIIP.URM.DataDirectory..path,text)
		return 
	end
	file.Append(TIIP.URM.DataDirectory..path, text)
end

function Files.Exists(path)
	return file.Exists(TIIP.URM.DataDirectory..path, "DATA")
end

function Files.Delete(path) 
	file.Delete( TIIP.URM.DataDirectory..path )
end

function Files.Write(path,text)
	file.Write( TIIP.URM.DataDirectory..path, text )
end

function Files.Read(path)
	local f = file.Open( TIIP.URM.DataDirectory..path, "r", "DATA" )
	if ( !f ) then return "" end
	local str = f:Read( f:Size() )
	f:Close()
	return str or ""
end
Files.Initialize()

TIIP.Files = Files