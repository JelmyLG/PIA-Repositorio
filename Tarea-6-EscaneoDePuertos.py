import nmap 
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--ip", help="IP")
parser = parser.parser_args()

if __name__ =="__main__":
    nm = nmap.PortScanner()
    ip = parser.ip 
    nm.scan(ip, "1-1000")

    for host in nm.all_hosts():
        print('Host : %s (%s)' % (host,nm[host].hostname()))
        print('State : %s' % nm[host].state())
        for proto in nm[host].all_protocols():
            print('protocol : %s' % proto )
            lport = nm[host][proto].keys() 
            for port in lport:                                                                  # Asignar lport a puerto y atravesar
                print('port : %s\tstate : %s' % (port,nm[host][proto][port]['state']))
