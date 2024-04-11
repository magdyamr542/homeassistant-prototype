TEMPRATURE ?= $(shell bash -c 'read -p "Enter a temprature: " temprature; echo $$temprature')

.PHONY: check-homeassistant-config
check-homeassistant-config:
	docker compose exec homeassistant python -m homeassistant --script check_config --config /config


.PHONY: list-homeassistant-loaded-files
list-homeassistant-loaded-files:
	docker compose exec homeassistant python -m homeassistant --script check_config --files --config /config


.PHONY: restart-homeassistant
restart-homeassistant:
	docker compose restart homeassistant

.PHONY: mqtt-publish-room-temprature
mqtt-publish-room-temprature:
	docker exec -it mosquitto mosquitto_pub -h localhost -t "home/bedroom/temperature" -m $(TEMPRATURE) 

.PHONY: up-influx
up-influx:
	docker compose --profile influx up --build 

.PHONY: up-homeassistant
up-homeassistant:
	docker compose --profile homeassistant up --build 

.PHONY: up-all
up-all:
	docker compose --profile homeassistant --profile influx up --build 

.PHONY:influx-initial-setup
influx-initial-setup:
	influx setup \
	--username admin \
	--password password \
	--token lIm2WGTw9wnTINJqrmjur3X9TFtDZcXO7sI86rlHOpUoW2PY-JFGqoqg8wICuXAsk2rTRH2fypoExbv0tuqSNQ== \
	--org gems \
	--bucket homeassistant \
	--force
