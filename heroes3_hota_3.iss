; heroes3_hota_3.iss — установщик готовой папки Heroes 3 HotA + HD (Inno Setup 7)
;
; Скрипт лежит в подпапке _ISS папки игры и упаковывает всю папку игры, кроме
; сохранений (games), деинсталлятора (Uninstall_HotA) и готовых сборок (_ISS\Output).
; Папка _ISS сама попадает в установку, поэтому инсталлер можно пересобрать
; из любой установленной копии: добавь карты в Maps, открой этот файл
; в Inno Setup 7 и нажми Ctrl+F9. Готовый setup появится в _ISS\Output.
; Если Inno Setup не установлен — его установщик лежит здесь же (innosetup-*.exe).
;
; Внешний вид и галочки повторяют оригинальный установщик HotA:
; картинки вырезаны с его скриншотов, иконка взята из его деинсталлятора.

; Папка игры = папка на уровень выше этого скрипта (работает из любого места)
#define ProjDir    RemoveBackslashUnlessRoot(SourcePath)
#define SrcDir     ExtractFileDir(ProjDir)
#define ProjName   ExtractFileName(ProjDir)
#define UninstDir  "Uninstall_HotA"

; Версии для текста «Программа установит HotA 1.8.1 + HD 5.8 R20 ...» берутся
; из самой игры, поэтому после автообновления их не нужно править вручную:
; HotA — из HotA_Setup.ini, HD — из описания HD3_Update.exe ("HoMM3 HD+ 5.8 R20 Update")
#define HotAVer    ReadIni(SrcDir + "\HotA_Setup.ini", "Version", "Main Version", "1.8")
#define HDUpdExe   SrcDir + "\_HD3_Data\HD3_Update.exe"
#define HDVer      FileExists(HDUpdExe) ? Trim(StringChange(StringChange(StringChange(GetStringFileInfo(HDUpdExe, PRODUCT_NAME), "HoMM3 HD+", ""), "HoMM3 HD", ""), "Update", "")) : ""

#define MyAppName  "HotA + HD"
; Куда ведёт ярлык игры в меню «Пуск»: HotA_launcher.exe, HD_Launcher.exe или "h3hota HD.exe"
#define MainExe    "HotA_launcher.exe"

[Setup]
; Свой AppId, чтобы не смешиваться с официальным установщиком HotA ("HotA + HD")
AppId=Heroes3_HotA_HD
AppName={#MyAppName}
AppVersion={#HotAVer}
#if HDVer != ""
AppVerName=HotA {#HotAVer} + HD {#HDVer}
#else
AppVerName=HotA {#HotAVer} + HD
#endif
AppPublisher=HotA Repack
UninstallDisplayName=Heroes of Might and Magic® III: Horn of the Abyss
UninstallDisplayIcon={app}\h3hota.exe
UninstallFilesDir={app}\{#UninstDir}
DefaultDirName={sd}\Games\Heroes3_HotA
DefaultGroupName=Heroes 3 HotA
DisableProgramGroupPage=yes
DisableWelcomePage=no
; Всегда спрашивать папку установки, как в оригинале. По умолчанию Inno Setup 6+
; пропускает эту страницу, если игра уже установлена, и молча ставит в ту же папку.
DisableDirPage=no
; Без запроса UAC. Игра пишет сохранения и настройки в свою папку,
; поэтому в Program Files её ставить не нужно (там установка и запрещена, см. [Code]).
PrivilegesRequired=lowest
ChangesAssociations=yes
OutputDir=Output
OutputBaseFilename=Heroes3_HotA_{#HotAVer}_Setup
SetupIconFile=HotA.ico
; Классический вид, как у оригинала (Inno Setup 5): окно прежнего размера,
; картинки показываются в родном размере по центру, без растягивания
WizardStyle=classic
WizardSizePercent=100
WizardImageFile=WizardImage.bmp
WizardSmallImageFile=WizardSmallImage.bmp
WizardImageStretch=no
Compression=lzma2
SolidCompression=yes
ShowLanguageDialog=auto

[Languages]
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
; Тексты взяты из оригинального установщика HotA
ru.FileExtensions=Расширения файлов:
ru.Associateh3t=Связать редактор RMG-шаблонов HotA с файлами, имеющими расширение .h3t
ru.Associateh3m=Связать редактор карт HotA с файлами, имеющими расширение .h3m
ru.Associateh3c=Связать редактор кампаний HotA с файлами, имеющими расширение .h3c
ru.TaskEnableAutoUpd=Активировать автоматическое обновление
ru.TaskCreateShortcut=Создать ярлык на рабочем столе
ru.ProgramFiles=Игра может работать некорректно в системной папке Program Files.%nПожалуйста, выберите другую папку.
ru.MapEditor=Редактор карт
en.FileExtensions=File extensions:
en.Associateh3t=Associate the HotA RMG template editor with the .h3t file extension
en.Associateh3m=Associate the HotA map editor with the .h3m file extension
en.Associateh3c=Associate the HotA campaign editor with the .h3c file extension
en.TaskEnableAutoUpd=Enable automatic updates
en.TaskCreateShortcut=Create a desktop shortcut
en.ProgramFiles=The game may not work correctly in the system Program Files folder.%nPlease choose a different folder.
en.MapEditor=Map Editor

[Tasks]
; Имена задач — как в оригинальном установщике
Name: "h3tassociation"; Description: "{cm:Associateh3t}"; GroupDescription: "{cm:FileExtensions}"
Name: "h3massociation"; Description: "{cm:Associateh3m}"; GroupDescription: "{cm:FileExtensions}"
Name: "h3cassociation"; Description: "{cm:Associateh3c}"; GroupDescription: "{cm:FileExtensions}"
Name: "autoupdates"; Description: "{cm:TaskEnableAutoUpd}"
Name: "createshortcut"; Description: "{cm:TaskCreateShortcut}"; Flags: unchecked

[Files]
; Вся папка игры, кроме сохранений, деинсталлятора и готовых сборок инсталлера.
; Проект инсталлера (_ISS) тоже устанавливается, чтобы его можно было пересобрать.
Source: "{#SrcDir}\*"; DestDir: "{app}"; Excludes: "\games,\{#UninstDir},\{#ProjName}\Output"; Flags: ignoreversion recursesubdirs createallsubdirs

[Dirs]
; Пустая папка games, чтобы игре было куда сохраняться
Name: "{app}\games"

[INI]
; Галочка «Активировать автоматическое обновление»
Filename: "{app}\HotA_Setup.ini"; Section: "Global Settings"; Key: "AutoUpdate"; String: "true"; Tasks: autoupdates
Filename: "{app}\HotA_Setup.ini"; Section: "Global Settings"; Key: "AutoUpdate"; String: "false"; Tasks: not autoupdates

[Registry]
; Ассоциации файлов — те же ProgID, что у оригинала, но для текущего пользователя
Root: HKA; Subkey: "Software\Classes\.h3t"; ValueType: string; ValueName: ""; ValueData: "hota_rmg_template"; Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: h3tassociation
Root: HKA; Subkey: "Software\Classes\hota_rmg_template"; ValueType: string; ValueName: ""; ValueData: "HotA RMG Template"; Flags: uninsdeletekey; Tasks: h3tassociation
Root: HKA; Subkey: "Software\Classes\hota_rmg_template\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\h3hota_tmpled.exe,0"; Tasks: h3tassociation
Root: HKA; Subkey: "Software\Classes\hota_rmg_template\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\h3hota_tmpled.exe"" ""%1"""; Tasks: h3tassociation

Root: HKA; Subkey: "Software\Classes\.h3m"; ValueType: string; ValueName: ""; ValueData: "h3m_auto_file"; Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: h3massociation
Root: HKA; Subkey: "Software\Classes\h3m_auto_file"; ValueType: string; ValueName: ""; ValueData: "Heroes 3 Map File"; Flags: uninsdeletekey; Tasks: h3massociation
Root: HKA; Subkey: "Software\Classes\h3m_auto_file\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\h3hota_maped.exe,0"; Tasks: h3massociation
Root: HKA; Subkey: "Software\Classes\h3m_auto_file\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\h3hota_maped.exe"" ""%1"""; Tasks: h3massociation

Root: HKA; Subkey: "Software\Classes\.h3c"; ValueType: string; ValueName: ""; ValueData: "h3c_auto_file"; Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: h3cassociation
Root: HKA; Subkey: "Software\Classes\h3c_auto_file"; ValueType: string; ValueName: ""; ValueData: "Heroes 3 Campaign File"; Flags: uninsdeletekey; Tasks: h3cassociation
Root: HKA; Subkey: "Software\Classes\h3c_auto_file\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\h3hota_cmped.exe,0"; Tasks: h3cassociation
Root: HKA; Subkey: "Software\Classes\h3c_auto_file\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\h3hota_cmped.exe"" ""%1"""; Tasks: h3cassociation

[Icons]
Name: "{group}\Heroes 3 HotA"; Filename: "{app}\{#MainExe}"; WorkingDir: "{app}"
Name: "{group}\HD Launcher"; Filename: "{app}\HD_Launcher.exe"; WorkingDir: "{app}"
Name: "{group}\{cm:MapEditor}"; Filename: "{app}\h3hota_maped.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\Heroes 3 HotA"; Filename: "{app}\HD_Launcher.exe"; WorkingDir: "{app}"; Tasks: createshortcut

[Run]
; После установки запускаем HD Launcher
Filename: "{app}\HD_Launcher.exe"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

[Code]
function IsInsideDir(const Path, Dir: String): Boolean;
begin
  Result := Pos(Uppercase(AddBackslash(Dir)), Uppercase(AddBackslash(Path))) = 1;
end;

// Как в оригинале: не даём ставить игру в Program Files
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if (CurPageID = wpSelectDir) and
     (IsInsideDir(WizardDirValue, ExpandConstant('{commonpf32}')) or
      (IsWin64 and IsInsideDir(WizardDirValue, ExpandConstant('{commonpf64}')))) then
  begin
    SuppressibleMsgBox(CustomMessage('ProgramFiles'), mbError, MB_OK, IDOK);
    Result := False;
  end;
end;

// Стрелки на кнопках «< Назад» и «Далее >», как у оригинала
// (Inno Setup 6+ убирает их из текстов сообщений)
procedure CurPageChanged(CurPageID: Integer);
begin
  WizardForm.BackButton.Caption := '< ' + SetupMessage(msgButtonBack);
  if WizardForm.NextButton.Caption = SetupMessage(msgButtonNext) then
    WizardForm.NextButton.Caption := SetupMessage(msgButtonNext) + ' >';
end;
