$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-GameChoiceSet Unit" {
    $NumOptions = 3
    $NumChoices = 4
    $Choices = @("Choice1","Choice2","Choice3","Choice4","Choice5","Choice6","Choice7","Choice8","Choice9","Choice10","Choice11","Choice12")

    $GameSet = New-GameChoiceSet -Choices $Choices -NumOptions $NumOptions -NumChoices $NumChoices
    #write-Host ($GameSet | Out-String)
    It "Should Generate the correct number of choice sets"{
        $GameSet.Count | Should Be $NumChoices
    }
    It "Should Generate Unique Choice Sets"{
        foreach($Set in $GameSet){
            ($Set.ChoiceSet | Select -Unique).Count | Should Be $NumOptions
        }
    }
    It "Should Generate the correct number of Correct Choices"{
        $GameSet.CorrectChoice.Count | Should Be $NumChoices
    }
    It "Should Generate Unique Correct Choices"{
        ($GameSet.CorrectChoice | Select -Unique).Count | Should Be $NumChoices
    }
    $NewCHoices = @("Choice1","Balls","Sacks","filler","filler2")
    $NewGame = New-GameChoiceSet -Choices $NewChoices -Question "Test Question" -InputObject $GameSet
    write-Host "$($NewGame | Out-String)"
}

