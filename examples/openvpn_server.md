
# Examples of openvpn server uses

## push routes

````conf
# We want to push to the clients
# - our DNS server
# - routes to the networks we know
# Make sure clients route requests to our subnets through us.

# route 10.1.1.0 255.255.255.0 10.0.0.4
#push "route 10.1.1.0 255.255.255.0"
#push "route 51.77.212.1 255.255.255.255"
#push "route 172.17.0.0 255.255.0.0"
#push "route 172.18.0.0 255.255.0.0"
#push "route 172.19.0.0 255.255.0.0"
````

## client push ip

inside the client config directory, add a file named with the client CN:

example for the ``portable`` client : 

````shell
client-configs# cat ./portable
ifconfig-push 10.0.0.25 255.255.255.0
ifconfig-ipv6-push fd1d:cc55:893:1b4c::1000/24
# allow route to the network 10.1.1.0 to pass through ``portable``
iroute 10.1.1.0 255.255.255.0
````



