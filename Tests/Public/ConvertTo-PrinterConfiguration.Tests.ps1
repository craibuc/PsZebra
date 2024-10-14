BeforeAll {

    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsZebra/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsZebra/Private/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $SUT)

}

Describe 'ConvertTo-PrinterConfiguration' {

    Context 'Parameter validation' {

        BeforeAll {
            $Command = Get-Command 'ConvertTo-PrinterConfiguration'
        }

        Context 'InputObject' {
            BeforeAll {
                $ParameterName='InputObject'
            }
            It "$ParameterName is a [object]" {
                $Command | Should -HaveParameter $ParameterName -Type [object]
            }
            It "$ParameterName is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "$ParameterName accepts ValueFromPipeline" -Skip {
            }
        }

    }

}