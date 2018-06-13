program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Form3:=TForm3.Create(Application);
  Application.Title := 'BeBoo Mod Player';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
