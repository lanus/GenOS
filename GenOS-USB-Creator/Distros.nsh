; ------------ Distros Macro --------------

!macro Distros  
  ${If} $DistroName == "GenOS 0.2" 
  SetShellVarContext all
  InitPluginsDir
  File /oname=$PLUGINSDIR\genostxt.cfg "texts\genostxt.cfg"
  File /oname=$PLUGINSDIR\genossyslinux.cfg "texts\genossyslinux.cfg"
  DetailPrint $(CreateSysConfig) 
  Rename "$DestDisk\isolinux\" "$DestDisk\syslinux\"
  CopyFiles "$PLUGINSDIR\genossyslinux.cfg" "$DestDisk\syslinux\syslinux.cfg"
  CopyFiles "$PLUGINSDIR\genostxt.cfg" "$DestDisk\syslinux\txt.cfg" ; create new boot menu 
  Call CasperScript  
  
; ##################################### ADD NEW DISTRO ########################################
  ${EndIf} 
  SetShellVarContext all
  InitPluginsDir
  File /oname=$PLUGINSDIR\Copying.txt "Copying.txt"
  nsExec::ExecToLog '"xcopy" "Copying.txt" /f/y "$DestDisk\"' ; Copy Licenses to the drive
!macroend

Function RandomISO
${If} ${FileExists} "$DestDisk\boot\isolinux\isolinux.cfg"
  Rename "$DestDisk\boot\isolinux\" "$DestDisk\boot\syslinux\"
  Rename "$DestDisk\boot\syslinux\isolinux.cfg" "$DestDisk\boot\syslinux\syslinux.cfg"  
${EndIf} 
  
${If} ${FileExists} "$DestDisk\isolinux\isolinux.cfg"
  Rename "$DestDisk\isolinux\" "$DestDisk\syslinux\"
  Rename "$DestDisk\syslinux\isolinux.cfg" "$DestDisk\syslinux\syslinux.cfg" 
${EndIf}  
 
${If} ${FileExists} "$DestDisk\isolinux.cfg"
  Rename "$DestDisk\isolinux.cfg" "$DestDisk\syslinux.cfg" 
${EndIf}   
FunctionEnd