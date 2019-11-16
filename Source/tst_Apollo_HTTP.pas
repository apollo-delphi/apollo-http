unit tst_Apollo_HTTP;

interface

uses
  Apollo_HTTP,
  DUnitX.TestFramework;

type
  [TestFixture]
  TestTHTTP = class
  strict private
    FHTTP: THTTP;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [TestCase('TestGet', 'https://github.com;<!DOCTYPE', ';')]
    procedure TestGet(const aURL, _Result: string);
    [TestCase('TestGetStream', 'https://raw.githubusercontent.com/apollo-delphi/apollo-dpm/master/README.md;Apollo Delphi Package Manager', ';')]
    procedure TestGetStream(const aURL, _Result: string);
  end;

implementation

uses
  System.Classes;

{ TestTHTTP }

procedure TestTHTTP.Setup;
begin
  FHTTP := THTTP.Create;
end;

procedure TestTHTTP.TearDown;
begin
  FHTTP := nil;
end;

procedure TestTHTTP.TestGet(const aURL, _Result: string);
var
  sHTML: string;
begin
  sHTML := FHTTP.Get(aURL);

  Assert.IsMatch(_Result, sHTML);
end;

procedure TestTHTTP.TestGetStream(const aURL, _Result: string);
var
  MS: TMemoryStream;
  SL: TStringList;
begin
  MS := nil;
  SL := TStringList.Create;
  try
    MS := FHTTP.GetStream(aURL);
    SL.LoadFromStream(MS);

    Assert.IsMatch(_Result, SL.Text);
  finally
    SL.Free;
    MS.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHTTP);

end.
