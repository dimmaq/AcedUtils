
/////////////////////////////////////////////////////////////
//                                                         //
//   AcedCompression 1.16                                  //
//                                                         //
//   Функции, реализующие сжатие бинарных данных методом   //
//   LZ+Huffman и последующую их распаковку.               //
//                                                         //
//   mailto: acedutils@yandex.ru                           //
//                                                         //
/////////////////////////////////////////////////////////////

unit AcedCompression;

{$B-,H+,R-,Q-,T-,X+}

interface

{ Перечисляемый тип, выбирающий соотношение степени сжатия и времени,
  затрачиваемого на сжатие информации. }

type
  TCompressionMode = (
    dcmNoCompression,       // Простое копирование данных в выходной массив
    dcmFastest,             // Самое быстрое, но и самое слабое сжатие данных
    dcmFast,                // Нормальная степень сжатия за минимальное время
    dcmNormal,              // Хорошая степень сжатия за приемлемое время
    dcmMaximumCompression   // Максимальная степень сжатия
  );

{ G_Deflate упаковывает массив байт, адресуемый параметром SourceBytes,
  длиной SourceLength байт. Степень сжатия задается параметром Mode. При этом
  выделяется память под массив, достаточный для хранения сжатых данных. Кроме
  того, в начале массива резервируется место под BeforeGap байт, а в конце -
  под AfterGap байт. Ссылка на этот массив, содержащий сжатые данные,
  возвращается в параметре DestinationBytes. Длина сжатого фрагмента данных
  (без учета BeforeGap и AfterGap) возвращается как результат функции. }

function G_Deflate(SourceBytes: Pointer; SourceLength: Integer;
  var DestinationBytes: Pointer; BeforeGap, AfterGap: Integer;
  Mode: TCompressionMode = dcmFast): Integer; overload;

{ Следующая функция G_Deflate аналогична предыдущей, но память под выходной
  массив должна быть распределена пользователем заранее, до вызова функции.
  Ссылка на область, предназначенную для хранения упакованных данных передается
  параметром DestinationBytes. Максимальная длина выходных данных составляет
  (SourceLength + 4) байт. Функция возвращает число байт, помещенное в массив,
  адресуемый параметром DestinationBytes. Если в параметре DestinationBytes
  передать значение nil, функция выполнит "фиктивное" сжатие без сохранения
  результата. Таким образом можно точно определить необходимый размер выходного
  массива. Следует, однако, учитывать, что сжатие "вхолостую" выполняется
  примерно за то же время, что и сжатие в обычном режиме. }

function G_Deflate(SourceBytes: Pointer; SourceLength: Integer;
  DestinationBytes: Pointer; Mode: TCompressionMode = dcmFast): Integer; overload;

{ G_ReleaseDeflator освобождает внутренние массивы, используемые упаковщиком,
  суммарный размер которых составляет около 150 килобайт. Эти массивы
  размещаются в памяти при вызове функций G_Deflate. Если G_Deflate вызывается
  многократно то, чтобы избежать лишнего перераспределения памяти, процедуру
  G_ReleaseDeflator можно вызвать после всего цикла упаковки данных или
  не вызывать совсем. }

procedure G_ReleaseDeflator;

{ G_GetInflatedLength возвращает размер в байтах области памяти, необходимой
  для распаковки данных, ссылка на которые передается параметром SourceBytes.
  Предполагается, что данные были сжаты функцией G_Deflate. }

function G_GetInflatedLength(SourceBytes: Pointer): Integer;

{ G_Inflate выполняет распаковку данных, адресуемых параметром SourceBytes,
  длиной SourceLength байт. При этом распределяется область памяти, достаточная
  для хранения распакованных данных, а также блока размером BeforeGap байт
  в начале этой области и блока размером AfterGap байт в конце области памяти.
  Ссылка на распределенную область памяти возвращается в параметре
  DestinationBytes. Длина распакованного фрагмента данных (без учета BeforeGap
  и AfterGap) возвращается как результат функции. }

function G_Inflate(SourceBytes: Pointer; SourceLength: Integer;
  var DestinationBytes: Pointer; BeforeGap, AfterGap: Integer): Integer; overload;

{ Следующая функция G_Inflate аналогична предыдущей, но память под выходной
  массив должна быть распределена пользователем заранее, до вызова функции.
  Ссылка на область памяти, предназначенную для хранения распакованных данных,
  передается параметром DestinationBytes. Определить размер данных после их
  распаковки можно вызовом функции G_GetInflatedLength. Функция G_Inflate
  возвращает число байт, помещенное в массив, адресуемый параметром
  DestinationBytes. Если в этом параметре передано значение nil, функция
  работает аналогично G_GetInflatedLength, т.е. просто возвращает размер
  массива, необходимого для хранения распакованных данных. }

function G_Inflate(SourceBytes: Pointer; SourceLength: Integer;
  DestinationBytes: Pointer): Integer; overload;

{ G_ReleaseInflator освобождает память, занимаемую внутренними массивами,
  используемыми при распаковке данных. Эти массивы выделяются при вызове
  функций G_Inflate. Их суммарный размер составляет около 7 килобайт.
  Обычно вызывать данную процедуру из прикладного приложения не нужно. }

procedure G_ReleaseInflator;

implementation

{ FORMAT OF THE DATA BLOCK

  Encoded data block consists of sequences of symbols drawn from
  three conceptually distinct alphabets: either literal bytes,
  from the alphabet of byte values (0..255), or <length, backward
  distance> pairs, where the length is drawn from (3..2^21) and
  the distance is drawn from (1..262,143). In fact, the literal
  and length alphabets are merged into a single alphabet (0..286),
  where values 0..255 represent literal bytes, and values
  256..286 represent length codes (possibly in conjunction with
  extra bits following the symbol code) as follows:

      Extra               Extra                Extra
  Code Bits Length(s) Code Bits Length(s) Code  Bits   Length(s)
  ---- ---- -------   ---- ---- -------   ----  -----  -------
   256   0     3       268   0    15       280    2     41-44
   257   0     4       269   0    16       281    2     45-48
   258   0     5       270   1   17,18     282    3     49-56
   259   0     6       271   1   19,20     283    3     57-64
   260   0     7       272   1   21,22     284    4     65-80
   261   0     8       273   1   23,24     285    6     81-144
   262   0     9       274   1   25,26     286 8,16,23 145-2^21
   263   0    10       275   1   27,28
   264   0    11       276   1   29,30
   265   0    12       277   1   31,32
   266   0    13       278   2   33-36
   267   0    14       279   2   37-40

  Distance codes 0-63 are represented by codes of variable length
  with possible additional bits.

            Extra                    Extra
        Code Bits   Distance    Code  Bits    Distance
        ---- ----   --------    ----  ----    ---------
          0    0        1        32     7      513-640
          1    0        2        33     7      641-768
          2    0        3        34     7      769-896
          3    0        4        35     7      897-1024
          4    0        5        36     8     1025-1280
          5    0        6        37     8     1281-1536
          6    0        7        38     8     1537-1792
          7    0        8        39     8     1793-2048
          8    1       9,10      40     9     2049-2560
          9    1      11,12      41     9     2561-3072
         10    1      13,14      42     9     3073-3584
         11    1      15,16      43     9     3585-4096
         12    2      17-20      44    10     4097-5120
         13    2      21-24      45    10     5121-6144
         14    2      25-28      46    10     6145-7168
         15    2      29-32      47    10     7169-8192
         16    3      33-40      48    11     8193-10240
         17    3      41-48      49    11    10241-12288
         18    3      49-56      50    11    12289-14336
         19    3      57-64      51    11    14337-16384
         20    4      65-80      52    12    16385-20480
         21    4      81-96      53    12    20481-24576
         22    4      97-112     54    12    24577-28672
         23    4     113-128     55    12    28673-32768
         24    5     129-160     56    13    32769-40960
         25    5     161-192     57    13    40961-49152
         26    5     193-224     58    13    49153-57344
         27    5     225-256     59    13    57345-65536
         28    6     257-320     60    15    65537-98304
         29    6     321-384     61    15    98305-131072
         30    6     385-448     62    16   131073-196608
         31    6     449-512     63    16   196609-262143

  Fixed Huffman code lengths for the literal/length alphabet are:

       Lit Value    Bits
       ---------    ----
           0         7      1 from 128 of 7 bits (127)
         1 - 142     8      142 from 254 of 8 bits (112)
       143 - 254     9      112 from 224 of 9 bits (112)
          255        8      1 from 56 of 8 bits (55)
       256 - 279     7      24 from 27.5 of 7 bits (3.5)
       280 - 286     8      7 from 7 of 8 bits (0)

  The alphabet for code lengths is as follows:

     0 - 14: Represent code lengths of 0 - 14
       15:   Copy twice the previous code length.
       16:   Copy the previous code length 3, 4 times.
             (1 bits of length: 0 = 3, 1 = 4)
       17:   Copy the previous code length 5 - 8 times.
             (2 bits of length: 0 = 5, ... , 3 = 8)
       18:   Copy the previous code length 9 - 16 times.
             (3 bits of length: 0 = 9, ... , 7 = 16)
       19:   Copy the previous code length 17 - 144 times
             (7 bits of length)

  We can now define the format of the block:

     1 Bit: X, 1 means using of dynamic Huffman codes
               0 - see description of the next bit

     1 Bit (if X = 0): F,
            1 means using of fixed Huffman codes
            0 non-compressed block of data

     8 Bits (if X = 0 and F = 0): # of Bytes in this block:
            # - 8192, 0 if this block is the last

     if X = 1

     4 Bits: HCLEN, # of Code Length codes - 5 (5 - 20)

     (HCLEN + 5) x 3 bits: code lengths for the code length
        alphabet given just above, in the order:
        9, 10, 8, 15, 7, 11, 0, 6, 16, 5, 12, 4, 17, 13, 3,
        18, 19, 2, 1, 14

        These code lengths are interpreted as 3-bit integers
        (0-7); as above, a code length of 0 means the
        corresponding symbol (literal/length or distance code
        length) is not used.

     5 Bits: HLIT, # of Literal/Length codes - 256 (256 - 287)

     HLIT + 256 code lengths for the literal/length alphabet,
        encoded using the code length Huffman code

     6 Bits: HDIST, # of Distance codes - 1 (1 - 64)

     HDIST + 1 code lengths for the distance alphabet,
        encoded using the code length Huffman code

     1..8192..8447 literal/length and distance Huffman codes
}

uses Windows, AcedBinary, AcedConsts;

const
  ChunkShift = 15;
  ChunkCapacity = 8192;
  BlockSize = 8192;
  MaxLength = 2097296;
  Len3MaxDist = 4096;
  Len4MaxDist = 65536;
  Diff1Min = 1025;
  Diff2Min = 65537;
  LazyLimit = 32;
  CharCount = 287;
  LastChar = CharCount - 1;
  FirstLengthChar = 256;
  FirstCharWithExBit = 270;
  CharTreeSize = CharCount * 2;
  DistCount = 64;
  FirstDistWithExBit = 8;
  DistTreeSize = DistCount * 2;
  MaxBits = 14;
  ChLenCount = 20;
  ChLenTreeSize = ChLenCount * 2;
  MaxChLenBits = 7;

  HashSizeFastest = $1000;
  HashMaskFastest = $0FFF;
  PrevSizeFastest = $2000;
  PrevMaskFastest = $1FFF;
  ChainFastest = 2;
  ShiftFastest = 4;

  HashSizeFast = $8000;
  HashMaskFast = $7FFF;
  PrevSizeFast = $10000;
  PrevMaskFast = $FFFF;
  ChainFast = 8;
  ShiftFast = 5;

  HashSizeNormal = $40000;
  HashMaskNormal = $3FFFF;
  PrevSizeNormal = $40000;
  PrevMaskNormal = $3FFFF;
  ChainNormal = 32;
  ShiftNormal = 6;

  HashSizeMaximum = $40000;
  HashMaskMaximum = $3FFFF;
  PrevSizeMaximum = $40000;
  PrevMaskMaximum = $3FFFF;
  ChainMaximum = 64;
  ShiftMaximum = 6;

const
  CharExBitLength: array[0..15] of Integer =
    (1,1,1,1,1,1,1,1,2,2,2,2,3,3,4,6);

  CharExBitBase: array[0..15] of Integer =
    (17,19,21,23,25,27,29,31,33,37,41,45,49,57,65,81);

  DistExBitLength: array[0..63] of Integer =
    (0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,
     8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13,15,15,16,16);

  DistExBitBase: array[0..63] of Integer =
    (1,2,3,4,5,6,7,8,9,11,13,15,17,21,25,29,33,41,49,57,65,81,97,113,129,161,
     193,225,257,321,385,449,513,641,769,897,1025,1281,1537,1793,2049,2561,
     3073,3585,4097,5121,6145,7169,8193,10241,12289,14337,16385,20481,24577,
     28673,32769,40961,49153,57345,65537,98305,131073,196609);

  ChLenExBitLength: array[0..19] of Integer =
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,7);

  FixedCharLength: array[0..286] of Integer =
    (7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
     9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
     9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
     9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,
     7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8);

  FixedBitCount: array[0..14] of Integer =
    (0,0,0,0,0,0,0,25,150,112,0,0,0,0,0);

var
  _HashHead: Integer;
  _Length: Integer;
  _Distance: Integer;
  _PrevSize: Integer;
  _PrevMask: Integer;
  _Shift: Integer;
  _HashSize: Integer;
  _HashMask: Integer;
  _MaxChain: Integer;
  _Limit: Integer;
  _BreakDefOffset: Integer;
  _ThisBreakOffset: Integer;
  _Chain: Integer;
  _MaxCode: Integer;
  _HeapLen: Integer;

  _Hash: PIntegerItemList;
  _Prev: PIntegerItemList;
  _Heap: PIntegerItemList = nil;
  _WorkFreq: PIntegerItemList;
  _WorkDad: PIntegerItemList;
  _Depth: PIntegerItemList;
  _Tree: PIntegerItemList;
  _NextDefCode: PIntegerItemList;

  _DstIndex: Integer;
  _ChunkLength: Integer;
  _Chunk: PLongWordItemList;
  _BitsDef: Integer;
  _HoldDef: LongWord;

  _ChunkListLength: Integer;
  _ChunkListCapacity: Integer;
  _ChunkList: PPointerItemList;

  _SrcDefBytes: PBytes;
  _DstDefBytes: PBytes;

  _ExBitCount: Integer;
  _BlockStart: Integer;
  _BlockEndIndex: Integer;
  _BufLength: Integer;

  _Buffer: PIntegerItemList;
  _Len: PIntegerItemList;
  _Dist: PIntegerItemList;
  _DistExBits: PIntegerItemList;

  _CharBitLenLen: Integer;
  _DistBitLenLen: Integer;
  _ChLenBitLenLen: Integer;
  _CharLenCount: Integer;
  _DistLenCount: Integer;

  _CharBitCount: PIntegerItemList;
  _CharFreqCode: PIntegerItemList;
  _CharDadLen: PIntegerItemList;
  _CharBitLen: PIntegerItemList;
  _CharBitLenEx: PIntegerItemList;
  _DistBitCount: PIntegerItemList;
  _DistFreqCode: PIntegerItemList;
  _DistDadLen: PIntegerItemList;
  _DistBitLen: PIntegerItemList;
  _DistBitLenEx: PIntegerItemList;
  _ChLenBitCount: PIntegerItemList;
  _ChLenFreqCode: PIntegerItemList;
  _ChLenDadLen: PIntegerItemList;
  _ChLenBitLen: PIntegerItemList;

  _SrcIndex: Integer;
  _Break32Offset: Integer;
  _Break16Offset: Integer;
  _BreakInfOffset: Integer;
  _HoldInf: Integer;
  _BitsInf: Integer;
  _OutCounter: Integer;
  _InCounter: Integer;

  _SrcInfBytes: PBytes;
  _DstInfBytes: PBytes;

  _CharTree: PIntegerItemList;
  _DistTree: PIntegerItemList;
  _ChLenTree: PIntegerItemList;
  _BitCount: PIntegerItemList;
  _NextInfCode: PIntegerItemList;
  _BitLen: PIntegerItemList = nil;

  _FixedTree: Boolean;
  _TryMode: Boolean;
  _GrowMode: Boolean;

procedure NextChunk;
var
  NewList: PPointerItemList;
begin
  if _ChunkListCapacity = 0 then
  begin
    _ChunkListCapacity := 16;
    GetMem(_ChunkList, _ChunkListCapacity * SizeOf(Pointer));
    _ChunkList^[0] := _Chunk;
    _ChunkListLength := 1;
  end else
  begin
    if _ChunkListLength = _ChunkListCapacity then
    begin
      _ChunkListCapacity := _ChunkListCapacity shl 1;
      GetMem(NewList, _ChunkListCapacity * SizeOf(Pointer));
      G_CopyLongs(_ChunkList, NewList, _ChunkListLength);
      FreeMem(_ChunkList);
      _ChunkList := NewList;
    end;
    _ChunkList^[_ChunkListLength] := _Chunk;
    Inc(_ChunkListLength);
  end;
  GetMem(_Chunk, ChunkCapacity * SizeOf(LongWord));
  _ChunkLength := 0;
end;

function PutBit(V: Integer): Boolean;
begin
  if _BitsDef <> 0 then
  begin
    _HoldDef := _HoldDef or (LongWord(V) shl (32 - _BitsDef));
    Dec(_BitsDef);
    Result := True;
    Exit;
  end;
  Inc(_DstIndex, 4);
  Result := False;
  if _DstIndex <= _BreakDefOffset then
  begin
    if _GrowMode then
    begin
      if _ChunkLength = ChunkCapacity then
        NextChunk;
      _Chunk^[_ChunkLength] := _HoldDef;
      Inc(_ChunkLength);
    end
    else if not _TryMode then
    begin
      PLongWord(_DstDefBytes)^ := _HoldDef;
      Inc(LongWord(_DstDefBytes), SizeOf(LongWord));
    end;
    _HoldDef := LongWord(V);
    _BitsDef := 31;
    Result := True;
  end;
end;

function PutNBits(N: Integer; V: LongWord): Boolean;
var
  Bits: Integer;
begin
  Bits := _BitsDef;
  if Bits >= N then
  begin
    _HoldDef := _HoldDef or (V shl (32 - Bits));
    _BitsDef := Bits - N;
    Result := True;
    Exit;
  end;
  if Bits <> 0 then
  begin
    _HoldDef := _HoldDef or (V shl (32 - Bits));
    V := V shr Bits;
  end;
  Inc(_DstIndex, 4);
  Result := False;
  if _DstIndex <= _BreakDefOffset then
  begin
    if _GrowMode then
    begin
      if _ChunkLength = ChunkCapacity then
        NextChunk;
      _Chunk^[_ChunkLength] := _HoldDef;
      Inc(_ChunkLength);
    end
    else if not _TryMode then
    begin
      PLongWord(_DstDefBytes)^ := _HoldDef;
      Inc(LongWord(_DstDefBytes), SizeOf(LongWord));
    end;
    _HoldDef := V;
    _BitsDef := 32 + Bits - N;
    Result := True;
  end;
end;

procedure InitHeap(Count: Integer);
var
  H, W: PInteger;
  I: Integer;
begin
  H := @_Heap^[1];
  W := @_WorkFreq[0];
  _HeapLen := 0;
  _MaxCode := -1;
  I := 0;
  while I < Count do
  begin
    if W^ <> 0 then
    begin
      H^ := I;
      _MaxCode := I;
      _Depth^[I] := 0;
      Inc(_HeapLen);
      Inc(LongWord(H), SizeOf(Integer));
    end else
      _WorkDad^[I] := 0;
    Inc(I);
    Inc(LongWord(W), SizeOf(Integer));
  end;
  if _HeapLen > 1 then
    Exit;
  if _HeapLen > 0 then
  begin
    if _MaxCode = 0 then
    begin
      I := 1;
      _MaxCode := I;
    end else
      I := 0;
    H^ := i;
    _WorkFreq^[I] := 1;
    _Depth^[I] := 0;
  end else
  begin
    _MaxCode := 1;
    H^ := 0;
    PIntegerItemList(H)^[1] := 1;
    _WorkFreq^[0] := 1;
    _WorkFreq^[1] := 1;
    _Depth^[0] := 0;
    _Depth^[1] := 0;
  end;
  _HeapLen := 2;
end;

procedure SortHeap(L, R: Integer);
var
  H, W: PIntegerItemList;
  I, J, M, T: Integer;
begin
  H := _Heap;
  W := _WorkFreq;
  repeat
    I := L;
    J := R;
    M := W^[H^[(L + R) shr 1]];
    repeat
      while W^[H^[I]] < M do
        Inc(I);
      while M < W^[H^[J]] do
        Dec(J);
      if I <= J then
      begin
        T := H^[I];
        H^[I] := H^[J];
        H^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      SortHeap(L, J);
    L := I;
  until I >= R;
end;

procedure PQDownHeap;
var
  H: PIntegerItemList;
  p0, n0, p1, n1: Integer;
  V, K, J, nV: Integer;
begin
  H := _Heap;
  V := H^[1];
  nV := _WorkFreq^[V];
  K := 1;
  J := 2;
  while J <= _HeapLen do
  begin
    p0 := H^[J];
    n0 := _WorkFreq^[p0];
    if J < _HeapLen then
    begin
      p1 := H^[J + 1];
      n1 := _WorkFreq^[p1];
      if (n1 < n0) or ((n1 = n0) and (_Depth^[p1] <= _Depth^[p0])) then
      begin
        Inc(J);
        p0 := p1;
        n0 := n1;
      end;
    end;
    if (nV < n0) or ((nV = n0) and (_Depth^[V] <= _Depth^[p0])) then
      Break;
    H^[K] := H^[J];
    K := J;
    J := J shl 1;
  end;
  H^[K] := V;
end;

function BuildTree(NextNode: Integer): Integer;
var
  I, N, M: Integer;
  T: PIntegerItemList;
  Heap1: PInteger;
begin
  I := 0;
  Heap1 := @_Heap^[1];
  T := _Tree;
  repeat
    N := Heap1^;
    Heap1^ := _Heap^[_HeapLen];
    Dec(_HeapLen);
    PQDownHeap;
    M := Heap1^;
    T^[0] := N;
    T^[1] := M;
    Inc(I, 2);
    Inc(LongWord(T), SizeOf(Integer) * 2);
    _WorkDad^[M] := nextNode;
    _WorkDad^[N] := nextNode;
    _WorkFreq^[nextNode] := _WorkFreq^[N] + _WorkFreq^[M];
    N := _Depth^[N];
    M := _Depth^[M];
    if N > M then
      _Depth^[NextNode] := N + 1
    else
      _Depth^[NextNode] := M + 1;
    Heap1^ := nextNode;
    Inc(NextNode);
    PQDownHeap;
  until _HeapLen = 1;
  _WorkDad^[Heap1^] := 0;
  Result := I;
end;

function PrepareCharLengths: Integer;
var
  N, M, I, OverF: Integer;
  T: PInteger;
begin
  _WorkFreq := _CharFreqCode;
  _WorkDad := _CharDadLen;
  InitHeap(CharCount);
  SortHeap(1, _HeapLen);
  I := BuildTree(CharCount);
  G_FillLongs(0, _CharBitCount, MaxBits + 1);
  OverF := 0;
  Result := 0;
  T := @_Tree^[I];
  repeat
    Dec(LongWord(T), 4);
    N := T^;
    M := _CharDadLen^[_CharDadLen^[N]] + 1;
    if M > MaxBits then
    begin
      M := MaxBits;
      Inc(OverF);
    end;
    _CharDadLen^[N] := M;
    if N < CharCount then
    begin
      Inc(Result, M * _CharFreqCode^[N]);
      Inc(_CharBitCount^[M]);
    end;
    Dec(I);
  until I = 0;
  if OverF = 0 then
    Exit;
  repeat
    I := MaxBits - 1;
    while _CharBitCount^[I] = 0 do
      Dec(I);
    Dec(_CharBitCount^[I]);
    Inc(_CharBitCount^[I + 1], 2);
    Dec(_CharBitCount^[MaxBits]);
    Dec(OverF, 2);
  until OverF <= 0;
  OverF := MaxBits;
  repeat
    N := _CharBitCount^[OverF];
    while N <> 0 do
    begin
      M := T^;
      Inc(LongWord(T), SizeOf(Integer));
      if M < CharCount then
      begin
        Inc(Result, (OverF - _CharDadLen^[M]) * _CharFreqCode^[M]);
        _CharDadLen^[M] := OverF;
        Dec(N);
      end;
    end;
    Dec(OverF);
  until OverF = 0;
end;

function PrepareDistLengths: Integer;
var
  N, M, I, OverF: Integer;
  T: PInteger;
begin
  _WorkFreq := _DistFreqCode;
  _WorkDad := _DistDadLen;
  InitHeap(DistCount);
  SortHeap(1, _HeapLen);
  I := BuildTree(DistCount);
  G_FillLongs(0, _DistBitCount, MaxBits + 1);
  OverF := 0;
  Result := 0;
  T := @_Tree[I];
  repeat
    Dec(LongWord(T), 4);
    N := T^;
    M := _DistDadLen^[_DistDadLen^[N]] + 1;
    if M > MaxBits then
    begin
      M := MaxBits;
      Inc(OverF);
    end;
    _DistDadLen^[N] := M;
    if N < DistCount then
    begin
      Inc(Result, M * _DistFreqCode^[N]);
      Inc(_DistBitCount^[M]);
    end;
    Dec(I);
  until I = 0;
  if OverF = 0 then
    Exit;
  repeat
    I := MaxBits - 1;
    while _DistBitCount^[I] = 0 do
      Dec(I);
    Dec(_DistBitCount^[I]);
    Inc(_DistBitCount^[I + 1], 2);
    Dec(_DistBitCount^[MaxBits]);
    Dec(OverF, 2);
  until OverF <= 0;
  OverF := MaxBits;
  repeat
    N := _DistBitCount^[OverF];
    while N <> 0 do
    begin
      M := T^;
      Inc(LongWord(T), SizeOf(Integer));
      if M < DistCount then
      begin
        Inc(Result, (OverF - _DistDadLen^[M]) * _DistFreqCode^[M]);
        _DistDadLen^[M] := OverF;
        Dec(N);
      end;
    end;
    Dec(OverF);
  until OverF = 0;
end;

function FillCharBitLengths: Integer;
var
  Dad, Len: PInteger;
  LastLen, M, I, J, BreakOffset: Integer;
begin
  Dad := PInteger(_CharDadLen);
  Len := PInteger(_CharBitLen);
  _CharBitLenLen := 0;
  LastLen := 7;
  I := 0;
  if _MaxCode >= 255 then
    _CharLenCount := _MaxCode + 1
  else
  begin
    _CharLenCount := 256;
    _MaxCode := 255;
  end;
  G_FillLongs(0, _CharBitLenEx, _CharLenCount);
  Result := 0;
  repeat
    M := Dad^;
    Inc(LongWord(Dad), SizeOf(Integer));
    if (M <> LastLen) or (M <> Dad^) then
    begin
      LastLen := M;
      Len^ := M;
      Inc(I);
    end else
    begin
      if I + 144 > _MaxCode then
        BreakOffset := _CharLenCount
      else
        BreakOffset := I + 144;
      J := I;
      Inc(I, 2);
      Inc(LongWord(Dad), SizeOf(Integer));
      while (I < BreakOffset) and (M = Dad^) do
      begin
        Inc(LongWord(Dad), SizeOf(Integer));
        Inc(I);
      end;
      J := I - J;
      if J = 2 then
        Len^ := 15
      else if J < 5 then
      begin
        Len^ := 16;
        _CharBitLenEx^[_CharBitLenLen] := J - 3;
        Inc(Result);
      end
      else if J < 9 then
      begin
        Len^ := 17;
        _CharBitLenEx^[_CharBitLenLen] := J - 5;
        Inc(Result, 2);
      end
      else if J < 17 then
      begin
        Len^ := 18;
        _CharBitLenEx^[_CharBitLenLen] := J - 9;
        Inc(Result, 3);
      end else
      begin
        Len^ := 19;
        _CharBitLenEx^[_CharBitLenLen] := J - 17;
        Inc(Result, 7);
      end;
    end;
    Inc(_CharBitLenLen);
    Inc(LongWord(Len), SizeOf(Integer));
  until I >= _MaxCode;
  if I = _MaxCode then
  begin
    Len^ := Dad^;
    Inc(_CharBitLenLen);
  end;
end;

function FillDistBitLengths: Integer;
var
  Dad, Len: PInteger;
  LastLen, M, I, J: Integer;
begin
  Dad := PInteger(_DistDadLen);
  Len := PInteger(_DistBitLen);
  _DistBitLenLen := 0;
  LastLen := 7;
  I := 0;
  _DistLenCount := _MaxCode + 1;
  G_FillLongs(0, _DistBitLenEx, _DistLenCount);
  Result := 0;
  repeat
    M := Dad^;
    Inc(LongWord(Dad), SizeOf(Integer));
    if (M <> LastLen) or (M <> Dad^) then
    begin
      LastLen := M;
      Len^ := M;
      Inc(I);
    end
    else
    begin
      J := I;
      Inc(I, 2);
      Inc(LongWord(Dad), SizeOf(Integer));
      while (I < _DistLenCount) and (M = Dad^) do
      begin
        Inc(LongWord(Dad), SizeOf(Integer));
        Inc(I);
      end;
      J := I - J;
      if J = 2 then
        Len^ := 15
      else if J < 5 then
      begin
        Len^ := 16;
        _DistBitLenEx^[_DistBitLenLen] := J - 3;
        Inc(Result);
      end
      else if J < 9 then
      begin
        Len^ := 17;
        _DistBitLenEx^[_DistBitLenLen] := J - 5;
        Inc(Result, 2);
      end
      else if J < 17 then
      begin
        Len^ := 18;
        _DistBitLenEx^[_DistBitLenLen] := J - 9;
        Inc(Result, 3);
      end else
      begin
        Len^ := 19;
        _DistBitLenEx^[_DistBitLenLen] := J - 17;
        Inc(Result, 7);
      end;
    end;
    Inc(_DistBitLenLen);
    Inc(LongWord(Len), SizeOf(Integer));
  until I >= _MaxCode;
  if I = _MaxCode then
  begin
    Len^ := Dad^;
    Inc(_DistBitLenLen);
  end;
end;

procedure FillChLenFreqCodes;
var
  Freq, Len: PIntegerItemList;
  I: Integer;
begin
  Freq := _ChLenFreqCode;
  G_FillLongs(0, Freq, ChLenCount);
  Len := _CharBitLen;
  I := 7;
  while I < _CharBitLenLen do
  begin
    Inc(Freq^[Len^[0]]);
    Inc(Freq^[Len^[1]]);
    Inc(Freq^[Len^[2]]);
    Inc(Freq^[Len^[3]]);
    Inc(Freq^[Len^[4]]);
    Inc(Freq^[Len^[5]]);
    Inc(Freq^[Len^[6]]);
    Inc(Freq^[Len^[7]]);
    Inc(LongWord(Len), SizeOf(Integer) * 8);
    Inc(I, 8);
  end;
  Dec(I, 7);
  while I < _CharBitLenLen do
  begin
    Inc(Freq^[PInteger(Len)^]);
    Inc(LongWord(Len), SizeOf(Integer));
    Inc(I);
  end;
  Len := _DistBitLen;
  I := 7;
  while i < _DistBitLenLen do
  begin
    Inc(Freq^[Len^[0]]);
    Inc(Freq^[Len^[1]]);
    Inc(Freq^[Len^[2]]);
    Inc(Freq^[Len^[3]]);
    Inc(Freq^[Len^[4]]);
    Inc(Freq^[Len^[5]]);
    Inc(Freq^[Len^[6]]);
    Inc(Freq^[Len^[7]]);
    Inc(LongWord(Len), SizeOf(Integer) * 8);
    Inc(I, 8);
  end;
  Dec(I, 7);
  while I < _DistBitLenLen do
  begin
    Inc(Freq^[PInteger(Len)^]);
    Inc(LongWord(Len), SizeOf(Integer));
    Inc(I);
  end;
end;

function PrepareChLenLengths: Integer;
var
  N, M, I, OverF: Integer;
  T: PInteger;
begin
  _WorkFreq := _ChLenFreqCode;
  _WorkDad := _ChLenDadLen;
  InitHeap(ChLenCount);
  SortHeap(1, _HeapLen);
  I := BuildTree(ChLenCount);
  G_FillLongs(0, _ChLenBitCount, MaxChLenBits + 1);
  OverF := 0;
  Result := 0;
  T := @_Tree[I];
  repeat
    Dec(LongWord(T), 4);
    N := T^;
    M := _ChLenDadLen^[_ChLenDadLen^[N]] + 1;
    if M > MaxChLenBits then
    begin
      M := MaxChLenBits;
      Inc(OverF);
    end;
    _ChLenDadLen^[N] := M;
    if N < ChLenCount then
    begin
      Inc(Result, M * _ChLenFreqCode^[N]);
      Inc(_ChLenBitCount^[M]);
    end;
    Dec(I);
  until I = 0;
  if OverF = 0 then
    Exit;
  repeat
    I := MaxChLenBits - 1;
    while _ChLenBitCount^[I] = 0 do
      Dec(I);
    Dec(_ChLenBitCount^[I]);
    Inc(_ChLenBitCount^[I + 1], 2);
    Dec(_ChLenBitCount^[MaxChLenBits]);
    Dec(OverF, 2);
  until OverF <= 0;
  OverF := MaxChLenBits;
  repeat
    N := _ChLenBitCount^[OverF];
    while N <> 0 do
    begin
      M := T^;
      Inc(LongWord(T), SizeOf(Integer));
      if M < ChLenCount then
      begin
        Inc(Result, (OverF - _ChLenDadLen^[M]) * _ChLenFreqCode^[M]);
        _ChLenDadLen^[M] := OverF;
        Dec(N);
      end;
    end;
    Dec(OverF);
  until OverF = 0;
end;

function FillChLenBitLengths: Integer;
var
  Dad, Len: PIntegerItemList;
begin
  Dad := _ChLenDadLen;
  Len := _ChLenBitLen;
  Len^[0] := Dad^[9];
  Len^[1] := Dad^[10];
  Len^[2] := Dad^[8];
  Len^[3] := Dad^[15];
  Len^[4] := Dad^[7];
  Len^[5] := Dad^[11];
  Len^[6] := Dad^[0];
  Len^[7] := Dad^[6];
  Len^[8] := Dad^[16];
  Len^[9] := Dad^[5];
  Len^[10] := Dad^[12];
  Len^[11] := Dad^[4];
  Len^[12] := Dad^[17];
  Len^[13] := Dad^[13];
  Len^[14] := Dad^[3];
  Len^[15] := Dad^[18];
  Len^[16] := Dad^[19];
  Len^[17] := Dad^[2];
  Len^[18] := Dad^[1];
  Len^[19] := Dad^[14];
  Result := ChLenCount - 1;
  while (Len^[Result] = 0) and (Result > 5) do
    Dec(Result);
  Inc(Result);
  _ChLenBitLenLen := Result;
  Result := Result * 3;
end;

function GetFixedBitAmount: Integer;
var
  F, L: PIntegerItemList;
  I: Integer;
begin
  F := _DistFreqCode;
  Result := F^[0] + F^[1] + F^[2] + F^[3] + F^[4] + F^[5] + F^[6] + F^[7] +
    F^[8] + F^[9] + F^[10] + F^[11] + F^[12] + F^[13] + F^[14] + F^[15];
  Inc(Result, F^[16] + F^[17] + F^[18] + F^[19] + F^[20] + F^[21] + F^[22] + F^[23] +
    F^[24] + F^[25] + F^[26] + F^[27] + F^[28] + F^[29] + F^[30] + F^[31]);
  Inc(Result, F^[32] + F^[33] + F^[34] + F^[35] + F^[36] + F^[37] + F^[38] + F^[39] +
    F^[40] + F^[41] + F^[42] + F^[43] + F^[44] + F^[45] + F^[46] + F^[47]);
  Inc(Result, F^[48] + F^[49] + F^[50] + F^[51] + F^[52] + F^[53] + F^[54] + F^[55] +
    F^[56] + F^[57] + F^[58] + F^[59] + F^[60] + F^[61] + F^[62] + F^[63]);
  Result := Result * 6;
  L := @FixedCharLength;
  F := _CharFreqCode;
  I := 7;
  while I < CharCount do
  begin
    Inc(Result, L^[0] * F^[0]);
    Inc(Result, L^[1] * F^[1]);
    Inc(Result, L^[2] * F^[2]);
    Inc(Result, L^[3] * F^[3]);
    Inc(Result, L^[4] * F^[4]);
    Inc(Result, L^[5] * F^[5]);
    Inc(Result, L^[6] * F^[6]);
    Inc(Result, L^[7] * F^[7]);
    Inc(LongWord(L), SizeOf(Integer) * 8);
    Inc(LongWord(F), SizeOf(Integer) * 8);
    Inc(I, 8);
  end;
  Dec(I, 7);
  while I < CharCount do
  begin
    Inc(Result, PInteger(L)^ * PInteger(F)^);
    Inc(LongWord(L), SizeOf(Integer));
    Inc(LongWord(F), SizeOf(Integer));
    Inc(I);
  end;
  Inc(Result, 2);
end;

function WriteNonCompressedBlock(V: LongWord; BlockStart, BlockEnd: Integer): Boolean;
var
  Bits: Integer;
begin
  Result := False;
  if not PutBit(0) then
    Exit;
  if not PutBit(0) then
    Exit;
  Bits := _BitsDef;
  repeat
    if Bits >= 8 then
    begin
      _HoldDef := _HoldDef or (V shl (32 - Bits));
      Dec(Bits, 8);
    end else
    begin
      if Bits <> 0 then
      begin
        _HoldDef := _HoldDef or (V shl (32 - Bits));
        V := V shr Bits;
      end;
      Inc(_DstIndex, 4);
      if _DstIndex > _BreakDefOffset then
        Exit;
      if _GrowMode then
      begin
        if _ChunkLength = ChunkCapacity then
          NextChunk;
        _Chunk^[_ChunkLength] := _HoldDef;
        Inc(_ChunkLength);
      end
      else if not _TryMode then
      begin
        PLongWord(_DstDefBytes)^ := _HoldDef;
        Inc(LongWord(_DstDefBytes), SizeOf(LongWord));
      end;
      _HoldDef := V;
      Inc(Bits, 24);
    end;
    if BlockStart < BlockEnd then
      V := _SrcDefBytes^[BlockStart]
    else
      Break;
    Inc(BlockStart);
  until False;
  _BitsDef := Bits;
  Result := True;
end;

function WriteBlockData: Boolean;
label
  NextLoop;
var
  I, C, N: Integer;
begin
  Result := False;
  I := 0;
  while I < _BufLength do
  begin
    C := _Buffer^[I];
    if not PutNBits(_CharDadLen^[C], LongWord(_CharFreqCode^[C])) then
      Exit;
    if C < FirstLengthChar then
      goto NextLoop;
    if C >= FirstCharWithExBit then
      if C <> LastChar then
      begin
        Dec(C, FirstCharWithExBit);
        if not PutNBits(CharExBitLength[C], LongWord(_Len^[I] - CharExBitBase[C])) then
          Exit;
      end else
      begin
        C := _Len[I] - 145;
        if C < 128 then
        begin
          if not PutNBits(8, LongWord(C or $80)) then
            Exit;
        end
        else if C < 16384 then
        begin
          if not PutNBits(16, LongWord((C and $7F) or
            ((C and $3F80) shl 1) or $8000)) then
            Exit;
        end
        else if not PutNBits(23, LongWord((C and $7F) or
          ((C and $3F80) shl 1) or ((C and $1FC000) shl 2))) then
          Exit;
      end;
    C := _Dist^[I];
    N := _DistDadLen^[C];
    if not PutNBits(N + DistExBitLength[C], LongWord(_DistFreqCode^[C] or
      (_DistExBits^[I] shl N))) then
      Exit;
  NextLoop:
    Inc(I);
  end;
  Result := True;
end;

procedure GenerateFixedCodes;
var
  P: PIntegerItemList;
  BD, FC: PInteger;
  N, I, M: Integer;
begin
  P := _NextDefCode;
  P^[1] := 0;
  N := FixedBitCount[1] shl 1;
  P^[2] := N;
  BD := @FixedBitCount[2];
  Inc(LongWord(P), SizeOf(Integer) * 3);
  I := MaxBits - 2;
  while I > 0 do
  begin
    N := (N + BD^) shl 1;
    PInteger(P)^ := N;
    Inc(LongWord(BD), SizeOf(Integer));
    Inc(LongWord(P), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  FC := PInteger(_CharFreqCode);
  BD := @FixedCharLength[0];
  I := CharCount;
  while I > 0 do
  begin
    N := BD^;
    M := P^[N];
    FC^ := Integer(G_ReverseBits(LongWord(M), N));
    Inc(LongWord(BD), SizeOf(Integer));
    P^[N] := M + 1;
    Inc(LongWord(FC), SizeOf(Integer));
    Dec(I);
  end;
  G_CopyLongs(@FixedCharLength, _CharDadLen, CharCount);
  FC := PInteger(_DistFreqCode);
  I := 0;
  while I < DistCount do
  begin
    FC^ := I;
    Inc(LongWord(FC), SizeOf(Integer));
    Inc(I);
  end;
  G_FillLongs(6, _DistDadLen, DistCount);
end;

function WriteFixedBlock: Boolean;
begin
  GenerateFixedCodes;
  Result := False;
  if not PutBit(0) then
    Exit;
  if not  PutBit(1) then
    Exit;
  Result := WriteBlockData();
end;

procedure GenerateCodes;
var
  P: PIntegerItemList;
  BD, FC: PInteger;
  N, I, M: Integer;
begin
  P := _NextDefCode;
  P^[1] := 0;
  N := _ChLenBitCount^[1] shl 1;
  P^[2] := N;
  Inc(LongWord(P), SizeOf(Integer) * 3);
  BD := @_ChLenBitCount^[2];
  I := MaxChLenBits - 2;
  while i > 0 do
  begin
    N := (N + BD^) shl 1;
    Inc(LongWord(BD), SizeOf(Integer));
    PInteger(P)^ := N;
    Inc(LongWord(P), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  FC := PInteger(_ChLenFreqCode);
  BD := PInteger(_ChLenDadLen);
  I := ChLenCount;
  while I > 0 do
  begin
    N := BD^;
    if N <> 0 then
    begin
      M := P^[N];
      FC^ := Integer(G_ReverseBits(LongWord(M), N));
      P^[N] := M + 1;
    end;
    Inc(LongWord(BD), SizeOf(Integer));
    Inc(LongWord(FC), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  P^[1] := 0;
  N := _CharBitCount^[1] shl 1;
  P^[2] := N;
  Inc(LongWord(P), SizeOf(Integer) * 3);
  BD := @_CharBitCount^[2];
  I := MaxBits - 2;
  while I > 0 do
  begin
    N := (N + BD^) shl 1;
    Inc(LongWord(BD), SizeOf(Integer));
    PInteger(P)^ := N;
    Inc(LongWord(P), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  FC := PInteger(_CharFreqCode);
  BD := PInteger(_CharDadLen);
  I := CharCount;
  while I > 0 do
  begin
    N := BD^;
    if N <> 0 then
    begin
      M := P^[N];
      FC^ := Integer(G_ReverseBits(LongWord(M), N));
      P^[N] := M + 1;
    end;
    Inc(LongWord(BD), SizeOf(Integer));
    Inc(LongWord(FC), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  P^[1] := 0;
  N := _DistBitCount^[1] shl 1;
  P^[2] := N;
  Inc(LongWord(P), SizeOf(Integer) * 3);
  BD := @_DistBitCount^[2];
  I := MaxBits - 2;
  while I > 0 do
  begin
    N := (N + BD^) shl 1;
    Inc(LongWord(BD), SizeOf(Integer));
    PInteger(P)^ := N;
    Inc(LongWord(P), SizeOf(Integer));
    Dec(I);
  end;
  P := _NextDefCode;
  FC := PInteger(_DistFreqCode);
  BD := PInteger(_DistDadLen);
  I := DistCount;
  while I > 0 do
  begin
    N := BD^;
    if N <> 0 then
    begin
      M := P^[N];
      FC^ := Integer(G_ReverseBits(LongWord(M), N));
      P^[N] := M + 1;
    end;
    Inc(LongWord(BD), SizeOf(Integer));
    Inc(LongWord(FC), SizeOf(Integer));
    Dec(I);
  end;
end;

function WriteDynamicBlock: Boolean;
var
  I, M, N: Integer;
begin
  GenerateCodes;
  Result := False;
  if not PutBit(1) then
    Exit;
  if not PutNBits(4, LongWord(_ChLenBitLenLen - 5)) then
    Exit;
  I := 0;
  while I < _ChLenBitLenLen do
  begin
    if not PutNBits(3, LongWord(_ChLenBitLen[I])) then
      Exit;
    Inc(I);
  end;
  if not PutNBits(5, LongWord(_CharLenCount - 256)) then
    Exit;
  I := 0;
  while I < _CharBitLenLen do
  begin
    M := _CharBitLen^[I];
    N := _ChLenDadLen^[M];
    if not PutNBits(N + ChLenExBitLength[M],
      LongWord(_ChLenFreqCode^[M] or (_CharBitLenEx^[I] shl N))) then
      Exit;
    Inc(I);
  end;
  if not PutNBits(6, LongWord(_DistLenCount - 1)) then
    Exit;
  I := 0;
  while I < _DistBitLenLen do
  begin
    M := _DistBitLen^[I];
    N := _ChLenDadLen^[M];
    if not PutNBits(N + ChLenExBitLength[M],
      LongWord(_ChLenFreqCode^[M] or (_DistBitLenEx^[I] shl N))) then
      Exit;
    Inc(I);
  end;
  Result := WriteBlockData;
end;

function FlushBuffer: Boolean;
var
  BitAmount, N: Integer;
  FixedTree: Boolean;
begin
  BitAmount := 16;
  Inc(BitAmount, PrepareCharLengths);
  Inc(BitAmount, FillCharBitLengths);
  Inc(BitAmount, PrepareDistLengths);
  Inc(BitAmount, FillDistBitLengths);
  FillChLenFreqCodes;
  Inc(BitAmount, PrepareChLenLengths);
  Inc(BitAmount, FillChLenBitLengths);
  FixedTree := False;
  N := GetFixedBitAmount;
  if N <= BitAmount then
  begin
    BitAmount := N;
    FixedTree := True;
  end;
  Inc(BitAmount, _ExBitCount);
  N := _BlockEndIndex - _BlockStart;
  Result := False;
  if (N <= BlockSize + 255) and ((N shl 3) + 10 <= BitAmount) then
  begin
    if N < BlockSize then
      N := 0
    else
      Dec(N, BlockSize);
    if not WriteNonCompressedBlock(LongWord(N), _BlockStart, _BlockEndIndex) then
      Exit;
  end
  else if not FixedTree then
  begin
    if not WriteDynamicBlock then
      Exit;
  end
  else if not WriteFixedBlock then
    Exit;
  G_FillLongs(0, _CharFreqCode, CharCount);
  G_FillLongs(0, _DistFreqCode, DistCount);
  _ExBitCount := 0;
  _BlockStart := _BlockEndIndex;
  _BufLength := 0;
  Result := True;
end;

function GetLenChar(L: Integer): Integer;
begin
  if L < 17 then
  begin
    Result := L + 253;
    Exit;
  end;
  if L < 49 then
  begin
    if L < 33 then
    begin
      Inc(_ExBitCount);
      Result := ((L - 17) shr 1) + 270;
      Exit;
    end;
    Inc(_ExBitCount, 2);
    Result := ((L - 33) shr 2) + 278;
    Exit;
  end;
  if L < 81 then
  begin
    if L < 65 then
    begin
      Inc(_ExBitCount, 3);
      Result := ((L - 49) shr 3) + 282;
      Exit;
    end;
    Inc(_ExBitCount, 4);
    Result := 284;
    Exit;
  end;
  if L < 145 then
  begin
    Inc(_ExBitCount, 6);
    Result := 285;
    Exit;
  end;
  if L < 273 then
    Inc(_ExBitCount, 8)
  else if L < 16529 then
    Inc(_ExBitCount, 16)
  else
    Inc(_ExBitCount, 23);
  Result := 286;
end;

function SplitDistance(D: Integer): Integer;
begin
  if D < 1025 then
  begin
    if D < 65 then
    begin
      if D < 17 then
      begin
        if D < 9 then
          Result := D - 1
        else
          Result := ((D - 9) shr 1) + 8;
      end
      else if D < 33 then
        Result := ((D - 17) shr 2) + 12
      else
        Result := ((D - 33) shr 3) + 16;
    end
    else if D < 257 then
    begin
      if D < 129 then
        Result := ((D - 65) shr 4) + 20
      else
        Result := ((D - 129) shr 5) + 24;
    end
    else if D < 513 then
      Result := ((D - 257) shr 6) + 28
    else
      Result := ((D - 513) shr 7) + 32;
  end
  else if D < 16385 then
  begin
    if D < 4097 then
    begin
      if D < 2049 then
        Result := ((D - 1025) shr 8) + 36
      else
        Result := ((D - 2049) shr 9) + 40;
    end
    else if D < 8193 then
      Result := ((D - 4097) shr 10) + 44
    else
      Result := ((D - 8193) shr 11) + 48;
  end
  else if D < 65537 then
  begin
    if D < 32769 then
      Result := ((D - 16385) shr 12) + 52
    else
      Result := ((D - 32769) shr 13) + 56;
  end
  else if D < 131073 then
    Result := ((D - 65537) shr 15) + 60
  else
    Result := ((D - 131073) shr 16) + 62;
end;

function PutChar(C: Integer): Boolean;
var
  BufPos: Integer;
begin
  BufPos := _BufLength;
  if BufPos = BlockSize then
  begin
    if not FlushBuffer then
    begin
      Result := False;
      Exit;
    end;
    BufPos := 0;
  end;
  Inc(_CharFreqCode^[C]);
  _Buffer^[BufPos] := C;
  _BufLength := BufPos + 1;
  Result := True;
end;

function PutLenDist: Boolean;
var
  BufPos, C: Integer;
begin
  BufPos := _BufLength;
  if BufPos = BlockSize then
  begin
    if not FlushBuffer then
    begin
      Result := False;
      Exit;
    end;
    BufPos := 0;
  end;
  C := GetLenChar(_Length);
  Inc(_CharFreqCode^[C]);
  _Buffer^[BufPos] := C;
  _Len^[BufPos] := _Length;
  C := SplitDistance(_Distance);
  _DistExBits^[BufPos] := _Distance - DistExBitBase[C];
  Inc(_DistFreqCode^[C]);
  _Dist^[BufPos] := C;
  Inc(_ExBitCount, DistExBitLength[C]);
  _BufLength := BufPos + 1;
  Result := True;
end;

function Test1Difference(NewDistance: Integer): Boolean;
begin
  Result := True;
  if NewDistance < 16385 then
  begin
    if NewDistance < 4097 then
    begin
      if NewDistance < 2049 then
      begin
        if _Distance < 9 then
          Result := False;
      end
      else if _Distance < 17 then
        Result := False;
    end
    else if NewDistance < 8193 then
    begin
      if _Distance < 33 then
        Result := False;
    end
    else if _Distance < 65 then
      Result := False;
  end
  else if NewDistance < 65537 then
  begin
    if NewDistance < 32769 then
    begin
      if _Distance < 129 then
        Result := False;
    end
    else if _Distance < 257 then
      Result := False;
  end
  else if NewDistance < 131073 then
  begin
    if _Distance < 1025 then
      Result := False;
  end
  else if _Distance < 2049 then
    Result := False;
end;

function Test2Difference(NewDistance: Integer): Boolean;
begin
  Result := True;
  if NewDistance < 131073 then
  begin
    if _Distance < 17 then
      Result := False;
  end
  else if _Distance < 33 then
    Result := False;
end;

function TestMatch(P: Pointer; M1, M2: Integer): Integer;
asm
        PUSH  EBX
        PUSH  ESI
        MOV   EBX,[_ThisBreakOffset]
        LEA   ESI,[EBX-15]
        PUSH  EBX
        JMP   @@ts
@@lp1:  MOV   EBX,[EAX+EDX]
        XOR   EBX,[EAX+ECX]
        JNE   @@m0
        MOV   EBX,[EAX+EDX+4]
        XOR   EBX,[EAX+ECX+4]
        JNE   @@m1
        MOV   EBX,[EAX+EDX+8]
        XOR   EBX,[EAX+ECX+8]
        JNE   @@m2
        MOV   EBX,[EAX+EDX+12]
        XOR   EBX,[EAX+ECX+12]
        JNE   @@m3
        ADD   ECX,16
        ADD   EDX,16
@@ts:   CMP   ECX,ESI
        JL    @@lp1
        POP   ESI
        JMP   @@nx
@@m3:   ADD   ECX,4
@@m2:   ADD   ECX,4
@@m1:   ADD   ECX,4
@@m0:   TEST  EBX,$FFFF
        JNE   @@nz
        ADD   ECX,2
        SHR   EBX,16
@@nz:   SUB   BL,1
        ADC   ECX,0
        POP   ESI
        JMP   @@qt 
@@lp2:  MOV   BL,[EAX+EDX]
        CMP   BL,[EAX+ECX]
        JNE   @@qt
        INC   ECX
        INC   EDX
@@nx:   CMP   ECX,ESI
        JL    @@lp2
@@qt:   MOV   EAX,ECX
        POP   ESI
        POP   EBX
end;

function FindNextFragment(SrcIndex: Integer): Boolean;
var
  P: PBytes;
  M2, Head, Length, Chain: Integer;
  M: LongWord;
begin
  P := _SrcDefBytes;
  Head := _HashHead;
  Length := _Length;
  M := PLongWord(@P^[SrcIndex + Length - 3])^;
  if SrcIndex + MaxLength <= _BreakDefOffset then
    _ThisBreakOffset := SrcIndex + MaxLength
  else
    _ThisBreakOffset := _BreakDefOffset;
  Result := False;
  Chain := _Chain;
  repeat
    if PLongWord(@P^[Head + Length - 3])^ = M then
    begin
      M2 := TestMatch(P, Head, SrcIndex);
      Dec(M2, SrcIndex + Length);
      Dec(SrcIndex, Head);
      if (M2 > 2) or ((M2 = 1) and ((SrcIndex < Diff1Min) or Test1Difference(SrcIndex))) or
        ((M2 = 2) and ((SrcIndex < Diff2Min) or Test2Difference(SrcIndex))) then
      begin
        Inc(Length, M2);
        _Distance := SrcIndex;
        M2 := Length + SrcIndex + Head;
        Result := True;
        if M2 = _ThisBreakOffset then
          Break;
        M := PLongWord(@P^[M2 - 3])^;
      end;
      Inc(SrcIndex, Head);
    end;
    Head := _Prev^[Head and _PrevMask];
    if Head <= _Limit then
      Break;
    Dec(Chain);
  until Chain = 0;
  _Length := Length;
end;

function FindFirstFragment(SrcIndex: Integer): Boolean;
var
  P: PBytes;
  Head, Chain: Integer;
  M: LongWord;
begin
  P := _SrcDefBytes;
  M := LongWord(P^[SrcIndex]) or (LongWord(P^[SrcIndex + 1]) shl 8) or
    (LongWord(P^[SrcIndex + 2]) shl 16);
  Head := _HashHead;
  if SrcIndex + MaxLength <= _BreakDefOffset then
    _ThisBreakOffset := SrcIndex + MaxLength
  else
    _ThisBreakOffset := _BreakDefOffset;
  Chain := _Chain;
  Result := False;
  repeat
    if PLongWord(@P^[Head])^ and $FFFFFF = M then
    begin
      if (SrcIndex + 3 < _ThisBreakOffset) and (P^[SrcIndex + 3] = P^[Head + 3]) then
      begin
        if (SrcIndex + 4 < _ThisBreakOffset) and (P^[SrcIndex + 4] = P^[Head + 4]) then
        begin
          _Length := TestMatch(P, Head + 5, SrcIndex + 5) - SrcIndex;
          Result := True;
          Break;
        end
        else if SrcIndex - Head <= Len4MaxDist then
        begin
          _Length := 4;
          Result := True;
          Break;
        end;
      end
      else if SrcIndex - Head <= Len3MaxDist then
      begin
        _Length := 3;
        Result := True;
        Break;
      end;
    end;
    Head := _Prev^[Head and _PrevMask];
    if Head <= _Limit then
      Break;
    Dec(Chain);
  until Chain = 0;
  _Distance := SrcIndex - Head;
  _HashHead := Head;
  _Chain := Chain;
end;

function FlushBitTrail: Boolean;
var
  Hold: LongWord;
begin
  Result := False;
  if not FlushBuffer then
    Exit;
  Inc(_DstIndex, 4 - (_BitsDef shr 3));
  if _DstIndex <= _BreakDefOffset then
  begin
    Hold := _HoldDef;
    if _GrowMode then
    begin
      if _ChunkLength = ChunkCapacity then
        NextChunk;
      _Chunk^[_ChunkLength] := Hold;
      Inc(_ChunkLength);
    end
    else if not _TryMode then
      case _BitsDef shr 3 of
        0: PLongWord(_DstDefBytes)^ := Hold;
        1:
          begin
            _DstDefBytes^[0] := Byte(Hold);
            _DstDefBytes^[1] := Byte(Hold shr 8);
            _DstDefBytes^[2] := Byte(Hold shr 16);
          end;
        2:
          begin
            _DstDefBytes^[0] := Byte(Hold);
            _DstDefBytes^[1] := Byte(Hold shr 8);
          end;
        3: PByte(_DstDefBytes)^ := Byte(Hold);
      end;
    Result := True;
  end;
end;

function DeflateCore: Integer;
var
  H, SrcIndex, NextOffset: Integer;
begin
  GetMem(_Hash, _HashSize * SizeOf(Integer));
  GetMem(_Prev, _PrevSize * SizeOf(Integer));
  G_FillLongs(-_PrevSize, _Hash, _HashSize);
  G_FillLongs(0, _CharFreqCode, CharCount);
  G_FillLongs(0, _DistFreqCode, DistCount);
  _BlockStart := 0;
  _BufLength := 0;
  _ExBitCount := 0;
  _Prev^[0] := -_PrevSize;
  H := ((_SrcDefBytes^[0] shl (_Shift + _Shift)) xor
    (_SrcDefBytes^[1] shl _Shift) xor _SrcDefBytes^[2]) and _HashMask;
  _Hash^[H] := 0;
  _DstIndex := 0;
  PutChar(_SrcDefBytes^[0]);
  _BitsDef := 32;
  _HoldDef := 0;
  SrcIndex := 1;
  Result := -1;
  while SrcIndex < _BreakDefOffset - 2 do
  begin
    H := ((H shl _Shift) xor _SrcDefBytes^[SrcIndex + 2]) and _HashMask;
    _HashHead := _Hash^[H];
    _Prev^[SrcIndex and _PrevMask] := _HashHead;
    _Hash^[H] := SrcIndex;
    _BlockEndIndex := SrcIndex;
    _Chain := _MaxChain;
    _Limit := SrcIndex - _PrevSize;
    if (_HashHead <= _Limit) or not FindFirstFragment(SrcIndex) then
    begin
      if not PutChar(_SrcDefBytes^[SrcIndex]) then
        Exit;
      Inc(SrcIndex);
    end else
    begin
      NextOffset := SrcIndex + _Length;
      _HashHead := _Prev^[_HashHead and _PrevMask];
      if (_HashHead > _Limit) and (NextOffset < _ThisBreakOffset) then
      begin
        FindNextFragment(SrcIndex);
        NextOffset := SrcIndex + _Length;
      end;
      while (_Length < LazyLimit) and (NextOffset < _BreakDefOffset) do
      begin
        Inc(SrcIndex);
        H := ((H shl _Shift) xor _SrcDefBytes^[SrcIndex + 2]) and _HashMask;
        _HashHead := _Hash^[H];
        _Prev^[SrcIndex and _PrevMask] := _HashHead;
        _Hash^[H] := SrcIndex;
        _Chain := _MaxChain;
        _Limit := SrcIndex - _PrevSize;
        if (_HashHead <= _Limit) or not FindNextFragment(SrcIndex) then
          Break;
        if not PutChar(_SrcDefBytes^[SrcIndex - 1]) then
          Exit;
        NextOffset := SrcIndex + _Length;
        _BlockEndIndex := SrcIndex;
      end;
      if not PutLenDist then
        Exit;
      if NextOffset >= _BreakDefOffset - 2 then
        SrcIndex := NextOffset
      else
      begin
        Inc(SrcIndex);
        repeat
          H := ((H shl _Shift) xor _SrcDefBytes^[SrcIndex + 2]) and _HashMask;
          _HashHead := _Hash^[H];
          _Prev^[SrcIndex and _PrevMask] := _HashHead;
          _Hash^[H] := SrcIndex;
          Inc(SrcIndex);
        until SrcIndex = NextOffset;
      end;
    end;
  end;
  while SrcIndex < _BreakDefOffset do
  begin
    _BlockEndIndex := SrcIndex;
    if not PutChar(_SrcDefBytes^[SrcIndex]) then
      Exit;
    Inc(SrcIndex);
  end;
  _BlockEndIndex := SrcIndex;
  if not FlushBitTrail then
    Exit;
  Result := _DstIndex;
end;

procedure SetupDeflateMode(Mode: TCompressionMode);
begin
  case Mode of
    dcmFastest:
      begin
        _HashSize := HashSizeFastest;
        _HashMask := HashMaskFastest;
        _PrevSize := PrevSizeFastest;
        _PrevMask := PrevMaskFastest;
        _MaxChain := ChainFastest;
        _Shift := ShiftFastest;
      end;
    dcmFast:
      begin
        _HashSize := HashSizeFast;
        _HashMask := HashMaskFast;
        _PrevSize := PrevSizeFast;
        _PrevMask := PrevMaskFast;
        _MaxChain := ChainFast;
        _Shift := ShiftFast;
      end;
    dcmNormal:
      begin
        _HashSize := HashSizeNormal;
        _HashMask := HashMaskNormal;
        _PrevSize := PrevSizeNormal;
        _PrevMask := PrevMaskNormal;
        _MaxChain := ChainNormal;
        _Shift := ShiftNormal;
      end;
    dcmMaximumCompression:
      begin
        _HashSize := HashSizeMaximum;
        _HashMask := HashMaskMaximum;
        _PrevSize := PrevSizeMaximum;
        _PrevMask := PrevMaskMaximum;
        _MaxChain := ChainMaximum;
        _Shift := ShiftMaximum;
      end;
  end;
end;

var
  DeflatorCriticalSection: _RTL_CRITICAL_SECTION;

procedure AllocDeflator;
begin
  if _Heap = nil then
  begin
    GetMem(_CharBitCount, (MaxBits + 1) * SizeOf(Integer));
    GetMem(_CharFreqCode, CharTreeSize * SizeOf(Integer));
    GetMem(_CharDadLen, CharTreeSize * SizeOf(Integer));
    GetMem(_CharBitLen, CharCount * SizeOf(Integer));
    GetMem(_CharBitLenEx, CharCount * SizeOf(Integer));
    GetMem(_DistBitCount, (MaxBits + 1) * SizeOf(Integer));
    GetMem(_DistFreqCode, DistTreeSize * SizeOf(Integer));
    GetMem(_DistDadLen, DistTreeSize * SizeOf(Integer));
    GetMem(_DistBitLen, DistCount * SizeOf(Integer));
    GetMem(_DistBitLenEx, DistCount * SizeOf(Integer));
    GetMem(_ChLenBitCount, (MaxChLenBits + 1) * SizeOf(Integer));
    GetMem(_ChLenFreqCode, ChLenTreeSize * SizeOf(Integer));
    GetMem(_ChLenDadLen, ChLenTreeSize * SizeOf(Integer));
    GetMem(_ChLenBitLen, ChLenCount * SizeOf(Integer));
    GetMem(_Buffer, BlockSize * SizeOf(Integer));
    GetMem(_Len, BlockSize * SizeOf(Integer));
    GetMem(_Dist, BlockSize * SizeOf(Integer));
    GetMem(_DistExBits, BlockSize * SizeOf(Integer));
    GetMem(_NextDefCode, (MaxBits + 1) * SizeOf(Integer));
    GetMem(_Tree, CharTreeSize * SizeOf(Integer));
    GetMem(_Depth, CharTreeSize * SizeOf(Integer));
    GetMem(_Heap, (CharCount + 1) * SizeOf(Integer));
  end;
end;

procedure FreeChunks;
var
  I: Integer;
begin
  if _ChunkListCapacity > 0 then
  begin
    for I := _ChunkListLength - 1 downto 0 do
      FreeMem(_ChunkList^[I]);
    FreeMem(_ChunkList);
  end;
  FreeMem(_Chunk);
end;

function FlushNonCompressed(SourceBytes: Pointer; SourceLength: Integer;
  var DestinationBytes: Pointer; BeforeGap, AfterGap: Integer): Integer;
begin
  GetMem(DestinationBytes, BeforeGap + 4 + SourceLength + AfterGap);
  if BeforeGap > 0 then
    G_ZeroMem(DestinationBytes, BeforeGap);
  PInteger(@PBytes(DestinationBytes)^[BeforeGap])^ := -SourceLength;
  Inc(BeforeGap, 4);
  G_CopyMem(SourceBytes, @PBytes(DestinationBytes)^[BeforeGap], SourceLength);
  if AfterGap > 0 then
    G_ZeroMem(@PBytes(DestinationBytes)^[BeforeGap + SourceLength], AfterGap);
  Result := SourceLength + 4;
end;

function G_Deflate(SourceBytes: Pointer; SourceLength: Integer;
  var DestinationBytes: Pointer; BeforeGap, AfterGap: Integer;
  Mode: TCompressionMode): Integer;
var
  OutSize, I, N: Integer;
begin
  if SourceLength = 0 then
  begin
    DestinationBytes := G_AllocMem(BeforeGap + AfterGap + 4);
    Result := 4;
    Exit;
  end;
  if not Assigned(SourceBytes) then
    RaiseErrorFmt(SErrArgumentNull, 'SourceBytes', 'G_Deflate');
  if (Mode = dcmNoCompression) or (SourceLength < 4) then
  begin
    Result := FlushNonCompressed(SourceBytes, SourceLength, DestinationBytes,
      BeforeGap, AfterGap);
    Exit;
  end;
  if IsMultiThread then
    EnterCriticalSection(DeflatorCriticalSection);
  try
    AllocDeflator;
    SetupDeflateMode(Mode);
    _GrowMode := True;
    _TryMode := False;
    _ChunkListCapacity := 0;
    _ChunkListLength := 0;
    GetMem(_Chunk, ChunkCapacity * SizeOf(LongWord));
    _ChunkLength := 0;
    _BreakDefOffset := SourceLength;
    _DstDefBytes := nil;
    _SrcDefBytes := PBytes(SourceBytes);
    OutSize := DeflateCore;
    FreeMem(_Hash);
    FreeMem(_Prev);
    if OutSize < 0 then
    begin
      FreeChunks;
      Result := FlushNonCompressed(SourceBytes, SourceLength, DestinationBytes,
        BeforeGap, AfterGap);
    end else
    begin
      Result := OutSize + 4;
      GetMem(DestinationBytes, BeforeGap + Result + AfterGap);
      if BeforeGap > 0 then
        G_ZeroMem(DestinationBytes, BeforeGap);
      PInteger(@PBytes(DestinationBytes)^[BeforeGap])^ := SourceLength;
      Inc(BeforeGap, 4);
      if AfterGap > 0 then
        G_ZeroMem(@PBytes(DestinationBytes)^[BeforeGap + OutSize], AfterGap);
      Dec(OutSize);
      N := OutSize shr ChunkShift;
      I := 0;
      while I < N do
      begin
        G_CopyMem(_ChunkList^[I], @PBytes(DestinationBytes)^[BeforeGap],
          ChunkCapacity * SizeOf(LongWord));
        Inc(BeforeGap, ChunkCapacity * SizeOf(LongWord));
        Inc(I);
      end;
      G_CopyMem(_Chunk, @PBytes(DestinationBytes)^[BeforeGap],
        (OutSize and ((ChunkCapacity * SizeOf(LongWord)) - 1)) + 1);
      FreeChunks;
    end;
  finally
    if IsMultiThread then
      LeaveCriticalSection(DeflatorCriticalSection);
  end;
end;

function G_Deflate(SourceBytes: Pointer; SourceLength: Integer;
  DestinationBytes: Pointer; Mode: TCompressionMode): Integer;
var
  DstBytes: PBytes;
  TryMode: Boolean;
begin
  TryMode := False;
  if destinationBytes <> nil then
    DstBytes := PBytes(DestinationBytes)
  else
  begin
    DstBytes := nil;
    TryMode := True;
  end;
  if SourceLength = 0 then
  begin
    if not TryMode then
      PInteger(DstBytes)^ := 0;
    Result := 4;
    Exit;
  end;
  if not Assigned(SourceBytes) then
    RaiseErrorFmt(SErrArgumentNull, 'SourceBytes', 'G_Deflate');
  Result := -1;
  if (Mode <> dcmNoCompression) and (SourceLength > 3) then
  begin
    if IsMultiThread then
      EnterCriticalSection(DeflatorCriticalSection);
    try
      AllocDeflator;
      SetupDeflateMode(Mode);
      _TryMode := TryMode;
      _GrowMode := False;
      _BreakDefOffset := SourceLength;
      _SrcDefBytes := PBytes(SourceBytes);
      _DstDefBytes := @DstBytes^[4];
      if not TryMode then
        PInteger(DstBytes)^ := SourceLength;
      Result := DeflateCore;
      FreeMem(_Hash);
      FreeMem(_Prev);
    finally
      if IsMultiThread then
        LeaveCriticalSection(DeflatorCriticalSection);
    end;
  end;
  if Result < 0 then
  begin
    if not TryMode then
    begin
      PInteger(DstBytes)^ := -SourceLength;
      G_CopyMem(SourceBytes, @DstBytes^[4], SourceLength);
    end;
    Result := SourceLength;
  end;
  Inc(Result, 4);
end;

procedure G_ReleaseDeflator;
begin
  if IsMultiThread then
    EnterCriticalSection(DeflatorCriticalSection);
  try
    if _Heap <> nil then
    begin
      FreeMem(_CharBitCount);
      FreeMem(_CharFreqCode);
      FreeMem(_CharDadLen);
      FreeMem(_CharBitLen);
      FreeMem(_CharBitLenEx);
      FreeMem(_DistBitCount);
      FreeMem(_DistFreqCode);
      FreeMem(_DistDadLen);
      FreeMem(_DistBitLen);
      FreeMem(_DistBitLenEx);
      FreeMem(_ChLenBitCount);
      FreeMem(_ChLenFreqCode);
      FreeMem(_ChLenDadLen);
      FreeMem(_ChLenBitLen);
      FreeMem(_Buffer);
      FreeMem(_Len);
      FreeMem(_Dist);
      FreeMem(_DistExBits);
      FreeMem(_NextDefCode);
      FreeMem(_Tree);
      FreeMem(_Depth);
      FreeMem(_Heap);
      _Heap := nil;
    end;
  finally
    if IsMultiThread then
      LeaveCriticalSection(DeflatorCriticalSection);
  end;
end;

function ProcessNBitsTail(Bits: Integer): Integer;
begin
  if _SrcIndex < _BreakInfOffset then
  begin
    Inc(_SrcIndex);
    Result := (PByte(_SrcInfBytes)^ shl Bits);
    Inc(LongWord(_SrcInfBytes));
  end else
  begin
    RaiseError(SErrReadBeyondTheEndOfStream);
    Result := 0;
  end;
end;

function GetNBits(N: Integer): Integer;
var
  Hold, Bits: Integer;
begin
  Hold := _HoldInf;
  Bits := _BitsInf;
  if Bits < N then
    if _SrcIndex < _Break16Offset then
    begin
      Inc(_SrcIndex, 2);
      Hold := Hold or (PWord(_SrcInfBytes)^ shl Bits);
      Inc(LongWord(_SrcInfBytes), 2);
      Inc(Bits, 16);
    end else
    begin
      Hold := Hold or ProcessNBitsTail(Bits);
      Inc(Bits, 8);
    end;
  _HoldInf := Hold shr N;
  _BitsInf := Bits - N;
  Result := Hold and ((1 shl N) - 1);
end;

function ProcessTail: Integer;
begin
  if _SrcIndex < _BreakInfOffset then
  begin
    Inc(_SrcIndex);
    Result := PByte(_SrcInfBytes)^;
    Inc(LongWord(_SrcInfBytes));
  end else
  begin
    RaiseError(SErrReadBeyondTheEndOfStream);
    Result := 0;
  end;
end;

function GetBit: Integer;
var
  Hold: LongWord;
  Bits: Integer;
begin
  Hold := LongWord(_HoldInf);
  Bits := _BitsInf;
  if Bits <> 0 then
    Dec(Bits)
  else if _SrcIndex < _Break32Offset then
  begin
    Inc(_SrcIndex, 4);
    Hold := PLongWord(_SrcInfBytes)^;
    Inc(LongWord(_SrcInfBytes), SizeOf(LongWord));
    Bits := 31;
  end else
  begin
    Hold := ProcessTail;
    Bits := 7;
  end;
  _HoldInf := Integer(Hold shr 1);
  _BitsInf := Bits;
  Result := Integer(Hold and 1);
end;

function GetCode(Tree: PIntegerItemList): Integer;
label
  CodeFound;
var
  Code, Hold, Bits: Integer;
begin
  Code := 1;
  Hold := _HoldInf;
  Bits := _BitsInf;
  repeat
    while Bits <> 0 do
    begin
      Code := Tree^[Code + (Hold and 1)];
      Hold := Hold shr 1;
      Dec(Bits);
      if Code <= 0 then
        goto CodeFound;
    end;
    if _SrcIndex < _Break32Offset then
    begin
      Inc(_SrcIndex, 4);
      Hold := PInteger(_SrcInfBytes)^;
      Inc(LongWord(_SrcInfBytes), SizeOf(Integer));
      Bits := 31;
    end else
    begin
      Hold := ProcessTail;
      Bits := 7;
    end;
    Code := Tree^[Code + (Hold and 1)];
    Hold := Integer(LongWord(Hold) shr 1);
  until Code <= 0;
CodeFound:
  _HoldInf := Hold;
  _BitsInf := Bits;
  Result := -Code;
end;

procedure LoadChLenLengths;
var
  N, M: Integer;
begin
  G_FillLongs(0, _BitLen, ChLenCount);
  G_FillLongs(0, _BitCount, MaxChLenBits + 1);
  N := GetNBits(4);
  M := GetNBits(3);
  _BitLen^[9] := M;
  Inc(_BitCount^[M]);
  M := GetNBits(3);
  _BitLen^[10] := M;
  Inc(_BitCount^[M]);
  M := GetNBits(3);
  _BitLen^[8] := M;
  Inc(_BitCount^[M]);
  M := GetNBits(3);
  _BitLen^[15] := M;
  Inc(_BitCount^[M]);
  M := GetNBits(3);
  _BitLen^[7] := M;
  Inc(_BitCount^[M]);
  if N = 0 then
    Exit;
  M := GetNBits(3);
  _BitLen^[11] := M;
  Inc(_BitCount^[M]);
  if N = 1 then
    Exit;
  M := GetNBits(3);
  _BitLen^[0] := M;
  Inc(_BitCount^[M]);
  if N = 2 then
    Exit;
  M := GetNBits(3);
  _BitLen^[6] := M;
  Inc(_BitCount^[M]);
  if N = 3 then
    Exit;
  M := GetNBits(3);
  _BitLen^[16] := M;
  Inc(_BitCount^[M]);
  if N = 4 then
    Exit;
  M := GetNBits(3);
  _BitLen^[5] := M;
  Inc(_BitCount^[M]);
  if N = 5 then
    Exit;
  M := GetNBits(3);
  _BitLen^[12] := M;
  Inc(_BitCount^[M]);
  if N = 6 then
    Exit;
  M := GetNBits(3);
  _BitLen^[4] := M;
  Inc(_BitCount^[M]);
  if N = 7 then
    Exit;
  M := GetNBits(3);
  _BitLen^[17] := M;
  Inc(_BitCount^[M]);
  if N = 8 then
    Exit;
  M := GetNBits(3);
  _BitLen^[13] := M;
  Inc(_BitCount^[M]);
  if N = 9 then
    Exit;
  M := GetNBits(3);
  _BitLen^[3] := M;
  Inc(_BitCount^[M]);
  if N = 10 then
    Exit;
  M := GetNBits(3);
  _BitLen^[18] := M;
  Inc(_BitCount^[M]);
  if N = 11 then
    Exit;
  M := GetNBits(3);
  _BitLen^[19] := M;
  Inc(_BitCount^[M]);
  if N = 12 then
    Exit;
  M := GetNBits(3);
  _BitLen^[2] := M;
  Inc(_BitCount^[M]);
  if N = 13 then
    Exit;
  M := GetNBits(3);
  _BitLen^[1] := M;
  Inc(_BitCount^[M]);
  if N = 14 then
    Exit;
  M := GetNBits(3);
  _BitLen^[14] := M;
  Inc(_BitCount^[M]);
end;

procedure LoadChLenTree;
label
  NextLoop;
var
  N, M, P, Code, TreeLen, I: Integer;
begin
  LoadChLenLengths();
  G_FillLongs(0, _ChLenTree, ChLenTreeSize);
  _NextInfCode^[1] := 0;
  N := _BitCount^[1] shl 1;
  _NextInfCode^[2] := N;
  N := (N + _BitCount^[2]) shl 1;
  _NextInfCode^[3] := N;
  N := (N + _BitCount^[3]) shl 1;
  _NextInfCode^[4] := N;
  N := (N + _BitCount^[4]) shl 1;
  _NextInfCode^[5] := N;
  N := (N + _BitCount^[5]) shl 1;
  _NextInfCode^[6] := N;
  N := (N + _BitCount^[6]) shl 1;
  _NextInfCode^[7] := N;
  TreeLen := 2;
  I := 0;
  while I < ChLenCount do
  begin
    N := _BitLen^[I];
    if N = 0 then
      goto NextLoop;
    M := _NextInfCode^[N];
    Code := Integer(G_ReverseBits(LongWord(M), N));
    _NextInfCode^[N] := M + 1;
    P := 1;
    repeat
      Inc(P, Code and 1);
      Code := Code shr 1;
      Dec(N);
      if N <> 0 then
      begin
        M := P;
        P := _ChLenTree^[P];
        if P = 0 then
        begin
          P := TreeLen + 1;
          TreeLen := P + 1;
          _ChLenTree^[M] := P;
        end;
      end else
      begin
        _ChLenTree^[P] := -I;
        Break;
      end;
    until False;
  NextLoop:
    Inc(I);
  end;
end;

procedure LoadCharDistLengths(Count: Integer);
var
  C, LastLen: Integer;
  P: PInteger;
begin
  LastLen := 7;
  P := PInteger(_BitLen);
  G_FillLongs(0, _BitCount, MaxBits + 1);
  while Count > 0 do
  begin
    C := GetCode(_ChLenTree);
    if C < 15 then
    begin
      P^ := C;
      Inc(_BitCount^[C]);
      Inc(LongWord(P), SizeOf(Integer));
      LastLen := C;
      Dec(Count);
    end else
    begin
      case C of
        15: C := 2;
        16: C := GetBit + 3;
        17: C := GetNBits(2) + 5;
        18: C := GetNBits(3) + 9;
        19: C := GetNBits(7) + 17;
      end;
      Dec(Count, C);
      Inc(_BitCount^[LastLen], C);
      repeat
        P^ := LastLen;
        Inc(LongWord(P), SizeOf(Integer));
        Dec(C);
      until C = 0;
    end;
  end;
end;

procedure LoadCharTree;
label
  NextLoop;
var
  N, M, P, Code, TreeLen, I: Integer;
begin
  G_FillLongs(0, _BitLen, CharCount);
  LoadCharDistLengths(GetNBits(5) + 256);
  G_FillLongs(0, _CharTree, CharTreeSize);
  _NextInfCode^[1] := 0;
  N := _BitCount^[1] shl 1;
  _NextInfCode^[2] := N;
  N := (N + _BitCount^[2]) shl 1;
  _NextInfCode^[3] := N;
  N := (N + _BitCount^[3]) shl 1;
  _NextInfCode^[4] := N;
  N := (N + _BitCount^[4]) shl 1;
  _NextInfCode^[5] := N;
  N := (N + _BitCount^[5]) shl 1;
  _NextInfCode^[6] := N;
  N := (N + _BitCount^[6]) shl 1;
  _NextInfCode^[7] := N;
  N := (N + _BitCount^[7]) shl 1;
  _NextInfCode^[8] := N;
  N := (N + _BitCount^[8]) shl 1;
  _NextInfCode^[9] := N;
  N := (N + _BitCount^[9]) shl 1;
  _NextInfCode^[10] := N;
  N := (N + _BitCount^[10]) shl 1;
  _NextInfCode^[11] := N;
  N := (N + _BitCount^[11]) shl 1;
  _NextInfCode^[12] := N;
  N := (N + _BitCount^[12]) shl 1;
  _NextInfCode^[13] := N;
  N := (N + _BitCount^[13]) shl 1;
  _NextInfCode^[14] := N;
  TreeLen := 2;
  I := 0;
  while I < CharCount do
  begin
    N := _BitLen^[I];
    if N = 0 then
      goto NextLoop;
    M := _NextInfCode^[N];
    Code := Integer(G_ReverseBits(LongWord(M), N));
    _NextInfCode^[N] := M + 1;
    P := 1;
    repeat
      Inc(P, Code and 1);
      Code := Code shr 1;
      Dec(N);
      if N <> 0 then
      begin
        M := P;
        P := _CharTree^[P];
        if P = 0 then
        begin
          P := TreeLen + 1;
          TreeLen := P + 1;
          _CharTree^[M] := P;
        end;
      end else
      begin
        _CharTree^[P] := -I;
        Break;
      end;
    until False;
  NextLoop:
    Inc(I);
  end;
end;

procedure LoadDistTree;
label
  NextLoop;
var
  N, M, P, Code, TreeLen, I: Integer;
begin
  G_FillLongs(0, _BitLen, DistCount);
  LoadCharDistLengths(GetNBits(6) + 1);
  G_FillLongs(0, _DistTree, DistTreeSize);
  _NextInfCode^[1] := 0;
  N := _BitCount^[1] shl 1;
  _NextInfCode^[2] := N;
  N := (N + _BitCount^[2]) shl 1;
  _NextInfCode^[3] := N;
  N := (N + _BitCount^[3]) shl 1;
  _NextInfCode^[4] := N;
  N := (N + _BitCount^[4]) shl 1;
  _NextInfCode^[5] := N;
  N := (N + _BitCount^[5]) shl 1;
  _NextInfCode^[6] := N;
  N := (N + _BitCount^[6]) shl 1;
  _NextInfCode^[7] := N;
  N := (N + _BitCount^[7]) shl 1;
  _NextInfCode^[8] := N;
  N := (N + _BitCount^[8]) shl 1;
  _NextInfCode^[9] := N;
  N := (N + _BitCount^[9]) shl 1;
  _NextInfCode^[10] := N;
  N := (N + _BitCount^[10]) shl 1;
  _NextInfCode^[11] := N;
  N := (N + _BitCount^[11]) shl 1;
  _NextInfCode^[12] := N;
  N := (N + _BitCount^[12]) shl 1;
  _NextInfCode^[13] := N;
  N := (N + _BitCount^[13]) shl 1;
  _NextInfCode^[14] := N;
  TreeLen := 2;
  I := 0;
  while I < DistCount do
  begin
    N := _BitLen^[I];
    if N = 0 then
      goto NextLoop;
    M := _NextInfCode^[N];
    Code := Integer(G_ReverseBits(LongWord(M), N));
    _NextInfCode^[N] := M + 1;
    P := 1;
    repeat
      Inc(P, Code and 1);
      Code := Code shr 1;
      Dec(N);
      if N <> 0 then
      begin
        M := P;
        P := _DistTree^[P];
        if P = 0 then
        begin
          P := TreeLen + 1;
          TreeLen := P + 1;
          _DistTree^[M] := P;
        end;
      end else
      begin
        _DistTree^[P] := -I;
        Break;
      end;
    until False;
  NextLoop:
    Inc(I);
  end;
end;

procedure LoadFixedTree;
var
  I, N, M, P, Code, TreeLen: Integer;
begin
  G_FillLongs(0, _CharTree, CharTreeSize);
  _NextInfCode^[1] := 0;
  N := FixedBitCount[1] shl 1;
  _NextInfCode^[2] := N;
  I := 0;
  while I < MaxBits do
  begin
    N := (N + FixedBitCount[I]) shl 1;
    _NextInfCode^[I + 1] := N;
    Inc(I);
  end;
  TreeLen := 2;
  I := 0;
  while I < CharCount do
  begin
    N := FixedCharLength[I];
    M := _NextInfCode^[N];
    Code := Integer(G_ReverseBits(LongWord(M), N));
    _NextInfCode^[N] := M + 1;
    P := 1;
    repeat
      Inc(P, Code and 1);
      Code := Code shr 1;
      Dec(N);
      if n <> 0 then
      begin
        M := P;
        P := _CharTree^[P];
        if P = 0 then
        begin
          P := TreeLen + 1;
          TreeLen := P + 1;
          _CharTree^[M] := P;
        end;
      end else
      begin
        _CharTree^[P] := -I;
        Break;
      end;
    until False;
    Inc(I);
  end;
end;

procedure ReadNonCompressedBlock;
var
  Bits, Hold, Counter: Integer;
  P: PWord;
begin
  Counter := GetNBits(8) + BlockSize;
  if Counter > _OutCounter then
    Counter := _OutCounter;
  Dec(_OutCounter, Counter);
  Bits := _BitsInf;
  Hold := _HoldInf;
  P := PWord(_SrcInfBytes);
  while Counter > 0 do
  begin
    if Bits < 8 then
      if _SrcIndex < _Break16Offset then
      begin
        Inc(_SrcIndex, 2);
        Hold := Hold or (P^ shl Bits);
        Inc(Bits, 16);
        Inc(LongWord(P), 2);
      end else
      begin
        _SrcInfBytes := PBytes(P);
        Hold := Hold or ProcessNBitsTail(Bits);
        P := PWord(_SrcInfBytes);
        Inc(Bits, 8);
      end;
    PByte(_DstInfBytes)^ := Byte(Hold);
    Hold := Hold shr 8;
    Dec(Bits, 8);
    Inc(LongWord(_DstInfBytes));
    Dec(Counter);
  end;
  _SrcInfBytes := PBytes(P);
  _BitsInf := Bits;
  _HoldInf := Hold;
end;

procedure InflateCore;
var
  C, Length: Integer;
begin
  repeat
    _FixedTree := False;
    if GetBit <> 0 then
    begin
      LoadChLenTree;
      LoadCharTree;
      LoadDistTree;
    end
    else if GetBit <> 0 then
    begin
      LoadFixedTree;
      _FixedTree := True;
    end else
    begin
      ReadNonCompressedBlock;
      if _OutCounter > 0 then
        Continue
      else
        Exit;
    end;
    _InCounter := BlockSize;
    repeat
      C := GetCode(_CharTree);
      Dec(_InCounter);
      if C < FirstLengthChar then
      begin
        PByte(_DstInfBytes)^ := Byte(C);
        Inc(LongWord(_DstInfBytes));
        Dec(_OutCounter);
      end else
      begin
        Dec(C, FirstCharWithExBit);
        if C < 0 then
          Length := C + 17
        else if C < 16 then
          Length := GetNBits(CharExBitLength[C]) + CharExBitBase[C]
        else
        begin
          C := GetNBits(8);
          Length := C and $7F;
          if (C and $80) = 0 then
          begin
            C := GetNBits(8);
            Length := Length or ((C and $7F) shl 7);
            if (C and $80) = 0 then
            begin
              C := GetNBits(7);
              Length := Length or (C shl 14);
            end;
          end;
          Inc(Length, 145);
        end;
        if not _FixedTree then
          C := GetCode(_DistTree)
        else
          C := GetNBits(6);
        if C >= FirstDistWithExBit then
          C := GetNBits(DistExBitLength[C]) + DistExBitBase[C]
        else
          C := DistExBitBase[C];
        G_CopyBytes(@_DstInfBytes^[-C], _DstInfBytes, Length);
        Inc(LongWord(_DstInfBytes), Length);
        Dec(_OutCounter, Length);
      end;
      if _OutCounter <= 0 then
        Exit;
    until _InCounter = 0;
  until False;
end;

function G_GetInflatedLength(SourceBytes: Pointer): Integer;
begin
  if not Assigned(SourceBytes) then
    RaiseErrorFmt(SErrArgumentNull, 'SourceBytes', 'G_GetInflatedLength');
  Result := PInteger(SourceBytes)^;
  if Result < 0 then
    Result := -Result;
end;

function G_Inflate(SourceBytes: Pointer; SourceLength: Integer;
  var DestinationBytes: Pointer; BeforeGap, AfterGap: Integer): Integer;
var
  SkipInflating: Boolean;
begin
  if not Assigned(SourceBytes) then
    RaiseErrorFmt(SErrArgumentNull, 'SourceBytes', 'G_Inflate');
  Result := PInteger(SourceBytes)^;
  SkipInflating := False;
  if Result < 0 then
  begin
    Result := -Result;
    SkipInflating := True;
  end;
  GetMem(DestinationBytes, BeforeGap + Result + AfterGap);
  if BeforeGap > 0 then
    G_ZeroMem(DestinationBytes, BeforeGap);
  if SkipInflating then
    G_CopyMem(@PBytes(SourceBytes)^[4], @PBytes(DestinationBytes)^[BeforeGap], Result)
  else if Result > 0 then
    G_Inflate(SourceBytes, SourceLength, @PBytes(DestinationBytes)^[BeforeGap]);
  if AfterGap > 0 then
    G_ZeroMem(@PBytes(DestinationBytes)^[BeforeGap + Result], AfterGap);
end;

var
  InflatorCriticalSection: _RTL_CRITICAL_SECTION;

procedure AllocInflator;
begin
  if _BitLen = nil then
  begin
    GetMem(_CharTree, CharTreeSize * SizeOf(Integer));
    GetMem(_DistTree, DistTreeSize * SizeOf(Integer));
    GetMem(_ChLenTree, ChLenTreeSize * SizeOf(Integer));
    GetMem(_BitCount, (MaxBits + 1) * SizeOf(Integer));
    GetMem(_NextInfCode, (MaxBits + 1) * SizeOf(Integer));
    GetMem(_BitLen, CharCount * SizeOf(Integer));
  end;
end;

function G_Inflate(SourceBytes: Pointer; SourceLength: Integer;
  DestinationBytes: Pointer): Integer;
begin
  if not Assigned(SourceBytes) then
    RaiseErrorFmt(SErrArgumentNull, 'SourceBytes', 'G_Inflate');
  Result := PInteger(SourceBytes)^;
  if (Result = 0) or not Assigned(DestinationBytes) then
  begin
    if Result < 0 then
      Result := -Result;
    Exit;
  end;
  if Result < 0 then
  begin
    Result := -Result;
    G_CopyMem(@PBytes(SourceBytes)^[4], DestinationBytes, Result);
    Exit;
  end;
  if IsMultiThread then
    EnterCriticalSection(InflatorCriticalSection);
  try
    AllocInflator;
    _SrcInfBytes := @PBytes(SourceBytes)^[4];
    _DstInfBytes := PBytes(DestinationBytes);
    _BitsInf := 0;
    _HoldInf := 0;
    _SrcIndex := 4;
    _BreakInfOffset := SourceLength;
    _Break32Offset := SourceLength - 3;
    _Break16Offset := SourceLength - 1;
    _OutCounter := Result;
    InflateCore;
  finally
    if IsMultiThread then
      LeaveCriticalSection(InflatorCriticalSection);
  end;
end;

procedure G_ReleaseInflator;
begin
  if IsMultiThread then
    EnterCriticalSection(InflatorCriticalSection);
  try
    if _BitLen <> nil then
    begin
      FreeMem(_CharTree);
      FreeMem(_DistTree);
      FreeMem(_ChLenTree);
      FreeMem(_BitCount);
      FreeMem(_NextInfCode);
      FreeMem(_BitLen);
      _BitLen := nil;
    end;
  finally
    if IsMultiThread then
      LeaveCriticalSection(InflatorCriticalSection);
  end;
end;

initialization
  InitializeCriticalSection(DeflatorCriticalSection);
  InitializeCriticalSection(InflatorCriticalSection);

finalization
  if not IsMultiThread then
  begin
    G_ReleaseDeflator;
    G_ReleaseInflator;
    DeleteCriticalSection(DeflatorCriticalSection);
    DeleteCriticalSection(InflatorCriticalSection);
  end;
end.

