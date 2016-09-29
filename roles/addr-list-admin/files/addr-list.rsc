/foreach i in=[/ip firewall address-list find list="admins"] do {/ip firewall address-list remove numbers=$i}
/ip firewall address-list add address=192.168.0.3 list=admins

