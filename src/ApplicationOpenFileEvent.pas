unit ApplicationOpenFileEvent;

interface

type
  tApplicationOpenFileEvent = reference to function(FileName: string): boolean;

procedure ReferenceApplicationOpenFileEvent
  (CallBack: tApplicationOpenFileEvent);

implementation

{$IF Defined(IOS)}
{$ELSEIF Defined(MACOS)}

uses System.SysUtils, Macapi.ObjectiveC, Macapi.CoreFoundation,
  Macapi.CocoaTypes, Macapi.Foundation, Macapi.AppKit, FMX.Helpers.Mac,
  FMX.Forms;

type
  ILocalApplicationDelegate = interface(NSApplicationDelegate)
    ['{7CAB9802-144B-4F82-8301-EC9181983D02}']
    // procedure onMenuClicked(sender: NSMenuItem); cdecl;
    // need IFMXApplicationDelegate to declare and use onMenuClicked
    function application(theApplication: Pointer; openFile: CFStringRef)
      : boolean; cdecl;
  end;

  TLocalApplicationDelegate = class(TOCLocal, ILocalApplicationDelegate)
  public
    function applicationShouldTerminate(Notification: NSNotification)
      : NSInteger; cdecl;
    procedure applicationWillTerminate(Notification: NSNotification); cdecl;
    procedure applicationDidFinishLaunching(Notification
      : NSNotification); cdecl;
    function applicationDockMenu(sender: NSApplication): NSMenu; cdecl;
    procedure applicationDidHide(Notification: NSNotification); cdecl;
    procedure applicationDidUnhide(Notification: NSNotification); cdecl;
    // procedure onMenuClicked(sender: NSMenuItem); cdecl;
    // need IFMXApplicationDelegate to declare and use onMenuClicked
    function application(theApplication: Pointer; openFile: CFStringRef)
      : boolean; cdecl;
  end;

var
  OpenFileCallBack: tApplicationOpenFileEvent;
  OldApplicationDelegate: NSApplicationDelegate;

function TLocalApplicationDelegate.applicationShouldTerminate
  (Notification: NSNotification): NSInteger; cdecl;
begin
  if assigned(OldApplicationDelegate) then
    Result := OldApplicationDelegate.applicationShouldTerminate(Notification)
  else
    Result := NSInteger(0);
end;

procedure TLocalApplicationDelegate.applicationWillTerminate
  (Notification: NSNotification); cdecl;
begin
  if assigned(OldApplicationDelegate) then
    OldApplicationDelegate.applicationWillTerminate(Notification);
end;

procedure TLocalApplicationDelegate.applicationDidFinishLaunching
  (Notification: NSNotification); cdecl;
begin
  if assigned(OldApplicationDelegate) then
    OldApplicationDelegate.applicationDidFinishLaunching(Notification);
end;

function TLocalApplicationDelegate.applicationDockMenu(sender: NSApplication)
  : NSMenu; cdecl;
begin
  if assigned(OldApplicationDelegate) then
    Result := OldApplicationDelegate.applicationDockMenu(sender)
  else
    Result := nil;
end;

procedure TLocalApplicationDelegate.applicationDidHide
  (Notification: NSNotification); cdecl;
begin
  if assigned(OldApplicationDelegate) then
    OldApplicationDelegate.applicationDidHide(Notification);
end;

procedure TLocalApplicationDelegate.applicationDidUnhide
  (Notification: NSNotification); cdecl;
begin
  if assigned(OldApplicationDelegate) then
    OldApplicationDelegate.applicationDidUnhide(Notification);
end;

// procedure TLocalApplicationDelegate.onMenuClicked(sender: NSMenuItem); cdecl;
// begin
// if assigned(OldApplicationDelegate) then
// OldApplicationDelegate.onMenuClicked(sender);
// end;

function TLocalApplicationDelegate.application(theApplication: Pointer;
  openFile: CFStringRef): boolean; cdecl;
var
  Range: CFRange;
  S: String;
begin
  Result := assigned(OpenFileCallBack);
  if not Result then
    Exit;
  Range.location := 0;
  Range.length := CFStringGetLength(openFile);
  SetLength(S, Range.length);
  CFStringGetCharacters(openFile, Range, PChar(S));
  try
    Result := OpenFileCallBack(S);
  except
    on E: Exception do
    begin
      FMX.Forms.application.HandleException(E);
      Result := False;
    end;
  end;
end;

{$ENDIF}

procedure ReferenceApplicationOpenFileEvent
  (CallBack: tApplicationOpenFileEvent);
{$IF Defined(IOS)}
{$ELSEIF Defined(MACOS)}
var
  NSApp: NSApplication;
  LocalApplicationDelegate: TLocalApplicationDelegate;
{$ENDIF}
begin
{$IF Defined(IOS)}
{$ELSEIF Defined(MACOS)}
  NSApp := TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication);
  OldApplicationDelegate := NSApp.Delegate;
  LocalApplicationDelegate := TLocalApplicationDelegate.Create;
  NSApp.setDelegate(ILocalApplicationDelegate(LocalApplicationDelegate));
  OpenFileCallBack := CallBack;
{$ENDIF}
end;

initialization

{$IF Defined(IOS)}
{$ELSEIF Defined(MACOS)}
  OpenFileCallBack := nil;
{$ENDIF}

end.
