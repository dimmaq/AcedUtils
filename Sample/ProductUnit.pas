unit ProductUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TProductForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ProductNameEdit: TEdit;
    Label2: TLabel;
    CategoryCombo: TComboBox;
    Label3: TLabel;
    SupplierCombo: TComboBox;
    Label4: TLabel;
    QuantityPerUnitEdit: TEdit;
    Label5: TLabel;
    UnitPriceEdit: TEdit;
    Label6: TLabel;
    UnitsInStockEdit: TEdit;
    Label7: TLabel;
    UnitsOnOrderEdit: TEdit;
    OkButton: TButton;
    CancelButton: TButton;
    DiscontinuedCheck: TCheckBox;
    NewCategoryButton: TButton;
    NewSupplierButton: TButton;
    LittleCheck: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure NewCategoryButtonClick(Sender: TObject);
    procedure NewSupplierButtonClick(Sender: TObject);
  private
    procedure FillCategories;
    procedure FillSuppliers;
  public
    { Public declarations }
  end;

var
  ProductForm: TProductForm;

implementation

uses AcedConsts, AcedStorage, DataTypes, AcedCommon, CategoryUnit,
  SupplierUnit;

{$R *.dfm}

procedure TProductForm.FormShow(Sender: TObject);
var
  Category: TCategoryObject;
  Supplier: TSupplierObject;
begin
  FillCategories;
  FillSuppliers;
  ProductNameEdit.Text := ProductObject.ProductName;
  Category := nil;
  if ProductObject.CategoryID <> 0 then
    Category := TCategoryObject(Categories.Search(ProductObject.CategoryID));
  if Category <> nil then
    CategoryCombo.ItemIndex := CategoriesCategoryNameIndex.ScanPointer(Category) + 1
  else
    CategoryCombo.ItemIndex := 0;
  QuantityPerUnitEdit.Text := ProductObject.QuantityPerUnit;
  UnitPriceEdit.Text := FormatCurr('0.00', ProductObject.UnitPrice);
  Supplier := nil;
  if ProductObject.SupplierID <> 0 then
    Supplier := TSupplierObject(Suppliers.Search(ProductObject.SupplierID));
  if Supplier <> nil then
    SupplierCombo.ItemIndex := SuppliersCompanyNameIndex.ScanPointer(Supplier) + 1
  else
    SupplierCombo.ItemIndex := 0;
  UnitsInStockEdit.Text := G_IntToStr(ProductObject.UnitsInStock);
  LittleCheck.Checked := ProductObject.Little;
  UnitsOnOrderEdit.Text := G_IntToStr(ProductObject.UnitsOnOrder);
  DiscontinuedCheck.Checked := ProductObject.Discontinued;
  ProductNameEdit.SetFocus;
end;

procedure TProductForm.FillCategories;
var
  Count, I: Integer;
  List: PSerializableObjectList;
begin
  with CategoryCombo do
  begin
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('(не выбрана)');
    Count := Categories.Count;
    List := CategoriesCategoryNameIndex.ItemList;
    for I := 0 to Count - 1 do
      Items.Add(TCategoryObject(List^[I]).CategoryName);
    Items.EndUpdate;
  end;
end;

procedure TProductForm.FillSuppliers;
var
  Count, I: Integer;
  List: PSerializableObjectList;
begin
  with SupplierCombo do
  begin
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('(не выбран)');
    Count := Suppliers.Count;
    List := SuppliersCompanyNameIndex.ItemList;
    for I := 0 to Count - 1 do
      Items.Add(TSupplierObject(List^[I]).CompanyName);
    Items.EndUpdate;
  end;
end;

procedure TProductForm.OkButtonClick(Sender: TObject);
var
  O: TProductObject;
  S: string;
  C: Currency;
  N: Integer;
begin
  ProductObject.ProductName := Trim(ProductNameEdit.Text);
  if Length(ProductObject.ProductName) = 0 then
  begin
    ProductNameEdit.SetFocus;
    ShowMessage('Наименование товара не может быть пустым.');
    Exit;
  end;
  O := TProductObject(ProductsProductNameIndex.Search(ProductObject.ProductName));
  if (O <> nil) and (O.ID <> ProductObject.ID) then
  begin
    ProductNameEdit.SetFocus;
    ShowMessage('Товар с таким наименованием уже есть в списке.');
    Exit;
  end;
  if CategoryCombo.ItemIndex > 0 then
    ProductObject.CategoryID := TCategoryObject(CategoriesCategoryNameIndex.
      ItemList^[CategoryCombo.ItemIndex - 1]).ID
  else
    ProductObject.CategoryID := 0;
  ProductObject.QuantityPerUnit := QuantityPerUnitEdit.Text;
  S := UnitPriceEdit.Text;
  G_AdjustSeparator(S);
  if not G_StrTo_Currency(S, C) then
  begin
    UnitPriceEdit.SetFocus;
    ShowMessage('Неправильное число введено в поле "Цена".');
    Exit;
  end;
  ProductObject.UnitPrice := C;
  if SupplierCombo.ItemIndex > 0 then
    ProductObject.SupplierID := TSupplierObject(SuppliersCompanyNameIndex.
      ItemList^[SupplierCombo.ItemIndex - 1]).ID
  else
    ProductObject.SupplierID := 0;
  if not G_StrTo_Integer(UnitsInStockEdit.Text, N) then
  begin
    UnitsInStockEdit.SetFocus;
    ShowMessage('Неправильное число введено в поле "На складе".');
    Exit;
  end;
  ProductObject.UnitsInStock := N;
  ProductObject.Little := LittleCheck.Checked;
  if not G_StrTo_Integer(UnitsOnOrderEdit.Text, N) then
  begin
    UnitsOnOrderEdit.SetFocus;
    ShowMessage('Неправильное число введено в поле "Ожидается".');
    Exit;
  end;
  ProductObject.UnitsOnOrder := N;
  ProductObject.Discontinued := DiscontinuedCheck.Checked;
  ModalResult := mrOk;
end;

procedure TProductForm.NewCategoryButtonClick(Sender: TObject);
begin
  CategoryObject := TCategoryObject(Categories.NewItem);
  if CategoryForm.ShowModal <> mrOk then
    Categories.CancelEdit(CategoryObject)
  else
  begin
    Categories.EndEdit(CategoryObject);
    if SaveCategories then
    begin
      FillCategories;
      CategoryCombo.ItemIndex := CategoriesCategoryNameIndex.
        ScanPointer(CategoryObject) + 1;
    end;
  end;
end;

procedure TProductForm.NewSupplierButtonClick(Sender: TObject);
begin
  SupplierObject := TSupplierObject(Suppliers.NewItem);
  if SupplierForm.ShowModal <> mrOk then
    Suppliers.CancelEdit(SupplierObject)
  else
  begin
    Suppliers.EndEdit(SupplierObject);
    if SaveSuppliers then
    begin
      FillSuppliers;
      SupplierCombo.ItemIndex := SuppliersCompanyNameIndex.
        ScanPointer(SupplierObject) + 1;
    end;
  end;
end;

end.
