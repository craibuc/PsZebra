<#
.SYNOPSIS
Parses the printer's "raw" response into an object.

.DESCRIPTION

.PARAMETER InputObject
The printer's response.

.EXAMPLE

'~HS' | Out-ZebraPrinter -IpAddress '192.168.1.209' | ConvertTo-PrinterStatus

Formats             : 0
FormatWhilePrinting : True
PrintMode           : TearOff
UnderTemperature    : False
BufferFull          : False
Password            : 0000
HeadUp              : True
CorruptRam          : False
LabelWaiting        : False
Communication       : 30
RibbonOut           : False
n                   : 0
Pause               : True
ThermalTransferMode : True
PritnWidthMode      : 6
RamInstalled        : False
OverTemperature     : False
DiagnosticMode      : False
Functions           : PrintMode
iii                 : 000
LabelRemaining      : 0
PartialFormat       : False
GraphImages         : 0
PaperOut            : False
LabelLength         : 414

.NOTES
Sample response includes control characters and data.

# <STX> = \x02 - 2
# <ETX> = \x03 - 3
# <CR> = \x0D - 13
# <LF> = \x0A - 10

# <STX>030,0,0,0414,000,0,0,0,000,0,0,0<ETX><CR><LF>
# <STX>001,0,0,0,1,2,6,0,00000000,1,000<ETX><CR><LF>
# <STX>0000,0<ETX>

.LINK
https://arcanecode.com/2021/12/06/fun-with-powershell-enum-flags/

.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arithmetic_operators?view=powershell-7.4
#>

enum ThermalMode {
    Direct = 0
    Transfer = 1
}

enum MediaType {
    DieCut = 0
    Continuous = 1
}

[Flags()] 
enum Functions {
    PrintMode   = 1 -shl 0   # 00000001 1
    m1          = 1 -shl 1   # 00000010 2
    m2          = 1 -shl 2   # 00000100 4
    m3          = 1 -shl 3   # 00001000 8
    m4          = 1 -shl 4   # 00010000 16
    Diagnostics = 1 -shl 5   # 00100000 32
    Sensors     = 1 -shl 6   # 01000000 64
    MediaType   = 1 -shl 7   # 10000000 128
}

enum PrintMode {
    Rewind
    PeelOff
    TearOff
    Cutter
    Applicator
}

function ConvertTo-PrinterStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$InputObject
    )
        
    Begin {
        $i=0
        $Status = @{}
    }
    Process {

        $Commands = ($InputObject -replace '[\x02\x03\x0D]', '') -split '\x0A'

        switch ($i) {
            0 { 
                [int]$Status.Communication, [bool][int]$Status.PaperOut, [bool][int]$Status.Pause, 
                [int]$Status.LabelLength, [int]$Status.Formats, [bool][int]$Status.BufferFull, 
                [bool][int]$Status.DiagnosticMode, [bool][int]$Status.PartialFormat, $Status.iii, 
                [bool][int]$Status.CorruptRam, [bool][int]$Status.UnderTemperature, [bool][int]$Status.OverTemperature = $Commands -split ','
                        
                # $Status.Communication = $Status.Communication.ToString("B")
            }
            1 { 
                [Functions][int]$Status.Functions, $Status.n, [bool][int]$Status.HeadUp, 
                [bool][int]$Status.RibbonOut, [bool][int]$Status.ThermalTransferMode, [PrintMode]$Status.PrintMode, 
                $Status.PritnWidthMode, [bool][int]$Status.LabelWaiting, [int]$Status.LabelRemaining, 
                [bool][int]$Status.FormatWhilePrinting, [int]$Status.GraphImages = $Commands -split ','
                # $Status.Functions = $Status.Functions.ToString("B")

            }
            2 { 
                $Status.Password, [bool][int]$Status.RamInstalled = $Commands -split ','

            }
        }

        $i += 1

    }
    End {
        [pscustomobject]$Status
    }
    
}