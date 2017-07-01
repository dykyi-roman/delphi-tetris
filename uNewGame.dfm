object fNewGame: TfNewGame
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'New Game'
  ClientHeight = 148
  ClientWidth = 191
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 79
    Top = 27
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object seHeight: TSpinEdit
    Left = 107
    Top = 24
    Width = 46
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object seWidth: TSpinEdit
    Left = 24
    Top = 24
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object BitBtn1: TBitBtn
    Left = 54
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
end
