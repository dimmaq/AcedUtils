unit DataTypes;

interface

uses AcedContainers, AcedStreams, AcedStorage, Graphics, Classes;

type

{ Поставщик товара }

  TSupplierObject = class(TSerializableObject)
  private
    FCompanyName: string;    // Наименование
    FCountry: string;        // Страна
    FCityRegion: string;     // Город, область
    FAddress: string;        // Адрес
    FPostalCode: string;     // Почтовый индекс
    FPhoneFax: string;       // Телефон, факс
    FHttpEmail: string;      // Электронный адрес
    FContactPerson: string;  // Контактное лицо
    FComments: string;       // Примечание

  public
    property CompanyName: string read FCompanyName write FCompanyName;
    property Country: string read FCountry write FCountry;
    property CityRegion: string read FCityRegion write FCityRegion;
    property Address: string read FAddress write FAddress;
    property PostalCode: string read FPostalCode write FPostalCode;
    property PhoneFax: string read FPhoneFax write FPhoneFax;
    property HttpEmail: string read FHttpEmail write FHttpEmail;
    property ContactPerson: string read FContactPerson write FContactPerson;
    property Comments: string read FComments write FComments;

    procedure Load(Reader: TBinaryReader; Version: Integer); override;
    procedure Save(Writer: TBinaryWriter); override;
    function Equals(SO: TSerializableObject): Boolean; override;
    function Clone: TSerializableObject; override;
  end;

{ Сжатое изображение, сохраняемое в бинарном потоке }

  TPictureObject = class(TObject)
  private
    FLength: LongWord;  // Флаги и длина в байтах массива, содержащего рисунок
    FBytes: Pointer;    // Упакованный рисунок в виде массива байт

    function GetIsBitmap: Boolean;
    function GetIsMetafile: Boolean;
    function GetIsIcon: Boolean;
    function GetLength: Integer;

  public
    destructor Destroy; override;

    property IsBitmap: Boolean read GetIsBitmap;
    property IsMetafile: Boolean read GetIsMetafile;
    property IsIcon: Boolean read GetIsIcon;
    property Length: Integer read GetLength;
    property Bytes: Pointer read FBytes;

    procedure Load(Reader: TBinaryReader); overload;
    procedure Load(Obj: TPictureObject); overload;
    procedure Load(Picture: TPicture); overload;
    procedure Save(Writer: TBinaryWriter);
    procedure Assign(Picture: TPicture);
    function Equals(Obj: TPictureObject): Boolean;
    procedure FreePicture;
  end;

{ Категория товара }

  TCategoryObject = class(TSerializableObject)
  private
    FCategoryName: string;     // Наименование категории
    FComments: string;         // Примечание
    FPicture: TPictureObject;  // Изображение, ассоциированное с категорией

  public
    constructor Create; override;
    destructor Destroy; override;

    property CategoryName: string read FCategoryName write FCategoryName;
    property Comments: string read FComments write FComments;
    property Picture: TPictureObject read FPicture;

    procedure Load(Reader: TBinaryReader; Version: Integer); override;
    procedure Save(Writer: TBinaryWriter); override;
    function Equals(SO: TSerializableObject): Boolean; override;
    function Clone: TSerializableObject; override;
  end;

{ Товар }

  TProductObject = class(TSerializableObject)
  private
    FProductName: string;       // Наименование товара
    FSupplierID: Integer;       // Ссылка на поставщика
    FCategoryID: Integer;       // Ссылка на категорию
    FQuantityPerUnit: string;   // Единица измерения
    FUnitPrice: Currency;       // Цена
    FUnitsInStock: Integer;     // На складе
    FUnitsOnOrder: Integer;     // Ожидается
    FDiscontinued: Boolean;     // Поставки прекращены
    FLittle: Boolean;           // Мало - добавлено в версии 2

  public
    property ProductName: string read FProductName write FProductName;
    property SupplierID: Integer read FSupplierID write FSupplierID;
    property CategoryID: Integer read FCategoryID write FCategoryID;
    property QuantityPerUnit: string read FQuantityPerUnit write FQuantityPerUnit;
    property UnitPrice: Currency read FUnitPrice write FUnitPrice;
    property UnitsInStock: Integer read FUnitsInStock write FUnitsInStock;
    property UnitsOnOrder: Integer read FUnitsOnOrder write FUnitsOnOrder;
    property Discontinued: Boolean read FDiscontinued write FDiscontinued;
    property Little: Boolean read FLittle write FLittle;

    procedure Load(Reader: TBinaryReader; Version: Integer); override;
    procedure Save(Writer: TBinaryWriter); override;
    function Equals(SO: TSerializableObject): Boolean; override;
    function Clone: TSerializableObject; override;
  end;

{ Чтение/сохранение параметров конфигурации в реестре Windows }

const
  rgConfigKey           = 'Software\AcedUtils\Demo';
  rgSelectedSupplierID  = 'SelectedSupplierID';
  rgCheckedCategories   = 'CheckedCategories';

var
  SelectedSupplierID: Integer = 0;
  CheckedCategories: TIntegerList;

procedure LoadConfiguration;
procedure SaveConfiguration;

const

{ Имена файлов данных }

  cfDataPath            = 'Data\';
  cfSuppliers           = 'Suppliers.dat';
  cfCategories          = 'Categories.dat';
  cfProducts            = 'Products.dat';

{ Имена шаблонов отчетов }

  cfTemplatesPath       = 'Templates\';
  rpProducts            = 'Products.xlt';
  rpSuppliers           = 'Suppliers.xlt';

var
  SuppliersFileName: string;
  CategoriesFileName: string;
  ProductsFileName: string;
  TemplatesPath: string;

var
{ Информация о поставщиках, категориях и товарах }

  Suppliers: TSerializableCollection;
  Categories: TBytePrimaryKeyCollection;
  Products: TSerializableCollection;

{ Индексы для сортировки, выборки и обеспечения целостности данных }

  SuppliersCompanyNameIndex: TStringIndex;
  CategoriesCategoryNameIndex: TStringIndex;
  ProductsProductNameIndex: TStringIndex;
  ProductsSupplierIDIndex: TIntegerIndex;
  ProductsCategoryIDIndex: TIntegerIndex;

{ Переменные, используемые при редактировании объектов }

  SupplierObject: TSupplierObject;
  CategoryObject: TCategoryObject;
  ProductObject: TProductObject;

const
  UnknownIndex = Integer($80000000);

{ Методы для загрузки и сохранения коллекций на диске }

function LoadSuppliers: Boolean;
function SaveSuppliers: Boolean;
function LoadCategories: Boolean;
function SaveCategories: Boolean;
function LoadProducts: Boolean;
function SaveProducts: Boolean;

implementation

uses Windows, SysUtils, Forms, Dialogs, Registry,
  AcedConsts, AcedBinary, AcedStrings, AcedCrypto, AcedCompression;

{ TSupplierObject }

const
  CountryNotEmpty        = $01;
  CityRegionNotEmpty     = $02;
  AddressNotEmpty        = $04;
  PostalCodeNotEmpty     = $08;
  PhoneFaxNotEmpty       = $10;
  HttpEmailNotEmpty      = $20;
  ContactPersonNotEmpty  = $40;
  CommentsNotEmpty       = $80;

procedure TSupplierObject.Load(Reader: TBinaryReader; Version: Integer);
var
  Flags: LongWord;
begin
  if Version = 1 then
  begin
    FID := Reader.ReadInteger;
    FCompanyName := Reader.ReadString;
    Flags := Reader.ReadByte;
    if Flags and CountryNotEmpty <> 0 then
      FCountry := Reader.ReadString;
    if Flags and CityRegionNotEmpty <> 0 then
      FCityRegion := Reader.ReadString;
    if Flags and AddressNotEmpty <> 0 then
      FAddress := Reader.ReadString;
    if Flags and PostalCodeNotEmpty <> 0 then
      FPostalCode := Reader.ReadString;
    if Flags and PhoneFaxNotEmpty <> 0 then
      FPhoneFax := Reader.ReadString;
    if Flags and HttpEmailNotEmpty <> 0 then
      FHttpEmail := Reader.ReadString;
    if Flags and ContactPersonNotEmpty <> 0 then
      FContactPerson := Reader.ReadString;
    if Flags and CommentsNotEmpty <> 0 then
      FComments := Reader.ReadString;
  end else
    RaiseVersionNotSupported(Self, Version);
end;

procedure TSupplierObject.Save(Writer: TBinaryWriter);
var
  Flags: LongWord;
begin
  Writer.WriteInteger(FID);
  Writer.WriteString(FCompanyName);
  Flags := 0;
  if Length(FCountry) > 0 then
    Flags := Flags or CountryNotEmpty;
  if Length(FCityRegion) > 0 then
    Flags := Flags or CityRegionNotEmpty;
  if Length(FAddress) > 0 then
    Flags := Flags or AddressNotEmpty;
  if Length(FPostalCode) > 0 then
    Flags := Flags or PostalCodeNotEmpty;
  if Length(FPhoneFax) > 0 then
    Flags := Flags or PhoneFaxNotEmpty;
  if Length(FHttpEmail) > 0 then
    Flags := Flags or HttpEmailNotEmpty;
  if Length(FContactPerson) > 0 then
    Flags := Flags or ContactPersonNotEmpty;
  if Length(FComments) > 0 then
    Flags := Flags or CommentsNotEmpty;
  Writer.WriteByte(Byte(Flags));
  if Flags and CountryNotEmpty <> 0 then
    Writer.WriteString(FCountry);
  if Flags and CityRegionNotEmpty <> 0 then
    Writer.WriteString(FCityRegion);
  if Flags and AddressNotEmpty <> 0 then
    Writer.WriteString(FAddress);
  if Flags and PostalCodeNotEmpty <> 0 then
    Writer.WriteString(FPostalCode);
  if Flags and PhoneFaxNotEmpty <> 0 then
    Writer.WriteString(FPhoneFax);
  if Flags and HttpEmailNotEmpty <> 0 then
    Writer.WriteString(FHttpEmail);
  if Flags and ContactPersonNotEmpty <> 0 then
    Writer.WriteString(FContactPerson);
  if Flags and CommentsNotEmpty <> 0 then
    Writer.WriteString(FComments);
end;

function TSupplierObject.Equals(SO: TSerializableObject): Boolean;
var
  O: TSupplierObject;
begin
  O := TSupplierObject(SO);
  Result := (FID = O.FID) and G_SameStr(FCompanyName, O.FCompanyName) and
    G_SameStr(FCountry, O.FCountry) and G_SameStr(FCityRegion, O.FCityRegion) and
    G_SameStr(FAddress, O.FAddress) and G_SameStr(FPostalCode, O.FPostalCode) and
    G_SameStr(FPhoneFax, O.FPhoneFax) and G_SameStr(FHttpEmail, O.FHttpEmail) and
    G_SameStr(FContactPerson, O.FContactPerson) and
    G_SameStr(FComments, O.FComments);
end;

function TSupplierObject.Clone: TSerializableObject;
var
  O: TSupplierObject;
begin
  O := TSupplierObject.Create;
  O.FID := FID;
  O.FCompanyName := FCompanyName;
  O.FCountry := FCountry;
  O.FCityRegion := FCityRegion;
  O.FAddress := FAddress;
  O.FPostalCode := FPostalCode;
  O.FPhoneFax := FPhoneFax;
  O.FHttpEmail := FHttpEmail;
  O.FContactPerson := FContactPerson;
  O.FComments := FComments;
  Result := O;
end;

{ TPictureObject }

const
  PictureIsBitmap        = $40000000;
  PictureIsMetafile      = $80000000;
  PictureIsIcon          = $C0000000;
  PictureFlagsMask       = $C0000000;
  PictureLengthMask      = $3FFFFFFF;

destructor TPictureObject.Destroy;
begin
  FreePicture;
end;

procedure TPictureObject.Load(Reader: TBinaryReader);
var
  L: Integer;
begin
  FreePicture;
  FLength := Reader.ReadInteger;
  L := Integer(FLength and PictureLengthMask);
  if L > 0 then
  begin
    GetMem(FBytes, L);
    Reader.Read(FBytes, L);
  end;
end;

procedure TPictureObject.Load(Obj: TPictureObject);
var
  L: Integer;
begin
  FreePicture;
  FLength := Obj.FLength;
  L := Integer(FLength and PictureLengthMask);
  if L > 0 then
  begin
    GetMem(FBytes, L);
    G_CopyMem(Obj.FBytes, FBytes, L);
  end;
end;

procedure TPictureObject.Load(Picture: TPicture);
var
  G: TGraphic;
  Writer: TBinaryWriter;
  WS: TWriterStream;
begin
  FreePicture;
  G := Picture.Graphic;
  if (G <> nil) and not G.Empty then
  begin
    Writer := TBinaryWriter.Create;
    WS := TWriterStream.Create(Writer);
    G.SaveToStream(WS);
    WS.Free;
    FLength := Writer.SaveToArray(FBytes, nil, dcmNormal);
    Writer.Free;
    if G is Graphics.TBitmap then
      FLength := FLength or PictureIsBitmap
    else if G is Graphics.TMetafile then
      FLength := FLength or PictureIsMetafile
    else if G is Graphics.TIcon then
      FLength := FLength or PictureIsIcon;
  end;
end;

procedure TPictureObject.Save(Writer: TBinaryWriter);
var
  L: Integer;
begin
  Writer.WriteInteger(FLength);
  L := Integer(FLength and PictureLengthMask);
  if L > 0 then
    Writer.Write(FBytes, L);
end;

procedure TPictureObject.Assign(Picture: TPicture);
var
  Reader: TBinaryReader;
  RS: TReaderStream;
begin
  if FLength = 0 then
  begin
    Picture.Graphic := nil;
    Exit;
  end;
  Reader := TBinaryReader.Create;
  Reader.LoadFromArray(FBytes, FLength and PictureLengthMask);
  RS := TReaderStream.Create(Reader);
  case FLength and PictureFlagsMask of
    PictureIsBitmap:
      Picture.Bitmap.LoadFromStream(RS);
    PictureIsMetafile:
      Picture.Metafile.LoadFromStream(RS);
    PictureIsIcon:
      Picture.Icon.LoadFromStream(RS);
  end;
  Reader.Free;
  RS.Free;
end;

function TPictureObject.Equals(Obj: TPictureObject): Boolean;
var
  L: Integer;
begin
  if FLength <> Obj.FLength then
    Result := False
  else
  begin
    L := Integer(FLength and PictureLengthMask);
    if L <> 0 then
      Result := G_SameMem(FBytes, Obj.FBytes, L)
    else
      Result := True;
  end;
end;

procedure TPictureObject.FreePicture;
begin
  if (FLength and PictureLengthMask) > 0 then
    FreeMem(FBytes);
  FLength := 0;
end;

function TPictureObject.GetIsBitmap: Boolean;
begin
  Result := (FLength and PictureFlagsMask) = PictureIsBitmap;
end;

function TPictureObject.GetIsMetafile: Boolean;
begin
  Result := (FLength and PictureFlagsMask) = PictureIsMetafile;
end;

function TPictureObject.GetIsIcon: Boolean;
begin
  Result := (FLength and PictureFlagsMask) = PictureIsIcon;
end;

function TPictureObject.GetLength: Integer;
begin
  Result := Integer(FLength and PictureLengthMask);
end;

{ TCategoryObject }

constructor TCategoryObject.Create;
begin
  FPicture := TPictureObject.Create;
end;

destructor TCategoryObject.Destroy;
begin
  FPicture.Free;
end;

procedure TCategoryObject.Load(Reader: TBinaryReader; Version: Integer);
begin
  if Version = 1 then
  begin
    FID := Reader.ReadByte;
    FCategoryName := Reader.ReadString;
    FComments := Reader.ReadString;
    FPicture.Load(Reader);
  end else
    RaiseVersionNotSupported(Self, Version);
end;

procedure TCategoryObject.Save(Writer: TBinaryWriter);
begin
  Writer.WriteByte(FID);
  Writer.WriteString(FCategoryName);
  Writer.WriteString(FComments);
  FPicture.Save(Writer);
end;

function TCategoryObject.Equals(SO: TSerializableObject): Boolean;
var
  O: TCategoryObject;
begin
  O := TCategoryObject(SO);
  Result := (FID = O.FID) and G_SameStr(FCategoryName, O.FCategoryName) and
    G_SameStr(FComments, O.FComments) and FPicture.Equals(O.Picture);
end;

function TCategoryObject.Clone: TSerializableObject;
var
  O: TCategoryObject;
begin
  O := TCategoryObject.Create;
  O.FID := FID;
  O.FCategoryName := FCategoryName;
  O.FComments := FComments;
  O.FPicture.Load(FPicture);
  Result := O;
end;

{ TProductObject }

procedure TProductObject.Load(Reader: TBinaryReader; Version: Integer);
begin
  if Version <= 2 then
  begin
    FID := Reader.ReadInteger;
    FProductName := Reader.ReadString;
    FSupplierID := Reader.ReadInteger;
    FCategoryID := Reader.ReadByte;
    FQuantityPerUnit := Reader.ReadString;
    FUnitPrice := Reader.ReadCurrency;
    FUnitsInStock := Reader.ReadInteger;
    FUnitsOnOrder := Reader.ReadInteger;
    FDiscontinued := Reader.ReadBoolean;
    if Version = 2 then
      FLittle := Reader.ReadBoolean;
  end else
    RaiseVersionNotSupported(Self, Version);
end;

procedure TProductObject.Save(Writer: TBinaryWriter);
begin
  Writer.WriteInteger(FID);
  Writer.WriteString(FProductName);
  Writer.WriteInteger(FSupplierID);
  Writer.WriteByte(FCategoryID);
  Writer.WriteString(FQuantityPerUnit);
  Writer.WriteCurrency(FUnitPrice);
  Writer.WriteInteger(FUnitsInStock);
  Writer.WriteInteger(FUnitsOnOrder);
  Writer.WriteBoolean(FDiscontinued);
  Writer.WriteBoolean(FLittle);
end;

function TProductObject.Equals(SO: TSerializableObject): Boolean;
var
  O: TProductObject;
begin
  O := TProductObject(SO);
  Result := (FID = O.FID) and G_SameStr(FProductName, O.FProductName) and
    (FSupplierID = O.FSupplierID) and (FCategoryID = O.FCategoryID) and
    G_SameStr(FQuantityPerUnit, O.FQuantityPerUnit) and (FUnitPrice = O.FUnitPrice) and
    (FUnitsInStock = O.FUnitsInStock) and (FUnitsOnOrder = O.FUnitsOnOrder) and
    (FDiscontinued = O.FDiscontinued) and (FLittle = O.FLittle);
end;

function TProductObject.Clone: TSerializableObject;
var
  O: TProductObject;
begin
  O := TProductObject.Create;
  O.FID := FID;
  O.FProductName := FProductName;
  O.FSupplierID := FSupplierID;
  O.FCategoryID := FCategoryID;
  O.FQuantityPerUnit := FQuantityPerUnit;
  O.FUnitPrice := FUnitPrice;
  O.FUnitsInStock := FUnitsInStock;
  O.FUnitsOnOrder := FUnitsOnOrder;
  O.FDiscontinued := FDiscontinued;
  O.FLittle := FLittle;
  Result := O;
end;

{ Глобальные функции }

procedure LoadConfiguration;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if Registry.OpenKeyReadOnly(rgConfigKey) then
    begin
      if Registry.ValueExists(rgSelectedSupplierID) then
        SelectedSupplierID := Registry.ReadInteger(rgSelectedSupplierID);
      CheckedCategories.Load(Registry, rgCheckedCategories);
    end;
  finally
    Registry.Free;
  end;
end;

procedure SaveConfiguration;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if Registry.OpenKey(rgConfigKey, True) then
    begin
      Registry.WriteInteger(rgSelectedSupplierID, SelectedSupplierID);
      CheckedCategories.Save(Registry, rgCheckedCategories);
    end;
  finally
    Registry.Free;
  end;
end;

const
  SuppliersPassword: TSHA256Digest =
    ($be60e2db,$a9c23101,$eba5315c,$224e42f2,$1c5c1572,$f6721b2c,$1ad2fff3,$8c25404e);

function LoadSuppliers: Boolean;
begin
  Result := Suppliers.LoadFile(SuppliersFileName, @SuppliersPassword);
end;

function SaveSuppliers: Boolean;
var
  appResult: TAppChangesResult;
begin
  Result := True;
  if Suppliers.HasChanges then
    if Suppliers.OpenFile(SuppliersFileName, @SuppliersPassword, dcmFast) then
      try
        appResult := Suppliers.ApplyChanges;
        if appResult = appChangesOk then
          Suppliers.SaveIfChanged
        else
        begin
          Suppliers.UndoIfChanged;
          if appResult = appChangesOriginalObjectChanged then
            ShowMessage('Информация о поставщике изменена другим пользователем.')
          else if appResult = appChangesUniqueIndexViolation then
            ShowMessage('Такой поставщик уже есть в списке.');
          Result := False;
        end;
      finally
        Suppliers.CloseFile;
      end
    else
    begin
      Suppliers.RejectChanges;
      ShowMessage('Ошибка при сохранении данных о поставщике.');
      Result := False;
    end;
end;

function LoadCategories: Boolean;
begin
  Result := Categories.LoadFile(CategoriesFileName);
end;

function SaveCategories: Boolean;
var
  appResult: TAppChangesResult;
begin
  Result := True;
  if Categories.HasChanges then
    if Categories.OpenFile(CategoriesFileName) then
      try
        appResult := Categories.ApplyChanges;
        if appResult = appChangesOk then
          Categories.SaveIfChanged
        else
        begin
          Categories.UndoIfChanged;
          if appResult = appChangesOriginalObjectChanged then
            ShowMessage('Информация о категории товара изменена другим пользователем.')
          else if appResult = appChangesUniqueIndexViolation then
            ShowMessage('Такая категория уже есть в списке.');
          Result := False;
        end;
      finally
        Categories.CloseFile;
      end
    else
    begin
      Categories.RejectChanges;
      ShowMessage('Ошибка при сохранении данных о категории товара.');
      Result := False;
    end;
end;

function LoadProducts: Boolean;
begin
  Result := Products.LoadFile(ProductsFileName);
end;

function SaveProducts: Boolean;
var
  P: TProductObject;
  InsertedList: PSerializableObjectList;
  I: Integer;
  appResult: TAppChangesResult;
  SuppliersOpened: Boolean;
  CategoriesOpened: Boolean;
  NoSupplier: Boolean;
  NoCategory: Boolean;
begin
  Result := False;
  if not Products.HasChanges then
    Result := True
  else if not Products.OpenFile(ProductsFileName) then
  begin
    Products.RejectChanges;
    ShowMessage('Ошибка при сохранении данных о товаре.');
    Exit;
  end;
  SuppliersOpened := True;
  CategoriesOpened := True;
  NoSupplier := False;
  NoCategory := False;
  try
    if Products.InsertedCount > 0 then
    begin
      InsertedList := Products.InsertedItemList;
      SuppliersOpened := Suppliers.OpenFile(SuppliersFileName, @SuppliersPassword);
      try
        CategoriesOpened := Categories.OpenFile(CategoriesFileName);
        try
          if SuppliersOpened and CategoriesOpened then
            for I := Products.InsertedCount - 1 downto 0 do
            begin
              P := TProductObject(InsertedList^[I]);
              if (P.SupplierID <> 0) and
                (Suppliers.Search(P.SupplierID) = nil) then
              begin
                NoSupplier := True;
                Break;
              end;
              if (P.CategoryID <> 0) and
                (Categories.Search(P.CategoryID) = nil) then
              begin
                NoCategory := True;
                Break;
              end;
            end;
        finally
          if CategoriesOpened then
            Categories.CloseFile;
        end;
      finally
        if SuppliersOpened then
          Suppliers.CloseFile;
      end;
    end;
    if SuppliersOpened and CategoriesOpened and not NoSupplier and not NoCategory then
    begin
      appResult := Products.ApplyChanges;
      if appResult = appChangesOk then
      begin
        Products.SaveIfChanged;
        Result := True;
      end else
      begin
        Products.UndoIfChanged;
        if appResult = appChangesOriginalObjectChanged then
          ShowMessage('Информация о товаре изменена другим пользователем.')
        else if appResult = appChangesUniqueIndexViolation then
          ShowMessage('Такой товар уже есть в списке.');
      end;
    end else
    begin
      Products.RejectChanges;
      if not SuppliersOpened then
        ShowMessage('Ошибка при открытии файла поставщиков.');
      if not CategoriesOpened then
        ShowMessage('Ошибка при открытии файла категорий товара.');
      if NoSupplier then
        ShowMessage('Обнаружена ссылка на несуществующего поставщика.');
      if NoCategory then
        ShowMessage('Обнаружена ссылка на несуществующую категорию товара.');
    end;
  finally
    Products.CloseFile;
  end;
end;

function SuppliersCompanyNameKeyOf(SO: TSerializableObject): string;
begin
  Result := TSupplierObject(SO).FCompanyName;
end;

function CategoriesCategoryNameKeyOf(SO: TSerializableObject): string;
begin
  Result := TCategoryObject(SO).FCategoryName;
end;

function ProductsProductNameKeyOf(SO: TSerializableObject): string;
begin
  Result := TProductObject(SO).FProductName;
end;

function ProductsSupplierIDKeyOf(SO: TSerializableObject): Integer;
begin
  Result := TProductObject(SO).FSupplierID;
end;

function ProductsCategoryIDKeyOf(SO: TSerializableObject): Integer;
begin
  Result := TProductObject(SO).FCategoryID;
end;

procedure CreateCollections;
begin
  SuppliersCompanyNameIndex := TStringIndex.Create(SuppliersCompanyNameKeyOf, True, False);
  Suppliers := TSerializableCollection.Create(TSupplierObject, 1, [SuppliersCompanyNameIndex]);
  Suppliers.MaintainHash := True;

  CategoriesCategoryNameIndex := TStringIndex.Create(CategoriesCategoryNameKeyOf, True, False);
  Categories := TBytePrimaryKeyCollection.Create(TCategoryObject, 1, [CategoriesCategoryNameIndex]);

  ProductsProductNameIndex := TStringIndex.Create(ProductsProductNameKeyOf, True, False);
  ProductsSupplierIDIndex := TIntegerIndex.Create(ProductsSupplierIDKeyOf, False);
  ProductsCategoryIDIndex := TIntegerIndex.Create(ProductsCategoryIDKeyOf, False);
  Products := TSerializableCollection.Create(TProductObject, 2,
    [ProductsProductNameIndex, ProductsSupplierIDIndex, ProductsCategoryIDIndex]);

  CheckedCategories := TIntegerList.Create;
end;

procedure FreeCollections;
begin
  Suppliers.Free;
  Categories.Free;
  Products.Free;
  CheckedCategories.Free;
end;

procedure UpdateFileNames;
var
  AppPath, DataPath: string;
begin
  AppPath := ExtractFilePath(Application.EXEName);
  DataPath := AppPath + cfDataPath;
  SuppliersFileName := DataPath + cfSuppliers;
  CategoriesFileName := DataPath + cfCategories;
  ProductsFileName := DataPath + cfProducts;
  TemplatesPath := AppPath + cfTemplatesPath;
end;

initialization
  CreateCollections;
  UpdateFileNames;

finalization
  FreeCollections;

end.
