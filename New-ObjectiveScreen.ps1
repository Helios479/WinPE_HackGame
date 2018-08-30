#Import Functions
. $PSScriptRoot\ConvertTo-WPFXAML.ps1
. $PSScriptRoot\New-CommandCodeForm.ps1
. $PSScriptRoot\New-ProgressBarForm.ps1
. $PSScriptRoot\New-ObjectiveCodeForm.ps1

#Import Codes
. $PSScriptRoot\SiteCodes.ps1
IF (!($SiteType)) {. $PSScriptRoot\SiteInfo.ps1}

$ObjectiveScreenXAML =@"
<Window x:Class="SatCommForm.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:SatCommForm"
        mc:Ignorable="d"
        Title="MainWindow" Height="576" Width="1024" WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="NoResize">
    <Grid>
        <Image x:Name="imageBackground" HorizontalAlignment="Left" Height="576" Margin="0,0,0,0" VerticalAlignment="Top" Width="1024" Source="C:\Users\del001\Documents\WindowsPowerShell\WinPE_AMS\Images\SD_Login.png"/>
    </Grid>
</Window>
"@

$ObjectiveScreen = ConvertTo-WPFXAML $ObjectiveScreenXAML

Switch ($SiteType) {
SatComm {$ObjectiveScreen.FindName("imageBackground").Source = "$PSScriptRoot\Images\SatCommBackground.png"}
FileServ {$ObjectiveScreen.FindName("imageBackground").Source = "$PSScriptRoot\Images\FileServBackgroud.png"}
}
$ObjectiveScreen.Show() | Out-Null

$ObjectiveCode = New-CommandCodeForm
$FinalCode = $SiteCode + "-" + $ObjectiveCode
Switch ($SiteType) {
SatComm {New-ProgressBarForm -TotalTime $ObjectiveTimer -Action "Processing Crypto Key..."}
FileServ {New-ProgressBarForm -TotalTime $ObjectiveTimer -Action "Decrypting File Structure..."}
}

New-ObjectiveCodeForm $FinalCode

$ObjectiveScreen.Hide()