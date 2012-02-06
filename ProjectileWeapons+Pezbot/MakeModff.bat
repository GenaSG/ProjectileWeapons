del "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare\mods\pezbot\mod.ff"

xcopy data\*.* "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare\raw\" /SY

copy /Y data\pezbot.csv "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare\zone_source"

cd "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare\bin"

linker_pc.exe -language english -compress -cleanup pezbot

cd ..\mods\pezbot

copy ..\..\zone\english\pezbot.ff mod.ff
