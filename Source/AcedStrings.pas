
///////////////////////////////////////////////////////////////
//                                                           //
//   AcedStrings 1.16                                        //
//                                                           //
//   Содержит разнообразные функции для работы со строками   //
//   типа AnsiString и класс TStringBuilder, используемый    //
//   для быстрого создания строк из отдельных фрагментов.    //
//                                                           //
//   mailto: acedutils@yandex.ru                             //
//                                                           //
///////////////////////////////////////////////////////////////

unit AcedStrings;

{$B-,H+,R-,Q-,T-,X+}

interface

{ ВАЖНОЕ ЗАМЕЧАНИЕ:

  Если необходимо применить G_StrToUpper(P: PAnsiChar), G_StrToAnsi(P: PAnsiChar) или
  другую подобную функцию, в которую передается указатель и данные по указателю
  изменяются, к строке S типа AnsiString, то сначала надо вызвать стандартную
  процедуру UniqueString(S) для фактического выделения памяти и исключения
  множественных ссылок и ссылок на константную строку. Только после этого
  можно изменять строку по указателю, как, например: G_StrToUpper(Pointer(S)). }

uses SysUtils, AcedConsts;

{ Функции для сравнения строк }

{ G_CompareStr сравнивает две строки с учетом регистра. Возвращаемый результат
  меньше нуля, если S1 < S2; больше нуля, если S1 > S2, и равен нулю, если
  S1 = S2. Эта функция прекращает сравнение, когда обнаружено различие строк
  или когда обнаружен символ с кодом 0, т.е. символ конца строки. }

function G_CompareStr(const S1, S2: AnsiString): Integer; overload;
function G_CompareStr(P1, P2: PAnsiChar): Integer; overload;

{ G_CompareStrL сравнивает две строки по, самое большое, maxL первым
  символам с учетом регистра. Возвращаемый результат меньше нуля, если
  Copy(S1, 1, maxL) < Copy(S2, 1, maxL); результат больше нуля, если
  Copy(S1, 1, maxL) > Copy(S2, 1, maxL), иначе результат равен нулю,
  если Copy(S1, 1, maxL) = Copy(S2, 1, maxL). }

function G_CompareStrL(const S1, S2: AnsiString; maxL: Cardinal = MaxInt): Integer; overload;
function G_CompareStrL(P1, P2: PAnsiChar; maxL: Cardinal = MaxInt): Integer; overload;

{ G_CompareText сравнивает две строки без учета регистра. Возвращаемый
  результат меньше нуля, если S1 < S2; больше нуля, если S1 > S2, и равен нулю,
  если S1 = S2. Эта функция прекращает сравнение, когда обнаружено различие
  строк или когда обнаружен символ с кодом 0,  т.е. символ конца строки. }

function G_CompareText(const S1, S2: AnsiString): Integer; overload;
function G_CompareText(P1, P2: PAnsiChar): Integer; overload;

{ G_CompareTextL сравнивает две строки по, самое большое, maxL первым символам
  без учета регистра. Если фрагмент первой строки больше (в алфавитном порядке),
  чем фрагмент второй строки, возвращаемое значение больше нуля. Если фрагмент
  первой строки меньше, чем фрагмент второй строки, возвращаемое значение
  меньше нуля, иначе, если строки равны, результат равен нулю. }

function G_CompareTextL(const S1, S2: AnsiString; maxL: Cardinal = MaxInt): Integer; overload;
function G_CompareTextL(P1, P2: PAnsiChar; maxL: Cardinal = MaxInt): Integer; overload;

{ G_SameStr сравнивает две строки с учетом регистра и возвращает True, если
  строки равны, иначе возвращает False. }

function G_SameStr(const S1, S2: AnsiString): Boolean; overload;
function G_SameStr(P1, P2: Pointer): Boolean; overload;

{ G_SameStrL сравнивает две строки по, самое большое, maxL первым символам с
  учетом регистра. Возвращает True, если строки равны, иначе возвращает False. }

function G_SameStrL(const S1, S2: AnsiString; maxL: Cardinal): Boolean;

{ G_SameText сравнивает две строки без учета регистра и возвращает True, если
  строки равны, иначе возвращает False. }

function G_SameText(const S1, S2: AnsiString): Boolean; overload;
function G_SameText(P1, P2: Pointer): Boolean; overload;

{ G_SameTextL сравнивает две строки по, самое большое, maxL первым символам
  без учета регистра. Возвращает True, если строки равны, иначе - False. }

function G_SameTextL(const S1, S2: AnsiString; maxL: Cardinal): Boolean;


{ Функции для изменения регистра символов }

{ G_CharToUpper переводит символ C в верхний регистр (в большую букву). }

function G_CharToUpper(C: AnsiChar): AnsiChar;

{ G_CharToLower переводит символ C в нижний регистр (в маленькую букву). }

function G_CharToLower(C: AnsiChar): AnsiChar;

{ G_StrToUpper переводит строку S в верхний регистр (в большие буквы).
  Исходная строка изменяется. }

procedure G_StrToUpper(var S: AnsiString); overload;
function G_StrToUpper(P: PAnsiChar): PAnsiChar; overload;

{ G_StrToLower переводит строку S в нижний регистр (в маленькие буквы).
  Исходная строка изменяется. }

procedure G_StrToLower(var S: AnsiString); overload;
function G_StrToLower(P: PAnsiChar): PAnsiChar; overload;

{ G_StrToUpperL переводит L первых символов строки, указываемой параметром P,
  в верхний регистр. При этом изменяется исходная строка. Функция возвращает
  указатель на начало строки. }

function G_StrToUpperL(P: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToLowerL переводит L первых символов строки, указываемой параметром P,
  в нижний регистр. При этом изменяется исходная строка. Функция возвращает
  указатель на начало строки. }

function G_StrToLowerL(P: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToUpperMoveL переводит L первых символов строки Source в верхний
  регистр. Результат сохраняется в строке Dest. Функция возвращает указатель
  на начало строки-приемника Dest. }

function G_StrToUpperMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToLowerMoveL переводит L первых символов строки Source в нижний
  регистр. Результат сохраняется в строке Dest. Функция возвращает указатель
  на начало строки-приемника Dest. }

function G_StrToLowerMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_ToUpper переводит все символы строки S в верхний регистр и возвращает
  полученную строку как результат функции. Исходная строка не изменяется. }

function G_ToUpper(const S: AnsiString): AnsiString;

{ G_ToLower переводит все символы строки S в нижний регистр и возвращает
  полученную строку как результат функции. Исходная строка не изменяется. }

function G_ToLower(const S: AnsiString): AnsiString;


{ Перекодировка строк из DOS в Windows и обратно }

{ G_StrToAnsi переводит строку S из кодировки DOS в кодировку Windows.
  Исходная строка изменяется. }

procedure G_StrToAnsi(var S: AnsiString); overload;
function G_StrToAnsi(P: PAnsiChar): PAnsiChar; overload;

{ G_StrToOem переводит строку S из кодировки Windows в кодировку DOS.
  Исходная строка изменяется. }

procedure G_StrToOem(var S: AnsiString); overload;
function G_StrToOem(P: PAnsiChar): PAnsiChar; overload;

{ G_StrToAnsiL переводит L первых символов строки, указываемой параметром P,
  из кодировки DOS в кодировку Windows. При этом изменяется исходная строка.
  Функция возвращает указатель на начало строки. }

function G_StrToAnsiL(P: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToOemL переводит L первых символов строки, указываемой параметром P,
  из кодировки Windows в кодировку DOS. При этом изменяется исходная строка.
  Функция возвращает указатель на начало строки. }

function G_StrToOemL(P: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToAnsiMoveL переводит L первых символов строки Source из кодировки
  DOS в кодировку Windows. Результат сохраняется в строке Dest. Функция
  возвращает указатель на начало строки-приемника Dest. }

function G_StrToAnsiMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_StrToOemMoveL переводит L первых символов строки Source из кодировки Windows
  в кодировку DOS. Результат сохраняется в строке Dest. Функция возвращает
  указатель на начало строки-приемника Dest. }

function G_StrToOemMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;

{ G_ToAnsi переводит строку OemStr из кодировки DOS в кодировку Windows и
  возвращает полученную строку как результат функции. Исходная строка при
  этом не изменяется. }

function G_ToAnsi(const OemStr: AnsiString): AnsiString;

{ G_ToOem переводит строку AnsiStr из кодировки Windows в кодировку DOS и
  возвращает полученную строку как результат функции. Исходная строка при
  этом не изменяется. }

function G_ToOem(const AnsiStr: AnsiString): AnsiString;


{ Поиск, замена и удаление подстрок и отдельных символов }

{ G_PosStr находит первое вхождение подстроки FindStr в строке SourceStr,
  начиная с позиции StartPos. Возвращает номер символа, с которого начинается
  вхождение или ноль, если подстрока FindStr не найдена в строке SourceStr.
  Поиск подстроки выполняется с учетом регистра символов. }

function G_PosStr(const FindStr, SourceStr: AnsiString; StartPos: Integer = 1): Integer;

{ G_PosText находит первое вхождение подстроки FindStr в строке SourceStr,
  начиная с позиции StartPos. Возвращает номер символа, с которого начинается
  вхождение или ноль, если подстрока FindStr не найдена в строке SourceStr.
  Поиск подстроки выполняется без учета регистра символов. }

function G_PosText(const FindStr, SourceStr: AnsiString; StartPos: Integer = 1): Integer;

{ G_LastPosStr находит последнее вхождение подстроки FindStr в строке SourceStr
  левее позиции NextPos. Если NextPos превышает длину строки SourceStr, то
  ищется самое последнее вхождение подстроки FindStr. Возвращает номер символа,
  с которого начинается искомая подстрока или ноль, если подстрока не найдена.
  Отдельные вхождения подстроки не перекрываются. Поиск выполняется с учетом
  регистра символов. }

function G_LastPosStr(const FindStr, SourceStr: AnsiString; NextPos: Integer = MaxInt): Integer;

{ G_LastPosText находит последнее вхождение подстроки FindStr в строке SourceStr
  левее позиции NextPos. Если NextPos превышает длину строки SourceStr, то ищется
  самое последнее вхождение подстроки FindStr. Возвращает номер символа, с
  которого начинается искомая подстрока или ноль, если подстрока не найдена.
  Отдельные вхождения подстроки не перекрываются. Поиск выполняется без учета
  регистра символов. }

function G_LastPosText(const FindStr, SourceStr: AnsiString; NextPos: Integer = MaxInt): Integer;

{ G_CharPos находит первое вхождение символа C в строке S, начиная с символа
  номер StartPos. Возвращает номер найденного символа или ноль, если символ C
  в строке S не найден. }

function G_CharPos(C: AnsiChar; const S: AnsiString; StartPos: Integer = 1): Integer; overload;
function G_CharPos(C: AnsiChar; P: Pointer; StartPos: Integer = 1): Integer; overload;

{ G_LastCharPos находит последнее вхождение символа C в строке S. Поиск
  начинается с символа, предшествующего символу S[NextPos] или с последнего
  символа строки, если NextPos превышает длину строки S. Функция возвращает
  номер найденного символа или ноль, если символ C в строке S не найден. }

function G_LastCharPos(C: AnsiChar; const S: AnsiString; NextPos: Integer = MaxInt): Integer; overload;
function G_LastCharPos(C: AnsiChar; P: Pointer; NextPos: Integer = MaxInt): Integer; overload;

{ G_Paste заменяет Count символов строки Dest, начиная с позиции Pos,
  содержимым строки Source. Строка Dest при этом изменяется. Например,
  если строка Dest равна 'How do you do', то после выполнения процедуры:
  G_Paste(Dest, 5, 6, 'does he'), она будет равна 'How does he do'. }

procedure G_Paste(var Dest: AnsiString; Pos, Count: Integer; const Source: AnsiString);

{ G_ReplaceStr заменяет все вхождения подстроки FindStr в строке SourceStr
  подстрокой ReplacementStr. Поиск подстроки выполняется с учетом регистра
  (большие и маленькие буквы различаются). Функция возвращает строку-результат.
  Если подстрока FindStr отсутствует в строке SourceStr, возвращается исходная
  строка SourceStr. }

function G_ReplaceStr(const SourceStr, FindStr, ReplacementStr: AnsiString): AnsiString;

{ G_ReplaceText заменяет все вхождения подстроки FindStr в строке SourceStr
  подстрокой ReplacementStr. Поиск подстроки выполняется без учета регистра
  (большие и маленькие буквы не различаются). Функция возвращает строку-
  результат. Если подстрока FindStr отсутствует в строке SourceStr,
  возвращается исходная строка SourceStr. }

function G_ReplaceText(const SourceStr, FindStr, ReplacementStr: AnsiString): AnsiString;

{ G_ReplaceChar заменяет в строке S каждое вхождение символа OldChar на символ
  NewChar. Результат функции равен количеству произведенных замен. Исходная
  строка S изменяется. }

function G_ReplaceChar(var S: AnsiString; OldChar, NewChar: AnsiChar): Integer;

{ G_ReplaceChars заменяет в строке S все символы из строки OldCharStr
  соответствующими символами из строки NewCharStr. Исходная строка S
  изменяется. Если число символов в строке OldCharStr не равно числу символов
  в строке NewCharStr, возникает исключение. }

procedure G_ReplaceChars(var S: AnsiString; const OldCharStr, NewCharStr: AnsiString);

{ G_ReplaceCharsWithOneChar заменяет все подряд идущие вхождения символов из
  множества OldCharSet в строке S одним символом NewChar. Исходная строка S при
  этом изменяется. Если надо заменить несколько символов одним без удаления
  повторений, лучше воспользоваться процедурой G_ReplaceChars. }

procedure G_ReplaceCharsWithOneChar(var S: AnsiString; const OldCharSet: TSysCharSet; NewChar: AnsiChar);

{ G_Delete удаляет подстроку из строки S. При этом исходная строка изменяется.
  Index - индекс первого удаляемого символа (нумерация символов с единицы),
  Count - количество символов, подлежащих удалению. }

procedure G_Delete(var S: AnsiString; Index, Count: Integer);

{ G_CutLeft обрезает строку S слева на CharCount символов, уменьшая при этом
  ее длину. Если параметр CharCount отрицательный, строка обрезается справа. }

procedure G_CutLeft(var S: AnsiString; CharCount: Integer);

{ G_CutRight обрезает строку S справа на CharCount символов, уменьшая при этом
  ее длину. Если параметр CharCount отрицательный, строка обрезается слева. }

procedure G_CutRight(var S: AnsiString; CharCount: Integer);

{ G_DeleteStr удаляет из строки S все вхождения подстроки SubStrToDel. Поиск
  подстроки выполняется с учетом регистра символов. Функция возвращает
  количество найденных и удаленных фрагментов. }

function G_DeleteStr(var S: AnsiString; const SubStrToDel: AnsiString): Integer;

{ G_DeleteText удаляет из строки S все вхождения подстроки SubStrToDel. Поиск
  подстроки выполняется без учета регистра символов. Функция возвращает
  количество найденных и удаленных фрагментов. }

function G_DeleteText(var S: AnsiString; const SubStrToDel: AnsiString): Integer;

{ G_DeleteChar удаляет все символы C из строки S. Исходная строка при
  этом изменяется. }

procedure G_DeleteChar(var S: AnsiString; C: AnsiChar = ' ');

{ G_DeleteChars удаляет из строки S символы, которые присутствуют во
  множестве CharsToRemove. Исходная строка S изменяется. }

procedure G_DeleteChars(var S: AnsiString; const CharsToRemove: TSysCharSet);

{ G_KeepChars оставляет в строке S только символы, которые присутствуют во
  множестве CharsToKeep, остальные символы удаляет. Исходная строка S
  изменяется. }

procedure G_KeepChars(var S: AnsiString; const CharsToKeep: TSysCharSet);

{ G_Compact удаляет из строки начальные и конечные пробелы и управляющие
  символы (меньшие пробела). Идущие подряд пробелы и управляющие символы
  в середине строки заменяются одним пробелом. При этом изменяется
  исходная строка. }

procedure G_Compact(var S: AnsiString);

{ G_Trim удаляет начальные и конечные пробелы и управляющие символы из
  строки S. Исходная строка изменяется. }

procedure G_Trim(var S: AnsiString);

{ G_TrimLeft удаляет начальные пробелы и управляющие символы из строки S.
  Исходная строка изменяется. }

procedure G_TrimLeft(var S: AnsiString);

{ G_TrimRight удаляет конечные пробелы и управляющие символы из строки S.
  Исходная строка изменяется. }

procedure G_TrimRight(var S: AnsiString);


{ Функции для работы с маской }

{ G_ApplyMask применяет маску Mask к строке SourceStr и возвращает полученную
  строку как результат функции. Символ MaskChar используется в строке Mask для
  указания позиций, в которых подставляются символы из строки SourceStr. Длина
  SourceStr должна быть равна количеству символов MaskChar в маске. Пример:
  G_ApplyMask('(###) ##-##-##', '075724793', '#') вернет '(075) 72-47-93'. }

function G_ApplyMask(const Mask, SourceStr: AnsiString; MaskChar: AnsiChar = 'X'): AnsiString;

{ G_ExtractWithMask удаляет из строки S символы, являющиеся фиксированными
  для маски Mask, оставляя только подставленные символы, которым в маске
  соответствует символ MaskChar. Полученная таким образом строка возвращается
  как результат функции. Длина строк S и Mask должна быть одинаковой.
  Например, вызов: G_ExtractWithMask('7-35-01', 'X-XX-XX') вернет '73501'. }

function G_ExtractWithMask(const S, Mask: AnsiString; MaskChar: AnsiChar = 'X'): AnsiString;

{ G_ValidateMask проверяет, удовлетворяет ли строка S маске Mask, полагая,
  что каждый символ MaskChar в строке Mask может быть заменен любым другим
  символом в строке S. Если строка S удовлетворяет маске, функция возвращает
  True, иначе False. Например, следующий вызов этой функции вернет True:
  G_ValidateMask('ISBN 5-95-00787', 'ISBN ?-??-?????', '?'). }

function G_ValidateMask(const S, Mask: AnsiString; MaskChar: AnsiChar = 'X'): Boolean;

{ G_ValidateWildStr проверяет, удовлетворяет ли строка S маске Mask, полагая,
  что каждый символ MaskChar в строке Mask может быть заменен любым другим
  символом в строке S, а символы WildCard могут быть заменены любым количеством
  произвольных символов. При сравнении большие и маленькие буквы различаются.
  Символ WildCard должен быть отличен от #0. Если строка S удовлетворяет маске,
  функция возвращает True, иначе False. Например, следующий вызов функции
  вернет True: G_ValidateWildStr('abc12345_inf@_XL.dat', 'abc*_???@_*.d*at'). }

function G_ValidateWildStr(const S, Mask: AnsiString; MaskChar: AnsiChar = '?';
  WildCard: AnsiChar = '*'): Boolean;

{ G_ValidateWildText проверяет, удовлетворяет ли строка S маске Mask, полагая,
  что каждый символ MaskChar в строке Mask может быть заменен любым другим
  символом в строке S, а символы WildCard могут быть заменены любым количеством
  произвольных символов. При сравнении регистр символом не принимается во
  внимание, т.е. большие и маленькие буквы не различаются. Символ WildCard
  должен быть отличен от #0. Если строка S удовлетворяет маске, функция
  возвращает True, иначе False. Например, следующий вызов функции вернет True:
  G_ValidateWildText('ABC12345_inf@_XL.DAT', 'abc*_???@_*.d*aT'). }

function G_ValidateWildText(const S, Mask: AnsiString; MaskChar: AnsiChar = '?';
  WildCard: AnsiChar = '*'): Boolean;


{ Другие функции для работы со строками }

{ G_CountOfChar подсчитывает и возвращает количество вхождений символа C
  в строку S. }

function G_CountOfChar(const S: AnsiString; C: AnsiChar): Integer;

{ G_CountOfChars подсчитывает в строке S количество вхождений символов,
  присутствующих в множестве CharSet, и возвращает полученное число как
  результат функции. }

function G_CountOfChars(const S: AnsiString; const CharSet: TSysCharSet): Integer;

{ G_IsEmpty возвращает True, если строка S содержит только пробелы и
  управляющие символы (меньшие пробела), иначе возвращает False. }

function G_IsEmpty(const S: AnsiString): Boolean;

{ G_PadLeft дополняет строку S слева до длины Length символами PaddingChar
  и возвращает полученную строку как результат функции. Если длина строки S
  больше или равна Length, функция просто возвращает исходная строку. }

function G_PadLeft(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar = ' '): AnsiString;

{ G_PadRight дополняет строку S справа до длины Length символами PaddingChar
  и возвращает полученную строку как результат функции. Если длина строки S
  больше или равна Length, функция просто возвращает исходная строку. }

function G_PadRight(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar = ' '): AnsiString;

{ G_Center центрирует строку S относительно длины Length символами PaddingChar
  и возвращает полученную строку как результат функции. Если длина строки S
  больше или равна Length, функция просто возвращает исходная строку. }

function G_Center(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar = ' '): AnsiString;

{ G_Duplicate возвращает строку, состоящую из Count копий строки S. }

function G_Duplicate(const S: AnsiString; Count: Integer): AnsiString;

{ G_StrMoveL копирует содержимое строки Source в строку Dest. Максимальное
  число копируемых символов равно maxL. Длина строки Dest устанавливается
  равной числу скопированных символов. Память для строки Dest должна быть
  распределена заранее вызовом SetString или SetLength размером не менее
  maxL символов. }

procedure G_StrMoveL(const Source: AnsiString; var Dest: AnsiString; maxL: Cardinal);

{ G_StrReverse переворачивает строку S так, что первый символ становится
  последним, второй -  предпоследним и т.д. Исходная строка изменяется и
  возвращается как результат функции. }

procedure G_StrReverse(var S: AnsiString); overload;
function G_StrReverse(P: Pointer): Pointer; overload;

{ G_PCharLen возвращает длину строки типа PAnsiChar, адресуемой параметром P.
  Эта функция работает значительно быстрее стандартной StrLen. Автором
  реализации является Robert Lee (rhlee@optimalcode.com). }

function G_PCharLen(P: PAnsiChar): Integer;


{ Класс TStringBuilder для динамического создания или изменения строк
  произвольной длины }

type
  TStringBuilder = class(TObject)
  private
    FLength: Integer;
    FCapacity: Integer;
    FChars: PChars;
    procedure SetLength(NewLength: Integer);
    procedure SetCapacity(NewCapacity: Integer);
  public

  { Следующий конструктор Create создает экземпляр класса TStringBuilder
    и распределяет память под 16 символов. }

    constructor Create; overload;

  { Следующий конструктор Create создает экземпляр класса TStringBuilder
    и распределяет память под Capacity символов. }

    constructor Create(Capacity: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TStringBuilder
    и помещает в него значение строки S. }

    constructor Create(const S: AnsiString); overload;

  { Следующий конструктор Create создает экземпляр класса TStringBulder
    и помещает в него Count символов строки S, начиная с символа с номером
    StartIndex (нумерация символов с единицы). }

    constructor Create(const S: AnsiString; StartIndex, Count: Integer); overload;

  { Следующий конструктор Create создает экземпляр класса TStringBuilder
    и помещает в него L символов, адресуемых указателем P. }

    constructor Create(P: Pointer; L: Integer); overload;

  { Деструктор Destroy освобождает память, занятую экземпляром класса
    TStringBuilder, включая внутренний массив, используемый для хранения
    символов строки. }

    destructor Destroy; override;

  {  }

    procedure CopyFrom(ASource: TStringBuilder);

  { Свойства }

  { Свойство Length возвращает или устанавливает текущую длину строки. При
    увеличении длины, символы за пределами исходной длины строки, т.е.
    добавленные символы, не инициализируются. }

    property Length: Integer read FLength write SetLength;

  { Свойство Capacity возвращает или устанавливает количество символов, под
    которые распределена память во внутреннем массиве Chars. }

    property Capacity: Integer read FCapacity write SetCapacity;

  { Свойство Chars возвращает ссылку на внутренний массив, используемый для
    хранения символов строки. Эта ссылка изменяется при каждом
    перераспределении памяти, которое происходит при прямом или косвенном
    изменении значения свойства Capacity. }

    property Chars: PChars read FChars;

  { Методы }

  { После вызова метода EnsureCapacity размер внутреннего массива Chars будет
    достаточен для хранения, как минимум, Capacity символов. }

    procedure EnsureCapacity(Capacity: Integer);

  { Метод Fill заполняет Count символов строки, начиная с позиции Index
    (нумерация с единицы), символом C. }

    procedure Fill(C: AnsiChar; Index, Count: Integer);

  { Следующая функция Append добавляет к строке десятичное представление
    числа N типа Integer и возвращает ссылку на данный экземпляр класса
    TStringBuilder. }

    function Append(N: Integer): TStringBuilder; overload;

  { Следующая функция Append добавляет к строке десятичное (если параметр
    Hexadecimal равен False) или шестнадцатеричное (если параметр Hexadecimal
    равен True) представление числа N. Параметр Digits задает минимальное
    количество цифр в строковом представлении числа. При необходимости число
    дополняется нулями слева. Функция возвращает ссылку на данный экземпляр
    класса TStringBuilder. }

    function Append(N: LongWord; Digits: Integer; Hexadecimal: Boolean = False): TStringBuilder; overload;

  { Следующая функция Append добавляет к строке десятичное представление числа
    N типа Int64 и возвращает ссылку на данный экземпляр класса TStringBuilder. }

    function Append(N: Int64): TStringBuilder; overload;

  { Следующая функция Append добавляет символ C в конец строки и возвращает
    ссылку на данный экземпляр класса TStringBuilder. }

    function Append(C: AnsiChar): TStringBuilder; overload;

  { Следующая функция Append добавляет Count копий символа C в конец строки и
    возвращает ссылку на данный экземпляр класса TStringBuilder. }

    function Append(C: AnsiChar; Count: Integer): TStringBuilder; overload;

  { Следующая функция Append добавляет строку S в конец данной строки и
    возвращает ссылку на данный экземпляр класса TStringBuilder. }

    function Append(const S: AnsiString): TStringBuilder; overload;

  { Следующая функция Append добавляет Count копий строки S в конец данной
    строки и возвращает ссылку на данный экземпляр класса TStringBuilder.}

    function Append(const S: AnsiString; Count: Integer): TStringBuilder; overload;

  { Следующая функция Append добавляет фрагмент строки S, начиная с позиции
    StartIndex (нумерация с единицы), длиной Count символов в конец данной
    строки. Функция возвращает ссылку на данный экземпляр класса
    TStringBuilder. }

    function Append(const S: AnsiString; StartIndex, Count: Integer): TStringBuilder; overload;

  { Следующая функция Append добавляет в конец строки L символов, адресуемых
    указателем P, и возвращает ссылку на данный экземпляр класса TStringBuilder. }

    function Append(P: Pointer; L: Integer): TStringBuilder; overload;

  { Следующая функция AppendLine добавляет в конец строки символы перевода
    строки #13#10 и возвращает ссылку на данный экземпляр TStringBuilder. }

    function AppendLine: TStringBuilder; overload;

  { Следующая функция AppendLine добавляет строку S в конец данной строки,
    а затем добавляет символы перевода строки #13#10 и возвращает ссылку
    на данный экземпляр класса TStringBuilder. }

    function AppendLine(const S: AnsiString): TStringBuilder; overload;

  { Следующий метод Insert вставляет символ C в позицию Index строки (нумерация
    с единицы). }

    procedure Insert(Index: Integer; C: AnsiChar); overload;

  { Следующий метод Insert вставляет Count копий символа C в позицию Index
    строки (нумерация с единицы). }

    procedure Insert(Index: Integer; C: AnsiChar; Count: Integer); overload;

  { Следующий метод Insert вставляет строку S в позицию Index данной строки
    (нумерация с единицы). }

    procedure Insert(Index: Integer; const S: AnsiString); overload;

  { Следующий метод Insert вставляет Count копий строки S в позицию Index
    данной строки (нумерация с единицы). }

    procedure Insert(Index: Integer; const S: AnsiString; Count: Integer); overload;

  { Следующий метод Insert вставляет фрагмент строки S, начиная с позиции
    StartIndex (нумерация с единицы), длиной Count символов в позицию Index
    данной строки (нумерация с единицы). }

    procedure Insert(Index: Integer; const S: AnsiString; StartIndex, Count: Integer); overload;

  { Следующий метод Insert вставляет L символов, адресуемых указателем P,
    в позицию Index данной строки (нумерация с единицы). }

    procedure Insert(Index: Integer; P: Pointer; L: Integer); overload;

  { Метод Reverse обращает текущее значение строки таким образом, что первые
    символы становятся последними и наоборот. Если указаны параметры Index и
    Count, то обращается фрагмент строки длиной Count символов, начиная с
    позиции Index (нумерация с единицы). }

    procedure Reverse; overload;
    procedure Reverse(Index, Count: Integer); overload;

  { Метод Delete удаляет из строки фрагмент длиной Count символов, начиная с
    позиции Index (нумерация с единицы). }

    procedure Delete(Index, Count: Integer);

  { Метод Clear очищает строку таким образом, что ее длина становится равной
    нулю. Свойство Capacity при этом не изменяется, т.е. память, распределенная
    под внутренний массив символов Chars не освобождается. }

    procedure Clear;

  { Функция ToString возвращает строку типа AnsiString, соответствующую строке,
    представленной экземпляром класса TStringBuilder. Если заданы параметры
    Index и Count, возвращается строка типа AnsiString, содержащая фрагмент
    данной строки длиной Count символов, начиная с позиции Index (нумерация
    с единицы). }

    function ToString: AnsiString;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}
    function ToString(Index, Count: Integer): AnsiString;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Функция Equals возвращает True, если текущее значение строки равно
    соответствующему значению, представленному экземпляром класса
    TStringBuilder, переданным параметром SB. Если две строки отличаются друг
    от друга, функция возвращает False. }

    function Equals(SB: TStringBuilder): Boolean;{$IFDEF UNICODE} reintroduce; overload;{$ENDIF}

  { Метод TrimToSize перераспределяет память, занятую под внутренний массив
    Chars таким образом, чтобы содержать только занятое в настоящий момент
    количество символов. }

    procedure TrimToSize;

  { Функция Clone возвращает экземпляр класса TStringBuilder, который является
    копией данной строки. }

    function Clone: TStringBuilder;
  end;


{ Ускоренная работа со строками через менеджер памяти AcedMemory }

{DEFINE USE_ACED_MEMORY} // Определить при использовании AcedMemory

{$IFDEF UNICODE}
{$IFDEF USE_ACED_MEMORY}

{ G_NewStr создает и возвращает новый экземпляр строки и резервирует место
  для возможного расширения строки с помощью G_Append. Параметр Capacity
  задает максимальное количество символов, которое может содержать строка. }

function G_NewStr(const S: AnsiString): AnsiString; overload;
function G_NewStr(Capacity: Integer): AnsiString; overload;
function G_NewStr(const S: AnsiString; Capacity: Integer): AnsiString; overload;
function G_NewStr(const S1, S2: AnsiString): AnsiString; overload;
function G_NewStr(const S1, S2: AnsiString; Capacity: Integer): AnsiString; overload;
function G_NewStr(const S1, S2, S3: AnsiString): AnsiString; overload;
function G_NewStr(const S1, S2, S3: AnsiString; Capacity: Integer): AnsiString; overload;
function G_NewStr(const S1, S2, S3, S4: AnsiString): AnsiString; overload;
function G_NewStr(const S1, S2, S3, S4: AnsiString; Capacity: Integer): AnsiString; overload;

{ Аналогично вызову G_NewStr(S1, Copy(S2, Index2, Count2)). }

function G_NewStr(const S1, S2: AnsiString; Index2, Count2: Integer): AnsiString; overload;

{ G_Append добавляет в конец строки S одну, две, три строки или один символ.
  Строка S при этом изменяется. }

procedure G_Append(var S: AnsiString; const S1: AnsiString); overload;
procedure G_Append(var S: AnsiString; const S1, S2: AnsiString); overload;
procedure G_Append(var S: AnsiString; const S1, S2, S3: AnsiString); overload;
procedure G_Append(var S: AnsiString; C: AnsiChar); overload;

{ Аналогично вызову G_Append(S, Copy(S1, Index1, Count1)). }

procedure G_Append(var S: AnsiString; const S1: AnsiString; Index1: Integer;
  Count1: Integer = MaxInt); overload;

{ Добавляет символы перевода строки #13, #10 в конец строки S. }

procedure G_AppendLine(var S: AnsiString); overload;
procedure G_AppendLine(var S: AnsiString; const S1: AnsiString); overload;

{ Аналогично вызову Insert(Copy(S1, Index1, Count1), S, Index). }

procedure G_Insert(const S1: AnsiString; var S: AnsiString; Index, Index1: Integer;
  Count1: Integer = MaxInt); overload;

{$ENDIF}
{$ENDIF}


{ Полезные стандартные строковые функции }

{ StringOfChar возвращает строку, состоящую из Count символов Ch. Например,
   StringOfChar('A', 10) вернет строку 'AAAAAAAAAA'. (модуль System)

function StringOfChar(Ch: AnsiChar; Count: Integer): AnsiString; }

{ SetString устанавливает S таким образом, чтобы она указывала на заново
  распределенную строку длиной Len символов. Если параметр Buffer равен nil,
  содержимое новой строки остается неопределенным, иначе SetString копирует
  Len символов из Buffer в новую строку. Если для размещения строки
  недостаточно памяти возникает исключительная ситуация EOutOfMemory. Вызов
  функции SetString гарантирует, что S будет уникальной строкой, т.е.
  счетчик ссылок этой строки будет равен единице.

  Для размещения в памяти новой строки S длиной Len символов используйте вызов
  процедуры SetString: SetString(S, nil, Len). (модуль System)

procedure SetString(var S: AnsiString; Buffer: PAnsiChar; Len: Integer); }

{ SetLength перераспределяет память под строку адресуемую параметром S, таким
  образом, чтобы ее длина равнялась NewLength. Существующие символы в строке
  сохраняются, а содержимое дополнительной выделенной памяти будет
  неопределенным. Если необходимое количество памяти не может быть выделено,
  вызывается исключение EOutOfMemory. Вызов SetLength гарантирует, что после
  него строка S будет являться уникальной, т.е. ее счетчик ссылок будет равен
  единице. (модуль System)

procedure SetLength(var S; NewLength: Integer); }

{ Copy возвращает подстроку из строки. S - это исходная строка (выражение типа
  AnsiString), Index и Count - целочисленные выражения. Copy возвращает подстроку,
  содержащую Count символов, начиная с S[Index]. Если Index больше, чем длина
  строки S, Copy возвращает пустую строку. Если Count задает больше символов,
  чем их есть до конца строки, то возвращаются подстрока, начиная с S[Index]
  и до конца строки. (модуль System)

function Copy(S; Index, Count: Integer): AnsiString; }

{ Insert вставляет подстроку в строку, начиная с указанного символа. Подстрока
  Source вставляется в строку S, начиная с символа S[Index]. Index - номер
  символа, с которого начинается вставка. Если Index больше длины строки S,
  подстрока Source просто добавляется в конец строки S. (модуль System)

procedure Insert(Source: AnsiString; var S: AnsiString; Index: Integer); }

{ UniqueString гарантирует, что данная строка Str будет иметь счетчик ссылок
  равный единице. Вызов этой процедуры необходим, когда в программе строка
  приводится к типу PAnsiChar, а затем содержимое строки изменяется. (модуль System)

procedure UniqueString(var Str: AnsiString); }

{ WrapText находит в строке Line символы, входящие во множество BreakChars,
  и добавляет перевод строки, переданный параметром BreakStr, после последнего
  символа из BreakChars перед позицией MaxCol. MaxCol - это максимальная длина
  строки (до символов перевода строки). Если параметры BreakStr и BreakChars
  опущены, функция WrapText ищет в строке Line пробелы, символы тире и символы
  табуляции, в позиции которых могут быть добавлены разрывы строки в виде пары
  символов #13#10. Эта функция не вставляет разрывы строки во фрагменты,
  заключенные в одиночные или двойные ковычки. (модуль SysUtils)

function WrapText(const Line, BreakStr: AnsiString; BreakChars: TSysCharSet;
  MaxCol: Integer): AnsiString; overload;
function WrapText(const Line: AnsiString; MaxCol: Integer = 45): AnsiString; overload; }

{ AdjustLineBreaks заменяет все переводы строки в строке S на правильную
  последовательность символов CR/LF. Эта функция превращает любой символ CR,
  за которым не следует символ LF, и любой символ LF, перед которым не стоит
  символ CR, в пару символов CR/LF. Она также преобразует пары символов LF/CR
  в пары CR/LF. Последовательность LF/CR обычно используется в текстовых
  файлах Unix. (модуль SysUtils)

function AdjustLineBreaks(const S: AnsiString): AnsiString; }

{ QuotedStr заключает переданную в нее строку в одинарные кавычки ('). Они
  добавляются в начале и в конце строки. Кроме того, каждый символ одинарной
  кавычки внутри строки удваивается. (модуль SysUtils)

function QuotedStr(const S: AnsiString): AnsiString; }


{ Кодовые таблицы для изменения регистра символов и перекодировки строк из
  OEM в ANSI и наоборот могут формироваться динамически при запуске программы
  в соответствии с текущими настройками на компьютере пользователя или могут
  задаваться при компиляции программы как константные массивы. Если следующий
  символ USE_DYNAMIC_TABLES определен, используются динамические таблицы,
  иначе - статические. }

{DEFINE USE_DYNAMIC_TABLES}

{$IFNDEF USE_DYNAMIC_TABLES}

{ Приведенные ниже статические таблицы соответствуют русской кодировке WIN1251.
  Таблицы для других кодировок могут быть получены следующим образом:
  устанавливаете в Control Panel нужный вам язык, компилируете и запускаете
  следующую программу:

  program MakeTables;
  uses
    Windows, SysUtils;
  var
    Ch, N: Byte;
    I, J: Integer;
    F: TextFile;
  begin
    AssignFile(F, 'CsTables.txt');
    Rewrite(F);
    WriteLn(F);
    WriteLn(F, '  ToUpperChars: array[0..255] of AnsiChar =');
    Write(F,'    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        Ch := N;
        CharUpperBuff(@Ch, 1);
        Write(F, '#$' + IntToHex(Ch, 2));
        if N <> 255 then
          Write(F, ',')
        else
          Write(F, ');');
      end;
      WriteLn(F);
      Write(F, '     ');
    end;
    WriteLn(F);
    WriteLn(F, '  ToLowerChars: array[0..255] of AnsiChar =');
    Write(F, '    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        Ch := N;
        CharLowerBuff(@Ch, 1);
        Write(F, '#$' + IntToHex(Ch, 2));
        if N <> 255 then
          Write(F, ',')
        else
          Write(F, ');');
      end;
      WriteLn(F);
      Write(F, '     ');
    end;
    WriteLn(F);
    WriteLn(F, '  ToOemChars: array[0..255] of AnsiChar =');
    Write(F, '    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        CharToOemBuff(@N, @Ch, 1);
        Write(F, '#$' + IntToHex(Ch, 2));
        if N <> 255 then
          Write(F, ',')
        else
          Write(F, ');');
      end;
      WriteLn(F);
      Write(F, '     ');
    end;
    WriteLn(F);
    WriteLn(F, '  ToAnsiChars: array[0..255] of AnsiChar =');
    Write(F, '    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        OemToCharBuff(@N, @Ch, 1);
        Write(F, '#$' + IntToHex(Ch, 2));
        if N <> 255 then
          Write(F, ',')
        else
          Write(F, ');');
      end;
      WriteLn(F);
      Write(F, '     ');
    end;
    CloseFile(F);
  end.

  В текущем каталоге находите файл CsTables.txt и как есть вставляете его после
  const. Компилируя этот модуль с ключом $J+, вы получаете возможность изменять
  статические таблицы перекодировки во время исполнения программы (динамические
  таблицы вы можете изменять независимо от каких-либо ключей).
}

const
  ToUpperChars: array[0..255] of AnsiChar =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$80,#$81,#$82,#$81,#$84,#$85,#$86,#$87,#$88,#$89,#$8A,#$8B,#$8C,#$8D,#$8E,#$8F,
     #$80,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$8A,#$9B,#$8C,#$8D,#$8E,#$8F,
     #$A0,#$A1,#$A1,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
     #$B0,#$B1,#$B2,#$B2,#$A5,#$B5,#$B6,#$B7,#$A8,#$B9,#$AA,#$BB,#$A3,#$BD,#$BD,#$AF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF);

  ToLowerChars: array[0..255] of AnsiChar =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$90,#$83,#$82,#$83,#$84,#$85,#$86,#$87,#$88,#$89,#$9A,#$8B,#$9C,#$9D,#$9E,#$9F,
     #$90,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$9A,#$9B,#$9C,#$9D,#$9E,#$9F,
     #$A0,#$A2,#$A2,#$BC,#$A4,#$B4,#$A6,#$A7,#$B8,#$A9,#$BA,#$AB,#$AC,#$AD,#$AE,#$BF,
     #$B0,#$B1,#$B3,#$B3,#$B4,#$B5,#$B6,#$B7,#$B8,#$B9,#$BA,#$BB,#$BC,#$BE,#$BE,#$BF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF);

  ToOemChars: array[0..255] of AnsiChar =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$3F,#$3F,#$27,#$3F,#$22,#$3A,#$C5,#$D8,#$3F,#$25,#$3F,#$3C,#$3F,#$3F,#$3F,#$3F,
     #$3F,#$27,#$27,#$22,#$22,#$07,#$2D,#$2D,#$3F,#$54,#$3F,#$3E,#$3F,#$3F,#$3F,#$3F,
     #$FF,#$F6,#$F7,#$3F,#$FD,#$3F,#$B3,#$15,#$F0,#$63,#$F2,#$3C,#$BF,#$2D,#$52,#$F4,
     #$F8,#$2B,#$3F,#$3F,#$3F,#$E7,#$14,#$FA,#$F1,#$FC,#$F3,#$3E,#$3F,#$3F,#$3F,#$F5,
     #$80,#$81,#$82,#$83,#$84,#$85,#$86,#$87,#$88,#$89,#$8A,#$8B,#$8C,#$8D,#$8E,#$8F,
     #$90,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$9A,#$9B,#$9C,#$9D,#$9E,#$9F,
     #$A0,#$A1,#$A2,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF);

  ToAnsiChars: array[0..255] of AnsiChar =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$A4,
     #$10,#$11,#$12,#$13,#$B6,#$A7,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$2D,#$2D,#$2D,#$A6,#$2B,#$A6,#$A6,#$AC,#$AC,#$A6,#$A6,#$AC,#$2D,#$2D,#$2D,#$AC,
     #$4C,#$2B,#$54,#$2B,#$2D,#$2B,#$A6,#$A6,#$4C,#$E3,#$A6,#$54,#$A6,#$3D,#$2B,#$A6,
     #$A6,#$54,#$54,#$4C,#$4C,#$2D,#$E3,#$2B,#$2B,#$2D,#$2D,#$2D,#$2D,#$A6,#$A6,#$2D,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF,
     #$A8,#$B8,#$AA,#$BA,#$AF,#$BF,#$A1,#$A2,#$B0,#$95,#$B7,#$76,#$B9,#$A4,#$A6,#$A0);

{$ELSE}

var
  ToUpperChars: array[0..255] of AnsiChar;
  ToLowerChars: array[0..255] of AnsiChar;
  ToOemChars: array[0..255] of AnsiChar;
  ToAnsiChars: array[0..255] of AnsiChar;

{$ENDIF}

implementation

uses Windows, AcedBinary, AcedCommon
{$IFDEF USE_ACED_MEMORY}
, AcedMemory
{$ENDIF}
;

{ Функции для сравнения строк }

function G_CompareStr(const S1, S2: AnsiString): Integer;
asm
        CMP     EAX,EDX
        JE      @@ex
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EAX
        MOVZX   EAX,BYTE PTR [EAX]
        MOVZX   ECX,BYTE PTR [EDX]
        SUB     EAX,ECX
        JE      @@m
        POP     ECX
        RET
@@ex:   XOR     EAX,EAX
        RET
@@m:    POP     EAX
        INC     EAX
        INC     EDX
@@0:    TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX]
        MOV     CH,BYTE PTR [EDX]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+1]
        MOV     CH,BYTE PTR [EDX+1]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+2]
        MOV     CH,BYTE PTR [EDX+2]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+3]
        MOV     CH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     CL,CH
        JE      @@0
@@ne:   MOVZX   EAX,CL
        MOVZX   EDX,CH
        SUB     EAX,EDX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareStr(P1, P2: PAnsiChar): Integer;
asm
        CMP     EAX,EDX
        JE      @@ex
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EAX
        MOVZX   EAX,BYTE PTR [EAX]
        MOVZX   ECX,BYTE PTR [EDX]
        SUB     EAX,ECX
        JE      @@m
        POP     ECX
        RET
@@ex:   XOR     EAX,EAX
        RET
@@m:    POP     EAX
        INC     EAX
        INC     EDX
@@0:    TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX]
        MOV     CH,BYTE PTR [EDX]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+1]
        MOV     CH,BYTE PTR [EDX+1]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+2]
        MOV     CH,BYTE PTR [EDX+2]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+3]
        MOV     CH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     CL,CH
        JE      @@0
@@ne:   MOVZX   EAX,CL
        MOVZX   EDX,CH
        SUB     EAX,EDX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareStrL(const S1, S2: AnsiString; maxL: Cardinal): Integer;
asm
        CMP     EAX,EDX
        JE      @@1
        TEST    ECX,ECX
        JE      @@1
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX-4]
        MOV     ESI,[EDX-4]
        SUB     EBX,ESI
        JG      @@w1
        ADD     ESI,EBX
@@w1:   CMP     ECX,ESI
        JA      @@fc
@@dn:   POP     ESI
@@lp:   DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX]
        MOV     BH,BYTE PTR [EDX]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+1]
        MOV     BH,BYTE PTR [EDX+1]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+2]
        MOV     BH,BYTE PTR [EDX+2]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+3]
        MOV     BH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     BL,BH
        JE      @@lp
@@ne:   MOVZX   EAX,BL
        MOVZX   EDX,BH
        SUB     EAX,EDX
        POP     EBX
        RET
@@fc:   LEA     ECX,[ESI+1]
        JMP     @@dn
@@1:    XOR     EAX,EAX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareStrL(P1, P2: PAnsiChar; maxL: Cardinal): Integer;
asm
        CMP     EAX,EDX
        JE      @@1
        TEST    ECX,ECX
        JE      @@1
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX-4]
        MOV     ESI,[EDX-4]
        SUB     EBX,ESI
        JG      @@w1
        ADD     ESI,EBX
@@w1:   CMP     ECX,ESI
        JA      @@fc
@@dn:   POP     ESI
@@lp:   DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX]
        MOV     BH,BYTE PTR [EDX]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+1]
        MOV     BH,BYTE PTR [EDX+1]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+2]
        MOV     BH,BYTE PTR [EDX+2]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+3]
        MOV     BH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     BL,BH
        JE      @@lp
@@ne:   MOVZX   EAX,BL
        MOVZX   EDX,BH
        SUB     EAX,EDX
        POP     EBX
        RET
@@fc:   LEA     ECX,[ESI+1]
        JMP     @@dn
@@1:    XOR     EAX,EAX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareText(const S1, S2: AnsiString): Integer;
asm
        CMP     EAX,EDX
        JE      @@ex
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        JMP     @@1
@@ex:   XOR     EAX,EAX
        RET
@@0:    TEST    AL,AL
        JE      @@4
        INC     ESI
        INC     EDI
@@1:    MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        CMP     AL,DL
        JE      @@0
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@0
        MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@4:    POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareText(P1, P2: PAnsiChar): Integer;
asm
        CMP     EAX,EDX
        JE      @@ex
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        JMP     @@1
@@ex:   XOR     EAX,EAX
        RET
@@0:    TEST    AL,AL
        JE      @@4
        INC     ESI
        INC     EDI
@@1:    MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        CMP     AL,DL
        JE      @@0
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@0
        MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@4:    POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareTextL(const S1, S2: AnsiString; maxL: Cardinal): Integer;
asm
        CMP     EAX,EDX
        JE      @@5
        TEST    ECX,ECX
        JE      @@5
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EAX-4]
        MOV     EDI,[EDX-4]
        SUB     ESI,EDI
        JG      @@w1
        ADD     EDI,ESI
@@w1:   CMP     ECX,EDI
        JA      @@fc
@@dn:   MOV     ESI,EAX
        MOV     EDI,EDX
@@lp:   DEC     ECX
        JS      @@zq
        MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        INC     ESI
        INC     EDI
        CMP     AL,DL
        JE      @@lp
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@lp
@@ne:   MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@fc:   LEA     ECX,[EDI+1]
        JMP     @@dn
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;

function G_CompareTextL(P1, P2: PAnsiChar; maxL: Cardinal): Integer;
asm
        CMP     EAX,EDX
        JE      @@5
        TEST    ECX,ECX
        JE      @@5
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EAX-4]
        MOV     EDI,[EDX-4]
        SUB     ESI,EDI
        JG      @@w1
        ADD     EDI,ESI
@@w1:   CMP     ECX,EDI
        JA      @@fc
@@dn:   MOV     ESI,EAX
        MOV     EDI,EDX
@@lp:   DEC     ECX
        JS      @@zq
        MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        INC     ESI
        INC     EDI
        CMP     AL,DL
        JE      @@lp
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@lp
@@ne:   MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@fc:   LEA     ECX,[EDI+1]
        JMP     @@dn
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;

function G_SameStr(const S1, S2: AnsiString): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@qt2
        TEST    EDX,EDX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
@@qt2:  RET
@@01:   PUSH    EBX
        SUB     ECX,8
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        MOV     EBX,DWORD PTR [EAX+ECX+4]
        CMP     EBX,DWORD PTR [EDX+ECX+4]
        JNE     @@zq
        SUB     ECX,8
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+32]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq
@@t4:   MOV     EBX,DWORD PTR [EAX]
        CMP     EBX,DWORD PTR [EDX]
        JNE     @@zq
@@eq:   POP     EBX
@@08:   MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
        POP     EBX
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@07:   XOR     EAX,EAX
end;

function G_SameStr(P1, P2: Pointer): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@qt2
        TEST    EDX,EDX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
@@qt2:  RET
@@01:   PUSH    EBX
        SUB     ECX,8
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        MOV     EBX,DWORD PTR [EAX+ECX+4]
        CMP     EBX,DWORD PTR [EDX+ECX+4]
        JNE     @@zq
        SUB     ECX,8
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+32]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq
@@t4:   MOV     EBX,DWORD PTR [EAX]
        CMP     EBX,DWORD PTR [EDX]
        JNE     @@zq
@@eq:   POP     EBX
@@08:   MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
        POP     EBX
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@07:   XOR     EAX,EAX
end;

function G_SameStrL(const S1, S2: AnsiString; maxL: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX-4]
        MOV     ESI,[EDX-4]
        SUB     EBX,ESI
        JG      @@w1
        ADD     ESI,EBX
@@w1:   CMP     ECX,ESI
        JA      @@fc
@@dn:   SUB     ECX,4
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        SUB     ECX,4
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+16]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
@@eq:   POP     ESI
        POP     EBX
@@08:   MOV     EAX,1
        RET
@@fc:   MOV     ECX,ESI
        TEST    EBX,EBX
        JE      @@dn
@@zq:   POP     ESI
        POP     EBX
@@07:   XOR     EAX,EAX
@@09:
end;

function G_SameText(const S1, S2: AnsiString): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@im
        XOR     EAX,EAX
        RET
@@im:   TEST    ECX,ECX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
@@00:   DEC     ECX
        JS      @@qt
@@01:   MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@00
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@00
        POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@09:   RET
@@qt:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;

function G_SameText(P1, P2: Pointer): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@im
        XOR     EAX,EAX
        RET
@@im:   TEST    ECX,ECX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
@@00:   DEC     ECX
        JS      @@qt
@@01:   MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@00
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@00
        POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@09:   RET
@@qt:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;

function G_SameTextL(const S1, S2: AnsiString; maxL: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@xx
        TEST    EDX,EDX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EAX-4]
        MOV     EDI,[EDX-4]
        SUB     ESI,EDI
        JG      @@w1
        ADD     EDI,ESI
@@w1:   CMP     ECX,EDI
        JA      @@fc
@@dn:   TEST    ECX,ECX
        JE      @@zq
        MOV     ESI,EAX
        MOV     EDI,EDX
@@0:    DEC     ECX
        JS      @@eq
@@1:    MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@0
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@0
@@zq:   POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@xx:   RET
@@fc:   MOV     ECX,EDI
        TEST    ESI,ESI
        JE      @@dn
        JMP     @@zq
@@eq:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;

{ Функции для изменения регистра символов }

function G_CharToUpper(C: AnsiChar): AnsiChar;
asm
        MOVZX   EDX,AL
        MOV     AL,BYTE PTR [EDX+ToUpperChars]
end;

function G_CharToLower(C: AnsiChar): AnsiChar;
asm
        MOVZX   EDX,AL
        MOV     AL,BYTE PTR [EDX+ToLowerChars]
end;

procedure G_StrToUpper(var S: AnsiString);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@2
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ECX
        JNS     @@1
@@2:
end;

function G_StrToUpper(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToUpperChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;

procedure G_StrToLower(var S: AnsiString);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@2
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToLowerChars]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ECX
        JNS     @@1
@@2:
end;

function G_StrToLower(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToLowerChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;

function G_StrToUpperL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToUpperChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;

function G_StrToLowerL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToLowerChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;

function G_StrToUpperMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToUpperChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;

function G_StrToLowerMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToLowerChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;

function G_ToUpper(const S: AnsiString): AnsiString;
var
  L: Integer;
begin
  L := Length(S);
  SetString(Result, nil, L);
  G_StrToUpperMoveL(Pointer(S), Pointer(Result), L);
end;

function G_ToLower(const S: AnsiString): AnsiString;
var
  L: Integer;
begin
  L := Length(S);
  SetString(Result, nil, L);
  G_StrToLowerMoveL(Pointer(S), Pointer(Result), L);
end;

{ Перекодировка строк из DOS в Windows и обратно }

procedure G_StrToAnsi(var S: AnsiString);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@2
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToAnsiChars]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ECX
        JNS     @@1
@@2:
end;

function G_StrToAnsi(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToAnsiChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;

procedure G_StrToOem(var S: AnsiString);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@2
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToOemChars]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ECX
        JNS     @@1
@@2:
end;

function G_StrToOem(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToOemChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;

function G_StrToAnsiL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToAnsiChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;

function G_StrToOemL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToOemChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;

function G_StrToAnsiMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToAnsiChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;

function G_StrToOemMoveL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToOemChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;

function G_ToAnsi(const OemStr: AnsiString): AnsiString;
var
  L: Integer;
begin
  L := Length(OemStr);
  SetString(Result, nil, L);
  G_StrToAnsiMoveL(Pointer(OemStr), Pointer(Result), L);
end;

function G_ToOem(const AnsiStr: AnsiString): AnsiString;
var
  L: Integer;
begin
  L := Length(AnsiStr);
  SetString(Result, nil, L);
  G_StrToOemMoveL(Pointer(AnsiStr), Pointer(Result), L);
end;

{ Поиск, замена и удаление подстрок и отдельных символов }

function G_PosStr(const FindStr, SourceStr: AnsiString; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        SUB     EDX,ECX
        JNG     @@qt0
        XCHG    EAX,EDX
        ADD     EDI,ECX
        MOV     ECX,EAX
        JMP     @@nx
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qt0
@@nx:   MOV     EBX,EDX
        MOV     AL,BYTE PTR [ESI]
@@lp1:  CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        SUB     EAX,[ESP]
        POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;

function G_PosText(const FindStr, SourceStr: AnsiString; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        PUSH    EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        PUSH    EAX
        SUB     EDX,ECX
        JNG     @@qtx
        ADD     EDI,ECX
        MOV     ECX,EDX
        MOV     EDX,EAX
        MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
@@lp1:  MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qtx:  ADD     ESP,$08
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
        RET
@@ms:   MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOV     EDX,[ESP]
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     BL,BYTE PTR [ESI+EDX]
        MOV     AH,BYTE PTR [EDI+EDX]
        CMP     BL,AH
        JE      @@eq
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOVZX   EBX,AH
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JNE     @@ms
@@eq:   DEC     EDX
        JNZ     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        POP     ECX
        SUB     EAX,[ESP]
        POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;

function G_LastPosStr(const FindStr, SourceStr: AnsiString; NextPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        DEC     ECX
        JLE     @@qt0
        MOV     ESI,EAX
        LEA     EDI,[EDX-1]
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        CMP     ECX,EDX
        JL      @@nu
        MOV     ECX,EDX
@@nu:   SUB     ECX,EAX
        JLE     @@qt0
        JMP     @@ft
@@nx:   SUB     EDI,ECX
        DEC     ECX
        JE      @@qt0
@@ft:   MOV     DL,BYTE PTR [ESI]
@@lp1:  CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EAX,EAX
        JE      @@fd
        ADD     EDI,ECX
        MOV     EBX,EAX
@@lp2:  MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JNE     @@lp2
@@fd:   MOV     EAX,ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;

function G_LastPosText(const FindStr, SourceStr: AnsiString; NextPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EBP
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        DEC     ECX
        JLE     @@qt0
        MOV     ESI,EAX
        LEA     EDI,[EDX-1]
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        CMP     ECX,EDX
        JL      @@nu
        MOV     ECX,EDX
@@nu:   SUB     ECX,EAX
        JLE     @@qt0
        JMP     @@ft
@@nx:   SUB     EDI,ECX
        DEC     ECX
        JE      @@qt0
@@ft:   MOVZX   EBP,BYTE PTR [ESI]
        MOV     DL,BYTE PTR [EBP+ToUpperChars]
@@lp1:  MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBP
        POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EAX,EAX
        JE      @@fd
        ADD     EDI,ECX
        MOV     EBX,EAX
@@lp2:  MOVZX   EDX,BYTE PTR [ESI+EBX]
        MOVZX   EBP,BYTE PTR [EDI+EBX]
        CMP     EDX,EBP
        JE      @@ws
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JNE     @@nx
@@ws:   DEC     EBX
        JNE     @@lp2
@@fd:   MOV     EAX,ECX
        POP     EBP
        POP     EBX
        POP     EDI
        POP     ESI
end;

function G_CharPos(C: AnsiChar; const S: AnsiString; StartPos: Integer): Integer;
asm
        TEST    EDX,EDX
        JE      @@qt
        PUSH    EDI
        MOV     EDI,EDX
        LEA     EDX,[ECX-1]
        MOV     ECX,[EDI-4]
        SUB     ECX,EDX
        JLE     @@m1
        PUSH    EDI
        ADD     EDI,EDX
        POP     EDX
        REPNE   SCASB
        JNE     @@m1
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        RET
@@m1:   POP     EDI
@@qt:   XOR     EAX,EAX
end;

function G_CharPos(C: AnsiChar; P: Pointer; StartPos: Integer): Integer;
asm
        TEST    EDX,EDX
        JE      @@qt
        PUSH    EDI
        MOV     EDI,EDX
        LEA     EDX,[ECX-1]
        MOV     ECX,[EDI-4]
        SUB     ECX,EDX
        JLE     @@m1
        PUSH    EDI
        ADD     EDI,EDX
        POP     EDX
        REPNE   SCASB
        JNE     @@m1
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        RET
@@m1:   POP     EDI
@@qt:   XOR     EAX,EAX
end;

function G_LastCharPos(C: AnsiChar; const S: AnsiString; NextPos: Integer): Integer;
asm
        TEST    EDX,EDX
        JE      @@qt
        PUSH    EBX
        DEC     ECX
        JS      @@m1
        MOV     EBX,[EDX-4]
        PUSH    EDI
        CMP     ECX,EBX
        JA      @@ch
        TEST    ECX,ECX
        JE      @@m2
@@nx:   LEA     EDI,[EDX+ECX-1]
        STD
        REPNE   SCASB
        INC     EDI
        CLD
        CMP     AL,BYTE PTR [EDI]
        JNE     @@m2
        SUB     EDI,EDX
        MOV     EAX,EDI
        POP     EDI
        INC     EAX
        POP     EBX
        RET
@@ch:   MOV     ECX,EBX
        TEST    EBX,EBX
        JNE     @@nx
@@m2:   POP     EDI
@@m1:   POP     EBX
@@qt:   XOR     EAX,EAX
end;

function G_LastCharPos(C: AnsiChar; P: Pointer; NextPos: Integer): Integer;
asm
        TEST    EDX,EDX
        JE      @@qt
        PUSH    EBX
        DEC     ECX
        JS      @@m1
        MOV     EBX,[EDX-4]
        PUSH    EDI
        CMP     ECX,EBX
        JA      @@ch
        TEST    ECX,ECX
        JE      @@m2
@@nx:   LEA     EDI,[EDX+ECX-1]
        STD
        REPNE   SCASB
        INC     EDI
        CLD
        CMP     AL,BYTE PTR [EDI]
        JNE     @@m2
        SUB     EDI,EDX
        MOV     EAX,EDI
        POP     EDI
        INC     EAX
        POP     EBX
        RET
@@ch:   MOV     ECX,EBX
        TEST    EBX,EBX
        JNE     @@nx
@@m2:   POP     EDI
@@m1:   POP     EBX
@@qt:   XOR     EAX,EAX
end;

procedure G_Paste(var Dest: AnsiString; Pos, Count: Integer; const Source: AnsiString);
var
  L1, L2: Integer;
  P, P1: PByte;
  Temp: AnsiString;
begin
  L1 := Length(Dest);
  Dec(Pos);
  if L1 < Count + Pos then
    Count := L1 - Pos;
  if (Pos >= 0) and (Count >= 0) then
  begin
    L2 := Length(Source);
    if L2 <= Count then
    begin
      if (L2 > 0) or (L1 > Count) then
      begin
        UniqueString(Dest);
        P := Pointer(Dest);
        Inc(P, Pos);
        P1 := P;
        if L2 <> 0 then
        begin
          G_CopyMem(Pointer(Source), P, L2);
          Inc(P, L2);
        end;
        if L2 <> Count then
        begin
          Inc(P1, Count);
          Dec(L1, Count);
          G_MoveMem(P1, P, L1 - Pos + 1);
          PLongWord(LongWord(Dest) - 4)^ := L1 + L2;
        end;
      end else
        Dest := '';
    end else
    begin
      SetString(Temp, nil, L1 - Count + L2);
      P := Pointer(Temp);
      if Pos <> 0 then
      begin
        G_CopyMem(Pointer(Dest), P, Pos);
        Inc(P, Pos);
      end;
      G_CopyMem(Pointer(Source), P, L2);
      Inc(P, L2);
      Dec(L1, Count + Pos);
      if L1 <> 0 then
      begin
        P1 := Pointer(Dest);
        Inc(P1, Pos + Count);
        G_CopyMem(P1, P, L1);
      end;
      Dest := Temp;
    end;
  end;
end;

function G_ReplaceStr(const SourceStr, FindStr, ReplacementStr: AnsiString): AnsiString;
var
  P, PS: PAnsiChar;
  L, L1, L2, Count: Integer;
  I, J, K, M: Integer;
begin
  L1 := Length(FindStr);
  Count := 0;
  I := G_PosStr(FindStr, SourceStr, 1);
  while I <> 0 do
  begin
    Inc(I, L1);
    asm
      PUSH    I
    end;
    Inc(Count);
    I := G_PosStr(FindStr, SourceStr, I);
  end;
  if Count <> 0 then
  begin
    L := Length(SourceStr);
    L2 := Length(ReplacementStr);
    J := L + 1;
    Inc(L, (L2 - L1) * Count);
    if L <> 0 then
    begin
      SetString(Result, nil, L);
      P := Pointer(Result);
      Inc(P, L);
      PS := Pointer(LongWord(SourceStr) - 1);
      for I := 0 to Count - 1 do
      begin
        asm
          POP     K
        end;
        M := J - K;
        if M > 0 then
        begin
          Dec(P, M);
          G_CopyMem(@PS[K], P, M);
        end;
        Dec(P, L2);
        G_CopyMem(Pointer(ReplacementStr), P, L2);
        J := K - L1;
      end;
      Dec(J);
      if J > 0 then
        G_CopyMem(Pointer(SourceStr), Pointer(Result), J);
    end else
    begin
      Result := '';
      for I := 0 to Count - 1 do
      asm
            POP     K
      end;
    end;
  end else
    Result := SourceStr;
end;

function G_ReplaceText(const SourceStr, FindStr, ReplacementStr: AnsiString): AnsiString;
var
  P, PS: PAnsiChar;
  L, L1, L2, Count: Integer;
  I, J, K, M: Integer;
begin
  L1 := Length(FindStr);
  Count := 0;
  I := G_PosText(FindStr, SourceStr, 1);
  while I <> 0 do
  begin
    Inc(I, L1);
    asm
      PUSH    I
    end;
    Inc(Count);
    I := G_PosText(FindStr, SourceStr, I);
  end;
  if Count <> 0 then
  begin
    L := Length(SourceStr);
    L2 := Length(ReplacementStr);
    J := L + 1;
    Inc(L, (L2 - L1) * Count);
    if L <> 0 then
    begin
      SetString(Result, nil, L);
      P := Pointer(Result);
      Inc(P, L);
      PS := Pointer(LongWord(SourceStr) - 1);
      for I := 0 to Count - 1 do
      begin
        asm
          POP     K
        end;
        M := J - K;
        if M > 0 then
        begin
          Dec(P, M);
          G_CopyMem(@PS[K], P, M);
        end;
        Dec(P, L2);
        G_CopyMem(Pointer(ReplacementStr), P, L2);
        J := K - L1;
      end;
      Dec(J);
      if J > 0 then
        G_CopyMem(Pointer(SourceStr), Pointer(Result), J);
    end else
    begin
      Result := '';
      for I := 0 to Count - 1 do
      asm
            POP     K
      end;
    end;
  end else
    Result := SourceStr;
end;

function G_ReplaceChar(var S: AnsiString; OldChar, NewChar: AnsiChar): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        MOV     ESI,EDX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,EBX
        MOV     EDX,ESI
        MOV     EBX,[EAX-4]
        TEST    EBX,EBX
        JE      @@zq
        LEA     ESI,[EAX-1]
        XOR     EAX,EAX
@@lp:   CMP     DL,BYTE PTR [ESI+EBX]
        JE      @@fn
        DEC     EBX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@fn:   MOV     BYTE PTR [ESI+EBX],CL
        INC     EAX
        DEC     EBX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:   POP     ESI
        POP     EBX
end;

procedure Int256Chars(P: Pointer);
asm
        MOV     ECX,8
        MOV     EDX,$03020100
@@lp:   MOV     [EAX],EDX
        ADD     EDX,$04040404
        MOV     [EAX+4],EDX
        ADD     EDX,$04040404
        MOV     [EAX+8],EDX
        ADD     EDX,$04040404
        MOV     [EAX+12],EDX
        ADD     EDX,$04040404
        MOV     [EAX+16],EDX
        ADD     EDX,$04040404
        MOV     [EAX+20],EDX
        ADD     EDX,$04040404
        MOV     [EAX+24],EDX
        ADD     EDX,$04040404
        MOV     [EAX+28],EDX
        ADD     EDX,$04040404
        ADD     EAX,32
        DEC     ECX
        JNE     @@lp
end;

procedure G_ReplaceChars(var S: AnsiString; const OldCharStr, NewCharStr: AnsiString);
var
  Map: array[#0..#255] of AnsiChar;
  I, J: Integer;
  P: PAnsiChar;
begin
  J := Length(OldCharStr);
  Int256Chars(@Map);
  if J <> Length(NewCharStr) then
    RaiseError(SErrWrongArgumentInReplaceChars);
  for I := 1 to J do
    Map[OldCharStr[I]] := NewCharStr[I];
  if J > 0 then
  begin
    UniqueString(S);
    P := Pointer(S);
    for I := 1 to Length(S) do
    begin
      P^ := Map[P^];
      Inc(P);
    end;
  end;
end;

procedure G_ReplaceCharsWithOneChar(var S: AnsiString; const OldCharSet: TSysCharSet; NewChar: AnsiChar);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EDX
        MOV     BL,CL
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EDI,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EAX
@@lp1:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JC      @@rp
@@nx1:  MOV     BYTE PTR [EDI],DL
        INC     EAX
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@nx2:  POP     EAX
        MOV     BYTE PTR [EDI],0
        SUB     EDI,EAX
        MOV     [EAX-4],EDI
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
        RET
@@rp:   MOV     BYTE PTR [EDI],BL
        INC     EAX
        INC     EDI
        DEC     ECX
        JE      @@nx2
@@lp2:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JNC     @@nx1
        INC     EAX
        DEC     ECX
        JNE     @@lp2
        JMP     @@nx2
end;

procedure G_Delete(var S: AnsiString; Index, Count: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        XOR     EBX,EBX
        CMP     ECX,EBX
        JLE     @@qt
        MOV     EBX,[EAX]
        TEST    EBX,EBX
        JE      @@qt
        MOV     ESI,[EBX-4]
        DEC     EDX
        JS      @@qt
        SUB     ESI,EDX
        JNG     @@qt
        SUB     ESI,ECX
        JLE     @@ct
        PUSH    ECX
        MOV     EBX,EDX
        CALL    UniqueString
        POP     ECX
        PUSH    EAX
        MOV     EDX,ESI
        ADD     EAX,EBX
        SHR     ESI,2
        JE      @@nx
@@lp:   MOV     BL,[EAX+ECX]
        MOV     [EAX],BL
        MOV     BL,[EAX+ECX+1]
        MOV     [EAX+1],BL
        MOV     BL,[EAX+ECX+2]
        MOV     [EAX+2],BL
        MOV     BL,[EAX+ECX+3]
        MOV     [EAX+3],BL
        ADD     EAX,4
        DEC     ESI
        JNE     @@lp
@@nx:   AND     EDX,3
        JMP     DWORD PTR @@tV[EDX*4]
@@ct:   TEST    EDX,EDX
        JE      @@zq
        MOV     EBX,EDX
        CALL    UniqueString
        MOV     [EAX-4],EBX
        XOR     EDX,EDX
        MOV     [EAX+EBX],DL
@@qt:   POP     ESI
        POP     EBX
        RET
@@zq:   CALL    System.@LStrClr
        POP     ESI
        POP     EBX
        RET
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
@@t1:   MOV     BL,[EAX+ECX]
        MOV     [EAX],BL
        INC     EAX
        JMP     @@t0
@@t2:   MOV     BL,[EAX+ECX]
        MOV     [EAX],BL
        MOV     BL,[EAX+ECX+1]
        MOV     [EAX+1],BL
        ADD     EAX,2
        JMP     @@t0
@@t3:   MOV     BL,[EAX+ECX]
        MOV     [EAX],BL
        MOV     BL,[EAX+ECX+1]
        MOV     [EAX+1],BL
        MOV     BL,[EAX+ECX+2]
        MOV     [EAX+2],BL
        ADD     EAX,3
@@t0:   POP     EDX
        MOV     BYTE PTR [EAX],0
        SUB     EAX,EDX
        MOV     [EDX-4],EAX
        POP     ESI
        POP     EBX
end;

procedure G_CutLeft(var S: AnsiString; CharCount: Integer);
var
  L: Integer;
  P: ^Integer;
begin
  if CharCount > 0 then
  begin
    L := Length(S) - CharCount;
    if L > 0 then
    begin
      UniqueString(S);
      P := Pointer(S);
      Dec(P);
      P^ := L;
      Inc(LongWord(P), CharCount + 4);
      if CharCount > 3 then
        G_MoveMem(P, Pointer(S), L)
      else
        G_MoveBytes(P, Pointer(S), L);
      P := Pointer(S);
      Inc(LongWord(P), L);
      PByte(P)^ := 0;
    end else
      S := '';
  end
  else if CharCount < 0 then
    G_CutRight(S, -CharCount);
end;

procedure G_CutRight(var S: AnsiString; CharCount: Integer);
var
  L: Integer;
  P: PInteger;
begin
  if CharCount > 0 then
  begin
    L := Length(S) - CharCount;
    if L > 0 then
    begin
      UniqueString(S);
      P := Pointer(S);
      Dec(P);
      P^ := L;
      Inc(LongWord(P), L + 4);
      PByte(P)^ := 0;
    end else
      S := '';
  end
  else if CharCount < 0 then
    G_CutLeft(S, -CharCount);
end;

function G_DeleteStr(var S: AnsiString; const SubStrToDel: AnsiString): Integer;
var
  I, L1: Integer;
begin
  L1 := Length(SubStrToDel);
  I := G_PosStr(SubStrToDel, S, 1);
  Result := 0;
  while I <> 0 do
  begin
    G_Delete(S, I, L1);
    I := G_PosStr(SubStrToDel, S, I);
    Inc(Result);
  end;
end;

function G_DeleteText(var S: AnsiString; const SubStrToDel: AnsiString): Integer;
var
  I, L1: Integer;
begin
  L1 := Length(SubStrToDel);
  I := G_PosText(SubStrToDel, S, 1);
  Result := 0;
  while I <> 0 do
  begin
    G_Delete(S, I, L1);
    I := G_PosText(SubStrToDel, S, I);
    Inc(Result);
  end;
end;

procedure G_DeleteChar(var S: AnsiString; C: AnsiChar);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EAX
        MOV     EBX,EDX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EDX,EAX
        TEST    ECX,ECX
        JE      @@zq0
@@lp1:  MOV     AL,BYTE PTR [EDX]
        CMP     BL,AL
        JE      @@cf
        INC     EDX
        DEC     ECX
        JNE     @@lp1
        JMP     @@qt
@@cf:   MOV     ESI,EDX
        INC     EDX
        DEC     ECX
        JE      @@rt
@@lp2:  MOV     AL,BYTE PTR [EDX]
        CMP     BL,AL
        JE      @@nx
        MOV     BYTE PTR [ESI],AL
        INC     ESI
@@nx:   INC     EDX
        DEC     ECX
        JNE     @@lp2
@@rt:   POP     EAX
        MOV     EBX,[EAX]
        MOV     BYTE PTR [ESI],0
        SUB     ESI,EBX
        JE      @@zq1
        MOV     [EBX-4],ESI
        POP     ESI
        POP     EBX
        RET
@@qt:   POP     ECX
        POP     ESI
        POP     EBX
        RET
@@zq0:  POP     EAX
@@zq1:  CALL    System.@LStrClr
        POP     ESI
        POP     EBX
end;

procedure G_DeleteChars(var S: AnsiString; const CharsToRemove: TSysCharSet);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EDX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EDI,EAX
        TEST    ECX,ECX
        JE      @@zq0
@@lp1:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JC      @@rp
@@nx1:  MOV     BYTE PTR [EDI],DL
        INC     EAX
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@nx2:  POP     EAX
        MOV     ECX,[EAX]
        MOV     BYTE PTR [EDI],0
        SUB     EDI,ECX
        JE      @@zq1
        MOV     [ECX-4],EDI
        POP     EDI
        POP     ESI
        RET
@@qt:   POP     ECX
        POP     EDI
        POP     ESI
        RET
@@zq0:  POP     EAX
@@zq1:  CALL    System.@LStrClr
        POP     EDI
        POP     ESI
        RET
@@rp:   INC     EAX
        DEC     ECX
        JE      @@nx2
@@lp2:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JNC     @@nx1
        INC     EAX
        DEC     ECX
        JNE     @@lp2
        JMP     @@nx2
end;

procedure G_KeepChars(var S: AnsiString; const CharsToKeep: TSysCharSet);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EDX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EDI,EAX
        TEST    ECX,ECX
        JE      @@zq0
@@lp1:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JNC     @@rp
@@nx1:  MOV     BYTE PTR [EDI],DL
        INC     EAX
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@nx2:  POP     EAX
        MOV     ECX,[EAX]
        MOV     BYTE PTR [EDI],0
        SUB     EDI,ECX
        JE      @@zq1
        MOV     [ECX-4],EDI
        POP     EDI
        POP     ESI
        RET
@@qt:   POP     ECX
        POP     EDI
        POP     ESI
        RET
@@zq0:  POP     EAX
@@zq1:  CALL    System.@LStrClr
        POP     EDI
        POP     ESI
        RET
@@rp:   INC     EAX
        DEC     ECX
        JE      @@nx2
@@lp2:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JC      @@nx1
        INC     EAX
        DEC     ECX
        JNE     @@lp2
        JMP     @@nx2
end;

procedure G_Compact(var S: AnsiString);
asm
        PUSH    EBX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EBX,EAX
        DEC     ECX
        JS      @@qt
        MOV     EDX,EAX
@@lp0:  CMP     BYTE PTR [EAX+ECX],$20
        JA      @@lp1
        DEC     ECX
        JNS     @@lp0
        JMP     @@nx4
@@lp1:  CMP     BYTE PTR [EBX],$20
        JA      @@lp3
        INC     EBX
        DEC     ECX
        JMP     @@lp1
@@lp3:  MOV     AL,BYTE PTR [EBX]
        INC     EBX
        CMP     AL,$20
        JBE     @@me
@@nx3:  MOV     BYTE PTR [EDX],AL
        INC     EDX
        DEC     ECX
        JNS     @@lp3
@@nx4:  POP     EAX
        MOV     EBX,[EAX]
        MOV     BYTE PTR [EDX],0
        SUB     EDX,EBX
        MOV     [EBX-4],EDX
        POP     EBX
        RET
@@me:   MOV     BYTE PTR [EDX],$20
        INC     EDX
        DEC     ECX
        JS      @@nx4
@@ml:   MOV     AL,BYTE PTR [EBX]
        INC     EBX
        CMP     AL,$20
        JA      @@nx3
        DEC     ECX
        JNS     @@ml
        JMP     @@nx4
@@qt:   POP     ECX
        POP     EBX
end;

procedure G_Trim(var S: AnsiString);
asm
        PUSH    EBX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EBX,EAX
        DEC     ECX
        JS      @@zq0
        MOV     EDX,EAX
@@lp0:  CMP     BYTE PTR [EAX+ECX],$20
        JA      @@nx0
        DEC     ECX
        JNS     @@lp0
        JMP     @@nx3
@@nx0:  INC     ECX
@@lp1:  CMP     BYTE PTR [EBX],$20
        JA      @@nx1
        INC     EBX
        DEC     ECX
        JMP     @@lp1
@@nx1:  CMP     EAX,EBX
        JE      @@qx
        TEST    ECX,3
        JE      @@nx2
@@lp2:  MOV     AL,BYTE PTR [EBX]
        DEC     ECX
        MOV     BYTE PTR [EDX],AL
        INC     EBX
        INC     EDX
        TEST    ECX,3
        JNE     @@lp2
@@nx2:  SHR     ECX,2
        JE      @@nx3
@@lp3:  MOV     AL,BYTE PTR [EBX]
        MOV     BYTE PTR [EDX],AL
        MOV     AL,BYTE PTR [EBX+1]
        MOV     BYTE PTR [EDX+1],AL
        MOV     AL,BYTE PTR [EBX+2]
        MOV     BYTE PTR [EDX+2],AL
        MOV     AL,BYTE PTR [EBX+3]
        MOV     BYTE PTR [EDX+3],AL
        ADD     EBX,4
        ADD     EDX,4
        DEC     ECX
        JNE     @@lp3
@@nx3:  POP     EAX
        MOV     EBX,[EAX]
        MOV     BYTE PTR [EDX],0
        SUB     EDX,EBX
        JE      @@zq1
        MOV     [EBX-4],EDX
        POP     EBX
        RET
@@qt:   POP     ECX
        POP     EBX
        RET
@@zq0:  POP     EAX
@@zq1:  CALL    System.@LStrClr
        POP     EBX
        RET
@@qx:   MOV     BYTE PTR [EAX+ECX],0
        MOV     [EAX-4],ECX
        POP     EDX
        POP     EBX
end;

procedure G_TrimLeft(var S: AnsiString);
asm
        PUSH    EBX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EBX,EAX
        TEST    ECX,ECX
        JE      @@zq0
        MOV     EDX,EAX
@@lp1:  CMP     BYTE PTR [EBX],$20
        JA      @@nx1
        INC     EBX
        DEC     ECX
        JNE     @@lp1
        JMP     @@nx3
@@nx1:  CMP     EAX,EBX
        JE      @@qt
        TEST    ECX,3
        JE      @@nx2
@@lp2:  MOV     AL,BYTE PTR [EBX]
        DEC     ECX
        MOV     BYTE PTR [EDX],AL
        INC     EBX
        INC     EDX
        TEST    ECX,3
        JNE     @@lp2
@@nx2:  SHR     ECX,2
        JE      @@nx3
@@lp3:  MOV     AL,BYTE PTR [EBX]
        MOV     BYTE PTR [EDX],AL
        MOV     AL,BYTE PTR [EBX+1]
        MOV     BYTE PTR [EDX+1],AL
        MOV     AL,BYTE PTR [EBX+2]
        MOV     BYTE PTR [EDX+2],AL
        MOV     AL,BYTE PTR [EBX+3]
        MOV     BYTE PTR [EDX+3],AL
        ADD     EBX,4
        ADD     EDX,4
        DEC     ECX
        JNE     @@lp3
@@nx3:  POP     EAX
        MOV     EBX,[EAX]
        MOV     BYTE PTR [EDX],0
        SUB     EDX,EBX
        JE      @@zq1
        MOV     [EBX-4],EDX
        POP     EBX
        RET
@@qt:   POP     ECX
        POP     EBX
        RET
@@zq0:  POP     EAX
@@zq1:  CALL    System.@LStrClr
        POP     EBX
end;

procedure G_TrimRight(var S: AnsiString);
asm
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@zq
@@lp:   CMP     BYTE PTR [EAX+ECX],$20
        JA      @@nx
        DEC     ECX
        JNS     @@lp
@@zq:   POP     EAX
        CALL    System.@LStrClr
        RET
        JMP     @@zq
@@nx:   INC     ECX
        MOV     BYTE PTR [EAX+ECX],0
        MOV     [EAX-4],ECX
@@qt:   POP     EAX
end;

{ Функции для работы с маской }

function G_ApplyMask(const Mask, SourceStr: AnsiString; MaskChar: AnsiChar): AnsiString;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,[ESP+20]
        MOV     EBX,ECX
        TEST    EAX,EAX
        JE      @@zq
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@zq
        PUSH    EDX
        MOV     EAX,EDI
        XOR     EDX,EDX
        CALL    System.@LStrFromPCharLen
        POP     EDX
        MOV     EDI,[EDI]
        MOV     ECX,[EDX-4]
        LEA     EDX,[EDX+ECX-1]
        MOV     ECX,[ESI-4]
        DEC     ECX
@@lp:   MOV     AL,BYTE PTR [ESI+ECX]
        CMP     BL,AL
        JNE     @@mb
        MOV     AL,BYTE PTR [EDX]
        MOV     BYTE PTR [EDI+ECX],AL
        DEC     EDX
        DEC     ECX
        JNS     @@lp
        JMP     @@qt
@@mb:   MOV     BYTE PTR [EDI+ECX],AL
        DEC     ECX
        JNS     @@lp
        JMP     @@qt
@@zq:   MOV     EAX,EDI
        CALL    System.@LStrClr
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

function G_ExtractWithMask(const S, Mask: AnsiString; MaskChar: AnsiChar): AnsiString;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP
        MOV     ESI,EAX
        MOV     EBX,ECX
        MOV     EDI,[ESP+24]
        TEST    EDX,EDX
        JE      @@zq
        MOV     ECX,[EDX-4]
        XOR     EBP,EBP
        DEC     ECX
        JS      @@zq
@@lpp:  CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@nx1
        INC     EBP
@@nx1:  DEC     ECX
        JS      @@ex
        CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@nx2
        INC     EBP
@@nx2:  DEC     ECX
        JS      @@ex
        CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@nx3
        INC     EBP
@@nx3:  DEC     ECX
        JS      @@ex
        CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@nx4
        INC     EBP
@@nx4:  DEC     ECX
        JNS     @@lpp
@@ex:   TEST    EBP,EBP
        JE      @@zq
        MOV     ECX,EBP
        PUSH    EDX
        MOV     EAX,EDI
        XOR     EDX,EDX
        CALL    System.@LStrFromPCharLen
        POP     EDX
        MOV     EDI,[EDI]
        LEA     EDI,[EDI+EBP-1]
        MOV     ECX,[EDX-4]
        DEC     ECX
@@lp:   CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@ne1
        MOV     AL,BYTE PTR [ESI+ECX]
        MOV     BYTE PTR [EDI],AL
        DEC     EDI
@@ne1:  DEC     ECX
        JS      @@qt
        CMP     BL,BYTE PTR [EDX+ECX]
        JNE     @@ne2
        MOV     AL,BYTE PTR [ESI+ECX]
        MOV     BYTE PTR [EDI],AL
        DEC     EDI
@@ne2:  DEC     ECX
        JNS     @@lp
        JMP     @@qt
@@zq:   MOV     EAX,EDI
        CALL    System.@LStrClr
@@qt:   POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;

function G_ValidateMask(const S, Mask: AnsiString; MaskChar: AnsiChar): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt2
        PUSH    EBX
        TEST    EDX,EDX
        JE      @@qt1
        MOV     EBX,[EAX-4]
        CMP     EBX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
        POP     EBX
@@qt2:  RET
@@01:   DEC     EBX
        JS      @@07
@@lp:   MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JNS     @@lp
@@eq:   MOV     EAX,1
        POP     EBX
        RET
@@cm:   CMP     CH,BYTE PTR [EAX+EBX]
        JNE     @@07
        DEC     EBX
        JNS     @@lp
        MOV     EAX,1
        POP     EBX
        RET
@@07:   XOR     EAX,EAX
        POP     EBX
end;

function G_ValidateWildStr(const S, Mask: AnsiString; MaskChar, WildCard: AnsiChar): Boolean;
label
  99;
var
  L, X, X0, Q: Integer;
  P, P1, B: PAnsiChar;
  C: AnsiChar;
begin
  X := G_CharPos(WildCard, Mask);
  if X = 0 then
  begin
    Result := G_ValidateMask(S, Mask, MaskChar);
    Exit;
  end;
  L := Length(S);
  P := Pointer(S);
  Result := False;
  B := Pointer(Mask);
  Q := X - 1;
  if L < Q then
    Exit;
  while Q > 0 do
  begin
    C := B^;
    if (C <> MaskChar) and (C <> P^) then
      Exit;
    Dec(Q);
    Inc(B);
    Inc(P);
  end;
  Dec(L, X - 1);
  repeat
    X0 := X;
    P1 := P;
    while Mask[X0] = WildCard do
      Inc(X0);
    X := G_CharPos(WildCard, Mask, X0);
    if X = 0 then
      Break;
  99:
    P := P1;
    B := @Mask[X0];
    Q := X - X0;
    if L < Q then
      Exit;
    while Q > 0 do
    begin
      C := B^;
      if (C <> MaskChar) and (C <> P^) then
      begin
        Inc(P1);
        Dec(L);
        goto 99;
      end;
      Dec(Q);
      Inc(B);
      Inc(P);
    end;
    Dec(L, X - X0);
  until False;
  X := Length(Mask);
  if L >= X - X0 + 1 then
  begin
    P := Pointer(S);
    Inc(P, Length(S) - 1);
    while X >= X0 do
    begin
      C := Mask[X];
      if (C <> MaskChar) and (C <> P^) then
        Exit;
      Dec(X);
      Dec(P);
    end;
    Result := True;
  end;
end;

function G_ValidateWildText(const S, Mask: AnsiString; MaskChar, WildCard: AnsiChar): Boolean;
label
  99;
var
  L, X, X0, Q: Integer;
  P, P1, B: PAnsiChar;
  C: AnsiChar;
begin
  X := G_CharPos(WildCard, Mask);
  Result := False;
  if X = 0 then
  begin
    L := Length(Mask);
    if (L > 0) and (L = Length(S)) then
    begin
      P := Pointer(S);
      B := Pointer(Mask);
      repeat
        C := B^;
        if (C <> MaskChar) and (C <> P^) and
            (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then
          Exit;
        Dec(L);
        Inc(B);
        Inc(P);
      until L = 0;
      Result := True;
    end;
    Exit;
  end;
  L := Length(S);
  P := Pointer(S);
  B := Pointer(Mask);
  Q := X - 1;
  if L < Q then
    Exit;
  while Q > 0 do
  begin
    C := B^;
    if (C <> MaskChar) and (C <> P^) and
        (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then
      Exit;
    Dec(Q);
    Inc(B);
    Inc(P);
  end;
  Dec(L, X - 1);
  repeat
    X0 := X;
    P1 := P;
    while Mask[X0] = WildCard do
      Inc(X0);
    X := G_CharPos(WildCard, Mask, X0);
    if X = 0 then
      Break;
  99:
    P := P1;
    B := @Mask[X0];
    Q := X - X0;
    if L < Q then
      Exit;
    while Q > 0 do
    begin
      C := B^;
      if (C <> MaskChar) and (C <> P^) and
        (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then
      begin
        Inc(P1);
        Dec(L);
        goto 99;
      end;
      Dec(Q);
      Inc(B);
      Inc(P);
    end;
    Dec(L, X - X0);
  until False;
  X := Length(Mask);
  if L >= X - X0 + 1 then
  begin
    P := Pointer(S);
    Inc(P, Length(S) - 1);
    while X >= X0 do
    begin
      C := Mask[X];
      if (C <> MaskChar) and (C <> P^) and
          (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then
        Exit;
      Dec(X);
      Dec(P);
    end;
    Result := True;
  end;
end;

{ Другие функции для работы со строками }

function G_CountOfChar(const S: AnsiString; C: AnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@zq
        PUSH    EBX
        LEA     EBX,[EAX-1]
        XOR     EAX,EAX
@@lp:   CMP     DL,BYTE PTR [EBX+ECX]
        JE      @@fn
        DEC     ECX
        JNE     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:
end;

function G_CountOfChars(const S: AnsiString; const CharSet: TSysCharSet): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@zq
        PUSH    EBX
        PUSH    ESI
        LEA     EBX,[EAX-1]
        XOR     EAX,EAX
@@lp:   MOVZX   ESI,BYTE PTR [EBX+ECX]
        BT      [EDX],ESI
        JC      @@fn
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@fn:   INC     EAX
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:
end;

function G_IsEmpty(const S: AnsiString): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        MOV     DL,32
        DEC     ECX
        JS      @@qt1
@@lp:   CMP     DL,BYTE PTR [EAX+ECX]
        JB      @@qt0
        DEC     ECX
        JNS     @@lp
@@qt1:  MOV     EAX,1
        RET
@@qt0:  XOR     EAX,EAX
end;

function G_PadLeft(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar): AnsiString;
var
  K, L: Integer;
  P: ^Byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    G_FillMem(Byte(PaddingChar), P, K);
    if L > 0 then
    begin
      Inc(P, K);
      G_CopyMem(Pointer(S), P, L);
    end;
  end else
    Result := S;
end;

function G_PadRight(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar): AnsiString;
var
  K, L: Integer;
  P: ^Byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    if L > 0 then
    begin
      G_CopyMem(Pointer(S), P, L);
      Inc(P, L);
    end;
    G_FillMem(Byte(PaddingChar), P, K);
  end else
    Result := S;
end;

function G_Center(const S: AnsiString; Length: Integer; PaddingChar: AnsiChar): AnsiString;
var
  K, L: Integer;
  P: ^Byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    G_FillMem(Byte(PaddingChar), P, K shr 1);
    Inc(P, K shr 1);
    if L > 0 then
    begin
      G_CopyMem(Pointer(S), P, L);
      Inc(P, L);
    end;
    G_FillMem(Byte(PaddingChar), P, K - K shr 1);
  end else
    Result := S;
end;

function G_Duplicate(const S: AnsiString; Count: Integer): AnsiString;
var
  I, L: Integer;
  P, P1: PAnsiChar;
begin
  L := Length(S);
  if (L > 0) and (Count > 0) then
  begin
    SetString(Result, nil, L * Count);
    P := Pointer(S);
    P1 := Pointer(Result);
    for I := 0 to Count - 1 do
    begin
      G_CopyMem(P, P1, L);
      Inc(P1, L);
    end;
  end else
    Result := '';
end;

procedure G_StrMoveL(const Source: AnsiString; var Dest: AnsiString; maxL: Cardinal);
asm
        MOV     EDX,[EDX]
        TEST    EAX,EAX
        JE      @@1
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EAX,[EAX-4]
        TEST    EAX,EAX
        JE      @@3
        CMP     ECX,EAX
        JB      @@0
        MOV     ECX,EAX
@@0:    MOV     [EDX-4],ECX
        MOV     BYTE PTR [EDX+ECX],$00
        CMP     ECX,64
        JB      @@cw
        MOV     EAX,ESI
        CALL    G_CopyMem
        POP     EDI
        POP     ESI
        RET
@@3:    POP     EDI
        POP     ESI
@@1:    TEST    EDX,EDX
        JE      @@2
        MOV     [EDX-4],EAX
        MOV     BYTE PTR [EDX],AL
@@2:    RET
@@cw:   MOV     EDI,EDX
        MOV     EDX,ECX
        SHR     ECX,2
        AND     EDX,3
        JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
        DD      @@w8, @@w9, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
@@w15:  MOV     EAX,[ESI+ECX*4-60]
        MOV     [EDI+ECX*4-60],EAX
@@w14:  MOV     EAX,[ESI+ECX*4-56]
        MOV     [EDI+ECX*4-56],EAX
@@w13:  MOV     EAX,[ESI+ECX*4-52]
        mov     [EDI+ECX*4-52],EAX
@@w12:  MOV     EAX,[ESI+ECX*4-48]
        MOV     [EDI+ECX*4-48],EAX
@@w11:  MOV     EAX,[ESI+ECX*4-44]
        MOV     [EDI+ECX*4-44],EAX
@@w10:  MOV     EAX,[ESI+ECX*4-40]
        MOV     [EDI+ECX*4-40],EAX
@@w9:   MOV     EAX,[ESI+ECX*4-36]
        mov     [EDI+ECX*4-36],EAX
@@w8:   MOV     EAX,[ESI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        mov     [EDI+ECX*4-20],EAX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        LEA     EAX,[ECX*4]
        ADD     ESI,EAX
        ADD     EDI,EAX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0, @@t1, @@t2, @@t3
@@t1:   MOV     AL,[ESI]
        MOV     [EDI],AL
@@t0:   POP     EDI
        POP     ESI
        RET
@@t2:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        POP     EDI
        POP     ESI
        RET
@@t3:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        POP     EDI
        POP     ESI
end;

procedure G_StrReverse(var S: AnsiString);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        LEA     EDX,[EAX+ECX-1]
@@lp:   CMP     EAX,EDX
        JAE     @@qt
        MOV     CH,BYTE PTR [EAX]
        MOV     CL,BYTE PTR [EDX]
        MOV     BYTE PTR [EDX],CH
        MOV     BYTE PTR [EAX],CL
        INC     EAX
        DEC     EDX
        JMP     @@lp
@@qt:
end;

function G_StrReverse(P: Pointer): Pointer;
asm
        TEST    EAX,EAX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        LEA     EDX,[EAX+ECX-1]
        PUSH    EAX
@@lp:   CMP     EAX,EDX
        JAE     @@qt0
        MOV     CH,BYTE PTR [EAX]
        MOV     CL,BYTE PTR [EDX]
        MOV     BYTE PTR [EDX],CH
        MOV     BYTE PTR [EAX],CL
        INC     EAX
        DEC     EDX
        JMP     @@lp
@@qt0:  POP     EAX
@@qt1:
end;

function G_PCharLen(P: PAnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        LEA     EDX,[EAX+1]
@L1:    MOV     EBX,[EAX]
        ADD     EAX,4
        LEA     ECX,[EBX-$01010101]
        NOT     EBX
        AND     ECX,EBX
        AND     ECX,$80808080
        JZ      @L1
        TEST    ECX,$00008080
        JZ      @L2
        SHL     ECX,16
        SUB     EAX,2
@L2:    SHL     ECX,9
        SBB     EAX,EDX
        POP     EBX
@@qt:
end;

{ TStringBuilder }

constructor TStringBuilder.Create;
begin
  FCapacity := 16;
  GetMem(FChars, FCapacity);
end;

constructor TStringBuilder.Create(Capacity: Integer);
begin
  FCapacity := G_NormalizeCapacity(Capacity);
  if FCapacity > 0 then
    GetMem(FChars, FCapacity);
end;

constructor TStringBuilder.Create(const S: AnsiString);
begin
  FLength := System.Length(S);
  if FLength > 0 then
  begin
    FCapacity := G_NormalizeCapacity(FLength);
    GetMem(FChars, FCapacity);
    G_CopyMem(Pointer(S), FChars, FLength);
  end else
  begin
    FCapacity := 16;
    GetMem(FChars, FCapacity);
  end;
end;

constructor TStringBuilder.Create(const S: AnsiString; StartIndex, Count: Integer);
var
  L: Integer;
  P: Pointer;
begin
  Dec(StartIndex);
  L := System.Length(S) - StartIndex;
  if L > Count then
    L := Count;
  if (L > 0) and (StartIndex >= 0) then
  begin
    FLength := L;
    FCapacity := G_NormalizeCapacity(L);
    GetMem(FChars, FCapacity);
    P := Pointer(S);
    Inc(LongWord(P), StartIndex);
    G_CopyMem(P, FChars, L);
  end else
  begin
    FCapacity := 16;
    GetMem(FChars, FCapacity);
  end;
end;

constructor TStringBuilder.Create(P: Pointer; L: Integer);
begin
  if L > 0 then
  begin
    FLength := L;
    FCapacity := G_NormalizeCapacity(L);
    GetMem(FChars, FCapacity);
    G_CopyMem(P, FChars, L);
  end else
  begin
    FCapacity := 16;
    GetMem(FChars, FCapacity);
  end;
end;

destructor TStringBuilder.Destroy;
begin
  if FCapacity > 0 then
    FreeMem(FChars);
end;

procedure TStringBuilder.SetLength(NewLength: Integer);
begin
  if NewLength >= 0 then
  begin
    if NewLength > FCapacity then
      SetCapacity(G_NormalizeCapacity(NewLength));
    FLength := NewLength;
  end;
end;

procedure TStringBuilder.SetCapacity(NewCapacity: Integer);
var
  NewChars: PChars;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FLength) then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewChars, NewCapacity);
      if FLength > 0 then
        G_CopyMem(FChars, NewChars, FLength);
    end else
      NewChars := nil;
    if FCapacity > 0 then
      FreeMem(FChars);
    FCapacity := NewCapacity;
    FChars := NewChars;
  end;
end;

procedure TStringBuilder.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TStringBuilder.Fill(C: AnsiChar; Index, Count: Integer);
var
  L: Integer;
begin
  Dec(Index);
  L := FLength - Index;
  if L > Count then
    L := Count;
  if (L > 0) and (Index >= 0) then
    G_FillMem(Byte(C), @FChars^[Index], L);
end;

function TStringBuilder.Append(N: Integer): TStringBuilder;
var
  L, M, NewL: Integer;
  P: PAnsiChar;
  Negative: Boolean;
begin
  if N = 0 then
  begin
    Result := Append('0');
    Exit;
  end;
  if LongWord(N) = $80000000 then
  begin
    Result := Append('-2147483648');
    Exit;
  end;
  L := 0;
  Negative := False;
  if N < 0 then
  begin
    N := -N;
    L := 1;
    Negative := True;
  end;
  M := N;
  repeat
    M := M div 10;
    Inc(L);
  until M = 0;
  NewL := FLength + L;
  if NewL > FCapacity then
  begin
    M := G_EnlargeCapacity(FCapacity);
    if M < NewL then
      M := G_NormalizeCapacity(NewL);
    SetCapacity(M);
  end;
  P := @FChars^[FLength];
  if Negative then
  begin
    Dec(L);
    P^ := '-';
    Inc(P);
  end;
  repeat
    P^ := AnsiChar(G_ModDiv10(LongWord(N)) + 48);
    Inc(P);
  until N = 0;
  FLength := NewL;
  Dec(P, L);
  G_ReverseBytes(P, L);
  Result := Self;
end;

function TStringBuilder.Append(N: LongWord; Digits: Integer;
  Hexadecimal: Boolean): TStringBuilder;
var
  L, NewL, NewC: Integer;
  P: PAnsiChar;
  M: LongWord;
begin
  L := 0;
  M := N;
  if not Hexadecimal then
    while M <> 0 do
    begin
      M := M div 10;
      Inc(L);
    end
  else
    while M <> 0 do
    begin
      M := M shr 4;
      Inc(L);
    end;
  if L < Digits then
    NewL := FLength + Digits
  else
    NewL := FLength + L;
  if NewL > FCapacity then
  begin
    NewC := G_EnlargeCapacity(FCapacity);
    if NewC < NewL then
      NewC := G_NormalizeCapacity(NewL);
    SetCapacity(NewC);
  end;
  P := @FChars^[FLength];
  if not Hexadecimal then
    while N <> 0 do
    begin
      P^ := AnsiChar(G_ModDiv10(N) + 48);
      Inc(P);
    end
  else
    while N <> 0 do
    begin
      M := N and $F;
      if M < 10 then
        P^ := AnsiChar(M + 48)
      else
        P^ := AnsiChar(M + 55);
      N := N shr 4;
      Inc(P);
    end;
  if L < Digits then
  begin
    G_FillMem(48, P, Digits - L);
    Dec(P, L);
    L := Digits;
  end else
    Dec(P, L);
  FLength := NewL;
  G_ReverseBytes(P, L);
  Result := Self;
end;

function TStringBuilder.Append(N: Int64): TStringBuilder;
var
  L, NewL, NewC: Integer;
  P: PAnsiChar;
  M: Int64;
  Negative: Boolean;
begin
  if N = 0 then
  begin
    Result := Append('0');
    Exit;
  end;
  if N = $8000000000000000 then
  begin
    Result := Append('-9223372036854775808');
    Exit;
  end;
  L := 0;
  Negative := False;
  if N < 0 then
  begin
    N := -N;
    L := 1;
    Negative := True;
  end;
  M := N;
  repeat
    M := M div 10;
    Inc(L);
  until M = 0;
  NewL := FLength + L;
  if NewL > FCapacity then
  begin
    NewC := G_EnlargeCapacity(FCapacity);
    if NewC < NewL then
      NewC := G_NormalizeCapacity(NewL);
    SetCapacity(NewC);
  end;
  P := @FChars^[FLength];
  if Negative then
  begin
    Dec(L);
    P^ := '-';
    Inc(P);
  end;
  repeat
    P^ := AnsiChar(N mod 10 + 48);
    N := N div 10;
    Inc(P);
  until N = 0;
  FLength := NewL;
  Dec(P, L);
  G_ReverseBytes(P, L);
  Result := Self;
end;

function TStringBuilder.Append(C: AnsiChar): TStringBuilder;
begin
  if FLength = FCapacity then
    SetCapacity(G_EnlargeCapacity(FCapacity));
  FChars^[FLength] := C;
  Inc(FLength);
  Result := Self;
end;

function TStringBuilder.Append(C: AnsiChar; Count: Integer): TStringBuilder;
var
  NewL, NewC: Integer;
begin
  if Count > 0 then
  begin
    NewL := FLength + Count;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    G_FillMem(Byte(C), @FChars^[FLength], Count);
    FLength := NewL;
  end;
  Result := Self;
end;

function TStringBuilder.Append(const S: AnsiString): TStringBuilder;
var
  L, NewL, NewC: Integer;
begin
  L := System.Length(S);
  if L > 0 then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    G_CopyMem(Pointer(S), @FChars^[FLength], L);
    FLength := NewL;
  end;
  Result := Self;
end;

function TStringBuilder.Append(const S: AnsiString; Count: Integer): TStringBuilder;
var
  L, SumL, NewL, NewC: Integer;
  X: Pointer;
begin
  L := System.Length(S);
  SumL := L * Count;
  if SumL > 0 then
  begin
    NewL := FLength + SumL;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    X := @FChars^[FLength];
    repeat
      G_CopyMem(Pointer(S), X, L);
      Inc(LongWord(X), L);
      Dec(Count);
    until Count = 0;
    FLength := NewL;
  end;
  Result := Self;
end;

function TStringBuilder.Append(const S: AnsiString; StartIndex, Count: Integer): TStringBuilder;
var
  L, NewL, NewC: Integer;
  P: Pointer;
begin
  Dec(StartIndex);
  L := System.Length(S) - StartIndex;
  if L > Count then
    L := Count;
  if (L > 0) and (StartIndex >= 0) then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    P := Pointer(S);
    Inc(LongWord(P), StartIndex);
    G_CopyMem(P, @FChars^[FLength], L);
    FLength := NewL;
  end;
  Result := Self;
end;

function TStringBuilder.Append(P: Pointer; L: Integer): TStringBuilder;
var
  NewL, NewC: Integer;
begin
  if L > 0 then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    G_CopyMem(P, @FChars^[FLength], L);
    FLength := NewL;
  end;
  Result := Self;
end;

function TStringBuilder.AppendLine: TStringBuilder;
begin
  Result := Append(#13).Append(#10);
end;

function TStringBuilder.AppendLine(const S: AnsiString): TStringBuilder;
begin
  Result := Append(S).Append(#13).Append(#10);
end;

procedure TStringBuilder.Insert(Index: Integer; C: AnsiChar);
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  if Index >= 0 then
  begin
    if FLength = FCapacity then
      SetCapacity(G_EnlargeCapacity(FCapacity));
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + 1], FLength - Index);
    FChars^[Index] := C;
    Inc(FLength);
  end;
end;

procedure TStringBuilder.Insert(Index: Integer; C: AnsiChar; Count: Integer);
var
  NewL, NewC: Integer;
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  if (Count > 0) and (Index >= 0) then
  begin
    NewL := FLength + Count;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + Count], FLength - Index);
    G_FillMem(Byte(C), @FChars^[Index], Count);
    FLength := NewL;
  end;
end;

procedure TStringBuilder.Insert(Index: Integer; const S: AnsiString);
var
  L, NewL, NewC: Integer;
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  L := System.Length(S);
  if (L > 0) and (Index >= 0) then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + L], FLength - Index);
    G_CopyMem(Pointer(S), @FChars^[Index], L);
    FLength := NewL;
  end;
end;

procedure TStringBuilder.Insert(Index: Integer; const S: AnsiString; Count: Integer);
var
  L, SumL, NewL, NewC: Integer;
  X: Pointer;
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  L := System.Length(S);
  SumL := L * Count;
  if (SumL > 0) and (Index >= 0) then
  begin
    NewL := FLength + SumL;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + SumL], FLength - Index);
    X := @FChars^[Index];
    repeat
      G_CopyMem(Pointer(S), X, L);
      Inc(LongWord(X), L);
      Dec(Count);
    until Count = 0;
    FLength := NewL;
  end;
end;

procedure TStringBuilder.Insert(Index: Integer; const S: AnsiString; StartIndex,
  Count: Integer);
var
  L, NewL, NewC: Integer;
  P: Pointer;
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  Dec(StartIndex);
  L := System.Length(S) - StartIndex;
  if L > Count then
    L := Count;
  if (L > 0) and (StartIndex >= 0) and (Index >= 0) then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + L], FLength - Index);
    P := Pointer(S);
    Inc(LongWord(P), StartIndex);
    G_CopyMem(P, @FChars^[Index], L);
    FLength := NewL;
  end;
end;

procedure TStringBuilder.Insert(Index: Integer; P: Pointer; L: Integer);
var
  NewL, NewC: Integer;
begin
  Dec(Index);
  if Index > FLength then
    Index := FLength;
  if (L > 0) and (Index >= 0) then
  begin
    NewL := FLength + L;
    if NewL > FCapacity then
    begin
      NewC := G_EnlargeCapacity(FCapacity);
      if NewC < NewL then
        NewC := G_NormalizeCapacity(NewL);
      SetCapacity(NewC);
    end;
    if Index < FLength then
      G_MoveBytes(@FChars^[Index], @FChars^[Index + L], FLength - Index);
    G_CopyMem(P, @FChars^[Index], L);
    FLength := NewL;
  end;
end;

procedure TStringBuilder.Reverse;
begin
  if FLength > 1 then
    G_ReverseBytes(FChars, FLength);
end;

procedure TStringBuilder.Reverse(Index, Count: Integer);
var
  L: Integer;
begin
  Dec(Index);
  L := FLength - Index;
  if L > Count then
    L := Count;
  if (L > 1) and (Index >= 0) then
    G_ReverseBytes(@FChars^[Index], L);
end;

procedure TStringBuilder.Delete(Index, Count: Integer);
var
  L, R: Integer;
begin
  Dec(Index);
  L := FLength - Index;
  if L > Count then
  begin
    R := L - Count;
    L := Count;
  end else
    R := 0;
  if (L > 0) and (Index >= 0) then
  begin
    if R > 0 then
      G_MoveBytes(@FChars^[Index + L], @FChars^[Index], R);
    Dec(FLength, L);
  end;
end;

procedure TStringBuilder.Clear;
begin
  FLength := 0;
end;

function TStringBuilder.ToString: AnsiString;
begin
  if FLength > 0 then
    SetString(Result, PAnsiChar(FChars), FLength)
  else
    Result := '';
end;

function TStringBuilder.ToString(Index, Count: Integer): AnsiString;
var
  L: Integer;
begin
  Dec(Index);
  L := FLength - Index;
  if L > Count then
    L := Count;
  if (L > 0) and (Index >= 0) then
    SetString(Result, PAnsiChar(@FChars^[Index]), L)
  else
    Result := '';
end;

function TStringBuilder.Equals(SB: TStringBuilder): Boolean;
begin
  if SB = Self then
    Result := True
  else if (SB <> nil) and (SB.FLength = FLength) then
    Result := G_SameMem(FChars, SB.FChars, FLength)
  else
    Result := False;
end;

procedure TStringBuilder.TrimToSize;
begin
  if FLength < FCapacity then
    SetCapacity(FLength);
end;

function TStringBuilder.Clone: TStringBuilder;
begin
  Result := TStringBuilder.Create(FChars, FLength);
end;

procedure TStringBuilder.CopyFrom(ASource: TStringBuilder);
begin
  Clear;
  Append(ASource.FChars, ASource.FLength)
end;

{$IFNDEF UNICODE}
{$IFDEF USE_ACED_MEMORY}

function G_CreateString(Capacity, Length: Integer): AnsiString;
asm
          ADD     EAX,9
          PUSH    ECX
          PUSH    EDX
          CALL    G_GetMem
          POP     EDX
          POP     ECX
          MOV     BYTE PTR [EAX+EDX+8],0
          MOV     [EAX],1
          MOV     [EAX+4],EDX
          ADD     EAX,8
          MOV     [ECX],EAX
end;

procedure G_DisposeString(P: Pointer);
asm
          TEST    EAX,EAX
          JE      @@qt
          SUB     EAX,8
          MOV     EDX,[EAX]
          DEC     EDX
          JL      @@qt
LOCK      DEC     [EAX]
          JNE     @@qt
          LEA     EAX,[EAX]
          CALL    G_FreeMem
@@qt:
end;

function G_NewStr(const S: AnsiString): AnsiString;
var
  L: Integer;
  X: Pointer;
begin
  L := Length(S);
  if L > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(L, L);
    G_CopyMem(Pointer(S), Pointer(Result), L);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(Capacity: Integer): AnsiString;
var
  X: Pointer;
begin
  if Capacity > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(Capacity, 0);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S: AnsiString; Capacity: Integer): AnsiString;
var
  L: Integer;
  X: Pointer;
begin
  L := Length(S);
  if L > Capacity then
    Capacity := L;
  if Capacity > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(Capacity, L);
    if L > 0 then
      G_CopyMem(Pointer(S), Pointer(Result), L);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2: AnsiString): AnsiString;
var
  L1, L2, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L := L1 + L2;
  if L > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(L, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
      G_CopyMem(Pointer(S2), P, L2);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2: AnsiString; Capacity: Integer): AnsiString;
var
  L1, L2, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L := L1 + L2;
  if L > Capacity then
    Capacity := L;
  if Capacity > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(Capacity, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
      G_CopyMem(Pointer(S2), P, L2);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2, S3: AnsiString): AnsiString;
var
  L1, L2, L3, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L3 := Length(S3);
  L := L1 + L2 + L3;
  if L > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(L, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
    begin
      G_CopyMem(Pointer(S2), P, L2);
      Inc(LongWord(P), L2);
    end;
    if L3 > 0 then
      G_CopyMem(Pointer(S3), P, L3);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2, S3: AnsiString; Capacity: Integer): AnsiString;
var
  L1, L2, L3, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L3 := Length(S3);
  L := L1 + L2 + L3;
  if L > Capacity then
    Capacity := L;
  if Capacity > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(Capacity, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
    begin
      G_CopyMem(Pointer(S2), P, L2);
      Inc(LongWord(P), L2);
    end;
    if L3 > 0 then
      G_CopyMem(Pointer(S3), P, L3);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2, S3, S4: AnsiString): AnsiString;
var
  L1, L2, L3, L4, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L3 := Length(S3);
  L4 := Length(S4);
  L := L1 + L2 + L3 + L4;
  if L > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(L, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
    begin
      G_CopyMem(Pointer(S2), P, L2);
      Inc(LongWord(P), L2);
    end;
    if L3 > 0 then
    begin
      G_CopyMem(Pointer(S3), P, L3);
      Inc(LongWord(P), L3);
    end;
    if L4 > 0 then
      G_CopyMem(Pointer(S4), P, L4);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2, S3, S4: AnsiString; Capacity: Integer): AnsiString;
var
  L1, L2, L3, L4, L: Integer;
  P, X: Pointer;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L3 := Length(S3);
  L4 := Length(S4);
  L := L1 + L2 + L3 + L4;
  if L > Capacity then
    Capacity := L;
  if Capacity > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(Capacity, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
    begin
      G_CopyMem(Pointer(S2), P, L2);
      Inc(LongWord(P), L2);
    end;
    if L3 > 0 then
    begin
      G_CopyMem(Pointer(S3), P, L3);
      Inc(LongWord(P), L3);
    end;
    if L4 > 0 then
      G_CopyMem(Pointer(S4), P, L4);
    G_DisposeString(X);
  end else
    Result := '';
end;

function G_NewStr(const S1, S2: AnsiString; Index2, Count2: Integer): AnsiString;
var
  L1, L2, L: Integer;
  P, P2, X: Pointer;
begin
  L1 := Length(S1);
  if (Index2 > 0) and (Count2 > 0) then
  begin
    Dec(Index2);
    L2 := Length(S2) - Index2;
    if L2 > Count2 then
      L2 := Count2
    else if L2 < 0 then
      L2 := 0;
    P2 := Pointer(S2);
    Inc(LongWord(P2), Index2);
  end else
  begin
    L2 := 0;
    P2 := nil;
  end;
  L := L1 + L2;
  if L > 0 then
  begin
    X := Pointer(Result);
    Result := G_CreateString(L, L);
    P := Pointer(Result);
    if L1 > 0 then
    begin
      G_CopyMem(Pointer(S1), P, L1);
      Inc(LongWord(P), L1);
    end;
    if L2 > 0 then
      G_CopyMem(P2, P, L2);
    G_DisposeString(X);
  end else
    Result := '';
end;

procedure G_Append(var S: AnsiString; const S1: AnsiString);
var
  LS, L1, L, C: Integer;
  P: Pointer;
  R: AnsiString;
begin
  L1 := Length(S1);
  if L1 > 0 then
  begin
    P := Pointer(S);
    if P = nil then
    begin
      S := G_CreateString(L1, L1);
      G_CopyMem(Pointer(S1), Pointer(S), L1);
      Exit;
    end;
    Dec(LongWord(P), 4);
    LS := PInteger(P)^;
    Dec(LongWord(P), 4);
    if PInteger(P)^ <> 1 then
    begin
      S := G_NewStr(S, S1);
      Exit;
    end;
    L := G_GetMemSize(P);
    if LS + L1 + 9 <= L then
    begin
      Inc(LongWord(P), 4);
      PInteger(P)^ := LS + L1;
      Inc(LongWord(P), LS + 4);
      G_CopyMem(Pointer(S1), P, L1 + 1);
    end else
    begin
      C := L shl 1;
      L := LS + L1;
      if C < L then
        C := L;
      R := G_CreateString(C, L);
      P := Pointer(R);
      if LS > 0 then
      begin
        G_CopyMem(Pointer(S), P, LS);
        Inc(LongWord(P), LS);
      end;
      G_CopyMem(Pointer(S1), P, L1);
      S := R;
    end;
  end;
end;

procedure G_Append(var S: AnsiString; const S1, S2: AnsiString);
var
  LS, L1, L2, L, C: Integer;
  P: Pointer;
  R: AnsiString;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  C := L1 + L2;
  if C > 0 then
  begin
    P := Pointer(S);
    if P = nil then
    begin
      S := G_NewStr(S1, S2);
      Exit;
    end;
    Dec(LongWord(P), 4);
    LS := PInteger(P)^;
    Dec(LongWord(P), 4);
    if PInteger(P)^ <> 1 then
    begin
      S := G_NewStr(S, S1, S2);
      Exit;
    end;
    L := G_GetMemSize(P);
    Inc(C, LS);
    if L >= C + 9 then
    begin
      Inc(LongWord(P), 4);
      PInteger(P)^ := C;
      Inc(LongWord(P), LS + 4);
      if L1 > 0 then
      begin
        G_CopyMem(Pointer(S1), P, L1);
        Inc(LongWord(P), L1);
      end;
      if L2 > 0 then
      begin
        G_CopyMem(Pointer(S2), P, L2);
        Inc(LongWord(P), L2);
      end;
      PByte(P)^ := 0;
    end else
    begin
      L := L shl 1;
      if L < C then
        L := C;
      R := G_CreateString(L, C);
      P := Pointer(R);
      if LS > 0 then
      begin
        G_CopyMem(Pointer(S), P, LS);
        Inc(LongWord(P), LS);
      end;
      if L1 > 0 then
      begin
        G_CopyMem(Pointer(S1), P, L1);
        Inc(LongWord(P), L1);
      end;
      if L2 > 0 then
        G_CopyMem(Pointer(S2), P, L2);
      S := R;
    end;
  end;
end;

procedure G_Append(var S: AnsiString; const S1, S2, S3: AnsiString);
var
  LS, L1, L2, L3, L, C: Integer;
  P: Pointer;
  R: AnsiString;
begin
  L1 := Length(S1);
  L2 := Length(S2);
  L3 := Length(S3);
  C := L1 + L2 + L3;
  if C > 0 then
  begin
    P := Pointer(S);
    if P = nil then
    begin
      S := G_NewStr(S1, S2, S3);
      Exit;
    end;
    Dec(LongWord(P), 4);
    LS := PInteger(P)^;
    Dec(LongWord(P), 4);
    if PInteger(P)^ <> 1 then
    begin
      S := G_NewStr(S, S1, S2, S3);
      Exit;
    end;
    L := G_GetMemSize(P);
    Inc(C, LS);
    if L >= C + 9 then
    begin
      Inc(LongWord(P), 4);
      PInteger(P)^ := C;
      Inc(LongWord(P), LS + 4);
      if L1 > 0 then
      begin
        G_CopyMem(Pointer(S1), P, L1);
        Inc(LongWord(P), L1);
      end;
      if L2 > 0 then
      begin
        G_CopyMem(Pointer(S2), P, L2);
        Inc(LongWord(P), L2);
      end;
      if L3 > 0 then
      begin
        G_CopyMem(Pointer(S3), P, L3);
        Inc(LongWord(P), L3);
      end;
      PByte(P)^ := 0;
    end else
    begin
      L := L shl 1;
      if L < C then
        L := C;
      R := G_CreateString(L, C);
      P := Pointer(R);
      if LS > 0 then
      begin
        G_CopyMem(Pointer(S), P, LS);
        Inc(LongWord(P), LS);
      end;
      if L1 > 0 then
      begin
        G_CopyMem(Pointer(S1), P, L1);
        Inc(LongWord(P), L1);
      end;
      if L2 > 0 then
      begin
        G_CopyMem(Pointer(S2), P, L2);
        Inc(LongWord(P), L2);
      end;
      if L3 > 0 then
        G_CopyMem(Pointer(S3), P, L3);
      S := R;
    end;
  end;
end;

procedure G_Append(var S: AnsiString; C: AnsiChar);
var
  LS, L: Integer;
  P: Pointer;
  R: AnsiString;
begin
  P := Pointer(S);
  if P = nil then
  begin
    S := C;
    Exit;
  end;
  Dec(LongWord(P), 4);
  LS := PInteger(P)^;
  Dec(LongWord(P), 4);
  if PInteger(P)^ <> 1 then
  begin
    UniqueString(S);
    P := Pointer(S);
    Dec(LongWord(P), 8);
  end;
  L := G_GetMemSize(P);
  if LS + 10 <= L then
  begin
    Inc(LongWord(P), 4);
    PInteger(P)^ := LS + 1;
    Inc(LongWord(P), LS + 4);
    PByte(P)^ := Byte(C);
    Inc(LongWord(P));
    PByte(P)^ := 0;
  end else
  begin
    L := LS + 1;
    R := G_CreateString(L, L);
    P := Pointer(R);
    if LS > 0 then
    begin
      G_CopyMem(Pointer(S), P, LS);
      Inc(LongWord(P), LS);
    end;
    PByte(P)^ := Byte(C);
    S := R;
  end;
end;

procedure G_Append(var S: AnsiString; const S1: AnsiString; Index1, Count1: Integer);
var
  LS, L1, L, C: Integer;
  P, P1: Pointer;
  R: AnsiString;
begin
  if (Index1 > 0) and (Count1 > 0) then
  begin
    Dec(Index1);
    L1 := Length(S1) - Index1;
    if L1 > Count1 then
      L1 := Count1
    else if L1 < 0 then
      L1 := 0;
    P1 := Pointer(S1);
    Inc(LongWord(P1), Index1);
  end else
  begin
    L1 := 0;
    P1 := nil;
  end;
  if L1 > 0 then
  begin
    P := Pointer(S);
    if P = nil then
    begin
      S := G_CreateString(L1, L1);
      G_CopyMem(P1, Pointer(S), L1);
      Exit;
    end;
    Dec(LongWord(P), 4);
    LS := PInteger(P)^;
    Dec(LongWord(P), 4);
    if PInteger(P)^ <> 1 then
    begin
      L := LS + L1;
      R := G_CreateString(L, L);
      P := Pointer(R);
      if LS > 0 then
      begin
        G_CopyMem(Pointer(S), P, LS);
        Inc(LongWord(P), LS);
      end;
      G_CopyMem(P1, P, L1);
      S := R;
      Exit;
    end;
    L := G_GetMemSize(P);
    if LS + L1 + 9 <= L then
    begin
      Inc(LongWord(P), 4);
      PInteger(P)^ := LS + L1;
      Inc(LongWord(P), LS + 4);
      G_CopyMem(P1, P, L1 + 1);
    end else
    begin
      C := L shl 1;
      L := LS + L1;
      if C < L then
        C := L;
      R := G_CreateString(C, L);
      P := Pointer(R);
      if LS > 0 then
      begin
        G_CopyMem(Pointer(S), P, LS);
        Inc(LongWord(P), LS);
      end;
      G_CopyMem(P1, P, L1);
      S := R;
    end;
  end;
end;

procedure G_AppendLine(var S: AnsiString);
begin
  G_Append(S, #13#10);
end;

procedure G_AppendLine(var S: AnsiString; const S1: AnsiString);
begin
  G_Append(S, S1, #13#10);
end;

procedure G_Insert(const S1: AnsiString; var S: AnsiString; Index, Index1, Count1: Integer);
var
  LS, L1, L, C: Integer;
  P, P1, PS: Pointer;
  R: AnsiString;
begin
  Dec(Index);
  LS := Length(S);
  if (Index < 0) or (Index >= LS) then
  begin
    if Index = LS then
      G_Append(S, S1, Index1, Count1);
    Exit;
  end;
  if (Index1 > 0) and (Count1 > 0) then
  begin
    Dec(Index1);
    L1 := Length(S1) - Index1;
    if L1 > Count1 then
      L1 := Count1
    else if L1 < 0 then
      L1 := 0;
    P1 := Pointer(S1);
    Inc(LongWord(P1), Index1);
  end else
  begin
    L1 := 0;
    P1 := nil;
  end;
  if L1 > 0 then
  begin
    P := Pointer(S);
    PS := P;
    Dec(LongWord(P), 8);
    if PInteger(P)^ <> 1 then
    begin
      L := LS + L1;
      R := G_CreateString(L, L);
      P := Pointer(R);
      if Index = 0 then
      begin
        G_CopyMem(P1, P, L1);
        Inc(LongWord(P), L1);
        G_CopyMem(PS, P, LS);
      end else
      begin
        G_CopyMem(PS, P, Index);
        Inc(LongWord(P), Index);
        Inc(LongWord(PS), Index);
        G_CopyMem(P1, P, L1);
        Inc(LongWord(P), L1);
        G_CopyMem(PS, P, LS - Index);
      end;
      S := R;
      Exit;
    end;
    L := G_GetMemSize(P);
    if LS + L1 + 9 <= L then
    begin
      Inc(LongWord(P), 4);
      PInteger(P)^ := LS + L1;
      Inc(LongWord(PS), Index + L1);
      Inc(LongWord(P), Index + 4);
      G_MoveMem(P, PS, LS - Index);
      G_CopyMem(P1, P, L1);
    end else
    begin
      C := L shl 1;
      L := LS + L1;
      if C < L then
        C := L;
      R := G_CreateString(C, L);
      P := Pointer(R);
      if Index = 0 then
      begin
        G_CopyMem(P1, P, L1);
        Inc(LongWord(P), L1);
        G_CopyMem(PS, P, LS);
      end else
      begin
        G_CopyMem(PS, P, Index);
        Inc(LongWord(P), Index);
        Inc(LongWord(PS), Index);
        G_CopyMem(P1, P, L1);
        Inc(LongWord(P), L1);
        G_CopyMem(PS, P, LS - Index);
      end;
      S := R;
    end;
  end;
end;

{$ENDIF}
{$ENDIF}

{$IFDEF USE_DYNAMIC_TABLES}

initialization
  Int256Chars(@ToUpperChars);
  CharToOemBuff(@ToUpperChars,@ToOemChars,256);
  OemToCharBuff(@ToUpperChars,@ToAnsiChars,256);
  CharUpperBuff(@ToUpperChars,256);
  Int256Chars(@ToLowerChars);
  CharLowerBuff(@ToLowerChars,256);

{$ENDIF}

end.

