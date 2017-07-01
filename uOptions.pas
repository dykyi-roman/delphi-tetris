unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Vcl.ExtCtrls, Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TfOptions = class(TForm)
    cbColorGridLine: TColorBox;
    cbGridColor: TCheckBox;
    BitBtn1: TBitBtn;
    cbFiguraColor: TColorBox;
    text1: TStaticText;
    tbZoom: TTrackBar;
    StaticText1: TStaticText;
    stZoomNumber: TStaticText;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbGridColorClick(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
  private
    procedure LoadPropery;
    procedure SaveProperty;
  public
    { Public declarations }
  end;

var
  fOptions: TfOptions;

implementation

uses
  uMain, uTetris;

{$R *.dfm}

procedure TfOptions.btnCloseClick(Sender: TObject);
begin
  SaveProperty;
  Close;
end;

procedure TfOptions.cbGridColorClick(Sender: TObject);
begin
  cbColorGridLine.Enabled := cbGridColor.Checked;
end;

procedure TfOptions.FormShow(Sender: TObject);
begin
  LoadPropery;
end;

procedure TfOptions.LoadPropery;
begin
  with Tetris do
  begin
    cbGridColor.Checked      := Field.Grid.GridLine;
    cbColorGridLine.Selected := Field.Grid.Color;
    cbFiguraColor.Selected   := Field.GridFigura.Color;
    tbZoom.Position          := Field.Grid.Cell;
    stZoomNumber.Caption     := IntToStr(Field.Grid.Cell);
  end;
end;

procedure TfOptions.SaveProperty;
begin
  with Tetris do
  begin
    Field.Grid.GridLine    := cbGridColor.Checked;
    Field.Grid.Color       := cbColorGridLine.Selected;
    Field.GridFigura.Color := cbFiguraColor.Selected;
    //zoom
    if Field.Grid.Cell <> tbZoom.Position then
    begin
      Field.Grid.Cell        := tbZoom.Position;
      Field.GridFigura.Cell  := tbZoom.Position;
      Field.Grid.UpdateAndClear
    end;
  end;
end;

procedure TfOptions.tbZoomChange(Sender: TObject);
begin
  stZoomNumber.Caption := IntToStr(tbZoom.Position);
end;

end.
