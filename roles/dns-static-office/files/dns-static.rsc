/foreach i in=[/ip dns static find] do={/ip dns static remove numbers=$i}
/ip dns static add address=192.168.0.11 name=example
/ip dns static add address=192.168.0.11 name=example.com
