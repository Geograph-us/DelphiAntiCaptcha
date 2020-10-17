object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1080#1084#1077#1088' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' '#1084#1086#1076#1091#1083#1103' AntiGate'
  ClientHeight = 295
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edtAntiGateKey: TLabeledEdit
    Left = 8
    Top = 24
    Width = 265
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = 'AntiGate '#1082#1083#1102#1095':'
    MaxLength = 32
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 278
    Width = 387
    Height = 17
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 296
      Top = 0
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = '2011 '#169' Geograph'
      Enabled = False
    end
    object Label2: TLabel
      Left = 4
      Top = 0
      Width = 93
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://geograph.us'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      OnClick = Label2Click
    end
  end
  object btnBalance: TButton
    Left = 279
    Top = 22
    Width = 108
    Height = 25
    Caption = #1041#1072#1083#1072#1085#1089
    TabOrder = 2
    OnClick = btnBalanceClick
  end
  object btnBrowse: TButton
    Left = 281
    Top = 72
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = btnBrowseClick
  end
  object edtImageFile: TLabeledEdit
    Left = 8
    Top = 72
    Width = 273
    Height = 21
    EditLabel.Width = 150
    EditLabel.Height = 13
    EditLabel.Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1090#1100' '#1082#1072#1087#1090#1095#1091' '#1080#1079' '#1092#1072#1081#1083#1072':'
    TabOrder = 4
    Text = 'captcha.jpg'
  end
  object btnImageFile: TButton
    Left = 308
    Top = 70
    Width = 75
    Height = 25
    Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1090#1100
    TabOrder = 5
    OnClick = btnImageFileClick
  end
  object edtImageURL: TLabeledEdit
    Left = 8
    Top = 115
    Width = 294
    Height = 21
    EditLabel.Width = 155
    EditLabel.Height = 13
    EditLabel.Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1090#1100' '#1082#1072#1087#1090#1095#1091' '#1087#1086' '#1089#1089#1099#1083#1082#1077':'
    TabOrder = 6
    Text = 'http://upload.wikimedia.org/wikipedia/commons/6/69/Captcha.jpg'
  end
  object btnImageURL: TButton
    Left = 308
    Top = 113
    Width = 75
    Height = 25
    Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1090#1100
    TabOrder = 7
    OnClick = btnImageURLClick
  end
  object btnReportBad: TButton
    Left = 8
    Top = 247
    Width = 371
    Height = 25
    Caption = #1055#1086#1078#1072#1083#1086#1074#1072#1090#1100#1089#1103' '#1085#1072' '#1085#1077#1087#1088#1072#1074#1080#1083#1100#1085#1086' '#1088#1072#1079#1075#1072#1076#1072#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
    TabOrder = 8
    OnClick = btnReportBadClick
  end
  object mResult: TMemo
    Left = 8
    Top = 144
    Width = 371
    Height = 97
    Alignment = taCenter
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      #1056#1077#1079#1091#1083#1100#1090#1072#1090)
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #1042#1089#1077' '#1090#1080#1087#1099' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081'|*.jpg;*.jpeg;*.gif;*.png|'#1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' JPEG (' +
      '*.jpg;*.jpeg)|*.jpg;*.jpeg|'#1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' GIF (*.gif)|*.gif|'#1048#1079#1086#1073#1088#1072#1078 +
      #1077#1085#1080#1077' PNG (*.png)|*.png|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 264
    Top = 336
  end
end
