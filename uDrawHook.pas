unit uDrawHook;

interface

type
  IDrawSurface = interface
  ['{AE722030-7AFE-4BE6-B6A7-88DB2FF05D3F}']
    procedure DrawObject;
    procedure UpdatePoints;
    procedure UpdateBonus;
    procedure ShowSpeed;
    procedure ShowTimeGame;
    procedure FiguraCount;
  end;

var
  Surface: IDrawSurface;

implementation

end.
