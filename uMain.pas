unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, ImgList, StdCtrls, Buttons,
  //
  uType,uDrawHook;

type
  TfTetris = class(TForm, IDrawSurface)
    pbTetris: TPaintBox;
    statBar: TStatusBar;
    pnlPanel: TPanel;
    imgFigura: TImage;
    btnRotate: TSpeedButton;
    tmr1: TTimer;
    txt1: TStaticText;
    mm1: TMainMenu;
    File1: TMenuItem;
    New: TMenuItem;
    Stop: TMenuItem;
    N2: TMenuItem;
    Save: TMenuItem;
    Open: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRotateClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbTetrisPaint(Sender: TObject);
  private
    procedure Send(Message: Cardinal);
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    procedure UpdateBonus;
    procedure UpdatePoints;
    procedure DrawObject;
    procedure ShowSpeed;
    procedure ShowTimeGame;
    procedure FiguraCount;
  end;

var
  fTetris: TfTetris;

implementation

uses
  MMSystem, uTetris, uOptions, uFiguraInterface, uNewGame;

{$R *.dfm}

procedure TfTetris.btnRotateClick(Sender: TObject);
begin
  Tetris.ChangeNextFigura;

  If Tetris.Bonus > 0 Then
  begin
    Tetris.Bonus    := Tetris.Bonus - 1;
    SendMessage(fTetris.Handle, WM_UPDATE_BONUS,0,0);
  end;
  btnRotate.Visible := Tetris.Bonus > 0;
end;

procedure TfTetris.Send(Message: Cardinal);
begin
 If Tetris.Active Then
    PostMessage(Self.Handle, Message, 0, 0);
end;

procedure TfTetris.DrawObject;
begin
  Send(WM_FIGURA_DRAW);
end;

procedure TfTetris.UpdateBonus;
begin
  Send(WM_UPDATE_BONUS);
end;

procedure TfTetris.UpdatePoints;
begin
 Send(WM_UPDATE_POINTS);
end;

procedure TfTetris.ShowSpeed;
begin
  Send(WM_SHOW_SPEED);
end;

procedure TfTetris.ShowTimeGame;
begin
  Send(WM_SHOW_TIME);
end;

procedure TfTetris.FiguraCount;
begin
  Send(WM_FIGURA_INC);
end;

procedure TfTetris.WndProc(var Message: TMessage);
begin
  inherited;
  Case Message.Msg Of

    WM_FIGURA_DRAW:
      Tetris.Field.GridFigura.Draw;

    WM_UPDATE_POINTS:
       txt1.Caption := IntToStr(Tetris.Points);

    WM_UPDATE_BONUS:
    begin
       btnRotate.Visible := True;
       btnRotate.Caption := IntToStr(Tetris.Bonus);
    end;

    WM_SHOW_TIME:
      statBar.Panels[2].Text := Format('Time: %.2d:%.2d',[Tetris.Time div 60, Tetris.Time mod 60]);

    WM_SHOW_SPEED:
      statBar.Panels[1].Text := Format('Speed: %d',[Tetris.Speed]);

    WM_FIGURA_INC:
      statBar.Panels[0].Text := Format('Count: %d',[Tetris.Count]);
  End;
end;

procedure TfTetris.Exit1Click(Sender: TObject);
begin
  {$message 'Input save dialogBox'}
  Tetris.StopGame;
  Close;
end;

procedure TfTetris.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tetris.StopGame;
  Tetris.FreeMem;
  Surface := nil;
  FreeAndNil(Tetris);
end;

procedure TfTetris.FormCreate(Sender: TObject);
begin
  // Form setting
  fTetris.KeyPreview := True;
  Surface := Self as IDrawSurface;
  //
  Randomize;
  Tetris := TTetris.Create(pbTetris.Canvas, imgFigura.Canvas);
end;

procedure TfTetris.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  tmp: IFiguraRotate;
begin
  If (Assigned(Tetris)) and (Assigned(Tetris.Figura)) Then
  Case Key Of
    // Rotate figura
    VK_UP:
    begin
      If Supports(Tetris.Figura, IFiguraRotate, tmp) Then
        If Tetris.Field.GridFigura.TryRotate Then
        begin
          tmp.Rotate;
          tmp.Draw;
        end;
    end;

    // Figura lowers down
    VK_DOWN:
      Tetris.CheckRules;

    // Move figura to the Left
    VK_LEFT:
    begin
      If Tetris.Field.GridFigura.TryMoveLeft Then
      begin
        Tetris.Figura.MoveLeft;
        Tetris.Figura.Draw;
      end;
    end;

    // Move figura to the Right
    VK_RIGHT:
    Begin
      If Tetris.Field.GridFigura.TryMoveRight Then
      begin
        Tetris.Figura.MoveRight;
        Tetris.Figura.Draw;
      end;
    End;
  End;
end;

procedure TfTetris.NewClick(Sender: TObject);
begin
  fNewGame.ShowModal;
  if fNewGame.isStart then
  begin
    PostMessage(Self.Handle, WM_FIGURA_INC,   0, 0);
    PostMessage(Self.Handle, WM_SHOW_SPEED,   0, 0);
    SendMessage(Self.Handle, WM_SHOW_TIME,    0, 0);
    PostMessage(Self.Handle, WM_UPDATE_POINTS,0, 0);
    SendMessage(Self.Handle, WM_UPDATE_BONUS, 0, 0);

    btnRotate.Visible := False;
    Stop.Enabled      := True;
    Save.Enabled      := True;;
  end;
end;

procedure TfTetris.OptionsClick(Sender: TObject);
begin
  if Tetris.Active then
  begin
    Tetris.StopGame;
    try
      fOptions.ShowModal;
    finally
      Tetris.StartGame;
    end;
  end
    else
      fOptions.ShowModal;
end;


procedure TfTetris.pbTetrisPaint(Sender: TObject);
begin
  if Tetris.Active then
    Tetris.Field.Update;
end;

procedure TfTetris.StopClick(Sender: TObject);
begin
  If Tetris.Active Then
  begin
    Tetris.StopGame;
    Stop.Caption := '&Start';
  end else begin
    Tetris.StartGame;
    Stop.Caption := '&Stop';
  end;
end;

procedure TfTetris.tmr1Timer(Sender: TObject);
begin
  Tetris.Field.
  Update;
end;

end.
