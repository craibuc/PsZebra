<#
.SYNOPSIS
Convert a printer-configuration response to an object.

.DESCRIPTION
Convert a printer-configuration response to an object.

.PARAMETER InputObject
The printer's response from the printer-configuration (^HH) command.

.EXAMPLE
'^XA^HH^XZ' | Out-ZebraPrinter -IpAddress '192.168.1.209' | ConvertTo-PrinterConfiguration
#>

function ConvertTo-PrinterConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$InputObject
    )
        
    Begin {
        $KeyValue = @{}
    }
    Process {
        $Lines = $InputObject -split "`n"
        $Lines.ForEach({
            Write-Debug "`Line: $_"

            $Key = $_.Substring(21).Trim()
            $Value = $_.Substring(0,21).Trim()

            $KeyValue[$Key] = $Value
        })
    }
    End {
        [pscustomobject]$KeyValue
    }

}

<#
'  +15.0               DARKNESS          
  LOW                 DARKNESS SWITCH   
  4.0 IPS             PRINT SPEED       
  +000                TEAR OFF ADJUST   
  TEAR OFF            PRINT MODE        
  GAP/NOTCH           MEDIA TYPE        
  TRANSMISSIVE        SENSOR SELECT     
  THERMAL-TRANS.      PRINT METHOD      
  831                 PRINT WIDTH       
  0414                LABEL LENGTH      
  15.0IN   380MM      MAXIMUM LENGTH    
  MAINT. OFF          EARLY WARNING     
  NOT CONNECTED       USB COMM.         
  AUTO                SER COMM. MODE    
  9600                BAUD              
  8 BITS              DATA BITS         
  NONE                PARITY            
  XON/XOFF            HOST HANDSHAKE    
  NONE                PROTOCOL          
  NORMAL MODE         COMMUNICATIONS    
  <~>  7EH            CONTROL PREFIX    
  <^>  5EH            FORMAT PREFIX     
  <,>  2CH            DELIMITER CHAR    
  ZPL II              ZPL MODE          
  INACTIVE            COMMAND OVERRIDE  
  NO MOTION           MEDIA POWER UP    
  FEED                HEAD CLOSE        
  DEFAULT             BACKFEED          
  +000                LABEL TOP         
  +0000               LEFT POSITION     
  DISABLED            REPRINT MODE      
  052                 WEB SENSOR        
  096                 MEDIA SENSOR      
  067                 RIBBON SENSOR     
  000                 TAKE LABEL        
  067                 MARK SENSOR       
  004                 MARK MED SENSOR   
  038                 TRANS GAIN        
  025                 TRANS LED         
  000                 RIBBON GAIN       
  066                 MARK GAIN         
  058                 MARK LED          
  DPCSWFXM            MODES ENABLED     
  ........            MODES DISABLED    
   832 8/MM FULL      RESOLUTION        
  6.3                 LINK-OS VERSION   
  V93.21.07Z <-       FIRMWARE          
  1.3                 XML SCHEMA        
  7.0.1               HARDWARE ID       
  8176k............R: RAM               
  65536k...........E: ONBOARD FLASH     
  NONE                FORMAT CONVERT    
  FW VERSION          IDLE DISPLAY      
  10/14/24            RTC DATE          
  15:33               RTC TIME          
  DISABLED            ZBI               
  2.1                 ZBI VERSION       
  READY               ZBI STATUS        
  6,277 LABELS        NONRESET CNTR     
  6,277 LABELS        RESET CNTR1       
  6,277 LABELS        RESET CNTR2       
  13,816 IN           NONRESET CNTR     
  13,816 IN           RESET CNTR1       
  13,816 IN           RESET CNTR2       
  35,092 CM           NONRESET CNTR     
  35,092 CM           RESET CNTR1       
  35,092 CM           RESET CNTR2       
  002 WIRED           SLOT 1            
  0                   MASS STORAGE COUNT
  0                   HID COUNT         
  OFF                 USB HOST LOCK OUT ' | ConvertTo-PrinterConfiguration #-Debug
#>