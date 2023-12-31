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
