{------------------------------------------------------------------------
 -
 -  PONG!
 -  A directX Delphi Application
 -  by imnes@go.com
 -  This program is PUBLIC DOMAIN, enjoy ;)
 -
 ------------------------------------------------------------------------}

unit Main;

interface

uses
  NewGame, HallOfFame,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, Menus, DXClass, StdCtrls, ExtCtrls, DXInput;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuFileHallofFame: TMenuItem;
    N1: TMenuItem;
    mnuFileExit: TMenuItem;
    Help1: TMenuItem;
    mnuHelpAbout: TMenuItem;
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    Bevel1: TBevel;
    Label1: TLabel;
    lblPlayer1Score: TLabel;
    Label2: TLabel;
    lblPlayer2Score: TLabel;
    lblFPSLabel: TLabel;
    lblFPS: TLabel;
    View1: TMenuItem;
    mnuViewShowFPS: TMenuItem;
    lblFPSTarget: TLabel;
    DXInput: TDXInput;
    Label3: TLabel;
    lblBalls: TLabel;
    Skill1: TMenuItem;
    mnuCPU1Smart: TMenuItem;
    mnuCPU2Smart: TMenuItem;
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileNewClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuFileHallofFameClick(Sender: TObject);
    procedure OnInitialize(Sender: TObject);
    procedure OnFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure mnuViewShowFPSClick(Sender: TObject);
    procedure mnuCPU1SmartClick(Sender: TObject);
    procedure mnuCPU2SmartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Player1Y, Player1Height, Player2Y, Player2Height,
  BallX, BallY, BallXV, BallYV, Player1Score, Player2Score: Integer;
  NumberOfPlayers: Integer;
  GameOver: Boolean = True;
  BallsRemaining: Integer;
  BallTargetSpeed: Integer = 20;
  HighScoreNames: array [1..5] of String;
  HighScoreScores: array [1..5] of String;

implementation

{$R *.DFM}


procedure GetHOFData;
begin

     HighScoreNames[1]:=frmHallOfFame.txtName1.Text;
     HighScoreScores[1]:=frmHallOfFame.txtScore1.Text;
     HighScoreNames[2]:=frmHallOfFame.txtName2.Text;
     HighScoreScores[2]:=frmHallOfFame.txtScore2.Text;
     HighScoreNames[3]:=frmHallOfFame.txtName3.Text;
     HighScoreScores[3]:=frmHallOfFame.txtScore3.Text;
     HighScoreNames[4]:=frmHallOfFame.txtName4.Text;
     HighScoreScores[4]:=frmHallOfFame.txtScore4.Text;
     HighScoreNames[5]:=frmHallOfFame.txtName5.Text;
     HighScoreScores[5]:=frmHallOfFame.txtScore5.Text;

end;

procedure WriteHOF;
var
   t: Text;
   i: Integer;
begin
     assign(t, 'scores.hi');
     rewrite(t);

     for i:=1 to 5 do
     begin
          writeln(t, HighScoreNames[i]);
          writeln(t, HighScoreScores[i]);
     end;

     close(t);
end;


procedure ReadHOF;
var
   t: Text;
   i: Integer;
begin
     assign(t, 'scores.hi')
     {$I-};
     reset(t);
     {$I+};
    if IOResult=0 then
    begin
     for i:=1 to 5 do
     begin
          readln(t, HighScoreNames[i]);
          readln(t, HighScoreScores[i]);
     end;
     close(t);
    end
    else
     begin
                 WriteHOF;
     end;

     frmHallOfFame.txtName1.Text:=HighScoreNames[1];
     frmHallOfFame.txtScore1.Text:=HighScoreScores[1];

     frmHallOfFame.txtName2.Text:=HighScoreNames[2];
     frmHallOfFame.txtScore2.Text:=HighScoreScores[2];

     frmHallOfFame.txtName3.Text:=HighScoreNames[3];
     frmHallOfFame.txtScore3.Text:=HighScoreScores[3];

     frmHallOfFame.txtName4.Text:=HighScoreNames[4];
     frmHallOfFame.txtScore4.Text:=HighScoreScores[4];

     frmHallOfFame.txtName5.Text:=HighScoreNames[5];
     frmHallOfFame.txtScore5.Text:=HighScoreScores[5];

           frmHallOfFame.txtName1.TabStop:=False;
           frmHallOfFame.txtName1.ReadOnly:=True;
           frmHallOfFame.txtName2.TabStop:=False;
           frmHallOfFame.txtName2.ReadOnly:=True;
           frmHallOfFame.txtName3.TabStop:=False;
           frmHallOfFame.txtName3.ReadOnly:=True;
           frmHallOfFame.txtName4.TabStop:=False;
           frmHallOfFame.txtName4.ReadOnly:=True;
           frmHallOfFame.txtName5.TabStop:=False;
           frmHallOfFame.txtName5.ReadOnly:=True;


end;

procedure CheckHOF;
var
   i: Integer;
   MySpot: Integer;
begin
     ReadHOF;
     { What's the minimum Hall of Fame score? Note: Scores are maintained in
       sequential order, highest to lowest, so this will be the last entry. }
     if ((Player1Score > StrToInt(HighScoreScores[5])) and (NumberOfPlayers >0)) then
      begin
           MessageDlg('Congradulations Player 1'+chr(13)+
                      'You''ve earned a place in the Hall of Fame!'+chr(13)+
                      'Click OK, then Enter your name!',
                      mtWarning, [mbOK], 0);

           { Where do I fit? }
           for MySpot:=1 to 5 do
                 if Player1Score > StrToInt(HighScoreScores[MySpot]) then break;

           { Bump all other entries down. }
           if(MySpot < 5) then
           for i:=4 downto MySpot do begin
               HighScoreNames[i+1]:=HighScoreNames[i];
               HighScoreScores[i+1]:=HighScoreScores[i];
           end;

           frmHallOfFame.txtName1.TabStop:=False;
           frmHallOfFame.txtName1.ReadOnly:=True;
           frmHallOfFame.txtName2.TabStop:=False;
           frmHallOfFame.txtName2.ReadOnly:=True;
           frmHallOfFame.txtName3.TabStop:=False;
           frmHallOfFame.txtName3.ReadOnly:=True;
           frmHallOfFame.txtName4.TabStop:=False;
           frmHallOfFame.txtName4.ReadOnly:=True;
           frmHallOfFame.txtName5.TabStop:=False;
           frmHallOfFame.txtName5.ReadOnly:=True;

           { Make my spot writeable. }
           if MySpot=1 then begin
              frmHallOfFame.txtName1.TabStop:=True;
              frmHallOfFame.txtName1.ReadOnly:=False;
              frmHallOfFame.txtName1.Text:='';
              frmHallOfFame.txtScore1.Text:=IntToStr(Player1Score);
           end else if MySpot=2 then begin
              frmHallOfFame.txtName2.TabStop:=True;
              frmHallOfFame.txtName2.ReadOnly:=False;
              frmHallOfFame.txtName2.Text:='';
              frmHallOfFame.txtScore2.Text:=IntToStr(Player1Score);
           end else if MySpot=3 then begin
              frmHallOfFame.txtName3.TabStop:=True;
              frmHallOfFame.txtName3.ReadOnly:=False;
              frmHallOfFame.txtName3.Text:='';
              frmHallOfFame.txtScore3.Text:=IntToStr(Player1Score);
           end else if MySpot=4 then begin
              frmHallOfFame.txtName4.TabStop:=True;
              frmHallOfFame.txtName4.ReadOnly:=False;
              frmHallOfFame.txtName4.Text:='';
              frmHallOfFame.txtScore4.Text:=IntToStr(Player1Score);
           end else if MySpot=5 then begin
              frmHallOfFame.txtName5.TabStop:=True;
              frmHallOfFame.txtName5.ReadOnly:=False;
              frmHallOfFame.txtName5.Text:='';
              frmHallOfFame.txtScore5.Text:=IntToStr(Player1Score);
           end;

           frmHallOfFame.ShowModal;
           GetHOFData;
           WriteHOF;

      end;

           frmHallOfFame.txtName1.TabStop:=False;
           frmHallOfFame.txtName1.ReadOnly:=True;
           frmHallOfFame.txtName2.TabStop:=False;
           frmHallOfFame.txtName2.ReadOnly:=True;
           frmHallOfFame.txtName3.TabStop:=False;
           frmHallOfFame.txtName3.ReadOnly:=True;
           frmHallOfFame.txtName4.TabStop:=False;
           frmHallOfFame.txtName4.ReadOnly:=True;
           frmHallOfFame.txtName5.TabStop:=False;
           frmHallOfFame.txtName5.ReadOnly:=True;

     if ((Player2Score > StrToInt(HighScoreScores[5])) and (NumberOfPlayers > 1)) then
      begin
           MessageDlg('Congradulations Player 2'+chr(13)+
                      'You''ve earned a place in the Hall of Fame!',
                      mtWarning, [mbOK], 0);

           { Where do I fit? }
           for MySpot:=1 to 5 do
                 if Player2Score > StrToInt(HighScoreScores[MySpot]) then break;

           { Bump all other entries down. }
           if(MySpot < 5) then
           for i:=4 downto MySpot do begin
               HighScoreNames[i+1]:=HighScoreNames[i];
               HighScoreScores[i+1]:=HighScoreScores[i];
           end;

           frmHallOfFame.txtName1.TabStop:=False;
           frmHallOfFame.txtName1.ReadOnly:=True;
           frmHallOfFame.txtName2.TabStop:=False;
           frmHallOfFame.txtName2.ReadOnly:=True;
           frmHallOfFame.txtName3.TabStop:=False;
           frmHallOfFame.txtName3.ReadOnly:=True;
           frmHallOfFame.txtName4.TabStop:=False;
           frmHallOfFame.txtName4.ReadOnly:=True;
           frmHallOfFame.txtName5.TabStop:=False;
           frmHallOfFame.txtName5.ReadOnly:=True;

           { Make my spot writeable. }
           if MySpot=1 then begin
              frmHallOfFame.txtName1.TabStop:=True;
              frmHallOfFame.txtName1.ReadOnly:=False;
              frmHallOfFame.txtName1.Text:='';
              frmHallOfFame.txtScore1.Text:=IntToStr(Player2Score);
           end else if MySpot=2 then begin
              frmHallOfFame.txtName2.TabStop:=True;
              frmHallOfFame.txtName2.ReadOnly:=False;
              frmHallOfFame.txtName2.Text:='';
              frmHallOfFame.txtScore2.Text:=IntToStr(Player2Score);
           end else if MySpot=3 then begin
              frmHallOfFame.txtName3.TabStop:=True;
              frmHallOfFame.txtName3.ReadOnly:=False;
              frmHallOfFame.txtName3.Text:='';
              frmHallOfFame.txtScore3.Text:=IntToStr(Player2Score);
           end else if MySpot=4 then begin
              frmHallOfFame.txtName4.TabStop:=True;
              frmHallOfFame.txtName4.ReadOnly:=False;
              frmHallOfFame.txtName4.Text:='';
              frmHallOfFame.txtScore4.Text:=IntToStr(Player2Score);
           end else if MySpot=5 then begin
              frmHallOfFame.txtName5.TabStop:=True;
              frmHallOfFame.txtName5.ReadOnly:=False;
              frmHallOfFame.txtName5.Text:='';
              frmHallOfFame.txtScore5.Text:=IntToStr(Player2Score);
           end;

           frmHallOfFame.ShowModal;
           GetHOFData;
           WriteHOF;
      end;

     frmHallOfFame.txtName1.TabStop:=False;
     frmHallOfFame.txtName1.ReadOnly:=True;
     frmHallOfFame.txtName2.TabStop:=False;
     frmHallOfFame.txtName2.ReadOnly:=True;
     frmHallOfFame.txtName3.TabStop:=False;
     frmHallOfFame.txtName3.ReadOnly:=True;
     frmHallOfFame.txtName4.TabStop:=False;
     frmHallOfFame.txtName4.ReadOnly:=True;
     frmHallOfFame.txtName5.TabStop:=False;
     frmHallOfFame.txtName5.ReadOnly:=True;

end;

procedure ShowScores;
begin
     frmMain.lblPlayer1Score.Caption:=inttostr(Player1Score);
     frmMain.lblPlayer2Score.Caption:=inttostr(Player2Score);
     if BallsRemaining<1 then begin
        BallsRemaining:=1;
        GameOver:=True;
        { Do we get to be in the hall of fame? }
        CheckHOF;
     End;
     frmMain.lblBalls.Caption:=inttostr(BallsRemaining-1);
end;



procedure TfrmMain.mnuFileExitClick(Sender: TObject);
begin
     if MessageDlg('Do you really want to quit?',
                   mtConfirmation,
                   [mbYes, mbNo],
                   0) = mrYes then Close;
end;

procedure TfrmMain.mnuFileNewClick(Sender: TObject);
begin
     frmNewGame.ShowModal;
     Randomize;
     NumberOfPlayers:=NewGame.NumberOfPlayers;
     GameOver:=False;
     Player1Y:=100; Player1Height:=50;
     Player2Y:=150; Player2Height:=50;
     Player1Score:=0; Player2Score:=0;
     BallX:=225;  BallY:=150;
     if Random(2)=1 then BallXV:=5 else BallXV:=-5;
     BallYV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
     BallXV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);     
     BallsRemaining:=3;
     ShowScores;
end;

procedure TfrmMain.mnuHelpAboutClick(Sender: TObject);
begin
     MessageDlg('WinPong!'+chr(13)+
                'A Delphi DirectX Application'+chr(13)+
                'by imnes@go.com'+chr(13)+chr(13)+
                'This application is released as PUBLIC DOMAIN.  Enjoy ;)',
                mtInformation, [mbOK], 0);
end;

procedure TfrmMain.mnuFileHallofFameClick(Sender: TObject);
begin
     ReadHOF;


     frmHallOfFame.ShowModal;
end;

procedure TfrmMain.OnInitialize(Sender: TObject);
begin
     frmMain.DXTimer.Enabled:=True;
end;

procedure TfrmMain.OnFinalize(Sender: TObject);
begin
     frmMain.DXTimer.Enabled:=False;
end;

{------------ ARTIFICIAL INTELLIGENCE ROUTINES -----------------------}
{
  If the CPU is set to Smart, it will precisely calculate where the ball
  is going, and try to get their before the ball does.  If however, the CPU
  is not set to smart, it will simply attempt to keep the paddle horizontally
  inline with the ball at all times.
}
procedure DoCPU1;
begin
     if frmMain.mnuCPU1Smart.Checked then
      begin
           Player1Y:=BallY-25;
      end
     else
      begin
          if BallXV<0 then begin
             if BallY < Player1Y+(Player1Height div 2) then Player1Y:=Player1Y-5;
             if BallY > Player1Y+(Player1Height div 2) then Player1Y:=Player1Y+5;
          end;
      end;
end;

procedure DoCPU2;
begin
     if frmMain.mnuCPU2Smart.Checked then
      begin
           Player2Y:=BallY-25;
      end
     else
      begin
          if BallXV>0 then begin
             if BallY < Player2Y+(Player2Height div 2) then Player2Y:=Player2Y-5;
             if BallY > Player2Y+(Player2Height div 2) then Player2Y:=Player2Y+5;
          end;
      end;
end;

{ Process a cycle of the Game Engine. }
procedure TfrmMain.DXTimerTimer(Sender: TObject; LagCount: Integer);
Var
   rPlayer1, rPlayer2, rBall: TRect;
begin
     { Show the current FPS. }
     frmMain.lblFPS.Caption:=inttostr(DXTimer.FrameRate);

     { If the game is over, state that, else, do processing. }
     if GameOver then
      Begin
           DXDraw.Surface.Canvas.Brush.Style := bsClear;
           DXDraw.Surface.Canvas.Font.Color := clWhite;
           DXDraw.Surface.Canvas.Font.Size := 16;
           DXDraw.Surface.Canvas.Font.Style := [fsBold];
           DXDraw.Surface.Canvas.TextOut(150, 140, 'GAME OVER');
      End
     else
      Begin
           { Check for input, update paddle positions. }
           DXInput.Update;
           Case NumberOfPlayers of
           0: begin
              DoCPU1;
              DoCPU2;
           end;
           1: begin
            if isButton1 in DXInput.Keyboard.States then
              Player1Y:=Player1Y-5;
            if isButton2 in DXInput.Keyboard.States then
              Player1Y:=Player1Y+5;
            DoCPU2;
            end;
           2: begin
            if isButton1 in DXInput.Keyboard.States then
              Player1Y:=Player1Y-5;
            if isButton2 in DXInput.Keyboard.States then
              Player1Y:=Player1Y+5;
            if isButton3 in DXInput.Keyboard.States then
              Player2Y:=Player2Y-5;
            if isButton4 in DXInput.Keyboard.States then
              Player2Y:=Player2Y+5;
            end;
           end;

           if Player1Y<0 then Player1Y:=0;
           if Player1Y+Player1Height>300 then Player1Y:=300-Player1Height;
           if Player2Y<0 then Player2Y:=0;
           if Player2Y+Player2Height>300 then Player2Y:=300-Player2Height;


           rPlayer1.Left:=5;
           rPlayer1.Top:=Player1Y;
           rPlayer1.Right:=7;
           rPlayer1.Bottom:=Player1Y+Player1Height;

           rPlayer2.Left:=443;
           rPlayer2.Top:=Player2Y;
           rPlayer2.Right:=445;
           rPlayer2.Bottom:=Player2Y+Player2Height;

           { Move the ball. }
           BallX:=BallX+BallXV;
           BallY:=BallY+BallYV;

           { Collision Detection. }
           if (BallX<7) and  (BallY>Player1Y) and (BallY<(Player1Y+Player1Height)) then
            begin
                 BallXV:=BallXV*-1;
                 BallX:=7+BallXV;
                 BallYV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
                 Player1Score:=Player1Score+50;
                 ShowScores;
            end;

           if (BallX>443) and  (BallY>Player2Y) and (BallY<(Player2Y+Player2Height)) then
            begin
                 BallXV:=BallXV*-1;
                 BallX:=443+BallXV;
                 BallYV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
                 Player2Score:=Player2Score+50;
                 ShowScores;
            end;


           { Bounds Check. }
           if BallX<0 then
            begin
              Player2Score:=Player2Score+1000;
              BallX:=225;  BallY:=150;
              BallXV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
              BallYV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
              BallsRemaining:=BallsRemaining-1;
              ShowScores;
            end;

           if BallX>450 then
            begin
              Player1Score:=Player1Score+1000;
              BallX:=225;  BallY:=150;
              if Random(2)=1 then BallXV:=5 else BallXV:=-5;
              BallYV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
              BallXV:=Random(BallTargetSpeed)-(BallTargetSpeed div 2);
              BallsRemaining:=BallsRemaining-1;
              ShowScores;
            end;

            if BallY<0 then
             begin
               BallYV:=BallYV*-1;
               BallY:=BallY+BallYV;
             end;

            if BallY>300 then
             begin
               BallYV:=BallYV*-1;
               BallY:=BallY+BallYV;
             end;

           rBall.Left:=BallX;
           rBall.Top:=BallY;
           rBall.Right:=BallX+2;
           rBall.Bottom:=BallY+2;


           {---------------------- RENDER A SCENE -------------------------}
           { Clear the Off-Screen buffer. }
           DXDraw.Surface.Fill(clGreen);

           { Show the paddles. }
           DXDraw.Surface.FillRect(rPlayer1, clWhite);
           DXDraw.Surface.FillRect(rPlayer2, clWhite);

           { Show the ball. }
           DXDraw.Surface.FillRect(rBall, clWhite);

      End;

     { We're done accessing the DirectDraw surface. }
     DXDraw.Surface.Canvas.Release;

     { Copy the off-screen buffer to the visual screen. }
     DXDraw.Flip;

end;


procedure TfrmMain.mnuViewShowFPSClick(Sender: TObject);
begin
     if mnuViewShowFPS.Checked=true then
      begin
          mnuViewShowFPS.Checked:=false;
          frmMain.lblFPS.Visible:=false;
          frmMain.lblFPSLabel.Visible:=false;
          frmMain.lblFPSTarget.Visible:=false;
      end
     else
      begin
          mnuViewShowFPS.Checked:=true;
          frmMain.lblFPS.Visible:=true;
          frmMain.lblFPSLabel.Visible:=true;
          frmMain.lblFPSTarget.Visible:=true;
      end;
end;

procedure TfrmMain.mnuCPU1SmartClick(Sender: TObject);
begin
     if mnuCPU1Smart.Checked then
        mnuCPU1Smart.Checked:=False
     else
        mnuCPU1Smart.Checked:=True;
end;

procedure TfrmMain.mnuCPU2SmartClick(Sender: TObject);
begin
     if mnuCPU2Smart.Checked then
        mnuCPU2Smart.Checked:=False
     else
        mnuCPU2Smart.Checked:=True;
end;

end.
