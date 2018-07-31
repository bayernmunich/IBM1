
call @was_home@/bin/setupCmdLine.bat

call @was_home@/wlp/bin/server.bat dump @server_name@ --archive="@output_file@"
