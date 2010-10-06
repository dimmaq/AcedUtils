
/////////////////////////////////////////////////////////
//                                                     //
//   AcedBinary 1.16                                   //
//                                                     //
//   Функции для работы с блоками памяти, массивами    //
//   одинарных и двойных слов, множествами в виде      //
//   таких массивов, битами в составе двойного слова   //
//   и битовыми строками.                              //
//                                                     //
//   mailto: acedutils@yandex.ru                       //
//                                                     //
/////////////////////////////////////////////////////////

unit AcedBinary;

{$B-,H+,R-,Q-,T-,X+}

interface

{ Разные функции }

{ G_Swap32 обменивает значения двух переменных любого 4-байтного типа.
  Например, это могут быть переменные следующих типов: AnsiString, Pointer,
  PAnsiChar, Integer, LongWord, Single. }

procedure G_Swap32(var A, B);

{ G_Swap16 обменивает значения переменных 2-байтного типа: Word, SmallInt,
  WideChar. }

procedure G_Swap16(var A, B);

{ G_Swap8 обменивает значения переменных размером 1 байт, типа Byte, Boolean,
  ShortInt, AnsiChar. }

procedure G_Swap8(var A, B);

{ G_BSwap изменяет порядок следования байт в двойном слове L (первый байт
  становится последним, второй - третьим, и наоборот). }

function G_BSwap(L: LongWord): LongWord;

{ G_Log2 возвращает число, равное логарифму числа L по основанию 2.
  Другими словами, функция возвращает индекс самого старшего ненулевого
  бита в числе L. Если L равно 0, функция возвращает 0. }

function G_Log2(L: LongWord): LongWord;

{ G_CeilPowerOfTwo возвращает число, равное 2 в степени N, большее или
  равное L (N - целое число). Если L равно 0, функция возвращает 1. Если
  L больше $80000000, функция возвращает 0. }

function G_CeilPowerOfTwo(L: LongWord): LongWord;

{ G_FloorPowerOfTwo возвращает число, равное 2 в степени N, меньшее или
  равное L (N - целое число). Если L равно 0, функция возвращает 0. }

function G_FloorPowerOfTwo(L: LongWord): LongWord;

{ G_IncPowerOfTwo возвращает число, равное 2 в степени N, большее L (N -
  целое число). Если L равно 0, функция возвращает 1. Если L больше или
  равно $80000000, функция возвращает 0. }

function G_IncPowerOfTwo(L: LongWord): LongWord;

{ G_DecPowerOfTwo возвращает число, равное 2 в степени N, меньшее L
  (N - целое число). Если L равно 0 или 1, функция возвращает 0. }

function G_DecPowerOfTwo(L: LongWord): LongWord;

{ G_Gcd вычисляет наибольший общий делитель (greatest common divisor)
  чисел U и V. }

function G_Gcd(U, V: LongWord): LongWord;

{ G_Lcm вычисляет наименьшее общее кратное (least common multiple)
  чисел U и V. }

function G_Lcm(U, V: LongWord): LongWord;


{ Функции для работы с блоками памяти }

{ G_ZeroMem обнуляет область памяти, адресуемую параметром P. Размер
  области памяти в байтах задается параметром L. }

procedure G_ZeroMem(P: Pointer; L: Cardinal);

{ G_FillMem заполняет L байт, адресуемых параметром P, значением B. }

procedure G_FillMem(B: Byte; P: Pointer; L: Cardinal);

{ G_CopyMem копирует L байт из области памяти, указываемой параметром
  Source, в область памяти, указываемую параметром Dest. Области памяти
  не должны перекрываться. }

procedure G_CopyMem(Source, Dest: Pointer; L: Cardinal);

{ G_MoveMem копирует L байт из Source в Dest. Эта процедура должна
  использоваться вместо G_CopyMem в случае, если блоки памяти, адресуемые
  параметрами Source и Dest, могут перекрываться. }

procedure G_MoveMem(Source, Dest: Pointer; L: Cardinal);

{ G_SameMem выполняет побайтное сравнение блоков памяти, адресуемых P1 и P2.
  Размер блоков памяти (в байтах) задается параметром L. Функция возвращает
  True, если содержимое блоков памяти полностью идентично. }

function G_SameMem(P1, P2: Pointer; L: Cardinal): Boolean;

{ G_XorMemSum возвращает число, являющееся результатом объединения каждых
  четырех байт области памяти, указываемой параметром P, длиной L байт в
  одно двойное слово с помощью операции xor ("исключающее или"). }

function G_XorMemSum(P: Pointer; L: Cardinal): LongWord;

{ G_AllocMem распределяет блок памяти размером L байт вызовом GetMem(),
  а затем обнуляет его вызовом G_ZeroMem(). Функция возвращает указатель
  на выделенный блок памяти. }

function G_AllocMem(L: Cardinal): Pointer;


{ Функции для работы с массивами двойных слов }

{ G_GenerateLongs заполняет массив элементов типа Integer или LongWord,
  указываемый параметром P, последовательностью целых чисел:
  (Seed, Seed + 1, Seed + 2, Seed + 3, ...), либо последовательностью:
  (Seed, Seed + Delta, Seed + (Delta * 2), Seed + (Delta * 3), ...)
  Количество элементов в массиве передается параметром Count. }

procedure G_GenerateLongs(P: Pointer; Count: Cardinal; Seed: Integer = 1); overload;
procedure G_GenerateLongs(P: Pointer; Count: Cardinal; Seed, Delta: Integer); overload;

{ G_FillLongs заполняет массив элементов типа LongWord (или любого другого
  4-байтного типа), указываемый параметром P, значением L. Количество
  элементов в массиве передается параметром Count. }

procedure G_FillLongs(L: LongWord; P: Pointer; Count: Cardinal);

{ G_CopyLongs копирует Count элементов массива типа LongWord (или другого
  4-байтного типа, например, Integer или Pointer) из области памяти,
  указываемой параметром Source, в область памяти, указываемую параметром
  Dest. Области памяти не должны перекрываться. }

procedure G_CopyLongs(Source, Dest: Pointer; Count: Cardinal);

{ G_MoveLongs копирует Count элементов массива типа LongWord (или другого
  4-байтного типа) из области памяти, указываемой параметром Source, в
  область памяти, указываемую параметром Dest. Эта процедура должна
  применяться в случае, если области памяти могут перекрываться. }

procedure G_MoveLongs(Source, Dest: Pointer; Count: Cardinal);

{ G_ReverseLongs переворачивает массив элементов 4-байтного типа так, что
  первый элемент становится последним, второй - предпоследним и т.д. P - адрес
  массива, Count - количество 4-байтных элементов в массиве. }

procedure G_ReverseLongs(P: Pointer; Count: Cardinal);

{ G_SameLongs выполняет побайтное сравнение массивов 4-байтных элементов
  (например, типа Integer), адресуемых P1 и P2. Количество элементов в каждом
  из массивов задается параметром Count. Функция возвращает True, если все
  соответствующие элементы обоих массивов равны, в противном случае возвращает
  False. }

function G_SameLongs(P1, P2: Pointer; Count: Cardinal): Boolean;

{ G_SwapLongs обменивает содержимое массивов 4-байтных элементов, адресуемых
  P1 и P2, длиной Count двойных слов. Перед использованием этой процедуры
  рассмотрите возможность обмена значений самих указателей. }

procedure G_SwapLongs(P1, P2: Pointer; Count: Cardinal);

{ G_NotLongs инвертирует каждый бит массива, адресуемого параметром P,
  длиной Count двойных слов. }

procedure G_NotLongs(P: Pointer; Count: Cardinal);

{ G_AndLongs выполняет логическое умножение каждого соответствующего бита
  массивов, адресуемых параметрами Dest и Source, и записывает результат
  в массив Dest ( Dest <- Dest AND Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure G_AndLongs(Dest, Source: Pointer; Count: Cardinal);

{ G_OrLongs Выполняет логическое сложение каждого соответствующего бита
  массивов, адресуемых параметрами Dest и Source, и записывает результат
  в массив Dest ( Dest <- Dest OR Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure G_OrLongs(Dest, Source: Pointer; Count: Cardinal);

{ G_XorLongs выполняет операцию "исключающее или" между соответствующими
  битами массивов, адресуемых параметрами Dest и Source, и записывает результат
  в массив Dest ( Dest <- Dest XOR Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure G_XorLongs(Dest, Source: Pointer; Count: Cardinal);

{ G_AndNotLongs выполняет логическое умножение каждого бита массива,
  адресуемого параметром Dest на соответствующий инвертированный бит массива,
  адресуемого Source, и записывает результат в массив Dest
  ( Dest <- Dest AND NOT Source ). В Count передается число двойных слов
  в каждом из массивов. В результате выполнения этой операции в массиве
  Dest обнуляются все биты, для которых соответствующие биты в массиве Source
  установлены в единицу. }

procedure G_AndNotLongs(Dest, Source: Pointer; Count: Cardinal);


{ Функции для работы с массивами значений типа Byte и Word }

{ G_FillWords заполняет массив элементов типа Word (или любого другого
  2-байтного типа), указываемый параметром P, значением W. Количество
  элементов в массиве передается параметром Count. }

procedure G_FillWords(W: Word; P: Pointer; Count: Cardinal);

{ G_CopyWords и G_MoveWords копируют Count 2-х байтных элементов из области
  памяти, указываемой параметром Source, в область памяти, указываемую
  параметром Dest. Области памяти могут перекрываться. G_CopyWords выполняет
  копирование всегда от младших байт к старшим, а G_MoveWords начинает
  копирование со старших байт, если адрес в параметре Source меньше, чем
  в параметре Dest. }

procedure G_CopyWords(Source, Dest: Pointer; Count: Cardinal);
procedure G_MoveWords(Source, Dest: Pointer; Count: Cardinal);

{ G_ReverseWords переворачивает массив элементов 2-байтного типа так, что
  первый элемент становится последним, второй - предпоследним и т.д. P -
  адрес массива, Count - количество 2-байтных элементов в массиве. }

procedure G_ReverseWords(P: Pointer; Count: Cardinal);

{ G_CopyBytes и G_MoveBytes копируют L байт из области памяти, указываемой
  параметром Source в область памяти, указываемую параметром Dest. Эти
  процедуры необходимо использовать вместо G_CopyMem и G_MoveMem, если
  области памяти перекрываются и смещение одной области относительно другой
  меньше 4 байт. G_CopyBytes выполняет копирование всегда от младших байт
  к старшим, а G_MoveBytes начинает копирование со старших байт, если адрес
  в параметре Source меньше, чем в параметре Dest. }

procedure G_CopyBytes(Source, Dest: Pointer; L: Cardinal);
procedure G_MoveBytes(Source, Dest: Pointer; L: Cardinal);

{ G_ReverseBytes переворачивает байтовый массив так, что первый байт
  становится последним, второй - предпоследним и т.д. P - адрес массива,
  L - размер массива в байтах. }

procedure G_ReverseBytes(P: Pointer; L: Cardinal);


{ Поиск, замена, подсчет, удаление значений в массиве одинарных и двойных слов }

{ Следующие функции G_Scan_... находят число, переданное первым параметром,
  в массиве 4-байтных значений, адрес которого передан параметром ArrPtr.
  Параметр Count задает количество элементов в массиве. Поиск выполняется
  с начала массива. Индекс первого найденного элемента массива возвращается
  как результат функции (элементы нумеруются с нуля). Если число не найдено
  в массиве, функция возвращает -1. }

function G_Scan_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Scan_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Scan_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_Scan_Word находит число, переданное параметром N, в массиве чисел типа
  Word, адрес которого передан параметром ArrPtr. Параметр Count задает
  количество элементов в массиве. Поиск выполняется с начала массива. Индекс
  первого найденного элемента массива возвращается как результат функции
  (элементы нумеруются с нуля). Если число N не найдено в массиве, функция
  возвращает -1. }

function G_Scan_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Следующие функции G_ScanBackward_... находят число, переданное первым
  параметром, в массиве 4-байтных значений по адресу ArrPtr. Count - количество
  элементов в массиве. Поиск выполняется с конца массива. Индекс последнего
  элемента с искомым значением возвращается как результат функции (элементы
  нумеруются с нуля). Если число не найдено в массиве, функция возвращает -1. }

function G_ScanBackward_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_ScanBackward_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_ScanBackward_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_ScanBackward_Word находит число, переданное параметром N, в массиве чисел
  типа Word по адресу ArrPtr. Count - количество элементов в массиве. Поиск
  выполняется с конца массива. Индекс последнего элемента с искомым значением
  возвращается как результат функции (элементы нумеруются с нуля). Если число
  N не найдено в массиве, функция возвращает -1. }

function G_ScanBackward_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Следующие функции G_ScanOther_... находят число, отличное от значения,
  переданного первым параметром, в массиве 4-байтных значений, адрес которого
  передан параметром ArrPtr. Параметр Count задает количество элементов
  в массиве. Поиск выполняется с начала массива. Индекс первого элемента
  массива, содержащего иное значение, возвращается как результат функции
  (элементы нумеруются с нуля). Если в массиве нет других значений, кроме
  указанного, функция возвращает -1. }

function G_ScanOther_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_ScanOther_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_ScanOther_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_ScanOther_Word находит число, отличное от значения, переданного параметром
  N, в массиве чисел типа Word, адрес которого передан параметром ArrPtr.
  Параметр Count задает количество элементов в массиве. Поиск выполняется
  с начала массива. Индекс первого элемента массива, содержащего иное значение,
  возвращается как результат функции (элементы нумеруются с нуля). Если
  в массиве нет других значений, кроме N, функция возвращает -1. }

function G_ScanOther_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Следующие функции G_Replace_... заменяют все вхождения числа, переданного
  первым параметром, в массиве 4-байтных значений другим числом, которое
  передано вторым параметром. ArrPtr - адрес массива. Параметр Count задает
  количество элементов в массиве. Число, равное количеству произведенных
  замен, возвращается как результат функции. }

function G_Replace_Integer(OldN, NewN: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Replace_LongWord(OldL, NewL: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Replace_Pointer(OldP, NewP: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_Replace_Word заменяет все вхождения числа OldN в массив чисел типа
  Word, адрес которого передан параметром ArrPtr, числом NewN. Параметр
  Count задает количество элементов в массиве. Число, равное количеству
  произведенных замен, возвращается как результат функции. }

function G_Replace_Word(OldN, NewN: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Следующие функции G_CountOf_... возвращают количество вхождений числа,
  переданного первым параметром, в массив 4-байтных значений, адресуемый
  параметром ArrPtr. Параметр Count задает количество элементов в массиве. }

function G_CountOf_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_CountOf_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_CountOf_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_CountOf_Word возвращают количество вхождений числа N в массив чисел типа
  Word, адрес которого передан параметром ArrPtr. Параметр Count задает
  количество элементов в массиве. }

function G_CountOf_Word(N: Word; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_CountOfUnique_LongWord возвращает число уникальных элементов в массиве
  4-байтных значений, адресуемом параметром ArrPtr. Несколько равных смежных
  элементов считаются за один. Count - общее число элементов в массиве. }

function G_CountOfUnique_LongWord(ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_CountOfUnique_Word возвращает число уникальных элементов в массиве
  2-байтных значений, адресуемом параметром ArrPtr. Несколько равных смежных
  элементов считаются за один. Count - общее число элементов в массиве. }

function G_CountOfUnique_Word(ArrPtr: Pointer; Count: Cardinal): Integer;

{ Следующие функции G_Remove_... удаляют из массива 4-байтных значений,
  адресуемого параметром ArrPtr, все элементы, равные значению первого
  параметра. Count - исходное число элементов в массиве. Функции
  возвращают число элементов, оставшихся в массиве после удаления
  искомого значения. }

function G_Remove_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Remove_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_Remove_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_Remove_Word удаляет из массива чисел типа Word, адресуемого параметром
  ArrPtr, все элементы, равные N. Count - исходное число элементов в массиве.
  Функция возвращает число элементов, оставшихся в массиве после удаления
  искомого значения N. }

function G_Remove_Word(N: Word; ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_Unique_LongWord удаляет все повторяющиеся смежные элементы из массива
  4-байтных значений, адресуемого параметром ArrPtr. Count - исходное число
  элементов в массиве. Функция возвращает число элементов, оставшихся
  в массиве после удаления смежных дубликатов. }

function G_Unique_LongWord(ArrPtr: Pointer; Count: Cardinal): Integer;

{ G_Unique_Word удаляет все повторяющиеся смежные элементы из массива 2-байтных
  значений, адресуемого параметром ArrPtr. Count - исходное число элементов
  в массиве. Функция возвращает число элементов, оставшихся в массиве после
  удаления смежных дубликатов. }

function G_Unique_Word(ArrPtr: Pointer; Count: Cardinal): Integer;


{ Работа с отсортированными массивами одинарных и двойных слов }

{ Функции G_Sort_... сортируют массив 4-байтных или 2-байтных элементов
  соответствующего типа в порядке возрастания (используется алгоритм быстрой
  сортировки). ArrPtr - адрес массива, Count - число элементов в массиве.
  Значение адреса массива ArrPtr должно быть кратным размеру элемента массива.
  Для сортировки по убыванию отсортируйте массив с помощью одной из этих
  функций, а затем вызовите функцию G_ReverseLongs или G_ReverseWords. }

procedure G_Sort_Integer(ArrPtr: Pointer; Count: Cardinal);
procedure G_Sort_LongWord(ArrPtr: Pointer; Count: Cardinal);
procedure G_Sort_Word(ArrPtr: Pointer; Count: Cardinal);

{ Функции G_BinarySearch_... выполняют бинарный поиск в массиве 4-байтных или
  2-байтных элементов значения соответствующего типа. Массив предварительно
  должен быть отсортирован по возрастанию. Функция возвращает индекс, начиная
  с нуля, найденного значения N в массиве, адрес которого передается ArrPtr,
  состоящем из Count элементов. Если значение N в массиве не найдено, функция
  возвращает -1. Если массив содержит повторяющиеся элементы, то найденный
  элемент необязательно будет первым среди имеющих такое значение. }

function G_BinarySearch_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_BinarySearch_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_BinarySearch_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Функции G_SearchFirstGE_... выполняют бинарный поиск в массиве 4-байтных или
  2-байтных элементов значения соответствующего типа, большего или равного N.
  Массив предварительно должен быть отсортирован по возрастанию. Функция
  возвращает индекс, начиная с нуля, первого элемента, значение которого больше
  или равно N, в массиве, адрес которого передан параметром ArrPtr, состоящем
  из Count элементов. Если значение, большее или равное N, в массиве не найдено,
  функция возвращает Count. }

function G_SearchFirstGE_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_SearchFirstGE_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
function G_SearchFirstGE_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;

{ Функции G_SetContainedIn_... возвращают True, если все элементы первого
  из двух массивов 4-байтных или 2-байтных элементов присутствуют во втором
  массиве. Если в первом массиве есть какие-либо элементы, отсутствующие
  во втором массиве, функции возвращают False. P1 - адрес первого массива,
  Count1 - число элементов в первом массиве, P2 - адрес второго массива,
  Count2 - число элементов во втором массиве. Массивы P1 и P2 должны быть
  отсортированы по возрастанию. }

function G_SetContainedIn_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
function G_SetContainedIn_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
function G_SetContainedIn_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;

{ Функции G_SetIntersectsWith_... возвращают True, если первый из двух
  массивов 4-байтных или 2-байтных элементов содержит какие-либо значения,
  присутствующие во втором массиве. Если в между массивами нет общих
  элементов, функции возвращают False. P1 - адрес первого массива, Count1 -
  число элементов в первом массиве, P2 - адрес второго массива, Count2 -
  число элементов во втором массиве. Массивы P1 и P2 должны быть
  отсортированы по возрастанию. }

function G_SetIntersectsWith_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
function G_SetIntersectsWith_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
function G_SetIntersectsWith_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;

{ Функции G_SetUnion_... формируют из двух массивов 4-байтных или 2-байтных
  элементов соответствующего типа новый массив, состоящий из элементов,
  которые присутствуют хотя бы в одном из исходных массивов. P1 - адрес
  первого массива, Count1 - число элементов в первом массиве, P2 - адрес
  второго массива, Count2 - число элементов во втором массиве, OutPlace -
  адрес области памяти, в которой будет сохранен массив-результат. Функции
  возвращают количество элементов в выходном массиве. Если OutPlace равно
  nil, функции не заполняют выходной массив, а только вычисляют количество
  элементов в нем; иначе, OutPlace должен указывать на область памяти,
  достаточную для хранения массива-результата (максимальный размер равен
  суммарному размеру первого и второго массивов). Массивы P1 и P2 должны
  быть отсортированы по возрастанию. }

function G_SetUnion_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetUnion_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetUnion_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;

{ Функции G_SetIntersection_... формируют из двух массивов 4-байтных или
  2-байтных элементов соответствующего типа новый массив, состоящий только
  из тех элементов, которые присутствуют в обоих исходных массивах. P1 - адрес
  первого массива, Count1 - число элементов в первом массиве, P2 - адрес
  второго массива, Count2 - число элементов во втором массиве, OutPlace - адрес
  области памяти, в которой будет сохранен массив-результат. Функции возвращают
  количество элементов в выходном массиве. Если OutPlace равно nil, функции
  не заполняют выходной массив, а только вычисляют количество элементов в нем.
  Иначе, OutPlace должен указывать на область памяти, достаточную для хранения
  массива-результата (максимальный размер равен размеру меньшего из исходных
  массивов). Массивы P1 и P2 должны быть отсортированы по возрастанию. }

function G_SetIntersection_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetIntersection_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetIntersection_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;

{ Функции G_SetDifference_... формируют из двух массивов 4-байтных или
  2-байтных элементов соответствующего типа новый массив, состоящий из
  элементов, которые присутствуют в первом исходном массиве, но отсутствуют
  во втором. P1 - адрес первого массива, Count1 - число элементов в первом
  массиве, P2 - адрес второго массива, Count2 - число элементов во втором
  массиве, OutPlace - адрес области памяти, в которой будет сохранен массив-
  результат. Функции возвращают количество элементов в выходном массиве.
  Если OutPlace равно nil, функции не заполняют выходной массив, а только
  вычисляют количество элементов в нем; иначе, OutPlace должен указывать на
  область памяти, достаточную для хранения массива-результата (максимальный
  размер равен размеру первого исходного массива). Массивы P1 и P2 должны
  быть отсортированы по возрастанию. }

function G_SetDifference_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetDifference_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetDifference_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;

{ Функции G_SetSymmetricDifference_... формируют из двух массивов 4-байтных
  или 2-байтных элементов соответствующего типа новый массив, состоящий из
  элементов, которые присутствуют в одном из исходных массивов, но отсутствуют
  в другом. P1 - адрес первого массива, Count1 - число элементов в первом
  массиве, P2 - адрес второго массива, Count2 - число элементов во втором
  массиве, OutPlace - адрес области памяти, в которой будет сохранен массив-
  результат. Функции возвращают количество элементов в выходном массиве. Если
  OutPlace равно nil, функции не заполняют выходной массив, а только вычисляют
  количество элементов в нем; иначе, OutPlace должен указывать на область
  памяти, достаточную для хранения массива-результата (максимальный размер
  равен суммарному размеру первого и второго массивов). Массивы P1 и P2
  должны быть отсортированы по возрастанию. }

function G_SetSymmetricDifference_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetSymmetricDifference_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;
function G_SetSymmetricDifference_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer = nil): Cardinal;


{ Функции для работы с битами в составе двойного слова }

{ Массив BitMasks32 содержит маску для каждого бита в составе двойного слова
  типа LongWord. Значение, маскирующее бит, можно получить обратившись к
  элементу массива с индексом, соответствующим номеру бита. }

const
  BitMasks32: array[0..31] of LongWord =
    ($00000001,$00000002,$00000004,$00000008,$00000010,$00000020,$00000040,$00000080,
     $00000100,$00000200,$00000400,$00000800,$00001000,$00002000,$00004000,$00008000,
     $00010000,$00020000,$00040000,$00080000,$00100000,$00200000,$00400000,$00800000,
     $01000000,$02000000,$04000000,$08000000,$10000000,$20000000,$40000000,$80000000);

{ G_ReverseBits обращает порядок следования бит в значении L длиной
  BitCount бит (0 < BitCount <= 32) и возвращает полученное значение
  как результат функции. }

function G_ReverseBits(L: LongWord; BitCount: Integer): LongWord;

{ G_BitTest32 возвращает True, если в двойном слове L бит с индексом Index
  установлен, т.е. равен единице (нумерация битов с нуля). Иначе, функция
  возвращает False. }

function G_BitTest32(L: LongWord; Index: Cardinal): Boolean;

{ G_BitSet32 устанавливает в двойном слове L бит с индексом Index в единицу. }

function G_BitSet32(L: LongWord; Index: Cardinal): LongWord;

{ G_BitReset32 сбрасывает в двойном слове L бит с индексом Index в ноль. }

function G_BitReset32(L: LongWord; Index: Cardinal): LongWord;

{ G_BitToggle32 инвертирует в двойном слове L бит с индексом Index. }

function G_BitToggle32(L: LongWord; Index: Cardinal): LongWord;

{ G_SetBits32 устанавливает в единицу каждый бит в двойном слове L, начиная
  с бита FirstBit (нумерация с нуля) и кончая битом LastBit. }

function G_SetBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;

{ G_ResetBits32 обнуляет (сбрасывает) каждый бит в двойном слове L, начиная
  с бита FirstBit (нумерация с нуля) и кончая битом LastBit. }

function G_ResetBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;

{ G_ToggleBits32 инвертирует каждый бит в двойном слове L, начиная с бита
  FirstBit (нумерация с нуля) и кончая битом LastBit. }

function G_ToggleBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;

{ G_CountOfSetBits32 возвращает количество установленных (единичных) битов
  в двойном слове L, начиная с бита FirstBit (от 0 до 31) и заканчивая битом
  LastBit (от 0 до 31). }

function G_CountOfSetBits32(L: LongWord): Cardinal; overload;
function G_CountOfSetBits32(L: LongWord; FirstBit, LastBit: Integer): Cardinal; overload;

{ G_CountOfFreeBits32 возвращает количество сброшенных (нулевых) битов
  в двойном слове L, начиная с бита FirstBit (от 0 до 31) и заканчивая битом
  LastBit (от 0 до 31). }

function G_CountOfFreeBits32(L: LongWord): Cardinal; overload;
function G_CountOfFreeBits32(L: LongWord; FirstBit, LastBit: Integer): Cardinal; overload;

{ G_SetBitScanForward32 сканирует двойное слово L в поисках бита, отличного от
  нуля. Функция возвращает индекс первого установленного бита, начиная с бита
  FirstBit (от 0 до 31). Если единичный бит не найден, функция возвращает -1. }

function G_SetBitScanForward32(L: LongWord; FirstBit: Integer = 0): Integer;

{ G_FreeBitScanForward32 сканирует двойное слово L в поисках нулевого бита.
  Функция возвращает индекс первого сброшенного бита, начиная с бита FirstBit
  (от 0 до 31). Если нулевой бит не найден, функция возвращает -1. }

function G_FreeBitScanForward32(L: LongWord; FirstBit: Integer = 0): Integer;

{ G_SetBitScanBackward32 сканирует назад двойное слово L в поисках бита,
  отличного от нуля. Функция возвращает индекс последнего установленного бита,
  начиная с бита LastBit (от 0 до 31). Если единичный бит не найден, функция
  возвращает -1. }

function G_SetBitScanBackward32(L: LongWord; LastBit: Integer = 31): Integer;

{ G_FreeBitScanBackward32 сканирует назад двойное слово L в поисках нулевого
  бита. Функция возвращает индекс последнего сброшенного бита, начиная с бита
  LastBit (от 0 до 31). Если нулевой бит не найден, функция возвращает -1. }

function G_FreeBitScanBackward32(L: LongWord; LastBit: Integer = 31): Integer;


{ Функции для работы с битовой строкой }

{ G_BitTest проверяет бит и возвращает True, если бит установлен в единицу,
  и False, если он сброшен в ноль. Адрес битовой строки передается параметром
  P. Смещение бита относительно начала строки задается параметром Index.
  Самый первый бит строки имеет смещение ноль. Возможно задание отрицательного
  смещения. }

function G_BitTest(P: Pointer; Index: Integer): Boolean;

{ G_BitSet устанавливает бит в единицу и возвращает True, если до этого бит
  был установлен в единицу, и False, если до этого бит был сброшен в ноль.
  Адрес битовой строки передается параметром P. Смещение бита относительно
  начала строки задается параметром Index. Самый первый бит строки имеет
  смещение ноль. Возможно задание отрицательного смещения. }

function G_BitSet(P: Pointer; Index: Integer): Boolean;

{ G_BitReset сбрасывает бит в ноль и возвращает True, если до этого бит был
  установлен в единицу, и False, если до этого бит был сброшен в ноль. Адрес
  битовой строки передается параметром P. Смещение бита относительно начала
  строки задается параметром Index. Нумерация битов начинается с нуля.
  Возможно задание отрицательного смещения. }

function G_BitReset(P: Pointer; Index: Integer): Boolean;

{ G_BitToggle инвертирует бит и возвращает True, если раньше бит был установлен
  в единицу, и False, если бит был сброшен в ноль. Адрес битовой строки
  передается параметром P. Смещение бита относительно начала строки задается
  параметром Index. Нумерация битов начинается с нуля. Возможно задание
  отрицательного смещения. }

function G_BitToggle(P: Pointer; Index: Integer): Boolean;

{ G_SetBits устанавливает в единицу каждый бит в массиве, адресуемом параметром
  P, начиная с бита с индексом FirstBit (нумерация с нуля) и кончая битом с
  индексом LastBit. Размер массива и его адрес должны быть кратны 4 байтам. }

procedure G_SetBits(P: Pointer; FirstBit, LastBit: Integer);

{ G_ResetBits обнуляет (сбрасывает) каждый бит в массиве, адрес которого
  передается параметром P, начиная с бита с индексом FirstBit (нумерация с
  нуля) и кончая битом с индексом LastBit. Размер массива и его адрес должны
  быть кратны 4 байтам. }

procedure G_ResetBits(P: Pointer; FirstBit, LastBit: Integer);

{ G_ToggleBits инвертирует каждый бит в массиве, адресуемом параметром P,
  начиная с бита с индексом FirstBit (нумерация с нуля) и кончая битом с
  индексом LastBit. Размер массива и его адрес должны быть кратны 4 байтам. }

procedure G_ToggleBits(P: Pointer; FirstBit, LastBit: Integer);

{ G_CountOfSetBits возвращает число установленных (единичных) битов в байтовом
  массиве, адресуемом параметром P, начиная с бита с индексом FirstBit
  (нумерация с нуля) и кончая битом с индексом LastBit. Размер массива и его
  адрес должны быть кратны 4 байтам. }

function G_CountOfSetBits(P: Pointer; FirstBit, LastBit: Integer): Cardinal;

{ G_CountOfFreeBits возвращает число сброшенных (нулевых) битов в байтовом
  массиве, адресуемом параметром P, начиная с бита с индексом FirstBit
  (нумерация с нуля) и кончая битом с индексом LastBit. Размер массива и его
  адрес должны быть кратны 4 байтам. }

function G_CountOfFreeBits(P: Pointer; FirstBit, LastBit: Integer): Cardinal;

{ G_SetBitScanForward сканирует битовый массив, адресуемый P, в поисках бита,
  отличного от нуля. Функция возвращает индекс первого установленного бита,
  начиная с бита с индексом FirstBit (нумерация битов с нуля) и кончая индексом
  LastBit. Если единичный бит в этом диапазоне не найден, функция возвращает
  -1. Размер массива и его адрес должны быть кратны 4 байтам. }

function G_SetBitScanForward(P: Pointer; FirstBit, LastBit: Integer): Integer;

{ G_FreeBitScanForward сканирует битовый массив, адресуемый P, в поисках
  нулевого бита. Функция возвращает индекс первого сброшенного бита, начиная
  с бита с индексом FirstBit (нумерация битов с нуля) и кончая индексом
  LastBit. Если нулевой бит в этом диапазоне не найден, функция возвращает -1.
  Размер массива и его адрес должны быть кратны 4 байтам. }

function G_FreeBitScanForward(P: Pointer; FirstBit, LastBit: Integer): Integer;

{ G_SetBitScanBackward сканирует назад битовый массив, адресуемый P, в поисках
  бита, отличного от нуля. Функция возвращает индекс последнего установленного
  бита, начиная с бита с индексом LastBit и кончая индексом FirstBit. Если
  единичный бит в этом диапазоне не найден, функция возвращает -1. Размер
  массива и его адрес должны быть кратны 4 байтам. }

function G_SetBitScanBackward(P: Pointer; FirstBit, LastBit: Integer): Integer;

{ G_FreeBitScanBackward сканирует назад битовый массив, адресуемый P, в поисках
  нулевого бита. Функция возвращает индекс последнего сброшенного бита, начиная
  с бита с индексом LastBit и кончая индексом FirstBit. Если нулевой бит в
  этом диапазоне не найден, функция возвращает -1. Размер массива и его адрес
  должны быть кратны 4 байтам. }

function G_FreeBitScanBackward(P: Pointer; FirstBit, LastBit: Integer): Integer;

implementation

uses AcedConsts;

{ Разные функции }

procedure G_Swap32(var A, B);
asm
        PUSH    EBX
        MOV     ECX,[EDX]
        MOV     EBX,[EAX]
        MOV     [EAX],ECX
        MOV     [EDX],EBX
        POP     EBX
end;

procedure G_Swap16(var A, B);
asm
        PUSH    EBX
        MOV     CX,[EDX]
        MOV     BX,[EAX]
        MOV     [EAX],CX
        MOV     [EDX],BX
        POP     EBX
end;

procedure G_Swap8(var A, B);
asm
        MOV     CL,[EDX]
        MOV     CH,[EAX]
        MOV     [EAX],CL
        MOV     [EDX],CH
end;

function G_BSwap(L: LongWord): LongWord;
asm
        BSWAP   EAX
end;

function G_Log2(L: LongWord): LongWord;
asm
        TEST    EAX,EAX
        JE      @@zq
        BSR     EAX,EAX
@@zq:
end;

function G_CeilPowerOfTwo(L: LongWord): LongWord;
asm
        TEST    EAX,EAX
        JE      @@zq
        BSR     EDX,EAX
        BSF     ECX,EAX
        CMP     EDX,ECX
        JNE     @@nx
        RET
@@zq:   MOV     EAX,1
        RET
@@nx:   INC     EDX
        TEST    EAX,$80000000
        JNE     @@ov
        MOV     EAX,DWORD PTR [EDX*4+BitMasks32]
        RET
@@ov:   XOR     EAX,EAX
end;

function G_FloorPowerOfTwo(L: LongWord): LongWord;
asm
        TEST    EAX,EAX
        JE      @@zq
        BSR     EDX,EAX
        MOV     EAX,DWORD PTR [EDX*4+BitMasks32]
@@zq:
end;

function G_IncPowerOfTwo(L: LongWord): LongWord;
asm
        TEST    EAX,EAX
        JE      @@zq
        TEST    EAX,$80000000
        JNE     @@ov
        BSR     EDX,EAX
        INC     EDX
        MOV     EAX,DWORD PTR [EDX*4+BitMasks32]
        RET
@@zq:   MOV     EAX,1
        RET
@@ov:   XOR     EAX,EAX
end;

function G_DecPowerOfTwo(L: LongWord): LongWord;
asm
        TEST    EAX,$FFFFFFFE
        JE      @@zq
        BSR     EDX,EAX
        BSF     ECX,EAX
        CMP     EDX,ECX
        JNE     @@nx
        DEC     EDX
@@nx:   MOV     EAX,DWORD PTR [EDX*4+BitMasks32]
        RET
@@zq:   XOR     EAX,EAX
end;

function G_Gcd(U, V: LongWord): LongWord;
begin
  repeat
    if U = 0 then
    begin
      Result := V;
      Exit;
    end;
    V := V mod U;
    if V = 0 then
    begin
      Result := U;
      Exit;
    end;
    U := U mod V;
  until False;
end;

function G_Lcm(U, V: LongWord): LongWord;
var
  T: LongWord;
begin
  T := G_Gcd(U, V);
  if T <> 0 then
    Result := (U div T) * V
  else
    Result := 0;
end;

procedure IntTinyFill(P: Pointer; L: Cardinal; Value: LongWord);
asm
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
        DD      @@tu16, @@tu17, @@tu18, @@tu19
        DD      @@tu20, @@tu21, @@tu22, @@tu23
        DD      @@tu24, @@tu25, @@tu26, @@tu27
        DD      @@tu28, @@tu29, @@tu30, @@tu31
@@tu01: MOV     BYTE PTR [EAX],CL
@@tu00: RET
@@tu02: MOV     WORD PTR [EAX],CX
        RET
@@tu03: MOV     WORD PTR [EAX],CX
        MOV     BYTE PTR [EAX+2],CL
        RET
@@tu04: MOV     DWORD PTR [EAX],ECX
        RET
@@tu05: MOV     DWORD PTR [EAX],ECX
        MOV     BYTE PTR [EAX+4],CL
        RET
@@tu06: MOV     DWORD PTR [EAX],ECX
        MOV     WORD PTR [EAX+4],CX
        RET
@@tu07: MOV     DWORD PTR [EAX],ECX
        MOV     WORD PTR [EAX+4],CX
        MOV     BYTE PTR [EAX+6],CL
        RET
@@tu08: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        RET
@@tu09: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     BYTE PTR [EAX+8],CL
        RET
@@tu10: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     WORD PTR [EAX+8],CX
        RET
@@tu11: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     WORD PTR [EAX+8],CX
        MOV     BYTE PTR [EAX+10],CL
        RET
@@tu12: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        RET
@@tu13: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     BYTE PTR [EAX+12],CL
        RET
@@tu14: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     WORD PTR [EAX+12],CX
        RET
@@tu15: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     WORD PTR [EAX+12],CX
        MOV     BYTE PTR [EAX+14],CL
        RET
@@tu16: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        RET
@@tu17: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     BYTE PTR [EAX+16],CL
        RET
@@tu18: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     WORD PTR [EAX+16],CX
        RET
@@tu19: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     WORD PTR [EAX+16],CX
        MOV     BYTE PTR [EAX+18],CL
        RET
@@tu20: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        RET
@@tu21: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     BYTE PTR [EAX+20],CL
        RET
@@tu22: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     WORD PTR [EAX+20],CX
        RET
@@tu23: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     WORD PTR [EAX+20],CX
        MOV     BYTE PTR [EAX+22],CL
        RET
@@tu24: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        RET
@@tu25: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     BYTE PTR [EAX+24],CL
        RET
@@tu26: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     WORD PTR [EAX+24],CX
        RET
@@tu27: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     WORD PTR [EAX+24],CX
        MOV     BYTE PTR [EAX+26],CL
        RET
@@tu28: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        RET
@@tu29: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     BYTE PTR [EAX+28],CL
        RET
@@tu30: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     WORD PTR [EAX+28],CX
        RET
@@tu31: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     WORD PTR [EAX+28],CX
        MOV     BYTE PTR [EAX+30],CL
end;

{ Функции для работы с блоками памяти }

procedure G_ZeroMem(P: Pointer; L: Cardinal);
asm
        CMP     EDX,31
        JA      @@nx1
        XOR     ECX,ECX
        CALL    IntTinyFill
        RET
@@nx1:  PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,31
        SHR     ECX,5
        JE      @@nx2
        PXOR    MM0,MM0
@@lp:   MOVQ    [EDI],MM0
        MOVQ    [EDI+8],MM0
        MOVQ    [EDI+16],MM0
        MOVQ    [EDI+24],MM0
        ADD     EDI,32
        DEC     ECX
        JNE     @@lp
@@nx2:  MOV     EAX,EDI
        CALL    IntTinyFill
        EMMS
        POP     EDI
end;

procedure G_FillMem(B: Byte; P: Pointer; L: Cardinal);
asm
        PUSH    EDI
        MOV     EDI,EDX
        CMP     ECX,16
        JB      @@tl
        NEG     EDX
        AND     EDX,7
        SUB     ECX,EDX
        JMP     DWORD PTR @@bV[EDX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,EDX
@@bu00: MOVZX   EDX,AL
        SHL     EAX,8
        OR      EAX,EDX
        MOVZX   EDX,AX
        SHL     EAX,16
        OR      EAX,EDX
        MOV     EDX,ECX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
        NOP
@@tl:   JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
@@tu15: MOV     [EDI+14],AL
@@tu14: MOV     [EDI+13],AL
@@tu13: MOV     [EDI+12],AL
@@tu12: MOV     [EDI+11],AL
@@tu11: MOV     [EDI+10],AL
@@tu10: MOV     [EDI+09],AL
@@tu09: MOV     [EDI+08],AL
@@tu08: MOV     [EDI+07],AL
@@tu07: MOV     [EDI+06],AL
@@tu06: MOV     [EDI+05],AL
@@tu05: MOV     [EDI+04],AL
@@tu04: MOV     [EDI+03],AL
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;

procedure IntCopy16;
asm
        MOVQ  MM0,[ESI]
        MOVQ  MM1,[ESI+8]
        MOVQ  MM2,[ESI+16]
        MOVQ  MM3,[ESI+24]
        MOVQ  MM4,[ESI+32]
        MOVQ  MM5,[ESI+40]
        MOVQ  MM6,[ESI+48]
        MOVQ  MM7,[ESI+56]
        MOVQ  [EDI],MM0
        MOVQ  [EDI+8],MM1
        MOVQ  [EDI+16],MM2
        MOVQ  [EDI+24],MM3
        MOVQ  [EDI+32],MM4
        MOVQ  [EDI+40],MM5
        MOVQ  [EDI+48],MM6
        MOVQ  [EDI+56],MM7
end;

procedure G_CopyMem(Source, Dest: Pointer; L: Cardinal);
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     EDX,ECX
        MOV     ESI,EAX
        TEST    EDI,3
        JNE     @@cl
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,16
        JBE     @@cw0
@@lp0:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp0
@@cw0:  JMP     DWORD PTR @@wV[ECX*4]
@@cl:   MOV     EAX,EDI
        MOV     EDX,3
        SUB     ECX,4
        JB      @@bc
        AND     EAX,3
        ADD     ECX,EAX
        JMP     DWORD PTR @@lV[EAX*4-4]
@@bc:   JMP     DWORD PTR @@tV[ECX*4+16]
@@lV:   DD      @@l1, @@l2, @@l3
@@l1:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        SHR     ECX,2
        MOV     [EDI+2],AL
        ADD     ESI,3
        ADD     EDI,3
        CMP     ECX,16
        JBE     @@cw1
@@lp1:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp1
@@cw1:  JMP     DWORD PTR @@wV[ECX*4]
@@l2:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        SHR     ECX,2
        MOV     [EDI+1],AL
        ADD     ESI,2
        ADD     EDI,2
        CMP     ECX,16
        JBE     @@cw2
@@lp2:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp2
@@cw2:  JMP     DWORD PTR @@wV[ECX*4]
@@l3:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        INC     ESI
        SHR     ECX,2
        INC     EDI
        CMP     ECX,16
        JBE     @@cw3
@@lp3:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp3
@@cw3:  JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
        DD      @@w8, @@w9, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16
@@w16:  MOV     EAX,[ESI+ECX*4-64]
        MOV     [EDI+ECX*4-64],EAX
@@w15:  MOV     EAX,[ESI+ECX*4-60]
        MOV     [EDI+ECX*4-60],EAX
@@w14:  MOV     EAX,[ESI+ECX*4-56]
        MOV     [EDI+ECX*4-56],EAX
@@w13:  MOV     EAX,[ESI+ECX*4-52]
        MOV     [EDI+ECX*4-52],EAX
@@w12:  MOV     EAX,[ESI+ECX*4-48]
        MOV     [EDI+ECX*4-48],EAX
@@w11:  MOV     EAX,[ESI+ECX*4-44]
        MOV     [EDI+ECX*4-44],EAX
@@w10:  MOV     EAX,[ESI+ECX*4-40]
        MOV     [EDI+ECX*4-40],EAX
@@w9:   MOV     EAX,[ESI+ECX*4-36]
        MOV     [EDI+ECX*4-36],EAX
@@w8:   MOV     EAX,[ESI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        MOV     [EDI+ECX*4-20],EAX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        SHL     ECX,2
        ADD     ESI,ECX
        ADD     EDI,ECX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        JMP     @@t0
@@t2:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        JMP     @@t0
@@t1:   MOV     AL,[ESI]
        MOV     [EDI],AL
@@t0:   POP     ESI
        POP     EDI
        EMMS
end;

procedure G_MoveMem(Source, Dest: Pointer; L: Cardinal);
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     EAX,ECX
        MOV     EDX,ECX
        ADD     EAX,ESI
        CMP     EDI,ESI
        JBE     @@cpu
        CMP     EDI,EAX
        JB      @@cpd
@@cpu:  TEST    EDI,3
        JNZ     @@clu
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,16
        JBE     @@cwu
        REP     MOVSD
        JMP     DWORD PTR @@tuV[EDX*4]
@@clu:  MOV     EAX,EDI
        MOV     EDX,3
        SUB     ECX,4
        JB      @@bcu
        AND     EAX,3
        ADD     ECX,EAX
        JMP     DWORD PTR @@luV[EAX*4-4]
@@bcu:  JMP     DWORD PTR @@tuV[ECX*4+16]
@@cwu:  JMP     DWORD PTR @@wuV[ECX*4]
@@luV:  DD      @@lu1, @@lu2, @@lu3
@@lu1:  AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        SHR     ECX,2
        MOV     [EDI+2],AL
        ADD     ESI,3
        ADD     EDI,3
        CMP     ECX,16
        JBE     @@cwu
        REP     MOVSD
        JMP     DWORD PTR @@tuV[EDX*4]
@@lu2:  AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        SHR     ECX,2
        MOV     [EDI+1],AL
        ADD     ESI,2
        ADD     EDI,2
        CMP     ECX,16
        JBE     @@cwu
        REP     MOVSD
        JMP     DWORD PTR @@tuV[EDX*4]
@@lu3:  AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        INC     ESI
        SHR     ECX,2
        INC     EDI
        CMP     ECX,16
        JBE     @@cwu
        REP     MOVSD
        JMP     DWORD PTR @@tuV[EDX*4]
@@wuV:  DD      @@wu0, @@wu1, @@wu2, @@wu3
        DD      @@wu4, @@wu5, @@wu6, @@wu7
        DD      @@wu8, @@wu9, @@wu10, @@wu11
        DD      @@wu12, @@wu13, @@wu14, @@wu15
        DD      @@wu16
@@wu16: MOV     EAX,[ESI+ECX*4-64]
        MOV     [EDI+ECX*4-64],EAX
@@wu15: MOV     EAX,[ESI+ECX*4-60]
        MOV     [EDI+ECX*4-60],EAX
@@wu14: MOV     EAX,[ESI+ECX*4-56]
        MOV     [EDI+ECX*4-56],EAX
@@wu13: MOV     EAX,[ESI+ECX*4-52]
        MOV     [EDI+ECX*4-52],EAX
@@wu12: MOV     EAX,[ESI+ECX*4-48]
        MOV     [EDI+ECX*4-48],EAX
@@wu11: MOV     EAX,[ESI+ECX*4-44]
        MOV     [EDI+ECX*4-44],EAX
@@wu10: MOV     EAX,[ESI+ECX*4-40]
        MOV     [EDI+ECX*4-40],EAX
@@wu9:  MOV     EAX,[ESI+ECX*4-36]
        MOV     [EDI+ECX*4-36],EAX
@@wu8:  MOV     EAX,[ESI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
@@wu7:  MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@wu6:  MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@wu5:  MOV     EAX,[ESI+ECX*4-20]
        MOV     [EDI+ECX*4-20],EAX
@@wu4:  MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@wu3:  MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@wu2:  MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@wu1:  MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        LEA     EAX,[ECX*4]
        ADD     ESI,EAX
        ADD     EDI,EAX
@@wu0:  JMP     DWORD PTR @@tuV[EDX*4]
@@tuV:  DD      @@tu0, @@tu1, @@tu2, @@tu3
@@tu0:  POP     ESI
        POP     EDI
        RET
@@tu1:  MOV     AL,[ESI]
        MOV     [EDI],AL
        POP     ESI
        POP     EDI
        RET
@@tu2:  MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        POP     ESI
        POP     EDI
        RET
@@tu3:  MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        POP     ESI
        POP     EDI
        RET
@@cpd:  LEA     ESI,[ESI+ECX-4]
        LEA     EDI,[EDI+ECX-4]
        TEST    EDI,3
        JNZ     @@cld
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,16
        JBE     @@cwd
        STD
        REP     MOVSD
        CLD
        JMP     DWORD PTR @@tdV[EDX*4]
@@cwd:  NEG     ECX
        JMP     DWORD PTR @@wdV[ECX*4+64]
@@cld:  MOV     EAX,EDI
        MOV     EDX,3
        CMP     ECX,4
        JB      @@bcd
        AND     EAX,3
        SUB     ECX,EAX
        JMP     DWORD PTR @@ldV[EAX*4-4]
@@bcd:  JMP     DWORD PTR @@tdV[ECX*4]
@@ldV:  DD      @@ld1, @@ld2, @@ld3
@@ld1:  MOV     AL,[ESI+3]
        AND     EDX,ECX
        MOV     [EDI+3],AL
        DEC     ESI
        SHR     ECX,2
        DEC     EDI
        CMP     ECX,16
        JBE     @@cwd
        STD
        REP     MOVSD
        CLD
        JMP     DWORD PTR @@tdV[EDX*4]
@@ld2:  MOV     AL,[ESI+3]
        AND     EDX,ECX
        MOV     [EDI+3],AL
        MOV     AL,[ESI+2]
        SHR     ECX,2
        MOV     [EDI+2],AL
        SUB     ESI,2
        SUB     EDI,2
        CMP     ECX,16
        JBE     @@cwd
        STD
        REP     MOVSD
        CLD
        JMP     DWORD PTR @@tdV[EDX*4]
@@ld3:  MOV     AL,[ESI+3]
        AND     EDX,ECX
        MOV     [EDI+3],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        MOV     AL,[ESI+1]
        SHR     ECX,2
        MOV     [EDI+1],AL
        SUB     ESI,3
        SUB     EDI,3
        CMP     ECX,16
        JBE     @@cwd
        STD
        REP     MOVSD
        CLD
        JMP     DWORD PTR @@tdV[EDX*4]
@@wdV:  DD      @@wd16
        DD      @@wd15, @@wd14, @@wd13, @@wd12
        DD      @@wd11, @@wd10, @@wd9, @@wd8
        DD      @@wd7, @@wd6, @@wd5, @@wd4
        DD      @@wd3, @@wd2, @@wd1, @@wd0
@@wd16: MOV     EAX,[ESI+ECX*4+64]
        MOV     [EDI+ECX*4+64],EAX
@@wd15: MOV     EAX,[ESI+ECX*4+60]
        MOV     [EDI+ECX*4+60],EAX
@@wd14: MOV     EAX,[ESI+ECX*4+56]
        MOV     [EDI+ECX*4+56],EAX
@@wd13: MOV     EAX,[ESI+ECX*4+52]
        MOV     [EDI+ECX*4+52],EAX
@@wd12: MOV     EAX,[ESI+ECX*4+48]
        MOV     [EDI+ECX*4+48],EAX
@@wd11: MOV     EAX,[ESI+ECX*4+44]
        MOV     [EDI+ECX*4+44],EAX
@@wd10: MOV     EAX,[ESI+ECX*4+40]
        MOV     [EDI+ECX*4+40],EAX
@@wd9:  MOV     EAX,[ESI+ECX*4+36]
        MOV     [EDI+ECX*4+36],EAX
@@wd8:  MOV     EAX,[ESI+ECX*4+32]
        MOV     [EDI+ECX*4+32],EAX
@@wd7:  MOV     EAX,[ESI+ECX*4+28]
        MOV     [EDI+ECX*4+28],EAX
@@wd6:  MOV     EAX,[ESI+ECX*4+24]
        MOV     [EDI+ECX*4+24],EAX
@@wd5:  MOV     EAX,[ESI+ECX*4+20]
        MOV     [EDI+ECX*4+20],EAX
@@wd4:  MOV     EAX,[ESI+ECX*4+16]
        MOV     [EDI+ECX*4+16],EAX
@@wd3:  MOV     EAX,[ESI+ECX*4+12]
        MOV     [EDI+ECX*4+12],EAX
@@wd2:  MOV     EAX,[ESI+ECX*4+8]
        MOV     [EDI+ECX*4+8],EAX
@@wd1:  MOV     EAX,[ESI+ECX*4+4]
        MOV     [EDI+ECX*4+4],EAX
        LEA     EAX,[ECX*4]
        ADD     ESI,EAX
        ADD     EDI,EAX
@@wd0:  JMP     DWORD PTR @@tdV[EDX*4]
@@tdV:  DD      @@td0, @@td1, @@td2, @@td3
@@td0:  POP     ESI
        POP     EDI
        RET
@@td1:  MOV     AL,[ESI+3]
        MOV     [EDI+3],AL
        POP     ESI
        POP     EDI
        RET
@@td2:  MOV     AL,[ESI+3]
        MOV     [EDI+3],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        POP     ESI
        POP     EDI
        RET
@@td3:  MOV     AL,[ESI+3]
        MOV     [EDI+3],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        POP     ESI
        POP     EDI
end;

function G_SameMem(P1, P2: Pointer; L: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@ex
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,ECX
        SHR     ECX,4
        JE      @@nx
@@lp:   MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq0
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq0
        MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq0
        MOV     EBX,[EAX+12]
        CMP     EBX,[EDX+12]
        JNE     @@zq0
        ADD     EAX,16
        ADD     EDX,16
        DEC     ECX
        JNE     @@lp
@@nx:   AND     ESI,$F
        JMP     DWORD PTR @@tV[ESI*4]
@@ex:   MOV     EAX,1
        RET
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
        DD      @@t8,@@t9,@@t10,@@t11
        DD      @@t12,@@t13,@@t14,@@t15
@@zq0:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@t15:  MOV     BL,BYTE PTR [EAX+14]
        XOR     BL,BYTE PTR [EDX+14]
        JNE     @@zq1
@@t14:  MOV     BL,BYTE PTR [EAX+13]
        XOR     BL,BYTE PTR [EDX+13]
        JNE     @@zq1
@@t13:  MOV     BL,BYTE PTR [EAX+12]
        XOR     BL,BYTE PTR [EDX+12]
        JNE     @@zq1
@@t12:  MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq1
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
@@eq:   POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@t11:  MOV     BL,BYTE PTR [EAX+10]
        XOR     BL,BYTE PTR [EDX+10]
        JNE     @@zq1
@@t10:  MOV     BL,BYTE PTR [EAX+9]
        XOR     BL,BYTE PTR [EDX+9]
        JNE     @@zq1
@@t9:   MOV     BL,BYTE PTR [EAX+8]
        XOR     BL,BYTE PTR [EDX+8]
        JNE     @@zq1
@@t8:   MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq1:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq2
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq2
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq2
@@t4:   MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq2
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq2
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq2
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq2
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq2:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
end;

function G_XorMemSum(P: Pointer; L: Cardinal): LongWord;
asm
        MOV     ECX,EDX
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
        SHR     EDX,3
        JE      @@nx
@@lp:   XOR     EAX,[EBX]
        XOR     EAX,[EBX+4]
        ADD     EBX,8
        DEC     EDX
        JNE     @@lp
@@nx:   AND     ECX,7
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@qt,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t1:   XOR     AL,BYTE PTR [EBX]
        JMP     @@qt
@@t2:   XOR     AX,WORD PTR [EBX]
        JMP     @@qt
@@t3:   XOR     AX,WORD PTR [EBX]
        MOVZX   EDX,BYTE PTR [EBX+2]
        SHL     EDX,16
        XOR     EAX,EDX
        JMP     @@qt
@@t4:   XOR     EAX,DWORD PTR [EBX]
        JMP     @@qt
@@t5:   XOR     EAX,DWORD PTR [EBX]
        XOR     AL,BYTE PTR [EBX+4]
        JMP     @@qt
@@t6:   XOR     EAX,DWORD PTR [EBX]
        XOR     AX,WORD PTR [EBX+4]
        JMP     @@qt
@@t7:   XOR     EAX,DWORD PTR [EBX]
        XOR     AX,WORD PTR [EBX+4]
        MOVZX   EDX,BYTE PTR [EBX+6]
        SHL     EDX,16
        XOR     EAX,EDX
@@qt:   POP     EBX
end;

function G_AllocMem(L: Cardinal): Pointer;
begin
  GetMem(Result, L);
  G_ZeroMem(Result, L);
end;

{ Функции для работы с массивами двойных слов }

procedure G_GenerateLongs(P: Pointer; Count: Cardinal; Seed: Integer);
asm
@@lp:   SUB     EDX,8
        JS      @@nx
        MOV     [EAX],ECX
        INC     ECX
        MOV     [EAX+4],ECX
        INC     ECX
        MOV     [EAX+8],ECX
        INC     ECX
        MOV     [EAX+12],ECX
        INC     ECX
        MOV     [EAX+16],ECX
        INC     ECX
        MOV     [EAX+20],ECX
        INC     ECX
        MOV     [EAX+24],ECX
        INC     ECX
        MOV     [EAX+28],ECX
        INC     ECX
        ADD     EAX,32
        JMP     @@lp
@@nx:   ADD     EDX,8
        JMP     DWORD PTR @@wV[EDX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
@@w07:  MOV     [EAX+EDX*4-28],ECX
        INC     ECX
@@w06:  MOV     [EAX+EDX*4-24],ECX
        INC     ECX
@@w05:  MOV     [EAX+EDX*4-20],ECX
        INC     ECX
@@w04:  MOV     [EAX+EDX*4-16],ECX
        INC     ECX
@@w03:  MOV     [EAX+EDX*4-12],ECX
        INC     ECX
@@w02:  MOV     [EAX+EDX*4-8],ECX
        INC     ECX
@@w01:  MOV     [EAX+EDX*4-4],ECX
@@w00:
end;

procedure G_GenerateLongs(P: Pointer; Count: Cardinal; Seed, Delta: Integer);
asm
        PUSH    EBX
        MOV     EBX,EAX
        MOV     EAX,[ESP+12]
@@lp:   SUB     EDX,8
        JS      @@nx
        MOV     [EBX],ECX
        ADD     ECX,EAX
        MOV     [EBX+4],ECX
        ADD     ECX,EAX
        MOV     [EBX+8],ECX
        ADD     ECX,EAX
        MOV     [EBX+12],ECX
        ADD     ECX,EAX
        MOV     [EBX+16],ECX
        ADD     ECX,EAX
        MOV     [EBX+20],ECX
        ADD     ECX,EAX
        MOV     [EBX+24],ECX
        ADD     ECX,EAX
        MOV     [EBX+28],ECX
        ADD     ECX,EAX
        ADD     EBX,32
        JMP     @@lp
@@nx:   ADD     EDX,8
        JMP     DWORD PTR @@wV[EDX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
@@w07:  MOV     [EBX+EDX*4-28],ECX
        ADD     ECX,EAX
@@w06:  MOV     [EBX+EDX*4-24],ECX
        ADD     ECX,EAX
@@w05:  MOV     [EBX+EDX*4-20],ECX
        ADD     ECX,EAX
@@w04:  MOV     [EBX+EDX*4-16],ECX
        ADD     ECX,EAX
@@w03:  MOV     [EBX+EDX*4-12],ECX
        ADD     ECX,EAX
@@w02:  MOV     [EBX+EDX*4-8],ECX
        ADD     ECX,EAX
@@w01:  MOV     [EBX+EDX*4-4],ECX
@@w00:  POP     EBX
end;

procedure G_FillLongs(L: LongWord; P: Pointer; Count: Cardinal);
asm
        CMP     ECX,35
        JBE     @@xx
        MOV     [EDX],EAX
        MOV     [EDX+4],EAX
        TEST    EDX,4
        JE      @@nx1
        MOV     [EDX+8],EAX
        ADD     EDX,4
        DEC     ECX
@@nx1:  MOVQ    MM0,[EDX]
        SUB     ECX,2
        ADD     EDX,8
@@lp:   SUB     ECX,32
        JS      @@nx2
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM0
        MOVQ    [EDX+16],MM0
        MOVQ    [EDX+24],MM0
        MOVQ    [EDX+32],MM0
        MOVQ    [EDX+40],MM0
        MOVQ    [EDX+48],MM0
        MOVQ    [EDX+56],MM0
        MOVQ    [EDX+64],MM0
        MOVQ    [EDX+72],MM0
        MOVQ    [EDX+80],MM0
        MOVQ    [EDX+88],MM0
        MOVQ    [EDX+96],MM0
        MOVQ    [EDX+104],MM0
        MOVQ    [EDX+112],MM0
        MOVQ    [EDX+120],MM0
        ADD     EDX,128
        JMP     @@lp
@@nx2:  ADD     ECX,32
@@xx:   JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16, @@w17, @@w18, @@w19
        DD      @@w20, @@w21, @@w22, @@w23
        DD      @@w24, @@w25, @@w26, @@w27
        DD      @@w28, @@w29, @@w30, @@w31
        DD      @@w32, @@w33, @@w34, @@w35
@@w35:  MOV     [EDX+ECX*4-140],EAX
@@w34:  MOV     [EDX+ECX*4-136],EAX
@@w33:  MOV     [EDX+ECX*4-132],EAX
@@w32:  MOV     [EDX+ECX*4-128],EAX
@@w31:  MOV     [EDX+ECX*4-124],EAX
@@w30:  MOV     [EDX+ECX*4-120],EAX
@@w29:  MOV     [EDX+ECX*4-116],EAX
@@w28:  MOV     [EDX+ECX*4-112],EAX
@@w27:  MOV     [EDX+ECX*4-108],EAX
@@w26:  MOV     [EDX+ECX*4-104],EAX
@@w25:  MOV     [EDX+ECX*4-100],EAX
@@w24:  MOV     [EDX+ECX*4-96],EAX
@@w23:  MOV     [EDX+ECX*4-92],EAX
@@w22:  MOV     [EDX+ECX*4-88],EAX
@@w21:  MOV     [EDX+ECX*4-84],EAX
@@w20:  MOV     [EDX+ECX*4-80],EAX
@@w19:  MOV     [EDX+ECX*4-76],EAX
@@w18:  MOV     [EDX+ECX*4-72],EAX
@@w17:  MOV     [EDX+ECX*4-68],EAX
@@w16:  MOV     [EDX+ECX*4-64],EAX
@@w15:  MOV     [EDX+ECX*4-60],EAX
@@w14:  MOV     [EDX+ECX*4-56],EAX
@@w13:  MOV     [EDX+ECX*4-52],EAX
@@w12:  MOV     [EDX+ECX*4-48],EAX
@@w11:  MOV     [EDX+ECX*4-44],EAX
@@w10:  MOV     [EDX+ECX*4-40],EAX
@@w09:  MOV     [EDX+ECX*4-36],EAX
@@w08:  MOV     [EDX+ECX*4-32],EAX
@@w07:  MOV     [EDX+ECX*4-28],EAX
@@w06:  MOV     [EDX+ECX*4-24],EAX
@@w05:  MOV     [EDX+ECX*4-20],EAX
@@w04:  MOV     [EDX+ECX*4-16],EAX
@@w03:  MOV     [EDX+ECX*4-12],EAX
@@w02:  MOV     [EDX+ECX*4-8],EAX
@@w01:  MOV     [EDX+ECX*4-4],EAX
@@w00:  EMMS
end;

procedure G_CopyLongs(Source, Dest: Pointer; Count: Cardinal);
asm
@@lp:   SUB     ECX,16
        JS      @@nx
        MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EAX+32]
        MOVQ    MM5,[EAX+40]
        MOVQ    MM6,[EAX+48]
        MOVQ    MM7,[EAX+56]
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM1
        MOVQ    [EDX+16],MM2
        MOVQ    [EDX+24],MM3
        MOVQ    [EDX+32],MM4
        MOVQ    [EDX+40],MM5
        MOVQ    [EDX+48],MM6
        MOVQ    [EDX+56],MM7
        ADD     EAX,64
        ADD     EDX,64
        JMP     @@lp
@@nx:   ADD     ECX,16
        PUSH    EBX
        JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
@@w15:  MOV     EBX,[EAX+ECX*4-60]
        MOV     [EDX+ECX*4-60],EBX
@@w14:  MOV     EBX,[EAX+ECX*4-56]
        MOV     [EDX+ECX*4-56],EBX
@@w13:  MOV     EBX,[EAX+ECX*4-52]
        MOV     [EDX+ECX*4-52],EBX
@@w12:  MOV     EBX,[EAX+ECX*4-48]
        MOV     [EDX+ECX*4-48],EBX
@@w11:  MOV     EBX,[EAX+ECX*4-44]
        MOV     [EDX+ECX*4-44],EBX
@@w10:  MOV     EBX,[EAX+ECX*4-40]
        MOV     [EDX+ECX*4-40],EBX
@@w09:  MOV     EBX,[EAX+ECX*4-36]
        MOV     [EDX+ECX*4-36],EBX
@@w08:  MOV     EBX,[EAX+ECX*4-32]
        MOV     [EDX+ECX*4-32],EBX
@@w07:  MOV     EBX,[EAX+ECX*4-28]
        MOV     [EDX+ECX*4-28],EBX
@@w06:  MOV     EBX,[EAX+ECX*4-24]
        MOV     [EDX+ECX*4-24],EBX
@@w05:  MOV     EBX,[EAX+ECX*4-20]
        MOV     [EDX+ECX*4-20],EBX
@@w04:  MOV     EBX,[EAX+ECX*4-16]
        MOV     [EDX+ECX*4-16],EBX
@@w03:  MOV     EBX,[EAX+ECX*4-12]
        MOV     [EDX+ECX*4-12],EBX
@@w02:  MOV     EBX,[EAX+ECX*4-8]
        MOV     [EDX+ECX*4-8],EBX
@@w01:  MOV     EBX,[EAX+ECX*4-4]
        MOV     [EDX+ECX*4-4],EBX
@@w00:  POP     EBX
        EMMS
end;

procedure G_MoveLongs(Source, Dest: Pointer; Count: Cardinal);
asm
        CMP     EDX,EAX
        JA      @@bm
        JE      @@qt
        CALL    G_CopyLongs
@@qt:   RET
@@bm:   SHL     ECX,2
        ADD     EAX,ECX
        ADD     EDX,ECX
@@lp:   SUB     ECX,64
        JS      @@nx
        SUB     EAX,64
        SUB     EDX,64
        MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EAX+32]
        MOVQ    MM5,[EAX+40]
        MOVQ    MM6,[EAX+48]
        MOVQ    MM7,[EAX+56]
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM1
        MOVQ    [EDX+16],MM2
        MOVQ    [EDX+24],MM3
        MOVQ    [EDX+32],MM4
        MOVQ    [EDX+40],MM5
        MOVQ    [EDX+48],MM6
        MOVQ    [EDX+56],MM7
        JMP     @@lp
@@nx:   ADD     ECX,64
        SUB     EAX,ECX
        SUB     EDX,ECX
        JMP     DWORD PTR @@wV[ECX]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
@@w15:  MOV     ECX,[EAX+56]
        MOV     [EDX+56],ECX
@@w14:  MOV     ECX,[EAX+52]
        MOV     [EDX+52],ECX
@@w13:  MOV     ECX,[EAX+48]
        MOV     [EDX+48],ECX
@@w12:  MOV     ECX,[EAX+44]
        MOV     [EDX+44],ECX
@@w11:  MOV     ECX,[EAX+40]
        MOV     [EDX+40],ECX
@@w10:  MOV     ECX,[EAX+36]
        MOV     [EDX+36],ECX
@@w09:  MOV     ECX,[EAX+32]
        MOV     [EDX+32],ECX
@@w08:  MOV     ECX,[EAX+28]
        MOV     [EDX+28],ECX
@@w07:  MOV     ECX,[EAX+24]
        MOV     [EDX+24],ECX
@@w06:  MOV     ECX,[EAX+20]
        MOV     [EDX+20],ECX
@@w05:  MOV     ECX,[EAX+16]
        MOV     [EDX+16],ECX
@@w04:  MOV     ECX,[EAX+12]
        MOV     [EDX+12],ECX
@@w03:  MOV     ECX,[EAX+8]
        MOV     [EDX+8],ECX
@@w02:  MOV     ECX,[EAX+4]
        MOV     [EDX+4],ECX
@@w01:  MOV     ECX,[EAX]
        MOV     [EDX],ECX
@@w00:  EMMS
end;

procedure G_ReverseLongs(P: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        ADD     EAX,4
        LEA     EDI,[EAX+EDX*4-12]
@@lp:   CMP     EAX,EDI
        JGE     @@nx
        MOV     ECX,[EAX-4]
        MOV     EDX,[EDI+4]
        MOV     [EDI+4],ECX
        MOV     [EAX-4],EDX
        MOV     ECX,[EAX]
        MOV     EDX,[EDI]
        MOV     [EDI],ECX
        MOV     [EAX],EDX
        ADD     EAX,8
        SUB     EDI,8
        JMP     @@lp
@@nx:   SUB     EAX,4
        CMP     EAX,EDI
        JG      @@qt
        MOV     ECX,[EAX]
        MOV     EDX,[EDI+4]
        MOV     [EDI+4],ECX
        MOV     [EAX],EDX
@@qt:   POP     EDI
end;                 

function G_SameLongs(P1, P2: Pointer; Count: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@ex
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,ECX
        AND     ECX,$7
        SHR     ESI,3
        JE      @@nx
@@lp1:  MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq1
        MOV     EBX,[EAX+12]
        CMP     EBX,[EDX+12]
        JNE     @@zq1
        MOV     EBX,[EAX+16]
        CMP     EBX,[EDX+16]
        JNE     @@zq1
        MOV     EBX,[EAX+20]
        CMP     EBX,[EDX+20]
        JNE     @@zq1
        MOV     EBX,[EAX+24]
        CMP     EBX,[EDX+24]
        JNE     @@zq1
        MOV     EBX,[EAX+28]
        CMP     EBX,[EDX+28]
        JNE     @@zq1
        ADD     EAX,32
        ADD     EDX,32
        DEC     ESI
        JNE     @@lp1
@@nx:   JMP     DWORD PTR @@tV[ECX*4]
@@ex:   MOV     EAX,1
        RET
@@tV:   DD      @@tu0, @@tu1, @@tu2, @@tu3
        DD      @@tu4, @@tu5, @@tu6, @@tu7
@@zq1:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@tu7:  MOV     EBX,[EAX+ECX*4-28]
        CMP     EBX,[EDX+ECX*4-28]
        JNE     @@zq2
@@tu6:  MOV     EBX,[EAX+ECX*4-24]
        CMP     EBX,[EDX+ECX*4-24]
        JNE     @@zq2
@@tu5:  MOV     EBX,[EAX+ECX*4-20]
        CMP     EBX,[EDX+ECX*4-20]
        JNE     @@zq2
@@tu4:  MOV     EBX,[EAX+ECX*4-16]
        CMP     EBX,[EDX+ECX*4-16]
        JNE     @@zq2
@@tu3:  MOV     EBX,[EAX+ECX*4-12]
        CMP     EBX,[EDX+ECX*4-12]
        JNE     @@zq2
@@tu2:  MOV     EBX,[EAX+ECX*4-8]
        CMP     EBX,[EDX+ECX*4-8]
        JNE     @@zq2
@@tu1:  MOV     EBX,[EAX+ECX*4-4]
        CMP     EBX,[EDX+ECX*4-4]
        JNE     @@zq2
@@tu0:  POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq2:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
end;

procedure G_SwapLongs(P1, P2: Pointer; Count: Cardinal);
asm
@@lp:   SUB     ECX,8
        JS      @@nx
        MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EDX]
        MOVQ    MM5,[EDX+8]
        MOVQ    MM6,[EDX+16]
        MOVQ    MM7,[EDX+24]
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM1
        MOVQ    [EDX+16],MM2
        MOVQ    [EDX+24],MM3
        MOVQ    [EAX],MM4
        MOVQ    [EAX+8],MM5
        MOVQ    [EAX+16],MM6
        MOVQ    [EAX+24],MM7
        ADD     EAX,32
        ADD     EDX,32
        JMP     @@lp
@@nx:   ADD     ECX,8
        PUSH    EBX
        PUSH    ESI
        JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
@@w07:  MOV     EBX,[EAX+ECX*4-28]
        MOV     ESI,[EDX+ECX*4-28]
        MOV     [EDX+ECX*4-28],EBX
        MOV     [EAX+ECX*4-28],ESI
@@w06:  MOV     EBX,[EAX+ECX*4-24]
        MOV     ESI,[EDX+ECX*4-24]
        MOV     [EDX+ECX*4-24],EBX
        MOV     [EAX+ECX*4-24],ESI
@@w05:  MOV     EBX,[EAX+ECX*4-20]
        MOV     ESI,[EDX+ECX*4-20]
        MOV     [EDX+ECX*4-20],EBX
        MOV     [EAX+ECX*4-20],ESI
@@w04:  MOV     EBX,[EAX+ECX*4-16]
        MOV     ESI,[EDX+ECX*4-16]
        MOV     [EDX+ECX*4-16],EBX
        MOV     [EAX+ECX*4-16],ESI
@@w03:  MOV     EBX,[EAX+ECX*4-12]
        MOV     ESI,[EDX+ECX*4-12]
        MOV     [EDX+ECX*4-12],EBX
        MOV     [EAX+ECX*4-12],ESI
@@w02:  MOV     EBX,[EAX+ECX*4-8]
        MOV     ESI,[EDX+ECX*4-8]
        MOV     [EDX+ECX*4-8],EBX
        MOV     [EAX+ECX*4-8],ESI
@@w01:  MOV     EBX,[EAX+ECX*4-4]
        MOV     ESI,[EDX+ECX*4-4]
        MOV     [EDX+ECX*4-4],EBX
        MOV     [EAX+ECX*4-4],ESI
@@w00:  POP     ESI
        POP     EBX
        EMMS
end;

procedure G_NotLongs(P: Pointer; Count: Cardinal);
asm
        MOV     ECX,EDX
        AND     EDX,15
        SHR     ECX,4
        JE      @@nx
@@lp:   NOT     DWORD PTR [EAX]
        NOT     DWORD PTR [EAX+4]
        NOT     DWORD PTR [EAX+8]
        NOT     DWORD PTR [EAX+12]
        NOT     DWORD PTR [EAX+16]
        NOT     DWORD PTR [EAX+20]
        NOT     DWORD PTR [EAX+24]
        NOT     DWORD PTR [EAX+28]
        NOT     DWORD PTR [EAX+32]
        NOT     DWORD PTR [EAX+36]
        NOT     DWORD PTR [EAX+40]
        NOT     DWORD PTR [EAX+44]
        NOT     DWORD PTR [EAX+48]
        NOT     DWORD PTR [EAX+52]
        NOT     DWORD PTR [EAX+56]
        NOT     DWORD PTR [EAX+60]
        ADD     EAX,64
        DEC     ECX
        JNE     @@lp
@@nx:   JMP     DWORD PTR @@kV[EDX*4]
@@kV:   DD      @@ku00, @@ku01, @@ku02, @@ku03
        DD      @@ku04, @@ku05, @@ku06, @@ku07
        DD      @@ku08, @@ku09, @@ku10, @@ku11
        DD      @@ku12, @@ku13, @@ku14, @@ku15
@@ku15: NOT     DWORD PTR [EAX+EDX*4-60]
@@ku14: NOT     DWORD PTR [EAX+EDX*4-56]
@@ku13: NOT     DWORD PTR [EAX+EDX*4-52]
@@ku12: NOT     DWORD PTR [EAX+EDX*4-48]
@@ku11: NOT     DWORD PTR [EAX+EDX*4-44]
@@ku10: NOT     DWORD PTR [EAX+EDX*4-40]
@@ku09: NOT     DWORD PTR [EAX+EDX*4-36]
@@ku08: NOT     DWORD PTR [EAX+EDX*4-32]
@@ku07: NOT     DWORD PTR [EAX+EDX*4-28]
@@ku06: NOT     DWORD PTR [EAX+EDX*4-24]
@@ku05: NOT     DWORD PTR [EAX+EDX*4-20]
@@ku04: NOT     DWORD PTR [EAX+EDX*4-16]
@@ku03: NOT     DWORD PTR [EAX+EDX*4-12]
@@ku02: NOT     DWORD PTR [EAX+EDX*4-8]
@@ku01: NOT     DWORD PTR [EAX+EDX*4-4]
@@ku00:
end;

procedure G_AndLongs(Dest, Source: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        AND     ECX,15
        SHR     EBX,4
        JE      @@nx
@@lp:   MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EAX+32]
        MOVQ    MM5,[EAX+40]
        MOVQ    MM6,[EAX+48]
        MOVQ    MM7,[EAX+56]
        PAND    MM0,[EDX]
        MOVQ    [EAX],MM0
        PAND    MM1,[EDX+8]
        MOVQ    [EAX+8],MM1
        PAND    MM2,[EDX+16]
        MOVQ    [EAX+16],MM2
        PAND    MM3,[EDX+24]
        MOVQ    [EAX+24],MM3
        PAND    MM4,[EDX+32]
        MOVQ    [EAX+32],MM4
        PAND    MM5,[EDX+40]
        MOVQ    [EAX+40],MM5
        PAND    MM6,[EDX+48]
        MOVQ    [EAX+48],MM6
        PAND    MM7,[EDX+56]
        MOVQ    [EAX+56],MM7
        ADD     EDX,64
        ADD     EAX,64
        DEC     EBX
        JNE     @@lp
        EMMS
@@nx:   JMP     DWORD PTR @@kV[ECX*4]
@@kV:   DD      @@ku00, @@ku01, @@ku02, @@ku03
        DD      @@ku04, @@ku05, @@ku06, @@ku07
        DD      @@ku08, @@ku09, @@ku10, @@ku11
        DD      @@ku12, @@ku13, @@ku14, @@ku15
@@ku15: MOV     ESI,[EDX+ECX*4-60]
        AND     [EAX+ECX*4-60],ESI
@@ku14: MOV     ESI,[EDX+ECX*4-56]
        AND     [EAX+ECX*4-56],ESI
@@ku13: MOV     ESI,[EDX+ECX*4-52]
        AND     [EAX+ECX*4-52],ESI
@@ku12: MOV     ESI,[EDX+ECX*4-48]
        AND     [EAX+ECX*4-48],ESI
@@ku11: MOV     ESI,[EDX+ECX*4-44]
        AND     [EAX+ECX*4-44],ESI
@@ku10: MOV     ESI,[EDX+ECX*4-40]
        AND     [EAX+ECX*4-40],ESI
@@ku09: MOV     ESI,[EDX+ECX*4-36]
        AND     [EAX+ECX*4-36],ESI
@@ku08: MOV     ESI,[EDX+ECX*4-32]
        AND     [EAX+ECX*4-32],ESI
@@ku07: MOV     ESI,[EDX+ECX*4-28]
        AND     [EAX+ECX*4-28],ESI
@@ku06: MOV     ESI,[EDX+ECX*4-24]
        AND     [EAX+ECX*4-24],ESI
@@ku05: MOV     ESI,[EDX+ECX*4-20]
        AND     [EAX+ECX*4-20],ESI
@@ku04: MOV     ESI,[EDX+ECX*4-16]
        AND     [EAX+ECX*4-16],ESI
@@ku03: MOV     ESI,[EDX+ECX*4-12]
        AND     [EAX+ECX*4-12],ESI
@@ku02: MOV     ESI,[EDX+ECX*4-8]
        AND     [EAX+ECX*4-8],ESI
@@ku01: MOV     ESI,[EDX+ECX*4-4]
        AND     [EAX+ECX*4-4],ESI
@@ku00: POP     ESI
        POP     EBX
end;

procedure G_OrLongs(Dest, Source: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        AND     ECX,15
        SHR     EBX,4
        JE      @@nx
@@lp:   MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EAX+32]
        MOVQ    MM5,[EAX+40]
        MOVQ    MM6,[EAX+48]
        MOVQ    MM7,[EAX+56]
        POR     MM0,[EDX]
        MOVQ    [EAX],MM0
        POR     MM1,[EDX+8]
        MOVQ    [EAX+8],MM1
        POR     MM2,[EDX+16]
        MOVQ    [EAX+16],MM2
        POR     MM3,[EDX+24]
        MOVQ    [EAX+24],MM3
        POR     MM4,[EDX+32]
        MOVQ    [EAX+32],MM4
        POR     MM5,[EDX+40]
        MOVQ    [EAX+40],MM5
        POR     MM6,[EDX+48]
        MOVQ    [EAX+48],MM6
        POR     MM7,[EDX+56]
        MOVQ    [EAX+56],MM7
        ADD     EDX,64
        ADD     EAX,64
        DEC     EBX
        JNE     @@lp
        EMMS
@@nx:   JMP     DWORD PTR @@kV[ECX*4]
@@kV:   DD      @@ku00, @@ku01, @@ku02, @@ku03
        DD      @@ku04, @@ku05, @@ku06, @@ku07
        DD      @@ku08, @@ku09, @@ku10, @@ku11
        DD      @@ku12, @@ku13, @@ku14, @@ku15
@@ku15: MOV     ESI,[EDX+ECX*4-60]
        OR      [EAX+ECX*4-60],ESI
@@ku14: MOV     ESI,[EDX+ECX*4-56]
        OR      [EAX+ECX*4-56],ESI
@@ku13: MOV     ESI,[EDX+ECX*4-52]
        OR      [EAX+ECX*4-52],ESI
@@ku12: MOV     ESI,[EDX+ECX*4-48]
        OR      [EAX+ECX*4-48],ESI
@@ku11: MOV     ESI,[EDX+ECX*4-44]
        OR      [EAX+ECX*4-44],ESI
@@ku10: MOV     ESI,[EDX+ECX*4-40]
        OR      [EAX+ECX*4-40],ESI
@@ku09: MOV     ESI,[EDX+ECX*4-36]
        OR      [EAX+ECX*4-36],ESI
@@ku08: MOV     ESI,[EDX+ECX*4-32]
        OR      [EAX+ECX*4-32],ESI
@@ku07: MOV     ESI,[EDX+ECX*4-28]
        OR      [EAX+ECX*4-28],ESI
@@ku06: MOV     ESI,[EDX+ECX*4-24]
        OR      [EAX+ECX*4-24],ESI
@@ku05: MOV     ESI,[EDX+ECX*4-20]
        OR      [EAX+ECX*4-20],ESI
@@ku04: MOV     ESI,[EDX+ECX*4-16]
        OR      [EAX+ECX*4-16],ESI
@@ku03: MOV     ESI,[EDX+ECX*4-12]
        OR      [EAX+ECX*4-12],ESI
@@ku02: MOV     ESI,[EDX+ECX*4-8]
        OR      [EAX+ECX*4-8],ESI
@@ku01: MOV     ESI,[EDX+ECX*4-4]
        OR      [EAX+ECX*4-4],ESI
@@ku00: POP     ESI
        POP     EBX
end;

procedure G_XorLongs(Dest, Source: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        AND     ECX,15
        SHR     EBX,4
        JE      @@nx
@@lp:   MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    MM4,[EAX+32]
        MOVQ    MM5,[EAX+40]
        MOVQ    MM6,[EAX+48]
        MOVQ    MM7,[EAX+56]
        PXOR    MM0,[EDX]
        MOVQ    [EAX],MM0
        PXOR    MM1,[EDX+8]
        MOVQ    [EAX+8],MM1
        PXOR    MM2,[EDX+16]
        MOVQ    [EAX+16],MM2
        PXOR    MM3,[EDX+24]
        MOVQ    [EAX+24],MM3
        PXOR    MM4,[EDX+32]
        MOVQ    [EAX+32],MM4
        PXOR    MM5,[EDX+40]
        MOVQ    [EAX+40],MM5
        PXOR    MM6,[EDX+48]
        MOVQ    [EAX+48],MM6
        PXOR    MM7,[EDX+56]
        MOVQ    [EAX+56],MM7
        ADD     EDX,64
        ADD     EAX,64
        DEC     EBX
        JNE     @@lp
        EMMS
@@nx:   JMP     DWORD PTR @@kV[ECX*4]
@@kV:   DD      @@ku00, @@ku01, @@ku02, @@ku03
        DD      @@ku04, @@ku05, @@ku06, @@ku07
        DD      @@ku08, @@ku09, @@ku10, @@ku11
        DD      @@ku12, @@ku13, @@ku14, @@ku15
@@ku15: MOV     ESI,[EDX+ECX*4-60]
        XOR     [EAX+ECX*4-60],ESI
@@ku14: MOV     ESI,[EDX+ECX*4-56]
        XOR     [EAX+ECX*4-56],ESI
@@ku13: MOV     ESI,[EDX+ECX*4-52]
        XOR     [EAX+ECX*4-52],ESI
@@ku12: MOV     ESI,[EDX+ECX*4-48]
        XOR     [EAX+ECX*4-48],ESI
@@ku11: MOV     ESI,[EDX+ECX*4-44]
        XOR     [EAX+ECX*4-44],ESI
@@ku10: MOV     ESI,[EDX+ECX*4-40]
        XOR     [EAX+ECX*4-40],ESI
@@ku09: MOV     ESI,[EDX+ECX*4-36]
        XOR     [EAX+ECX*4-36],ESI
@@ku08: MOV     ESI,[EDX+ECX*4-32]
        XOR     [EAX+ECX*4-32],ESI
@@ku07: MOV     ESI,[EDX+ECX*4-28]
        XOR     [EAX+ECX*4-28],ESI
@@ku06: MOV     ESI,[EDX+ECX*4-24]
        XOR     [EAX+ECX*4-24],ESI
@@ku05: MOV     ESI,[EDX+ECX*4-20]
        XOR     [EAX+ECX*4-20],ESI
@@ku04: MOV     ESI,[EDX+ECX*4-16]
        XOR     [EAX+ECX*4-16],ESI
@@ku03: MOV     ESI,[EDX+ECX*4-12]
        XOR     [EAX+ECX*4-12],ESI
@@ku02: MOV     ESI,[EDX+ECX*4-8]
        XOR     [EAX+ECX*4-8],ESI
@@ku01: MOV     ESI,[EDX+ECX*4-4]
        XOR     [EAX+ECX*4-4],ESI
@@ku00: POP     ESI
        POP     EBX
end;

procedure G_AndNotLongs(Dest, Source: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        AND     ECX,15
        SHR     EBX,4
        JE      @@nx
@@lp:   MOVQ    MM0,[EDX]
        MOVQ    MM1,[EDX+8]
        MOVQ    MM2,[EDX+16]
        MOVQ    MM3,[EDX+24]
        MOVQ    MM4,[EDX+32]
        MOVQ    MM5,[EDX+40]
        MOVQ    MM6,[EDX+48]
        MOVQ    MM7,[EDX+56]
        PANDN   MM0,[EAX]
        MOVQ    [EAX],MM0
        PANDN   MM1,[EAX+8]
        MOVQ    [EAX+8],MM1
        PANDN   MM2,[EAX+16]
        MOVQ    [EAX+16],MM2
        PANDN   MM3,[EAX+24]
        MOVQ    [EAX+24],MM3
        PANDN   MM4,[EAX+32]
        MOVQ    [EAX+32],MM4
        PANDN   MM5,[EAX+40]
        MOVQ    [EAX+40],MM5
        PANDN   MM6,[EAX+48]
        MOVQ    [EAX+48],MM6
        PANDN   MM7,[EAX+56]
        MOVQ    [EAX+56],MM7
        ADD     EDX,64
        ADD     EAX,64
        DEC     EBX
        JNE     @@lp
        EMMS
@@nx:   JMP     DWORD PTR @@kV[ECX*4]
@@kV:   DD      @@ku00, @@ku01, @@ku02, @@ku03
        DD      @@ku04, @@ku05, @@ku06, @@ku07
        DD      @@ku08, @@ku09, @@ku10, @@ku11
        DD      @@ku12, @@ku13, @@ku14, @@ku15
@@ku15: MOV     ESI,[EDX+ECX*4-60]
        NOT     ESI
        AND     [EAX+ECX*4-60],ESI
@@ku14: MOV     ESI,[EDX+ECX*4-56]
        NOT     ESI
        AND     [EAX+ECX*4-56],ESI
@@ku13: MOV     ESI,[EDX+ECX*4-52]
        NOT     ESI
        AND     [EAX+ECX*4-52],ESI
@@ku12: MOV     ESI,[EDX+ECX*4-48]
        NOT     ESI
        AND     [EAX+ECX*4-48],ESI
@@ku11: MOV     ESI,[EDX+ECX*4-44]
        NOT     ESI
        AND     [EAX+ECX*4-44],ESI
@@ku10: MOV     ESI,[EDX+ECX*4-40]
        NOT     ESI
        AND     [EAX+ECX*4-40],ESI
@@ku09: MOV     ESI,[EDX+ECX*4-36]
        NOT     ESI
        AND     [EAX+ECX*4-36],ESI
@@ku08: MOV     ESI,[EDX+ECX*4-32]
        NOT     ESI
        AND     [EAX+ECX*4-32],ESI
@@ku07: MOV     ESI,[EDX+ECX*4-28]
        NOT     ESI
        AND     [EAX+ECX*4-28],ESI
@@ku06: MOV     ESI,[EDX+ECX*4-24]
        NOT     ESI
        AND     [EAX+ECX*4-24],ESI
@@ku05: MOV     ESI,[EDX+ECX*4-20]
        NOT     ESI
        AND     [EAX+ECX*4-20],ESI
@@ku04: MOV     ESI,[EDX+ECX*4-16]
        NOT     ESI
        AND     [EAX+ECX*4-16],ESI
@@ku03: MOV     ESI,[EDX+ECX*4-12]
        NOT     ESI
        AND     [EAX+ECX*4-12],ESI
@@ku02: MOV     ESI,[EDX+ECX*4-8]
        NOT     ESI
        AND     [EAX+ECX*4-8],ESI
@@ku01: MOV     ESI,[EDX+ECX*4-4]
        NOT     ESI
        AND     [EAX+ECX*4-4],ESI
@@ku00: POP     ESI
        POP     EBX
end;

{ Функции для работы с массивами значений типа Byte и Word }

procedure G_FillWords(W: Word; P: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        TEST    ECX,ECX
        JE      @@qt
        MOV     EBX,EAX
        TEST    EDX,2
        JE      @@nx1
        MOV     WORD PTR [EDX],AX
        INC     EDX
        DEC     ECX
        INC     EDX
@@nx1:  SHL     EBX,16
        TEST    ECX,1
        JE      @@nx2
        DEC     ECX
        MOV     WORD PTR [EDX+ECX*2],AX
@@nx2:  OR      EAX,EBX
        SHR     ECX,1
        CALL    G_FillLongs
@@qt:   POP     EBX
end;

procedure G_CopyWords(Source, Dest: Pointer; Count: Cardinal);
asm
        SHL     ECX,1
        PUSH    EBX
        NOP
@@lp:   SUB     ECX,16
        JS      @@nx
        MOVZX   EBX,WORD PTR [EAX]
        MOV     [EDX],BX
        MOVZX   EBX,WORD PTR [EAX+2]
        MOV     [EDX+2],BX
        MOVZX   EBX,WORD PTR [EAX+4]
        MOV     [EDX+4],BX
        MOVZX   EBX,WORD PTR [EAX+6]
        MOV     [EDX+6],BX
        MOVZX   EBX,WORD PTR [EAX+8]
        MOV     [EDX+8],BX
        MOVZX   EBX,WORD PTR [EAX+10]
        MOV     [EDX+10],BX
        MOVZX   EBX,WORD PTR [EAX+12]
        MOV     [EDX+12],BX
        MOVZX   EBX,WORD PTR [EAX+14]
        MOV     [EDX+14],BX
        ADD     EAX,16
        ADD     EDX,16
        JMP     @@lp
        NOP
@@nx:   ADD     EAX,ECX
        ADD     EDX,ECX
        ADD     ECX,16
        JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w00, @@w01, @@w00
        DD      @@w02, @@w00, @@w03, @@w00
        DD      @@w04, @@w00, @@w05, @@w00
        DD      @@w06, @@w00, @@w07, @@w00
@@w07:  MOVZX   EBX,WORD PTR [EAX+2]
        MOV     [EDX+2],BX
@@w06:  MOVZX   EBX,WORD PTR [EAX+4]
        MOV     [EDX+4],BX
@@w05:  MOVZX   EBX,WORD PTR [EAX+6]
        MOV     [EDX+6],BX
@@w04:  MOVZX   EBX,WORD PTR [EAX+8]
        MOV     [EDX+8],BX
@@w03:  MOVZX   EBX,WORD PTR [EAX+10]
        MOV     [EDX+10],BX
@@w02:  MOVZX   EBX,WORD PTR [EAX+12]
        MOV     [EDX+12],BX
@@w01:  MOVZX   EBX,WORD PTR [EAX+14]
        MOV     [EDX+14],BX
@@w00:  POP     EBX
end;

procedure G_MoveWords(Source, Dest: Pointer; Count: Cardinal);
asm
        CMP     EDX,EAX
        JA      @@bm
        JE      @@qt
        XCHG    ESI,EAX
        XCHG    EDI,EDX
        REP     MOVSW
        MOV     ESI,EAX
        MOV     EDI,EDX
        RET
@@bm:   PUSH    ESI
        PUSH    EDI
        STD
        LEA     ESI,[EAX+ECX*2-2]
        LEA     EDI,[EDX+ECX*2-2]
        REP     MOVSW
        CLD
        POP     EDI
        POP     ESI
@@qt:
end;

procedure G_ReverseWords(P: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        LEA     EDI,[EAX+EDX*2-2]
@@lp:   CMP     EAX,EDI
        JGE     @@qt
        MOV     CX,WORD PTR [EAX]
        MOV     DX,WORD PTR [EDI]
        MOV     WORD PTR [EDI],CX
        MOV     WORD PTR [EAX],DX
        ADD     EAX,2
        SUB     EDI,2
        JMP     @@lp
@@qt:   POP     EDI
end;

procedure G_CopyBytes(Source, Dest: Pointer; L: Cardinal);
asm
        PUSH    EBX
        JMP     @@uu
        DB      $90,$90,$90,$90,$90
@@lp:   MOVZX   EBX,BYTE PTR [EAX]
        MOV     [EDX],BL
        MOVZX   EBX,BYTE PTR [EAX+1]
        MOV     [EDX+1],BL
        MOVZX   EBX,BYTE PTR [EAX+2]
        MOV     [EDX+2],BL
        MOVZX   EBX,BYTE PTR [EAX+3]
        MOV     [EDX+3],BL
        MOVZX   EBX,BYTE PTR [EAX+4]
        MOV     [EDX+4],BL
        MOVZX   EBX,BYTE PTR [EAX+5]
        MOV     [EDX+5],BL
        MOVZX   EBX,BYTE PTR [EAX+6]
        MOV     [EDX+6],BL
        MOVZX   EBX,BYTE PTR [EAX+7]
        MOV     [EDX+7],BL
        MOVZX   EBX,BYTE PTR [EAX+8]
        MOV     [EDX+8],BL
        MOVZX   EBX,BYTE PTR [EAX+9]
        MOV     [EDX+9],BL
        MOVZX   EBX,BYTE PTR [EAX+10]
        MOV     [EDX+10],BL
        MOVZX   EBX,BYTE PTR [EAX+11]
        MOV     [EDX+11],BL
        MOVZX   EBX,BYTE PTR [EAX+12]
        MOV     [EDX+12],BL
        MOVZX   EBX,BYTE PTR [EAX+13]
        MOV     [EDX+13],BL
        MOVZX   EBX,BYTE PTR [EAX+14]
        MOV     [EDX+14],BL
        MOVZX   EBX,BYTE PTR [EAX+15]
        MOV     [EDX+15],BL
        ADD     EAX,16
        ADD     EDX,16
@@uu:   SUB     ECX,16
        JNS     @@lp
        ADD     EAX,ECX
        ADD     EDX,ECX
        ADD     ECX,16
        JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
@@w15:  MOVZX   EBX,BYTE PTR [EAX+1]
        MOV     [EDX+1],BL
@@w14:  MOVZX   EBX,BYTE PTR [EAX+2]
        MOV     [EDX+2],BL
@@w13:  MOVZX   EBX,BYTE PTR [EAX+3]
        MOV     [EDX+3],BL
@@w12:  MOVZX   EBX,BYTE PTR [EAX+4]
        MOV     [EDX+4],BL
@@w11:  MOVZX   EBX,BYTE PTR [EAX+5]
        MOV     [EDX+5],BL
@@w10:  MOVZX   EBX,BYTE PTR [EAX+6]
        MOV     [EDX+6],BL
@@w09:  MOVZX   EBX,BYTE PTR [EAX+7]
        MOV     [EDX+7],BL
@@w08:  MOVZX   EBX,BYTE PTR [EAX+8]
        MOV     [EDX+8],BL
@@w07:  MOVZX   EBX,BYTE PTR [EAX+9]
        MOV     [EDX+9],BL
@@w06:  MOVZX   EBX,BYTE PTR [EAX+10]
        MOV     [EDX+10],BL
@@w05:  MOVZX   EBX,BYTE PTR [EAX+11]
        MOV     [EDX+11],BL
@@w04:  MOVZX   EBX,BYTE PTR [EAX+12]
        MOV     [EDX+12],BL
@@w03:  MOVZX   EBX,BYTE PTR [EAX+13]
        MOV     [EDX+13],BL
@@w02:  MOVZX   EBX,BYTE PTR [EAX+14]
        MOV     [EDX+14],BL
@@w01:  MOVZX   EBX,BYTE PTR [EAX+15]
        MOV     [EDX+15],BL
@@w00:  POP     EBX
end;

procedure G_MoveBytes(Source, Dest: Pointer; L: Cardinal);
asm
        CMP     EDX,EAX
        JA      @@bm
        JE      @@qt
        XCHG    ESI,EAX
        XCHG    EDI,EDX
        REP     MOVSB
        MOV     ESI,EAX
        MOV     EDI,EDX
        RET
@@bm:   PUSH    ESI
        PUSH    EDI
        STD
        LEA     ESI,[EAX+ECX-1]
        LEA     EDI,[EDX+ECX-1]
        REP     MOVSB
        CLD
        POP     EDI
        POP     ESI
@@qt:
end;

procedure G_ReverseBytes(P: Pointer; L: Cardinal);
asm
        LEA     ECX,[EAX+EDX-1]
@@lp:   CMP     EAX,ECX
        JGE     @@qt
        MOV     DH,BYTE PTR [EAX]
        MOV     DL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],DH
        MOV     BYTE PTR [EAX],DL
        INC     EAX
        DEC     ECX
        JMP     @@lp
@@qt:
end;

{ Поиск, замена, подсчет, удаление значений в массиве одинарных и двойных слов }

function G_Scan_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_Scan_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_Scan_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_Scan_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASW
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,1
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanBackward_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        LEA     EDI,[EDX+ECX*4-4]
        STD
        REPNE   SCASD
        JNE     @@m2
        CLD
        LEA     EAX,[EDI+4]
        POP     EDI
        SUB     EAX,EDX
        SHR     EAX,2
        RET
@@m2:   POP     EDI
        CLD
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanBackward_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        LEA     EDI,[EDX+ECX*4-4]
        STD
        REPNE   SCASD
        JNE     @@m2
        CLD
        LEA     EAX,[EDI+4]
        POP     EDI
        SUB     EAX,EDX
        SHR     EAX,2
        RET
@@m2:   POP     EDI
        CLD
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanBackward_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        LEA     EDI,[EDX+ECX*4-4]
        STD
        REPNE   SCASD
        JNE     @@m2
        CLD
        LEA     EAX,[EDI+4]
        POP     EDI
        SUB     EAX,EDX
        SHR     EAX,2
        RET
@@m2:   POP     EDI
        CLD
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanBackward_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        LEA     EDI,[EDX+ECX*2-2]
        STD
        REPNE   SCASW
        JNE     @@m2
        CLD
        LEA     EAX,[EDI+2]
        POP     EDI
        SUB     EAX,EDX
        SHR     EAX,1
        RET
@@m2:   POP     EDI
        CLD
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanOther_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPE    SCASD
        JE      @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanOther_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPE    SCASD
        JE      @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanOther_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPE    SCASD
        JE      @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_ScanOther_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPE    SCASW
        JE      @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,1
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;

function G_Replace_Integer(OldN, NewN: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        MOV     ECX,[ESP+16]
        XOR     ESI,ESI
@@lp:   TEST    ECX,ECX
        JE      @@qt
        REPNE   SCASD
        JNE     @@qt
        MOV     [EDI-4],EDX
        INC     ESI
        JMP     @@lp
@@qt:   MOV     EAX,ESI
        POP     ESI
        POP     EDI
end;

function G_Replace_LongWord(OldL, NewL: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        MOV     ECX,[ESP+16]
        XOR     ESI,ESI
@@lp:   TEST    ECX,ECX
        JE      @@qt
        REPNE   SCASD
        JNE     @@qt
        MOV     [EDI-4],EDX
        INC     ESI
        JMP     @@lp
@@qt:   MOV     EAX,ESI
        POP     ESI
        POP     EDI
end;

function G_Replace_Pointer(OldP, NewP: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        MOV     ECX,[ESP+16]
        XOR     ESI,ESI
@@lp:   TEST    ECX,ECX
        JE      @@qt
        REPNE   SCASD
        JNE     @@qt
        MOV     [EDI-4],EDX
        INC     ESI
        JMP     @@lp
@@qt:   MOV     EAX,ESI
        POP     ESI
        POP     EDI
end;

function G_Replace_Word(OldN, NewN: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        MOV     ECX,[ESP+16]
        XOR     ESI,ESI
@@lp:   TEST    ECX,ECX
        JE      @@qt
        REPNE   SCASW
        JNE     @@qt
        MOV     WORD PTR [EDI-2],DX
        INC     ESI
        JMP     @@lp
@@qt:   MOV     EAX,ESI
        POP     ESI
        POP     EDI
end;

function G_CountOf_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if PIntegerItemList(ArrPtr)^[I] = N then
      Inc(Result);
end;

function G_CountOf_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
begin
  Result := G_CountOf_Integer(L, ArrPtr, Count);
end;

function G_CountOf_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
begin
  Result := G_CountOf_Integer(Integer(P), ArrPtr, Count);
end;

function G_CountOf_Word(N: Word; ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if PWordItemList(ArrPtr)^[I] = N then
      Inc(Result);
end;

function G_CountOfUnique_LongWord(ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    Inc(Result);
    for I := 0 to Count - 2 do
      if PLongWordItemList(ArrPtr)^[I] <> PLongWordItemList(ArrPtr)^[I + 1] then
        Inc(Result);
  end;
end;

function G_CountOfUnique_Word(ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    Inc(Result);
    for I := 0 to Count - 2 do
      if PWordItemList(ArrPtr)^[I] <> PWordItemList(ArrPtr)^[I + 1] then
        Inc(Result);
  end;
end;

function G_Remove_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := G_Scan_Integer(N, ArrPtr, Count);
  if Result < 0 then
  begin
    Result := Count;
    Exit;
  end;
  for I := Result + 1 to Count - 1 do
    if PIntegerItemList(ArrPtr)^[I] <> N then
    begin
      PIntegerItemList(ArrPtr)^[Result] := PIntegerItemList(ArrPtr)^[I];
      Inc(Result);
    end;
end;

function G_Remove_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
begin
  Result := G_Remove_Integer(L, ArrPtr, Count);
end;

function G_Remove_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Integer;
begin
  Result := G_Remove_Integer(Integer(P), ArrPtr, Count);
end;

function G_Remove_Word(N: Word; ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := G_Scan_Word(N, ArrPtr, Count);
  if Result < 0 then
  begin
    Result := Count;
    Exit;
  end;
  for I := Result + 1 to Count - 1 do
    if PWordItemList(ArrPtr)^[I] <> N then
    begin
      PWordItemList(ArrPtr)^[Result] := PWordItemList(ArrPtr)^[I];
      Inc(Result);
    end;
end;

function G_Unique_LongWord(ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    Result := Count;
    for I := 0 to Count - 2 do
      if PLongWordItemList(ArrPtr)^[I] = PLongWordItemList(ArrPtr)^[I + 1] then
      begin
        Result := I + 1;
        Break;
      end;
    for I := Result + 1 to Count - 1 do
      if PLongWordItemList(ArrPtr)^[I] <> PLongWordItemList(ArrPtr)^[I - 1] then
      begin
        PLongWordItemList(ArrPtr)^[Result] := PLongWordItemList(ArrPtr)^[I];
        Inc(Result);
      end;
  end;
end;

function G_Unique_Word(ArrPtr: Pointer; Count: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    Result := Count;
    for I := 0 to Count - 2 do
      if PWordItemList(ArrPtr)^[I] = PWordItemList(ArrPtr)^[I + 1] then
      begin
        Result := I + 1;
        Break;
      end;
    for I := Result + 1 to Count - 1 do
      if PWordItemList(ArrPtr)^[I] <> PWordItemList(ArrPtr)^[I - 1] then
      begin
        PWordItemList(ArrPtr)^[Result] := PWordItemList(ArrPtr)^[I];
        Inc(Result);
      end;
  end;
end;

{ Работа с отсортированными массивами одинарных и двойных слов }

procedure IntSortIntegers(ArrPtr: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        MOV     EDI,EDX
        PUSH    EBX
@@lp0:  LEA     ECX,[EAX+EDI]
        SHR     ECX,1
        AND     ECX,$FFFFFFFC
        MOV     EBX,EAX
        MOV     ESI,[ECX]
        MOV     EDX,EDI
@@lp1:  CMP     ESI,[EBX]
        JNG     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNG     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNG     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNG     @@lp2
        ADD     EBX,4
        JMP     @@lp1
@@lp2:  CMP     ESI,[EDX]
        JNL     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNL     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNL     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNL     @@nxA
        SUB     EDX,4
        JMP     @@lp2
@@nxA:  CMP     EBX,EDX
        JG      @@nxB
        MOV     ECX,[EBX]
        MOV     EBP,[EDX]
        MOV     [EDX],ECX
        MOV     [EBX],EBP
        ADD     EBX,4
        SUB     EDX,4
        CMP     EBX,EDX
        JNG     @@lp1
@@nxB:  CMP     EAX,EDX
        JNL     @@nxC
        CALL    IntSortIntegers
@@nxC:  MOV     EAX,EBX
        CMP     EBX,EDI
        JL      @@lp0
        POP     EBX
        POP     EDI
end;

procedure G_Sort_Integer(ArrPtr: Pointer; Count: Cardinal);
asm
        TEST    EDX,$FFFFFFFE
        JE      @@qt
        PUSH    EBP
        PUSH    ESI
        LEA     EDX,[EAX+EDX*4-4]
        CALL    IntSortIntegers
        POP     ESI
        POP     EBP
@@qt:
end;

procedure IntSortLongWords(ArrPtr: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        MOV     EDI,EDX
        PUSH    EBX
@@lp0:  LEA     ECX,[EAX+EDI]
        SHR     ECX,1
        AND     ECX,$FFFFFFFC
        MOV     EBX,EAX
        MOV     ESI,[ECX]
        MOV     EDX,EDI
@@lp1:  CMP     ESI,[EBX]
        JNA     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNA     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNA     @@lp2
        ADD     EBX,4
        CMP     ESI,[EBX]
        JNA     @@lp2
        ADD     EBX,4
        JMP     @@lp1
@@lp2:  CMP     ESI,[EDX]
        JNB     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNB     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNB     @@nxA
        SUB     EDX,4
        CMP     ESI,[EDX]
        JNB     @@nxA
        SUB     EDX,4
        JMP     @@lp2
@@nxA:  CMP     EBX,EDX
        JG      @@nxB
        MOV     ECX,[EBX]
        MOV     EBP,[EDX]
        MOV     [EDX],ECX
        MOV     [EBX],EBP
        ADD     EBX,4
        SUB     EDX,4
        CMP     EBX,EDX
        JNG     @@lp1
@@nxB:  CMP     EAX,EDX
        JNL     @@nxC
        CALL    IntSortLongWords
@@nxC:  MOV     EAX,EBX
        CMP     EBX,EDI
        JL      @@lp0
        POP     EBX
        POP     EDI
end;

procedure G_Sort_LongWord(ArrPtr: Pointer; Count: Cardinal);
asm
        TEST    EDX,$FFFFFFFE
        JE      @@qt
        PUSH    EBP
        PUSH    ESI
        LEA     EDX,[EAX+EDX*4-4]
        CALL    IntSortLongWords
        POP     ESI
        POP     EBP
@@qt:
end;

procedure IntSortWords(ArrPtr: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        MOV     EDI,EDX
        PUSH    EBX
@@lp0:  LEA     ECX,[EAX+EDI]
        SHR     ECX,1
        AND     ECX,$FFFFFFFE
        MOV     EBX,EAX
        MOV     SI,[ECX]
        MOV     EDX,EDI
@@lp1:  CMP     SI,[EBX]
        JNA     @@lp2
        ADD     EBX,2
        CMP     SI,[EBX]
        JNA     @@lp2
        ADD     EBX,2
        CMP     SI,[EBX]
        JNA     @@lp2
        ADD     EBX,2
        CMP     SI,[EBX]
        JNA     @@lp2
        ADD     EBX,2
        JMP     @@lp1
@@lp2:  CMP     SI,[EDX]
        JNB     @@nxA
        SUB     EDX,2
        CMP     SI,[EDX]
        JNB     @@nxA
        SUB     EDX,2
        CMP     SI,[EDX]
        JNB     @@nxA
        SUB     EDX,2
        CMP     SI,[EDX]
        JNB     @@nxA
        SUB     EDX,2
        JMP     @@lp2
@@nxA:  CMP     EBX,EDX
        JG      @@nxB
        MOV     CX,[EBX]
        MOV     BP,[EDX]
        MOV     [EDX],CX
        MOV     [EBX],BP
        ADD     EBX,2
        SUB     EDX,2
        CMP     EBX,EDX
        JNG     @@lp1
@@nxB:  CMP     EAX,EDX
        JNL     @@nxC
        CALL    IntSortWords
@@nxC:  MOV     EAX,EBX
        CMP     EBX,EDI
        JL      @@lp0
        POP     EBX
        POP     EDI
end;

procedure G_Sort_Word(ArrPtr: Pointer; Count: Cardinal);
asm
        TEST    EDX,$FFFFFFFE
        JE      @@qt
        PUSH    EBP
        PUSH    ESI
        LEA     EDX,[EAX+EDX*2-2]
        CALL    IntSortWords
        POP     ESI
        POP     EBP
@@qt:
end;

function G_BinarySearch_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        DEC     ECX
        JS      @@zq
        PUSH    ESI
        PUSH    EBX
        XOR     ESI,ESI
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     EAX,[EDX+EBX*4]
        JL      @@mm
        JE      @@qt
        LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
        JMP     @@nx
@@mm:   LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
@@nx:   POP     EBX
        POP     ESI
@@zq:   MOV     EAX,$FFFFFFFF
        RET
@@qt:   MOV     EAX,EBX
        POP     EBX
        POP     ESI
end;

function G_BinarySearch_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        DEC     ECX
        JS      @@zq
        PUSH    ESI
        PUSH    EBX
        XOR     ESI,ESI
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     EAX,[EDX+EBX*4]
        JB      @@mm
        JE      @@qt
        LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
        JMP     @@nx
@@mm:   LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
@@nx:   POP     EBX
        POP     ESI
@@zq:   MOV     EAX,$FFFFFFFF
        RET
@@qt:   MOV     EAX,EBX
        POP     EBX
        POP     ESI
end;

function G_BinarySearch_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        DEC     ECX
        JS      @@zq
        PUSH    ESI
        PUSH    EBX
        XOR     ESI,ESI
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     AX,[EDX+EBX*2]
        JB      @@mm
        JE      @@qt
        LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
        JMP     @@nx
@@mm:   LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
@@nx:   POP     EBX
        POP     ESI
@@zq:   MOV     EAX,$FFFFFFFF
        RET
@@qt:   MOV     EAX,EBX
        POP     EBX
        POP     ESI
end;

function G_SearchFirstGE_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        XOR     ESI,ESI
        PUSH    EBX
        DEC     ECX
        JS      @@qt
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     EAX,[EDX+EBX*4]
        JG      @@aa
        MOV     EDI,EBX
        LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
        JMP     @@qt
@@aa:   LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
@@qt:   POP     EBX
        MOV     EAX,EDI
        POP     ESI
        POP     EDI
end;

function G_SearchFirstGE_LongWord(L: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        XOR     ESI,ESI
        PUSH    EBX
        DEC     ECX
        JS      @@qt
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     EAX,[EDX+EBX*4]
        JA      @@aa
        MOV     EDI,EBX
        LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
        JMP     @@qt
@@aa:   LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
@@qt:   POP     EBX
        MOV     EAX,EDI
        POP     ESI
        POP     EDI
end;

function G_SearchFirstGE_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        XOR     ESI,ESI
        PUSH    EBX
        DEC     ECX
        JS      @@qt
@@lp:   LEA     EBX,[ECX+ESI]
        SHR     EBX,1
        CMP     AX,[EDX+EBX*2]
        JA      @@aa
        MOV     EDI,EBX
        LEA     ECX,[EBX-1]
        CMP     ESI,ECX
        JLE     @@lp
        JMP     @@qt
@@aa:   LEA     ESI,[EBX+1]
        CMP     ECX,ESI
        JGE     @@lp
@@qt:   POP     EBX
        MOV     EAX,EDI
        POP     ESI
        POP     EDI
end;

function G_SetContainedIn_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
@@lp:   DEC     EDX
        JS      @@eq
        DEC     EBX
        JS      @@zq
        MOV     ESI,[EAX]
        MOV     EDI,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EDI
        JL      @@zq
        JG      @@aa
        JMP     @@lp
@@aa:   DEC     EBX
        JS      @@zq
        MOV     EDI,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@eq:   MOV     EAX,1
        JMP     @@qt
@@zq:   XOR     EAX,EAX
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetContainedIn_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
@@lp:   DEC     EDX
        JS      @@eq
        DEC     EBX
        JS      @@zq
        MOV     ESI,[EAX]
        MOV     EDI,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EDI
        JB      @@zq
        JA      @@aa
        JMP     @@lp
@@aa:   DEC     EBX
        JS      @@zq
        MOV     EDI,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@eq:   MOV     EAX,1
        JMP     @@qt
@@zq:   XOR     EAX,EAX
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetContainedIn_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
@@lp:   DEC     EDX
        JS      @@eq
        DEC     EBX
        JS      @@zq
        MOV     SI,[EAX]
        MOV     DI,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,DI
        JB      @@zq
        JA      @@aa
        JMP     @@lp
@@aa:   DEC     EBX
        JS      @@zq
        MOV     DI,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@eq:   MOV     EAX,1
        JMP     @@qt
@@zq:   XOR     EAX,EAX
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetIntersectsWith_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
        DEC     EDX
        JS      @@zq
        DEC     EBX
        JS      @@zq
        MOV     ESI,[EAX]
        MOV     EDI,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EDI
        JG      @@bb
        JZ      @@eq
        DEC     EDX
        JS      @@zq
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bb:   DEC     EBX
        JS      @@zq
        MOV     EDI,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@zq:   XOR     EAX,EAX
        JMP     @@qt
@@eq:   MOV     EAX,1
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetIntersectsWith_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
        DEC     EDX
        JS      @@zq
        DEC     EBX
        JS      @@zq
        MOV     ESI,[EAX]
        MOV     EDI,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EDI
        JA      @@bb
        JE      @@eq
        DEC     EDX
        JS      @@zq
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bb:   DEC     EBX
        JS      @@zq
        MOV     EDI,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@zq:   XOR     EAX,EAX
        JMP     @@qt
@@eq:   MOV     EAX,1
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetIntersectsWith_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal): Boolean;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,[ESP+20]
        DEC     EDX
        JS      @@zq
        DEC     EBX
        JS      @@zq
        MOV     SI,[EAX]
        MOV     DI,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,DI
        JA      @@bb
        JE      @@eq
        DEC     EDX
        JS      @@zq
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx
@@bb:   DEC     EBX
        JS      @@zq
        MOV     DI,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@zq:   XOR     EAX,EAX
        JMP     @@qt
@@eq:   MOV     EAX,1
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetUnion_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JL      @@bb
        JG      @@aa
        MOV     [EDI],ESI
        ADD     EDI,4
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@bx
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bx:   MOV     [EDI],EBP
        ADD     EDI,4
@@mm:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@bx
@@aa:   MOV     [EDI],EBP
        ADD     EDI,4
        DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JL      @@bb1
        JG      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetUnion_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JB      @@bb
        JA      @@aa
        MOV     [EDI],ESI
        ADD     EDI,4
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@bx
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bx:   MOV     [EDI],EBP
        ADD     EDI,4
@@mm:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@bx
@@aa:   MOV     [EDI],EBP
        ADD     EDI,4
        DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JB      @@bb1
        JA      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetUnion_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,BP
        JB      @@bb
        JA      @@aa
        MOV     [EDI],SI
        ADD     EDI,2
        JMP     @@lp
@@bb:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@bx
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx
@@bx:   MOV     [EDI],BP
        ADD     EDI,2
@@mm:   DEC     EBX
        JS      @@qt
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@bx
@@aa:   MOV     [EDI],BP
        ADD     EDI,2
        DEC     EBX
        JS      @@ax
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@ax:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@qt
@@nn:   MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,1
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx1:  CMP     SI,BP
        JB      @@bb1
        JA      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetIntersection_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@qt
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JL      @@bb
        JG      @@aa
        MOV     [EDI],ESI
        ADD     EDI,4
        JMP     @@lp
@@bb:   DEC     EDX
        JS      @@qt
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@qt1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JL      @@bb1
        JG      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  DEC     EDX
        JS      @@qt1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@qt1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@qt1:  MOV     EAX,EDI
        POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetIntersection_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@qt
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JB      @@bb
        JA      @@aa
        MOV     [EDI],ESI
        ADD     EDI,4
        JMP     @@lp
@@bb:   DEC     EDX
        JS      @@qt
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@qt1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JB      @@bb1
        JA      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  DEC     EDX
        JS      @@qt1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@qt1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@qt1:  MOV     EAX,EDI
        POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetIntersection_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@qt
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,BP
        JB      @@bb
        JA      @@aa
        MOV     [EDI],SI
        ADD     EDI,2
        JMP     @@lp
@@bb:   DEC     EDX
        JS      @@qt
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@qt
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,1
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@qt1
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx1:  CMP     SI,BP
        JB      @@bb1
        JA      @@aa1
        INC     EDI
        JMP     @@lp1
@@bb1:  DEC     EDX
        JS      @@qt1
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@qt1
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx1
@@qt1:  MOV     EAX,EDI
        POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetDifference_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JL      @@bb
        JG      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JL      @@bb1
        JG      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@qt1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetDifference_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JB      @@bb
        JA      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JB      @@bb1
        JA      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@qt1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetDifference_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@qt
        DEC     EBX
        JS      @@nn
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,BP
        JB      @@bb
        JA      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@qt
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx
@@aa:   DEC     EBX
        JS      @@ax
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@ax:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@qt
@@nn:   MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,1
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@qt1
        DEC     EBX
        JS      @@ax1
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx1:  CMP     SI,BP
        JB      @@bb1
        JA      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@qt1
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx1
@@aa1:  DEC     EBX
        JS      @@ax1
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetSymmetricDifference_Integer(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JL      @@bb
        JG      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@bx
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bx:   MOV     [EDI],EBP
        ADD     EDI,4
@@mm:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@bx
@@aa:   MOV     [EDI],EBP
        ADD     EDI,4
        DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JL      @@bb1
        JG      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetSymmetricDifference_LongWord(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx:   CMP     ESI,EBP
        JB      @@bb
        JA      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@bx
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx
@@bx:   MOV     [EDI],EBP
        ADD     EDI,4
@@mm:   DEC     EBX
        JS      @@qt
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@bx
@@aa:   MOV     [EDI],EBP
        ADD     EDI,4
        DEC     EBX
        JS      @@ax
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx
@@ax:   MOV     [EDI],ESI
        ADD     EDI,4
        DEC     EDX
        JS      @@qt
@@nn:   MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,2
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     ESI,[EAX]
        MOV     EBP,[ECX]
        ADD     EAX,4
        ADD     ECX,4
@@nx1:  CMP     ESI,EBP
        JB      @@bb1
        JA      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     ESI,[EAX]
        ADD     EAX,4
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     EBP,[ECX]
        ADD     ECX,4
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

function G_SetSymmetricDifference_Word(P1: Pointer; Count1: Cardinal;
  P2: Pointer; Count2: Cardinal; OutPlace: Pointer): Cardinal;
asm
        PUSH    ESI
        PUSH    EBX
        PUSH    EDI
        PUSH    EBP
        MOV     EDI,[ESP+24]
        MOV     EBX,[ESP+28]
        TEST    EDI,EDI
        JE      @@lp1
@@lp:   DEC     EDX
        JS      @@mm
        DEC     EBX
        JS      @@nn
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx:   CMP     SI,BP
        JB      @@bb
        JA      @@aa
        JMP     @@lp
@@bb:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@bx
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx
@@bx:   MOV     [EDI],BP
        ADD     EDI,2
@@mm:   DEC     EBX
        JS      @@qt
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@bx
@@aa:   MOV     [EDI],BP
        ADD     EDI,2
        DEC     EBX
        JS      @@ax
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx
@@ax:   MOV     [EDI],SI
        ADD     EDI,2
        DEC     EDX
        JS      @@qt
@@nn:   MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@ax
@@qt:   SUB     EDI,[ESP+24]
        SHR     EDI,1
        JMP     @@qt1
@@lp1:  DEC     EDX
        JS      @@bx1
        DEC     EBX
        JS      @@ax1
        MOV     SI,[EAX]
        MOV     BP,[ECX]
        ADD     EAX,2
        ADD     ECX,2
@@nx1:  CMP     SI,BP
        JB      @@bb1
        JA      @@aa1
        JMP     @@lp1
@@bb1:  INC     EDI
        DEC     EDX
        JS      @@bx1
        MOV     SI,[EAX]
        ADD     EAX,2
        JMP     @@nx1
@@bx1:  LEA     EAX,[EDI+EBX+1]
        JMP     @@qte
@@aa1:  INC     EDI
        DEC     EBX
        JS      @@ax1
        MOV     BP,[ECX]
        ADD     ECX,2
        JMP     @@nx1
@@ax1:  LEA     EAX,[EDI+EDX+1]
        JMP     @@qte
@@qt1:  MOV     EAX,EDI
@@qte:  POP     EBP
        POP     EDI
        POP     EBX
        POP     ESI
end;

{ Функции для работы с битами в составе двойного слова }

const
  ReverseBitsTable: array[0..255] of Byte =
    ($00,$80,$40,$C0,$20,$A0,$60,$E0,$10,$90,$50,$D0,$30,$B0,$70,$F0,
     $08,$88,$48,$C8,$28,$A8,$68,$E8,$18,$98,$58,$D8,$38,$B8,$78,$F8,
     $04,$84,$44,$C4,$24,$A4,$64,$E4,$14,$94,$54,$D4,$34,$B4,$74,$F4,
     $0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC,$1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC,
     $02,$82,$42,$C2,$22,$A2,$62,$E2,$12,$92,$52,$D2,$32,$B2,$72,$F2,
     $0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA,$1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA,
     $06,$86,$46,$C6,$26,$A6,$66,$E6,$16,$96,$56,$D6,$36,$B6,$76,$F6,
     $0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE,$1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE,
     $01,$81,$41,$C1,$21,$A1,$61,$E1,$11,$91,$51,$D1,$31,$B1,$71,$F1,
     $09,$89,$49,$C9,$29,$A9,$69,$E9,$19,$99,$59,$D9,$39,$B9,$79,$F9,
     $05,$85,$45,$C5,$25,$A5,$65,$E5,$15,$95,$55,$D5,$35,$B5,$75,$F5,
     $0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED,$1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD,
     $03,$83,$43,$C3,$23,$A3,$63,$E3,$13,$93,$53,$D3,$33,$B3,$73,$F3,
     $0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB,$1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB,
     $07,$87,$47,$C7,$27,$A7,$67,$E7,$17,$97,$57,$D7,$37,$B7,$77,$F7,
     $0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF,$1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF);

function G_ReverseBits(L: LongWord; BitCount: Integer): LongWord;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOVZX   ECX,AL
        MOVZX   ESI,AH
        XOR     EAX,EAX
        MOV     AH,BYTE PTR [ECX+ReverseBitsTable]
        SHR     EBX,16
        MOV     AL,BYTE PTR [ESI+ReverseBitsTable]
        SHL     EAX,16
        MOVZX   ECX,BL
        MOVZX   ESI,BH
        XOR     EBX,EBX
        MOV     BH,BYTE PTR [ECX+ReverseBitsTable]
        MOV     BL,BYTE PTR [ESI+ReverseBitsTable]
        MOV     ECX,32
        OR      EAX,EBX
        SUB     ECX,EDX
        SHR     EAX,CL
        POP     ESI
        POP     EBX
end;

function G_BitTest32(L: LongWord; Index: Cardinal): Boolean;
asm
        MOV     CL,DL
        SHR     EAX,CL
        AND     EAX,1
end;

function G_BitSet32(L: LongWord; Index: Cardinal): LongWord;
asm
        OR      EAX,DWORD PTR [EDX*4+BitMasks32]
end;

function G_BitReset32(L: LongWord; Index: Cardinal): LongWord;
asm
        MOV     ECX,DWORD PTR [EDX*4+BitMasks32]
        NOT     ECX
        AND     EAX,ECX
end;

function G_BitToggle32(L: LongWord; Index: Cardinal): LongWord;
asm
        XOR     EAX,DWORD PTR [EDX*4+BitMasks32]
end;

function G_SetBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;
asm
        PUSH    EBX
        MOV     EBX,ECX
        MOV     ECX,31
        SUB     ECX,EBX
        MOV     EBX,$FFFFFFFF
        SHR     EBX,CL
        MOV     ECX,EDX
        MOV     EDX,EBX
        SHL     EBX,CL
        AND     EDX,EBX
        OR      EAX,EDX
        POP     EBX
end;

function G_ResetBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;
asm
        PUSH    EBX
        MOV     EBX,ECX
        MOV     ECX,31
        SUB     ECX,EBX
        MOV     EBX,$FFFFFFFF
        SHR     EBX,CL
        MOV     ECX,EDX
        MOV     EDX,EBX
        SHL     EBX,CL
        AND     EDX,EBX
        NOT     EDX
        AND     EAX,EDX
        POP     EBX
end;

function G_ToggleBits32(L: LongWord; FirstBit, LastBit: Integer): LongWord;
asm
        PUSH    EBX
        MOV     EBX,ECX
        MOV     ECX,31
        SUB     ECX,EBX
        MOV     EBX,$FFFFFFFF
        SHR     EBX,CL
        MOV     ECX,EDX
        MOV     EDX,EBX
        SHL     EBX,CL
        AND     EDX,EBX
        XOR     EAX,EDX
        POP     EBX
end;

const
  BitCountTable: array[0..255] of Byte =
    (0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,
     1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,
     1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,
     2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,
     1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,
     2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,
     2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,
     3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,4,5,5,6,5,6,6,7,5,6,6,7,6,7,7,8);

function G_CountOfSetBits32(L: LongWord): Cardinal;
asm
        PUSH    EBX
        MOVZX   EDX,AL
        MOVZX   ECX,AH
        SHR     EAX,16
        MOVZX   EBX,AH
        AND     EAX,$FF
        MOVZX   EAX,BYTE PTR [EAX+BitCountTable]
        ADD     AL,BYTE PTR [EBX+BitCountTable]
        ADD     AL,BYTE PTR [ECX+BitCountTable]
        ADD     AL,BYTE PTR [EDX+BitCountTable]
        POP     EBX
end;

function G_CountOfSetBits32(L: LongWord; FirstBit, LastBit: Integer): Cardinal;
asm
        PUSH    EBX
        MOV     EBX,ECX
        MOV     ECX,31
        SUB     ECX,EBX
        MOV     EBX,$FFFFFFFF
        SHR     EBX,CL
        AND     EAX,EBX
        MOV     ECX,EDX
        SHL     EBX,CL
        AND     EAX,EBX
        MOVZX   EDX,AL
        MOVZX   ECX,AH
        SHR     EAX,16
        MOVZX   EBX,AH
        AND     EAX,$FF
        MOVZX   EAX,BYTE PTR [EAX+BitCountTable]
        ADD     AL,BYTE PTR [EBX+BitCountTable]
        ADD     AL,BYTE PTR [ECX+BitCountTable]
        ADD     AL,BYTE PTR [EDX+BitCountTable]
        POP     EBX
end;

function G_CountOfFreeBits32(L: LongWord): Cardinal;
asm
        PUSH    EBX
        MOVZX   EDX,AL
        MOVZX   ECX,AH
        SHR     EAX,16
        MOVZX   EBX,AH
        AND     EAX,$FF
        MOV     BL,BYTE PTR [EBX+BitCountTable]
        ADD     BL,BYTE PTR [EAX+BitCountTable]
        MOV     EAX,32
        ADD     BL,BYTE PTR [ECX+BitCountTable]
        ADD     BL,BYTE PTR [EDX+BitCountTable]
        SUB     AL,BL
        POP     EBX
end;

function G_CountOfFreeBits32(L: LongWord; FirstBit, LastBit: Integer): Cardinal;
asm
        PUSH    EBX
        MOV     EBX,ECX
        SUB     ECX,EDX
        INC     ECX
        PUSH    ECX
        MOV     ECX,31
        SUB     ECX,EBX
        MOV     EBX,$FFFFFFFF
        SHR     EBX,CL
        AND     EAX,EBX
        MOV     ECX,EDX
        SHL     EBX,CL
        AND     EAX,EBX
        MOVZX   EDX,AL
        MOVZX   ECX,AH
        SHR     EAX,16
        MOVZX   EBX,AH
        AND     EAX,$FF
        MOV     BL,BYTE PTR [EBX+BitCountTable]
        ADD     BL,BYTE PTR [EAX+BitCountTable]
        POP     EAX
        ADD     BL,BYTE PTR [ECX+BitCountTable]
        ADD     BL,BYTE PTR [EDX+BitCountTable]
        SUB     AL,BL
        POP     EBX
end;

function G_SetBitScanForward32(L: LongWord; FirstBit: Integer): Integer;
asm
        MOV     ECX,EDX
        MOV     EDX,$FFFFFFFF
        SHL     EDX,CL
        AND     EDX,EAX
        JE      @@zq
        BSF     EAX,EDX
        RET
@@zq:   MOV     EAX,$FFFFFFFF
end;

function G_FreeBitScanForward32(L: LongWord; FirstBit: Integer): Integer;
asm
        MOV     ECX,EDX
        MOV     EDX,$FFFFFFFF
        NOT     EAX
        SHL     EDX,CL
        AND     EDX,EAX
        JE      @@zq
        BSF     EAX,EDX
        RET
@@zq:   MOV     EAX,$FFFFFFFF
end;

function G_SetBitScanBackward32(L: LongWord; LastBit: Integer): Integer;
asm
        LEA     ECX,[EDX-31]
        MOV     EDX,$FFFFFFFF
        NEG     ECX
        SHR     EDX,CL
        AND     EDX,EAX
        JE      @@zq
        BSR     EAX,EDX
        RET
@@zq:   MOV     EAX,$FFFFFFFF
end;

function G_FreeBitScanBackward32(L: LongWord; LastBit: Integer): Integer;
asm
        LEA     ECX,[EDX-31]
        MOV     EDX,$FFFFFFFF
        NEG     ECX
        NOT     EAX
        SHR     EDX,CL
        AND     EDX,EAX
        JE      @@zq
        BSR     EAX,EDX
        RET
@@zq:   MOV     EAX,$FFFFFFFF
end;

{ Функции для работы с битовой строкой }

function G_BitTest(P: Pointer; Index: Integer): Boolean;
asm
        BT      [EAX],EDX
        SETC    AL
end;

function G_BitSet(P: Pointer; Index: Integer): Boolean;
asm
        BTS     [EAX],EDX
        SETC    AL
end;

function G_BitReset(P: Pointer; Index: Integer): Boolean;
asm
        BTR     [EAX],EDX
        SETC    AL
end;

function G_BitToggle(P: Pointer; Index: Integer): Boolean;
asm
        BTC     [EAX],EDX
        SETC    AL
end;

procedure G_SetBits(P: Pointer; FirstBit, LastBit: Integer);
asm
        CMP     ECX,EDX
        JL      @@qt
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        SUB     ESI,EDX
        JE      @@xx
        OR      [EAX+EDX*4],EBX
        INC     EDX
        DEC     ESI
        JE      @@ne
        MOV     EBX,$FFFFFFFF
@@lp:   MOV     [EAX+EDX*4],EBX
        INC     EDX
        DEC     ESI
        JNE     @@lp
@@xx:   AND     EDI,EBX
@@ne:   OR      [EAX+EDX*4],EDI
        POP     EDI
        POP     ESI
        POP     EBX
@@qt:
end;

procedure G_ResetBits(P: Pointer; FirstBit, LastBit: Integer);
asm
        CMP     ECX,EDX
        JL      @@qt
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        NOT     EDI
        NOT     EBX
        SUB     ESI,EDX
        JE      @@xx
        AND     [EAX+EDX*4],EBX
        INC     EDX
        DEC     ESI
        JE      @@ne
        XOR     EBX,EBX
@@lp:   MOV     [EAX+EDX*4],EBX
        INC     EDX
        DEC     ESI
        JNE     @@lp
@@xx:   OR      EDI,EBX
@@ne:   AND     [EAX+EDX*4],EDI
        POP     EDI
        POP     ESI
        POP     EBX
@@qt:
end;

procedure G_ToggleBits(P: Pointer; FirstBit, LastBit: Integer);
asm
        CMP     ECX,EDX
        JL      @@qt
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        SUB     ESI,EDX
        JE      @@xx
        XOR     [EAX+EDX*4],EBX
        INC     EDX
        DEC     ESI
        JE      @@ne
        MOV     EBX,$FFFFFFFF
@@lp:   NOT     DWORD PTR [EAX+EDX*4]
        INC     EDX
        DEC     ESI
        JNE     @@lp
@@xx:   AND     EDI,EBX
@@ne:   XOR     [EAX+EDX*4],EDI
        POP     EDI
        POP     ESI
        POP     EBX
@@qt:
end;

function G_CountOfSetBits(P: Pointer; FirstBit, LastBit: Integer): Cardinal;
var
  N1, N2: Integer;
begin
  N1 := FirstBit shr 5;
  N2 := LastBit shr 5;
  FirstBit := FirstBit and $1F;
  LastBit := LastBit and $1F;
  if N1 < N2 then
  begin
    Result := G_CountOfSetBits32(PLongWordItemList(P)^[N1], FirstBit, 31);
    Inc(N1);
    while N1 < N2 do
    begin
      Result := Result + G_CountOfSetBits32(PLongWordItemList(P)^[N1]);
      Inc(N1);
    end;
    Result := Result + G_CountOfSetBits32(PLongWordItemList(P)^[N1], 0, LastBit);
  end
  else if N1 = N2 then
    Result := G_CountOfSetBits32(PLongWordItemList(P)^[N1], FirstBit, LastBit)
  else
    Result := 0;
end;

function G_CountOfFreeBits(P: Pointer; FirstBit, LastBit: Integer): Cardinal;
var
  N1, N2: Integer;
begin
  N1 := FirstBit shr 5;
  N2 := LastBit shr 5;
  FirstBit := FirstBit and $1F;
  LastBit := LastBit and $1F;
  if N1 < N2 then
  begin
    Result := G_CountOfFreeBits32(PLongWordItemList(P)^[N1], FirstBit, 31);
    Inc(N1);
    while N1 < N2 do
    begin
      Result := Result + G_CountOfFreeBits32(PLongWordItemList(P)^[N1]);
      Inc(N1);
    end;
    Result := Result + G_CountOfFreeBits32(PLongWordItemList(P)^[N1], 0, LastBit);
  end
  else if N1 = N2 then
    Result := G_CountOfFreeBits32(PLongWordItemList(P)^[N1], FirstBit, LastBit)
  else
    Result := 0;
end;

function G_SetBitScanForward(P: Pointer; FirstBit, LastBit: Integer): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        LEA     ESI,[EDX+8]
        CMP     ECX,ESI
        JL      @@ut
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        AND     EBX,[EAX+EDX*4]
        SUB     ESI,EDX
        JE      @@nq
        TEST    EBX,EBX
        JNE     @@ne
        INC     EDX
        DEC     ESI
        JE      @@xx
@@lp:   OR      EBX,[EAX+EDX*4]
        JNE     @@ne
        INC     EDX
        DEC     ESI
        JNE     @@lp
@@xx:   MOV     EBX,[EAX+EDX*4]
@@nq:   AND     EBX,EDI
        JE      @@zq
@@ne:   BSF     ECX,EBX
@@qt:   SHL     EDX,5
        LEA     EAX,[ECX+EDX]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@ut:   SUB     ECX,EDX
        JS      @@zq
@@uk:   BT      [EAX],EDX
        JC      @@iq
        INC     EDX
        DEC     ECX
        JNS     @@uk
@@zq:   MOV     EAX,$FFFFFFFF
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@iq:   MOV     EAX,EDX
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_FreeBitScanForward(P: Pointer; FirstBit, LastBit: Integer): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        LEA     ESI,[EDX+8]
        CMP     ECX,ESI
        JL      @@ut
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        MOV     ECX,[EAX+EDX*4]
        NOT     ECX
        AND     EBX,ECX
        SUB     ESI,EDX
        JE      @@nq
        TEST    EBX,EBX
        JNE     @@ne
        INC     EDX
        DEC     ESI
        JE      @@xx
@@lp:   MOV     EBX,[EAX+EDX*4]
        NOT     EBX
        TEST    EBX,EBX
        JNE     @@ne
        INC     EDX
        DEC     ESI
        JNE     @@lp
@@xx:   MOV     EBX,[EAX+EDX*4]
        NOT     EBX
@@nq:   AND     EBX,EDI
        JE      @@zq
@@ne:   BSF     ECX,EBX
@@qt:   SHL     EDX,5
        LEA     EAX,[ECX+EDX]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@ut:   SUB     ECX,EDX
        JS      @@zq
@@uk:   BT      [EAX],EDX
        JNC     @@iq
        INC     EDX
        DEC     ECX
        JNS     @@uk
@@zq:   MOV     EAX,$FFFFFFFF
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@iq:   MOV     EAX,EDX
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_SetBitScanBackward(P: Pointer; FirstBit, LastBit: Integer): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        LEA     ESI,[EDX+8]
        CMP     ECX,ESI
        JL      @@ut
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        AND     EDI,[EAX+ESI*4]
        SUB     EDX,ESI
        JE      @@nq
        TEST    EDI,EDI
        JNE     @@ne
        NEG     EDX
        DEC     ESI
        DEC     EDX
        JE      @@xx
@@lp:   OR      EDI,[EAX+ESI*4]
        JNE     @@ne
        DEC     ESI
        DEC     EDX
        JNE     @@lp
@@xx:   MOV     EDI,[EAX+ESI*4]
@@nq:   AND     EDI,EBX
        JE      @@zq
@@ne:   BSR     ECX,EDI
@@qt:   SHL     ESI,5
        LEA     EAX,[ECX+ESI]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@ut:   SUB     EDX,ECX
        JG      @@zq
@@uk:   BT      [EAX],ECX
        JC      @@iq
        DEC     ECX
        INC     EDX
        JNG     @@uk
@@zq:   MOV     EAX,$FFFFFFFF
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@iq:   MOV     EAX,ECX
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_FreeBitScanBackward(P: Pointer; FirstBit, LastBit: Integer): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        LEA     ESI,[EDX+8]
        CMP     ECX,ESI
        JL      @@ut
        MOV     EBX,$FFFFFFFF
        MOV     ESI,ECX
        MOV     EDI,$0000001F
        AND     ECX,EDI
        AND     ESI,$FFFFFFE0
        SUB     EDI,ECX
        SHR     ESI,5
        MOV     ECX,EDI
        MOV     EDI,EBX
        SHR     EDI,CL
        MOV     ECX,EDX
        AND     EDX,$FFFFFFE0
        AND     ECX,$0000001F
        SHR     EDX,5
        SHL     EBX,CL
        MOV     ECX,[EAX+ESI*4]
        NOT     ECX
        AND     EDI,ECX
        SUB     EDX,ESI
        JE      @@nq
        TEST    EDI,EDI
        JNE     @@ne
        NEG     EDX
        DEC     ESI
        DEC     EDX
        JE      @@xx
@@lp:   MOV     EDI,[EAX+ESI*4]
        NOT     EDI
        TEST    EDI,EDI
        JNE     @@ne
        DEC     ESI
        DEC     EDX
        JNE     @@lp
@@xx:   MOV     EDI,[EAX+ESI*4]
        NOT     EDI
@@nq:   AND     EDI,EBX
        JE      @@zq
@@ne:   BSR     ECX,EDI
@@qt:   SHL     ESI,5
        LEA     EAX,[ECX+ESI]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@ut:   SUB     EDX,ECX
        JG      @@zq
@@uk:   BT      [EAX],ECX
        JNC     @@iq
        DEC     ECX
        INC     EDX
        JNG     @@uk
@@zq:   MOV     EAX,$FFFFFFFF
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@iq:   MOV     EAX,ECX
        POP     EDI
        POP     ESI
        POP     EBX
end;

end.

