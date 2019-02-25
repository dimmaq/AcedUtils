
///////////////////////////////////////////////////////////
//                                                       //
//   AcedContainers 1.17                                 //
//                                                       //
//   Классы и коллекции для организации битовых полей,   //
//   обычных, ассоциативных, связанных, хэшированных     //
//   и других списков, бинарных деревьев, обычных и      //
//   приоритетных очередей и т.п.                        //
//                                                       //
//   mailto: acedutils@yandex.ru                         //
//                                                       //
///////////////////////////////////////////////////////////

unit AcedContainers;

{$B-,H+,R-,Q-,T-,X+}

interface

uses Registry, AcedBinary, AcedConsts, AcedCrypto, AcedCompression,
  AcedAlgorithm, AcedStreams;

type

{ Класс TBitList представляет собой битовое поле, т.е. упакованный набор
  элементов типа Boolean }

  TBitList = class(TObject)
  private
    FCapacity: Integer;
    FBits: PLongWordItemList;
    FCount: Integer;
    procedure IntSetCount(NewCount: Integer);
    function IntGetBit(Index: Integer): Boolean;
    procedure IntSetBit(Index: Integer; Value: Boolean);
    procedure SetCount(NewCount: Integer);
  public

  { Конструктор Create создает список с заданным количеством элементов.
    При этом элементы списка инициализируются значением InitValue. }

    constructor Create(Count: Integer; InitValue: Boolean = False);

  { Деструктор Destroy освобождает память, занятую экземпляром класса TBitList
    и внутренним массивом, адресуемым свойством InnerList. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает или устанавливает число значений в упакованном
    списке. При установке этого свойства возможно перераспределение памяти под
    внутренний массив InnerList. }

    property Count: Integer read FCount write SetCount;

  { Свойство Bits возвращает или устанавливает значение элемента битовой
    строки с индексом Index (индексация с нуля). }

    property Bits[Index: Integer]: Boolean read IntGetBit write IntSetBit; default;

  { Свойство Capacity возвращает размер (в двойных словах) внутреннего массива,
    адресуемого свойством InnerList. }

    property Capacity: Integer read FCapacity;

  { Свойство InnerList возвращает указатель на внутренний массив, содержащий
    битовую строку. Количество элементов в этом массиве можно определить,
    обратившись к свойству Capacity. }

    property InnerList: PLongWordItemList read FBits;

  { Методы }

  { Следующий метод Load загружает список из бинарного потока Reader. }

    procedure Load(Reader: TBinaryReader); overload;

  { Следующий метод Load загружает значения из списка, переданного параметром
    BitList, в данный список. }

    procedure Load(BitList: TBitList); overload;

  { Следующий метод Load загружает в данный список значения из массива двойных
    слов, адресуемых параметром Bits. Параметр Count определяет длину битовой
    строки (в битах). Эта длина соответствует значению свойства TBitList.Count
    после выполнения операции. }

    procedure Load(Bits: Pointer; Count: Integer); overload;

  { Следующий метод Load загружает в список значения, сохраненные в реестре
    Windows. В экземпляре класса TRegistry, передаваемом параметром Registry,
    должен быть открыт нужный ключ в режиме, допускающем чтение. Имя значения
    задается параметром ValueName. Если параметр EncryptionKey не равен nil,
    предполагается, что данные в реестре зашифрованы и перед чтением их
    необходимо расшифровать с ключом EncryptionKey. }

    procedure Load(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil); overload;

  { Следующий метод Save сохраняет список в бинарном потоке Writer. }

    procedure Save(Writer: TBinaryWriter); overload;

  { Следующий метод Save сохраняет список в реестре Windows. В экземпляре
    класса TRegistry, передаваемом параметром Registry, должен быть открыт
    нужный ключ в режиме, допускающем запись. Имя значения задается параметром
    ValueName. Если параметр EncryptionKey не равен nil, данные перед
    сохранением шифруются с ключом EncryptionKey. Параметр CompressionMode,
    если он отличен от dcmNoCompression, определяет режим сжатия данных. }

    procedure Save(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression); overload;

  { Метод FromString загружает список из строки S, состоящей из символов
    '0' и '1'. Например, вызов FromString('10110') создаст битовую строку
    из пяти элементов со значениями: True, False, True, True, False. }

    procedure FromString(const S: AnsiString);

  { Функция ToString возвращает список в виде строки, состоящей из символов
    '0' и '1'. Например, список из пяти элементов может быть представлен
    строкой: '10101'. }

    function ToString: AnsiString;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Метод FromBase64 загружает список из строки S, которая представляет
    собой бинарный поток данных в кодировке Base64. Если данные, помещенные
    в бинарный поток, зашифрованы, необходимо передать ключ в параметре
    EncryptionKey. }

    procedure FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest = nil);

  { Функция ToBase64 сохраняет список в бинарном потоке и преобразует его
    в строку в кодировке Base64. Полученная строка возвращается как результат
    функции. Если параметр Encrypted не равен nil, данные, помещенные в
    бинарный поток, шифруются с ключом EncryptionKey. Последний параметр
    CompressionMode, если он отличен от dcmNoCompression, определяет режим
    сжатия данных. }

    function ToBase64(EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): AnsiString;

  { Функция SetBit устанавливает в True (1) элемент битовой строки с индексом
    Index (индексация с нуля) и возвращает предыдущее значение этого элемента. }

    function SetBit(Index: Integer): Boolean;

  { Функция ResetBit сбрасывает в False (0) элемент битовой строки с индексом
    Index (индексация с нуля) и возвращает предыдущее значение этого элемента. }

    function ResetBit(Index: Integer): Boolean;

  { Функция ToggleBit инвертирует элемент битовой строки с индексом Index
    (индексация с нуля). Если он был равен True, то становится False, если
    был равен False, то становится True. Функция возвращает предыдущее
    состояние измененного бита. }

    function ToggleBit(Index: Integer): Boolean;

  { Функция Contains возвращает True, если в списке есть элемент, значение
    которого равно Value. }

    function Contains(Value: Boolean): Boolean;

  { Функция IndexOf возвращает индекс первого элемента списка, значение
    которого равно Value. Поиск начинается с элемента с индексом StartIndex.
    Если значение Value в списке не найдено, функция возвращает -1. }

    function IndexOf(Value: Boolean; StartIndex: Integer = 0): Integer;

  { Функция LastIndexOf возвращает индекс последнего элемента списка,
    значение которого равно Value. Поиск в обратном направлении начинается
    с элемента с индексом StartIndex, включительно. Если значение Value
    в списке не найдено, функция возвращает -1. }

    function LastIndexOf(Value: Boolean; StartIndex: Integer = MaxInt): Integer;

  { Функция CountOf возвращает количество элементов в списке, значение
    которых равно Value. }

    function CountOf(Value: Boolean): Integer;

  { Функция SetAll устанавливает все, т.е. Count элементов списка в значение
    True или False в соответствии со значением параметра Value. Возвращает
    ссылку на данный экземпляр класса TBitList. }

    function SetAll(Value: Boolean): TBitList;

  { Функция NotBits инвертирует все элементы списка. Элементы, которые были
    равны False, становятся True, а которые были равны True, становятся False.
    Возвращает ссылку на данный экземпляр класса TBitList. }

    function NotBits: TBitList;

  { Функция AndBits выполняет операцию логического умножения на соответствующие
    элементы списка BitList. Свойство Count обоих списков должно совпадать.
    Функция возвращает ссылку на данный экземпляр класса TBitList, в котором
    сохраняется результат операции. }

    function AndBits(BitList: TBitList): TBitList;

  { Функция OrBits выполняет операцию логического сложения с соответствующими
    элементами списка BitList. Свойство Count обоих списков должно совпадать.
    Функция возвращает ссылку на данный экземпляр класса TBitList, в котором
    сохраняется результат операции. }

    function OrBits(BitList: TBitList): TBitList;

  { Функция XorBits применяет операцию "исключающее ИЛИ" ко всем элементам
    данного списка и соответствующим элементам списка BitList. Свойство Count
    обоих списков должно совпадать. Функция возвращает ссылку на данный
    экземпляр класса TBitList, в котором сохраняется результат операции. }

    function XorBits(BitList: TBitList): TBitList;

  { Функция AndNotBits применяет операцию "И-НЕ" ко всем элементам данного
    списка и соответствующим элементам списка BitList. В результате получается
    список, в котором значения True присвоены только тем элементам, которые
    были равны True в исходном списке и False в списке BitList. Свойство Count
    обоих списков должно совпадать. Функция возвращает ссылку на данный
    экземпляр класса TBitList, в котором сохраняется результат операции. }

    function AndNotBits(BitList: TBitList): TBitList;

  { Функция Equals возвращает True, если данный список поэлементно совпадает
    со списком BitList. Если списки содержат различное количество элементов
    или содержат несовпадающие элементы, функция возвращает False. }

    function Equals(BitList: TBitList): Boolean;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Функция Clone возвращает экземпляр класса TBitList, который является
    копией данного списка. }

    function Clone: TBitList;
  end;

  
{ Класс TIntegerList - упорядоченный набор значений типа Integer }

  TIntegerList = class;

  TIntegerListEnumerator = class
  private
    FIndex: Integer;
    FList: TIntegerList;
  public
    constructor Create(AList: TIntegerList);
    function GetCurrent: Integer;
    function MoveNext: Boolean;
    property Current: Integer read GetCurrent;
  end;

  TIntegerList = class(TObject)
  private
    FCapacity: Integer;
    FItems: PIntegerItemList;
    FCount: Integer;
    FMaintainSorted: Boolean;
    FSorted: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetMaintainSorted(Value: Boolean);
//------------------------
    function Get(Index: Integer): Integer;
    procedure Put(Index: Integer; Item: Integer);
//------------------------
  public

  { Конструктор Create создает экземпляр класса TIntegerList и выделяет
    память под InitialCapacity элементов во внутреннем массиве. Свойство
    MaintainSorted инициализируется значением False. }

    constructor Create(InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TIntegerList и его внутренним массивом, адресуемым свойством ItemList. }

    destructor Destroy; override;

    function GetEnumerator: TIntegerListEnumerator;    

  { Свойства }

  { Свойство Count возвращает или устанавливает текущее число элементов
    в списке. При присвоении значения этому свойству никаких проверок
    не выполняется. }

    property Count: Integer read FCount write FCount;

  { Свойство ItemList возвращает указатель на внутренний массив, используемый
    для хранения элементов списка. Этот указатель меняется при изменении
    свойства Capacity. Обращение к свойству ItemList является основным методом
    доступа к элементам списка. }

    property ItemList: PIntegerItemList read FItems;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутреннем массиве. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство MaintainSorted возвращает или устанавливает значение, определяющее,
    нужно ли поддерживать элементы списка в отсортированном порядке. Если это
    свойство равно True, запрещается вызывать метод Insert для добавления
    значений в список. }

    property MaintainSorted: Boolean read FMaintainSorted write SetMaintainSorted;

  { Если свойство Sorted равно True, элементы списка упорядочены по возрастанию,
    если False - элементы не упорядочены. Чтобы быть уверенным в том, что список
    отсортирован, вызовите метод EnsureSorted. }

    property Sorted: Boolean read FSorted;

  { Методы }

  { Следующий метод Load загружает список из бинарного потока Reader. }

    procedure Load(Reader: TBinaryReader); overload;

  { Следующий метод Load загружает значения из другого экземпляра списка,
    переданного параметром IntegerList. }

    procedure Load(IntegerList: TIntegerList); overload;

  { Следующий метод Load загружает список из массива элементов типа Integer,
    адресуемого параметром Items, состоящего из Count элементов. Параметр
    Sorted определяет, является ли массив отсортированным по возрастанию. }

    procedure Load(Items: Pointer; Count: Integer; Sorted: Boolean); overload;

  { Следующий метод Load загружает список из реестра Windows. В экземпляре
    класса TRegistry, передаваемом параметром Registry, должен быть открыт
    нужный ключ в режиме, допускающем чтение. Имя значения задается параметром
    ValueName. Если параметр EncryptionKey не равен nil, предполагается, что
    данные в реестре зашифрованы и перед чтением их необходимо расшифровать
    с помощью ключа EncryptionKey. }

    procedure Load(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil); overload;

  { Следующий метод Save сохраняет список в бинарном потоке Writer. }

    procedure Save(Writer: TBinaryWriter); overload;

  { Следующий метод Save сохраняет список в реестре Windows. В экземпляре
    класса TRegistry, передаваемом параметром Registry, должен быть открыт
    нужный ключ в режиме, допускающем запись. Имя значения задается параметром
    ValueName. Если параметр EncryptionKey не равен nil, данные перед
    сохранением шифруются с ключом EncryptionKey. Параметр CompressionMode,
    если он отличен от dcmNoCompression, определяет режим сжатия данных. }

    procedure Save(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression); overload;

  { Метод FromBase64 загружает список из строки S, которая представляет собой
    бинарный поток данных в кодировке Base64. Если данные, помещенные в
    бинарный поток, зашифрованы, необходимо передать ключ в параметре
    EncryptionKey. }

    procedure FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest = nil);

  { Функция ToBase64 сохраняет список в бинарном потоке и преобразует его
    в строку в кодировке Base64. Полученная строка возвращается как результат
    функции. Если параметр EncryptionKey не равен nil, данные, помещенные
    в бинарный поток, шифруются с ключом EncryptionKey. Параметр
    CompressionMode, если он отличен от dcmNoCompression, определяет режим
    сжатия данных. }

    function ToBase64(EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): AnsiString;

  { Вызов метода EnsureCapacity гарантирует, что размер внутреннего массива,
    адресуемого свойством ItemList, будет достаточен для хранения Capacity
    элементов, т.е. свойство Capacity данного экземпляра класса TIntegerList
    будет больше или равно значению, переданному параметром Capacity.}

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Add добавляет значение N в список элементов. Если свойство
    MaintainSorted равно True, значение добавляется в соответствующую ему
    позицию, иначе - в конец списка. }

    procedure Add(N: Integer);

  { Метод AddIfNotExists добавляет значение N в список элементов при условии,
    что в списке нет такого значения. Если свойство MaintainSorted равно True,
    значение добавляется в соответствующую ему позицию, иначе - в конец списка. }

    procedure AddIfNotExists(N: Integer);

  { Следующий метод Insert вставляет элемент со значением N в позицию Index
    списка (индексация с нуля). Используется только для списков со значением
    свойства MaintainSorted равным False. }

    procedure Insert(Index, N: Integer); overload;

  { Следующий метод Insert вставляет в позицию Index списка (индексация с нуля)
    массив элементов типа Integer, адресуемый параметром Items, состоящий из
    Count элементов. Данный метод используется только для списков со значением
    свойства MaintainSorted равным False. }

    procedure Insert(Index: Integer; Items: Pointer; Count: Integer); overload;

  { Следующий метод Insert вставляет Count копий элемента со значением N
    в позицию Index списка (индексация с нуля). Используется только для списков
    со значением свойства MaintainSorted равным False. }

    procedure Insert(Index, Count, N: Integer); overload;

  { Функция PopBack возвращает значение последнего элемента списка и уменьшает
    число элементов на единицу. Эта операция эквивалентна извлечению элемента
    из стека. Для помещения элемента в стек можно использовать метод Add,
    когда свойство MaintainSorted равно False. }

    function PopBack: Integer;

  { Функция PeekBack возвращает значение последнего элемента списка, т.е.
    элемента с индексом (Count - 1). }

    function PeekBack: Integer;

  { Метод EnsureSorted вызывается для того, чтобы гарантировать, что элементы
    списка отсортированы по возрастанию. }

    procedure EnsureSorted;

  { Функция IndexOf возвращает индекс элемента списка со значением N или -1,
    если такой элемент в списке отсутствует. }

    function IndexOf(N: Integer): Integer;

  { Метод Remove удаляет из списка все элементы со значением N. }

    procedure Remove(N: Integer);

  { Следующий метод RemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из списка Count последовательных
    элементов, начиная с элемента с индексом Index. }

    procedure RemoveAt(Index, Count: Integer); overload;

  { Метод UnorderedRemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). Удаляемый элемент замещается последним элементом
    списка, после чего свойство Count уменьшается на 1. Метод используется
    только для списков со значением свойства MaintainSorted равным False.
    Он выполняется значительно быстрее, чем RemoveAt, но приводит к изменению
    относительного порядка элементов списка. }

    procedure UnorderedRemoveAt(Index: Integer);

  { Метод Clear очищает список путем присвоения нуля свойству Count. Память,
    занятая под внутренний массив, при этом не освобождается и значение
    свойства Capacity не меняется. }

    procedure Clear;

  { Метод TrimToSize изменяет размер внутреннего массива, адресуемого свойством
    ItemList, таким образом, чтобы он соответствовал занятому в настоящий
    момент количеству элементов. }

    procedure TrimToSize;

  { Функция Equals возвращает True, если данный список поэлементно совпадает
    со списком IntegerList. Если списки содержат различное количество элементов
    или содержат несовпадающие элементы, функция возвращает False. }

    function Equals(IntegerList: TIntegerList): Boolean;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Функция Clone возвращает экземпляр класса TIntegerList, который является
    копией данного списка. }

    function Clone: TIntegerList;

    function _Dump(): AnsiString;
//---------------------------------------------------
    property Items[Index: Integer]: Integer read Get write Put; default;
//---------------------------------------------------
  end;

  
{ Класс TWordList - упорядоченный набор значений типа Word }

  TWordList = class(TObject)
  private
    FCapacity: Integer;
    FItems: PWordItemList;
    FCount: Integer;
    FMaintainSorted: Boolean;
    FSorted: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetMaintainSorted(Value: Boolean);
  public

  { Конструктор Create создает экземпляр класса TWordList и выделяет память
    под InitialCapacity элементов во внутреннем массиве. Свойство
    MaintainSorted инициализируется значением False. }

    constructor Create(InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую экземпляром класса TWordList
    и внутренним массивом, адресуемым свойством ItemList. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает или устанавливает текущее число элементов
    в списке. При присвоении значения данному свойству никаких проверок
    не выполняется. }

    property Count: Integer read FCount write FCount;

  { Свойство ItemList возвращает указатель на внутренний массив, используемый
    для хранения элементов списка. Этот указатель меняется при изменении
    свойства Capacity. Обращение к свойству ItemList является основным методом
    доступа к элементам списка. }

    property ItemList: PWordItemList read FItems;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутреннем массиве. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство MaintainSorted возвращает или устанавливает значение, обозначающее,
    нужно ли поддерживать элементы списка в отсортированном порядке. Если это
    свойство равно True, запрещается вызывать метод Insert для добавления
    значений в список. }

    property MaintainSorted: Boolean read FMaintainSorted write SetMaintainSorted;

  { Если свойство Sorted равно True, элементы списка упорядочены по возрастанию,
    если False - элементы не упорядочены. Чтобы быть уверенным в том, что список
    отсортирован, вызовите метод EnsureSorted. }

    property Sorted: Boolean read FSorted;

  { Методы }

  { Следующий метод Load загружает список из бинарного потока Reader. }

    procedure Load(Reader: TBinaryReader); overload;

  { Следующий метод Load загружает значения из другого экземпляра списка,
    переданного параметром WordList. }

    procedure Load(WordList: TWordList); overload;

  { Следующий метод Load загружает список из массива элементов типа Word,
    адресуемого параметром Items, состоящего из Count элементов. Параметр
    Sorted определяет, является ли массив отсортированным по возрастанию. }

    procedure Load(Items: Pointer; Count: Integer; Sorted: Boolean); overload;

  { Следующий метод Load загружает список из реестра Windows. В экземпляре
    класса TRegistry, передаваемом параметром Registry, должен быть открыт
    нужный ключ в режиме, допускающем чтение. Имя значения задается параметром
    ValueName. Если параметр EncryptionKey не равен nil, предполагается, что
    данные в реестре зашифрованы и перед чтением их необходимо расшифровать
    с помощью ключа EncryptionKey. }

    procedure Load(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil); overload;

  { Следующий метод Save сохраняет список в бинарном потоке Writer. }

    procedure Save(Writer: TBinaryWriter); overload;

  { Следующий метод Save сохраняет список в реестре Windows. В экземпляре
    класса TRegistry, передаваемом параметром Registry, должен быть открыт
    нужный ключ в режиме, допускающем запись. Имя значения задается параметром
    ValueName. Если параметр EncryptionKey не равен nil, то данные перед
    сохранением шифруются с ключом EncryptionKey. Параметр CompressionMode,
    если он отличен от dcmNoCompression, определяет режим сжатия данных. }

    procedure Save(Registry: TRegistry; const ValueName: AnsiString;
      EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression); overload;

  { Метод FromBase64 загружает список из строки S, которая представляет собой
    бинарный поток данных в кодировке Base64. Если данные, помещенные в
    бинарный поток, зашифрованы, необходимо передать ключ в параметре
    EncryptionKey. }

    procedure FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest = nil);

  { Функция ToBase64 сохраняет список в бинарном потоке и преобразует его
    в строку в кодировке Base64. Полученная строка возвращается как результат
    функции. Если параметр EncryptionKey не равен nil, данные, помещенные
    в бинарный поток, шифруются с ключом EncryptionKey. Параметр
    CompressionMode, если он отличен от dcmNoCompression, определяет режим
    сжатия данных. }

    function ToBase64(EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): AnsiString;

  { Вызов метода EnsureCapacity гарантирует, что размер внутреннего массива,
    адресуемого свойством ItemList, будет достаточен для хранения Capacity
    элементов, т.е. свойство Capacity данного экземпляра класса TWordList
    будет больше или равно значению, переданному параметром Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Add добавляет значение N в список элементов. Если свойство
    MaintainSorted равно True, значение добавляется в соответствующую ему
    позицию, иначе - в конец списка. }

    procedure Add(N: Word);

  { Метод AddIfNotExists добавляет значение N в список элементов при условии,
    что в списке нет такого значения. Если свойство MaintainSorted равно True,
    значение добавляется в соответствующую ему позицию, иначе - в конец списка. }

    procedure AddIfNotExists(N: Word);

  { Следующий метод Insert вставляет элемент со значением N в позицию Index
    списка (индексация с нуля). Используется только для списков со значением
    свойства MaintainSorted равным False. }

    procedure Insert(Index: Integer; N: Word); overload;

  { Следующий метод Insert вставляет в позицию Index списка (индексация с нуля)
    массив элементов типа Word, адресуемый параметром Items, состоящий из
    Count элементов. Данный метод используется только для списков со значением
    свойства MaintainSorted равным False. }

    procedure Insert(Index: Integer; Items: Pointer; Count: Integer); overload;

  { Следующий метод Insert вставляет Count копий элемента со значением N
    в позицию Index списка (индексация с нуля). Используется только для списков
    со значением свойства MaintainSorted равным False. }

    procedure Insert(Index, Count: Integer; N: Word); overload;

  { Функция PopBack возвращает значение последнего элемента списка и уменьшает
    число элементов на единицу. Эта операция эквивалентна извлечению элемента
    из стека. Для помещения элемента в стек можно использовать метод Add,
    когда свойство MaintainSorted равно False. }

    function PopBack: Word;

  { Функция PeekBack возвращает значение последнего элемента списка, т.е.
    элемента с индексом (Count - 1). }

    function PeekBack: Word;

  { Метод EnsureSorted вызывается для того, чтобы гарантировать, что элементы
    списка отсортированы по возрастанию. }

    procedure EnsureSorted;

  { Функция IndexOf возвращает индекс элемента списка со значением N или -1,
    если такой элемент в списке отсутствует. }

    function IndexOf(N: Word): Integer;

  { Метод Remove удаляет из списка все элементы со значением N. }

    procedure Remove(N: Word);

  { Следующий метод RemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из списка Count последовательных
    элементов, начиная с элемента с индексом Index. }

    procedure RemoveAt(Index, Count: Integer); overload;

  { Метод UnorderedRemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). Удаляемый элемент замещается последним элементом
    списка, после чего свойство Count уменьшается на 1. Метод используется
    только для списков со значением свойства MaintainSorted равным False.
    Он выполняется значительно быстрее, чем RemoveAt, но приводит к изменению
    относительного порядка элементов списка. }

    procedure UnorderedRemoveAt(Index: Integer);

  { Метод Clear очищает список путем присвоения нуля свойству Count. Память,
    занятая под внутренний массив, при этом не освобождается и значение
    свойства Capacity не меняется. }

    procedure Clear;

  { Метод TrimToSize изменяет размер внутреннего массива, адресуемого свойством
    ItemList, таким образом, чтобы он соответствовал занятому в настоящий
    момент количеству элементов. }

    procedure TrimToSize;

  { Функция Equals возвращает True, если данный список поэлементно совпадает
    со списком WordList. Если списки содержат различное количество элементов
    или содержат несовпадающие элементы, функция возвращает False. }

    function Equals(WordList: TWordList): Boolean;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Функция Clone возвращает экземпляр класса TWordList, который является
    копией данного списка. }

    function Clone: TWordList;
  end;


{ Класс TArrayList - список элементов типа Pointer или TObject }

  TGroupEnumerator = class;

  TArrayList = class;

  TArrayListEnumerator = class
  private
    FIndex: Integer;
    FList: TArrayList;
  public
    constructor Create(AList: TArrayList);
    function GetCurrent: Pointer;
    function MoveNext: Boolean;
    property Current: Pointer read GetCurrent;
  end;

  TArrayList = class(TObject)
  private
    FCapacity: Integer;
    FItems: PPointerItemList;
    FCount: Integer;
    FOwnItems: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    function Get(Index: Integer): Pointer;
    procedure Put(Index: Integer; Item: Pointer);
  public

  { Конструктор Create создает экземпляр класса TArrayList и выделяет память
    под InitialCapacity элементов во внутреннем массиве. }

    constructor Create(InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TArrayList и его внутренним массивом. Если свойство OwnItems равно True,
    каждый элемент списка приводится к типу TObject и для него вызывается
    метод Free. }

    destructor Destroy; override;

    function GetEnumerator: TArrayListEnumerator;


  { Свойства }

  { Свойство Count возвращает или устанавливает текущее число элементов
    в списке. При присвоении значения данному свойству никаких проверок
    не выполняется. }

    property Count: Integer read FCount write FCount;

  { Свойство ItemList возвращает указатель на внутренний массив, используемый
    для хранения элементов списка. Этот указатель меняется при изменении
    свойства Capacity. Обращение к свойству ItemList является основным методом
    доступа к элементам списка. }

    property ItemList: PPointerItemList read FItems;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутреннем массиве. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Если свойство OwnItems равно True, при удалении элементов и полной очистке
    списка, например из деструктора класса, для каждого элемента вызывается
    метод Free, чтобы освободить память, занимаемую соответствующим объектом.
    По умолчанию это свойство равно False и метод Free не вызывается для
    элементов списка. }

    property OwnItems: Boolean read FOwnItems write FOwnItems;

  { Методы }

  { Следующий метод Load загружает элементы из другого экземпляра списка,
    переданного параметром ArrayList. Перед загрузкой данных вызывается метод
    Clear с параметром SuppressDisposingItems. }

    procedure Load(ArrayList: TArrayList;
      SuppressDisposingItems: Boolean = False); overload;

  { Следующий метод Load загружает список из массива указателей, адресуемого
    параметром Items, состоящего из Count элементов. Перед загрузкой данных
    вызывается метод Clear с параметром SuppressDisposingItems. }

    procedure Load(Items: Pointer; Count: Integer;
      SuppressDisposingItems: Boolean = False); overload;

  { Вызов метода EnsureCapacity гарантирует, что размер внутреннего массива,
    адресуемого свойством ItemList, будет достаточен для хранения Capacity
    элементов, т.е. свойство Capacity данного экземпляра класса TArrayList
    будет больше или равно значению, переданному параметром Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Add добавляет значение, переданное параметром P, в конец списка. }

    procedure Add(P: Pointer);

  { Следующий метод Insert вставляет значение, переданное параметром P,
    в позицию Index списка (индексация с нуля). }

    procedure Insert(Index: Integer; P: Pointer); overload;

  { Следующий метод Insert вставляет в позицию Index списка (индексация с нуля)
    массив из Count указателей, адресуемый параметром Items. }

    procedure Insert(Index: Integer; Items: Pointer; Count: Integer); overload;

  { Следующий метод Insert вставляет Count копий значения, переданного
    параметром P, в позицию Index списка (индексация с нуля). }

    procedure Insert(Index, Count: Integer; P: Pointer); overload;

  { Функция PopBack возвращает указатель на последний элемент списка и
    уменьшает число элементов на единицу. Эта операция подобна извлечению
    элемента из стека. Поместить элемент в стек можно методом Add. }

    function PopBack: Pointer;

  { Функция PeekBack возвращает указатель на последний элемент списка, т.е.
    элемент с индексом (Count - 1). }

    function PeekBack: Pointer;

  { Функция ScanPointer выполняет последовательный поиск элемента списка,
    указатель на который передан параметром P, и возвращает индекс найденного
    элемента. Если в списке нет элемента с таким указателем, возвращает
    значение -1. Если список большой и он отсортирован по возрастанию, лучше
    использовать функцию IndexOf, реализующую бинарный поиск. }

    function ScanPointer(P: Pointer): Integer;

  { Метод Sort сортирует элементы списка в порядке возрастания. Функция для
    сравнения элементов задается параметром CompareFunction. }

    procedure Sort(CompareFunction: TCompareFunction);

  { Метод StableSort сортирует элементы списка в порядке возрастания.
    В отличие от метода Sort, относительное расположение равных элементов
    списка не меняется, но функция сортировки использует дополнительную память.
    Функция для сравнения элементов задается параметром CompareFunction. }

    procedure StableSort(CompareFunction: TCompareFunction);

  { Функция EnumerateGroups сортирует и группирует элементы списка. Они
    сравниваются между собой с помощью функции, которая передается параметром
    CompareFunction. В группу объединяются элементы, которые равны с точки
    зрения функции CompareFunction. Если данный список уже отсортирован
    по возрастанию, в параметре Sorted следует передать значение True,
    чтобы избежать повторной сортировки. Иначе, в параметре Sorted надо
    передавать False. Функция EnumerateGroups возвращает экземпляр класса
    TGroupEnumerator, представляющий собой коллекцию групп. }

    function EnumerateGroups(CompareFunction: TCompareFunction;
      Sorted: Boolean = False): TGroupEnumerator;

  { Функция Search выполняет бинарный или линейный поиск значения Value
    в списке. Если список отсортирован по возрастанию значения искомого
    признака, в параметре Sorted следует передать значение True. В этом случае
    используется метод бинарного поиска. Если в параметр Sorted равен False,
    применяется линейный поиск. Искомое значение передается в виде указателя.
    Функция для сопоставления значения элементу списка передается параметром
    MatchFunction. В случае успеха функция Search возвращает указатель
    на искомый элемент списка, иначе возвращает nil. }

    function Search(Value: Pointer; MatchFunction: TMatchFunction;
      Sorted: Boolean = False): Pointer;

  { Функция IndexOf выполняет бинарный или линейный поиск значения Value
    в списке. Если список отсортирован по возрастанию значения искомого
    признака, в параметре Sorted следует передать значение True. В этом случае
    используется метод бинарного поиска. Если в параметр Sorted равен False,
    применяется линейный поиск. Искомое значение передается в виде указателя.
    Функция для сопоставления значения элементу списка передается параметром
    MatchFunction. В случае успеха функция IndexOf возвращает индекс искомого
    элемента списка, иначе возвращает -1. }

    function IndexOf(Value: Pointer; MatchFunction: TMatchFunction;
      Sorted: Boolean = False): Integer;

  { Следующий метод RemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). Если свойство OwnItems равно True, элемент
    приводится к типу TObject и для него вызывается метод Free. }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из списка Count последовательных
    элементов, начиная с элемента с индексом Index. Если свойство OwnItems
    равно True, каждый удаляемый элемент приводится к типу TObject и для
    него вызывается метод Free. }

    procedure RemoveAt(Index, Count: Integer); overload;


  { **** }
  
    function Remove(P: Pointer):Integer;

  { Метод UnorderedRemoveAt удаляет из списка элемент, находящийся в позиции
    Index (индексация с нуля). Удаляемый элемент замещается последним элементом
    списка, после чего свойство Count уменьшается на 1. Метод выполняется
    значительно быстрее, чем RemoveAt, но приводит к изменению относительного
    порядка элементов списка. Если свойство OwnItems равно True, удаляемый
    элемент приводится к типу TObject и для него вызывается метод Free. }

    procedure UnorderedRemoveAt(Index: Integer);

  { Метод Clear очищает список без освобождения памяти, занимаемой внутренним
    массивом. Если свойство OwnItems равно True, каждый элемент списка
    приводится к типу TObject и для него вызывается метод Free. Однако, если
    в параметре SuppressDisposingItems передано значение True, метод Free
    для элементов списка не вызывается. }

    procedure Clear(SuppressDisposingItems: Boolean = False);

  { Метод TrimToSize изменяет размер внутреннего массива, адресуемого свойством
    ItemList, таким образом, чтобы он соответствовал занятому в настоящий
    момент количеству элементов. }

    procedure TrimToSize;

  { Функция Equals возвращает True, если данный список поэлементно равен списку
    ArrayList. Если списки содержат различное число элементов или содержат
    неравные соответствующие элементы, функция возвращает False. Равенство
    элементов проверяется с помощью функции CompareFunction, а если она
    не указана, сравниваются указатели на соответствующие элементы списков. }

    function Equals(ArrayList: TArrayList;
      CompareFunction: TCompareFunction = nil): Boolean;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Функция Clone возвращает экземпляр класса TArrayList, который является
    копией данного списка. Свойство OwnItems нового списка равно False. }

    function Clone: TArrayList;

    function CopyTo(ADestination: TArrayList): TArrayList;

    property Items[Index: Integer]: Pointer read Get write Put; default;    
  end;


{ Класс TArrayReadOnlyList представляет собой список элементов типа Pointer,
  аналогичный TArrayList, но не допускающий добавления/удаления элементов. }

  TArrayReadOnlyList = class(TObject)
  private
    FItems: PPointerItemList;
    FCount: Integer;
  public

  { Конструктор Create создает экземпляр класса TArrayReadOnlyList на основе
    массива указателей, адресуемого параметром ItemList, длиной Count элементов. }

    constructor Create(ItemList: PPointerItemList; Count: Integer);

  { Свойства }

  { Свойство Count возвращает число элементов в списке. }

    property Count: Integer read FCount;

  { Свойство ItemList возвращает указатель на внутренний массив, содержащий
    элементы списка. Обращение к свойству ItemList является основным методом
    доступа к элементам списка. }

    property ItemList: PPointerItemList read FItems;

  { Методы }

  { Функция ScanPointer выполняет последовательный поиск элемента списка,
    указатель на который передан параметром P, и возвращает индекс найденного
    элемента. Если в списке нет элемента с таким указателем, возвращает
    значение -1. Если список большой и он отсортирован по возрастанию, лучше
    использовать функцию IndexOf, реализующую бинарный поиск. }

    function ScanPointer(P: Pointer): Integer;

  { Метод Sort сортирует элементы списка в порядке возрастания. Функция для
    сравнения элементов задается параметром CompareFunction. }

    procedure Sort(CompareFunction: TCompareFunction);

  { Метод StableSort сортирует элементы списка в порядке возрастания.
    В отличие от метода Sort, относительное расположение равных элементов
    списка не меняется, но функция сортировки использует дополнительную память.
    Функция для сравнения элементов задается параметром CompareFunction. }

    procedure StableSort(CompareFunction: TCompareFunction);

  { Функция EnumerateGroups сортирует и группирует элементы списка. Они
    сравниваются между собой с помощью функции, которая передается параметром
    CompareFunction. В группу объединяются элементы, которые равны с точки
    зрения функции CompareFunction. Если данный список уже отсортирован
    по возрастанию, в параметре Sorted следует передать значение True,
    чтобы избежать повторной сортировки. Иначе, в параметре Sorted надо
    передавать False. Функция EnumerateGroups возвращает экземпляр класса
    TGroupEnumerator, представляющий собой коллекцию групп. }

    function EnumerateGroups(CompareFunction: TCompareFunction;
      Sorted: Boolean = False): TGroupEnumerator;

  { Функция Search выполняет бинарный или линейный поиск значения Value
    в списке. Если список отсортирован по возрастанию значения искомого
    признака, в параметре Sorted следует передать значение True. В этом случае
    используется метод бинарного поиска. Если в параметр Sorted равен False,
    применяется линейный поиск. Искомое значение передается в виде указателя.
    Функция для сопоставления значения элементу списка передается параметром
    MatchFunction. В случае успеха функция Search возвращает указатель
    на искомый элемент списка, иначе возвращает nil. }

    function Search(Value: Pointer; MatchFunction: TMatchFunction;
      Sorted: Boolean = False): Pointer;

  { Функция IndexOf выполняет бинарный или линейный поиск значения Value
    в списке. Если список отсортирован по возрастанию значения искомого
    признака, в параметре Sorted следует передать значение True. В этом случае
    используется метод бинарного поиска. Если в параметр Sorted равен False,
    применяется линейный поиск. Искомое значение передается в виде указателя.
    Функция для сопоставления значения элементу списка передается параметром
    MatchFunction. В случае успеха функция IndexOf возвращает индекс искомого
    элемента списка, иначе возвращает -1. }

    function IndexOf(Value: Pointer; MatchFunction: TMatchFunction;
      Sorted: Boolean = False): Integer;

  { Функция Equals возвращает True, если данный список поэлементно равен списку
    ArrayList. Если списки содержат различное число элементов или содержат
    неравные соответствующие элементы, функция возвращает False. Равенство
    элементов проверяется с помощью функции CompareFunction, а если она
    не указана, сравниваются указатели на соответствующие элементы списков. }

    function Equals(ArrayList: TArrayReadOnlyList;
      CompareFunction: TCompareFunction = nil): Boolean;{$IFDEF UNICODE} reintroduce;{$ENDIF} overload;
    function Equals(ArrayList: TArrayList;
      CompareFunction: TCompareFunction = nil): Boolean;{$IFDEF UNICODE} reintroduce;{$ENDIF} overload;

  { Функция Clone возвращает экземпляр класса TArrayList, который является
    копией данного списка. Свойство OwnItems нового списка равно False. }

    function Clone: TArrayList;
  end;

  
{ Класс TGroupEnumerator - сгруппированный набор данных }

{ Тип массива и указателя на массив групп, каждая из которых представляет
  собой коллекцию типа TArrayReadOnlyList. }

  PGroupList = ^TGroupList;
  TGroupList = array[0..DWordListUpperLimit] of TArrayReadOnlyList;

  TGroupEnumerator = class(TObject)
  private
    FGroups: PGroupList;
    FGroupCount: Integer;
  public

  { Конструктор Create создает экземпляр класса TGroupEnumerator, который
    представляет собой коллекцию групп. Сортирует и группирует элементы
    массива ссылок, адресуемого параметром ItemList, состоящего из Count
    элементов. При сортировке элементы массива попарно сравниваются с помощью
    функции CompareFunction. В группу затем объединяются элементы, равные
    с точки зрения этой функции. }

    constructor Create(ItemList: PPointerItemList; Count: Integer;
      CompareFunction: TCompareFunction; Sorted: Boolean);

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TGroupEnumerator и его внутренним массивом, содержащим группы элементов.
    При этом для каждой группы (экземпляра класса TArrayReadOnlyList)
    вызывается метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство GroupCount возвращает число групп в наборе. }

    property GroupCount: Integer read FGroupCount;

  { Свойство GroupList возвращает указатель на внутренний массив, содержащий
    группы элементов. Обращение к свойству GroupList является основным методом
    доступа к группам. }

    property GroupList: PGroupList read FGroups;
  end;


{ Класс TIntegerAssociationList представляет собой ассоциативный список,
  в котором с каждым ключом типа Integer связано значение типа Pointer
  или TObject. Ключи хранятся в виде сортированного массива. }

  TIntegerAssociationList = class(TObject)
  private
    FCapacity: Integer;
    FKeys: PIntegerItemList;
    FValues: PPointerItemList;
    FCount: Integer;
    FOwnValues: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    function GetItem(Key: Integer): Pointer;
    procedure SetItem(Key: Integer; Value: Pointer);
  public

  { Конструктор Create создает экземпляр класса TIntegerAssociationList
    и выделяет память под InitialCapacity элементов во внутренних массивах
    ключей и ассоциированных с ними значений. }

    constructor Create(InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую внутренними массивами
    и самим экземпляром класса TIntegerAssociationList. Если свойство OwnValues
    равно True, деструктор приводит каждое значение в ассоциативном списке
    к типу TObject и вызывает для него метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает или устанавливает текущее число элементов
    в списке. При присвоении значения данному свойству никаких проверок
    не выполняется. }

    property Count: Integer read FCount write FCount;

  { Свойство Items считывает или устанавливает значение, ассоциированное
    с ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в список
    добавляется пара ключ-значение. Если в списке уже есть значение,
    соответствующее такому ключу, оно заменяется новым значением. При этом,
    если свойство OwnValues равно True, старое значение приводится к типу
    TObject и для него вызывается метод Free. }

    property Items[Key: Integer]: Pointer read GetItem write SetItem; default;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутренних массивах. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free для
    значений, помещенных в ассоциативный список, когда они удаляются из
    списка, заменяются новыми значениями или когда сам список выгружается
    из памяти. По умолчанию свойство OwnValues равно False и метод Free
    не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Свойство KeyList возвращает указатель на внутренний массив, используемый
    для хранения ключей. Этот указатель меняется при изменении свойства
    Capacity. }

    property KeyList: PIntegerItemList read FKeys;

  { Свойство ValueList возвращает указатель на внутренний массив значений,
    ассоциированных с ключами. Этот указатель меняется при изменении свойства
    Capacity. }

    property ValueList: PPointerItemList read FValues;

  { Методы }

  { Вызов метода EnsureCapacity гарантирует, что размер внутренних массивов,
    адресуемых свойствами KeyList и ValueList, достаточен для хранения
    Capacity элементов, т.е. свойство Capacity данного экземпляра класса
    TIntegerAssociationList будет больше или равно значению, переданному
    параметром Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Функция IndexOf возвращает индекс ключа Key во внутреннем массиве,
    адресуемом свойством KeyList. Если элемент с таким ключом отсутствует
    в списке, функция возвращает -1. }

    function IndexOf(Key: Integer): Integer;

  { Метод Add добавляет в ассоциативный список ключ Key и соответствующее
    ему значение Value. Если в списке уже есть элемент с таким ключом,
    возникает исключение. }

    procedure Add(Key: Integer; Value: Pointer);

  { Метод Remove удаляет из ассоциативного списка элемент с ключом Key,
    если такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с этим ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(Key: Integer);

  { Следующий метод RemoveAt удаляет пару ключ-значение, находящуюся в позиции
    Index внутренних массивов (индексация с нуля). Если свойство OwnValues
    равно True, удаляемое значение приводится к типу TObject и для него
    вызывается метод Free. }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из списка Count последовательных пар
    ключ-значение, начиная с позиции Index. Если свойство OwnItems равно True,
    каждое удаляемое значение приводится к типу TObject и для него вызывается
    метод Free. }

    procedure RemoveAt(Index, Count: Integer); overload;

  { Метод Clear устанавливает в ноль свойство Count. Память, занятая под
    внутренние массивы, не освобождается и значение свойства Capacity
    не меняется. Если свойство OwnValues равно True, каждое значение в
    ассоциативном списке приводится к типу TObject и для него вызывается метод
    Free. Однако, если в параметре SuppressDisposingValues передано значение
    True, метод Free для значений в ассоциативном списке не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);

  { Метод TrimToSize изменяет размер внутренних массивов, адресуемых
    свойствами KeyList и ValueList, таким образом, чтобы он соответствовал
    занятому в настоящий момент количеству элементов. }

    procedure TrimToSize;
  end;

  
{ Класс TIntegerHashtable представляет собой ассоциативный массив, где
  с каждым ключом типа Integer связано значение типа Pointer или TObject.
  Ключи являются уникальными и хранятся в виде хэшированного списка. }

  TIntegerHashtable = class(TObject)
  private
    FCapacity: Integer;
    FKeys: PIntegerItemList;
    FValues: PPointerItemList;
    FBits: PLongWordItemList;
    FCount: Integer;
    FUsedCount: Integer;
    FMaxCount: Integer;
    FOwnValues: Boolean;
    procedure SetMaxCount(NewMaxCount: Integer);
    function GetIndex(Key: Integer): Integer;
    procedure SetCapacity(NewCapacity: Integer);
    function GetItem(Key: Integer): Pointer;
    procedure SetItem(Key: Integer; Value: Pointer);
  public

  { Конструктор Create создает экземпляр класса TIntegerHashtable и выделяет
    память, достаточную для хранения InitialCapacity элементов во внутренних
    массивах ключей и ассоциированных с ними значений. }

    constructor Create(InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую внутренними массивами
    и самим экземпляром класса TIntegerHashtable. Если свойство OwnValues
    равно True, деструктор приводит каждое значение в ассоциативном списке
    к типу TObject и вызывает для него метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает текущее число элементов в ассоциативном массиве. }

    property Count: Integer read FCount;

  { Свойство Items считывает или устанавливает значение, ассоциированное с
    ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в список
    добавляется пара ключ-значение. Если в списке уже есть значение,
    соответствующее такому ключу, оно заменяется новым значением. При этом,
    если свойство OwnValues равно True, старое значение приводится к типу
    TObject и для него вызывается метод Free. }

    property Items[Key: Integer]: Pointer read GetItem write SetItem; default;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутренних массивах. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    выделение дополнительной памяти под внутренние массивы, что повлечет за
    собой перестройку хэшированного списка ключей. }

    property Capacity: Integer read FMaxCount write SetMaxCount;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений, помещенных в ассоциативный список, когда они удаляются
    из списка, заменяются новыми значениями или когда сам список выгружается
    из памяти. По умолчанию свойство OwnValues равно False и метод Free
    не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Свойство InnerKeyList возвращает указатель на внутренний массив,
    используемый для хранения ключей в виде хэшированного списка. Число
    элементов в этом массиве определяется свойством InnerCapacity. Кроме
    элементов, содержащих значения ключей, в этом списке встречаются
    неиспользуемые элементы. Признаком использования является установленный,
    т.е. единичный, бит с индексом, соответствующим элементу, в битовой строке,
    возвращаемой свойством InnerBits. }

    property InnerKeyList: PIntegerItemList read FKeys;

  { Свойство InnerValueList возвращает указатель на внутренний массив значений,
    ассоциированных с ключами. Этот указатель меняется при изменении свойства
    InnerCapacity. }

    property InnerValueList: PPointerItemList read FValues;

  { Свойство InnerBits возвращает указатель на битовую строку, используемую
    для контроля заполнения массивов InnerKeyList и InnerValueList. Бит,
    установленный в 1, обозначает, что в элементе массива InnerKeyList
    с соответствующим индексом находится значение ключа, а в элементе массива
    InnerValueList с тем же индексом - значение, ассоциированное с данным
    ключом. Если бит равен 0, соответствующие элементы массивов
    не используются. }

    property InnerBits: PLongWordItemList read FBits;

  { Свойство InnerCapacity возвращает число элементов, под которое выделена
    память в массивах InnerKeyList, InnerValueList, и число используемых бит
    в массиве InnerBits. Значение этого свойства составляет приблизительно 7/5
    от значения свойства Capacity, т.к. для эффективного выполнения поиска в
    хэшированном списке в нем должно быть заполнено не более 71-73% элементов. }

    property InnerCapacity: Integer read FCapacity;

  { Методы }

  { Вызов метода EnsureCapacity гарантирует, что размер внутренних массивов,
    достаточен для помещения в список Capacity элементов, т.е. свойство
    Capacity данного экземпляра класса TIntegerHashtable после вызова метода
    EnsureCapacity будет больше или равно значению, переданному параметром
    Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Add добавляет в ассоциативный список ключ Key и соответствующее
    ему значение Value. Если в списке уже есть элемент с таким ключом,
    возникает исключение. }

    procedure Add(Key: Integer; Value: Pointer);

  { Функция Contains возвращает True, если в хэшированном списке присутствует
    ключ со значением Key. Если ключ с таким значением отсутствует в списке,
    функция возвращает False. }

    function Contains(Key: Integer): Boolean;

  { Метод Remove удаляет из ассоциативного списка элемент с ключом Key, если
    такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с этим ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(Key: Integer);

  { Метод Clear обнуляет массив InnerBits и устанавливает в ноль свойство
    Count. Память, занятая под внутренние массивы, не освобождается и значение
    свойства Capacity не меняется. Если свойство OwnValues равно True, каждое
    значение в ассоциативном списке приводится к типу TObject и для него
    вызывается метод Free. Однако, если в параметре SuppressDisposingValues
    передано значение True, метод Free для значений в ассоциативном списке
    не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;

  
{ Класс TIntegerRedBlackTree представляет собой самобалансируемое (красно-
  черное) бинарное дерево, в узлах которого находятся ключи типа Integer и
  значения типа Pointer или TObject. }

  TIntegerRedBlackTree = class;

{ Запись TIntegerRBTreeNode содержит данные узла красно-черного дерева типа
  TIntegerRedBlackTree. При отсутствии узлов-потомков свойства Left и Right
  ссылаются не на nil, а на специальный фиктивный узел IntegerRBTreeNil. }

  PIntegerRBTreeNode = ^TIntegerRBTreeNode;
  TIntegerRBTreeNode = record
    Key: Integer;                     // Ключ для поиска и сравнения элементов
    Parent: PIntegerRBTreeNode;       // Указатель на узел-предок
    Left: PIntegerRBTreeNode;         // Указатель на узел-потомок слева
    Right: PIntegerRBTreeNode;        // Указатель на узел-потомок справа
    Value: Pointer;                   // Значение узла
    OwnerTree: TIntegerRedBlackTree;  // Ссылка на экземпляр дерева
    IsRed: Boolean;                   // Признак того, что узел красный
  end;

  TIntegerRedBlackTree = class(TObject)
  private
    FRoot: PIntegerRBTreeNode;
    FOwnValues: Boolean;
    function GetRoot: PIntegerRBTreeNode;
    procedure RotateLeft(Node: PIntegerRBTreeNode);
    procedure RotateRight(Node: PIntegerRBTreeNode);
    procedure InsertFixUp(Node: PIntegerRBTreeNode);
    procedure RemoveFixUp(Node: PIntegerRBTreeNode);
    function GetItem(Key: Integer): Pointer;
    procedure SetItem(Key: Integer; Value: Pointer);
    function GetFirstNode: PIntegerRBTreeNode;
    function GetLastNode: PIntegerRBTreeNode;
    function InsertNode(Parent: PIntegerRBTreeNode;
      Key: Integer; Value: Pointer): PIntegerRBTreeNode;
  public

  { Конструктор Create создает экземпляр класса TIntegerRedBlackTree. }

    constructor Create;

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TIntegerRedBlackTree и всеми узлами красно-черного дерева. Если свойство
    OwnValues равно True, деструктор приводит значение каждого узла к типу
    TObject и вызывает для него метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Items считывает или устанавливает значение, ассоциированное с
    ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в красно-черное
    дерево помещается новый узел с соответствующим ключом и значением. Если
    в дереве уже есть значение, соответствующее такому ключу, оно заменяется
    новым значением. При этом, если свойство OwnValues равно True, старое
    значение приводится к типу TObject и для него вызывается метод Free. }

    property Items[Key: Integer]: Pointer read GetItem write SetItem; default;

  { Свойство Root возвращает указатель на корень красно-черного дерева
    или nil, если дерево пустое. }

    property Root: PIntegerRBTreeNode read GetRoot;

  { Свойство FirstNode возвращает указатель на узел красно-черного дерева
    с наименьшим значением ключа Key или nil, если дерево пустое. }

    property FirstNode: PIntegerRBTreeNode read GetFirstNode;

  { Свойство LastNode возвращает указатель на узел красно-черного дерева
    с наибольшим значением ключа Key или nil, если дерево пустое. }

    property LastNode: PIntegerRBTreeNode read GetLastNode;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений узлов, когда они удаляются из дерева, заменяются новыми
    значениями или когда все дерево выгружается из памяти. По умолчанию
    свойство OwnValues равно False и метод Free не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Методы }

  { Функция Add помещает в красно-черное дерево новый элемент с ключом Key
    и соответствующим ему значением Value. Если в дереве уже есть элемент
    с таким ключом, возникает исключение. Функция возвращает указатель на
    добавленный узел красно-черного дерева. }

    function Add(Key: Integer; Value: Pointer): PIntegerRBTreeNode;

  { Функция SearchNode возвращает указатель на узел красно-черного дерева
    с ключом, равным Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchNode(Key: Integer): PIntegerRBTreeNode;

  { Функция SearchFirstGreater возвращает указатель на первый (по порядку
    возрастания значений ключа) узел дерева с ключом, большим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchFirstGreater(Key: Integer): PIntegerRBTreeNode;

  { Функция SearchFirstGreaterOrEqual возвращает указатель на первый
    (по порядку возрастания значений ключа) узел дерева с ключом, большим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchFirstGreaterOrEqual(Key: Integer): PIntegerRBTreeNode;

  { Функция SearchLastLesser возвращает указатель на последний (по порядку
    возрастания значений ключа) узел дерева с ключом, меньшим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchLastLesser(Key: Integer): PIntegerRBTreeNode;

  { Функция SearchLastLesserOrEqual возвращает указатель на последний
    (по порядку возрастания значений ключа) узел дерева с ключом, меньшим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchLastLesserOrEqual(Key: Integer): PIntegerRBTreeNode;

  { Функция NextNode возвращает указатель на узел красно-черного дерева,
    который следует за узлом Node в порядке увеличения значения ключа Key.
    Если Node указывает на последний узел списка, т.е. LastNode, функция
    возвращает nil. }

    function NextNode(Node: PIntegerRBTreeNode): PIntegerRBTreeNode;

  { Функция PreviousNode возвращает указатель на узел красно-черного дерева,
    который предшествует узлу Node в порядке увеличения значения ключа Key.
    Если Node указывает на первый узел списка, т.е. FirstNode, функция
    возвращает nil. }

    function PreviousNode(Node: PIntegerRBTreeNode): PIntegerRBTreeNode;

  { Метод Remove удаляет из красно-черного дерева элемент с ключом Key,
    если такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с данным ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(Key: Integer);

  { Метод RemoveNode удаляет из красно-черного дерева узел Node. Если
    свойство OwnValues дерева равно True, значение Value этого узла приводится
    к типу TObject и для него вызывается метод Free. Занимаемая узлом память
    освобождается. }

    procedure RemoveNode(Node: PIntegerRBTreeNode);

  { Метод Clear очищает красно-черное дерево, т.е. удаляет все узлы и, если
    значение свойства OwnValues равно True, приводит значение Value каждого
    узла к типу TObject и вызывает для него метод Free. Однако, если в
    параметре SuppressDisposingValues передано True, метод Free для значений
    узлов не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;


{ Класс TInt64RedBlackTree представляет собой самобалансируемое (красно-
  черное) бинарное дерево, в узлах которого находятся ключи типа Int64 и
  значения типа Pointer или TObject. }

  TInt64RedBlackTree = class;

{ Запись TInt64RBTreeNode содержит данные узла красно-черного дерева типа
  TInt64RedBlackTree. При отсутствии узлов-потомков свойства Left и Right
  ссылаются не на nil, а на специальный фиктивный узел Int64RBTreeNil. }

  PInt64RBTreeNode = ^TInt64RBTreeNode;
  TInt64RBTreeNode = record
    Key: Int64;                     // Ключ для поиска и сравнения элементов
    Parent: PInt64RBTreeNode;       // Указатель на узел-предок
    Left: PInt64RBTreeNode;         // Указатель на узел-потомок слева
    Right: PInt64RBTreeNode;        // Указатель на узел-потомок справа
    Value: Pointer;                 // Значение узла
    OwnerTree: TInt64RedBlackTree;  // Ссылка на экземпляр дерева
    IsRed: Boolean;                 // Признак того, что узел красный
  end;

  TInt64RedBlackTree = class(TObject)
  private
    FRoot: PInt64RBTreeNode;
    FOwnValues: Boolean;
    function GetRoot: PInt64RBTreeNode;
    procedure RotateLeft(Node: PInt64RBTreeNode);
    procedure RotateRight(Node: PInt64RBTreeNode);
    procedure InsertFixUp(Node: PInt64RBTreeNode);
    procedure RemoveFixUp(Node: PInt64RBTreeNode);
    function GetItem(const Key: Int64): Pointer;
    procedure SetItem(const Key: Int64; Value: Pointer);
    function GetFirstNode: PInt64RBTreeNode;
    function GetLastNode: PInt64RBTreeNode;
    function InsertNode(Parent: PInt64RBTreeNode;
      const Key: Int64; Value: Pointer): PInt64RBTreeNode;
  public

  { Конструктор Create создает экземпляр класса TInt64RedBlackTree. }

    constructor Create;

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TInt64RedBlackTree и всеми узлами красно-черного дерева. Если свойство
    OwnValues равно True, деструктор приводит значение каждого узла к типу
    TObject и вызывает для него метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Items считывает или устанавливает значение, ассоциированное с
    ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в красно-черное
    дерево помещается новый узел с соответствующим ключом и значением. Если
    в дереве уже есть значение, соответствующее такому ключу, оно заменяется
    новым значением. При этом, если свойство OwnValues равно True, старое
    значение приводится к типу TObject и для него вызывается метод Free. }

    property Items[const Key: Int64]: Pointer read GetItem write SetItem; default;

  { Свойство Root возвращает указатель на корень красно-черного дерева
    или nil, если дерево пустое. }

    property Root: PInt64RBTreeNode read GetRoot;

  { Свойство FirstNode возвращает указатель на узел красно-черного дерева
    с наименьшим значением ключа Key или nil, если дерево пустое. }

    property FirstNode: PInt64RBTreeNode read GetFirstNode;

  { Свойство LastNode возвращает указатель на узел красно-черного дерева
    с наибольшим значением ключа Key или nil, если дерево пустое. }

    property LastNode: PInt64RBTreeNode read GetLastNode;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений узлов, когда они удаляются из дерева, заменяются новыми
    значениями или когда все дерево выгружается из памяти. По умолчанию
    свойство OwnValues равно False и метод Free не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Методы }

  { Функция Add помещает в красно-черное дерево новый элемент с ключом Key
    и соответствующим ему значением Value. Если в дереве уже есть элемент
    с таким ключом, возникает исключение. Функция возвращает указатель на
    добавленный узел красно-черного дерева. }

    function Add(const Key: Int64; Value: Pointer): PInt64RBTreeNode;

  { Функция SearchNode возвращает указатель на узел красно-черного дерева
    с ключом, равным Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchNode(const Key: Int64): PInt64RBTreeNode;

  { Функция SearchFirstGreater возвращает указатель на первый (по порядку
    возрастания значений ключа) узел дерева с ключом, большим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchFirstGreater(const Key: Int64): PInt64RBTreeNode;

  { Функция SearchFirstGreaterOrEqual возвращает указатель на первый
    (по порядку возрастания значений ключа) узел дерева с ключом, большим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchFirstGreaterOrEqual(const Key: Int64): PInt64RBTreeNode;

  { Функция SearchLastLesser возвращает указатель на последний (по порядку
    возрастания значений ключа) узел дерева с ключом, меньшим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchLastLesser(const Key: Int64): PInt64RBTreeNode;

  { Функция SearchLastLesserOrEqual возвращает указатель на последний
    (по порядку возрастания значений ключа) узел дерева с ключом, меньшим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchLastLesserOrEqual(const Key: Int64): PInt64RBTreeNode;

  { Функция NextNode возвращает указатель на узел красно-черного дерева,
    который следует за узлом Node в порядке увеличения значения ключа Key.
    Если Node указывает на последний узел списка, т.е. LastNode, функция
    возвращает nil. }

    function NextNode(Node: PInt64RBTreeNode): PInt64RBTreeNode;

  { Функция PreviousNode возвращает указатель на узел красно-черного дерева,
    который предшествует узлу Node в порядке увеличения значения ключа Key.
    Если Node указывает на первый узел списка, т.е. FirstNode, функция
    возвращает nil. }

    function PreviousNode(Node: PInt64RBTreeNode): PInt64RBTreeNode;

  { Метод Remove удаляет из красно-черного дерева элемент с ключом Key,
    если такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с данным ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(const Key: Int64);

  { Метод RemoveNode удаляет из красно-черного дерева узел Node. Если
    свойство OwnValues дерева равно True, значение Value этого узла приводится
    к типу TObject и для него вызывается метод Free. Занимаемая узлом память
    освобождается. }

    procedure RemoveNode(Node: PInt64RBTreeNode);

  { Метод Clear очищает красно-черное дерево, т.е. удаляет все узлы и, если
    значение свойства OwnValues равно True, приводит значение Value каждого
    узла к типу TObject и вызывает для него метод Free. Однако, если в
    параметре SuppressDisposingValues передано True, метод Free для значений
    узлов не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;


{ Класс TStringAssociationList представляет собой ассоциативный список,
  в котором с каждым ключом типа AnsiString связано значение типа Pointer или
  TObject. Ключи хранятся в виде сортированного массива. }

  TStringAssociationList = class(TObject)
  private
    FCapacity: Integer;
    FKeys: PStringItemList;
    FValues: PPointerItemList;
    FCount: Integer;
    FCaseSensitive: Boolean;
    FOwnValues: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    function GetItem(const Key: AnsiString): Pointer;
    function SearchFirstGE(const Key: AnsiString): Integer;
    procedure SetItem(const Key: AnsiString; Value: Pointer);
    function Compare(const S1, S2: AnsiString): Integer;
  public

  { Конструктор Create создает экземпляр класса TStringAssociationList
    и выделяет память под InitialCapacity элементов во внутренних массивах
    ключей и ассоциированных с ними значений. Параметр CaseSensitive
    определяет, нужно ли учитывать регистр символов при сортировке и поиске
    ключей типа AnsiString. Если этот параметр равен False, большие и маленькие
    буквы в значении ключей не различаются, если True, они различаются }

    constructor Create(CaseSensitive: Boolean; InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую внутренними массивами и
    самим экземпляром класса TStringAssociationList. Если свойство OwnValues
    равно True, деструктор приводит каждое значение в ассоциативном списке
    к типу TObject и вызывает для него метод Free }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает или устанавливает текущее число элементов
    в списке. При присвоении значения данному свойству никаких проверок
    не выполняется. }

    property Count: Integer read FCount write FCount;

  { Свойство Items считывает или устанавливает значение, ассоциированное
    с ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в список
    добавляется пара ключ-значение. Если в списке уже есть значение,
    соответствующее такому ключу, оно заменяется новым значением. При этом,
    если свойство OwnValues равно True, старое значение приводится к типу
    TObject и для него вызывается метод Free. }

    property Items[const Key: AnsiString]: Pointer read GetItem write SetItem; default;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутренних массивах. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство CaseSensitive возвращает значение одноименного параметра,
    переданного в конструктор данного класса. Если это значение равно True,
    работа со списком ключей, т.е. сортировка и поиск, производятся с учетом
    регистра символов, если False регистр символов игнорируется в значении
    ключей. }

    property CaseSensitive: Boolean read FCaseSensitive;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений, помещенных в ассоциативный список, когда они удаляются
    из списка, заменяются новыми значениями или когда сам список выгружается
    из памяти. По умолчанию свойство OwnValues равно False и метод Free
    не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Свойство KeyList возвращает указатель на внутренний массив, используемый
    для хранения ключей. Этот указатель меняется при изменении свойства
    Capacity. }

    property KeyList: PStringItemList read FKeys;

  { Свойство ValueList возвращает указатель на внутренний массив значений,
    ассоциированных с ключами. Этот указатель меняется при изменении свойства
    Capacity. }

    property ValueList: PPointerItemList read FValues;

  { Методы }

  { Вызов метода EnsureCapacity гарантирует, что размер внутренних массивов,
    адресуемых свойствами KeyList и ValueList, достаточен для хранения
    Capacity элементов, т.е. свойство Capacity данного экземпляра класса
    TStringAssociationList будет больше или равно значению, переданному
    параметром Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Функция IndexOf возвращает индекс ключа Key во внутреннем массиве,
    адресуемом свойством KeyList. Если элемент с таким ключом отсутствует
    в списке, функция возвращает -1. }

    function IndexOf(const Key: AnsiString): Integer;

  { Метод Add добавляет в ассоциативный список ключ Key и соответствующее
    ему значение Value. Если в списке уже есть элемент с таким ключом,
    возникает исключение. }

    function Add(const Key: AnsiString; Value: Pointer): Integer;

    function AddIfNotExists(const Key: AnsiString; Value: Pointer): Integer;

  { Метод Remove удаляет из ассоциативного списка элемент с ключом Key,
    если такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с этим ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(const Key: AnsiString);

  { Следующий метод RemoveAt удаляет пару ключ-значение, находящуюся в позиции
    Index внутренних массивов (индексация с нуля). Если свойство OwnValues
    равно True, удаляемое значение приводится к типу TObject и для него
    вызывается метод Free. }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из списка Count последовательных пар
    ключ-значение, начиная с позиции Index. Если свойство OwnItems равно True,
    каждое удаляемое значение приводится к типу TObject и для него вызывается
    метод Free. }

    procedure RemoveAt(Index, Count: Integer); overload;

  { Метод Clear устанавливает в ноль свойство Count. Память, занятая под
    внутренние массивы, не освобождается и значение свойства Capacity
    не меняется. Если свойство OwnValues равно True, каждое значение в
    ассоциативном списке приводится к типу TObject и для него вызывается метод
    Free. Однако, если в параметре SuppressDisposingValues передано значение
    True, метод Free для значений в ассоциативном списке не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);

  { Метод TrimToSize изменяет размер внутренних массивов, адресуемых свойствами
    KeyList и ValueList, таким образом, чтобы он соответствовал занятому
    в настоящий момент количеству элементов. }

    procedure TrimToSize;

    function ToString: AnsiString;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}
    procedure AddList(AList: TStringAssociationList);
  end;


{ Класс TStringHashtable представляет собой ассоциативный массив, где с каждым
  ключом типа AnsiString связано значение типа Pointer или TObject. Ключи являются
  уникальными и хранятся в виде хэшированного списка. }

  TStringHashtable = class(TObject)
  private
    FCapacity: Integer;
    FKeys: PStringItemList;
    FValues: PPointerItemList;
    FCount: Integer;
    FUsedCount: Integer;
    FMaxCount: Integer;
    FCaseSensitive: Boolean;
    FOwnValues: Boolean;
    procedure SetMaxCount(NewMaxCount: Integer);
    function GetIndex(P: Pointer): Integer;
    procedure SetCapacity(NewCapacity: Integer);
    function GetItem(const Key: AnsiString): Pointer;
    procedure SetItem(const Key: AnsiString; Value: Pointer);
  public

  { Конструктор Create создает экземпляр класса TStringHashtable и выделяет
    память, достаточную для хранения InitialCapacity элементов во внутренних
    массивах ключей и ассоциированных с ними значений. Параметр CaseSensitive
    определяет, нужно ли учитывать регистр символов при сортировке и поиске
    ключей типа AnsiString. Если этот параметр равен False, большие и маленькие
    буквы в значении ключей не различаются, если True, они различаются. }

    constructor Create(CaseSensitive: Boolean; InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую внутренними массивами
    и самим экземпляром класса TStringHashtable. Если свойство OwnValues
    равно True, деструктор приводит каждое значение в ассоциативном списке
    к типу TObject и вызывает для него метод Free }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает текущее число элементов в ассоциативном массиве. }

    property Count: Integer read FCount;

  { Свойство Items считывает или устанавливает значение, ассоциированное
    с ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в список
    добавляется пара ключ-значение. Если в списке уже есть значение,
    соответствующее такому ключу, оно заменяется новым значением. При этом,
    если свойство OwnValues равно True, старое значение приводится к типу
    TObject и для него вызывается метод Free. }

    property Items[const Key: AnsiString]: Pointer read GetItem write SetItem; default;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутренних массивах. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    выделение дополнительной памяти под внутренние массивы, что повлечет за
    собой перестройку хэшированного списка ключей. }

    property Capacity: Integer read FMaxCount write SetMaxCount;

  { Свойство CaseSensitive возвращает значение одноименного параметра,
    переданного в конструктор данного класса. Если это значение равно True,
    сравнение ключей типа AnsiString выполняется с учетом регистра символов,
    если False, регистр символов игнорируется в значении ключей. }

    property CaseSensitive: Boolean read FCaseSensitive;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений, помещенных в ассоциативный список, когда они удаляются
    из списка, заменяются новыми значениями или когда сам список выгружается
    из памяти. По умолчанию свойство OwnValues равно False и метод Free
    не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Свойство InnerKeyList возвращает указатель на внутренний массив,
    используемый для хранения ключей в виде хэшированного списка. Число
    элементов в этом массиве определяется свойством InnerCapacity. Кроме
    элементов, содержащих значения ключей, в этом списке встречаются пустые
    элементы, равные nil, а также удаленные элементы. Числовое значение ключа
    удаленного элемента хэша, т.е. PLongWord(@InnerKeyList^[I])^, равно
    $FFFFFFFF. }

    property InnerKeyList: PStringItemList read FKeys;

  { Свойство InnerValueList возвращает указатель на внутренний массив значений,
    ассоциированных с ключами. Этот указатель меняется при изменении свойства
    InnerCapacity. }

    property InnerValueList: PPointerItemList read FValues;

  { Свойство InnerCapacity возвращает число элементов, под которое распределена
    память в массивах InnerKeyList и InnerValueList. Значение этого свойства
    составляет приблизительно 7/5 от значения свойства Capacity, т.к. для
    эффективного выполнения поиска в хэшированном списке в нем должно быть
    заполнено не более 71-73% элементов. }

    property InnerCapacity: Integer read FCapacity;

  { Методы }

  { Вызов метода EnsureCapacity гарантирует, что размер внутренних массивов,
    достаточен для помещения в список Capacity элементов, т.е. свойство
    Capacity данного экземпляра класса TStringHashtable после вызова метода
    EnsureCapacity будет больше или равно значению, переданному параметром
    Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Add добавляет в ассоциативный список ключ Key и соответствующее
    ему значение Value. Если в списке уже есть элемент с таким ключом,
    возникает исключение. }

    procedure Add(const Key: AnsiString; Value: Pointer);

  { Функция Contains возвращает True, если в хэшированном списке присутствует
    ключ со значением Key. Если ключ с таким значением отсутствует в списке,
    функция возвращает False. }

    function Contains(const Key: AnsiString): Boolean;

  { Метод Remove удаляет из ассоциативного списка элемент с ключом Key, если
    такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с этим ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(const Key: AnsiString);

  { Метод Clear очищает массив InnerKeyList и устанавливает в ноль свойство
    Count. Память, занятая под внутренние массивы, не освобождается и значение
    свойства Capacity не меняется. Если свойство OwnValues равно True, каждое
    значение в ассоциативном списке приводится к типу TObject и для него
    вызывается метод Free. Однако, если в параметре SuppressDisposingValues
    передано значение True, метод Free для значений в ассоциативном списке
    не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;


{ Класс TStringRedBlackTree представляет собой самобалансируемое (красно-
  черное) бинарное дерево, в узлах которого находятся ключи типа AnsiString и
  значения типа Pointer или TObject. }

  TStringRedBlackTree = class;

{ Запись TStringRBTreeNode содержит данные узла красно-черного дерева типа
  TStringRedBlackTree. При отсутствии узлов-потомков свойства Left и Right
  ссылаются не на nil, а на специальный фиктивный узел StringRBTreeNil. }

  PStringRBTreeNode = ^TStringRBTreeNode;
  TStringRBTreeNode = record
    Key: AnsiString;                     // Ключ для поиска и сравнения элементов
    Parent: PStringRBTreeNode;       // Указатель на узел-предок
    Left: PStringRBTreeNode;         // Указатель на узел-потомок слева
    Right: PStringRBTreeNode;        // Указатель на узел-потомок справа
    Value: Pointer;                  // Значение узла
    OwnerTree: TStringRedBlackTree;  // Ссылка на экземпляр дерева
    IsRed: Boolean;                  // Признак того, что узел красный
  end;

  TStringRedBlackTree = class(TObject)
  private
    FRoot: PStringRBTreeNode;
    FCaseSensitive: Boolean;
    FOwnValues: Boolean;
    function GetRoot: PStringRBTreeNode;
    procedure RotateLeft(Node: PStringRBTreeNode);
    procedure RotateRight(Node: PStringRBTreeNode);
    procedure InsertFixUp(Node: PStringRBTreeNode);
    procedure RemoveFixUp(Node: PStringRBTreeNode);
    function GetItem(const Key: AnsiString): Pointer;
    procedure SetItem(const Key: AnsiString; Value: Pointer);
    function GetFirstNode: PStringRBTreeNode;
    function GetLastNode: PStringRBTreeNode;
    function InsertNode(Parent: PStringRBTreeNode;
      const Key: AnsiString; Value: Pointer): PStringRBTreeNode;
  public

  { Конструктор Create создает экземпляр класса TStringRedBlackTree.
    Параметр CaseSensitive определяет, нужно ли учитывать регистр символов
    при сравнении ключей типа AnsiString. Если этот параметр равен False,
    большие и маленькие буквы в значении ключей не различаются, иначе
    различаются. }

    constructor Create(CaseSensitive: Boolean = False);

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TStringRedBlackTree и всеми узлами красно-черного дерева. Если свойство
    OwnValues равно True, деструктор приводит значение каждого узла к типу
    TObject и вызывает для него метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Items считывает или устанавливает значение, ассоциированное с
    ключом Key. При чтении, если такой ключ отсутствует в списке, свойство
    возвращает nil. При записи, если такой ключ отсутствует, в красно-черное
    дерево помещается новый узел с соответствующим ключом и значением. Если
    в дереве уже есть значение, соответствующее такому ключу, оно заменяется
    новым значением. При этом, если свойство OwnValues равно True, старое
    значение приводится к типу TObject и для него вызывается метод Free. }

    property Items[const Key: AnsiString]: Pointer read GetItem write SetItem; default;

  { Свойство Root возвращает указатель на корень красно-черного дерева
    или nil, если дерево пустое. }

    property Root: PStringRBTreeNode read GetRoot;

  { Свойство FirstNode возвращает указатель на узел красно-черного дерева
    с наименьшим значением ключа Key или nil, если дерево пустое. }

    property FirstNode: PStringRBTreeNode read GetFirstNode;

  { Свойство LastNode возвращает указатель на узел красно-черного дерева
    с наибольшим значением ключа Key или nil, если дерево пустое. }

    property LastNode: PStringRBTreeNode read GetLastNode;

  { Свойство CaseSensitive возвращает значение одноименного параметра,
    переданного в конструктор данного класса. Если это значение равно True,
    сравнение ключей типа AnsiString выполняется с учетом регистра символов,
    если False, регистр символов игнорируется в значении ключей. }

    property CaseSensitive: Boolean read FCaseSensitive;

  { Значение свойства OwnValues определяет, нужно ли вызывать метод Free
    для значений узлов, когда они удаляются из дерева, заменяются новыми
    значениями или когда все дерево выгружается из памяти. По умолчанию
    свойство OwnValues равно False и метод Free не вызывается. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Методы }

  { Функция Add помещает в красно-черное дерево новый элемент с ключом Key
    и соответствующим ему значением Value. Если в дереве уже есть элемент
    с таким ключом, возникает исключение. Функция возвращает указатель на
    добавленный узел красно-черного дерева. }

    function Add(const Key: AnsiString; Value: Pointer): PStringRBTreeNode;

  { Функция SearchNode возвращает указатель на узел красно-черного дерева
    с ключом, равным Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchNode(const Key: AnsiString): PStringRBTreeNode;

  { Функция SearchFirstGreater возвращает указатель на первый (по порядку
    возрастания значений ключа) узел дерева с ключом, большим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchFirstGreater(const Key: AnsiString): PStringRBTreeNode;

  { Функция SearchFirstGreaterOrEqual возвращает указатель на первый
    (по порядку возрастания значений ключа) узел дерева с ключом, большим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchFirstGreaterOrEqual(const Key: AnsiString): PStringRBTreeNode;

  { Функция SearchLastLesser возвращает указатель на последний (по порядку
    возрастания значений ключа) узел дерева с ключом, меньшим значения Key.
    Если узел с таким значением ключа отсутствует, функция возвращает nil. }

    function SearchLastLesser(const Key: AnsiString): PStringRBTreeNode;

  { Функция SearchLastLesserOrEqual возвращает указатель на последний
    (по порядку возрастания значений ключа) узел дерева с ключом, меньшим
    или равным значению Key. Если узел с таким значением ключа отсутствует,
    функция возвращает nil. }

    function SearchLastLesserOrEqual(const Key: AnsiString): PStringRBTreeNode;

  { Функция NextNode возвращает указатель на узел красно-черного дерева,
    который следует за узлом Node в порядке увеличения значения ключа Key.
    Если Node указывает на последний узел списка, т.е. LastNode, функция
    возвращает nil. }

    function NextNode(Node: PStringRBTreeNode): PStringRBTreeNode;

  { Функция PreviousNode возвращает указатель на узел красно-черного дерева,
    который предшествует узлу Node в порядке увеличения значения ключа Key.
    Если Node указывает на первый узел списка, т.е. FirstNode, функция
    возвращает nil. }

    function PreviousNode(Node: PStringRBTreeNode): PStringRBTreeNode;

  { Метод Remove удаляет из красно-черного дерева элемент с ключом Key,
    если такой элемент имеется. Если свойство OwnValues равно True, значение,
    ассоциированное с данным ключом, приводится к типу TObject и для него
    вызывается метод Free. }

    procedure Remove(const Key: AnsiString);

  { Метод RemoveNode удаляет из красно-черного дерева узел Node. Если
    свойство OwnValues дерева равно True, значение Value этого узла приводится
    к типу TObject и для него вызывается метод Free. Занимаемая узлом память
    освобождается. }

    procedure RemoveNode(Node: PStringRBTreeNode);

  { Метод Clear очищает красно-черное дерево, т.е. удаляет все узлы и, если
    значение свойства OwnValues равно True, приводит значение Value каждого
    узла к типу TObject и вызывает для него метод Free. Однако, если в
    параметре SuppressDisposingValues передано True, метод Free для значений
    узлов не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;


{ Класс TLinkedList реализует связанный список узлов со значениями типа
  Pointer или TObject. Удобен для последовательного перебора элементов,
  вставки и удаления элементов в произвольном месте списка. }

  TLinkedList = class;

{ Запись TLinkedListNode содержит данные элемента, т.е. узла, связанного
  списка типа TLinkedList. Поля записи: Value - указатель на объект,
  представляющий значение элемента связанного списка; OwnerList - cсылка
  на экземляр связанного списка, т.е. класса TLinkedList, к которому
  относится данный узел; NextNode - указатель на следующий узел связанного
  списка (nil для последнего элемента списка); PrevNode - указатель на
  предыдущий узел связанного списка (nil для первого элемента списка). }

  PLinkedListNode = ^TLinkedListNode;
  TLinkedListNode = record
    Value: Pointer;
    OwnerList: TLinkedList;
    NextNode: PLinkedListNode;
    PrevNode: PLinkedListNode;
  end;

  TLinkedList = class(TObject)
  private
    FHeadNode: PLinkedListNode;
    FTailNode: PLinkedListNode;
    FOwnValues: Boolean;

    procedure SwitchOwner(FirstNode, LastNode: PLinkedListNode);
  public

  { Деструктор Destroy освобождает память, занятую каждым узлом типа
    TLinkedListNode в составе связанного списка и самим экземпляром класса
    TLinkedList. При этом, если свойство OwnValues равно True, значение
    каждого узла связанного списка приводится к типу TObject и для него
    вызывается метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство HeadNode возвращает ссылку на первый элемент, т.е. узел,
    связанного списка. Если список пуст, значение этого свойства равно nil. }

    property HeadNode: PLinkedListNode read FHeadNode;

  { Свойство TailNode возвращает ссылку на последний элемент, т.е. узел,
    связанного списка. Если список пуст, значение этого свойства равно nil. }

    property TailNode: PLinkedListNode read FTailNode;

  { Если свойство OwnValues равно True, при удалении узлов и полной очистке
    списка, например из деструктора класса, значение каждого узла приводится
    к типу TObject и для него вызывается метод Free, чтобы освободить память,
    занимаемую соответствующим объектом. По умолчанию это свойство равно False
    и метод Free не вызывается для значений узлов связанного списка. }

    property OwnValues: Boolean read FOwnValues write FOwnValues;

  { Методы }

  { Функция AddHead вставляет новый узел со значением Value в начало связанного
    списка и возвращает указатель на этот узел как результат функции. }

    function AddHead(Value: Pointer): PLinkedListNode; overload;

  { Метод AddHead добавляет последовательность узлов, начиная с FirstNode
    и заканчивая LastNode, в начало данного связанного списка. Узлы могут
    принадлежать другому или тому же списку. При этом в исходной позиции
    элементы связанного списка удаляются. }

    procedure AddHead(FirstNode, LastNode: PLinkedListNode); overload;

  { Функция AddTail добавляет новый узел со значением Value в конец связанного
    списка и возвращает указатель на этот узел как результат функции. }

    function AddTail(Value: Pointer): PLinkedListNode; overload;

  { Метод AddTail добавляет последовательность узлов, начиная с FirstNode
    и заканчивая LastNode, в конец данного связанного списка. Узлы могут
    принадлежать другому или тому же списку. При этом в исходной позиции
    элементы связанного списка удаляются. }

    procedure AddTail(FirstNode, LastNode: PLinkedListNode); overload;

  { Функция InsertBefore вставляет новый узел со значением Value перед узлом
    Node связанного списка и возвращает указатель на добавленный узел как
    результат функции. Если узел Node не принадлежит данному списку, возникает
    исключение. }

    function InsertBefore(Node: PLinkedListNode; Value: Pointer): PLinkedListNode; overload;

  { Метод InsertBefore вставляет последовательность узлов, начиная с FirstNode
    и заканчивая LastNode, перед узлом Node данного связанного списка. Узлы
    могут принадлежать другому или тому же списку. При этом в исходной позиции
    элементы связанного списка удаляются. }

    procedure InsertBefore(Node, FirstNode, LastNode: PLinkedListNode); overload;

  { Функция InsertAfter вставляет новый узел со значением Value после узла
    Node связанного списка и возвращает указатель на добавленный узел как
    результат функции. Если узел Node не принадлежит данному списку, возникает
    исключение. }

    function InsertAfter(Node: PLinkedListNode; Value: Pointer): PLinkedListNode; overload;

  { Метод InsertAfter вставляет последовательность узлов, начиная с FirstNode
    и заканчивая LastNode, после узла Node данного связанного списка. Узлы
    могут принадлежать другому или тому же списку. При этом в исходной позиции
    элементы связанного списка удаляются. }

    procedure InsertAfter(Node, FirstNode, LastNode: PLinkedListNode); overload;

  { Функция IsEmpty возвращает True, если связанный список пустой. Если
    в списке присутствует хотя бы один элемент, функция возвращает False. }

    function IsEmpty: Boolean;

  { Функция PopHeadValue возвращает значение первого элемента списка, а затем
    удаляет соответствующий узел из связанного списка. }

    function PopHeadValue: Pointer;

  { Функция PopTailValue возвращает значение последнего узла списка, а затем
    удаляет сам узел из связанного списка. }

    function PopTailValue: Pointer;

  { Функция PopValue возвращает значение узла Node списка, а затем удаляет
    сам узел из связанного списка. }

    function PopValue(Node: PLinkedListNode): Pointer;

  { Метод RemoveHead удаляет из связанного списка первый элемент. Если свойство
    OwnValues равно True, значение удаляемого узла приводится к типу TObject и
    для него вызывается метод Free. }

    procedure RemoveHead;

  { Метод RemoveTail удаляет из связанного списка последний элемент. Если
    свойство OwnValues равно True, значение удаляемого узла приводится к типу
    TObject и для него вызывается метод Free. }

    procedure RemoveTail;

  { Следующий метод Remove удаляет из связанного списка узел Node. Если
    свойство OwnValues равно True, значение этого узла приводится к типу
    TObject и для него вызывается метод Free. }

    procedure Remove(Node: PLinkedListNode); overload;

  { Следующий метод Remove удаляет из связанного списка последовательность
    узлов, начиная с FirstNode и заканчивая LastNode. Если свойство OwnValues
    равно True, значение каждого удаляемого узла приводится к типу TObject и
    для него вызывается метод Free. }

    procedure Remove(FirstNode, LastNode: PLinkedListNode); overload;

  { Метод Clear удаляет все элементы из связанного списка. Если свойство
    OwnValues равно True, значение каждого узла приводится к типу TObject
    и для него вызывается метод Free. Однако, если в параметре
    SuppressDisposingValues передано True, метод Free для значений
    узлов не вызывается. }

    procedure Clear(SuppressDisposingValues: Boolean = False);
  end;

  
{ Класс TDoubleEndedQueue - двухсторонняя очередь указателей }

  TDoubleEndedQueue = class(TObject)
  private
    FChunkListOffset: Integer;
    FChunkList: PPointerItemList;
    FChunkListCapacity: Integer;
    FChunkCount: Integer;
    FStart: Integer;
    FCount: Integer;
    FOwnItems: Boolean;
    procedure UpdateChunkCount(NewCount: Integer);
    function GetItem(Index: Integer): Pointer;
    procedure SetItem(Index: Integer; P: Pointer);
    procedure GrowFront;
    procedure GrowBack;
  public

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TDoubleEndedQueue и его внутренними массивами. Кроме того, если свойство
    OwnItems равно True, каждый элемент очереди приводится к типу TObject и
    для него вызывается метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает текущее число элементов в очереди. }
  
    property Count: Integer read FCount;

  { Свойство Items считывает или устанавливает элемент очереди с индексом
    Index (индексация с нуля). Если изменяемый элемент очереди содержит
    значение, отличное (по указателю) от нового значения, и если при этом
    свойство OwnValues равно True, старое значение приводится к типу TObject
    и для него вызывается метод Free. }

    property Items[Index: Integer]: Pointer read GetItem write SetItem; default;

  { Если свойство OwnItems равно True, при удалении элементов и полной очистке
    очереди, например из деструктора класса, для каждого элемента вызывается
    метод Free, чтобы освободить память, занимаемую соответствующим объектом.
    По умолчанию это свойство равно False и метод Free не вызывается для
    элементов очереди. }

    property OwnItems: Boolean read FOwnItems write FOwnItems;

  { Методы }

  { Следующий метод Load загружает элементы из другого экземпляра двухсторонней
    очереди, переданного параметром DoubleEndedQueue. Перед загрузкой данных
    вызывается метод Clear с параметром SuppressDisposingItems. }

    procedure Load(DoubleEndedQueue: TDoubleEndedQueue;
      SuppressDisposingItems: Boolean = False); overload;

  { Следующий метод Load загружает элементы очереди из массива указателей,
    адресуемого параметром Items, состоящего из Count элементов. Перед
    загрузкой вызывается метод Clear с параметром SuppressDisposingItems. }

    procedure Load(Items: Pointer; Count: Integer;
      SuppressDisposingItems: Boolean = False); overload;

  { Метод Save переписывает элементы очереди в массив, адресуемый параметром
    Items. Размер массива должен быть достаточен для хранения указателей в
    количестве, не меньшем, чем значение свойства Count. Функция возвращает
    число указателей, сохраненных в массиве Items. }

    function Save(Items: Pointer): Integer;

  { Функция IsEmpty возвращает True, если двухсторонняя очередь пустая.
    Если в очереди есть хотя бы один элемент, функция возвращает False. }

    function IsEmpty: Boolean;

  { Метод PushFront добавляет значение, переданное параметром P, в начало
    очереди. }

    procedure PushFront(P: Pointer);

  { Метод PushBack добавляет значение, переданное параметром P, в конец
    очереди. }

    procedure PushBack(P: Pointer);

  { Функция PopFront возвращает указатель на первый элемент очереди и
    одновременно удаляет этот элемент из очереди. }

    function PopFront: Pointer;

  { Функция PopBack возвращает указатель на первый элемент очереди и
    одновременно удаляет этот элемент из очереди. }

    function PopBack: Pointer;

  { Функция PeekFront возвращает указатель на первый элемент очереди. }

    function PeekFront: Pointer;

  { Функция PeekBack возвращает указатель на первый элемент очереди. }

    function PeekBack: Pointer;

  { Следующий метод Insert вставляет значение, переданное параметром P,
    в позицию Index очереди (индексация с нуля). }

    procedure Insert(Index: Integer; P: Pointer); overload;

  { Следующий метод Insert вставляет в позицию Index очереди (индексация
    с нуля) массив из Count указателей, адресуемый параметром Items. }

    procedure Insert(Index: Integer; Items: Pointer; Count: Integer); overload;

  { Следующий метод Insert вставляет Count копий значения, переданного
    параметром P, в позицию Index очереди (индексация с нуля). }

    procedure Insert(Index, Count: Integer; P: Pointer); overload;

  { Функция ScanPointer выполняет линейных поиск элемента, указатель на
    который передан параметром P, и возвращает индекс найденного элемента.
    Если в очереди нет такого элемента, возвращает значение -1. }

    function ScanPointer(P: Pointer): Integer;

  { Функция Search выполняет линейный поиск значения Value среди элементов
    двухсторонней очереди. Функция для сопоставления значения элементу очереди
    передается параметром MatchFunction. В случае успеха функция Search
    возвращает указатель на искомый элемент очереди, иначе возвращает nil. }

    function Search(Value: Pointer; MatchFunction: TMatchFunction): Pointer;

  { Функция IndexOf выполняет линейный поиск значения Value среди элементов
    двухсторонней очереди. Функция для сопоставления значения элементу очереди
    передается параметром MatchFunction. В случае успеха функция IndexOf
    возвращает индекс искомого элемента очереди, иначе возвращает -1. }

    function IndexOf(Value: Pointer; MatchFunction: TMatchFunction): Integer;

  { Метод Swap меняет местами Count элементов очереди, начиная с индексов
    Index1 и Index2 (индексация с нуля). }

    procedure Swap(Index1, Index2: Integer; Count: Integer = 1);

  { Метод Reverse обращает порядок следования Count элементов очереди, начиная
    с элемента с индексом Index (индексация с нуля). }

    procedure Reverse(Index, Count: Integer);

  { Метод Rotate выполняет циклический сдвиг Count элементов очереди, начиная
    с индекса FirstIndex, таким образом, чтобы на место элемента с индексом
    FirstIndex встал элемент с индексом MiddleIndex (индексация с нуля). }

    procedure Rotate(FirstIndex, MiddleIndex, Count: Integer);

  { Метод RandomShuffle перемешивает случайным образом Count элементов
    очереди, начиная с индекса Index (индексация с нуля). Дескриптор
    генератора псевдослучайных чисел передается параметром H. Если в этом
    параметре передано значение nil, процедура использует собственный экземпляр
    генератора, инициализируемый значением по умолчанию, который уничтожается
    при выходе из процедуры. }

    procedure RandomShuffle(Index, Count: Integer; H: HMT = nil);

  { Метод RemoveFront удаляет первый элемент из очереди. Если свойство
    OwnItems равно True, этот элемент приводится к типу TObject и
    для него вызывается метод Free. }

    procedure RemoveFront;

  { Метод RemoveBack удаляет последний элемент из очереди. Если свойство
    OwnItems равно True, этот элемент приводится к типу TObject и
    для него вызывается метод Free. }

    procedure RemoveBack;

  { Следующий метод RemoveAt удаляет из очереди элемент, находящийся в позиции
    Index (индексация с нуля). Если свойство OwnItems равно True, элемент
    приводится к типу TObject и для него вызывается метод Free. }

    procedure RemoveAt(Index: Integer); overload;

  { Следующий метод RemoveAt удаляет из очереди Count последовательных
    элементов, начиная с элемента с индексом Index. Если свойство OwnItems
    равно True, каждый удаляемый элемент приводится к типу TObject и для
    него вызывается метод Free. }

    procedure RemoveAt(Index, Count: Integer); overload;

  { Метод Clear очищает двухстороннюю очередь и освобождает память, занимаемую
    внутренними массивами второго уровня, т.е. подсписками элементов. Если
    свойство OwnItems равно True, каждый элемент очереди приводится к типу
    TObject и для него вызывается метод Free. Однако, если в параметре
    SuppressDisposingItems передано значение True, метод Free для элементов
    очереди не вызывается. }

    procedure Clear(SuppressDisposingItems: Boolean = False);

  { Функция Equals возвращает True, если данная очередь поэлементно
    совпадает с очередью DoubleEndedQueue. Если очереди содержат различное
    число элементов или содержат неравные соответствующие элементы, функция
    возвращает False. Равенство элементов проверяется с помощью функции
    CompareFunction, а если она не указана, сравниваются указатели на
    соответствующие элементы очередей. }

    function Equals(DoubleEndedQueue: TDoubleEndedQueue;
      CompareFunction: TCompareFunction = nil): Boolean; {$IFDEF UNICODE}reintroduce; overload;{$ENDIF}

  { Функция Clone возвращает экземпляр класса TDoubleEndedQueue, который
    является поэлементной копией данной очереди. Свойство OwnItems новой
    очереди равно False. }

    function Clone: TDoubleEndedQueue;
  end;


{ Класс TPriorityQueue - приоритетная очередь указателей }

  TPriorityQueue = class(TObject)
  private
    FCapacity: Integer;
    FItems: PPointerItemList;
    FCount: Integer;
    FCompareFunction: TCompareFunction;
    FOwnItems: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCompareFunction(CompareFunction: TCompareFunction);
  public

  { Конструктор Create создает экземпляр класса TPriorityQueue и выделяет
    память под InitialCapacity элементов во внутреннем массиве. Функция
    для сравнения элементов передается параметром CompareFunction. }

    constructor Create(CompareFunction: TCompareFunction; InitialCapacity: Integer = 0);

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TPriorityQueue и его внутренним массивом. Если свойство OwnItems равно
    True, каждый элемент очереди приводится к типу TObject и для него
    вызывается метод Free. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Count возвращает текущее число элементов в очереди. }

    property Count: Integer read FCount;

  { Свойство ItemList возвращает указатель на внутренний массив, используемый
    для хранения элементов очереди. Этот указатель меняется при изменении
    свойства Capacity. }

    property ItemList: PPointerItemList read FItems;

  { Свойство Capacity считывает или изменяет количество элементов, под которое
    распределена память во внутреннем массиве. Если при добавлении нового
    элемента фактическое число элементов превысит Capacity, произойдет
    перераспределение памяти и свойство Capacity увеличится до значения,
    рассчитанного вызовом G_EnlargeCapacity(Capacity). }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство CompareFunction возвращает адрес функции, используемой для
    сравнения элементов приоритетной очереди. }

    property CompareFunction: TCompareFunction read FCompareFunction write SetCompareFunction;

  { Если свойство OwnItems равно True, при удалении элементов и полной очистке
    очереди, например из деструктора класса, для каждого элемента вызывается
    метод Free, чтобы освободить память, занимаемую соответствующим объектом.
    По умолчанию это свойство равно False и метод Free не вызывается для
    элементов очереди. }

    property OwnItems: Boolean read FOwnItems write FOwnItems;

  { Методы }

  { Следующий метод Load загружает элементы из другого экземпляра приоритетной
    очереди, переданного параметром PriorityQueue. Перед загрузкой данных
    вызывается метод Clear с параметром SuppressDisposingItems. }

    procedure Load(PriorityQueue: TPriorityQueue;
      SuppressDisposingItems: Boolean = False); overload;

  { Следующий метод Load загружает элементы очереди из массива указателей,
    адресуемого параметром Items, состоящего из Count элементов. Перед
    загрузкой вызывается метод Clear с параметром SuppressDisposingItems. }

    procedure Load(Items: Pointer; Count: Integer;
      SuppressDisposingItems: Boolean = False); overload;

  { Вызов метода EnsureCapacity гарантирует, что размер внутреннего массива,
    адресуемого свойством ItemList, будет достаточен для хранения Capacity
    элементов, т.е. свойство Capacity данного экземпляра класса TPriorityQueue
    будет больше или равно значению, переданному параметром Capacity. }

    procedure EnsureCapacity(Capacity: Integer);

  { Функция IsEmpty возвращает True, если приоритетная очередь пустая.
    Если в очереди есть хотя бы один элемент, функция возвращает False. }

    function IsEmpty: Boolean;

  { Метод Push добавляет значение, переданное параметром P, в приоритетную
    очередь. Функция возвращает индекс элемента внутреннего массива ItemList,
    в который помещено добавленное значение. }

    function Push(P: Pointer): Integer;

  { Функция Pop возвращает указатель на первый, т.е. максимальный, элемент
    очереди и удаляет этот элемент из приоритетной очереди. }

    function Pop: Pointer;

  { Функция Peek возвращает указатель на первый, т.е. максимальный, элемент
    приоритетной очереди. }

    function Peek: Pointer;

  { Функция ScanPointer выполняет линейных поиск элемента, указатель на
    который передан параметром P, и возвращает индекс найденного элемента.
    Если в очереди нет такого элемента, возвращает значение -1. }

    function ScanPointer(P: Pointer): Integer;

  { Функция Search выполняет линейный поиск значения Value среди элементов
    приоритетной очереди. Функция для сопоставления значения элементу очереди
    передается параметром MatchFunction. В случае успеха функция Search
    возвращает указатель на искомый элемент очереди, иначе возвращает nil. }

    function Search(Value: Pointer; MatchFunction: TMatchFunction): Pointer;

  { Функция IndexOf выполняет линейный поиск значения Value среди элементов
    приоритетной очереди. Функция для сопоставления значения элементу очереди
    передается параметром MatchFunction. В случае успеха функция IndexOf
    возвращает индекс искомого элемента очереди, иначе возвращает -1. }

    function IndexOf(Value: Pointer; MatchFunction: TMatchFunction): Integer;

  { Метод RemoveAt удаляет из очереди элемент, находящийся в позиции Index
    внутреннего массива ItemList (индексация с нуля). Если свойство OwnItems
    равно True, перед удалением элемент приводится к типу TObject и для него
    вызывается метод Free. }

    procedure RemoveAt(Index: Integer);

  { Метод Clear очищает очередь без освобождения памяти, занимаемой внутренним
    массивом. Если свойство OwnItems равно True, каждый элемент очереди
    приводится к типу TObject и для него вызывается метод Free. Однако, если
    в параметре SuppressDisposingItems передано значение True, метод Free
    для элементов очереди не вызывается. }

    procedure Clear(SuppressDisposingItems: Boolean = False);

  { Метод TrimToSize изменяет размер внутреннего массива, адресуемого свойством
    ItemList, таким образом, чтобы он соответствовал занятому в настоящий
    момент количеству элементов. }

    procedure TrimToSize;

  { Функция Equals возвращает True, если все элементы данной очереди равны
    соответствующим элементам очереди PriorityQueue. Если очереди содержат
    различное число элементов или содержат несовпадающие (неравные) элементы,
    функция возвращает False. При передаче False в параметре CompareValues
    элементы очередей сравниваются по ссылке, т.е. два элемента считаются
    равными, если равны соответствующие им указатели. При передаче True в
    параметре CompareValues элементы очередей сравниваются по значению, т.е.
    с помощью функции CompareFunction данной приоритетной очереди. }

    function Equals(PriorityQueue: TPriorityQueue;
      CompareValues: Boolean = False): Boolean; reintroduce; overload;

  { Функция Clone возвращает экземпляр класса TPriorityQueue, который является
    копией данной очереди. Свойство OwnItems новой очереди равно False. }

    function Clone: TPriorityQueue;
  end;


{ Специальные константы, используемые хэшами и бинарными деревьями }

{ Значения ключей для удаленных и пустых значений хэшированных списков
  TIntegerHashtable и TStringHashtable. }

const
  MissingIntegerHashKey  = Integer($81000000);
  EmptyIntegerHashKey    = Integer($81000001);
  MissingStringHashKey   = Pointer($FFFFFFFF);

{ Переменные, содержащие ссылки на фиктивный узел красно-черного дерева типа
  TIntegerRedBlackTree, TStringRedBlackTree или TInt64RedBlackTree. Значения
  этих ссылок и адресуемых ими записей не должны меняться. }

var
  StringRBTreeNil: PStringRBTreeNode;
  IntegerRBTreeNil: PIntegerRBTreeNode;
  Int64RBTreeNil: PInt64RBTreeNode;

implementation

uses Windows, AcedCommon, AcedStrings;

{ TBitList }

constructor TBitList.Create(Count: Integer; InitValue: Boolean);
begin
  FCapacity := (Count + 31) shr 5;
  if FCapacity > 0 then
  begin
    GetMem(FBits, FCapacity * SizeOf(LongWord));
    if not InitValue then
      G_FillLongs(0, FBits, FCapacity)
    else
      G_FillLongs($FFFFFFFF, FBits, FCapacity);
  end;
  FCount := Count;
end;

destructor TBitList.Destroy;
begin
  if FCapacity > 0 then
    FreeMem(FBits);
end;

procedure TBitList.IntSetCount(NewCount: Integer);
var
  NewCapacity: Integer;
begin
  NewCapacity := (NewCount + 31) shr 5;
  if NewCapacity <> FCapacity then
  begin
    if FCapacity > 0 then
      FreeMem(FBits);
    if NewCapacity > 0 then
      GetMem(FBits, NewCapacity * SizeOf(LongWord))
    else
      FBits := nil;
    FCapacity := NewCapacity;
  end;
  FCount := NewCount;
end;

function TBitList.IntGetBit(Index: Integer): Boolean;
asm
        MOV     EAX,[EAX].TBitList.FBits
        BT      [EAX],EDX
        SETC    AL
end;

procedure TBitList.IntSetBit(Index: Integer; Value: Boolean);
asm
        MOV     EAX,[EAX].TBitList.FBits
        TEST    CL,CL
        JE      @@fl
        BTS     [EAX],EDX
        RET
@@fl:   BTR     [EAX],EDX
end;

procedure TBitList.SetCount(NewCount: Integer);
var
  NewBits: PLongWordItemList;
  NewCapacity, C: Integer;
begin
  NewCapacity := (NewCount + 31) shr 5;
  if NewCapacity <> FCapacity then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewBits, NewCapacity * SizeOf(LongWord));
      C := 0;
      if FCount > 0 then
      begin
        if FCount > NewCount then
          FCount := NewCount;
        C := (FCount + 31) shr 5;
        G_CopyLongs(FBits, NewBits, C);
      end;
      G_FillLongs(0, @NewBits^[C], NewCapacity - C);
    end else
      NewBits := nil;
    if FCapacity > 0 then
      FreeMem(FBits);
    FCapacity := NewCapacity;
    FBits := NewBits;
  end;
  FCount := NewCount;
end;

procedure TBitList.Load(Reader: TBinaryReader);
var
  C: Integer;
begin
  C := Reader.ReadWord;
  if C = $FFFF then
    C := Reader.ReadInteger;
  IntSetCount(C);
  if C > 0 then
    Reader.Read(FBits, (C + 7) shr 3);
end;

procedure TBitList.Load(BitList: TBitList);
begin
  IntSetCount(BitList.FCount);
  G_CopyLongs(BitList.FBits, FBits, FCapacity);
end;

procedure TBitList.Load(Bits: Pointer; Count: Integer);
begin
  IntSetCount(Count);
  G_CopyLongs(Bits, FBits, FCapacity);
end;

procedure TBitList.Load(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := Registry.GetDataSize(string(ValueName));
  if L > 0 then
  begin
    GetMem(P, L);
    Registry.ReadBinaryData(string(ValueName), P^, L);
    BR := TBinaryReader.Create;
    BR.LoadFromArray(P, L, True, EncryptionKey);
    Load(BR);
    BR.Free;
  end else
    IntSetCount(0);
end;

procedure TBitList.Save(Writer: TBinaryWriter);
var
  C: Integer;
begin
  C := FCount;
  if C < $FFFF then
    Writer.WriteWord(Word(C))
  else
  begin
    Writer.WriteWord($FFFF);
    Writer.WriteInteger(C);
  end;
  if C > 0 then
    Writer.Write(FBits, (C + 7) shr 3);
end;

procedure TBitList.Save(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest; CompressionMode: TCompressionMode);
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create((FCount + 7) shr 3 + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Registry.WriteBinaryData(string(ValueName), P^, L);
  FreeMem(P);
end;

procedure TBitList.FromString(const S: AnsiString);
var
  L, I: Integer;
  P: PChars;
begin
  L := Length(S);
  IntSetCount(L);
  P := PChars(S);
  I := 0;
  while I < L do
  begin
    if P^[I] = '1' then
      SetBit(I)
    else
      ResetBit(I);
    Inc(I);
  end;
end;

function TBitList.ToString: AnsiString;
var
  I: Integer;
  P: PChars;
begin
  SetString(Result, nil, FCount);
  P := PChars(Result);
  I := 0;
  while I < FCount do
  begin
    if IntGetBit(I) then
      P^[I] := '1'
    else
      P^[I] := '0';
    Inc(I);
  end;
end;

procedure TBitList.FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := G_Base64Decode(S, nil);
  GetMem(P, L);
  G_Base64Decode(S, P);
  BR := TBinaryReader.Create;
  BR.LoadFromArray(P, L, True, EncryptionKey);
  Load(BR);
  BR.Free;
end;

function TBitList.ToBase64(EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): AnsiString;
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create((FCount + 7) shr 3 + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Result := G_Base64Encode(P, L);
  FreeMem(P);
end;

function TBitList.SetBit(Index: Integer): Boolean;
asm
        MOV     EAX,[EAX].TBitList.FBits
        BTS     [EAX],EDX
        SETC    AL
end;

function TBitList.ResetBit(Index: Integer): Boolean;
asm
        MOV     EAX,[EAX].TBitList.FBits
        BTR     [EAX],EDX
        SETC    AL
end;

function TBitList.ToggleBit(Index: Integer): Boolean;
asm
        MOV     EAX,[EAX].TBitList.FBits
        BTC     [EAX],EDX
        SETC    AL
end;

function TBitList.Contains(Value: Boolean): Boolean;
var
  C: Integer;
begin
  if FCount = 0 then
    Result := False
  else if Value then
  begin
    if FCount and 31 = 0 then
      Result := G_ScanOther_LongWord(0, FBits, FCapacity) >= 0
    else
    begin
      C := FCapacity - 1;
      if (C = 0) or (G_ScanOther_LongWord(0, FBits, C) < 0) then
        Result := FBits^[C] and ((1 shl (FCount - (C shl 5))) - 1) <> 0
      else
        Result := True;
    end;
  end else
  begin
    if FCount and 31 = 0 then
      Result := G_ScanOther_LongWord($FFFFFFFF, FBits, FCapacity) >= 0
    else
    begin
      C := FCapacity - 1;
      if (C = 0) or (G_ScanOther_LongWord($FFFFFFFF, FBits, C) < 0) then
        Result := (not FBits^[C]) and ((1 shl (FCount - (C shl 5))) - 1) <> 0
      else
        Result := True;
    end;
  end;
end;

function TBitList.IndexOf(Value: Boolean; StartIndex: Integer): Integer;
begin
  if Value then
    Result := G_SetBitScanForward(FBits, StartIndex, FCount - 1)
  else
    Result := G_FreeBitScanForward(FBits, StartIndex, FCount - 1)
end;

function TBitList.LastIndexOf(Value: Boolean; StartIndex: Integer): Integer;
var
  LastBit: Integer;
begin
  if StartIndex < FCount then
    LastBit := StartIndex
  else
    LastBit := FCount - 1;
  if Value then
    Result := G_SetBitScanBackward(FBits, 0, LastBit)
  else
    Result := G_FreeBitScanBackward(FBits, 0, LastBit);
end;

function TBitList.CountOf(Value: Boolean): Integer;
begin
  if Value then
    Result := G_CountOfSetBits(FBits, 0, FCount - 1)
  else
    Result := G_CountOfFreeBits(FBits, 0, FCount - 1);
end;

function TBitList.SetAll(Value: Boolean): TBitList;
begin
  if not Value then
    G_FillLongs(0, FBits, FCapacity)
  else
    G_FillLongs($FFFFFFFF, FBits, FCapacity);
  Result := Self;
end;

function TBitList.NotBits: TBitList;
begin
  G_NotLongs(FBits, FCapacity);
  Result := Self;
end;

function TBitList.AndBits(BitList: TBitList): TBitList;
begin
  if BitList.FCount = FCount then
    G_AndLongs(FBits, BitList.FBits, FCapacity)
  else
    RaiseError(SErrCountDiffersInTBitLists);
  Result := Self;
end;

function TBitList.OrBits(BitList: TBitList): TBitList;
begin
  if BitList.FCount = FCount then
    G_OrLongs(FBits, BitList.FBits, FCapacity)
  else
    RaiseError(SErrCountDiffersInTBitLists);
  Result := Self;
end;

function TBitList.XorBits(BitList: TBitList): TBitList;
begin
  if BitList.FCount = FCount then
    G_XorLongs(FBits, BitList.FBits, FCapacity)
  else
    RaiseError(SErrCountDiffersInTBitLists);
  Result := Self;
end;

function TBitList.AndNotBits(BitList: TBitList): TBitList;
begin
  if BitList.FCount = FCount then
    G_AndNotLongs(FBits, BitList.FBits, FCapacity)
  else
    RaiseError(SErrCountDiffersInTBitLists);
  Result := Self;
end;

function TBitList.Equals(BitList: TBitList): Boolean;
var
  C: Integer;
begin
  Result := True;
  if BitList.FCount <> FCount then
    Result := False
  else if (BitList <> Self) and (FCount > 0) then
    if FCount and 31 = 0 then
      Result := G_SameLongs(FBits, BitList.FBits, FCapacity)
    else
    begin
      C := FCapacity - 1;
      if (C = 0) or G_SameLongs(FBits, BitList.FBits, C) then
        Result := (FBits^[C] xor BitList.FBits^[C]) and
          ((1 shl (FCount - (C shl 5))) - 1) = 0
      else
        Result := False;
    end;
end;

function TBitList.Clone: TBitList;
begin
  Result := TBitList.Create(0);
  Result.FCapacity := FCapacity;
  if FCapacity > 0 then
  begin
    GetMem(Result.FBits, FCapacity * SizeOf(LongWord));
    G_CopyLongs(FBits, Result.FBits, FCapacity);
  end;
  Result.FCount := FCount;
end;

{ TIntegerList }

constructor TIntegerList.Create(InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  if InitialCapacity > 0 then
    GetMem(FItems, InitialCapacity * SizeOf(Integer));
  FSorted := True;
end;

destructor TIntegerList.Destroy;
begin
  if FCapacity > 0 then
    FreeMem(FItems);
end;

procedure TIntegerList.SetCapacity(NewCapacity: Integer);
var
  NewItems: PIntegerItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewItems, NewCapacity * SizeOf(Integer));
      if FCount > 0 then
        G_CopyLongs(FItems, NewItems, FCount);
    end else
      NewItems := nil;
    if FCapacity > 0 then
      FreeMem(FItems);
    FCapacity := NewCapacity;
    FItems := NewItems;
  end;
end;

procedure TIntegerList.SetMaintainSorted(Value: Boolean);
begin
  FMaintainSorted := Value;
  if Value then
    EnsureSorted;
end;

procedure TIntegerList.Load(Reader: TBinaryReader);
var
  C: Integer;
begin
  C := Reader.ReadSmallInt;
  if C = -32768 then
    C := Reader.ReadInteger;
  if C >= 0 then
    FSorted := True
  else
  begin
    FSorted := False;
    C := -C;
  end;
  if C > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(C));
  end;
  if C > 0 then
    Reader.Read(FItems, C * SizeOf(Integer));
  FCount := C;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TIntegerList.Load(IntegerList: TIntegerList);
var
  C: Integer;
begin
  C := IntegerList.FCount;
  if C > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(C));
  end;
  if C > 0 then
    G_CopyLongs(IntegerList.FItems, FItems, C);
  FCount := C;
  FSorted := IntegerList.FSorted;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TIntegerList.Load(Items: Pointer; Count: Integer; Sorted: Boolean);
begin
  if Count > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(Count));
  end;
  if Count > 0 then
    G_CopyLongs(Items, FItems, Count);
  FSorted := Sorted;
  FCount := Count;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TIntegerList.Load(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := Registry.GetDataSize(string(ValueName));
  if L > 0 then
  begin
    GetMem(P, L);
    Registry.ReadBinaryData(string(ValueName), P^, L);
    BR := TBinaryReader.Create;
    BR.LoadFromArray(P, L, True, EncryptionKey);
    Load(BR);
    BR.Free;
  end else
    Clear;
end;

procedure TIntegerList.Save(Writer: TBinaryWriter);
var
  C: Integer;
begin
  C := FCount;
  if C < 32768 then
  begin
    if FSorted then
      Writer.WriteSmallInt(SmallInt(C))
    else
      Writer.WriteSmallInt(-SmallInt(C))
  end else
  begin
    Writer.WriteSmallInt(-32768);
    if FSorted then
      Writer.WriteInteger(C)
    else
      Writer.WriteInteger(-C)
  end;
  if C > 0 then
    Writer.Write(FItems, C * SizeOf(Integer));
end;

procedure TIntegerList.Save(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest; CompressionMode: TCompressionMode);
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create(FCount * SizeOf(Integer) + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Registry.WriteBinaryData(string(ValueName), P^, L);
  FreeMem(P);
end;

procedure TIntegerList.FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := G_Base64Decode(S, nil);
  GetMem(P, L);
  G_Base64Decode(S, P);
  BR := TBinaryReader.Create;
  BR.LoadFromArray(P, L, True, EncryptionKey);
  Load(BR);
  BR.Free;
end;

function TIntegerList.ToBase64(EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): AnsiString;
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create(FCount * SizeOf(Integer) + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Result := G_Base64Encode(P, L);
  FreeMem(P);
end;

procedure TIntegerList.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TIntegerList.Add(N: Integer);
var
  L: Integer;
begin
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if FMaintainSorted then
  begin
    L := G_SearchFirstGE_Integer(N, FItems, FCount);
    if L < FCount then
      G_MoveLongs(@FItems^[L], @FItems^[L + 1], FCount - L);
    FItems^[L] := N;
  end else
  begin
    FItems^[FCount] := N;
    FSorted := False;
  end;
  Inc(FCount);
end;

procedure TIntegerList.AddIfNotExists(N: Integer);
var
  L: Integer;
begin
  if FSorted then
  begin
    L := G_SearchFirstGE_Integer(N, FItems, FCount);
    if (L < FCount) and (FItems^[L] = N) then
      Exit;
  end else
  begin
    L := G_Scan_Integer(N, FItems, FCount);
    if L >= 0 then
      Exit;
  end;
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if FMaintainSorted then
  begin
    if L < FCount then
      G_MoveLongs(@FItems^[L], @FItems^[L + 1], FCount - L);
    FItems^[L] := N;
  end else
  begin
    FItems^[FCount] := N;
    FSorted := False;
  end;
  Inc(FCount);
end;

procedure TIntegerList.Insert(Index, N: Integer);
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + 1], FCount - Index);
  FItems^[Index] := N;
  Inc(FCount);
  FSorted := False;
end;

procedure TIntegerList.Insert(Index: Integer; Items: Pointer; Count: Integer);
var
  C: Integer;
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_CopyLongs(Items, @FItems^[Index], Count);
  Inc(FCount, Count);
  FSorted := False;
end;

procedure TIntegerList.Insert(Index, Count, N: Integer);
var
  C: Integer;
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_FillLongs(N, @FItems^[Index], Count);
  Inc(FCount, Count);
  FSorted := False;
end;

function TIntegerList.PopBack: Integer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Dec(FCount);
  Result := FItems^[FCount];
end;

function TIntegerList.PeekBack: Integer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Result := FItems^[FCount - 1]
end;

procedure TIntegerList.EnsureSorted;
begin
  if not FSorted then
  begin
    if FCount > 1 then
      G_Sort_Integer(FItems, FCount);
    FSorted := True;
  end;
end;

function TIntegerList.IndexOf(N: Integer): Integer;
begin
  if FSorted then
    Result := G_BinarySearch_Integer(N, FItems, FCount)
  else
    Result := G_Scan_Integer(N, FItems, FCount);
end;

procedure TIntegerList.Remove(N: Integer);
var
  I, L: Integer;
begin
  if not FSorted then
    FCount := G_Remove_Integer(N, FItems, FCount)
  else
  begin
    I := G_SearchFirstGE_Integer(N, FItems, FCount);
    if (I < FCount) and (FItems^[I] = N) then
    begin
      L := I + 1;
      if (L < FCount) and (FItems^[L] = N) then
        if N < MaxInt then
        begin
          Inc(L);
          Inc(L, G_SearchFirstGE_Integer(N + 1, @FItems^[L], FCount - L));
        end else
          L := FCount;
      if L < FCount then
        G_MoveLongs(@FItems^[L], @FItems^[I], FCount - L);
      Dec(FCount, L - I);
    end;
  end;
end;

procedure TIntegerList.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  Dec(FCount);
  if Index < FCount then
    G_MoveLongs(@FItems^[Index + 1], @FItems^[Index], FCount - Index)
end;

procedure TIntegerList.RemoveAt(Index, Count: Integer);
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if LongWord(Index + Count) >= LongWord(FCount) then
    FCount := Index
  else if Count > 0 then
  begin
    Dec(FCount, Count);
    G_MoveLongs(@FItems^[Index + Count], @FItems^[Index], FCount - Index);
  end;
end;

procedure TIntegerList.UnorderedRemoveAt(Index: Integer);
begin
  if FMaintainSorted then
    RaiseError(SErrUnorderedRemovalNotAllowed);
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  Dec(FCount);
  if Index < FCount then
  begin
    FItems^[Index] := FItems^[FCount];
    FSorted := False;
  end;
end;

function TIntegerList._Dump: AnsiString;
var j: Integer;
begin
  Result := '[';
  for j:=0 to FCount - 1 do
  begin
    if j>0 then
      Result := Result + ',';
    Result := Result + G_IntToStr(FItems^[j]);
  end;

  Result := Result + ']';
end;

procedure TIntegerList.Clear;
begin
  FCount := 0;
end;

procedure TIntegerList.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

function TIntegerList.Equals(IntegerList: TIntegerList): Boolean;
begin
  if IntegerList = Self then
    Result := True
  else if (IntegerList <> nil) and (IntegerList.FCount = FCount) then
    Result := G_SameLongs(FItems, IntegerList.FItems, FCount)
  else
    Result := False;
end;

function TIntegerList.Clone: TIntegerList;
begin
  Result := TIntegerList.Create(FCount);
  if FCount > 0 then
    G_CopyLongs(FItems, Result.FItems, FCount);
  Result.FCount := FCount;
  Result.FMaintainSorted := FMaintainSorted;
  Result.FSorted := FSorted;
end;

//------------------------
function TIntegerList.Get(Index: Integer): Integer;
begin
  result := FItems[Index]
end;

function TIntegerList.GetEnumerator: TIntegerListEnumerator;
begin
  Result := TIntegerListEnumerator.Create(Self);
end;

procedure TIntegerList.Put(Index, Item: Integer);
begin
  FItems[Index] := Item;
end;
//------------------------


{ TWordList }

constructor TWordList.Create(InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  if InitialCapacity > 0 then
    GetMem(FItems, InitialCapacity * SizeOf(Word));
  FSorted := True;
end;

destructor TWordList.Destroy;
begin
  if FCapacity > 0 then
    FreeMem(FItems);
end;

procedure TWordList.SetCapacity(NewCapacity: Integer);
var
  NewItems: PWordItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewItems, NewCapacity * SizeOf(Word));
      if FCount > 0 then
        G_CopyMem(FItems, NewItems, FCount * SizeOf(Word));
    end else
      NewItems := nil;
    if FCapacity > 0 then
      FreeMem(FItems);
    FCapacity := NewCapacity;
    FItems := NewItems;
  end;
end;

procedure TWordList.SetMaintainSorted(Value: Boolean);
begin
  FMaintainSorted := Value;
  if Value then
    EnsureSorted;
end;

procedure TWordList.Load(Reader: TBinaryReader);
var
  C: Integer;
begin
  C := Reader.ReadSmallInt;
  if C = -32768 then
    C := Reader.ReadInteger;
  if C >= 0 then
    FSorted := True
  else
  begin
    FSorted := False;
    C := -C;
  end;
  if C > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(C));
  end;
  if C > 0 then
    Reader.Read(FItems, C * SizeOf(Word));
  FCount := C;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TWordList.Load(WordList: TWordList);
var
  C: Integer;
begin
  C := WordList.FCount;
  if C > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(C));
  end;
  if C > 0 then
    G_CopyMem(WordList.FItems, FItems, C * SizeOf(Word));
  FCount := C;
  FSorted := WordList.FSorted;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TWordList.Load(Items: Pointer; Count: Integer; Sorted: Boolean);
begin
  if Count > FCapacity then
  begin
    FCount := 0;
    SetCapacity(G_NormalizeCapacity(Count));
  end;
  if Count > 0 then
    G_CopyMem(Items, FItems, Count * SizeOf(Word));
  FSorted := Sorted;
  FCount := Count;
  if FMaintainSorted then
    EnsureSorted;
end;

procedure TWordList.Load(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := Registry.GetDataSize(string(ValueName));
  if L > 0 then
  begin
    GetMem(P, L);
    Registry.ReadBinaryData(string(ValueName), P^, L);
    BR := TBinaryReader.Create;
    BR.LoadFromArray(P, L, True, EncryptionKey);
    Load(BR);
    BR.Free;
  end else
    Clear;
end;

procedure TWordList.Save(Writer: TBinaryWriter);
var
  C: Integer;
begin
  C := FCount;
  if C < 32768 then
  begin
    if FSorted then
      Writer.WriteSmallInt(SmallInt(C))
    else
      Writer.WriteSmallInt(-SmallInt(C))
  end else
  begin
    Writer.WriteSmallInt(-32768);
    if FSorted then
      Writer.WriteInteger(C)
    else
      Writer.WriteInteger(-C)
  end;
  if C > 0 then
    Writer.Write(FItems, C * SizeOf(Word));
end;

procedure TWordList.Save(Registry: TRegistry; const ValueName: AnsiString;
  EncryptionKey: PSHA256Digest; CompressionMode: TCompressionMode);
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create(FCount * SizeOf(Word) + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Registry.WriteBinaryData(string(ValueName), P^, L);
  FreeMem(P);
end;

procedure TWordList.FromBase64(const S: AnsiString; EncryptionKey: PSHA256Digest);
var
  L: Integer;
  P: Pointer;
  BR: TBinaryReader;
begin
  L := G_Base64Decode(S, nil);
  GetMem(P, L);
  G_Base64Decode(S, P);
  BR := TBinaryReader.Create;
  BR.LoadFromArray(P, L, True, EncryptionKey);
  Load(BR);
  BR.Free;
end;

function TWordList.ToBase64(EncryptionKey: PSHA256Digest;
  CompressionMode: TCompressionMode): AnsiString;
var
  BW: TBinaryWriter;
  P: Pointer;
  L: Integer;
begin
  BW := TBinaryWriter.Create(FCount * SizeOf(Word) + 10);
  Save(BW);
  L := BW.SaveToArray(P, EncryptionKey, CompressionMode);
  BW.Free;
  Result := G_Base64Encode(P, L);
  FreeMem(P);
end;

procedure TWordList.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TWordList.Add(N: Word);
var
  L: Integer;
begin
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if FMaintainSorted then
  begin
    L := G_SearchFirstGE_Word(N, FItems, FCount);
    if L < FCount then
      G_MoveWords(@FItems^[L], @FItems^[L + 1], FCount - L);
    FItems^[L] := N;
  end else
  begin
    FItems^[FCount] := N;
    FSorted := False;
  end;
  Inc(FCount);
end;

procedure TWordList.AddIfNotExists(N: Word);
var
  L: Integer;
begin
  if FSorted then
  begin
    L := G_SearchFirstGE_Word(N, FItems, FCount);
    if (L < FCount) and (FItems^[L] = N) then
      Exit;
  end else
  begin
    L := G_Scan_Word(N, FItems, FCount);
    if L >= 0 then
      Exit;
  end;
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if FMaintainSorted then
  begin
    if L < FCount then
      G_MoveWords(@FItems^[L], @FItems^[L + 1], FCount - L);
    FItems^[L] := N;
  end else
  begin
    FItems^[FCount] := N;
    FSorted := False;
  end;
  Inc(FCount);
end;

procedure TWordList.Insert(Index: Integer; N: Word);
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if Index < FCount then
    G_MoveWords(@FItems^[Index], @FItems^[Index + 1], FCount - Index);
  FItems^[Index] := N;
  Inc(FCount);
  FSorted := False;
end;

procedure TWordList.Insert(Index: Integer; Items: Pointer; Count: Integer);
var
  C: Integer;
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveWords(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_CopyMem(Items, @FItems^[Index], Count * SizeOf(Word));
  Inc(FCount, Count);
  FSorted := False;
end;

procedure TWordList.Insert(Index, Count: Integer; N: Word);
var
  C: Integer;
begin
  if FMaintainSorted then
    RaiseError(SErrInsertionNotAllowed);
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveWords(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_FillWords(N, @FItems^[Index], Count);
  Inc(FCount, Count);
  FSorted := False;
end;

function TWordList.PopBack: Word;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Dec(FCount);
  Result := FItems^[FCount];
end;

function TWordList.PeekBack: Word;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Result := FItems^[FCount - 1];
end;

procedure TWordList.EnsureSorted;
begin
  if not FSorted then
  begin
    if FCount > 1 then
      G_Sort_Word(FItems, FCount);
    FSorted := True;
  end;
end;

function TWordList.IndexOf(N: Word): Integer;
begin
  if FSorted then
    Result := G_BinarySearch_Word(N, FItems, FCount)
  else
    Result := G_Scan_Word(N, FItems, FCount);
end;

procedure TWordList.Remove(N: Word);
var
  I, L: Integer;
begin
  if not FSorted then
    FCount := G_Remove_Word(N, FItems, FCount)
  else
  begin
    I := G_SearchFirstGE_Word(N, FItems, FCount);
    if (I < FCount) and (FItems^[I] = N) then
    begin
      L := I + 1;
      if (L < FCount) and (FItems^[L] = N) then
        if N < $FFFF then
        begin
          Inc(L);
          Inc(L, G_SearchFirstGE_Word(N + 1, @FItems^[L], FCount - L));
        end else
          L := FCount;
      if L < FCount then
        G_MoveWords(@FItems^[L], @FItems^[I], FCount - L);
      Dec(FCount, L - I);
    end;
  end;
end;

procedure TWordList.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  Dec(FCount);
  if Index < FCount then
    G_MoveWords(@FItems^[Index + 1], @FItems^[Index], FCount - Index)
end;

procedure TWordList.RemoveAt(Index, Count: Integer);
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if LongWord(Index + Count) >= LongWord(FCount) then
    FCount := Index
  else if Count > 0 then
  begin
    Dec(FCount, Count);
    G_MoveWords(@FItems^[Index + Count], @FItems^[Index], FCount - Index);
  end;
end;

procedure TWordList.UnorderedRemoveAt(Index: Integer);
begin
  if FMaintainSorted then
    RaiseError(SErrUnorderedRemovalNotAllowed);
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  Dec(FCount);
  if Index < FCount then
  begin
    FItems^[Index] := FItems^[FCount];
    FSorted := False;
  end;
end;

procedure TWordList.Clear;
begin
  FCount := 0;
end;

procedure TWordList.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

function TWordList.Equals(WordList: TWordList): Boolean;
begin
  if WordList = Self then
    Result := True
  else if (WordList <> nil) and (WordList.FCount = FCount) then
    Result := G_SameMem(FItems, WordList.FItems, FCount * SizeOf(Word))
  else
    Result := False;
end;

function TWordList.Clone: TWordList;
begin
  Result := TWordList.Create(FCount);
  if FCount > 0 then
    G_CopyMem(FItems, Result.FItems, FCount * SizeOf(Word));
  Result.FCount := FCount;
  Result.FMaintainSorted := FMaintainSorted;
  Result.FSorted := FSorted;
end;

{ TArrayList }

constructor TArrayList.Create(InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  if InitialCapacity > 0 then
    GetMem(FItems, InitialCapacity * SizeOf(Pointer));
end;

destructor TArrayList.Destroy;
var
  I: Integer;
begin
  if FCapacity > 0 then
  begin
    if FOwnItems then
      for I := FCount - 1 downto 0 do
        TObject(FItems^[I]).Free;
    FreeMem(FItems);
  end;
end;

procedure TArrayList.SetCapacity(NewCapacity: Integer);
var
  NewItems: PPointerItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewItems, NewCapacity * SizeOf(Pointer));
      if FCount > 0 then
        G_CopyLongs(FItems, NewItems, FCount);
    end else
      NewItems := nil;
    if FCapacity > 0 then
      FreeMem(FItems);
    FCapacity := NewCapacity;
    FItems := NewItems;
  end;
end;

procedure TArrayList.Load(ArrayList: TArrayList; SuppressDisposingItems: Boolean);
var
  C: Integer;
begin
  Clear(SuppressDisposingItems);
  C := ArrayList.FCount;
  if C > FCapacity then
    SetCapacity(G_NormalizeCapacity(C));
  if C > 0 then
    G_CopyLongs(ArrayList.FItems, FItems, C);
  FCount := C;
end;

procedure TArrayList.Load(Items: Pointer; Count: Integer;
  SuppressDisposingItems: Boolean);
begin
  Clear(SuppressDisposingItems);
  if Count > FCapacity then
    SetCapacity(G_NormalizeCapacity(Count));
  if Count > 0 then
    G_CopyLongs(Items, FItems, Count);
  FCount := Count;
end;

procedure TArrayList.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TArrayList.Add(P: Pointer);
begin
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  FItems^[FCount] := P;
  Inc(FCount);
end;

procedure TArrayList.Insert(Index: Integer; P: Pointer);
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + 1], FCount - Index);
  FItems^[Index] := P;
  Inc(FCount);
end;

procedure TArrayList.Insert(Index: Integer; Items: Pointer; Count: Integer);
var
  C: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_CopyLongs(Items, @FItems^[Index], Count);
  Inc(FCount, Count);
end;

procedure TArrayList.Insert(Index, Count: Integer; P: Pointer);
var
  C: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Count + FCount > FCapacity then
  begin
    C := G_EnlargeCapacity(FCapacity);
    if C < Count + FCount then
      C := Count + FCount;
    SetCapacity(C);
  end;
  if Index < FCount then
    G_MoveLongs(@FItems^[Index], @FItems^[Index + Count], FCount - Index);
  G_FillLongs(LongWord(P), @FItems^[Index], Count);
  Inc(FCount, Count);
end;

function TArrayList.PopBack: Pointer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Dec(FCount);
  Result := FItems^[FCount];
end;

function TArrayList.PeekBack: Pointer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Result := FItems^[FCount - 1];
end;

function TArrayList.ScanPointer(P: Pointer): Integer;
begin
  Result := G_Scan_Pointer(P, FItems, FCount);
end;

procedure TArrayList.Sort(CompareFunction: TCompareFunction);
begin
  G_Sort(FItems, FCount, CompareFunction);
end;

procedure TArrayList.StableSort(CompareFunction: TCompareFunction);
begin
  G_StableSort(FItems, FCount, CompareFunction);
end;

function TArrayList.EnumerateGroups(CompareFunction: TCompareFunction;
  Sorted: Boolean): TGroupEnumerator;
begin
  Result := TGroupEnumerator.Create(FItems, FCount, CompareFunction, Sorted);
end;

function TArrayList.Search(Value: Pointer; MatchFunction: TMatchFunction;
  Sorted: Boolean): Pointer;
var
  Index: Integer;
begin
  if Sorted then
    Index := G_BinarySearch(Value, FItems, FCount, MatchFunction)
  else
    Index := G_Search(Value, FItems, FCount, MatchFunction);
  if Index >= 0 then
    Result := FItems^[Index]
  else
    Result := nil;
end;

function TArrayList.IndexOf(Value: Pointer; MatchFunction: TMatchFunction;
  Sorted: Boolean): Integer;
begin
  if Sorted then
    Result := G_BinarySearch(Value, FItems, FCount, MatchFunction)
  else
    Result := G_Search(Value, FItems, FCount, MatchFunction);
end;

procedure TArrayList.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FOwnItems then
    TObject(FItems^[Index]).Free;
  Dec(FCount);
  if Index < FCount then
    G_MoveLongs(@FItems^[Index + 1], @FItems^[Index], FCount - Index);
end;

procedure TArrayList.RemoveAt(Index, Count: Integer);
var
  I: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if LongWord(Index + Count) >= LongWord(FCount) then
  begin
    if FOwnItems then
      for I := FCount - 1 downto Index do
        TObject(FItems^[I]).Free;
    FCount := Index;
  end
  else if Count > 0 then
  begin
    if FOwnItems then
      for I := Index + Count - 1 downto Index do
        TObject(FItems^[I]).Free;
    Dec(FCount, Count);
    G_MoveLongs(@FItems^[Index + Count], @FItems^[Index], FCount - Index);
  end;
end;

function TArrayList.Remove(P: Pointer):Integer;
begin
  Result := ScanPointer(P);
  if Result >= 0 then
    RemoveAt(Result);
end;

procedure TArrayList.UnorderedRemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FOwnItems then
    TObject(FItems^[Index]).Free;
  Dec(FCount);
  if Index < FCount then
    FItems^[Index] := FItems^[FCount];
end;

procedure TArrayList.Clear(SuppressDisposingItems: Boolean);
var
  I: Integer;
begin
  if FOwnItems and not SuppressDisposingItems then
    for I := FCount - 1 downto 0 do
      TObject(FItems^[I]).Free;
  FCount := 0;
end;

procedure TArrayList.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

function TArrayList.Equals(ArrayList: TArrayList;
  CompareFunction: TCompareFunction): Boolean;
var
  P1, P2: Pointer;
  I: Integer;
begin
  if ArrayList = Self then
    Result := True
  else if (ArrayList <> nil) and (ArrayList.FCount = FCount) then
  begin
    if not Assigned(CompareFunction) then
      Result := G_SameLongs(FItems, ArrayList.FItems, FCount)
    else
    begin
      Result := False;
      for I := FCount - 1 downto 0 do
      begin
        P1 := FItems^[I];
        P2 := ArrayList.FItems^[I];
        if (P1 <> P2) and (CompareFunction(P1, P2) <> 0) then
          Exit;
      end;
      Result := True;
    end;
  end else
    Result := False;
end;

function TArrayList.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    RaiseError(SErrIndexOutOfRange +
      ' [i:' + G_IntToStr(Index) + ';c:' + G_IntToStr(FCount) + ']');
  Result := FItems^[Index]
end;

function TArrayList.GetEnumerator: TArrayListEnumerator;
begin
  Result := TArrayListEnumerator.Create(Self);
end;

procedure TArrayList.Put(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index >= FCount) then
    RaiseError(SErrIndexOutOfRange +
      ' [i:' + G_IntToStr(Index) + ';c:' + G_IntToStr(FCount) + ']');
  FItems^[Index] := Item
end;

function TArrayList.Clone: TArrayList;
begin
  Result := TArrayList.Create(FCount);
  if FCount > 0 then
    G_CopyLongs(FItems, Result.FItems, FCount);
  Result.FCount := FCount;
end;

function TArrayList.CopyTo(ADestination: TArrayList): TArrayList;
begin
  Result := ADestination;
  Result.Clear;
  if FCount > 0 then
  begin
    Result.Capacity := FCount;
    G_CopyLongs(FItems, Result.FItems, FCount);
    Result.FCount := FCount;
  end;
end;

{ TArrayReadOnlyList }

constructor TArrayReadOnlyList.Create(ItemList: PPointerItemList; Count: Integer);
begin
  FItems := ItemList;
  FCount := Count;
end;

function TArrayReadOnlyList.ScanPointer(P: Pointer): Integer;
begin
  Result := G_Scan_Pointer(P, FItems, FCount);
end;

procedure TArrayReadOnlyList.Sort(CompareFunction: TCompareFunction);
begin
  G_Sort(FItems, FCount, CompareFunction);
end;

procedure TArrayReadOnlyList.StableSort(CompareFunction: TCompareFunction);
begin
  G_StableSort(FItems, FCount, CompareFunction);
end;

function TArrayReadOnlyList.EnumerateGroups(CompareFunction: TCompareFunction;
  Sorted: Boolean): TGroupEnumerator;
begin
  Result := TGroupEnumerator.Create(FItems, FCount, CompareFunction, Sorted);
end;

function TArrayReadOnlyList.Search(Value: Pointer; MatchFunction: TMatchFunction;
  Sorted: Boolean): Pointer;
var
  Index: Integer;
begin
  if Sorted then
    Index := G_BinarySearch(Value, FItems, FCount, MatchFunction)
  else
    Index := G_Search(Value, FItems, FCount, MatchFunction);
  if Index >= 0 then
    Result := FItems^[Index]
  else
    Result := nil;
end;

function TArrayReadOnlyList.IndexOf(Value: Pointer; MatchFunction: TMatchFunction;
  Sorted: Boolean): Integer;
begin
  if Sorted then
    Result := G_BinarySearch(Value, FItems, FCount, MatchFunction)
  else
    Result := G_Search(Value, FItems, FCount, MatchFunction);
end;

function TArrayReadOnlyList.Equals(ArrayList: TArrayReadOnlyList;
  CompareFunction: TCompareFunction): Boolean;
var
  P1, P2: Pointer;
  I: Integer;
begin
  if ArrayList = Self then
    Result := True
  else if (ArrayList <> nil) and (ArrayList.FCount = FCount) then
  begin
    if not Assigned(CompareFunction) then
      Result := G_SameLongs(FItems, ArrayList.FItems, FCount)
    else
    begin
      Result := False;
      for I := FCount - 1 downto 0 do
      begin
        P1 := FItems^[I];
        P2 := ArrayList.FItems^[I];
        if (P1 <> P2) and (CompareFunction(P1, P2) <> 0) then
          Exit;
      end;
      Result := True;
    end;
  end else
    Result := False;
end;

function TArrayReadOnlyList.Equals(ArrayList: TArrayList;
  CompareFunction: TCompareFunction): Boolean;
var
  P1, P2: Pointer;
  I: Integer;
begin
  if (ArrayList <> nil) and (ArrayList.FCount = FCount) then
  begin
    if not Assigned(CompareFunction) then
      Result := G_SameLongs(FItems, ArrayList.FItems, FCount)
    else
    begin
      Result := False;
      for I := FCount - 1 downto 0 do
      begin
        P1 := FItems^[I];
        P2 := ArrayList.FItems^[I];
        if (P1 <> P2) and (CompareFunction(P1, P2) <> 0) then
          Exit;
      end;
      Result := True;
    end;
  end else
    Result := False;
end;

function TArrayReadOnlyList.Clone: TArrayList;
begin
  Result := TArrayList.Create(FCount);
  if FCount > 0 then
    G_CopyLongs(FItems, Result.FItems, FCount);
  Result.FCount := FCount;
end;

{ TGroupEnumerator }

constructor TGroupEnumerator.Create(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; Sorted: Boolean);
var
  I, N, P: Integer;
begin
  if Count > 0 then
  begin
    if not Sorted then
      G_Sort(ItemList, Count, CompareFunction);
    N := 1;
    for I := 1 to Count - 1 do
      if CompareFunction(ItemList^[I - 1], ItemList^[I]) <> 0 then
        Inc(N);
    FGroupCount := N;
    GetMem(FGroups, N * SizeOf(Pointer));
    N := 0;
    P := 0;
    for I := 1 to Count - 1 do
      if CompareFunction(ItemList^[I - 1], ItemList^[I]) <> 0 then
      begin
        FGroups^[N] := TArrayReadOnlyList.Create(@ItemList^[P], I - P);
        Inc(N);
        P := I;
      end;
    FGroups^[N] := TArrayReadOnlyList.Create(@ItemList^[P], Count - P);
  end;
end;

destructor TGroupEnumerator.Destroy;
var
  I: Integer;
begin
  if FGroupCount > 0 then
  begin
    for I := FGroupCount - 1 downto 0 do
      FGroups^[I].Free;
    FreeMem(FGroups);
  end;
end;

{ TIntegerAssociationList }

constructor TIntegerAssociationList.Create(InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  if InitialCapacity > 0 then
  begin
    GetMem(FKeys, InitialCapacity * SizeOf(Integer));
    GetMem(FValues, InitialCapacity * SizeOf(Pointer));
  end;
end;

destructor TIntegerAssociationList.Destroy;
begin
  if FCapacity > 0 then
  begin
    Clear(False);
    FreeMem(FKeys);
    FreeMem(FValues);
  end;
end;

procedure TIntegerAssociationList.SetCapacity(NewCapacity: Integer);
var
  NewKeys: PIntegerItemList;
  NewValues: PPointerItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewKeys, NewCapacity * SizeOf(Integer));
      GetMem(NewValues, NewCapacity * SizeOf(Pointer));
      if FCount > 0 then
      begin
        G_CopyLongs(FKeys, NewKeys, FCount);
        G_CopyLongs(FValues, NewValues, FCount);
      end;
    end else
    begin
      NewKeys := nil;
      NewValues := nil;
    end;
    if FCapacity > 0 then
    begin
      FreeMem(FKeys);
      FreeMem(FValues);
    end;
    FCapacity := NewCapacity;
    FKeys := NewKeys;
    FValues := NewValues;
  end;
end;

function TIntegerAssociationList.GetItem(Key: Integer): Pointer;
var
  L: Integer;
begin
  L := G_BinarySearch_Integer(Key, FKeys, FCount);
  if L >= 0 then
    Result := FValues^[L]
  else
    Result := nil;
end;

procedure TIntegerAssociationList.SetItem(Key: Integer; Value: Pointer);
var
  L: Integer;
  O: Pointer;
begin
  L := G_SearchFirstGE_Integer(Key, FKeys, FCount);
  if (L < FCount) and (FKeys^[L] = Key) then
  begin
    if not FOwnValues then
      FValues^[L] := Value
    else
    begin
      O := FValues^[L];
      if O <> Value then
      begin
        FValues^[L] := Value;
        TObject(O).Free;
      end;
    end;
  end else
  begin
    if FCount >= FCapacity then
      SetCapacity(G_EnlargeCapacity(FCapacity));
    if L < FCount then
    begin
      G_MoveLongs(@FKeys^[L], @FKeys^[L + 1], FCount - L);
      G_MoveLongs(@FValues^[L], @FValues^[L + 1], FCount - L);
    end;
    FKeys^[L] := Key;
    FValues^[L] := Value;
    Inc(FCount);
  end;
end;

procedure TIntegerAssociationList.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

function TIntegerAssociationList.IndexOf(Key: Integer): Integer;
begin
  Result := G_BinarySearch_Integer(Key, FKeys, FCount)
end;

procedure TIntegerAssociationList.Add(Key: Integer; Value: Pointer);
var
  L: Integer;
begin
  L := G_SearchFirstGE_Integer(Key, FKeys, FCount);
  if (L < FCount) and (FKeys^[L] = Key) then
    RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TIntegerAssociationList');
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if L < FCount then
  begin
    G_MoveLongs(@FKeys^[L], @FKeys^[L + 1], FCount - L);
    G_MoveLongs(@FValues^[L], @FValues^[L + 1], FCount - L);
  end;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  Inc(FCount);
end;

procedure TIntegerAssociationList.Remove(Key: Integer);
var
  L: Integer;
begin
  L := G_BinarySearch_Integer(Key, FKeys, FCount);
  if L >= 0 then
    RemoveAt(L);
end;

procedure TIntegerAssociationList.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FOwnValues then
    TObject(FValues^[Index]).Free;
  Dec(FCount);
  if Index < FCount then
  begin
    G_MoveLongs(@FKeys^[Index + 1], @FKeys^[Index], FCount - Index);
    G_MoveLongs(@FValues^[Index + 1], @FValues^[Index], FCount - Index);
  end;
end;

procedure TIntegerAssociationList.RemoveAt(Index, Count: Integer);
var
  I: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if LongWord(Index + Count) >= LongWord(FCount) then
  begin
    if FOwnValues then
      for I := FCount - 1 downto Index do
        TObject(FValues^[I]).Free;
    FCount := Index;
  end
  else if Count > 0 then
  begin
    if FOwnValues then
      for I := Index + Count - 1 downto Index do
        TObject(FValues^[I]).Free;
    Dec(FCount, Count);
    G_MoveLongs(@FKeys^[Index + Count], @FKeys^[Index], FCount - Index);
    G_MoveLongs(@FValues^[Index + Count], @FValues^[Index], FCount - Index);
  end;
end;

procedure TIntegerAssociationList.Clear(SuppressDisposingValues: Boolean);
var
  I: Integer;
begin
  if FOwnValues and not SuppressDisposingValues then
    for I := FCount - 1 downto 0 do
      TObject(FValues^[I]).Free;
  FCount := 0;
end;

procedure TIntegerAssociationList.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

{ TIntegerHashtable }

constructor TIntegerHashtable.Create(InitialCapacity: Integer);
var
  N: Integer;
begin
  N := G_EnlargePrimeCapacity((InitialCapacity * 7) div 5);
  FCapacity := N;
  FMaxCount := (N * 5) div 7;
  GetMem(FKeys, N shl 2);
  G_FillLongs(LongWord(EmptyIntegerHashKey), FKeys, N);
  GetMem(FValues, N shl 2);
  N := (N + 31) shr 5;
  GetMem(FBits, N shl 2);
  G_FillLongs(0, FBits, N);
end;

destructor TIntegerHashtable.Destroy;
var
  I: Integer;
begin
  if FOwnValues then
    for I := FCapacity - 1 downto 0 do
      if G_BitTest(FBits, I) then
        TObject(FValues^[I]).Free;
  FreeMem(FKeys);
  FreeMem(FValues);
  FreeMem(FBits);
end;

procedure TIntegerHashtable.SetMaxCount(NewMaxCount: Integer);
var
  N: Integer;
begin
  if NewMaxCount >= FCount then
  begin
    N := G_EnlargePrimeCapacity((NewMaxCount * 7) div 5);
    if (N <> FCapacity) or (NewMaxCount < FUsedCount) then
      SetCapacity(N);
  end;
end;

function TIntegerHashtable.GetIndex(Key: Integer): Integer;
var
  X, HashSize, HashStep: LongWord;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if (FKeys^[X] = EmptyIntegerHashKey) and not G_BitTest(FBits, X) then
    begin
      Result := X;
      Exit;
    end;
    Inc(X, HashStep);
  end;
end;

procedure TIntegerHashtable.SetCapacity(NewCapacity: Integer);
var
  PrevKeys: PIntegerItemList;
  PrevValues: PPointerItemList;
  PrevBits: PLongWordItemList;
  N, I: Integer;
begin
  N := NewCapacity;
  I := FCapacity - 1;
  PrevKeys := FKeys;
  PrevValues := FValues;
  PrevBits := FBits;
  FCapacity := N;
  FUsedCount := FCount;
  FMaxCount := (N * 5) div 7;
  GetMem(FKeys, N shl 2);
  G_FillLongs(LongWord(EmptyIntegerHashKey), FKeys, N);
  GetMem(FValues, N shl 2);
  N := (N + 31) shr 5;
  GetMem(FBits, N shl 2);
  G_FillLongs(0, FBits, N);
  while I >= 0 do
  begin
    if G_BitTest(PrevBits, I) then
    begin
      N := GetIndex(PrevKeys^[I]);
      FKeys^[N] := PrevKeys^[I];
      FValues^[N] := PrevValues^[I];
      G_BitSet(FBits, N);
    end;
    Dec(I);
  end;
  FreeMem(PrevKeys);
  FreeMem(PrevValues);
  FreeMem(PrevBits);
end;

function TIntegerHashtable.GetItem(Key: Integer): Pointer;
var
  X, HashSize, HashStep: LongWord;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if (FKeys^[X] = EmptyIntegerHashKey) and not G_BitTest(FBits, X) then
      Break;
    if (FKeys^[X] = Key) and ((Key <> MissingIntegerHashKey) or
      G_BitTest(FBits, X)) then
    begin
      Result := FValues^[X];
      Exit;
    end;
    Inc(X, HashStep);
  end;
  Result := nil;
end;

procedure TIntegerHashtable.SetItem(Key: Integer; Value: Pointer);
var
  X, HashSize, HashStep: LongWord;
  L: Integer;
  O: Pointer;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  L := -1;
  while True do
  begin
    X := X mod HashSize;
    if G_BitTest(FBits, X) then
    begin
      if FKeys^[X] = Key then
      begin
        if not FOwnValues then
          FValues^[X] := Value
        else
        begin
          O := FValues^[X];
          if O <> Value then
          begin
            FValues^[X] := Value;
            TObject(O).Free;
          end;
        end;
        Exit;
      end;
    end else
    begin
      if L < 0 then
        L := X;
      if FKeys^[X] = EmptyIntegerHashKey then
        Break;
    end;
    Inc(X, HashStep);
  end;
  if FKeys^[L] = EmptyIntegerHashKey then
  begin
    if FUsedCount >= FMaxCount then
    begin
      if FCount + FCount > FUsedCount then
        L := G_EnlargePrimeCapacity(FCapacity)
      else
        L := FCapacity;
      SetCapacity(L);
      L := GetIndex(Key);
    end;
    Inc(FUsedCount);
  end;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  G_BitSet(FBits, L);
  Inc(FCount);
end;

procedure TIntegerHashtable.EnsureCapacity(Capacity: Integer);
begin
  if FMaxCount < Capacity + FUsedCount - FCount then
    SetCapacity(G_EnlargePrimeCapacity((Capacity * 7) div 5));
end;

procedure TIntegerHashtable.Add(Key: Integer; Value: Pointer);
var
  X, HashSize, HashStep: LongWord;
  L: Integer;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  L := -1;
  while True do
  begin
    X := X mod HashSize;
    if G_BitTest(FBits, X) then
    begin
      if FKeys^[X] = Key then
        RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TIntegerHashtable');
    end else
    begin
      if L < 0 then
        L := X;
      if FKeys^[X] = EmptyIntegerHashKey then
        Break;
    end;
    Inc(X, HashStep);
  end;
  if FKeys^[L] = EmptyIntegerHashKey then
  begin
    if FUsedCount >= FMaxCount then
    begin
      if FCount + FCount > FUsedCount then
        L := G_EnlargePrimeCapacity(FCapacity)
      else
        L := FCapacity;
      SetCapacity(L);
      L := GetIndex(Key);
    end;
    Inc(FUsedCount);
  end;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  G_BitSet(FBits, L);
  Inc(FCount);
end;

function TIntegerHashtable.Contains(Key: Integer): Boolean;
var
  X, HashSize, HashStep: LongWord;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if (FKeys^[X] = EmptyIntegerHashKey) and not G_BitTest(FBits, X) then
      Break;
    if (FKeys^[X] = Key) and ((Key <> MissingIntegerHashKey) or
      G_BitTest(FBits, X)) then
    begin
      Result := True;
      Exit;
    end;
    Inc(X, HashStep);
  end;
  Result := False;
end;

procedure TIntegerHashtable.Remove(Key: Integer);
var
  X, HashSize, HashStep: LongWord;
begin
  X := LongWord(Key);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if (FKeys^[X] = EmptyIntegerHashKey) and not G_BitTest(FBits, X) then
      Break;
    if (FKeys^[X] = Key) and ((Key <> MissingIntegerHashKey) or
      G_BitTest(FBits, X)) then
    begin
      if FOwnValues then
        TObject(FValues^[X]).Free;
      FKeys^[X] := MissingIntegerHashKey;
      G_BitReset(FBits, X);
      Dec(FCount);
      Exit;
    end;
    Inc(X, HashStep);
  end;
end;

procedure TIntegerHashtable.Clear(SuppressDisposingValues: Boolean);
var
  I, N: Integer;
begin
  N := FCapacity;
  if FOwnValues and not SuppressDisposingValues then
    for I := N - 1 downto 0 do
      if G_BitTest(FBits, I) then
        TObject(FValues^[I]).Free;
  G_FillLongs(LongWord(EmptyIntegerHashKey), FKeys, N);
  N := (N + 31) shr 5;
  G_FillLongs(0, FBits, N);
  FCount := 0;
  FUsedCount := 0;
end;

{ TIntegerRedBlackTree }

constructor TIntegerRedBlackTree.Create;
begin
  FRoot := IntegerRBTreeNil;
end;

destructor TIntegerRedBlackTree.Destroy;
begin
  Clear(False);
end;

function TIntegerRedBlackTree.GetRoot: PIntegerRBTreeNode;
begin
  if FRoot <> IntegerRBTreeNil then
    Result := FRoot
  else
    Result := nil;
end;

procedure TIntegerRedBlackTree.RotateLeft(Node: PIntegerRBTreeNode);
var
  PT: PIntegerRBTreeNode;
begin
  PT := Node^.Right;
  Node^.Right := PT^.Left;
  if PT^.Left <> IntegerRBTreeNil then
    PT^.Left^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = IntegerRBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Left then
    Node^.Parent^.Left := PT
  else
    Node^.Parent^.Right := PT;
  PT^.Left := Node;
  Node^.Parent := PT;
end;

procedure TIntegerRedBlackTree.RotateRight(Node: PIntegerRBTreeNode);
var
  PT: PIntegerRBTreeNode;
begin
  PT := Node^.Left;
  Node^.Left := PT^.Right;
  if PT^.Right <> IntegerRBTreeNil then
    PT^.Right^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = IntegerRBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Right then
    Node^.Parent^.Right := PT
  else
    Node^.Parent^.Left := PT;
  PT^.Right := Node;
  Node^.Parent := PT;
end;

procedure TIntegerRedBlackTree.InsertFixUp(Node: PIntegerRBTreeNode);
var
  PT: PIntegerRBTreeNode;
begin
  while (Node <> FRoot) and Node^.Parent.IsRed do
  begin
    PT := Node^.Parent^.Parent;
    if Node^.Parent = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Right then
        begin
          Node := Node^.Parent;
          RotateLeft(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateRight(PT);
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Left then
        begin
          Node := Node^.Parent;
          RotateRight(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateLeft(PT);
      end;
    end;
  end;
  FRoot.IsRed := False;
end;

procedure TIntegerRedBlackTree.RemoveFixUp(Node: PIntegerRBTreeNode);
var
  PT: PIntegerRBTreeNode;
begin
  while (Node <> FRoot) and not Node^.IsRed do
  begin
    PT := Node^.Parent;
    if Node = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateLeft(Node^.Parent);
        PT := Node^.Parent^.Right;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Right^.IsRed then
        begin
          PT^.Left^.IsRed := False;
          PT^.IsRed := True;
          RotateRight(PT);
          PT := Node^.Parent^.Right;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Right^.IsRed := False;
        RotateLeft(Node^.Parent);
        Node := FRoot;
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateRight(Node^.Parent);
        PT := Node^.Parent^.Left;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Left^.IsRed then
        begin
          PT^.Right^.IsRed := False;
          PT^.IsRed := True;
          RotateLeft(PT);
          PT := Node^.Parent^.Left;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Left^.IsRed := False;
        RotateRight(Node^.Parent);
        Node := FRoot;
      end;
    end;
  end;
  Node^.IsRed := False;
end;

function TIntegerRedBlackTree.GetItem(Key: Integer): Pointer;
var
  P: PIntegerRBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    Result := P^.Value
  else
    Result := nil;
end;

procedure TIntegerRedBlackTree.SetItem(Key: Integer; Value: Pointer);
var
  P: PIntegerRBTreeNode;
  PP: Pointer;
begin
  PP := IntegerRBTreeNil;
  P := FRoot;
  repeat
    if P = IntegerRBTreeNil then
    begin
      InsertNode(PP, Key, Value);
      Exit;
    end;
    PP := P;
    if Key < P^.Key then
      P := P^.Left
    else if Key <> P^.Key then
      P := P^.Right
    else
      Break;
  until False;
  if not FOwnValues then
    P^.Value := Value
  else
  begin
    PP := P^.Value;
    if PP <> Pointer(Value) then
    begin
      P^.Value := Value;
      TObject(PP).Free;
    end;
  end;
end;

function TIntegerRedBlackTree.GetFirstNode: PIntegerRBTreeNode;
begin
  Result := FRoot;
  if Result <> IntegerRBTreeNil then
    while Result^.Left <> IntegerRBTreeNil do
      Result := Result^.Left
  else
    Result := nil;
end;

function TIntegerRedBlackTree.GetLastNode: PIntegerRBTreeNode;
begin
  Result := FRoot;
  if Result <> IntegerRBTreeNil then
    while Result^.Right <> IntegerRBTreeNil do
      Result := Result^.Right
  else
    Result := nil;
end;

function TIntegerRedBlackTree.InsertNode(Parent: PIntegerRBTreeNode;
  Key: Integer; Value: Pointer): PIntegerRBTreeNode;
begin
  GetMem(Result, SizeOf(TIntegerRBTreeNode));
  Result^.Key := Key;
  Result^.Parent := Parent;
  Result^.Left := IntegerRBTreeNil;
  Result^.Right := IntegerRBTreeNil;
  Result^.Value := Value;
  Result^.OwnerTree := Self;
  Result^.IsRed := True;
  if Parent = IntegerRBTreeNil then
    FRoot := Result
  else if Key < Parent^.Key then
    Parent^.Left := Result
  else
    Parent^.Right := Result;
  InsertFixUp(Result);
end;

function TIntegerRedBlackTree.Add(Key: Integer; Value: Pointer): PIntegerRBTreeNode;
var
  P: PIntegerRBTreeNode;
begin
  Result := IntegerRBTreeNil;
  P := FRoot;
  repeat
    if P = IntegerRBTreeNil then
    begin
      Result := InsertNode(Result, Key, Value);
      Exit;
    end;
    Result := P;
    if Key < P^.Key then
      P := P^.Left
    else if Key <> P^.Key then
      P := P^.Right
    else
      Break;
  until False;
  RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TIntegerRedBlackTree');
end;

function TIntegerRedBlackTree.SearchNode(Key: Integer): PIntegerRBTreeNode;
begin
  Result := FRoot;
  while Result <> IntegerRBTreeNil do
    if Key < Result^.Key then
      Result := Result^.Left
    else if Key <> Result^.Key then
      Result := Result^.Right
    else
      Exit;
  Result := nil;
end;

function TIntegerRedBlackTree.SearchFirstGreater(Key: Integer): PIntegerRBTreeNode;
var
  P: PIntegerRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> IntegerRBTreeNil do
    if Key >= P^.Key then
      P := P^.Right
    else
    begin
      Result := P;
      P := P^.Left;
    end;
end;

function TIntegerRedBlackTree.SearchFirstGreaterOrEqual(Key: Integer): PIntegerRBTreeNode;
var
  P: PIntegerRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> IntegerRBTreeNil do
    if Key > P^.Key then
      P := P^.Right
    else
    begin
      Result := P;
      P := P^.Left;
    end;
end;

function TIntegerRedBlackTree.SearchLastLesser(Key: Integer): PIntegerRBTreeNode;
var
  P: PIntegerRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> IntegerRBTreeNil do
    if Key <= P^.Key then
      P := P^.Left
    else
    begin
      Result := P;
      P := P^.Right;
    end;
end;

function TIntegerRedBlackTree.SearchLastLesserOrEqual(Key: Integer): PIntegerRBTreeNode;
var
  P: PIntegerRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> IntegerRBTreeNil do
    if Key < P^.Key then
      P := P^.Left
    else
    begin
      Result := P;
      P := P^.Right;
    end;
end;

function TIntegerRedBlackTree.NextNode(Node: PIntegerRBTreeNode): PIntegerRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Right;
  if Result <> IntegerRBTreeNil then
    while Result^.Left <> IntegerRBTreeNil do
      Result := Result^.Left
  else
  begin
    Result := Node^.Parent;
    while Result <> IntegerRBTreeNil do
      if Node = Result^.Right then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

function TIntegerRedBlackTree.PreviousNode(Node: PIntegerRBTreeNode): PIntegerRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Left;
  if Result <> IntegerRBTreeNil then
    while Result^.Right <> IntegerRBTreeNil do
      Result := Result^.Right
  else
  begin
    Result := Node^.Parent;
    while Result <> IntegerRBTreeNil do
      if Node = Result^.Left then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

procedure TIntegerRedBlackTree.Remove(Key: Integer);
var
  P: PIntegerRBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    RemoveNode(P);
end;

procedure TIntegerRedBlackTree.RemoveNode(Node: PIntegerRBTreeNode);
var
  P, PT: PIntegerRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  if (Node^.Left = IntegerRBTreeNil) or (Node^.Right = IntegerRBTreeNil) then
    P := Node
  else
    P := NextNode(Node);
  if P^.Left <> IntegerRBTreeNil then
    PT := P^.Left
  else
    PT := P^.Right;
  PT^.Parent := P^.Parent;
  if P^.Parent = IntegerRBTreeNil then
    FRoot := PT
  else if P^.Parent^.Left = P then
    P^.Parent^.Left := PT
  else
    P^.Parent^.Right := PT;
  if FOwnValues then
    TObject(Node^.Value).Free;
  if P <> Node then
  begin
    Node^.Key := P^.Key;
    Node^.Value := P^.Value;
  end;
  if not P^.IsRed then
    RemoveFixUp(PT);
  FreeMem(P);
end;

procedure FreeIntegerRBTValue(Node: PIntegerRBTreeNode);
begin
  if Node^.Left <> IntegerRBTreeNil then
    FreeIntegerRBTValue(Node^.Left);
  if Node^.Right <> IntegerRBTreeNil then
    FreeIntegerRBTValue(Node^.Right);
  TObject(Node^.Value).Free;
end;

procedure FreeIntegerRBTNode(Node: PIntegerRBTreeNode);
begin
  if Node^.Left <> IntegerRBTreeNil then
    FreeIntegerRBTNode(Node^.Left);
  if Node^.Right <> IntegerRBTreeNil then
    FreeIntegerRBTNode(Node^.Right);
  FreeMem(Node);
end;

procedure TIntegerRedBlackTree.Clear(SuppressDisposingValues: Boolean);
begin
  if FRoot <> IntegerRBTreeNil then
  begin
    if FOwnValues and not SuppressDisposingValues then
      FreeIntegerRBTValue(FRoot);
    FreeIntegerRBTNode(FRoot);
  end;
  FRoot := IntegerRBTreeNil;
end;

{ TInt64RedBlackTree }

constructor TInt64RedBlackTree.Create;
begin
  FRoot := Int64RBTreeNil;
end;

destructor TInt64RedBlackTree.Destroy;
begin
  Clear(False);
end;

function TInt64RedBlackTree.GetRoot: PInt64RBTreeNode;
begin
  if FRoot <> Int64RBTreeNil then
    Result := FRoot
  else
    Result := nil;
end;

procedure TInt64RedBlackTree.RotateLeft(Node: PInt64RBTreeNode);
var
  PT: PInt64RBTreeNode;
begin
  PT := Node^.Right;
  Node^.Right := PT^.Left;
  if PT^.Left <> Int64RBTreeNil then
    PT^.Left^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = Int64RBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Left then
    Node^.Parent^.Left := PT
  else
    Node^.Parent^.Right := PT;
  PT^.Left := Node;
  Node^.Parent := PT;
end;

procedure TInt64RedBlackTree.RotateRight(Node: PInt64RBTreeNode);
var
  PT: PInt64RBTreeNode;
begin
  PT := Node^.Left;
  Node^.Left := PT^.Right;
  if PT^.Right <> Int64RBTreeNil then
    PT^.Right^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = Int64RBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Right then
    Node^.Parent^.Right := PT
  else
    Node^.Parent^.Left := PT;
  PT^.Right := Node;
  Node^.Parent := PT;
end;

procedure TInt64RedBlackTree.InsertFixUp(Node: PInt64RBTreeNode);
var
  PT: PInt64RBTreeNode;
begin
  while (Node <> FRoot) and Node^.Parent.IsRed do
  begin
    PT := Node^.Parent^.Parent;
    if Node^.Parent = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Right then
        begin
          Node := Node^.Parent;
          RotateLeft(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateRight(PT);
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Left then
        begin
          Node := Node^.Parent;
          RotateRight(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateLeft(PT);
      end;
    end;
  end;
  FRoot.IsRed := False;
end;

procedure TInt64RedBlackTree.RemoveFixUp(Node: PInt64RBTreeNode);
var
  PT: PInt64RBTreeNode;
begin
  while (Node <> FRoot) and not Node^.IsRed do
  begin
    PT := Node^.Parent;
    if Node = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateLeft(Node^.Parent);
        PT := Node^.Parent^.Right;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Right^.IsRed then
        begin
          PT^.Left^.IsRed := False;
          PT^.IsRed := True;
          RotateRight(PT);
          PT := Node^.Parent^.Right;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Right^.IsRed := False;
        RotateLeft(Node^.Parent);
        Node := FRoot;
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateRight(Node^.Parent);
        PT := Node^.Parent^.Left;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Left^.IsRed then
        begin
          PT^.Right^.IsRed := False;
          PT^.IsRed := True;
          RotateLeft(PT);
          PT := Node^.Parent^.Left;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Left^.IsRed := False;
        RotateRight(Node^.Parent);
        Node := FRoot;
      end;
    end;
  end;
  Node^.IsRed := False;
end;

function TInt64RedBlackTree.GetItem(const Key: Int64): Pointer;
var
  P: PInt64RBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    Result := P^.Value
  else
    Result := nil;
end;

procedure TInt64RedBlackTree.SetItem(const Key: Int64; Value: Pointer);
var
  P: PInt64RBTreeNode;
  PP: Pointer;
begin
  PP := Int64RBTreeNil;
  P := FRoot;
  repeat
    if P = Int64RBTreeNil then
    begin
      InsertNode(PP, Key, Value);
      Exit;
    end;
    PP := P;
    if Key < P^.Key then
      P := P^.Left
    else if Key <> P^.Key then
      P := P^.Right
    else
      Break;
  until False;
  if not FOwnValues then
    P^.Value := Value
  else
  begin
    PP := P^.Value;
    if PP <> Pointer(Value) then
    begin
      P^.Value := Value;
      TObject(PP).Free;
    end;
  end;
end;

function TInt64RedBlackTree.GetFirstNode: PInt64RBTreeNode;
begin
  Result := FRoot;
  if Result <> Int64RBTreeNil then
    while Result^.Left <> Int64RBTreeNil do
      Result := Result^.Left
  else
    Result := nil;
end;

function TInt64RedBlackTree.GetLastNode: PInt64RBTreeNode;
begin
  Result := FRoot;
  if Result <> Int64RBTreeNil then
    while Result^.Right <> Int64RBTreeNil do
      Result := Result^.Right
  else
    Result := nil;
end;

function TInt64RedBlackTree.InsertNode(Parent: PInt64RBTreeNode;
  const Key: Int64; Value: Pointer): PInt64RBTreeNode;
begin
  GetMem(Result, SizeOf(TInt64RBTreeNode));
  Result^.Key := Key;
  Result^.Parent := Parent;
  Result^.Left := Int64RBTreeNil;
  Result^.Right := Int64RBTreeNil;
  Result^.Value := Value;
  Result^.OwnerTree := Self;
  Result^.IsRed := True;
  if Parent = Int64RBTreeNil then
    FRoot := Result
  else if Key < Parent^.Key then
    Parent^.Left := Result
  else
    Parent^.Right := Result;
  InsertFixUp(Result);
end;

function TInt64RedBlackTree.Add(const Key: Int64; Value: Pointer): PInt64RBTreeNode;
var
  P: PInt64RBTreeNode;
begin
  Result := Int64RBTreeNil;
  P := FRoot;
  repeat
    if P = Int64RBTreeNil then
    begin
      Result := InsertNode(Result, Key, Value);
      Exit;
    end;
    Result := P;
    if Key < P^.Key then
      P := P^.Left
    else if Key <> P^.Key then
      P := P^.Right
    else
      Break;
  until False;
  RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TInt64RedBlackTree');
end;

function TInt64RedBlackTree.SearchNode(const Key: Int64): PInt64RBTreeNode;
begin
  Result := FRoot;
  while Result <> Int64RBTreeNil do
    if Key < Result^.Key then
      Result := Result^.Left
    else if Key <> Result^.Key then
      Result := Result^.Right
    else
      Exit;
  Result := nil;
end;

function TInt64RedBlackTree.SearchFirstGreater(const Key: Int64): PInt64RBTreeNode;
var
  P: PInt64RBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> Int64RBTreeNil do
    if Key >= P^.Key then
      P := P^.Right
    else
    begin
      Result := P;
      P := P^.Left;
    end;
end;

function TInt64RedBlackTree.SearchFirstGreaterOrEqual(const Key: Int64): PInt64RBTreeNode;
var
  P: PInt64RBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> Int64RBTreeNil do
    if Key > P^.Key then
      P := P^.Right
    else
    begin
      Result := P;
      P := P^.Left;
    end;
end;

function TInt64RedBlackTree.SearchLastLesser(const Key: Int64): PInt64RBTreeNode;
var
  P: PInt64RBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> Int64RBTreeNil do
    if Key <= P^.Key then
      P := P^.Left
    else
    begin
      Result := P;
      P := P^.Right;
    end;
end;

function TInt64RedBlackTree.SearchLastLesserOrEqual(const Key: Int64): PInt64RBTreeNode;
var
  P: PInt64RBTreeNode;
begin
  Result := nil;
  P := FRoot;
  while P <> Int64RBTreeNil do
    if Key < P^.Key then
      P := P^.Left
    else
    begin
      Result := P;
      P := P^.Right;
    end;
end;

function TInt64RedBlackTree.NextNode(Node: PInt64RBTreeNode): PInt64RBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Right;
  if Result <> Int64RBTreeNil then
    while Result^.Left <> Int64RBTreeNil do
      Result := Result^.Left
  else
  begin
    Result := Node^.Parent;
    while Result <> Int64RBTreeNil do
      if Node = Result^.Right then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

function TInt64RedBlackTree.PreviousNode(Node: PInt64RBTreeNode): PInt64RBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Left;
  if Result <> Int64RBTreeNil then
    while Result^.Right <> Int64RBTreeNil do
      Result := Result^.Right
  else
  begin
    Result := Node^.Parent;
    while Result <> Int64RBTreeNil do
      if Node = Result^.Left then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

procedure TInt64RedBlackTree.Remove(const Key: Int64);
var
  P: PInt64RBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    RemoveNode(P);
end;

procedure TInt64RedBlackTree.RemoveNode(Node: PInt64RBTreeNode);
var
  P, PT: PInt64RBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  if (Node^.Left = Int64RBTreeNil) or (Node^.Right = Int64RBTreeNil) then
    P := Node
  else
    P := NextNode(Node);
  if P^.Left <> Int64RBTreeNil then
    PT := P^.Left
  else
    PT := P^.Right;
  PT^.Parent := P^.Parent;
  if P^.Parent = Int64RBTreeNil then
    FRoot := PT
  else if P^.Parent^.Left = P then
    P^.Parent^.Left := PT
  else
    P^.Parent^.Right := PT;
  if FOwnValues then
    TObject(Node^.Value).Free;
  if P <> Node then
  begin
    Node^.Key := P^.Key;
    Node^.Value := P^.Value;
  end;
  if not P^.IsRed then
    RemoveFixUp(PT);
  FreeMem(P);
end;

procedure FreeInt64RBTValue(Node: PInt64RBTreeNode);
begin
  if Node^.Left <> Int64RBTreeNil then
    FreeInt64RBTValue(Node^.Left);
  if Node^.Right <> Int64RBTreeNil then
    FreeInt64RBTValue(Node^.Right);
  TObject(Node^.Value).Free;
end;

procedure FreeInt64RBTNode(Node: PInt64RBTreeNode);
begin
  if Node^.Left <> Int64RBTreeNil then
    FreeInt64RBTNode(Node^.Left);
  if Node^.Right <> Int64RBTreeNil then
    FreeInt64RBTNode(Node^.Right);
  FreeMem(Node);
end;

procedure TInt64RedBlackTree.Clear(SuppressDisposingValues: Boolean);
begin
  if FRoot <> Int64RBTreeNil then
  begin
    if FOwnValues and not SuppressDisposingValues then
      FreeInt64RBTValue(FRoot);
    FreeInt64RBTNode(FRoot);
  end;
  FRoot := Int64RBTreeNil;
end;

{ TStringAssociationList }

constructor TStringAssociationList.Create(CaseSensitive: Boolean;
  InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  FCaseSensitive := CaseSensitive;
  if InitialCapacity > 0 then
  begin
    GetMem(FKeys, InitialCapacity * SizeOf(Pointer));
    GetMem(FValues, InitialCapacity * SizeOf(Pointer));
  end;
end;

destructor TStringAssociationList.Destroy;
begin
  if FCapacity > 0 then
  begin
    Clear(False);
    FreeMem(FKeys);
    FreeMem(FValues);
  end;
end;

procedure TStringAssociationList.SetCapacity(NewCapacity: Integer);
var
  NewKeys: PStringItemList;
  NewValues: PPointerItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewKeys, NewCapacity * SizeOf(Pointer));
      GetMem(NewValues, NewCapacity * SizeOf(Pointer));
      if FCount > 0 then
      begin
        G_CopyLongs(FKeys, NewKeys, FCount);
        G_CopyLongs(FValues, NewValues, FCount);
      end;
    end else
    begin
      NewKeys := nil;
      NewValues := nil;
    end;
    if FCapacity > 0 then
    begin
      FreeMem(FKeys);
      FreeMem(FValues);
    end;
    FCapacity := NewCapacity;
    FKeys := NewKeys;
    FValues := NewValues;
  end;
end;

function TStringAssociationList.GetItem(const Key: AnsiString): Pointer;
var
  L: Integer;
begin
  L := IndexOf(Key);
  if L >= 0 then
    Result := FValues^[L]
  else
    Result := nil;
end;

function TStringAssociationList.SearchFirstGE(const Key: AnsiString): Integer;
var
  L, H, I: Integer;
begin
  L := 0;
  H := FCount - 1;
  if not FCaseSensitive then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if G_CompareText(FKeys^[I], Key) < 0 then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if G_CompareStr(FKeys^[I], Key) < 0 then
        L := I + 1
      else
        H := I - 1;
    end;
  Result := L;
end;

procedure TStringAssociationList.SetItem(const Key: AnsiString; Value: Pointer);
var
  L: Integer;
  O: Pointer;
begin
  L := SearchFirstGE(Key);
  if (L < FCount) and (FKeys^[L] = Key) then
  begin
    if not FOwnValues then
      FValues^[L] := Value
    else
    begin
      O := FValues^[L];
      if O <> Value then
      begin
        FValues^[L] := Value;
        TObject(O).Free;
      end;
    end;
  end else
  begin
    if FCount >= FCapacity then
      SetCapacity(G_EnlargeCapacity(FCapacity));
    if L < FCount then
    begin
      G_MoveLongs(@FKeys^[L], @FKeys^[L + 1], FCount - L);
      G_MoveLongs(@FValues^[L], @FValues^[L + 1], FCount - L);
    end;
    Pointer(FKeys^[L]) := nil;
    FKeys^[L] := Key;
    FValues^[L] := Value;
    Inc(FCount);
  end;
end;

procedure TStringAssociationList.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

function TStringAssociationList.IndexOf(const Key: AnsiString): Integer;
var
  L, H, I, C: Integer;
begin
  L := 0;
  H := FCount - 1;
  if not FCaseSensitive then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := G_CompareText(FKeys^[I], Key);
      if C < 0 then
        L := I + 1
      else
      begin
        if C = 0 then
        begin
          Result := I;
          Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := G_CompareStr(FKeys^[I], Key);
      if C < 0 then
        L := I + 1
      else
      begin
        if C = 0 then
        begin
          Result := I;
          Exit;
        end;
        H := I - 1;
      end;
    end;
  Result := -1;
end;

function TStringAssociationList.Add(const Key: AnsiString; Value: Pointer): Integer;
var L: Integer;
begin
  L := SearchFirstGE(Key);
  if (L < FCount) and  (Self.Compare(FKeys^[L], Key) = 0) then
    RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TStringAssociationList');
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if L < FCount then
  begin
    G_MoveLongs(@FKeys^[L], @FKeys^[L + 1], FCount - L);
    G_MoveLongs(@FValues^[L], @FValues^[L + 1], FCount - L);
  end;
  Pointer(FKeys^[L]) := nil;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  Inc(FCount);
  Result := L;
end;

function TStringAssociationList.AddIfNotExists(const Key: AnsiString; Value: Pointer): Integer;
var L: Integer;
begin
  L := SearchFirstGE(Key);
  if (L < FCount) and (Self.Compare(FKeys^[L], Key) = 0) then
  begin
    Result := L;
    Exit;
  end;
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  if L < FCount then
  begin
    G_MoveLongs(@FKeys^[L], @FKeys^[L + 1], FCount - L);
    G_MoveLongs(@FValues^[L], @FValues^[L + 1], FCount - L);
  end;
  Pointer(FKeys^[L]) := nil;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  Inc(FCount);
  Result := L;
end;

procedure TStringAssociationList.Remove(const Key: AnsiString);
var
  L: Integer;
begin
  L := IndexOf(Key);
  if L >= 0 then
    RemoveAt(L);
end;

procedure TStringAssociationList.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if FOwnValues then
    TObject(FValues^[Index]).Free;
  FKeys^[Index] := '';
  Dec(FCount);
  if Index < FCount then
  begin
    G_MoveLongs(@FKeys^[Index + 1], @FKeys^[Index], FCount - Index);
    G_MoveLongs(@FValues^[Index + 1], @FValues^[Index], FCount - Index);
  end;
end;

procedure TStringAssociationList.RemoveAt(Index, Count: Integer);
var
  I: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if LongWord(Index + Count) >= LongWord(FCount) then
  begin
    for I := FCount - 1 downto Index do
    begin
      if FOwnValues then
        TObject(FValues^[I]).Free;
      FKeys^[I] := '';
    end;
    FCount := Index;
  end
  else if Count > 0 then
  begin
    for I := Index + Count - 1 downto Index do
    begin
      if FOwnValues then
        TObject(FValues^[I]).Free;
      FKeys^[I] := '';
    end;
    Dec(FCount, Count);
    G_MoveLongs(@FKeys^[Index + Count], @FKeys^[Index], FCount - Index);
    G_MoveLongs(@FValues^[Index + Count], @FValues^[Index], FCount - Index);
  end;
end;

procedure TStringAssociationList.AddList(AList: TStringAssociationList);
var j: Integer;
begin
  if Assigned(AList) then  
    for j := 0 to AList.Count - 1 do
      Add(AList.KeyList[j], AList.ValueList[j])    
end;

procedure TStringAssociationList.Clear(SuppressDisposingValues: Boolean);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
  begin
    if FOwnValues and not SuppressDisposingValues then
      TObject(FValues^[I]).Free;
    FKeys^[I] := '';
  end;
  FCount := 0;
end;

function TStringAssociationList.Compare(const S1, S2: AnsiString): Integer;
begin
  if FCaseSensitive then
    Result := G_CompareStr(S1, S2)
  else
    Result := G_CompareText(S1, S2)
end;

function TStringAssociationList.ToString: AnsiString;
var
  j : Integer;
  z : TAnsiStringBuilder;
begin
  z := TAnsiStringBuilder.Create(Count*30);
  try
    for j:=0 to Count-1 do
      z.AppendLine(KeyList^[j]);
    Result := z.ToString;
  finally
    z.Free;
  end;
end;

procedure TStringAssociationList.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

{ TStringHashtable }

constructor TStringHashtable.Create(CaseSensitive: Boolean;
  InitialCapacity: Integer);
var
  N: Integer;
begin
  N := G_EnlargePrimeCapacity((InitialCapacity * 7) div 5);
  FCapacity := N;
  FMaxCount := (N * 5) div 7;
  FCaseSensitive := CaseSensitive;
  GetMem(FKeys, N shl 2);
  GetMem(FValues, N shl 2);
  G_FillLongs(0, FKeys, N);
end;

destructor TStringHashtable.Destroy;
var
  I: Integer;
  P: Pointer;
begin
  for I := FCapacity - 1 downto 0 do
  begin
    P := Pointer(FKeys^[I]);
    if (P <> nil) and (P <> MissingStringHashKey) then
    begin
      if FOwnValues then
        TObject(FValues^[I]).Free;
      FKeys^[I] := '';
    end;
  end;
  FreeMem(FKeys);
  FreeMem(FValues);
end;

procedure TStringHashtable.SetMaxCount(NewMaxCount: Integer);
var
  N: Integer;
begin
  if NewMaxCount >= FCount then
  begin
    N := G_EnlargePrimeCapacity((NewMaxCount * 7) div 5);
    if (N <> FCapacity) or (NewMaxCount < FUsedCount) then
      SetCapacity(N);
  end;
end;

function TStringHashtable.GetIndex(P: Pointer): Integer;
var
  X, HashSize, HashStep: LongWord;
begin
  if not FCaseSensitive then
    X := G_CRC32_Text(P)
  else
    X := G_CRC32_Str(P);
  HashSize := LongWord(FCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if Pointer(FKeys^[X]) = nil then
    begin
      Result := X;
      Exit;
    end;
    Inc(X, HashStep);
  end;
end;

procedure TStringHashtable.SetCapacity(NewCapacity: Integer);
var
  PrevKeys: PStringItemList;
  PrevValues: PPointerItemList;
  P: Pointer;
  N, I: Integer;
begin
  N := NewCapacity;
  I := FCapacity - 1;
  PrevKeys := FKeys;
  PrevValues := FValues;
  FCapacity := N;
  FUsedCount := FCount;
  FMaxCount := (N * 5) div 7;
  GetMem(FKeys, N shl 2);
  GetMem(FValues, N shl 2);
  G_FillLongs(0, FKeys, N);
  while I >= 0 do
  begin
    P := Pointer(PrevKeys^[I]);
    if (P <> nil) and (P <> MissingStringHashKey) then
    begin
      N := GetIndex(P);
      Pointer(FKeys^[N]) := P;
      FValues^[N] := PrevValues^[I];
    end;
    Dec(I);
  end;
  FreeMem(PrevKeys);
  FreeMem(PrevValues);
end;

function TStringHashtable.GetItem(const Key: AnsiString): Pointer;
var
  X, HashSize, HashStep: LongWord;
  P: Pointer;
begin
  HashSize := LongWord(FCapacity);
  if not FCaseSensitive then
  begin
    X := G_CRC32_Text(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameText(P, Pointer(Key)) then
      begin
        Result := FValues^[X];
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end else
  begin
    X := G_CRC32_Str(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameStr(P, Pointer(Key)) then
      begin
        Result := FValues^[X];
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end;
  Result := nil;
end;

procedure TStringHashtable.SetItem(const Key: AnsiString; Value: Pointer);
var
  X, HashSize, HashStep: LongWord;
  L: Integer;
  P: Pointer;
  O: Pointer;
begin
  HashSize := LongWord(FCapacity);
  L := -1;
  if not FCaseSensitive then
  begin
    X := G_CRC32_Text(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if (P <> nil) and (P <> MissingStringHashKey) then
      begin
        if G_SameText(P, Pointer(Key)) then
        begin
          if not FOwnValues then
            FValues^[X] := Value
          else
          begin
            O := FValues^[X];
            if O <> Value then
            begin
              FValues^[X] := Value;
              TObject(O).Free;
            end;
          end;
          Exit;
        end;
      end else
      begin
        if L < 0 then
          L := X;
        if P = nil then
          Break;
      end;
      Inc(X, HashStep);
    end;
  end else
  begin
    X := G_CRC32_Str(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if (P <> nil) and (P <> MissingStringHashKey) then
      begin
        if G_SameStr(P, Pointer(Key)) then
        begin
          if not FOwnValues then
            FValues^[X] := Value
          else
          begin
            O := FValues^[X];
            if O <> Value then
            begin
              FValues^[X] := Value;
              TObject(O).Free;
            end;
          end;
          Exit;
        end;
      end else
      begin
        if L < 0 then
          L := X;
        if P = nil then
          Break;
      end;
      Inc(X, HashStep);
    end;
  end;
  if Pointer(FKeys^[L]) <> nil then
    Pointer(FKeys^[L]) := nil
  else
  begin
    if FUsedCount >= FMaxCount then
    begin
      if FCount + FCount > FUsedCount then
        L := G_EnlargePrimeCapacity(FCapacity)
      else
        L := FCapacity;
      SetCapacity(L);
      L := GetIndex(Pointer(Key));
    end;
    Inc(FUsedCount);
  end;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  Inc(FCount);
end;

procedure TStringHashtable.EnsureCapacity(Capacity: Integer);
begin
  if FMaxCount < Capacity + FUsedCount - FCount then
    SetCapacity(G_EnlargePrimeCapacity((Capacity * 7) div 5));
end;

procedure TStringHashtable.Add(const Key: AnsiString; Value: Pointer);
var
  X, HashSize, HashStep: LongWord;
  L: Integer;
  P: Pointer;
begin
  HashSize := LongWord(FCapacity);
  L := -1;
  if not FCaseSensitive then
  begin
    X := G_CRC32_Text(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if (P <> nil) and (P <> MissingStringHashKey) then
      begin
        if G_SameText(P, Pointer(Key)) then
          RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TStringHashtable');
      end else
      begin
        if L < 0 then
          L := X;
        if P = nil then
          Break;
      end;
      Inc(X, HashStep);
    end;
  end else
  begin
    X := G_CRC32_Str(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if (P <> nil) and (P <> MissingStringHashKey) then
      begin
        if G_SameStr(P, Pointer(Key)) then
          RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TStringHashtable');
      end else
      begin
        if L < 0 then
          L := X;
        if P = nil then
          Break;
      end;
      Inc(X, HashStep);
    end;
  end;
  if Pointer(FKeys^[L]) <> nil then
    Pointer(FKeys^[L]) := nil
  else
  begin
    if FUsedCount >= FMaxCount then
    begin
      if FCount + FCount > FUsedCount then
        L := G_EnlargePrimeCapacity(FCapacity)
      else
        L := FCapacity;
      SetCapacity(L);
      L := GetIndex(Pointer(Key));
    end;
    Inc(FUsedCount);
  end;
  FKeys^[L] := Key;
  FValues^[L] := Value;
  Inc(FCount);
end;

function TStringHashtable.Contains(const Key: AnsiString): Boolean;
var
  X, HashSize, HashStep: LongWord;
  P: Pointer;
begin
  HashSize := LongWord(FCapacity);
  if not FCaseSensitive then
  begin
    X := G_CRC32_Text(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameText(P, Pointer(Key)) then
      begin
        Result := True;
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end else
  begin
    X := G_CRC32_Str(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameStr(P, Pointer(Key)) then
      begin
        Result := True;
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end;
  Result := False;
end;

procedure TStringHashtable.Remove(const Key: AnsiString);
var
  X, HashSize, HashStep: LongWord;
  P: Pointer;
begin
  HashSize := LongWord(FCapacity);
  if not FCaseSensitive then
  begin
    X := G_CRC32_Text(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameText(P, Pointer(Key)) then
      begin
        FKeys^[X] := '';
        Pointer(FKeys^[X]) := MissingStringHashKey;
        if FOwnValues then
          TObject(FValues^[X]).Free;
        Dec(FCount);
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end else
  begin
    X := G_CRC32_Str(Key);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      P := Pointer(FKeys^[X]);
      if P = nil then
        Break;
      if (P <> MissingStringHashKey) and G_SameStr(P, Pointer(Key)) then
      begin
        FKeys^[X] := '';
        Pointer(FKeys^[X]) := MissingStringHashKey;
        if FOwnValues then
          TObject(FValues^[X]).Free;
        Dec(FCount);
        Exit;
      end;
      Inc(X, HashStep);
    end;
  end;
end;

procedure TStringHashtable.Clear(SuppressDisposingValues: Boolean);
var
  I: Integer;
  P: Pointer;
begin
  for I := FCapacity - 1 downto 0 do
  begin
    P := Pointer(FKeys^[I]);
    if (P <> nil) and (P <> MissingStringHashKey) then
    begin
      if FOwnValues and not SuppressDisposingValues then
        TObject(FValues^[I]).Free;
      FKeys^[I] := '';
    end;
  end;
  G_FillLongs(0, FKeys, FCapacity);
  FCount := 0;
  FUsedCount := 0;
end;

{ TStringRedBlackTree }

constructor TStringRedBlackTree.Create(CaseSensitive: Boolean);
begin
  FRoot := StringRBTreeNil;
  FCaseSensitive := CaseSensitive; 
end;

destructor TStringRedBlackTree.Destroy;
begin
  Clear(False);
end;

function TStringRedBlackTree.GetRoot: PStringRBTreeNode;
begin
  if FRoot <> StringRBTreeNil then
    Result := FRoot
  else
    Result := nil;
end;

procedure TStringRedBlackTree.RotateLeft(Node: PStringRBTreeNode);
var
  PT: PStringRBTreeNode;
begin
  PT := Node^.Right;
  Node^.Right := PT^.Left;
  if PT^.Left <> StringRBTreeNil then
    PT^.Left^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = StringRBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Left then
    Node^.Parent^.Left := PT
  else
    Node^.Parent^.Right := PT;
  PT^.Left := Node;
  Node^.Parent := PT;
end;

procedure TStringRedBlackTree.RotateRight(Node: PStringRBTreeNode);
var
  PT: PStringRBTreeNode;
begin
  PT := Node^.Left;
  Node^.Left := PT^.Right;
  if PT^.Right <> StringRBTreeNil then
    PT^.Right^.Parent := Node;
  PT^.Parent := Node^.Parent;
  if Node^.Parent = StringRBTreeNil then
    FRoot := PT
  else if Node = Node^.Parent^.Right then
    Node^.Parent^.Right := PT
  else
    Node^.Parent^.Left := PT;
  PT^.Right := Node;
  Node^.Parent := PT;
end;

procedure TStringRedBlackTree.InsertFixUp(Node: PStringRBTreeNode);
var
  PT: PStringRBTreeNode;
begin
  while (Node <> FRoot) and Node^.Parent.IsRed do
  begin
    PT := Node^.Parent^.Parent;
    if Node^.Parent = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Right then
        begin
          Node := Node^.Parent;
          RotateLeft(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateRight(PT);
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        Node^.Parent.IsRed := False;
        PT^.IsRed := False;
        Node := Node^.Parent^.Parent;
        Node^.IsRed := True;
      end else
      begin
        if Node = Node^.Parent^.Left then
        begin
          Node := Node^.Parent;
          RotateRight(Node);
        end;
        Node^.Parent^.IsRed := False;
        PT := Node^.Parent^.Parent;
        PT^.IsRed := True;
        RotateLeft(PT);
      end;
    end;
  end;
  FRoot.IsRed := False;
end;

procedure TStringRedBlackTree.RemoveFixUp(Node: PStringRBTreeNode);
var
  PT: PStringRBTreeNode;
begin
  while (Node <> FRoot) and not Node^.IsRed do
  begin
    PT := Node^.Parent;
    if Node = PT^.Left then
    begin
      PT := PT^.Right;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateLeft(Node^.Parent);
        PT := Node^.Parent^.Right;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Right^.IsRed then
        begin
          PT^.Left^.IsRed := False;
          PT^.IsRed := True;
          RotateRight(PT);
          PT := Node^.Parent^.Right;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Right^.IsRed := False;
        RotateLeft(Node^.Parent);
        Node := FRoot;
      end;
    end else
    begin
      PT := PT^.Left;
      if PT^.IsRed then
      begin
        PT^.IsRed := False;
        Node^.Parent^.IsRed := True;
        RotateRight(Node^.Parent);
        PT := Node^.Parent^.Left;
      end;
      if not PT^.Left^.IsRed and not PT^.Right^.IsRed then
      begin
        PT^.IsRed := True;
        Node := Node^.Parent;
      end else
      begin
        if not PT^.Left^.IsRed then
        begin
          PT^.Right^.IsRed := False;
          PT^.IsRed := True;
          RotateLeft(PT);
          PT := Node^.Parent^.Left;
        end;
        PT^.IsRed := Node^.Parent^.IsRed;
        Node^.Parent^.IsRed := False;
        PT^.Left^.IsRed := False;
        RotateRight(Node^.Parent);
        Node := FRoot;
      end;
    end;
  end;
  Node^.IsRed := False;
end;

function TStringRedBlackTree.GetItem(const Key: AnsiString): Pointer;
var
  P: PStringRBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    Result := P^.Value
  else
    Result := nil;
end;

procedure TStringRedBlackTree.SetItem(const Key: AnsiString; Value: Pointer);
var
  P: PStringRBTreeNode;
  PP: Pointer;
  C: Integer;
begin
  PP := StringRBTreeNil;
  P := FRoot;
  repeat
    if P = StringRBTreeNil then
    begin
      InsertNode(PP, Key, Value);
      Exit;
    end;
    PP := P;
    if not FCaseSensitive then
      C := G_CompareText(Key, P^.Key)
    else
      C := G_CompareStr(Key, P^.Key);
    if C < 0 then
      P := P^.Left
    else if C <> 0 then
      P := P^.Right
    else
      Break;
  until False;
  if not FOwnValues then
    P^.Value := Value
  else
  begin
    PP := P^.Value;
    if PP <> Pointer(Value) then
    begin
      P^.Value := Value;
      TObject(PP).Free;
    end;
  end;
end;

function TStringRedBlackTree.GetFirstNode: PStringRBTreeNode;
begin
  Result := FRoot;
  if Result <> StringRBTreeNil then
    while Result^.Left <> StringRBTreeNil do
      Result := Result^.Left
  else
    Result := nil;
end;

function TStringRedBlackTree.GetLastNode: PStringRBTreeNode;
begin
  Result := FRoot;
  if Result <> StringRBTreeNil then
    while Result^.Right <> StringRBTreeNil do
      Result := Result^.Right
  else
    Result := nil;
end;

function TStringRedBlackTree.InsertNode(Parent: PStringRBTreeNode;
  const Key: AnsiString; Value: Pointer): PStringRBTreeNode;
begin
  GetMem(Result, SizeOf(TStringRBTreeNode));
  Pointer(Result^.Key) := nil;
  Result^.Key := Key;
  Result^.Parent := Parent;
  Result^.Left := StringRBTreeNil;
  Result^.Right := StringRBTreeNil;
  Result^.Value := Value;
  Result^.OwnerTree := Self;
  Result^.IsRed := True;
  if Parent = StringRBTreeNil then
    FRoot := Result
  else if not FCaseSensitive then
  begin
    if G_CompareText(Key, Parent^.Key) < 0 then
      Parent^.Left := Result
    else
      Parent^.Right := Result;
  end else
  begin
    if G_CompareStr(Key, Parent^.Key) < 0 then
      Parent^.Left := Result
    else
      Parent^.Right := Result;
  end;
  InsertFixUp(Result);
end;

function TStringRedBlackTree.Add(const Key: AnsiString; Value: Pointer): PStringRBTreeNode;
var
  P: PStringRBTreeNode;
  C: Integer;
begin
  Result := StringRBTreeNil;
  P := FRoot;
  repeat
    if P = StringRBTreeNil then
    begin
      Result := InsertNode(Result, Key, Value);
      Exit;
    end;
    Result := P;
    if not FCaseSensitive then
      C := G_CompareText(Key, P^.Key)
    else
      C := G_CompareStr(Key, P^.Key);
    if C < 0 then
      P := P^.Left
    else if C <> 0 then
      P := P^.Right
    else
      Break;
  until False;
  RaiseErrorFmt(SErrKeyDuplicatesInAssociationList, 'TStringRedBlackTree');
end;

function TStringRedBlackTree.SearchNode(const Key: AnsiString): PStringRBTreeNode;
var
  C: Integer;
begin
  Result := FRoot;
  while Result <> StringRBTreeNil do
  begin
    if not FCaseSensitive then
      C := G_CompareText(Key, Result^.Key)
    else
      C := G_CompareStr(Key, Result^.Key);
    if C < 0 then
      Result := Result^.Left
    else if C <> 0 then
      Result := Result^.Right
    else
      Exit;
  end;
  Result := nil;
end;

function TStringRedBlackTree.SearchFirstGreater(const Key: AnsiString): PStringRBTreeNode;
var
  P: PStringRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  if not FCaseSensitive then
  begin
    while P <> StringRBTreeNil do
      if G_CompareText(Key, P^.Key) >= 0 then
        P := P^.Right
      else
      begin
        Result := P;
        P := P^.Left;
      end;
  end else
  begin
    while P <> StringRBTreeNil do
      if G_CompareStr(Key, P^.Key) >= 0 then
        P := P^.Right
      else
      begin
        Result := P;
        P := P^.Left;
      end;
  end;
end;

function TStringRedBlackTree.SearchFirstGreaterOrEqual(const Key: AnsiString): PStringRBTreeNode;
var
  P: PStringRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  if not FCaseSensitive then
  begin
    while P <> StringRBTreeNil do
      if G_CompareText(Key, P^.Key) > 0 then
        P := P^.Right
      else
      begin
        Result := P;
        P := P^.Left;
      end;
  end else
  begin
    while P <> StringRBTreeNil do
      if G_CompareStr(Key, P^.Key) > 0 then
        P := P^.Right
      else
      begin
        Result := P;
        P := P^.Left;
      end;
  end;
end;

function TStringRedBlackTree.SearchLastLesser(const Key: AnsiString): PStringRBTreeNode;
var
  P: PStringRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  if not FCaseSensitive then
  begin
    while P <> StringRBTreeNil do
      if G_CompareText(Key, P^.Key) <= 0 then
        P := P^.Left
      else
      begin
        Result := P;
        P := P^.Right;
      end;
  end else
  begin
    while P <> StringRBTreeNil do
      if G_CompareStr(Key, P^.Key) <= 0 then
        P := P^.Left
      else
      begin
        Result := P;
        P := P^.Right;
      end;
  end;
end;

function TStringRedBlackTree.SearchLastLesserOrEqual(const Key: AnsiString): PStringRBTreeNode;
var
  P: PStringRBTreeNode;
begin
  Result := nil;
  P := FRoot;
  if not FCaseSensitive then
  begin
    while P <> StringRBTreeNil do
      if G_CompareText(Key, P^.Key) < 0 then
        P := P^.Left
      else
      begin
        Result := P;
        P := P^.Right;
      end;
  end else
  begin
    while P <> StringRBTreeNil do
      if G_CompareStr(Key, P^.Key) < 0 then
        P := P^.Left
      else
      begin
        Result := P;
        P := P^.Right;
      end;
  end;
end;

function TStringRedBlackTree.NextNode(Node: PStringRBTreeNode): PStringRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Right;
  if Result <> StringRBTreeNil then
    while Result^.Left <> StringRBTreeNil do
      Result := Result^.Left
  else
  begin
    Result := Node^.Parent;
    while Result <> StringRBTreeNil do
      if Node = Result^.Right then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

function TStringRedBlackTree.PreviousNode(Node: PStringRBTreeNode): PStringRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  Result := Node^.Left;
  if Result <> StringRBTreeNil then
    while Result^.Right <> StringRBTreeNil do
      Result := Result^.Right
  else
  begin
    Result := Node^.Parent;
    while Result <> StringRBTreeNil do
      if Node = Result^.Left then
      begin
        Node := Result;
        Result := Result^.Parent;
      end else
        Exit;
    Result := nil;
  end;
end;

procedure TStringRedBlackTree.Remove(const Key: AnsiString);
var
  P: PStringRBTreeNode;
begin
  P := SearchNode(Key);
  if P <> nil then
    RemoveNode(P);
end;

procedure TStringRedBlackTree.RemoveNode(Node: PStringRBTreeNode);
var
  P, PT: PStringRBTreeNode;
begin
  if (Node = nil) or (Node^.OwnerTree <> Self) then
    RaiseError(SErrNodeBelongsToAnotherTree);
  if (Node^.Left = StringRBTreeNil) or (Node^.Right = StringRBTreeNil) then
    P := Node
  else
    P := NextNode(Node);
  if P^.Left <> StringRBTreeNil then
    PT := P^.Left
  else
    PT := P^.Right;
  PT^.Parent := P^.Parent;
  if P^.Parent = StringRBTreeNil then
    FRoot := PT
  else if P^.Parent^.Left = P then
    P^.Parent^.Left := PT
  else
    P^.Parent^.Right := PT;
  if FOwnValues then
    TObject(Node^.Value).Free;
  if P <> Node then
  begin
    Node^.Key := P^.Key;
    Node^.Value := P^.Value;
  end;
  if not P^.IsRed then
    RemoveFixUp(PT);
  P^.Key := '';
  FreeMem(P);
end;

procedure FreeStringRBTValue(Node: PStringRBTreeNode);
begin
  if Node^.Left <> StringRBTreeNil then
    FreeStringRBTValue(Node^.Left);
  if Node^.Right <> StringRBTreeNil then
    FreeStringRBTValue(Node^.Right);
  TObject(Node^.Value).Free;
end;

procedure FreeStringRBTNode(Node: PStringRBTreeNode);
begin
  if Node^.Left <> StringRBTreeNil then
    FreeStringRBTNode(Node^.Left);
  if Node^.Right <> StringRBTreeNil then
    FreeStringRBTNode(Node^.Right);
  Node^.Key := '';
  FreeMem(Node);
end;

procedure TStringRedBlackTree.Clear(SuppressDisposingValues: Boolean);
begin
  if FRoot <> StringRBTreeNil then
  begin
    if FOwnValues and not SuppressDisposingValues then
      FreeStringRBTValue(FRoot);
    FreeStringRBTNode(FRoot);
  end;
  FRoot := StringRBTreeNil;
end;

{ TLinkedList }

destructor TLinkedList.Destroy;
begin
  Clear(False);
end;

procedure TLinkedList.SwitchOwner(FirstNode, LastNode: PLinkedListNode);
var
  Owner: TLinkedList;
begin
  Owner := FirstNode^.OwnerList;
  if LastNode^.OwnerList <> Owner then
    RaiseError(SErrNodeBelongsToAnotherList);
  if FirstNode <> Owner.FHeadNode then
    FirstNode^.PrevNode^.NextNode := LastNode^.NextNode
  else
  begin
    Owner.FHeadNode := LastNode^.NextNode;
    if Owner.FHeadNode <> nil then
      Owner.FHeadNode^.PrevNode := nil;
  end;
  if LastNode <> Owner.FTailNode then
    LastNode^.NextNode^.PrevNode := FirstNode^.PrevNode
  else
  begin
    Owner.FTailNode := FirstNode^.PrevNode;
    if Owner.FTailNode <> nil then
      Owner.FTailNode^.NextNode := nil;
  end;
  if Owner <> Self then
  begin
    FirstNode^.OwnerList := Self;
    while FirstNode <> LastNode do
    begin
      FirstNode := FirstNode^.NextNode;
      FirstNode^.OwnerList := Self;
    end;
  end;
end;

function TLinkedList.AddHead(Value: Pointer): PLinkedListNode;
var
  P: PLinkedListNode;
begin
  GetMem(P, SizeOf(TLinkedListNode));
  P^.Value := Value;
  P^.OwnerList := Self;
  P^.PrevNode := nil;
  P^.NextNode := FHeadNode;
  if FHeadNode <> nil then
    FHeadNode^.PrevNode := P
  else
    FTailNode := P;
  FHeadNode := P;
  Result := P;
end;

procedure TLinkedList.AddHead(FirstNode, LastNode: PLinkedListNode);
begin
  SwitchOwner(FirstNode, LastNode);
  FirstNode^.PrevNode := nil;
  LastNode^.NextNode := FHeadNode;
  if FHeadNode <> nil then
    FHeadNode^.PrevNode := LastNode
  else
    FTailNode := LastNode;
  FHeadNode := FirstNode;
end;

function TLinkedList.AddTail(Value: Pointer): PLinkedListNode;
var
  P: PLinkedListNode;
begin
  GetMem(P, SizeOf(TLinkedListNode));
  P^.Value := Value;
  P^.OwnerList := Self;
  P^.PrevNode := FTailNode;
  P^.NextNode := nil;
  if FTailNode <> nil then
    FTailNode^.NextNode := P
  else
    FHeadNode := P;
  FTailNode := P;
  Result := P;
end;

procedure TLinkedList.AddTail(FirstNode, LastNode: PLinkedListNode);
begin
  SwitchOwner(FirstNode, LastNode);
  FirstNode^.PrevNode := FTailNode;
  LastNode^.NextNode := nil;
  if FTailNode <> nil then
    FTailNode^.NextNode := FirstNode
  else
    FHeadNode := FirstNode;
  FTailNode := LastNode;
end;

function TLinkedList.InsertBefore(Node: PLinkedListNode; Value: Pointer): PLinkedListNode;
var
  P: PLinkedListNode;
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  GetMem(P, SizeOf(TLinkedListNode));
  P^.Value := Value;
  P^.OwnerList := Self;
  P^.PrevNode := Node^.PrevNode;
  P^.NextNode := Node;
  Node^.PrevNode := P;
  if P^.PrevNode <> nil then
    P^.PrevNode^.NextNode := P
  else
    FHeadNode := P;
  Result := P;
end;

procedure TLinkedList.InsertBefore(Node, FirstNode, LastNode: PLinkedListNode);
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  SwitchOwner(FirstNode, LastNode);
  FirstNode^.PrevNode := Node^.PrevNode;
  LastNode^.NextNode := Node;
  Node^.PrevNode := LastNode;
  if FirstNode^.PrevNode <> nil then
    FirstNode^.PrevNode^.NextNode := FirstNode
  else
    FHeadNode := FirstNode;
end;

function TLinkedList.InsertAfter(Node: PLinkedListNode; Value: Pointer): PLinkedListNode;
var
  P: PLinkedListNode;
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  GetMem(P, SizeOf(TLinkedListNode));
  P^.Value := Value;
  P^.OwnerList := Self;
  P^.PrevNode := Node;
  P^.NextNode := Node^.NextNode;
  Node^.NextNode := P;
  if P^.NextNode <> nil then
    P^.NextNode^.PrevNode := P
  else
    FTailNode := P;
  Result := P;
end;

procedure TLinkedList.InsertAfter(Node, FirstNode, LastNode: PLinkedListNode);
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  SwitchOwner(FirstNode, LastNode);
  FirstNode^.PrevNode := Node;
  LastNode^.NextNode := Node^.NextNode;
  Node^.NextNode := FirstNode;
  if LastNode^.NextNode <> nil then
    LastNode^.NextNode^.PrevNode := LastNode
  else
    FTailNode := LastNode;
end;

function TLinkedList.IsEmpty: Boolean;
begin
  Result := FHeadNode = nil;
end;

function TLinkedList.PopHeadValue: Pointer;
var
  P: PLinkedListNode;
begin
  P := FHeadNode;
  if P = nil then
    RaiseError(SErrPeekFromEmptyList);
  FHeadNode := P^.NextNode;
  if FHeadNode <> nil then
    FHeadNode^.PrevNode := nil
  else
    FTailNode := nil;
  Result := P^.Value;
  FreeMem(P);
end;

function TLinkedList.PopTailValue: Pointer;
var
  P: PLinkedListNode;
begin
  P := FTailNode;
  if P = nil then
    RaiseError(SErrPeekFromEmptyList);
  FTailNode := P^.PrevNode;
  if FTailNode <> nil then
    FTailNode^.NextNode := nil
  else
    FHeadNode := nil;
  Result := P^.Value;
  FreeMem(P);
end;

function TLinkedList.PopValue(Node: PLinkedListNode): Pointer;
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  if Node = FHeadNode then
  begin
    FHeadNode := Node^.NextNode;
    if FHeadNode <> nil then
      FHeadNode^.PrevNode := nil
    else
      FTailNode := nil;
  end
  else if Node = FTailNode then
  begin
    FTailNode := Node^.PrevNode;
    if FTailNode <> nil then
      FTailNode^.NextNode := nil
    else
      FHeadNode := nil;
  end else
  begin
    Node^.PrevNode^.NextNode := Node^.NextNode;
    Node^.NextNode^.PrevNode := Node^.PrevNode;
  end;
  Result := Node^.Value;
  FreeMem(Node);
end;

procedure TLinkedList.RemoveHead;
var
  P: PLinkedListNode;
begin
  P := FHeadNode;
  if P <> nil then
  begin
    FHeadNode := P^.NextNode;
    if FHeadNode <> nil then
      FHeadNode^.PrevNode := nil
    else
      FTailNode := nil;
    if FOwnValues then
      TObject(P^.Value).Free;
    FreeMem(P);
  end;
end;

procedure TLinkedList.RemoveTail;
var
  P: PLinkedListNode;
begin
  P := FTailNode;
  if P <> nil then
  begin
    FTailNode := P^.PrevNode;
    if FTailNode <> nil then
      FTailNode^.NextNode := nil
    else
      FHeadNode := nil;
    if FOwnValues then
      TObject(P^.Value).Free;
    FreeMem(P);
  end;
end;

procedure TLinkedList.Remove(Node: PLinkedListNode);
begin
  if (Node = nil) or (Node^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  if Node = FHeadNode then
  begin
    FHeadNode := Node^.NextNode;
    if FHeadNode <> nil then
      FHeadNode^.PrevNode := nil
    else
      FTailNode := nil;
  end
  else if Node = FTailNode then
  begin
    FTailNode := Node^.PrevNode;
    if FTailNode <> nil then
      FTailNode^.NextNode := nil
    else
      FHeadNode := nil;
  end else
  begin
    Node^.PrevNode^.NextNode := Node^.NextNode;
    Node^.NextNode^.PrevNode := Node^.PrevNode;
  end;
  if FOwnValues then
    TObject(Node^.Value).Free;
  FreeMem(Node);
end;

procedure TLinkedList.Remove(FirstNode, LastNode: PLinkedListNode);
var
  N: PLinkedListNode;
begin
  if (FirstNode = nil) or (FirstNode^.OwnerList <> Self) or
    (LastNode = nil) or (LastNode^.OwnerList <> Self) then
    RaiseError(SErrNodeBelongsToAnotherList);
  if FirstNode = FHeadNode then
  begin
    FHeadNode := LastNode^.NextNode;
    if FHeadNode <> nil then
      FHeadNode^.PrevNode := nil
    else
      FTailNode := nil;
  end
  else if LastNode = FTailNode then
  begin
    FTailNode := FirstNode^.PrevNode;
    if FTailNode <> nil then
      FTailNode^.NextNode := nil
    else
      FHeadNode := nil;
  end else
  begin
    FirstNode^.PrevNode^.NextNode := LastNode^.NextNode;
    LastNode^.NextNode^.PrevNode := FirstNode^.PrevNode;
  end;
  LastNode^.NextNode := nil;
  repeat
    N := FirstNode^.NextNode;
    if FOwnValues then
      TObject(FirstNode^.Value).Free;
    FreeMem(FirstNode);
    FirstNode := N;
  until FirstNode = nil;
end;

procedure TLinkedList.Clear(SuppressDisposingValues: Boolean);
var
  P, N: PLinkedListNode;
begin
  P := FHeadNode;
  while P <> nil do
  begin
    N := P^.NextNode;
    if FOwnValues and not SuppressDisposingValues then
      TObject(P^.Value).Free;
    FreeMem(P);
    P := N;
  end;
  FHeadNode := nil;
  FTailNode := nil;
end;

{ TDoubleEndedQueue }

const
  ChunkIndexShift = 7;
  ChunkIndexMask = 127;
  ChunkCapacity = 128;

destructor TDoubleEndedQueue.Destroy;
begin
  if FChunkListCapacity > 0 then
  begin
    Clear(False);
    FreeMem(FChunkList);
  end;
end;

procedure TDoubleEndedQueue.UpdateChunkCount(NewCount: Integer);
var
  C: Integer;
begin
  C := G_EnlargeCapacity(NewCount);
  if (FChunkListCapacity >= NewCount) and (FChunkListCapacity <= C) then
    FChunkListOffset := (FChunkListCapacity - NewCount) shr 1
  else
  begin
    if FChunkListCapacity > 0 then
      FreeMem(FChunkList);
    FChunkListCapacity := NewCount;
    if NewCount > 0 then
      GetMem(FChunkList, NewCount * SizeOf(Pointer))
    else
      FChunkList := nil;
    FChunkListOffset := 0;
  end;
  FChunkCount := NewCount;
  C := FChunkListOffset;
  Inc(NewCount, C);
  while C < NewCount do
  begin
    GetMem(FChunkList^[C], ChunkCapacity * SizeOf(Pointer));
    Inc(C);
  end;
end;

function TDoubleEndedQueue.GetItem(Index: Integer): Pointer;
begin
  Inc(Index, FStart);
  Result := PPointerItemList(FChunkList^[Index shr ChunkIndexShift + FChunkListOffset])^
    [Index and ChunkIndexMask];
end;

procedure TDoubleEndedQueue.SetItem(Index: Integer; P: Pointer);
var
  X: PPointer;
  O: Pointer;
begin
  Inc(Index, FStart);
  if not FOwnItems then
    PPointerItemList(FChunkList^[Index shr ChunkIndexShift + FChunkListOffset])^
      [Index and ChunkIndexMask] := P
  else
  begin
    X := @PPointerItemList(FChunkList^[Index shr ChunkIndexShift + FChunkListOffset])^
      [Index and ChunkIndexMask];
    O := X^;
    if O <> P then
    begin
      X^ := P;
      TObject(O).Free;
    end;
  end;
end;

procedure TDoubleEndedQueue.GrowFront;
var
  NewChunks: PPointerItemList;
  N, C: Integer;
begin
  N := FChunkListCapacity;
  if FChunkCount < (N shr 1) + (N shr 3) then
  begin
    N := N - (N shr 3) - FChunkCount;
    if FChunkCount > 0 then
      G_MoveLongs(@FChunkList^[FChunkListOffset], @FChunkList^[N], FChunkCount);
    FChunkListOffset := N;
  end else
  begin
    N := G_EnlargeCapacity(FChunkListCapacity);
    GetMem(NewChunks, N * SizeOf(Pointer));
    C := N;
    N := N - (N shr 3) - FChunkCount;
    if FChunkListCapacity > 0 then
    begin
      if FChunkCount > 0 then
        G_MoveLongs(@FChunkList^[FChunkListOffset], @NewChunks^[N], FChunkCount);
      FreeMem(FChunkList);
    end;
    FChunkListOffset := N;
    FChunkListCapacity := C;
    FChunkList := NewChunks;
  end;
end;

procedure TDoubleEndedQueue.GrowBack;
var
  NewChunks: PPointerItemList;
  N, C: Integer;
begin
  N := FChunkListCapacity;
  if FChunkCount < (N shr 1) + (N shr 3) then
  begin
    N := N shr 3;
    if FChunkCount > 0 then
      G_MoveLongs(@FChunkList^[FChunkListOffset], @FChunkList^[N], FChunkCount);
    FChunkListOffset := N;
  end else
  begin
    N := G_EnlargeCapacity(FChunkListCapacity);
    GetMem(NewChunks, N * SizeOf(Pointer));
    C := N;
    N := N shr 3;
    if FChunkListCapacity > 0 then
    begin
      if FChunkCount > 0 then
        G_MoveLongs(@FChunkList^[FChunkListOffset], @NewChunks^[N], FChunkCount);
      FreeMem(FChunkList);
    end;
    FChunkListOffset := N;
    FChunkListCapacity := C;
    FChunkList := NewChunks;
  end;
end;

procedure TDoubleEndedQueue.Load(DoubleEndedQueue: TDoubleEndedQueue;
  SuppressDisposingItems: Boolean);
var
  I, J, N1, N2, C: Integer;
begin
  Clear(SuppressDisposingItems);
  UpdateChunkCount(DoubleEndedQueue.FChunkCount);
  if DoubleEndedQueue.FCount = 0 then
    Exit;
  N1 := DoubleEndedQueue.FChunkListOffset;
  N2 := FChunkListOffset;
  FStart := DoubleEndedQueue.FStart;
  FCount := DoubleEndedQueue.FCount;
  I := FStart;
  C := FStart + FCount;
  if FStart >= ChunkCapacity then
  begin
    Dec(I, ChunkCapacity);
    Dec(C, ChunkCapacity);
    Inc(N1);
    Inc(N2);
  end;
  if C >= ChunkCapacity then
    J := ChunkCapacity - I
  else
    J := C - I;
  G_CopyLongs(@PPointerItemList(DoubleEndedQueue.FChunkList^[N1])^[I],
    @PPointerItemList(FChunkList^[N2])^[I], J);
  Dec(C, ChunkCapacity);
  Inc(N1);
  Inc(N2);
  while C > 0 do
  begin
    if C >= ChunkCapacity then
      J := ChunkCapacity
    else
      J := C;
    G_CopyLongs(DoubleEndedQueue.FChunkList^[N1], FChunkList^[N2], J);
    Dec(C, ChunkCapacity);
    Inc(N1);
    Inc(N2);
  end;
end;

procedure TDoubleEndedQueue.Load(Items: Pointer; Count: Integer;
  SuppressDisposingItems: Boolean);
var
  I, J: Integer;
begin
  Clear(SuppressDisposingItems);
  UpdateChunkCount((Count + ChunkCapacity - 1) shr ChunkIndexShift);
  if Count = 0 then
    Exit;
  I := FChunkListOffset;
  FStart := 0;
  FCount := Count;
  while Count > 0 do
  begin
    if Count >= ChunkCapacity then
      J := ChunkCapacity
    else
      J := Count;
    G_CopyLongs(Items, FChunkList^[I], J);
    Inc(LongWord(Items), ChunkCapacity * SizeOf(Pointer));
    Dec(Count, ChunkCapacity);
    Inc(I);
  end;
end;

function TDoubleEndedQueue.Save(Items: Pointer): Integer;
var
  I, J, C, N: Integer;
begin
  Result := FCount;
  if FCount = 0 then
    Exit;
  I := FStart;
  C := I + FCount;
  N := FChunkListOffset;
  if FStart >= ChunkCapacity then
  begin
    Dec(I, ChunkCapacity);
    Dec(C, ChunkCapacity);
    Inc(N);
  end;
  if C >= ChunkCapacity then
    J := ChunkCapacity - I
  else
    J := C - I;
  G_CopyLongs(@PPointerItemList(FChunkList^[N])^[I], Items, J);
  Inc(LongWord(Items), J * SizeOf(Pointer));
  Dec(C, ChunkCapacity);
  Inc(N);
  while C > 0 do
  begin
    if C >= ChunkCapacity then
      J := ChunkCapacity
    else
      J := C;
    G_CopyLongs(FChunkList^[N], Items, J);
    Inc(LongWord(Items), ChunkCapacity * SizeOf(Pointer));
    Dec(C, ChunkCapacity);
    Inc(N);
  end;
end;

function TDoubleEndedQueue.IsEmpty: Boolean;
begin
  Result := FCount = 0;
end;

procedure TDoubleEndedQueue.PushFront(P: Pointer);
var
  I: Integer;
begin
  I := FStart;
  if I = 0 then
  begin
    if FChunkListOffset = 0 then
      GrowFront;
    Dec(FChunkListOffset);
    GetMem(FChunkList^[FChunkListOffset], ChunkCapacity * SizeOf(Pointer));
    Inc(FChunkCount);
    I := ChunkCapacity;
  end;
  Dec(I);
  PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
    [I and ChunkIndexMask] := P;
  FStart := I;
  Inc(FCount);
end;

procedure TDoubleEndedQueue.PushBack(P: Pointer);
var
  C: Integer;
begin
  C := FStart + FCount;
  if C shr ChunkIndexShift = FChunkCount then
  begin
    if FChunkListOffset + FChunkCount = FChunkListCapacity then
      GrowBack;
    GetMem(FChunkList^[FChunkListOffset + FChunkCount], ChunkCapacity * SizeOf(Pointer));
    Inc(FChunkCount);
  end;
  PPointerItemList(FChunkList^[C shr ChunkIndexShift + FChunkListOffset])^
    [C and ChunkIndexMask] := P;
  Inc(FCount);
end;

function TDoubleEndedQueue.PopFront: Pointer;
var
  I: Integer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  I := FStart;
  Result := PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
    [I and ChunkIndexMask];
  Dec(FCount);
  Inc(I);
  if I < ChunkCapacity * 2 then
    FStart := I
  else
  begin
    FreeMem(FChunkList^[FChunkListOffset]);
    Inc(FChunkListOffset);
    Dec(FChunkCount);
    FStart := ChunkCapacity;
  end;
end;

function TDoubleEndedQueue.PopBack: Pointer;
var
  I, J: Integer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Dec(FCount);
  I := FStart + FCount;
  J := I and ChunkIndexMask;
  I := I shr ChunkIndexShift;
  Result := PPointerItemList(FChunkList^[I + FChunkListOffset])^[J];
  if (J = 0) and (I + 1 < FChunkCount) then
  begin
    Dec(FChunkCount);
    FreeMem(FChunkList^[FChunkListOffset + FChunkCount]);
  end;
end;

function TDoubleEndedQueue.PeekFront: Pointer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Result := PPointerItemList(FChunkList^[FStart shr ChunkIndexShift + FChunkListOffset])^
    [FStart and ChunkIndexMask];
end;

function TDoubleEndedQueue.PeekBack: Pointer;
var
  I: Integer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  I := FStart + FCount - 1;
  Result := PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
    [I and ChunkIndexMask];
end;

procedure TDoubleEndedQueue.Insert(Index: Integer; P: Pointer);
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Index < FCount shr 1 then
  begin
    PushFront(P);
    if Index <> 0 then
      Rotate(0, 1, Index + 1);
  end else
  begin
    PushBack(P);
    if Index < FCount - 1 then
      Rotate(Index, FCount - 1, FCount - Index);
  end;
end;

procedure TDoubleEndedQueue.Insert(Index: Integer; Items: Pointer; Count: Integer);
var
  I: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count > 0 then
    if Index < FCount shr 1 then
    begin
      I := Count;
      repeat
        Dec(I);
        PushFront(PPointerItemList(Items)^[I]);
      until I = 0;
      if Index <> 0 then
        Rotate(0, Count, Index + Count);
    end else
    begin
      I := 0;
      repeat
        PushBack(PPointerItemList(Items)^[I]);
        Inc(I);
      until I = Count;
      if Index < FCount - Count then
        Rotate(Index, FCount - Count, FCount - Index);
    end;
end;

procedure TDoubleEndedQueue.Insert(Index, Count: Integer; P: Pointer);
var
  I: Integer;
begin
  if LongWord(Index) > LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  I := Count;
  if I > 0 then
    if Index < FCount shr 1 then
    begin
      repeat
        PushFront(P);
        Dec(I);
      until I = 0;
      if Index <> 0 then
        Rotate(0, Count, Index + Count);
    end else
    begin
      repeat
        PushBack(P);
        Dec(I);
      until I = 0;
      if Index < FCount - Count then
        Rotate(Index, FCount - Count, FCount - Index);
    end;
end;

function TDoubleEndedQueue.ScanPointer(P: Pointer): Integer;
var
  I, J, C, N: Integer;
begin
  Result := -1;
  if FCount = 0 then
    Exit;
  I := FStart;
  C := FStart + FCount;
  N := FChunkListOffset;
  if FStart >= ChunkCapacity then
  begin
    Dec(I, ChunkCapacity);
    Dec(C, ChunkCapacity);
    Inc(N);
  end;
  if C >= ChunkCapacity then
    J := ChunkCapacity - I
  else
    J := C - I;
  Result := G_Scan_Pointer(P, @PPointerItemList(FChunkList^[N])^[I], J);
  if Result >= 0 then
    Exit;
  Dec(C, ChunkCapacity);
  Inc(N);
  while C > 0 do
  begin
    if C >= ChunkCapacity then
      J := ChunkCapacity
    else
      J := C;
    Result := G_Scan_Pointer(P, FChunkList^[N], J);
    if Result >= 0 then
    begin
      Inc(Result, (N - FChunkListOffset) * ChunkCapacity - FStart);
      Exit;
    end;
    Dec(C, ChunkCapacity);
    Inc(N);
  end;
end;

function TDoubleEndedQueue.Search(Value: Pointer; MatchFunction: TMatchFunction): Pointer;
var
  I, C: Integer;
begin
  I := FStart;
  C := I + FCount;
  while I < C do
  begin
    Result := PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
      [I and ChunkIndexMask];
    if MatchFunction(Value, Result) = 0 then
      Exit;
    Inc(I);
  end;
  Result := nil;
end;

function TDoubleEndedQueue.IndexOf(Value: Pointer; MatchFunction: TMatchFunction): Integer;
var
  I, C: Integer;
  P: Pointer;
begin
  I := FStart;
  C := I + FCount;
  while I < C do
  begin
    P := PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
      [I and ChunkIndexMask];
    if MatchFunction(Value, P) = 0 then
    begin
      Result := I - FStart;
      Exit;
    end;
    Inc(I);
  end;
  Result := -1;
end;

procedure TDoubleEndedQueue.Swap(Index1, Index2, Count: Integer);
begin
  if Index1 <> Index2 then
  begin
    Inc(Index1, FStart);
    Inc(Index2, FStart);
    while Count > 0 do
    begin
      G_Swap32(PPointerItemList(FChunkList^[Index1 shr ChunkIndexShift + FChunkListOffset])^
        [Index1 and ChunkIndexMask], PPointerItemList(FChunkList^
        [Index2 shr ChunkIndexShift + FChunkListOffset])^[Index2 and ChunkIndexMask]);
      Inc(Index1);
      Inc(Index2);
      Dec(Count);
    end;
  end;
end;

procedure TDoubleEndedQueue.Reverse(Index, Count: Integer);
var
  I, J: Integer;
begin
  I := Index + FStart;
  J := I + Count - 1;
  while I < J do
  begin
    G_Swap32(PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
      [I and ChunkIndexMask], PPointerItemList(FChunkList^
      [J shr ChunkIndexShift + FChunkListOffset])^[J and ChunkIndexMask]);
    Inc(I);
    Dec(J);
  end;
end;

procedure TDoubleEndedQueue.Rotate(FirstIndex, MiddleIndex, Count: Integer);
var
  I: Integer;
begin
  I := MiddleIndex - FirstIndex;
  if (I > 0) and (I < Count) then
    if I * 2 = Count then
      Swap(FirstIndex, MiddleIndex, I)
    else
    begin
      Reverse(FirstIndex, I);
      Reverse(MiddleIndex, Count - I);
      Reverse(FirstIndex, Count);
    end;
end;

procedure TDoubleEndedQueue.RandomShuffle(Index, Count: Integer; H: HMT);
var
  I: Integer;
  G: Boolean;
begin
  if H = nil then
  begin
    G_RandomInit(H);
    G := True;
  end else
    G := False;
  Inc(Count, Index);
  I := Index + 1;
  while I < Count do
  begin
    Swap(Integer(G_RandomUInt32(H, I - Index + 1)) + Index, I);
    Inc(I);
  end;
  if G then
    G_RandomDone(H);
end;

procedure TDoubleEndedQueue.RemoveFront;
var
  I: Integer;
begin
  if FCount > 0 then
  begin
    I := FStart;
    if FOwnItems then
      TObject(PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
      [I and ChunkIndexMask]).Free;
    Dec(FCount);
    Inc(I);
    if I < ChunkCapacity * 2 then
      FStart := I
    else
    begin
      FreeMem(FChunkList^[FChunkListOffset]);
      Inc(FChunkListOffset);
      Dec(FChunkCount);
      FStart := ChunkCapacity;
    end;
  end;
end;

procedure TDoubleEndedQueue.RemoveBack;
var
  I, J: Integer;
begin
  if FCount > 0 then
  begin
    Dec(FCount);
    I := FStart + FCount;
    J := I and ChunkIndexMask;
    I := I shr ChunkIndexShift;
    if FOwnItems then
      TObject(PPointerItemList(FChunkList^[I + FChunkListOffset])^[J]).Free;
    if (J = 0) and (I + 1 < FChunkCount) then
    begin
      Dec(FChunkCount);
      FreeMem(FChunkList^[FChunkListOffset + FChunkCount]);
    end;
  end;
end;

procedure TDoubleEndedQueue.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Index < FCount shr 1 then
  begin
    if Index > 0 then
      Rotate(0, Index, Index + 1);
    RemoveFront;
  end else
  begin
    if Index < FCount - 1 then
      Rotate(Index, Index + 1, FCount - Index);
    RemoveBack;
  end;
end;

procedure TDoubleEndedQueue.RemoveAt(Index, Count: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  if Count <= 0 then
    Exit;
  if Index < FCount - (Index + Count) then
  begin
    if Index > 0 then
      Rotate(0, Index, Index + Count);
    repeat
      RemoveFront;
      Dec(Count);
    until Count = 0;
  end else
  begin
    if Index < FCount - Count then
      Rotate(Index, Index + Count, FCount - Index);
    repeat
      RemoveBack;
      Dec(Count);
    until Count = 0;
  end;
end;

procedure TDoubleEndedQueue.Clear(SuppressDisposingItems: Boolean);
var
  I, C: Integer;
begin
  if FOwnItems and not SuppressDisposingItems then
  begin
    I := FStart;
    C := I + FCount;
    while I < C do
    begin
      TObject(PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
        [I and ChunkIndexMask]).Free;
      Inc(I);
    end;
  end;
  I := FChunkListOffset;
  C := I + FChunkCount;
  while I < C do
  begin
    FreeMem(FChunkList^[I]);
    Inc(I);
  end;
  FChunkCount := 0;
  FChunkListOffset := FChunkListCapacity shr 1;
  FStart := 0;
  FCount := 0;
end;

function TDoubleEndedQueue.Equals(DoubleEndedQueue: TDoubleEndedQueue;
  CompareFunction: TCompareFunction): Boolean;
var
  I, J, C: Integer;
  P1, P2: Pointer;
begin
  if DoubleEndedQueue = Self then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
  if (DoubleEndedQueue = nil) or (DoubleEndedQueue.FCount <> FCount) then
    Exit;
  I := FStart;
  J := DoubleEndedQueue.FStart;
  C := I + FCount;
  while I < C do
  begin
    P1 := PPointerItemList(FChunkList^[I shr ChunkIndexShift + FChunkListOffset])^
      [I and ChunkIndexMask];
    P2 := PPointerItemList(DoubleEndedQueue.FChunkList^
      [J shr ChunkIndexShift + DoubleEndedQueue.FChunkListOffset])^
      [J and ChunkIndexMask];
    if (P1 <> P2) and (not Assigned(CompareFunction) or
      (CompareFunction(P1, P2) <> 0)) then
      Exit;
    Inc(I);
    Inc(J);
  end;
  Result := True;
end;

function TDoubleEndedQueue.Clone: TDoubleEndedQueue;
begin
  Result := TDoubleEndedQueue.Create;
  Result.Load(Self, True);
end;

{ TPriorityQueue }

constructor TPriorityQueue.Create(CompareFunction: TCompareFunction;
  InitialCapacity: Integer);
begin
  FCapacity := InitialCapacity;
  FCompareFunction := CompareFunction;
  if InitialCapacity > 0 then
    GetMem(FItems, InitialCapacity * SizeOf(Pointer));
end;

destructor TPriorityQueue.Destroy;
var
  I: Integer;
begin
  if FCapacity > 0 then
  begin
    if FOwnItems then
      for I := FCount - 1 downto 0 do
        TObject(FItems^[I]).Free;
    FreeMem(FItems);
  end;
end;

procedure TPriorityQueue.SetCapacity(NewCapacity: Integer);
var
  NewItems: PPointerItemList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewItems, NewCapacity * SizeOf(Pointer));
      if FCount > 0 then
        G_CopyLongs(FItems, NewItems, FCount);
    end else
      NewItems := nil;
    if FCapacity > 0 then
      FreeMem(FItems);
    FCapacity := NewCapacity;
    FItems := NewItems;
  end;
end;

procedure TPriorityQueue.SetCompareFunction(CompareFunction: TCompareFunction);
begin
  if @CompareFunction <> @FCompareFunction then
  begin
    FCompareFunction := CompareFunction;
    G_MakeHeap(FItems, FCount, CompareFunction);
  end;
end;

procedure TPriorityQueue.Load(PriorityQueue: TPriorityQueue;
  SuppressDisposingItems: Boolean);
var
  C: Integer;
begin
  Clear(SuppressDisposingItems);
  C := PriorityQueue.FCount;
  if C > FCapacity then
    SetCapacity(G_NormalizeCapacity(C));
  if C > 0 then
    G_CopyLongs(PriorityQueue.FItems, FItems, C);
  if @FCompareFunction <> @PriorityQueue.FCompareFunction then
    G_MakeHeap(FItems, C, FCompareFunction);
  FCount := C;
end;

procedure TPriorityQueue.Load(Items: Pointer; Count: Integer;
  SuppressDisposingItems: Boolean);
begin
  Clear(SuppressDisposingItems);
  if Count > FCapacity then
    SetCapacity(G_NormalizeCapacity(Count));
  if Count > 0 then
    G_CopyLongs(Items, FItems, Count);
  G_MakeHeap(FItems, Count, FCompareFunction);
  FCount := Count;
end;

procedure TPriorityQueue.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

function TPriorityQueue.IsEmpty: Boolean;
begin
  Result := FCount = 0;
end;

function TPriorityQueue.Push(P: Pointer): Integer;
begin
  if FCount >= FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  FItems^[FCount] := P;
  Inc(FCount);
  Result := G_PushHeap(FItems, FCount, FCompareFunction);
end;

function TPriorityQueue.Pop: Pointer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  G_PopHeap(FItems, FCount, FCompareFunction);
  Dec(FCount);
  Result := FItems^[FCount];
end;

function TPriorityQueue.Peek: Pointer;
begin
  if FCount = 0 then
    RaiseError(SErrPeekFromEmptyList);
  Result := FItems^[0];
end;

function TPriorityQueue.ScanPointer(P: Pointer): Integer;
begin
  Result := G_Scan_Pointer(P, FItems, FCount);
end;

function TPriorityQueue.Search(Value: Pointer; MatchFunction: TMatchFunction): Pointer;
var
  Index: Integer;
begin
  Index := G_Search(Value, FItems, FCount, MatchFunction);
  if Index >= 0 then
    Result := FItems^[Index]
  else
    Result := nil;
end;

function TPriorityQueue.IndexOf(Value: Pointer; MatchFunction: TMatchFunction): Integer;
begin
  Result := G_Search(Value, FItems, FCount, MatchFunction);
end;

procedure TPriorityQueue.RemoveAt(Index: Integer);
begin
  if LongWord(Index) >= LongWord(FCount) then
    RaiseError(SErrIndexOutOfRange);
  G_PopHeap(Index, FItems, FCount, FCompareFunction);
  Dec(FCount);
  if FOwnItems then
    TObject(FItems^[FCount]).Free;
end;

procedure TPriorityQueue.Clear(SuppressDisposingItems: Boolean);
var
  I: Integer;
begin
  if FOwnItems and not SuppressDisposingItems then
    for I := FCount - 1 downto 0 do
      TObject(FItems^[I]).Free;
  FCount := 0;
end;

procedure TPriorityQueue.TrimToSize;
begin
  if FCount < FCapacity then
    SetCapacity(FCount);
end;

function TPriorityQueue.Equals(PriorityQueue: TPriorityQueue;
  CompareValues: Boolean): Boolean;
var
  P1, P2: Pointer;
  I: Integer;
begin
  if PriorityQueue = Self then
    Result := True
  else if (PriorityQueue <> nil) and (PriorityQueue.FCount = FCount) then
  begin
    if not CompareValues then
      Result := G_SameLongs(FItems, PriorityQueue.FItems, FCount)
    else
    begin
      Result := False;
      for I := FCount - 1 downto 0 do
      begin
        P1 := FItems^[I];
        P2 := PriorityQueue.FItems^[I];
        if (P1 <> P2) and (FCompareFunction(P1, P2) <> 0) then
          Exit;
      end;
      Result := True;
    end;
  end else
    Result := False;
end;

function TPriorityQueue.Clone: TPriorityQueue;
begin
  Result := TPriorityQueue.Create(FCompareFunction, FCount);
  if FCount > 0 then
    G_CopyLongs(FItems, Result.FItems, FCount);
  Result.FCount := FCount;
end;

{ TIntegerListEnumerator }

constructor TIntegerListEnumerator.Create(AList: TIntegerList);
begin
  inherited Create;
  FIndex := -1;
  FList := AList;
end;

function TIntegerListEnumerator.GetCurrent: Integer;
begin
  Result := FList[FIndex]
end;

function TIntegerListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

{ TArrayListEnumerator }

constructor TArrayListEnumerator.Create(AList: TArrayList);
begin
  inherited Create;
  FIndex := -1;
  FList := AList;
end;

function TArrayListEnumerator.GetCurrent: Pointer;
begin
  Result := FList.FItems^[FIndex]
end;

function TArrayListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

initialization
  New(StringRBTreeNil);
  StringRBTreeNil^.Parent := StringRBTreeNil;
  StringRBTreeNil^.Left := StringRBTreeNil;
  StringRBTreeNil^.Right := StringRBTreeNil;
  New(IntegerRBTreeNil);
  IntegerRBTreeNil^.Parent := IntegerRBTreeNil;
  IntegerRBTreeNil^.Left := IntegerRBTreeNil;
  IntegerRBTreeNil^.Right := IntegerRBTreeNil;
  New(Int64RBTreeNil);
  Int64RBTreeNil^.Parent := Int64RBTreeNil;
  Int64RBTreeNil^.Left := Int64RBTreeNil;
  Int64RBTreeNil^.Right := Int64RBTreeNil;

finalization
//  {DONE: Утечка памяти}
//  {$IFNDEF DEBUG}
//  if not IsMultiThread then
//  {$ENDIF}
  begin
    Dispose(Int64RBTreeNil);
    Dispose(IntegerRBTreeNil);
    Dispose(StringRBTreeNil);
  end;

end.
