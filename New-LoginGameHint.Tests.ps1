$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-EncryptionGameHint" {
   $CorrectChoice = @("Choice1","AES256","Brazil")
   $NumChars = 600
   $Method = 'ExtendedASCII'
   $Result = New-LoginGameHint -CorrectChoice $CorrectChoice -NumChars $NumChars -Method $Method
   It "Should Contain all answers"{
        foreach($choice in $CorrectChoice){
            $Result -like "*$Choice*" | Should be $true
        }
   }
   #It "Should Contain the correct number of characters"

}