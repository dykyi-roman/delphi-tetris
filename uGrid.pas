unit uGrid;

interface

uses
  Windows, Classes, Messages, ShellAPI, Graphics, Dialogs,
  uType, uFiguraInterface;

const
  GRID_WIDTH    = 15;
  GRID_HEIGHT   = 29; //25 + 4(space for create figura)
  DEFAULT_CELL  = 20;
  DEFAULT_COLOR = clGreen;

type
  TBaseGrid = class
    FCell       : Byte;
    FWidth      : Byte;
    FHeigth     : Byte;
    FColor      : TColor;
    Canvas      : TCanvas;
  private
    procedure DrawRect(ARect: TPoint; AColor: TColor; CreateSpace: Integer = 4);
  public
    constructor Create(ACanvas: TCanvas; AColor: Tcolor; AWidth: Integer; AHeight: Integer);  virtual;
    property Color     : TColor  read FColor    write FColor;
    property Widht     : Byte    read FWidth    write FWidth  default GRID_WIDTH;
    property Height    : Byte    read FHeigth   write FHeigth default GRID_HEIGHT;
    property Cell      : Byte    read FCell     write FCell   default DEFAULT_CELL;
  end;

  TIsLine = TArray<Boolean>;
  TGrid   = class(TBaseGrid)
  private
    FGridLine   : Boolean;
    procedure   CreateGrid;
  public
    constructor Create(ACanvas: TCanvas; AColor: Tcolor; AWidth: Integer; AHeight: Integer); override;
    //
    procedure   UpdateAndClear;
    procedure   Draw(const ACell: Integer = DEFAULT_CELL);
  public
    property    GridLine  : Boolean read FGridLine write FGridLine;
  end;

  TGridFigura = class(TBaseGrid)
  private
    Grid        : TGrid;
    OldFigura   : TFiguraPos;
    procedure   BuildFigura(APos: TFiguraPos; AColor: TColor = clBtnFace);
  public
    Figura      : IFigura;
    function    TryMoveLeft : Boolean;
    function    TryMoveRight: Boolean;
    function    TryMoveDown : Boolean;
    function    TryRotate   : Boolean;
    function    Add         : Boolean;
    procedure   Draw;
    //
    constructor Create(ACanvas: TCanvas; AColor: TColor; AWidth: Integer; AHeight: Integer); override;
  end;

  TField = class
  const
     POINTS       = 100;
  public
     Grid        : TGrid;
     GridFigura  : TGridFigura;
     constructor Create(ACanvas: TCanvas; AWidth: Integer = GRID_WIDTH; AHeight: Integer = GRID_HEIGHT); override;
     destructor  Destroy; override;
     //
     procedure   Update;
     procedure   Clear;
     function    Recalculate: Word;
  end;

var
   FGrid : TArray<TIsLine>;

implementation

uses
  SysUtils;

constructor TBaseGrid.Create(ACanvas: TCanvas; AColor: Tcolor; AWidth, AHeight: Integer);
begin
  Canvas    := ACanvas;
  FColor    := AColor;
  FCell     := DEFAULT_CELL;
  FHeigth   := AHeight;
  FWidth    := AWidth;
end;

procedure TBaseGrid.DrawRect(ARect: TPoint; AColor: TColor);
begin
  ARect.Y := ARect.Y - 4;  //!!! -4 - use for bult figura upper
  Canvas.Brush.Color := AColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(FCell*ARect.X, FCell*ARect.Y, FCell*ARect.X-FCell, FCell*ARect.Y-FCell);
end;

{ TGrid }

constructor TGrid.Create(ACanvas: TCanvas; AColor: TColor; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AColor, AWidth, AHeight);
  FGridLine := True;
  CreateGrid;
end;

procedure TGrid.UpdateAndClear;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(Rect(0,0,1000,1000));
  end;
end;

function TGridFigura.TryMoveDown: Boolean;
var
  Pos : TFiguraPos;
begin
  Result := False;
  If (Figura.GetDownPoint.Y >= Grid.Height) Then
    Exit;

   Pos := FIgura.GetPos;
   If Pos[1].Y > 0 Then
   if (FGrid[Pos[1].Y, Pos[1].X]) or
      (FGrid[Pos[2].Y, Pos[2].X]) or
      (FGrid[Pos[3].Y, Pos[3].X]) or
      (FGrid[Pos[4].Y, Pos[4].X])
   then
     Exit;

  Result := True;
end;

function TGridFigura.TryMoveLeft: Boolean;
var
  Pos : TFiguraPos;
begin
  Result := False;
  If (Figura.GetLeftPoint.X <= 1) Then
    Exit;

   Pos := FIgura.GetPos;
   If Pos[1].Y > 0 Then
   if (FGrid[Pos[1].Y-1, Pos[1].X-1]) or
      (FGrid[Pos[2].Y-1, Pos[2].X-1]) or
      (FGrid[Pos[3].Y-1, Pos[3].X-1]) or
      (FGrid[Pos[4].Y-1, Pos[4].X-1])
   then
     Exit;

  Result := True;
end;

function TGridFigura.TryMoveRight: Boolean;
var
  Pos: TFiguraPos;
begin
  Result := False;
  If (Figura.GetRightPoint.X = Grid.Widht) Then
    Exit;

   Pos := FIgura.GetPos;
   If Pos[1].Y > 0 Then
   if (FGrid[Pos[1].Y-1, Pos[1].X+1]) or
      (FGrid[Pos[2].Y-1, Pos[2].X+1]) or
      (FGrid[Pos[3].Y-1, Pos[3].X+1]) or
      (FGrid[Pos[4].Y-1, Pos[4].X+1])
   then
     Exit;

  Result := True;
end;

function TGridFigura.TryRotate: Boolean;
begin
  Result := True;
end;

function TGridFigura.Add: Boolean;

procedure Add(APoint: TPoint);
begin
  If (APoint.X > 0) and (APoint.Y > 0) Then
    FGrid[APoint.Y-1, APoint.X] := True;
end;

var
  pos : TFiguraPos;
begin
  Result := True;
  // clear old figura - becouse figura disappear after add to grid
  FillChar(OldFigura, 4*SizeOf(TPoint),0);

  //Add figura fo grid
  pos := Figura.GetPos;
  add(pos[1]);
  add(pos[2]);
  add(pos[3]);
  add(pos[4]);

  // Check the End game
  If (pos[1].Y < 4) Then
    Exit(False);
end;

procedure TGridFigura.BuildFigura(APos: TFiguraPos; AColor: TColor);
var
  I: Integer;
begin
  For I := Low(APos) To High(APos) Do
    DrawRect(APos[i], AColor);
end;

constructor TGridFigura.Create(ACanvas: TCanvas; AColor: TColor; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AColor, AWidth, AHeight);
end;

procedure TGridFigura.Draw;
begin
  BuildFigura(OldFigura);
  if Assigned(FIgura) then
  begin
    OldFigura := FIgura.GetPos;
    BuildFigura(FIgura.GetPos, Color);
  end;
end;

constructor TField.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  Grid            := TGrid.Create(ACanvas, clGreen, AWidth, AHeight);
  GridFigura      := TGridFigura.Create(ACanvas, clBlack, AWidth, AHeight);
  GridFigura.Grid := Grid;
end;

destructor TField.Destroy;
begin
  Grid.Free;
  GridFigura.Free;
  inherited;
end;

function TField.Recalculate: Word;

function isLine(ALine: TIsLine): Boolean;
var
  i: Integer;
begin
  Result:= True;
  For i := 1 to High(ALine) Do
    If ALine[i] = False Then
      Exit(False);
end;

procedure DropLine(Index: Integer);
var
  k : TIsLine;
begin
  // move line  
  While Index > 0 Do
  begin
    k := FGrid[Index-1];
    FGrid[Index] := k;
    Dec(Index);    
  end; 
end;

var
  FromLine,
  i : Integer;
begin
  FromLine := GridFigura.Figura.GetDownPoint.Y;
  Result := 0;
  i := 1;
  While i < 5 Do
  begin
    If (FromLine >= i) and (isLine(FGrid[FromLine - i])) Then
    begin
      DropLine( FromLine - i );
      Result := Result + POINTS;
      Update;
    end
      else
        inc(i);
  end;
end;

procedure TField.Update;
var
  i, j : integer;
begin
  with Grid.Canvas do
  begin
    if Grid.GridLine then
      Pen.Color   := Grid.Color
    else
      Pen.Color   := clBtnFace;

    Brush.Style := bsSolid;
    for i := 0 to Grid.Height -1 do
      for j := 0 to Grid.Widht +1 do
      begin
        if j = Grid.Widht+1 then
          Continue;
        If FGrid[i][j] = True Then
          Grid.DrawRect(Point(j, i+1), GridFigura.Color)
        else
          Grid.DrawRect(Point(j, i+1), clBtnFace);
      end;
  end;
end;

procedure TGrid.CreateGrid;
var
  i: Integer;
begin
  SetLength(FGrid, FHeigth);
  For I := 0 To FHeigth - 1 Do
    SetLength(FGrid[i], FWidth+1);
end;

procedure TField.Clear;
begin
//  FillChar(Grid, SizeOf(Grid), #0);
  ZeroMemory(@FGrid[Low(FGrid)], Length(FGrid) * SizeOf(FGrid[Low(FGrid)]));
  Grid.CreateGrid;
  Update;
end;

procedure TGrid.Draw(const ACell: Integer);
var
  i, j : integer;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsClear;
    Pen.Color   := FColor;
    for j := 0 to FWidth - 1 do
      for i := 0 to FHeigth - 5 do    //!!! -5 - use for bult figura upper
        Rectangle(j * FCell, i * FCell, FCell + j * FCell, FCell + i * FCell);
  end;
end;

end.
