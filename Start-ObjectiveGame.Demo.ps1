#Load Functions
. $PSScriptRoot\ConvertTo-WPFXAML.ps1

#Load Objective Info
. $PSScriptRoot\SiteInfo.Demo.ps1
#region DemoScreen
$DemoInputXML = @"
<Window x:Class="WpfApplication3.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication3"
        mc:Ignorable="d"
        Title="Demo"
        Height="768"
        Width="1024"
        FontFamily="Consolas"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        WindowStyle="None"
        Background="Black">
    <Grid>
        <Label x:Name="labelDemoHeader" Content="DEMO HEADER" HorizontalAlignment="Center" Margin="0,20,0,0" VerticalAlignment="Top" HorizontalContentAlignment="Center" Foreground="DodgerBlue" Height="41" Width="1024" FontSize="24"/>
        <Label x:Name="labelDemoFooter" Content="DEMO FOOTER" HorizontalAlignment="Center" Margin="0,707,0,0" VerticalAlignment="Top" HorizontalContentAlignment="Center" Foreground="DodgerBlue" Height="41" Width="1024" FontSize="24"/>
    </Grid>
</Window>
"@
$DemoForm = ConvertTo-WPFXAML $DemoInputXML
$DemoForm.FindName("labelDemoHeader").Content = "LOGIN PHASE"
$DemoForm.FindName("labelDemoFooter").Content = "Use password or start the Omega Protocol in the lower right of the screen"
$DemoForm.Show() | Out-Null
#endregion

#region LoginScreen
$LoginStatus = $false
$LoginInputXML = @"
<Window x:Class="WpfApplication3.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication3"
        mc:Ignorable="d"
        Title="Login"
        Height="576"
        Width="1024"
        FontFamily="Consolas"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        WindowStyle="None">
    <Grid>
        <Image x:Name="imageBackground" HorizontalAlignment="Left" Height="576" Margin="0,0,0,0" VerticalAlignment="Top" Width="1024" Source="X:\Images\AbstergoBackground.png"/>
        <Label x:Name="labelSDSite" Content="Sierra Dynamics SatComm THX-1138" Foreground="White" HorizontalAlignment="Left" HorizontalContentAlignment="Center" Margin="331,143,0,0" VerticalAlignment="Top" FontSize="20"/>
        <TextBox x:Name="textBoxUsername" HorizontalAlignment="Left" Height="23" Margin="452,416,0,0" TextWrapping="Wrap" Text="admin" VerticalAlignment="Top" Width="120"/>
        <TextBox x:Name="textBoxPassword" HorizontalAlignment="Left" Height="23" Margin="452,444,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="120"/>
        <Button x:Name="buttonHack" Content="Ω" HorizontalAlignment="Left" Margin="980,526,0,0" VerticalAlignment="Top" Width="20" BorderBrush="DarkRed" Background="Black" Height="20" FontWeight="Bold" FontSize="13" FontFamily="Courier New" Foreground="DarkRed" BorderThickness="1,1,2,2" Cursor="Hand" ToolTip="Start hacking password"/>
        <Button x:Name="buttonLogin" Content="Login" HorizontalAlignment="Left" Margin="452,472,0,0" VerticalAlignment="Top" Width="120" BorderBrush="White" Background="#FF646464" Foreground="White"/>
        <Label x:Name="labelLoginStatus" Content="" HorizontalAlignment="Center" Margin="399,500,403,35" VerticalAlignment="Center" HorizontalContentAlignment="Center" Foreground="OrangeRed" Height="41" Width="226" FontSize="24"/>
        <Image x:Name="imageLogo" HorizontalAlignment="Left" Height="120" Margin="452,228,0,0" VerticalAlignment="Top" Width="120" Source="X:\Images\SD_Logo.png"/>
    </Grid>
</Window>
"@
$LoginForm = ConvertTo-WPFXAML $LoginInputXML
$LoginForm.FindName("imageBackground").Source = "$PSScriptRoot\Images\CarbonBackground.png"
$LoginForm.FindName("labelSDSite").Content = "Sierra Dynamics " + $SiteType + " " +$SiteName
Switch ($SiteName) {
    default {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\SD_Logo.png"}
    Hydra {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Hydra.png"}
    Arrow {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Arrow.png"}
    Flame {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Flame.png"}
    Orchid {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Orchid.png"}
    Tempest {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Tempest.png"}
    Swan {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Swan.png"}
    Pearl {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Pearl.png"}
    Staff {$LoginForm.FindName("imageLogo").Source = "$PSScriptRoot\Images\Staff.png"}
}

# Login Password
$LoginForm.FindName("buttonLogin").Add_Click({
    IF ($LoginForm.FindName("textBoxPassword").Text -eq $SitePassword) {
        $LoginForm.Close()
    }
    ELSE {
        $LoginForm.FindName("labelLoginStatus").Content = "Login FAILED"
    }
})

# Hack Button
$LoginForm.FindName("buttonHack").Add_Click({
    $HackAttempt = . $PSScriptRoot\New-HackScreen.Demo.ps1
    If ($HackAttempt -eq $true) {$LoginForm.Hide()}
}) 

# Show Login
$LoginForm.ShowDialog() | out-null
#endregion

. $PSScriptRoot\New-ObjectiveScreen.Demo.ps1