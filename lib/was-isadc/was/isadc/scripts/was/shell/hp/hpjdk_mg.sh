#! /bin/sh 
#Script to gather required information 
#from the environment for HP-IBM hybrid JDK 
>./hpjdk_mg.out 
echo "\n___ENV___" >>hpjdk_mg.out 
/usr/bin/env >>hpjdk_mg.out 
echo "\n____List of Installed Software_-for patches____" >>hpjdk_mg.out 
/usr/sbin/swlist -l product | grep -v "#" >>hpjdk_mg.out 
echo "\n___UNAME_INFO___" >>hpjdk_mg.out 
/usr/bin/uname -a >>hpjdk_mg.out 
echo "\n____swapinfo____">> hpjdk_mg.out 
/usr/sbin/swapinfo >>hpjdk_mg.out 
