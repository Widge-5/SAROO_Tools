@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo.
echo SEGA SATURN SAROO BACKGROUND MUSIC PROCESSOR 🪐 (v1.00)
echo =======================================================
echo by Widge : 2025
echo 📺 https://www.youtube.com/@Widge
echo ☕ Support me at https://ko-fi.com/widge
echo.
echo.
echo Ensure all source audio/video files are placed in the directory with the BAT file.
echo This utility will convert the audio into the PCM format required by SAROO.
echo.
pause
echo.


:: Check for ffmpeg
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ FFmpeg is not installed or not found in your system PATH.
    echo Please install FFmpeg and ensure it is accessible from the command line.
    echo.
	pause
    exit /b
)
echo FFmpeg found.
:: Check for ffplay
where ffplay >nul 2>&1
if errorlevel 1 (
    echo FFplay not found
    set "canplay=false"
) else (
    echo FFplay found
    set "canplay=true"
)
echo.

:: Create working directory
set "WORKDIR=SAROO_output"
if not exist "%WORKDIR%" mkdir "%WORKDIR%"


:: Define supported extensions
set "EXTS=wav mp3 mp4 m4a aac flac ogg wma avi mkv mov"
set "index=0"

:: Scan for files and store in input array
for %%G in (%EXTS%) do (
    for %%F in (*.^%%G) do (
        set /a index+=1
        set "filelist[!index!]=%%F"
    )
)
if %index%==0 (
    echo ❌ No audio/video files found in this directory.
	echo.
    pause
    exit /b
)
echo Found %index% audio/video file(s):
for /l %%i in (1,1,%index%) do (
    echo %%i ➤  !filelist[%%i]!
)
echo.

:: If only one file found, treat this as the user's choice
if %index%==1 (
    echo Only one audio/video file found.
	set "CHOICE=1"
    goto :onechosen
)


:: In One go?
call :askYesNo "Do you want to process all of these files in one batch?" allfilesprocess
echo.
if /i "%allfilesprocess%"=="true" (
	goto :loopchoice
)
call :askNumberInRange "Enter the list number of the single file you'd like to process:" 1 %index% CHOICE

:onechosen
set INPUT=!filelist[%CHOICE%]!
echo File to process: !INPUT!
echo.


:: single-play or loop? (loop has _r at the end of the filename).
:loopchoice
echo.
set "outname=bgsound"
call :askYesNo "Do you want the audio to loop continuously?" chooseloop
echo.
if /i "%chooseloop%"=="true" (
    set "outname=!outname!_r"
)


:: Declare output filename
set "ext=pcm"
set "output=%WORKDIR%\%outname%.%ext%"
set "suffix=0"


:: Skip to single file processing if selected
if /i not "%allfilesprocess%"=="true" (
    call :singlefileprocess
	goto :finito
)



:: Process files from filelist array
:batchprocess
for /l %%i in (1,1,%index%) do (
	set "INPUT=!filelist[%%i]!"
	call :singlefileprocess
)
echo All files processed.
goto :finito


:singlefileprocess
echo 🎵 Processing: !INPUT!
call :checkOutputExists
ffmpeg.exe -i "!INPUT!" -ar 44100 -ac 2 -f s16le -acodec pcm_s16le "!OUTPUT!" >nul 2>&1
echo ✅ !INPUT! file processed.
echo ℹ️ Output filename is !OUTPUT!
echo.
exit /b

:finito
echo ⚠️ If your file has a numeric suffix, then this will need to be removed when transferred to the SAROO.
echo Valid filenames ar "bgsound.pcm" or "bgsound_r.pcm"
echo.
:: if only one file was created, and if FFplay is present, offer to play a preview
if "%canplay%"=="true" (
	if not "%allfilesprocess%"=="true" (
		call :askYesNo "Do you want to hear the resulting conversion?" waitAnswer
		if "!waitAnswer!"=="true" (
			echo Playing: !OUTPUT! 🔊🎵🎶🎵
			if "!chooseloop!"=="true" (
				ffplay -f s16le -ar 44100 -ac 2 -loglevel quiet -loop 0 "!OUTPUT!"
			) else (
				ffplay -f s16le -ar 44100 -ac 2 -loglevel quiet -autoexit "!OUTPUT!"
			)
		)
	) else (pause)
) else (pause)
exit /b


:: Subroutine to get unique filename by appending a number if needed
:checkOutputExists
if exist "%output%" (
    set /a suffix+=1
    set "output=%WORKDIR%\%outname%_%suffix%.%ext%"
    goto :checkOutputExists
)
exit /b


:askYesNo
setlocal
:askYesNoLoop
set "response="
set /p "response=❓ %~1 (Y/N): "
if /i "%response%"=="Y" ( endlocal & set "%~2=true" & goto :eof )
if /i "%response%"=="N" ( endlocal & set "%~2=false" & goto :eof )
echo Invalid response. Please enter Y or N.
goto askYesNoLoop

:askNumberInRange
setlocal enabledelayedexpansion
:askNumberLoop
set /p "number=❓ %~1 "
echo.!number!| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo Invalid input. Please enter a number.
    goto askNumberLoop
)
if !number! lss %~2 (
    echo Number too small. Must be >= %~2.
    goto askNumberLoop
)
if !number! gtr %~3 (
    echo Number too large. Must be <= %~3.
    goto askNumberLoop
)
endlocal & set "%~4=%number%" & exit /b


