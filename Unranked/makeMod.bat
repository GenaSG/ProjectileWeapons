del z_ProjectileWeapons.iwd
del mod.ff

xcopy ui_mp ..\..\raw\ui_mp /SY
copy /Y mod.csv ..\..\zone_source
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\Mods\Unranked
copy ..\..\zone\english\mod.ff

pause
