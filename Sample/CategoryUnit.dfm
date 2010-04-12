object CategoryForm: TCategoryForm
  Left = 288
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1080#1083#1080' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
  ClientHeight = 270
  ClientWidth = 447
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
  object OkButton: TButton
    Left = 304
    Top = 206
    Width = 133
    Height = 25
    Caption = 'Enter - '#1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 304
    Top = 238
    Width = 133
    Height = 23
    Cancel = True
    Caption = 'Esc - '#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 116
    Width = 285
    Height = 145
    Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
    TabOrder = 1
    object PictureImage: TImage
      Left = 116
      Top = 16
      Width = 161
      Height = 120
      Center = True
    end
    object LoadImageButton: TButton
      Left = 8
      Top = 48
      Width = 101
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 0
      OnClick = LoadImageButtonClick
    end
    object SaveImageButton: TButton
      Left = 8
      Top = 80
      Width = 101
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
      OnClick = SaveImageButtonClick
    end
    object ClearImageButton: TButton
      Left = 8
      Top = 112
      Width = 101
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      OnClick = ClearImageButtonClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 429
    Height = 101
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 102
      Height = 16
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 8
      Top = 66
      Width = 86
      Height = 16
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
    end
    object CategoryNameEdit: TEdit
      Left = 120
      Top = 24
      Width = 297
      Height = 24
      TabOrder = 0
    end
    object CommentsEdit: TEdit
      Left = 120
      Top = 62
      Width = 297
      Height = 24
      TabOrder = 1
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    DefaultExt = 'bmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1089' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077#1084
    Left = 324
    Top = 152
  end
  object SavePictureDialog: TSavePictureDialog
    DefaultExt = 'bmp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
    Left = 360
    Top = 152
  end
end
