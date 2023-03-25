unit uParam;

interface

type
  tParam = class
  private
    Fhauteur: cardinal;
    Flargeur: cardinal;
    FChanged: boolean;
    FchangeLargeur: boolean;
    FchangeHauteur: boolean;
    procedure Sethauteur(const Value: cardinal);
    procedure Setlargeur(const Value: cardinal);
    procedure SetchangeHauteur(const Value: boolean);
    procedure SetchangeLargeur(const Value: boolean);
  protected
    function paramFileName: string;
  public
    function paramFolder: string;
    property changeLargeur: boolean read FchangeLargeur write SetchangeLargeur;
    property largeur: cardinal read Flargeur write Setlargeur;
    property changeHauteur: boolean read FchangeHauteur write SetchangeHauteur;
    property hauteur: cardinal read Fhauteur write Sethauteur;
    constructor create;
    destructor destroy;
    procedure save;
    procedure load;
  end;

var
  param: tParam;

implementation

uses System.SysUtils, System.IOUtils;

{ tParam }

const
  paramVersionInfo: byte = 1;

constructor tParam.create;
begin
  FChanged := false;
  FchangeLargeur := true;
  Flargeur := 500;
  FchangeHauteur := false;
  Fhauteur := 0;
  load;
end;

destructor tParam.destroy;
begin
  if FChanged then
    save;
end;

procedure tParam.load;
var
  nomFichier: string;
  fichier: file;
  version: byte;
begin
  nomFichier := paramFileName;
  if tfile.Exists(nomFichier) then
  begin
    AssignFile(fichier, paramFileName);
{$I+}
    Reset(fichier, 1);
{$I-}
    blockread(fichier, version, sizeof(paramVersionInfo));
    if (version > 0) then
    begin
      blockread(fichier, Flargeur, sizeof(Flargeur));
      blockread(fichier, FchangeLargeur, sizeof(FchangeLargeur));
      blockread(fichier, Fhauteur, sizeof(Fhauteur));
      blockread(fichier, FchangeHauteur, sizeof(FchangeHauteur));
    end;
    closefile(fichier);
  end;
end;

function tParam.paramFileName: string;
begin
  result := TPath.Combine(paramFolder, 'config.dat');
end;

function tParam.paramFolder: string;
begin
  result := TPath.Combine(TPath.Combine(TPath.GetDocumentsPath, 'OlfSoftware'),
    'PicResize');
  if not tdirectory.Exists(result) then
    tdirectory.CreateDirectory(result);
end;

procedure tParam.save;
var
  fichier: file;
begin
  if FChanged then
  begin
    AssignFile(fichier, paramFileName);
{$I+}
    Rewrite(fichier, 1);
{$I-}
    blockwrite(fichier, paramVersionInfo, sizeof(paramVersionInfo));
    blockwrite(fichier, Flargeur, sizeof(Flargeur));
    blockwrite(fichier, FchangeLargeur, sizeof(FchangeLargeur));
    blockwrite(fichier, Fhauteur, sizeof(Fhauteur));
    blockwrite(fichier, FchangeHauteur, sizeof(FchangeHauteur));
    closefile(fichier);
    FChanged := false;
  end;
end;

procedure tParam.SetchangeHauteur(const Value: boolean);
begin
  FChanged := FChanged or (FchangeHauteur <> Value);
  FchangeHauteur := Value;
end;

procedure tParam.SetchangeLargeur(const Value: boolean);
begin
  FChanged := FChanged or (FchangeLargeur <> Value);
  FchangeLargeur := Value;
end;

procedure tParam.Sethauteur(const Value: cardinal);
begin
  FChanged := FChanged or (Fhauteur <> Value);
  Fhauteur := Value;
end;

procedure tParam.Setlargeur(const Value: cardinal);
begin
  FChanged := FChanged or (Flargeur <> Value);
  Flargeur := Value;
end;

initialization

param := tParam.create;

finalization

if assigned(param) then
begin
  param.save;
  FreeAndNil(param);
end;

end.
