:global SecProfile [/interface wireless get number=[/interface wireless find where interface-type!="virtual-AP"] security-profile]
if ([/interface wireless security-profiles get $SecProfile wpa2-pre-shared-key] !="_ActualPasswd_") do={/interface wireless security-profiles set $SecProfile wpa2-pre-shared-key="_ActualPasswd_"}
