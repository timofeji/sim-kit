git clone https://github.com/juj/emsdk.git
cd emsdk
rd /s /q clang
rd /s /q emscripten
rd /s /q java
rd /s /q node
rd /s /q python
rd /s /q zips
git reset --hard HEAD
git checkout main
git pull
call emsdk install latest
call emsdk activate latest
call emsdk_env
WHERE emmake >nul 2>nul
IF %ERRORLEVEL% NEQ 0 ECHO Emscripten install failed, run script again
IF %ERRORLEVEL% EQU 0 ECHO Emscripten install successful 
