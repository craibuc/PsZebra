BeforeAll {

    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsZebra/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsZebra/Private/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $SUT)

}

Describe 'ConvertTo-PrinterStatus' {

    Context 'Parameter validation' {

        BeforeAll {
            $Command = Get-Command 'ConvertTo-PrinterStatus'
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

    Context 'Usage' {

        Context 'Pause' {
    
            It 'returns the expected value' {
                # arrange
                $Response = '{0}030,0,1,0414,000,0,0,0,000,0,0,0{1}{2}{3}{0}001,0,0,0,1,2,6,0,00000000,1,000{1}{2}{3}{0}0000,0{1}' -f [char]2, [char]3, [char]13, [char]10
    
                # act
                $Actual = $Response | ConvertTo-PrinterStatus -Debug

                # assert
                $Actual.Pause -eq $true
            }
    
        }

        Context 'HeadUp' {
    
            It 'returns the expected value' {
                # arrange
                $Response = '{0}030,0,0,0414,000,0,0,0,000,0,0,0{1}{2}{3}{0}001,0,1,0,1,2,6,0,00000000,1,000{1}{2}{3}{0}0000,0{1}' -f [char]2, [char]3, [char]13, [char]10
    
                # act
                $Actual = $Response | ConvertTo-PrinterStatus -Debug

                # assert
                $Actual.HeadUp -eq $true
            }
    
        }

        Context 'Paper out' {
    
            It 'returns the expected value' {
                # arrange
                $Response = '{0}030,1,0,0414,000,0,0,0,000,0,0,0{1}{2}{3}{0}001,0,0,0,1,2,6,0,00000000,1,000{1}{2}{3}{0}0000,0{1}' -f [char]2, [char]3, [char]13, [char]10
    
                # act
                $Actual = $Response | ConvertTo-PrinterStatus -Debug

                # assert
                $Actual.PaperOut -eq $true
            }
    
        }

        Context 'Ribbon out' {
    
            It 'returns the expected value' {
                # arrange
                $Response = '{0}030,0,0,0414,000,0,0,0,000,0,0,0{1}{2}{3}{0}001,0,0,1,1,2,6,0,00000000,1,000{1}{2}{3}{0}0000,0{1}' -f [char]2, [char]3, [char]13, [char]10
                    
                # act
                $Actual = $Response | ConvertTo-PrinterStatus -Debug

                # assert
                $Actual.RibbonOut -eq $true
            }
    
        }

    }
}