# Instalando Iptables Persistant
apt install iptables-persistent -y

# Limpar Regras
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z

# Definir políticas padrão
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfego no loopback (localhost)
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexões já estabelecidas e relacionadas
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Permitir acesso à VPN na porta 1194 (UDP)
iptables -A INPUT -p udp --dport 1194 -j ACCEPT

# Permitir tráfego APENAS da VPN (172.17.0.0/16) para serviços específicos
iptables -A INPUT -p tcp --dport 80 -s 172.17.0.0/16 -j ACCEPT  # HTTP
iptables -A INPUT -p tcp --dport 443 -s 172.17.0.0/16 -j ACCEPT  # HTTPS
iptables -A INPUT -p tcp --dport 24849 -s 172.17.0.0/16 -j ACCEPT  # SSH

# Bloquear qualquer outra tentativa de SSH fora da VPN
iptables -A INPUT -p tcp --dport 24849 -j DROP

# Salvar regras para persistência após reboot
netfilter-persistent save
netfilter-persistent reload