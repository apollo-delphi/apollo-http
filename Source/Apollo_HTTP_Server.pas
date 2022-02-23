unit Apollo_HTTP_Server;

interface

uses
  Apollo_HTTP,
  IdContext,
  IdCustomHTTPServer,
  IdHTTPServer;

type
  THandleRequestFunc = function(aRequestInfo: TIdHTTPRequestInfo): string of object;

  THTTPServer = class
  private
    FIdHTTPServer: TIdHTTPServer;
    FOnHandleRequest: THandleRequestFunc;
    procedure IdHTTPServerCommand(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    procedure Run(const aPort: Integer);
    constructor Create;
    destructor Destroy; override;
    property OnHandleRequest: THandleRequestFunc read FOnHandleRequest write FOnHandleRequest;
  end;

implementation

uses
  System.SysUtils;

{ THTTPServer }

constructor THTTPServer.Create;
begin
  FIdHTTPServer := TIdHTTPServer.Create(nil);
  FIdHTTPServer.OnCommandGet := IdHTTPServerCommand;
  FIdHTTPServer.OnCommandOther := IdHTTPServerCommand;
end;

destructor THTTPServer.Destroy;
begin
  FIdHTTPServer.Free;

  inherited;
end;

procedure THTTPServer.IdHTTPServerCommand(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if Assigned(FOnHandleRequest) then
    AResponseInfo.ContentText := FOnHandleRequest(ARequestInfo);
end;

procedure THTTPServer.Run(const aPort: Integer);
begin
  FIdHTTPServer.DefaultPort := aPort;
  FIdHTTPServer.Active := True;
end;

end.
