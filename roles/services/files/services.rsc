:if ([/ip service get telnet disabled] !=true) do={/ip service set telnet disabled=yes}
:if ([/ip service get ftp disabled] !=true) do={/ip service set ftp disabled=yes}
:if ([/ip service get api disabled] !=true) do={/ip service set api disabled=yes}
:if ([/ip service get api-ssl disabled] !=true) do={/ip service set api-ssl disabled=yes}
:if ([/ip service get www disabled] !=true) do={/ip service set www disabled=yes}
:if ([/ip service get www-ssl disabled] !=true) do={/ip service set www-ssl disabled=yes}
