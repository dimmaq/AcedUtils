unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, Menus, ImgList, ToolWin, Buttons, StdCtrls,
  ExtCtrls;

type
  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    ActionList: TActionList;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    actSuppliers: TAction;
    actCategories: TAction;
    actProducts: TAction;
    actExit: TAction;
    actSuppliersReport: TAction;
    actProductByCategoryReport: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ToolBar: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Bevel1: TBevel;
    actProductBySupplierReport: TAction;
    N3: TMenuItem;
    ToolButton1: TToolButton;
    SpeedButton7: TSpeedButton;
    actSuppliersCategoriesReport: TAction;
    ToolButton2: TToolButton;
    N8: TMenuItem;
    SpeedButton4: TSpeedButton;
    SpeedButton8: TSpeedButton;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actSuppliersExecute(Sender: TObject);
    procedure actCategoriesExecute(Sender: TObject);
    procedure actProductsExecute(Sender: TObject);
    procedure actSuppliersReportExecute(Sender: TObject);
    procedure actProductByCategoryReportExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure actProductBySupplierReportExecute(Sender: TObject);
    procedure actSuppliersCategoriesReportExecute(Sender: TObject);
  private
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses AcedCommon, AcedMemory, DataTypes, SuppliersUnit, CategoriesUnit,
  ProductsUnit, ReportsUnit, CheckCategoriesUnit, SelectSupplierUnit,
  AcedContainers, AcedAlgorithm;

{$R *.dfm}

var
  PreviousIdle: TIdleEvent;

procedure TMainForm.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  StatusBar.Panels[2].Text := 'Используемая память: ' + G_UIntToStr(G_GetTotalMemAllocated) + ' байт';
  if Assigned(PreviousIdle) then
    PreviousIdle(Sender, Done);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PreviousIdle := Application.OnIdle;
  Application.OnIdle := ApplicationIdle;
  LoadConfiguration;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveConfiguration;
end;

procedure TMainForm.actSuppliersExecute(Sender: TObject);
begin
  if LoadSuppliers then
    SuppliersForm.ShowModal;
end;

procedure TMainForm.actCategoriesExecute(Sender: TObject);
begin
  if LoadCategories then
    CategoriesForm.ShowModal;
end;

procedure TMainForm.actProductsExecute(Sender: TObject);
begin
  if LoadSuppliers and LoadCategories and LoadProducts then
    ProductsForm.ShowModal;
end;

procedure TMainForm.actProductBySupplierReportExecute(Sender: TObject);
begin
  if LoadSuppliers and LoadCategories and LoadProducts then
    if SelectSupplierForm.ShowModal = mrOk then
      MakeProductBySupplierReport;
end;

procedure TMainForm.actProductByCategoryReportExecute(Sender: TObject);
begin
  if LoadCategories and LoadProducts then
    if CheckCategoriesForm.ShowModal = mrOk then
      MakeProductByCategoryReport;
end;

procedure TMainForm.actSuppliersCategoriesReportExecute(Sender: TObject);
begin
  if LoadSuppliers and LoadCategories and LoadProducts then
    MakeSuppliersCategoriesReport;
end;

procedure TMainForm.actSuppliersReportExecute(Sender: TObject);
begin
  if LoadSuppliers and LoadProducts then
    MakeSupplierReport;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    actExit.Execute;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

end.

