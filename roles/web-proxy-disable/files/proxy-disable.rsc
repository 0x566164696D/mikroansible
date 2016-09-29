/ip proxy set enabled=no max-client-connections=400 max-server-connections=500
:foreach x in=[/ip firewall nat find chain=dstnat action=redirect to-ports="8080"] do={/ip firewall nat disable numbers=$x}
