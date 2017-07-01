program TetrisProject;

uses
  Forms,
  uMain in 'uMain.pas' {fTetris},
  uTetris in 'uTetris.pas',
  uFigura in 'uFigura.pas',
  uGrid in 'uGrid.pas',
  uOptions in 'uOptions.pas' {fOptions},
  uFiguraInterface in 'uFiguraInterface.pas',
  uType in 'uType.pas',
  uDrawHook in 'uDrawHook.pas',
  uNewGame in 'uNewGame.pas' {fNewGame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfTetris, fTetris);
  Application.CreateForm(TfOptions, fOptions);
  Application.CreateForm(TfNewGame, fNewGame);
  Application.Run;
end.
