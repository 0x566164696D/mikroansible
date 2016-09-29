:do {/system script remove WanCheck} on-error={}
/system script
add name=WanCheck source="{\r\
    \n:local emailTo \"user@example.com\"\r\
    \n:local ExpectedWanIfaceName \"WAN\"\r\
    \n:global wanIfaceName [:toarray \"\"]\r\
    \n:local inputFWrulePresent 0\r\
    \n:local WhereRuleNotSet\r\
    \n:global routerIP [:toarray \"\"]\r\
    \n:local EmailBody\r\
    \n:local EmaiSubject\r\
    \n:local LocalInterfaceName \"bridge-local\"\r\
    \n:local NATCommentToFilter \"to-Tcore-From3G-Only\"\r\
    \n#function to check array\r\
    \n:global IsInArray do={\r\
    \n:local PresentInArray false;\r\
    \n:foreach a in=\$2 do={:if (\$a=\$1) do={:set PresentInArray true}};\r\
    \n:return \$PresentInArray};\r\
    \n#get src-nat iface name\r\
    \n#:put [/ip firewall nat find chain=srcnat comment!=\"\$NATCommentToFilte\
    r\"]\r\
    \n:foreach x in=[/ip firewall nat find chain=srcnat comment!=\"\$NATCommen\
    tToFilter\"] do={\r\
    \nif ( [\$IsInArray [/ip firewall nat get number=\$x out-interface] \$wanI\
    faceName] = false) do={\r\
    \n:set wanIfaceName (\$wanIfaceName, [/ip firewall nat get number=\$x out-\
    interface])} }\r\
    \n#get dhcp-iface name\r\
    \n:foreach dhcpiface in=[/ip dhcp-client find disabled=no] do={\r\
    \n:if ([ \$IsInArray [/ip dhcp-client get number=\$dhcpiface interface] \$\
    wanIfaceName ] = false ) do={\r\
    \n:set wanIfaceName ( \$wanIfaceName, [/ip dhcp-client get number=\$dhcpif\
    ace interface])} } \r\
    \n#get iface whete name is WAN\r\
    \nforeach ifname in=[/interface find where name~\"\$ExpectedWanIfaceName\"\
    ] do={\r\
    \n:if ( [\$IsInArray [/interface get number=\$ifname name] \$wanIfaceName]\
    \_= false ) do={\r\
    \n:set wanIfaceName (\$wanIfaceName, [/interface get number=\$ifname name]\
    )} }\r\
    \n#Check firewall input\\forward chains for drop rules\r\
    \nforeach iface in=\$wanIfaceName do={\r\
    \n:if ([/ip firewall filter find chain=input action=drop disabled=no in-in\
    terface=\$iface] = \"\") do={\r\
    \n:set inputFWrulePresent (\$inputFWrulePresent + 1)\r\
    \n:if ( [\$IsInArray (\" input: \" . \$iface) \$WhereRuleNotSet] = false) \
    do={\r\
    \n:set WhereRuleNotSet (\$WhereRuleNotSet, (\" input: \" . \$iface ))} }\r\
    \n#\r\
    \n:if ([/ip firewall filter find chain=forward action=drop disabled=no in-\
    interface=\$iface] = \"\") do={\r\
    \n:set inputFWrulePresent (\$inputFWrulePresent + 1)\r\
    \n:if ( [\$IsInArray (\" forward: \" . \$iface) \$WhereRuleNotSet] = false\
    ) do={\r\
    \n:set WhereRuleNotSet (\$WhereRuleNotSet, (\" forward: \" . \$iface)) } }\
    \r\
    \n#\r\
    \n:do {:set routerIP (\$routerIP,  \"  \" . [/ip address get number=[/ip a\
    ddress find interface=\$iface] address] )} on-error={}\r\
    \n}\r\
    \n#If drop rules not present generate email report\r\
    \n:if (\$inputFWrulePresent >=1) do={\r\
    \n:local indentity [/system identity get name]\r\
    \n#\r\
    \nforeach y in=[/ip address find interface=\"\$LocalInterfaceName\"] do={\
    \r\
    \n:do {:set routerIP (\$routerIP, \"  \" . [/ip address get number=\$y add\
    ress] )} on-error={} }\r\
    \n#\r\
    \n:set routerIP [:tostr \$routerIP]\r\
    \n:set WhereRuleNotSet [:tostr \$WhereRuleNotSet]\r\
    \n:set EmaiSubject (\"Possible bad firewall on \" .\$indentity)\r\
    \n:set EmailBody (\"Device: \".\$indentity.\"\\nIP Adresses:\". \$routerIP\
    .\"\\nChains:\".\$WhereRuleNotSet.\"\\n\")\r\
    \n/tool e-mail send subject=\"\$EmaiSubject\" to=\"\$emailTo\" body=\"\$Em\
    ailBody\" start-tls=yes\r\
    \n}\r\
    \n}"

:do {/system scheduler remove WanCheck} on-error={}
/system scheduler add name=WanCheck interval=6h start-time=startup on-event="/system script run WanCheck"
/system script run WanCheck
