; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "eTrendHarvester"
!define APPNAMEANDVERSION " eTrendHarvester.0.0.28_2012.09.20"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES"
OutFile "C:\Setup\eLTv3\eTrendHarvester.0.0.28_2012.09.20.exe"

; Use compression
SetCompressor LZMA

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "eLT" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\experts\"
	File /oname=eTrendHarvester.0.0.28_2012.09.20.ex4 "eTrendHarvester.ex4"
	SetOutPath "$INSTDIR\experts\indicators\"
	File "indicators\ZigZag.ex4"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; eof