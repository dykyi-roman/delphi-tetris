unit uTetris;

interface

uses
  Windows, Classes, ShellAPI, Graphics, ExtCtrls,
  uType, uGrid, uFiguraInterface;

type
  TTetris = class
  private const
    BONUS_ROTATE  = 1000;
    MSG_GAME_OVER = 'Game is over! Your points: %d';
  private
    FActive     : Boolean;
    FTime       : Cardinal;
    FSpeed      : Word;
    FCount      : LongWord;
    FPoints     : LongWord;
    FBonus      : Word;
    TimeTimer   : TTimer;
    GameTimer   : TTimer;
    function    GenerateFigura: IFigura;
    procedure   actTimerTime(Sender: TObject);
    procedure   actTimerGame(Sender: TObject);
    procedure   SetSpeed(const Value: Word);
    procedure   SetPoints(const Value: LongWord);
    procedure   SetTime(const Value: Cardinal);
  public
    Figura      : IFigura;
    NextFigura  : IFigura;
    Field       : TField;
    Previw      : TCanvas;
    constructor Create(AGrid, APreviw: TCanvas);
    destructor  Destroy;   override;
    //
    procedure   GetNextFigura;
    procedure   ChangeNextFigura;
    procedure   CheckRules;
    procedure   FreeMem;
    procedure   SetNewWidth(AWidth, AHeight: Byte);
    procedure   Update;
  public
    property    Active : Boolean  read FActive write Factive  default False;
    property    Speed  : Word     read FSpeed  write SetSpeed default 1;
    property    Points : LongWord read FPoints write SetPoints;
    property    Time   : Cardinal read FTime   write SetTime;
    property    Count  : LongWord read FCount  write FCount;
    property    Bonus  : Word     read FBonus  write FBonus;
    //
    procedure   NewGame(AWidth, AHeight: Byte);virtual;
    procedure   StartGame; virtual;
    procedure   StopGame;  virtual;
    procedure   SaveGame;  virtual; abstract;
    procedure   LoadGame;  virtual; abstract;
  end;

var
  Tetris : TTetris;

implementation

uses
  SysUtils, Dialogs, uDrawHook;

{ TTetris }

constructor TTetris.Create(AGrid, APreviw: TCanvas);
begin
  Randomize;
  Previw  := APreviw;
  Field   := TField.Create(AGrid);
  FActive := False;
  FPoints := 0;
  FBonus  := 0;
  FCount  := 0;
  FTime   := 0;

  // GameTimer create
  GameTimer         := TTimer.Create(nil);
  GameTimer.Enabled := False;
  GameTimer.OnTimer := actTimerGame;

  FSpeed  := 1;

  // TimeTimer create
  TimeTimer         := TTimer.Create(nil);
  TimeTimer.Enabled := False;
  TimeTimer.OnTimer := actTimerTime;
end;

destructor TTetris.Destroy;
begin
  Field.Free;
  GameTimer.Free;
  inherited;
end;

procedure TTetris.FreeMem;
begin
  Field.Clear;
  Figura     := nil;
  NextFigura := nil;
end;

procedure TTetris.SetNewWidth(AWidth, AHeight: Byte);
begin
  if (Tetris.Field.Grid.Widht  <> AWidth) or
     (Tetris.Field.Grid.Height <> AHeight)then
  begin
    Tetris.Field.Grid.Widht  := AWidth;
    Tetris.Field.Grid.Height := AHeight+4;
  end;
end;

procedure TTetris.SetPoints(const Value: LongWord);
begin
  If Value = 0 Then
    Exit;

  //Set points
  FPoints := FPoints + Value;
  //Set Speed
  Case FPoints Of
    10000 : Speed := 2;
    50000 : Speed := 3;
    100000: Speed := 4;
    200000: Speed := 5;
  End;
  // Set bonus rotate figura
  If (FPoints > 0) and (FPoints mod BONUS_ROTATE = 0) Then
  begin
    Inc(FBonus);
    if Assigned(Surface) then
       Surface.UpdateBonus;
  end;

  if Assigned(Surface) then
     Surface.UpdatePoints;
end;

procedure TTetris.CheckRules;
begin
  If Assigned(Figura) and (Field.GridFigura.TryMoveDown) Then
  begin
    Figura.MoveDown;
    Figura.Draw;
  end else begin
    if not Field.GridFigura.Add then
    begin
      StopGame;
      ShowMessageFmt(MSG_GAME_OVER,[FPoints]);
      FreeMem;
      Exit;
    end;

    Points := Field.Recalculate;
    GetNextFigura;
  end;
end;

function TTetris.GenerateFigura: IFigura;
var
  Size: Integer;
begin
  Result := nil;
  Size   := Ord(High(TFiguraType)) - Ord(Low(TFiguraType)) + 1;   // replace ord to integer if not work
  Result := GetIFigura(TFiguraType(Random(size) + 1),Field.Grid.Widht div 2 + 1);

  //Set preview figura color
  if Assigned(Field.GridFigura) then
    Result.Color := Field.GridFigura.Color;

  if Assigned(Result) and Assigned(Surface) then
  begin
    FCount := FCount + 1;
    Surface.FiguraCount;
  end;
end;

procedure TTetris.GetNextFigura;
begin
  Figura     := nil;
  Figura     := NextFigura;
  NextFigura := nil;
  NextFigura := GenerateFigura;
  NextFigura.Preview(Previw);
  Field.GridFigura.Figura := Figura;
  //
  actTimerGame(Self);
end;

procedure TTetris.actTimerTime(Sender: TObject);
begin
  Time := Time + 1;
end;

procedure TTetris.ChangeNextFigura;
begin
  NextFigura := nil;
  NextFigura := GenerateFigura;
  NextFigura.Preview(Previw);
end;

procedure TTetris.NewGame(AWidth, AHeight: Byte);
begin
  StopGame;
  SetNewWidth(AWidth, AHeight);
  try
    Field.Grid.UpdateAndClear;
    Field.Update;
    FreeMem;
    Figura     := GenerateFigura;
    NextFigura := GenerateFigura;
    NextFigura.Preview(Previw);

    Field.GridFigura.Figura := Figura;
    Speed   := 1;
    FBonus  := 0;
    FPoints := 0;
    FCount  := 0;
    FTime   := 0;
  finally
    StartGame;
  end;
end;

procedure TTetris.SetSpeed(const Value: Word);
begin
  If Assigned(GameTimer) and (Value <= 5) Then
  begin
    FSpeed := Value;
    Case Value Of
      1: GameTimer.Interval := 1000;
      2: GameTimer.Interval := 500;
      3: GameTimer.Interval := 300;
      4: GameTimer.Interval := 200;
      5: GameTimer.Interval := 100;
    End;
    if Assigned(Surface) then
       Surface.ShowSpeed;
  end;
end;

procedure TTetris.SetTime(const Value: Cardinal);
begin
  FTime := Value;
  if Assigned(Surface) then
    Surface.ShowTimeGame;
end;

procedure TTetris.StartGame;
begin
  FActive           := True;
  GameTimer.Enabled := Active;
  TimeTimer.Enabled := Active;

  Update;
end;

procedure TTetris.StopGame;
begin
  FActive           := False;
  GameTimer.Enabled := Active;
  TimeTimer.Enabled := Active;
end;

procedure TTetris.Update;
begin
  //update fields
  Tetris.Field.Update;
  //update figura
  if Assigned(Tetris.Figura) then
    Tetris.Figura.Draw;
end;

procedure TTetris.actTimerGame(Sender: TObject);
begin
  CheckRules;
end;

end.
