unit NewGame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmNewGame = class(TForm)
    Label1: TLabel;
    txtNumberOfPlayers: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewGame: TfrmNewGame;
  NumberOfPlayers: Integer;

implementation

{$R *.DFM}

procedure TfrmNewGame.Button1Click(Sender: TObject);
begin
     NumberOfPlayers:=-1;

     if txtNumberOfPlayers.Text='0' then
        NumberOfPlayers:=0
     else if txtNumberOfPlayers.Text='1' then
        NumberOfPlayers:=1
     else if txtNumberOfPlayers.Text='2' then
        NumberOfPlayers:=2
     else
        MessageDlg('Number of Players must be 0, 1, or 2!',
                   mtWarning, [mbOK], 0);

     if NumberOfPlayers>-1 then Close;
end;

end.
