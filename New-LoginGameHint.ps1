function New-LoginGameHint {
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Array]$CorrectChoice,
        [Parameter()][int]$NumLines = 1,
        [Parameter()][int]$NumChars = 155,
        [Parameter()][ValidateSet("Unicode","Characters","ASCII","ExtendedASCII")][string]$Method = "Characters",
        [Parameter()][ValidateSet('!','@','#','$','%','^','&','*',',','.','+','=','|')][string]$Marker
    )

    $CharacterCount = 0
    $Hints = @()
    #Create Hint Marker is none is specified
    IF (!($Marker)) {
        $HintMarkers = @('!','@','#','$','%','^','&','*',',','.','+','=','|')
        $Marker = $HintMarkers[(Get-Random -Minimum 0 -Maximum $HintMarkers.Count)]}
    #Determines character count of the information ($CorrectChoice) plus 2 random demarkers
    #Also Adds those characters to the front and back of the choice
    foreach($Choice in $CorrectChoice){
        $Hint = "$($Marker)$($Choice)$($Marker)"
        $CharacterCount += $Hint.Length
        $Hints+=$Hint
    }
        #Determine how many characters of noise we need.
        $NoiseChars = ($NumLines * $NumChars) - $CharacterCount
    #generate random Unicode characters to fill,
    switch ($Method){
        "Unicode"{
            #set Encoding size appropraitely, UTF-8 = 8 , UFT-16 = 16 etc
            $CharacterEncodingSize = 8
            $NoiseSize = $CharacterCount * $CharacterEncodingSize
            $NoiseBytes = New-Object Byte[] $NoiseSize
            (New-Object Random).NextBytes($NoiseBytes)
            $Noise = [System.Text.Encoding]::UTF8.GetString($NoiseBytes) -replace "`n","$([Char](Get-Random -Minimum 0 -Maximum 255))"
        }
        "Characters"{
            $Noise = ""
            for($i=0;$i -lt $NoiseChars;$i+=1){
                $Noise+=[char](Get-Random -Minimum 32 -Maximum 126)
            }
        }
        "ASCII"{
            $Noise = ""
            for($i=0;$i -lt $NoiseChars;$i+=1){
                $Noise+=[char](Get-Random -Minimum 32 -Maximum 254)
            }
            $Noise = $Noise.Replace("$([char]133)","")
        }
        "ExtendedASCII"{
            $Noise = ""
            for($i=0;$i -lt $NoiseChars;$i+=1){
                $Noise+=[char](Get-Random -Minimum 32 -Maximum 500)
            }
            $Noise = $Noise.Replace("$([char]133)","")
        }
    }
    #Distribute the hints into the noise, spreading them out into their own chunks to avoid collision and Crowding
    $sectionsize = [int](($Noise.Length)/($Hints.Count + 1))
    $spacingsize = [int]($sectionsize/($Hints.Count + 1))
    #extrapadding from inserting words
    $padding = 0
    #index variable for determining sections
    $i=1
    foreach ($Hint in ($Hints | Sort-Object {Get-Random})){
        $sectionstart = ($i * $spacingsize)+ (($i-1) * $sectionsize) + $padding
        $sectionend = ($i * ($spacingsize + $sectionsize)) + $padding
        $insertPoint = Get-Random -Minimum $sectionstart -Maximum $sectionend
        #insert the hint at the randomly generated point
        Write-Verbose $Hint
        $Noise = $Noise.Insert($insertPoint,$Hint)
        $padding+=$Hint.Length
        $i+=1
    }
    $Noise
}
