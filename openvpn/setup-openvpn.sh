# IP=<IP> PORT=<PORT>/bin/bash -c "$(curl -fsSL https://bit.ly/install-openvpn-sh-feuser)"
# Example: IP=142.250.188.228 PORT=1194 /bin/bash -c "$(curl -fsSL https://bit.ly/install-openvpn-sh-feuser)"

IP=${1:-$IP}
PORT=${2:-$PORT}
export OVPN_DATA="ovpn-data-feuser"
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$IP
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p $PORT:$PORT/udp --cap-add=NET_ADMIN kylemanna/openvpn
