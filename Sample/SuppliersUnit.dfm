object SuppliersForm: TSuppliersForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 407
  ClientWidth = 646
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
    Top = 374
    Width = 121
    Height = 25
    Caption = 'Insert - '#1044#1086#1073#1072#1074#1080#1090#1100
    OnClick = InsertButtonClick
  end
  object EditButton: TSpeedButton
    Left = 136
    Top = 374
    Width = 121
    Height = 25
    Caption = 'Enter - '#1048#1079#1084#1077#1085#1080#1090#1100
    OnClick = EditButtonClick
  end
  object DeleteButton: TSpeedButton
    Left = 264
    Top = 374
    Width = 121
    Height = 25
    Caption = 'Delete - '#1059#1076#1072#1083#1080#1090#1100
    OnClick = DeleteButtonClick
  end
  object PrintButton: TSpeedButton
    Left = 392
    Top = 374
    Width = 137
    Height = 25
    Caption = 'F4 - '#1055#1077#1095#1072#1090#1100' '#1089#1087#1080#1089#1082#1072
    OnClick = PrintButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 629
    Height = 357
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
    TabOrder = 0
    inline SuppliersGrid: TGridFrame
      Left = 8
      Top = 20
      Width = 613
      Height = 325
      TabOrder = 0
      inherited DesignRect: TShape
        Width = 613
        Height = 325
      end
    end
  end
  object ExitButton: TButton
    Left = 536
    Top = 374
    Width = 101
    Height = 25
    Cancel = True
    Caption = 'Esc - '#1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 1
    TabStop = False
  end
end
