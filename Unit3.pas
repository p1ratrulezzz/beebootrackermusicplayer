unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,bass, Buttons, ComCtrls, AdvTrackBar;

type
  TForm3 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    BitBtn1: TBitBtn;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    AdvTrackBar1: TAdvTrackBar;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure AdvTrackBar1Change(Sender: TObject);
    procedure AdvTrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvTrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    WindowLong:DWORD;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
var
  info:BASS_DEVICEINFO;
  i:integer;
begin
  ComboBox1.Items.Clear;
  i:=0;
  //ComboBox1.Items.Add('Устройство по умолчанию');
  while(BASS_GetDeviceInfo(i,info)) do
  begin
    ComboBox1.Items.Add(info.name);
    inc(i);

  end;

  ComboBox1.ItemIndex:=BASS_GetDevice;
  Label2.Caption:=IntToStr(trunc(AdvTrackbar1.Min*100/255))+'%';
  
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
begin
  //Form1.Pause.Click;
  BASS_Stop;
  BASS_SetDevice(ComboBox1.ItemIndex);
  {if(not BASS_Init
    (
      ComboBox1.ItemIndex,
      44100,
      BASS_DEVICE_CPSPEAKERS,
      0,
      0
      )) then
  begin
    ShowMessage('Error init device');
  end;}
  //BASS_Update(1000);
  BASS_Start;
end;

procedure TForm3.AdvTrackBar1Change(Sender: TObject);
begin
  //SetWindowLong(Form1.BitBtn1.Handle,GWL_EXSTYLE,GetWindowLong(Button1.Handle,GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Form1.Handle,0,AdvTrackBar1.Position,ULW_ALPHA);
  SetLayeredWindowAttributes(Form3.Handle,0,5,ULW_ALPHA);
  AdvTrackBar1.TrackLabel.Format:=IntToStr(trunc(AdvTrackBar1.Position*100/255))+'%%';

end;

procedure TForm3.AdvTrackBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  WindowLong:=GetWindowLong(Form3.Handle,GWL_EXSTYLE);
  SetWindowLong(Form3.Handle,GWL_EXSTYLE,WindowLong or WS_EX_LAYERED);
  AdvTrackBar1.OnChange(AdvTrackBar1);
end;

procedure TForm3.AdvTrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetWindowLong(Form3.Handle,GWL_EXSTYLE,WindowLong);
end;

end.
