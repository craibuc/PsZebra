<#
.SYNOPSIS
Sends ZPL commands to a Zebra barcode printer.

.PARAMETER Command
The ZPL commands to be printed.

.PARAMETER IpAddress
The IP address of the printer.

.PARAMETER Port
The TCP/IP port of the printer.  Default: 9100.

.PARAMETER Timeout
The delay, in milliseconds, that the printer will wait during send and receive before failing.  Default: 500.

.EXAMPLE
'^FT78,76^A0N,28,28^FH\^FDHello, World!^FS' | Out-ZebraPrinter -IpAddress 10.10.10.10 -Port 9100

#>
function Out-ZebraPrinter
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$Command,

        [Parameter(Mandatory)]
        [string]$IpAddress,

        [Parameter()]
        [int]$Port = 9100,

        [Parameter()]
        [int]$Timeout = 500
    )

    begin {
        Write-Verbose "Opening connection to $IpAddress`:$Port..."

        try {
            if ($PSCmdlet.ShouldProcess("$IpAddress`:$Port",'Connect'))
            {
                $client = [System.Net.Sockets.TcpClient]::new()
                $client.SendTimeout = $Timeout # milliseconds
                $client.ReceiveTimeout = $Timeout # milliseconds        
                $client.Connect($ipAddress, $port)

                $writer = [System.IO.StreamWriter]::new($client.GetStream())
                $reader = [System.IO.StreamReader]::new($client.GetStream())
            }
        }
        catch {
            throw 'Printer not responding'
        }
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess("$IpAddress`:$Port",'Write'))
            {
                Write-Verbose 'Writing stream...'
                $writer.Write($Command)
                $writer.Flush()

                Write-Verbose 'Reading stream...'
                try 
                {
                    while ($reader.Peek()) {
                        $Line = $reader.ReadLine()
                        Write-Debug "Line: $Line"
                        Write-Output $Line
                    }
                }
                catch [System.IO.IOException] {
                    #  ignore
                }

            }
        }
        catch {
            Write-Error $_.Exception.Message    
        }
    }
    end {
        Write-Verbose 'Closing connection...'

        if ($null -ne $reader) {
            $reader.Dispose()
        }

        if ($null -ne $writer) {
            $writer.Dispose()    
        }

        if ($null -ne $client) {
            $client.Dispose()    
        }
    }

}