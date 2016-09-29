#upgrade, add RSA key & update firmware
/system script
add name=Init source="\r\
    \n:global MTversion [/system resource get version];\r\
    \n:global Major [:pick \$MTversion 0];\r\
    \n:global Minor;\r\
    \n:global SecondDotPresent [:find \$MTversion \".\" 1];\r\
    \n:global RunFromSheduler;\r\
    \n:global IsUpdated;\r\
    \n\r\
    \n:if ([:len \$SecondDotPresent] = 0) do={:set Minor [:pick \$MTversion 2 \
    [[:len \$MTversion] -3]]} else={:set Minor [:pick \$MTversion 2 [:find \$M\
    Tversion \".\" 1]] };\r\
    \n\r\
    \n:if (\$Major = 5) do={\r\
    \n:if (\$Minor >= 21) do={\r\
    \n/system package update check-for-updates;\r\
    \n:delay 3;\r\
    \n/system package update upgrade }}\r\
    \n\r\
    \n:if (\$Major = 6) do={\r\
    \n:if (\$Minor < 31) do={\r\
    \n/system package update check-for-updates;\r\
    \n:delay 3;\r\
    \n/system package update upgrade } else= {:set IsUpdated \"yes\"}\r\
    \n}\r\
    \n\r\
    \n:if (\$IsUpdated = \"yes\") do= {\r\
    \n\r\
    \n:global AnsibleUserPresent [/user find where name=mikroansible]\r\
    \nif ([:len \$AnsibleUserPresent] = 0) do={\r\
    \n/user add name=mikroansible group=full password=\"CHANGEME!!!\"\r\
    \n/file print file=mikroansible_key.txt\r\
    \n:delay 1\r\
    \n/file set mikroansible_key.txt contents=\"ssh-rsa AAAAB3NyaC1yc2EAAAAD0Q\
    ABAAABAQCvTbkJA4IvLU6Elzzzr7fPgsEX/HNHVelKJ7cvUTausN1F0Wo+awZ10txGCLD4YV+X\
    SzK+hrxczO9WESMr4aZjFRaZXCNpsPWZ+zi40rV3CJQWQZ1t5kwP+bk7GnhfZQbr4m1qHMh+1v\
    eXDTz5CzCwEW6wler7ukuT4Qx3Jsck0ehdry2hj3keynrGLq8eL+vDrFIwv9jSj15QNuwT8wQa\
    ZGu7Ma/nWwg7zlxYO+KS/WB3/9kPUQzAgZet1AsFjS0GAtXSCNjdkKWLYajUcDXMnxFyrZ0N6n\
    y1Swtu5qWU0FP1hwP5KBjfnE35mQ5jQ77HgRz1PzJkOfAICjjN1i4p mikroansible@host\"\
    \r\
    \n:delay 1\r\
    \n/user ssh-keys import user=mikroansible public-key-file=mikroansible_key\
    .txt\r\
    \n}\r\
    \n\r\
    \n:if (\$RunFromSheduler=\"yes\") do={\r\
    \n:if ( [/system routerboard get current-firmware] != [system routerboard \
    get upgrade-firmware]) do={\r\
    \n/system routerboard upgrade\r\
    \n:delay 10\r\
    \n/system reboot\r\
    \n}\r\
    \n}\r\
    \n}"

/system scheduler
add name=Init on-event=\
    ":global RunFromSheduler \"yes\"\r\
    \n/system script run Init" start-time= startup

/system script run Init
