unit CategoryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs;

type
  TCategoryForm = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    GroupBox2: TGroupBox;
    LoadImageButton: TButton;
    SaveImageButton: TButton;
    ClearImageButton: TButton;
    PictureImage: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    CategoryNameEdit: TEdit;
    CommentsEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure ClearImageButtonClick(Sender: TObject);
    procedure LoadImageButtonClick(Sender: TObject);
    procedure SaveImageButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CategoryForm: TCategoryForm;

implementation

uses AcedConsts, AcedStorage, DataTypes, AcedStreams, AcedCompression;

{$R *.dfm}

procedure TCategoryForm.FormShow(Sender: TObject);
begin
  CategoryNameEdit.Text := CategoryObject.CategoryName;
  CommentsEdit.Text := CategoryObject.Comments;
  CategoryObject.Picture.Assign(PictureImage.Picture);
  CategoryNameEdit.SetFocus;
end;

procedure TCategoryForm.OkButtonClick(Sender: TObject);
var
  O: TCategoryObject;
begin
  CategoryObject.CategoryName := Trim(CategoryNameEdit.Text);
  if Length(CategoryObject.CategoryName) = 0 then
  begin
    CategoryNameEdit.SetFocus;
    ShowMessage('Ќазвание категории не может быть пустым.');
    Exit;
  end;
  O := TCategoryObject(CategoriesCategoryNameIndex.
    Search(CategoryObject.CategoryName));
  if (O <> nil) and (O.ID <> CategoryObject.ID) then
  begin
    CategoryNameEdit.SetFocus;
    ShowMessage(' атегори€ с таким названием уже есть в списке.');
    Exit;
  end;
  CategoryObject.Comments := Trim(CommentsEdit.Text);
  CategoryObject.Picture.Load(PictureImage.Picture);
  ModalResult := mrOk;
end;

procedure TCategoryForm.LoadImageButtonClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    PictureImage.Picture.LoadFromFile(OpenPictureDialog.FileName);
    OkButton.SetFocus;
  end;
end;

procedure TCategoryForm.SaveImageButtonClick(Sender: TObject);
begin
  if not PictureImage.Picture.Graphic.Empty and SavePictureDialog.Execute then
    PictureImage.Picture.SaveToFile(SavePictureDialog.FileName);
end;

procedure TCategoryForm.ClearImageButtonClick(Sender: TObject);
begin
  PictureImage.Picture.Graphic := nil;
end;

end.

