# Home assistant prototype

1. Install [vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
1. Install [virtual box](https://www.virtualbox.org/wiki/Downloads)
1. Create the vm using `vagrant up` (this will take some time since go will be installed in the vm as well)
1. SSH into the vm using `cd vms && vagrant ssh`
1. Bootstrap influx db and create the auth token
   - `make up-influx`
   - `make influx-initial-setup`
1. Stop the running stack using `docker compose down`
1. Run the full stack using `make up-all`
1. Configure the MQTT broker through the home assistant ui

   - Broker host: `mosquitto`
   - Broker user: `admin`
   - Broker password: `password`

1. Restart home assistant from the ui
1. Start publishing data either by:
   - `make mqtt-publish-room-temprature` OR
   - `cd ./mqtt-sample-app && make publish-data` (you have to have golang installed)
