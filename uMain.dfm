object fTetris: TfTetris
  Left = 0
  Top = 0
  Caption = 'Tetris'
  ClientHeight = 594
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.SheetOfGlass = True
  Menu = mm1
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pbTetris: TPaintBox
    Left = 0
    Top = 73
    Width = 333
    Height = 502
    Align = alClient
    OnPaint = pbTetrisPaint
    ExplicitLeft = 72
    ExplicitTop = 144
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object statBar: TStatusBar
    Left = 0
    Top = 575
    Width = 333
    Height = 19
    Panels = <
      item
        Width = 120
      end
      item
        Width = 60
      end
      item
        Alignment = taRightJustify
        BiDiMode = bdRightToLeft
        ParentBiDiMode = False
        Width = 50
      end>
  end
  object pnlPanel: TPanel
    Left = 0
    Top = 0
    Width = 333
    Height = 73
    Align = alTop
    TabOrder = 1
    object imgFigura: TImage
      Left = 7
      Top = 4
      Width = 66
      Height = 63
    end
    object btnRotate: TSpeedButton
      Left = 79
      Top = 30
      Width = 23
      Height = 37
      HelpType = htKeyword
      Caption = '0'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        F9F9F9EFEFEFE6E6E6E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5
        E5E6E6E6EAEAEAEFEFEFFFFFFFFFFFFFF4F4F4DFDFDFCFCDCCCEC8C1D1C7BCCF
        C7BEA37E5AAC7034AC7034AC7034AC7034AC7034A5815DE0E0E0FFFFFFFFFFFF
        FFFFFFF1EBE6E6D3BEECD7B8F6DFB4FEEDC7AF7337FDBC28FCB81DFCB81DFDC0
        33AF7337DBC0A4FFFFFFFFFFFFFFFFFFF2E8DEE0C4A5FCE1A8FBDC9DFBDDA0FD
        ECC8B4783BF8B62AF6AC14F8BA35B4783BCEA77FFFFFFFFFFFFFFFFFFFF9F4EF
        D8B68FF8D694F5CF86F1CD8CE0C096EDDECEB97D3EF1B339F3B943EEA824F1B3
        39C1894BF6EEE6FFFFFFFFFFFFE6D0B8DDB37AEEC174ECC27DD4AC81EFE0D0FF
        FFFFBF8343F0BD5CBF8343ECB148E8A83BD2994ADDBD9BFFFFFFFFFFFFD6AD80
        E5B771E7B56AD7A76AE9D3BCFFFFFFFFFFFFC48847C48847D4A979D0974FE3A8
        4EE1AB57CF9E69FFFFFFFFFFFFCD9555E8B86EE6B469CD9555FFFFFFFFFFFFFF
        FFFFD7AA78E7CCADFFFFFFCB8F4BE5B061E7B466CB8F4BFFFFFFFFFFFFD09450
        E9B86FE6B46CD09450FFFFFFEACFB0DCAF7CFFFFFFFFFFFFFFFFFFD39A5AE7B8
        74EABB76D39A5AFFFFFFFFFFFFDEAD74E8B871E8B570DFA861E1B683D79B54D7
        9B54FFFFFFFFFFFFF0DBC1E4B678EBC086ECC387E3BA8AFFFFFFFFFFFFECCDA7
        E6B36BEDBC76F1C67EDCA059F7D38ADCA059FFFFFFF6E8D6E8C090F3D39EF2CF
        9EEDC792F2DBC0FFFFFFFFFFFFFBF3EAE5AE6AF7CE84F2C27AF9D48AF7CE84E2
        A65CF7E8D6F2D4ABF8DEB2F8DEB5FBE5BCEFCDA2FCF7F2FFFFFFFFFFFFFFFFFF
        EFC897E7AB60FDD88EF9CC82FCD58AE7AB60FEF4E1FDEBCBFCEACAFDEECEF4DA
        B8FAF0E4FFFFFFFFFFFFFFFFFFF5DAB9EAAE63FFE094FED98DFED98DFFDD91EA
        AE63FEF5E3FCEDD3FAE8CEF8E5CDFCF5EBFFFFFFFFFFFFFFFFFFFFFFFFF1C48C
        EDB166EDB166EDB166EDB166EDB166F1C48CFCF2E7FBF0E3FCF5ECFEFCFAFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Layout = blGlyphTop
      ParentFont = False
      Visible = False
      OnClick = btnRotateClick
    end
    object txt1: TStaticText
      Left = 79
      Top = 4
      Width = 14
      Height = 27
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object tmr1: TTimer
    Enabled = False
    OnTimer = tmr1Timer
    Left = 56
    Top = 88
  end
  object mm1: TMainMenu
    Left = 16
    Top = 88
    object File1: TMenuItem
      Caption = 'Game'
      object New: TMenuItem
        Caption = '&New'
        OnClick = NewClick
      end
      object Stop: TMenuItem
        Caption = '&Stop'
        Enabled = False
        OnClick = StopClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Save: TMenuItem
        Caption = 'S&ave'
        Enabled = False
      end
      object Open: TMenuItem
        Caption = '&Open'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
    object Options: TMenuItem
      Caption = 'Options'
      OnClick = OptionsClick
    end
  end
end
