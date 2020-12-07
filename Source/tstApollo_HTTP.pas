unit tstApollo_HTTP;

interface

uses
  Apollo_HTTP,
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestHTTP = class
  strict private
    FHTTP: THTTP;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [TestCase('TestGet', 'https://github.com/;<!DOCTYPE', ';')]
    procedure TestGet(const aURL, _result: string);
  end;

implementation

uses
  System.SysUtils;

{ TTestHTTP }

procedure TTestHTTP.Setup;
begin
  FHTTP := THTTP.Create;
end;

procedure TTestHTTP.TearDown;
begin
  FreeAndNil(FHTTP);
end;

procedure TTestHTTP.TestGet(const aURL, _result: string);
var
  sHTML: string;
begin
  sHTML := FHTTP.Get(aURL);

  Assert.IsMatch(_result, sHTML);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestHTTP);

end.
