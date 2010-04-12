
//////////////////////////////////////////////////////
//                                                  //
//   AcedCrypto 1.16 (без использования MMX)        //
//                                                  //
//   Функции для шифрования, верификации данных и   //
//   для генерации псевдослучайных чисел.           //
//                                                  //
//   mailto: acedutils@yandex.ru                    //
//                                                  //
//////////////////////////////////////////////////////

unit AcedCrypto;

{$B-,H+,R-,Q-,T-,X+}

{$DEFINE NO_MMX}

interface

{ Функции G_RC4... реализуют поточный алгоритм шифрования RC4, разработанный
  Роном Ривестом (все права принадлежат RSA Data Security, Inc.). Алгоритм
  очень быстрый и достаточно надежный. Повторное применение его с тем же
  ключом восстанавливает исходное состояние данных. Не следует использовать
  один и тот же ключ несколько раз. Алгоритм реализован с учетом замечаний,
  опубликованных в документе: "RSA Security Response to Weaknesses in Key
  Scheduling Algorithm of RC4". }

{ Тип дескриптора процесса шифрования методом RC4. Каждый дескриптор должен
  освобождаться в конце вызовом G_RC4Done. }

type HRC4 = type Pointer;

{ G_RC4Init задает ключевую последовательность для шифрования данных методом
  RC4 и инициализирует процесс шифрования. В качестве ключа принимает массив
  байт, адресуемый параметром Key, длиной KeyLength байт. Длина ключа может
  быть до 255 байт (нормальная длина ключа - 16 байт). В параметре H
  возвращается дескриптор процесса шифрования, который затем передается в
  G_RC4Apply и G_RC4Done. }

procedure G_RC4Init(var H: HRC4; Key: Pointer; KeyLength: Cardinal);

{ G_RC4Apply выполняет шифрование или дешифрацию данных, адресуемых
  параметром P, длиной L байт с помощью ключа, связанного с дескриптором H.
  Эта процедура может вызываться многократно для последовательного
  шифрования нескольких массивов данных. }

procedure G_RC4Apply(H: HRC4; P: Pointer; L: Cardinal);

{ G_RC4Done освобождает внутренние ресурсы, связанные с дескриптором H. }

procedure G_RC4Done(H: HRC4);

{ G_RC4SelfTest проверяет работоспособность алгоритма RC4. Если тест пройден
  успешно, функция возвращает True, иначе False. }

function G_RC4SelfTest: Boolean;


{ Функции G_RC6... реализуют блочный алгоритм шифрования RC6(TM). Авторы
  алгоритма: Ronald L. Rivest, M.J.B. Robshaw, R. Sidney и Y.L. Yin. Длина
  ключа до 255 байт (нормальная длина ключа - 32 байта). }

{ Тип массива, содержащего начальный вектор, и тип дескриптора процесса
  шифрования. Дескриптор должен освобождаться в конце вызовом G_RC6Done. }

type
  PRC6Vector = ^TRC6Vector;
  TRC6Vector = array[0..3] of LongWord;

  HRC6 = type Pointer;

{ G_RC6Init инициализирует шифрование методом RC6. Ключ передается параметром
  Key (адрес байтового массива), а длина ключа (в байтах) - параметром
  KeyLength. Дескриптор процесса шифрования возвращается в параметре H. Он
  передается как первый параметр в другие процедуры G_RC6..., а в конце
  должен освобождаться вызовом G_RC6Done. }

procedure G_RC6Init(var H: HRC6; Key: Pointer; KeyLength: Cardinal);

{ G_RC6EncryptECB шифрует блок памяти размером 16 байт, адресуемый параметром
  V, в режиме ECB, который не предусматривает распространение ошибок. H -
  дескриптор процесса шифрования, полученный из G_RC6Init. }

procedure G_RC6EncryptECB(H: HRC6; V: PRC6Vector);

{ G_RC6DecryptECB дешифрует блок памяти размером 16 байт, адресуемый
  параметром V, зашифрованный в режиме ECB. H - дескриптор процесса шифрования,
  полученный из G_RC6Init. }

procedure G_RC6DecryptECB(H: HRC6; V: PRC6Vector);

{ G_RC6GetVector сохраняет вектор, используемый в режимах CFB и OFB,
  в массиве, переданном параметром IV. H - дескриптор процесса шифрования,
  полученный из G_RC6Init. }

procedure G_RC6GetVector(H: HRC6; IV: PRC6Vector);

{ G_RC6SetVector устанавливает начальный вектор, используемый в режимах CFB
  и OFB, равным вектору, переданному параметром IV. H - дескриптор процесса
  шифрования, полученный из G_RC6Init. }

procedure G_RC6SetVector(H: HRC6; IV: PRC6Vector);

{ G_RC6SetOrdinaryVector обнуляет начальный вектор, используемый в режимах
  CFB и OFB, а затем шифрует его текущим ключом. H - дескриптор процесса
  шифрования, полученный из G_RC6Init. }

procedure G_RC6SetOrdinaryVector(H: HRC6);

{ G_RC6EncryptCFB выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом RC6 в блочном режиме CFB (128 бит).
  H - дескриптор процесса шифрования, полученный из G_RC6Init. }

procedure G_RC6EncryptCFB(H: HRC6; P: Pointer; L: Cardinal);

{ G_RC6DecryptCFB выполняет дешифрование байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой G_RC6EncryptCFB.
  H - идентификатор процесса шифрования, полученный из G_RC6Init. Размер
  дешифруемых фрагментов памяти должен соответствовать размеру шифруемых
  фрагментов. }

procedure G_RC6DecryptCFB(H: HRC6; P: Pointer; L: Cardinal);

{ G_RC6ApplyOFB выполняет шифрование или дешифрование области памяти,
  адресуемой параметром P, длиной L байт методом RC6 в блочном режиме OFB
  (128 бит). Параметр H задает дескриптор процесса шифрования. Следует
  иметь в виду, что режим OFB является эквивалентом поточного шифра и
  не предусматривает распространения ошибок. В этом режиме не следует
  использовать один и тот же ключ несколько раз. Размер дешифруемых
  фрагментов памяти должен соответствовать размеру шифруемых фрагментов. }

procedure G_RC6ApplyOFB(H: HRC6; P: Pointer; L: Cardinal);

{ G_RC6Done освобождает дескриптор процесса шифрования H, полученный из
  процедуры G_RC6Init и все связанные с ним ресурсы. }

procedure G_RC6Done(H: HRC6);

{ G_RC6SelfTest проверяет работоспособность алгоритма RC6 по тестовым векторам,
  приведенным в документе: The RC6(TM) Block Cipher. Ronald L. Rivest, M.J.B.
  Robshaw, R. Sidney, and Y.L. Yin, http://theory.lcs.mit.edu/~rivest/rc6.pdf.
  Если тест пройден успешно, функция возвращает True, иначе False. }

function G_RC6SelfTest: Boolean;


{ Функции G_SHA256... предназначены для получения значения односторонней
  хэш-функции SHA-256 для массива байт или строки символов. Алгоритм
  реализован в соответствии с FIPS180-2. Результат представляет собой
  256-битный массив, состоящий из восьми двойных слов (32 байт). По этому
  значению практически невозможно восстановить исходное сообщение. Кроме
  того, невозможно найти другое сообщение с тем же значением хэш-функции. }

{ Тип массива, содержащего значение хэш-функции SHA-256, тип массива,
  представляющего собой входной блок данных для преобразования SHA-256,
  и тип дескриптора процесса расчета односторонней хэш-функции. }

type
  PSHA256Digest = ^TSHA256Digest;
  TSHA256Digest = array[0..7] of LongWord;

  PSHA256Block = ^TSHA256Block;
  TSHA256Block = array[0..15] of LongWord;

  HSHA256 = type Pointer;

{ G_SHA256Init инициализирует расчет хэш-функции SHA-256. В параметре H
  возвращает дескриптор, который затем передается в процедуры: G_SHA256Update
  и G_SHA256Done. }

procedure G_SHA256Init(var H: HSHA256);

{ G_SHA256Update вычисляет значение хэш-функции для следующего фрагмента
  данных, адресуемого параметром P длиной L байт. Эта процедура может
  вызывается многократно для нескольких массивов данных, но само значение
  хэш-функции будет получено только при вызове процедуры G_SHA256Done. }

procedure G_SHA256Update(H: HSHA256; P: Pointer; L: Cardinal);

{ G_SHA256Transform выполняет преобразование SHA-256 блока памяти, адресуемого
  параметром Source, и сохраняет результат в блоке, адресуемом параметром
  Dest. H - дескриптор, полученный из G_SHA256Init. }

procedure G_SHA256Transform(H: HSHA256; Source: PSHA256Block; Dest: PSHA256Digest);

{ G_SHA256Done завершает расчет хэш-функции SHA-256 для дескриптора H и
  возвращает полученное значение в параметре Hash, если этот параметр передан.
  Затем освобождает ресурсы, связанные с дескриптором H. }

procedure G_SHA256Done(H: HSHA256; Hash: PSHA256Digest); overload;
procedure G_SHA256Done(H: HSHA256); overload;

{ G_SHA256 возвращает в параметре Hash значение хэш-функции SHA-256 для области
  памяти, адресуемой параметром P, длиной L байт или для строки символов S. }

procedure G_SHA256(P: Pointer; L: Cardinal; Hash: PSHA256Digest); overload;
procedure G_SHA256(const S: string; Hash: PSHA256Digest); overload;

{ G_SHA256SelfTest проверяет работоспособность алгоритма SHA-256 по тестовым
  векторам, приведенным в FIPS180-2. Если тест пройден успешно, функция
  возвращает True, иначе False. }

function G_SHA256SelfTest: Boolean;

{ G_SHA256Copy копирует значение хэш-функции SHA-256 из области памяти,
  адресуемой параметром SourceHash, в область памяти, адресуемую параметром
  DestHash. Это аналогично вызову: G_CopyLongs(SourceHash, DestHash, 8). }

procedure G_SHA256Copy(SourceHash, DestHash: PSHA256Digest);

{ G_SHA256Equals возвращает True, если значение хэш-функции SHA-256,
  адресуемое параметром Hash1, равно значению, адресуемому параметром Hash2.
  В противном случае функция возвращает False. }

function G_SHA256Equals(Hash1, Hash2: PSHA256Digest): Boolean;

{ G_SHA256Clear обнуляет значение хэш-функции, адресуемое параметром Hash. }

procedure G_SHA256Clear(Hash: PSHA256Digest);


{ Функции G_Random... могут использоваться для генерации псевдослучайной
  последовательности чисел с периодом (2^19937)-1 на основе алгоритма:
  "Mersenne Twister: A 623-dimensionally equidistributed uniform pseudo-random
  number generator", Makoto Matsumoto and Takuji Nishimura, ACM Transactions
  on Modeling and Computer Simulation: Special Issue on Uniform Random Number
  Generation, Vol. 8, No. 1, January 1998, pp. 3-30. }

{ Тип массива, содержащего начальный вектор для генератора псевдослучайных
  чисел, и тип дескриптора, который возвращается из G_RandomInit, а затем,
  после работы с генератором, освобождается вызовом G_RandomDone. }

type
  PRandomVector = ^TRandomVector;
  TRandomVector = array[0..623] of LongWord;
  
  HMT = type Pointer;

{ G_RandomInit инициализирует генератор ПСП. Его дескриптор возвращается в
  var-параметре H. Этот дескриптор должен передаваться как первый параметр при
  вызове других функций G_Random.... Для инициализации используется беззнаковое
  целое число Seed, не равное нулю, или начальный вектор Vector. Дескриптор
  должен освобождаться в конце работы с генератором вызовом G_RandomDone. При
  инициализации с помощью числа Seed используется новый алгоритм, описанный
  на http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/emt19937ar.html. }

procedure G_RandomInit(var H: HMT; Seed: LongWord = 5489); overload;
procedure G_RandomInit(var H: HMT; Vector: PRandomVector); overload;

{ G_RandomGetVector копирует текущее содержимое вектора, используемого для
  генерации псевдослучайных чисел, в массив, переданный параметром Vector.
  Таким образом, в дальнейшем генератор можно инициализировать этим вектором
  и воспроизвести последовательность псевдослучайных чисел, начиная со
  следующего числа. В параметре H передается дескриптор генератора. }

procedure G_RandomGetVector(H: HMT; Vector: PRandomVector);

{ G_RandomSetVector задает новое значение вектора, используемого при генерации
  псевдослучайных чисел. Позволяет воспроизвести последовательность, начиная
  с вектора, переданного параметром Vector. H - дескриптор генератора. }

procedure G_RandomSetVector(H: HMT; Vector: PRandomVector);

{ G_RandomEncryptVector шифрует текущее состояние вектора, используемого для
  генерации псевдослучайных чисел, методом RC6 в режиме ECB. H - дескриптор
  генератора, EH - дескриптор процесса шифрования методом RC6. }

procedure G_RandomEncryptVector(H: HMT; EH: HRC6);

{ G_RandomValue возвращает следующее псевдослучайное число, которое является
  равномерно распределенным в интервале от 0 до $FFFFFFFF, для генератора,
  дескриптор которого передан параметром H. }

function G_RandomValue(H: HMT): LongWord;

{ G_RandomUniform возвращает псевдослучайную величину, равномерно распределенную
  в интервале [0, 1], для генератора, дескриптор которого передан параметром H.
  Непрерывная псевдослучайная величина с равномерным распределением в интервале
  [Min, Max] получается по формуле: (Max - Min) * G_RandomUniform(H) + Min. }

function G_RandomUniform(H: HMT): Extended;

{ G_RandomUInt32 возвращает целое псевдослучайное число (0 <= X < Range) для
  генератора, дескриптор которого передан параметром H. Функция G_RandomUInt64
  аналогична G_RandomUInt32, но допустимый диапазон задается 64-битным числом. }

function G_RandomUInt32(H: HMT; Range: LongWord): LongWord;
function G_RandomUInt64(H: HMT; Range: Int64): Int64;

{ G_RandomGauss используется для моделирования непрерывной случайной величины
  с нормальным законом распределения. Эта функция возвращает (0,1)-нормально
  распределенное псевдослучайное число для генератора, дескриптор которого
  передается параметром H. В параметре ExtraNumber может быть передан адрес
  переменной типа Double, в которую запишется другое число с аналогичным
  распределением. Это возможно, так как используемый алгоритм (Marsaglia-Bray)
  генерирует сразу пару чисел с нормальным распределением. Для того, чтобы
  получить величину с математическим ожиданием Mean и среднеквадратическим
  отклонением StdDev, используйте формулу: G_RandomGauss(ID) * StdDev + Mean. }

function G_RandomGauss(H: HMT; ExtraNumber: PDouble = nil): Extended;

{ G_RandomFill заполняет область памяти, адресуемую параметром P, длиной L байт
  псевдослучайными числами с равномерным законом распределения. H - дескриптор
  генератора, полученный при вызове G_RandomInit. }

procedure G_RandomFill(H: HMT; P: Pointer; L: Integer);

{ G_RandomDone освобождает ресурсы, связанные c генератором псевдослучайных
  чисел с дескриптором H. }

procedure G_RandomDone(H: HMT);

implementation

uses AcedBinary, AcedConsts, AcedStrings, AcedCommon;

type
  PRC4Data = ^TRC4Data;
  TRC4Data = record
    State: array[0..255] of Byte;
    X, Y: Byte;
  end;

procedure IntRC4Init(PSt, Key: Pointer; KeyLength: Cardinal);
asm
        PUSH    EBX
        PUSH    EDI
        MOV     EBX,$03020100
        PUSH    ESI
        MOV     EDI,EAX
        MOV     ESI,8
@@lp1:  MOV     [EAX],EBX
        ADD     EBX,$04040404
        MOV     [EAX+4],EBX
        ADD     EBX,$04040404
        MOV     [EAX+8],EBX
        ADD     EBX,$04040404
        MOV     [EAX+12],EBX
        ADD     EBX,$04040404
        MOV     [EAX+16],EBX
        ADD     EBX,$04040404
        MOV     [EAX+20],EBX
        ADD     EBX,$04040404
        MOV     [EAX+24],EBX
        ADD     EBX,$04040404
        MOV     [EAX+28],EBX
        ADD     EBX,$04040404
        ADD     EAX,32
        DEC     ESI
        JNE     @@lp1
        DEC     ECX
        JS      @@qt
        PUSH    EBP
        XOR     EAX,EAX
        MOV     EBP,$100
        PUSH    EDX
        PUSH    ECX
@@lp2:  MOV     BL,BYTE PTR [EDI+ESI]
        ADD     AL,BYTE PTR [EDX]
        ADD     AL,BL
        MOVZX   EAX,AL
        MOV     BH,BYTE PTR [EDI+EAX]
        MOV     BYTE PTR [EDI+EAX],BL
        MOV     BYTE PTR [EDI+ESI],BH
        INC     EDX
        DEC     ECX
        JS      @@me
        INC     ESI
        DEC     EBP
        JNE     @@lp2
@@nx:   MOV     [ESP],EBP
        POP     ECX
        POP     ECX
        POP     EBP
@@qt:   POP     ESI
        POP     EDI
        POP     EBX
        RET
@@me:   MOV     ECX,[ESP]
        MOV     EDX,[ESP+4]
        INC     ESI
        DEC     EBP
        JNE     @@lp2
        JMP     @@nx
end;

procedure IntRC4AvoidWeakness(H: HRC4);
asm
        PUSH    EDI
        PUSH    EBX
        MOV     EDI,EAX
        XOR     EBX,EBX
        MOV     BL,BYTE PTR [EAX+256]
        XOR     EDX,EDX
        MOV     DL,BYTE PTR [EAX+257]
        MOV     ECX,256
@@lp:   INC     EBX
        AND     EBX,$FF
        MOVZX   EAX,BYTE PTR [EDI+EBX]
        ADD     EDX,EAX
        AND     EDX,$FF
        MOV     AH,BYTE PTR [EDI+EDX]
        MOV     BYTE PTR [EDI+EDX],AL
        MOV     BYTE PTR [EDI+EBX],AH
        DEC     ECX
        JNE     @@lp
        MOV     [EDI+256],BL
        MOV     [EDI+257],DL
        POP     EBX
        POP     EDI
end;

procedure G_RC4Init(var H: HRC4; Key: Pointer; KeyLength: Cardinal);
begin
  GetMem(PRC4Data(H), SizeOf(TRC4Data));
  with PRC4Data(H)^ do
  begin
    IntRC4Init(@State, Key, KeyLength);
    X := 0;
    Y := 0;
  end;
  IntRC4AvoidWeakness(H);
end;

procedure G_RC4Apply(H: HRC4; P: Pointer; L: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EDI
        LEA     ESI,[EDX-1]
        MOV     EDI,EAX
        XOR     EBX,EBX
        MOV     BL,BYTE PTR [EAX+256]
        XOR     EDX,EDX
        MOV     DL,BYTE PTR [EAX+257]
@@lp:   INC     EBX
        AND     EBX,$FF
        MOVZX   EAX,BYTE PTR [EDI+EBX]
        ADD     EDX,EAX
        AND     EDX,$FF
        MOV     AH,BYTE PTR [EDI+EDX]
        MOV     BYTE PTR [EDI+EDX],AL
        ADD     AL,AH
        INC     ESI
        MOV     BYTE PTR [EDI+EBX],AH
        MOVZX   EAX,AL
        MOV     AL,BYTE PTR [EDI+EAX]
        XOR     BYTE PTR [ESI],AL
        DEC     ECX
        JNE     @@lp
        MOV     [EDI+256],BL
        MOV     [EDI+257],DL
        POP     EDI
@@qt:   POP     ESI
        POP     EBX
end;

{$IFDEF NO_MMX}

procedure IntFill32(P: Pointer; V: LongWord);
asm
        MOV     [EAX],EDX
        MOV     [EAX+4],EDX
        MOV     [EAX+8],EDX
        MOV     [EAX+12],EDX
        MOV     [EAX+16],EDX
        MOV     [EAX+20],EDX
        MOV     [EAX+24],EDX
        MOV     [EAX+28],EDX
        MOV     [EAX+32],EDX
        MOV     [EAX+36],EDX
        MOV     [EAX+40],EDX
        MOV     [EAX+44],EDX
        MOV     [EAX+48],EDX
        MOV     [EAX+52],EDX
        MOV     [EAX+56],EDX
        MOV     [EAX+60],EDX
        MOV     [EAX+64],EDX
        MOV     [EAX+68],EDX
        MOV     [EAX+72],EDX
        MOV     [EAX+76],EDX
        MOV     [EAX+80],EDX
        MOV     [EAX+84],EDX
        MOV     [EAX+88],EDX
        MOV     [EAX+92],EDX
        MOV     [EAX+96],EDX
        MOV     [EAX+100],EDX
        MOV     [EAX+104],EDX
        MOV     [EAX+108],EDX
        MOV     [EAX+112],EDX
        MOV     [EAX+116],EDX
        MOV     [EAX+120],EDX
        MOV     [EAX+124],EDX
end;

procedure IntRC4Clear(H: HRC4);
asm
        XOR     EDX,EDX
        CALL    IntFill32
        ADD     EAX,128
        CALL    IntFill32
        MOV     WORD PTR [EAX+128],DX
end;

{$ELSE}

procedure IntFill32(P: Pointer);
asm
        MOVQ    [EAX],MM0
        MOVQ    [EAX+8],MM0
        MOVQ    [EAX+16],MM0
        MOVQ    [EAX+24],MM0
        MOVQ    [EAX+32],MM0
        MOVQ    [EAX+40],MM0
        MOVQ    [EAX+48],MM0
        MOVQ    [EAX+56],MM0
        MOVQ    [EAX+64],MM0
        MOVQ    [EAX+72],MM0
        MOVQ    [EAX+80],MM0
        MOVQ    [EAX+88],MM0
        MOVQ    [EAX+96],MM0
        MOVQ    [EAX+104],MM0
        MOVQ    [EAX+112],MM0
        MOVQ    [EAX+120],MM0
end;

procedure IntRC4Clear(H: HRC4);
asm
        PXOR    MM0,MM0
        CALL    IntFill32
        ADD     EAX,128
        CALL    IntFill32
        MOV     WORD PTR [EAX+128],DX
        EMMS
end;

{$ENDIF}

procedure G_RC4Done(H: HRC4);
begin
  IntRC4Clear(H);
  FreeMem(PRC4Data(H));
end;

function G_RC4SelfTest: Boolean;
const
  PlainText: string = 'DCEE4CF92C';
  UserKey: string = '618A63D2FB';
  CipherText: string = '04399148D9';
var
  S, K: string;
  H: HRC4;
begin
  S := G_CodesToStr(PlainText);
  K := G_CodesToStr(UserKey);
  G_RC4Init(H, Pointer(K), Length(K));
  G_RC4Apply(H, Pointer(S), Length(S));
  G_RC4Done(H);
  if not G_SameStr(G_StrToCodes(S), CipherText) then
  begin
    Result := False;
    Exit;
  end;
  G_RC4Init(H, Pointer(K), Length(K));
  G_RC4Apply(H, Pointer(S), Length(S));
  G_RC4Done(H);
  Result := G_SameStr(G_StrToCodes(S), PlainText);
end;

type
  PRC6Data = ^TRC6Data;
  TRC6Data = record
    V: TRC6Vector;
    KeyData: array[0..43] of LongWord;
  end;

const
  RC6_Shifts: array[0..43] of LongWord =
    (4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76,80,84,88,92,96,100,
     104,108,112,116,120,124,128,132,136,140,144,148,152,156,160,164,168,172,0);

{$IFDEF NO_MMX}

procedure IntRC6Init(H: HRC6; Key: Pointer; KeyLength: Cardinal);
asm
        PUSH    EBX
        PUSH    EBP
        PUSH    ESI
        XOR     EBP,EBP
        PUSH    EDI
        MOV     [EAX],EBP
        MOV     [EAX+4],EBP
        MOV     [EAX+8],EBP
        MOV     [EAX+12],EBP
        LEA     EBX,[EAX+16]
        TEST    ECX,ECX
        JE      @@mz
        SUB     ESP,$100
        MOV     ESI,ECX
        MOV     EBP,ECX
        MOV     EDI,ESP
        SHR     ESI,2
        MOV     EAX,ESI
        JE      @@nnx
@@ff:   MOV     ECX,[EDX+ESI*4-4]
        MOV     [EDI+ESI*4-4],ECX
        DEC     ESI
        JNE     @@ff
@@nnx:  AND     EBP,3
        XOR     ECX,ECX
        JMP     DWORD PTR @@tV[EBP*4]
@@tV:   DD      @@pe, @@t1, @@t2, @@t3
@@t3:   MOVZX   ECX,BYTE PTR [EDX+EAX*4+2]
@@t2:   SHL     ECX,8
        MOVZX   EBP,BYTE PTR [EDX+EAX*4+1]
        OR      ECX,EBP
@@t1:   SHL     ECX,8
        MOVZX   EBP,BYTE PTR [EDX+EAX*4]
        OR      ECX,EBP
        MOV     [EDI+EAX*4],ECX
        INC     EAX
@@pe:   MOV     ESI,EBX
        MOV     ECX,11
        MOV     EDX,$B7E15163
@@lp1:  MOV     [ESI],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+4],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+8],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+12],EDX
        ADD     EDX,$9E3779B9
        ADD     ESI,16
        DEC     ECX
        JNE     @@lp1
        CMP     EAX,44
        JA      @@me
        MOV     EBP,132
        SHL     EAX,2
@@nx:   ADD     EAX,EDI
        PUSH    EAX
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    EAX
        MOV     ESI,ESP
@@lp2:  MOV     ECX,[EBX+EAX]
        ADD     ECX,[ESI]
        ADD     ECX,[ESI+4]
        ROL     ECX,3
        MOV     [ESI+4],ECX
        MOV     [EBX+EAX],ECX
        ADD     ECX,[ESI]
        MOV     EDX,ECX
        ADD     EDX,[EDI]
        ROL     EDX,CL
        MOV     [EDI],EDX
        MOV     [ESI],EDX
        MOV     EAX,DWORD PTR [EAX+RC6_Shifts]
        ADD     EDI,4
        CMP     EDI,[ESI+8]
        JE      @@jx
@@nj:   DEC     EBP
        JNE     @@lp2
        MOV     EAX,ESP
        XOR     EDX,EDX
        MOV     [EAX],EDX
        MOV     [EAX+4],EDX
        MOV     [EAX+8],EDX
        ADD     EAX,12
        CALL    IntFill32
        ADD     EAX,128
        CALL    IntFill32
        ADD     ESP,$10C
@@k2:   POP     EDI
        POP     ESI
        POP     EBP
        POP     EBX
        RET
@@me:   MOV     EBP,EAX
        ADD     EBP,EAX
        ADD     EBP,EAX
        JMP     @@nx
@@jx:   LEA     EDI,[ESP+12]
        JMP     @@nj
@@mz:   MOV     ECX,11
        MOV     EDX,$B7E15163
@@lz:   MOV     [EBX],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+4],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+8],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+12],EDX
        ADD     EDX,$9E3779B9
        ADD     EBX,16
        DEC     ECX
        JNE     @@lz
        JMP     @@k2
end;

{$ELSE}

procedure IntRC6Init(H: HRC6; Key: Pointer; KeyLength: Cardinal);
asm
        PUSH    EBX
        PUSH    EBP
        PUSH    ESI
        XOR     EBP,EBP
        PUSH    EDI
        MOV     [EAX],EBP
        MOV     [EAX+4],EBP
        MOV     [EAX+8],EBP
        MOV     [EAX+12],EBP
        LEA     EBX,[EAX+16]
        TEST    ECX,ECX
        JE      @@mz
        SUB     ESP,$100
        MOV     ESI,ECX
        MOV     EBP,ECX
        MOV     EDI,ESP
        SHR     ESI,2
        MOV     EAX,ESI
        JE      @@nnx
@@ff:   MOV     ECX,[EDX+ESI*4-4]
        MOV     [EDI+ESI*4-4],ECX
        DEC     ESI
        JNE     @@ff
@@nnx:  AND     EBP,3
        XOR     ECX,ECX
        JMP     DWORD PTR @@tV[EBP*4]
@@tV:   DD      @@pe, @@t1, @@t2, @@t3
@@t3:   MOVZX   ECX,BYTE PTR [EDX+EAX*4+2]
@@t2:   SHL     ECX,8
        MOVZX   EBP,BYTE PTR [EDX+EAX*4+1]
        OR      ECX,EBP
@@t1:   SHL     ECX,8
        MOVZX   EBP,BYTE PTR [EDX+EAX*4]
        OR      ECX,EBP
        MOV     [EDI+EAX*4],ECX
        INC     EAX
@@pe:   MOV     ESI,EBX
        MOV     ECX,11
        MOV     EDX,$B7E15163
@@lp1:  MOV     [ESI],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+4],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+8],EDX
        ADD     EDX,$9E3779B9
        MOV     [ESI+12],EDX
        ADD     EDX,$9E3779B9
        ADD     ESI,16
        DEC     ECX
        JNE     @@lp1
        CMP     EAX,44
        JA      @@me
        MOV     EBP,132
        SHL     EAX,2
@@nx:   ADD     EAX,EDI
        PUSH    EAX
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    EAX
        MOV     ESI,ESP
@@lp2:  MOV     ECX,[EBX+EAX]
        ADD     ECX,[ESI]
        ADD     ECX,[ESI+4]
        ROL     ECX,3
        MOV     [ESI+4],ECX
        MOV     [EBX+EAX],ECX
        ADD     ECX,[ESI]
        MOV     EDX,ECX
        ADD     EDX,[EDI]
        ROL     EDX,CL
        MOV     [EDI],EDX
        MOV     [ESI],EDX
        MOV     EAX,DWORD PTR [EAX+RC6_Shifts]
        ADD     EDI,4
        CMP     EDI,[ESI+8]
        JE      @@jx
@@nj:   DEC     EBP
        JNE     @@lp2
        MOV     EAX,ESP
        PXOR    MM0,MM0
        CALL    IntFill32
        ADD     EAX,128
        CALL    IntFill32
        MOVQ    [EAX+128],MM0
        XOR     EDX,EDX
        MOV     [EAX+136],EDX
        EMMS
        ADD     ESP,$10C
@@k2:   POP     EDI
        POP     ESI
        POP     EBP
        POP     EBX
        RET
@@me:   MOV     EBP,EAX
        ADD     EBP,EAX
        ADD     EBP,EAX
        JMP     @@nx
@@jx:   LEA     EDI,[ESP+12]
        JMP     @@nj
@@mz:   MOV     ECX,11
        MOV     EDX,$B7E15163
@@lz:   MOV     [EBX],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+4],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+8],EDX
        ADD     EDX,$9E3779B9
        MOV     [EBX+12],EDX
        ADD     EDX,$9E3779B9
        ADD     EBX,16
        DEC     ECX
        JNE     @@lz
        JMP     @@k2
end;

{$ENDIF}

procedure G_RC6Init(var H: HRC6; Key: Pointer; KeyLength: Cardinal);
begin
  GetMem(PRC6Data(H), SizeOf(TRC6Data));
  if KeyLength > 255 then
    KeyLength := 255;
  IntRC6Init(H, Key, KeyLength);
end;

procedure G_RC6EncryptECB(H: HRC6; V: PRC6Vector);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        LEA     EBX,[EAX+24]
        PUSH    EBP
        MOV     ESI,[EDX]
        PUSH    EDX
        MOV     EDI,[EDX+4]
        MOV     EBP,[EDX+12]
        ADD     EDI,[EBX-8]
        ADD     EBP,[EBX-4]
        MOV     EDX,[EDX+8]
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        ROL     EAX,5
        XOR     ESI,EAX
        IMUL    ECX,EBP
        ROL     ECX,5
        XOR     EDX,ECX
        ROL     ESI,CL
        MOV     ECX,EAX
        ROL     EDX,CL
        ADD     ESI,[EBX]
        ADD     EDX,[EBX+4]
        LEA     ECX,[ESI+ESI+1]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        ROL     EAX,5
        XOR     EDI,EAX
        IMUL    ECX,ESI
        ROL     ECX,5
        XOR     EBP,ECX
        ROL     EDI,CL
        MOV     ECX,EAX
        ROL     EBP,CL
        ADD     EDI,[EBX+8]
        ADD     EBP,[EBX+12]
        LEA     ECX,[EDI+EDI+1]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        XOR     EDX,EAX
        IMUL    ECX,EDI
        ROL     ECX,5
        XOR     ESI,ECX
        ROL     EDX,CL
        MOV     ECX,EAX
        ROL     ESI,CL
        ADD     EDX,[EBX+16]
        ADD     ESI,[EBX+20]
        LEA     ECX,[EDX+EDX+1]
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        XOR     EBP,EAX
        IMUL    ECX,EDX
        ROL     ECX,5
        XOR     EDI,ECX
        ROL     EBP,CL
        MOV     ECX,EAX
        ROL     EDI,CL
        ADD     EBP,[EBX+24]
        ADD     EDI,[EBX+28]
        LEA     ECX,[EBP+EBP+1]
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        ROL     EAX,5
        XOR     ESI,EAX
        IMUL    ECX,EBP
        ROL     ECX,5
        XOR     EDX,ECX
        ROL     ESI,CL
        ADD     ESI,[EBX+32]
        MOV     ECX,EAX
        ROL     EDX,CL
        ADD     EDX,[EBX+36]
        LEA     ECX,[ESI+ESI+1]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        ROL     EAX,5
        XOR     EDI,EAX
        IMUL    ECX,ESI
        ROL     ECX,5
        XOR     EBP,ECX
        ROL     EDI,CL
        MOV     ECX,EAX
        ROL     EBP,CL
        ADD     EDI,[EBX+40]
        ADD     EBP,[EBX+44]
        LEA     ECX,[EDI+EDI+1]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        XOR     EDX,EAX
        IMUL    ECX,EDI
        ROL     ECX,5
        XOR     ESI,ECX
        ROL     EDX,CL
        MOV     ECX,EAX
        ROL     ESI,CL
        ADD     EDX,[EBX+48]
        ADD     ESI,[EBX+52]
        LEA     ECX,[EDX+EDX+1]
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        XOR     EBP,EAX
        IMUL    ECX,EDX
        ROL     ECX,5
        XOR     EDI,ECX
        ROL     EBP,CL
        MOV     ECX,EAX
        ROL     EDI,CL
        ADD     EBP,[EBX+56]
        ADD     EDI,[EBX+60]
        LEA     ECX,[EBP+EBP+1]
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        ROL     EAX,5
        XOR     ESI,EAX
        IMUL    ECX,EBP
        ROL     ECX,5
        XOR     EDX,ECX
        ROL     ESI,CL
        MOV     ECX,EAX
        ROL     EDX,CL
        ADD     ESI,[EBX+64]
        ADD     EDX,[EBX+68]
        LEA     ECX,[ESI+ESI+1]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        ROL     EAX,5
        XOR     EDI,EAX
        IMUL    ECX,ESI
        ROL     ECX,5
        XOR     EBP,ECX
        ROL     EDI,CL
        MOV     ECX,EAX
        ROL     EBP,CL
        ADD     EDI,[EBX+72]
        ADD     EBP,[EBX+76]
        LEA     ECX,[EDI+EDI+1]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        XOR     EDX,EAX
        IMUL    ECX,EDI
        ROL     ECX,5
        XOR     ESI,ECX
        ROL     EDX,CL
        MOV     ECX,EAX
        ROL     ESI,CL
        ADD     EDX,[EBX+80]
        ADD     ESI,[EBX+84]
        LEA     ECX,[EDX+EDX+1]
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        XOR     EBP,EAX
        IMUL    ECX,EDX
        ROL     ECX,5
        XOR     EDI,ECX
        ROL     EBP,CL
        MOV     ECX,EAX
        ROL     EDI,CL
        ADD     EBP,[EBX+88]
        ADD     EDI,[EBX+92]
        LEA     ECX,[EBP+EBP+1]
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        ROL     EAX,5
        XOR     ESI,EAX
        IMUL    ECX,EBP
        ROL     ECX,5
        XOR     EDX,ECX
        ROL     ESI,CL
        MOV     ECX,EAX
        ROL     EDX,CL
        ADD     ESI,[EBX+96]
        ADD     EDX,[EBX+100]
        LEA     ECX,[ESI+ESI+1]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        ROL     EAX,5
        XOR     EDI,EAX
        IMUL    ECX,ESI
        ROL     ECX,5
        XOR     EBP,ECX
        ROL     EDI,CL
        MOV     ECX,EAX
        ROL     EBP,CL
        ADD     EDI,[EBX+104]
        ADD     EBP,[EBX+108]
        LEA     ECX,[EDI+EDI+1]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        XOR     EDX,EAX
        IMUL    ECX,EDI
        ROL     ECX,5
        XOR     ESI,ECX
        ROL     EDX,CL
        MOV     ECX,EAX
        ROL     ESI,CL
        ADD     EDX,[EBX+112]
        ADD     ESI,[EBX+116]
        LEA     ECX,[EDX+EDX+1]
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        XOR     EBP,EAX
        IMUL    ECX,EDX
        ROL     ECX,5
        XOR     EDI,ECX
        ROL     EBP,CL
        MOV     ECX,EAX
        ROL     EDI,CL
        ADD     EBP,[EBX+120]
        ADD     EDI,[EBX+124]
        LEA     ECX,[EBP+EBP+1]
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        ROL     EAX,5
        XOR     ESI,EAX
        IMUL    ECX,EBP
        ROL     ECX,5
        XOR     EDX,ECX
        ROL     ESI,CL
        MOV     ECX,EAX
        ROL     EDX,CL
        ADD     ESI,[EBX+128]
        ADD     EDX,[EBX+132]
        LEA     ECX,[ESI+ESI+1]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        ROL     EAX,5
        XOR     EDI,EAX
        IMUL    ECX,ESI
        ROL     ECX,5
        XOR     EBP,ECX
        ROL     EDI,CL
        MOV     ECX,EAX
        ROL     EBP,CL
        ADD     EDI,[EBX+136]
        ADD     EBP,[EBX+140]
        LEA     ECX,[EDI+EDI+1]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        XOR     EDX,EAX
        IMUL    ECX,EDI
        ROL     ECX,5
        XOR     ESI,ECX
        ROL     EDX,CL
        MOV     ECX,EAX
        ROL     ESI,CL
        ADD     EDX,[EBX+144]
        ADD     ESI,[EBX+148]
        LEA     ECX,[EDX+EDX+1]
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        XOR     EBP,EAX
        IMUL    ECX,EDX
        ROL     ECX,5
        XOR     EDI,ECX
        ROL     EBP,CL
        MOV     ECX,EAX
        ROL     EDI,CL
        ADD     EBP,[EBX+152]
        ADD     EDI,[EBX+156]
        POP     ECX
        ADD     ESI,[EBX+160]
        ADD     EDX,[EBX+164]
        MOV     [ECX+12],EBP
        MOV     [ECX],ESI
        POP     EBP
        MOV     [ECX+4],EDI
        MOV     [ECX+8],EDX
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure G_RC6DecryptECB(H: HRC6; V: PRC6Vector);
asm
        PUSH    EBX
        PUSH    EBP
        PUSH    ESI
        LEA     EBX,[EAX+24]
        MOV     ESI,[EDX+12]
        PUSH    EDI
        MOV     EBP,[EDX+8]
        MOV     EDI,[EDX]
        PUSH    EDX
        SUB     EBP,[EBX+164]
        SUB     EDI,[EBX+160]
        PUSH    ECX
        MOV     EDX,[EDX+4]
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        LEA     ECX,[EDI+EDI+1]
        IMUL    ECX,EDI
        SUB     EDX,[EBX+156]
        ROL     EAX,5
        ROL     ECX,5
        SUB     ESI,[EBX+152]
        ROR     EDX,CL
        XCHG    EAX,ECX
        ROR     ESI,CL
        XOR     EDX,ECX
        XOR     ESI,EAX
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        LEA     ECX,[ESI+ESI+1]
        SUB     EDI,[EBX+148]
        IMUL    ECX,ESI
        ROL     EAX,5
        ROL     ECX,5
        SUB     EBP,[EBX+144]
        ROR     EDI,CL
        XCHG    EAX,ECX
        ROR     EBP,CL
        XOR     EDI,ECX
        XOR     EBP,EAX
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        SUB     ESI,[EBX+140]
        IMUL    ECX,EBP
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDX,[EBX+136]
        ROR     ESI,CL
        XCHG    EAX,ECX
        ROR     EDX,CL
        XOR     ESI,ECX
        XOR     EDX,EAX
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        LEA     ECX,[EDX+EDX+1]
        SUB     EBP,[EBX+132]
        IMUL    ECX,EDX
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDI,[EBX+128]
        ROR     EBP,CL
        XCHG    EAX,ECX
        ROR     EDI,CL
        XOR     EBP,ECX
        XOR     EDI,EAX
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        LEA     ECX,[EDI+EDI+1]
        SUB     EDX,[EBX+124]
        IMUL    ECX,EDI
        ROL     EAX,5
        ROL     ECX,5
        SUB     ESI,[EBX+120]
        ROR     EDX,CL
        XCHG    EAX,ECX
        ROR     ESI,CL
        XOR     EDX,ECX
        XOR     ESI,EAX
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        LEA     ECX,[ESI+ESI+1]
        SUB     EDI,[EBX+116]
        IMUL    ECX,ESI
        ROL     EAX,5
        ROL     ECX,5
        SUB     EBP,[EBX+112]
        ROR     EDI,CL
        XCHG    EAX,ECX
        ROR     EBP,CL
        XOR     EDI,ECX
        XOR     EBP,EAX
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        SUB     ESI,[EBX+108]
        IMUL    ECX,EBP
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDX,[EBX+104]
        ROR     ESI,CL
        XCHG    EAX,ECX
        ROR     EDX,CL
        XOR     ESI,ECX
        XOR     EDX,EAX
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        LEA     ECX,[EDX+EDX+1]
        SUB     EBP,[EBX+100]
        IMUL    ECX,EDX
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDI,[EBX+96]
        ROR     EBP,CL
        XCHG    EAX,ECX
        ROR     EDI,CL
        XOR     EBP,ECX
        XOR     EDI,EAX
        SUB     EDX,[EBX+92]
        SUB     ESI,[EBX+88]
        LEA     ECX,[EDI+EDI+1]
        IMUL    ECX,EDI
        ROL     ECX,5
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        ROL     EAX,5
        MOV     [ESP],ECX
        ROR     EDX,CL
        XOR     EDX,EAX
        MOV     ECX,EAX
        ROR     ESI,CL
        XOR     ESI,[ESP]
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        LEA     ECX,[ESI+ESI+1]
        SUB     EDI,[EBX+84]
        IMUL    ECX,ESI
        ROL     EAX,5
        ROL     ECX,5
        SUB     EBP,[EBX+80]
        ROR     EDI,CL
        XCHG    EAX,ECX
        ROR     EBP,CL
        XOR     EDI,ECX
        XOR     EBP,EAX
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        SUB     ESI,[EBX+76]
        IMUL    ECX,EBP
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDX,[EBX+72]
        ROR     ESI,CL
        XCHG    EAX,ECX
        ROR     EDX,CL
        XOR     ESI,ECX
        XOR     EDX,EAX
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        LEA     ECX,[EDX+EDX+1]
        SUB     EBP,[EBX+68]
        IMUL    ECX,EDX
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDI,[EBX+64]
        ROR     EBP,CL
        XCHG    EAX,ECX
        ROR     EDI,CL
        XOR     EBP,ECX
        XOR     EDI,EAX
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        LEA     ECX,[EDI+EDI+1]
        SUB     EDX,[EBX+60]
        IMUL    ECX,EDI
        ROL     EAX,5
        ROL     ECX,5
        SUB     ESI,[EBX+56]
        ROR     EDX,CL
        XCHG    EAX,ECX
        ROR     ESI,CL
        XOR     EDX,ECX
        XOR     ESI,EAX
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        LEA     ECX,[ESI+ESI+1]
        SUB     EDI,[EBX+52]
        IMUL    ECX,ESI
        ROL     EAX,5
        ROL     ECX,5
        SUB     EBP,[EBX+48]
        ROR     EDI,CL
        XCHG    EAX,ECX
        ROR     EBP,CL
        XOR     EDI,ECX
        XOR     EBP,EAX
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        SUB     ESI,[EBX+44]
        IMUL    ECX,EBP
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDX,[EBX+40]
        ROR     ESI,CL
        XCHG    EAX,ECX
        ROR     EDX,CL
        XOR     ESI,ECX
        XOR     EDX,EAX
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        LEA     ECX,[EDX+EDX+1]
        SUB     EBP,[EBX+36]
        IMUL    ECX,EDX
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDI,[EBX+32]
        ROR     EBP,CL
        XCHG    EAX,ECX
        ROR     EDI,CL
        XOR     EBP,ECX
        XOR     EDI,EAX
        LEA     EAX,[EBP+EBP+1]
        IMUL    EAX,EBP
        LEA     ECX,[EDI+EDI+1]
        SUB     EDX,[EBX+28]
        IMUL    ECX,EDI
        ROL     EAX,5
        ROL     ECX,5
        SUB     ESI,[EBX+24]
        ROR     EDX,CL
        XCHG    EAX,ECX
        ROR     ESI,CL
        XOR     EDX,ECX
        XOR     ESI,EAX
        LEA     EAX,[EDX+EDX+1]
        IMUL    EAX,EDX
        LEA     ECX,[ESI+ESI+1]
        SUB     EDI,[EBX+20]
        IMUL    ECX,ESI
        ROL     EAX,5
        ROL     ECX,5
        SUB     EBP,[EBX+16]
        ROR     EDI,CL
        XCHG    EAX,ECX
        ROR     EBP,CL
        XOR     EDI,ECX
        XOR     EBP,EAX
        LEA     EAX,[EDI+EDI+1]
        IMUL    EAX,EDI
        LEA     ECX,[EBP+EBP+1]
        SUB     ESI,[EBX+12]
        IMUL    ECX,EBP
        ROL     EAX,5
        ROL     ECX,5
        SUB     EDX,[EBX+8]
        ROR     ESI,CL
        XCHG    EAX,ECX
        ROR     EDX,CL
        XOR     ESI,ECX
        XOR     EDX,EAX
        SUB     EBP,[EBX+4]
        SUB     EDI,[EBX]
        LEA     ECX,[EDX+EDX+1]
        IMUL    ECX,EDX
        ROL     ECX,5
        LEA     EAX,[ESI+ESI+1]
        IMUL    EAX,ESI
        ROL     EAX,5
        MOV     [ESP],ECX
        ROR     EBP,CL
        XOR     EBP,EAX
        MOV     ECX,EAX
        ROR     EDI,CL
        POP     EAX
        XOR     EDI,EAX
        SUB     ESI,[EBX-4]
        SUB     EDX,[EBX-8]
        POP     ECX
        MOV     [ECX],EDI
        MOV     [ECX+4],EDX
        POP     EDI
        MOV     [ECX+12],ESI
        MOV     [ECX+8],EBP
        POP     ESI
        POP     EBP
        POP     EBX
end;

procedure G_RC6GetVector(H: HRC6; IV: PRC6Vector);
asm
        MOV     ECX,[EAX]
        MOV     [EDX],ECX
        MOV     ECX,[EAX+4]
        MOV     [EDX+4],ECX
        MOV     ECX,[EAX+8]
        MOV     [EDX+8],ECX
        MOV     ECX,[EAX+12]
        MOV     [EDX+12],ECX
end;

procedure G_RC6SetVector(H: HRC6; IV: PRC6Vector);
asm
        MOV     ECX,[EDX]
        MOV     [EAX],ECX
        MOV     ECX,[EDX+4]
        MOV     [EAX+4],ECX
        MOV     ECX,[EDX+8]
        MOV     [EAX+8],ECX
        MOV     ECX,[EDX+12]
        MOV     [EAX+12],ECX
end;

procedure G_RC6SetOrdinaryVector(H: HRC6);
asm
        XOR     EDX,EDX
        MOV     [EAX],EDX
        MOV     [EAX+4],EDX
        MOV     [EAX+8],EDX
        MOV     [EAX+12],EDX
        MOV     EDX,EAX
        CALL    G_RC6EncryptECB
end;

procedure G_RC6EncryptCFB(H: HRC6; P: Pointer; L: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        PUSH    ECX
        MOV     EDI,EDX
        SHR     ESI,4
        JE      @@nx
@@lp1:  MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     EAX,[EBX]
        XOR     EAX,[EDI]
        MOV     [EBX],EAX
        MOV     [EDI],EAX
        MOV     EAX,[EBX+4]
        XOR     EAX,[EDI+4]
        MOV     [EBX+4],EAX
        MOV     [EDI+4],EAX
        MOV     EAX,[EBX+8]
        XOR     EAX,[EDI+8]
        MOV     [EBX+8],EAX
        MOV     [EDI+8],EAX
        MOV     EAX,[EBX+12]
        XOR     EAX,[EDI+12]
        MOV     [EBX+12],EAX
        MOV     [EDI+12],EAX
        ADD     EDI,$10
        DEC     ESI
        JNE     @@lp1
@@nx:   POP     ESI
        AND     ESI,$F
        JE      @@qt
        MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     ECX,ESI
        SHR     ESI,2
        JE      @@uu
@@lp2:  MOV     EAX,[EBX]
        XOR     EAX,[EDI]
        MOV     [EBX],EAX
        MOV     [EDI],EAX
        ADD     EBX,4
        ADD     EDI,4
        DEC     ESI
        JNE     @@lp2
@@uu:   AND     ECX,3
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@qt, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[EBX+2]
        XOR     AL,[EDI+2]
        MOV     [EBX+2],AL
        MOV     [EDI+2],AL
@@t2:   MOV     AL,[EBX+1]
        XOR     AL,[EDI+1]
        MOV     [EBX+1],AL
        MOV     [EDI+1],AL
@@t1:   MOV     AL,[EBX]
        XOR     AL,[EDI]
        MOV     [EBX],AL
        MOV     [EDI],AL
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

procedure G_RC6DecryptCFB(H: HRC6; P: Pointer; L: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        PUSH    ECX
        MOV     EDI,EDX
        SHR     ESI,4
        JE      @@nx
@@lp1:  MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     EAX,[EBX]
        MOV     EDX,[EDI]
        XOR     EAX,EDX
        MOV     [EBX],EDX
        MOV     [EDI],EAX
        MOV     EAX,[EBX+4]
        MOV     EDX,[EDI+4]
        XOR     EAX,EDX
        MOV     [EBX+4],EDX
        MOV     [EDI+4],EAX
        MOV     EAX,[EBX+8]
        MOV     EDX,[EDI+8]
        XOR     EAX,EDX
        MOV     [EBX+8],EDX
        MOV     [EDI+8],EAX
        MOV     EAX,[EBX+12]
        MOV     EDX,[EDI+12]
        XOR     EAX,EDX
        MOV     [EBX+12],EDX
        MOV     [EDI+12],EAX
        ADD     EDI,$10
        DEC     ESI
        JNE     @@lp1
@@nx:   POP     ESI
        AND     ESI,$F
        JE      @@qt
        MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     ECX,ESI
        SHR     ESI,2
        JE      @@uu
@@lp2:  MOV     EAX,[EBX]
        MOV     EDX,[EDI]
        XOR     EAX,EDX
        MOV     [EBX],EDX
        MOV     [EDI],EAX
        ADD     EBX,4
        ADD     EDI,4
        DEC     ESI
        JNE     @@lp2
@@uu:   AND     ECX,3
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@qt, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[EBX+2]
        MOV     DL,[EDI+2]
        XOR     AL,DL
        MOV     [EBX+2],DL
        MOV     [EDI+2],AL
@@t2:   MOV     AL,[EBX+1]
        MOV     DL,[EDI+1]
        XOR     AL,DL
        MOV     [EBX+1],DL
        MOV     [EDI+1],AL
@@t1:   MOV     AL,[EBX]
        MOV     DL,[EDI]
        XOR     AL,DL
        MOV     [EBX],DL
        MOV     [EDI],AL
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

procedure G_RC6ApplyOFB(H: HRC6; P: Pointer; L: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        PUSH    ECX
        MOV     EDI,EDX
        SHR     ESI,4
        JE      @@nx
@@lp1:  MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     EAX,[EDI]
        XOR     EAX,[EBX]
        MOV     [EDI],EAX
        MOV     EAX,[EDI+4]
        XOR     EAX,[EBX+4]
        MOV     [EDI+4],EAX
        MOV     EAX,[EDI+8]
        XOR     EAX,[EBX+8]
        MOV     [EDI+8],EAX
        MOV     EAX,[EDI+12]
        XOR     EAX,[EBX+12]
        MOV     [EDI+12],EAX
        ADD     EDI,$10
        DEC     ESI
        JNE     @@lp1
@@nx:   POP     ESI
        AND     ESI,$F
        JE      @@qt
        MOV     EAX,EBX
        MOV     EDX,EBX
        CALL    G_RC6EncryptECB
        MOV     ECX,ESI
        SHR     ESI,2
        JE      @@uu
@@lp2:  MOV     EAX,[EDI]
        XOR     EAX,[EBX]
        MOV     [EDI],EAX
        ADD     EBX,4
        ADD     EDI,4
        DEC     ESI
        JNE     @@lp2
@@uu:   AND     ECX,3
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@qt, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[EDI+2]
        XOR     AL,[EBX+2]
        MOV     [EDI+2],AL
@@t2:   MOV     AL,[EDI+1]
        XOR     AL,[EBX+1]
        MOV     [EDI+1],AL
@@t1:   MOV     AL,[EDI]
        XOR     AL,[EBX]
        MOV     [EDI],AL
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
end;

{$IFDEF NO_MMX}

procedure IntFill16(P: Pointer; L: LongWord);
asm
        MOV     [EAX],EDX
        MOV     [EAX+4],EDX
        MOV     [EAX+8],EDX
        MOV     [EAX+12],EDX
        MOV     [EAX+16],EDX
        MOV     [EAX+20],EDX
        MOV     [EAX+24],EDX
        MOV     [EAX+28],EDX
        MOV     [EAX+32],EDX
        MOV     [EAX+36],EDX
        MOV     [EAX+40],EDX
        MOV     [EAX+44],EDX
        MOV     [EAX+48],EDX
        MOV     [EAX+52],EDX
        MOV     [EAX+56],EDX
        MOV     [EAX+60],EDX
end;

procedure IntRC6Clear(H: HRC6);
asm
        XOR     EDX,EDX
        CALL    IntFill16
        ADD     EAX,64
        CALL    IntFill32
end;

{$ELSE}

procedure IntFill16(P: Pointer);
asm
        MOVQ    [EAX],MM0
        MOVQ    [EAX+8],MM0
        MOVQ    [EAX+16],MM0
        MOVQ    [EAX+24],MM0
        MOVQ    [EAX+32],MM0
        MOVQ    [EAX+40],MM0
        MOVQ    [EAX+48],MM0
        MOVQ    [EAX+56],MM0
end;

procedure IntRC6Clear(H: HRC6);
asm
        PXOR    MM0,MM0
        CALL    IntFill32
        ADD     EAX,128
        CALL    IntFill16
        EMMS
end;

{$ENDIF}

procedure G_RC6Done(H: HRC6);
begin
  IntRC6Clear(H);
  FreeMem(PRC6Data(H));
end;

function G_RC6SelfTest: Boolean;
const
  PlainTexts: array[0..1] of string =
    ('00000000000000000000000000000000',
     '02132435465768798A9BACBDCEDFE0F1');
  UserKeys: array[0..5] of string =
    ('00000000000000000000000000000000',
     '0123456789ABCDEF0112233445566778',
     '000000000000000000000000000000000000000000000000',
     '0123456789ABCDEF0112233445566778899AABBCCDDEEFF0',
     '0000000000000000000000000000000000000000000000000000000000000000',
     '0123456789ABCDEF0112233445566778899AABBCCDDEEFF01032547698BADCFE');
  CipherTexts: array[0..5] of string =
    ('8FC3A53656B1F778C129DF4E9848A41E',
     '524E192F4715C6231F51F6367EA43F18',
     '6CD61BCB190B30384E8A3F168690AE82',
     '688329D019E505041E52E92AF95291D4',
     '8F5FBD0510D15FA893FA3FDA6E857EC2',
     'C8241816F0D7E48920AD16A1674E5D48');
var
  K, S: string;
  H: HRC6;
  I: Integer;
begin
  for I := 0 to 5 do
  begin
    K := G_CodesToStr(UserKeys[I]);
    SetString(K, PChar(K), Length(K));
    G_RC6Init(H, Pointer(K), Length(K));
    S := G_CodesToStr(PlainTexts[I and 1]);
    SetString(S, PChar(S), Length(S));
    G_RC6EncryptECB(H, Pointer(S));
    if not G_SameStr(G_StrToCodes(S), CipherTexts[I]) then
    begin
      G_RC6Done(H);
      Result := False;
      Exit;
    end;
    G_RC6DecryptECB(H, Pointer(S));
    G_RC6Done(H);
    if not G_SameStr(G_StrToCodes(S), PlainTexts[I and 1]) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

const
  SHA256_K: array[0..63] of LongWord =
    ($428a2f98,$71374491,$b5c0fbcf,$e9b5dba5,$3956c25b,$59f111f1,$923f82a4,$ab1c5ed5,
     $d807aa98,$12835b01,$243185be,$550c7dc3,$72be5d74,$80deb1fe,$9bdc06a7,$c19bf174,
     $e49b69c1,$efbe4786,$0fc19dc6,$240ca1cc,$2de92c6f,$4a7484aa,$5cb0a9dc,$76f988da,
     $983e5152,$a831c66d,$b00327c8,$bf597fc7,$c6e00bf3,$d5a79147,$06ca6351,$14292967,
     $27b70a85,$2e1b2138,$4d2c6dfc,$53380d13,$650a7354,$766a0abb,$81c2c92e,$92722c85,
     $a2bfe8a1,$a81a664b,$c24b8b70,$c76c51a3,$d192e819,$d6990624,$f40e3585,$106aa070,
     $19a4c116,$1e376c08,$2748774c,$34b0bcb5,$391c0cb3,$4ed8aa4a,$5b9cca4f,$682e6ff3,
     $748f82ee,$78a5636f,$84c87814,$8cc70208,$90befffa,$a4506ceb,$bef9a3f7,$c67178f2);

type
  PSHA256MessageSchedule = ^TSHA256MessageSchedule;
  TSHA256MessageSchedule = array[0..63] of LongWord;

  PSHA256Data = ^TSHA256Data;
  TSHA256Data = record
    A, B, C, D, E, F, G, J: LongWord;
    X: TSHA256Digest;
    W: TSHA256MessageSchedule;
    LLo, LHi, I: Cardinal;
  end;

procedure IntSHA256Transform(P: PSHA256Data);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        PUSH    EDI
        PUSH    EBP
        MOV     EAX,[EBX+64]
        MOV     EDX,[EBX+68]
        BSWAP   EAX
        MOV     [EBX+64],EAX
        BSWAP   EDX
        MOV     [EBX+68],EDX
        MOV     EAX,[EBX+72]
        MOV     EDX,[EBX+76]
        BSWAP   EAX
        MOV     [EBX+72],EAX
        BSWAP   EDX
        MOV     [EBX+76],EDX
        MOV     EAX,[EBX+80]
        MOV     EDX,[EBX+84]
        BSWAP   EAX
        MOV     [EBX+80],EAX
        BSWAP   EDX
        MOV     [EBX+84],EDX
        MOV     EAX,[EBX+88]
        MOV     EDX,[EBX+92]
        BSWAP   EAX
        MOV     [EBX+88],EAX
        BSWAP   EDX
        MOV     [EBX+92],EDX
        MOV     EAX,[EBX+96]
        MOV     EDX,[EBX+100]
        BSWAP   EAX
        MOV     [EBX+96],EAX
        BSWAP   EDX
        MOV     [EBX+100],EDX
        MOV     EAX,[EBX+104]
        MOV     EDX,[EBX+108]
        BSWAP   EAX
        MOV     [EBX+104],EAX
        BSWAP   EDX
        MOV     [EBX+108],EDX
        MOV     EAX,[EBX+112]
        MOV     EDX,[EBX+116]
        BSWAP   EAX
        MOV     [EBX+112],EAX
        BSWAP   EDX
        MOV     [EBX+116],EDX
        MOV     EAX,[EBX+120]
        MOV     EDX,[EBX+124]
        BSWAP   EAX
        MOV     [EBX+120],EAX
        BSWAP   EDX
        MOV     [EBX+124],EDX
        MOV     EDI,EBX
        MOV     EBP,6
@@lp1:  MOV     EAX,[EDI+68]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+120]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+64]
        XOR     ESI,ECX
        ADD     EAX,[EDI+100]
        ADD     EAX,ESI
        MOV     [EDI+128],EAX
        MOV     EAX,[EDI+72]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+124]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+68]
        XOR     ESI,ECX
        ADD     EAX,[EDI+104]
        ADD     EAX,ESI
        MOV     [EDI+132],EAX
        MOV     EAX,[EDI+76]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+128]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+72]
        XOR     ESI,ECX
        ADD     EAX,[EDI+108]
        ADD     EAX,ESI
        MOV     [EDI+136],EAX
        MOV     EAX,[EDI+80]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+132]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+76]
        XOR     ESI,ECX
        ADD     EAX,[EDI+112]
        ADD     EAX,ESI
        MOV     [EDI+140],EAX
        MOV     EAX,[EDI+84]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+136]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+80]
        XOR     ESI,ECX
        ADD     EAX,[EDI+116]
        ADD     EAX,ESI
        MOV     [EDI+144],EAX
        MOV     EAX,[EDI+88]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+140]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+84]
        XOR     ESI,ECX
        ADD     EAX,[EDI+120]
        ADD     EAX,ESI
        MOV     [EDI+148],EAX
        MOV     EAX,[EDI+92]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+144]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+88]
        XOR     ESI,ECX
        ADD     EAX,[EDI+124]
        ADD     EAX,ESI
        MOV     [EDI+152],EAX
        MOV     EAX,[EDI+96]
        MOV     EDX,EAX
        ROR     EAX,7
        MOV     ECX,EDX
        ROR     EDX,18
        XOR     EAX,EDX
        SHR     ECX,3
        MOV     ESI,[EDI+148]
        XOR     EAX,ECX
        MOV     EDX,ESI
        ROR     ESI,17
        MOV     ECX,EDX
        ROR     EDX,19
        XOR     ESI,EDX
        SHR     ECX,10
        ADD     EAX,[EDI+92]
        XOR     ESI,ECX
        ADD     EAX,[EDI+128]
        ADD     EAX,ESI
        MOV     [EDI+156],EAX
        ADD     EDI,32
        DEC     EBP
        JNE     @@lp1
        MOV     EAX,[EBX+32]
        MOV     [EBX],EAX
        MOV     EAX,[EBX+36]
        MOV     [EBX+4],EAX
        MOV     EAX,[EBX+40]
        MOV     [EBX+8],EAX
        MOV     EAX,[EBX+44]
        MOV     [EBX+12],EAX
        MOV     EAX,[EBX+48]
        MOV     [EBX+16],EAX
        MOV     EAX,[EBX+52]
        MOV     [EBX+20],EAX
        MOV     EAX,[EBX+56]
        MOV     [EBX+24],EAX
        MOV     EAX,[EBX+60]
        MOV     [EBX+28],EAX
        MOV     ESI,OFFSET SHA256_K
        LEA     EDI,[EBX].TSHA256Data.W
        MOV     EBP,8
@@lp2:  MOV     ECX,[EBX+16]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+20]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+24]
        XOR     EAX,EDX
        ADD     EAX,[EDI]
        ADD     EAX,ECX
        ADD     EAX,[ESI]
        ADD     EAX,[EBX+28]
        ADD     [EBX+12],EAX
        MOV     [EBX+28],EAX
        MOV     ECX,[EBX]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+4]
        AND     EDX,EAX
        AND     EAX,[EBX+8]
        XOR     EDX,EAX
        MOV     EAX,[EBX+4]
        AND     EAX,[EBX+8]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+28],EAX
        MOV     ECX,[EBX+12]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+16]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+20]
        XOR     EAX,EDX
        ADD     EAX,[EDI+4]
        ADD     EAX,ECX
        ADD     EAX,[ESI+4]
        ADD     EAX,[EBX+24]
        ADD     [EBX+8],EAX
        MOV     [EBX+24],EAX
        MOV     ECX,[EBX+28]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX]
        AND     EDX,EAX
        AND     EAX,[EBX+4]
        XOR     EDX,EAX
        MOV     EAX,[EBX]
        AND     EAX,[EBX+4]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+24],EAX
        MOV     ECX,[EBX+8]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+12]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+16]
        XOR     EAX,EDX
        ADD     EAX,[EDI+8]
        ADD     EAX,ECX
        ADD     EAX,[ESI+8]
        ADD     EAX,[EBX+20]
        ADD     [EBX+4],EAX
        MOV     [EBX+20],EAX
        MOV     ECX,[EBX+24]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+28]
        AND     EDX,EAX
        AND     EAX,[EBX]
        XOR     EDX,EAX
        MOV     EAX,[EBX+28]
        AND     EAX,[EBX]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+20],EAX
        MOV     ECX,[EBX+4]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+8]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+12]
        XOR     EAX,EDX
        ADD     EAX,[EDI+12]
        ADD     EAX,ECX
        ADD     EAX,[ESI+12]
        ADD     EAX,[EBX+16]
        ADD     [EBX],EAX
        MOV     [EBX+16],EAX
        MOV     ECX,[EBX+20]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+24]
        AND     EDX,EAX
        AND     EAX,[EBX+28]
        XOR     EDX,EAX
        MOV     EAX,[EBX+24]
        AND     EAX,[EBX+28]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+16],EAX
        MOV     ECX,[EBX]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+4]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+8]
        XOR     EAX,EDX
        ADD     EAX,[EDI+16]
        ADD     EAX,ECX
        ADD     EAX,[ESI+16]
        ADD     EAX,[EBX+12]
        ADD     [EBX+28],EAX
        MOV     [EBX+12],EAX
        MOV     ECX,[EBX+16]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+20]
        AND     EDX,EAX
        AND     EAX,[EBX+24]
        XOR     EDX,EAX
        MOV     EAX,[EBX+20]
        AND     EAX,[EBX+24]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+12],EAX
        MOV     ECX,[EBX+28]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+4]
        XOR     EAX,EDX
        ADD     EAX,[EDI+20]
        ADD     EAX,ECX
        ADD     EAX,[ESI+20]
        ADD     EAX,[EBX+8]
        ADD     [EBX+24],EAX
        MOV     [EBX+8],EAX
        MOV     ECX,[EBX+12]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+16]
        AND     EDX,EAX
        AND     EAX,[EBX+20]
        XOR     EDX,EAX
        MOV     EAX,[EBX+16]
        AND     EAX,[EBX+20]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+8],EAX
        MOV     ECX,[EBX+24]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+28]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX]
        XOR     EAX,EDX
        ADD     EAX,[EDI+24]
        ADD     EAX,ECX
        ADD     EAX,[ESI+24]
        ADD     EAX,[EBX+4]
        ADD     [EBX+20],EAX
        MOV     [EBX+4],EAX
        MOV     ECX,[EBX+8]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+12]
        AND     EDX,EAX
        AND     EAX,[EBX+16]
        XOR     EDX,EAX
        MOV     EAX,[EBX+12]
        AND     EAX,[EBX+16]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX+4],EAX
        MOV     ECX,[EBX+20]
        MOV     EAX,ECX
        ROR     ECX,6
        MOV     EDX,EAX
        ROR     EAX,11
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,7
        XOR     ECX,EDX
        MOV     EDX,[EBX+24]
        AND     EDX,EAX
        NOT     EAX
        AND     EAX,[EBX+28]
        XOR     EAX,EDX
        ADD     EAX,[EDI+28]
        ADD     EAX,ECX
        ADD     EAX,[ESI+28]
        ADD     EAX,[EBX]
        ADD     [EBX+16],EAX
        MOV     [EBX],EAX
        MOV     ECX,[EBX+4]
        MOV     EAX,ECX
        ROR     ECX,2
        MOV     EDX,EAX
        ROR     EAX,13
        XOR     ECX,EAX
        MOV     EAX,EDX
        ROL     EDX,10
        XOR     ECX,EDX
        MOV     EDX,[EBX+8]
        AND     EDX,EAX
        AND     EAX,[EBX+12]
        XOR     EDX,EAX
        MOV     EAX,[EBX+8]
        AND     EAX,[EBX+12]
        XOR     EAX,EDX
        ADD     EAX,ECX
        ADD     [EBX],EAX
        ADD     ESI,32
        ADD     EDI,32
        DEC     EBP
        JNE     @@lp2
        MOV     EAX,[EBX]
        ADD     [EBX+32],EAX
        MOV     EAX,[EBX+4]
        ADD     [EBX+36],EAX
        MOV     EAX,[EBX+8]
        ADD     [EBX+40],EAX
        MOV     EAX,[EBX+12]
        ADD     [EBX+44],EAX
        MOV     EAX,[EBX+16]
        ADD     [EBX+48],EAX
        MOV     EAX,[EBX+20]
        ADD     [EBX+52],EAX
        MOV     EAX,[EBX+24]
        ADD     [EBX+56],EAX
        MOV     EAX,[EBX+28]
        ADD     [EBX+60],EAX
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure G_SHA256Init(var H: HSHA256);
begin
  GetMem(PSHA256Data(H), SizeOf(TSHA256Data));
  G_ZeroMem(PSHA256Data(H), SizeOf(TSHA256Data));
  with PSHA256Data(H)^ do
  begin
    X[0] := $6a09e667;
    X[1] := $bb67ae85;
    X[2] := $3c6ef372;
    X[3] := $a54ff53a;
    X[4] := $510e527f;
    X[5] := $9b05688c;
    X[6] := $1f83d9ab;
    X[7] := $5be0cd19;
  end;
end;

{$IFDEF NO_MMX}

procedure IntCopy16(Source, Destination: Pointer);
asm
        MOV     ECX,[EAX]
        MOV     [EDX],ECX
        MOV     ECX,[EAX+4]
        MOV     [EDX+4],ECX
        MOV     ECX,[EAX+8]
        MOV     [EDX+8],ECX
        MOV     ECX,[EAX+12]
        MOV     [EDX+12],ECX
        MOV     ECX,[EAX+16]
        MOV     [EDX+16],ECX
        MOV     ECX,[EAX+20]
        MOV     [EDX+20],ECX
        MOV     ECX,[EAX+24]
        MOV     [EDX+24],ECX
        MOV     ECX,[EAX+28]
        MOV     [EDX+28],ECX
        MOV     ECX,[EAX+32]
        MOV     [EDX+32],ECX
        MOV     ECX,[EAX+36]
        MOV     [EDX+36],ECX
        MOV     ECX,[EAX+40]
        MOV     [EDX+40],ECX
        MOV     ECX,[EAX+44]
        MOV     [EDX+44],ECX
        MOV     ECX,[EAX+48]
        MOV     [EDX+48],ECX
        MOV     ECX,[EAX+52]
        MOV     [EDX+52],ECX
        MOV     ECX,[EAX+56]
        MOV     [EDX+56],ECX
        MOV     ECX,[EAX+60]
        MOV     [EDX+60],ECX
end;

procedure G_SHA256Update(H: HSHA256; P: Pointer; L: Cardinal);
var
  N: LongWord;
begin
  with PSHA256Data(H)^ do
  begin
    N := L shl 3;
    Inc(LLo, N);
    if LLo < N then
      Inc(LHi);
    Inc(LHi, L shr 29);
    if I + L < 64 then
    begin
      G_CopyMem(P, @(PBytes(@W)^[I]), L);
      Inc(I, L);
      Exit;
    end;
    N := 64 - I;
    G_CopyMem(P, @(PBytes(@W)^[I]), N);
    IntSHA256Transform(PSHA256Data(H));
    Inc(LongWord(P), N);
    Dec(L, N);
    while L >= 64 do
    begin
      IntCopy16(P, @W);
      IntSHA256Transform(PSHA256Data(H));
      Inc(LongWord(P), 64);
      Dec(L, 64);
    end;
    IntFill16(@W, 0);
    if L > 0 then
      G_CopyMem(P, @W, L);
    I := L;
  end;
end;

procedure IntCopy8(Source, Destination: Pointer);
asm
        MOV     ECX,[EAX]
        MOV     [EDX],ECX
        MOV     ECX,[EAX+4]
        MOV     [EDX+4],ECX
        MOV     ECX,[EAX+8]
        MOV     [EDX+8],ECX
        MOV     ECX,[EAX+12]
        MOV     [EDX+12],ECX
        MOV     ECX,[EAX+16]
        MOV     [EDX+16],ECX
        MOV     ECX,[EAX+20]
        MOV     [EDX+20],ECX
        MOV     ECX,[EAX+24]
        MOV     [EDX+24],ECX
        MOV     ECX,[EAX+28]
        MOV     [EDX+28],ECX
end;

procedure IntFill8(P: Pointer; L: LongWord);
asm
        MOV     [EAX],EDX
        MOV     [EAX+4],EDX
        MOV     [EAX+8],EDX
        MOV     [EAX+12],EDX
        MOV     [EAX+16],EDX
        MOV     [EAX+20],EDX
        MOV     [EAX+24],EDX
        MOV     [EAX+28],EDX
end;

procedure G_SHA256Transform(H: HSHA256; Source: PSHA256Block; Dest: PSHA256Digest);
var
  P: PSHA256Data;
begin
  P := PSHA256Data(H);
  IntCopy16(Source, @P^.W);
  IntSHA256Transform(P);
  IntCopy8(@P^.X, Dest);
end;

procedure G_SHA256Done(H: HSHA256; Hash: PSHA256Digest);
begin
  with PSHA256Data(H)^ do
  begin
    PBytes(@W)^[I] := $80;
    if I > 55 then
    begin
      IntSHA256Transform(PSHA256Data(H));
      IntFill16(@W, 0);
    end;
    W[14] := G_BSwap(LHi);
    W[15] := G_BSwap(LLo);
    IntSHA256Transform(PSHA256Data(H));
    IntCopy8(@X, Hash);
  end;
  G_ZeroMem(PSHA256Data(H), SizeOf(TSHA256Data));
  FreeMem(PSHA256Data(H));
end;

procedure G_SHA256Done(H: HSHA256);
begin
  G_ZeroMem(PSHA256Data(H), SizeOf(TSHA256Data));
  FreeMem(PSHA256Data(H));
end;

procedure G_SHA256(P: Pointer; L: Cardinal; Hash: PSHA256Digest);
var
  H: HSHA256;
begin
  G_SHA256Init(H);
  G_SHA256Update(H, P, L);
  G_SHA256Done(H, Hash);
end;

procedure G_SHA256(const S: string; Hash: PSHA256Digest);
var
  H: HSHA256;
begin
  G_SHA256Init(H);
  G_SHA256Update(H, Pointer(S), Length(S));
  G_SHA256Done(H, Hash);
end;

function G_SHA256SelfTest: Boolean;
var
  H: HSHA256;
  Hash: TSHA256Digest;
  S: string;
begin
  G_SHA256('abc', @Hash);
  if not ((Hash[0] = $ba7816bf) and (Hash[1] = $8f01cfea) and
    (Hash[2] = $414140de) and (Hash[3] = $5dae2223) and (Hash[4] = $b00361a3) and
    (Hash[5] = $96177a9c) and (Hash[6] = $b410ff61) and (Hash[7] = $f20015ad)) then
  begin
    Result := False;
    Exit;
  end;
  S := StringOfChar('a', 200000);
  G_SHA256Init(H);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Done(H, @Hash);
  if not ((Hash[0] = $cdc76e5c) and (Hash[1] = $9914fb92) and
    (Hash[2] = $81a1c7e2) and (Hash[3] = $84d73e67) and (Hash[4] = $f1809a48) and
    (Hash[5] = $a497200e) and (Hash[6] = $046d39cc) and (Hash[7] = $c7112cd0)) then
  begin
    Result := False;
    Exit;
  end;
  G_SHA256Init(H);
  S := 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  G_SHA256Update(H, Pointer(S), Length(S));
  G_SHA256Done(H, @Hash);
  Result := (Hash[0] = $248d6a61) and (Hash[1] = $d20638b8) and
    (Hash[2] = $e5c02693) and (Hash[3] = $0c3e6039) and (Hash[4] = $a33ce459) and
    (Hash[5] = $64ff2167) and (Hash[6] = $f6ecedd4) and (Hash[7] = $19db06c1);
end;

procedure G_SHA256Copy(SourceHash, DestHash: PSHA256Digest);
begin
  IntCopy8(SourceHash, DestHash);
end;

function G_SHA256Equals(Hash1, Hash2: PSHA256Digest): Boolean;
asm
        MOV     ECX,[EAX]
        CMP     ECX,[EDX]
        JNE     @@zq
        MOV     ECX,[EAX+4]
        CMP     ECX,[EDX+4]
        JNE     @@zq
        MOV     ECX,[EAX+8]
        CMP     ECX,[EDX+8]
        JNE     @@zq
        MOV     ECX,[EAX+12]
        CMP     ECX,[EDX+12]
        JNE     @@zq
        MOV     ECX,[EAX+16]
        CMP     ECX,[EDX+16]
        JNE     @@zq
        MOV     ECX,[EAX+20]
        CMP     ECX,[EDX+20]
        JNE     @@zq
        MOV     ECX,[EAX+24]
        CMP     ECX,[EDX+24]
        JNE     @@zq
        MOV     ECX,[EAX+28]
        CMP     ECX,[EDX+28]
        JNE     @@zq
        MOV     EAX,1
        JMP     @@qt
@@zq:   XOR     EAX,EAX
@@qt:
end;

procedure G_SHA256Clear(Hash: PSHA256Digest);
begin
  IntFill8(Hash, 0);
end;

{$ELSE}

procedure IntCopy16(Source, Destination: Pointer);
asm
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
end;

procedure G_SHA256Update(H: HSHA256; P: Pointer; L: Cardinal);
var
  N: LongWord;
begin
  with PSHA256Data(H)^ do
  begin
    N := L shl 3;
    Inc(LLo, N);
    if LLo < N then
      Inc(LHi);
    Inc(LHi, L shr 29);
    if I + L < 64 then
    begin
      G_CopyMem(P, @(PBytes(@W)^[I]), L);
      Inc(I, L);
      Exit;
    end;
    N := 64 - I;
    G_CopyMem(P, @(PBytes(@W)^[I]), N);
    IntSHA256Transform(PSHA256Data(H));
    Inc(LongWord(P), N);
    Dec(L, N);
    while L >= 64 do
    begin
      IntCopy16(P, @W);
      IntSHA256Transform(PSHA256Data(H));
      Inc(LongWord(P), 64);
      Dec(L, 64);
    end;
    asm
        PXOR    MM0,MM0
    end;
    IntFill16(@W);
    asm
        EMMS
    end;
    if L > 0 then
      G_CopyMem(P, @W, L);
    I := L;
  end;
end;

procedure IntCopy8(Source, Destination: Pointer);
asm
        MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM1
        MOVQ    [EDX+16],MM2
        MOVQ    [EDX+24],MM3
end;

procedure G_SHA256Transform(H: HSHA256; Source: PSHA256Block; Dest: PSHA256Digest);
var
  P: PSHA256Data;
begin
  P := PSHA256Data(H);
  IntCopy16(Source, @P^.W);
  IntSHA256Transform(P);
  IntCopy8(@P^.X, Dest);
  asm
        EMMS
  end;
end;

procedure G_SHA256Done(H: HSHA256; Hash: PSHA256Digest);
begin
  with PSHA256Data(H)^ do
  begin
    PBytes(@W)^[I] := $80;
    if I > 55 then
    begin
      IntSHA256Transform(PSHA256Data(H));
      asm
        PXOR    MM0,MM0
      end;
      IntFill16(@W);
    end;
    W[14] := G_BSwap(LHi);
    W[15] := G_BSwap(LLo);
    IntSHA256Transform(PSHA256Data(H));
    IntCopy8(@X, Hash);
  end;
  asm
        EMMS
  end;
  G_ZeroMem(PSHA256Data(H), SizeOf(TSHA256Data));
  FreeMem(PSHA256Data(H));
end;

procedure G_SHA256Done(H: HSHA256);
begin
  G_ZeroMem(PSHA256Data(H), SizeOf(TSHA256Data));
  FreeMem(PSHA256Data(H));
end;

procedure G_SHA256(P: Pointer; L: Cardinal; Hash: PSHA256Digest);
var
  H: HSHA256;
begin
  G_SHA256Init(H);
  G_SHA256Update(H, P, L);
  G_SHA256Done(H, Hash);
end;

procedure G_SHA256(const S: string; Hash: PSHA256Digest);
var
  H: HSHA256;
begin
  G_SHA256Init(H);
  G_SHA256Update(H, Pointer(S), Length(S));
  G_SHA256Done(H, Hash);
end;

function G_SHA256SelfTest: Boolean;
var
  H: HSHA256;
  Hash: TSHA256Digest;
  S: string;
begin
  G_SHA256('abc', @Hash);
  if not ((Hash[0] = $ba7816bf) and (Hash[1] = $8f01cfea) and
    (Hash[2] = $414140de) and (Hash[3] = $5dae2223) and (Hash[4] = $b00361a3) and
    (Hash[5] = $96177a9c) and (Hash[6] = $b410ff61) and (Hash[7] = $f20015ad)) then
  begin
    Result := False;
    Exit;
  end;
  S := StringOfChar('a', 200000);
  G_SHA256Init(H);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Update(H, Pointer(S), 200000);
  G_SHA256Done(H, @Hash);
  if not ((Hash[0] = $cdc76e5c) and (Hash[1] = $9914fb92) and
    (Hash[2] = $81a1c7e2) and (Hash[3] = $84d73e67) and (Hash[4] = $f1809a48) and
    (Hash[5] = $a497200e) and (Hash[6] = $046d39cc) and (Hash[7] = $c7112cd0)) then
  begin
    Result := False;
    Exit;
  end;
  G_SHA256Init(H);
  S := 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  G_SHA256Update(H, Pointer(S), Length(S));
  G_SHA256Done(H, @Hash);
  Result := (Hash[0] = $248d6a61) and (Hash[1] = $d20638b8) and
    (Hash[2] = $e5c02693) and (Hash[3] = $0c3e6039) and (Hash[4] = $a33ce459) and
    (Hash[5] = $64ff2167) and (Hash[6] = $f6ecedd4) and (Hash[7] = $19db06c1);
end;

procedure G_SHA256Copy(SourceHash, DestHash: PSHA256Digest);
asm
        MOVQ    MM0,[EAX]
        MOVQ    MM1,[EAX+8]
        MOVQ    MM2,[EAX+16]
        MOVQ    MM3,[EAX+24]
        MOVQ    [EDX],MM0
        MOVQ    [EDX+8],MM1
        MOVQ    [EDX+16],MM2
        MOVQ    [EDX+24],MM3
        EMMS
end;

function G_SHA256Equals(Hash1, Hash2: PSHA256Digest): Boolean;
asm
        MOV     ECX,[EAX]
        CMP     ECX,[EDX]
        JNE     @@zq
        MOV     ECX,[EAX+4]
        CMP     ECX,[EDX+4]
        JNE     @@zq
        MOV     ECX,[EAX+8]
        CMP     ECX,[EDX+8]
        JNE     @@zq
        MOV     ECX,[EAX+12]
        CMP     ECX,[EDX+12]
        JNE     @@zq
        MOV     ECX,[EAX+16]
        CMP     ECX,[EDX+16]
        JNE     @@zq
        MOV     ECX,[EAX+20]
        CMP     ECX,[EDX+20]
        JNE     @@zq
        MOV     ECX,[EAX+24]
        CMP     ECX,[EDX+24]
        JNE     @@zq
        MOV     ECX,[EAX+28]
        CMP     ECX,[EDX+28]
        JNE     @@zq
        MOV     EAX,1
        JMP     @@qt
@@zq:   XOR     EAX,EAX
@@qt:
end;

procedure G_SHA256Clear(Hash: PSHA256Digest);
asm
        PXOR    MM0,MM0
        MOVQ    [EAX],MM0
        MOVQ    [EAX+8],MM0
        MOVQ    [EAX+16],MM0
        MOVQ    [EAX+24],MM0
        EMMS
end;

{$ENDIF}

type
  PRandomData = ^TRandomData;
  TRandomData = record
    RV: TRandomVector;
    Index: Integer;
  end;

procedure IntRandomInit(P: Pointer; Seed: LongWord);
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EAX
        MOV     EAX,EDX
        MOV     [EDI],EDX
        MOV     ESI,1812433253
        XOR     ECX,ECX
@@lp:   MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+4],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+8],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+12],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+16],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+20],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI+24],EAX
        MOV     EDX,EAX
        SHR     EAX,30
        ADD     EDI,28
        INC     ECX
        XOR     EAX,EDX
        MUL     ESI
        ADD     EAX,ECX
        MOV     [EDI],EAX
        CMP     ECX,623
        JNE     @@lp
        POP     ESI
        POP     EDI
end;

procedure G_RandomInit(var H: HMT; Seed: LongWord); overload;
begin
  GetMem(H, SizeOf(TRandomData));
  with PRandomData(H)^ do
  begin
    IntRandomInit(@RV, Seed);
    Index := 624;
  end;
end;

procedure G_RandomInit(var H: HMT; Vector: PRandomVector); overload;
begin
  GetMem(H, SizeOf(TRandomData));
  with PRandomData(H)^ do
  begin
    G_CopyLongs(Vector, @RV, 624);
    Index := 624;
  end;
end;

procedure G_RandomGetVector(H: HMT; Vector: PRandomVector);
begin
  with PRandomData(H)^ do
  begin
    G_CopyLongs(@RV, Vector, 624);
    Index := 624;
  end;
end;

procedure G_RandomSetVector(H: HMT; Vector: PRandomVector);
begin
  with PRandomData(H)^ do
  begin
    G_CopyLongs(Vector, @RV, 624);
    Index := 624;
  end;
end;

procedure G_RandomEncryptVector(H: HMT; EH: HRC6);
var
  P: PRandomVector;
  I: Integer;
begin
  P := @(PRandomData(H)^.RV);
  for I := 1 to 39 do
  begin
    G_RC6EncryptECB(EH, @P^[0]);
    G_RC6EncryptECB(EH, @P^[4]);
    G_RC6EncryptECB(EH, @P^[8]);
    G_RC6EncryptECB(EH, @P^[12]);
    Inc(LongWord(P), 64);
  end;
  PRandomData(H)^.Index := 624;
end;

function G_RandomValue(H: HMT): LongWord;
asm
        MOV     ECX,[EAX].TRandomData.Index
        CMP     ECX,624
        JE      @@mk
@@nx:   MOV     EDX,[EAX+ECX*4]
        INC     ECX
        MOV     [EAX].TRandomData.Index,ECX
        MOV     EAX,EDX
        SHR     EDX,11
        XOR     EAX,EDX
        MOV     EDX,EAX
        SHL     EAX,7
        AND     EAX,$9D2C5680
        XOR     EDX,EAX
        MOV     EAX,EDX
        SHL     EDX,15
        AND     EDX,$EFC60000
        XOR     EDX,EAX
        MOV     EAX,EDX
        SHR     EDX,18
        XOR     EAX,EDX
        RET
@@ku:   DD      0,$9908B0DF
@@mk:   PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     EDI,EAX
        MOV     ECX,227
        PUSH    EAX
@@lp1:  MOV     EAX,[EDI]
        MOV     EDX,[EDI+4]
        AND     EAX,$80000000
        AND     EDX,$7FFFFFFF
        OR      EAX,EDX
        MOV     EDX,EAX
        MOV     EBX,[EDI+1588]
        SHR     EAX,1
        AND     EDX,1
        XOR     EBX,EAX
        XOR     EBX,DWORD PTR @@ku[EDX*4]
        MOV     [EDI],EBX
        ADD     EDI,4
        DEC     ECX
        JNE     @@lp1
        MOV     ECX,198
        MOV     EAX,[EDI]
@@lp2:  MOV     EDX,[EDI+4]
        MOV     ESI,EDX
        AND     EDX,$7FFFFFFF
        AND     EAX,$80000000
        OR      EAX,EDX
        MOV     EBX,[EDI-908]
        MOV     EDX,EAX
        AND     EDX,1
        SHR     EAX,1
        XOR     EBX,EAX
        XOR     EBX,DWORD PTR @@ku[EDX*4]
        MOV     [EDI],EBX
        MOV     EDX,[EDI+8]
        MOV     EAX,EDX
        AND     EDX,$7FFFFFFF
        AND     ESI,$80000000
        OR      ESI,EDX
        MOV     EBX,[EDI-904]
        MOV     EDX,ESI
        AND     EDX,1
        SHR     ESI,1
        XOR     EBX,ESI
        XOR     EBX,DWORD PTR @@ku[EDX*4]
        MOV     [EDI+4],EBX
        ADD     EDI,8
        DEC     ECX
        JNE     @@lp2
        AND     EAX,$80000000
        POP     EDI
        MOV     EDX,[EDI]
        AND     EDX,$7FFFFFFF
        OR      EAX,EDX
        MOV     EBX,[EDI+1584]
        MOV     EDX,EAX
        AND     EDX,1
        SHR     EAX,1
        XOR     EBX,EAX
        XOR     EBX,DWORD PTR @@ku[EDX*4]
        MOV     [EDI+2492],EBX
        MOV     EAX,EDI
        POP     EBX
        POP     ESI
        POP     EDI
        JMP     @@nx
end;

function G_RandomUniform(H: HMT): Extended;
const
  InvMax: Double = 1/$4000000000000000;
asm
        PUSH    EAX
        CALL    G_RandomValue
        AND     EAX,$3FFFFFFF
        MOV     EDX,[ESP]
        MOV     [ESP],EAX
        MOV     EAX,EDX
        CALL    G_RandomValue
        PUSH    EAX
        FILD    QWORD PTR [ESP]
        ADD     ESP,8
        FMUL    InvMax
end;

function G_RandomUInt32(H: HMT; Range: LongWord): LongWord;
asm
        PUSH    EDX
        CALL    G_RandomValue
        POP     EDX
        MUL     EDX
        MOV     EAX,EDX
end;

function G_RandomUInt64(H: HMT; Range: Int64): Int64;
var
  X: array[0..1] of LongWord;
  C: Comp absolute X;
begin
  X[0] := G_RandomValue(H);
  X[1] := G_RandomValue(H) and $7FFFFFFF;
  Result := Round(C - Int(C / Range) * Range);
end;

function G_RandomGauss(H: HMT; ExtraNumber: PDouble): Extended;
const
  InverseMax: Double = 1/$2000000000000000;
  XX1: Double = 1;
  XX2: Double = -2;
asm
        PUSH    EBX
        PUSH    EDI
        PUSH    ESI
        LEA     EDI,[ESP-24]
        SUB     ESP,32
        AND     EDI,$FFFFFFF8
        PUSH    EDX
        MOV     EBX,EAX
@@lp:   MOV     EAX,EBX
        CALL    G_RandomValue
        AND     EAX,$3FFFFFFF
        MOV     ESI,EAX
        MOV     EAX,EBX
        CALL    G_RandomValue
        PUSH    ESI
        PUSH    EAX
        FILD    QWORD PTR [ESP]
        FMUL    InverseMax
        FSUB    XX1
        FST     QWORD PTR [EDI+8]
        MOV     EAX,EBX
        FMUL    ST(0),ST(0)
        CALL    G_RandomValue
        AND     EAX,$3FFFFFFF
        MOV     ESI,EAX
        MOV     EAX,EBX
        CALL    G_RandomValue
        MOV     [ESP],EAX
        MOV     [ESP+4],ESI
        FILD    QWORD PTR [ESP]
        FMUL    InverseMax
        FSUB    XX1
        ADD     ESP,8
        FST     QWORD PTR [EDI+16]
        FMUL    ST(0),ST(0)
        FADDP
        FCOM    XX1
        FSTSW   AX
        FSTP    QWORD PTR [EDI]
        SAHF
        JNB     @@lp
        FLDLN2
        FLD     QWORD PTR [EDI]
        FYL2X
        FMUL    XX2
        FDIV    QWORD PTR [EDI]
        POP     EDX
        FSQRT
        TEST    EDX,EDX
        JE      @@qt
        FLD     ST(0)
        FMUL    QWORD PTR [EDI+16]
        FSTP    QWORD PTR [EDX]
@@qt:   FMUL    QWORD PTR [EDI+8]
        ADD     ESP,32
        POP     ESI
        POP     EDI
        POP     EBX
end;

procedure G_RandomFill(H: HMT; P: Pointer; L: Integer);
asm
        PUSH    EBX
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,ECX
        AND     ECX,7
        MOV     ESI,EAX
        MOV     EBX,EDX
        PUSH    ECX
        SHR     EDI,3
        JE      @@nx
@@lp:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        ADD     EBX,4
        MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        ADD     EBX,4
        DEC     EDI
        JNE     @@lp
@@nx:   POP     ECX
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@qt, @@t1, @@t2, @@t3
        DD      @@t4, @@t5, @@t6, @@t7
@@t1:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     BYTE PTR [EBX],AL
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t2:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     WORD PTR [EBX],AX
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t3:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     WORD PTR [EBX],AX
        SHR     EAX,16
        MOV     BYTE PTR [EBX+2],AL
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t4:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t5:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     BYTE PTR [EBX+4],AL
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t6:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     WORD PTR [EBX+4],AX
        POP     ESI
        POP     EDI
        POP     EBX
        RET
@@t7:   MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     [EBX],EAX
        MOV     EAX,ESI
        CALL    G_RandomValue
        MOV     WORD PTR [EBX+4],AX
        SHR     EAX,16
        MOV     BYTE PTR [EBX+6],AL
@@qt:   POP     ESI
        POP     EDI
        POP     EBX
end;

procedure G_RandomDone(H: HMT);
begin
  FreeMem(H);
end;

end.

