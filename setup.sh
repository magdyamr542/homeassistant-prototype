mkdir -p /tmp/setup

cd /tmp/setup

# install make
sudo apt install make

# install influx cli
wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.3-linux-amd64.tar.gz
tar zxvf influxdb2-client-2.7.3-linux-amd64.tar.gz
sudo mv influx /usr/bin/influx

# clone the repository
git clone https://github.com/magdyamr542/homeassistant-prototype.git /home/vagrant/homeassistant-prototype

cd ~/

rm -rf /tmp/setup
