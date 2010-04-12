object NetWaitNotifyForm: TNetWaitNotifyForm
  Left = 332
  Top = 339
  Width = 469
  Height = 183
  BorderIcons = [biSystemMenu]
  Caption = #1057#1077#1090#1077#1074#1072#1103' '#1079#1072#1076#1077#1088#1078#1082#1072'...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object FileInfoLabel: TLabel
    Left = 0
    Top = 12
    Width = 461
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = #1054#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1086#1090#1082#1088#1099#1090#1080#1080' '#1092#1072#1081#1083#1072
    Transparent = True
    WordWrap = True
  end
  object Label1: TLabel
    Left = 25
    Top = 60
    Width = 411
    Height = 16
    Caption = #1042#1086#1079#1084#1086#1078#1085#1086', '#1101#1090#1086#1090' '#1092#1072#1081#1083' '#1079#1072#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085' '#1076#1088#1091#1075#1080#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1084'.'
  end
  object Label2: TLabel
    Left = 16
    Top = 80
    Width = 434
    Height = 16
    Caption = #1046#1076#1080#1090#1077', '#1087#1086#1082#1072' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1073#1091#1076#1077#1090' '#1089#1085#1103#1090#1072' '#1080#1083#1080' '#1086#1090#1084#1077#1085#1080#1090#1077' '#1086#1087#1077#1088#1072#1094#1080#1102'.'
  end
  object btnRetry: TButton
    Left = 44
    Top = 120
    Width = 177
    Height = 25
    Caption = #1055#1086#1087#1088#1086#1073#1086#1074#1072#1090#1100' '#1077#1097#1077' '#1088#1072#1079
    Default = True
    TabOrder = 0
    OnClick = btnRetryClick
  end
  object btnCancel: TButton
    Left = 248
    Top = 120
    Width = 165
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
