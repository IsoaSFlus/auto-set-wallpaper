$scriptLocation = split-path -parent $MyInvocation.MyCommand.Definition
$date = Get-Date
if($date.Hour -ge 6 -and $date.Hour -lt 17) {
    $picPrefix = "d-*"
} elseif($date.Hour -ge 17 -and $date.Hour -lt 19) {
    $picPrefix = "s-*"
} else {
    $picPrefix = "yuuki-*"
}


function Set-Wallpaper  
{  
    param(  
        [Parameter(Mandatory=$true)]  
        $Path,  
   
        [ValidateSet('Center', 'Stretch')]  
        $Style = 'Stretch'  
    )  
   
    Add-Type @"  
using System;  
using System.Runtime.InteropServices;  
using Microsoft.Win32;  
namespace Wallpaper  
{  
public enum Style : int  
{  
Center, Stretch  
}  
public class Setter {  
public const int SetDesktopWallpaper = 20;  
public const int UpdateIniFile = 0x01;  
public const int SendWinIniChange = 0x02;  
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)] 
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);  
public static void SetWallpaper ( string path, Wallpaper.Style style ) {  
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange ); 
RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true); 
switch( style ) 
{ 
case Style.Stretch :  
key.SetValue(@"WallpaperStyle", "10") ;  
key.SetValue(@"TileWallpaper", "0") ;  
break;  
case Style.Center :  
key.SetValue(@"WallpaperStyle", "6") ;  
key.SetValue(@"TileWallpaper", "0") ;  
break;  
}  
key.Close();  
}  
}  
}  
"@  
   
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )  
}

Function Set-WallPaper-deputy($Value)
{

    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $value

    rundll32.exe user32.dll, UpdatePerUserSystemParameters 0, $false

}

Set-Wallpaper -Path $scriptLocation.ToString() + "\arsenixc_wallpaper\" + (Get-Random -InputObject (ls ($scriptLocation.ToString() + "\arsenixc_wallpaper\" + $picPrefix) -name)).ToString()
#Set-WallPaper-deputy -Value ($scriptLocation.ToString() + "\arsenixc_wallpaper\" + (ls ($scriptLocation.ToString() + "\arsenixc_wallpaper\" + $picPrefix) -name)).ToString()
