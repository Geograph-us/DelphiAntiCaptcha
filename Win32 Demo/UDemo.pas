unit UDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellApi, AntiGate;

type
  TForm1 = class(TForm)
    edtAntiGateKey: TLabeledEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnBalance: TButton;
    btnBrowse: TButton;
    edtImageFile: TLabeledEdit;
    btnImageFile: TButton;
    edtImageURL: TLabeledEdit;
    btnImageURL: TButton;
    OpenDialog: TOpenDialog;
    btnReportBad: TButton;
    mResult: TMemo;
    procedure Label2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBalanceClick(Sender: TObject);
    procedure btnImageFileClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnImageURLClick(Sender: TObject);
    procedure btnReportBadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CaptchaID: Integer;

implementation

{$R *.dfm}

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.btnBalanceClick(Sender: TObject);
begin
  btnBalance.Caption := '������: ' + GetBalanceAG(edtAntiGateKey.Text);
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if(OpenDialog.Execute(Handle)) then
  begin
    edtImageFile.Text := OpenDialog.FileName;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.btnImageFileClick(Sender: TObject);
var s: String;
begin
  mResult.Lines.Strings[0] := '���� �������������...';
  Application.ProcessMessages;
  // ���������� ������ �� �����
  CaptchaID := RecognizeAG(edtImageFile.Text, edtAntiGateKey.Text, s);
  mResult.Lines.Strings[0] := s; // ������� ���������
  Beep;    // ����� �� �������, ��� ��������� :)
  mResult.Lines.SaveToFile('Result.txt');  // ��������� ������ � ����
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.btnImageURLClick(Sender: TObject);
var s: String;
begin
  mResult.Lines.Strings[0] := '���� �������������...';
  Application.ProcessMessages;
  // ���������� ������ �� ������
  CaptchaID := RecognizeAG(edtImageURL.Text, edtAntiGateKey.Text, s, '');
  mResult.Lines.Strings[0] := s;  // ������� ���������
  Beep;    // ����� �� �������, ��� ��������� :)
  mResult.Lines.SaveToFile('Result.txt');  // ��������� ������ � ����
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.btnReportBadClick(Sender: TObject);
begin
  // ���������� ������ �� ������� ������������ ������ � ������� CaptchaID
  mResult.Lines.Strings[0] := ReportBadAG(edtAntiGateKey.Text, CaptchaID);
  Beep;    // ����� �� �������, ��� ��������� :)
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.FormCreate(Sender: TObject);
begin
  //������ ���������� ������ ����, � �� ��� ��� ���� ������
  Screen.Cursors[crHandPoint] := LoadCursor(0,PChar(IDC_HAND));
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

procedure TForm1.Label2Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://geograph.us', nil, nil, SW_SHOW)
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

end.
