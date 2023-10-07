function fullScreenCapture{
	<#
	.SYNOPSIS
	        Simple Screen-Capture done in PowerShell

            Needs ffmpeg: https://www.ffmpeg.org/
			
			Author: Pepe - Version: 0.0.9
		
    .DESCRIPTION
	        Simple  Full Screen-Capture done in PowerShell
			
            Uses FFMPeg to make a video file (.avi format)
			
			$ffMPEgPath -> definition is needed
			$timeOut -> recording length (removable)
			
			$audio -> use alternative device name obtained with: ffmpeg -list_devices true -f dshow -i dummy			
			
	.EXAMPLE
	        fullScreenCapture -outFolder 'C:\Users\.....\Desktop'
#>

	[CmdletBinding()]
        PARAM(
            [Parameter(Mandatory=$true,Position=0)]
            [Alias("path")]
            [string]$outFolder,
            [Parameter(Mandatory=$false,Position=1)]
            [Alias("FPS")]
            [string]$framerate = 15, 
            [Parameter(Mandatory=$false,Position=2)]
            [string]$videoName = 'out.avi',
			[string]$timeOut = '00:00:10',
			[string]$audio = "@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{733DE5FE-556D-4DF8-A274-7BBCD5B54300}",
            [Parameter(Mandatory=$false,Position=3)]
            [string]$ffMPegPath = 'C:\Users\.....\Downloads\ffmpeg-N-101429-g54e5d21aca-win64-gpl-shared-vulkan\bin\ffmpeg.exe',
            [switch]$Confirm
        )
        begin{
		
		#FFMPEG Path Error Alert
		Add-Type -AssemblyName system.drawing
        if(!$(test-path -Path $ffMPegPath -ErrorAction SilentlyContinue))
        {
			Write-Error 'FFMPeg path is incorrect'
            return -1
        }
			
		Write-Verbose 'Creating video using ffmpeg'
		#---------------- Feel free to exclude the argument -t $timeOut for an unlimited recording --------------------------
		
		#With Audio
		$args = "-f gdigrab -framerate $framerate -i desktop -f dshow -i audio=$audio -t $timeOut $outFolder\$videoName -y"
		
		#Audio +++
		#$args = "-f gdigrab -framerate ntsc -video_size 1920x1080 -i desktop -f dshow -i audio=$audio -vcodec libx264 -pix_fmt yuv420p -preset ultrafast -t $timeOut $outFolder\$videoName -y"
		
		#NoAudio
        #$args = "-f gdigrab -framerate $framerate -i desktop -t $timeOut $outFolder\$videoName -y"
			
		
		Start-Process -FilePath $ffMPegPath -ArgumentList $args 
		# Use same PowerShell -NoNewWindow -> only with timer
		}End{
		}
}
fullScreenCapture -outFolder 'C:\Users\....\Desktop'
