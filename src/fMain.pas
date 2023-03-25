unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Edit, FMX.EditBox, FMX.NumberBox,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Memo.Types;

type
  TfrmMain = class(TForm)
    lLargeur: TLayout;
    cbLargeur: TCheckBox;
    edtLargeur: TNumberBox;
    lHauteur: TLayout;
    cbHauteur: TCheckBox;
    edtHauteur: TNumberBox;
    lATraiter: TLayout;
    lblATraiter: TLabel;
    mmoATraiter: TMemo;
    lTraitementEffectue: TLayout;
    lblTraitementEffectue: TLabel;
    mmoTraitementEffectue: TMemo;
    timTraitement: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure cbHauteurChange(Sender: TObject);
    procedure edtLargeurChange(Sender: TObject);
    procedure edtHauteurChange(Sender: TObject);
    procedure cbLargeurChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lATraiterDragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure lATraiterDragDrop(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure timTraitementTimer(Sender: TObject);
  private
    { Déclarations privées }
    procedure memoAdd(mmo: TMemo; s: string);
    procedure changeTailleFichier(NomFichier: string);
  public
    { Déclarations publiques }
    function AjouterFichierATraiter(NomFichier: string): Boolean;
    procedure logEffectuee(s: string);
    procedure logATraiter(s: string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses System.IOUtils, System.Threading, System.Math,
  ApplicationOpenFileEvent, uConfig;

function TfrmMain.AjouterFichierATraiter(NomFichier: string): Boolean;
var
  s: string;
begin
  s := NomFichier.ToLower;
  Result := s.EndsWith('.png') or s.EndsWith('.jpg') or s.EndsWith('.jpeg');
  Result := Result and tfile.exists(NomFichier);
  if Result then
    logATraiter(NomFichier)
  else
    logEffectuee('ERROR : fichier non traité.' + NomFichier);
end;

procedure TfrmMain.cbHauteurChange(Sender: TObject);
begin
  tconfig.changeHauteur := cbHauteur.IsChecked;
end;

procedure TfrmMain.cbLargeurChange(Sender: TObject);
begin
  tconfig.changeLargeur := cbLargeur.IsChecked;
end;

procedure TfrmMain.changeTailleFichier(NomFichier: string);
begin
  ttask.run(
    procedure
    var
      btm1, btm2: TBitmap;
      ratiow, ratioh, ratio: single;
      NomFichierDest, Extension: string;
      w, h: integer;
      x, y: integer;
    begin
      tthread.Synchronize(nil,
        procedure
        begin
          logEffectuee('Travail sur ' + NomFichier);
        end);
      if tfile.exists(NomFichier) and
        ((tconfig.changeLargeur and (tconfig.largeur > 0)) or
        (tconfig.changeHauteur and (tconfig.hauteur > 0))) then
      begin
        btm1 := TBitmap.CreateFromFile(NomFichier);
        try
{$IFDEF DEBUG}
          tthread.Synchronize(nil,
            procedure
            begin
              logEffectuee('btm1.width = ' + btm1.Width.tostring);
              logEffectuee('btm1.height = ' + btm1.height.tostring);
            end);
{$ENDIF}
          if tconfig.changeLargeur and (tconfig.largeur > 0) then
            ratiow := btm1.Width / tconfig.largeur
          else
            ratiow := 0;
          if tconfig.changeHauteur and (tconfig.hauteur > 0) then
            ratioh := btm1.height / tconfig.hauteur
          else
            ratioh := 0;
          if ((ratiow = 0) or (ratioh < ratiow)) and (ratioh > 0) then
            ratio := ratioh
          else if ((ratioh = 0) or (ratiow < ratioh)) and (ratiow > 0) then
            ratio := ratiow
          else
            ratio := 0;
          if (ratio = 0) then
            ratio := 1;
{$IFDEF DEBUG}
          tthread.Synchronize(nil,
            procedure
            begin
              logEffectuee('ratiow = ' + ratiow.tostring);
              logEffectuee('ratioh = ' + ratioh.tostring);
              logEffectuee('ratio = ' + ratio.tostring);
            end);
{$ENDIF}
          btm1.Resize(ceil(btm1.Width / ratio), ceil(btm1.height / ratio));
{$IFDEF DEBUG}
          // var
          // tempfilename := tpath.GetTempFileName +
          // tpath.GetExtension(NomFichier);
          // btm1.SaveToFile(tempfilename);
          // tthread.Synchronize(nil,
          // procedure
          // begin
          // logEffectuee('TempFileName : ' + tempfilename);
          // logEffectuee('btm1.width = ' + btm1.Width.tostring);
          // logEffectuee('btm1.height = ' + btm1.height.tostring);
          // end);
{$ENDIF}
          if ratiow = 0 then
            w := btm1.Width
          else
            w := tconfig.largeur;
          if ratioh = 0 then
            h := btm1.height
          else
            h := tconfig.hauteur;
{$IFDEF DEBUG}
          tthread.Synchronize(nil,
            procedure
            begin
              logEffectuee('w = ' + w.tostring);
              logEffectuee('h = ' + h.tostring);
            end);
{$ENDIF}
          btm2 := TBitmap.Create(w, h);
          try
            x := ((btm1.Width - w) div 2);
            y := ((btm1.height - h) div 2);
{$IFDEF DEBUG}
            tthread.Synchronize(nil,
              procedure
              begin
                logEffectuee('x = ' + x.tostring);
                logEffectuee('y = ' + y.tostring);
              end);
{$ENDIF}
            tthread.Synchronize(nil,
              procedure
              begin
                btm2.CopyFromBitmap(btm1, trect.Create(x, y, x + w,
                  y + h), 0, 0);
              end);
            Extension := tpath.GetExtension(NomFichier);
            NomFichierDest := NomFichier.Substring(0,
              NomFichier.Length - Extension.Length) + '-' + w.tostring + 'x' +
              h.tostring + Extension;
{$IFDEF DEBUG}
            tthread.Synchronize(nil,
              procedure
              begin
                logEffectuee('NomFichier = ' + NomFichier);
                logEffectuee('Extension = ' + Extension);
                logEffectuee('NomFichierDest = ' + NomFichierDest);
              end);
{$ENDIF}
            btm2.SaveToFile(NomFichierDest);
            tthread.Synchronize(nil,
              procedure
              begin
                logEffectuee('=> ' + NomFichierDest);
                timTraitement.Enabled := true;
              end);
          finally
            FreeAndNil(btm2);
          end;
        finally
          FreeAndNil(btm1);
        end;
      end
      else
        tthread.Synchronize(nil,
          procedure
          begin
            logEffectuee('* ERROR : traitement impossible');
            timTraitement.Enabled := true;
          end);
      tthread.Synchronize(nil,
        procedure
        begin
          logEffectuee('*****');
          timTraitement.Enabled := true;
        end);
    end);
end;

procedure TfrmMain.edtHauteurChange(Sender: TObject);
begin
  tconfig.hauteur := trunc(edtHauteur.Value);
end;

procedure TfrmMain.edtLargeurChange(Sender: TObject);
begin
  tconfig.largeur := trunc(edtLargeur.Value);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  s: string;
begin
  tconfig.save;
  if mmoATraiter.Lines.Count > 0 then
  begin
    s := tpath.Combine(tconfig.Folder, 'waiting.dat');
    mmoATraiter.Lines.SaveToFile(s);
    mmoATraiter.Lines.Clear;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if mmoATraiter.Lines.Count < 1 then
    CanClose := true
  else
    CanClose := mrYes = MessageDlg
      ('Il reste des images à traiter. Voulez-vous fermer quand même ?',
      tmsgdlgtype.mtConfirmation, [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbNo], 0);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  s: string;
  i: integer;
begin
  cbLargeur.IsChecked := tconfig.changeLargeur;
  edtLargeur.Value := tconfig.largeur;
  cbHauteur.IsChecked := tconfig.changeHauteur;
  edtHauteur.Value := tconfig.hauteur;
  s := tpath.Combine(tconfig.Folder, 'waiting.dat');
  if tfile.exists(s) then
  begin
    mmoATraiter.Lines.LoadFromFile(s);
    tfile.Delete(s);
  end
  else
    mmoATraiter.Lines.Clear;
  mmoTraitementEffectue.Lines.Clear;
  timTraitement.Enabled := true;
  ReferenceApplicationOpenFileEvent(AjouterFichierATraiter);
{$IFDEF MSWINDOWS}
  for i := 1 to paramcount do
    AjouterFichierATraiter(paramstr(i));
{$ENDIF}
end;

procedure TfrmMain.lATraiterDragDrop(Sender: TObject;

const Data: TDragObject;

const Point: TPointF);
var
  s: string;
begin
  for s in Data.Files do
    AjouterFichierATraiter(s);
end;

procedure TfrmMain.lATraiterDragOver(Sender: TObject;

const Data: TDragObject;

const Point: TPointF;

var Operation: TDragOperation);
begin
  if Length(Data.Files) > 0 then
    Operation := TDragOperation.Copy
  else
    Operation := TDragOperation.None;
end;

procedure TfrmMain.logATraiter(s: string);
begin
  memoAdd(mmoATraiter, s);
end;

procedure TfrmMain.logEffectuee(s: string);
begin
  memoAdd(mmoTraitementEffectue, s);
end;

procedure TfrmMain.memoAdd(mmo: TMemo; s: string);
begin
  mmo.Lines.Add(s);
  mmo.GoToTextEnd;
end;

procedure TfrmMain.timTraitementTimer(Sender: TObject);
begin
  timTraitement.Enabled := false;
  try
    if mmoATraiter.Lines.Count > 0 then
    begin
      changeTailleFichier(mmoATraiter.Lines[0]);
      mmoATraiter.Lines.Delete(0);
    end
    else
      timTraitement.Enabled := true;
  except
    timTraitement.Enabled := true;
  end;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
