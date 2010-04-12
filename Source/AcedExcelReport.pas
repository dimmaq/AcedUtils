
//////////////////////////////////////////////////////////
//                                                      //
//   AcedExcelReport 1.09                               //
//                                                      //
//   Функции и классы, облегчающие подготовку отчетов   //
//   в Microsoft Excel.                                 //
//                                                      //
//   mailto: acedutils@yandex.ru                        //
//                                                      //
//////////////////////////////////////////////////////////

unit AcedExcelReport;

interface

uses Windows, SysUtils, Dialogs, ActiveX, ComObj, Excel97, AcedContainers;

type

{ Константы и перечисления }

{ Толщины линий, которыми прорисовываются границы между ячейками. Используется
  для параметра Weight, передаваемого в функцию DrawExcelBorders. }

  TExcelBorderWeight = (
    xlbwHairline         = Integer($00000001),  // Очень тонкая линия
    xlbwThin             = Integer($00000002),  // Тонкая линия
    xlbwMedium           = Integer($FFFFEFD6),  // Средняя линия
    xlbwThick            = Integer($00000004)   // Толстая линия
  );

{ Стили линий для прорисовки границ. Используется для параметра LineStyle,
  передаваемого в функцию DrawExcelBorders. }

  TExcelLineStyle = (
    xllsNone             = Integer($FFFFEFD2),  // Нет линии
    xllsContinuous       = Integer($00000001),  // Сплошная линия
    xllsDash             = Integer($FFFFEFED),  // Линия из тире
    xllsDashDot          = Integer($00000004),  // Линия из точек и тире
    xllsDashDotDot       = Integer($00000005),  // Линия "две точки - тире"
    xllsDot              = Integer($FFFFEFEA),  // Линия из точек
    xllsDouble           = Integer($FFFFEFE9),  // Двойная линия
    xllsSlantDashDot     = Integer($0000000D)   // С наклонными штрихами
  );

{ Групповые функции, которые могут быть применены к интервалу ячеек.
  Используется для параметра F, передаваемого в функции AssignAbsoluteFormula
  и AssignRelativeFormula. }

  TExcelRangeFunction = (
    xlrfSum,                 // Сумма всех значений
    xlrfAverage,             // Среднее арифметическое
    xlrfCount,               // Количество непустых ячеек
    xlrfMax,                 // Максимальное значение
    xlrfMin,                 // Минимальное значение
    xlrfProduct              // Произведение всех значений
  );

{ Границы ячеек - возможные значения для параметра CellBorders, который
  передается в функции DrawExcelBorders и ClearExcelBorders. }

const
  xlcbNone               = $0000;  // Пустое множество
  xlcbEdgeLeft           = $0001;  // Левый край диапазона ячеек
  xlcbEdgeRight          = $0002;  // Правый край диапазона ячеек
  xlcbEdgeTop            = $0004;  // Верхний край диапазона ячеек
  xlcbEdgeBottom         = $0008;  // Нижний край диапазона ячеек
  xlcbInsideHorizontal   = $0010;  // Все горизонтальные линии внутри диапазона
  xlcbInsideVertical     = $0020;  // Все вертикальные линии внутри диапазона
  xlcbDiagonalUp         = $0040;  // Все диагонали снизу вверх
  xlcbDiagonalDown       = $0080;  // Все диагонали сверху вниз

  // Все границы вокруг диапазона ячеек
  xlcbAllAround = xlcbEdgeLeft or xlcbEdgeRight or xlcbEdgeTop or xlcbEdgeBottom;

  // Все границы внутри диапазона ячеек
  xlcbAllInside = xlcbInsideHorizontal or xlcbInsideVertical;

  // Все границы вокруг и внутри диапазона ячеек
  xlcbAll = xlcbAllAround or xlcbAllInside;

{ Цвет текста, фона, линий и т.п. - возможные значения для параметров
  ColorIndex и PatternColorIndex, которые передаются в функции DrawBorders
  и FillInterior, в дополнение к константам xlColorIndexNone и
  xlColorIndexAutomatic, определенным в модуле Excel97. }

const
  xlColorBlack = 1;         // Черный              (00,00,00)
  xlColorBrown = 53;        // Коричневый          (99,33,00)
  xlColorDarkOlive = 52;    // Темно-оливковый     (33,33,00)
  xlColorDarkGreen = 51;    // Темно-зеленый       (00,33,00)
  xlColorDarkDove = 49;     // Темно-сизый         (00,33,66)
  xlColorNavy = 11;         // Темно-синий         (00,00,80)
  xlColorIndigo = 55;       // Индиго              (33,33,99)
  xlColorGray80 = 56;       // Серый 80%           (33,33,33)
  xlColorMaroon = 9;        // Темно-красный       (80,00,00)
  xlColorOrange = 46;       // Оранжевый           (FF,66,00)
  xlColorOlive = 12;        // Оливковый           (80,80,00)
  xlColorGreen = 10;        // Зеленый             (00,80,00)
  xlColorTeal = 14;         // Сине-зеленый        (00,80,80)
  xlColorBlue = 5;          // Синий               (00,00,FF)
  xlColorDove = 47;         // Сизый               (66,66,99)
  xlColorGray50 = 16;       // Серый 50%           (80,80,80)
  xlColorRed = 3;           // Красный             (FF,00,00)
  xlColorLightOrange = 45;  // Светло-оранжевый    (FF,99,00)
  xlColorGrassGreen = 43;   // Травяной            (99,CC,00)
  xlColorEmerald = 50;      // Изумрудный          (33,99,66)
  xlColorTurquoise = 42;    // Темно-бирюзовый     (33,CC,CC)
  xlColorDarkCyan = 41;     // Темно-голубой       (33,66,FF)
  xlColorPurple = 13;       // Фиолетовый          (80,00,80)
  xlColorGray40 = 48;       // Серый 40%           (96,96,96)
  xlColorMagenta = 7;       // Лиловый             (FF,00,FF)
  xlColorGoldish = 44;      // Золотистый          (FF,CC,00)
  xlColorYellow = 6;        // Желтый              (FF,FF,00)
  xlColorLime = 4;          // Ярко-зеленый        (00,FF,00)
  xlColorAqua = 8;          // Бирюзовый           (00,FF,FF)
  xlColorLightBlue = 33;    // Голубой             (00,CC,FF)
  xlColorCherry = 54;       // Вишневый            (99,33,66)
  xlColorGray25 = 15;       // Серый 25%           (C0,C0,C0)
  xlColorPink = 38;         // Розовый             (FF,99,CC)
  xlColorLightBrown = 40;   // Светло-коричневый   (FF,CC,99)
  xlColorLightYellow = 36;  // Светло-желтый       (FF,FF,99)
  xlColorGreenPale = 35;    // Бледно-зеленый      (CC,FF,CC)
  xlColorAquaPale = 34;     // Светло-бирюзовый    (CC,FF,FF)
  xlColorCyanPale = 37;     // Бледно-голубой      (99,CC,FF)
  xlColorLilac = 39;        // Сиреневый           (CC,99,FF)
  xlColorWhite = 2;         // Белый               (FF,FF,FF)
  xlColorBlueViolet = 17;   // Сине-фиолетовый     (99,99,FF)
  xlColorIvory = 19;        // Слоновая кость      (FF,FF,CC)
  xlColorDarkPurple = 21;   // Темно-фиолетовый    (66,00,66)
  xlColorCoral = 22;        // Коралловый          (FF,80,80)
  xlColorCornflower = 23;   // Васильковый         (00,66,CC)
  xlColorBluePale = 24;     // Пастельный голубой  (CC,CC,FF)
  xlColorDarkBlue = 25;     // Темно-синий         (00,00,80)
  xlColorFuchsia = 26;      // Лиловый             (FF,00,FF)
  xlColorCyan = 28;         // Бирюзовый           (00,FF,FF)


{ Класс TExcelInterval - прямоугольный интервал ячеек, добавляемый в
  коллекцию TExcelRange }

type
  TExcelInterval = class(TObject)
  private
    FRowNumber: Integer;
    FColumnNumber: Integer;
    FRowCount: Integer;
    FColumnCount: Integer;
    FWholeRows: Boolean;
    FWholeColumns: Boolean;
    function GetLastRowNumber: Integer;
    function GetLastColumnNumber: Integer;
  public

  { Следующий конструктор Create создает экземпляр класса TExcelInterval,
    который представляет собой интервал, состоящий из одной ячейки,
    находящейся на пересечении строки RowNumber со столбцом ColumnNumber. }

    constructor Create(RowNumber, ColumnNumber: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelInterval,
    представляющий прямоугольный интервал ячеек высотой RowCount строк шириной
    ColumnCount столбцов с левой верхней ячейкой, находящейся на пересечении
    строки RowNumber со столбцом ColumnNumber. }

    constructor Create(RowNumber, ColumnNumber,
      RowCount, ColumnCount: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelInterval,
    представляющий целые строки (если параметр WholeColumns равен False) или
    целые столбцы (если параметр WholeColumns равен True). Параметр Number
    задает номер первой строки (столбца) интервала. Параметр Count задает
    количество строк (столбцов) интервала. }

    constructor Create(WholeColumns: Boolean; Number: Integer;
      Count: Integer = 1); overload;

  { Свойства }

  { Свойство RowNumber возвращает номер первой строки интервала ячеек. Если
    интервал содержит все строки некоторого столбца, свойство возвращает
    наименьшее отрицательное значение типа Integer (-2147483648). }

    property RowNumber: Integer read FRowNumber;

  { Свойство ColumnNumber возвращает номер первого столбца интервала ячеек.
    Если интервал содержит все столбцы некоторой строки, свойство возвращает
    наименьшее отрицательное значение типа Integer (-2147483648). }

    property ColumnNumber: Integer read FColumnNumber;

  { Свойство LastRowNumber возвращает номер последней строки интервала ячеек.
    Если интервал содержит все строки некоторого столбца, свойство возвращает
    значение MaxInt (2147483647). }

    property LastRowNumber: Integer read GetLastRowNumber;

  { Свойство LastColumnNumber Возвращает номер последнего столбца интервала
    ячеек. Если интервал содержит все столбцы некоторой строки, свойство
    возвращает значение MaxInt (2147483647). }

    property LastColumnNumber: Integer read GetLastColumnNumber;

  { Свойство RowCount возвращает число строк в интервале ячеек. Если интервал
    содержит все строки некоторого столбца, свойство возвращает 0. }

    property RowCount: Integer read FRowCount;

  { Свойство ColumnCount возвращает число столбцов в интервале ячеек. Если
    интервал содержит все столбцы некоторой строки, свойство возвращает 0. }

    property ColumnCount: Integer read FColumnCount;

  { Свойство WholeRows возвращает True, если интервал охватывает все столбцы,
    т.е. полные строки. Иначе, возвращает False. }

    property WholeRows: Boolean read FWholeRows;

  { Свойство WholeColumns возвращает True, если интервал охватывает все строки,
    т.е. полные столбцы. Иначе, возвращает False. }

    property WholeColumns: Boolean read FWholeColumns;

  { Методы }

  { Функция GetRange возвращает диапазон типа ExcelRange, представляющий данный
    интервал ячеек на рабочем листе, с учетом смещения на ExcelRowOffset строк
    и ExcelColumnOffset столбцов. Полный диапазон ячеек рабочего листа задается
    параметром Cells. }

    function GetRange(Cells: ExcelRange): ExcelRange;

  { Функция Equals возвращает True, если в параметре Interval передан экземпляр
    класса TExcelInterval в точности идентичный данному экземпляру. }

    function Equals(Interval: TExcelInterval): Boolean;

  { Функция Clone возвращает копию данного экземпляра класса TExcelInterval. }

    function Clone: TExcelInterval;
  end;


{ Класс TExcelRange - коллекция прямоугольных интервалов ячеек, которая
  сортируется сначала по строкам, а затем по столбцам }

  TExcelRange = class(TObject)
  private
    FList: TArrayList;
    FSorted: Boolean;
    function GetInterval(Index: Integer): TExcelInterval;
    function GetIntervalCount: Integer;
  public

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и внутренний список, в котором изначально распределяется память под
    InitialCapacity прямоугольных интервалов. }

    constructor Create(InitialCapacity: Integer = 16); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и добавляет в него интервал, представляющий одну ячейку, которая
    находится на пересечении строки RowNumber со столбцом ColumnNumber. }

    constructor Create(RowNumber, ColumnNumber: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и добавляет в него прямоугольный интервал высотой RowCount строк шириной
    ColumnCount столбцов с левой верхней ячейкой, находящейся на пересечении
    строки RowNumber со столбцом ColumnNumber. }

    constructor Create(RowNumber, ColumnNumber,
      RowCount, ColumnCount: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и добавляет в него интервал, представляющий целые строки (если параметр
    WholeColumns равен False) или целые столбцы (если параметр WholeColumns
    равен True). Параметр Number задает номер первой строки (столбца)
    интервала. Параметр Count задает количество строк (столбцов) интервала. }

    constructor Create(WholeColumns: Boolean; Number: Integer;
      Count: Integer = 1); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и добавляет в него интервал, переданный параметром Interval. }

    constructor Create(Interval: TExcelInterval); overload;

  { Следующий конструктор Create создает экземпляр класса TExcelRange
    и добавляет в него копию каждого интервала из коллекции интервалов,
    переданной параметром Range. }

    constructor Create(Range: TExcelRange); overload;

  { Деструктор Destroy освобождает память занятую коллекцией интервалов и
    каждым интервалом, т.е. экземпляром класса TExcelInterval, в составе этой
    коллекции. }

    destructor Destroy; override;

  { Свойства }

  { Свойство Intervals возвращает интервал с индексом Index в коллекции
    интервалов (индексация с нуля). }

    property Intervals[Index: Integer]: TExcelInterval read GetInterval; default;

  { Свойство IntervalCount возвращает количество интервалов в коллекции. }

    property IntervalCount: Integer read GetIntervalCount;

  { Свойство InnerList возвращает ссылку на внутренний список, используемый
    для хранения элементов коллекции интервалов. }

    property InnerList: TArrayList read FList;

  { Методы }

  { После вызова метода EnsureSorted внутренний массив содержит элементы
    коллекции, отсортированные сначала по строкам, а затем по столбцам. }

    procedure EnsureSorted;

  { Следующий метод Add добавляет в коллекцию новый интервал, представляющий
    одну ячейку, которая находится на пересечении строки RowNumber со столбцом
    ColumnNumber. }

    procedure Add(RowNumber, ColumnNumber: Integer); overload;

  { Следующий метод Add добавляет в коллекцию прямоугольный интервал высотой
    RowCount строк шириной ColumnCount столбцов с левой верхней ячейкой,
    находящейся на пересечении строки RowNumber со столбцом ColumnNumber. }

    procedure Add(RowNumber, ColumnNumber, RowCount, ColumnCount: Integer); overload;

  { Следующий метод Add добавляет в коллекцию интервал, переданный параметром
    Interval. }

    procedure Add(Interval: TExcelInterval); overload;

  { Следующий метод Add добавляет в данную коллекцию копию каждого интервала
    из коллекции интервалов, переданной параметром Range. }

    procedure Add(Range: TExcelRange); overload;

  { Метод AddRows добавляет в коллекцию новый интервал, состоящий из RowCount
    целых строк, начиная со строки RowNumber. }

    procedure AddRows(RowNumber: Integer; RowCount: Integer = 1);

  { Метод AddColumns добавляет в коллекцию новый интервал, состоящий из
    ColumnCount целых столбцов, начиная со столбца ColumnNumber. }

    procedure AddColumns(ColumnNumber: Integer; ColumnCount: Integer = 1);

  { Функция GetAbsoluteAddress возвращает строку, содержащую абсолютную ссылку
    на диапазон ячеек с учетом смещения на ExcelRowOffset строк и
    ExcelColumnOffset столбцов. Например, для коллекции, содержащей три
    интервала, функция может вернуть строку: "R1C2:R2C2;R3C5;R4C1:R4C5". }

    function GetAbsoluteAddress: string;

  { Функция GetRelativeAddress возвращает строку, содержащую относительную
    ссылку на диапазон ячеек относительно ячейки:
    [BaseRowNumber, BaseColumnNumber]. Например, для коллекции из трех
    интервалов этот метод, вызванный относительно ячейки R2C2, может вернуть
    строку: "R[-1]C:RC;R[1]C[3];R[2]C[-1]:R[2]C[3]". }

    function GetRelativeAddress(BaseRowNumber, BaseColumnNumber: Integer): string;

  { Функция GetRange возвращает объект типа ExcelRange, представляющий диапазон
    ячеек на рабочем листе, с учетом смещения на ExcelRowOffset строк и
    ExcelColumnOffset столбцов. Полный диапазон ячеек рабочего листа задается
    параметром Cells. }

    function GetRange(Cells: ExcelRange): ExcelRange;

  { Метод Clear очищает коллекцию интервалов. При этом для каждого интервала
    в составе коллекции, т.е. экземпляра класса TExcelInterval, вызывается
    метод Free. }

    procedure Clear;

  { Функция Equals возвращает True, если данная коллекция интервалов полностью
    идентична коллекции, переданной параметром Range. }

    function Equals(Range: TExcelRange): Boolean;

  { Функция Clone создает и возвращает новую коллекцию интервалов, которая
    содержит копии всех экземпляров класса TExcelInterval данной коллекции. }

    function Clone: TExcelRange;
  end;


{ Глобальные функции для управления приложением Microsoft Excel }

{ StartExcel запускает приложение Microsoft Excel, если оно не было запущено.
  Возвращает True в случае успеха и False, если Microsoft Excel на данном
  компьютере не установлен. В последнем случае на экран выводится сообщение
  для пользователя с предложением установить Microsoft Excel. }

function StartExcel: Boolean;

{ ShutdownExcel завершает процесс Microsoft Excel, если он был запущен. }

procedure ShutdownExcel;

{ Следующая функция CreateExcelWorkbook создает пустую рабочую книгу, состоящую
  из SheetsInNewWorkbook листов. Возвращает True как результат функции и ссылку
  на рабочую книгу в параметре WB. В случае ошибки функция возвращает False. }

function CreateExcelWorkbook(var WB: _Workbook;
  SheetsInNewWorkbook: Integer = 1): Boolean; overload;

{ Следующая функция CreateExcelWorkbook создает рабочую книгу на основе
  XLT-шаблона. Имя файла шаблона задается параметром TemplateFileName.
  В случае успеха возвращает True как результат функции и ссылку на рабочую
  книгу в параметре WB. При возникновении ошибки функция возвращает False. }

function CreateExcelWorkbook(var WB: _Workbook;
  const TemplateFileName: string): Boolean; overload;

{ InitializeExcelWorkbook настраивает визуальные свойства рабочей книги,
  переданной параметром WB, устанавливает оба смещения: ExcelRowOffset и
  ExcelColumnOffset в 0. Смысл каждого из параметров метода:

  Caption - устанавливает заголовок окна, в котором отображается отчет;
  DisplayWorkbookTabs - если равен True, показываются ярлычки листов;
  DisplayZeros - если False, нулевые значения не показываются;
  DisplayHeadings - если True, отображаются заголовки строк и столбцов;
  DisplayGridlines - если True, отображаются линии сетки;
  DisplayHorizontalScrollBar - если False, полоса горизонтальной
    прокрутки скрывается;
  DisplayVerticalScrollBar - если False, полоса вертикальной
    прокрутки скрывается. }

procedure InitializeExcelWorkbook(WB: _Workbook; const Caption: string;
  DisplayWorkbookTabs: Boolean = True; DisplayZeros: Boolean = False;
  DisplayHeadings: Boolean = False; DisplayGridlines: Boolean = False;
  DisplayHorizontalScrollBar: Boolean = True;
  DisplayVerticalScrollBar: Boolean = True);

{ GetExcelCell возвращает ссылку на диапазон, состоящий из одной ячейки,
  находящейся на пересечении строки RowNumber со столбцом ColumnNumber,
  с учетом смещения на ExcelRowOffset строк и ExcelColumnOffset столбцов.
  Cells задает полный диапазон ячеек рабочего листа. }

function GetExcelCell(Cells: ExcelRange;
  RowNumber, ColumnNumber: Integer): ExcelRange;

{ GetExcelRange возвращает ссылку на прямоугольный диапазон ячеек, начиная
  с ячейки: [RowNumber, ColumnNumber], с учетом смещения на ExcelRowOffset
  строк и ExcelColumnOffset столбцов высотой RowCount строк, шириной
  ColumnCount столбцов. Параметр Cells задает полный диапазон ячеек
  рабочего листа. }

function GetExcelRange(Cells: ExcelRange; RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer): ExcelRange;

{ GetNamedExcelRange возвращает ссылку на именованный диапазон ячеек с именем
  Name. Параметр Cells задает полный диапазон ячеек рабочего листа. }

function GetNamedExcelRange(Cells: ExcelRange; const Name: string): ExcelRange;

{ GetExcelRows возвращает ссылку на диапазон, состоящий из RowCount строк,
  начиная со строки RowNumber, с учетом смещения на ExcelRowOffset строк.
  Параметр Cells задает полный диапазон ячеек рабочего листа. }

function GetExcelRows(Cells: ExcelRange; RowNumber, RowCount: Integer): ExcelRange;

{ GetExcelColumns возвращает ссылку на диапазон, состоящий из ColumnCount
  столбцов, начиная со столбца ColumnNumber, с учетом смещения на
  ExcelColumnOffset столбцов. Параметр Cells задает полный диапазон ячеек
  рабочего листа. }

function GetExcelColumns(Cells: ExcelRange;
  ColumnNumber, ColumnCount: Integer): ExcelRange;

{ InsertExcelRows вставляет RowCount строк перед строкой с номером
  NextRowNumber с учетом смещения на ExcelRowOffset строк. Параметр Cells
  задает полный диапазон ячеек рабочего листа. }

procedure InsertExcelRows(Cells: ExcelRange; NextRowNumber: Integer;
  RowCount: Integer = 1);

{ InsertExcelColumns вставляет ColumnCount столбцов перед столбцом с номером
  NextColumnNumber с учетом смещения на ExcelColumnOffset столбцов. Параметр
  Cells задает полный диапазон ячеек рабочего листа. }

procedure InsertExcelColumns(Cells: ExcelRange; NextColumnNumber: Integer;
  ColumnCount: Integer = 1);

{ GetAbsoluteAddress возвращает строку, содержащую абсолютную ссылку на
  диапазон ячеек из RowCount строк и ColumnCount столбцов, начиная со строки
  RowNumber и столбца ColumnNumber, с учетом смещения на ExcelRowOffset строк
  и ExcelColumnOffset столбцов. }

function GetAbsoluteAddress(RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer): string;

{ GetRelativeAddress возвращает строку, содержащую относительную ссылку на
  диапазон ячеек из RowCount строк и ColumnCount столбцов, начиная со строки
  RowNumber и столбца ColumnNumber, относительно ячейки: [BaseRowNumber,
  BaseColumnNumber]. }

function GetRelativeAddress(BaseRowNumber, BaseColumnNumber,
  RowNumber, ColumnNumber, RowCount, ColumnCount: Integer): string;

{ Следующая процедура AssignAbsoluteFormula заносит формулу, выбранную
  параметром F, во все ячейки диапазона TargetRange. В качестве аргумента
  для групповой функции F передается абсолютная ссылка на диапазон ячеек,
  содержащий SourceRowCount строк и SourceColumnCount столбцов, начиная
  со строки SourceRowNumber и столбца SourceColumnNumber, с учетом смещения
  на ExcelRowOffset строк и ExcelColumnOffset столбцов. }

procedure AssignAbsoluteFormula(SourceRowNumber, SourceColumnNumber,
  SourceRowCount, SourceColumnCount: Integer; F: TExcelRangeFunction;
  TargetRange: ExcelRange); overload;

{ Следующая процедура AssignAbsoluteFormula заносит формулу, выбранную
  параметром F, во все ячейки диапазона TargetRange. В качестве аргумента
  для групповой функции F передается абсолютная ссылка на диапазон ячеек
  SourceRange с учетом смещения на ExcelRowOffset строк и ExcelColumnOffset
  столбцов. }

procedure AssignAbsoluteFormula(SourceRange: TExcelRange;
  F: TExcelRangeFunction; TargetRange: ExcelRange); overload;

{ Следующая процедура AssignRelativeFormula заносит формулу, выбранную
  параметром F, во все ячейки диапазона TargetRange. В качестве аргумента
  для групповой функции F передается ссылка на диапазон ячеек, содержащий
  SourceRowCount строк и SourceColumnCount столбцов, начиная со строки
  SourceRowNumber и столбца SourceColumnNumber, относительно ячейки:
  [BaseRowNumber, BaseColumnNumber]. Таким образом, для каждой ячейки
  диапазона TargetRange формула вычисляется с учетом смещения относительно
  базовой ячейки: [BaseRowNumber, BaseColumnNumber]. }

procedure AssignRelativeFormula(BaseRowNumber, BaseColumnNumber,
  SourceRowNumber, SourceColumnNumber, SourceRowCount, SourceColumnCount: Integer;
  F: TExcelRangeFunction; TargetRange: ExcelRange); overload;

{ Следующая процедура AssignRelativeFormula заносит формулу, выбранную
  параметром F, во все ячейки диапазона TargetRange. В качестве аргумента
  для групповой функции F передается ссылка на диапазон ячеек SourceRange
  относительно ячейки: [BaseRowNumber, BaseColumnNumber]. Таким образом,
  для каждой ячейки диапазона TargetRange формула вычисляется с учетом
  смещения относительно базовой ячейки: [BaseRowNumber, BaseColumnNumber]. }

procedure AssignRelativeFormula(BaseRowNumber, BaseColumnNumber: Integer;
  SourceRange: TExcelRange; F: TExcelRangeFunction; TargetRange: ExcelRange); overload;

{ DrawExcelBorders прорисовывает границы, заданные параметром CellBorders,
  линией толщиной Weight, типом LineStyle и цветом ColorIndex в ячейках
  диапазона Range. Возможные значения для параметра CellBorders, которые
  можно комбинировать с помощью "or": xlcbNone, xlcbEdgeLeft, xlcbEdgeRight,
  xlcbEdgeTop, xlcbEdgeBottom, xlcbInsideHorizontal, xlcbInsideVertical,
  xlcbDiagonalUp, xlcbDiagonalDown, xlcbAllAround, xlcbAllInside, xlcbAll. }

procedure DrawExcelBorders(Range: ExcelRange; CellBorders: Integer;
  Weight: TExcelBorderWeight = xlbwThin;
  LineStyle: TExcelLineStyle = xllsContinuous;
  ColorIndex: Integer = Integer(xlAutomatic));

{ ClearExcelBorders убирает границы, заданные параметром CellBorders (см.
  описание процедуры DrawExcelBorders), во всех ячейках диапазона Range. }

procedure ClearExcelBorders(Range: ExcelRange; CellBorders: Integer);

{ FillExcelInterior устанавливает заливку для ячеек диапазона Range.
  ColorIndex - цвет заливки, Pattern - шаблон, который накладывается на заливку
  (см. тип XlPattern в модуле Excel97), PatternColorIndex - цвет линий шаблона. }

procedure FillExcelInterior(Range: ExcelRange; ColorIndex: Integer = xlColorYellow;
  Pattern: Integer = xlPatternSolid; PatternColorIndex: Integer = Integer(xlAutomatic));

{ FreezeExcelRows определяет, что строки с номерами от RowNumber1 до
  RowNumber2, включительно, с учетом смещения на ExcelRowOffset строк
  не должны перемещаться при вертикальном скроллинге окна рабочей книги WB. }

procedure FreezeExcelRows(WB: _Workbook; RowNumber1, RowNumber2: Integer);

{ FreezeExcelColumns определяет, что столбцы с номерами от ColumnNumber1 до
  ColumnNumber2, включительно, с учетом смещения на ExcelColumnOffset столбцов
  не должны перемещаться при горизонтальном скроллинге окна рабочей книги WB. }

procedure FreezeExcelColumns(WB: _Workbook; ColumnNumber1, ColumnNumber2: Integer);

{ ProtectExcelWorksheet защищает рабочий лист WS так, чтобы на нем ничего
  нельзя было выделить и изменить. }

procedure ProtectExcelWorksheet(WS: _Worksheet);

{ ShowExcelWorkbook активизирует приложение Microsoft Excel, показывает рабочую
  книгу WB на экране и устанавливает ее свойство Saved в значение True, чтобы
  при закрытии рабочей книги не спрашивалось, нужно ли сохранять изменения. }

procedure ShowExcelWorkbook(WB: _Workbook);


{ Глобальные переменные }

{ ExcelApp содержит ссылку на запущенный экземпляр приложения Microsoft Excel,
  используемый данной программой для построения отчетов. }

var
  ExcelApp: _Application = nil;

{ ExcelRowOffset задает смещение, которое автоматически добавляется
  к номеру строки при обращении к функциям: GetExcelCell, GetExcelRange
  и другим функциям и методам, в которых номер строки используется для
  обращения к ячейкам рабочего листа. }

  ExcelRowOffset: Integer = 0;

{ ExcelColumnOffset задает смещение, которое автоматически добавляется
  к номеру столбца при обращении к функциям: GetExcelCell, GetExcelRange
  и другим функциям и методам, в которых номер столбца используется для
  обращения к ячейкам рабочего листа. }

  ExcelColumnOffset: Integer = 0;

implementation

uses Office97, Variants, AcedCommon, AcedConsts, AcedStrings;

const
  ExcelIntervalDelimiter: Char = ';';
  ExcelRangeFunctions: array[0..5] of string =
    ('=СУММ(', '=СРЗНАЧ(', '=СЧЁТ(', '=МАКС(', '=МИН(', '=ПРОИЗВЕД(');

var
  Range1, Range2: ExcelRange;
  Ranges: array[0..27] of OleVariant;

  VisibleCommandBars: TBitList;
  OldSheetsInNewWorkbook: Integer;
  OldDisplayFormulaBar: Boolean;
  OldDisplayStatusBar: Boolean;

{ TExcelInterval }

constructor TExcelInterval.Create(RowNumber, ColumnNumber: Integer);
begin
  FRowNumber := RowNumber;
  FColumnNumber := ColumnNumber;
  FRowCount := 1;
  FColumnCount := 1;
end;

constructor TExcelInterval.Create(RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer);
begin
  FRowNumber := RowNumber;
  FColumnNumber := ColumnNumber;
  FRowCount := RowCount;
  FColumnCount := ColumnCount;
end;

constructor TExcelInterval.Create(WholeColumns: Boolean; Number, Count: Integer);
begin
  if not WholeColumns then
  begin
    FRowNumber := Number;
    FColumnNumber := Integer($80000000);
    FRowCount := Count;
    FColumnCount := 0;
    FWholeRows := True;
  end else
  begin
    FRowNumber := Integer($80000000);
    FColumnNumber := Number;
    FRowCount := 0;
    FColumnCount := Count;
    FWholeColumns := True;
  end;
end;

function TExcelInterval.GetLastRowNumber: Integer;
begin
  Result := FRowNumber + FRowCount - 1;
end;

function TExcelInterval.GetLastColumnNumber: Integer;
begin
  Result := FColumnNumber + FColumnCount - 1;
end;

function TExcelInterval.GetRange(Cells: ExcelRange): ExcelRange;
var
  R, C: Integer;
begin
  if FWholeRows then
  begin
    R := FRowNumber + ExcelRowOffset;
    if FRowCount > 1 then
      Result := Cells.Range[Cells.Item[R, 1],
        Cells.Item[R + FRowCount - 1, 1]].EntireRow
    else
      Result := ExcelRange(TVarData(Cells.Item[R, 1]).VDispatch).EntireRow;
  end
  else if FWholeColumns then
  begin
    C := FColumnNumber + ExcelColumnOffset;
    if FColumnCount > 1 then
      Result := Cells.Range[Cells.Item[1, C],
        Cells.Item[1, C + FColumnCount - 1]].EntireColumn
    else
      Result := ExcelRange(TVarData(Cells.Item[1, C]).VDispatch).EntireColumn;
  end else
  begin
    R := FRowNumber + ExcelRowOffset;
    C := FColumnNumber + ExcelColumnOffset;
    if (FRowCount > 1) or (FColumnCount > 1) then
      Result := Cells.Range[Cells.Item[R, C],
        Cells.Item[R + FRowCount - 1, C + FColumnCount - 1]]
    else
      Result := ExcelRange(TVarData(Cells.Item[R, C]).VDispatch);
  end;
end;

function TExcelInterval.Equals(Interval: TExcelInterval): Boolean;
begin
  if Interval = Self then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
  if (Interval.FWholeRows <> FWholeRows) or
    (Interval.FWholeColumns <> FWholeColumns) then
    Exit;
  if not FWholeColumns and ((Interval.FRowNumber <> FRowNumber) or
    (Interval.FRowCount <> FRowCount)) then
    Exit;
  if not FWholeRows and ((Interval.FColumnNumber <> FColumnNumber) or
    (Interval.FColumnCount <> FColumnCount)) then
    Exit;
  Result := True;
end;

function TExcelInterval.Clone: TExcelInterval;
begin
  if FWholeRows then
    Result := TExcelInterval.Create(False, FRowNumber, FRowCount)
  else if FWholeColumns then
    Result := TExcelInterval.Create(True, FColumnNumber, FColumnCount)
  else
    Result := TExcelInterval.Create(FRowNumber, FColumnNumber,
      FRowCount, FColumnCount);
end;

function CompareExcelIntervals(Item1, Item2: Pointer): Integer;
var
  I1, I2: TExcelInterval;
begin
  I1 := TExcelInterval(Item1);
  I2 := TExcelInterval(Item2);
  if I1.FRowNumber < I2.FRowNumber then
    Result := -1
  else if I1.FRowNumber > I2.FRowNumber then
    Result := 1
  else if I1.FColumnNumber < I2.FColumnNumber then
    Result := -1
  else if I1.FColumnNumber > I2.FColumnNumber then
    Result := 1
  else
    Result := 0;
end;

{ TExcelRange }

constructor TExcelRange.Create(InitialCapacity: Integer);
begin
  FList := TArrayList.Create(InitialCapacity);
end;

constructor TExcelRange.Create(RowNumber, ColumnNumber: Integer);
begin
  FList := TArrayList.Create(16);
  FList.Add(TExcelInterval.Create(RowNumber, ColumnNumber));
end;

constructor TExcelRange.Create(RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer);
begin
  FList := TArrayList.Create(16);
  FList.Add(TExcelInterval.Create(RowNumber, ColumnNumber, RowCount, ColumnCount));
end;

constructor TExcelRange.Create(WholeColumns: Boolean; Number, Count: Integer);
begin
  FList := TArrayList.Create(16);
  FList.Add(TExcelInterval.Create(WholeColumns, Number, Count));
end;

constructor TExcelRange.Create(Interval: TExcelInterval);
begin
  FList := TArrayList.Create(16);
  FList.Add(Interval);
end;

constructor TExcelRange.Create(Range: TExcelRange);
var
  I, C: Integer;
  List: PPointerItemList;
  AL: TArrayList;
begin
  AL := Range.FList;
  FList := TArrayList.Create(AL.Count);
  C := AL.Count - 1;
  List := AL.ItemList;
  for I := 0 to C do
    FList.Add(TExcelRange(List^[I]).Clone);
  FSorted := Range.FSorted;
end;

destructor TExcelRange.Destroy;
var
  List: PPointerItemList;
  I: Integer;
begin
  List := FList.ItemList;
  for I := FList.Count - 1 downto 0 do
    TExcelInterval(List^[I]).Free;
  FList.Free;
end;

function TExcelRange.GetInterval(Index: Integer): TExcelInterval;
begin
  Result := TExcelInterval(FList.ItemList^[Index]);
end;

function TExcelRange.GetIntervalCount: Integer;
begin
  Result := FList.Count;
end;

procedure TExcelRange.EnsureSorted;
begin
  if not FSorted then
  begin
    FList.Sort(CompareExcelIntervals);
    FSorted := True;
  end;
end;

procedure TExcelRange.Add(RowNumber, ColumnNumber: Integer);
begin
  FList.Add(TExcelInterval.Create(RowNumber, ColumnNumber));
  FSorted := False;
end;

procedure TExcelRange.Add(RowNumber, ColumnNumber, RowCount, ColumnCount: Integer);
begin
  FList.Add(TExcelInterval.Create(RowNumber, ColumnNumber, RowCount, ColumnCount));
  FSorted := False;
end;

procedure TExcelRange.Add(Interval: TExcelInterval);
begin
  FList.Add(Interval);
  FSorted := False;
end;

procedure TExcelRange.Add(Range: TExcelRange);
var
  I, C: Integer;
  List: PPointerItemList;
begin
  C := Range.FList.Count - 1;
  List := Range.FList.ItemList;
  for I := 0 to C do
    FList.Add(TExcelRange(List^[I]).Clone);
  FSorted := False;
end;

procedure TExcelRange.AddRows(RowNumber, RowCount: Integer);
begin
  FList.Add(TExcelInterval.Create(False, RowNumber, RowCount));
  FSorted := False;
end;

procedure TExcelRange.AddColumns(ColumnNumber, ColumnCount: Integer);
begin
  FList.Add(TExcelInterval.Create(True, ColumnNumber, ColumnCount));
  FSorted := False;
end;

function TExcelRange.GetAbsoluteAddress: string;
var
  SB: TStringBuilder;
  List: PPointerItemList;
  I, LastIndex: Integer;
  FirstTime: Boolean;
begin
  EnsureSorted;
  SB := TStringBuilder.Create;
  FirstTime := True;
  List := FList.ItemList;
  LastIndex := FList.Count - 1;
  for I := 0 to LastIndex do
  begin
    if not FirstTime then
      SB.Append(ExcelIntervalDelimiter)
    else
      FirstTime := False;
    with TExcelInterval(List^[I]) do
    begin
      if not WholeColumns then
      begin
        SB.Append('R');
        SB.Append(RowNumber + ExcelRowOffset);
      end;
      if not WholeRows then
      begin
        SB.Append('C');
        SB.Append(ColumnNumber + ExcelColumnOffset);
      end;
      if (RowCount > 1) or (ColumnCount > 1) then
      begin
        SB.Append(':');
        if not WholeColumns then
        begin
          SB.Append('R');
          SB.Append(LastRowNumber + ExcelRowOffset);
        end;
        if not WholeRows then
        begin
          SB.Append('C');
          SB.Append(LastColumnNumber + ExcelColumnOffset);
        end;
      end;
    end;
  end;
  Result := SB.ToString;
  SB.Free;
end;

function TExcelRange.GetRelativeAddress(BaseRowNumber,
  BaseColumnNumber: Integer): string;
var
  SB: TStringBuilder;
  Delta: Integer;
  List: PPointerItemList;
  I, LastIndex: Integer;
  FirstTime: Boolean;
begin
  EnsureSorted;
  SB := TStringBuilder.Create;
  FirstTime := True;
  List := FList.ItemList;
  LastIndex := FList.Count - 1;
  for I := 0 to LastIndex do
  begin
    if not FirstTime then
      SB.Append(ExcelIntervalDelimiter)
    else
      FirstTime := False;
    with TExcelInterval(List^[I]) do
    begin
      if not WholeColumns then
      begin
        SB.Append('R');
        Delta := RowNumber - BaseRowNumber;
        if Delta <> 0 then
        begin
          SB.Append('[');
          SB.Append(Delta);
          SB.Append(']');
        end;
      end;
      if not WholeRows then
      begin
        SB.Append('C');
        Delta := ColumnNumber - BaseColumnNumber;
        if Delta <> 0 then
        begin
          SB.Append('[');
          SB.Append(Delta);
          SB.Append(']');
        end;
      end;
      if (RowCount > 1) or (ColumnCount > 1) then
      begin
        SB.Append(':');
        if not WholeColumns then
        begin
          SB.Append('R');
          Delta := LastRowNumber - BaseRowNumber;
          if Delta <> 0 then
          begin
            SB.Append('[');
            SB.Append(Delta);
            SB.Append(']');
          end;
        end;
        if not WholeRows then
        begin
          SB.Append('C');
          Delta := LastColumnNumber - BaseColumnNumber;
          if Delta <> 0 then
          begin
            SB.Append('[');
            SB.Append(Delta);
            SB.Append(']');
          end;
        end;
      end;
    end;
  end;
  Result := SB.ToString;
  SB.Free;
end;

function CollapseUnion(Count: Integer): ExcelRange;
begin
  while Count < 28 do
  begin
    Ranges[Count] := Null;
    Inc(Count);
  end;
  Result := ExcelApp.Union(Range1, Range2, Ranges[0], Ranges[1], Ranges[2],
    Ranges[3], Ranges[4], Ranges[5], Ranges[6], Ranges[7], Ranges[8], Ranges[9],
    Ranges[10], Ranges[11], Ranges[12], Ranges[13], Ranges[14], Ranges[15],
    Ranges[16], Ranges[17], Ranges[18], Ranges[19], Ranges[20], Ranges[21],
    Ranges[22], Ranges[23], Ranges[24], Ranges[25], Ranges[26], Ranges[27], 0);
end;

function TExcelRange.GetRange(Cells: ExcelRange): ExcelRange;
var
  List: PPointerItemList;
  I, LastIndex: Integer;
  Count: Integer;
  Range: ExcelRange;
begin
  EnsureSorted;
  List := FList.ItemList;
  LastIndex := FList.Count - 1;
  if LastIndex < 0 then
  begin
    Result := nil;
    Exit;
  end;
  Range := TExcelInterval(List^[0]).GetRange(Cells);
  if LastIndex = 0 then
  begin
    Result := Range;
    Exit;
  end;
  Range1 := Range;
  Range2 := TExcelInterval(List^[1]).GetRange(Cells);
  Count := 0;
  for I := 2 to LastIndex do
  begin
    Range := TExcelInterval(List^[I]).GetRange(Cells);
    if Count < 28 then
    begin
      Ranges[Count] := Range;
      Inc(Count);
    end else
    begin
      Range1 := CollapseUnion(Count);
      Range2 := Range;
      Count := 0;
    end;
  end;
  Result := CollapseUnion(Count);
end;

procedure TExcelRange.Clear;
var
  List: PPointerItemList;
  I: Integer;
begin
  List := FList.ItemList;
  for I := FList.Count - 1 downto 0 do
    TExcelInterval(List^[I]).Free;
  FList.Count := 0;
end;

function TExcelRange.Equals(Range: TExcelRange): Boolean;
var
  I: Integer;
  L1, L2: PPointerItemList;
begin
  Result := False;
  if Range = Self then
    Result := True
  else if Range.FList.Count = FList.Count then
  begin
    EnsureSorted;
    L1 := FList.ItemList;
    Range.EnsureSorted;
    L2 := Range.FList.ItemList;
    for I := FList.Count - 1 downto 0 do
      if not TExcelInterval(L1^[I]).Equals(TExcelInterval(L2^[I])) then
        Exit;
    Result := True;
  end;
end;

function TExcelRange.Clone: TExcelRange;
begin
  Result := TExcelRange.Create(Self);
end;

{ Глобальные методы }

function StartExcel: Boolean;
var
  I: Integer;
  Bars: CommandBars;
  Bar: CommandBar;
  Controls: CommandBarControls;
  Control: CommandBarControl;
  Button: CommandBarButton;
begin
  Result := True;
  if ExcelApp = nil then
  begin
    try
      ExcelApp := CreateOleObject('Excel.Application') as _Application;
    except
      ShowMessage(SErrMSExcelNotFound);
      Result := False;
      Exit;
    end;
    OldSheetsInNewWorkbook := ExcelApp.SheetsInNewWorkbook[0];
    OldDisplayFormulaBar := ExcelApp.DisplayFormulaBar[0];
    OldDisplayStatusBar := ExcelApp.DisplayStatusBar[0];
    ExcelApp.DisplayStatusBar[0] := False;
    ExcelApp.DisplayFormulaBar[0] := False;
    Bars := ExcelApp.CommandBars;
    VisibleCommandBars := TBitList.Create(Bars.Count);
    for I := 3 to VisibleCommandBars.Count do
    begin
      Bar := Bars.Item[I];
      if Bar.Visible then
      begin
        VisibleCommandBars[I - 1] := True;
        Bar.Set_Visible(False);
      end;
    end;
    Bar := Bars.Add('AcedExcelReport CommandBar', msoBarTop, True, True);
    Controls := Bar.Get_Controls;
    Button := Controls.Add(msoControlButton, 752, 0, 1, True) as CommandBarButton;
    Button.Set_Style(msoButtonCaption);
    Control := Controls.Add(msoControlButton, 19, 0, 2, True);
    Control.Set_BeginGroup(True);
    Controls.Add(msoControlButton, 748, 0, 3, True);
    Controls.Add(msoControlButton, 723, 0, 4, True);
    Controls.Add(msoControlButton, 724, 0, 5, True);
    Control := Controls.Add(msoControlButton, 109, 0, 6, True);
    Control.Set_BeginGroup(True);
    Controls.Add(msoControlButton, 4, 0, 7, True);
    Controls.Add(msoControlButton, 247, 0, 8, True);
    Control := Controls.Add(msoControlComboBox, 1733, 0, 9, True);
    Control.Set_Width(52);
    Controls.Add(msoControlButton, 444, 0, 10, True);
    Controls.Add(msoControlButton, 445, 0, 11, True);
    Controls.Add(msoControlButton, 1849, 0, 12, True);
    Controls.Add(msoControlButton, 298, 0, 13, True);
    Controls.Add(msoControlButton, 302, 0, 14, True);
    Controls.Add(msoControlButton, 443, 0, 15, True);
    Bar.Set_Visible(True);
  end;
end;

procedure ShutdownExcel;
var
  I: Integer;
  Bars: CommandBars;
begin
  if ExcelApp <> nil then
  begin
    G_ToggleKey(tkScrollLock, False);
    try
      Bars := ExcelApp.CommandBars;
      for I := 3 to VisibleCommandBars.Count do
        if VisibleCommandBars[I - 1] then
          Bars.Item[I].Set_Visible(True);
      VisibleCommandBars.Free;
      ExcelApp.SheetsInNewWorkbook[0] := OldSheetsInNewWorkbook;
      ExcelApp.DisplayFormulaBar[0] := OldDisplayFormulaBar;
      ExcelApp.DisplayStatusBar[0] := OldDisplayStatusBar;
      ExcelApp.Quit;
    except
    end;
    ExcelApp := nil;
  end;
end;

function CreateExcelWorkbook(var WB: _Workbook; SheetsInNewWorkbook: Integer): Boolean;
begin
  Result := True;
  try
    ExcelApp.SheetsInNewWorkbook[0] := SheetsInNewWorkbook;
    WB := ExcelApp.Workbooks.Add(Null, 0);
  except
    ShowMessage('Ошибка при создании рабочей книги.');
    WB := nil;
    Result := False;
  end;
end;

function CreateExcelWorkbook(var WB: _Workbook;
  const TemplateFileName: string): Boolean;
begin
  Result := True;
  try
    WB := ExcelApp.Workbooks.Add(TemplateFileName, 0);
  except
    ShowMessage('Ошибка при открытии шаблона ' + TemplateFileName + '.');
    WB := nil;
    Result := False;
  end;
end;

procedure InitializeExcelWorkbook(WB: _Workbook; const Caption: string;
  DisplayWorkbookTabs, DisplayZeros, DisplayHeadings, DisplayGridlines,
  DisplayHorizontalScrollBar, DisplayVerticalScrollBar: Boolean);
var
  W: Excel97.Window;
begin
  W := WB.Windows.Item[1];
  W.Caption := Caption;
  W.DisplayWorkbookTabs := DisplayWorkbookTabs;
  W.DisplayZeros := DisplayZeros;
  W.DisplayHeadings := DisplayHeadings;
  W.DisplayGridlines := DisplayGridLines;
  W.DisplayHorizontalScrollBar := DisplayHorizontalScrollBar;
  W.DisplayVerticalScrollBar := DisplayVerticalScrollBar;
  ExcelRowOffset := 0;
  ExcelColumnOffset := 0;
end;

function GetExcelCell(Cells: ExcelRange; RowNumber, ColumnNumber: Integer): ExcelRange;
begin
  Result := ExcelRange(TVarData(Cells.Item[RowNumber + ExcelRowOffset,
    ColumnNumber + ExcelColumnOffset]).VDispatch);
end;

function GetExcelRange(Cells: ExcelRange; RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer): ExcelRange;
begin
  if (RowCount > 1) or (ColumnCount > 1) then
  begin
    Inc(RowNumber, ExcelRowOffset);
    Inc(ColumnNumber, ExcelColumnOffset);
    Result := Cells.Range[Cells.Item[RowNumber, ColumnNumber],
      Cells.Item[RowNumber + RowCount - 1, ColumnNumber + ColumnCount - 1]];
  end else
    Result := GetExcelCell(Cells, RowNumber, ColumnNumber);
end;

function GetNamedExcelRange(Cells: ExcelRange; const Name: string): ExcelRange;
begin
  Result := Cells.Range[Name, Name];
end;

function GetExcelRows(Cells: ExcelRange; RowNumber, RowCount: Integer): ExcelRange;
begin
  if RowCount > 1 then
    Result := GetExcelRange(Cells, RowNumber, 1, RowCount, 1).EntireRow
  else
    Result := GetExcelCell(Cells, RowNumber, 1).EntireRow;
end;

function GetExcelColumns(Cells: ExcelRange;
  ColumnNumber, ColumnCount: Integer): ExcelRange;
begin
  if ColumnCount > 1 then
    Result := GetExcelRange(Cells, 1, ColumnNumber, 1, ColumnCount).EntireColumn
  else
    Result := GetExcelCell(Cells, 1, ColumnNumber).EntireColumn;
end;

procedure InsertExcelRows(Cells: ExcelRange; NextRowNumber, RowCount: Integer);
var
  Range: ExcelRange;
begin
  Range := GetExcelCell(Cells, NextRowNumber, 1).EntireRow;
  while RowCount > 0 do
  begin
    Range.Insert(Null);
    Dec(RowCount);
  end;
end;

procedure InsertExcelColumns(Cells: ExcelRange; NextColumnNumber,
  ColumnCount: Integer);
var
  Range: ExcelRange;
begin
  Range := GetExcelCell(Cells, 1, NextColumnNumber).EntireColumn;
  while ColumnCount > 0 do
  begin
    Range.Insert(Null);
    Dec(ColumnCount);
  end;
end;

function GetAbsoluteAddress(RowNumber, ColumnNumber,
  RowCount, ColumnCount: Integer): string;
var
  SB: TStringBuilder;
begin
  Inc(RowNumber, ExcelRowOffset);
  Inc(ColumnNumber, ExcelColumnOffset);
  SB := TStringBuilder.Create;
  SB.Append('R');
  SB.Append(RowNumber);
  SB.Append('C');
  SB.Append(ColumnNumber);
  if (RowCount > 1) or (ColumnCount > 1) then
  begin
    SB.Append(':');
    SB.Append('R');
    SB.Append(RowNumber + RowCount - 1);
    SB.Append('C');
    SB.Append(ColumnNumber + ColumnCount - 1);
  end;
  Result := SB.ToString;
  SB.Free;
end;

function GetRelativeAddress(BaseRowNumber, BaseColumnNumber,
  RowNumber, ColumnNumber, RowCount, ColumnCount: Integer): string;
var
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  SB.Append('R');
  Dec(RowNumber, BaseRowNumber);
  if RowNumber <> 0 then
  begin
    SB.Append('[');
    SB.Append(RowNumber);
    SB.Append(']');
  end;
  SB.Append('C');
  Dec(ColumnNumber, BaseColumnNumber);
  if ColumnNumber <> 0 then
  begin
    SB.Append('[');
    SB.Append(ColumnNumber);
    SB.Append(']');
  end;
  if (RowCount > 1) or (ColumnCount > 1) then
  begin
    SB.Append(':');
    SB.Append('R');
    Inc(RowNumber, RowCount - 1);
    if RowNumber <> 0 then
    begin
      SB.Append('[');
      SB.Append(RowNumber);
      SB.Append(']');
    end;
    SB.Append('C');
    Inc(ColumnNumber, ColumnCount - 1);
    if ColumnNumber <> 0 then
    begin
      SB.Append('[');
      SB.Append(ColumnNumber);
      SB.Append(']');
    end;
  end;
  Result := SB.ToString;
  SB.Free;
end;

procedure AssignAbsoluteFormula(SourceRowNumber, SourceColumnNumber,
  SourceRowCount, SourceColumnCount: Integer; F: TExcelRangeFunction;
  TargetRange: ExcelRange);
begin
  TargetRange.FormulaR1C1Local := ExcelRangeFunctions[Integer(F)] +
    GetAbsoluteAddress(SourceRowNumber, SourceColumnNumber,
    SourceRowCount, SourceColumnCount) + ')';
end;

procedure AssignAbsoluteFormula(SourceRange: TExcelRange;
  F: TExcelRangeFunction; TargetRange: ExcelRange);
begin
  if (SourceRange <> nil) and (SourceRange.FList.Count > 0) then
  begin
    TargetRange.FormulaR1C1Local := ExcelRangeFunctions[Integer(F)] +
      SourceRange.GetAbsoluteAddress + ')';
  end else
    TargetRange.Value := 0;
end;

procedure AssignRelativeFormula(BaseRowNumber, BaseColumnNumber,
  SourceRowNumber, SourceColumnNumber, SourceRowCount, SourceColumnCount: Integer;
  F: TExcelRangeFunction; TargetRange: ExcelRange);
begin
  TargetRange.FormulaR1C1Local := ExcelRangeFunctions[Integer(F)] +
    GetRelativeAddress(BaseRowNumber, BaseColumnNumber, SourceRowNumber,
    SourceColumnNumber, SourceRowCount, SourceColumnCount) + ')';
end;

procedure AssignRelativeFormula(BaseRowNumber, BaseColumnNumber: Integer;
  SourceRange: TExcelRange; F: TExcelRangeFunction; TargetRange: ExcelRange);
begin
  if (SourceRange <> nil) and (SourceRange.FList.Count > 0) then
  begin
    TargetRange.FormulaR1C1Local := ExcelRangeFunctions[Integer(F)] +
      SourceRange.GetRelativeAddress(BaseRowNumber, BaseColumnNumber) + ')';
  end else
    TargetRange.Value := 0;
end;

procedure UpdateBorder(B: Border; Weight: TExcelBorderWeight;
  LineStyle: TExcelLineStyle; ColorIndex: Integer);
begin
  if LineStyle <> xllsNone then
  begin
    B.Weight := Integer(Weight);
    B.ColorIndex := ColorIndex;
  end;
  B.LineStyle := Integer(LineStyle);
end;

procedure DrawExcelBorders(Range: ExcelRange; CellBorders: Integer;
  Weight: TExcelBorderWeight; LineStyle: TExcelLineStyle;
  ColorIndex: Integer);
var
  bs: Borders;
begin
  bs := Range.Borders;
  if CellBorders and xlcbEdgeLeft <> 0 then
    UpdateBorder(bs.Item[xlEdgeLeft], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbEdgeRight <> 0 then
    UpdateBorder(bs.Item[xlEdgeRight], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbEdgeTop <> 0 then
    UpdateBorder(bs.Item[xlEdgeTop], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbEdgeBottom <> 0 then
    UpdateBorder(bs.Item[xlEdgeBottom], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbInsideHorizontal <> 0 then
    UpdateBorder(bs.Item[xlInsideHorizontal], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbInsideVertical <> 0 then
    UpdateBorder(bs.Item[xlInsideVertical], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbDiagonalUp <> 0 then
    UpdateBorder(bs.Item[xlDiagonalUp], Weight, LineStyle, ColorIndex);
  if CellBorders and xlcbDiagonalDown <> 0 then
    UpdateBorder(bs.Item[xlDiagonalDown], Weight, LineStyle, ColorIndex);
end;

procedure ClearExcelBorders(Range: ExcelRange; CellBorders: Integer);
var
  bs: Borders;
begin
  bs := Range.Borders;
  if CellBorders and xlcbEdgeLeft <> 0 then
    bs.Item[xlEdgeLeft].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbEdgeRight <> 0 then
    bs.Item[xlEdgeRight].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbEdgeTop <> 0 then
    bs.Item[xlEdgeTop].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbEdgeBottom <> 0 then
    bs.Item[xlEdgeBottom].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbInsideHorizontal <> 0 then
    bs.Item[xlInsideHorizontal].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbInsideVertical <> 0 then
    bs.Item[xlInsideVertical].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbDiagonalUp <> 0 then
    bs.Item[xlDiagonalUp].LineStyle := xlLineStyleNone;
  if CellBorders and xlcbDiagonalDown <> 0 then
    bs.Item[xlDiagonalDown].LineStyle := xlLineStyleNone;
end;

procedure FillExcelInterior(Range: ExcelRange; ColorIndex, Pattern,
  PatternColorIndex: Integer);
var
  Inter: Interior;
begin
  Inter := Range.Interior;
  Inter.Pattern := Pattern;
  if Pattern <> Integer(xlPatternNone) then
  begin
    Inter.ColorIndex := ColorIndex;
    if Pattern <> xlPatternSolid then
      Inter.PatternColorIndex := PatternColorIndex;
  end;
end;

procedure FreezeExcelRows(WB: _Workbook; RowNumber1, RowNumber2: Integer);
begin
  with WB.Windows.Item[1] do
  begin
    FreezePanes := False;
    ScrollRow := RowNumber1 + ExcelRowOffset;
    SplitRow := RowNumber2 - RowNumber1 + 1;
    FreezePanes := True;
  end;
end;

procedure FreezeExcelColumns(WB: _Workbook; ColumnNumber1, ColumnNumber2: Integer);
begin
  with WB.Windows.Item[1] do
  begin
    FreezePanes := False;
    ScrollColumn := ColumnNumber1 + ExcelColumnOffset;
    SplitColumn := ColumnNumber2 - ColumnNumber1 + 1;
    FreezePanes := True;
  end;
end;

procedure ProtectExcelWorksheet(WS: _Worksheet);
begin
  WS.EnableSelection := xlNoSelection;
  WS.Protect(Null, Null, Null, Null, Null, 0);
end;

procedure ShowExcelWorkbook(WB: _Workbook);
begin
  WB.Saved[0] := True;
  ExcelApp.Visible[0] := True;
  WB.Activate(0);
end;

initialization

finalization
  ShutdownExcel;

end.

