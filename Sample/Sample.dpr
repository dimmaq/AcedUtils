program Sample;

uses
  AcedMemory in '..\Source\AcedMemory.pas',
  Forms,
  AcedConsts in '..\Source\AcedConsts.pas',
  AcedBinary in '..\Source\AcedBinary.pas',
  AcedStrings in '..\Source\AcedStrings.pas',
  AcedCommon in '..\Source\AcedCommon.pas',
  AcedCompression in '..\Source\AcedCompression.pas',
  AcedCrypto in '..\Source\AcedCrypto.pas',
  AcedAlgorithm in '..\Source\AcedAlgorithm.pas',
  AcedStreams in '..\Source\AcedStreams.pas',
  AcedContainers in '..\Source\AcedContainers.pas',
  AcedNetWait in '..\Source\AcedNetWait.pas' {NetWaitNotifyForm},
  AcedStorage in '..\Source\AcedStorage.pas',
  AcedExcelReport in '..\Source\AcedExcelReport.pas',
  AcedGrids in '..\Source\Grids\AcedGrids.pas',
  AcedCheckFrame in '..\Source\Grids\AcedCheckFrame.pas' {CheckFrame: TFrame},
  AcedGridFrame in '..\Source\Grids\AcedGridFrame.pas' {GridFrame: TFrame},
  MainUnit in 'MainUnit.pas' {MainForm},
  DataTypes in 'DataTypes.pas',
  SuppliersUnit in 'SuppliersUnit.pas' {SuppliersForm},
  SupplierUnit in 'SupplierUnit.pas' {SupplierForm},
  CategoriesUnit in 'CategoriesUnit.pas' {CategoriesForm},
  CategoryUnit in 'CategoryUnit.pas' {CategoryForm},
  ProductsUnit in 'ProductsUnit.pas' {ProductsForm},
  ProductUnit in 'ProductUnit.pas' {ProductForm},
  CheckCategoriesUnit in 'CheckCategoriesUnit.pas' {CheckCategoriesForm},
  SelectSupplierUnit in 'SelectSupplierUnit.pas' {SelectSupplierForm},
  ReportsUnit in 'ReportsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AcedUtils Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSuppliersForm, SuppliersForm);
  Application.CreateForm(TSupplierForm, SupplierForm);
  Application.CreateForm(TCategoriesForm, CategoriesForm);
  Application.CreateForm(TCategoryForm, CategoryForm);
  Application.CreateForm(TProductsForm, ProductsForm);
  Application.CreateForm(TProductForm, ProductForm);
  Application.CreateForm(TCheckCategoriesForm, CheckCategoriesForm);
  Application.CreateForm(TSelectSupplierForm, SelectSupplierForm);
  Application.Run;
end.
