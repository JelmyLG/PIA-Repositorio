
echo "--- Menu ---"
echo "1) Detectar equipos activos en la red"
echo "2) Detectar puertos abiertos"
echo "3) Informacion"
echo "4) exit"
while true; do
    read -p "Seleccione una opción: " op
    case $op in
        [1]* )
          which ifconfig && {echo "Comando ifconfig existe..";
                             ipdi = “ifconfig |grep inet |grep -v "127.0.0.1" |awk "{ print $2}" ”;
                             echo "Direccion IP: "$ipdi;
                             subred = “ifconfig |grep inet |grep -v "127.0.0.1" |awk"{print $2}" |awk -F. "{print $1"."$2"."$3"."}"”;
                             echo "Red: "$subred;
                             }\
                             {echo "No existe el comando ifconfig.. uando ip";
                             ipdi = “ip addr show |grep inet |grep -v "127.0.0.1" |awk "{ print $2}" ”;
                             echo "Direccion IP: "$ipdi;
                             subred = “ip addr show |grep inet |grep -v "127.0.0.1" |awk"{print $2}" |awk -F. "{print $1"."$2"."$3"."}"”;
                             echo "Direccion IP: "$ipdi;
                             }
          for ip in {1..254}
          do
            ping -q -c 4 ${subred}${ip} > /dev/null
            if  [ $? -eq 0]
            then
              echo "Host responde: " ${subred}${ip}
            fi
          break;;

        [2]* )
          ip = $1
          puertos = "20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,162,389,443,445,636,1025,1443,3389,5985,5985";
          [ $# -eq 0] && {echo "Modo: $0 <direccion ip>"; exit 1;}
          IFS  = ,
          for port in $puertos
          do
            timeout 1 bash -c "echo > /dev/tcp/$ip/$port > /dev/null 2>$1" &&\
            echo $ip": "$port" OPEN"\
            ||\
            echo $ip": "$port" CLOSED"
          break;;

        [3]* )
        echo "Username: "${LOGNAME};
        echo "Hostname: "${HOSTNAME};
        platform='unknown'
        unamestr=`uname`
        if [[ "$unamestr" == 'Linux' ]]; then
          platform='linux'
          echo "Sistema operativo: "$platform;
        elif [[ "$unamestr" == 'FreeBSD' ]]; then
          platform='freebsd'
          echo "Sistema operativo: "$platform;
        fi
        echo "Fecha: "`date +"%d/%m/%Y"`
        break;;
        [4]* )
        break;;
        * ) echo "¡Seleccione una Opción!";;
    esac
done
