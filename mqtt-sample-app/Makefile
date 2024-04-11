.PHONY:publish-data
publish-data:
	go run ./main.go --broker-address "tcp://localhost:1883" \
		-topic1 home/bedroom/temperature -topic1-interval-seconds 1 \
		-topic2 home/kitchen/temperature -topic2-interval-seconds 2 
