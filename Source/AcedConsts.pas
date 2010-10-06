
/////////////////////////////////////////////////////////////
//                                                         //
//   AcedConsts 1.16                                       //
//                                                         //
//   Общие типы и функции, используемые другими модулями   //
//   в составе библиотеки AcedUtils, а также методы для    //
//   генерации исключений.                                 //
//                                                         //
//   mailto: acedutils@yandex.ru                           //
//                                                         //
/////////////////////////////////////////////////////////////

unit AcedConsts;

{$B-,H+,R-,Q-,T-,X+}

interface

{ Типы массивов, содержащих произвольное число элементов, и соответствующие
  им константы. }

const

{ Максимальный индекс в массиве байт }

  ByteListUpperLimit = 536870911;

{ Максимальный индекс в массиве 2-байтных элементов }

  WordListUpperLimit = 268435455;

{ Максимальный индекс в массиве 4-байтных элементов }

  DWordListUpperLimit = 134217727;

{ Максимальный индекс в массиве 8-байтных элементов }

  QWordListUpperLimit = 67108863;

type

{ Тип массива и указателя на массив элементов типа Integer }

  PIntegerItemList = ^TIntegerItemList;
  TIntegerItemList = array[0..DWordListUpperLimit] of Integer;

{ Тип массива и указателя на массив элементов типа LongWord }

  PLongWordItemList = ^TLongWordItemList;
  TLongWordItemList = array[0..DWordListUpperLimit] of LongWord;

{ Тип массива и указателя на массив элементов типа TObject }

  PObjectItemList = ^TObjectItemList;
  TObjectItemList = array[0..DWordListUpperLimit] of TObject;

{ Тип массива и указателя на массив элементов типа Pointer }

  PPointerItemList = ^TPointerItemList;
  TPointerItemList = array[0..DWordListUpperLimit] of Pointer;

{ Тип массива и указателя на массив элементов типа AnsiString }

  PStringItemList = ^TStringItemList;
  TStringItemList = array[0..DWordListUpperLimit] of AnsiString;

{ Тип массива и указателя на массив элементов типа Word }

  PWordItemList = ^TWordItemList;
  TWordItemList = array[0..WordListUpperLimit] of Word;

{ Тип массива и указателя на массив элементов типа Currency }

  PCurrencyItemList = ^TCurrencyItemList;
  TCurrencyItemList = array[0..QWordListUpperLimit] of Currency;

{ Тип массива и указателя на массив элементов типа Double }

  PDoubleItemList = ^TDoubleItemList;
  TDoubleItemList = array[0..QWordListUpperLimit] of Double;

{ Тип массива и указателя на массив элементов типа Int64 }

  PInt64ItemList = ^TInt64ItemList;
  TInt64ItemList = array[0..QWordListUpperLimit] of Int64;

{ Тип массива и указателя на массив элементов типа Byte }

  PBytes = ^TBytes;
  TBytes = array[0..ByteListUpperLimit] of Byte;

{ Тип массива и указателя на массив элементов типа AnsiChar }

  PChars = ^TChars;
  TChars = array[0..ByteListUpperLimit] of AnsiChar;


{ Функции для выбора оптимального размера внутреннего массива обычного
  и хэшированного списков. }

{ G_EnlargeCapacity возвращает новое предельное число элементов коллекции
  при необходимости добавления нового элемента в коллекцию, когда ее размер
  достиг предельного значения, равного Capacity. }

function G_EnlargeCapacity(Capacity: Integer): Integer;

{ G_NormalizeCapacity возвращает предельное число элементов коллекции, большее
  или равное значению параметра Capacity. Это число подбирается таким образом,
  чтобы оптимизировать количество перераспределений памяти при возможном
  будущем расширении коллекции. }

function G_NormalizeCapacity(Capacity: Integer): Integer;

{ G_EnlargePrimeCapacity возвращает новое предельное число элементов
  хэшированного массива при необходимости добавления нового элемента, когда
  используемый размер хэша достиг предельного значения, равного Capacity. }

function G_EnlargePrimeCapacity(Capacity: Integer): Integer;


{ Константы и методы для генерации исключений }

const
  SErrArgumentNull = 'Параметр "%s", передаваемый в функцию "%s", не может быть равен nil.';
  SErrBinaryStreamCorrupted = 'Данные в бинарном потоке испорчены и не могут быть прочитаны.';
  SErrCodesToStrConversionFault = 'Ошибка при преобразовании строки шестнадцатеричных кодов в строку символов.';
  SErrCountDiffersInTBitLists = 'Два экземпляра класса TBitList имеют различное значение свойства Count.';
  SErrFileCreateError = 'Ошибка при создании файла "%s"';
  SErrFileOpenedForWrite = 'Невозможно открыть файл "%s", т.к. файл данных коллекции уже открыт для записи.';
  SErrFileReadError = 'Ошибка при чтении файла "%s".';
  SErrFileRereadError = 'Ошибка при повторном чтении данных из файла.';
  SErrFileWriteError = 'Ошибка при записи файла.';
  SErrFileWriteErrorFmt = 'Ошибка при записи файла "%s".';
  SErrFrameNotInitialized = 'Grid-фрейм не был инициализирован.';
  SErrFreeUnusedBlock = 'Попытка освободить незанятую область памяти.';
  SErrHexToIntConversionFault = 'Ошибка в ходе преобразования шестнадцатеричного числа %s в целое число.';
  SErrIndexOutOfRange = 'Попытка обратиться к несуществующему элементу списка или очереди.';
  SErrInsertionNotAllowed = 'Недопустима вставка элементов в массив при (MaintainSorted = True).';
  SErrKeyDuplicatesInAssociationList = 'Нарушение уникальности ключа в наборе %s.';
  SErrMSExcelNotFound = 'Для построения отчетов на компьютере должен быть установлен Microsoft Excel.';
  SErrNoAvailableTimers = 'Невозможно создать таймер в Grid-фрейме.';
  SErrNodeBelongsToAnotherList = 'Узел не принадлежит данному связанному списку.';
  SErrNodeBelongsToAnotherTree = 'Узел не принадлежит данному красно-черному дереву.';
  SErrNoFileOpenedForWrite = 'Файл не был открыт для записи.';
  SErrNoHighResolutionPC = 'В данной конфигурации отсутствует таймер высокого разрешения.';
  SErrNoMoreAvailableID = 'В коллекции закончились уникальные идентификаторы.';
  SErrOnDelayedSelectItemNotAssigned = 'Не назначен обработчик для события OnDelayedSelectItem.';
  SErrOnGetDataNotAssigned = 'Не назначен обработчик для события OnGetData.';
  SErrPeekFromEmptyList = 'Попытка вызвать метод Peek или Pop для пустого списка или очереди.';
  SErrReadNotComplete = 'Чтение из бинарного потока не завершено (файл "%s").';
  SErrReadBeyondTheEndOfStream = 'Попытка прочитать данные за пределами бинарного потока.';
  SErrRereadNotComplete = 'Повторное чтение из бинарного потока не завершено.';
  SErrStreamIsReadOnly = 'Невозможно произвести запись в бинарный поток, открытый в режиме "только для чтения".';
  SErrStreamIsWriteOnly = 'Невозможно произвести чтение из бинарного потока, открытого в режиме "только для записи".';
  SErrUnorderedRemovalNotAllowed = 'Недопустимо unordered-удаление из массива при (MaintainSorted = True).';
  SErrVersionNotSupported = 'Класс %s не поддерживает версию данных %d.';
  SErrWrongArgumentInReplaceChars = 'В функцию G_ReplaceChars переданы неправильные параметры.';
  SErrWrongBase64EncodedString = 'Формат строки не соответствует способу кодирования Base64.';
  SErrWrongDecryptionKey = 'Неправильный ключ используется при расшифровке данных бинарного потока.';
  SErrWrongGridColumnIndex = 'Неправильный номер столбца в Grid-фрейме.';
  SErrWrongGridRowIndex = 'Неправильный номер строки в Grid-фрейме.';
  SErrWrongNumberOfGridColumns = 'Неверное число столбцов в Grid-фрейме.';
  SErrWrongStreamLength = 'Неправильная длина указана при создании бинарного потока.';

{ Генерирует исключение с сообщением о том, что сохраненная версия объекта
  не может быть прочитана. Обычно вызывается из метода Load классов,
  производных от TSerializableObject. В параметре O передается Self. }

procedure RaiseVersionNotSupported(O: TObject; Version: Integer);

{ Методы, генерирующие исключения типа Exception и EConvertError. }

procedure RaiseErrorFmt(const msg, S: AnsiString); overload;
procedure RaiseErrorFmt(const msg, S1, S2: AnsiString); overload;
procedure RaiseConvertErrorFmt(const msg, S: AnsiString);
procedure RaiseError(const msg: AnsiString);
procedure RaiseConvertError(const msg: AnsiString);

implementation

uses SysUtils, AcedBinary;

{ Функции для выбора оптимального размера внутреннего массива обычного
  и хэшированного списков. }

function G_EnlargeCapacity(Capacity: Integer): Integer;
begin
  Inc(Capacity, 10);
  if Capacity >= 8192 then
    Result := (((Capacity shr 1) + Capacity + $FFF) and $7FFFF000) - 8
  else
    Result := G_IncPowerOfTwo(Capacity);
end;

function G_NormalizeCapacity(Capacity: Integer): Integer;
begin
  if Capacity <= 8 then
    Result := 16
  else if Capacity <= 8192 then
    Result := G_CeilPowerOfTwo(Capacity)
  else
    Result := ((Capacity + $1007) and $7FFFF000) - 8;
end;

function G_EnlargePrimeCapacity(Capacity: Integer): Integer;
begin
  if Capacity < 2729 then
  begin
    if Capacity < 163 then
    begin
      if Capacity < 37 then
      begin
        if Capacity < 17 then
        begin
          Result := 17;
          Exit;
        end else
        begin
          Result := 37;
          Exit;
        end;
      end
      else if Capacity < 79 then
      begin
        Result := 79;
        Exit;
      end else
      begin
        Result := 163;
        Exit;
      end;
    end else
    begin
      if Capacity < 673 then
      begin
        if Capacity < 331 then
        begin
          Result := 331;
          Exit;
        end else
        begin
          Result := 673;
          Exit;
        end;
      end
      else if Capacity < 1361 then
      begin
        Result := 1361;
        Exit;
      end else
      begin
        Result := 2729;
        Exit;
      end;
    end;
  end
  else if Capacity < 701819 then
  begin
    if Capacity < 43853 then
    begin
      if Capacity < 10949 then
      begin
        if Capacity < 5471 then
        begin
          Result := 5471;
          Exit;
        end else
        begin
          Result := 10949;
          Exit;
        end;
      end
      else if Capacity < 21911 then
      begin
        Result := 21911;
        Exit;
      end else
      begin
        Result := 43853;
        Exit;
      end;
    end else
    begin
      if Capacity < 175447 then
      begin
        if Capacity < 87719 then
        begin
          Result := 87719;
          Exit;
        end else
        begin
          Result := 175447;
          Exit;
        end;
      end
      else if Capacity < 350899 then
      begin
        Result := 350899;
        Exit;
      end else
      begin
        Result := 701819;
        Exit;
      end;
    end;
  end
  else if Capacity < 179669557 then
  begin
    if Capacity < 11229331 then
    begin
      if Capacity < 2807303 then
      begin
        if Capacity < 1403641 then
        begin
          Result := 1403641;
          Exit;
        end else
        begin
          Result := 2807303;
          Exit;
        end;
      end
      else if Capacity < 5614657 then
      begin
        Result := 5614657;
        Exit;
      end else
      begin
        Result := 11229331;
        Exit;
      end;
    end else
    begin
      if Capacity < 44917381 then
      begin
        if Capacity < 22458671 then
        begin
          Result := 22458671;
          Exit;
        end else
        begin
          Result := 44917381;
          Exit;
        end;
      end
      else if Capacity < 89834777 then
      begin
        Result := 89834777;
        Exit;
      end else
      begin
        Result := 179669557;
        Exit;
      end;
    end;
  end
  else if Capacity < 718678369 then
  begin
    if Capacity < 359339171 then
    begin
      Result := 359339171;
      Exit;
    end else
    begin
      Result := 718678369;
      Exit;
    end;
  end
  else if Capacity < 1437356741 then
  begin
    Result := 1437356741;
    Exit;
  end else
    Result := 0;
end;

{ Методы для генерации исключений }

procedure RaiseVersionNotSupported(O: TObject; Version: Integer);
begin
  raise Exception.CreateFmt(SErrVersionNotSupported, [O.ClassName, Version]);
end;

procedure RaiseErrorFmt(const msg, S: AnsiString);
begin
  raise Exception.CreateFmt(string(msg), [S]);
end;

procedure RaiseErrorFmt(const msg, S1, S2: AnsiString);
begin
  raise Exception.CreateFmt(string(msg), [S1, S2]);
end;

procedure RaiseConvertErrorFmt(const msg, S: AnsiString);
begin
  raise EConvertError.CreateFmt(string(msg), [S]);
end;

procedure RaiseError(const msg: AnsiString);
begin
  raise Exception.Create(string(msg));
end;

procedure RaiseConvertError(const msg: AnsiString);
begin
  raise EConvertError.Create(string(msg));
end;

end.

