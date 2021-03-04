@echo off
setlocal enabledelayedexpansion
set resitcpath="C:\autobackup"
rem your repo path
set /a allrow=0
set /a row=1
set /a diffrow=0

for /f "delims=" %%i in ('restic -r %resitcpath% snapshots') do (
set /a allrow+=1
)
rem sum how many rows output

set /a lastrow=%allrow%-2
set /a prerow=%allrow%-3
for /f "delims=" %%i in ('restic -r %resitcpath% snapshots') do (
if !row!==%prerow% set prerowid=%%i
if !row!==%lastrow% set lastrowid=%%i
set /a row+=1
)
set idpre=%prerowid:~0,8%
set idlast=%lastrowid:~0,8%
rem find lastest two snapshots and get IDs

for /f "delims=" %%j in ('restic -r %resitcpath% diff %idpre% %idlast%') do (
set /a diffrow+=1
echo %%j
)
rem sum how many rows restic diff output

echo %diffrow%
if %diffrow%==8 (
restic -r %resitcpath% forget %idlast%
)
rem if restic diff output rows is 8 than shows nothing changed.Use resitc forget to delete the newest snapshot.
