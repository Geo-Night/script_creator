Write-Host "Script Creator - Automatic addon creation
"

# Asking for details
$DevName = Read-Host -Prompt "Entrez le nom (en minuscule, un seul mot) de votre addon (Par defaut : 'nom_addon')"
$TableName = Read-Host -Prompt "Entrez le nom de la table globale qui sera créée (Par defaut : 'NomAddon')"
$NeedServer = Read-Host -Prompt "Avez-vous besoin d'une partie serveur pour votre addon ? (y/n)"
$NeedClient = Read-Host -Prompt "Avez-vous besoin d'une partie client pour votre addon ? (y/n)"
$NeedConst = Read-Host -Prompt "Voulez-vous un fichier pour mettre des valeurs constantes ? (y/n)"
Write-Host ""
Clear-Host

Write-Host "Script Creator - Automatic addon creation

Processing"

# Set default values
if ($DevName -eq "") { $DevName = "addon_name" }
if ($TableName -eq "") { $TableName = "AddonName" }

$LuaRoot = "$DevName/lua/$DevName/"

# First step: Create folders
New-Item -Name "$DevName/lua/autorun" -ItemType "directory" -Force > $NULL

if ($NeedServer -eq "Y" -or $NeedServer -eq "y")
{
	New-Item -Name "${LuaRoot}server" -ItemType "directory" -Force > $NULL
}

if ($NeedClient -eq "Y" -or $NeedClient -eq "y")
{
	New-Item -Name "${LuaRoot}client" -ItemType "directory" -Force > $NULL
}

Write-Host "Processing."

# Second step: Create files
## autorun.lua
New-Item -Path "./$DevName/lua/autorun/" -Name "${DevName}_load.lua" -ItemType "file" -Value @"
$TableName = {}

$TableName.ID = "geows"

function ${TableName}:Load()

    if SERVER then

        include(self.ID.."/config.lua")
        include(self.ID.."/constants.lua")
    
        AddCSLuaFile(self.ID.."/config.lua")
        AddCSLuaFile(self.ID.."/constants.lua")

        AddCSLuaFile(self.ID.."/client/cl_functions.lua")
        AddCSLuaFile(self.ID.."/client/cl_hooks.lua")

    else

        include(self.ID.."/config.lua")
        include(self.ID.."/constants.lua")

        include(self.ID.."/client/cl_functions.lua")
        include(self.ID.."/client/cl_hooks.lua")

    end

end
${TableName}:Load()
"@ -Force > $NULL

## config.lua
New-Item -Path "./${LuaRoot}" -Name "config.lua" -ItemType "file" -Value @"
$TableName.Config = {}

-- Admin ranks
$TableName.Config.AdminRanks = {
	["superadmin"] = true,	
	["admin"] = true	
}
"@ -Force > $NULL

## constants.lua
if ($NeedConst -eq "Y" -or $NeedConst -eq "y")
{

New-Item -Path "./${LuaRoot}" -Name "constants.lua" -ItemType "file" -Value @"
$TableName.Constants = {}

-- Colors constants
$TableName.Constants["colors"] = {
	["background"] = Color(20, 20, 20),
	["header"] = Color(35, 35, 35),
	["primary"] = Color(8, 67, 214),
}

-- Materials constants
$TableName.Constants["materials"] = {
	["logo"] = Material("materials/${DevName}/icons/wasied.png"),
}
"@ -Force > $NULL

}

## cl_functions.lua
if ($NeedClient -eq "Y" -or $NeedClient -eq "y")
{

New-Item -Path "./${LuaRoot}client/" -Name "cl_functions.lua" -ItemType "file" -Value @"
$TableName.Fonts = {}

-- Automatic responsive functions
RX = RX or function(x) return x / 1920 * ScrW() end
RY = RY or function(y) return y / 1080 * ScrH() end

-- Automatic font-creation function
function ${TableName}:Font(iSize, iWeight)

    iSize = (iSize or 24)
    iWeight = (iWeight or 500)

    local sName = ("${TableName}:Font:%i:%i"):format(iSize, iWeight)

    if not $TableName.Fonts[sName] then

        surface.CreateFont(sName, {
            font = "Montserrat",
            extended = false,
            size = GeoWS:RX(iSize),
            weight = iWeight
        })

        $TableName.Fonts[sName] = true

    end

    return sName

end
"@ -Force > $NULL

}

## cl_hooks.lua
if ($NeedClient -eq "Y" -or $NeedClient -eq "y")
{

New-Item -Path "./${LuaRoot}client/" -Name "cl_hooks.lua" -ItemType "file" -Value @"
-- Clear fonts cache after a screen size change
hook.Add("OnScreenSizeChanged", "${TableName}:OnScreenSizeChanged", function()
	${TableName}.Fonts = {}
end)
"@ -Force > $NULL

}

Write-Host "Processing..
Processing..."
Clear-Host

Write-Host "
Successfully created! Have fun."