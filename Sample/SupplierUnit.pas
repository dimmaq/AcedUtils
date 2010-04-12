unit SupplierUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSupplierForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CompanyNameEdit: TEdit;
    Label2: TLabel;
    ContactPersonEdit: TEdit;
    Label4: TLabel;
    CountryEdit: TEdit;
    Label5: TLabel;
    CityRegionEdit: TEdit;
    Label7: TLabel;
    PostalCodeEdit: TEdit;
    Label8: TLabel;
    PhoneFaxEdit: TEdit;
    Label9: TLabel;
    CommentsEdit: TEdit;
    OkButton: TButton;
    CancelButton: TButton;
    Label3: TLabel;
    AddressMemo: TMemo;
    Label6: TLabel;
    HttpEmailEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SupplierForm: TSupplierForm;

implementation

uses AcedStorage, DataTypes;

{$R *.dfm}

procedure TSupplierForm.FormShow(Sender: TObject);
begin
  CompanyNameEdit.Text := SupplierObject.CompanyName;
  CountryEdit.Text := SupplierObject.Country;
  CityRegionEdit.Text := SupplierObject.CityRegion;
  AddressMemo.Text := SupplierObject.Address;
  PostalCodeEdit.Text := SupplierObject.PostalCode;
  PhoneFaxEdit.Text := SupplierObject.PhoneFax;
  HttpEmailEdit.Text := SupplierObject.HttpEmail;
  ContactPersonEdit.Text := SupplierObject.ContactPerson;
  CommentsEdit.Text := SupplierObject.Comments;
  CompanyNameEdit.SetFocus;
end;

procedure TSupplierForm.OkButtonClick(Sender: TObject);
var
  O: TSupplierObject;
begin
  SupplierObject.CompanyName := Trim(CompanyNameEdit.Text);
  if Length(SupplierObject.CompanyName) = 0 then
  begin
    CompanyNameEdit.SetFocus;
    ShowMessage('Наименование поставщика не может быть пустым.');
    Exit;
  end;
  O := TSupplierObject(SuppliersCompanyNameIndex.Search(SupplierObject.CompanyName));
  if (O <> nil) and (O.ID <> SupplierObject.ID) then
  begin
    CompanyNameEdit.SetFocus;
    ShowMessage('Поставщик с таким наименованием уже есть в списке.');
    Exit;
  end;
  SupplierObject.Country := Trim(CountryEdit.Text);
  SupplierObject.CityRegion := Trim(CityRegionEdit.Text);
  SupplierObject.Address := Trim(AddressMemo.Text);
  SupplierObject.PostalCode := Trim(PostalCodeEdit.Text);
  SupplierObject.PhoneFax := Trim(PhoneFaxEdit.Text);
  SupplierObject.HttpEmail := Trim(HttpEmailEdit.Text);
  SupplierObject.ContactPerson := Trim(ContactPersonEdit.Text);
  SupplierObject.Comments := Trim(CommentsEdit.Text);
  ModalResult := mrOk;
end;

end.
