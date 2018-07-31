rem create the artifacts for a hang problem

outdir=%1
wasroot=%2
waspid=%3

echo 'Issuing netstat (before server restart)'
netstat -an > %outdir%\netstat_before.out

echo 'Important Message ---------------------------------------------------'
echo 'The instructions for enabling verbose GC can be found at'
echo 'http://www.ibm.com/support/docview.wss?rs=180&uid=swg21114927'
echo 'Open the instructions in a web browser and follow them for your particular platform.'
echo 'NOTE: This will require a server restart'
echo '---------------------------------------------------------------------'

