; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "eLTv3 alpha"
!define APPNAMEANDVERSION " eLTv3 0.0.51_2012.10.02 "

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES"
OutFile "C:\Setup\eLTv3\eLTv3_0.0.51_2012.10.02.exe"

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
	File /oname=eLTv3.0.0.51_2012.10.02.ex4 "eLT_3.0.ex4"
	SetOutPath "$INSTDIR\experts\indicators\"
	File "indicators\ZigZag.ex4"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; eof