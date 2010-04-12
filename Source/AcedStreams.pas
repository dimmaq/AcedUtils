
//////////////////////////////////////////////////////
//                                                  //
//   AcedStreams 1.16                               //
//                                                  //
//   Классы для работы с бинарным потоком данных.   //
//                                                  //
//   mailto: acedutils@yandex.ru                    //
//                                                  //
//////////////////////////////////////////////////////

unit AcedStreams;

{$B-,H+,R-,Q-,T-,X+}

interface

uses AcedConsts, AcedCompression, AcedCrypto, Classes;

type

{ Класс TBinaryReader предназначен для чтения данных из бинарного потока. }

  TBinaryReader = class(TObject)
  private
    FLength: Integer;
    FPosition: Integer;
    FBytes: PBytes;
    procedure EraseData;
    procedure Load(P: Pointer; L: Integer; EncryptionKey: PSHA256Digest);
  public

  { Деструктор Destroy обнуляет и освобождает память, занятую внутренним
    массивом, содержащим данные бинарного потока. Кроме того, освобождает
    память, занятую самим экземпляром класса TBinaryReader. }

    destructor Destroy; override;

  { Свойство Position возвращает текущую позицию в байтах относительно начала
    бинарного потока, т.е. индекс следующего читаемого байта. }

    property Position: Integer read FPosition;

  { Свойство Length возвращает длину бинарного потока в байтах. Это значение
    соответствует максимальному значению свойства Position. При попытке чтения
    данных за пределами этой длины возникает исключение. }

    property Length: Integer read FLength;

  { Метод LoadFromArray загружает данные бинарного потока из области памяти
    длиной Length байт, адресуемой параметром Bytes. Если параметр OwnBytes
    равен True, память, распределенная под массив Bytes, освобождается после
    считывания из нее данных. Если параметр EncryptionKey не равен nil,
    предполагается, что исходные данные потока зашифрованы и перед загрузкой
    их во внутренний массив бинарного потока они расшифровываются с ключом
    EncryptionKey. }

    procedure LoadFromArray(Bytes: Pointer; Length: Integer;
      OwnBytes: Boolean = False; EncryptionKey: PSHA256Digest = nil);

  { Метод LoadFromBase64 загружает данные бинарного потока из строки S,
    представленной в кодировке Base64. Если параметр EncryptionKey не равен
    nil, это означает, что исходные данные потока зашифрованы и перед
    загрузкой их во внутренний массив бинарного потока они расшифровываются
    с ключом EncryptionKey. }

    procedure LoadFromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest = nil);

  { Функция LoadFromFile загружает данные бинарного потока из файла,
    дескриптор которого передается параметром FileHandle. Текущая позиция
    в файла должна быть заранее установлена на начало данных бинарного
    потока. Если параметр EncryptionKey не равен nil, предполагается, что
    данные в файле зашифрованы и перед загрузкой их во внутренний массив
    бинарного потока они расшифровываются с ключом EncryptionKey. }

    function LoadFromFile(FileHandle: THandle;
      EncryptionKey: PSHA256Digest = nil): Boolean;

  { Функция LoadFromStream загружает данные бинарного потока из другого,
    потока типа TStream. Если параметр EncryptionKey не равен nil,
    предполагается, что данные в потоке Stream зашифрованы. Тогда
    перед загрузкой их во внутренний массив этого бинарного потока они
    расшифровываются с ключом EncryptionKey. }

    function LoadFromStream(Stream: TStream;
      EncryptionKey: PSHA256Digest = nil): Boolean;

  { Метод Reset устанавливает текущую позицию на начало бинарного потока.
    После этого данные могут быть повторно считаны из бинарного потока. }

    procedure Reset;

  { Метод Read считывает Count байт из бинарного потока и помещает их
    в область памяти, адресуемую параметром P. }

    procedure Read(P: Pointer; Count: Integer); overload;

  { Функция Read пропускает Count байт во входном потоке данных. Свойство
    Position увеличивается при этом на значение Count. Функция возвращает
    указатель на первый байт пропущенного фрагмента бинарного потока. }

    function Read(Count: Integer): Pointer; overload;

  { Функция ReadString считывает строку типа AnsiString из бинарного потока. }

    function ReadString(): AnsiString;

  { Функция ReadShortInt считывает значение типа ShortInt из бинарного потока. }

    function ReadShortInt(): ShortInt;

  { Функция ReadByte считывает значение типа Byte из бинарного потока. }

    function ReadByte(): Byte;

  { Функция ReadSmallInt считывает значение типа SmallInt из бинарного потока. }

    function ReadSmallInt(): SmallInt;

  { Функция ReadWord считывает значение типа Word из бинарного потока. }

    function ReadWord(): Word;

  { Функция ReadInteger считывает значение типа Integer из бинарного потока. }

    function ReadInteger(): Integer;

  { Функция ReadLongWord считывает значение типа LongWord из бинарного потока. }

    function ReadLongWord(): LongWord;

  { Функция ReadInt64 считывает значение типа Int64 из бинарного потока. }

    function ReadInt64(): Int64;

  { Функция ReadDateTime считывает значение типа TDateTime из бинарного потока. }

    function ReadDateTime(): TDateTime;

  { Функция ReadSingle считывает значение типа Single из бинарного потока. }

    function ReadSingle(): Single;

  { Функция ReadDouble считывает значение типа Double из бинарного потока. }

    function ReadDouble(): Double;

  { Функция ReadCurrency считывает значение типа Currency из бинарного потока. }

    function ReadCurrency(): Currency;

  { Функция ReadBoolean считывает значение типа Boolean из бинарного потока. }

    function ReadBoolean(): Boolean;

  { Функция ReadChar считывает значение типа AnsiChar из бинарного потока. }

    function ReadChar(): AnsiChar;
  end;


{ Класс TBinaryWriter предназначен для помещения данных в бинарный поток. }

  TBinaryWriter = class(TObject)
  private
    FLength: Integer;
    FCapacity: Integer;
    FBytes: PBytes;
    procedure SetCapacity(NewCapacity: Integer);
    procedure EnlargeCapacity(Capacity: Integer);
  public

  { Конструктор Create cоздает экземпляр класса TBinaryWriter, т.е. бинарный
    поток, предназначенный для записи в него данных. Если заранее известен
    объем данных, которые будут помещены в бинарный поток, можно передать это
    значение в параметре Capacity конструктора, чтобы исключить лишнее
    перераспределение памяти. }

    constructor Create(Capacity: Integer = 0);

  { Деструктор Destroy обнуляет и освобождает память, занятую внутренним
    массивом, содержащим данные бинарного потока. Кроме того, освобождает
    память, занятую самим экземпляром класса TBinaryWriter. }

    destructor Destroy; override;

  { Свойство Capacity возвращает или устанавливает размер блока памяти,
    выделенного под бинарный поток. При превышении этого размера произойдет
    выделение нового блока памяти и копирование в него данных бинарного
    потока. }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство Length возвращает текущую длину бинарного потока, т.е. позицию
    следующего сохраняемого байта относительно начала потока. }

    property Length: Integer read FLength;

  { Вызов метода EnsureCapacity гарантирует, что под бинарный поток будет
    выделен блок памяти, достаточный для хранения Capacity байт. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Reset очищает выходной бинарный поток и подготавливает его к
    заполнению новыми данными. Свойство Capacity при этом не изменяется. }

    procedure Reset;

  { Метод Write помещает Count байт, адресуемых параметром P, в выходной
    бинарный поток. }

    procedure Write(P: Pointer; Count: Integer); overload;

  { Функция Write увеличивает длину выходного бинарного потока на Count байт,
    не заполняя данными фрагмент соответствующего размера. Функция возвращает
    указатель на первый байт пропущенного фрагмента. }

    function Write(Count: Integer): Pointer; overload;

  { Метод WriteString помещает в поток строку S типа AnsiString. }

    procedure WriteString(const S: AnsiString);

  { Метод WriteShortInt помещает в поток значение типа ShortInt. }

    procedure WriteShortInt(N: ShortInt);

  { Метод WriteByte помещает в поток значение типа Byte. }

    procedure WriteByte(N: Byte);

  { Метод WriteSmallInt помещает в поток значение типа SmallInt. }

    procedure WriteSmallInt(N: SmallInt);

  { Метод WriteWord помещает в поток значение типа Word. }

    procedure WriteWord(N: Word);

  { Метод WriteInteger помещает в поток значение типа Integer. }

    procedure WriteInteger(N: Integer);

  { Метод WriteLongWord помещает в поток значение типа LongWord. }

    procedure WriteLongWord(N: LongWord);

  { Метод WriteInt64 помещает в поток значение типа Int64. }

    procedure WriteInt64(const N: Int64);

  { Метод WriteDateTime помещает в поток значение типа TDateTime. }

    procedure WriteDateTime(const D: TDateTime);

  { Метод WriteSingle помещает в поток значение типа Single. }

    procedure WriteSingle(const V: Single);

  { Метод WriteDouble помещает в поток значение типа Double. }

    procedure WriteDouble(const V: Double);

  { Метод WriteCurrency помещает в поток значение типа Currency. }

    procedure WriteCurrency(const V: Currency);

  { Метод WriteBoolean помещает в поток значение типа Boolean. }

    procedure WriteBoolean(V: Boolean);

  { Метод WriteChar помещает в поток значение типа AnsiChar. }

    procedure WriteChar(C: AnsiChar);

  { Функция SaveToArray сохраняет данные бинарного потока в области памяти,
    адрес которой возвращается затем в параметре Bytes, а длина этой области
    памяти возвращается как результат функции. Если параметр EncryptionKey
    не равен nil, перед сохранением данные шифруются с ключом EncryptionKey.
    Параметр CompressionMode, если он отличен от dcmNoCompression, задает
    режим сжатия данных бинарного потока. }

    function SaveToArray(var Bytes: Pointer; EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): Integer;

  { Функция SaveToBase64 представляет данные бинарного потока в виде строки
    в кодировке Base64. Эта строка возвращается как результат функции. Если
    параметр EncryptionKey не равен nil, перед сохранением данные шифруются
    с ключом EncryptionKey. Параметр CompressionMode, если он отличен от
    dcmNoCompression, задает режим сжатия данных бинарного потока. }

    function SaveToBase64(EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): AnsiString;

  { Функция SaveToFile сохраняет данные бинарного потока в файле, дескриптор
    которого передан параметром FileHandle. Текущая позиция в файле должна
    быть заранее установлена в нужное положение. Если параметр EncryptionKey
    не равен nil, перед сохранением данные шифруются с ключом EncryptionKey.
    Параметр CompressionMode, если он отличен от dcmNoCompression, задает
    режим сжатия данных бинарного потока. }

    function SaveToFile(FileHandle: THandle; EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): Boolean;

  { Функция SaveToStream сохраняет данные бинарного потока в другом потоке
    типа TStream, который задается параметром Stream. Если параметр
    EncryptionKey не равен nil, перед сохранением данные шифруются с ключом
    EncryptionKey. Параметр CompressionMode, если он отличен от
    dcmNoCompression, задает режим сжатия данных бинарного потока. }

    function SaveToStream(Stream: TStream; EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): Boolean;
  end;


{ Класс TReaderStream позволяет представить экземпляр класса TBinaryReader
  в виде объекта, производного от класса TStream. }

  TReaderStream = class(TStream)
  private
    FReader: TBinaryReader;
  protected
    function GetSize: Int64; override;
    procedure SetSize(NewSize: Longint); override;
  public

  { Конструктор Create создает экземпляр класса TReaderStream на основе
    экземпляра класса TBinaryReader, передаваемого параметром Reader. }

    constructor Create(Reader: TBinaryReader);

  { Свойство Reader возвращает экземпляр класса TBinaryReader,
    инкапсулируемый данным классом. }

    property Reader: TBinaryReader read FReader;

  { Функция Read пытается считать Count байт из бинарного потока и сохраняет
    прочитанные данные в области памяти, ссылка на которую передается
    параметром Buffer. Если объем данных в потоке меньше Count байт,
    считывается все, что есть. Функция возвращает число байт, фактически
    прочитанное из бинарного потока. }

    function Read(var Buffer; Count: Longint): Longint; override;

  { При вызове функции Write класса TReaderStream возникает исключение,
    т.к. этот класс не предназначен для записи данных в поток. }

    function Write(const Buffer; Count: Longint): Longint; override;

  { Функция Seek перемещает текущую позицию в бинарном потоке и возвращает
    новое значение свойства Reader.Position. Если параметр Origin равен
    soFromBeginning, текущая позиция устанавливается на расстоянии Offset
    байт от начала бинарного потока. Если Origin равен soFromCurrent текущая
    позиция смещается на Offset байт относительно ее прежнего положения.
    Если параметр Origin равен soFromEnd, позиция устанавливается на
    расстоянии Offset байт с конца бинарного потока. В последнем случае
    Offset, как правило, задается отрицательным числом. }

    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;


{ Класс TWriterStream позволяет представить экземпляр класса TBinaryWriter
  в виде объекта, производного от класса TStream. }

  TWriterStream = class(TStream)
  private
    FWriter: TBinaryWriter;
  protected
    function GetSize: Int64; override;
    procedure SetSize(NewSize: Longint); override;
  public

  { Конструктор Create создает экземпляр класса TWriterStream на основе
    экземпляра класса TBinaryWriter, передаваемого параметром Writer. }

    constructor Create(Writer: TBinaryWriter);

  { Свойство Writer возвращает экземпляр класса TBinaryWriter,
    инкапсулируемый данным классом. }

    property Writer: TBinaryWriter read FWriter;

  { При вызове функции Read класса TWriterStream возникает исключение,
    т.к. этот класс не предназначен для чтения данных из потока. }

    function Read(var Buffer; Count: Longint): Longint; override;

  { Функция Write переписывает в бинарный поток Count байт из области памяти,
    ссылка на которую передается параметром Buffer. Функция возвращает
    переданное в нее значение параметра Count. }

    function Write(const Buffer; Count: Longint): Longint; override;

  { Функция Seek изменяет текущую длину выходного бинарном потока и возвращает
    новое значение свойства Writer.Length. Если параметр Origin равен
    soFromBeginning, текущая позиция, т.е. длина, устанавливается на расстоянии
    Offset байт от начала бинарного потока. Если Origin равен soFromCurrent
    текущая позиция смещается на Offset байт относительно прежней длины.
    Если параметр Origin равен soFromEnd, позиция устанавливается на расстоянии
    Offset байт с конца бинарного потока. Если новая длина потока превосходит
    прежнее значение длины, возможно выделение дополнительной памяти под
    внутренний массив бинарного потока. }

    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

implementation

uses Windows, AcedBinary, AcedCommon;

{ TBinaryReader }

destructor TBinaryReader.Destroy;
begin
  EraseData;
end;

procedure TBinaryReader.EraseData;
begin
  if FBytes <> nil then
  begin
    G_ZeroMem(FBytes, FLength);
    FLength := 0;
    FPosition := 0;
    FreeMem(FBytes);
    FBytes := nil;
  end;
end;

procedure TBinaryReader.Load(P: Pointer; L: Integer; EncryptionKey: PSHA256Digest);
var
  Hash: TSHA256Digest;
  H: HRC6;
begin
  Dec(L, 4);
  if (L < 0) or (G_Adler32(@PBytes(P)^[4], L) <> PLongWord(P)^) then
    RaiseError(SErrBinaryStreamCorrupted);
  if not Assigned(EncryptionKey) then
    FLength := PInteger(@PBytes(P)^[4])^
  else
  begin
    Dec(L, 32);
    G_RC6Init(H, EncryptionKey, 32);
    G_RC6SetOrdinaryVector(H);
    G_RC6DecryptCFB(H, @PBytes(P)^[36], L);
    G_RC6Done(H);
    G_SHA256(@PBytes(P)^[36], L, @Hash);
    if not G_SHA256Equals(@PBytes(P)^[4], @Hash) then
      RaiseError(SErrWrongDecryptionKey);
    FLength := PInteger(@PBytes(P)^[36])^;
  end;
  if FLength > 0 then
  begin
    GetMem(FBytes, FLength);
    if not Assigned(EncryptionKey) then
      G_Inflate(@PBytes(P)^[4], L, FBytes)
    else
    begin
      G_Inflate(@PBytes(P)^[36], L, FBytes);
      G_ZeroMem(P, L + 36);
    end;
    FreeMem(P);
  end else
  begin
    FLength := -FLength;
    if FLength <> L - 4 then
      RaiseError(SErrWrongStreamLength);
    L := (L - 1) shr 2;
    if not Assigned(EncryptionKey) then
      G_CopyLongs(@PBytes(P)^[8], P, L)
    else
    begin
      G_CopyLongs(@PBytes(P)^[40], P, L);
      G_ZeroMem(@PBytes(P)^[FLength], 40);
    end;
    FBytes := P;
  end;
end;

procedure TBinaryReader.LoadFromArray(Bytes: Pointer; Length: Integer;
  OwnBytes: Boolean; EncryptionKey: PSHA256Digest);
var
  P: Pointer;
begin
  EraseData;
  if not OwnBytes then
  begin
    GetMem(P, Length);
    G_CopyMem(Bytes, P, Length);
  end else
    P := Bytes;
  Load(P, Length, EncryptionKey);
end;

procedure TBinaryReader.LoadFromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
begin
  EraseData;
  L := G_Base64Decode(S, nil);
  if L > 0 then
  begin
    GetMem(P, L);
    G_Base64Decode(S, P);
    Load(P, L, EncryptionKey);
  end;
end;

function TBinaryReader.LoadFromFile(FileHandle: THandle;
  EncryptionKey: PSHA256Digest): Boolean;
var
  Count: LongWord;
  L: Integer;
  P: Pointer;
begin
  EraseData;
  Result := False;
  if not ReadFile(FileHandle, L, 4, Count, nil) or (Count <> 4) or (L < 8) then
    Exit;
  GetMem(P, L);
  if not ReadFile(FileHandle, P^, L, Count, nil) or (Integer(Count) <> L) then
  begin
    FreeMem(P);
    Exit;
  end;
  Load(P, L, EncryptionKey);
  Result := True;
end;

function TBinaryReader.LoadFromStream(Stream: TStream;
  EncryptionKey: PSHA256Digest): Boolean;
var
  L: Integer;
  P: Pointer;
begin
  EraseData;
  Result := False;
  if (Stream.Read(L, 4) <> 4) or (L < 8) then
    Exit;
  GetMem(P, L);
  if Stream.Read(P^, L) <> L then
  begin
    FreeMem(P);
    Exit;
  end;
  Load(P, L, EncryptionKey);
  Result := True;
end;

procedure TBinaryReader.Reset;
begin
  FPosition := 0;
end;

procedure TBinaryReader.Read(P: Pointer; Count: Integer);
var
  X: Integer;
begin
  X := FPosition + Count;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  G_CopyMem(@FBytes^[FPosition], P, Count);
  FPosition := X;
end;

function TBinaryReader.Read(Count: Integer): Pointer;
var
  X: Integer;
begin
  X := FPosition + Count;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := @FBytes^[FPosition];
  FPosition := X;
end;

function TBinaryReader.ReadString(): AnsiString;
var
  L, X: Integer;
begin
  L := ReadByte;
  if L = $FF then
  begin
    L := ReadWord;
    if L = $FFFF then
      L := ReadInteger
    else
      Inc(L, $FF);
  end;
  SetLength(Result, L);
  if L > 0 then
  begin
    X := FPosition + L;
    if X > FLength then
      RaiseError(SErrReadBeyondTheEndOfStream);
    G_CopyMem(@FBytes^[FPosition], Pointer(Result), L);
    FPosition := X;
  end;
end;

function TBinaryReader.ReadShortInt(): ShortInt;
begin
  if FPosition = FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PShortInt(@FBytes^[FPosition])^;
  Inc(FPosition);
end;

function TBinaryReader.ReadByte(): Byte;
begin
  if FPosition = FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := FBytes^[FPosition];
  Inc(FPosition);
end;

function TBinaryReader.ReadSmallInt(): SmallInt;
var
  X: Integer;
begin
  X := FPosition + 2;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PSmallInt(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadWord(): Word;
var
  X: Integer;
begin
  X := FPosition + 2;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PWord(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadInteger(): Integer;
var
  X: Integer;
begin
  X := FPosition + 4;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PInteger(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadLongWord(): LongWord;
var
  X: Integer;
begin
  X := FPosition + 4;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PLongWord(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadInt64(): Int64;
var
  X: Integer;
begin
  X := FPosition + 8;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PInt64(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadDateTime(): TDateTime;
var
  X: Integer;
begin
  X := FPosition + 8;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PDateTime(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadSingle(): Single;
var
  X: Integer;
begin
  X := FPosition + 4;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PSingle(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadDouble(): Double;
var
  X: Integer;
begin
  X := FPosition + 8;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PDouble(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadCurrency(): Currency;
var
  X: Integer;
begin
  X := FPosition + 8;
  if X > FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PCurrency(@FBytes^[FPosition])^;
  FPosition := X;
end;

function TBinaryReader.ReadBoolean(): Boolean;
begin
  if FPosition = FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PBoolean(@FBytes^[FPosition])^;
  Inc(FPosition);
end;

function TBinaryReader.ReadChar(): AnsiChar;
begin
  if FPosition = FLength then
    RaiseError(SErrReadBeyondTheEndOfStream);
  Result := PAnsiChar(@FBytes^[FPosition])^;
  Inc(FPosition);
end;

{ TBinaryWriter }

constructor TBinaryWriter.Create(Capacity: Integer);
begin
  FCapacity := G_NormalizeCapacity(Capacity);
  FBytes := G_AllocMem(FCapacity);
end;

destructor TBinaryWriter.Destroy;
begin
  if FCapacity > 0 then
  begin
    G_ZeroMem(FBytes, FLength);
    FreeMem(FBytes);
  end;
end;

procedure TBinaryWriter.SetCapacity(NewCapacity: Integer);
var
  NewBytes: PBytes;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FLength) then
  begin
    GetMem(NewBytes, NewCapacity);
    FCapacity := NewCapacity;
    G_CopyMem(FBytes, NewBytes, FLength);
    G_ZeroMem(FBytes, FLength);
    FreeMem(FBytes);
    FBytes := NewBytes;
  end;
end;

procedure TBinaryWriter.EnlargeCapacity(Capacity: Integer);
var
  NewCapacity: Integer;
begin
  NewCapacity := G_EnlargeCapacity(FCapacity);
  if NewCapacity < Capacity then
    NewCapacity := G_NormalizeCapacity(Capacity);
  SetCapacity(NewCapacity);
end;

procedure TBinaryWriter.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TBinaryWriter.Reset;
begin
  G_ZeroMem(FBytes, FLength);
  FLength := 0;
end;

procedure TBinaryWriter.Write(P: Pointer; Count: Integer);
var
  X: Integer;
begin
  X := FLength + Count;
  if X > FCapacity then
    EnlargeCapacity(X);
  G_CopyMem(P, @FBytes^[FLength], Count);
  FLength := X;
end;

function TBinaryWriter.Write(Count: Integer): Pointer;
var
  X: Integer;
begin
  X := FLength + Count;
  if X > FCapacity then
    EnlargeCapacity(X);
  Result := @FBytes^[FLength];
  FLength := X;
end;

procedure TBinaryWriter.WriteString(const S: AnsiString);
var
  L, X: Integer;
begin
  L := System.Length(S);
  X := L + FLength;
  if L < $FF then
    Inc(X)
  else if L < $100FE then
    Inc(X, 3)
  else
    Inc(X, 7);
  if X > FCapacity then
    EnlargeCapacity(X);
  if L < $FF then
  begin
    FBytes^[FLength] := Byte(L);
    Inc(FLength);
  end
  else if L < $100FE then
  begin
    FBytes^[FLength] := $FF;
    FBytes^[FLength + 1] := Byte(L - $FF);
    FBytes^[FLength + 2] := Byte((L - $FF) shr 8);
    Inc(FLength, 3);
  end else
  begin
    FBytes^[FLength] := $FF;
    FBytes^[FLength + 1] := $FF;
    FBytes^[FLength + 2] := $FF;
    PInteger(@FBytes^[FLength + 3])^ := L;
    Inc(FLength, 7);
  end;
  if L > 0 then
    G_CopyMem(Pointer(S), @FBytes^[FLength], L);
  FLength := X;
end;

procedure TBinaryWriter.WriteShortInt(N: ShortInt);
begin
  if FLength = FCapacity then
    EnlargeCapacity(FLength + 1);
  PShortInt(@FBytes^[FLength])^ := N;
  Inc(FLength);
end;

procedure TBinaryWriter.WriteByte(N: Byte);
begin
  if FLength = FCapacity then
    EnlargeCapacity(FLength + 1);
  FBytes^[FLength] := N;
  Inc(FLength);
end;

procedure TBinaryWriter.WriteSmallInt(N: SmallInt);
var
  X: Integer;
begin
  X := FLength + 2;
  if X > FCapacity then
    EnlargeCapacity(X);
  PSmallInt(@FBytes^[FLength])^ := N;
  FLength := X;
end;

procedure TBinaryWriter.WriteWord(N: Word);
var
  X: Integer;
begin
  X := FLength + 2;
  if X > FCapacity then
    EnlargeCapacity(X);
  PWord(@FBytes^[FLength])^ := N;
  FLength := X;
end;

procedure TBinaryWriter.WriteInteger(N: Integer);
var
  X: Integer;
begin
  X := FLength + 4;
  if X > FCapacity then
    EnlargeCapacity(X);
  PInteger(@FBytes^[FLength])^ := N;
  FLength := X;
end;

procedure TBinaryWriter.WriteLongWord(N: LongWord);
var
  X: Integer;
begin
  X := FLength + 4;
  if X > FCapacity then
    EnlargeCapacity(X);
  PLongWord(@FBytes^[FLength])^ := N;
  FLength := X;
end;

procedure TBinaryWriter.WriteInt64(const N: Int64);
var
  X: Integer;
begin
  X := FLength + 8;
  if X > FCapacity then
    EnlargeCapacity(X);
  PInt64(@FBytes^[FLength])^ := N;
  FLength := X;
end;

procedure TBinaryWriter.WriteDateTime(const D: TDateTime);
var
  X: Integer;
begin
  X := FLength + 8;
  if X > FCapacity then
    EnlargeCapacity(X);
  PDateTime(@FBytes^[FLength])^ := D;
  FLength := X;
end;

procedure TBinaryWriter.WriteSingle(const V: Single);
var
  X: Integer;
begin
  X := FLength + 4;
  if X > FCapacity then
    EnlargeCapacity(X);
  PSingle(@FBytes^[FLength])^ := V;
  FLength := X;
end;

procedure TBinaryWriter.WriteDouble(const V: Double);
var
  X: Integer;
begin
  X := FLength + 8;
  if X > FCapacity then
    EnlargeCapacity(X);
  PDouble(@FBytes^[FLength])^ := V;
  FLength := X;
end;

procedure TBinaryWriter.WriteCurrency(const V: Currency);
var
  X: Integer;
begin
  X := FLength + 8;
  if X > FCapacity then
    EnlargeCapacity(X);
  PCurrency(@FBytes^[FLength])^ := V;
  FLength := X;
end;

procedure TBinaryWriter.WriteBoolean(V: Boolean);
begin
  if FLength = FCapacity then
    EnlargeCapacity(FLength + 1);
  PBoolean(@FBytes^[FLength])^ := V;
  Inc(FLength);
end;

procedure TBinaryWriter.WriteChar(C: AnsiChar);
begin
  if FLength = FCapacity then
    EnlargeCapacity(FLength + 1);
  PAnsiChar(@FBytes^[FLength])^ := C;
  Inc(FLength);
end;

function TBinaryWriter.SaveToArray(var Bytes: Pointer; EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): Integer;
var
  H: HRC6;
begin
  if not Assigned(EncryptionKey) then
    Result := G_Deflate(FBytes, FLength, Bytes, 4, 0, CompressionMode)
  else
  begin
    Result := G_Deflate(FBytes, FLength, Bytes, 36, 0, CompressionMode);
    G_SHA256(@PBytes(Bytes)^[36], Result, @PBytes(Bytes)^[4]);
    G_RC6Init(H, EncryptionKey, 32);
    G_RC6SetOrdinaryVector(H);
    G_RC6EncryptCFB(H, @PBytes(Bytes)^[36], Result);
    G_RC6Done(H);
    Inc(Result, 32);
  end;
  PLongWord(Bytes)^ := G_Adler32(@PBytes(Bytes)^[4], Result);
  Inc(Result, 4);
end;

function TBinaryWriter.SaveToBase64(EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): AnsiString;
var
  P: Pointer;
  L: Integer;
begin
  L := SaveToArray(P, EncryptionKey, CompressionMode);
  Result := G_Base64Encode(P, L);
  FreeMem(P);
end;

function TBinaryWriter.SaveToFile(FileHandle: THandle; EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): Boolean;
var
  P: Pointer;
  L: Integer;
  Count: LongWord;
begin
  L := SaveToArray(P, EncryptionKey, CompressionMode);
  Result := False;
  if not WriteFile(FileHandle, L, 4, Count, nil) or (Count <> 4) then
  begin
    FreeMem(P);
    Exit;
  end;
  Result := WriteFile(FileHandle, P^, L, Count, nil) and (Integer(Count) = L);
  FreeMem(P);
end;

function TBinaryWriter.SaveToStream(Stream: TStream; EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): Boolean;
var
  P: Pointer;
  L: Integer;
begin
  L := SaveToArray(P, EncryptionKey, CompressionMode);
  Result := False;
  if Stream.Write(L, 4) <> 4 then
  begin
    FreeMem(P);
    Exit;
  end;
  Result := Stream.Write(P^, L) = L;
  FreeMem(P);
end;

{ TReaderStream }

constructor TReaderStream.Create(Reader: TBinaryReader);
begin
  FReader := Reader;
end;

function TReaderStream.GetSize: Int64;
begin
  Result := FReader.FLength;
end;

procedure TReaderStream.SetSize(NewSize: Longint);
begin
  RaiseError(SErrStreamIsReadOnly);
end;

function TReaderStream.Read(var Buffer; Count: Longint): Longint;
var
  P0, P1: Integer;
begin
  P0 := FReader.FPosition;
  P1 := P0 + Count;
  if P1 > FReader.FLength then
  begin
    P1 := FReader.FLength;
    Result := P1 - P0;
  end else
    Result := Count;
  G_CopyMem(@FReader.FBytes^[P0], @Buffer, Result);
  FReader.FPosition := P1;
end;

function TReaderStream.Write(const Buffer; Count: Longint): Longint;
begin
  RaiseError(SErrStreamIsReadOnly);
  Result := 0;
end;

function TReaderStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := FReader.FPosition;
  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent: Inc(Result, Offset);
    soFromEnd: Result := FReader.FLength + Offset;
  end;
  if Result > FReader.FLength then
    Result := FReader.FLength
  else if Result < 0 then
    Result := 0;
  FReader.FPosition := Result;
end;

{ TWriterStream }

constructor TWriterStream.Create(Writer: TBinaryWriter);
begin
  FWriter := Writer;
end;

function TWriterStream.GetSize: Int64;
begin
  Result := FWriter.FLength;
end;

procedure TWriterStream.SetSize(NewSize: Longint);
begin
  Seek(NewSize, soFromBeginning);
end;

function TWriterStream.Read(var Buffer; Count: Longint): Longint;
begin
  RaiseError(SErrStreamIsWriteOnly);
  Result := 0;
end;

function TWriterStream.Write(const Buffer; Count: Longint): Longint;
begin
  FWriter.Write(@Buffer, Count);
  Result := Count;
end;

function TWriterStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := FWriter.FLength;
  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent: Inc(Result, Offset);
    soFromEnd: Result := FWriter.FLength + Offset;
  end;
  if Result < 0 then
    Result := 0;
  if Result > FWriter.FCapacity then
    FWriter.EnlargeCapacity(Result);
  FWriter.FLength := Result;
end;

end.

