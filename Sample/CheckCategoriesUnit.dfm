object CheckCategoriesForm: TCheckCategoriesForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
  ClientHeight = 353
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ScreenSnap = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 12
    Top = 8
    Width = 187
    Height = 16
    Caption = #1054#1090#1084#1077#1090#1100#1090#1077' '#1085#1091#1078#1085#1099#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 525
    Height = 277
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1090#1086#1074#1072#1088#1086#1074
    TabOrder = 0
    inline CategoriesGrid: TCheckFrame
      Left = 8
      Top = 20
      Width = 509
      Height = 245
      TabOrder = 0
      inherited DesignRect: TShape
        Width = 509
        Height = 245
      end
    end
  end
  object OkButton: TButton
    Left = 282
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Enter - '#1044#1072#1083#1077#1077
    Default = True
    ModalResult = 1
    TabOrder = 1
    TabStop = False
  end
  object CancelButton: TButton
    Left = 416
    Top = 320
    Width = 117
    Height = 25
    Cancel = True
    Caption = 'Esc - '#1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 2
    TabStop = False
  end
end
