unit AntiGate;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

  ������ AntiGate - ������ ��� ������������� ������, ��������� ������ AntiGate.com (����������)
  ��� ������ � HTTP-���������� ������������ ��������� Synapse (������� � 100% ��� ����� �������� Indy :) )
  �����: Geograph
  ����: 30.04.2011
  ����: http://geograph.us
  E-mail: geograph@list.ru

  -------------

  ������� RecognizeAG - ����� ������������ �������� ��������� ������ AntiGate.com �� ������, �� URL-������ � �� �������� �� ����������.
  ��������� �������:
  ImageData   - �����, ���������� ������
  ImageFile   - ���� � ����� ������
  ImageURL    - ������ �� ������
  AGKey       - ���� ������� AntiGate.com ��� �������������
  Cookies     - ��� ������������� �� URL ����� �������� � ������� ����, ��� �������� ������, ����� ��� ����������
  CaptchaRes  - ������, � ������� �������� ����� ������, ���� ��������� �� ������
  MinLen      - 0 ��-���������, �������� ����������� ����� ������ ������
  MaxLen      - 0 - ��� �����������, �������� ������������ ����� ������
  Phrase      - 0 ��-���������, 1 �������� ��� ������ ������� �� ���������� ����
  Regsense    - 0 ��-���������, 1 �������� ��� ����� ������ ������������ � ��������
  Numeric     - 0 ��-���������, 1 �������� ��� ����� ������ ������� ������ �� ����, 2 �������� ��� �� ������ ��� ����
  Calc        - 0 ��-���������, 1 �������� ��� ����� �� ������ ������ ���� ���������
  Russian     - 0 �� ���������, 1 �������� ��� ������� ����� ������ ������� �����, 2 - ������� ��� ����������
  ������� ����������:
  ����� ������ (CaptchaID), ���� 0 ��� ������

  -------------

  ������� GetBalanceAG - ������� ������� ������ �� ������� AntiGate.com
  ��������� �������:
  AGKey       - ���� ������� AntiGate.com ��� �������������
  ������� ����������:
  ������ � ����������� �������, ���� 'N/A' ��� ������

  -------------

  ������� ReportBadAG - ���������� ������ � ������� ������������ ������ � ������ AntiGate.com
  ��������� �������:
  AGKey       - ���� ������� AntiGate.com ��� �������������
  CaptchaID   - ����� ������, ������� ���� ������� ����������
  ������� ����������:
  ������ � ����������� ������ �� ������� (OK_REPORT_RECORDED - � ������ ������), ���� 'N/A' ��� ������

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

interface

uses
  SysUtils, Classes, HttpSend, SynAUtil;

  // ���������� �������� �� ������
  function RecognizeAG(ImageData: TMemoryStream; AGKey: String; var CaptchaRes: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // ���������� �������� �� �����
  function RecognizeAG(ImageFile: String;        AGKey: String; var CaptchaRes: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // ���������� �������� �� ������
  function RecognizeAG(ImageURL: String;         AGKey: String; var CaptchaRes: String; Cookies: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // �������� ��� ������� �������� ������
  function GetBalanceAG(AGKey: String): String;

  // ������������ �� ����������� ����������� �����
  function ReportBadAG(AGKey: String; CaptchaID: Integer): String;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

const
  AntiServer  = 'antigate.com'; // ������ ���������
  CRLF        = #$0D#$0A; // \r\n

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

implementation

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

function GetFormValue(Bound, Parametr, Value:String): String;
begin
  Result := '--' + Bound + CRLF + 'Content-Disposition: form-data; name="' +
            Parametr + '"' + CRLF + CRLF + Value + CRLF;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// ������������ �� ����������� ����������� �����
function ReportBadAG(AGKey: String; CaptchaID: Integer): String;
var HTTP: THTTPSend;
    Resp: TStringList;
begin
  Result := 'N/A';
  if (Trim(AGKey) = '') then exit;

  HTTP := THTTPSend.Create;
  Resp := TStringList.Create;

  if(HTTP.HTTPMethod('GET', 'http://' + AntiServer + '/res.php?key=' + AGKey +
      '&action=reportbad&id=' + Trim(IntToStr(CaptchaID)))) then
  begin
    Resp.LoadFromStream(HTTP.Document);
    if(trim(Resp.Strings[0]) <> '') then
      Result := Resp.Strings[0];
  end;

  HTTP.Free;
  Resp.Free;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// �������� ��� ������� �������� ������
function GetBalanceAG(AGKey: String): String;
var HTTP: THTTPSend;
    Resp: TStringList;
begin
  Result := 'N/A';
  if (Trim(AGKey) = '') then exit;

  HTTP := THTTPSend.Create;
  Resp := TStringList.Create;

  if(HTTP.HTTPMethod('GET', 'http://' + AntiServer + '/res.php?key=' + AGKey +
      '&action=getbalance')) then
  begin
    Resp.LoadFromStream(HTTP.Document);
    if(trim(Resp.Strings[0]) <> '') then
      Result := Resp.Strings[0];
  end;

  HTTP.Free;
  Resp.Free;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// ���������� �������� �� ������
function RecognizeAG(ImageURL:        String;
                     AGKey:           String;
                     var CaptchaRes:  String;
                     Cookies:         String;
                     MinLen:          integer=0;
                     MaxLen:          integer=0;
                     Numeric:         integer=0;
                     Phrase:          integer=0;
                     RegSense:        integer=0;
                     Calc:            integer=0;
                     Russian:         integer=0
                     ): Integer; overload;
var HTTP: THTTPSend;
begin
  Result := 0;
  CaptchaRes := 'ERROR_IN_AG_MODULE';

  HTTP := THTTPSend.Create;
  HTTP.Cookies.Text := Cookies;

  if(HTTP.HTTPMethod('GET', ImageURL)) then
  begin
    Result := RecognizeAG(HTTP.Document, AGKey, CaptchaRes, MinLen, MaxLen,
                          Numeric, Phrase, RegSense, Calc, Russian);
  end else CaptchaRes := 'ERROR_CONNECT';

  HTTP.Free;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// ���������� �������� �� �����
function RecognizeAG(ImageFile:       String;
                     AGKey:           String;
                     var CaptchaRes:  String;
                     MinLen:          integer=0;
                     MaxLen:          integer=0;
                     Numeric:         integer=0;
                     Phrase:          integer=0;
                     RegSense:        integer=0;
                     Calc:            integer=0;
                     Russian:         integer=0
                     ): Integer; overload;

var Image:  TMemoryStream;

begin
  Image := TMemoryStream.Create;
  Image.LoadFromFile(ImageFile);

  Result := RecognizeAG(Image, AGKey, CaptchaRes, MinLen, MaxLen, Numeric,
                        Phrase, RegSense, Calc, Russian);

  Image.Free;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// ���������� �������� �� ������
function RecognizeAG(ImageData:       TMemoryStream;
                     AGKey:           String;
                     var CaptchaRes:  String;
                     MinLen:          integer=0;
                     MaxLen:          integer=0;
                     Numeric:         integer=0;
                     Phrase:          integer=0;
                     RegSense:        integer=0;
                     Calc:            integer=0;
                     Russian:         integer=0
                     ): Integer; overload;

var Bound, ftype:  String;
    s, CaptchaID: String;
    i:             Integer;
    Resp:          TStringList;
    Image:         TMemoryStream;
    HTTP:          THTTPSend;

begin

  Result := 0;
  ftype := 'image/pjpeg';

  Resp := TStringList.Create;
  Image := TMemoryStream.Create;
  Image.LoadFromStream(ImageData);

  HTTP := THTTPSend.Create;

  Randomize;
  Bound := '-----' + IntToHex(random(65535), 8) + '_boundary';

  Resp.Text := GetFormValue(Bound, 'method', 'post');
  Resp.Text := Resp.Text + GetFormValue(Bound, 'key', AGKey);
  Resp.Text := Resp.Text + GetFormValue(Bound, 'soft_id', '248');
  if (MinLen > 0)        then Resp.Text := Resp.Text + GetFormValue(Bound, 'min_len',   IntToStr(MinLen));
  if (MaxLen > 0)        then Resp.Text := Resp.Text + GetFormValue(Bound, 'max_len',   IntToStr(MaxLen));
  if (Numeric > 0)       then Resp.Text := Resp.Text + GetFormValue(Bound, 'numeric',   IntToStr(Numeric));
  if (Phrase > 0)        then Resp.Text := Resp.Text + GetFormValue(Bound, 'phrase',    IntToStr(Phrase));
  if (RegSense > 0)      then Resp.Text := Resp.Text + GetFormValue(Bound, 'regsense',  IntToStr(RegSense));
  if (Calc > 0)          then Resp.Text := Resp.Text + GetFormValue(Bound, 'calc',      IntToStr(Calc));
  if (Russian > 0)       then Resp.Text := Resp.Text + GetFormValue(Bound, 'is_russian',IntToStr(Russian));
  Resp.Text := Resp.Text + '--' + Bound + CRLF;

  Resp.Text := Resp.Text + 'Content-Disposition: form-data; name="file"; filename="image.jpg"' + CRLF + 
						   'Content-Type: ' + ftype + CRLF + CRLF;
  WriteStrToStream(HTTP.Document, Resp.Text);
  HTTP.Document.CopyFrom(Image, 0);
  Resp.Text := CRLF + '--' + Bound + '--' + CRLF;
  WriteStrToStream(HTTP.Document, Resp.Text);

  CaptchaRes := 'ERROR_IN_AG_MODULE';

  HTTP.MimeType := 'multipart/form-data; boundary=' + Bound;
  if (HTTP.HTTPMethod('POST', 'http://' + AntiServer + '/in.php')) then
  begin
    Resp.LoadFromStream(HTTP.Document);
    s := Resp.Strings[0];
    CaptchaRes := s;
    CaptchaID := '';
    if (Pos('ERROR_', s) < 1) then
    begin
      if (Pos('OK|', s) > 0) then CaptchaID := StringReplace(s, 'OK|', '', [rfReplaceAll]);
      if (CaptchaID <> '') then
      begin
        Result := StrToInt(CaptchaID);
        for i := 0 to 20 do
        begin
          Sleep(3000);
          HTTP.Clear;
          if (HTTP.HTTPMethod('GET', 'http://' + AntiServer + '/res.php?key=' +
              AGKey + '&action=get&id=' + CaptchaID)) then
          begin
            Resp.LoadFromStream(HTTP.Document);
            s := Resp.Strings[0];
            if (Pos('ERROR_', s) > 0) then
            begin
              CaptchaRes := s;
              break;
            end;
            if (Pos('OK|', s) > 0) then
            begin
              CaptchaRes := StringReplace(s, 'OK|', '', [rfReplaceAll]);
              break;
            end;
          end;
          CaptchaRes := 'ERROR_TIMEOUT';
        end;
      end else CaptchaRes := 'ERROR_BAD_CAPTCHA_ID';
    end;
  end else CaptchaRes := 'ERROR_CONNECT';

  Resp.Free;
  Image.Free;
  HTTP.Free;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

end.
