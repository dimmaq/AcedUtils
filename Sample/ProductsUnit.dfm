object ProductsForm: TProductsForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 370
  ClientWidth = 667
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
  object InsertButton: TSpeedButton
    Left = 8
    Top = 336
    Width = 133
    Height = 25
    Caption = 'Insert - '#1044#1086#1073#1072#1074#1080#1090#1100
    OnClick = InsertButtonClick
  end
  object EditButton: TSpeedButton
    Left = 148
    Top = 336
    Width = 133
    Height = 25
    Caption = 'Enter - '#1048#1079#1084#1077#1085#1080#1090#1100
    OnClick = EditButtonClick
  end
  object DeleteButton: TSpeedButton
    Left = 288
    Top = 336
    Width = 133
    Height = 25
    Caption = 'Delete - '#1059#1076#1072#1083#1080#1090#1100
    OnClick = DeleteButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 651
    Height = 317
    Caption = #1058#1086#1074#1072#1088#1099
    TabOrder = 0
    inline ProductsGrid: TGridFrame
      Left = 8
      Top = 20
      Width = 634
      Height = 285
      TabOrder = 0
      inherited DesignRect: TShape
        Width = 634
        Height = 285
      end
    end
  end
  object ExitButton: TButton
    Left = 537
    Top = 336
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'Esc - '#1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 1
    TabStop = False
  end
end
