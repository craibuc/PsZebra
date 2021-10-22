<#
.SYNOPSIS
Sends ZPL commands to a Zebra barcode printer.

.PARAMETER Command
The ZPL commands to be printed.

.PARAMETER IpAddress
The IP address of the printer.

.PARAMETER Port
The TCP/IP port of the printer.

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
        [int]$Port = 9100
    )

    begin {
        Write-Verbose "Opening connection to $IpAddress`:$Port..."

        [System.Net.Sockets.TcpClient] $client
        [System.IO.StreamWriter] $writer

        try {
            if ($PSCmdlet.ShouldProcess("$IpAddress`:$Port",'Connect'))
            {
                $client = [System.Net.Sockets.TcpClient]::new()
                $client.Connect($ipAddress, $port)
                $writer = [System.IO.StreamWriter]::new($client.GetStream())
            }
        }
        catch {
            throw 'Printer not responding'
        }
    }
    process {
        try {
            Write-Verbose 'Writing stream...'
            if ($PSCmdlet.ShouldProcess("$IpAddress`:$Port",'Write'))
            {
                $writer.Write($Command)
                $writer.Flush()    
            }
        }
        catch {
            Write-Error $_.Exception.Message    
        }
    }
    end {
        Write-Verbose 'Closing connection...'

        if ($null -ne $writer)
        {
            $writer.Close()
            $writer.Dispose()    
        }

        if ($null -ne $client)
        {
            $client.Close()
            $client.Dispose()    
        }
    }

}