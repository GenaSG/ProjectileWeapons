#!/bin/bash
rm -f mod.ff

cp -rf ./Data/* ../../raw/
cp -f ./Data/PeZBOT.csv ../../zone_source/mod.csv
cd ../../bin/
wine linker_pc.exe -language english -compress -cleanup mod
cd ../Mods/ProjectileWeapons+Pezbot/
cp ../../zone/english/mod.ff ./


