del z_modwarfare.iwd
del mod.ff

xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy weapons ..\..\raw\weapons /SY
copy /Y mod.csv ..\..\zone_source
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\ProjectileWeapons
copy ..\..\zone\english\mod.ff
7za a -r -tzip z_modwarfare.iwd maps
7za a -r -tzip z_modwarfare.iwd images
7za a -r -tzip z_modwarfare.iwd weapons


pause