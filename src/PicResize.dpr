(* C2PP
  ***************************************************************************

  Pic Resize

  Copyright 2019-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://picresize.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/Pic-Resize

  ***************************************************************************
  File last update : 2025-10-16T10:42:51.799+02:00
  Signature : 8e2a65ce0946757eb69719b84c4662c9ba70c688
  ***************************************************************************
*)

program PicResize;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uConfig in 'uConfig.pas',
  ApplicationOpenFileEvent in 'ApplicationOpenFileEvent.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  dmPicResizeLogo in 'dmPicResizeLogo.pas' {dmPRLogo: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmPRLogo, dmPRLogo);
  Application.Run;
end.
