Write-Host "Script Creator - Automatic addon creation script"

$AddonName = Read-Host -Prompt "Enter the name of the addon (addon_name)"
$TableName = Read-Host -Prompt "Enter the name of the table (AddonName)"
$NeedServer = Read-Host -Prompt "Do you need a server part ? (y/n)"
$NeedClient = Read-Host -Prompt "Do you need a client part ? (y/n)"
Write-Host ""
Clear-Host

Write-Host "Creating the addon folder"

if ($AddonName -eq "") { $AddonName = "addon_name" }
if ($TableName -eq "") { $TableName = "AddonName" }

$LuaRoot = "$AddonName/lua/$AddonName/"

New-Item -Name "$AddonName" -ItemType "directory" -Force > $null

if ($NeedServer -eq "y" -or $NeedServer -eq "Y") {
    New-Item -Name "${LuaRoot}server" -ItemType "directory" -Force > $null
}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {
    New-Item -Name "${LuaRoot}client" -ItemType "directory" -Force > $null
}

Write-Host "Processing"

$ServerComment = if ($NeedServer -eq "y" -or $NeedServer -eq "Y") { "" } else { "-- " }
$ClientComment = if ($NeedClient -eq "y" -or $NeedClient -eq "Y") { "" } else { "-- " }

New-Item -Path "./$AddonName/lua/autorun/" -Name "${AddonName}_load.lua" -ItemType "file" -Value @"
-- Script table
$TableName = {}

-- Check if GLib (GeoNight Library) is installed
if not GLib then

    MsgC(Color(255, 0, 0), "[GTeleport.] GLib is not installed, please install it and restart the server.\n")
    return

end

-- Function to load script files
function ${TableName}:Load()

    local sFolder = "${AddonName}"

    if SERVER then

        -- [[ Shared part ]]--
        include(sFolder .. "/config.lua")
        AddCSLuaFile(sFolder .. "/config.lua")

        -- [[ Client part ]]--
        ${ClientComment}AddCSLuaFile(sFolder .. "/client/cl_hooks.lua")
        ${ClientComment}AddCSLuaFile(sFolder .. "/client/cl_functions.lua")
        ${ClientComment}AddCSLuaFile(sFolder .. "/client/cl_network.lua")
        ${ClientComment}AddCSLuaFile(sFolder .. "/client/cl_vgui.lua")

        -- [[ Server part ]]--
        ${ServerComment}include(sFolder .. "/server/sv_hooks.lua")
        ${ServerComment}include(sFolder .. "/server/sv_functions.lua")
        ${ServerComment}include(sFolder .. "/server/sv_network.lua")

    else

        -- [[ Shared part ]]--
        include(sFolder .. "/config.lua")
        AddCSLuaFile(sFolder .. "/config.lua")

        -- [[ Client part ]]--
        ${ClientComment}include(sFolder .. "/client/cl_hooks.lua")
        ${ClientComment}include(sFolder .. "/client/cl_functions.lua")
        ${ClientComment}include(sFolder .. "/client/cl_network.lua")
        ${ClientComment}include(sFolder .. "/client/cl_vgui.lua")

    end

end
${TableName}:Load()
"@ -Force > $null

New-Item -Path "./${LuaRoot}" -Name "config.lua" -ItemType "file" -Value @"
-- Config table
$TableName.Config = {}
"@ -Force > $null

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client" -Name "cl_functions.lua" -ItemType "file" -Value @"
-- cl_functions.lua
"@ -Force > $null

}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client/" -Name "cl_hooks.lua" -ItemType "file" -Value @"
-- cl_hooks.lua
"@ -Force > $null

}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client/" -Name "cl_network.lua" -ItemType "file" -Value @"
-- cl_network.lua
"@ -Force > $null

}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client/" -Name "cl_vgui.lua" -ItemType "file" -Value @"
-- cl_vgui.lua
"@ -Force > $null

}

if ($NeedServer -eq "y" -or $NeedServer -eq "Y") {

New-Item -Path "./${LuaRoot}server/" -Name "sv_network.lua" -ItemType "file" -Value @"
-- sv_network.lua
"@ -Force > $null

}

if ($NeedServer -eq "y" -or $NeedServer -eq "Y") {

New-Item -Path "./${LuaRoot}server/" -Name "sv_functions.lua" -ItemType "file" -Value @"
-- sv_functions.lua
"@ -Force > $null

}

if ($NeedServer -eq "y" -or $NeedServer -eq "Y") {

New-Item -Path "./${LuaRoot}server/" -Name "sv_hooks.lua" -ItemType "file" -Value @"
-- sv_hooks.lua
"@ -Force > $null

}

Write-Host "Processing"

Write-Host "
Successfully created!"