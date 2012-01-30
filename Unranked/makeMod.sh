#!/bin/bash
rm -f z_ProjectileWeapons.iwd
rm -f mod.ff

cp -rf ./ui_mp ../../raw/ui_mp
cp -f mod.csv ../../zone_source
cd ../../bin/
wine linker_pc.exe -language english -compress -cleanup mod
cd ../Mods/Unranked
cp ../../zone/english/mod.ff ./


