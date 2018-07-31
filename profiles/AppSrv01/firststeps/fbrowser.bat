@echo off
    CALL "%~dp0readRegistry.bat" "HKEY_CLASSES_ROOT\.html" @ browser FirstStepsDefaultBrowser
    IF {%FirstStepsDefaultBrowser%} == {MozillaHTML} SET FirstStepsDefaultBrowser=Mozilla
    IF {%FirstStepsDefaultBrowser%} == {FirefoxHTML} SET FirstStepsDefaultBrowser=Firefox
    IF {%FirstStepsDefaultBrowser%} == {htmlfile} SET FirstStepsDefaultBrowser=IExplore
    IF {%FirstStepsDefaultBrowser%} == {IExplore} SET FirstStepsDefaultBrowserPath=IExplore
		IF {%FirstStepsDefaultBrowser%} == {Mozilla} CALL "%~dp0readRegistry.bat" "HKEY_LOCAL_MACHINE\Software\Clients\StartMenuInternet\MOZILLA.EXE\shell\open\command" @ moz FirstStepsDefaultBrowserPath
		IF {%FirstStepsDefaultBrowser%} == {Firefox} CALL "%~dp0readRegistry.bat" "HKEY_LOCAL_MACHINE\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command" @ moz FirstStepsDefaultBrowserPath
