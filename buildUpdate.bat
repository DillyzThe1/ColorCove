cd ./assetsHidden/data/
set numb=0
for /f %%i in (buildNum.txt) DO ( 
	if %numb%==0 @set "ogBuild=%%i"
	set /a numb+=1
)
@set /a "c=%ogBuild%+1"
(
	echo %c%
)>"buildNum.txt"
cd ../..
::if exist ".\export\debug\.build" (
::	echo hd
::	echo y | xcopy ".\export\debug\.build" ".\assetsHidden\data\debugCount.txt"
::) else (
::	cd ".\assetsHidden\data\"
::	(
::		echo 0
::	)>debugCount.txt
::	cd "..\.."
::)
::
::if exist ".\export\release\.build" (
::	echo hd2
::	echo y | xcopy ".\export\release\.build" ".\assetsHidden\data\releaseCount.txt"
::) else (
::	cd ".\assetsHidden\data\"
::	(
::		echo 0
::	)>releaseCount.txt
::	cd "..\.."
::)
::cls