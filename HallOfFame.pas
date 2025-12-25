unit HallOfFame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmHallOfFame = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    txtName1: TEdit;
    txtScore1: TEdit;
    txtName2: TEdit;
    txtScore2: TEdit;
    txtName3: TEdit;
    txtScore3: TEdit;
    txtName4: TEdit;
    txtScore4: TEdit;
    txtName5: TEdit;
    txtScore5: TEdit;
    btnOkay: TButton;
    procedure btnOkayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHallOfFame: TfrmHallOfFame;

implementation

{$R *.DFM}



procedure TfrmHallOfFame.btnOkayClick(Sender: TObject);
begin
     Close
end;

end.
