{
:local ScriptName "dhcp_autolease_Kiosk"
:local Hostname "init"
:local StartIP "240"

:do {/system script remove "$ScriptName" } on-error={}

/system script add name="$ScriptName" source="#dhcpAutoLease script\r\
    \n{\r\
    \n:local DeviceHostNameLike \"$Hostname\"\r\
    \n:local 4rdOctet $StartIP\r\
    \n\r\
    \n:global NewDevices [/ip dhcp-server lease find dynamic=yes host-name~\$D\
    eviceHostNameLike]\r\
    \n:global returnOctet do={\r\
    \n    :if (\$1=\"\") do={ :error \"You did not specify an IP Address.\"; }\
    \r\
    \n    :if (\$2=\"\") do={ :error \"You did not specify an octet to return.\
    \"; }\r\
    \n    :if ((\$2>\"4\") || (\$2<\"0\")) do={ :error \"Octet argument out of\
    \_range.\"; }\r\
    \n    :local decimalPos \"0\";\r\
    \n    :local octet1;\r\
    \n    :local octet2;\r\
    \n    :local octet3;\r\
    \n    :local octet4;\r\
    \n    :local octetArray; \r\
    \n    :set decimalPos [:find \$1 \".\"];\r\
    \n    :set octet1 [:pick \$1 0 \$decimalPos];\r\
    \n    :set decimalPos (\$decimalPos+1);\r\
    \n    :set octet2  [:pick \$1 \$decimalPos [:find \$1 \".\" \$decimalPos]]\
    ;\r\
    \n    :set decimalPos ([:find \$1 \".\" \$decimalPos]+1);\r\
    \n    :set octet3  [:pick \$1 \$decimalPos [:find \$1 \".\" \$decimalPos]]\
    ;\r\
    \n    :set decimalPos ([:find \$1 \".\" \$decimalPos]+1);\r\
    \n    :set octet4 [:pick \$1 \$decimalPos [:len \$1]];\r\
    \n    :set octetArray [:toarray \"\$octet1,\$octet2,\$octet3,\$octet4\"];\
    \r\
    \n    :if ((\$octet1<\"0\" || \$octet1>\"255\") || (\$octet2<\"0\" || \$oc\
    tet2>\"255\") || (\$octet3<\"0\" || \$octet3>\"255\") || (\$octet4<\"0\" |\
    | \$octet4>\"255\")) do={ :error \"Octet out of range.\"; }\r\
    \n    :if (\$2=\"0\") do={ :return \$octet1; }\r\
    \n    :if (\$2=\"1\") do={ :return \$octet2; }\r\
    \n    :if (\$2=\"2\") do={ :return \$octet3; }\r\
    \n    :if (\$2=\"3\") do={ :return \$octet4; }\r\
    \n    :if (\$2=\"4\") do={ :return \$octetArray; } }\r\
    \n\r\
    \nif (\$NewDevices!=\"\") do={\r\
    \n:global LeaseOK\r\
    \n:foreach i in=\$NewDevices do={\r\
    \n:local DynamicDHCPActiveAddr [/ip dhcp-server lease get number=\$i addre\
    ss];\r\
    \n:local MACAddress [/ip dhcp-server lease get number=\$i mac-address];\r\
    \n:log info [(\"Dynamic record for host like \" . \$DeviceHostNameLike . \
    \" detected. Creating static record\")]; \r\
    \n\r\
    \n:set LeaseOK \"False\";\r\
    \n:while ( \$LeaseOK = \"False\" ) do={\r\
    \n:local NewLeaseIPAddr [([\$returnOctet \$DynamicDHCPActiveAddr 0].\".\".\
    [\$returnOctet \$DynamicDHCPActiveAddr 1].\".\".[\$returnOctet \$DynamicDH\
    CPActiveAddr 2].\".\".\$4rdOctet)];\r\
    \n:if ([/ip dhcp-server lease find address=\$NewLeaseIPAddr]!=\"\") do={:l\
    og info [(\$NewLeaseIPAddr . \" IS BUSY\")]; :set 4rdOctet (\$4rdOctet + 1\
    )} else={\r\
    \n\t:log info [(\"Add dhcp lease. Address: \". \$NewLeaseIPAddr . \" MAC: \
    \" . \$MACAddress)];     \r\
    \n\t/ip dhcp-server lease make-static numbers=\$i;\r\
    \n\t/ip dhcp-server lease set number=\$i address=\$NewLeaseIPAddr comment=\
    \"added by AutoLease script\";\r\
    \n\t:set LeaseOK \"True\" }}\r\
    \n}}}\r\
    \n\r\
    \n\r\
    \n"

:do {/system scheduler remove "$ScriptName"} on-error={}
/system scheduler add name="$ScriptName" interval=1h start-time=startup on-event="/system script run $ScriptName"
/system script run $ScriptName
}