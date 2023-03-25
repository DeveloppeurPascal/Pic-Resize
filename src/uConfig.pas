unit uConfig;

interface

type
  TConfig = class
  private
    class var FFolder: string;
    class function GetChangeHauteur: boolean; static;
    class function GetchangeLargeur: boolean; static;
    class function GetHauteur: cardinal; static;
    class function Getlargeur: cardinal; static;
    class procedure SetchangeHauteur(const Value: boolean); static;
    class procedure SetchangeLargeur(const Value: boolean); static;
    class procedure Sethauteur(const Value: cardinal); static;
    class procedure Setlargeur(const Value: cardinal); static;
  public
    /// <summary>
    /// Fix height of the final resized pictures
    /// </summary>
    class property ChangeLargeur: boolean read GetchangeLargeur
      write SetchangeLargeur;
    /// <summary>
    /// Width of the resized pictures
    /// </summary>
    class property Largeur: cardinal read Getlargeur write Setlargeur;
    /// <summary>
    /// Fix width of the final resized pictures
    /// </summary>
    class property ChangeHauteur: boolean read GetChangeHauteur
      write SetchangeHauteur;
    /// <summary>
    /// Height of the resized pictures
    /// </summary>
    class property Hauteur: cardinal read GetHauteur write Sethauteur;
    /// <summary>
    /// Return folder of the storrage
    /// </summary>
    class property Folder: string read FFolder;
    /// <summary>
    /// Save parameters to a storrage file
    /// </summary>
    class procedure Save;
    /// <summary>
    /// Reload parameters from storrage
    /// </summary>
    class procedure Load;
  end;

implementation

{ TConfig }

uses Olf.RTL.Params, System.IOUtils;

const
  CParamChangeHauteur = 'forceWidth';
  CParamHauteur = 'width';
  CParamChangeLargeur = 'forceHeight';
  CParamLargeur = 'height';

class function TConfig.GetChangeHauteur: boolean;
begin
  result := tparams.getValue(CParamChangeHauteur, false);
end;

class function TConfig.GetchangeLargeur: boolean;
begin
  result := tparams.getValue(CParamChangeLargeur, true);
end;

class function TConfig.GetHauteur: cardinal;
begin
  result := tparams.getValue(CParamHauteur, 0);
end;

class function TConfig.Getlargeur: cardinal;
begin
  result := tparams.getValue(CParamLargeur, 500);
end;

class procedure TConfig.Load;
begin
  tparams.Load;
end;

class procedure TConfig.Save;
begin
  tparams.Save;
end;

class procedure TConfig.SetchangeHauteur(const Value: boolean);
begin
  tparams.setValue(CParamChangeHauteur, Value);
end;

class procedure TConfig.SetchangeLargeur(const Value: boolean);
begin
  tparams.setValue(CParamChangeLargeur, Value);
end;

class procedure TConfig.Sethauteur(const Value: cardinal);
begin
  tparams.setValue(CParamHauteur, Value);
end;

class procedure TConfig.Setlargeur(const Value: cardinal);
begin
  tparams.setValue(CParamLargeur, Value);
end;

initialization

{$IFDEF DEBUG}
  TConfig.FFolder := tpath.combine(tpath.combine(tpath.GetDocumentsPath,
  'OlfSoftware-debug'), 'PicResize-debug');
{$ELSE}
  TConfig.FFolder := tpath.combine(tpath.combine(tpath.GetHomePath,
  'OlfSoftware'), 'PicResize');
{$ENDIF}
tparams.setFolderName(TConfig.Folder);

end.
