
///////////////////////////////////////////////////
//                                               //
//   AcedMemory 1.16                             //
//                                               //
//   Функции для выделения/освобождения памяти   //
//                                               //
//   mailto: acedutils@yandex.ru                 //
//                                               //
///////////////////////////////////////////////////

unit AcedMemory;

{$B-,H+,R-,Q-,T-,X+}

(*
  AcedMemory заменяет собой стандартный менеджер памяти, используемый
  библиотекой времени выполнения (RTL) при вызове функций GetMem, FreeMem
  и ReallocMem. Этот модуль должен стоять первым в разделе uses основной
  программы. Например:

  program Project1;

  uses
    AcedMemory in 'AcedMemory.pas',
    Forms,
    ...

  {$R *.RES}

  begin
    Application.Initialize;
    Application.Title := 'Project1';
    Application.CreateForm(TMainForm, MainForm);
    ...
    Application.Run;
  end.
*)

interface

{ Внутренняя функция для выделения блока памяти размером Size байт.
  Значение параметра Size должно быть больше 0. }

function G_GetMem(Size: Integer): Pointer;

{ Внутренняя функция для освобождения блока памяти. Значение
  параметра P должно быть отлично от nil. }

function G_FreeMem(P: Pointer): Integer;

{ Внутренняя функция для изменения размера блока памяти. Параметр P
  должен быть отличен от nil, а параметр Size больше нуля. }

function G_ReallocMem(P: Pointer; Size: Integer): Pointer;

{ G_GetMemSize возвращает размер блока памяти, адрес которого передан
  параметром P. }

function G_GetMemSize(P: Pointer): Integer;

{ G_GetTotalMemAllocated возвращает общий размер памяти, используемой
  программой. }

function G_GetTotalMemAllocated: LongWord;

{ G_GetTotalMemCommitted возвращает общий размер физической памяти,
  выделенной программе в страничном файле без учета служебных структур. }

function G_GetTotalMemCommitted: LongWord;

implementation

uses Windows, SysUtils, AcedBinary, AcedConsts;

const
  winHEAP_NO_SERIALIZE = 1;
  winHEAP_GENERATE_EXCEPTIONS = 4;
  winHEAP_ZERO_MEMORY = 8;

  MediumBlockPoolSize = 256;
  CountDelta = 16;

  StdBlockSize: array[0..23] of Integer =
    (16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,
     6144,8192,12288,16384,24576,32768,49152);

  StdFreeCount: array[0..14] of Integer =
    (6143,4095,3071,2047,1535,1023,767,511,383,255,191,127,95,63,47);

type
  PRegion = ^TRegion;
  TRegion = packed record
    BaseAddr: LongWord;
    BlockMask: LongWord;
    BlockIndexList: array[0..31] of Word;
    BlockSizeList: array[0..31] of Word;
  end;

  PBlock16 = ^TBlock16;
  TBlock16 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..191] of LongWord;
  end;

  PBlock24 = ^TBlock24;
  TBlock24 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..127] of LongWord;
  end;

  PBlock32 = ^TBlock32;
  TBlock32 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..95] of LongWord;
  end;

  PBlock48 = ^TBlock48;
  TBlock48 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..63] of LongWord;
  end;

  PBlock64 = ^TBlock64;
  TBlock64 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..47] of LongWord;
  end;

  PBlock96 = ^TBlock96;
  TBlock96 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..31] of LongWord;
  end;

  PBlock128 = ^TBlock128;
  TBlock128 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..23] of LongWord;
  end;

  PBlock192 = ^TBlock192;
  TBlock192 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..15] of LongWord;
  end;

  PBlock256 = ^TBlock256;
  TBlock256 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..11] of LongWord;
  end;

  PBlock384 = ^TBlock384;
  TBlock384 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..7] of LongWord;
  end;

  PBlock512 = ^TBlock512;
  TBlock512 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..5] of LongWord;
  end;

  PBlock768 = ^TBlock768;
  TBlock768 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..3] of LongWord;
  end;

  PBlock1024 = ^TBlock1024;
  TBlock1024 = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..2] of LongWord;
  end;

  PBlock2k = ^TBlock2k;
  TBlock2k = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    FirstFree: Integer;
    FreeCount: Integer;
    BitArray: array[0..1] of LongWord;
  end;

  PMediumBlock = ^TMediumBlock;
  TMediumBlock = packed record
    Region: PRegion;
    RegionItemIndex: LongWord;
    BaseAddr: LongWord;
    BitArray: LongWord;
  end;

  PRegionList = ^TRegionList;
  TRegionList = array[0..DWordListUpperLimit] of PRegion;

  PBlock16List = ^TBlock16List;
  TBlock16List = array[0..DWordListUpperLimit] of PBlock16;

  PBlock24List = ^TBlock24List;
  TBlock24List = array[0..DWordListUpperLimit] of PBlock24;

  PBlock32List = ^TBlock32List;
  TBlock32List = array[0..DWordListUpperLimit] of PBlock32;

  PBlock48List = ^TBlock48List;
  TBlock48List = array[0..DWordListUpperLimit] of PBlock48;

  PBlock64List = ^TBlock64List;
  TBlock64List = array[0..DWordListUpperLimit] of PBlock64;

  PBlock96List = ^TBlock96List;
  TBlock96List = array[0..DWordListUpperLimit] of PBlock96;

  PBlock128List = ^TBlock128List;
  TBlock128List = array[0..DWordListUpperLimit] of PBlock128;

  PBlock192List = ^TBlock192List;
  TBlock192List = array[0..DWordListUpperLimit] of PBlock192;

  PBlock256List = ^TBlock256List;
  TBlock256List = array[0..DWordListUpperLimit] of PBlock256;

  PBlock384List = ^TBlock384List;
  TBlock384List = array[0..DWordListUpperLimit] of PBlock384;

  PBlock512List = ^TBlock512List;
  TBlock512List = array[0..DWordListUpperLimit] of PBlock512;

  PBlock768List = ^TBlock768List;
  TBlock768List = array[0..DWordListUpperLimit] of PBlock768;

  PBlock1024List = ^TBlock1024List;
  TBlock1024List = array[0..DWordListUpperLimit] of PBlock1024;

  PBlock2kList = ^TBlock2kList;
  TBlock2kList = array[0..DWordListUpperLimit] of PBlock2k;

  PMediumBlockList = ^TMediumBlockList;
  TMediumBlockList = array[0..DWordListUpperLimit] of PMediumBlock;

var
  TotalMemAllocated: LongWord = 0;
  CriticalSection: _RTL_CRITICAL_SECTION;
  OldMemoryManager: TMemoryManager;
  Heap: THandle;

  BigBlockCount: Integer = 0;
  BigBlockCapacity: Integer;
  BigBlockAddrs: PLongWordItemList;

  MediumBlockCount: Integer = 0;
  MediumBlockPool: PMediumBlock;

  FoundRegion: PRegion;
  RegionFreeItemIndex: LongWord;

  RegionCount: Integer;
  RegionListCapacity: Integer;
  RegionCapacity: Integer = 0;
  Regions: PRegionList;

  Block16Count: Integer = 0;
  Block16ListCapacity: Integer;
  Block16Capacity: Integer = 0;
  FirstFreeBlock16: Integer = 0;
  Blocks16: PBlock16List;

  Block24Count: Integer = 0;
  Block24ListCapacity: Integer;
  Block24Capacity: Integer = 0;
  FirstFreeBlock24: Integer = 0;
  Blocks24: PBlock24List;

  Block32Count: Integer = 0;
  Block32ListCapacity: Integer;
  Block32Capacity: Integer = 0;
  FirstFreeBlock32: Integer = 0;
  Blocks32: PBlock32List;

  Block48Count: Integer = 0;
  Block48ListCapacity: Integer;
  Block48Capacity: Integer = 0;
  FirstFreeBlock48: Integer = 0;
  Blocks48: PBlock48List;

  Block64Count: Integer = 0;
  Block64ListCapacity: Integer;
  Block64Capacity: Integer = 0;
  FirstFreeBlock64: Integer = 0;
  Blocks64: PBlock64List;

  Block96Count: Integer = 0;
  Block96ListCapacity: Integer;
  Block96Capacity: Integer = 0;
  FirstFreeBlock96: Integer = 0;
  Blocks96: PBlock96List;

  Block128Count: Integer = 0;
  Block128ListCapacity: Integer;
  Block128Capacity: Integer = 0;
  FirstFreeBlock128: Integer = 0;
  Blocks128: PBlock128List;

  Block192Count: Integer = 0;
  Block192ListCapacity: Integer;
  Block192Capacity: Integer = 0;
  FirstFreeBlock192: Integer = 0;
  Blocks192: PBlock192List;

  Block256Count: Integer = 0;
  Block256ListCapacity: Integer;
  Block256Capacity: Integer = 0;
  FirstFreeBlock256: Integer = 0;
  Blocks256: PBlock256List;

  Block384Count: Integer = 0;
  Block384ListCapacity: Integer;
  Block384Capacity: Integer = 0;
  FirstFreeBlock384: Integer = 0;
  Blocks384: PBlock384List;

  Block512Count: Integer = 0;
  Block512ListCapacity: Integer;
  Block512Capacity: Integer = 0;
  FirstFreeBlock512: Integer = 0;
  Blocks512: PBlock512List;

  Block768Count: Integer = 0;
  Block768ListCapacity: Integer;
  Block768Capacity: Integer = 0;
  FirstFreeBlock768: Integer = 0;
  Blocks768: PBlock768List;

  Block1024Count: Integer = 0;
  Block1024ListCapacity: Integer;
  Block1024Capacity: Integer = 0;
  FirstFreeBlock1024: Integer = 0;
  Blocks1024: PBlock1024List;

  Block1536Count: Integer = 0;
  Block1536ListCapacity: Integer;
  Block1536Capacity: Integer = 0;
  FirstFreeBlock1536: Integer = 0;
  Blocks1536: PBlock2kList;

  Block2kCount: Integer = 0;
  Block2kListCapacity: Integer;
  Block2kCapacity: Integer = 0;
  FirstFreeBlock2k: Integer = 0;
  Blocks2k: PBlock2kList;

  Block3kCount: Integer = 0;
  Block3kListCapacity: Integer;
  Block3kCapacity: Integer = 0;
  FirstFreeBlock3k: Integer = 0;
  Blocks3k: PMediumBlockList;

  Block4kCount: Integer = 0;
  Block4kListCapacity: Integer;
  Block4kCapacity: Integer = 0;
  FirstFreeBlock4k: Integer = 0;
  Blocks4k: PMediumBlockList;

  Block6kCount: Integer = 0;
  Block6kListCapacity: Integer;
  Block6kCapacity: Integer = 0;
  FirstFreeBlock6k: Integer = 0;
  Blocks6k: PMediumBlockList;

  Block8kCount: Integer = 0;
  Block8kListCapacity: Integer;
  Block8kCapacity: Integer = 0;
  FirstFreeBlock8k: Integer = 0;
  Blocks8k: PMediumBlockList;

  Block12kCount: Integer = 0;
  Block12kListCapacity: Integer;
  Block12kCapacity: Integer = 0;
  FirstFreeBlock12k: Integer = 0;
  Blocks12k: PMediumBlockList;

  Block16kCount: Integer = 0;
  Block16kListCapacity: Integer;
  Block16kCapacity: Integer = 0;
  FirstFreeBlock16k: Integer = 0;
  Blocks16k: PMediumBlockList;

  Block24kCount: Integer = 0;
  Block24kListCapacity: Integer;
  Block24kCapacity: Integer = 0;
  FirstFreeBlock24k: Integer = 0;
  Blocks24k: PMediumBlockList;

  Block32kCount: Integer = 0;
  Block32kListCapacity: Integer;
  Block32kCapacity: Integer = 0;
  FirstFreeBlock32k: Integer = 0;
  Blocks32k: PMediumBlockList;

  Block48kCount: Integer = 0;
  Block48kListCapacity: Integer;
  Block48kCapacity: Integer = 0;
  FirstFreeBlock48k: Integer = 0;
  Blocks48k: PMediumBlockList;

  FreeBlock16Exists: Boolean = False;
  FreeBlock24Exists: Boolean = False;
  FreeBlock32Exists: Boolean = False;
  FreeBlock48Exists: Boolean = False;
  FreeBlock64Exists: Boolean = False;
  FreeBlock96Exists: Boolean = False;
  FreeBlock128Exists: Boolean = False;
  FreeBlock192Exists: Boolean = False;
  FreeBlock256Exists: Boolean = False;
  FreeBlock384Exists: Boolean = False;
  FreeBlock512Exists: Boolean = False;
  FreeBlock768Exists: Boolean = False;
  FreeBlock1024Exists: Boolean = False;
  FreeBlock1536Exists: Boolean = False;
  FreeBlock2kExists: Boolean = False;
  FreeBlock3kExists: Boolean = False;
  FreeBlock4kExists: Boolean = False;
  FreeBlock6kExists: Boolean = False;
  FreeBlock8kExists: Boolean = False;
  FreeBlock12kExists: Boolean = False;
  FreeBlock16kExists: Boolean = False;
  FreeBlock24kExists: Boolean = False;
  FreeBlock32kExists: Boolean = False;
  FreeBlock48kExists: Boolean = False;
  FreeRegionExists: Boolean = False;
  ManagerInstalled: Boolean = False;

function ScanAndSetFreeBit(var L: LongWord): LongWord;
asm
        MOV     ECX,EAX
        MOV     EDX,[EAX]
        NOT     EDX
        BSF     EAX,EDX
        NOT     EDX
        OR      EDX,DWORD PTR [EAX*4+BitMasks32]
        MOV     [ECX],EDX
end;

procedure InsertRegion(R: PRegion);
var
  L, H, I: Integer;
  X: LongWord;
begin
  L := 0;
  H := RegionCount - 1;
  X := R^.BaseAddr;
  while L <= H do
  begin
    I := (L + H) shr 1;
    if Regions^[I].BaseAddr < X then
      L := I + 1
    else
      H := I - 1;
  end;
  if L < RegionCount then
    G_MoveLongs(@Regions^[L], @Regions^[L + 1], RegionCount - L);
  Regions^[L] := R;
  Inc(RegionCount);
end;

procedure EnlargeList(ListAddr: PPointer; var Capacity: Integer);
var
  NewCapacity: Integer;
  NewList: Pointer;
begin
  NewCapacity := G_EnlargeCapacity(Capacity);
  NewList := HeapAlloc(Heap, 0, NewCapacity * SizeOf(LongWord));
  G_CopyLongs(ListAddr^, NewList, Capacity);
  HeapFree(Heap, 0, ListAddr^);
  ListAddr^ := NewList;
  Capacity := NewCapacity;
end;

procedure UpdateCapacity(ListAddr: PPointer; var Capacity: Integer;
  SizeOfItem: LongWord);
var
  P: Pointer;
  I: Integer;
begin
  P := HeapAlloc(Heap, winHEAP_ZERO_MEMORY, SizeOfItem * CountDelta);
  I := Capacity;
  Capacity := I + CountDelta;
  while I < Capacity do
  begin
    PPointerItemList(ListAddr^)^[I] := P;
    Inc(LongWord(P), SizeOfItem);
    Inc(I);
  end;
end;

function TakeNewBlock: Boolean;
var
  I: Integer;
  R: PRegion;
begin
  Result := True;
  for I := 0 to RegionCount - 1 do
  begin
    R := Regions^[I];
    if R^.BlockMask <> $FFFFFFFF then
    begin
      RegionFreeItemIndex := ScanAndSetFreeBit(R^.BlockMask);
      FoundRegion := R;
      Exit;
    end;
  end;
  RegionFreeItemIndex := 0;
  if FreeRegionExists then
  begin
    R := Regions^[RegionCount];
    R^.BlockMask := 1;
    InsertRegion(R);
    FreeRegionExists := False;
    FoundRegion := R;
    Exit;
  end;
  if RegionCount = RegionCapacity then
  begin
    if RegionCount = RegionListCapacity then
      EnlargeList(@Regions, RegionListCapacity);
    UpdateCapacity(@Regions, RegionCapacity, SizeOf(TRegion));
  end;
  R := Regions^[RegionCount];
  R^.BaseAddr := LongWord(VirtualAlloc(nil, $300000,
    MEM_RESERVE or MEM_COMMIT or MEM_TOP_DOWN, PAGE_READWRITE));
  if R^.BaseAddr <> 0 then
  begin
    R^.BlockMask := 1;
    InsertRegion(R);
    FoundRegion := R;
    Exit;
  end;
  Result := False;
end;

function RestoreSmallBlock(Blocks: Pointer; var Count: Integer; SizeFreeCount: Integer): Pointer;
begin
  with PBlock2kList(Blocks)^[Count]^ do
  begin
    FreeCount := SizeFreeCount;
    BitArray[0] := 1;
    Result := Pointer(BaseAddr);
  end;
  Inc(Count);
end;

function UpdateSmallBlockInfo(Blocks: Pointer; var Count: Integer; SizeIndex: Integer): Pointer;
var
  L: LongWord;
begin
  L := RegionFreeItemIndex;
  with FoundRegion^ do
  begin
    BlockIndexList[L] := Count;
    BlockSizeList[L] := SizeIndex;
  end;
  with PBlock2kList(Blocks)^[Count]^ do
  begin
    Region := FoundRegion;
    RegionItemIndex := L;
    BaseAddr :=  L * 98304 + FoundRegion^.BaseAddr;
    FirstFree := 0;
    FreeCount := StdFreeCount[SizeIndex];
    BitArray[0] := 1;
    Result := Pointer(BaseAddr);
  end;
  Inc(Count);
end;

function GetMem16: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock16 < Block16Count then
    with Blocks16^[FirstFreeBlock16]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 4) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock16);
        FirstFree := -1;
      end;
    end
  else if FreeBlock16Exists then
  begin
    Result := RestoreSmallBlock(Blocks16, Block16Count, 6143);
    FreeBlock16Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block16Count = Block16Capacity then
    begin
      if Block16Count = Block16ListCapacity then
        EnlargeList(@Blocks16, Block16ListCapacity);
      UpdateCapacity(@Blocks16, Block16Capacity, SizeOf(TBlock16));
    end;
    Result := UpdateSmallBlockInfo(Blocks16, Block16Count, 0);
  end;
  Inc(TotalMemAllocated, 16);
end;

function GetMem24: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock24 < Block24Count then
    with Blocks24^[FirstFreeBlock24]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 24) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock24);
        FirstFree := -1;
      end;
    end
  else if FreeBlock24Exists then
  begin
    Result := RestoreSmallBlock(Blocks24, Block24Count, 4095);
    FreeBlock24Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block24Count = Block24Capacity then
    begin
      if Block24Count = Block24ListCapacity then
        EnlargeList(@Blocks24, Block24ListCapacity);
      UpdateCapacity(@Blocks24, Block24Capacity, SizeOf(TBlock24));
    end;
    Result := UpdateSmallBlockInfo(Blocks24, Block24Count, 1);
  end;
  Inc(TotalMemAllocated, 24);
end;

function GetMem32: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock32 < Block32Count then
    with Blocks32^[FirstFreeBlock32]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 5) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock32);
        FirstFree := -1;
      end;
    end
  else if FreeBlock32Exists then
  begin
    Result := RestoreSmallBlock(Blocks32, Block32Count, 3071);
    FreeBlock32Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block32Count = Block32Capacity then
    begin
      if Block32Count = Block32ListCapacity then
        EnlargeList(@Blocks32, Block32ListCapacity);
      UpdateCapacity(@Blocks32, Block32Capacity, SizeOf(TBlock32));
    end;
    Result := UpdateSmallBlockInfo(Blocks32, Block32Count, 2);
  end;
  Inc(TotalMemAllocated, 32);
end;

function GetMem48: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock48 < Block48Count then
    with Blocks48^[FirstFreeBlock48]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 48) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock48);
        FirstFree := -1;
      end;
    end
  else if FreeBlock48Exists then
  begin
    Result := RestoreSmallBlock(Blocks48, Block48Count, 2047);
    FreeBlock48Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block48Count = Block48Capacity then
    begin
      if Block48Count = Block48ListCapacity then
        EnlargeList(@Blocks48, Block48ListCapacity);
      UpdateCapacity(@Blocks48, Block48Capacity, SizeOf(TBlock48));
    end;
    Result := UpdateSmallBlockInfo(Blocks48, Block48Count, 3);
  end;
  Inc(TotalMemAllocated, 48);
end;

function GetMem64: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock64 < Block64Count then
    with Blocks64^[FirstFreeBlock64]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 6) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock64);
        FirstFree := -1;
      end;
    end
  else if FreeBlock64Exists then
  begin
    Result := RestoreSmallBlock(Blocks64, Block64Count, 1535);
    FreeBlock64Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block64Count = Block64Capacity then
    begin
      if Block64Count = Block64ListCapacity then
        EnlargeList(@Blocks64, Block64ListCapacity);
      UpdateCapacity(@Blocks64, Block64Capacity, SizeOf(TBlock64));
    end;
    Result := UpdateSmallBlockInfo(Blocks64, Block64Count, 4);
  end;
  Inc(TotalMemAllocated, 64);
end;

function GetMem96: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock96 < Block96Count then
    with Blocks96^[FirstFreeBlock96]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 96) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock96);
        FirstFree := -1;
      end;
    end
  else if FreeBlock96Exists then
  begin
    Result := RestoreSmallBlock(Blocks96, Block96Count, 1023);
    FreeBlock96Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block96Count = Block96Capacity then
    begin
      if Block96Count = Block96ListCapacity then
        EnlargeList(@Blocks96, Block96ListCapacity);
      UpdateCapacity(@Blocks96, Block96Capacity, SizeOf(TBlock96));
    end;
    Result := UpdateSmallBlockInfo(Blocks96, Block96Count, 5);
  end;
  Inc(TotalMemAllocated, 96);
end;

function GetMem128: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock128 < Block128Count then
    with Blocks128^[FirstFreeBlock128]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 7) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock128);
        FirstFree := -1;
      end;
    end
  else if FreeBlock128Exists then
  begin
    Result := RestoreSmallBlock(Blocks128, Block128Count, 767);
    FreeBlock128Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block128Count = Block128Capacity then
    begin
      if Block128Count = Block128ListCapacity then
        EnlargeList(@Blocks128, Block128ListCapacity);
      UpdateCapacity(@Blocks128, Block128Capacity, SizeOf(TBlock128));
    end;
    Result := UpdateSmallBlockInfo(Blocks128, Block128Count, 6);
  end;
  Inc(TotalMemAllocated, 128);
end;

function GetMem192: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock192 < Block192Count then
    with Blocks192^[FirstFreeBlock192]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 192) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock192);
        FirstFree := -1;
      end;
    end
  else if FreeBlock192Exists then
  begin
    Result := RestoreSmallBlock(Blocks192, Block192Count, 511);
    FreeBlock192Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block192Count = Block192Capacity then
    begin
      if Block192Count = Block192ListCapacity then
        EnlargeList(@Blocks192, Block192ListCapacity);
      UpdateCapacity(@Blocks192, Block192Capacity, SizeOf(TBlock192));
    end;
    Result := UpdateSmallBlockInfo(Blocks192, Block192Count, 7);
  end;
  Inc(TotalMemAllocated, 192);
end;

function GetMem256: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock256 < Block256Count then
    with Blocks256^[FirstFreeBlock256]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 8) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock256);
        FirstFree := -1;
      end;
    end
  else if FreeBlock256Exists then
  begin
    Result := RestoreSmallBlock(Blocks256, Block256Count, 383);
    FreeBlock256Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block256Count = Block256Capacity then
    begin
      if Block256Count = Block256ListCapacity then
        EnlargeList(@Blocks256, Block256ListCapacity);
      UpdateCapacity(@Blocks256, Block256Capacity, SizeOf(TBlock256));
    end;
    Result := UpdateSmallBlockInfo(Blocks256, Block256Count, 8);
  end;
  Inc(TotalMemAllocated, 256);
end;

function GetMem384: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock384 < Block384Count then
    with Blocks384^[FirstFreeBlock384]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 384) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock384);
        FirstFree := -1;
      end;
    end
  else if FreeBlock384Exists then
  begin
    Result := RestoreSmallBlock(Blocks384, Block384Count, 255);
    FreeBlock384Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block384Count = Block384Capacity then
    begin
      if Block384Count = Block384ListCapacity then
        EnlargeList(@Blocks384, Block384ListCapacity);
      UpdateCapacity(@Blocks384, Block384Capacity, SizeOf(TBlock384));
    end;
    Result := UpdateSmallBlockInfo(Blocks384, Block384Count, 9);
  end;
  Inc(TotalMemAllocated, 384);
end;

function GetMem512: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock512 < Block512Count then
    with Blocks512^[FirstFreeBlock512]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 9) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock512);
        FirstFree := -1;
      end;
    end
  else if FreeBlock512Exists then
  begin
    Result := RestoreSmallBlock(Blocks512, Block512Count, 191);
    FreeBlock512Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block512Count = Block512Capacity then
    begin
      if Block512Count = Block512ListCapacity then
        EnlargeList(@Blocks512, Block512ListCapacity);
      UpdateCapacity(@Blocks512, Block512Capacity, SizeOf(TBlock512));
    end;
    Result := UpdateSmallBlockInfo(Blocks512, Block512Count, 10);
  end;
  Inc(TotalMemAllocated, 512);
end;

function GetMem768: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock768 < Block768Count then
    with Blocks768^[FirstFreeBlock768]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) * 768) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock768);
        FirstFree := -1;
      end;
    end
  else if FreeBlock768Exists then
  begin
    Result := RestoreSmallBlock(Blocks768, Block768Count, 127);
    FreeBlock768Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block768Count = Block768Capacity then
    begin
      if Block768Count = Block768ListCapacity then
        EnlargeList(@Blocks768, Block768ListCapacity);
      UpdateCapacity(@Blocks768, Block768Capacity, SizeOf(TBlock768));
    end;
    Result := UpdateSmallBlockInfo(Blocks768, Block768Count, 11);
  end;
  Inc(TotalMemAllocated, 768);
end;

function GetMem1024: Pointer;
var
  I: Integer;
begin
  Result := nil;
  if FirstFreeBlock1024 < Block1024Count then
    with Blocks1024^[FirstFreeBlock1024]^ do
    begin
      I := FirstFree;
      Result := Pointer(((ScanAndSetFreeBit(BitArray[I]) +
        (LongWord(I) shl 5)) shl 10) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        while BitArray[I] = $FFFFFFFF do
          Inc(I);
        FirstFree := I;
      end else
      begin
        Inc(FirstFreeBlock1024);
        FirstFree := -1;
      end;
    end
  else if FreeBlock1024Exists then
  begin
    Result := RestoreSmallBlock(Blocks1024, Block1024Count, 95);
    FreeBlock1024Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block1024Count = Block1024Capacity then
    begin
      if Block1024Count = Block1024ListCapacity then
        EnlargeList(@Blocks1024, Block1024ListCapacity);
      UpdateCapacity(@Blocks1024, Block1024Capacity, SizeOf(TBlock1024));
    end;
    Result := UpdateSmallBlockInfo(Blocks1024, Block1024Count, 12);
  end;
  Inc(TotalMemAllocated, 1024);
end;

function GetMem1536: Pointer;
begin
  Result := nil;
  if FirstFreeBlock1536 < Block1536Count then
    with Blocks1536^[FirstFreeBlock1536]^ do
    begin
      if FirstFree = 0 then
        Result := Pointer((ScanAndSetFreeBit(BitArray[0]) * 1536) + BaseAddr)
      else
        Result := Pointer(((ScanAndSetFreeBit(BitArray[1]) + 32) * 1536) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        if BitArray[0] = $FFFFFFFF then
          FirstFree := 1;
      end else
      begin
        Inc(FirstFreeBlock1536);
        FirstFree := -1;
      end;
    end
  else if FreeBlock1536Exists then
  begin
    Result := RestoreSmallBlock(Blocks1536, Block1536Count, 63);
    FreeBlock1536Exists := False;
  end
  else if TakeNewBlock then
  begin
    if Block1536Count = Block1536Capacity then
    begin
      if Block1536Count = Block1536ListCapacity then
        EnlargeList(@Blocks1536, Block1536ListCapacity);
      UpdateCapacity(@Blocks1536, Block1536Capacity, SizeOf(TBlock2k));
    end;
    Result := UpdateSmallBlockInfo(Blocks1536, Block1536Count, 13);
  end;
  Inc(TotalMemAllocated, 1536);
end;

function GetMem2k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock2k < Block2kCount then
    with Blocks2k^[FirstFreeBlock2k]^ do
    begin
      if FirstFree = 0 then
        Result := Pointer((ScanAndSetFreeBit(BitArray[0]) shl 11) + BaseAddr)
      else
        Result := Pointer(((ScanAndSetFreeBit(BitArray[1]) + 32) shl 11) + BaseAddr);
      Dec(FreeCount);
      if FreeCount > 0 then
      begin
        if BitArray[0] = $FFFFFFFF then
          FirstFree := 1;
      end else
      begin
        Inc(FirstFreeBlock2k);
        FirstFree := -1;
      end;
    end
  else if FreeBlock2kExists then
  begin
    Result := RestoreSmallBlock(Blocks2k, Block2kCount, 47);
    FreeBlock2kExists := False;
  end
  else if TakeNewBlock then
  begin
    if Block2kCount = Block2kCapacity then
    begin
      if Block2kCount = Block2kListCapacity then
        EnlargeList(@Blocks2k, Block2kListCapacity);
      UpdateCapacity(@Blocks2k, Block2kCapacity, SizeOf(TBlock2k));
    end;
    Result := UpdateSmallBlockInfo(Blocks2k, Block2kCount, 14);
  end;
  Inc(TotalMemAllocated, 2048);
end;

function NewMediumBlock: PMediumBlock;
begin
  if MediumBlockCount = 0 then
  begin
    MediumBlockPool := HeapAlloc(Heap, 0, MediumBlockPoolSize * SizeOf(TMediumBlock));
    MediumBlockCount := MediumBlockPoolSize;
  end;
  Result := MediumBlockPool;
  Inc(LongWord(MediumBlockPool), SizeOf(TMediumBlock));
  Dec(MediumBlockCount);
end;

function UpdateMediumBlockInfo(Blocks: PMediumBlockList; var Count: Integer; SizeIndex: Integer): Pointer;
var
  L: LongWord;
begin
  L := RegionFreeItemIndex;
  with FoundRegion^ do
  begin
    BlockIndexList[L] := Count;
    BlockSizeList[L] := SizeIndex;
  end;
  with Blocks^[Count]^ do
  begin
    Region := FoundRegion;
    RegionItemIndex := L;
    BaseAddr := L * 98304 + FoundRegion^.BaseAddr;
    BitArray := 1;
    Result := Pointer(BaseAddr);
  end;
  Inc(Count);
end;

function GetMem3k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock3k < Block3kCount then
    with Blocks3k^[FirstFreeBlock3k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) * 3072) + BaseAddr);
      if BitArray = $FFFFFFFF then
        Inc(FirstFreeBlock3k);
    end
  else if FreeBlock3kExists then
  begin
    with Blocks3k^[Block3kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock3kExists := False;
    Inc(Block3kCount);
  end
  else if TakeNewBlock then
  begin
    if Block3kCount = Block3kCapacity then
    begin
      if Block3kCount = Block3kListCapacity then
        EnlargeList(@Blocks3k, Block3kListCapacity);
      Blocks3k^[Block3kCapacity] := NewMediumBlock;
      Inc(Block3kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks3k, Block3kCount, 15);
  end;
  Inc(TotalMemAllocated, 3072);
end;

function GetMem4k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock4k < Block4kCount then
    with Blocks4k^[FirstFreeBlock4k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) shl 12) + BaseAddr);
      if BitArray = $FFFFFF then
        Inc(FirstFreeBlock4k);
    end
  else if FreeBlock4kExists then
  begin
    with Blocks4k^[Block4kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock4kExists := False;
    Inc(Block4kCount);
  end
  else if TakeNewBlock then
  begin
    if Block4kCount = Block4kCapacity then
    begin
      if Block4kCount = Block4kListCapacity then
        EnlargeList(@Blocks4k, Block4kListCapacity);
      Blocks4k^[Block4kCapacity] := NewMediumBlock;
      Inc(Block4kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks4k, Block4kCount, 16);
  end;
  Inc(TotalMemAllocated, 4096);
end;

function GetMem6k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock6k < Block6kCount then
    with Blocks6k^[FirstFreeBlock6k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) * 6144) + BaseAddr);
      if BitArray = $FFFF then
        Inc(FirstFreeBlock6k);
    end
  else if FreeBlock6kExists then
  begin
    with Blocks6k^[Block6kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock6kExists := False;
    Inc(Block6kCount);
  end
  else if TakeNewBlock then
  begin
    if Block6kCount = Block6kCapacity then
    begin
      if Block6kCount = Block6kListCapacity then
        EnlargeList(@Blocks6k, Block6kListCapacity);
      Blocks6k^[Block6kCapacity] := NewMediumBlock;
      Inc(Block6kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks6k, Block6kCount, 17);
  end;
  Inc(TotalMemAllocated, 6144);
end;

function GetMem8k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock8k < Block8kCount then
    with Blocks8k^[FirstFreeBlock8k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) shl 13) + BaseAddr);
      if BitArray = $FFF then
        Inc(FirstFreeBlock8k);
    end
  else if FreeBlock8kExists then
  begin
    with Blocks8k^[Block8kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock8kExists := False;
    Inc(Block8kCount);
  end
  else if TakeNewBlock then
  begin
    if Block8kCount = Block8kCapacity then
    begin
      if Block8kCount = Block8kListCapacity then
        EnlargeList(@Blocks8k, Block8kListCapacity);
      Blocks8k^[Block8kCapacity] := NewMediumBlock;
      Inc(Block8kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks8k, Block8kCount, 18);
  end;
  Inc(TotalMemAllocated, 8192);
end;

function GetMem12k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock12k < Block12kCount then
    with Blocks12k^[FirstFreeBlock12k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) * 12288) + BaseAddr);
      if BitArray = $FF then
        Inc(FirstFreeBlock12k);
    end
  else if FreeBlock12kExists then
  begin
    with Blocks12k^[Block12kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock12kExists := False;
    Inc(Block12kCount);
  end
  else if TakeNewBlock then
  begin
    if Block12kCount = Block12kCapacity then
    begin
      if Block12kCount = Block12kListCapacity then
        EnlargeList(@Blocks12k, Block12kListCapacity);
      Blocks12k^[Block12kCapacity] := NewMediumBlock;
      Inc(Block12kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks12k, Block12kCount, 19);
  end;
  Inc(TotalMemAllocated, 12288);
end;

function GetMem16k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock16k < Block16kCount then
    with Blocks16k^[FirstFreeBlock16k]^ do
    begin
      Result := Pointer((ScanAndSetFreeBit(BitArray) shl 14) + BaseAddr);
      if BitArray = $3F then
        Inc(FirstFreeBlock16k);
    end
  else if FreeBlock16kExists then
  begin
    with Blocks16k^[Block16kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock16kExists := False;
    Inc(Block16kCount);
  end
  else if TakeNewBlock then
  begin
    if Block16kCount = Block16kCapacity then
    begin
      if Block16kCount = Block16kListCapacity then
        EnlargeList(@Blocks16k, Block16kListCapacity);
      Blocks16k^[Block16kCapacity] := NewMediumBlock;
      Inc(Block16kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks16k, Block16kCount, 20);
  end;
  Inc(TotalMemAllocated, 16384);
end;

function GetMem24k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock24k < Block24kCount then
    with Blocks24k^[FirstFreeBlock24k]^ do
    begin
      if BitArray and 3 <> 3 then
      begin
        if BitArray and 1 = 0 then
        begin
          BitArray := BitArray or 1;
          Result := Pointer(BaseAddr);
        end else
        begin
          BitArray := BitArray or 2;
          Result := Pointer(BaseAddr + 24576);
        end;
      end else
      begin
        if BitArray and 4 = 0 then
        begin
          BitArray := BitArray or 4;
          Result := Pointer(BaseAddr + 49152);
        end else
        begin
          BitArray := BitArray or 8;
          Result := Pointer(BaseAddr + 73728);
        end;
      end;
      if BitArray = $F then
        Inc(FirstFreeBlock24k);
    end
  else if FreeBlock24kExists then
  begin
    with Blocks24k^[Block24kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock24kExists := False;
    Inc(Block24kCount);
  end
  else if TakeNewBlock then
  begin
    if Block24kCount = Block24kCapacity then
    begin
      if Block24kCount = Block24kListCapacity then
        EnlargeList(@Blocks24k, Block24kListCapacity);
      Blocks24k^[Block24kCapacity] := NewMediumBlock;
      Inc(Block24kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks24k, Block24kCount, 21);
  end;
  Inc(TotalMemAllocated, 24576);
end;

function GetMem32k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock32k < Block32kCount then
    with Blocks32k^[FirstFreeBlock32k]^ do
    begin
      if BitArray and 1 = 0 then
      begin
        BitArray := BitArray or 1;
        Result := Pointer(BaseAddr);
      end
      else if BitArray and 2 = 0 then
      begin
        BitArray := BitArray or 2;
        Result := Pointer(BaseAddr + 32768);
      end else
      begin
        BitArray := BitArray or 4;
        Result := Pointer(BaseAddr + 65536);
      end;
      if BitArray = 7 then
        Inc(FirstFreeBlock32k);
    end
  else if FreeBlock32kExists then
  begin
    with Blocks32k^[Block32kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock32kExists := False;
    Inc(Block32kCount);
  end
  else if TakeNewBlock then
  begin
    if Block32kCount = Block32kCapacity then
    begin
      if Block32kCount = Block32kListCapacity then
        EnlargeList(@Blocks32k, Block32kListCapacity);
      Blocks32k^[Block32kCapacity] := NewMediumBlock;
      Inc(Block32kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks32k, Block32kCount, 22);
  end;
  Inc(TotalMemAllocated, 32768);
end;

function GetMem48k: Pointer;
begin
  Result := nil;
  if FirstFreeBlock48k < Block48kCount then
    with Blocks48k^[FirstFreeBlock48k]^ do
    begin
      if BitArray and 1 = 0 then
        Result := Pointer(BaseAddr)
      else
        Result := Pointer(BaseAddr + 49152);
      Inc(FirstFreeBlock48k);
      BitArray := 3;
    end
  else if FreeBlock48kExists then
  begin
    with Blocks48k^[Block48kCount]^ do
    begin
      BitArray := 1;
      Result := Pointer(BaseAddr);
    end;
    FreeBlock48kExists := False;
    Inc(Block48kCount);
  end
  else if TakeNewBlock then
  begin
    if Block48kCount = Block48kCapacity then
    begin
      if Block48kCount = Block48kListCapacity then
        EnlargeList(@Blocks48k, Block48kListCapacity);
      Blocks48k^[Block48kCapacity] := NewMediumBlock;
      Inc(Block48kCapacity);
    end;
    Result := UpdateMediumBlockInfo(Blocks48k, Block48kCount, 23);
  end;
  Inc(TotalMemAllocated, 49152);
end;

type
  TGetMemHandler = function: Pointer;

const
  GetMemHandlers: array[0..23] of TGetMemHandler =
    (GetMem16, GetMem24, GetMem32, GetMem48, GetMem64, GetMem96, GetMem128,
     GetMem192, GetMem256, GetMem384, GetMem512, GetMem768, GetMem1024,
     GetMem1536, GetMem2k, GetMem3k, GetMem4k, GetMem6k, GetMem8k, GetMem12k,
     GetMem16k, GetMem24k, GetMem32k, GetMem48k);

function GetBigBlock(Size: Integer): Pointer;
var
  N: Integer;
begin
  N := BigBlockCount;
  if N = BigBlockCapacity then
    EnlargeList(@BigBlockAddrs, BigBlockCapacity);
  Result := VirtualAlloc(nil, Size + 8, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);
  if Result <> nil then
  begin
    BigBlockAddrs^[N] := LongWord(Result);
    PInteger(Result)^ := N;
    Inc(LongWord(Result), 4);
    PInteger(Result)^ := Size;
    Inc(LongWord(Result), 4);
    Inc(N);
    Inc(TotalMemAllocated, Size);
    BigBlockCount := N;
  end;
end;

function GetSizeIndex(Size: Integer): Integer;
begin
  if Size <= 192 then
  begin
    if Size <= 48 then
    begin
      if Size <= 24 then
      begin
        if Size <= 16 then
        begin
          Result := 0;
          Exit;
        end;
        Result := 1;
        Exit;
      end;
      if Size <= 32 then
      begin
        Result := 2;
        Exit;
      end;
      Result := 3;
      Exit;
    end;
    if Size <= 96 then
    begin
      if Size <= 64 then
      begin
        Result := 4;
        Exit;
      end;
      Result := 5;
      Exit;
    end;
    if Size <= 128 then
    begin
      Result := 6;
      Exit;
    end;
    Result := 7;
    Exit;
  end;
  if Size <= 3072 then
  begin
    if Size <= 768 then
    begin
      if Size <= 384 then
      begin
        if Size <= 256 then
        begin
          Result := 8;
          Exit;
        end;
        Result := 9;
        Exit;
      end;
      if Size <= 512 then
      begin
        Result := 10;
        Exit;
      end;
      Result := 11;
      Exit;
    end;
    if Size <= 1536 then
    begin
      if Size <= 1024 then
      begin
        Result := 12;
        Exit;
      end;
      Result := 13;
      Exit;
    end;
    if Size <= 2048 then
    begin
      Result := 14;
      Exit;
    end;
    Result := 15;
    Exit;
  end;
  if Size <= 12288 then
  begin
    if Size <= 6144 then
    begin
      if Size <= 4096 then
      begin
        Result := 16;
        Exit;
      end;
      Result := 17;
      Exit;
    end;
    if Size <= 8192 then
    begin
      Result := 18;
      Exit;
    end;
    Result := 19;
    Exit;
  end;
  if Size <= 24576 then
  begin
    if Size <= 16384 then
    begin
      Result := 20;
      Exit;
    end;
    Result := 21;
    Exit;
  end;
  if Size <= 32768 then
  begin
    Result := 22;
    Exit;
  end;
  if Size <= 49152 then
  begin
    Result := 23;
    Exit;
  end;
  Result := ((Size + $1007) and $7FFFF000) - 8;
end;

function G_GetMem(Size: Integer): Pointer;
begin
  if not IsMultiThread then
  begin
    Size := GetSizeIndex(Size);
    if Size < 24 then
      Result := GetMemHandlers[Size]
    else
      Result := GetBigBlock(Size);
  end else
  begin
    EnterCriticalSection(CriticalSection);
    try
      Size := GetSizeIndex(Size);
      if Size < 24 then
        Result := GetMemHandlers[Size]
      else
        Result := GetBigBlock(Size);
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

procedure RaiseFreeUnusedBlockError;
begin
  raise Exception.Create(SErrFreeUnusedBlock);
end;

procedure ExchangeBlocks(Blocks: Pointer; Index1, Index2: Integer);
var
  T: Pointer;
begin
  T := PBlock2kList(Blocks)^[Index1];
  PBlock2kList(Blocks)^[Index1] := PBlock2kList(Blocks)^[Index2];
  PBlock2kList(Blocks)^[Index2] := T;
  with PBlock2kList(Blocks)^[Index1]^ do
    Region^.BlockIndexList[RegionItemIndex] := Index1;
  with PBlock2kList(Blocks)^[Index2]^ do
    Region^.BlockIndexList[RegionItemIndex] := Index2;
end;

procedure DeleteRegion(R: PRegion);
var
  RL: PRegionList;
  L, H, I: Integer;
  P: LongWord;
begin
  RL := Regions;
  H := RegionCount;
  if FreeRegionExists then
    VirtualFree(Pointer(RL^[H]^.BaseAddr), 0, MEM_RELEASE)
  else
    FreeRegionExists := True;
  Dec(H);
  RegionCount := H;
  if RL^[H] <> R then
  begin
    L := 0;
    P := R^.BaseAddr;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if RL^[I].BaseAddr < P then
        L := I + 1
      else
        H := I - 1;
    end;
    H := RegionCount;
    G_MoveLongs(@RL^[L + 1], @RL^[L], H - L);
    RL^[H] := R;
  end;
end;

procedure ReleaseBlock(Block: Pointer);
begin
  with PBlock2k(Block)^.Region^ do
  begin
    BlockMask := BlockMask and not BitMasks32[PBlock2k(Block)^.RegionItemIndex];
    if BlockMask = 0 then
      DeleteRegion(PBlock2k(Block)^.Region);
  end;
end;

procedure FreeMem16(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 16);
  Offset := Offset shr 4;
  with Blocks16^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 6144 then
    begin
      if BlockIndex < FirstFreeBlock16 then
      begin
        N := FirstFreeBlock16 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks16, BlockIndex, N);
        FirstFreeBlock16 := N;
      end;
      Exit;
    end;
  end;
  N := Block16Count;
  if FreeBlock16Exists then
    ReleaseBlock(Blocks16^[N])
  else
    FreeBlock16Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks16, BlockIndex, N);
  Block16Count := N;
end;

procedure FreeMem24(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 24);
  Offset := Offset div 24;
  with Blocks24^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 4096 then
    begin
      if BlockIndex < FirstFreeBlock24 then
      begin
        N := FirstFreeBlock24 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks24, BlockIndex, N);
        FirstFreeBlock24 := N;
      end;
      Exit;
    end;
  end;
  N := Block24Count;
  if FreeBlock24Exists then
    ReleaseBlock(Blocks24^[N])
  else
    FreeBlock24Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks24, BlockIndex, N);
  Block24Count := N;
end;

procedure FreeMem32(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 32);
  Offset := Offset shr 5;
  with Blocks32^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 3072 then
    begin
      if BlockIndex < FirstFreeBlock32 then
      begin
        N := FirstFreeBlock32 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks32, BlockIndex, N);
        FirstFreeBlock32 := N;
      end;
      Exit;
    end;
  end;
  N := Block32Count;
  if FreeBlock32Exists then
    ReleaseBlock(Blocks32^[N])
  else
    FreeBlock32Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks32, BlockIndex, N);
  Block32Count := N;
end;

procedure FreeMem48(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 48);
  Offset := Offset div 48;
  with Blocks48^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 2048 then
    begin
      if BlockIndex < FirstFreeBlock48 then
      begin
        N := FirstFreeBlock48 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks48, BlockIndex, N);
        FirstFreeBlock48 := N;
      end;
      Exit;
    end;
  end;
  N := Block48Count;
  if FreeBlock48Exists then
    ReleaseBlock(Blocks48^[N])
  else
    FreeBlock48Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks48, BlockIndex, N);
  Block48Count := N;
end;

procedure FreeMem64(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 64);
  Offset := Offset shr 6;
  with Blocks64^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 1536 then
    begin
      if BlockIndex < FirstFreeBlock64 then
      begin
        N := FirstFreeBlock64 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks64, BlockIndex, N);
        FirstFreeBlock64 := N;
      end;
      Exit;
    end;
  end;
  N := Block64Count;
  if FreeBlock64Exists then
    ReleaseBlock(Blocks64^[N])
  else
    FreeBlock64Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks64, BlockIndex, N);
  Block64Count := N;
end;

procedure FreeMem96(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 96);
  Offset := Offset div 96;
  with Blocks96^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 1024 then
    begin
      if BlockIndex < FirstFreeBlock96 then
      begin
        N := FirstFreeBlock96 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks96, BlockIndex, N);
        FirstFreeBlock96 := N;
      end;
      Exit;
    end;
  end;
  N := Block96Count;
  if FreeBlock96Exists then
    ReleaseBlock(Blocks96^[N])
  else
    FreeBlock96Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks96, BlockIndex, N);
  Block96Count := N;
end;

procedure FreeMem128(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 128);
  Offset := Offset shr 7;
  with Blocks128^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 768 then
    begin
      if BlockIndex < FirstFreeBlock128 then
      begin
        N := FirstFreeBlock128 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks128, BlockIndex, N);
        FirstFreeBlock128 := N;
      end;
      Exit;
    end;
  end;
  N := Block128Count;
  if FreeBlock128Exists then
    ReleaseBlock(Blocks128^[N])
  else
    FreeBlock128Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks128, BlockIndex, N);
  Block128Count := N;
end;

procedure FreeMem192(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 192);
  Offset := Offset div 192;
  with Blocks192^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 512 then
    begin
      if BlockIndex < FirstFreeBlock192 then
      begin
        N := FirstFreeBlock192 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks192, BlockIndex, N);
        FirstFreeBlock192 := N;
      end;
      Exit;
    end;
  end;
  N := Block192Count;
  if FreeBlock192Exists then
    ReleaseBlock(Blocks192^[N])
  else
    FreeBlock192Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks192, BlockIndex, N);
  Block192Count := N;
end;

procedure FreeMem256(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 256);
  Offset := Offset shr 8;
  with Blocks256^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 384 then
    begin
      if BlockIndex < FirstFreeBlock256 then
      begin
        N := FirstFreeBlock256 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks256, BlockIndex, N);
        FirstFreeBlock256 := N;
      end;
      Exit;
    end;
  end;
  N := Block256Count;
  if FreeBlock256Exists then
    ReleaseBlock(Blocks256^[N])
  else
    FreeBlock256Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks256, BlockIndex, N);
  Block256Count := N;
end;

procedure FreeMem384(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 384);
  Offset := Offset div 384;
  with Blocks384^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 256 then
    begin
      if BlockIndex < FirstFreeBlock384 then
      begin
        N := FirstFreeBlock384 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks384, BlockIndex, N);
        FirstFreeBlock384 := N;
      end;
      Exit;
    end;
  end;
  N := Block384Count;
  if FreeBlock384Exists then
    ReleaseBlock(Blocks384^[N])
  else
    FreeBlock384Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks384, BlockIndex, N);
  Block384Count := N;
end;

procedure FreeMem512(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 512);
  Offset := Offset shr 9;
  with Blocks512^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 192 then
    begin
      if BlockIndex < FirstFreeBlock512 then
      begin
        N := FirstFreeBlock512 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks512, BlockIndex, N);
        FirstFreeBlock512 := N;
      end;
      Exit;
    end;
  end;
  N := Block512Count;
  if FreeBlock512Exists then
    ReleaseBlock(Blocks512^[N])
  else
    FreeBlock512Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks512, BlockIndex, N);
  Block512Count := N;
end;

procedure FreeMem768(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 768);
  Offset := Offset div 768;
  with Blocks768^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 128 then
    begin
      if BlockIndex < FirstFreeBlock768 then
      begin
        N := FirstFreeBlock768 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks768, BlockIndex, N);
        FirstFreeBlock768 := N;
      end;
      Exit;
    end;
  end;
  N := Block768Count;
  if FreeBlock768Exists then
    ReleaseBlock(Blocks768^[N])
  else
    FreeBlock768Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks768, BlockIndex, N);
  Block768Count := N;
end;

procedure FreeMem1024(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 1024);
  Offset := Offset shr 10;
  with Blocks1024^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 96 then
    begin
      if BlockIndex < FirstFreeBlock1024 then
      begin
        N := FirstFreeBlock1024 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks1024, BlockIndex, N);
        FirstFreeBlock1024 := N;
      end;
      Exit;
    end;
  end;
  N := Block1024Count;
  if FreeBlock1024Exists then
    ReleaseBlock(Blocks1024^[N])
  else
    FreeBlock1024Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks1024, BlockIndex, N);
  Block1024Count := N;
end;

procedure FreeMem1536(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 1536);
  Offset := Offset div 1536;
  with Blocks1536^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 64 then
    begin
      if BlockIndex < FirstFreeBlock1536 then
      begin
        N := FirstFreeBlock1536 - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks1536, BlockIndex, N);
        FirstFreeBlock1536 := N;
      end;
      Exit;
    end;
  end;
  N := Block1536Count;
  if FreeBlock1536Exists then
    ReleaseBlock(Blocks1536^[N])
  else
    FreeBlock1536Exists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks1536, BlockIndex, N);
  Block1536Count := N;
end;

procedure FreeMem2k(BlockIndex: Integer; Offset: LongWord);
var
  N: Integer;
begin
  Dec(TotalMemAllocated, 2048);
  Offset := Offset shr 11;
  with Blocks2k^[BlockIndex]^ do
  begin
    if not G_BitReset(@BitArray, Offset) then
      RaiseFreeUnusedBlockError;
    N := Offset shr 5;
    if LongWord(N) < LongWord(FirstFree) then
      FirstFree := N;
    Inc(FreeCount);
    if FreeCount < 48 then
    begin
      if BlockIndex < FirstFreeBlock2k then
      begin
        N := FirstFreeBlock2k - 1;
        if BlockIndex < N then
          ExchangeBlocks(Blocks2k, BlockIndex, N);
        FirstFreeBlock2k := N;
      end;
      Exit;
    end;
  end;
  N := Block2kCount;
  if FreeBlock2kExists then
    ReleaseBlock(Blocks2k^[N])
  else
    FreeBlock2kExists := True;
  Dec(N);
  if BlockIndex < N then
    ExchangeBlocks(Blocks2k, BlockIndex, N);
  Block2kCount := N;
end;

procedure FreeMem3k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 3072);
  with Blocks3k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset div 3072]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock3k then
      begin
        N := FirstFreeBlock3k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks3k, BlockIndex, N);
        FirstFreeBlock3k := N;
      end;
      Exit;
    end;
  end;
  N := Block3kCount;
  if FreeBlock3kExists then
    ReleaseBlock(Blocks3k^[N])
  else
    FreeBlock3kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks3k, BlockIndex, N);
  Block3kCount := N;
end;

procedure FreeMem4k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 4096);
  with Blocks4k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset shr 12]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock4k then
      begin
        N := FirstFreeBlock4k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks4k, BlockIndex, N);
        FirstFreeBlock4k := N;
      end;
      Exit;
    end;
  end;
  N := Block4kCount;
  if FreeBlock4kExists then
    ReleaseBlock(Blocks4k^[N])
  else
    FreeBlock4kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks4k, BlockIndex, N);
  Block4kCount := N;
end;

procedure FreeMem6k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 6144);
  with Blocks6k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset div 6144]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock6k then
      begin
        N := FirstFreeBlock6k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks6k, BlockIndex, N);
        FirstFreeBlock6k := N;
      end;
      Exit;
    end;
  end;
  N := Block6kCount;
  if FreeBlock6kExists then
    ReleaseBlock(Blocks6k^[N])
  else
    FreeBlock6kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks6k, BlockIndex, N);
  Block6kCount := N;
end;

procedure FreeMem8k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 8192);
  with Blocks8k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset shr 13]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock8k then
      begin
        N := FirstFreeBlock8k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks8k, BlockIndex, N);
        FirstFreeBlock8k := N;
      end;
      Exit;
    end;
  end;
  N := Block8kCount;
  if FreeBlock8kExists then
    ReleaseBlock(Blocks8k^[N])
  else
    FreeBlock8kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks8k, BlockIndex, N);
  Block8kCount := N;
end;

procedure FreeMem12k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 12288);
  with Blocks12k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset div 12288]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock12k then
      begin
        N := FirstFreeBlock12k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks12k, BlockIndex, N);
        FirstFreeBlock12k := N;
      end;
      Exit;
    end;
  end;
  N := Block12kCount;
  if FreeBlock12kExists then
    ReleaseBlock(Blocks12k^[N])
  else
    FreeBlock12kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks12k, BlockIndex, N);
  Block12kCount := N;
end;

procedure FreeMem16k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 16384);
  with Blocks16k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset shr 14]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock16k then
      begin
        N := FirstFreeBlock16k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks16k, BlockIndex, N);
        FirstFreeBlock16k := N;
      end;
      Exit;
    end;
  end;
  N := Block16kCount;
  if FreeBlock16kExists then
    ReleaseBlock(Blocks16k^[N])
  else
    FreeBlock16kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks16k, BlockIndex, N);
  Block16kCount := N;
end;

procedure FreeMem24k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 24576);
  with Blocks24k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset div 24576]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock24k then
      begin
        N := FirstFreeBlock24k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks24k, BlockIndex, N);
        FirstFreeBlock24k := N;
      end;
      Exit;
    end;
  end;
  N := Block24kCount;
  if FreeBlock24kExists then
    ReleaseBlock(Blocks24k^[N])
  else
    FreeBlock24kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks24k, BlockIndex, N);
  Block24kCount := N;
end;

procedure FreeMem32k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 32768);
  with Blocks32k^[BlockIndex]^ do
  begin
    N := BitArray;
    BitArray := (not BitMasks32[Offset shr 15]) and N;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock32k then
      begin
        N := FirstFreeBlock32k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks32k, BlockIndex, N);
        FirstFreeBlock32k := N;
      end;
      Exit;
    end;
  end;
  N := Block32kCount;
  if FreeBlock32kExists then
    ReleaseBlock(Blocks32k^[N])
  else
    FreeBlock32kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks32k, BlockIndex, N);
  Block32kCount := N;
end;

procedure FreeMem48k(BlockIndex: Integer; Offset: LongWord);
var
  N: LongWord;
begin
  Dec(TotalMemAllocated, 49152);
  with Blocks48k^[BlockIndex]^ do
  begin
    N := BitArray;
    if Offset < 49152 then
      BitArray := N and 2
    else
      BitArray := N and 1;
    if N = BitArray then
      RaiseFreeUnusedBlockError;
    if BitArray <> 0 then
    begin
      if BlockIndex < FirstFreeBlock48k then
      begin
        N := FirstFreeBlock48k - 1;
        if BlockIndex < Integer(N) then
          ExchangeBlocks(Blocks48k, BlockIndex, N);
        FirstFreeBlock48k := N;
      end;
      Exit;
    end;
  end;
  N := Block48kCount;
  if FreeBlock48kExists then
    ReleaseBlock(Blocks48k^[N])
  else
    FreeBlock48kExists := True;
  Dec(N);
  if BlockIndex < Integer(N) then
    ExchangeBlocks(Blocks48k, BlockIndex, N);
  Block48kCount := N;
end;

type
  TFreeMemHandler = procedure(BlockIndex: Integer; Offset: LongWord);

const
  FreeMemHandlers: array[0..23] of TFreeMemHandler =
    (FreeMem16, FreeMem24, FreeMem32, FreeMem48, FreeMem64, FreeMem96,
     FreeMem128, FreeMem192, FreeMem256, FreeMem384, FreeMem512,
     FreeMem768, FreeMem1024, FreeMem1536, FreeMem2k, FreeMem3k,
     FreeMem4k, FreeMem6k, FreeMem8k, FreeMem12k, FreeMem16k,
     FreeMem24k, FreeMem32k, FreeMem48k);

function FreeBigBlock(L: LongWord): Boolean;
var
  I: LongWord;
begin
  Dec(L, 8);
  I := PLongWord(L)^;
  if (I >= LongWord(BigBlockCount)) or (BigBlockAddrs^[I] <> L) then
    Result := False
  else
  begin
    Inc(L, 4);
    Dec(TotalMemAllocated, PInteger(L)^);
    VirtualFree(Pointer(BigBlockAddrs^[I]), 0, MEM_RELEASE);
    Dec(BigBlockCount);
    if Integer(I) < BigBlockCount then
    begin
      L := BigBlockAddrs^[BigBlockCount];
      BigBlockAddrs^[I] := L;
      PLongWord(L)^ := I;
    end;
    Result := True;
  end;
end;

function IntFreeMem(L: LongWord): Integer;
var
  M, N, I: Integer;
  K: LongWord;
  RL: PRegionList;
begin
  RL := Regions;
  M := 0;
  N := RegionCount - 1;
  repeat
    if M > N then
    begin
      if not FreeBigBlock(L) then
        Result := OldMemoryManager.FreeMem(Pointer(L))
      else
        Result := 0;
      Exit;
    end;
    I := (M + N) shr 1;
    K := RL^[I]^.BaseAddr;
    if L < K then
      N := I - 1
    else if L >= K + $300000 then
      M := I + 1
    else
      Break;
  until False;
  Dec(L, K);
  K := L div 98304;
  with RL^[I]^ do
  begin
    if BlockMask and BitMasks32[K] = 0 then
      RaiseFreeUnusedBlockError;
    FreeMemHandlers[BlockSizeList[K]](BlockIndexList[K], L - (K * 98304));
  end;
  Result := 0;
end;

function G_FreeMem(P: Pointer): Integer;
begin
  if not IsMultiThread then
    Result := IntFreeMem(LongWord(P))
  else
  begin
    EnterCriticalSection(CriticalSection);
    try
      Result := IntFreeMem(LongWord(P));
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

function G_ReallocMem(P: Pointer; Size: Integer): Pointer;
var
  L: Integer;
begin
  L := G_GetMemSize(P);
  if L = 0 then
  begin
    Result := OldMemoryManager.ReallocMem(P, Size);
    Exit;
  end;
  Size := GetSizeIndex(Size);
  if Size < 24 then
    Size := StdBlockSize[Size];
  if Size = L then
    Result := P
  else
  begin
    Result := G_GetMem(Size);
    if L < Size then
      Size := L;
    G_CopyLongs(P, Result, Size shr 2);
    G_FreeMem(P);
  end;
end;

function IntGetMemSize(L: LongWord): Integer;
var
  M, N, I: Integer;
  K: LongWord;
  RL: PRegionList;
begin
  RL := Regions;
  M := 0;
  N := RegionCount - 1;
  repeat
    if M > N then
    begin
      Dec(L, 8);
      K := PLongWord(L)^;
      if (K < LongWord(BigBlockCount)) and (BigBlockAddrs^[K] = L) then
      begin
        Inc(L, 4);
        Result := PInteger(L)^;
      end else
        Result := 0;
      Exit;
    end;
    I := (M + N) shr 1;
    K := RL^[I]^.BaseAddr;
    if L < K then
      N := I - 1
    else if L >= K + $300000 then
      M := I + 1
    else
      Break;
  until False;
  L := (L - K) div 98304;
  with RL^[I]^ do
    if BlockMask and BitMasks32[L] <> 0 then
      Result := StdBlockSize[BlockSizeList[L]]
    else
      Result := 0;
end;

function G_GetMemSize(P: Pointer): Integer;
begin
  if P = nil then
    Result := 0
  else if not IsMultiThread then
    Result := IntGetMemSize(LongWord(P))
  else
  begin
    EnterCriticalSection(CriticalSection);
    try
      Result := IntGetMemSize(LongWord(P));
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

function G_GetTotalMemAllocated: LongWord;
begin
  Result := TotalMemAllocated;
end;

function G_GetTotalMemCommitted: LongWord;
var
  I: Integer;
begin
  if IsMultiThread then
    EnterCriticalSection(CriticalSection);
  try
    Result := RegionCount;
    if FreeRegionExists then
      Inc(Result);
    Result := Result * $300000;
    for I := BigBlockCount - 1 downto 0 do
      Inc(Result, PLongWord(BigBlockAddrs^[I] + 4)^ + 8);
  finally
    if IsMultiThread then
      LeaveCriticalSection(CriticalSection);
  end;
end;

const
  G_Manager: TMemoryManager = (GetMem: G_GetMem; FreeMem: G_FreeMem; ReallocMem: G_ReallocMem);

procedure CreateList(ListAddr: PPointer; var ListCapacity: Integer);
var
  N: Integer;
begin
  N := CountDelta * 2;
  ListAddr^ := HeapAlloc(Heap, 0, N * SizeOf(LongWord));
  ListCapacity := N;
end;

procedure InitHeap;
begin
  if ManagerInstalled then
    Exit;
  Heap := HeapCreate(winHEAP_NO_SERIALIZE or winHEAP_GENERATE_EXCEPTIONS, $20000, $800000);
  CreateList(@BigBlockAddrs, BigBlockCapacity);
  CreateList(@Regions, RegionListCapacity);
  UpdateCapacity(@Regions, RegionCapacity, SizeOf(TRegion));
  with Regions^[0]^ do
  begin
    BaseAddr := LongWord(VirtualAlloc(nil, $300000,
      MEM_RESERVE or MEM_COMMIT or MEM_TOP_DOWN, PAGE_READWRITE));
    BlockMask := 0;
  end;
  RegionCount := 1;
  CreateList(@Blocks16, Block16ListCapacity);
  CreateList(@Blocks24, Block24ListCapacity);
  CreateList(@Blocks32, Block32ListCapacity);
  CreateList(@Blocks48, Block48ListCapacity);
  CreateList(@Blocks64, Block64ListCapacity);
  CreateList(@Blocks96, Block96ListCapacity);
  CreateList(@Blocks128, Block128ListCapacity);
  CreateList(@Blocks192, Block192ListCapacity);
  CreateList(@Blocks256, Block256ListCapacity);
  CreateList(@Blocks384, Block384ListCapacity);
  CreateList(@Blocks512, Block512ListCapacity);
  CreateList(@Blocks768, Block768ListCapacity);
  CreateList(@Blocks1024, Block1024ListCapacity);
  CreateList(@Blocks1536, Block1536ListCapacity);
  CreateList(@Blocks2k, Block2kListCapacity);
  CreateList(@Blocks3k, Block3kListCapacity);
  CreateList(@Blocks4k, Block4kListCapacity);
  CreateList(@Blocks6k, Block6kListCapacity);
  CreateList(@Blocks8k, Block8kListCapacity);
  CreateList(@Blocks12k, Block12kListCapacity);
  CreateList(@Blocks16k, Block16kListCapacity);
  CreateList(@Blocks24k, Block24kListCapacity);
  CreateList(@Blocks32k, Block32kListCapacity);
  CreateList(@Blocks48k, Block48kListCapacity);
  InitializeCriticalSection(CriticalSection);
  GetMemoryManager(OldMemoryManager);
  ManagerInstalled := True;
  SetMemoryManager(G_Manager);
end;

procedure DoneHeap;
var
  I: Integer;
begin
  if ManagerInstalled then
  begin
    SetMemoryManager(OldMemoryManager);
    ManagerInstalled := False;
    DeleteCriticalSection(CriticalSection);
    for I := BigBlockCount - 1 downto 0 do
      VirtualFree(Pointer(BigBlockAddrs^[I]), 0, MEM_RELEASE);
    if FreeRegionExists then
      VirtualFree(Pointer(Regions^[RegionCount]^.BaseAddr), 0, MEM_RELEASE);
    for I := RegionCount - 1 downto 0 do
      VirtualFree(Pointer(Regions^[I]^.BaseAddr), 0, MEM_RELEASE);
    HeapDestroy(Heap);
  end;
end;

initialization
  InitHeap;

finalization
  if not IsMultiThread then
    DoneHeap;

end.

