package main

import (
	"context"
	"flag"
	"fmt"
	"math/rand"
	"os"
	"os/signal"
	"sync"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

func main() {
	brokerAddress := flag.String("broker-address", "", "the address of the mqtt broker in format host:port")
	topic1 := flag.String("topic1", "", "the first topic to send random integer values to")
	topic1IntervalSeconds := flag.Int("topic1-interval-seconds", 3, "number of seconds to wait before sending a new value to topic1")
	topic2 := flag.String("topic2", "", "the second topic to send random integer values to")
	topic2IntervalSeconds := flag.Int("topic2-interval-seconds", 5, "number of seconds to wait before sending a new value to topic2")
	flag.Parse()

	opts := mqtt.NewClientOptions().AddBroker(*brokerAddress)
	client := mqtt.NewClient(opts)

	fmt.Printf("Connecting to MQTT broker: %s\n", *brokerAddress)

	if token := client.Connect(); token.Wait() && token.Error() != nil {
		fmt.Println("Error connecting to MQTT broker:", token.Error())
		os.Exit(1)
	}

	fmt.Printf("Connected to MQTT broker: %s\n", *brokerAddress)

	ctx, _ := signal.NotifyContext(context.Background(), os.Interrupt)
	var wg sync.WaitGroup

	// Topic 1, send each second.
	if *topic1 != "" {
		wg.Add(1)
		go func() {
			fmt.Printf("Will send a value to topic %s every %d seconds\n", *topic1, *topic1IntervalSeconds)
			defer wg.Done()
			ticker := time.NewTicker(time.Second * time.Duration(*topic1IntervalSeconds))
			defer ticker.Stop()

			for {
				select {
				case <-ticker.C:
					publish(client, *topic1, rand.Intn(400))
				case <-ctx.Done():
					fmt.Println("Stopping sending to topic1...")
					return
				}
			}
		}()
	}

	// Topic 2
	if *topic2 != "" {
		go func() {
			fmt.Printf("Will send a value to topic %s every %d seconds\n", *topic2, *topic2IntervalSeconds)
			ticker := time.NewTicker(time.Second * time.Duration(*topic2IntervalSeconds))
			defer ticker.Stop()
			for {
				select {
				case <-ticker.C:
					publish(client, *topic2, rand.Intn(800))
				case <-ctx.Done():
					fmt.Println("Stopping sending to topic2...")
					return
				}
			}
		}()
	}

	wg.Wait()
	fmt.Println("Disconnecting from the mqtt server...")
	client.Disconnect(250)
	fmt.Println("Done")
}

func publish(client mqtt.Client, topic string, value int) {
	token := client.Publish(topic, 0, false, fmt.Sprintf("%d", value))
	token.Wait()
	fmt.Printf("Published %d to %s\n", value, topic)
}
