object SupplierForm: TSupplierForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1080#1083#1080' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1089#1074#1077#1076#1077#1085#1080#1081' '#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1077
  ClientHeight = 318
  ClientWidth = 533
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
    Width = 517
    Height = 265
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 102
      Height = 16
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 12
      Top = 208
      Width = 115
      Height = 16
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086':'
    end
    object Label4: TLabel
      Left = 12
      Top = 64
      Width = 51
      Height = 16
      Caption = #1057#1090#1088#1072#1085#1072':'
    end
    object Label5: TLabel
      Left = 196
      Top = 64
      Width = 101
      Height = 16
      Caption = #1043#1086#1088#1086#1076', '#1086#1073#1083#1072#1089#1090#1100':'
    end
    object Label7: TLabel
      Left = 12
      Top = 152
      Width = 51
      Height = 16
      Caption = #1048#1085#1076#1077#1082#1089':'
    end
    object Label8: TLabel
      Left = 136
      Top = 152
      Width = 102
      Height = 16
      Caption = #1058#1077#1083#1077#1092#1086#1085', '#1092#1072#1082#1089':'
    end
    object Label9: TLabel
      Left = 268
      Top = 208
      Width = 86
      Height = 16
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
    end
    object Label3: TLabel
      Left = 12
      Top = 100
      Width = 43
      Height = 16
      Caption = #1040#1076#1088#1077#1089':'
    end
    object Label6: TLabel
      Left = 308
      Top = 152
      Width = 134
      Height = 16
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1072#1076#1088#1077#1089':'
    end
    object CompanyNameEdit: TEdit
      Left = 120
      Top = 24
      Width = 385
      Height = 24
      TabOrder = 0
    end
    object ContactPersonEdit: TEdit
      Left = 12
      Top = 228
      Width = 241
      Height = 24
      TabOrder = 7
    end
    object CountryEdit: TEdit
      Left = 72
      Top = 60
      Width = 109
      Height = 24
      TabOrder = 1
    end
    object CityRegionEdit: TEdit
      Left = 308
      Top = 60
      Width = 197
      Height = 24
      TabOrder = 2
    end
    object PostalCodeEdit: TEdit
      Left = 12
      Top = 172
      Width = 109
      Height = 24
      TabOrder = 4
    end
    object PhoneFaxEdit: TEdit
      Left = 136
      Top = 172
      Width = 157
      Height = 24
      TabOrder = 5
    end
    object CommentsEdit: TEdit
      Left = 268
      Top = 228
      Width = 237
      Height = 24
      TabOrder = 8
    end
    object AddressMemo: TMemo
      Left = 72
      Top = 96
      Width = 433
      Height = 45
      TabOrder = 3
    end
    object HttpEmailEdit: TEdit
      Left = 308
      Top = 172
      Width = 197
      Height = 24
      TabOrder = 6
    end
  end
  object OkButton: TButton
    Left = 260
    Top = 284
    Width = 133
    Height = 25
    Caption = 'Enter - '#1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 1
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 400
    Top = 284
    Width = 125
    Height = 25
    Cancel = True
    Caption = 'Esc - '#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 2
  end
end
