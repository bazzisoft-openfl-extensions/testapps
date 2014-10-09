@echo off
SET PATH=%PATH%;c:\Android\AndroidSDK\tools;c:\Android\AndroidSDK\platform-tools
adb logcat -c
call lime test project.xml android -debug
rem call lime test project.xml android
pause
pskill adb
