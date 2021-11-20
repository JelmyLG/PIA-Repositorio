Write-host Menu
Write-host ====
Write-host  "1) Escaneo de toda la subred"
Write-host  "2) Escaneo de un puerto"
Write-host  "3) Escaneo de puertos para todos los equipos"
Write-host  "4) Salir"

$opcion = Read-Host
$rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)

switch($opcion)

{
	1 {
        $subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
        Write-Host "Tu gateway: $subred"
        $responde = Test-Connection $subred -Quiet  -Count 1
        write-host "Conexion: "$responde
        break
      }

	2 {
       Write-Host "Puerto a escanear: "
       $puerto = Read-Host
       Test-NetConnection -ComputerName ny-msg01 -Port $puerto
       break
      }
	3 {
        $subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
        Write-Host "$subred"
        $rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
        $punto = $rango.EndsWith('.')
        if ( $punto -like "False" )
        {
            $rango = $rango +  '.'
        }
        $portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
        $waittime = 100
        Write-Host "Dirección ip a escanear:" -NoNewline
        $direccion = Read-Host
        foreach ( $p in $portstoscan )
        {
	        $TCPObject = new-object System.Net.Sockets.TcpClient
		    try{ $resultado = $TCPObject.ConnectAsync($direccion,$p).Wait($waittime)}catch{}
		    if ( $resultado -eq "True")
		    {
			    Write-Host "Puerto abierto: " -NoNewline; Write-Host $p -ForegroundColor Green
		    }
        }
        break
      }
	4 {date;

       break
      }
	default {break}
}
