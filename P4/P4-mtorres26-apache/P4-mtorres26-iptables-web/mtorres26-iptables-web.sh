# Denegación implícita de todo el tráfico
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Aceptar paquetes que pertenezcan a una conexión existente o relacionada
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir conexiones nuevas o ya establecidas al tráfico saliente 
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Permitir conexiones loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir el tráfico HTTP y HTTPS
iptables -A INPUT -p tcp -s 192.168.10.50 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.10.50 --dport 443 -j ACCEPT
