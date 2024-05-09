#!/bin/bash
# Ejecuta el script de iptables
./mtorres26-iptables-web.sh
# Luego, ejecuta el comando principal del contenedor
exec "$@"
