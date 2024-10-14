[CmdletBinding()]
param (
    [string]$IpAddress = '192.168.1.209',
    [int]$Timeout = 50
)

#requires -module PsZebra

# $ZPL = 
# "^XA
# ^CF0,35
# ^FO235,25,0^FD{0} {1}^FS
# ^FO235,100,0^FD{2}^FS
# ^FO235,175,0^FDSafety Score: {3}^FS
# ^FO235,250,0^FDMiles Driven: {4}^FS
# ^XZ" -f 'First', 'Last', '10/01/2024', 90, 150

# host identification
'~HI' | 
Out-ZebraPrinter -IpAddress $IpAddress -Timeout $Timeout

# printer configuration
# '^XA^HH^XZ' | 
# Out-ZebraPrinter -IpAddress $IpAddress -Timeout $Timeout |
# Where-Object { $null -ne $_ } | 
# ConvertTo-PrinterConfiguration

# host status
# '~HS' | 
# Out-ZebraPrinter -IpAddress $IpAddress -Timeout $Timeout | 
# Where-Object { $null -ne $_ } | 
# ConvertTo-PrinterStatus

# host alerts
'~HU' | 
Out-ZebraPrinter -IpAddress $IpAddress -Timeout $Timeout