program Pong;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  NewGame in 'NewGame.pas' {frmNewGame},
  HallOfFame in 'HallOfFame.pas' {frmHallOfFame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNewGame, frmNewGame);
  Application.CreateForm(TfrmHallOfFame, frmHallOfFame);
  Application.Run;
end.
