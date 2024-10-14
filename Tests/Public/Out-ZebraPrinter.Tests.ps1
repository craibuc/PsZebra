BeforeAll {

    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsZebra/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsZebra/Private/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $SUT)

}

Describe 'Out-ZebraPrinter' {

    Context 'Parameter validation' {

        BeforeAll {
            $Command = Get-Command 'Out-ZebraPrinter'
        }

        Context 'Command' {
            BeforeAll {
                $ParameterName='Command'
            }
            It "$ParameterName is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "$ParameterName is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "$ParameterName accepts ValueFromPipeline" -Skip {
            }
        }

        Context 'IpAddress' {
            BeforeAll {
                $ParameterName='IpAddress'
            }
            It "$ParameterName is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "$ParameterName is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'Port' {
            BeforeAll {
                $ParameterName='Port'
            }
            It "$ParameterName is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type [int]
            }
            It "$ParameterName is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'Timeout' {
            BeforeAll {
                $ParameterName='Timeout'
            }
            It "$ParameterName is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type [int]
            }
            It "$ParameterName is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

    }

}