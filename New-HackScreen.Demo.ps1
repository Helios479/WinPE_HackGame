IF (!($HackTimePenalty)) {. $PSScriptRoot\SiteInfo.ps1}
IF (!(Get-Command ConvertTo-WPFXAML -ErrorAction SilentlyContinue)) {. $PSScriptRoot\ConvertTo-WPFXAML}
IF (!(Get-Command New-GameChoiceSet -ErrorAction SilentlyContinue)) {. $PSScriptRoot\New-GameChoiceSet.ps1}
IF (!(Get-Command New-LoginGameHint -ErrorAction SilentlyContinue)) {. $PSScriptRoot\New-LoginGameHint.ps1}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$DemoForm.FindName("labelDemoHeader").Content = "HACK PHASE"
$DemoForm.FindName("labelDemoFooter").Content = "Find the option from the Hack Console hidden in the Intercepted Hash"

$HackInfoXAML = @"
<Window x:Class="HackForm.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:HackForm"
        mc:Ignorable="d"
        Title="Hack Console" Height="200" Width="150" WindowStyle="None" FontFamily="Lucida Console" Left="800" Top="200">
    <Grid>
        <ProgressBar x:Name="ProgressBar" HorizontalAlignment="Left" Height="10" Margin="10,10,0,0" VerticalAlignment="Top" Width="120"/>
        <Button x:Name="button" Content="Submit" HorizontalAlignment="Left" Margin="10,138,0,0" VerticalAlignment="Top" Width="120"/>
        <RadioButton x:Name="radioButton0" Content="" HorizontalAlignment="Left" Margin="9,58,0,0" VerticalAlignment="Top"/>
        <RadioButton x:Name="radioButton1" Content="" HorizontalAlignment="Left" Margin="9,78,0,0" VerticalAlignment="Top"/>
        <RadioButton x:Name="radioButton2" Content="" HorizontalAlignment="Left" Margin="9,98,0,0" VerticalAlignment="Top"/>
        <RadioButton x:Name="radioButton3" Content="" HorizontalAlignment="Left" Margin="9,119,0,0" VerticalAlignment="Top"/>
        <Label x:Name="label" Content="" HorizontalAlignment="Left" HorizontalContentAlignment="Center" Margin="10,159,0,0" VerticalAlignment="Top" Width="120"/>
        <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Margin="10,25,0,0" TextWrapping="Wrap" Text="Question Block" VerticalAlignment="Top" RenderTransformOrigin="-0.083,0.071" Width="120" Height="28"/>
    </Grid>
</Window>
"@

$HackDisplayXAML = @"
<Window x:Class="HackDisplay.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:HackDisplay"
        mc:Ignorable="d"
        Title="Intercepted Hash" Height="350" Width="525" Background="Black" Foreground="LimeGreen" FontFamily="Consolas" FontSize="16">
    <Grid>
        <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Margin="10,10,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" Height="300" Width="496"/>
    </Grid>
</Window>
"@

$HackInfoForm = ConvertTo-WPFXAML $HackInfoXAML
$HackDisplay = ConvertTo-WPFXAML $HackDisplayXAML

#Generate Choices
#Encryption
$GameChoiceArray = New-GameChoiceSet -Choices @("3DES","AES","ARIA","Blowfish","Camellia","CAST","CLEFIA","CMAC",`
    "DES","GOST 28147","IDEA","Mars","MISTY1","Rabbit","Rijndael","SEED","SKIPJACK","SOBER","Twofish") `
    -NumOptions 4 -NumChoices 1 -Question "Encryption`nProtocol"
#Authentication
$GameChoiceArray = New-GameChoiceSet -Choices @("EAP-TLS","EAP-GTC","MSCHAPv2","PEAP","PEAP-TLS","EAP-SIM",`
    "EAP-AKA","EAP-FAST") -NumOptions 4 -NumChoices 1 -Question "Authentication`nProtocol" -InputObject $GameChoiceArray
#Country
$GameChoiceArray += New-GameChoiceSet -Choices @("China","Turkey","Russia","Taiwan","Brazil","Romania","India",`
    "Italy","Hungary") -NumOptions 4 -NumChoices 1 -Question "Destination`nCountry"
#Gateway
$GameChoiceArray += New-GameChoiceSet -Choices @("192.168.0.1","8.8.8.8","128.105.39.11","127.0.0.1","169.254.254.255",`
    "130.184.16.54","31.13.66.36","151.101.1.140","105.25.45.103","208.90.107.118","207.200.74.38") -NumOptions 4 `
    -NumChoices 1 -Question "Default`nGateway"

#Populate HackDisplay
$Hint = New-LoginGameHint -CorrectChoice $GameChoiceArray.CorrectChoice -NumChars 700 -Method Characters -Marker '|'
$HackDisplay.FindName("textBlock").Text = $Hint

#Show forms
$HackDisplay.Show() | Out-Null ; $HackDisplay.Activate()
$HackInfoForm.Show() | Out-Null ; $HackInfoForm.Activate()

$TimePenalty = New-Timespan -Seconds $HackTimePenalty
    $HackInfoForm.FindName("button").Add_Click({ 
        If ($HackInfoForm.FindName("$CorrectButton").IsChecked -eq $true) {   
            [int]$ProgressValue = $HackInfoForm.FindName("ProgressBar").Value
            $AddValue = $ProgressValue + ((1 / $GameChoiceArray.Count) * 100)
            $HackInfoForm.FindName("ProgressBar").Value = $AddValue
            Break
            }
        Else {
            #Disable Controls
            $HackInfoForm.FindName("button").IsEnabled = $false
            $HackInfoForm.FindName("radioButton0").IsEnabled = $false
            $HackInfoForm.FindName("radioButton1").IsEnabled = $false
            $HackInfoForm.FindName("radioButton2").IsEnabled = $false
            $HackInfoForm.FindName("radioButton3").IsEnabled = $false
            $HackInfoForm.FindName("label").Content = "INCORRECT"
            $HackInfoForm.FindName("label").Background = "Firebrick"
            [System.Windows.Forms.Application]::DoEvents()
            #Time Penalty
            $HackWatch = [diagnostics.stopwatch]::StartNew()
            Do {
                [System.Windows.Forms.Application]::DoEvents()
                Write-Host $HackWatch.elapsed.Seconds
                $PenaltyRemaining = $TimePenalty - $HackWatch.elapsed
                [string]$PenaltyDisplay = $PenaltyRemaining.Seconds
                $HackInfoForm.FindName("textBlock").Text = $PenaltyDisplay + ' Second Penalty'
                Start-Sleep -Milliseconds 500
            }
            Until ($HackWatch.elapsed -gt $TimePenalty)
            #Enable Controls
            $HackInfoForm.FindName("button").IsEnabled = $true
            $HackInfoForm.FindName("radioButton0").IsEnabled = $true
            $HackInfoForm.FindName("radioButton1").IsEnabled = $true
            $HackInfoForm.FindName("radioButton2").IsEnabled = $true
            $HackInfoForm.FindName("radioButton3").IsEnabled = $true
            $HackInfoForm.FindName("textBlock").Text = $Round.Question
            $HackInfoForm.FindName("label").Content = ""
            $HackInfoForm.FindName("label").Background = "Transparent"
            }
        })

ForEach ($Round in $GameChoiceArray) {
    $HackInfoForm.FindName("radioButton0").Content = $Round.ChoiceSet[0]
    $HackInfoForm.FindName("radioButton1").Content = $Round.ChoiceSet[1]
    $HackInfoForm.FindName("radioButton2").Content = $Round.ChoiceSet[2]
    $HackInfoForm.FindName("radioButton3").Content = $Round.ChoiceSet[3]
    $HackInfoForm.FindName("textBlock").Text = $Round.Question
    $HackInfoForm.FindName("label").Content = ""        
    $CorrectButton = 'radioButton' + $Round.CorrectIndex
While (1) {
[System.Windows.Forms.Application]::DoEvents()
}
}

#Close Forms
$HackInfoForm.Close() | Out-Null
$HackDisplay.Close() | Out-Null

#Return Completed
return $true