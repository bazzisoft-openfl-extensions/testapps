TestApps
========

Provides a common test view and testing apps for the various OpenFL extensions.


Dependencies
------------

- Requires the below extensions to be available in the parent directory.


Installation
------------

    git clone https://github.com/bazzisoft-openfl-extensions/extensionkit
    git clone https://github.com/bazzisoft-openfl-extensions/mobiledisplay
    git clone https://github.com/bazzisoft-openfl-extensions/interop
    git clone https://github.com/bazzisoft-openfl-extensions/barcode
    git clone https://github.com/bazzisoft-openfl-extensions/camera
	git clone https://github.com/bazzisoft-openfl-extensions/nativetext
    git clone https://github.com/bazzisoft-openfl-extensions/testapps

    lime rebuild extensionkit [linux|windows|mac|android|ios]
    lime rebuild mobiledisplay [linux|windows|mac|android|ios]
    lime rebuild interop [linux|windows|mac|android|ios]
    lime rebuild barcode [linux|windows|mac|android|ios]
    lime rebuild camera [linux|windows|mac|android|ios]
	lime rebuild nativetext [linux|windows|mac|android|ios]
    
    lime test testapps/extensionkit/project.xml [flash|linux|windows|mac|android|ios] -debug
    lime test testapps/mobiledisplay/project.xml [flash|linux|windows|mac|android|ios] -debug
    lime test testapps/interop/project.xml [flash|linux|windows|mac|android|ios] -debug
    lime test testapps/barcode/project.xml [flash|linux|windows|mac|android|ios] -debug
    lime test testapps/camera/project.xml [flash|linux|windows|mac|android|ios] -debug
	lime test testapps/nativetext/project.xml [flash|linux|windows|mac|android|ios] -debug

