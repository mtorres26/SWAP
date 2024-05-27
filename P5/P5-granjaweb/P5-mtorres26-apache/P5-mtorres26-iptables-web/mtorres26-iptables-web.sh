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


# Limitar tasa de nuevas conexiones por IP (ventana deslizante)
iptables -N limit_conn  # Crear una cadena para la limitación
iptables -A INPUT -m state --state NEW -j limit_conn  # Marcar nuevas conexiones
iptables -A limit_conn -m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-mode count/s --connlimit-unit 1 -j ACCEPT
iptables -A limit_conn -j DROP  # Bloquear después de superar el límite

# Bloquear paquetes nuevos que no sean SYN ni pertenezcan a una conexión existente
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

# Bloquear valores anormales de MSS
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

# Bloquear tráfico por cantidad de conexiones
iptables -A INPUT -p tcp -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset