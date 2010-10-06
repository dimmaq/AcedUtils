
///////////////////////////////////////////////////////////
//                                                       //
//   AcedAlgorithm 1.16                                  //
//                                                       //
//   Функции линейного и бинарного поиска, сортировки,   //
//   слияния, переупорядочивания элементов списка и      //
//   другие функции для работы со списком элементов,     //
//   представленным в виде массива указателей.           //
//                                                       //
//   mailto: acedutils@yandex.ru                         //
//                                                       //
///////////////////////////////////////////////////////////

unit AcedAlgorithm;

{$B-,H+,R-,Q-,T-,X+}

interface

uses Registry, AcedBinary, AcedConsts, AcedCrypto;

{ Прототип функции, используемой для сопоставления значения элементу списка.
  Функция должна сравнить значение, ссылка на которое передается параметром
  Value, с соответствующим значением, полученным для элемента Item списка.
  Если Value меньше, чем значение, рассчитанное для элемента Item, функция
  должна вернуть отрицательное число. Если Value больше, чем значение,
  рассчитанное для элемента Item, функция возвращает положительное число.
  Если Value равно значению, рассчитанному для элемента Item, функция должна
  вернуть ноль. }

type
  TMatchFunction = function (Value, Item: Pointer): Integer;

{ Прототип функции, используемой при сортировке и группировании элементов
  списка. Функция должна сравнить элементы Item1 и Item2 и вернуть значение
  меньше нуля, если первый элемент меньше второго, значение больше нуля,
  если первый элемент больше второго, и ноль, если элементы равны. }

  TCompareFunction = function (Item1, Item2: Pointer): Integer;


{ Функции для поиска, замены, подсчета и удаления элементов массива указателей }

{ G_Search выполняет линейный поиск значения Value в массиве указателей
  ItemList, состоящем из Count элементов. Функция для сопоставления значения
  элементу массива передается параметром MatchFunction. Функция G_Search
  возвращает индекс найденного элемента или -1, если значение не найдено. }

function G_Search(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer;

{ G_SearchBackward выполняет линейный поиск значения Value в массиве
  указателей ItemList, состоящем из Count элементов. Поиск начинается с
  последних элементов массива. Функция для сопоставления значения элементу
  массива передается параметром MatchFunction. Функция G_SearchBackward
  возвращает индекс найденного элемента или -1, если значение не найдено. }

function G_SearchBackward(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_Replace заменяет все элементы, равные значению Value, в массиве указателей,
  адрес которого передан параметром ItemList, элементом NewP. Count - число
  элементов в массиве ItemList. MatchFunction - функция для сопоставления
  значения элементу массива. G_Replace возвращает число, равное количеству
  произведенных замен. }

function G_Replace(Value, NewP: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_CountOf возвращает число элементов, равных Value, в массиве указателей
  ItemList, состоящем из Count элементов. Функция для сопоставления значения
  элементу массива передается параметром MatchFunction. }

function G_CountOf(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer;

{ G_CountOfUnique возвращает число уникальных элементов в массиве указателей
  ItemList, состоящем из Count элементов. При этом несколько равных смежных
  элементов считаются за один. Функция для сравнения двух элементов массива
  передается параметром CompareFunction. }

function G_CountOfUnique(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Integer;

{ G_RemoveCopy копирует все элементы, кроме тех, которые равны Value, из
  массива указателей ItemList, состоящего из Count элементов, в массив,
  адресуемый параметром OutList. Функция возвращает количество элементов,
  помещенное в выходной массив. Функция для сопоставления значения элементу
  массива передается параметром MatchFunction. Если передать в OutList
  указатель на исходный массив ItemList, операция выполнится на месте. }

function G_RemoveCopy(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction; OutList: PPointerItemList): Integer;

{ G_UniqueCopy копирует все элементы, исключая повторяющиеся смежные элементы,
  из массива указателей ItemList, состоящего из Count элементов, в массив,
  адресуемый параметром OutList. Функция возвращает количество элементов,
  помещенное в выходной массив. В параметре CompareFunction передается функция
  для сравнения двух элементов массива. Если передать в OutList указатель на
  исходный массив ItemList, операция выполнится на месте. }

function G_UniqueCopy(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; OutList: PPointerItemList): Integer;


{ Функции для поиска минимального и максимального элементов массива }

{ Следующая функция G_SearchMin возвращает первый минимальный элемент
  в массиве указателей ItemList. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. }

function G_SearchMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer; overload;

{ Следующая функция G_SearchMin возвращает первый минимальный элемент
  в массиве указателей ItemList. В параметре N возвращается число элементов
  массива, равных минимальному элементу. Count - общее число элементов
  в массиве. CompareFunction - функция для сравнения двух элементов массива. }

function G_SearchMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out N: Integer): Pointer; overload;

{ G_IndexOfMin возвращает индекс первого минимального элемента в массиве
  указателей ItemList. Если в параметре LastIndex передан указатель на
  переменную типа Integer, в ней сохраняется индекс последнего минимального
  элемента в массиве ItemList. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. }

function G_IndexOfMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; LastIndex: PInteger = nil): Integer;

{ Следующая функция G_SearchMax возвращает первый максимальный элемент
  в массиве указателей ItemList. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. }

function G_SearchMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer; overload;

{ Следующая функция G_SearchMax возвращает первый максимальный элемент
  в массиве указателей ItemList. В параметре N возвращается число элементов
  массива, равных максимальному элементу. Count - общее число элементов
  в массиве. CompareFunction - функция для сравнения двух элементов массива. }

function G_SearchMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out N: Integer): Pointer; overload;

{ G_IndexOfMax возвращает индекс первого максимального элемента в массиве
  указателей ItemList. Если в параметре LastIndex передан указатель на
  переменную типа Integer, в ней сохраняется индекс последнего максимального
  элемента в массиве ItemList. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. }

function G_IndexOfMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; LastIndex: PInteger = nil): Integer;

{ Функция G_SearchMinMax возвращает минимальный элемент в массиве указателей
  ItemList как результат функции, а максимальный элемент этого массива
  возвращает в параметре MaxItem. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. }

function G_SearchMinMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out MaxItem: Pointer): Pointer;


{ Функции для переупорядочивания массива указателей }

{ G_Rotate выполняет циклический сдвиг массива указателей ItemList, состоящего
  из Count элементов, таким образом, чтобы элемент с индексом Index и все
  следующие за ним элементы оказались в начале массива, а элементы от нулевого
  до (Index - 1)-го оказались в конце массива. }

procedure G_Rotate(ItemList: PPointerItemList; Index, Count: Integer);

{ G_RotateCopy выполняет циклический сдвиг массива указателей ItemList,
  состоящего из Count элементов, и помещает результат в массив OutList
  той же длины. Циклический сдвиг выполняется таким образом, чтобы элемент
  с индексом Index и все следующие за ним элементы оказались в начале массива,
  а элементы от нулевого до (Index - 1)-го оказались в конце массива. }

procedure G_RotateCopy(ItemList: PPointerItemList; Index, Count: Integer;
  OutList: PPointerItemList);

{ G_PartitionStrict перемещает все элементы массива указателей ItemList,
  меньшие значения Value, в начало массива. Число таких элементов возвращается
  как результат функции. Остальные элементы перемещаются в конец массива.
  Count - общее число элементов в массиве. MatchFunction - функция для
  сопоставления значения элементу массива. }

function G_PartitionStrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_PartitionUnstrict перемещает все элементы массива указателей ItemList,
  меньшие или равные значению Value, в начало массива. Число таких элементов
  возвращается как результат функции. Остальные элементы перемещаются в конец
  массива. Count - общее число элементов в массиве. MatchFunction - функция
  для сопоставления значения элементу массива. }

function G_PartitionUnstrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_StablePartitionStrict перемещает все элементы массива указателей ItemList,
  меньшие значения Value, в начало массива. Число таких элементов возвращается
  как результат функции. Остальные элементы перемещаются в конец массива.
  В отличие от функции G_PartitionStrict, относительное расположение элементов,
  меньших Value, и элементов, больших или равных Value, не меняется. Count -
  общее число элементов в массиве. MatchFunction - функция для сопоставления
  значения элементу массива. }

function G_StablePartitionStrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_StablePartitionUnstrict перемещает все элементы массива указателей
  ItemList, меньшие или равные значению Value, в начало массива. Число таких
  элементов возвращается как результат функции. Остальные элементы перемещаются
  в конец массива. В отличие от функции G_PartitionUnstrict, относительное
  расположение элементов, меньших или равных Value, и элементов, больших Value,
  не меняется. В ходе выполнения данной функции выделяется дополнительная
  память. Count - общее число элементов в массиве. MatchFunction - функция для
  сопоставления значения элементу массива. }

function G_StablePartitionUnstrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_SelectTop перемещает N минимальных элементов массива указателей ItemList
  в начало массива. Count - общее число элементов в массиве. CompareFunction -
  функция для сравнения двух элементов массива. }

procedure G_SelectTop(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);

{ G_StableSelectTop перемещает N минимальных элементов массива указателей
  ItemList в начало массива. Count - общее число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов массива. В отличие
  от G_SelectTop, при выполнении данной процедуры относительное расположение
  N минимальных элементов не меняется. Также сохраняется относительное
  расположение (Count - N) максимальных элементов массива. В ходе работы
  процедуры выделяется дополнительная память. }

procedure G_StableSelectTop(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);

{ G_RandomShuffle перемешивает случайным образом массив указателей ItemList,
  состоящий из Count элементов. Дескриптор генератора псевдослучайных чисел
  передается параметром H. Если в этом параметре передано значение nil,
  процедура использует собственный экземпляр генератора, инициализируемый
  значением по умолчанию, который уничтожается при выходе из процедуры. }

procedure G_RandomShuffle(ItemList: PPointerItemList; Count: Integer;
  H: HMT = nil);


{ Функции для сортировки массива указателей }

{ G_Sort сортирует по возрастанию массив указателей ItemList, состоящий из
  Count элементов. Функция для сравнения двух элементов массива передается
  параметром CompareFunction. Используется метод интроспективной сортировки. }

procedure G_Sort(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);

{ G_StableSort сортирует по возрастанию массив указателей ItemList, состоящий
  из Count элементов. Функция для сравнения двух элементов массива передается
  параметром CompareFunction. В отличие от процедуры G_Sort, относительное
  расположение равных элементов массива не меняется. В ходе выполнения этой
  процедуры выделяется дополнительная память. Применяется метод сортировки
  слиянием. }

procedure G_StableSort(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);

{ G_PartialSort сортирует по возрастанию N минимальных элементов массива
  указателей ItemList, состоящего из Count элементов. Остальные элементы
  перемещаются в конец массива. Функция для сравнения двух элементов массива
  передается параметром CompareFunction. Используется метод пирамидальной
  сортировки. }

procedure G_PartialSort(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);

{ G_PartialSortCopy заполняет массив OutList минимальными элементами массива
  указателей ItemList, отсортированными по возрастанию. Count - общее число
  элементов в массиве ItemList. OutCount - максимальное число элементов,
  которое может быть записано в массив OutList. CompareFunction - функция
  для сравнения двух элементов массива ItemList. }

function G_PartialSortCopy(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; OutList: PPointerItemList;
  OutCount: Integer): Integer;

{ G_IsSorted возвращает True, если массив указателей ItemList является
  отсортированным по возрастанию. Count - число элементов в массиве.
  CompareFunction - функция для сравнения двух элементов. Если в массиве
  есть хотя бы одна пара элементов, для которой нарушается условие
  сортировки по возрастанию, функция возвращает False. }

function G_IsSorted(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Boolean;


{ Функции для бинарного поиска в отсортированном массиве указателей }

{ Следующая функция G_BinarySearch выполняет бинарный поиск значения Value
  в массиве указателей ItemList, состоящем из Count элементов. Функция
  возвращает индекс элемента массива, значение которого равно Value. Если
  в массиве нет элемента с таким значением, функция возвращает -1. Массив
  должен быть отсортирован по возрастанию. Функция для сопоставления
  значения элементу массива передается параметром MatchFunction. }

function G_BinarySearch(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer; overload;

{ Следующая функция G_BinarySearch выполняет бинарный поиск значения Value
  в массиве указателей ItemList, состоящем из Count элементов. Если в ходе
  выполнения функции найден элемент массива, значение которого равно Value,
  функция возвращает True и индекс найденного элемента в параметре Index.
  Если в массиве нет элемента с таким значением, функция возвращает False,
  а в параметре Index возвращает индекс элемента, в позицию которого может
  быть вставлено искомое значение без нарушения порядка сортировки. Массив
  должен быть отсортирован по возрастанию. Функция для сопоставления значения
  элементу массива передается параметром MatchFunction. }

function G_BinarySearch(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction; out Index: Integer): Boolean; overload;

{ G_SearchFirstGreater возвращает индекс первого элемента в массиве указателей
  ItemList, значение которого больше Value. Count - число элементов в массиве.
  MatchFunction - функция для сопоставления значения элементу массива. Если
  в массиве нет элемента, большего Value, функция возвращает Count. Элементы
  массива ItemList должны быть отсортированы по возрастанию. }

function G_SearchFirstGreater(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_SearchFirstGreaterOrEqual возвращает индекс первого элемента в массиве
  указателей ItemList, значение которого больше или равно Value. Count - число
  элементов в массиве. MatchFunction - функция для сопоставления значения
  элементу массива. Если в массиве нет элемента, большего или равного Value,
  функция возвращает Count. Элементы массива ItemList должны быть отсортированы
  по возрастанию. }

function G_SearchFirstGreaterOrEqual(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_SearchLastLesser возвращает индекс последнего элемента в массиве
  указателей ItemList, значение которого меньше Value. Count - число элементов
  в массиве. MatchFunction - функция для сопоставления значения элементу
  массива. Если в массиве нет элемента, меньшего Value, функция возвращает -1.
  Элементы массива ItemList должны быть отсортированы по возрастанию. }

function G_SearchLastLesser(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;

{ G_SearchLastLesserOrEqual возвращает индекс последнего элемента в массиве
  указателей ItemList, значение которого меньше или равно Value. Count - число
  элементов в массиве. MatchFunction - функция для сопоставления значения
  элементу массива. Если в массиве нет элемента, меньшего или равного Value,
  функция возвращает -1. Элементы массива ItemList должны быть отсортированы
  по возрастанию. }

function G_SearchLastLesserOrEqual(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;


{ Функции для слияния сортированных массивов указателей }

{ G_Merge формирует из двух отсортированных по возрастанию массивов указателей
  новый массив, состоящий из всех элементов исходных массивов, который будет
  также отсортирован по возрастанию. ItemList1 - адрес первого массива. Count1
  - число элементов в первом массиве. ItemList2 - адрес второго массива. Count2
  - число элементов во втором массиве. OutList - адрес массива, в котором
  сохраняется результат слияния массивов. Функция возвращает число элементов,
  помещенных в выходной массив. Функция для сравнения двух элементов массивов
  передается параметром CompareFunction. }

function G_Merge(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;

{ G_SetContainedIn возвращает True, если все элементы первого массива
  ItemList1 длиной Count1 элементов присутствуют во втором массиве ItemList2
  длиной Count2 элементов. Если в первом массиве есть какие-либо элементы,
  отсутствующие во втором массиве, функция возвращает False. Массивы ItemList1
  и ItemList2 должны быть отсортированы по возрастанию. Функция для сравнения
  двух элементов массивов передается параметром CompareFunction. }

function G_SetContainedIn(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction): Boolean;

{ G_SetIntersectsWith возвращает True, первый массив ItemList1 длиной Count1
  содержит какие-либо элементы, присутствующие во втором массиве ItemList2
  длиной Count2 элементов. Если в массивах нет равных элементов, функция
  возвращает False. Массивы ItemList1 и ItemList2 должны быть отсортированы
  по возрастанию. Функция для сравнения двух элементов массивов передается
  параметром CompareFunction. }

function G_SetIntersectsWith(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction): Boolean;

{ G_SetUnion формирует из двух массивов указателей новый массив, состоящий
  из элементов, которые присутствуют хотя бы в одном из исходных массивов.
  ItemList1 - адрес первого массива. Count1 - число элементов в первом массиве.
  ItemList2 - адрес второго массива. Count2 - число элементов во втором
  массиве. OutList - адрес массива, в котором сохраняется результат объединения
  массивов. Функция возвращает число элементов, помещенных в выходной массив.
  Массивы ItemList1 и ItemList2 должны быть отсортированы по возрастанию.
  Функция для сравнения двух элементов массивов передается параметром
  CompareFunction. Если в параметре OutList передано значение nil, функция
  просто возвращает число элементов, которое должно быть помещено в выходной
  массив. }

function G_SetUnion(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList = nil): Integer;

{ G_SetIntersection формирует из двух массивов указателей новый массив,
  состоящий из элементов, которые присутствуют в обоих исходных массивах.
  ItemList1 - адрес первого массива. Count1 - число элементов в первом массиве.
  ItemList2 - адрес второго массива. Count2 - число элементов во втором
  массиве. OutList - адрес массива, в котором сохраняется результат пересечения
  массивов. Функция возвращает число элементов, помещенных в выходной массив.
  Массивы ItemList1 и ItemList2 должны быть отсортированы по возрастанию.
  Функция для сравнения двух элементов массивов передается параметром
  CompareFunction. Если в параметре OutList передано значение nil, функция
  просто возвращает число элементов, которое должно быть помещено в выходной
  массив. }

function G_SetIntersection(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList = nil): Integer;

{ G_SetDifference формирует из двух массивов указателей новый массив,
  состоящий из элементов, которые присутствуют первом массиве, но отсутствуют
  во втором. ItemList1 - адрес первого массива. Count1 - число элементов
  в первом массиве. ItemList2 - адрес второго массива. Count2 - число элементов
  во втором массиве. OutList - адрес массива, в котором сохраняется массив -
  результат разности множеств. Функция возвращает число элементов, помещенных
  в выходной массив. Массивы ItemList1 и ItemList2 должны быть отсортированы
  по возрастанию. Функция для сравнения двух элементов массивов передается
  параметром CompareFunction. Если в параметре OutList передано значение nil,
  функция просто возвращает число элементов, которое должно быть помещено
  в выходной массив. }

function G_SetDifference(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList = nil): Integer;

{ G_SetSymmetricDifference формирует из двух массивов указателей новый массив,
  состоящий из элементов, которые присутствуют только в одном из исходных
  массивов. Элементы, присутствующие в обоих исходных массивах, при этом
  игнорируются. ItemList1 - адрес первого массива. Count1 - число элементов
  в первом массиве. ItemList2 - адрес второго массива. Count2 - число элементов
  во втором массиве. OutList - адрес массива, в котором сохраняется массив -
  результат операции XOR множеств. Функция возвращает число элементов,
  помещенных в выходной массив. Массивы ItemList1 и ItemList2 должны быть
  отсортированы по возрастанию. Функция для сравнения двух элементов массивов
  передается параметром CompareFunction. Если в параметре OutList передано
  значение nil, функция просто возвращает число элементов, которое должно быть
  помещено в выходной массив. }

function G_SetSymmetricDifference(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList = nil): Integer;


{ Функции для работы с кучей }

{ Кучей называется бинарное дерево, реализованное в виде последовательного
  набора элементов, который обладает двумя важными свойствами: первый элемент
  всегда является максимальным, добавление и удаление элементов производится
  с логарифмической сложностью. Значение каждого узла такого бинарного дерева
  больше или равно значению каждого из его дочерних узлов. }

{ G_MakeHeap переупорядочивает массив указателей ItemList, состоящий из
  Count элементов, таким образом, чтобы набор элементов представлял собой
  кучу, т.е. значение каждого элемента было больше или равно значению каждого
  из его дочерних элементов. Функция для сравнения двух элементов массива
  передается параметром CompareFunction. }

procedure G_MakeHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);

{ G_PushHeap помещает в кучу новый элемент. Адрес кучи передается параметром
  ItemList, число элементов в массиве - параметром Count. Предполагается,
  что последний элемент массива, т.е. элемент ItemList^[Count - 1], возможно
  нарушает порядок кучи. Он переносится на соответствующее ему место. Функция
  возвращает индекс элемента массива, в который был перенесен последний,
  т.е. добавленный, элемент. Функция для сравнения двух элементов передается
  параметром CompareFunction. }

function G_PushHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Integer;

{ Следующая функция G_PopHeap извлекает из кучи первый, т.е. максимальный,
  элемент, который возвращается как результат функции. Одновременно,
  функция перемещает удаляемый элемент в конец массива. Адрес кучи передается
  параметром ItemList, число элементов в куче - параметром Count. После
  вызова данной функции размер кучи следует уменьшить на 1, т.к. последний
  элемент, вероятно, нарушает порядок кучи. Функция для сравнения двух
  элементов передается параметром CompareFunction. }

function G_PopHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer; overload;

{ Следующая функция G_PopHeap извлекает из кучи элемент с индексом Index,
  который возвращается как результат функции. Одновременно, функция перемещает
  удаляемый элемент в конец массива. Адрес кучи передается параметром ItemList,
  число элементов в куче - параметром Count. После вызова данной функции размер
  кучи следует уменьшить на 1, т.к. последний элемент, вероятно, нарушает
  порядок кучи. Функция для сравнения двух элементов передается параметром
  CompareFunction. }

function G_PopHeap(Index: Integer; ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer; overload;

{ G_SortHeap сортирует элементы кучи по возрастанию. Адрес кучи передается
  параметром ItemList, число элементов в куче - параметром Count. Функция для
  сравнения двух элементов передается параметром CompareFunction. Процедура
  G_SortHeap, фактически, реализует метод пирамидальной сортировки. }

procedure G_SortHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);

{ G_IsHeap возвращает True, если массив указателей ItemList, состоящий из
  Count элементов, представляет собой кучу, т.е. значение каждого элемента
  больше или равно значению каждого из его дочерних элементов. Если данное
  условие не выполняется для какого-либо элемента массива, функция
  возвращает False. Элементы массива сравниваются между собой с помощью
  функции, передаваемой параметром CompareFunction. }

function G_IsHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Boolean;

implementation

uses Windows, AcedCommon, AcedStrings;

{ Функции для поиска, замены, подсчета и удаления элементов массива указателей }

function G_Search(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer;
var
  I: Integer;
begin
  Result := -1;
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) = 0 then
    begin
      Result := I;
      Exit;
    end;
    Inc(I);
  end;
end;

function G_SearchBackward(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  I: Integer;
begin
  Result := -1;
  I := Count - 1;
  while I >= 0 do
  begin
    if MatchFunction(Value, ItemList^[I]) = 0 then
    begin
      Result := I;
      Exit;
    end;
    Dec(I);
  end;
end;

function G_Replace(Value, NewP: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) = 0 then
    begin
      ItemList^[I] := NewP;
      Inc(Result);
    end;
    Inc(I);
  end;
end;

function G_CountOf(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) = 0 then
      Inc(Result);
    Inc(I);
  end;
end;

function G_CountOfUnique(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    I := 1;
    Result := I;
    while I < Count do
    begin
      if CompareFunction(ItemList^[I - 1], ItemList^[I]) <> 0 then
        Inc(Result);
      Inc(I);
    end;
  end;
end;

function G_RemoveCopy(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction; OutList: PPointerItemList): Integer;
var
  I: Integer;
begin
  Result := Integer(OutList);
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) <> 0 then
    begin
      PPointer(OutList)^ := ItemList^[I];
      Inc(LongWord(OutList), SizeOf(Pointer));
    end;
    Inc(I);
  end;
  Result := (LongWord(OutList) - LongWord(Result)) shr 2;
end;

function G_UniqueCopy(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; OutList: PPointerItemList): Integer;
var
  I: Integer;
begin
  Result := Integer(OutList);
  if Count > 0 then
  begin
    PPointer(OutList)^ := ItemList^[0];
    Inc(LongWord(OutList), SizeOf(Pointer));
    I := 1;
    while I < Count do
    begin
      if CompareFunction(ItemList^[I - 1], ItemList^[I]) <> 0 then
      begin
        PPointer(OutList)^ := ItemList^[I];
        Inc(LongWord(OutList), SizeOf(Pointer));
      end;
      Inc(I);
    end;
  end;
  Result := (LongWord(OutList) - LongWord(Result)) shr 2;
end;

{ Функции для поиска минимального и максимального элементов массива }

function G_SearchMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer;
var
  I: Integer;
begin
  if Count = 0 then
    Result := nil
  else
  begin
    Result := ItemList^[0];
    I := 1;
    while I < Count do
    begin
      if CompareFunction(Result, ItemList^[I]) > 0 then
        Result := ItemList^[I];
      Inc(I);
    end;
  end;
end;

function G_SearchMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out N: Integer): Pointer;
var
  I, J, C: Integer;
begin
  if Count = 0 then
  begin
    Result := nil;
    J := 0;
  end else
  begin
    Result := ItemList^[0];
    I := 1;
    J := I;
    while I < Count do
    begin
      C := CompareFunction(Result, ItemList^[I]);
      if C >= 0 then
        if C = 0 then
          Inc(J)
        else
        begin
          Result := ItemList^[I];
          J := 1;
        end;
      Inc(I);
    end;
  end;
  N := J;
end;

function G_IndexOfMin(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; LastIndex: PInteger): Integer;
var
  I, J1, J2, C: Integer;
  P: Pointer;
begin
  if Count = 0 then
  begin
    if LastIndex <> nil then
      LastIndex^ := -1;
    Result := -1;
  end else
  begin
    J1 := 0;
    J2 := 0;
    P := ItemList^[0];
    I := 1;
    while I < Count do
    begin
      C := CompareFunction(P, ItemList^[I]);
      if C >= 0 then
        if C = 0 then
          J2 := I
        else
        begin
          J1 := I;
          J2 := I;
          P := ItemList^[I];
        end;
      Inc(I);
    end;
    if LastIndex <> nil then
      LastIndex^ := J2;
    Result := J1;
  end;
end;

function G_SearchMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer;
var
  I: Integer;
begin
  if Count = 0 then
    Result := nil
  else
  begin
    Result := ItemList^[0];
    I := 1;
    while I < Count do
    begin
      if CompareFunction(Result, ItemList^[I]) < 0 then
        Result := ItemList^[I];
      Inc(I);
    end;
  end;
end;

function G_SearchMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out N: Integer): Pointer;
var
  I, J, C: Integer;
begin
  if Count = 0 then
  begin
    Result := nil;
    J := 0;
  end else
  begin
    Result := ItemList^[0];
    I := 1;
    J := I;
    while I < Count do
    begin
      C := CompareFunction(Result, ItemList^[I]);
      if C <= 0 then
        if C = 0 then
          Inc(J)
        else
        begin
          Result := ItemList^[I];
          J := 1;
        end;
      Inc(I);
    end;
  end;
  N := J;
end;

function G_IndexOfMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; LastIndex: PInteger): Integer;
var
  I, J1, J2, C: Integer;
  P: Pointer;
begin
  if Count = 0 then
  begin
    if LastIndex <> nil then
      LastIndex^ := -1;
    Result := -1;
  end else
  begin
    J1 := 0;
    J2 := 0;
    P := ItemList^[0];
    I := 1;
    while I < Count do
    begin
      C := CompareFunction(P, ItemList^[I]);
      if C <= 0 then
        if C = 0 then
          J2 := I
        else
        begin
          J1 := I;
          J2 := I;
          P := ItemList^[I];
        end;
      Inc(I);
    end;
    if LastIndex <> nil then
      LastIndex^ := J2;
    Result := J1;
  end;
end;

function G_SearchMinMax(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; out MaxItem: Pointer): Pointer;
var
  I: Integer;
  PMin, PMax: Pointer;
begin
  if Count = 0 then
  begin
    MaxItem := nil;
    Result := nil;
  end else
  begin
    PMin := ItemList^[0];
    PMax := PMin;
    I := 1;
    Dec(Count);
    while I < Count do
    begin
      if CompareFunction(ItemList^[I], ItemList^[I + 1]) < 0 then
      begin
        if CompareFunction(PMin, ItemList^[I]) > 0 then
          PMin := ItemList^[I];
        if CompareFunction(PMax, ItemList^[I + 1]) < 0 then
          PMax := ItemList^[I + 1];
      end else
      begin
        if CompareFunction(PMin, ItemList^[I + 1]) > 0 then
          PMin := ItemList^[I + 1];
        if CompareFunction(PMax, ItemList^[I]) < 0 then
          PMax := ItemList^[I];
      end;
      Inc(I, 2);
    end;
    if I = Count then
      if CompareFunction(PMax, ItemList^[I]) < 0 then
        PMax := ItemList^[I]
      else if CompareFunction(PMin, ItemList^[I]) > 0 then
        PMin := ItemList^[I];
    MaxItem := PMax;
    Result := PMin;
  end;
end;

{ Функции для переупорядочивания массива указателей }

procedure G_Rotate(ItemList: PPointerItemList; Index, Count: Integer);
var
  L: Integer;
begin
  if (Index > 0) and (Index < Count) then
  begin
    L := Count - Index;
    if Index = L then
      G_SwapLongs(ItemList, @ItemList^[Index], L)
    else
    begin
      G_ReverseLongs(ItemList, Index);
      G_ReverseLongs(@ItemList^[Index], L);
      G_ReverseLongs(ItemList, Count);
    end;
  end;
end;

procedure G_RotateCopy(ItemList: PPointerItemList; Index, Count: Integer;
  OutList: PPointerItemList);
begin
  if (Index = 0) or (Index >= Count) then
    G_CopyLongs(ItemList, OutList, Count)
  else
  begin
    Dec(Count, Index);
    G_CopyLongs(@ItemList^[Index], OutList, Count);
    G_CopyLongs(ItemList, @OutList^[Count], Index);
  end;
end;

function G_PartitionStrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  P: Pointer;
begin
  Result := 0;
  repeat
    repeat
      if Result = Count then
        Exit;
      if MatchFunction(Value, ItemList^[Result]) > 0 then
        Inc(Result)
      else
        Break;
    until False;
    Dec(Count);
    repeat
      if Result = Count then
        Exit;
      if MatchFunction(Value, ItemList^[Count]) <= 0 then
        Dec(Count)
      else
        Break;
    until False;
    P := ItemList^[Result];
    ItemList^[Result] := ItemList^[Count];
    ItemList^[Count] := P;
    Inc(Result);
  until False;
end;

function G_PartitionUnstrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  P: Pointer;
begin
  Result := 0;
  repeat
    repeat
      if Result = Count then
        Exit;
      if MatchFunction(Value, ItemList^[Result]) >= 0 then
        Inc(Result)
      else
        Break;
    until False;
    Dec(Count);
    repeat
      if Result = Count then
        Exit;
      if MatchFunction(Value, ItemList^[Count]) < 0 then
        Dec(Count)
      else
        Break;
    until False;
    P := ItemList^[Result];
    ItemList^[Result] := ItemList^[Count];
    ItemList^[Count] := P;
    Inc(Result);
  until False;
end;

function G_StablePartitionStrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  Buffer: PPointerItemList;
  I, L: Integer;
begin
  GetMem(Buffer, Count * SizeOf(Pointer));
  Result := 0;
  L := 0;
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) > 0 then
    begin
      ItemList^[Result] := ItemList^[I];
      Inc(Result);
    end else
    begin
      Buffer^[L] := ItemList^[I];
      Inc(L);
    end;
    Inc(I);
  end;
  G_CopyLongs(Buffer, @ItemList^[Result], L);
  FreeMem(Buffer);
end;

function G_StablePartitionUnstrict(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  Buffer: PPointerItemList;
  I, L: Integer;
begin
  GetMem(Buffer, Count * SizeOf(Pointer));
  Result := 0;
  L := 0;
  I := 0;
  while I < Count do
  begin
    if MatchFunction(Value, ItemList^[I]) >= 0 then
    begin
      ItemList^[Result] := ItemList^[I];
      Inc(Result);
    end else
    begin
      Buffer^[L] := ItemList^[I];
      Inc(L);
    end;
    Inc(I);
  end;
  G_CopyLongs(Buffer, @ItemList^[Result], L);
  FreeMem(Buffer);
end;

procedure IntSort3(ItemList: PPointerItemList; CompareFunction: TCompareFunction);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP
        MOV     EBX,EAX
        MOV     EDI,[EBX+4]
        MOV     ESI,EDX
        MOV     EBP,[EBX+8]
        MOV     EDX,EDI
        MOV     EAX,[EBX]
        CALL    ESI
        TEST    EAX,EAX
        JNLE    @@m2
        MOV     EAX,EDI
        MOV     EDX,EBP
        CALL    ESI
        TEST    EAX,EAX
        JLE     @@qt
        MOV     EAX,[EBX]
        MOV     EDX,EBP
        CALL    ESI
        TEST    EAX,EAX
        JNLE    @@m1
        MOV     [EBX+4],EBP
        MOV     [EBX+8],EDI
        JMP     @@qt
@@m1:   MOV     [EBX+8],EDI
        MOV     EAX,[EBX]
        MOV     [EBX],EBP
        MOV     [EBX+4],EAX
        JMP     @@qt
@@m2:   MOV     EAX,[EBX]
        MOV     EDX,EBP
        CALL    ESI
        TEST    EAX,EAX
        JNLE    @@m3
        MOV     EAX,[EBX]
        MOV     [EBX],EDI
        MOV     [EBX+4],EAX
        JMP     @@qt
@@m3:   MOV     EAX,EDI
        MOV     EDX,EBP
        CALL    ESI
        MOV     ECX,[EBX]
        MOV     [EBX+8],ECX
        TEST    EAX,EAX
        JNLE    @@m4
        MOV     [EBX],EDI
        MOV     [EBX+4],EBP
        JMP     @@qt
@@m4:   MOV     [EBX],EBP
@@qt:   POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure IntSort4(ItemList: PPointerItemList; CompareFunction: TCompareFunction);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     EAX,[EAX]
        MOV     ESI,EDX
        MOV     EDX,[EBX+4]
        CALL    ESI
        TEST    EAX,EAX
        JLE     @@nx1
        MOV     EAX,[EBX]
        MOV     EDX,[EBX+4]
        MOV     [EBX],EDX
        MOV     [EBX+4],EAX
@@nx1:  MOV     EAX,[EBX+8]
        MOV     EDX,[EBX+12]
        CALL    ESI
        TEST    EAX,EAX
        JLE     @@nx2
        MOV     EAX,[EBX+8]
        MOV     EDX,[EBX+12]
        MOV     [EBX+8],EDX
        MOV     [EBX+12],EAX
@@nx2:  MOV     EAX,[EBX]
        MOV     EDX,[EBX+8]
        CALL    ESI
        MOV     EDX,[EBX+12]
        MOV     EDI,EAX
        MOV     EAX,[EBX+4]
        CALL    ESI
        TEST    EAX,EAX
        JNLE    @@m2
        TEST    EDI,EDI
        JNLE    @@m1
        MOV     EAX,[EBX+4]
        MOV     EDX,[EBX+8]
        CALL    ESI
        TEST    EAX,EAX
        JLE     @@qt
        MOV     EAX,[EBX+4]
        MOV     EDX,[EBX+8]
        MOV     [EBX+4],EDX
        MOV     [EBX+8],EAX
        JMP     @@qt
@@m1:   MOV     EAX,[EBX]
        MOV     EDX,[EBX+8]
        MOV     [EBX],EDX
        MOV     EDX,[EBX+4]
        MOV     [EBX+4],EAX
        MOV     [EBX+8],EDX
        JMP     @@qt
@@m2:   TEST    EDI,EDI
        JNLE    @@m3
        MOV     EAX,[EBX+4]
        MOV     EDX,[EBX+8]
        MOV     [EBX+4],EDX
        MOV     EDX,[EBX+12]
        MOV     [EBX+8],EDX
        MOV     [EBX+12],EAX
        JMP     @@qt
@@m3:   MOV     EAX,[EBX]
        MOV     EDX,[EBX+12]
        CALL    ESI
        MOV     ECX,[EBX]
        MOV     EDX,[EBX+4]
        MOV     EDI,[EBX+8]
        MOV     [EBX],EDI
        MOV     EDI,[EBX+12]
        MOV     [EBX+12],EDX
        TEST    EAX,EAX
        JNLE    @@m4
        MOV     [EBX+4],ECX
        MOV     [EBX+8],EDI
        JMP     @@qt
@@m4:   MOV     [EBX+4],EDI
        MOV     [EBX+8],ECX
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

procedure IntTinySort(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);
begin
  if Count > 2 then
  begin
    if Count = 4 then
      IntSort4(ItemList, CompareFunction)
    else
      IntSort3(ItemList, CompareFunction)
  end
  else if (Count = 2) and (CompareFunction(ItemList^[0], ItemList^[1]) > 0) then
  begin
    Count := Integer(ItemList^[0]);
    ItemList^[0] := ItemList^[1];
    ItemList^[1] := Pointer(Count);
  end;
end;

procedure G_SelectTop(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);
label
  99;
var
  L, H, QL: Integer;
  P, T: Pointer;
begin
  if (N = 0) or (N >= Count) then
    Exit;
  L := 0;
  H := Count;
  QL := L;
  while H - L > 4 do
  begin
    P := ItemList^[(L + H) shr 1];
    T := ItemList^[H - 1];
    if CompareFunction(ItemList^[L], P) <= 0 then
    begin
      if CompareFunction(P, T) > 0 then
        if CompareFunction(ItemList^[L], T) <= 0 then
          P := T
        else
          P := ItemList^[L];
    end
    else if CompareFunction(ItemList^[L], T) <= 0 then
      P := ItemList^[L]
    else if CompareFunction(P, T) <= 0 then
      P := T;
    repeat
      repeat
        if L = H then
          goto 99;
        if CompareFunction(P, ItemList^[L]) > 0 then
          Inc(L)
        else
          Break;
      until False;
      Dec(H);
      repeat
        if L = H then
          goto 99;
        if CompareFunction(P, ItemList^[H]) <= 0 then
          Dec(H)
        else
          Break;
      until False;
      T := ItemList^[L];
      ItemList^[L] := ItemList^[H];
      ItemList^[H] := T;
      Inc(L);
    until False;
  99:
    if L <= N then
      QL := L
    else
      Count := L;
    L := QL;
    H := Count;
  end;
  IntTinySort(@ItemList^[L], H - L, CompareFunction);
end;

procedure G_StableSelectTop(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);
var
  L, B, I, C: Integer;
  Buffer: PPointerItemList;
  P: Pointer;
begin
  if (N = 0) or (N >= Count) then
    Exit;
  GetMem(Buffer, Count * SizeOf(Pointer));
  G_CopyLongs(ItemList, Buffer, Count);
  G_SelectTop(N, Buffer, Count, CompareFunction);
  P := G_SearchMax(Buffer, N, CompareFunction, N);
  L := 0;
  B := 0;
  I := 0;
  while I < Count do
  begin
    C := CompareFunction(P, ItemList^[I]);
    if C > 0 then
    begin
      ItemList^[L] := ItemList^[I];
      Inc(L);
    end
    else if (C < 0) or (N = 0) then
    begin
      Buffer^[B] := ItemList^[I];
      Inc(B);
    end else
    begin
      ItemList^[L] := ItemList^[I];
      Inc(L);
      Dec(N);
    end;
    Inc(I);
  end;
  G_CopyLongs(Buffer, @ItemList^[L], B);
  FreeMem(Buffer);
end;

procedure G_RandomShuffle(ItemList: PPointerItemList; Count: Integer; H: HMT);
var
  I, R: Integer;
  P: Pointer;
  G: Boolean;
begin
  if H = nil then
  begin
    G_RandomInit(H);
    G := True;
  end else
    G := False;
  I := 1;
  while I < Count do
  begin
    R := G_RandomUInt32(H, I + 1);
    P := ItemList^[R];
    ItemList^[R] := ItemList^[I];
    ItemList^[I] := P;
    Inc(I);
  end;
  if G then
    G_RandomDone(H);
end;

{ Функции для сортировки массива указателей }

procedure IntRotateRight(P: Pointer; Count: Cardinal);
asm
        MOV     ECX,[EAX+EDX*4]
        JMP     DWORD PTR @@wV[EDX*4]
@@wV :  DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
@@w15:  MOV     EDX,[EAX+56]
        MOV     [EAX+60],EDX
@@w14:  MOV     EDX,[EAX+52]
        MOV     [EAX+56],EDX
@@w13:  MOV     EDX,[EAX+48]
        MOV     [EAX+52],EDX
@@w12:  MOV     EDX,[EAX+44]
        MOV     [EAX+48],EDX
@@w11:  MOV     EDX,[EAX+40]
        MOV     [EAX+44],EDX
@@w10:  MOV     EDX,[EAX+36]
        MOV     [EAX+40],EDX
@@w09:  MOV     EDX,[EAX+32]
        MOV     [EAX+36],EDX
@@w08:  MOV     EDX,[EAX+28]
        MOV     [EAX+32],EDX
@@w07:  MOV     EDX,[EAX+24]
        MOV     [EAX+28],EDX
@@w06:  MOV     EDX,[EAX+20]
        MOV     [EAX+24],EDX
@@w05:  MOV     EDX,[EAX+16]
        MOV     [EAX+20],EDX
@@w04:  MOV     EDX,[EAX+12]
        MOV     [EAX+16],EDX
@@w03:  MOV     EDX,[EAX+8]
        MOV     [EAX+12],EDX
@@w02:  MOV     EDX,[EAX+4]
        MOV     [EAX+8],EDX
@@w01:  MOV     EDX,[EAX]
        MOV     [EAX+4],EDX
@@w00:  MOV     [EAX],ECX
end;

procedure IntInsertionSort(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);
var
  I, J: Integer;
begin
  I := 1;
  while I < Count do
  begin
    J := I - 1;
    while J >= 0 do
    begin
      if CompareFunction(ItemList^[I], ItemList^[J]) >= 0 then
        Break;
      Dec(J);
    end;
    Inc(J);
    if I <> J then
      IntRotateRight(@ItemList^[J], I - J);
    Inc(I);
  end;
end;

procedure IntroSort(L, R: Integer; ItemList: PPointerItemList;
  CompareFunction: TCompareFunction; DepthLimit: Integer);
var
  I, J: Integer;
  P, T: Pointer;
begin
  I := L;
  J := R;
  if DepthLimit = 0 then
  begin
    Dec(J, I);
    G_MakeHeap(@ItemList^[I], J + 1, CompareFunction);
    G_SortHeap(@ItemList^[I], J + 1, CompareFunction);
    Exit;
  end;
  Dec(DepthLimit);
  P := ItemList^[(I + J) shr 1];
  if CompareFunction(ItemList^[I], P) <= 0 then
  begin
    if CompareFunction(P, ItemList^[J]) > 0 then
      if CompareFunction(ItemList^[I], ItemList^[J]) <= 0 then
        P := ItemList^[J]
      else
        P := ItemList^[I];
  end
  else if CompareFunction(ItemList^[I], ItemList^[J]) <= 0 then
    P := ItemList^[I]
  else if CompareFunction(P, ItemList^[J]) <= 0 then
    P := ItemList^[J];
  repeat
    while CompareFunction(ItemList^[I], P) < 0 do Inc(I);
    while CompareFunction(ItemList^[J], P) > 0 do Dec(J);
    if I <= J then
    begin
      T := ItemList^[I];
      ItemList^[I] := ItemList^[J];
      ItemList^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if J - L > 15 then
    IntroSort(L, J, ItemList, CompareFunction, DepthLimit)
  else
    IntInsertionSort(@ItemList^[L], J - L + 1, CompareFunction);
  if R - I > 15 then
    IntroSort(I, R, ItemList, CompareFunction, DepthLimit)
  else
    IntInsertionSort(@ItemList^[I], R - I + 1, CompareFunction);
end;

procedure G_Sort(ItemList: PPointerItemList; Count: Integer; CompareFunction: TCompareFunction);
begin
  if Count < 17 then
  begin
    IntInsertionSort(ItemList, Count, CompareFunction);
    Exit;
  end;
  IntroSort(0, Count - 1, ItemList, CompareFunction, G_Log2(Count) * 2);
end;

procedure IntMergeLoop(InList, OutList: PPointerItemList; Step, Count: Integer;
  CompareFunction: TCompareFunction);
var
  I1, I2, DoubleStep: Integer;
begin
  DoubleStep := Step * 2;
  repeat
    if Count < DoubleStep then
      if Count > Step then
        DoubleStep := Count
      else
      begin
        G_CopyLongs(InList, OutList, Count);
        Break;
      end;
    I1 := 0;
    I2 := Step;
    repeat
      if CompareFunction(InList^[I1], InList^[I2]) <= 0 then
      begin
        PPointer(OutList)^ := InList^[I1];
        Inc(I1);
        Inc(LongWord(OutList), SizeOf(Pointer));
        if I1 = Step then
        begin
          I1 := DoubleStep - I2;
          G_CopyLongs(@InList^[I2], OutList, I1);
          Inc(LongWord(OutList), I1 * SizeOf(Pointer));
          Break;
        end;
      end else
      begin
        PPointer(OutList)^ := InList^[I2];
        Inc(I2);
        Inc(LongWord(OutList), SizeOf(Pointer));
        if I2 = DoubleStep then
        begin
          I2 := Step - I1;
          G_CopyLongs(@InList^[I1], OutList, I2);
          Inc(LongWord(OutList), I2 * SizeOf(Pointer));
          Break;
        end;
      end;
    until False;
    Inc(LongWord(InList), DoubleStep * SizeOf(Pointer));
    Dec(Count, DoubleStep);
  until Count = 0;
end;

procedure G_StableSort(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);
var
  I: Integer;
  Buffer: PPointerItemList;
begin
  if Count < 17 then
  begin
    IntInsertionSort(ItemList, Count, CompareFunction);
    Exit;
  end;
  I := 0;
  Dec(Count, 4);
  while I <= Count do
  begin
    IntSort4(@ItemList^[I], CompareFunction);
    Inc(I, 4);
  end;
  Inc(Count, 4);
  IntTinySort(@ItemList^[I], Count - I, CompareFunction);
  GetMem(Buffer, Count * SizeOf(Pointer));
  I := 4;
  while I < Count do
  begin
    IntMergeLoop(ItemList, Buffer, I, Count, CompareFunction);
    Inc(I, I);
    IntMergeLoop(Buffer, ItemList, I, Count, CompareFunction);
    Inc(I, I);
  end;
  FreeMem(Buffer);
end;

procedure IntDownHeap(ItemList: PPointerItemList; Index, Count: Integer;
  P: Pointer; CompareFunction: TCompareFunction);
var
  Top, J: Integer;
begin
  Top := Index;
  J := (Index * 2) + 2;
  while J < Count do
  begin
    if CompareFunction(ItemList^[J], ItemList^[J - 1]) < 0 then
      Dec(J);
    ItemList^[Index] := ItemList^[J];
    Index := J;
    Inc(J, J + 2);
  end;
  if J = Count then
  begin
    ItemList^[Index] := ItemList^[J - 1];
    Index := J - 1;
  end;
  J := (Index - 1) shr 1;
  while (Index > Top) and (CompareFunction(ItemList^[J], P) < 0) do
  begin
    ItemList^[Index] := ItemList^[J];
    Index := J;
    J := (Index - 1) shr 1;
  end;
  ItemList^[Index] := P;
end;

procedure G_PartialSort(N: Integer; ItemList: PPointerItemList;
  Count: Integer; CompareFunction: TCompareFunction);
var
  I: Integer;
  P: Pointer;
begin
  if N > Count then
    N := Count;
  if N <= 0 then
    Exit;
  G_MakeHeap(ItemList, N, CompareFunction);
  I := N;
  while I < Count do
  begin
    P := ItemList^[I];
    if CompareFunction(P, ItemList^[0]) < 0 then
    begin
      ItemList^[I] := ItemList^[0];
      IntDownHeap(ItemList, 0, N, P, CompareFunction);
    end;
    Inc(I);
  end;
  G_SortHeap(ItemList, N, CompareFunction);
end;

function G_PartialSortCopy(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction; OutList: PPointerItemList;
  OutCount: Integer): Integer;
var
  I: Integer;
  P: Pointer;
begin
  I := OutCount;
  if I > Count then
    I := Count;
  Result := I;
  if I <= 0 then
    Exit;
  G_CopyLongs(ItemList, OutList, I);
  G_MakeHeap(OutList, I, CompareFunction);
  while I < Count do
  begin
    P := ItemList^[I];
    if CompareFunction(P, OutList^[0]) < 0 then
      IntDownHeap(OutList, 0, Result, P, CompareFunction);
    Inc(I);
  end;
  G_SortHeap(OutList, Result, CompareFunction);
end;

function G_IsSorted(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Boolean;
var
  I: Integer;
begin
  if Count > 1 then
  begin
    I := 1;
    repeat
      if CompareFunction(ItemList^[I], ItemList^[I - 1]) < 0 then
      begin
        Result := False;
        Exit;
      end;
      Inc(I);
    until I = Count;
  end;
  Result := True;
end;

{ Функции для бинарного поиска в отсортированном массиве указателей }

function G_BinarySearch(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction): Integer;
var
  L, M, C: Integer;
begin
  if Count > 0 then
  begin
    L := 0;
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      C := MatchFunction(Value, ItemList^[M]);
      if C > 0 then
        L := M + 1
      else if C <> 0 then
        Count := M - 1
      else
      begin
        Result := M;
        Exit;
      end;
    end;
  end;
  Result := -1;
end;

function G_BinarySearch(Value: Pointer; ItemList: PPointerItemList; Count: Integer;
  MatchFunction: TMatchFunction; out Index: Integer): Boolean;
var
  L, M, C: Integer;
begin
  L := 0;
  if Count > 0 then
  begin
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      C := MatchFunction(Value, ItemList^[M]);
      if C > 0 then
        L := M + 1
      else if C <> 0 then
        Count := M - 1
      else
      begin
        Index := M;
        Result := True;
        Exit;
      end;
    end;
  end;
  Index := L;
  Result := False;
end;

function G_SearchFirstGreater(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  L, M: Integer;
begin
  Result := Count;
  if Count > 0 then
  begin
    L := 0;
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      if MatchFunction(Value, ItemList^[M]) >= 0 then
        L := M + 1
      else
      begin
        Count := M - 1;
        Result := M;
      end;
    end;
  end;
end;

function G_SearchFirstGreaterOrEqual(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  L, M: Integer;
begin
  Result := Count;
  if Count > 0 then
  begin
    L := 0;
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      if MatchFunction(Value, ItemList^[M]) > 0 then
        L := M + 1
      else
      begin
        Count := M - 1;
        Result := M;
      end;
    end;
  end;
end;

function G_SearchLastLesser(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  L, M: Integer;
begin
  Result := -1;
  if Count > 0 then
  begin
    L := 0;
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      if MatchFunction(Value, ItemList^[M]) <= 0 then
        Count := M - 1
      else
      begin
        L := M + 1;
        Result := M;
      end;
    end;
  end;
end;

function G_SearchLastLesserOrEqual(Value: Pointer; ItemList: PPointerItemList;
  Count: Integer; MatchFunction: TMatchFunction): Integer;
var
  L, M: Integer;
begin
  Result := -1;
  if Count > 0 then
  begin
    L := 0;
    Dec(Count);
    while L <= Count do
    begin
      M := (L + Count) shr 1;
      if MatchFunction(Value, ItemList^[M]) < 0 then
        Count := M - 1
      else
      begin
        L := M + 1;
        Result := M;
      end;
    end;
  end;
end;

{ Функции для слияния сортированных массивов указателей }

function G_Merge(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;
var
  I1, I2: Integer;
begin
  if Count1 = 0 then
    G_CopyLongs(ItemList2, OutList, Count2)
  else if Count2 = 0 then
    G_CopyLongs(ItemList1, OutList, Count1)
  else
  begin
    I1 := 0;
    I2 := 0;
    repeat
      if CompareFunction(ItemList1^[I1], ItemList2^[I2]) <= 0 then
      begin
        PPointer(OutList)^ := ItemList1^[I1];
        Inc(I1);
        Inc(LongWord(OutList), SizeOf(Pointer));
        if I1 = Count1 then
        begin
          G_CopyLongs(@ItemList2^[I2], OutList, Count2 - I2);
          Break;
        end;
      end else
      begin
        PPointer(OutList)^ := ItemList2^[I2];
        Inc(I2);
        Inc(LongWord(OutList), SizeOf(Pointer));
        if I2 = Count2 then
        begin
          G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
          Break;
        end;
      end;
    until False;
  end;
  Result := Count1 + Count2;
end;

function G_SetContainedIn(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction): Boolean;
var
  I1, I2, C: Integer;
begin
  Result := False;
  I1 := 0;
  I2 := 0;
  repeat
    if I1 = Count1 then
      Break;
    if I2 = Count2 then
      Exit;
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C = 0 then
        Break;
      if C < 0 then
        Exit;
      Inc(I2);
      if I2 = Count2 then
        Exit;
    until False;
    Inc(I1);
    Inc(I2);
  until False;
  Result := True;
end;

function G_SetIntersectsWith(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction): Boolean;
var
  I1, I2, C: Integer;
begin
  Result := True;
  if (Count1 <> 0) and (Count2 <> 0) then
  begin
    I1 := 0;
    I2 := 0;
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C < 0 then
      begin
        Inc(I1);
        if I1 = Count1 then
          Break;
      end
      else if C <> 0 then
      begin
        Inc(I2);
        if I2 = Count2 then
          Break;
      end else
        Exit;
    until False;
  end;
  Result := False;
end;

function G_SetUnion(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;
var
  I1, I2, C: Integer;
begin
  Result := Count1 + Count2;
  I1 := 0;
  I2 := 0;
  if OutList <> nil then
  begin
    if Count1 = 0 then
      G_CopyLongs(ItemList2, OutList, Count2)
    else if Count2 = 0 then
      G_CopyLongs(ItemList1, OutList, Count1)
    else
      repeat
        C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
        if C = 0 then
        begin
          Dec(Result);
          PPointer(OutList)^ := ItemList1^[I1];
          Inc(I1);
          Inc(I2);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I1 = Count1 then
          begin
            G_CopyLongs(@ItemList2^[I2], OutList, Count2 - I2);
            Break;
          end;
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end
        else if C < 0 then
        begin
          PPointer(OutList)^ := ItemList1^[I1];
          Inc(I1);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I1 = Count1 then
          begin
            G_CopyLongs(@ItemList2^[I2], OutList, Count2 - I2);
            Break;
          end;
        end else
        begin
          PPointer(OutList)^ := ItemList2^[I2];
          Inc(I2);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end;
      until False;
  end
  else if (Count1 <> 0) and (Count2 <> 0) then
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C = 0 then
      begin
        Dec(Result);
        Inc(I1);
        Inc(I2);
        if (I1 = Count1) or (I2 = Count2) then
          Break;
      end
      else if C < 0 then
      begin
        Inc(I1);
        if I1 = Count1 then
          Break;
      end else
      begin
        Inc(I2);
        if I2 = Count2 then
          Break;
      end;
    until False;
end;

function G_SetIntersection(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;
var
  I1, I2, C: Integer;
begin
  Result := 0;
  if (Count1 <> 0) and (Count2 <> 0) then
  begin
    I1 := 0;
    I2 := 0;
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C = 0 then
      begin
        if OutList <> nil then
        begin
          PPointer(OutList)^ := ItemList1^[I1];
          Inc(LongWord(OutList), SizeOf(Pointer));
        end;
        Inc(Result);
        Inc(I1);
        Inc(I2);
        if (I1 = Count1) or (I2 = Count2) then
          Break;
      end
      else if C < 0 then
      begin
        Inc(I1);
        if I1 = Count1 then
          Break;
      end else
      begin
        Inc(I2);
        if I2 = Count2 then
          Break;
      end;
    until False;
  end;
end;

function G_SetDifference(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;
var
  I1, I2, C: Integer;
begin
  Result := Count1;
  I1 := 0;
  I2 := 0;
  if OutList <> nil then
  begin
    if Count2 = 0 then
      G_CopyLongs(ItemList1, OutList, Count1)
    else if Count1 <> 0 then
      repeat
        C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
        if C = 0 then
        begin
          Dec(Result);
          Inc(I1);
          Inc(I2);
          if I1 = Count1 then
            Break;
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end
        else if C < 0 then
        begin
          PPointer(OutList)^ := ItemList1^[I1];
          Inc(I1);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I1 = Count1 then
            Break;
        end else
        begin
          Inc(I2);
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end;
      until False;
  end
  else if (Count1 <> 0) and (Count2 <> 0) then
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C = 0 then
      begin
        Dec(Result);
        Inc(I1);
        Inc(I2);
        if (I1 = Count1) or (I2 = Count2) then
          Break;
      end
      else if C < 0 then
      begin
        Inc(I1);
        if I1 = Count1 then
          Break;
      end else
      begin
        Inc(I2);
        if I2 = Count2 then
          Break;
      end;
    until False;
end;

function G_SetSymmetricDifference(ItemList1: PPointerItemList; Count1: Integer;
  ItemList2: PPointerItemList; Count2: Integer; CompareFunction: TCompareFunction;
  OutList: PPointerItemList): Integer;
var
  I1, I2, C: Integer;
begin
  Result := Count1 + Count2;
  I1 := 0;
  I2 := 0;
  if OutList <> nil then
  begin
    if Count1 = 0 then
      G_CopyLongs(ItemList2, OutList, Count2)
    else if Count2 = 0 then
      G_CopyLongs(ItemList1, OutList, Count1)
    else
      repeat
        C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
        if C = 0 then
        begin
          Dec(Result, 2);
          Inc(I1);
          Inc(I2);
          if I1 = Count1 then
          begin
            G_CopyLongs(@ItemList2^[I2], OutList, Count2 - I2);
            Break;
          end;
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end
        else if C < 0 then
        begin
          PPointer(OutList)^ := ItemList1^[I1];
          Inc(I1);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I1 = Count1 then
          begin
            G_CopyLongs(@ItemList2^[I2], OutList, Count2 - I2);
            Break;
          end;
        end else
        begin
          PPointer(OutList)^ := ItemList2^[I2];
          Inc(I2);
          Inc(LongWord(OutList), SizeOf(Pointer));
          if I2 = Count2 then
          begin
            G_CopyLongs(@ItemList1^[I1], OutList, Count1 - I1);
            Break;
          end;
        end;
      until False;
  end
  else if (Count1 <> 0) and (Count2 <> 0) then
    repeat
      C := CompareFunction(ItemList1^[I1], ItemList2^[I2]);
      if C = 0 then
      begin
        Dec(Result, 2);
        Inc(I1);
        Inc(I2);
        if (I1 = Count1) or (I2 = Count2) then
          Break;
      end
      else if C < 0 then
      begin
        Inc(I1);
        if I1 = Count1 then
          Break;
      end else
      begin
        Inc(I2);
        if I2 = Count2 then
          Break;
      end;
    until False;
end;

{ Функции для работы с кучей }

procedure G_MakeHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);
var
  Parent: Integer;
begin
  if Count > 1 then
  begin
    Parent := (Count - 2) shr 1;
    repeat
      IntDownHeap(ItemList, Parent, Count, ItemList^[Parent], CompareFunction);
      if Parent = 0 then
        Break;
      Dec(Parent);
    until False;
  end;
end;

function G_PushHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Integer;
var
  Parent: Integer;
  V: Pointer;
begin
  Dec(Count);
  Parent := (Count - 1) shr 1;
  V := ItemList^[Count];
  while (Count > 0) and (CompareFunction(ItemList^[Parent], V) < 0) do
  begin
    ItemList^[Count] := ItemList^[Parent];
    Count := Parent;
    Parent := (Count - 1) shr 1;
  end;
  ItemList^[Count] := V;
  Result := Count;
end;

function G_PopHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer;
begin
  Dec(Count);
  Result := ItemList^[Count];
  ItemList^[Count] := ItemList^[0];
  IntDownHeap(ItemList, 0, Count, Result, CompareFunction);
  Result := ItemList^[Count];
end;

function G_PopHeap(Index: Integer; ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Pointer;
begin
  Dec(Count);
  if Index < Count then
  begin
    Result := ItemList^[Count];
    ItemList^[Count] := ItemList^[Index];
    IntDownHeap(ItemList, Index, Count, Result, CompareFunction);
  end;
  Result := ItemList^[Count];
end;

procedure G_SortHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction);
var
  P: Pointer;
begin
  while Count > 1 do
  begin
    Dec(Count);
    P := ItemList^[Count];
    ItemList^[Count] := ItemList^[0];
    IntDownHeap(ItemList, 0, Count, P, CompareFunction);
  end;
end;

function G_IsHeap(ItemList: PPointerItemList; Count: Integer;
  CompareFunction: TCompareFunction): Boolean;
var
  P, C: Integer;
begin
  Result := False;
  P := 0;
  Dec(Count);
  C := 1;
  while C < Count do
  begin
    if CompareFunction(ItemList^[P], ItemList^[C]) < 0 then
      Exit;
    Inc(C);
    if CompareFunction(ItemList^[P], ItemList^[C]) < 0 then
      Exit;
    Inc(C);
    Inc(P);
  end;
  if (Count > 0) and (Count and 1 <> 0) then
    Result := CompareFunction(ItemList^[P], ItemList^[C]) >= 0
  else
    Result := True;
end;

end.

