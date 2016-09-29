:if ([/ip route find where dst-address=10.0.0.0/8 type=unreachable] = "") do={/ip route add disabled=no distance=254 dst-address=10.0.0.0/8 type=unreachable}
:if ([/ip route find where dst-address=192.168.0.0/16 type=unreachable] = "") do={/ip route add disabled=no distance=254 dst-address=192.168.0.0/16 type=unreachable}
