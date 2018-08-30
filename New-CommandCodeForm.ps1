function New-CommandCodeForm {
IF (!(Get-Command ConvertTo-WPFXAML)){. $PSScriptRoot\ConvertTo-WPFXAML.ps1}
IF (!($SiteCodes)){. $PSScriptRoot\SiteCodes.ps1}

$CmdCodeFormXAML = @"
<Window x:Class="CommandCodeForm.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:CommandCodeForm"
        mc:Ignorable="d"
        Title="CommandCodeForm" Height="110" Width="260 " WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="NoResize" FontFamily="Lucida Console" Foreground="White" Background="#FF323232" FontSize="20">
    <Grid>
        <Label x:Name="label" Content="Enter Command Code:" HorizontalAlignment="Left" HorizontalContentAlignment="Center" Margin="10,10,0,0" VerticalAlignment="Top" Width="235" Foreground="WhiteSmoke"/>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" HorizontalContentAlignment="Center" Height="23" Margin="10,41,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="235"/>
        <Button x:Name="button" Content="Submit Code" HorizontalAlignment="Left" Margin="10,69,0,0" VerticalAlignment="Top" Width="235" Background="Black" Foreground="WhiteSmoke"/>
    </Grid>
</Window>
"@
$CodeForm = ConvertTo-WPFXAML $CmdCodeFormXAML

$CodeForm.FindName("button").Add_Click({
    $EnteredCode = $CodeForm.FindName("textBox").Text
    $Global:ObjectiveCode = $SiteCodes[$EnteredCode]
    IF ($ObjectiveCode -ne $null) {$CodeForm.Hide()}
})

$CodeForm.ShowDialog() | Out-Null
Return $Global:ObjectiveCode
}