unit ProductsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, AcedGridFrame;

type
  TProductsForm = class(TForm)
    GroupBox1: TGroupBox;
    InsertButton: TSpeedButton;
    EditButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    ExitButton: TButton;
    ProductsGrid: TGridFrame;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
  private
    procedure ProductsGridGetData(Sender: TObject);
    procedure ProductsGridDblClick(Sender: TObject; Index: Integer);
    procedure ProductsGridKeyDown(Sender: TObject; Index: Integer;
      Key: Word; Shift: TShiftState);
    function ProductsGridGetColor(Sender: TObject; RowIndex,
      ColumnIndex: Integer; Selected, Inactive: Boolean): TColor;
    procedure InsertProduct;
    procedure EditProduct(Index: Integer);
    procedure UpdateProduct;
    procedure DeleteProduct(Index: Integer);
  public
    { Public declarations }
  end;

var
  ProductsForm: TProductsForm;

implementation

uses AcedConsts, AcedCommon, AcedStorage, DataTypes, ProductUnit;

{$R *.dfm}

procedure TProductsForm.FormShow(Sender: TObject);
begin
  with ProductsGrid do
  begin
    Activate;
    if RowCount > 0 then
      SelectRow(0);
    SetFocus;
  end;
end;

procedure TProductsForm.FormHide(Sender: TObject);
begin
  ProductsGrid.Deactivate;
end;

procedure TProductsForm.FormCreate(Sender: TObject);
begin
  with ProductsGrid do
  begin
    Init(7);
    with ColumnInfo[0]^ do
    begin
      Title := '№ п/п';
      Alignment := taCenter;
      Width := 42;
    end;
    with ColumnInfo[1]^ do
    begin
      Title := 'Товар';
      Alignment := taLeftJustify;
      Width := 172;
    end;
    with ColumnInfo[2]^ do
    begin
      Title := 'Поставщик';
      Alignment := taLeftJustify;
      Width := 108;
    end;
    with ColumnInfo[3]^ do
    begin
      Title := 'Ед. изм.';
      Alignment := taCenter;
      Width := 60;
    end;
    with ColumnInfo[4]^ do
    begin
      Title := 'Цена';
      Alignment := taRightJustify;
      Width := 72;
    end;
    with ColumnInfo[5]^ do
    begin
      Title := 'На складе';
      Alignment := taRightJustify;
      Width := 76;
    end;
    with ColumnInfo[6]^ do
    begin
      Title := 'Ожидается';
      Alignment := taRightJustify;
      Width := 76;
    end;
    OnGetData := ProductsGridGetData;
    OnDoubleClick := ProductsGridDblClick;
    OnKeyDown := ProductsGridKeyDown;
    OnGetColor := ProductsGridGetColor;
    ApplyFormats;
  end;
end;

procedure TProductsForm.ProductsGridGetData(Sender: TObject);
var
  I, Count: Integer;
  List: PSerializableObjectList;
  P: ^AnsiString;
  Supplier: TSupplierObject;
  O: TProductObject;
begin
  List := ProductsProductNameIndex.ItemList;
  Count := Products.Count;
  with ProductsGrid do
  begin
    RowCount := Count;
    P := Pointer(ItemList);
    for I := 0 to Count - 1 do
    begin
      O := TProductObject(List^[I]);
      P^ := G_IntToStr(I + 1);
      Inc(P);
      P^ := O.ProductName;
      Inc(P);
      Supplier := nil;
      if O.SupplierID <> 0 then
        Supplier := TSupplierObject(Suppliers.Search(O.SupplierID));
      if Supplier <> nil then
        P^ := Supplier.CompanyName
      else
        P^ := '(не выбран)';
      Inc(P);
      P^ := O.QuantityPerUnit;
      Inc(P);
      P^ := FormatCurr('#,##0.00р''.''', O.UnitPrice);
      Inc(P);
      P^ := G_IntToStr(O.UnitsInStock);
      Inc(P);
      P^ := G_IntToStr(O.UnitsOnOrder);
      Inc(P);
    end;
  end;
end;

procedure TProductsForm.ProductsGridDblClick(Sender: TObject; Index: Integer);
begin
  EditProduct(Index);
end;

procedure TProductsForm.ProductsGridKeyDown(Sender: TObject; Index: Integer;
  Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_INSERT:  InsertProduct;
    VK_RETURN:  EditProduct(Index);
    VK_DELETE:  DeleteProduct(Index);
  end;
end;

function TProductsForm.ProductsGridGetColor(Sender: TObject; RowIndex,
  ColumnIndex: Integer; Selected, Inactive: Boolean): TColor;
var
  P: TProductObject;
begin
  P := TProductObject(ProductsProductNameIndex.ItemList^[RowIndex]);
  if P.Discontinued then
  begin
    if Selected then
      Result := TColor($F0F040)
    else
      Result := TColor($FF8000);
  end
  else if P.Little then
  begin
    if Selected then
      Result := TColor($8080FF)
    else
      Result := clRed;
  end else
    Result := clDefault;
end;

procedure TProductsForm.InsertButtonClick(Sender: TObject);
begin
  InsertProduct;
end;

procedure TProductsForm.EditButtonClick(Sender: TObject);
begin
  EditProduct(UnknownIndex);
end;

procedure TProductsForm.DeleteButtonClick(Sender: TObject);
begin
  DeleteProduct(UnknownIndex);
end;

procedure TProductsForm.InsertProduct;
begin
  ProductObject := TProductObject(Products.NewItem);
  ProductObject.QuantityPerUnit := 'шт.';
  if ProductForm.ShowModal <> mrOk then
    Products.CancelEdit(ProductObject)
  else
    UpdateProduct;
end;

procedure TProductsForm.EditProduct(Index: Integer);
begin
  if Index = UnknownIndex then
    Index := ProductsGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    ProductObject := TProductObject(Products.BeginEdit(
      TProductObject(ProductsProductNameIndex.ItemList^[Index]).ID));
    if ProductForm.ShowModal <> mrOk then
      Products.CancelEdit(ProductObject)
    else
      UpdateProduct;
  end;
end;

procedure TProductsForm.UpdateProduct;
begin
  Products.EndEdit(ProductObject);
  if SaveProducts then
    with ProductsGrid do
    begin
      Activate;
      SelectRow(ProductsProductNameIndex.ScanPointer(ProductObject));
    end;
end;

procedure TProductsForm.DeleteProduct(Index: Integer);
begin
  if Index = UnknownIndex then
    Index := ProductsGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    ProductObject := TProductObject(ProductsProductNameIndex.ItemList^[Index]);
    if MessageBox(Handle, PAnsiChar('Вы уверены, что хотите удалить товар "' + ProductObject.ProductName + '"?'),
      PAnsiChar('Подтверждение'), MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      Products.Delete(ProductObject.ID);
      if SaveProducts then
        with ProductsGrid do
        begin
          Activate;
          if RowCount > 0 then
            if Index >= RowCount then
              SelectRow(RowCount - 1)
            else
              SelectRow(Index);
        end;
    end;
  end;
end;

end.
