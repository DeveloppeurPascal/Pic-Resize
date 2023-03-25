program PicResize;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPicResize in 'fPicResize.pas' {frmPicResize},
  uParam in 'uParam.pas',
  ApplicationOpenFileEvent in 'ApplicationOpenFileEvent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPicResize, frmPicResize);
  Application.Run;
end.
