
////////////////////////////////////////////////////
//                                                //
//   AcedCommon 1.16                              //
//                                                //
//   Константы и функции различного назначения.   //
//                                                //
//   mailto: acedutils@yandex.ru                  //
//                                                //
////////////////////////////////////////////////////

unit AcedCommon;

{$B-,H+,R-,Q-,T-,X+}

{$INCLUDE AcedUtils.inc}

interface

{ Константные массивы, содержащие названия месяцев и дней недели }

const

{ Полные названия месяцев по-русски с большой буквы }

  MonthLongNameUp: array[1..12] of AnsiString =
    ('Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август',
     'Сентябрь','Октябрь','Ноябрь','Декабрь');

{ Полные названия месяцев по-русски с маленькой буквы }

  MonthLongNameLo: array[1..12] of AnsiString =
    ('января','февраля','марта','апреля','мая','июня','июля','августа',
     'сентября','октября','ноября','декабря');

{ Полные названия месяцев по-английски }

  MonthLongNameEng: array[1..12] of AnsiString =
    ('January','February','March','April','May','June','July','August',
     'September','October','November','December');

{ Сокращенные названия месяцев по-русски с большой буквы }

  MonthShortNameUp: array[1..12] of AnsiString =
    ('Янв','Фев','Мар','Апр','Май','Июн','Июл','Авг','Сен','Окт','Ноя','Дек');

{ Сокращенные названия месяцев по-русски с маленькой буквы }

  MonthShortNameLo: array[1..12] of AnsiString =
    ('янв','фев','мар','апр','мая','июн','июл','авг','сен','окт','ноя','дек');

{ Сокращенные названия месяцев по-английски }

  MonthShortNameEng: array[1..12] of AnsiString =
    ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

{ Полные названия дней недели по-русски }

  WeekDayLongName: array[1..7] of AnsiString =
    ('воскресенье','понедельник','вторник','среда','четверг',
     'пятница','суббота');

{ Полные названия дней недели по-английски }

  WeekDayLongNameEng: array[1..7] of AnsiString =
    ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

{ Сокращенные названия дней недели из двух букв по-русски }

  WeekDayShortName2: array[1..7] of AnsiString =
    ('вс','пн','вт','ср','чт','пт','сб');

{ Сокращенные названия дней недели из трех букв по-русски }

  WeekDayShortName3: array[1..7] of AnsiString =
    ('вск','пон','втр','срд','чет','пят','суб');

{ Сокращенные названия дней недели из трех букв по-английски }

  WeekDayShortNameEng: array[1..7] of AnsiString =
    ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');

    
{ Функции для работы с датой и временем }

{ G_FormatDate преобразует дату в строку по формату, заданному параметром
  FormatFlags. Возможные значения для параметра FormatFlags: }

const
  dfNoDate            = $0000; // ''
  dfCompact           = $0001; // '09.02.04'
  dfLetterCompact     = $0002; // '9-фев-04'
  dfShort             = $0003; // '09.02.2004'
  dfNormal            = $0004; // '9 февраля 2004 г.'
  dfLong              = $0005; // '9 февраля 2004 года'
  dfMonthYear         = $0006; // 'Февраль 2004 г.'
  dfDayMonth          = $0007; // '9 февраля'
  dfSortable          = $0008; // '2004-02-09'

  dfWeekDayCompact    = $0100; // 'вт'
  dfWeekDayShort      = $0200; // 'втр'
  dfWeekDayFull       = $0300; // 'вторник'

{ Константы, выбирающие формат даты, могут комбинироваться с константами,
  выбирающими формат дня недели, с помощью "or". В этом случае название дня
  недели будет следовать после даты и отделяться от нее запятой. }

function G_FormatDate(const DateTime: TDateTime; FormatFlags: LongWord = dfNormal): AnsiString;

{ G_FormatTime преобразует время в строку по формату, заданному параметром
  FormatFlags. Возможные значения для параметра FormatFlags: }

const
  tfShort            = $0000; // '8:00'
  tfFull             = $0001; // '8:00:59'

  tfTwoDigitHour     = $0010; // '08:00'

  tfFracOneDigit     = $0100; // '8:00:59.9'
  tfFracTwoDigits    = $0200; // '8:00:59.99'
  tfFracThreeDigits  = $0300; // '8:00:59.999'

{ Эти константы могут комбинироваться друг с другом с помощью "or". }

function G_FormatTime(const DateTime: TDateTime; FormatFlags: LongWord = tfShort): AnsiString;

{ G_SplitDate для значения даты, переданной параметром DateTime (например,
  5 апреля 2004 г.) возвращает день (5), как результат функции, и месяц
  с годом в переменной MonthYear ('апреля 2004 г.'). }

function G_SplitDate(const DateTime: TDateTime; out MonthYear: AnsiString): Integer;


{ Работа со значениями типа Double и Currency }

{ G_ToDouble преобразует значение типа Currency к типу Double. }

function G_ToDouble(const Amount: Currency): Double;

{ G_ThousandsToDouble возвращает значение Amount, деленное на тысячу и
  округленное до трех знаков после запятой, приведенное к типу Double. }

function G_ThousandsToDouble(const Amount: Currency): Double;

{ G_Inc складывает значение первого параметра со значением второго. Результат
  сохраняется в первом параметре. }

procedure G_Inc(var V: Currency; const X: Currency); overload;
procedure G_Inc(var V: Double; const X: Double); overload;

{ G_Dec вычитает значение второго параметра из значения первого. Результат
  сохраняется в первом параметре. }

procedure G_Dec(var V: Currency; const X: Currency); overload;
procedure G_Dec(var V: Double; const X: Double); overload;

{ G_Mult умножает значение первого параметра на значение второго. Результат
  сохраняется в первом параметре. }

procedure G_Mult(var V: Currency; const K: Double); overload;
procedure G_Mult(var V: Double; const K: Double); overload;

{ G_Div делит значение первого параметра на значение второго. Результат
  сохраняется в первом параметре. }

procedure G_Div(var V: Currency; const K: Double); overload;
procedure G_Div(var V: Double; const K: Double); overload;


{ Функции для расчета контрольных сумм. Они используются при проверке
  целостности данных. Например, после передачи данных по каналу связи
  контрольная сумма, рассчитанная для массива байт, должна быть равна значению
  исходной контрольной суммы, рассчитанной до передачи данных. Тогда с большой
  вероятностью можно предположить, что данные переданы без ошибок. }

{ G_Adler32 вычисляет контрольную сумму Адлера в соответствии с RFC 1950 для
  области памяти, адресуемой параметром P. Размер области памяти в байтах
  задается параметром L. }

function G_Adler32(P: Pointer; L: Cardinal): LongWord;

{ G_CRC32 вычисляет контрольную сумму CRC-32 для области памяти, адресуемой
  параметром P. Размер области памяти в байтах задается параметром L. }

function G_CRC32(P: Pointer; L: Cardinal): LongWord;

{ G_NextCRC32 вычисляет по исходному значению контрольной суммы CRC-32 новое
  значение, которое учитывает следующий фрагмент данных, находящийся в области
  памяти, адрес которой передается параметром P, размером L байт. Новое CRC32
  возвращается как значение одноименного параметра, а также как результат
  функции. Когда эта функция вызывается для самого первого фрагмента данных,
  в параметре CRC32 следует передавать 0. }

function G_NextCRC32(var CRC32: LongWord; P: Pointer; L: Cardinal): LongWord;

{ G_CRC32_Str вычисляет контрольную сумму CRC-32 для строки S. В отличие от
  функции G_CRC32_Text, если две строки различаются только регистром символов,
  значение контрольной суммы будет для них различным. }

function G_CRC32_Str(const S: AnsiString): LongWord; overload;
function G_CRC32_Str(P: Pointer): LongWord; overload;

{ G_CRC32_Text вычисляет контрольную сумму CRC-32 для строки S. В отличие от
  функции G_CRC32_Str, если две строки различаются только регистром символов,
  значение контрольной суммы будет для них одинаковым. }

function G_CRC32_Text(const S: AnsiString): LongWord; overload;
function G_CRC32_Text(P: Pointer): LongWord; overload;


{ Функции для перекодировки строк и массива байт }

{ G_Base64Encode возвращает строку S или байтовый массив P длиной L байт,
  представленные в кодировке Base64. Выходная строка дополняется символами
  '=' до длины, кратной 4. }

procedure IntBase64Encode(P1, P2: Pointer; L: Integer); // ***

function G_Base64Encode(P: Pointer; L: Integer): AnsiString; overload;
function G_Base64Encode(const S: AnsiString): AnsiString; overload;



{ G_Base64Decode возвращает результат декодирования строки S из Base64, т.е.
  восстанавливает первоначальное содержимое строки или байтового массива.
  Длина закодированной строки должна быть кратна 4 символам. Параметр P должен
  указывать на область памяти, достаточную для хранения декодированной строки.
  Функция возвращает длину строки-результата в байтах. Если в P передается nil,
  функция только возвращает длину байтового массива, необходимого для
  сохранения выходных данных. }

function IntBase64Decode(P1, P2: Pointer; L: Integer): Integer;

function G_Base64Decode(const S: AnsiString; P: Pointer): Integer; overload;
function G_Base64Decode(const S: AnsiString): AnsiString; overload;

{ G_StrToCodes возвращает строку, состоящую из шестнадцатеричных кодов
  символов строки S. Например, G_StrToCodes('A?<*') -> '413F3C2A'.
  Исходная строка при этом не изменяется. }

function G_StrToCodes(const S: AnsiString): AnsiString;

{ G_CodesToStr преобразует строку S, состоящую из шестнадцатеричных кодов,
  в строку символов и возвращает ее как результат функции. Например,
  G_CodesToStr('413F3C2A') -> 'A?<*'. Исходная строка при этом не изменяется.
  Если во время преобразования происходит ошибка, возникает исключение
  EConvertError. }

function G_CodesToStr(const S: AnsiString): AnsiString;


{ Функции для преобразования числа в строку и строки в число }

{ G_IntToStr возвращает десятичную запись числа N в виде строки. }

function G_IntToStr(N: Integer): AnsiString;

{ G_UIntToStr возвращает десятичную запись беззнакового числа N в виде строки. }

function G_UIntToStr(N: LongWord): AnsiString;

{ G_UIntToStrL возвращает десятичную запись беззнакового числа N в виде строки.
  Параметр Digits задает количество символов в возвращаемом числе. При
  необходимости, оно обрезается слева или дополняется нулями слева до длины
  Digits. }

function G_UIntToStrL(N: LongWord; Digits: Cardinal): AnsiString;

{ G_UIntToHex возвращает шестнадцатеричную запись беззнакового числа N в виде
  строки. Параметр Digits задает количество цифр в возвращаемом числе. При
  необходимости, оно обрезается слева или дополняется нулями слева до длины
  Digits. }

function G_UIntToHex(N: LongWord; Digits: Cardinal = 8): AnsiString;

{ G_HexToUInt преобразует шестнадцатеричное число, переданное строкой S,
  в целое беззнаковое число. Если во время преобразования происходит ошибка,
  возникает исключение EConvertError. }

function G_HexToUInt(const S: AnsiString): LongWord;

{ G_AdjustSeparator заменяет первую точку в строке S на запятую, если символ
  DecimalSeparator, определенный в модуле SysUtils, равен запятой, либо
  заменяет первую запятую в строке S на точку, если DecimalSeparator равен
  точке. После применения этой функции к строке она может быть преобразована
  в число с дробной частью независимо от того, каким символом отделяется
  дробная часть (точкой или запятой). Следует, однако, помнить, что процедура
  Val не обращает внимания на DecimalSeparator и всегда ожидает, что дробная
  часть отделяется точкой. }

function G_AdjustSeparator(const S: AnsiString): AnsiString;

{ Функции G_Between_... возвращают True, если строка S содержит число (целое,
  целое без знака, 64-битное целое, вещественное или число, обозначающее
  денежную сумму), находящееся в диапазоне от LowBound до HighBound, включая
  границы диапазона. Иначе, функции возвращают False. При работе с функциями
  G_Between_Extended и G_Between_Currency необходимо учитывать, что целая часть
  числа должна отделяться от дробной части символом, назначенным переменной
  DecimalSeparator, определенной в модуле SysUtils. }

function G_Between_Integer(const S: AnsiString; LowBound, HighBound: Integer): Boolean;
function G_Between_LongWord(const S: AnsiString; LowBound, HighBound: LongWord): Boolean;
function G_Between_Int64(const S: AnsiString; LowBound, HighBound: Int64): Boolean;
function G_Between_Extended(const S: AnsiString; LowBound, HighBound: Extended): Boolean;
function G_Between_Currency(const S: AnsiString; LowBound, HighBound: Currency): Boolean;

{ Функции G_StrTo_... преобразуют число, символьная запись которого передается
  строкой S, в обычную числовую форму. Результат преобразования сохраняется в
  переменной V. Если преобразование строки S в число выполнено успешно,
  функции возвращают True. Если в ходе преобразования возникла ошибка, функции
  возвращают False. Исключение при этом не возникает. }

function G_StrTo_Integer(const S: AnsiString; var V: Integer): Boolean;
function G_StrTo_LongWord(const S: AnsiString; var V: LongWord): Boolean;
function G_StrTo_Int64(const S: AnsiString; var V: Int64): Boolean;
function G_StrTo_Extended(const S: AnsiString; var V: Extended): Boolean;
function G_StrTo_Currency(const S: AnsiString; var V: Currency): Boolean;

{ G_ModDiv10 оптимальным образом выполняет следующие операции:
  Result := V mod 10; V := V div 10. Значение переменной V изменяется. }

function G_ModDiv10(var V: LongWord): Integer;

{ G_NumToStr сохраняет в строке S число, переданное параметром N, записанное
  прописью по-русски. Параметр FormatFlags определяет способ преобразования
  числа в строку: }

const
  nfFull    = 0; // Полное название триад:  тысяча, миллион, ...
  nfShort   = 4; // Краткое название триад:  тыс., млн., ...

  nfMale    = 0; // Мужской род
  nfFemale  = 1; // Женский род
  nfMiddle  = 2; // Средний род

{ Эти константы можно объединять с помощью "or". Функция G_NumToStr возвращает
  номер формы, в которой должно стоять следующее за данным числом слово, т.е.
  одно из следующих значений: }

  rfFirst  = 1;  // Первая форма: "один слон" или "двадцать одна кошка"
  rfSecond = 2;  // Вторая форма: "три слона" или "четыре кошки"
  rfThird  = 3;  // Третья форма: "шесть слонов" или "восемь кошек"

{ Cтрока, возвращаемая в параметре S, всегда заканчивается пробелом. Чтобы
  убрать его, вызовите G_CutRight(S, 1). }

function G_NumToStr(N: Int64; var S: AnsiString; FormatFlags: LongWord = 0): Integer;

{ G_NumToRub возвращает денежную сумму прописью. В параметре V передается
  численное значение денежной суммы в рублях. Сотые доли выражают копейки.
  Параметры RubFormat и CopFormat определяют формат записи, соответственно,
  рублей и копеек. Возможные значения для форматов: }

const
  ruNumFull     = 0; // Полный числовой формат: "342 рубля" или "25 копеек"
  ruFull        = 2; // Полный строчный формат: "Один рубль" или "две копейки"
  ruNumShort    = 1; // Краткий числовой формат: "475084 руб." или "15 коп."
  ruShort       = 3; // Краткий строчный формат: "Пять руб." или "десять коп."
  ruShortTriad  = 4; // Краткая запись названий триад: тыс., млн., ...
  ruNone        = 8; // Нет рублей, нет копеек или простая числовая запись

{ Если параметр CopFormat равен ruNone, сумма округляется до рублей и копейки
  не выводятся. Если параметр RubFormat равен ruNone, рубли не выводятся, а
  к копейкам прибавляется число рублей, умноженное на 100. Если оба параметра
  равны ruNone, просто возвращается строка, содержащая число V. Константа
  ruShortTriad комбинируется с другими константами с помощью операции or.
  Возвращаемая строка начинается с большой буквы. Если денежная сумма
  отрицательная, строка заключается в круглые скобки. }

function G_NumToRub(V: Currency; RubFormat: LongWord = ruFull;
  CopFormat: LongWord = ruNumShort): AnsiString;


{ Работа со счетчиками и таймерами. }

{ G_TickCountSince возвращает число миллисекунд, которое прошло с того
  момента, как функция Windows.GetTickCount вернула значение Tick. Здесь
  учитывается, что счетчик миллисекунд обнуляется каждые 49,7 дней. }

function G_TickCountSince(Tick: LongWord): LongWord;

{ G_QueryPC возвращает текущее значение таймера высокого разрешения, если
  он присутствует в системе. Эта функция позволяет точно засекать временные
  интервалы. Ее можно вызвать, например, до и после выполнения некоторой
  операции, а затем передать разность полученных значений в функцию
  G_GetTimeInterval, которая вернет время выполнения данной операции в
  миллисекундах. }

function G_QueryPC: Int64;

{ G_GetTimeInterval вычисляет и возвращает как результат функции длительность
  временного интервала в миллисекундах, соответствующего разности PC_Delta
  значений функции G_QueryPC. }

function G_GetTimeInterval(PC_Delta: Int64): LongWord;

{ G_GetPC_Delta возвращает разность значений функции G_QueryPC, соответствующую
  временному интервалу, равному TimeInterval миллисекунд. }

function G_GetPC_Delta(TimeInterval: LongWord): Int64;

{ G_RDTSC считывает значение 64-разрядного счетчика, который увеличивается
  при каждом такте процессора. }

function G_RDTSC: Int64;


{ Прочие функции }

{ G_SwitchToApplication находит окно с именем класса, соответствующим
  значению параметра MainFormClassName, и активизирует породившее его
  приложение, т.е. переводит это приложение на передний план. Если класс
  окна с таким именем не найден, функция возвращает False. В случае
  успеха функция возвращает True. }

const
  WM_USER_SWITCH_TO = $B510;

{ Экземпляр класса с именем MainFormClassName должен обрабатывать сообщение
  WM_USER_SWITCH_TO следующим образом:

  procedure WMUserSwitchTo(var Msg: TWMNoParams); message WM_USER_SWITCH_TO;

  procedure TMainForm.WMUserSwitchTo(var Msg: TWMNoParams);
  var
    AppHandle, TopWindow: HWND;
  begin
    Application.Restore;
    Msg.Result := 0;
    AppHandle := Application.Handle;
    if AppHandle <> 0 then
    begin
      TopWindow := GetLastActivePopup(AppHandle);
      if (TopWindow <> 0) and (TopWindow <> AppHandle) and
        IsWindowVisible(TopWindow) and IsWindowEnabled(TopWindow) then
        Msg.Result := TopWindow;
    end;
  end;

  Для предотвращения повторного запуска приложения достаточно поставить
  в начале файла-проекта следующую проверку:

  if G_SwitchToApplication('MainFormClassName') then
    Exit;

  где MainFormClassName - имя класса главной формы приложения, которая
  обрабатывает сообщение WM_USER_SWITCH_TO. }

function G_SwitchToApplication(const MainFormClassName: AnsiString): Boolean;

{ G_SelectMenu активизирует меню текущего окна, выбирает пункт с номером,
  соответствующим первому элементу массива ItemNumbers (нумерация пунктов
  с единицы), активизирует этот пункт, если в ItemNumbers содержится
  более одного числа, выбирает подпункт с номером, соответствующим второму
  элементу массива ItemsNumbers, активизирует этот подпункт, если в
  ItemNumbers находится более двух чисел, выбирает подпункт с номером,
  соответствующим третьему элементу массива ItemsNumbers и т.д. Чтобы
  не просто отметить, но и раскрыть конечный пункт меню, нужно добавить
  в конец массива ItemNumbers дополнительную единицу. }

procedure G_SelectMenu(ItemNumbers: array of Integer);

{ G_ToggleKey изменяет состояние управляющих клавиш: Num Lock, Caps Lock,
  Scroll Lock. Параметр Key принимает одно из следующих значений: }

const
  tkNumLock = 144;
  tkCapsLock = 20;
  tkScrollLock = 145;

{ Если OnState равно True, соответствующий индикатор включается, если False,
  выключается. }

procedure G_ToggleKey(Key: Integer; OnState: Boolean);

{ G_IsToggled возвращает состояние управляющей клавиши Key из набора:
  tkNumLock, tkCapsLock, tkScrollLock. Если соответствующий индикатор
  включен, функция возвращает True, иначе False. }

function G_IsToggled(Key: Integer): Boolean;

{ G_ODS заносит сообщение в Event Log, вызываемый по Ctrl+Alt+V. Number -
  число, которое будет предварять данное сообщение, есть оно не равно 0.
  Если параметр Number равен нулю, а S - пустой строке, в Event Log
  помещается сообщение, содержащее псевдослучайное число от 0 до 999. }

procedure G_ODS(Number: Integer = 0; const S: AnsiString = '');

implementation

uses
  Windows, SysUtils,
  {$IFDEF DELPHIXE_UP}
    System.SysConst, System.AnsiStrings,
  {$ENDIF}
  AcedStrings, AcedBinary, AcedConsts
  ;

const
  AAA = CompilerVersion;

{$IFDEF UNICODE}
procedure ConvertError(ResString: PResStringRec); local;
begin
  raise EConvertError.CreateRes(ResString);
end;
function FormatFloat(const Format: AnsiString; Value: Extended): AnsiString;
var
  Buffer: array[0..255] of AnsiChar;
begin
  if Length(Format) > Length(Buffer) - 32 then ConvertError(@SFormatTooLong);
  SetString(Result, Buffer,
    {$IFDEF DELPHIXE_UP}System.AnsiStrings.{$ENDIF}FloatToTextFmt(Buffer, Value, fvExtended,
      PAnsiChar(Format)));
end;
{$ENDIF}

{ Функции для работы с датой и временем }

function G_FormatDate(const DateTime: TDateTime; FormatFlags: LongWord): AnsiString;
var
  Y, M, D, DayOfWeek: Word;
begin
  DecodeDateFully(DateTime, Y, M, D, DayOfWeek);
  Result := '';
  case FormatFlags and $FF of
    dfNoDate:
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := WeekDayLongName[DayOfWeek];
      end;
    dfCompact:
    begin
      if Y >= 2000 then
        Dec(Y, 2000)
      else if Y > 1900 then
        Dec(Y, 1900);
      Result := G_UIntToStrL(D, 2) + '.' + G_UIntToStrL(M, 2) + '.' + G_UIntToStrL(Y, 2);
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ',' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ',' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ',' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfLetterCompact:
    begin
      if Y >= 2000 then
        Dec(Y, 2000)
      else if Y > 1900 then
        Dec(Y, 1900);
      Result := G_UIntToStr(D) + '-' + MonthShortNameLo[M] + '-' + G_UIntToStrL(Y, 2);
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ',' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ',' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ',' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfShort:
    begin
      Result := G_UIntToStrL(D, 2) + '.' + G_UIntToStrL(M, 2) + '.' + G_UIntToStr(Y);
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfNormal:
    begin
      Result := G_UIntToStr(D) + ' ' + MonthLongNameLo[M] + ' ' + G_UIntToStr(Y) +' г.';
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfLong:
    begin
      Result := G_UIntToStr(D) + ' ' + MonthLongNameLo[M] + ' ' + G_UIntToStr(Y) +' года';
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfMonthYear:
    begin
      Result := MonthLongNameUp[M] + ' ' + G_UIntToStr(Y) +' г.';
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfDayMonth:
    begin
      Result := G_UIntToStr(D) + ' ' + MonthLongNameLo[M];
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
    dfSortable:
    begin
      Result := G_UIntToStr(Y) + '-' + G_UIntToStrL(M, 2) + '-' + G_UIntToStrL(D, 2);
      case FormatFlags and $FF00 of
        dfWeekDayCompact: Result := Result + ', ' + WeekDayShortName2[DayOfWeek];
        dfWeekDayShort:   Result := Result + ', ' + WeekDayShortName3[DayOfWeek];
        dfWeekDayFull:    Result := Result + ', ' + WeekDayLongName[DayOfWeek];
      end;
    end;
  end;
end;

function G_FormatTime(const DateTime: TDateTime; FormatFlags: LongWord): AnsiString;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(DateTime, Hour, Min, Sec, MSec);
  if FormatFlags and tfTwoDigitHour = 0 then
    Result := G_UIntToStr(Hour) + ':' + G_UIntToStrL(Min, 2)
  else
    Result := G_UIntToStrL(Hour, 2) + ':' + G_UIntToStrL(Min, 2);
  if FormatFlags and (tfFull or tfFracThreeDigits) <> 0 then
  begin
    Result := Result + ':' + G_UIntToStrL(Sec, 2);
    case FormatFlags and tfFracThreeDigits of
      tfFracOneDigit: Result := Result + '.' + G_UIntToStr(MSec div 100);
      tfFracTwoDigits: Result := Result + '.' + G_UIntToStrL(MSec div 10, 2);
      tfFracThreeDigits: Result := Result + '.' + G_UIntToStrL(MSec, 3);
    end;
  end;
end;

function G_SplitDate(const DateTime: TDateTime; out MonthYear: AnsiString): Integer;
var
  Y, M, D, DOW: Word;
begin
  DecodeDateFully(DateTime, Y, M, D, DOW);
  MonthYear := MonthLongNameLo[M] + ' ' + G_UIntToStr(Y) + ' г.';
  Result := D;
end;

{ Работа со значениями типа Double и Currency }

function G_ToDouble(const Amount: Currency): Double;
begin
  Result := Amount;
end;

function G_ThousandsToDouble(const Amount: Currency): Double;
begin
  Result := Amount;
  Result := Round(Result) * 0.001;
end;

procedure G_Inc(var V: Currency; const X: Currency);
begin
  V := V + X;
end;

procedure G_Inc(var V: Double; const X: Double);
begin
  V := V + X;
end;

procedure G_Dec(var V: Currency; const X: Currency);
begin
  V := V - X;
end;

procedure G_Dec(var V: Double; const X: Double);
begin
  V := V - X;
end;

procedure G_Mult(var V: Currency; const K: Double);
begin
  V := V * K;
end;

procedure G_Mult(var V: Double; const K: Double);
begin
  V := V * K;
end;

procedure G_Div(var V: Currency; const K: Double);
begin
  V := V / K;
end;

procedure G_Div(var V: Double; const K: Double);
begin
  V := V / K;
end;

{ Функции для расчета контрольных сумм }

function G_Adler32(P: Pointer; L: Cardinal): LongWord;
var
  S1, S2: LongWord;
  K: Integer;
begin
  S1 := 1;
  S2 := 0;
  while L > 0 do
  begin
    if L >= 5552 then
      K := 5552
    else
      K := L;
    Dec(L, K);
    while K >= 16 do
    begin
      Inc(S1, PBytes(P)^[0]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[1]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[2]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[3]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[4]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[5]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[6]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[7]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[8]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[9]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[10]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[11]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[12]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[13]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[14]);
      Inc(S2, S1);
      Inc(S1, PBytes(P)^[15]);
      Inc(S2, S1);
      Inc(LongWord(P), 16);
      Dec(K, 16);
    end;
    while K > 0 do
    begin
      Inc(S1, PByte(P)^);
      Inc(S2, S1);
      Inc(LongWord(P));
      Dec(K);
    end;
    S1 := S1 mod 65521;
    S2 := S2 mod 65521;
  end;
  Result := (S2 shl 16) or S1;
end;

const
  CRC32_Table: array[0..255] of LongWord =
    ($00000000,$77073096,$EE0E612C,$990951BA,$076DC419,$706AF48F,$E963A535,$9E6495A3,
     $0EDB8832,$79DCB8A4,$E0D5E91E,$97D2D988,$09B64C2B,$7EB17CBD,$E7B82D07,$90BF1D91,
     $1DB71064,$6AB020F2,$F3B97148,$84BE41DE,$1ADAD47D,$6DDDE4EB,$F4D4B551,$83D385C7,
     $136C9856,$646BA8C0,$FD62F97A,$8A65C9EC,$14015C4F,$63066CD9,$FA0F3D63,$8D080DF5,
     $3B6E20C8,$4C69105E,$D56041E4,$A2677172,$3C03E4D1,$4B04D447,$D20D85FD,$A50AB56B,
     $35B5A8FA,$42B2986C,$DBBBC9D6,$ACBCF940,$32D86CE3,$45DF5C75,$DCD60DCF,$ABD13D59,
     $26D930AC,$51DE003A,$C8D75180,$BFD06116,$21B4F4B5,$56B3C423,$CFBA9599,$B8BDA50F,
     $2802B89E,$5F058808,$C60CD9B2,$B10BE924,$2F6F7C87,$58684C11,$C1611DAB,$B6662D3D,
     $76DC4190,$01DB7106,$98D220BC,$EFD5102A,$71B18589,$06B6B51F,$9FBFE4A5,$E8B8D433,
     $7807C9A2,$0F00F934,$9609A88E,$E10E9818,$7F6A0DBB,$086D3D2D,$91646C97,$E6635C01,
     $6B6B51F4,$1C6C6162,$856530D8,$F262004E,$6C0695ED,$1B01A57B,$8208F4C1,$F50FC457,
     $65B0D9C6,$12B7E950,$8BBEB8EA,$FCB9887C,$62DD1DDF,$15DA2D49,$8CD37CF3,$FBD44C65,
     $4DB26158,$3AB551CE,$A3BC0074,$D4BB30E2,$4ADFA541,$3DD895D7,$A4D1C46D,$D3D6F4FB,
     $4369E96A,$346ED9FC,$AD678846,$DA60B8D0,$44042D73,$33031DE5,$AA0A4C5F,$DD0D7CC9,
     $5005713C,$270241AA,$BE0B1010,$C90C2086,$5768B525,$206F85B3,$B966D409,$CE61E49F,
     $5EDEF90E,$29D9C998,$B0D09822,$C7D7A8B4,$59B33D17,$2EB40D81,$B7BD5C3B,$C0BA6CAD,
     $EDB88320,$9ABFB3B6,$03B6E20C,$74B1D29A,$EAD54739,$9DD277AF,$04DB2615,$73DC1683,
     $E3630B12,$94643B84,$0D6D6A3E,$7A6A5AA8,$E40ECF0B,$9309FF9D,$0A00AE27,$7D079EB1,
     $F00F9344,$8708A3D2,$1E01F268,$6906C2FE,$F762575D,$806567CB,$196C3671,$6E6B06E7,
     $FED41B76,$89D32BE0,$10DA7A5A,$67DD4ACC,$F9B9DF6F,$8EBEEFF9,$17B7BE43,$60B08ED5,
     $D6D6A3E8,$A1D1937E,$38D8C2C4,$4FDFF252,$D1BB67F1,$A6BC5767,$3FB506DD,$48B2364B,
     $D80D2BDA,$AF0A1B4C,$36034AF6,$41047A60,$DF60EFC3,$A867DF55,$316E8EEF,$4669BE79,
     $CB61B38C,$BC66831A,$256FD2A0,$5268E236,$CC0C7795,$BB0B4703,$220216B9,$5505262F,
     $C5BA3BBE,$B2BD0B28,$2BB45A92,$5CB36A04,$C2D7FFA7,$B5D0CF31,$2CD99E8B,$5BDEAE1D,
     $9B64C2B0,$EC63F226,$756AA39C,$026D930A,$9C0906A9,$EB0E363F,$72076785,$05005713,
     $95BF4A82,$E2B87A14,$7BB12BAE,$0CB61B38,$92D28E9B,$E5D5BE0D,$7CDCEFB7,$0BDBDF21,
     $86D3D2D4,$F1D4E242,$68DDB3F8,$1FDA836E,$81BE16CD,$F6B9265B,$6FB077E1,$18B74777,
     $88085AE6,$FF0F6A70,$66063BCA,$11010B5C,$8F659EFF,$F862AE69,$616BFFD3,$166CCF45,
     $A00AE278,$D70DD2EE,$4E048354,$3903B3C2,$A7672661,$D06016F7,$4969474D,$3E6E77DB,
     $AED16A4A,$D9D65ADC,$40DF0B66,$37D83BF0,$A9BCAE53,$DEBB9EC5,$47B2CF7F,$30B5FFE9,
     $BDBDF21C,$CABAC28A,$53B39330,$24B4A3A6,$BAD03605,$CDD70693,$54DE5729,$23D967BF,
     $B3667A2E,$C4614AB8,$5D681B02,$2A6F2B94,$B40BBE37,$C30C8EA1,$5A05DF1B,$2D02EF8D);

function G_CRC32(P: Pointer; L: Cardinal): LongWord;
asm
        PUSH    EBX
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt:   POP     ESI
        NOT     EAX
        POP     EBX
end;

function G_NextCRC32(var CRC32: LongWord; P: Pointer; L: Cardinal): LongWord;
asm
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EBX
        PUSH    EAX
        MOV     EAX,[EAX]
        NOT     EAX
        PUSH    ESI
@@lp:   MOVZX   ESI,BYTE PTR [EDX]
        MOVZX   EBX,AL
        SHR     EAX,8
        XOR     EBX,ESI
        XOR     EAX,DWORD PTR [EBX*4+CRC32_Table]
        INC     EDX
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EDX
        NOT     EAX
        MOV     [EDX],EAX
        POP     EBX
        RET
@@qt:   MOV     EAX,[EAX]
end;

function G_CRC32_Str(const S: AnsiString): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt1
        PUSH    EBX
        MOV     EDX,[EAX-4]
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt0
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt0:  POP     ESI
        NOT     EAX
        POP     EBX
@@qt1:
end;

function G_CRC32_Str(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt1
        PUSH    EBX
        MOV     EDX,[EAX-4]
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt0
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt0:  POP     ESI
        NOT     EAX
        POP     EBX
@@qt1:
end;

function G_CRC32_Text(const S: AnsiString): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt1
        PUSH    EBX
        MOV     EDX,[EAX-4]
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt0
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        MOVZX   ESI,BYTE PTR [ESI+ToUpperChars]
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt0:  POP     ESI
        NOT     EAX
        POP     EBX
@@qt1:
end;

function G_CRC32_Text(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt1
        PUSH    EBX
        MOV     EDX,[EAX-4]
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt0
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        MOVZX   ESI,BYTE PTR [ESI+ToUpperChars]
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt0:  POP     ESI
        NOT     EAX
        POP     EBX
@@qt1:
end;

{ Функции для перекодировки строк и массива байт }

const
  ToBase64: array[0..63] of AnsiChar =
    ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R',
     'S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j',
     'k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1',
     '2','3','4','5','6','7','8','9','+','/');

procedure IntBase64Encode(P1, P2: Pointer; L: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        MOV     EDI,EDX
        SUB     ESI,3
        JS      @@nx
@@lp:   MOVZX   EAX,BYTE PTR [EBX]
        SHL     EAX,16
        MOV     AH,BYTE PTR [EBX+1]
        MOV     AL,BYTE PTR [EBX+2]
        ROL     EAX,14
        MOV     EDX,EAX
        AND     EDX,$3F
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        MOV     EDX,EAX
        AND     EDX,$3F
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        MOV     EDX,EAX
        AND     EDX,$3F
        SHR     EAX,26
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+2],CL
        ADD     EBX,3
        MOV     CL,BYTE PTR [EAX+ToBase64]
        MOV     BYTE PTR [EDI+3],CL
        ADD     EDI,4
        SUB     ESI,3
        JNS     @@lp
@@nx:   ADD     ESI,3
        JMP     DWORD PTR @@tV[ESI*4]
@@tV:   DD      @@tu0,@@tu1,@@tu2
@@tu1:  MOVZX   EAX,BYTE PTR [EBX]
        MOV     EDX,EAX
        SHR     EAX,2
        MOV     CL,BYTE PTR [EAX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        AND     EDX,3
        SHL     EDX,4
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        MOV     BYTE PTR [EDI+2],61
        MOV     BYTE PTR [EDI+3],61
@@tu0:  POP     EDI
        POP     ESI
        POP     EBX
        RET
@@tu2:  XOR     EAX,EAX
        MOV     AH,BYTE PTR [EBX]
        MOV     AL,BYTE PTR [EBX+1]
        ROL     EAX,22
        MOV     EDX,EAX
        AND     EDX,$3F
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        MOV     EDX,EAX
        AND     EDX,$3F
        SHR     EAX,26
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        MOV     CL,BYTE PTR [EAX+ToBase64]
        MOV     BYTE PTR [EDI+2],CL
        MOV     BYTE PTR [EDI+3],61
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_Base64Encode(P: Pointer; L: Integer): AnsiString;
begin
  if L <> 0 then
  begin
    SetString(Result, nil, ((L + 2) div 3) shl 2);
    IntBase64Encode(P, Pointer(Result), L);
  end else
    Result := '';
end;

function G_Base64Encode(const S: AnsiString): AnsiString;
var
  L: Integer;
begin
  L := Length(S);
  if L <> 0 then
  begin
    SetString(Result, nil, ((L + 2) div 3) shl 2);
    IntBase64Encode(Pointer(S), Pointer(Result), L);
  end else
    Result := '';
end;

const
  FromBase64: array[0..79] of Integer =
    (62,0,0,0,63,52,53,54,55,56,57,58,59,60,61,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,
     9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,26,27,28,29,
     30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51);

function IntBase64Decode(P1, P2: Pointer; L: Integer): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        MOV     EDI,EDX
        MOV     EAX,3
        MUL     ECX
        PUSH    EAX
        DEC     ESI
        JE      @@nx0
@@lp:   MOV     EDX,[EBX]
        MOVZX   EAX,DL
        SUB     EAX,43
        MOV     ECX,DWORD PTR [EAX*4+FromBase64]
        MOVZX   EAX,DH
        SHL     ECX,6
        SUB     EAX,43
        SHR     EDX,16
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        MOVZX   EAX,DL
        SUB     EAX,43
        SHL     ECX,6
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        MOVZX   EAX,DH
        SUB     EAX,43
        SHL     ECX,6
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        MOV     BYTE PTR [EDI+1],CH
        ADD     EBX,4
        MOV     BYTE PTR [EDI+2],CL
        SHR     ECX,16
        MOV     BYTE PTR [EDI],CL
        ADD     EDI,3
        DEC     ESI
        JNE     @@lp
@@nx0:  MOV     EDX,[EBX]
        MOVZX   EAX,DL
        SUB     EAX,43
        MOV     ECX,DWORD PTR [EAX*4+FromBase64]
        MOVZX   EAX,DH
        SHL     ECX,6
        SUB     EAX,43
        SHR     EDX,16
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        CMP     DH,61
        JE      @@nx1
        MOVZX   EAX,DL
        SUB     EAX,43
        SHL     ECX,6
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        MOVZX   EAX,DH
        SUB     EAX,43
        SHL     ECX,6
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        MOV     BYTE PTR [EDI+1],CH
        MOV     BYTE PTR [EDI+2],CL
        SHR     ECX,16
        MOV     BYTE PTR [EDI],CL
        POP     EAX
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@nx1:  CMP     DL,61
        JE      @@nx2
        MOVZX   EAX,DL
        SUB     EAX,43
        SHL     ECX,6
        OR      ECX,DWORD PTR [EAX*4+FromBase64]
        SHR     ECX,2
        MOV     BYTE PTR [EDI],CH
        MOV     BYTE PTR [EDI+1],CL
        POP     EAX
        DEC     EAX
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@nx2:  SHR     ECX,4
        MOV     BYTE PTR [EDI],CL
        POP     EAX
        SUB     EAX,2
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_Base64Decode(const S: AnsiString; P: Pointer): Integer;
var
  L: Integer;
begin
  L := Length(S);
  if L <> 0 then
  begin
    if L and 3 <> 0 then
      RaiseConvertError(SErrWrongBase64EncodedString);
    if P <> nil then
      Result := IntBase64Decode(Pointer(S), P, L shr 2)
    else
    begin
      Result := (L shr 2) * 3;
      if S[L] = '=' then
        if S[L - 1] = '=' then
          Dec(Result, 2)
        else
          Dec(Result);
    end;
  end else
    Result := 0;
end;

function G_Base64Decode(const S: AnsiString): AnsiString;
var
  L, N: Integer;
begin
  L := Length(S);
  if L <> 0 then
  begin
    if L and 3 <> 0 then
      RaiseConvertError(SErrWrongBase64EncodedString);
    N := (L shr 2) * 3;
    if S[L] = '=' then
      if S[L - 1] = '=' then
        Dec(N, 2)
      else
        Dec(N);
    SetString(Result, nil, N);
    IntBase64Decode(Pointer(S), Pointer(Result), L shr 2);
  end else
    Result := '';
end;

function G_StrToCodes(const S: AnsiString): AnsiString;
asm
        TEST    EAX,EAX
        JE      @@cl
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@cl
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        MOV     EAX,EDX
        SHL     ECX,1
        XOR     EDX,EDX
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EDI,[EDI]
@@lp:   MOV     AL,BYTE PTR [ESI]
        MOV     DL,AL
        SHR     AL,4
        AND     DL,$0F
        CMP     AL,$09
        JA      @@bd1
        ADD     AL,$30
        JMP     @@nx1
@@bd1:  ADD     AL,$37
@@nx1:  MOV     BYTE PTR [EDI],AL
        INC     EDI
        CMP     DL,$09
        JA      @@bd2
        ADD     DL,$30
        JMP     @@nx2
@@bd2:  ADD     DL,$37
@@nx2:  MOV     BYTE PTR [EDI],DL
        INC     ESI
        INC     EDI
        DEC     EBX
        JNE     @@lp
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@cl:   MOV     EAX,EDX
        CALL    System.@LStrClr
end;

function G_CodesToStr(const S: AnsiString): AnsiString;
const
  ErrorMessage: AnsiString = SErrCodesToStrConversionFault;
asm
        TEST    EAX,EAX
        JE      @@cl
        MOV     ECX,[EAX-4]
        SHR     ECX,1
        JC      @@err1
        JE      @@cl
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        MOV     EAX,EDX
        XOR     EDX,EDX
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EDI,[EDI]
@@lp:   MOV     AL,BYTE PTR [ESI]
        MOV     DL,BYTE PTR [ESI+1]
        SUB     AL,$30
        JB      @@err0
        SUB     DL,$30
        JB      @@err0
        CMP     AL,$09
        JBE     @@ct1
        SUB     AL,$11
        JB      @@err0
        CMP     AL,$05
        JBE     @@pt1
        SUB     AL,$20
        JB      @@err0
        CMP     AL,$05
        JA      @@err0
@@pt1:  ADD     AL,$0A
@@ct1:  SHL     AL,4
        CMP     DL,$09
        JBE     @@ct2
        SUB     DL,$11
        JB      @@err0
        CMP     DL,$05
        JBE     @@pt2
        SUB     DL,$20
        JB      @@err0
        CMP     DL,$05
        JA      @@err0
@@pt2:  ADD     DL,$0A
@@ct2:  OR      AL,DL
        MOV     BYTE PTR [EDI],AL
        ADD     ESI,2
        INC     EDI
        DEC     EBX
        JNE     @@lp
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@cl:   MOV     EAX,EDX
        CALL    System.@LStrClr
        RET
@@err0: POP     EDI
        POP     ESI
        POP     EBX
@@err1: MOV     EAX,ErrorMessage
        CALL    RaiseConvertError
end;

{ Функции для преобразования числа в строку и строки в число }

function G_IntToStr(N: Integer): AnsiString;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,EDX
        XOR     EDX,EDX
        CMP     ESI,1000
        JNL     @@x1
        CMP     ESI,$FFFFFF9C
        JNG     @@x1
        MOV     ECX,3
        JMP     @@do
@@x1:   CMP     ESI,10000000
        JNL     @@x2
        CMP     ESI,$FFF0BDC0
        JNG     @@x2
        MOV     ECX,7
        JMP     @@do
@@x2:   MOV     ECX,$0B
@@do:
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EAX,ESI
        MOV     ESI,[EDI]
        MOV     EDI,ESI
        TEST    EAX,EAX
        JE      @@eq
        JNS     @@ns
        CMP     EAX,$80000000
        JE      @@mm
        MOV     BYTE PTR [ESI],$2D
        INC     ESI
        NEG     EAX
@@ns:   MOV     ECX,$0A
@@lp1:  XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
        MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
        CMP     BYTE PTR [EDI],$2D
        JE      @@ws
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        DEC     ECX
@@ws:   INC     EDI
        JMP     @@lp2
@@qt:   POP     EDI
        POP     ESI
        RET
@@eq:   MOV     WORD PTR [ESI],$0030
        MOV     DWORD PTR [ESI-4],1
        POP     EDI
        POP     ESI
        RET
@@mm:   MOV     DWORD PTR [ESI],$3431322D
        MOV     DWORD PTR [ESI+4],$33383437
        MOV     DWORD PTR [ESI+8],$00383436
        MOV     DWORD PTR [ESI-4],11
        POP     EDI
        POP     ESI
end;

function G_UIntToStr(N: LongWord): AnsiString;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,EDX
        XOR     EDX,EDX
        CMP     ESI,1000
        JNB     @@x1
        MOV     ECX,$03
        JMP     @@do
@@x1:   CMP     ESI,10000000
        JNB     @@x2
        MOV     ECX,$07
        JMP     @@do
@@x2:   MOV     ECX,$0B
@@do:
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EAX,ESI
        MOV     ESI,[EDI]
        MOV     EDI,ESI
        TEST    EAX,EAX
        JE      @@eq
        MOV     ECX,$0A
@@lp1:  XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
        MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EDI
        POP     ESI
        RET
@@eq:   MOV     WORD PTR [ESI],$0030
        MOV     DWORD PTR [ESI-4],1
        POP     EDI
        POP     ESI
end;

function G_UIntToStrL(N: LongWord; Digits: Cardinal): AnsiString;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,ECX
        MOV     EBX,EDX
        MOV     EAX,ECX
        MOV     ECX,EDX
        XOR     EDX,EDX
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EAX,ESI
        MOV     ESI,[EDI]
        MOV     EDI,ESI
        MOV     ECX,$0A
@@lp1:  DEC     EBX
        JS      @@lp2
        XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
@@bl:   DEC     EBX
        JS      @@lp2
        MOV     BYTE PTR [ESI],$30
        INC     ESI
        JMP     @@bl
@@lp2:  DEC     ESI
        CMP     EDI,ESI
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ESI]
        MOV     BYTE PTR [ESI],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;

function G_UIntToHex(N: LongWord; Digits: Cardinal): AnsiString;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,ECX
        MOV     EBX,EDX
        MOV     EAX,ECX
        MOV     ECX,EDX
        XOR     EDX,EDX
        {$IFDEF UNICODE}
          PUSH  DefaultSystemCodePage
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        MOV     EAX,ESI
        MOV     ESI,[EDI]
        MOV     EDI,ESI
@@lp1:  DEC     EBX
        JS      @@lp2
        MOV     DL,AL
        AND     DL,$0F
        CMP     DL,$09
        JA      @@bd
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        SHR     EAX,4
        JNE     @@lp1
        JMP     @@bl
@@bd:   ADD     DL,$37
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        SHR     EAX,4
        JNE     @@lp1
@@bl:   DEC     EBX
        JS      @@lp2
        MOV     BYTE PTR [ESI],$30
        INC     ESI
        JMP     @@bl
@@lp2:  DEC     ESI
        CMP     EDI,ESI
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ESI]
        MOV     BYTE PTR [ESI],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;

function G_HexToUInt(const S: AnsiString): LongWord;
const
  ErrorMessage: AnsiString = SErrHexToIntConversionFault;
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        TEST    EAX,EAX
        JE      @@err
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@err
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   MOV     DL,BYTE PTR [EBX]
        SHL     EAX,4
        SUB     DL,$30
        JB      @@err
        CMP     DL,$09
        JBE     @@ct
        SUB     DL,$11
        JB      @@err
        CMP     DL,$05
        JBE     @@pt
        SUB     DL,$20
        JB      @@err
        CMP     DL,$05
        JA      @@err
@@pt:   ADD     DL,$0A
@@ct:   OR      AL,DL
        INC     EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
        RET
@@err:  MOV     EAX,ErrorMessage
        MOV     EDX,ESI
        POP     EBX
        POP     ESI
        CALL    RaiseConvertErrorFmt
end;

function G_AdjustSeparator(const S: AnsiString): AnsiString;
var
  I, L: Integer;
  P: PAnsiChar;
begin
  L := Length(S);
{$IFDEF UNICODE}
  if FormatSettings.DecimalSeparator = ',' then
{$ELSE}
  if DecimalSeparator = ',' then
{$ENDIF}
  begin
    I := G_CharPos('.', S);
    if I <> 0 then
    begin
      Result := '';
      SetLength(Result, L);
      P := Pointer(Result);
      G_CopyMem(Pointer(S), P, L);
      Inc(P, I - 1);
      P^ := ',';
    end else
      Result := S;
  end else
  begin
    I := G_CharPos(',', S);
    if I <> 0 then
    begin
      Result := '';
      SetLength(Result, L);
      P := Pointer(Result);
      G_CopyMem(Pointer(S), P, L);
      Inc(P, I - 1);
      P^ := '.';
    end else
      Result := S;
  end
end;

function G_Between_Integer(const S: AnsiString; LowBound, HighBound: Integer): Boolean;
var
  N: Integer;
begin
  Result := G_StrTo_Integer(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function G_Between_LongWord(const S: AnsiString; LowBound, HighBound: LongWord): Boolean;
var
  N: LongWord;
begin
  Result := G_StrTo_LongWord(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function G_Between_Int64(const S: AnsiString; LowBound, HighBound: Int64): Boolean;
var
  N: Int64;
begin
  Result := G_StrTo_Int64(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function G_Between_Extended(const S: AnsiString; LowBound, HighBound: Extended): Boolean;
var
  N: Extended;
begin
  Result := {$IFDEF DELPHIXE_UP}System.AnsiStrings.{$ENDIF}TextToFloat(PAnsiChar(S), N, fvExtended) and (N >= LowBound) and (N <= HighBound);
end;

function G_Between_Currency(const S: AnsiString; LowBound, HighBound: Currency): Boolean;
var
  N: Currency;
begin
  Result := {$IFDEF DELPHIXE_UP}System.AnsiStrings.{$ENDIF}TextToFloat(PAnsiChar(S), N, fvCurrency) and (N >= LowBound) and (N <= HighBound);
end;

function G_StrTo_Integer(const S: AnsiString; var V: Integer): Boolean;
var
  P: PAnsiChar;
  C: Integer;
  Sign: Boolean;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ = '-' then
  begin
    Sign := True;
    Inc(P);
  end else
  begin
    Sign := False;
    if P^ = '+' then
      Inc(P);
  end;
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := Byte(P^);
      if AnsiChar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < 0) or (V > $CCCCCCC) then
      begin
        Result := False;
        Exit;
      end;
      V := V * 10 + C;
      Inc(P);
    until False;
    if V < 0 then
    begin
      Result := (LongWord(V) = $80000000) and Sign and (C = 0);
      Exit;
    end;
  end else
  begin
    Inc(P);
    repeat
      C := Byte(P^);
      case AnsiChar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
      else
        Break;
      end;
      if LongWord(V) >= $10000000 then
      begin
        Result := False;
        Exit;
      end;
      V := (V shl 4) or C;
      Inc(P);
    until False;
    if Sign and (LongWord(V) = $80000000) then
    begin
      Result := False;
      Exit;
    end;
  end;
  if Sign then
    V := -V;
  Result := C = 0;
end;

function G_StrTo_LongWord(const S: AnsiString; var V: LongWord): Boolean;
var
  P: PAnsiChar;
  C: LongWord;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := Byte(P^);
      if AnsiChar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < $19999999) or ((V = $19999999) and (C < 6)) then
        V := V * 10 + C
      else
      begin
        Result := False;
        Exit;
      end;
      Inc(P);
    until False;
  end else
  begin
    Inc(P);
    repeat
      C := Byte(P^);
      case AnsiChar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
      else
        Break;
      end;
      if LongWord(V) >= $10000000 then
      begin
        Result := False;
        Exit;
      end;
      V := (V shl 4) or C;
      Inc(P);
    until False;
  end;
  Result := C = 0;
end;

function G_StrTo_Int64(const S: AnsiString; var V: Int64): Boolean;
type
  PArr64 = ^TArr64;
  TArr64 = array[0..7] of Byte;
var
  P: PAnsiChar;
  C: LongWord;
  Sign: Boolean;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ = '-' then
  begin
    Sign := True;
    Inc(P);
  end else
  begin
    Sign := False;
    if P^ = '+' then
      Inc(P);
  end;
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := Byte(P^);
      if AnsiChar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < 0) or (V > $CCCCCCCCCCCCCCC) then
      begin
        Result := False;
        Exit;
      end;
      V := V * 10 + C;
      Inc(P);
    until False;
    if V < 0 then
    begin
      Result := (V = $8000000000000000) and Sign and (C = 0);
      Exit;
    end;
  end else
  begin
    Inc(P);
    repeat
      C := Byte(P^);
      case AnsiChar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
      else
        Break;
      end;
      if PArr64(@V)^[7] >= $10 then
      begin
        Result := False;
        Exit;
      end;
      V := V shl 4;
      PLongWord(@V)^ := PLongWord(@V)^ or C;
      Inc(P);
    until False;
    if Sign and (V = $8000000000000000) then
    begin
      Result := False;
      Exit;
    end;
  end;
  if Sign then
    V := -V;
  Result := C = 0;
end;

function G_StrTo_Extended(const S: AnsiString; var V: Extended): Boolean;
begin
  Result := {$IFDEF DELPHIXE_UP}System.AnsiStrings.{$ENDIF}TextToFloat(PAnsiChar(S), V, fvExtended);
end;

function G_StrTo_Currency(const S: AnsiString; var V: Currency): Boolean;
begin
  Result := {$IFDEF DELPHIXE_UP}System.AnsiStrings.{$ENDIF}TextToFloat(PAnsiChar(S), V, fvCurrency);
end;

function G_ModDiv10(var V: LongWord): Integer;
const
  Base10: Integer = 10;
asm
        MOV     ECX,EAX
        MOV     EAX,[EAX]
        XOR     EDX,EDX
        DIV     Base10
        MOV     [ECX],EAX
        MOV     EAX,EDX
end;

function G_NumToStr(N: Int64; var S: AnsiString; FormatFlags: LongWord): Integer;
const
  M_Ed: array [1..9] of AnsiString =
    ('один ','два ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ');
  W_Ed: array [1..9] of AnsiString =
    ('одна ','две ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ');
  G_Ed: array [1..9] of AnsiString =
    ('одно ','два ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ');
  E_Ds: array [0..9] of AnsiString =
    ('десять ','одиннадцать ','двенадцать ','тринадцать ','четырнадцать ',
     'пятнадцать ','шестнадцать ','семнадцать ','восемнадцать ','девятнадцать ');
  D_Ds: array [2..9] of AnsiString =
    ('двадцать ','тридцать ','сорок ','пятьдесят ','шестьдесят ','семьдесят ',
     'восемьдесят ','девяносто ');
  U_Hd: array [1..9] of AnsiString =
    ('сто ','двести ','триста ','четыреста ','пятьсот ','шестьсот ','семьсот ',
     'восемьсот ','девятьсот ');
  M_Tr: array[1..6,0..3] of AnsiString =
    (('тыс. ','тысяча ','тысячи ','тысяч '),
     ('млн. ','миллион ','миллиона ','миллионов '),
     ('млрд. ','миллиард ','миллиарда ','миллиардов '),
     ('трлн. ','триллион ','триллиона ','триллионов '),
     ('квадр. ','квадриллион ','квадриллиона ','квадриллионов '),
     ('квинт. ','квинтиллион ','квинтиллиона ','квинтиллионов '));
var
  V1: Int64;
  VArr: array[0..6] of Integer;
  I, E, D, H, Count: Integer;
  SB: TAnsiStringBuilder;
begin
  Result := 3;
  if N = 0 then
  begin
    S := 'ноль ';
    Exit;
  end;
  if N > 0 then
    SB := TAnsiStringBuilder.Create(120)
  else if N <> $8000000000000000 then
  begin
    N := -N;
    SB := TAnsiStringBuilder.Create('минус ');
  end else
  begin                                 { -9.223.372.036.854.775.808 }
    if FormatFlags and nfShort = 0 then
      S := 'минус девять квинтиллионов двести двадцать три квадриллиона'+
        ' триста семьдесят два триллиона тридцать шесть миллиардов'+
        ' восемьсот пятьдесят четыре миллиона семьсот семьдесят пять'+
        ' тысяч восемьсот восемь '
    else
      S := 'минус девять квинт. двести двадцать три квадр. триста'+
        ' семьдесят два трлн. тридцать шесть млрд. восемьсот пятьдесят'+
        ' четыре млн. семьсот семьдесят пять тыс. восемьсот восемь ';
    Exit;
  end;
  Count := 0;
  repeat
    V1 := N div 1000;
    VArr[Count] := N - (V1 * 1000);
    N := V1;
    Inc(Count);
  until V1 = 0;
  for I := Count - 1 downto 0 do
  begin
    H := VArr[I];
    Result := 3;
    if H <> 0 then
    begin
      E := G_ModDiv10(LongWord(H));
      D := G_ModDiv10(LongWord(H));
      if D <> 1 then
      begin
        if E = 1 then
          Result := 1
        else if (E >= 2) and (E <= 4) then
          Result := 2;
        if (H <> 0) and (D <> 0) then
          SB.Append(U_Hd[H]).Append(D_Ds[D])
        else if H <> 0 then
          SB.Append(U_Hd[H])
        else if D <> 0 then
          SB.Append(D_Ds[D]);
        if E <> 0 then
          if I = 0 then
            case FormatFlags and 3 of
              0: SB.Append(M_Ed[E]);
              1: SB.Append(W_Ed[E]);
              2: SB.Append(G_Ed[E]);
            else
              SB.Append('#### ');
            end
          else if I = 1 then
            SB.Append(W_Ed[E])
          else
            SB.Append(M_Ed[E]);
      end else
        if H = 0 then
          SB.Append(E_Ds[E])
        else
          SB.Append(U_Hd[H]).Append(E_Ds[E]);
      if I <> 0 then
      begin
        if FormatFlags and nfShort = 0 then
          SB.Append(M_Tr[I, Result])
        else
          SB.Append(M_Tr[I, 0]);
      end;
    end;
  end;
  S := SB.ToString;
  SB.Free;
end;

function G_NumToRub(V: Currency; RubFormat, CopFormat: LongWord): AnsiString;
var
  V1: Int64;
  S1, S2, S3, S4: AnsiString;
  Cp, I: Integer;
  Negative: Boolean;
begin
  if V >= 0 then
    Negative := False
  else
  begin
    Negative := True;
    V := -V;
  end;
  if RubFormat <> ruNone then
  begin
    if CopFormat <> ruNone then
    begin
      V1 := Trunc(V);
      Cp := Round(Frac(V) * 100);
      if V1 <> 0 then
      begin
        if RubFormat and 1 = 0 then
        begin
          if RubFormat and 2 <> 0 then
            case G_NumToStr(V1, S1, nfMale or (RubFormat and 4)) of
              1: S2 := 'рубль ';
              2: S2 := 'рубля ';
              3: S2 := 'рублей ';
            end
          else
          begin
            S1 := G_IntToStr(V1);
            I := V1 mod 100;
            if (I < 10) or (I > 20) then
              case I mod 10 of
                1: S2 := ' рубль ';
                2,3,4: S2 := ' рубля ';
              else
                S2 := ' рублей ';
              end
            else
              S2 := ' рублей ';
          end;
        end
        else if RubFormat and 2 <> 0 then
        begin
          G_NumToStr(V1, S1, nfMale or (RubFormat and 4));
          S2 := 'руб. ';
        end else
        begin
          S1 := G_IntToStr(V1);
          S2 := ' руб. ';
        end;
      end else
      begin
        S1 := '';
        S2 := '';
      end;
      if CopFormat and 1 = 0 then
      begin
        if CopFormat and 2 <> 0 then
          case G_NumToStr(Cp, S3, nfFemale) of
            1: S4 := 'копейка';
            2: S4 := 'копейки';
            3: S4 := 'копеек';
          end
        else
        begin
          S3 := G_UIntToStrL(Cp, 2);
          I := Cp mod 100;
          if (I < 10) or (I > 20) then
            case I mod 10 of
              1: S4 := ' копейка';
              2,3,4: S4 := ' копейки';
            else
              S4 := ' копеек';
            end
          else
            S4 := ' копеек';
        end;
      end
      else if CopFormat and 2 <> 0 then
      begin
        G_NumToStr(Cp, S3, nfFemale);
        S4 := 'коп.';
      end else
      begin
        S3 := G_UIntToStrL(Cp, 2);
        S4 := ' коп.';
      end;
      if not Negative then
      begin
        Result := S1 + S2 + S3 + S4;
        Result[1] := ToUpperChars[Byte(Result[1])];
      end
      else
      begin
        Result := '(' + S1 + S2 + S3 + S4 + ')';
        Result[2] := ToUpperChars[Byte(Result[2])];
      end;
    end else
    begin
      V1 := Round(V);
      if V1 <> 0 then
      begin
        if RubFormat and 1 = 0 then
        begin
          if RubFormat and 2 <> 0 then
            case G_NumToStr(V1, S1, nfMale or (RubFormat and 4)) of
              1: S2 := 'рубль';
              2: S2 := 'рубля';
              3: S2 := 'рублей';
            end
          else
          begin
            S1 := G_IntToStr(V1);
            I := V1 mod 100;
            if (I < 10) or (I > 20) then
              case I mod 10 of
                1: S2 := ' рубль';
                2,3,4: S2 := ' рубля';
              else
                S2 := ' рублей';
              end
            else
              S2 := ' рублей';
          end;
        end
        else if RubFormat and 2 <> 0 then
        begin
          G_NumToStr(V1, S1, nfMale or (RubFormat and 4));
          S2 := 'руб.';
        end else
        begin
          S1 := G_IntToStr(V1);
          S2 := ' руб.';
        end;
        S1[1] := ToUpperChars[Byte(S1[1])];
        if not Negative then
          Result := S1 + S2
        else
          Result := '(' + S1 + S2 + ')';
      end else
        Result := '';
    end;
  end
  else if CopFormat <> ruNone then
  begin
    V1 := Round(V * 100);
    if CopFormat and 1 = 0 then
    begin
      if CopFormat and 2 <> 0 then
        case G_NumToStr(V1, S1, nfFemale or (CopFormat and 4)) of
          1: S2 := 'копейка';
          2: S2 := 'копейки';
          3: S2 := 'копеек';
        end
      else
      begin
        S1 := G_IntToStr(V1);
        I := V1 mod 100;
        if (I < 10) or (I > 20) then
          case I mod 10 of
            1: S2 := ' копейка';
            2,3,4: S2 := ' копейки';
          else
            S2 := ' копеек';
          end
        else
          S2 := ' копеек';
      end;
    end
    else if CopFormat and 2 <> 0 then
    begin
      G_NumToStr(V1, S1, nfFemale or (CopFormat and 4));
      S2 := 'коп.';
    end else
    begin
      S1 := G_IntToStr(V1);
      S2 := ' коп.';
    end;
    S1[1] := ToUpperChars[Byte(S1[1])];
    if not Negative then
      Result := S1 + S2
    else
      Result := '(' + S1 + S2 + ')';
  end
  else if not Negative then
    Result := FormatFloat('0.00', V)
  else
    Result := '(' + FormatFloat('0.00', V) + ')';
end;

{ Работа со счетчиками и таймерами. }

function G_TickCountSince(Tick: LongWord): LongWord;
var
  C: LongWord;
begin
  C := GetTickCount;
  if Tick <= C then
    Result := C - Tick
  else
    Result := ($FFFFFFFF - Tick) + C + 1;
end;

var
  PerformanceFrequency: Double;
  PC_Exists: Boolean;

procedure SetupPerformanceFrequency;
var
  F: Int64;
begin
  if QueryPerformanceFrequency(F) then
  begin
    PerformanceFrequency := F / 1000;
    PC_Exists := True;
  end else
    PC_Exists := False;
end;

function G_QueryPC: Int64;
begin
  if not PC_Exists then
    RaiseError(SErrNoHighResolutionPC);
  QueryPerformanceCounter(Result);
end;

function G_GetTimeInterval(PC_Delta: Int64): LongWord;
begin
  if not PC_Exists then
    RaiseError(SErrNoHighResolutionPC);
  Result := Round(PC_Delta / PerformanceFrequency);
end;

function G_GetPC_Delta(TimeInterval: LongWord): Int64;
begin
  if not PC_Exists then
    RaiseError(SErrNoHighResolutionPC);
  Result := Round(TimeInterval * PerformanceFrequency)
end;

function G_RDTSC: Int64;
asm
        RDTSC
end;

{ Прочие функции }

function G_SwitchToApplication(const MainFormClassName: AnsiString): Boolean;
var
  Handle: HWND;
begin
  Result := False;
  Handle := FindWindowA(PAnsiChar(MainFormClassName), nil);
  if Handle <> 0 then
  begin
    Handle := SendMessageA(Handle, WM_USER_SWITCH_TO, 0, 0);
    if Handle <> 0 then
    begin
      SetForegroundWindow(Handle);
      Result := True;
    end;
  end;
end;

procedure G_SelectMenu(ItemNumbers: array of Integer);
var
  I, N, Depth: Integer;
  ScanCode, DownCode: Byte;
begin
  Depth := High(ItemNumbers);
  if Depth < 0 then
    Exit;
  ScanCode := Lo(MapVirtualKey(VK_MENU, 0));
  keybd_event(VK_MENU, ScanCode, 0, 0);
  keybd_event(VK_MENU, ScanCode, KEYEVENTF_KEYUP, 0);
  N := ItemNumbers[0];
  if N > 1 then
  begin
    ScanCode := Lo(MapVirtualKey(VK_RIGHT, 0));
    for I := N downto 2 do
    begin
      keybd_event(VK_RIGHT, ScanCode, KEYEVENTF_EXTENDEDKEY, 0);
      keybd_event(VK_RIGHT, ScanCode, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
    end;
  end;
  if Depth > 0 then
  begin
    ScanCode := Lo(MapVirtualKey(VK_RETURN, 0));
    DownCode := Lo(MapVirtualKey(VK_DOWN, 0));
    N := 1;
    repeat
      keybd_event(VK_RETURN, ScanCode, 0, 0);
      keybd_event(VK_RETURN, ScanCode, KEYEVENTF_KEYUP, 0);
      for I := ItemNumbers[N] downto 2 do
      begin
        keybd_event(VK_DOWN, DownCode, KEYEVENTF_EXTENDEDKEY, 0);
        keybd_event(VK_DOWN, DownCode, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
      end;
      Dec(Depth);
      Inc(N);
    until Depth = 0;
  end;
end;

procedure G_ToggleKey(Key: Integer; OnState: Boolean);
var
  ScanCode: Byte;
begin
  if (GetKeyState(Key) and 1 <> 0) xor OnState then
  begin
    ScanCode := Byte(MapVirtualKey(Key, 0));
    keybd_event(Key, ScanCode, 0, 0);
    keybd_event(Key, ScanCode, KEYEVENTF_KEYUP, 0);
  end;
end;

function G_IsToggled(Key: Integer): Boolean;
begin
  Result := (GetKeyState(Key) and 1) <> 0;
end;

procedure G_ODS(Number: Integer; const S: AnsiString);
begin
  if Length(S) > 0 then
  begin
    if Number <> 0 then
      OutputDebugStringA(PAnsiChar('<' + G_IntToStr(Number) + '> ' + S))
    else
      OutputDebugStringA(PAnsiChar(S));
  end else
  begin
    if Number <> 0 then
      OutputDebugStringA(PAnsiChar('<' + G_IntToStr(Number) + '>'))
    else
      OutputDebugStringA(PAnsiChar('<' + G_UIntToStrL(LongWord(Random(1000)), 3) + '>'));
  end;
end;

initialization
  SetupPerformanceFrequency;

end.

