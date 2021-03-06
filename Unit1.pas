unit Unit1;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,bass, ExtCtrls, AdvTrackBar, Buttons, StdCtrls, XPMan, ComCtrls, ToolWin, ActnMan,
  ActnCtrls, ActnMenus, WinXP, DateUtils, Menus, AdvMenus, AdvMenuStylers;

type
  //String = PWideChar;
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    BitBtn2: TBitBtn;
    Pause: TBitBtn;
    GroupBox1: TGroupBox;
    AdvTrackBar1: TAdvTrackBar;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    AdvTrackBar2: TAdvTrackBar;
    Timer1: TTimer;
    WinXP1: TWinXP;
    Label1: TLabel;
    Button2: TButton;
    BitBtn1: TBitBtn;
    AdvMainMenu1: TAdvMainMenu;
    AdvMenuStyler1: TAdvMenuStyler;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    WindowTopmost: TMenuItem;
    AdvMenuFantasyStyler1: TAdvMenuFantasyStyler;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvTrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AdvTrackBar2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AdvTrackBar2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvTrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvTrackBar2Click(Sender: TObject);
    procedure AdvTrackBar2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenDialog1Show(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure WindowTopmostClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    hMusic:HMUSIC;
    IsStoped:boolean;
    TrackLength:QWORD;
    Timer1Enabled:boolean;
    TimeMode:DWORD;
    MaxLength:longint;
    isWindowTopMost:boolean;
  public
    { Public declarations }
    procedure FormToBack;
    procedure FormToTop;
  end;

var
  Form1: TForm1;
  function GetFileSize(FileName: String): Integer;
  function SecToTime(Sec: Integer): TTime;
  procedure Dos2Win(CmdLine:String; OutMemo:TMemo); 

implementation

uses  Unit3;

{$R *.dfm}

procedure TForm1.FormToBack;
begin
  isWindowTopmost:=WindowTopmost.Checked;
  WindowTopmost.Checked:=false;
  WindowTopMostClick(Nil);
end;

procedure TForm1.FormToTop;
begin
  WindowTopmost.Checked:=isWindowTopmost;
  WindowTopmostClick(Nil);
end;

procedure Dos2Win(CmdLine:String; OutMemo:TMemo);
const BUFSIZE = 2000; 
var SecAttr    : TSecurityAttributes; 
    hReadPipe,
    hWritePipe : THandle;
    StartupInfo: TStartUpInfo; 
    ProcessInfo: TProcessInformation; 
    Buffer     : PAnsiChar;
    WaitReason, 
    BytesRead  : DWord; 
begin 

 with SecAttr do 
 begin 
   nlength              := SizeOf(TSecurityAttributes);
   binherithandle       := true;
   lpsecuritydescriptor := nil; 
 end; 
 // Creazione della pipe 
 if Createpipe (hReadPipe, hWritePipe, @SecAttr, 0) then 
 begin 
   Buffer  := AllocMem(BUFSIZE + 1);    // Allochiamo un buffer di dimensioni BUFSIZE+1 
   FillChar(StartupInfo, Sizeof(StartupInfo), #0); 
   StartupInfo.cb          := SizeOf(StartupInfo); 
   StartupInfo.hStdOutput  := hWritePipe; 
   StartupInfo.hStdInput   := hReadPipe; 
   StartupInfo.dwFlags     := STARTF_USESTDHANDLES + 
                              STARTF_USESHOWWINDOW; 
   StartupInfo.wShowWindow := SW_HIDE; 

   if CreateProcess(nil, 
      PChar(CmdLine), 
      @SecAttr, 
      @SecAttr, 
      true, 
      NORMAL_PRIORITY_CLASS, 
      nil, 
      nil, 
      StartupInfo, 
      ProcessInfo) then 
     begin 
       // Attendiamo la fine dell'esecuzione del processo 
       repeat 
         WaitReason := WaitForSingleObject( ProcessInfo.hProcess,100);
         Application.ProcessMessages;
       until (WaitReason <> WAIT_TIMEOUT);
       // Leggiamo la pipe 
       Repeat 
         BytesRead := 0; 
         // Leggiamo "BUFSIZE" bytes dalla pipe 
         ReadFile(hReadPipe, Buffer[0], BUFSIZE, BytesRead, nil);
         // Convertiamo in una stringa "\0 terminated" 
         Buffer[BytesRead]:= #0; 
         // Convertiamo i caratteri da DOS ad ANSI
         OemToAnsi(Buffer,Buffer);

         // Scriviamo nell' "OutMemo" l'output ricevuto tramite pipe 
         OutMemo.text := OutMemo.text + String(Buffer);
       until (BytesRead < BUFSIZE); 
     end; 
   FreeMem(Buffer); 
   CloseHandle(ProcessInfo.hProcess); 
   CloseHandle(ProcessInfo.hThread); 
   CloseHandle(hReadPipe); 
   CloseHandle(hWritePipe); 
 end; 
end; 


function SecToTime(Sec: Integer): TTime;
var
  H, M, S: INTEGER;
  HS, MS, SS: string;
begin
  S := Sec;
  M := Round(INT(S / 60));
  S := S - M * 60; //Seconds
  H := Round(INT(M / 60)); //Hours
  M := M - H * 60; //Minutes
  if H < 10 then
    HS := '0' + Inttostr(H)
  else
    HS := inttostr(H);
  if M < 10 then
    MS := '0' + Inttostr(M)
  else
    MS := inttostr(M);
  if S < 10 then
    SS := '0' + inttostr(S)
  else
    SS := inttostr(S);
  RESULT := StrToTime(HS + ':' + MS + ':' + SS);
end;

function GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  try
    FS := TFileStream.Create(Filename, fmOpenRead);
  except
    Result := -1;
  end;
  if Result <> -1 then Result := FS.Size;
  FS.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  hMusic:=0;
  {if(not BASS_Init(-1,44100,BASS_DEVICE_CPSPEAKERS,Form1.Handle,0)) then
  begin
    ShowMessage('Error init device');
  end;
  }
  if(not BASS_Init
    (
      -1,
      44100,
      BASS_DEVICE_CPSPEAKERS,
      0,
      0
      )) then
  begin
    ShowMessage('Error init device');
  end;
  //Form3.BitBtn1Click(Form3.BitBtn1);
  BASS_PluginLoad('bassmidi.dll',BASS_UNICODE);
  BASS_PluginLoad('bassflac.dll',BASS_UNICODE);
  BASS_PluginLoad('bass_alac.dll',BASS_UNICODE);
  IsStoped:=false;
  AdvTrackBar1.Position:=trunc(BASS_GetVolume*10000);
  AdvTrackBar1.OnChange(AdvTrackBar1);
  {
  BitBtn1.Width:=BitBtn1.Glyph.Width;
  BitBtn1.Height:=BitBtn1.Glyph.Height;
  BitBtn2.Width:=BitBtn2.Glyph.Width;
  BitBtn2.Height:=BitBtn2.Glyph.Height;
  Pause.Width:=Pause.Glyph.Width;
  Pause.Height:=Pause.Glyph.Height;
   }




   end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FormToBack;
  WindowTopmost.Checked:=false;
  if(OpenDialog1.Execute) then
  begin
    FormToTop;
    Pause.Click;
    ISSTOPED:=true;
    Edit1.Text:=OpenDialog1.FileName;
    


  end
  else FormToTop;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  FilterIndex:integer;
  Console:TMemo;
  tmp:string;
  ps:integer;
begin

  if(isStoped) then
  begin
    BASS_MusicFree(hMusic);
    BASS_StreamFree(hMusic);
    FilterIndex:=OpenDialog1.FilterIndex;
    if(FilterIndex>2) then
    begin
      Console:=TMemo.Create(Application);
      Dos2Win('"utils\bin\file.exe" -i '+'"'+Form1.OpenDialog1.FileName+'"',Console);
      if(Console.Text='') then
      begin
        //MessageBox(Form1.Handle,'','',MB_OK or MB_ICONWARNING);
        //Console.Free;
        //break;
        FilterIndex:=1;
      end
      else
      begin
        //ShowMessage(Console.Text);
        tmp:=Console.Text;
        ps:=pos(';',tmp);
        delete(tmp,1,ps+1);
        tmp:=copy(tmp,1,pos(';',tmp)-1);
        ps:=pos('/',tmp);
        Console.Text:=copy(tmp,1,ps-1);
        tmp:=copy(tmp,ps+1,length(tmp)-ps+1);

        if(Console.Text='audio')and(tmp='x-mod') then FilterIndex:=2
        else if(Console.Text='audio')or(Console.Text='application') then FilterIndex:=1
        else FilterIndex:=-1;
        //ShowMessage(Console.text+#13#10+tmp+#13+#10+IntToStr(FilterIndex));
      end;
      Console.Free;
    end;
    case FilterIndex of
      1:
      begin

        hMusic:=BASS_StreamCreateFile
        (
          false,
          PChar(OpenDialog1.FileName),
          0,
          0,
          BASS_STREAM_PRESCAN or BASS_UNICODE
        );
        TimeMode:=BASS_POS_BYTE;


      end;
      2:
      begin

        hMusic:=BASS_MusicLoad
        (
          false,
          PChar(OpenDialog1.FileName),
          0,
          0,
          BASS_SAMPLE_8BITS or BASS_MUSIC_PRESCAN or BASS_UNICODE,
          0
        );
        TimeMode:=BASS_POS_BYTE;
      end;
     else
      begin
        MessageBox(Form1.Handle,'������ ������ ����� �� ��������������','������',MB_OK or MB_ICONWARNING);
        Exit;
      end;

    end;
    //ShowMessage(IntToStr(hMusic));
    if(hMusic in [0,BASS_ERROR_FILEFORM,BASS_ERROR_CODEC,BASS_ERROR_FORMAT]) then
    begin

      MessageBox(Form1.Handle,PChar('������ ���� �� ����� ���� �������������'+': '+IntToStr(BASS_ErrorGetCode)),'������',MB_OK or MB_ICONINFORMATION);
      hMusic:=0;
      Exit;
    end;
    TrackLength:=BASS_ChannelGetLength(hMusic,TimeMode);
    AdvTrackBar2.Max:=trunc(BASS_ChannelBytes2Seconds(hMusic,TrackLength));
    ISSTOPED:=false;
  end;
  if(hMusic=0) then Button1.Click;
  if(hMusic=0) then Exit;

  BASS_ChannelPlay(hMusic,ISSTOPED);
  IsStoped:=false;
  Timer1.Enabled:=true;
  Timer2.Enabled:=true;
  Timer1Timer(Timer1);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  IsStoped:=true;
  BitBtn2.Click;
  
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin    
  BASS_ChannelPause(hMusic);
  Timer1.Enabled:=false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

    BASS_Free();
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BASS_ChannelStop(hMusic);
end;

procedure TForm1.AdvTrackBar1Change(Sender: TObject);
begin
  BASS_SetVolume((AdvTrackBar1.Position/10000));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  p:QWORD;
begin
  p:=trunc(BASS_ChannelBytes2Seconds(hMusic,BASS_ChannelGetPosition(hMusic,TimeMode)));
  try
    Label1.Caption:=TimeToStr(SecToTime(p));
    AdvTrackBar2.TrackLabel.Format:=TimeToStr(SecToTime(p));
    AdvTrackBar2.Position:=p;
  except
    on E:EConvertError do;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  fft:array[0..4096-1] of float;
  I,g,z,j: Integer;
  data:extended;
  bmp:TBitMap;
  lw,lh:integer;
begin
  if(not Timer1.Enabled) then
  begin
    //Timer2.Enabled:=false;
    Exit;
  end;
  bmp:=TBitMap.Create;
  bmp.Width:=320;
  bmp.Height:=240;
  if(BASS_ChannelIsActive(hMusic)<>BASS_ACTIVE_PLAYING) then
  begin
    Timer2.Enabled:=false;
    Exit;
  end;
  ZeroMemory(@fft,4096);
  BASS_ChannelGetData(hMusic,@fft,BASS_DATA_FFT8192);

  i:=0;
  g:=512;
  //ListBox1.Items.Clear;
  lw:=trunc(320/(4096/256));
  bmp.Canvas.Brush.Color:=clWhite;
  bmp.Canvas.FillRect(Rect(0,0,bmp.Width,bmp.Height));
  while(i<=320-lw)and(g<4096)do
  begin
    //ListBox1.Items.Clear;
    data:=0;
    with bmp.Canvas do
    begin
      for z:=g-128+1 to g-1 do
        data:=data+fft[z];
      data:=Round(data*230);
      if(data>230) then data:=230;
      Pen.Width:=3;
      Pen.Color:=clBlack;
      Brush.Color:=clGreen;
      //Pixels[i,Round(fft[g]*230)]:=clBlack;
      Rectangle(i,abs(220-Round(data))+10,i+lw,240);
      //ListBox1.Items.Add(FloatToStr(Round(data)));
    end;
    //ListBox1.Items.Add(FloatToStr(data));
    //ListBox1.Items.Add(FloatToStr(fft[i]));
    i:=i+lw;
    g:=g+128;
  end;
  Canvas.Draw(310,10,bmp);
  bmp.Free;
end;

procedure TForm1.AdvTrackBar2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer1.Enabled:=false;
end;

procedure TForm1.AdvTrackBar2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Timer1Enabled:=Timer1.Enabled;
  Timer1.Enabled:=false;
end;

procedure TForm1.AdvTrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if(not Timer1.Enabled)and(hMusic<>0) then
  Begin
    BASS_ChannelSetPosition(hMusic,BASS_ChannelSeconds2Bytes(hMusic,AdvTrackBar2.Position),TimeMode);
    Timer1Timer(Timer1);
  end;
  Timer1.Enabled:=Timer1Enabled;
end;

procedure TForm1.AdvTrackBar2Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
end;

procedure TForm1.AdvTrackBar2Change(Sender: TObject);
begin
  if(not Timer1.Enabled)and(hMusic<>0) then
  Begin
    BASS_ChannelSetPosition(hMusic,BASS_ChannelSeconds2Bytes(hMusic,AdvTrackBar2.Position),TimeMode);
    Timer1Timer(Timer1);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SetWindowLong(Form1.Handle,GWL_EXSTYLE,GetWindowLong(Form1.Handle,GWL_EXSTYLE) or WS_EX_LAYERED);
  Form3.AdvTrackBar1.Position:=245;
  Form3.AdvTrackBar1Change(Form3.AdvTrackBar1);
  SetLayeredWindowAttributes(Form1.Handle,0,245,LWA_ALPHA);
  WindowTopmostClick(Nil);

end;

procedure TForm1.OpenDialog1Show(Sender: TObject);
begin
 // SetWindowLong(OpenDialog1.Handle,GWL_EXSTYLE,GetWindowLong(Form1.Handle,GWL_EXSTYLE) or WS_EX_LAYERED);
 // SetLayeredWindowAttributes(OpenDialog1.Handle,0,220,LWA_ALPHA);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //Form2.Show;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  FormToBack;
  Form3.ShowModal;

  FormToTop;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  BitBtn1.Click;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  if(WindowTopmost.Checked) then SetWindowPos(Form1.Handle,HWND_TOPMOST,Left,Top,Width,Height,0);
end;

procedure TForm1.WindowTopmostClick(Sender: TObject);
begin
  if(Sender=WindowTopmost) then WindowTopmost.Checked:=not WindowTopmost.Checked;
  if(not WindowTopmost.Checked) then SetWindowPos(Form1.Handle,HWND_NOTOPMOST,Left,Top,Width,Height,0)
  else FormPaint(Form1);
end;

end.
