function New-ProgressBarForm {
param (
    [int]$TotalTime = 10,
    [int]$TimeIncriment = 1,
    [string]$Action = "Working on it..."
)
IF (!(Get-Command ConvertTo-WPFXAML)){. $PSScriptRoot\ConvertTo-WPFXAML.ps1}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$ProgressBarFormXAML = @"
<Window x:Class="ProgressBarForm.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:ProgressBarForm"
        mc:Ignorable="d"
        Title="MainWindow" Height="92" Width="420" HorizontalAlignment="Center" WindowStyle="None" ResizeMode="NoResize" FontFamily="Lucida Console" Background="#FF323232" Foreground="WhiteSmoke">
    <Grid>
        <Label x:Name="labelAction" Content="Action" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Foreground="WhiteSmoke"/>
        <ProgressBar x:Name="progressBar" HorizontalAlignment="Left" Height="22" Margin="10,37,0,0" VerticalAlignment="Top" Width="400" Value="0" Background="Black" BorderBrush="WhiteSmoke" Foreground="DodgerBlue"/>
        <Label x:Name="labelPercentComplete" Content="XXX%" HorizontalAlignment="Center" Margin="0,37,0,0" VerticalAlignment="Top" Foreground="WhiteSmoke"/>
        <Label x:Name="labelTimeRemaining" Content="Time Remainging : xxmxxs" HorizontalAlignment="Left" Margin="10,64,0,0" VerticalAlignment="Top" Foreground="AliceBlue"/>
    </Grid>
</Window>
"@
$BarForm = ConvertTo-WPFXAML $ProgressBarFormXAML
$BarForm.FindName("labelAction").Content = $Action
$BarForm.Show()
$Timeout = New-Timespan -Seconds $TotalTime
$StopWatch = [diagnostics.stopwatch]::StartNew()

While ($StopWatch.elapsed -lt $Timeout) {
        [int]$Elapsed = $StopWatch.ElapsedMilliseconds
        $PercentComplete = ($Elapsed / $Timeout.TotalMilliseconds) * 100
        $BarForm.FindName("progressBar").Value = $PercentComplete
        $PercentSimple = "{0:N0}" -f $PercentComplete
        $BarForm.FindName("labelPercentComplete").Content = $PercentSimple
        $TimeRemaining = $Timeout - $StopWatch.elapsed
        $BarForm.FindName("labelTimeRemaining").Content = "Time Remaining: " + $TimeRemaining.Minutes + "m " + $TimeRemaining.Seconds + "s"
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Seconds $TimeIncriment
}
    $BarForm.Hide()
}