#/ip proxy set enabled=yes
/ip proxy access { :foreach r in=[find] do={ remove $r }}
/ip proxy access add action=allow disabled=no dst-host=*accounts.google.com dst-port=""
/ip proxy access add action=allow disabled=no dst-host=*docs.google.com dst-port=""
