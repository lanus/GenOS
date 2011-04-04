; GenOS USB Creator ©2011 Ivo Nunes http://www.gen-os.info
; Universal USB Installer ©2009-2011 Lance http://www.pendrivelinux.com
; 7-Zip ©2011 Igor Pavlovis http://7-zip.org (unmodified binaries were used)
; Syslinux ©2011 H. Peter Anvin http://syslinux.zytor.com (unmodified binary used)
; dd.exe ©2011 John Newbigin http://www.chrysocome.net/dd (unmodified binary used)
; mke2fs.exe ©2011 Matt WU http://ext2fsd.sourceforge.net (unmodified binary used)
; grldr GRUB4DOS ©2011, the Gna! people http://www.gnu.org/software/grub (unmodified binary used)
; Fat32format.exe ©2011 Tom Thornhill Ridgecorp Consultants http://www.ridgecrop.demon.co.uk (unmodified binary used)
; NSIS Installer ©2011 Contributors http://nsis.sourceforge.net - This script was created using NSIS, you must install and use NSIS to compile this script. http://nsis.sourceforge.net/Download

!define NAME "GenOS USB Creator"
!define FILENAME "GenOS-USB-Creator"
!define VERSION "1.0.0.0"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\nsis1-install.ico"

; MoreInfo Plugin - Adds Version Tab fields to Properties. Plugin created by onad http://nsis.sourceforge.net/MoreInfo_plug-in
VIProductVersion "${VERSION}"
VIAddVersionKey CompanyName "gen-os.info"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription "GenOS USB Creator"
VIAddVersionKey License "GPL Version 2"

Name "${NAME} ${VERSION}"
OutFile "${FILENAME}-${VERSION}.exe"
RequestExecutionLevel admin ;highest
SetCompressor LZMA
CRCCheck On
XPStyle on
ShowInstDetails show
BrandingText "GenOS USB Creator http://www.gen-os.info"
CompletedText "Installation done, process is complete!"
InstallButtonText Create

!include nsDialogs.nsh
!include MUI2.nsh
!include FileFunc.nsh
!include LogicLib.nsh
!include FileNames.nsh ; FileNames Macro Script created by Lance http://www.pendrivelinux.com

; Variables
Var FileFormat
Var Dialog
Var LabelDrivePage
Var Distro
Var DistroName
Var ISOFileName
Var SomeFileExt
Var DestDriveTxt
Var DestDrive
Var LinuxDistroSelection
Var LabelISOSelection
Var ISOFileTxt
Var TheISO
Var IsoFile
Var ISOSelection
Var ISOTest
Var Casper
Var CasperSelection
Var Persistence
Var SizeOfCasper
Var DestDisk
Var DownloadISO
Var DownloadMe
Var Link
Var Links
Var Auth
Var DownLink
Var AllDriveOption
Var DisplayAll
Var Format 
Var FormatMe
Var SysLinVer
Var DistroLink
Var Homepage
Var OfficialSite
Var OfficialName
Var RemainingSpace
Var CasperSlider
Var SlideSpot
Var MaxPersist
Var BlockSize

; Interface settings
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "usb-logo-nsis.bmp" 
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_HEADERIMAGE_RIGHT

; License Agreement Page
!define MUI_TEXT_LICENSE_SUBTITLE $(License_Subtitle)
!define MUI_LICENSEPAGE_TEXT_TOP $(License_Text_Top)
!define MUI_LICENSEPAGE_TEXT_BOTTOM $(License_Text_Bottom)
!insertmacro MUI_PAGE_LICENSE "Copying.txt"

; Distro Selection Page
Page custom SelectionsPage

; Install Files Page
!define MUI_INSTFILESPAGE_COLORS "00FF00 000000" ;Green and Black
!define MUI_TEXT_INSTALLING_TITLE $(Install_Title)
!define MUI_TEXT_INSTALLING_SUBTITLE $(Install_SubTitle)
!define MUI_TEXT_FINISH_SUBTITLE $(Install_Finish_Sucess)
!insertmacro MUI_PAGE_INSTFILES

; English Language files
!insertmacro MUI_LANGUAGE "English" ; first language is the default language
LangString License_Subtitle ${LANG_ENGLISH} "Please review the license terms before proceeding"
LangString License_Text_Top ${LANG_ENGLISH} "The software within this program falls under the following Licenses."
LangString License_Text_Bottom ${LANG_ENGLISH} "You must accept the terms of this License agreement to run this ${NAME}. If you agree, Click I Agree to Continue."
LangString SelectDist_Title ${LANG_ENGLISH} "Setup your Selections Page"
LangString SelectDist_Subtitle ${LANG_ENGLISH} "Choose the GenOS version, ISO and, your USB Flash Drive."
LangString Distro_Text ${LANG_ENGLISH} "Step 1: Select a GenOS version from the dropdown to put on your USB"
LangString IsoPage_Title ${LANG_ENGLISH} "Select Your $FileFormat"
LangString IsoPage_Text ${LANG_ENGLISH} "Step 2: Select the $FileFormat (Name MUST BE the same as above)."
LangString IsoFile ${LANG_ENGLISH} "$FileFormat file|$ISOFileName" ;$ISOFileName variable previously *.iso
LangString DrivePage_Text ${LANG_ENGLISH} "Step 3: Select your USB Flash Drive Letter Only"
LangString Casper_Text ${LANG_ENGLISH} "Step 4: Set a Persistent file size for storing changes (Optional)."
LangString Extract ${LANG_ENGLISH} "Extracting the $FileFormat: The progress bar will not move until finished. Please be patient..."
LangString CreateSysConfig ${LANG_ENGLISH} "Creating configuration files for $DestDrive"
LangString ExecuteSyslinux ${LANG_ENGLISH} "Executing syslinux on $DestDisk"
LangString SkipSyslinux ${LANG_ENGLISH} "Good Syslinux Exists..."
LangString WarningSyslinux ${LANG_ENGLISH} "An error ($R8) occurred while executing syslinux.$\r$\nYour USB drive won't be bootable..."
LangString Install_Title ${LANG_ENGLISH} "Installing $DistroName"
LangString Install_SubTitle ${LANG_ENGLISH} "Please wait while ${NAME} installs $DistroName on $0"
LangString Install_Finish_Sucess ${LANG_ENGLISH} "${NAME} sucessfully installed $DistroName on $0"

Function SomeFiles ; Distro2Check (Name of the Distro)
	
  !insertmacro FileNames "GenOS 0.2"
  
; ##################################### ADD NEW DISTRO ########################################
FunctionEnd

Function SetISOFileName
  !insertmacro SetISOFileNames "GenOS 0.2" genos_beta2.iso "https://github.com/downloads/lanus/GenOS/genos_beta2.iso" 1137 "casper" syslinuxnew.exe "http://www.gen-os.info" "GenOS"
; ##################################### ADD NEW DISTRO ######################################## 
FunctionEnd

Function SelectionsPage
!insertmacro MUI_HEADER_TEXT $(SelectDist_Title) $(SelectDist_Subtitle) 
  nsDialogs::Create 1018
  Pop $Dialog

; Distro Selection Starts
  ${NSD_CreateLabel} 0 0 100% 15 $(Distro_Text) 
  Pop $LinuxDistroSelection   
  ${NSD_CreateDropList} 0 20 47% 15 ""
  Pop $Distro   
  ${NSD_OnChange} $Distro OnSelectDistro  
  Call SomeFiles
  
  ${NSD_CB_SelectString} $Distro $DistroName  
  
; ISO Download Option
  ${NSD_CreateCheckBox} 50% 20 50% 15 "Download the ISO (Optional)."
  Pop $DownloadISO
  ${NSD_OnClick} $DownloadISO DownloadIt 

  ;SetCtlColors $DownloadDone /BRANDING 009900  
  
; Clickable Link to Distribution Homepage  
  ${NSD_CreateLink} 55% 35 45% 15 "Visit the $OfficialName website"
  Pop $DistroLink
  ${NSD_OnClick} $DistroLink onClickLinuxSite 
  
; ISO Selection Starts  
  ${NSD_CreateLabel} 0 50 100% 15 $(IsoPage_Text)
  Pop $LabelISOSelection
  ${NSD_CreateText} 0 70 83% 20 "Browse to and select the $FileFormat"
  Pop $ISOFileTxt 
  ${NSD_CreateBrowseButton} 85% 70 60 20 "Browse"
  Pop $ISOSelection 
  ${NSD_OnClick} $ISOSelection ISOBrowse  
  
; Drive Selection Starts  
  ${NSD_CreateLabel} 0 100 54% 15 $(DrivePage_Text)
  Pop $LabelDrivePage
  ${NSD_CreateDroplist} 0 120 15% 15 ""
  Pop $DestDriveTxt
  Call ListAllDrives
  ${NSD_OnChange} $DestDriveTxt OnSelectDrive
  
; All Drives Option
  ${NSD_CreateCheckBox} 55% 100 45% 15 "Show all Drives (USE WITH CAUTION)"
  Pop $AllDriveOption
  ${NSD_OnClick} $AllDriveOption ListAllDrives  
  
  ${If} $DestDrive != ""
  ${NSD_CB_SelectString} $DestDriveTxt $DestDrive
  ${EndIf}  
  
; Format Drive Option
  ${NSD_CreateCheckBox} 20% 123 75% 15 "Format Drive as Fat32"
  Pop $Format
  ${NSD_OnClick} $Format FormatIt    
  
; Casper-RW Selection Starts
  ${NSD_CreateLabel} 0 150 100% 15 $(Casper_Text)
  Pop $CasperSelection  
  
; CasperSlider - TrackBar
  !define TBM_SETPOS 0x0405
  !define TBM_GETPOS 0x0400
  !define TBM_SETRANGEMIN 0x0407
  !define TBM_SETRANGEMAX 0x0408

  ${NSD_CreateLabel} 52% 178 30% 25 ""
  Pop $SlideSpot  

  nsDialogs::CreateControl "msctls_trackbar32" "0x50010000|0x00000018" "" 0 174 50% 25 ""
  Pop $CasperSlider

  SendMessage $CasperSlider ${TBM_SETRANGEMIN} 1 0 ; Min Range Value 0
  SendMessage $CasperSlider ${TBM_SETRANGEMAX} 1 $RemainingSpace ; Max Range Value $RemainingSpace
  ${NSD_OnNotify} $CasperSlider onNotify_CasperSlider      
  
; Disable Next Button until a selection is made for all 
  GetDlgItem $6 $HWNDPARENT 1
  EnableWindow $6 0 
; Remove Back Button
  GetDlgItem $6 $HWNDPARENT 3
  ShowWindow $6 0 
; Hide or disable steps until we state to display them 
  EnableWindow $LabelISOSelection 0
  EnableWindow $ISOFileTxt 0
  EnableWindow $ISOSelection 0
  EnableWindow $LabelDrivePage 0
  EnableWindow $AllDriveOption 0
  EnableWindow $DestDriveTxt 0
  ShowWindow $CasperSelection 0 
  ShowWindow $CasperSlider 0 
  ShowWindow $SlideSpot 0
  ShowWindow $Format 0
  ShowWindow $DistroLink 0 
  ShowWindow $DownloadISO 0
  nsDialogs::Show 
FunctionEnd

Function onClickMyLink
  Pop $Links ; pop something to prevent corruption
  ExecShell "open" "http://www.gen-os.info/usb.html"
FunctionEnd

Function onClickLinuxSite
  Pop $OfficialSite 
  ExecShell "open" "$Homepage"
FunctionEnd

Function DownloadIt ; Set Download Option
  ${NSD_GetState} $DownloadISO $DownloadMe
  ${If} $DownloadMe == ${BST_CHECKED}
  ${NSD_Check} $DownloadISO
  ${NSD_SetText} $DownloadISO "Opted to Download the $FileFormat."
  Call DownloadLinks
  ${ElseIf} $DownloadMe == ${BST_UNCHECKED}
  ${NSD_Uncheck} $DownloadISO 
  ${NSD_SetText} $DownloadISO "Download the $FileFormat (Optional)."  
  ${EndIf}  
FunctionEnd

Function ListAllDrives ; Set to Display All Drives
  SendMessage $DestDriveTxt ${CB_RESETCONTENT} 0 0 
  ${NSD_GetState} $AllDriveOption $DisplayAll
  ${If} $DisplayAll == ${BST_CHECKED}
  ${NSD_Check} $AllDriveOption
  ${NSD_SetText} $AllDriveOption "Now Showing All Drives (BE CAREFUL)" 
    ${GetDrives} "ALL" DrivesList ; All Drives Listed  
  ${ElseIf} $DisplayAll == ${BST_UNCHECKED}
  ${NSD_Uncheck} $AllDriveOption
  ${NSD_SetText} $AllDriveOption "Show all Drives (USE WITH CAUTION)"  
	${GetDrives} "FDD" DrivesList ; FDD+HDD reduce to FDD for removable media only
  ${EndIf}
FunctionEnd

Function FormatYes ; If Format is checked, do something
  ${If} $FormatMe == "Yes"
  
; Close Open Explorer Windows to allow fat32format to format the drive  
  DetailPrint "Closing All Open Explorer Windows" 
  FindWindow $R0 CabinetWClass
  IsWindow $R0 0 +3
  SendMessage $R0 ${WM_SYSCOMMAND} 0xF060 0
  Goto -3  
  
  SetShellVarContext all
  InitPluginsDir
  File /oname=$PLUGINSDIR\fat32format.exe "fat32format.exe"  
  DetailPrint "Formatting $DestDisk as Fat32"
  nsExec::ExecToLog '"cmd" /c "echo y|$PLUGINSDIR\fat32format -c$BlockSize $DestDisk /Q /y"'
  DetailPrint "Creating Label PENDRIVE on $DestDisk"
  nsExec::ExecToLog '"cmd" /c "LABEL $DestDisk PENDRIVE"'
  ${Else} 
  DetailPrint "Creating Label PENDRIVE on $DestDisk"
  nsExec::ExecToLog '"cmd" /c "LABEL $DestDisk PENDRIVE"'
  ${EndIf} 
FunctionEnd

Function FormatIt ; Set Format Option
  ${NSD_GetState} $Format $FormatMe
  ${If} $FormatMe == ${BST_CHECKED}
  ${NSD_Check} $Format
  StrCpy $FormatMe "Yes"
  ${NSD_SetText} $Format "We will format $DestDrive Drive as Fat32."
  ${ElseIf} $FormatMe == ${BST_UNCHECKED}
  ${NSD_Uncheck} $Format 
  ${NSD_SetText} $Format "Format $DestDrive Drive (Erases Content)"  
  ${EndIf}  
  Call SetSpace
FunctionEnd

Function EnableNext ; Enable Install Button
  ${If} $Blocksize >= 4 
  ShowWindow $Format 1 
  ${Else}
  ShowWindow $Format 0
  ${EndIf}

  ${If} $ISOFileName != ""
  ${AndIf} $ISOFile != ""
  ${AndIf} $DestDrive != "" 
  GetDlgItem $6 $HWNDPARENT 1 ; Get "Install" control handle
  EnableWindow $6 1 ; Enable "Install" control button
  ${EndIf}
  
; Test if ISO has been Selected. If not, disable Install Button
  ${If} $ISOTest == ""
  GetDlgItem $6 $HWNDPARENT 1
  EnableWindow $6 0 ; Disable "Install" if ISO not set 
  ${EndIf}
  
; Show Steps in progression
  ${If} $Persistence == "casper" ; If can use Casper Persistence... 
  ${AndIf} $ISOFile != ""
  ${AndIf} $DestDrive != "" 
  ShowWindow $CasperSelection 1
  ShowWindow $CasperSlider 1
  ShowWindow $SlideSpot 1
  ${NSD_SetText} $Format "Format $DestDrive Drive (Erases Content)"  
	
; Or if not using Casper Persistence...  
  ${ElseIf} $ISOFile != ""
  ${AndIf} $DestDrive != ""   
  ShowWindow $CasperSelection 0
  ShowWindow $CasperSlider 0 
  ShowWindow $SlideSpot 0
  ${NSD_SetText} $Format "Format $DestDrive Drive (Erases Content)" 
  ${EndIf}  
  
  ${If} $ISOFileName != "" 
  EnableWindow $LabelISOSelection 1  
  EnableWindow $ISOFileTxt 1
  EnableWindow $ISOSelection 1
  ${EndIf}  
  
  ${If} $ISOFile != ""
  EnableWindow $LabelDrivePage 1
  EnableWindow $AllDriveOption 1
  EnableWindow $DestDriveTxt 1
  ${EndIf} 
  
; Disable Window if ISO was downloaded
  ${If} $TheISO == "$EXEDIR\$ISOFileName"
  ${AndIf} $ISOTest != ""  
  EnableWindow $ISOSelection 0
  SetCtlColors $ISOFileTxt 009900 FFFFFF  
  ${EndIf}   
FunctionEnd

Function DownloadLinks
MessageBox MB_YESNO|MB_ICONQUESTION "Launch the $DistroName Download Link?$\r$\nLet the download finish before moving to step 2." IDYES DownloadIt IDNO Skip
  Skip: ; Reset Download Checkbox Options 
  ${NSD_Uncheck} $DownloadISO 
  ${NSD_SetText} $DownloadISO "Download the $FileFormat (Optional)."  
  EnableWindow $DownloadISO 1
  Goto end
  DownloadIt:
  ${NSD_SetText} $LabelISOSelection "Step 2: Once your download has finished, Browse to and select the ISO."  
  EnableWindow $DownloadISO 0
  ExecShell "open" "$DownLink"  
  EnableWindow $DownloadISO 1	
  end:
FunctionEnd

; On Selection of Linux Distro
Function OnSelectDistro
  Pop $Distro 
  ${NSD_GetText} $Distro $DistroName 
  StrCpy $DistroName "$DistroName" 
  Call SetISOFileName
  StrCpy $ISOFileName "$ISOFileName"  
  StrCpy $SomeFileExt "$ISOFileName" "" -3 ; Grabs the last 3 charactors of the filename... zip or iso?
  StrCpy $FileFormat "$SomeFileExt"

 ; Redraw Home page Links and Download Links as necessary
  ${If} $DownLink == ""
  ShowWindow $DownloadISO 0  
  ${Else}
  ShowWindow $DownloadISO 1 
  ${EndIf}  
	
  ${NSD_SetText} $DistroLink "Visit the $OfficialName Home Page" 
  ShowWindow $DistroLink 0
  ${If} $OfficialName == ""
  ShowWindow $DistroLink 0
  ${Else}
  ShowWindow $DistroLink 1
  ${EndIf}  
	
  ${NSD_SetText} $LabelISOSelection "Step 2: Select your $ISOFileName"
  ${NSD_SetText} $ISOFileTxt "Browse to your $ISOFileName  -->" 
  SetCtlColors $ISOFileTxt FF0000 FFFFFF  
  StrCpy $ISOTest "" ; Set to null until a new ISO selection is made 
  
; Autodetect ISO's in same folder and select if they exist  
${If} ${FileExists} "$EXEDIR\$ISOFileName"
${AndIf} $DistroName != "Try Unlisted Linux ISO (Old Syslinux)"  
${AndIf} $DistroName != "Try Unlisted Linux ISO (New Syslinux)"
${AndIf} $DistroName != "Windows Vista Installer"
${AndIf} $DistroName != "Windows 7 Installer"
${AndIf} $DistroName != "Easus Disk Copy"
  StrCpy $TheISO "$EXEDIR\$ISOFileName" 
  StrCpy $ISOFile "$TheISO"  
  EnableWindow $DownloadISO 0
  ${NSD_SetText} $DownloadISO "We Found and Selected the $FileFormat."    
  EnableWindow $ISOSelection 0 
  SetCtlColors $ISOFileTxt 009900 FFFFFF  
  ${NSD_SetText} $ISOFileTxt $ISOFile 
  ${NSD_SetText} $LabelISOSelection "Step 2 DONE: $ISOFileName Found and Selected!"  
  StrCpy $ISOTest "$TheISO" ; Populate ISOTest so we can enable Next    
  Call EnableNext   
${ElseIf} $DistroName == "Try Unlisted Linux ISO (Old Syslinux)" 
${OrIf} $DistroName == "Try Unlisted Linux ISO (New Syslinux)"
${OrIf} $DistroName == "Windows Vista Installer"
${OrIf} $DistroName == "Windows 7 Installer"
${OrIf} $DistroName == "Hiren's Boot CD"
  Call EnableNext
  ShowWindow $DownloadISO 0 
${Else}
  Call EnableNext
  EnableWindow $DownloadISO 1
  ${NSD_Uncheck} $DownloadISO  
  ${NSD_SetText} $DownloadISO "Download the $FileFormat (Optional)."   
${EndIf}  
FunctionEnd 

; On Selection of ISO File
Function ISOBrowse
 nsDialogs::SelectFileDialog open "$EXEDIR" $(IsoFile) ; set to "$EXEDIR" rather than "" an empty path..
 Pop $TheISO  
 ${NSD_SetText} $ISOFileTxt $TheISO
 SetCtlColors $ISOFileTxt 009900 FFFFFF
 EnableWindow $DownloadISO 0
 ${NSD_SetText} $DownloadISO "Local $FileFormat Selected." 
 StrCpy $ISOTest "$TheISO" ; Populate ISOTest so we can enable Next 
 StrCpy $ISOFile "$TheISO" 
 Call EnableNext
FunctionEnd

; On selection of USB Drive
Function OnSelectDrive
  Pop $DestDriveTxt
  ${NSD_GetText} $DestDriveTxt $0
  StrCpy $DestDrive "$0"
  StrCpy $DestDisk $DestDrive -1 ; Set DestDisk to drive letter plus colon
  Call SetSpace
  Call CheckSpace
  Call EnableNext
FunctionEnd

Function DrivesList
	SendMessage $DestDriveTxt ${CB_ADDSTRING} 0 "STR:$9"
	Push 1 ; must push something - see GetDrives documentation
FunctionEnd

Function FreeDiskSpace
${If} $FormatMe == "Yes"
${DriveSpace} "$0" "/D=T /S=M" $1
${Else}
${DriveSpace} "$0" "/D=F /S=M" $1
${EndIf}
FunctionEnd

Function TotalSpace
${DriveSpace} "$0" "/D=T /S=M" $1 ; used to find total space of disk
FunctionEnd

Function CheckSpace ; Check total available space so we can set block size
  Call TotalSpace
  ${If} $1 <= 511
  StrCpy $BlockSize 1
  ${ElseIf} $1 >= 512
  ${AndIf} $1 <= 8191
  StrCpy $BlockSize 4
  ${ElseIf} $1 >= 8192 
  ${AndIf} $1 <= 16383
  StrCpy $BlockSize 8
  ${ElseIf} $1 >= 16384
  ${AndIf} $1 <= 32767
  StrCpy $BlockSize 16
  ${ElseIf} $1 > 32768
  StrCpy $BlockSize 32
  ${EndIf}
  ;MessageBox MB_ICONSTOP|MB_OK "$0 Drive is $1 MB in size, blocksize = $BlockSize KB."  
FunctionEnd

Function SetSpace ; Set space available for persistence
  StrCpy $0 '$0'
  Call FreeDiskSpace
  IntOp $MaxPersist 4090 + $CasperSize ; Space required for distro and 4GB max persistent file
 ${If} $1 > $MaxPersist ; Check if more space is available than we need for distro + 4GB persistent file
  StrCpy $RemainingSpace 4090 ; Set maximum possible value to 4090 MB (any larger wont work on fat32 Filesystem)
 ${Else}
  StrCpy $RemainingSpace "$1"
  IntOp $RemainingSpace $RemainingSpace - $SizeOfCasper ; Remaining space minus distro size
 ${EndIf}
  IntOp $RemainingSpace $RemainingSpace - 1 ; Subtract 1MB so that we don't error for not having enough space
  SendMessage $CasperSlider ${TBM_SETRANGEMAX} 1 $RemainingSpace ; Re-Setting Max Value
FunctionEnd

Function HaveSpace ; Check space required before installing
  Call CasperSize
  StrCpy $0 '$0' ; check how much free space is left
  Call FreeDiskSpace
  StrCpy $2 $SizeOfCasper ; Free space required by you (in MB)
  System::Int64Op $1 > $2 ; Compare the space required and the space available
  Pop $3 ; Get the result ...
  IntCmp $3 1 okay ; ... and compare it
  MessageBox MB_ICONSTOP|MB_OK "Oops: There is not enough Free disk space! $1 MB of $2 MB Needed on $0 Drive."
  quit ; Close the program if the disk space was too small...
  okay: ; Proceed to execute...
FunctionEnd

Function DoSyslinux ; Install Syslinux on chosen USB 
  SetShellVarContext all
  InitPluginsDir
  File /oname=$PLUGINSDIR\syslinux.exe "syslinux.exe"
  File /oname=$PLUGINSDIR\syslinuxnew.exe "syslinuxnew.exe"
  File /oname=$PLUGINSDIR\7zG.exe "7zG.exe"
  File /oname=$PLUGINSDIR\7z.dll "7z.dll"  
  File /oname=$PLUGINSDIR\chain.c32 "chain.c32"  
  
  DetailPrint $(ExecuteSyslinux)
  ExecWait '$PLUGINSDIR\$SysLinVer -maf $DestDisk' $R8
  DetailPrint "Syslinux Errors $R8"
  Banner::destroy
  ${If} $R8 != 0
  MessageBox MB_ICONEXCLAMATION|MB_OK $(WarningSyslinux)
  ${EndIf} 
FunctionEnd

Function 7zExtractor ; Extract files from archive
  ${If} $DistroName == "XBMC"
  DetailPrint $(Extract)
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$ISOFile" -o"$EXEDIR" -y' 
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$EXEDIR\xbmc*.iso" -o"$DestDrive" -y -x![BOOT]*' 
  ${ElseIf} $DistroName == "GEEXBOX"
  DetailPrint $(Extract)
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$ISOFile" -ir!GEEXBOX -o"$DestDrive" -y -x![BOOT]*'
  CopyFiles "$DestDrive\GEEXBOX\*" "$DestDrive"
  CopyFiles "$DestDrive\boot\*" "$DestDrive"
  Rename "$DestDrive\isolinux.cfg" "$DestDrive\syslinux.cfg"
;  ${ElseIf} $DistroName == "EASUS Disk Copy"
;  DetailPrint $(Extract)
;  ExecWait '"$PLUGINSDIR\7zG.exe" x "$ISOFile" -o"$EXEDIR" -y -x![BOOT]*'
;  ExecWait '"$PLUGINSDIR\7zG.exe" x "DiskCopy2.3.iso" -o"$DestDrive" -y -x![BOOT]*'
  ${ElseIf} $DistroName == "Hiren's Boot CD"
  DetailPrint $(Extract)
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$ISOFile" -o"$EXEDIR\TEMP" -y -x![BOOT]*'
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$EXEDIR\TEMP\Hiren*.iso" -o"$DestDrive" -y -x![BOOT]*'  
  RMDir /R "$EXEDIR\TEMP"
  ${Else}
  DetailPrint $(Extract)
  ExecWait '"$PLUGINSDIR\7zG.exe" x "$ISOFile" -o"$DestDrive" -y -x![BOOT]*'
  ${EndIf}
FunctionEnd  

; Custom Includes
!include "CasperScript.nsh" 
!include "Distros.nsh" ; ##################################### ADD NEW DISTRO ########################################

; ---- Let's Do This Stuff ----
Section 
${If} $FormatMe == "Yes" 
MessageBox MB_YESNO|MB_ICONEXCLAMATION "${NAME} is Ready to perform the following actions:$\r$\n$\r$\n1.) Close Explorer Windows - Allows ($DestDisk) to be Fat32 Formatted!$\r$\n$\r$\n2.) Fat32 Format ($DestDisk) - All Data will be Irrecoverably Deleted!$\r$\n$\r$\n3.) Create a Syslinux MBR on ($DestDisk) - Existing MBR will be Overwritten!$\r$\n$\r$\n4.) Install ($DistroName) on ($DestDisk)$\r$\n$\r$\nAre you absolutely positive Drive ($DestDisk) is your USB Device?$\r$\nDouble Check with Windows (My Computer) to make sure!$\r$\n$\r$\nClick YES to perform these actions on ($DestDisk) or NO to Abort." IDYES proceed
Quit
${Else}
MessageBox MB_YESNO|MB_ICONEXCLAMATION "${NAME} is Ready to perform the following actions:$\r$\n$\r$\n1.) Create a Syslinux MBR on ($DestDisk) - Existing MBR will be Overwritten!$\r$\n$\r$\n2.) Install ($DistroName) on ($DestDisk)$\r$\n$\r$\nAre you absolutely positive Drive ($DestDisk) is your USB Device?$\r$\nDouble Check with Windows (My Computer) to make sure!$\r$\n$\r$\nClick YES to perform these actions on ($DestDisk) or NO to Abort." IDYES proceed
Quit
${EndIf}
proceed:
${If} ${FileExists} "$DestDisk\windows\system32" ; To add additional safeguard from user ignorance.
MessageBox MB_ICONSTOP|MB_OK "ABORTING! ($DestDisk) contains a WINDOWS/SYSTEM32 Directory."
Quit
${Else}
 Call FormatYes ; Format the Drive?
 Call HaveSpace ; Got enough Space? Lets Check!
 Call DoSyslinux ; Install Syslinux on the drive
 Call 7zExtractor ; Extract the ISO
!insertmacro Distros
${EndIf}
SectionEnd

; --- Stuff to do at startup of script ---
Function .onInit
 StrCpy $FileFormat "iso"
 userInfo::getAccountType
  Pop $Auth
   strCmp $Auth "Admin" done
    Messagebox MB_OK|MB_ICONINFORMATION "Currently you're trying to run this program as: $Auth$\r$\n$\r$\nYou must run this program with administrative rights...$\r$\n$\r$\nRight click the file and select Run As Administrator or Run As (and select an administrative account)!"
  abort
 done:
FunctionEnd

Function onNotify_CasperSlider
Pop $Casper
SendMessage $CasperSlider ${TBM_GETPOS} 0 0 $Casper ; Get Trackbar position
${NSD_SetText} $SlideSpot "$Casper MB"
FunctionEnd