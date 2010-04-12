unit SelectSupplierUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AcedGridFrame;

type
  TSelectSupplierForm = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    OkButton: TButton;
    CancelButton: TButton;
    SuppliersGrid: TGridFrame;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    procedure SuppliersGridGetData(Sender: TObject);
    procedure SuppliersGridDblClick(Sender: TObject; Index: Integer);
  public
    { Public declarations }
  end;

var
  SelectSupplierForm: TSelectSupplierForm;

implementation

uses AcedCommon, AcedConsts, AcedStorage, DataTypes, AcedStrings;

{$R *.dfm}

procedure TSelectSupplierForm.FormShow(Sender: TObject);
var
  Index: Integer;
  P: TSerializableObject;
begin
  with SuppliersGrid do
  begin
    Activate;
    if RowCount > 0 then
    begin
      Index := 0;
      if SelectedSupplierID > 0 then
      begin
        P := Suppliers.Search(SelectedSupplierID);
        if P <> nil then
        begin
          Index := SuppliersCompanyNameIndex.ScanPointer(P);
          if Index < 0 then
            Index := 0;
        end;
      end;
      SelectRow(Index);
    end;
    SetFocus;
  end;
end;

procedure TSelectSupplierForm.FormHide(Sender: TObject);
begin
  SuppliersGrid.Deactivate;
end;

procedure TSelectSupplierForm.FormCreate(Sender: TObject);
begin
  with SuppliersGrid do
  begin
    Init(5);
    with ColumnInfo[0]^ do
    begin
      Title := '№ п/п';
      Alignment := taCenter;
      Width := 40;
    end;
    with ColumnInfo[1]^ do
    begin
      Title := 'Наименование';
      Alignment := taLeftJustify;
      Width := 162;
    end;
    with ColumnInfo[2]^ do
    begin
      Title := 'Страна';
      Alignment := taLeftJustify;
      Width := 80;
    end;
    with ColumnInfo[3]^ do
    begin
      Title := 'Город';
      Alignment := taLeftJustify;
      Width := 98;
    end;
    with ColumnInfo[4]^ do
    begin
      Title := 'Адрес';
      Alignment := taLeftJustify;
      Width := 141;
    end;
    OnGetData := SuppliersGridGetData;
    OnDoubleClick := SuppliersGridDblClick;
    ApplyFormats;
  end;
end;

procedure TSelectSupplierForm.SuppliersGridGetData(Sender: TObject);
var
  I, Count: Integer;
  List: PSerializableObjectList;
  P: ^string;
  O: TSupplierObject;
  S: string;
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
      P^ := O.Country;
      Inc(P);
      P^ := O.CityRegion;
      Inc(P);
      if Length(O.Address) > 0 then
      begin
        S := O.Address;
        if G_CharPos(#10, S) > 0 then
        begin
          G_DeleteChar(S, #13);
          G_ReplaceChar(S, #10, #32);
        end;
        P^ := S;
      end else
        P^ := '';
      Inc(P);
    end;
  end;
end;

procedure TSelectSupplierForm.SuppliersGridDblClick(Sender: TObject; Index: Integer);
begin
  OkButtonClick(Sender);
end;

procedure TSelectSupplierForm.OkButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := SuppliersGrid.GetSelectedRowIndex;
  if Index >= 0 then
  begin
    SelectedSupplierID := TSupplierObject(SuppliersCompanyNameIndex.ItemList^[Index]).ID;
    ModalResult := mrOk;
  end;
end;

end.
