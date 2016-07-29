unit frameBuscaDepartamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameBusca, Vcl.StdCtrls, Vcl.Buttons, Departamento,
  Vcl.Mask, RxToolEdit, RxCurrEdit, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TBuscaDepartamento = class(TBusca)
    edtCodigo: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtDepartamento: TEdit;
    imgPilates: TImage;
    imgEstetica: TImage;
    imgFisioterapia: TImage;
    imgSelecione: TImage;
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  private
    FDepartamento :TDepartamento;

    procedure pesquisa;override;
    procedure setaImagem(ID_Departamento :integer);
  protected
    procedure inicializa;override;
    procedure efetuaBusca(parametro :Variant);override;
    procedure carregar(const ID :integer = 0);override;
  public
    procedure BeforeDestruction; override;
    procedure limpa;override;

    property Departamento :TDepartamento read FDepartamento;
  end;

var
  BuscaDepartamento: TBuscaDepartamento;

implementation

{$R *.dfm}

{ TBuscaDepartamento }

procedure TBuscaDepartamento.BeforeDestruction;
begin
  inherited;
  if Assigned(FDepartamento) then
    FreeAndNil(FDepartamento);
end;

procedure TBuscaDepartamento.carregar(const ID: integer);
begin
  inherited;
  if not assigned(FDepartamento) then
    FDepartamento := TDepartamento.Create;
  FDepartamento.Load(ID);

  if not assigned(FDepartamento) then
    exit;

  edtCodigo.AsInteger   := FDepartamento.ID;
  edtDepartamento.Text  := FDepartamento.Departamento;
  setaImagem(FDepartamento.ID);
end;

procedure TBuscaDepartamento.efetuaBusca(parametro: Variant);
begin
  FDepartamento.Load(parametro);

  if FDepartamento.ID > 0 then
  begin
    carregaDados;
    keybd_event(VK_TAB,0,0,0);
  end
  else
    Pesquisa;
end;

procedure TBuscaDepartamento.FrameEnter(Sender: TObject);
begin
  inicializa;
end;

procedure TBuscaDepartamento.FrameExit(Sender: TObject);
begin
  if not assigned(FDepartamento) or (FDepartamento.ID = 0) then
    edtCodigo.Clear;
  if assigned(FDepartamento) and FDepartamento.isEmpty then
    FreeAndNil(FDepartamento);
end;

procedure TBuscaDepartamento.inicializa;
begin
  inherited;
  if FInicializou then
    exit;

  if not assigned(FDepartamento) then
    FDepartamento                := TDepartamento.Create;
  self.edtCodigo.OnChange  := self.edtIdChange;
  self.edtCodigo.OnEnter   := self.edtIdEnter;
  self.edtDepartamento.OnEnter := self.edtEnter;
end;

procedure TBuscaDepartamento.limpa;
begin
  if FcarregandoDados then
  begin
    FcarregandoDados := false;
    Exit;
  end;

  if not (TForm(self.Owner).ActiveControl = self.edtCodigo) then
    edtCodigo.Clear;
  if Assigned(FDepartamento) then
    FDepartamento.Clear;
  edtDepartamento.Clear;
  setaImagem(0);
end;

procedure TBuscaDepartamento.pesquisa;
var SQL, titulo :String;
begin
  titulo := 'Selecione o departamento...';
  SQL    := 'Select d.ID, d.Departamento from DEPARTAMENTOS d ';
  self.abrePesquisa(SQl, titulo);
end;

procedure TBuscaDepartamento.setaImagem(ID_Departamento: integer);
begin
  imgSelecione.Visible    := ID_Departamento = 0;
  imgFisioterapia.Visible := ID_Departamento = 1;
  imgPilates.Visible      := ID_Departamento = 2;
  imgEstetica.Visible     := ID_Departamento = 3;
end;

end.