object ProductForm: TProductForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1080#1083#1080' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1090#1086#1074#1072#1088#1077
  ClientHeight = 262
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ScreenSnap = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 481
    Height = 209
    Caption = #1058#1086#1074#1072#1088
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 28
      Width = 69
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 12
      Top = 152
      Width = 75
      Height = 16
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object Label3: TLabel
      Left = 12
      Top = 76
      Width = 71
      Height = 16
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
    end
    object Label4: TLabel
      Left = 251
      Top = 76
      Width = 100
      Height = 16
      Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103':'
    end
    object Label5: TLabel
      Left = 368
      Top = 76
      Width = 36
      Height = 16
      Caption = #1062#1077#1085#1072':'
    end
    object Label6: TLabel
      Left = 252
      Top = 152
      Width = 70
      Height = 16
      Caption = #1053#1072' '#1089#1082#1083#1072#1076#1077':'
    end
    object Label7: TLabel
      Left = 368
      Top = 152
      Width = 75
      Height = 16
      Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103':'
    end
    object ProductNameEdit: TEdit
      Left = 96
      Top = 24
      Width = 373
      Height = 24
      TabOrder = 0
    end
    object CategoryCombo: TComboBox
      Left = 12
      Top = 96
      Width = 225
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
    end
    object SupplierCombo: TComboBox
      Left = 12
      Top = 172
      Width = 225
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 6
    end
    object QuantityPerUnitEdit: TEdit
      Left = 252
      Top = 96
      Width = 101
      Height = 24
      TabOrder = 3
    end
    object UnitPriceEdit: TEdit
      Left = 368
      Top = 96
      Width = 101
      Height = 24
      TabOrder = 4
    end
    object UnitsInStockEdit: TEdit
      Left = 252
      Top = 172
      Width = 101
      Height = 24
      TabOrder = 7
    end
    object UnitsOnOrderEdit: TEdit
      Left = 368
      Top = 172
      Width = 101
      Height = 24
      TabOrder = 9
    end
    object NewCategoryButton: TButton
      Left = 100
      Top = 64
      Width = 137
      Height = 25
      Caption = #1053#1086#1074#1072#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1103
      TabOrder = 1
      OnClick = NewCategoryButtonClick
    end
    object NewSupplierButton: TButton
      Left = 100
      Top = 140
      Width = 137
      Height = 25
      Caption = #1053#1086#1074#1099#1081' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
      TabOrder = 5
      OnClick = NewSupplierButtonClick
    end
    object LittleCheck: TCheckBox
      Left = 324
      Top = 136
      Width = 65
      Height = 17
      Caption = #1052#1072#1083#1086
      TabOrder = 8
    end
  end
  object OkButton: TButton
    Left = 224
    Top = 228
    Width = 133
    Height = 25
    Caption = 'Enter - '#1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 364
    Top = 228
    Width = 125
    Height = 25
    Cancel = True
    Caption = 'Esc - '#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 3
  end
  object DiscontinuedCheck: TCheckBox
    Left = 8
    Top = 236
    Width = 189
    Height = 17
    Caption = #1055#1086#1089#1090#1072#1074#1082#1080' '#1087#1088#1077#1082#1088#1072#1097#1077#1085#1099
    TabOrder = 1
  end
end
