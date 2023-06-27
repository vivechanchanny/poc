sudo yum install haproxy -y
cd /etc/haproxy
sudo cp haproxy.cfg haproxy.cfg.orig
sudo wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/haproxy.cfg -O haproxy.cfg
sudo systemctl enable haproxy
sudo systemctl restart haproxy
