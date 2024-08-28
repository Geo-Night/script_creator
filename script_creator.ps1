Write-Host "Script Creator - Automatic addon creation script"

$AddonName = Read-Host -Prompt "Enter the name of the addon (addon_name)"
$TableName = Read-Host -Prompt "Enter the name of the table (AddonName)"
$NeedServer = Read-Host -Prompt "Do you need a server part ? (y/n)"
$NeedClient = Read-Host -Prompt "Do you need a client part ? (y/n)"
$NeedConst = Read-Host -Prompt "Do you need constants values ? (y/n)"
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
$ConstComment = if ($NeedConst -eq "y" -or $NeedConst -eq "Y") { "" } else { "-- " }

New-Item -Path "./$AddonName/lua/autorun/" -Name "${AddonName}_load.lua" -ItemType "file" -Value @"
$TableName = {}

$TableName.Folder = "${AddonName}"

function ${TableName}:Load()

    if SERVER then

        -- Shared
        include($TableName.Folder .. "/config.lua")
        AddCSLuaFile($TableName.Folder .. "/config.lua")

        -- Server
        ${ServerComment}include($TableName.Folder .. "/server/sv_hooks.lua")
        ${ServerComment}include($TableName.Folder .. "/server/sv_functions.lua")
        ${ServerComment}include($TableName.Folder .. "/server/sv_network.lua")

        -- Client
        ${ClientComment}AddCSLuaFile($TableName.Folder .. "/client/cl_hooks.lua")
        ${ClientComment}AddCSLuaFile($TableName.Folder .. "/client/cl_functions.lua")
        ${ClientComment}AddCSLuaFile($TableName.Folder .. "/client/cl_network.lua")
        ${ClientComment}AddCSLuaFile($TableName.Folder .. "/client/cl_vgui.lua")

        -- Fonts
        resource.AddSingleFile("resource/fonts/Lexend-Bold.ttf")
        resource.AddSingleFile("resource/fonts/Lexend-Light.ttf")
        resource.AddSingleFile("resource/fonts/Lexend-Medium.ttf")
        resource.AddSingleFile("resource/fonts/Lexend-Regular.ttf")

    else

        -- Shared
        include($TableName.Folder .. "/config.lua")
        AddCSLuaFile($TableName.Folder .. "/config.lua")

        -- Client
        ${ClientComment}include($TableName.Folder .. "/client/cl_hooks.lua")
        ${ClientComment}include($TableName.Folder .. "/client/cl_functions.lua")
        ${ClientComment}include($TableName.Folder .. "/client/cl_network.lua")
        ${ClientComment}include($TableName.Folder .. "/client/cl_vgui.lua")

    end

end
${TableName}:Load()
"@ -Force > $null

New-Item -Path "./${LuaRoot}" -Name "config.lua" -ItemType "file" -Value @"
$TableName.Config = {}

$TableName.Config.AdminRanks = {
    ["superadmin"] = true,
    ["admin"] = true
}
"@ -Force > $null

if ($NeedConst -eq "y" -or $NeedConst -eq "Y") {

New-Item -Path "./${LuaRoot}" -Name "constants.lua" -ItemType "file" -Value @"
$TableName.Constants = {}

$TableName.Constants.Colors = {
    ["red"] = Color(255, 0, 0),
    ["green"] = Color(0, 255, 0),
    ["blue"] = Color(0, 0, 255)
}

$TableName.Constants.Materials = {
    ["example"] = Material("materials/${AddonName}/example.png")
}
"@ -Force > $null

}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client" -Name "cl_functions.lua" -ItemType "file" -Value @"
$TableName.Fonts = {}

function ${TableName}:RX(x) return x * ScrW() / 1920 end
function ${TableName}:RY(y) return y * ScrH() / 1080 end

function ${TableName}:Font(iSize, sType)

    iSize = iSize or 16
    sType = sType or "Regular"

    local sName = ("${TableName}:%s:%i"):format(sType, iSize)

    if not $TableName.Fonts[sName] then
    
        surface.CreateFont(sName, {
            font = ("Lexend %s"):format(sType),
            size = iSize,
            weight = 500,
            extended = false
        })

        $TableName.Fonts[sName] = true

    end

    return sName

end
"@ -Force > $null

}

if ($NeedClient -eq "y" -or $NeedClient -eq "Y") {

New-Item -Path "./${LuaRoot}client/" -Name "cl_hooks.lua" -ItemType "file" -Value @"
hook.Add("OnScreenSizeChanged", "${TableName}:OnScreenSizeChanged", function()
	${TableName}.Fonts = {}
end)
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

$FontFolderPath = Join-Path -Path "." -ChildPath "$AddonName/resource/fonts"
New-Item -Path $FontFolderPath -ItemType "directory" -Force > $null

$FontFiles = @("Lexend-Bold.ttf", "Lexend-Light.ttf", "Lexend-Medium.ttf", "Lexend-Regular.ttf")
$BaseUrl = "https://github.com/GregoireTacquet/script_creator/raw/main/static/"

foreach ($FontFile in $FontFiles) {
    $FontUrl = $BaseUrl + $FontFile
    $DestinationPath = Join-Path -Path $FontFolderPath -ChildPath $FontFile

    try {
        Invoke-WebRequest -Uri $FontUrl -OutFile $DestinationPath
        Write-Output "Downloaded successfully : $FontFile"
    } catch {
        Write-Error "Error downloading : $FontFile : $_"
    }
}

Write-Host "Processing"

Write-Host "
Successfully created!"