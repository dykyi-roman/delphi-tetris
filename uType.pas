unit uType;

interface

uses
  Messages, Windows;

const
  WM_FIGURA_DRAW   = WM_USER + 1;
  WM_UPDATE_POINTS = WM_USER + 2;
  WM_UPDATE_BONUS  = WM_USER + 3;
  WM_SHOW_SPEED    = WM_USER + 4;
  WM_FIGURA_INC    = WM_USER + 5;
  WM_SHOW_TIME     = WM_USER + 6;

type
  TFiguraState = (tsLeft, tsTop, tsRight, tsBotom);
  TFiguraType  = (tft_point, tft_line, tft_Rect, tft_l_, tft_L);
  TMoveType    = (tmt_Left, tmt_rRight, tmt_Down);
  TFiguraPos   =  array[1..4] of TPoint;


implementation

end.
