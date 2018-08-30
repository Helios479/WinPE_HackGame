Function New-ObjectiveCodeForm {
param (
    $ObjectiveCode
)
IF (!(Get-Command ConvertTo-WPFXAML)){. $PSScriptRoot\ConvertTo-WPFXAML.ps1}

$ObjCodeFormXAML = @"
<Window x:Class="ObjectiveCodeForm.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:ObjectiveCodeForm"
        mc:Ignorable="d"
        Title="MainWindow" Height="94" Width="334" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" WindowStyle="None" FontFamily="Lucida Console" FontSize="18" Foreground="WhiteSmoke" Background="#FF323232">
    <Grid>
        <Label x:Name="label" Content="XXXX-XXXX-XXXX" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontSize="36" Foreground="WhiteSmoke"/>
        <Button x:Name="button" Content="Done - System will Shutdown" HorizontalAlignment="Left" Margin="10,61,0,0" VerticalAlignment="Top" Width="314" Background="Black" Foreground="WhiteSmoke"/>
    </Grid>
</Window>
"@
$ObjForm = ConvertTo-WPFXAML $ObjCodeFormXAML
$ObjForm.FindName("label").Content = $ObjectiveCode

$ObjForm.FindName("button").Add_Click({
    $ObjForm.Hide()
})

$ObjForm.ShowDialog() | Out-Null
}