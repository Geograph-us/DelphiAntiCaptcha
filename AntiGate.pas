unit AntiGate;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

  Модуль AntiGate - служит для распознавания каптчи, используя сервис AntiGate.com (АнтиКаптча)
  Для работы с HTTP-протоколом используется компонент Synapse (который в 100% раз круче глючного Indy :) )
  Автор: Geograph
  Дата: 30.04.2011
  Сайт: http://geograph.us
  E-mail: geograph@list.ru

  -------------

  Функция RecognizeAG - умеет распознавать картинку используя сервис AntiGate.com из потока, по URL-ссылке и из картинки на компьютере.
  Параметры функции:
  ImageData   - поток, содержащий каптчу
  ImageFile   - путь к файлу каптчи
  ImageURL    - ссылка на каптчу
  AGKey       - ключ сервиса AntiGate.com для распознавания
  Cookies     - при распознавании по URL можно передать в функцию куки, для открытия каптчи, когда это необходимо
  CaptchaRes  - буффер, в который попадает текст каптчи, либо сообщение об ошибке
  MinLen      - 0 по-умолчанию, помечает минимальную длину текста каптчи
  MaxLen      - 0 - без ограничений, помечает максимальную длину каптчи
  Phrase      - 0 по-умолчанию, 1 помечает что каптча состоит из нескольких слов
  Regsense    - 0 по-умолчанию, 1 помечает что текст каптчи чувствителен к регистру
  Numeric     - 0 по-умолчанию, 1 помечает что текст каптчи состоит только из цифр, 2 помечает что на каптче нет цифр
  Calc        - 0 по-умолчанию, 1 помечает что цифры на каптче должны быть высчитаны
  Russian     - 0 по умолчанию, 1 помечает что вводить нужно только русский текст, 2 - русский или английский
  Функция возвращает:
  Номер каптчи (CaptchaID), либо 0 при ошибке

  -------------

  Функция GetBalanceAG - выводит текущий баланс на сервисе AntiGate.com
  Параметры функции:
  AGKey       - ключ сервиса AntiGate.com для распознавания
  Функция возвращает:
  Строку с содержанием баланса, либо 'N/A' при ошибке

  -------------

  Функция ReportBadAG - отправляет жалобу о неверно распознанной каптче в сервис AntiGate.com
  Параметры функции:
  AGKey       - ключ сервиса AntiGate.com для распознавания
  CaptchaID   - номер каптчи, которая была неверно распознана
  Функция возвращает:
  Строку с результатом ответа от сервиса (OK_REPORT_RECORDED - в случае успеха), либо 'N/A' при ошибке

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

interface

uses
  SysUtils, Classes, HttpSend, SynAUtil;

  // Распознать картинку их потока
  function RecognizeAG(ImageData: TMemoryStream; AGKey: String; var CaptchaRes: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // Распознать картинку из файла
  function RecognizeAG(ImageFile: String;        AGKey: String; var CaptchaRes: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // Распознать картинку по ссылке
  function RecognizeAG(ImageURL: String;         AGKey: String; var CaptchaRes: String; Cookies: String; MinLen: integer=0; MaxLen: integer=0; Numeric: integer=0; Phrase: integer=0; RegSense: integer=0; Calc: integer=0; Russian: integer=0): Integer; overload;

  // Получить ваш текущий денежный баланс
  function GetBalanceAG(AGKey: String): String;

  // Пожаловаться на неправильно разгаданный текст
  function ReportBadAG(AGKey: String; CaptchaID: Integer): String;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

const
  AntiServer  = 'antigate.com'; // сервер АнтиКапчи
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
// Пожаловаться на неправильно разгаданный текст
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
// Получить ваш текущий денежный баланс
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
// Распознать картинку по ссылке
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
// Распознать картинку из файла
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
// Распознать картинку их потока
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
