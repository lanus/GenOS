; ------------ Filenames Macro --------------
!macro FileNames Distro2Check 
 ${NSD_CB_AddString} $Distro "${Distro2Check}"
!macroend

!macro SetISOFileNames Distro2Check ISO2Check Download2Get GimmeSize PersistentType SyslinuxVersion Homepage OfficialName
 ${If} $DistroName == "${Distro2Check}" 
 StrCpy $ISOFileName "${ISO2Check}" 
 StrCpy $DownLink "${Download2Get}"  ; Download Link  
 StrCpy $SizeOfCasper "${GimmeSize}" ; Space neeeded to install
 StrCpy $Persistence "${PersistentType}" ; Persistence?
 StrCpy $SysLinVer "${SyslinuxVersion}" ; Syslinux version to use
 StrCpy $Homepage "${Homepage}" ; Linux Distro Homepage
 StrCpy $OfficialName "${OfficialName}" ; Linux Distro Name for Home Page Anchor
 ${EndIf}
!macroend