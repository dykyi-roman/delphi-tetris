unit uFigura;

interface

uses
  Graphics, Windows, Classes, uDrawHook, uType, uFiguraInterface;

type
  TFigura = class(TInterfacedObject, IFigura)
  private
    FCanvas  : TCanvas;
    FColor   : TColor;
    Position : TFiguraPos;
    procedure Draw;                      virtual;
    procedure Preview(ACanvas: TCanvas); virtual;
    function  GetColor: TColor;
    procedure SetColor(const Value: TColor);
  public
    constructor Create(X: integer);      virtual; abstract;
    procedure MoveLeft;                  virtual; abstract;
    procedure MoveRight;                 virtual; abstract;
    procedure MoveDown;                  virtual; abstract;
    procedure GrandfatherInherited(ACanvas: TCanvas);
  public
    property Canvas: TCanvas read FCanvas  write FCanvas;
    property Color : TColor  read GetColor write SetColor;
    //
    function GetPos       : TFiguraPos;
    function GetLeftPoint : TPoint;
    function GetRightPoint: TPoint;
    function GetDownPoint : TPoint;
  end;

//  TBaseFigura = class of TFigura;

  TFiguraRotate = class(TFigura, IFiguraRotate)
  private
    FState : TFiguraState;
    function GetFiguraState: TFiguraState;
    procedure SetState(const Value: TFiguraState);
  public
    procedure Rotate; virtual;  // Rotate one
    property State : TFiguraState read GetFiguraState write SetState default tsTop;
  end;

  TLine = Class(TFiguraRotate, IFigura, IFiguraRotate, ILine)
  public
    constructor Create(X: integer);      override;
    procedure Preview(ACanvas: TCanvas); override;
    procedure MoveLeft;                  override;
    procedure MoveRight;                 override;
    procedure MoveDown;                  override;
    procedure Rotate;                    override;
  End;

  TL = Class(TFiguraRotate, IFigura, IFiguraRotate, IL)
  public
    constructor Create(X: integer);      override;
    procedure Preview(ACanvas: TCanvas); override;
    procedure MoveLeft;                  override;
    procedure MoveRight;                 override;
    procedure MoveDown;                  override;
    procedure Rotate;                    override;
  End;

  T_l_ = Class(TFiguraRotate, IFigura, IFiguraRotate, I_l_)
  public
    constructor Create(X: integer);      override;
    procedure Preview(ACanvas: TCanvas); override;
    procedure MoveLeft;                  override;
    procedure MoveRight;                 override;
    procedure MoveDown;                  override;
    procedure Rotate;                    override;
  End;

  TRect = Class(TFigura, IFigura, IRect)
  public
    constructor Create(X: integer);      override;
    procedure Preview(ACanvas: TCanvas); override;
    procedure MoveLeft;                  override;
    procedure MoveRight;                 override;
    procedure MoveDown;                  override;
  End;

  TPoints = Class(TFigura, IFigura, IPoint)
  public
    constructor Create(X: integer);      override;
    procedure Preview(ACanvas: TCanvas); override;
    procedure MoveLeft;                  override;
    procedure MoveRight;                 override;
    procedure MoveDown;                  override;
  End;

function GetFigura(AType: TFiguraType; APosition: Integer): IFigura;

implementation

{ -------------------------------------------------------------------------------------------------------------------- }

function GetFigura(AType: TFiguraType; APosition: Integer): IFigura;
begin
  case AType of
    tft_point: Result := TPoints.Create(APosition);
    tft_line : Result := TLine.Create(APosition);
    tft_Rect : Result := TRect.Create(APosition);
    tft_L    : Result := TL.Create(APosition);
    tft_l_   : Result := T_l_.Create(APosition);
  else
    Result := TPoints.Create(APosition);
  end;
end;

function TFiguraRotate.GetFiguraState: TFiguraState;
begin
  Result := FState;
end;

procedure TFiguraRotate.Rotate;
begin
    If FState = tsBotom Then
      FState := tsLeft
    else
      FState := Succ(FState);
end;

procedure TFiguraRotate.SetState(const Value: TFiguraState);
begin
  FState := Value;
end;

{ ----------------------------------------------------- TFigura ------------------------------------------------------ }

procedure TFigura.Draw;
begin
  if Assigned(Surface) then
     Surface.DrawObject;
end;

procedure TFigura.GrandfatherInherited(ACanvas: TCanvas);
// http://codes.com.ua/2014/05/kak-v-delphi-sdelat-inherited-metoda-ot-dedushki/
type
  TFigura_  = procedure(ACanvas: TCanvas) of object;
var
  tmp: TFigura_;
begin
  TMethod(tmp).Code := @TFigura.Preview;
  TMethod(tmp).Data := Self;
  tmp(ACanvas);
end;

function TFigura.GetColor: TColor;
begin
  Result := FColor;
end;

function TFigura.GetDownPoint: TPoint;
var
  I: Integer;
begin
  Result := Point(0,0);
  For I := Low(Position) To High(Position) Do
    If Position[i].Y > Result.Y Then
      Result := Position[i];
end;

function TFigura.GetLeftPoint: TPoint;
var
  I: Integer;
begin
  Result := Point(999,0);
  For I := Low(Position) To High(Position) Do
    If (Position[i].X < Result.X) and (Position[i].X  > 0) Then
      Result := Position[i];
end;

function TFigura.GetRightPoint: TPoint;
var
  I: Integer;
begin
  Result := Point(0,0);
  For I := Low(Position) To High(Position) Do
    If Position[i].X > Result.X Then
      Result := Position[i];
end;

function TFigura.GetPos: TFiguraPos;
begin
  Result := Position;
end;

procedure TFigura.Preview(ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    Brush.Color := clWhite;
    FillRect(Rect(0, 0, 100, 100));
    Brush.Style := bsSolid;
    Brush.Color := Color;
  end;
end;

procedure TFigura.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

{ ----------------------------------------------------- TPoints ------------------------------------------------------ }

procedure TPoints.Preview(ACanvas: TCanvas);
begin
  inherited Preview(ACanvas);
  ACanvas.Rectangle(25,25,40,40);
end;

constructor TPoints.Create(X: integer);
begin
  Position[1].X := X;  Position[1].Y := 4;
  Position[2].X := X;  Position[2].Y := 4;
  Position[3].X := X;  Position[3].Y := 4;
  Position[4].X := X;  Position[4].Y := 4;
end;

procedure TPoints.MoveDown;
begin
  Inc(Position[1].Y);
  Inc(Position[2].Y);
  Inc(Position[3].Y);
  Inc(Position[4].Y);
end;

procedure TPoints.MoveLeft;
begin
  Dec(Position[1].X);
  Dec(Position[2].X);
  Dec(Position[3].X);
  Dec(Position[4].X);
end;

procedure TPoints.MoveRight;
begin
  Inc(Position[1].X);
  Inc(Position[2].X);
  Inc(Position[3].X);
  Inc(Position[4].X);
end;

{ -------------------------------------------- TLine ----------------------------------------------------------------- }

constructor TLine.Create(X: Integer);
begin
  Position[1].X := X;   Position[1].Y := 4;
  Position[2].X := X+1; Position[2].Y := 4;
  Position[3].X := X+2; Position[3].Y := 4;
  Position[4].X := X+3; Position[4].Y := 4;
end;

procedure TLine.Preview(ACanvas: TCanvas);
begin
  inherited Preview(ACanvas);
  with ACanvas do
  begin
    Rectangle(31,01,45,14);
    Rectangle(31,15,45,30);
    Rectangle(31,31,45,45);
    Rectangle(31,46,45,60);
  end;
end;

procedure TLine.MoveDown;
begin
  Inc(Position[1].Y);
  Inc(Position[2].Y);
  Inc(Position[3].Y);
  Inc(Position[4].Y);
end;

procedure TLine.MoveLeft;
begin
  Dec(Position[1].X);
  Dec(Position[2].X);
  Dec(Position[3].X);
  Dec(Position[4].X);
end;

procedure TLine.MoveRight;
begin
  Inc(Position[1].X);
  Inc(Position[2].X);
  Inc(Position[3].X);
  Inc(Position[4].X);
end;

procedure TLine.Rotate;
begin
  Case FState Of
    tsLeft, tsRight:
    begin
      Inc(Position[1].X); Dec(Position[1].Y);
      Dec(Position[3].X); Inc(Position[3].Y);
      Dec(Position[4].X); Inc(Position[4].Y);
      Dec(Position[4].X); Inc(Position[4].Y);
    end;
    tsTop, tsBotom:
    begin
      Dec(Position[1].X); Inc(Position[1].Y);
      Inc(Position[3].X); Dec(Position[3].Y);
      Inc(Position[4].X); Dec(Position[4].Y);
      Inc(Position[4].X); Dec(Position[4].Y);
    end;
  End;
  inherited Rotate;
end;

{ ----------------------------------------------- TRect -------------------------------------------------------------- }

constructor TRect.Create(X: integer);
begin
  Position[1].X := X;   Position[1].Y := 3;
  Position[2].X := X  ; Position[2].Y := 4;
  Position[3].X := X+1; Position[3].Y := 3;
  Position[4].X := X+1; Position[4].Y := 4;
end;

procedure TRect.Preview(ACanvas: TCanvas);
begin
  inherited Preview(ACanvas);
  with ACanvas do
  begin
    Rectangle(15,15,30,30);
    Rectangle(31,15,45,30);
    Rectangle(31,31,45,45);
    Rectangle(15,31,30,45);
  end;
end;

procedure TRect.MoveDown;
begin
  Inc(Position[1].Y);
  Inc(Position[2].Y);
  Inc(Position[3].Y);
  Inc(Position[4].Y);
end;

procedure TRect.MoveLeft;
begin
  Dec(Position[1].X);
  Dec(Position[2].X);
  Dec(Position[3].X);
  Dec(Position[4].X);
end;

procedure TRect.MoveRight;
begin
  Inc(Position[1].X);
  Inc(Position[2].X);
  Inc(Position[3].X);
  Inc(Position[4].X);
end;

{ ------------------------------------------------------ TL ---------------------------------------------------------- }

constructor TL.Create(X: integer);
begin
  Position[1].X := X;   Position[1].Y := 2;
  Position[2].X := X;   Position[2].Y := 3;
  Position[3].X := X;   Position[3].Y := 4;
  Position[4].X := X-1; Position[4].Y := 4;

  FState := tsTop;
end;

procedure TL.MoveDown;
begin
  Inc(Position[1].Y);
  Inc(Position[2].Y);
  Inc(Position[3].Y);
  Inc(Position[4].Y);
end;

procedure TL.MoveLeft;
begin
  Dec(Position[1].X);
  Dec(Position[2].X);
  Dec(Position[3].X);
  Dec(Position[4].X);
end;

procedure TL.MoveRight;
begin
  Inc(Position[1].X);
  Inc(Position[2].X);
  Inc(Position[3].X);
  Inc(Position[4].X);
end;

procedure TL.Preview(ACanvas: TCanvas);
begin
  GrandfatherInherited(ACanvas);
  with ACanvas do
  begin
    Rectangle(31,01,45,14);
    Rectangle(31,15,45,30);
    Rectangle(31,31,45,45);
    Rectangle(15,31,30,45);
  end;
end;

procedure TL.Rotate;
begin
   inherited Rotate;
   Case FState Of
    tsTop:
    begin
      Dec(Position[1].Y);
      Inc(Position[2].X);
      Inc(Position[3].X); Inc(Position[3].X); Inc(Position[3].Y);
      Dec(Position[4].X);
    end;
    tsRight:
    begin
      Dec(Position[1].X); Inc(Position[1].Y); Inc(Position[1].Y);
      Inc(Position[2].Y);
      Inc(Position[3].X);
      Dec(Position[4].Y);
    end;
    tsBotom:
    begin
      Inc(Position[1].X); Dec(Position[1].Y);
      Dec(Position[3].X); Inc(Position[3].Y);
      Inc(Position[4].X); Inc(Position[4].X);
    end;
    tsLeft:
    begin
      Inc(Position[1].X);
      Dec(Position[2].Y);
      Dec(Position[3].X); Dec(Position[3].Y); Dec(Position[3].Y);
      Inc(Position[4].Y);
    end;
   End;
end;

{ ----------------------------------------------------- T_l_ --------------------------------------------------------- }

constructor T_l_.Create(X: integer);
begin
  Position[1].X := X-1; Position[1].Y := 4;
  Position[2].X := X;   Position[2].Y := 4;
  Position[3].X := X+1; Position[3].Y := 4;
  Position[4].X := X;   Position[4].Y := 3;

  FState := tsTop;
end;

procedure T_l_.MoveDown;
begin
  Inc(Position[1].Y);
  Inc(Position[2].Y);
  Inc(Position[3].Y);
  Inc(Position[4].Y);
end;

procedure T_l_.MoveLeft;
begin
  Dec(Position[1].X);
  Dec(Position[2].X);
  Dec(Position[3].X);
  Dec(Position[4].X);
end;

procedure T_l_.MoveRight;
begin
  Inc(Position[1].X);
  Inc(Position[2].X);
  Inc(Position[3].X);
  Inc(Position[4].X);
end;

procedure T_l_.Preview(ACanvas: TCanvas);
begin
  GrandfatherInherited(ACanvas);
  with ACanvas do
  begin
    Rectangle(31,01,45,14);
    Rectangle(31,15,45,30);
    Rectangle(31,31,45,45);
    Rectangle(15,15,30,30);
  end;
end;

procedure T_l_.Rotate;
begin
  inherited Rotate;
   Case FState Of
    tsTop:
    begin
      Dec(Position[1].Y); Dec(Position[1].X);
      Inc(Position[3].Y); Inc(Position[3].X);
      Dec(Position[4].Y); Inc(Position[4].X);
    end;
    tsRight:
    begin
      Dec(Position[1].Y); Inc(Position[1].X);
      Inc(Position[3].Y); Dec(Position[3].X);
      Inc(Position[4].Y); Inc(Position[4].X);
    end;
    tsBotom:
    begin
      Inc(Position[1].Y); Inc(Position[1].X);
      Dec(Position[3].Y); Dec(Position[3].X);
      Inc(Position[4].Y); Dec(Position[4].X);
    end;
    tsLeft:
    begin
      Dec(Position[3].Y); Inc(Position[3].X);
      Inc(Position[1].Y); Dec(Position[1].X);
      Dec(Position[4].Y); Dec(Position[4].X);
    end;
   End;
end;

{ -------------------------------------------------------------------------------------------------------------------- }

end.
