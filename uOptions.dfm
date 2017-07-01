object fOptions: TfOptions
  Left = 0
  Top = 0
  Caption = 'Options'
  ClientHeight = 249
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    332
    249)
  PixelsPerInch = 96
  TextHeight = 13
  object cbColorGridLine: TColorBox
    Left = 35
    Top = 45
    Width = 145
    Height = 22
    TabOrder = 0
  end
  object cbGridColor: TCheckBox
    Left = 16
    Top = 22
    Width = 97
    Height = 17
    Caption = 'Grid Color:'
    TabOrder = 1
    OnClick = cbGridColorClick
  end
  object BitBtn1: TBitBtn
    Left = 241
    Top = 208
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btnCloseClick
    ExplicitTop = 183
  end
  object cbFiguraColor: TColorBox
    Left = 16
    Top = 104
    Width = 145
    Height = 22
    TabOrder = 3
  end
  object text1: TStaticText
    Left = 8
    Top = 81
    Width = 66
    Height = 17
    Caption = 'Figura Color:'
    TabOrder = 4
  end
  object tbZoom: TTrackBar
    Left = 8
    Top = 165
    Width = 300
    Height = 28
    Max = 30
    Min = 10
    Position = 20
    TabOrder = 5
    OnChange = tbZoomChange
  end
  object StaticText1: TStaticText
    Left = 16
    Top = 142
    Width = 67
    Height = 17
    Caption = 'Figura Zoom:'
    TabOrder = 6
  end
  object stZoomNumber: TStaticText
    Left = 280
    Top = 142
    Width = 16
    Height = 17
    Caption = '20'
    TabOrder = 7
  end
end
