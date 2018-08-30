$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-ChoiceHandler Unit" -Tag "Unit" {
    $ChoiceSet = @("Choice1","Choice2","Choice3")
    $CorrectIndex = 0
    $GameObject = [PSCustomObject]@{ChoiceSet=$ChoiceSet;CorrectIndex=0}
    It "Returns True when the correct answer is guessed"{
        Mock -CommandName "Read-Host" {return 1}
        Mock -CommandName "Write-Host" {}
        $GameObject | Invoke-ChoiceHandler | Should Be $True
        Invoke-ChoiceHandler -ChoiceSet $ChoiceSet -CorrectIndex $CorrectIndex | Should Be $True
    }
    It "Returns False when the correct answer is guessed"{
        Mock -CommandName "Read-Host" {return 2}
        Mock -CommandName "Write-Host" {}
        $GameObject | Invoke-ChoiceHandler | Should Be $False
        Invoke-ChoiceHandler -ChoiceSet $ChoiceSet -CorrectIndex $CorrectIndex | Should Be $False
    }
    It "Correctly displays all output"{
        $Hint = "This is a Hint"
        Mock -CommandName "Read-Host" {return 1}
        Mock -CommandName "Write-Host" {Add-Content -Value $Object -Path TestDrive:\Test.txt -Force}
        $GameObject | Invoke-ChoiceHandler -Hint $Hint
        $result = (Get-Content TestDrive:\Test.txt) -join "`n"
        $expected = "This is a Hint`n" +
                    "(1) Choice1`n" +
                    "(2) Choice2`n" +
                    "(3) Choice3`n"
        $result | Should Be $Expected
    }
}