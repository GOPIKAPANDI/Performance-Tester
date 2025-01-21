@echo off
:monitor
:: Check if the Wi-Fi interface is connected by checking for an SSID
for /f "tokens=2 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /i "SSID"') do set "CURRENT_SSID=%%i"
set "CURRENT_SSID=%CURRENT_SSID:~1%"  :: Remove leading space

:: If connected to the desired SSID, continue monitoring without doing anything
if "%CURRENT_SSID%"=="DENSITY-NSS" (
    timeout /t 10 > nul
    goto monitor
)

:: If not connected to the desired SSID, check if Wi-Fi is disconnected
for /f "tokens=2 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /i "State"') do set "WIFI_STATE=%%i"
set "WIFI_STATE=%WIFI_STATE:~1%"  :: Remove leading space

:: If Wi-Fi is disconnected, reconnect
if "%WIFI_STATE%"=="Disconnected" (
    echo Wi-Fi disconnected. Attempting to reconnect...
    netsh wlan connect name="DENSITY-NSS"
)

:: Wait for 10 seconds before checking again
timeout /t 10 > nul
goto monitor
