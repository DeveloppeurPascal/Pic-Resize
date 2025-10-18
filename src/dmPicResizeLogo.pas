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
  File last update : 2025-10-16T10:42:51.801+02:00
  Signature : bc842dcee38e8dbe66d674071257325fbe825dfa
  ***************************************************************************
*)

unit dmPicResizeLogo;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TdmPRLogo = class(TDataModule)
    ilLogo: TImageList;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dmPRLogo: TdmPRLogo;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
