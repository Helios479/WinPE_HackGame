function New-GameChoiceSet {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)][Array]$Choices,
        [Parameter()][int]$NumOptions = 3,
        [Parameter()][int]$NumChoices = 1,
        [Parameter()][string]$Question = "Please pick an option",
        [Parameter()][array]$InputObject = @(),
        [Parameter()][switch]$UniqueOptions
    )
    If ($UniqueOptions){
        If($Choices.Count -lt ($NumOptions * $NumChoices)){
            Throw "Not enough possible choices provided, either provide more choices or lower the number of options/choices"
        }
    }
    Else{
        If($Choices.Count -lt ($NumChoices + $NumOptions + 1)){
            Throw "Not enough possible choices provided, either provide more choices or lower the number of options/choices"
        }
    }
    $ChoiceList = New-Object System.Collections.ArrayList(,$Choices)
    $PossibleOptions = New-Object System.Collections.ArrayList

    for ($i=0; $i -lt $NumChoices; $i+=1){
        $CorrectChoice = $choiceList[(Get-Random -Minimum 0 -Maximum $ChoiceList.count)]
        $ChoiceList.Remove($CorrectChoice)
        $CorrectIndex = Get-Random -Minimum 0 -Maximum $NumOptions
        $ChoiceSet = @()


        $PossibleOptions.Clear()
        $PossibleOptions.AddRange($ChoiceList)
        for($j=0;$j -lt $NumOptions;$j+=1){
            if ($j -eq $CorrectIndex){
                $ChoiceSet+=$CorrectChoice
            }
            else{
                $Option = $PossibleOptions[(Get-Random -Minimum 0 -Maximum $PossibleOptions.count)]
                $ChoiceSet += $Option
                $PossibleOptions.Remove($Option)
                If ($UniqueOptions){$CHoiceList.Remove($Option)}
            }
        }
        $InputObject+=[PSCustomObject]@{CorrectChoice=$CorrectChoice;CorrectIndex=$CorrectIndex;ChoiceSet=$ChoiceSet;Question=$Question}
    }
    Return $InputObject
}
