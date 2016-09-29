/ip dhcp-server option add code=157 name=UVCProvisioning value="'LifeSize: server=http://192.168.0.19/ac/\?mac=#M&ip=#I&type=#S'"
/ip dhcp-server option add code=119 name=DomainToSearch value="'example.local'"
:delay 1
/foreach i in=[/ip dhcp-server network find] do {/ip dhcp-server network set dhcp-option=UVCProvisioning,DomainToSearch numbers=$i}
