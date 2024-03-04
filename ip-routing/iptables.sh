iptables -F

# allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT


# allow from 172.20.0.100
iptables -A FORWARD -i eth0 -s 172.20.0.100 -d 192.168.0.0/24 -j ACCEPT
iptables -A FORWARD -i eth1 -s 192.168.0.0/24 -d 172.20.0.100 -j ACCEPT


# allow SMB
iptables -A FORWARD -s 172.20.0.0/24 -d 192.168.0.0/24 -p tcp --dport 445 -j ACCEPT
iptables -A FORWARD -s 192.168.0.0/24 -d 172.20.0.0/24 -p tcp --sport 445 -j ACCEPT

#allow protocols 
iptables -A OUTPUT -o wan0 -m iprange --src-range 172.20.0.100-172.20.0.200 -p icmp -m icmp --icmp-type 0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 172.20.0.100-172.20.0.200 -p udp -m udp --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 172.20.0.100-172.20.0.200 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 172.20.0.100-172.20.0.200 -p tcp -m multiport --dports 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 172.20.0.100-172.20.0.200 -p udp --dport 123 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -o wan0 -m iprange --src-range 192.168.0.30-192.168.0.44 -p icmp -m icmp --icmp-type 0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 192.168.0.30-192.168.0.44 -p udp -m udp --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 192.168.0.30-192.168.0.44 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 192.168.0.30-192.168.0.44 -p tcp -m multiport --dports 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o wan0 -m iprange --src-range 192.168.0.30-192.168.0.44 -p udp --dport 123 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


# deny other
iptables -A FORWARD -s 172.20.0.0/24 -d 192.168.0.0/24 -j DROP
iptables -A FORWARD -s 192.168.0.0/24 -d 172.20.0.0/24 -j DROP

#route between networks 
route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.20.0.1
route add -net 172.20.0.0 netmask 255.255.255.0 gw 192.168.0.1


iptables-save 
route -n

