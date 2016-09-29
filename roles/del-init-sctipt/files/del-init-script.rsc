:if ([system scheduler find name=Init] != "") do={/system scheduler remove Init}
:if ([system script find name=Init] != "") do={/system script remove Init}
:if ([/file find name=init-script.rsc] != "") do={/file remove init-script.rsc}
