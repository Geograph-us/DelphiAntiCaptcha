program AGDemo;

{$APPTYPE CONSOLE}

uses
  SysUtils, AntiGate;

var sFileName:    String;
    sURL:         String;
    sAntiGateKey: String;
    sResult:      String;

begin
  try

    if (ParamCount < 2) then
    begin
      WriteLn ('*** Anticaptcha service AntiGate.com demo by http://geograph.us ***' + sLineBreak);
      WriteLn ('Usage: ' + sLineBreak + 'AGDemo.exe AGKey Filename|URL' + sLineBreak);
      WriteLn ('Example: ' + sLineBreak + 'AGDemo.exe c54fa68f4d5s6df245s4d5c1a4s5d8f4 c:\image.jpg');
      WriteLn ('AGDemo.exe c54fa68f4d5s6df245s4d5c1a4s5d8f4 image.jpg>Result.txt');
      WriteLn ('AGDemo.exe c54fa68f4d5s6df245s4d5c1a4s5d8f4 http://site.com/image.jpg');
      exit;
    end;

    sAntiGateKey := ParamStr(1);

    if (Copy(ParamStr(2),1,4) = 'http') then
    begin
      sURL := ParamStr(2);
      RecognizeAG(sURL, sAntiGateKey, sResult, '');
    end else
    begin
      sFileName := ParamStr(2);
      RecognizeAG(sFileName, sAntiGateKey, sResult);
    end;

    WriteLn (sResult);

  except
    on E:Exception do
      WriteLn(E.Classname, ': ', E.Message);
  end;
end.
