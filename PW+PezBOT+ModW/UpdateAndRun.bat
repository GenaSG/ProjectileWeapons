"C:\Program Files\WinRAR\WinRAR.exe" A -afzip -y -r -ep1 "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare\Mods\PeZBOT\PeZBOT.iwd" "source\*.*"

cd "C:\Program Files\Activision\Call of Duty 4 - Modern Warfare"

iw3mp.exe "+seta sv_cheats 1 +set developer 1 +set developer_script 1 +set fs_game "mods/PeZBOT" +set svr_pezbots 1 +set svr_pezbots_mode normal +set svr_pezbots_drawdebug 0 +set svr_pezbots_team autoassign +set svr_pezbots_dogpack_size 0 +set svr_pezbots_skill 0 +set scr_war_timelimit 0 +set scr_war_scorelimit 0 +set scr_dm_timelimit 0 +set scr_dm_scorelimit 0 

rem +set sv_mapRotation "gametype dm map mp_cod4melee_test""