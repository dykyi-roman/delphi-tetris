unit uNewGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Samples.Spin;

type
  TfNewGame = class(TForm)
    seHeight: TSpinEdit;
    seWidth : TSpinEdit;
    Label1  : TLabel;
    BitBtn1 : TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    isStart: Boolean;
  end;

var
  fNewGame: TfNewGame;

implementation

uses
  uMain, uTetris, uType;

{$R *.dfm}

procedure TfNewGame.BitBtn1Click(Sender: TObject);
begin
  Tetris.NewGame(seWidth.Value, seHeight.Value);
  isStart := True;
  Close;
end;

procedure TfNewGame.FormShow(Sender: TObject);
begin
  seWidth.Value  := Tetris.Field.Grid.Widht;
  seHeight.Value := Tetris.Field.Grid.Height - 4;
end;

end.
