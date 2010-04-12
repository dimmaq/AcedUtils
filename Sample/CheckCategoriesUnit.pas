unit CheckCategoriesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AcedCheckFrame, StdCtrls;

type
  TCheckCategoriesForm = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    OkButton: TButton;
    CancelButton: TButton;
    CategoriesGrid: TCheckFrame;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CategoriesGridGetData(Sender: TObject);
    procedure SaveChecks;
  public
    { Public declarations }
  end;

var
  CheckCategoriesForm: TCheckCategoriesForm;

implementation

uses AcedConsts, AcedContainers, AcedStorage, DataTypes, AcedCommon;

{$R *.dfm}

procedure TCheckCategoriesForm.FormShow(Sender: TObject);
begin
  with CategoriesGrid do
  begin
    Activate;
    if RowCount > 0 then
      SelectRow(0);
    SetFocus;
  end;
end;

procedure TCheckCategoriesForm.FormHide(Sender: TObject);
begin
  if ModalResult = mrOk then
    SaveChecks;
  CategoriesGrid.Deactivate;
end;

procedure TCheckCategoriesForm.CategoriesGridGetData(Sender: TObject);
var
  I, Count: Integer;
  List: PSerializableObjectList;
  P: ^string;
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
      if CheckedCategories.IndexOf(O.ID) >= 0 then
        Checks[I] := True;
      P^ := G_IntToStr(I + 1);
      Inc(P);
      P^ := O.CategoryName;
      Inc(P);
      P^ := O.Comments;
      Inc(P);
    end;
  end;
end;

procedure TCheckCategoriesForm.SaveChecks;
var
  I: Integer;
  List: PSerializableObjectList;
  Checks: TBitList;
begin
  CheckedCategories.Clear;
  List := CategoriesCategoryNameIndex.ItemList;
  Checks := CategoriesGrid.Checks;
  for I := Categories.Count - 1 downto 0 do
    if Checks[I] then
      CheckedCategories.Add(TCategoryObject(List^[I]).ID);
end;

procedure TCheckCategoriesForm.FormCreate(Sender: TObject);
begin
  with CategoriesGrid do
  begin
    Init(3);
    with ColumnInfo[0]^ do
    begin
      Title := '№ п/п';
      Alignment := taCenter;
      Width := 61;
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
    ApplyFormats;
  end;
end;

end.
