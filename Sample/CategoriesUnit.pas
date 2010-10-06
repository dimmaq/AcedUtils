unit CategoriesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, AcedGridFrame;

type
  TCategoriesForm = class(TForm)
    GroupBox1: TGroupBox;
    CategoriesGrid: TGridFrame;
    InsertButton: TSpeedButton;
    EditButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    ExitButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
  private
    procedure CategoriesGridGetData(Sender: TObject);
    procedure CategoriesGridDblClick(Sender: TObject; Index: Integer);
    procedure CategoriesGridKeyDown(Sender: TObject; Index: Integer;
      Key: Word; Shift: TShiftState);
    procedure InsertCategory;
    procedure EditCategory(Index: Integer);
    procedure UpdateCategory;
    procedure DeleteCategory(Index: Integer);
  public
    { Public declarations }
  end;

var
  CategoriesForm: TCategoriesForm;

implementation

uses AcedGrids, AcedConsts, AcedCommon, AcedStorage, DataTypes,
  CategoryUnit;

{$R *.dfm}

procedure TCategoriesForm.FormShow(Sender: TObject);
begin
  with CategoriesGrid do
  begin
    Activate;
    if RowCount > 0 then
      SelectRow(0);
    SetFocus;
  end;
end;

procedure TCategoriesForm.FormHide(Sender: TObject);
begin
  CategoriesGrid.Deactivate;
end;

procedure TCategoriesForm.FormCreate(Sender: TObject);
begin
  with CategoriesGrid do
  begin
    Init(3);
    with ColumnInfo[0]^ do
    begin
      Title := '№ п/п';
      Alignment := taCenter;
      Width := 45;
    end;
    with ColumnInfo[1]^ do
    begin
      Title := 'Наименование категории';
      Alignment := taLeftJustify;
      Width := 320;
    end;
    with ColumnInfo[2]^ do
    begin
      Title := 'Примечание';
      Alignment := taLeftJustify;
      Width := 104;
    end;
    OnGetData := CategoriesGridGetData;
    OnDoubleClick := CategoriesGridDblClick;
    OnKeyDown := CategoriesGridKeyDown;
    ApplyFormats;
  end;
end;

procedure TCategoriesForm.CategoriesGridGetData(Sender: TObject);
var
  I, Count: Integer;
  List: PSerializableObjectList;
  P: ^AnsiString;
  O: TCategoryObject;
begin
  List := CategoriesCategoryNameIndex.ItemList;
  Count := Categories.Count;
  with CategoriesGrid do
  begin
    RowCount := Count;
    P := Pointer(ItemList);
    for I := 0 to Count - 1 do
    begin
      O := TCategoryObject(List^[I]);
      P^ := G_IntToStr(I + 1);
      Inc(P);
      P^ := O.CategoryName;
      Inc(P);
      P^ := O.Comments;
      Inc(P);
    end;
  end;
end;

procedure TCategoriesForm.CategoriesGridDblClick(Sender: TObject; Index: Integer);
begin
  EditCategory(Index);
end;

procedure TCategoriesForm.CategoriesGridKeyDown(Sender: TObject; Index: Integer;
  Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_INSERT:  InsertCategory;
    VK_RETURN:  EditCategory(Index);
    VK_DELETE:  DeleteCategory(Index);
  end;
end;

procedure TCategoriesForm.InsertButtonClick(Sender: TObject);
begin
  InsertCategory;
end;

procedure TCategoriesForm.EditButtonClick(Sender: TObject);
begin
  EditCategory(UnknownIndex);
end;

procedure TCategoriesForm.DeleteButtonClick(Sender: TObject);
begin
  DeleteCategory(UnknownIndex);
end;

procedure TCategoriesForm.InsertCategory;
begin
  CategoryObject := TCategoryObject(Categories.NewItem);
  if CategoryForm.ShowModal <> mrOk then
    Categories.CancelEdit(CategoryObject)
  else
    UpdateCategory;
end;

procedure TCategoriesForm.EditCategory(Index: Integer);
begin
  if Index = UnknownIndex then
    Index := CategoriesGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    CategoryObject := TCategoryObject(Categories.BeginEdit(
      TCategoryObject(CategoriesCategoryNameIndex.ItemList^[Index]).ID));
    if CategoryForm.ShowModal <> mrOk then
      Categories.CancelEdit(CategoryObject)
    else
      UpdateCategory;
  end;
end;

procedure TCategoriesForm.UpdateCategory;
begin
  Categories.EndEdit(CategoryObject);
  if SaveCategories then
    with CategoriesGrid do
    begin
      Activate;
      SelectRow(CategoriesCategoryNameIndex.ScanPointer(CategoryObject));
    end;
end;

procedure TCategoriesForm.DeleteCategory(Index: Integer);
var
  Complete: Boolean;
  ReferenceFound: Boolean;
begin
  if Index = UnknownIndex then
    Index := CategoriesGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    CategoryObject := TCategoryObject(CategoriesCategoryNameIndex.ItemList^[Index]);
    if MessageBox(Handle, PAnsiChar('Вы уверены, что хотите удалить категорию "' + CategoryObject.CategoryName + '"?'),
      PAnsiChar('Подтверждение'), MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      Complete := False;
      ReferenceFound := False;
      if Products.OpenFile(ProductsFileName) then
        try
          if not ProductsCategoryIDIndex.Contains(CategoryObject.ID) then
          begin
            Categories.Delete(CategoryObject.ID);
            Complete := SaveCategories;
          end else
            ReferenceFound := True;
        finally
          Products.CloseFile;
        end;
      if Complete then
        with CategoriesGrid do
        begin
          Activate;
          if RowCount > 0 then
            if Index >= RowCount then
              SelectRow(RowCount - 1)
            else
              SelectRow(Index);
        end
      else if ReferenceFound then
        ShowMessage('Категория не может быть удалена, т.к. на нее есть ссылка в таблице товаров.');
    end;
  end;
end;

end.
