Add-Type -AssemblyName PresentationFramework

[XML]$form = @"
    <Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Password Generator" Height="317.01" Width="704.124" ResizeMode="NoResize">
        <Grid>
            <Label Content="Password Length" HorizontalAlignment="Left" Margin="36,31,0,0" VerticalAlignment="Top" RenderTransformOrigin="-2.568,-2.973" Height="34" Width="140" FontSize="16" FontFamily="Trebuchet MS"/>
            <TextBox Name="Plengthtxtbox" HorizontalAlignment="Left" Height="28" Margin="181,37,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="88" RenderTransformOrigin="0.503,-0.152" Background="#FFF9F9F9"/>
            <Button Name="Generatebtn" Content="Generate" HorizontalAlignment="Left" Margin="295,37,0,0" VerticalAlignment="Top" Width="140" Height="28" Background="#FF78CB87"/>
            <Label Content="New Generated Password" HorizontalAlignment="Left" Margin="36,99,0,0" VerticalAlignment="Top" Width="194" Height="37" FontSize="16"/>
            <TextBox Name="Pouttxtbx" HorizontalAlignment="Left" Height="42" Margin="251,94,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="224" Background="#FFD4D4CC" IsEnabled="False" FontSize="16"/>
            <TextBox Name="errortxtbx" HorizontalAlignment="Left" Height="28" Margin="91,168,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="344" FontSize="16" FontFamily="Verdana" Visibility="Hidden" IsEnabled="False" Foreground="Red" BorderBrush="#FFACB4CD" Background="#FFDAB1B1"/>
            <Button Name="CopyBtn" Content="Copy to Clipboard" HorizontalAlignment="Left" Margin="494,90,0,0" VerticalAlignment="Top" Width="140" Height="51" Background="#FFCDDAD5" FontSize="14" Foreground="#FFB63232"/>

        </Grid>
    </Window>

   
"@

$NR = (New-Object System.Xml.XmlNodeReader $form)
$window = [Windows.Markup.XamlReader]::Load($NR)

$inputtxt = $window.FindName("Plengthtxtbox")
$submitbtn = $window.FindName("Generatebtn")
$outputtxt = $window.FindName("Pouttxtbx")
$errorlbl = $window.FindName("errortxtbx")
$copybtn = $window.FindName("CopyBtn")

$out = ""
function Generate-Password{

    try {
        $length = [int]($inputtxt.Text)

        for ($i = 0; $i -lt $length; $i++) {
            $out += [char](Get-Random -Minimum 33 -Maximum 126)
        }
        $errorlbl.Visibility = "Hidden"
        return $out
    }
    catch {
        $errorlbl.Text = "Error Generating Password"
        $errorlbl.Visibility = "Visible"
    }
   

}

$copybtn.Add_Click({
    if(!($outputtxt.Text -eq "")){
        Set-Clipboard -Value $outputtxt.Text
        $errorlbl.Text = "Password copied to Clipboard"
        $errorlbl.Foreground = "Darkgreen"
        $errorlbl.Visibility = "Visible"
    }
})

$submitbtn.Add_Click({
    $password = Generate-Password
    $outputtxt.Text = $password
})

$window.ShowDialog()