function Invoke-ChoiceHandler {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]$ChoiceSet,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]$CorrectIndex,
        [Parameter(ValueFromPipelineByPropertyName)]$Question = "Please enter a choice",
        [Parameter()]$Hint = ""
    )
    $ChoiceList = ""
    $i=1
    foreach($choice in $ChoiceSet){
        $ChoiceList+= "($i) $Choice`n"
        $i+=1
    }
    #write the Hint to the screen:
    Write-Host $Hint
    #display choiceset
    Write-Host $ChoiceList

    #Loop Through host input 
    $ValidChoice = $False
    While (-not $ValidChoice){
        $ChoiceIndex = Read-Host -Prompt $Prompt
        If ($ChoiceIndex -ge 1 -and $ChoiceIndex -le $ChoiceSet.Count){
            If (($ChoiceIndex - 1) -eq $CorrectIndex){ Return $true }
            else {Return $false}
            $ValidChoice = $true
        }
        Else{
        Write-Host "Invalid choice, please choose a number from the above options"
        }
    }

}
