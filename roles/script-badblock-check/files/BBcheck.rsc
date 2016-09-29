:do {/system script remove BBcheck} on-error={}
/system script
add name=BBcheck source="{\r\
    \n:local emailTo \"user@example.com\"\r\
    \n:global routerIP [:toarray \"\"]\r\
    \n:if ([/system resource get bad-blocks] > 0) do={\r\
    \nput \"BB DETECTED\"\r\
    \n#Get router all IP addr.\r\
    \n:foreach y in=[/ip address find disabled=no] do={\r\
    \n:do {:set routerIP (\$routerIP, \"  \" . [/ip address get number=\$y add\
    ress] )} on-error={} }\r\
    \n#Generate email notify\r\
    \n:set routerIP [:tostr \$routerIP]\r\
    \n:local indentity [/system identity get name]\r\
    \n:local EmaiSubject (\"Bad Block detected on \" .\$indentity)\r\
    \n:local EmailBody (\"Device: \".\$indentity.\"\\nIP Adresses:\". \$router\
    IP.\"\\n\")\r\
    \n/tool e-mail send subject=\"\$EmaiSubject\" to=\"\$emailTo\" body=\"\$Em\
    ailBody\" start-tls=yes\r\
    \n}}"

/system script run BBcheck
