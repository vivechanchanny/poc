if [[ $1 == "" ]]
then
        echo "Usage $0 <example.com>"
        exit 1
fi


sudo amazon-linux-extras install epel -y
sudo yum install certbot -y

# Temporariry stop haproxy
sudo systemctl stop haproxy

sudo certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d $1 -d www.$1

sudo ls /etc/letsencrypt/live/$1
sudo mkdir -p /etc/haproxy/certs

# create the combined file 
DOMAIN="$1" && sudo -E bash -c "cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem"

#Secure access to the combined file, which contains the private key, with this command:
sudo chmod -R go-rwx /etc/haproxy/certs

sudo -E bash -c "[ ! -f /etc/haproxy/certs/yourdomain.pem ] && { ln -s /etc/haproxy/certs/$1.pem /etc/haproxy/certs/yourdomain.pem;  }"


cd /etc/haproxy
sudo rm -f haproxy-tls.cfg
sudo wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/haproxy-tls.cfg -O haproxy-tls.cfg
sudo cp -f haproxy-tls.cfg haproxy.cfg
