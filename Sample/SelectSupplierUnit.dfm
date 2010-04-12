object SelectSupplierForm: TSelectSupplierForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 353
  ClientWidth = 580
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
    Width = 418
    Height = 16
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072', '#1087#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1087#1086#1089#1090#1088#1086#1080#1090#1089#1103' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 563
    Height = 277
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
    TabOrder = 0
    inline SuppliersGrid: TGridFrame
      Left = 8
      Top = 20
      Width = 547
      Height = 245
      TabOrder = 0
      inherited DesignRect: TShape
        Width = 547
        Height = 245
      end
    end
  end
  object OkButton: TButton
    Left = 320
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Enter - '#1044#1072#1083#1077#1077
    Default = True
    TabOrder = 1
    TabStop = False
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 454
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
