./emsdk/emsdk.bat activate latest &&
cd ./build &&
emcmake
emcmake cmake -S . -B build
