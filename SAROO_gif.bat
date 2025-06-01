@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo.
echo SEGA SATURN SAROO ANIMATED BACKGROUND IMAGE CREATOR 🪐 (v1.01)
echo ==============================================================
echo by Widge : 2025
echo 📺 https://www.youtube.com/@Widge
echo ☕ https://ko-fi.com/widge
echo.
echo.
echo Ensure all source image files are placed in the directory with the BAT file.
echo These should ideally already be all the same size, however this utility will
echo resize every image to 320x240 pixels regardless.
echo.
echo It is assumed that the image order is alphanumeric. please ensure that your
echo images are named so that they are in the expected sequence.
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
echo.


:: Create working directory
set "WORKDIR=SAROO_output"
if not exist "%WORKDIR%" mkdir "%WORKDIR%"

:: Declare output filename
set "outname=mainmenu_bg"
set "ext=gif"
set "output=%WORKDIR%\%outname%.%ext%"
set "suffix=0"
:checkOutputExists
if exist "%output%" (
    set /a suffix+=1
    set "output=%WORKDIR%\%outname%_%suffix%.%ext%"
    goto :checkOutputExists
)



echo Scanning for image files...
set "index=0"
for %%F in (*.png *.jpg *.jpeg *.bmp *.gif) do (
    set /a index+=1
    set "input[!index!]=%%F"
)
if %index%==0 (
    echo ❌ No image files found in this directory.
	echo.
    pause
    exit /b
)



echo Found %index% image(s).
for /l %%i in (1,1,%index%) do (
    echo %%i ➤  !input[%%i]!
)
echo.
echo.

:: If only one image, generate a still then skip to the end
if %index%==1 (
    echo 🖼  Only one image found. Creating a still image instead...

    set "inputfile=!input[1]!"
    set "bmpfile=%WORKDIR%\frame1.bmp"
	
	ffmpeg -loglevel error -y -i "!inputfile!" -vf scale=320:240 -pix_fmt rgb24 %output%
    
	goto :finalCleanup
)


:: Ask if there's a pause frame
call :askYesNo "Should the animation have a pause frame in the loop?" waitAnswer
set "useWaitFrame=false"
if "%waitAnswer%"=="true" (
    echo.
    call :askNumberInRange "Enter the list number of the frame to use as the pause frame:" 1 %index% waitframe
    echo.
	call :askMilliseconds "Enter duration of the pause frame in milliseconds:" waitdur
    set "useWaitFrame=true"
)

:: Ask for frame duration
echo.
call :askMilliseconds "Enter duration (ms) of each animation frame (excluding pause frame):" framedur


:: Ask about palette method
echo.
echo.
echo We need to generate a colour palette from one of the frames, to ensure that
echo all frames conform to the same palette, otherwise colour corruption can occur.
call :askNumberInRange "Enter the list number of the frame to use for the palette:" 1 %index% paletteframe


:: Convert all images to 320x240 BMPs and number them
echo.
echo 🖼  Converting images...
set "frameList=%WORKDIR%\frames.txt"
del "%frameList%" >nul 2>&1

set "count=0"
for /l %%i in (1,1,%index%) do (
    set /a count+=1
    set "inputfile=!input[%%i]!"
    set "bmpfile=%WORKDIR%\frame!count!.bmp"
    ffmpeg -loglevel error -y -i "!inputfile!" -vf "scale=320:240:flags=lanczos,format=pal8" "!bmpfile!"

    rem Write frame entry
    echo file 'frame!count!.bmp'>>"%frameList%"

    rem Decide duration
    set "addDuration=true"

    rem Skip duration on the last frame
    if %%i==%index% (
        set "addDuration=false"
    )

    rem If waitframe is defined and matches this frame
    if defined waitframe (
        if "%%i"=="%waitframe%" (
            set "useWaitDur=true"
        ) else (
            set "useWaitDur=false"
        )
    ) else (
        set "useWaitDur=false"
    )

    if "!addDuration!"=="true" (
        if "!useWaitDur!"=="true" (
            set /a durSec=%waitdur% / 1000
            set /a durMs=%waitdur% %% 1000
        ) else (
            set /a durSec=%framedur% / 1000
            set /a durMs=%framedur% %% 1000
        )

        if !durMs! lss 10 set "durMs=00!durMs!"
        if !durMs! lss 100 if !durMs! gtr 9 set "durMs=0!durMs!"
        echo duration !durSec!.!durMs!>>"%frameList%"
    )

    set "bmp[%%i]=!bmpfile!"
)

:: Final frame must be repeated once to finalize timing
echo file 'frame%count%.bmp'>>"%frameList%"


:: Generate palette
echo Generating palette...
set "paletteframe=!paletteframe:"=!"
set "palettebmp=frame!paletteframe!.bmp"
echo Using palette frame: !palettebmp!
ffmpeg -loglevel error -y -i "%WORKDIR%\!palettebmp!" -vf palettegen "%WORKDIR%\palette.png"


:: Create the animated GIF
echo Creating animated GIF...
ffmpeg -loglevel error -y -f concat -safe 0 -i "%frameList%" -i "%WORKDIR%\palette.png" -lavfi "paletteuse=dither=bayer:bayer_scale=4" -loop 0 "%output%"


:: Check output file size
for %%F in ("%output%") do set "filesize=%%~zF"
if %filesize% gtr 307200 (
    echo.
    echo ⚠️  WARNING: The final GIF file is %filesize% bytes, which exceeds the SAROO recommended maximum of 300KB.
    echo Consider reducing the number of frames or simplifying the animation.
    echo.
)


:: Clean up temporary files
:finalCleanup
echo Cleaning up temporary files...
del "%WORKDIR%\*.bmp" >nul 2>&1
if exist "%WORKDIR%\palette.png" del "%WORKDIR%\palette.png"
if exist "%frameList%" del "%frameList%"

echo.
echo ✅ Done. Output saved to: "%output%"
echo ⚠️ If your file has a numeric suffix, then this will need to be removed when transferred to the SAROO.
echo The valid filename is "mainmenu_bg.gif"

echo.

:: Open the resulting animation
call :askYesNo "Do you want to see the result in your default GIF viewer?" waitAnswer
if "%waitAnswer%"=="true" (
	start "" "%output%"
)

rem pause
exit /b

::--------------------
:: Input validation blocks
::--------------------

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
endlocal & set "%~4=%number%" & goto :eof


:askMilliseconds
setlocal enabledelayedexpansion
:askMillisLoop
set /p "ms=❓ %~1 "
echo.!ms!| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo Invalid input. Please enter a numeric value in milliseconds.
    goto askMillisLoop
)
if !ms! lss 1 (
    echo Duration must be greater than 0.
    goto askMillisLoop
)
endlocal & set "%~2=%ms%" & goto :eof
