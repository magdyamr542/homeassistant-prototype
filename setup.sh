# This script sets up the vm
# It installs:
# 1. Make
# 2. The Influx CLI (to interact with the db)
# 3. Golang version 1.20 using the gvm 'go version manager'
mkdir -p /tmp/setup

cd /tmp/setup

# install make
sudo apt install make

# install influx cli
wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.3-linux-amd64.tar.gz
tar zxvf influxdb2-client-2.7.3-linux-amd64.tar.gz
sudo mv influx /usr/bin/influx

# install golang version 1.20 using the go version manager gvm
sudo apt-get install -y curl git mercurial make binutils bison gcc build-essential
sudo -u vagrant -H bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

source /home/vagrant/.gvm/scripts/gvm

gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.17.13
gvm use go1.17.13
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.20
gvm use go1.20 --default

# clone the repository
git clone https://github.com/magdyamr542/homeassistant-prototype.git /home/vagrant/homeassistant-prototype

cd ~/

rm -rf /tmp/setup
