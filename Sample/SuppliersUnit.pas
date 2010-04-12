unit SuppliersUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AcedGridFrame, Buttons;

type
  TSuppliersForm = class(TForm)
    GroupBox1: TGroupBox;
    InsertButton: TSpeedButton;
    EditButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    ExitButton: TButton;
    SuppliersGrid: TGridFrame;
    PrintButton: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    procedure SuppliersGridGetData(Sender: TObject);
    procedure SuppliersGridDblClick(Sender: TObject; Index: Integer);
    procedure SuppliersGridKeyDown(Sender: TObject; Index: Integer;
      Key: Word; Shift: TShiftState);
    procedure InsertSupplier;
    procedure EditSupplier(Index: Integer);
    procedure UpdateSupplier;
    procedure DeleteSupplier(Index: Integer);
    procedure PrintSuppliers;
  public
    { Public declarations }
  end;

var
  SuppliersForm: TSuppliersForm;

implementation

uses DataTypes, AcedCommon, AcedConsts, AcedStorage, SupplierUnit,
  ReportsUnit;

{$R *.dfm}

procedure TSuppliersForm.FormShow(Sender: TObject);
begin
  with SuppliersGrid do
  begin
    Activate;
    if RowCount > 0 then
      SelectRow(0);
    SetFocus;
  end;
end;

procedure TSuppliersForm.FormHide(Sender: TObject);
begin
  SuppliersGrid.Deactivate;
end;

procedure TSuppliersForm.FormCreate(Sender: TObject);
begin
  with SuppliersGrid do
  begin
    Init(5);
    with ColumnInfo[0]^ do
    begin
      Title := '№ п/п';
      Alignment := taCenter;
      Width := 42;
    end;
    with ColumnInfo[1]^ do
    begin
      Title := 'Наименование';
      Alignment := taLeftJustify;
      Width := 162;
    end;
    with ColumnInfo[2]^ do
    begin
      Title := 'Город';
      Alignment := taLeftJustify;
      Width := 90;
    end;
    with ColumnInfo[3]^ do
    begin
      Title := 'Адрес';
      Alignment := taLeftJustify;
      Width := 195;
    end;
    with ColumnInfo[4]^ do
    begin
      Title := 'Телефон';
      Alignment := taCenter;
      Width := 98;
    end;
    OnGetData := SuppliersGridGetData;
    OnDoubleClick := SuppliersGridDblClick;
    OnKeyDown := SuppliersGridKeyDown;
    ApplyFormats;
  end;
end;

procedure TSuppliersForm.SuppliersGridGetData(Sender: TObject);
var
  I, Count: Integer;
  List: PSerializableObjectList;
  P: ^string;
  O: TSupplierObject;
begin
  List := SuppliersCompanyNameIndex.ItemList;
  Count := Suppliers.Count;
  with SuppliersGrid do
  begin
    RowCount := Count;
    P := Pointer(ItemList);
    for I := 0 to Count - 1 do
    begin
      O := TSupplierObject(List^[I]);
      P^ := G_IntToStr(I + 1);
      Inc(P);
      P^ := O.CompanyName;
      Inc(P);
      P^ := O.CityRegion;
      Inc(P);
      P^ := O.Address;
      Inc(P);
      P^ := O.PhoneFax;
      Inc(P);
    end;
  end;
end;

procedure TSuppliersForm.SuppliersGridDblClick(Sender: TObject; Index: Integer);
begin
  EditSupplier(Index);
end;

procedure TSuppliersForm.SuppliersGridKeyDown(Sender: TObject; Index: Integer;
  Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_INSERT:  InsertSupplier;
    VK_RETURN:  EditSupplier(Index);
    VK_DELETE:  DeleteSupplier(Index);
    VK_F4:      PrintSuppliers;
  end;
end;

procedure TSuppliersForm.InsertButtonClick(Sender: TObject);
begin
  InsertSupplier;
end;

procedure TSuppliersForm.EditButtonClick(Sender: TObject);
begin
  EditSupplier(UnknownIndex);
end;

procedure TSuppliersForm.DeleteButtonClick(Sender: TObject);
begin
  DeleteSupplier(UnknownIndex);
end;

procedure TSuppliersForm.PrintButtonClick(Sender: TObject);
begin
  PrintSuppliers;
end;

procedure TSuppliersForm.InsertSupplier;
begin
  SupplierObject := TSupplierObject(Suppliers.NewItem);
  if SupplierForm.ShowModal <> mrOk then
    Suppliers.CancelEdit(SupplierObject)
  else
    UpdateSupplier;
end;

procedure TSuppliersForm.EditSupplier(Index: Integer);
begin
  if Index = UnknownIndex then
    Index := SuppliersGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    SupplierObject := TSupplierObject(Suppliers.BeginEdit(
      TSupplierObject(SuppliersCompanyNameIndex.ItemList^[Index]).ID));
    if SupplierForm.ShowModal <> mrOk then
      Suppliers.CancelEdit(SupplierObject)
    else
      UpdateSupplier;
  end;
end;

procedure TSuppliersForm.UpdateSupplier;
begin
  Suppliers.EndEdit(SupplierObject);
  if SaveSuppliers then
    with SuppliersGrid do
    begin
      Activate;
      SelectRow(SuppliersCompanyNameIndex.ScanPointer(SupplierObject));
    end;
end;

procedure TSuppliersForm.DeleteSupplier(Index: Integer);
var
  Complete: Boolean;
  ReferenceFound: Boolean;
begin
  if Index = UnknownIndex then
    Index := SuppliersGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    SupplierObject := TSupplierObject(SuppliersCompanyNameIndex.ItemList^[Index]);
    if MessageBox(Handle, PChar('Вы уверены, что хотите удалить поставщика "' + SupplierObject.CompanyName + '"?'),
      PChar('Подтверждение'), MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      Complete := False;
      ReferenceFound := False;
      if Products.OpenFile(ProductsFileName) then
        try
          if not ProductsSupplierIDIndex.Contains(SupplierObject.ID) then
          begin
            Suppliers.Delete(SupplierObject.ID);
            Complete := SaveSuppliers;
          end else
            ReferenceFound := True;
        finally
          Products.CloseFile;
        end;
      if Complete then
        with SuppliersGrid do
        begin
          Activate;
          if RowCount > 0 then
            if Index >= RowCount then
              SelectRow(RowCount - 1)
            else
              SelectRow(Index);
        end
      else if ReferenceFound then
        ShowMessage('Поставщик не может быть удален, т.к. на него есть ссылка в таблице товаров.');
    end;
  end;
end;

procedure TSuppliersForm.PrintSuppliers;
begin
  if LoadProducts then
    MakeSupplierReport;
end;

end.
