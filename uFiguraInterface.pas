unit uFiguraInterface;

interface

uses
  Graphics, Windows, Classes, uType;

type
  IFigura = interface
  ['{2B2C658F-3C20-44D5-9341-7FEB09000F85}']
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
    //
    function GetPos       : TFiguraPos;
    function GetLeftPoint : TPoint;
    function GetRightPoint: TPoint;
    function GetDownPoint : TPoint;

    function  GetColor: TColor;
    procedure SetColor(const Value: TColor);
    property Color : TColor read GetColor write SetColor;
  end;

  IFiguraRotate = interface(IFigura)
  ['{2FDB1CFD-F67F-4DE1-BE44-D09F9A488B20}']
    function  GetFiguraState: TFiguraState;
    procedure SetState(const Value: TFiguraState);
    property State : TFiguraState read GetFiguraState write SetState;
    //
    procedure Rotate;
  end;

  ILine = interface(IFiguraRotate)
  ['{BC5DC715-B37A-4F77-B350-EC85DF8BCCF5}']
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
  End;

  IL = interface(IFiguraRotate)
  ['{F40443D4-7AFD-4D58-92EA-A974E93159BB}']
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
  End;

  I_l_ = interface(IFiguraRotate)
  ['{7888022C-3DC4-4056-B959-08126AECD648}']
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
  End;

  IRect = interface(IFigura)
  ['{9A646174-2780-412F-AC92-C63EBC8AFBB4}']
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
  End;

  IPoint = interface(IFigura)
  ['{423DAD07-5F7A-4592-8F84-3960BA9CA7C3}']
    //
    procedure Preview(ACanvas: TCanvas);
    procedure Draw;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveDown;
  End;

function GetIFigura(AType: TFiguraType; APosition: Integer): IFigura;

implementation

uses
  uFigura;

function GetIFigura(AType: TFiguraType; APosition: Integer): IFigura;
begin
  Result := GetFigura(AType, APosition);
end;

end.
