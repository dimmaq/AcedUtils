
/////////////////////////////////////////////////////////
//                                                     //
//   AcedStorage 1.16                                  //
//                                                     //
//   ������ ��� ������ � ��������� ���������� ������   //
//   � ������ ���������������������� �������.          //
//                                                     //
//   mailto: acedutils@yandex.ru                       //
//                                                     //
/////////////////////////////////////////////////////////

unit AcedStorage;

{$B-,H+,R-,Q-,T-,X+}

interface

uses Windows, Classes, Forms, SysUtils, AcedConsts, AcedStreams, AcedCrypto,
  AcedCompression;

{ ���� ������, ������������, ��������� ������� }

type
  TSerializableObject = class;
  TSerializableCollection = class;
  TDataIndex = class;

{ ��� ������ �� �����, ����������� �� TSerializableObject. ������������
  ��� ��������� ItemClassType, ������������� � ����������� ������
  TSerializableCollection, � ������������ �������� ���� ���������, �����
  ���������� ��� ��������, ���������� � ���������. }

  TSerializableObjectClassType = class of TSerializableObject;

{ ��� ������� � ��������� �� ������ ��������� ���� TSerializableObject. }

  PSerializableObjectList = ^TSerializableObjectList;
  TSerializableObjectList = array[0..DWordListUpperLimit] of TSerializableObject;

{ ��� ������� � ������ �� ������ ��������� ���� TDataIndex. }

  PDataIndexList = ^TDataIndexList;
  TDataIndexList = array[0..DWordListUpperLimit] of TDataIndex;

{ ���-������������, ������������ ��� ������������� �������� ������ ApplyChanges
  ��������� TSerializableCollection. ��� �������� ������������� ����������
  ���������� ��������� � ������ ������. ����� ������� �� ���������:

  appChangesOk - ��� ������������ ��������� ������� ��������� � ������ ������;
  appChangesOriginalObjectChanged - ���������� ��������� ���������, �.�. ������
     � ������ ������ ���������� �� �������������� ������ ����������� �������.
     ��� ��������, ��� � ������� ����������� ������ ������ ������ ��� �������
     ������ �������������;
  appChangesUniqueIndexViolation - ������ ��� ���������� ��������� � ������
    ������, ��������� ���������� ������������ ������ �� ��������. }

  TAppChangesResult =
  (
    appChangesOk,
    appChangesOriginalObjectChanged,
    appChangesUniqueIndexViolation
  );

{ �������� �������, ������������ �������� OnItemIDChanged ������
  TSerializableCollection. ��� ������� ���������� ��� ������������� ����������
  ������ ������� � ���������, ����� �������� ���������� ����� �������
  (�������� ID) �������� � ���������� �� ����������. � ��������� SC ����������
  ������ �� ��������� - �������� ������� �������, � SO - ������ �� ������ ����
  TSerializableObject, ��� �������� ��������� ��������� ����. ������, �.�
  ���������, �������� ���������� ����� ���������� ���������� TempID. }

  TItemIDChangedEvent = procedure(SC: TSerializableCollection;
    SO: TSerializableObject; TempID: Integer);

{ �������� �������, ������������ �������� OnItemInserted ������
  TSerializableCollection. ������� ���������� ��� ���������� � ���������
  ������ ��������. � ��������� SC ���������� ������ �� ��������� - ��������
  ������� �������, � ��������� NewItem - ������ �� ��������� ������
  TSerializableObject, ������� �������� � ���������. }

  TItemInsertedEvent = procedure(SC: TSerializableCollection;
    NewItem: TSerializableObject);

{ �������� �������, ������������ �������� OnItemChanged ������
  TSerializableCollection. ������� ���������� ��� ��������� �������� ���������.
  � ��������� SC ���������� ������ �� ��������� - �������� ������� �������,
  � ��������� NewItem - ������ �� ����� ��������� ������ TSerializableObject
  (���������� ������), � ��������� OldItem - ������ �� �������� ���������
  ������� ������ (������ �� �������� ���������). }

  TItemChangedEvent = procedure(SC: TSerializableCollection;
    NewItem, OldItem: TSerializableObject);

{ �������� �������, ������������ �������� OnItemDeleted ������
  TSerializableCollection. ������� ���������� ��� �������� �������� ��
  ���������. � ��������� SC ���������� ������ �� ��������� - �������� �������
  �������, � ��������� OldItem - ������ �� ��������� ������, �.�. ���������
  ������ TSerializableObject. }

  TItemDeletedEvent = procedure(SC: TSerializableCollection;
    OldItem: TSerializableObject);


{ ����� TSerializableObject - ����������� ������� ����� ��� ��������,
  ����������� � ��������� TSerializableCollection. � ����������� �� ����
  ������� �� ����� �������� ��� protected-���� FID, ������������ � ������
  TSerializableObject, ������� ������ ����������� ������� Load, �����������
  ������� Save, ����������� ������� Equals � ������������� ������� Clone. }

  TSerializableObject = class(TObject)
  protected

  { FID - ������������� �������, ���������� � �������� ���������. ������������
    ��� ��������� ���� � ������� ������. ��� �������� � ���������� �������
    � ��������� �������� ����� �������� ���������� �������������. ��� �� ������
    �������� � ���������� ���������. ��� ������ ��� ������������ ������� ���
    ���� �������� ��������� ��������, ������� ���������� ��� �������������
    ��������� ������� ApplyChanges ��� ��� ������ ������ EndEditDirect
    ��������� TSerializableCollection, ���������� ������ ������. ��� ����
    ������������ ������� OnItemIDChanged ���������. }

    FID: Integer;
    
  public

  { ����������� Create c������ ��������� ������ TSerializableObject. }

    constructor Create; virtual;

  { �������� ID ������ ��� ������������� �������� ���� FID, �����������
    ��������� ����, �.�. �����, ���������� ������� ���������������� ������
    ������ � �������� ���������. }

    property ID: Integer read FID write FID;

  { ������ }

  { ����� Load ��������������� ��������� ������� �� ��������� ������,
    ����������� ���������� Reader. ������ ������������ ������� ��������
    ���������� Version. ������ ������ ������ ����� ��������������� ����
    ��������� �� ����� ����������� ������ �� ����� ���������, ������������.
    � ������, ���� ������ �� ������������ ������ Version, �� ������� ������
    ���������� ������� ������� RaiseVersionNotSupported(Self, Version),
    ������������ � ������ AcedConsts, ��� ��������� ����������. }

    procedure Load(Reader: TBinaryReader; Version: Integer); virtual; abstract;

  { ����� Save ��������� ��������� ������� � �������� ������, ����������
    ���������� Writer. ��������������, ��� ����������� ������ ������� ������
    ��������������� �������� ��������� Version, ����������� � �����������
    ���������, ���������� ������ ������. }

    procedure Save(Writer: TBinaryWriter); virtual; abstract;

  { ������� Equals ���������� True, ���� �������� ���� ����� �������
    �������, ������� ����, �������������� �� �������-�������, ����� ���������
    ��������������� ����� �������, ����������� ���������� SO. ���� �����
    �������� SO � ������ �������� ���� �����-���� ��������, ������� ������
    ������� False. }

    function Equals(SO: TSerializableObject): Boolean; virtual; abstract;

  { ������� Clone ���������� ������ ����� ������� �������, ������� �����
    �����, �������������� �� �������-�������. }

    function Clone: TSerializableObject; virtual; abstract;
  end;

  
{ ����� TSerializableCollection ������������ ����� ����������� ���������
  ��������, ����������� ������� ���� ������. }

  TSerializableCollection = class(TObject)
  private
    FCapacity: Integer;
    FItems: PSerializableObjectList;
    FCount: Integer;
    FHashCapacity: Integer;
    FHash: PSerializableObjectList;
    FHashUsedCount: Integer;
    FHashMaxCount: Integer;
    FIndices: PDataIndexList;
    FIndexCount: Integer;
    FLastAddedTempID: Integer;
    FOnItemIDChanged: TItemIDChangedEvent;
    FMaxAddedID: Integer;
    FOnItemInserted: TItemInsertedEvent;
    FOnItemChanged: TItemChangedEvent;
    FOnItemDeleted: TItemDeletedEvent;
    FInsertedCapacity: Integer;
    FInsertedItems: PSerializableObjectList;
    FInsertedCount: Integer;
    FDeletedCapacity: Integer;
    FDeletedItems: PSerializableObjectList;
    FDeletedCount: Integer;
    FItemClassType: TSerializableObjectClassType;
    FVersion: Integer;
    FFileVersion: LongWord;
    FFileSize: LongWord;
    FHandle: THandle;
    FEncryptionKey: PSHA256Digest;
    FCompressionMode: TCompressionMode;
    FChanged: Boolean;
    procedure SetCapacity(NewCapacity: Integer);
    procedure GrowInsertedCapacity();
    procedure GrowDeletedCapacity();
    function InternalApplyChanges(ToIns, ToDel: TSerializableObject):
      TAppChangesResult;
    procedure SetHashCapacity(NewHashCapacity: Integer);
    procedure PutInHash(SO: TSerializableObject);
    function GetMaintainHash: Boolean;
    procedure SetMaintainHash(V: Boolean);

  protected

  { ������� GenerateID ���������� ���������� �������� ��������������
    ��� ������ ��������, ������� �������������� �������� � ���������. ����
    ������������� ������������ ����� ������������� ����� ����� � ���������
    �� 1 �� 2147483647. ��������, ������������ �������� GenerateID
    ������������� �������� ��������������� �������������. � �������-��������
    ���� ����� ����� ���������������� � ����� ����������� ���������
    ������������ ��������. }

    function GenerateID: Integer; virtual;

  { ����� LoadExtra ��������� �������������� ���������� �� ��������� ������
    Reader. �������� Version ���������� ����������� ������ �������� ���������.
    � ������ TSerializableCollection ������ ����� ��������� �� ���������
    ������ �������� �������� MaxAddedID. }

    procedure LoadExtra(Reader: TBinaryReader; Version: Integer); virtual;

  { ����� SaveExtra ��������� �������������� ���������� � ��������� � ��������
    ������ Writer. � ������ TSerializableCollection ������ ����� ��������
    � �������� ����� �������� �������� MaxAddedID. }

    procedure SaveExtra(Writer: TBinaryWriter); virtual;

  { ������� EqualsExtra ����� �������������� � �������-������� ��� ���������
    �������������� ����� ������ ��������� � ���������, ���������� ����������
    SC. ���� ��������������� �������������� ���� ��������� �����, �������
    ������ ������� True. ���� ���������� �����-���� ��������, ������� ������
    ������� False. � ������ TSerializableCollection ��� ������� ������
    ���������� True. }

    function EqualsExtra(SC: TSerializableCollection): Boolean; virtual;

  { ����� CloneExtra ���������� ��� ������������ �������������� ����� ���������.
    ��� ���� ����� ���������� ���������, ���������� ���������� SC, ����������
    ��������� �������� ��������������� ����� ������ ���������. � ������
    TSerializableCollection ���� ����� ������������ ��� �������� � ���������
    SC �������� �������� MaxAddedID. }

    procedure CloneExtra(SC: TSerializableCollection); virtual;

  { ����� ClearExtra ������������ ��� ������� �������������� ����� ��� ������
    ������ Clear ���������. � ������ TSerializableCollection ����� ������������
    ��� ��������� � ���� �������� �������� MaxAddedID. }

    procedure ClearExtra; virtual;

  public

  { ����������� Create ������� ��������� ������ TSerializableCollection,
    ��������������� ��� �������� �������� ����, ����������� ����������
    ItemClassType. �������� Version ���������� ����������� ������ ��������.
    ��� �������� ����� ������������ � ����� Load ������� ������� ��� ������
    ��������� �� ��������� ������. �������� Indices ������ ������ ��������,
    ������������ ��� ���������� � ������ �� ���������. ������� ���������
    ����� �������� ����������� ������������ �� ������� ������. ������ ���
    �������� ������ ��������� ��������� ���������� �� ����������. ��������
    ������ ������� ����� ������� ������ EnsureCapacity. }

    constructor Create(ItemClassType: TSerializableObjectClassType;
      Version: Integer; Indices: array of TDataIndex);

  { ���������� Destroy ����������� ������, ������� ���������� ��������. ���
    ���� ��� ������� ������� � ������� ��������� ���������� ����� Free. }

    destructor Destroy; override;

  { �������� �������� }

  { �������� Count ���������� ���������� ��������� � ���������, �.�. �����
    ������� � ������� ������. }

    property Count: Integer read FCount;

  { �������� ItemList ���������� ������ �� ������, ������������ ��� ��������
    ��������� ���������. ������ ����� ���������� ��� ���������� � ���������
    ����� �������� ��� ��� ������ ������ EnsureCapacity. ��� �������� ��������
    �������� ������� ������� � ��������� ���������. }

    property ItemList: PSerializableObjectList read FItems;

  { �������� InsertedCount ���������� ���������� ��������� ���������, �������
    ��������� ��� �������� � ��� ���, ��� ��������� ��������� ��� ����
    ������������ ��� ��������. }

    property InsertedCount: Integer read FInsertedCount;

  { �������� InsertedItemList ���������� ������ �� ������, ����������
    ����������� ������� � ����� ������ ���������� ��������. ��� ������
    ���������� �� ���� �������� ����� ���������. }

    property InsertedItemList: PSerializableObjectList read FInsertedItems;

  { �������� DeletedCount ���������� ���������� ��������� ���������, �������
    ������� ��� �������� � ��� ���, ��� ��������� ��������� ��� ����
    ������������ ��� ��������. }

    property DeletedCount: Integer read FDeletedCount;

  { �������� DeletedItemList ���������� ������ �� ������, ���������� ���������
    ������� � �������������� ������ ���������� ��������. ������ ���������� ��
    �������� ����� ���������. }

    property DeletedItemList: PSerializableObjectList read FDeletedItems;

  { ��������� �������� }

  { �������� ItemClassType ���������� ��� ��������, ������� �������� � ������
    ���������. ���� ��� ������������� �������� ������������ ���������,
    ����������� � ����������� ������. }

    property ItemClassType: TSerializableObjectClassType read FItemClassType;

  { �������� Version ���������� �������� �������� ����������� ������ ��������,
    ������� ���� �������� � ����������� ������. ��� �������� ���������� � �����
    Load ������� ������� ��� ������ ��������� �� ��������� ������. }

    property Version: Integer read FVersion;

  { �������� IndexCount ���������� ����� ��������, ��������� � ����������.
    ��� ����� ������������� ���������� �������� � ������� Indices, ����������
    � ����������� ������, � ����� ����� ��������� �� ���������� �������
    ��������, ������ �� ������� ������������ ����������� ���������. }

    property IndexCount: Integer read FIndexCount;

  { �������� Indices ���������� ������ �� ���������� ������ �������� ������
    ���������. ����� ��������� � ���� ������� ������������� �������� ��������
    IndexCount. ������� ������������� �������, � ������� ���������� �������
    � ������� Indices, ���������� � ����������� ������. }

    property Indices: PDataIndexList read FIndices;

  { �������� MaxAddedID ���������� ������������ �������� �����������
    ��������������, ������� �����-���� ���� ��������� ������������ � ���������
    �������. ��� �������� ������������ ��� ��������� ����� ���������������
    ������� GenerateID. }

    property MaxAddedID: Integer read FMaxAddedID write FMaxAddedID;

  { �������� MaintainHash ����������, ����� �� ���������� ������� �� ��������
    ID. ����������� ����������� �������� ����� �� ���������� �����, �� �������
    ��������� �������������� ������. ����� ����, ��� ����������, ���������
    � �������� ��������� ��������� ��������� �������������� ����� ��� ��������
    ��������� � ���. �� ��������� ��� �������� ����������� � False, �.�.
    ������� �� ����������. }

    property MaintainHash: Boolean read GetMaintainHash write SetMaintainHash;

  { �������� Changed ����������, ���� �� �������� ��������� �� ������� ��
    ��������� �������� � �����. ���� ��������� �� ���� ��������, ��� �� �����
    ����������� ��� ������ ������� SaveFile � SaveIfChanged � �� �����
    �������������� � ����� ��� ������ ������ LoadFile, ���� ���� �� �����
    �� ��� ������� ������ �������������. }

    property Changed: Boolean read FChanged write FChanged;

  { �������� ������ }

  { ����� Load c�������� ��������� �� ��������� ������ Reader. ������������
    ��������� ��� ���� �� �������������. }

    procedure Load(Reader: TBinaryReader);

  { ����� Save ��������� ��������� � �������� ������ Writer. }

    procedure Save(Writer: TBinaryWriter);

  { ������� Equals ���������� True, ��� �������� ������ ��������� �����
    ��������������� ��������� ���������, ���������� ���������� SC. ���� �����
    ����� ����������� ���� �����-���� ��������, ������� ���������� False. }

    function Equals(SC: TSerializableCollection): Boolean;

  { ������� Clone ���������� ���������, ������� ������������ ����� �����
    ������ ���������, �.�. �������� ����� ������� �� ��������. }

    function Clone: TSerializableCollection;

  { ����� ������ EnsureCapacity �����������, ��� �� ���������� ��������
    ��������� ������������ ����� ���, ��� �������, Capacity ���������. ����
    ������� ��������, ������� ��������� ����� ��������� � ���������, �����
    ������� ������ �����, ����� �������� ������� ����������������� ������. }

    procedure EnsureCapacity(Capacity: Integer);

  { ����� Clear ���������� ������ ������� ��������� ������� ������ Free. �����,
    ����� ��������� (�������� Count) ��������������� � �������� 0. ������,
    ���������� ��� ���������� ������� ��������� ��� ���� �� ������������� �
    ������������ ��������� �� ����������. �������� Changed ���������
    ��������������� � �������� False. }

    procedure Clear;

  { ������ ��� ������ ��������� �� ����� � ������ ��������� � ���� }

  { ������� LoadFile ��������� ��������� �� �����, ��� �������� ����������
    ���������� FileName. ���� �������� EncryptionKey �� ����� nil, �����
    ����������� �� ��������� ������ ������ ���������������� � ������
    EncryptionKey. ���� ��������� ����� ����������� � ����� � �� ��������
    � ������� ��������� ��������, �, ����� ����, ���� ��� �� ������ �� ���
    ����� ���������� �� �����, ��������� �������� �� ��������������. ���
    ������ ���� ����������� � ������ ������� "������ ��� ������" � ������������
    �������������� ������� � ����� ����� ������ ������������� � ��� �� ������.
    ������, ���� � ������ ������ ������ ������������ ������ ���� ���� � ������
    ������, ������� �������� ����� ��� ������ �������� �������. �� ������
    �������� ����, ������������ ������������ ��������� ���������� ��������
    ������ �������������, ��������� ������� �������� ����� ��� ��������
    ��������. ���� � ���� ���� ������������ ������ ������ ��� ������ ��������,
    ������� LoadFile ������ False. ��� �������� �������� ��������� �������
    ���������� True. }

    function LoadFile(const FileName: string;
      EncryptionKey: PSHA256Digest = nil): Boolean;

  { ���� � ��������� ���� �����-���� ��������� (�������� Changed ���������
    ����� True), ����� SaveFileDirect ��������� ��������� � ����� � ������
    FileName. �������� EncryptionKey, ���� �� ������� �� nil, ������ ����
    ��� ���������� ������ ��������� ��� ������ � ����. ����� ����, ��������,
    CompressionMode, ���� �� �� ����� dcmNoCompression, ���������� �����
    ������ ������ ���������. ���� � ��������� ������ ���� FileName ������
    ��� ������ ��� ��� ������ ������ ������������� � � ���� ������� ��������
    ������������ ����� ������ "�������� ��������", ������� ������ ��������
    False. ��� �������� ���������� ��������� �� �����, ������� ����������
    True � ������������� �������� Changed ��������� � �������� False.

    ��������: ����� SaveFileDirect ����� ������������ ��� ������ � �������
    ������ � ������ ������������ �������, �.�. �� �������������� ���������,
    ��������� ������� ��������������. }

    function SaveFileDirect(const FileName: string; EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): Boolean;

  { ������� OpenFile ��������� ���� � ������ FileName � ������ ������/������
    � ��������� �� ���� ������ ���������, ���� ��������� ���������� � ������
    ��� �� ����� � ������� ���������� �� ��������. ������������ ���������
    �������� � ��������� �������� �� ������ � �� ������������� ��� ��������
    ������. ��� ��������� ������ ���� ��������� � ����������� ������ ���������
    ������� ApplyChanges ����� �������� �����. �������� EncryptionKey, ����
    �� �� ����� nil, ������ ����, � ������� �������� ������ ����������������
    ��� �������� ��������� � ����� � ��������������� ��� ����������� ����������
    ��������� �� �����. �������� CompressionMode ������ ����� ������, �������
    ������������ ��� ���������� ������ �� ����� ������� SaveIfChanged. ���� �
    ��������� ������ ���� FileName ������ ��� ������ ��� ��� ������ ������
    ������������� � � ���� ������� �������� ������������ ����� ������ "��������
    ��������", ������� ������ �������� False. ��� �������� �������� �����
    ������� ���������� True. }

    function OpenFile(const FileName: string; EncryptionKey: PSHA256Digest = nil;
      CompressionMode: TCompressionMode = dcmNoCompression): Boolean;

  { ���� � ��������� ���� �����-���� ��������� (�������� Changed ���������
    ����� True), ����� SaveIfChanged ��������� ��������� � �����, ��������
    �������� OpenFile. ���� ��� �������� ����� �������� EncryptionKey ���
    �� ����� nil, ����� ����������� �� ����� ������ ��������� � ������
    EncryptionKey. ����, ����� ����, �������� CompressionMode ��� �������
    �� dcmNoCompression, ������ ��������� ��������������� �������. �����
    ���������� ������ �������� Changed ��������� ��������������� � ��������
    False. ��� �������� ����� ���������� ��������� ��� ������ � �������
    � ������ ���������������������� �������. }

    procedure SaveIfChanged;

  { ���� � ��������� ���� �����-���� ��������� (�������� Changed ���������
    ����� True), ����� UndoIfChanged ������������ ������ �� �����, ���������
    �������� OpenFile. ����� �������, ��� ���������, ��������� � �������
    ���������� ���������� ���������, ������������. �������� Changed ���������
    ��������������� � False. ���� ����� ����� ����������, ��������, �����
    ���������� ������ ������ ApplyChanges, ����� ����� ������������ ���������
    ��������� � ������, � ������ ����� - ���. ����� ��� ��������������
    ����������������� ��������� ������ ���������� ���������� �� � �����. }

    procedure UndoIfChanged;

  { ����� CloseFile ��������� ����, �������� ������� ������ OpenFile ������
    ���������. ��� �������� ����� � ������������ ������� ������ �����������
    ������� CloseFile. }

    procedure CloseFile;

  { ������ ��� ����������, �������� � ������������� ��������� ��������� }

  { ������� NewItem ������� � ���������� ����� ��������� ������, ��� ��������
    ������� ��� �������� ItemClassType � ����������� ������ ���������. ��������
    ID ���������� ���������� ����������� ��������� ������������� �������������,
    ������� ����� ������� ��� ������������� ��������� �������� ApplyChanges ���
    EndEditDirect. ������, ������� ���������� ������ �������, ������ �����
    ������������ � ������ EndEdit, EndEditDirect ��� CancelEdit ��� ����������
    ��� ������ ���������. ��� �� ���� ����� ������� NewItem �� ��������� �����
    ������� � ���������. }

    function NewItem: TSerializableObject;

  { ������� BeginEdit ���������� ����� �������� ��������� � ��������������� ID,
    ��������������� ��� �������� ���������. � ���������� ���� ������ ������
    ���� ������� � ������ EndEdit, EndEditDirect ��� CancelEdit ��� ����������
    ��� ������ ���������. }

    function BeginEdit(ID: Integer): TSerializableObject;

  { ����� CancelEdit ���������� ������ SO. ���� ����� ���������� �������
    � ������ ������ �� ��������� ��� �������, ������������� ��������� NewItem
    ��� BeginEdit. }

    procedure CancelEdit(SO: TSerializableObject);

  { ����� EndEdit ������������ ��������� ������� SO. ��� ���� ����� ������
    ���������� � ��� ���������, �.�. � ����� InsertedItemList, � ����� ���� ��
    ������� �� �������� ���������, ���� ��� ����������, � �� �����������
    ������, ���������� � ����� DeletedItemList. }

    procedure EndEdit(SO: TSerializableObject);

  { ����� Delete �������� ������ � ��������������� ID ��� ��������. ���� ���
    ������ ��� ����������� ������, �� ����� � ������������ ��������� ��
    ���������. ���� ������ � ����� ��������������� ������������ � ���������,
    � ����� DeletedItemList ���������� ��� �����.}

    procedure Delete(ID: Integer);

  { ������� EndEditDirect ������������ ��������� ������� SO, ������ ������
    ����������� ��� ���������� ��������������� � ���������, � �� � ������
    ������������ ���������. ��� ���� ����� �������������� ��������� �������:
    OnItemIDChanged, OnItemInserted, OnItemChanged. ������� ���������� True,
    ���� ���������� ������ ������� ������� �������� � ���������, � False,
    ���� ������ �� ����� ���� ������� � ���������, �.�. ��� ���� ���������
    ������������ ������ �� �������� ���������.

    ��������: ������ � ���������� ��������� ��������, ����� ���, ��������
    ��� �������� ������� OpenFile ����� ������ ��� ��� ������ � �������
    � ������ ������������ �������. � ������ ������� ���������� ��������
    ����� EndEdit ��� ���������� ��������� � ����. }

    function EndEditDirect(SO: TSerializableObject): Boolean;

  { ����� DeleteDirect ������� ������ � ��������������� ID �� ��������� � ��
    ������ ������������ ���������.

    ��������: �������� ��������, ����� ���, �������� ��� �������� �������
    OpenFile ����� ������ ��� ��� ������ � ������� � ������ ������������
    �������. � ��������� ������� ���������� �������� ����� Delete ���
    ��������� ���������� �������� � ��� ���������.}

    procedure DeleteDirect(ID: Integer);

  { ������ ��� ������ � ������������� ����������� }

  { ��������� ������� ApplyChanges ��������� ��� ������������ ��������� �
    ��������� ���������. ��� ���� ���������� ����������� ����������, ��������,
    ������������� ��������� ���������, ���������� �������: OnItemIDChanged,
    OnItemInserted, OnItemChanged, OnItemDeleted. � ������ ��������� ����������
    ���� ��������� ������� ���������� �������� appChangesOk. ���� � ��������
    ���������� ������ ������������, ��� � ������� ��������� ��� ��������
    ������-���� �������� ��������� �� ��� ������� ������ �������������, �����
    ���������� ��������� ���� ���������� � ���������� ��������
    appChangesOriginalObjectChanged. ���� �����-���� ������� ��������� �� �����
    ���� �������� ��� �������, �.�. ��� ������� ������������ ������ �� ��������
    ���������, ������������ �������� appChangesUniqueIndexViolation. ���
    ������������� ������ ������������ ������ �������� ��������� ���������
    ������� ������ UndoIfChanged.

    ��������: ��� ������ � ������ ���������������������� ������� � ������ �����
    ApplyChanges ������ ���������� ������ ��� �������� ������� OpenFile �����
    ������, ����� ������ ������������ �� ����� ������������ ��������� ����
    ��������� � ���� �� ����� ������. }

    function ApplyChanges: TAppChangesResult; overload;

  { ��������� ������� ApplyChanges ��������� ������������ ��������� � ������
    �������� ��������� � ��������������� ID. ��������, ������������ ������
    ��������, ���������� ���������, ������������ �������� ApplyChanges,
    ��������� ��� ����������.

    ��������: ��� ������ � ������ ���������������������� ������� � ������ �����
    ApplyChanges ������ ���������� ������ ��� �������� ������� OpenFile �����
    ������, ����� ������ ������������ �� ����� ������������ ��������� ����
    ��������� � ���� �� ����� ������. }

    function ApplyChanges(ID: Integer): TAppChangesResult; overload;

  { ��������� ����� RejectChanges ������� ������ ������������ ���������,
    ������� ����� ���� ��������� � ������ ������� ApplyChanges. ����� ������
    ������� ������ �������� InsertedCount � DeletedCount ����� ����. }

    procedure RejectChanges; overload;

  { ��������� ����� RejectChanges ���������� ��� ������ �� ��������� � ��������
    ��������� � ��������������� ID. ���� ��� ������ ��� ����������� �������,
    �� ��������� ��������� �� ���������. ���� ��� ��������� �������, ��������
    �������� ���������� � ������� �������� � ���������. }

    procedure RejectChanges(ID: Integer); overload;

  { ��������� ������� HasChanges ���������� True, ���� � ��������� ����
    �����-���� ������������ ���������, �.�. �������� InsertedCount ���
    DeletedCount ��������� ������� �� ����. ���� ������������ ��������� ���,
    ������� ���������� False. }

    function HasChanges: Boolean; overload;

  { ��������� ������� HasChanges ���������� True, ���� ���� �����-����
    ������������ ��������� ��� �������� ��������� � ��������������� ID. ����
    ������� � ����� ��������������� �� ��� ������� ��� �� ����� �����������
    � ���������, ������� ���������� False. }

    function HasChanges(ID: Integer): Boolean; overload;

  { ������ ��� ������ ��������� � ��������� }

  { ������� ScanPointer ��������� ���������������� ����� �������� SO
    � ���������. ���� ����� ������� (������) ������, ������� ����������
    ��� ������, ���� ���, ������� ���������� -1. ���� ����� �������������
    ������������ ������ ��� ��������� � ����� ������ ���������. }

    function ScanPointer(SO: TSerializableObject): Integer;

  { ������� Search ������� � ��������� ������� � ��������������� ID
    � ���������� ��� ��� ��������� �������. ���� ����� ������ �� ������,
    ������� ���������� nil. ��� ������������� ����� MaintainHash ��� ���������
    ����� ������������ � ������������ ������, ���� �������� MaintainHash �����
    False, ������������ �������� ����� �� ���������� �����. }

    function Search(ID: Integer): TSerializableObject;

  { ������� IndexOf ���������� ������ �������� � ��������������� ID. ����
    ����� ������� �� ������ � ���������, ������� ���������� -1. ��� ������
    �������� �������� IndexOf ������������ �������� ����� �� ���������� �����.
    ���� ����� ���������� ������ ������� � ��������� �������� � ��������
    ��������������� ��� ����� �������� ������ �� ��� �������, �����
    ��������������� �������� Search, ������� ��������� ������� �����
    � �������������� ����, ���� �������� MaintainHash ����� True. }

    function IndexOf(ID: Integer): Integer;

  { ������� }

  { ������� OnItemIDChanged ���������� ��� ������ ������ ApplyChanges ���
    EndEditDirect ��� ������� �������, ������������ � ���������, �����
    ��������� (�������������) �������� ���������� ����� �������� �� ����������
    ��������, ��������������� �������� GenerateID. }

    property OnItemIDChanged: TItemIDChangedEvent
      read FOnItemIDChanged write FOnItemIDChanged;

  { ������� OnItemInserted ���������� ��� ������ ������ ApplyChanges ���
    EndEditDirect ��� ������� �������, ������������ � ���������. }

    property OnItemInserted: TItemInsertedEvent
      read FOnItemInserted write FOnItemInserted;

  { ������� OnItemChanged ���������� ��� ������ ������ ApplyChanges ���
    EndEditDirect ��� ������� ����������� �������. }

    property OnItemChanged: TItemChangedEvent
      read FOnItemChanged write FOnItemChanged;

  { ������� OnItemDeleted ���������� ��� ������ ������ ApplyChanges ���
    EndEditDirect ��� ������� �������, ���������� �� ���������. }

    property OnItemDeleted: TItemDeletedEvent
      read FOnItemDeleted write FOnItemDeleted;
  end;


{ ����� TFakePrimaryKeyCollection - ������� ������ TSerializableCollection,
  ��������������� ��� �������� ���������, �� ������� ����������� ������ � ����
  � ������ �������� ������. � ���� ������ ������������� ��������� ��������
  ���������� ����� ������� �������� ��������� � �������� ������. ��������������
  ����� ����������� ��������� ��������� ����������� ����� �������� �� ��
  ��������� ������.

  ��������: ���� ����� �� ������������ ��� ������ � ������� � ������
  ���������������������� �������, ���� �������������� ����������� ��������
  ��������� ���������, ��� ��� ����� �������� �������� � ��������� ��������
  ��������� ������������ �������������� ��������� �� ��� ��������� ���������
  ���������. }

  TFakePrimaryKeyCollection = class(TSerializableCollection)
  protected

  { ����� LoadExtra ����������� ��������������� ����� ���������
    TSerializableCollection, ����� �������� ������ �� ��������� ������ ������
    ������. ����� ����, ����� ����������� ��������� ��������� ���������
    ��������� �������� ���������� �����. }

    procedure LoadExtra(Reader: TBinaryReader; Version: Integer); override;

  { ����� SaveExtra ����������� ��������������� ����� ���������
    TSerializableCollection, ����� �������� ���������� � �������� ������
    ������ ����������. }

    procedure SaveExtra(Writer: TBinaryWriter); override;
  end;


{ ����� TBytePrimaryKeyCollection - ������� ������ TSerializableCollection,
  ��������������� ��� �������� �� ����� ��� 255 ���������. � ���� ������
  ��������� ���� ������� �������� ��������� ����� ����������� � ��������
  ������ � ���� �����. }

  TBytePrimaryKeyCollection = class(TSerializableCollection)
  protected

  { ������� GenerateID ���������� ����� ���������� �������� ��������������
    � ��������� �� 1 �� 255. ���� � ��������� ��� 255 ���������, ���������
    ����������. }

    function GenerateID: Integer; override;

  { ����� LoadExtra ��������������� �� ��������� ������ �������� ��������
    MaxAddedID ���������, ����������� ��� ����. }

    procedure LoadExtra(Reader: TBinaryReader; Version: Integer); override;

  { ����� SaveExtra �������� � �������� ����� �������� �������� MaxAddedID
    ���������. ��� �������� ����������� ��� ����. }

    procedure SaveExtra(Writer: TBinaryWriter); override;
  end;


{ ����� TWordPrimaryKeyCollection - ������� ������ TSerializableCollection,
  ��������������� ��� �������� �� ����� ��� 65535 ���������. � ���� ������
  ��������� ���� ������� �������� ��������� ����� ����������� � ��������
  ������ � ���� 2-�������� �������� ���� Word. }

  TWordPrimaryKeyCollection = class(TSerializableCollection)
  protected

  { ������� GenerateID ���������� ����� ���������� �������� ��������������
    � ��������� �� 1 �� 65535. ���� � ��������� ��� 65535 ���������, ���������
    ����������. }

    function GenerateID: Integer; override;

  { ����� LoadExtra ��������������� �� ��������� ������ �������� ��������
    MaxAddedID ���������, ����������� ��� 2-������� ����� ���� Word. }

    procedure LoadExtra(Reader: TBinaryReader; Version: Integer); override;

  { ����� SaveExtra �������� � �������� ����� �������� �������� MaxAddedID
    ���������. ��� �������� ����������� ��� 2-������� ����� ���� Word. }

    procedure SaveExtra(Writer: TBinaryWriter); override;
  end;


{ ����� TDataIndex - ����������� ������� ����� �������� ��� ���������
  TSerializableCollection. ������� ������������� �������� ���������, ���������
  ������ �������� �������� �� �������� �������������� ����, �������� ���������
  ���������, �, ����� ����, ������� ����� ����������� ����������� ������������
  �� ������� ������. }

  TDataIndex = class(TObject)
  private
    FItems: PSerializableObjectList;
    FOwner: TSerializableCollection;
    FActive: Boolean;
    FDescending: Boolean;
    FUnique: Boolean;
    procedure SetCapacity(OldCapacity, NewCapacity, Count: Integer);
    function GetItemList: PSerializableObjectList;
    procedure SortItems; virtual; abstract;
    procedure SetActive(V: Boolean);
    procedure Activate;
    procedure SetDescending(V: Boolean);
    procedure Delete(SO: TSerializableObject);
    procedure UpdateItems;
  protected

  { ������� CanInsert ���������� True, ���� ������� SO ����� ���� ��������
    � ��������� ��� ��������� ������������ ������� �������, ���� ������
    �� �������� ���������� ��� ���� ��������� �������� ������� � ��� ��
    ��������� �������������� �������� � ������������� ����� �������� �����
    �������� �������� ID ������� SO. � ��������� ������ ������� ����������
    False, ��� �������� ������������� ������� ������� SO. }

    function CanInsert(SO: TSerializableObject): Boolean; virtual; abstract;

  { ����� Insert ��������� ������, ���������� ���������� SO, � ������,
    ���������� ��������� ItemList ������� �������, � ������������ �
    ������� �������� ���������� �������. }

    procedure Insert(SO: TSerializableObject); virtual; abstract;

  { ������� Clone ���������� ������, �������������� ����� ����� �������
    �������. }

    function Clone: TDataIndex; virtual; abstract;

  public

  { ���������� Destroy ����������� ������, ������� �������� � ����������
    ��������, ���������� ������ �� �������� ���������. }

    destructor Destroy; override;

  { �������� }

  { �������� Owner ���������� ������ �� ���������, ������� �������� ����������
    ������� �������. }

    property Owner: TSerializableCollection read FOwner;

  { �������� Active ��������� ��� ������������� ��������, ������������
    ���������� ������� �������. ����� ������ �������, � ������ �������������
    ������ ���������� �� �������� ���������, ������������� � ������������ �
    ����������� �������. ��� ������ ��������� � ���������, ���������� ���������
    ����������� ���� �������� ��������. ���������� ������� ����������� ���
    ���������� � ��������� ��������� ���������. ���� ���������� ������ �������,
    ��� ������������ ������������ �������� �����, ���� ���������, ������������
    ��������� �������� �����. ��� ��������� � ������� �������, ���� ������
    ������ ���������, �� ������������� ��������������. }

    property Active: Boolean read FActive write SetActive;

  { �������� Descending ���������� ��� ������������� ��������, ������������
    ������ ���������� ��������� �������. ���� �������� ����� False (��������
    �� ���������), �������� ������� ����������� �� �����������. ���� ��������
    Descending ����� True, �������� ������� ����������� �� ��������. }

    property Descending: Boolean read FDescending write SetDescending;

  { �������� Unique ���������� ��������, ������� ���������� ������������
    ������� �������. ���� ��� �������� ����� True, �� ������ ��������
    ���������� � � ��������� ���������� �������� ������ ������ � ��� ��
    ��������� �������������� ���������. ���� �������� ����� False,
    � ��������� ����� ���������� ��������� �������� � ����� � ��� ��
    ������������� ���������. }

    property Unique: Boolean read FUnique;

  { �������� ItemList ���������� ������ �� ������, ���������� ������ ���������
    ���������, ������������� � ������������ � ����������� ������� �������. ����
    ����� ���������� � ����� �������� ������ �� ��� �������, �� �������������
    ��������������. ������ �� ������ ����� ���������� ��� ����������
    � ��������� ����� �������� ��� ��� ������ ������ EnsureCapacity ���
    ���������, � ������� ��������� ������ ������. }

    property ItemList: PSerializableObjectList read GetItemList;

  { ������ }

  { ������� Compare - ����������� �����, ������� ������������� � �������-
    ��������. ������������ ��� ��������� ��������� SO1 � SO2 ���������
    � ������ �������� �������� Descending �������. }

    function Compare(SO1, SO2: TSerializableObject): Integer; virtual; abstract;

  { ������� ScanPointer ��������� ���������������� ����� �������� SO (������)
    �� ���������� �������, ���������� ��������� ItemList. ������� ����������
    ������ ���������� �������� ��� -1, ���� ����� ������� �����������. }

    function ScanPointer(SO: TSerializableObject): Integer;
  end;


{ ����� TStringIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� String. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  String ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_String = function(SO: TSerializableObject): string;

  TStringIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_String;
    FCaseSensitive: Boolean;
    procedure SortItems; override;
    procedure QuickSortTextAsc(L, R: Integer);
    procedure QuickSortTextDesc(L, R: Integer);
    procedure QuickSortStrAsc(L, R: Integer);
    procedure QuickSortStrDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TStringIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� String �������� ���������. �������� Unique
    ����������, ������ �� ������ ���� ����������. ���� �� ����� True, ���
    ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. ���������
    �������� CaseSensitive ����������, ����� �� ��������� �������/���������
    ����� ��� ��������� ��������� �������� �������. ���� ���� �������� �����
    False, �� ������� �������� �� �����������; ���� True, �� ��� ���������
    � ���������� ����� ������� (���������) ����� ������������ ���������
    (��������). }

    constructor Create(KeyOf: TKeyOfFunction_String; Unique, CaseSensitive: Boolean);

  { �������� CaseSensitive ���������� �������� ��������� CaseSensitive,
    ���������� � ����������� ������. ���� ��� �������� ����� False, �������
    �������� �� ����������� ��� ��������� ��������� �������� �������. ����
    True, ��� ��������� ������� � ��������� ����� �����������. }

    property CaseSensitive: Boolean read FCaseSensitive;

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������.
    ��� ���� ����������� �������� ������� Descending � CaseSensitive �������. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ��� ��������� ����� ������� �������� ����������� ��� �� �����������
    � ����������� �� �������� �������� CaseSensitive. ���� ������ Key
    �� ������� ����� ������������� ��������, ������� ���������� False. }

    function Contains(const Key: string): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� ������ Key. ��� ��������� ����� ������� �������� �����������
    ��� �� ����������� � ����������� �� �������� �������� CaseSensitive. ����
    ������ Key �� ������� ����� ������������� ��������, ������� ���������� nil. }

    function Search(const Key: string): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� ������ Key.
    ��� ��������� ����� ������� �������� ����������� ��� �� �����������
    � ����������� �� �������� �������� CaseSensitive. ���� ������ Key
    �� ������� ����� ������������� ��������, ������� IndexOf ����������
    �������� -1. }

    function IndexOf(const Key: string): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. ��� ��������� ����� ������� ��������
    ����������� ��� �� ����������� � ����������� �� �������� ��������
    CaseSensitive. }

    function SelectRange(const Key1, Key2: string; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. ��� ��������� ����� ������� ��������
    ����������� ��� �� ����������� � ����������� �� �������� ��������
    CaseSensitive. }

    function SelectRange(const Key: string): Integer; overload;

  { ������� StartsWith �������� �������� ��������� �������, �����������
    ��������� ItemList �������, �����, ��� ������������� ��������� ��������
    ��� ���� ��������� ����� ��������� ���������� � ���������, ��������
    ���������� S. ������� ���������� ���������� ��������� ���������.
    � ��������� Index ������������ ������ ������� �������� ���������.
    ��� ��������� ����� ������� �������� ����������� ��� �� �����������
    � ����������� �� �������� �������� CaseSensitive. }

    function StartsWith(const S: string; var Index: Integer): Integer;
  end;


{ ����� TShortIntIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� ShortInt. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  ShortInt ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_ShortInt = function(SO: TSerializableObject): ShortInt;

  TShortIntIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_ShortInt;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TShortIntIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� ShortInt ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_ShortInt; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: ShortInt): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: ShortInt): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: ShortInt): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: ShortInt; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: ShortInt): Integer; overload;
  end;


{ ����� TByteIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Byte. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Byte ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Byte = function(SO: TSerializableObject): Byte;

  TByteIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Byte;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TByteIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Byte ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Byte; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: Byte): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: Byte): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: Byte): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: Byte; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: Byte): Integer; overload;
  end;


{ ����� TSmallIntIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� SmallInt. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  SmallInt ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_SmallInt = function(SO: TSerializableObject): SmallInt;

  TSmallIntIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_SmallInt;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TSmallIntIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� SmallInt ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_SmallInt; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: SmallInt): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: SmallInt): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: SmallInt): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: SmallInt; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: SmallInt): Integer; overload;
  end;


{ ����� TWordIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Word. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Word ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Word = function(SO: TSerializableObject): Word;

  TWordIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Word;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TWordIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Word ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Word; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: Word): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: Word): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: Word): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: Word; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: Word): Integer; overload;
  end;


{ ����� TIntegerIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Integer. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Integer ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Integer = function(SO: TSerializableObject): Integer;

  TIntegerIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Integer;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TIntegerIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Integer ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Integer; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: Integer): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: Integer): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: Integer): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: Integer; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: Integer): Integer; overload;
  end;


{ ����� TLongWordIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� LongWord. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  LongWord ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_LongWord = function(SO: TSerializableObject): LongWord;

  TLongWordIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_LongWord;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TLongWordIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� LongWord ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_LongWord; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: LongWord): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: LongWord): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: LongWord): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: LongWord; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: LongWord): Integer; overload;
  end;


{ ����� TInt64Index - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Int64. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Int64 ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Int64 = function(SO: TSerializableObject): Int64;

  TInt64Index = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Int64;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TInt64Index. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Int64 ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Int64; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(const Key: Int64): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(const Key: Int64): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(const Key: Int64): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(const Key1, Key2: Int64; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(const Key: Int64): Integer; overload;
  end;


{ ����� TDateTimeIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� TDateTime. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  TDateTime ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_DateTime = function(SO: TSerializableObject): TDateTime;

  TDateTimeIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_DateTime;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TDateTimeIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� TDateTime ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_DateTime; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(const Key: TDateTime): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(const Key: TDateTime): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(const Key: TDateTime): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(const Key1, Key2: TDateTime; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(const Key: TDateTime): Integer; overload;
  end;


{ ����� TSingleIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Single. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Single ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Single = function(SO: TSerializableObject): Single;

  TSingleIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Single;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TSingleIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Single ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Single; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(const Key: Single): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(const Key: Single): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(const Key: Single): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(const Key1, Key2: Single; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(const Key: Single): Integer; overload;
  end;


{ ����� TDoubleIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Double. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Double ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Double = function(SO: TSerializableObject): Double;

  TDoubleIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Double;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TDoubleIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Double ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Double; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(const Key: Double): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(const Key: Double): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(const Key: Double): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(const Key1, Key2: Double; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(const Key: Double): Integer; overload;
  end;


{ ����� TCurrencyIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Currency. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Currency ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Currency = function(SO: TSerializableObject): Currency;

  TCurrencyIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Currency;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TCurrencyIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Currency ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Currency; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(const Key: Currency): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(const Key: Currency): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(const Key: Currency): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(const Key1, Key2: Currency; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(const Key: Currency): Integer; overload;
  end;


{ ����� TCharIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� �� �������� ���� Char. }

{ �������� �������, ������������ ��� ��������� �������������� �������� ����
  Char ������� ���� TSerializableObject, ����������� ���������� SO. }

  TKeyOfFunction_Char = function(SO: TSerializableObject): Char;

  TCharIndex = class(TDataIndex)
  private
    FKeyOf: TKeyOfFunction_Char;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TCharIndex. � ��������
    ������� ��������� (KeyOf) ��������� ����� �������, ������� ����������
    ������������� �������� ���� Char ��� �������� ���������. ��������
    Unique ����������, ������ �� ������ ���� ����������. ���� �� ����� True,
    ��� ��������� �������� ����������� ����������� ����� � � ��� ����������
    �������� ������ ������� � ��� �� ������������� ���������. }

    constructor Create(KeyOf: TKeyOfFunction_Char; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ��� ��������� ��������� SO1 � SO2 ��������� �� �������� �����,
    ������������� ��������, ����� ������� ������� � ����������� ������� ������
    ���������� KeyOf. ��� ���� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ������ �������� �������� Key.
    ���� ����� �������� �� ������� � ������ ������������� ��������, �������
    ���������� False. }

    function Contains(Key: Char): Boolean;

  { ������� Search ���������� ������� ���������, ��� �������� �������������
    �������� ����� �������� ��������� Key. ���� ����� �������� �� �������
    � �������, ������� ���������� nil. }

    function Search(Key: Char): TSerializableObject;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ��� �������� ������������� �������� ����� Key. ����
    ����� �������� �� ������� � �������, ������� ���������� -1. }

    function IndexOf(Key: Char): Integer;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ���������
    Key1 � ������ �������� ��������� Key2. ������� ���������� ����������
    ��������� ���������. � ��������� Index ������������ ������ �������
    �������� ���������. � ������, ���� ������ ���������� �� �������� (��������
    Descending ����� True), ���������� ����� ��������, ��� �������������
    �������� ��� ���� ��� ��������� ������ ��� ����� �������� ��������� Key1
    � ������ �������� ��������� Key2. }

    function SelectRange(Key1, Key2: Char; var Index: Integer): Integer; overload;

  { ��������� ������� SelectRange �������� �������� ��������� �������,
    ����������� ��������� ItemList �������, �����, ��� ������������� ��������
    ��� ���� ��������� ����� ��������� ������ ��� ����� �������� ��������� Key.
    ������� ���������� ������ ������� �������� ���������. � ������, ���� ������
    ���������� �� �������� (�������� Descending ����� True), ���������� �����
    ��������, ��� ������������� �������� ��� ���� ��� ��������� ������ ���
    ����� �������� ��������� Key. }

    function SelectRange(Key: Char): Integer; overload;
  end;


{ ����� TCompoundIndex - ������� ������ TDataIndex, ��������������� ���
  �������������� ��������� ��������� �� ��������� ���������� �����. }

{ �������� �������, ������������ ��� ��������� ���� ����������� ������
  TSerializableObject �� ���������� �����. ���� ������ SO1 ������ ������� SO2,
  ������� ������ ������� �������� ������ ����. ���� ������ SO1 ������ �������
  SO2, ������� ������ ������� �������� ������ ����. ���� ��������������� ����
  �������� �����, ������� ������ ������� ����. }

  TCompareObjectsFunction = function (SO1, SO2: TSerializableObject): Integer;

  TCompoundIndex = class(TDataIndex)
  private
    FCompareFunction: TCompareObjectsFunction;
    procedure SortItems; override;
    procedure QuickSortAsc(L, R: Integer);
    procedure QuickSortDesc(L, R: Integer);
  protected
    function CanInsert(SO: TSerializableObject): Boolean; override;
    procedure Insert(SO: TSerializableObject); override;
    function Clone: TDataIndex; override;
  public

  { ����������� Create ������� ��������� ������ TCompoundIndex. � ��������
    ������� ��������� (CompareFunction) ��������� ����� �������, ������������
    ��� ��������� ���� ����������� ������, ������������ �� TSerializableObject.
    �������� Unique ����������, ������ �� ������ ���� ����������. ���� ��
    ����� True, ��� ��������� �������� ����������� ����������� ����� � � ���
    ���������� �������� ������ ������� � ��� �� ������� ������������� �����. }
                
    constructor Create(CompareFunction: TCompareObjectsFunction; Unique: Boolean);

  { ������� Compare ����������� ��������������� �����, ������������ � ������
    TDataIndex, ����� ���������� �������� SO1 � SO2 ��������� � �������
    �������, ����� ������� ������� � ����������� ������� ������. ��� ����
    ������������� ����������� �������� �������� Descending. }

    function Compare(SO1, SO2: TSerializableObject): Integer; override;

  { ������� Contains ���������� True, ���� ��������� �������� �������, ������
    �������, ����������� ���������� SO. ��� ��������� �������� ������������
    �������, ���������� � ����������� ������� ������. ���� ������� ������ SO
    �� ������ � ���������, ������� Contains ���������� False. }

    function Contains(SO: TSerializableObject): Boolean;

  { ������� IndexOf ���������� ������ ������� �������� � �������, ����������
    ��������� ItemList, ������� ����� �������, ����������� ���������� SO.
    ��� ��������� �������� ������������ �������, ���������� � �����������
    ������� ������. ���� ������� ������ SO �� ������ �� ���������� �������
    �������, ������� IndexOf ���������� -1. }

    function IndexOf(SO: TSerializableObject): Integer;
  end;

implementation

uses AcedBinary, AcedStrings, AcedCommon, AcedNetWait;

var
  EmptyObject: TSerializableObject;

{ TSerializableObject }

constructor TSerializableObject.Create;
begin
end;

{ TSerializableCollection }

constructor TSerializableCollection.Create(ItemClassType: TSerializableObjectClassType;
  Version: Integer; Indices: array of TDataIndex);
var
  I: Integer;
  DataIndex: TDataIndex;
begin
  FItemClassType := ItemClassType;
  FVersion := Version;
  FIndexCount := High(Indices) + 1;
  if FIndexCount > 0 then
  begin
    GetMem(FIndices, FIndexCount * SizeOf(Pointer));
    for I := FIndexCount - 1 downto 0 do
    begin
      DataIndex := Indices[I];
      FIndices^[I] := DataIndex;
      DataIndex.FOwner := Self;
    end;
  end;
  FHandle := INVALID_HANDLE_VALUE;
end;

destructor TSerializableCollection.Destroy;
var
  I: Integer;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
  if FHash <> nil then
    FreeMem(FHash);
  if FCapacity > 0 then
  begin
    for I := FCount - 1 downto 0 do
      FItems^[I].Free;
    FreeMem(FItems);
  end;
  if FIndexCount > 0 then
  begin
    for I := FIndexCount - 1 downto 0 do
      FIndices^[I].Free;
    FreeMem(FIndices);
  end;
  if FInsertedCapacity > 0 then
  begin
    for I := FInsertedCount - 1 downto 0 do
      FInsertedItems^[I].Free;
    FreeMem(FInsertedItems);
  end;
  if FDeletedCapacity > 0 then
  begin
    for I := FDeletedCount - 1 downto 0 do
      FDeletedItems^[I].Free;
    FreeMem(FDeletedItems);
  end;
end;

procedure TSerializableCollection.SetCapacity(NewCapacity: Integer);
var
  I: Integer;
  NewItems: PSerializableObjectList;
begin
  if (NewCapacity <> FCapacity) and (NewCapacity >= FCount) then
  begin
    for I := FIndexCount - 1 downto 0 do
      FIndices^[I].SetCapacity(FCapacity, NewCapacity, FCount);
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

procedure TSerializableCollection.GrowInsertedCapacity();
var
  N: Integer;
  NewItems: PSerializableObjectList;
begin
  N := G_EnlargeCapacity(FInsertedCapacity);
  GetMem(NewItems, N * SizeOf(Pointer));
  if FInsertedCount > 0 then
    G_CopyLongs(FInsertedItems, NewItems, FInsertedCount);
  if FInsertedCapacity > 0 then
    FreeMem(FInsertedItems);
  FInsertedCapacity := N;
  FInsertedItems := NewItems;
end;

procedure TSerializableCollection.GrowDeletedCapacity();
var
  N: Integer;
  NewItems: PSerializableObjectList;
begin
  N := G_EnlargeCapacity(FDeletedCapacity);
  GetMem(NewItems, N * SizeOf(Pointer));
  if FDeletedCount > 0 then
    G_CopyLongs(FDeletedItems, NewItems, FDeletedCount);
  if FDeletedCapacity > 0 then
    FreeMem(FDeletedItems);
  FDeletedCapacity := N;
  FDeletedItems := NewItems;
end;

procedure TSerializableCollection.SetHashCapacity(NewHashCapacity: Integer);
var
  I: Integer;
begin
  FHashCapacity := NewHashCapacity;
  if FHash <> nil then
    FreeMem(FHash);
  GetMem(FHash, FHashCapacity * SizeOf(Pointer));
  G_FillLongs(0, FHash, FHashCapacity);
  FHashMaxCount := (FHashCapacity * 5) div 7;
  for I := FCount - 1 downto 0 do
    PutInHash(FItems^[I]);
  FHashUsedCount := FCount;
end;

procedure TSerializableCollection.PutInHash(SO: TSerializableObject);
var
  X, HashSize, HashStep: LongWord;
begin
  X := LongWord(SO.FID);
  HashSize := LongWord(FHashCapacity);
  HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
  while True do
  begin
    X := X mod HashSize;
    if FHash^[X] = nil then
    begin
      FHash^[X] := SO;
      Exit;
    end;
    Inc(X, HashStep);
  end;
end;

function TSerializableCollection.GetMaintainHash: Boolean;
begin
  Result := FHash <> nil;
end;

procedure TSerializableCollection.SetMaintainHash(V: Boolean);
begin
  if V then
  begin
    if FHash = nil then
      SetHashCapacity(G_EnlargePrimeCapacity((FCapacity * 7) div 5));
  end
  else if FHash <> nil then
  begin
    FreeMem(FHash);
    FHash := nil;
  end;
end;

function TSerializableCollection.GenerateID: Integer;
var
  I: Integer;
begin
  if FMaxAddedID < $7FFFFFFF then
  begin
    Inc(FMaxAddedID);
    Result := FMaxAddedID;
  end else
  begin
    I := 0;
    while (I < FCount) and (TSerializableObject(FItems^[I]).FID = I + 1) do
      Inc(I);
    Result := I + 1;
  end;
end;

procedure TSerializableCollection.LoadExtra(Reader: TBinaryReader; Version: Integer);
begin
  FMaxAddedID := Reader.ReadInteger;
end;

procedure TSerializableCollection.SaveExtra(Writer: TBinaryWriter);
begin
  Writer.WriteInteger(FMaxAddedID);
end;

function TSerializableCollection.EqualsExtra(SC: TSerializableCollection): Boolean;
begin
  Result := True;
end;

procedure TSerializableCollection.CloneExtra(SC: TSerializableCollection);
begin
  SC.FMaxAddedID := FMaxAddedID;
end;

procedure TSerializableCollection.ClearExtra;
begin
  FMaxAddedID := 0;
end;

procedure TSerializableCollection.Load(Reader: TBinaryReader);
var
  I, V, Count: Integer;
  T: TSerializableObject;
begin
  Clear;
  V := Reader.ReadByte;
  if V = 0 then
  begin
    V := Reader.ReadWord;
    if V = 0 then
      V := Reader.ReadInteger
    else
      Inc(V, $FF);
  end;
  Count := Reader.ReadWord;
  if Count = $FFFF then
    Count := Reader.ReadInteger;
  EnsureCapacity(Count);
  for I := 0 to Count - 1 do
  begin
    T := FItemClassType.Create;
    T.Load(Reader, V);
    FItems^[I] := T;
  end;
  FCount := Count;
  LoadExtra(Reader, V);
  if FHash <> nil then
  begin
    if FCount > FHashMaxCount then
      SetHashCapacity(G_EnlargePrimeCapacity((FCount * 7) div 5))
    else
    begin
      for I := FCount - 1 downto 0 do
        PutInHash(FItems^[I]);
      FHashUsedCount := FCount;
    end;
  end;
  for I := FIndexCount - 1 downto 0 do
    FIndices^[I].UpdateItems;
  FChanged := False;
end;

procedure TSerializableCollection.Save(Writer: TBinaryWriter);
var
  I: Integer;
begin
  if FVersion <= $FF then
    Writer.WriteByte(Byte(FVersion))
  else if FVersion <= $100FE then
  begin
    Writer.WriteByte(0);
    Writer.WriteWord(Word(FVersion - $FF))
  end else
  begin
    Writer.WriteByte(0);
    Writer.WriteWord(0);
    Writer.WriteInteger(FVersion);
  end;
  if FCount < $FFFF then
    Writer.WriteWord(FCount)
  else
  begin
    Writer.WriteWord($FFFF);
    Writer.WriteInteger(FCount);
  end;
  for I := 0 to FCount - 1 do
    FItems^[I].Save(Writer);
  SaveExtra(Writer);
end;

function TSerializableCollection.Equals(SC: TSerializableCollection): Boolean;
var
  I: Integer;
  SCItems: PSerializableObjectList;
begin
  Result := False;
  if SC = Self then
    Result := True
  else if (FItemClassType = SC.FItemClassType) and (FCount = SC.FCount) then
  begin
    SCItems := SC.FItems;
    for I := FCount - 1 downto 0 do
      if not FItems^[I].Equals(SCItems^[I]) then
        Exit;
    Result := EqualsExtra(SC);
  end;
end;

function TSerializableCollection.Clone: TSerializableCollection;
var
  Indices: array of TDataIndex;
  NewItems: PSerializableObjectList;
  I: Integer;
begin
  SetLength(Indices, FIndexCount);
  for I := 0 to FIndexCount - 1 do
    Indices[I] := FIndices^[I].Clone;
  Result := Self.Create(FItemClassType, FVersion, Indices);
  Result.SetCapacity(FCapacity);
  NewItems := Result.FItems;
  for I := FCount - 1 downto 0 do
    NewItems^[I] := FItems^[I].Clone;
  Result.FCount := FCount;
  CloneExtra(Result);
end;

procedure TSerializableCollection.EnsureCapacity(Capacity: Integer);
begin
  if FCapacity < Capacity then
    SetCapacity(G_NormalizeCapacity(Capacity));
end;

procedure TSerializableCollection.Clear;
var
  I: Integer;
begin
  if (FHash <> nil) and (FHashUsedCount > 0) then
  begin
    G_FillLongs(0, FHash, FHashCapacity);
    FHashUsedCount := 0;
  end;
  if FCount > 0 then
  begin
    for I := FCount - 1 downto 0 do
      FItems^[I].Free;
    FCount := 0;
  end;
  ClearExtra;
  FChanged := False;
end;

function TSerializableCollection.LoadFile(const FileName: string;
  EncryptionKey: PSHA256Digest): Boolean;
var
  Handle: THandle;
  FindData: _WIN32_FIND_DATAA;
  Size, Tick: LongWord;
  FileVersion: LongWord;
  Reader: TBinaryReader;
begin
  Result := True;
  if FHandle <> INVALID_HANDLE_VALUE then
    RaiseErrorFmt(SErrFileOpenedForWrite, FileName);
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle = INVALID_HANDLE_VALUE then
  begin
    Clear;
    FFileVersion := 0;
    FFileSize := 0;
  end else
  begin
    Windows.FindClose(Handle);
    repeat
      NetWaitAction := netWaitActionNone;
      Handle := Windows.CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ,
        nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if Handle = INVALID_HANDLE_VALUE then
      begin
        if csDestroying in Application.ComponentState then
        begin
          NetWaitAction := netWaitActionCancel;
          Break;
        end;
        if NetWaitNotifyForm = nil then
          NetWaitNotifyForm := TNetWaitNotifyForm.Create(Application);
        with NetWaitNotifyForm do
        begin
          FileInfoLabel.Caption := NetWaitMsgBeginning + FileName + NetWaitMsgToWrite;
          Show;
        end;
        Tick := GetTickCount;
        repeat
          Application.ProcessMessages;
        until (NetWaitAction <> netWaitActionNone) or (G_TickCountSince(Tick) >= 3000);
        if NetWaitAction = netWaitActionNone then
          NetWaitAction := netWaitActionRetry;
        NetWaitNotifyForm.Hide;
      end;
    until NetWaitAction <> netWaitActionRetry;
    if NetWaitAction = netWaitActionCancel then
    begin
      Result := False;
      Exit;
    end;
    FFileSize := GetFileSize(Handle, nil);
    if FFileSize < 16 then
    begin
      CloseHandle(Handle);
      Clear;
      FFileVersion := 0;
      Exit;
    end;
    if not ReadFile(Handle, FileVersion, 4, Size, nil) or (Size <> 4) then
      RaiseErrorFmt(SErrFileReadError, FileName);
    if not FChanged and (FileVersion = FFileVersion) then
    begin
      CloseHandle(Handle);
      Exit;
    end;
    FFileVersion := FileVersion;
    Reader := TBinaryReader.Create;
    if not Reader.LoadFromFile(Handle, EncryptionKey) then
      RaiseErrorFmt(SErrFileReadError, FileName);
    CloseHandle(Handle);
    Load(Reader);
    if Reader.Position <> Reader.Length then
      RaiseErrorFmt(SErrReadNotComplete, FileName);
    Reader.Free;
  end;
end;

function TSerializableCollection.SaveFileDirect(const FileName: string;
  EncryptionKey: PSHA256Digest; CompressionMode: TCompressionMode): Boolean;
var
  Handle: THandle;
  Size, Tick: LongWord;
  Writer: TBinaryWriter;
begin
  Result := True;
  if FHandle <> INVALID_HANDLE_VALUE then
    RaiseErrorFmt(SErrFileOpenedForWrite, FileName);
  if FChanged then
  begin
    Writer := TBinaryWriter.Create(FFileSize);
    Save(Writer);
    repeat
      NetWaitAction := netWaitActionNone;
      Handle := Windows.CreateFile(PChar(FileName), GENERIC_WRITE,
        0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if Handle = INVALID_HANDLE_VALUE then
      begin
        if csDestroying in Application.ComponentState then
        begin
          NetWaitAction := netWaitActionCancel;
          Break;
        end;
        if NetWaitNotifyForm = nil then
          NetWaitNotifyForm := TNetWaitNotifyForm.Create(Application);
        with NetWaitNotifyForm do
        begin
          FileInfoLabel.Caption := NetWaitMsgBeginning + FileName + NetWaitMsgToWrite;
          Show;
        end;
        Tick := GetTickCount;
        repeat
          Application.ProcessMessages;
        until (NetWaitAction <> netWaitActionNone) or (G_TickCountSince(Tick) >= 3000);
        if NetWaitAction = netWaitActionNone then
          NetWaitAction := netWaitActionRetry;
        NetWaitNotifyForm.Hide;
      end;
    until NetWaitAction <> netWaitActionRetry;
    if NetWaitAction = netWaitActionCancel then
    begin
      Writer.Free;
      Result := False;
      Exit;
    end;
    Inc(FFileVersion);
    if not WriteFile(Handle, FFileVersion, 4, Size, nil) or (Size <> 4) then
      RaiseErrorFmt(SErrFileWriteErrorFmt, FileName);
    if not Writer.SaveToFile(Handle, EncryptionKey, CompressionMode) then
      RaiseErrorFmt(SErrFileWriteErrorFmt, FileName);
    CloseHandle(Handle);
    Writer.Free;
    FChanged := False;
  end;
end;

function TSerializableCollection.OpenFile(const FileName: string;
  EncryptionKey: PSHA256Digest; CompressionMode: TCompressionMode): Boolean;
var
  Size, Tick: LongWord;
  FileVersion: LongWord;
  Reader: TBinaryReader;
begin
  Result := True;
  if FHandle <> INVALID_HANDLE_VALUE then
    RaiseErrorFmt(SErrFileOpenedForWrite, FileName);
  repeat
    NetWaitAction := netWaitActionNone;
    FHandle := Windows.CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
      0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if FHandle = INVALID_HANDLE_VALUE then
    begin
      if csDestroying in Application.ComponentState then
      begin
        NetWaitAction := netWaitActionCancel;
        Break;
      end;
      if NetWaitNotifyForm = nil then
        NetWaitNotifyForm := TNetWaitNotifyForm.Create(Application);
      with NetWaitNotifyForm do
      begin
        FileInfoLabel.Caption := NetWaitMsgBeginning + FileName + NetWaitMsgToWrite;
        Show;
      end;
      Tick := GetTickCount;
      repeat
        Application.ProcessMessages;
      until (NetWaitAction <> netWaitActionNone) or (G_TickCountSince(Tick) >= 3000);
      if NetWaitAction = netWaitActionNone then
        NetWaitAction := netWaitActionRetry;
      NetWaitNotifyForm.Hide;
    end;
  until NetWaitAction <> netWaitActionRetry;
  if NetWaitAction = netWaitActionCancel then
  begin
    Result := False;
    Exit;
  end;
  FEncryptionKey := EncryptionKey;
  FCompressionMode := CompressionMode;
  FFileSize := GetFileSize(FHandle, nil);
  if FFileSize < 16 then
  begin
    Clear;
    FFileVersion := 0;
    Exit;
  end;
  if not ReadFile(FHandle, FileVersion, 4, Size, nil) or (Size <> 4) then
    RaiseErrorFmt(SErrFileReadError, FileName);
  if not FChanged and (FileVersion = FFileVersion) then
    Exit;
  FFileVersion := FileVersion;
  Reader := TBinaryReader.Create;
  if not Reader.LoadFromFile(FHandle, EncryptionKey) then
    RaiseErrorFmt(SErrFileReadError, FileName);
  Load(Reader);
  if Reader.Position <> Reader.Length then
    RaiseErrorFmt(SErrReadNotComplete, FileName);
  Reader.Free;
end;

procedure TSerializableCollection.SaveIfChanged;
var
  Writer: TBinaryWriter;
  Size: LongWord;
begin
  if FHandle = INVALID_HANDLE_VALUE then
    RaiseError(SErrNoFileOpenedForWrite);
  if FChanged then
  begin
    Writer := TBinaryWriter.Create(FFileSize);
    Save(Writer);
    SetFilePointer(FHandle, 0, nil, FILE_BEGIN);
    Inc(FFileVersion);
    if not WriteFile(FHandle, FFileVersion, 4, Size, nil) or (Size <> 4) then
      RaiseError(SErrFileWriteError);
    if not Writer.SaveToFile(FHandle, FEncryptionKey, FCompressionMode) then
      RaiseError(SErrFileWriteError);
    Writer.Free;
    SetEndOfFile(FHandle);
    FChanged := False;
  end;
end;

procedure TSerializableCollection.UndoIfChanged;
var
  Reader: TBinaryReader;
begin
  if FHandle = INVALID_HANDLE_VALUE then
    RaiseError(SErrNoFileOpenedForWrite);
  if FChanged then
  begin
    if FFileSize < 16 then
      Clear
    else
    begin
      SetFilePointer(FHandle, 4, nil, FILE_BEGIN);
      Reader := TBinaryReader.Create;
      if not Reader.LoadFromFile(FHandle, FEncryptionKey) then
        RaiseError(SErrFileRereadError);
      Load(Reader);
      if Reader.Position <> Reader.Length then
        RaiseError(SErrRereadNotComplete);
      Reader.Free;
    end;
  end;
end;

procedure TSerializableCollection.CloseFile;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    FEncryptionKey := nil;
  end;
end;

function IntAscIndexOf(ID: Integer; Items: PSerializableObjectList; Count: Integer): Integer;
var
  L, H, I: Integer;
begin
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    if Items^[I].FID < ID then
      L := I + 1
    else
      H := I - 1;
  end;
  Result := L;
end;

function IntDescIndexOf(ID: Integer; Items: PSerializableObjectList; Count: Integer): Integer;
var
  L, H, I: Integer;
begin
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    if Items^[I].FID > ID then
      L := I + 1
    else
      H := I - 1;
  end;
  Result := L;
end;

function TSerializableCollection.NewItem: TSerializableObject;
begin
  Result := FItemClassType.Create;
  Dec(FLastAddedTempID);
  Result.FID := FLastAddedTempID;
end;

function TSerializableCollection.BeginEdit(ID: Integer): TSerializableObject;
var
  I: Integer;
begin
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    Result := FInsertedItems^[I];
    if Result.FID = ID then
    begin
      Result := Result.Clone;
      Exit;
    end;
  end;
  Result := Search(ID);
  if Result <> nil then
    Result := Result.Clone;
end;

procedure TSerializableCollection.CancelEdit(SO: TSerializableObject);
begin
  SO.Free;
end;

procedure TSerializableCollection.EndEdit(SO: TSerializableObject);
var
  InsI, DelI, ID: Integer;
  O: TSerializableObject;
begin
  ID := SO.FID;
  InsI := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if InsI < FInsertedCount then
  begin
    O := FInsertedItems^[InsI];
    if O.FID = ID then
    begin
      FInsertedItems^[InsI] := SO;
      O.Free;
      Exit;
    end;
  end;
  if ID > 0 then
  begin
    DelI := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
    if (DelI >= FDeletedCount) or (FDeletedItems^[DelI].FID <> ID) then
    begin
      O := Search(ID);
      if O <> nil then
      begin
        if FDeletedCapacity = FDeletedCount then
          GrowDeletedCapacity;
        if DelI < FDeletedCount then
          G_MoveLongs(@FDeletedItems^[DelI], @FDeletedItems^[DelI + 1], FDeletedCount - DelI);
        FDeletedItems^[DelI] := O.Clone;
        Inc(FDeletedCount);
      end;
    end;
  end;
  if FInsertedCapacity = FInsertedCount then
    GrowInsertedCapacity;
  if InsI < FInsertedCount then
    G_MoveLongs(@FInsertedItems^[InsI], @FInsertedItems^[InsI + 1], FInsertedCount - InsI);
  FInsertedItems^[InsI] := SO;
  Inc(FInsertedCount);
end;

procedure TSerializableCollection.Delete(ID: Integer);
var
  I: Integer;
  O: TSerializableObject;
begin
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    O := FInsertedItems^[I];
    if O.FID = ID then
    begin
      Dec(FInsertedCount);
      if I < FInsertedCount then
        G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I);
      O.Free;
    end;
  end;
  if ID > 0 then
  begin
    I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
    if (I < FDeletedCount) and (FDeletedItems^[I].FID = ID) then
      Exit;
    O := Search(ID);
    if O = nil then
      Exit;
    if FDeletedCapacity = FDeletedCount then
      GrowDeletedCapacity;
    if I < FDeletedCount then
      G_MoveLongs(@FDeletedItems^[I], @FDeletedItems^[I + 1], FDeletedCount - I);
    FDeletedItems^[I] := O.Clone;
    Inc(FDeletedCount);
  end;
end;

function TSerializableCollection.EndEditDirect(SO: TSerializableObject): Boolean;
var
  ID, I, P: Integer;
  O: TSerializableObject;
  X, HashSize, HashStep: LongWord;
  DataIndex: TDataIndex;
begin
  for I := FIndexCount - 1 downto 0 do
    if not FIndices^[I].CanInsert(SO) then
    begin
      SO.Free;
      Result := False;
      Exit;
    end;
  Result := True;
  ID := SO.FID;
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    O := FInsertedItems^[I];
    if O.FID = ID then
    begin
      Dec(FInsertedCount);
      if I < FInsertedCount then
        G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I);
      O.Free;
    end;
  end;
  if ID > 0 then
  begin
    I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
    if I < FDeletedCount then
    begin
      O := FDeletedItems^[I];
      if O.FID = ID then
      begin
        Dec(FDeletedCount);
        if I < FDeletedCount then
          G_MoveLongs(@FDeletedItems^[I + 1], @FDeletedItems^[I], FDeletedCount - I);
        O.Free;
      end;
    end;
  end;
  P := IntAscIndexOf(ID, FItems, FCount);
  if (P < FCount) and (FItems^[P].FID = ID) then
  begin
    O := FItems^[P];
    if FHash <> nil then
    begin
      X := LongWord(ID);
      HashSize := LongWord(FHashCapacity);
      HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
      while True do
      begin
        X := X mod HashSize;
        if FHash^[X] = O then
        begin
          FHash^[X] := SO;
          Break;
        end;
        Inc(X, HashStep);
      end;
    end;
    FItems^[P] := SO;
    for I := FIndexCount - 1 downto 0 do
    begin
      DataIndex := FIndices^[I];
      if DataIndex.FActive then
      begin
        DataIndex.Delete(O);
        Dec(FCount);
        DataIndex.Insert(SO);
        Inc(FCount);
      end;
    end;
    if Assigned(FOnItemChanged) then
      FOnItemChanged(Self, SO, O);
    O.Free;
  end else
  begin
    if ID < 0 then
    begin
      SO.FID := GenerateID;
      if Assigned(FOnItemIDChanged) then
        FOnItemIDChanged(Self, SO, ID);
    end;
    if FHash <> nil then
    begin
      if FHashUsedCount < FHashMaxCount then
      begin
        X := LongWord(SO.FID);
        HashSize := LongWord(FHashCapacity);
        HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
        while True do
        begin
          X := X mod HashSize;
          if FHash^[X] = nil then
          begin
            FHash^[X] := SO;
            Inc(FHashUsedCount);
            Break;
          end;
          if FHash^[X] = EmptyObject then
          begin
            FHash^[X] := SO;
            Break;
          end;
          Inc(X, HashStep);
        end;
      end	else
      begin
        if FCount + FCount > FHashUsedCount then
          I := G_EnlargePrimeCapacity(FHashCapacity)
        else
          I := FHashCapacity;
        SetHashCapacity(I);
        PutInHash(SO);
        Inc(FHashUsedCount);
      end;
    end;
    if FCount >= FCapacity then
      SetCapacity(G_EnlargeCapacity(FCapacity));
    I := IntAscIndexOf(SO.FID, FItems, FCount);
    if I < FCount then
      G_MoveLongs(@FItems^[I], @FItems^[I + 1], FCount - I);
    FItems^[I] := SO;
    for I := FIndexCount - 1 downto 0 do
    begin
      DataIndex := FIndices^[I];
      if DataIndex.FActive then
        DataIndex.Insert(SO);
    end;
    Inc(FCount);
    if Assigned(FOnItemInserted) then
      FOnItemInserted(Self, SO);
  end;
  FChanged := True;
end;

procedure TSerializableCollection.DeleteDirect(ID: Integer);
var
  I, P: Integer;
  O: TSerializableObject;
  X, HashSize, HashStep: LongWord;
  DataIndex: TDataIndex;
begin
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    O := FInsertedItems^[I];
    if O.FID = ID then
    begin
      Dec(FInsertedCount);
      if I < FInsertedCount then
        G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I);
      O.Free;
    end;
  end;
  if ID > 0 then
  begin
    I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
    if I < FDeletedCount then
    begin
      O := FDeletedItems^[I];
      if O.FID = ID then
      begin
        Dec(FDeletedCount);
        if I < FDeletedCount then
          G_MoveLongs(@FDeletedItems^[I + 1], @FDeletedItems^[I], FDeletedCount - I);
        O.Free;
      end;
    end;
  end;
  P := IntAscIndexOf(ID, FItems, FCount);
  if P < FCount then
  begin
    O := FItems^[P];
    if O.FID = ID then
    begin
      if FHash <> nil then
      begin
        X := LongWord(ID);
        HashSize := LongWord(FHashCapacity);
        HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
        while True do
        begin
          X := X mod HashSize;
          if FHash^[X] = O then
          begin
            FHash^[X] := EmptyObject;
            Break;
          end;
          Inc(X, HashStep);
        end;
      end;
      for I := FIndexCount - 1 downto 0 do
      begin
        DataIndex := FIndices^[I];
        if DataIndex.FActive then
          DataIndex.Delete(O);
      end;
      Dec(FCount);
      if P < FCount then
        G_MoveLongs(@FItems^[P + 1], @FItems^[P], FCount - P);
      if Assigned(FOnItemDeleted) then
        FOnItemDeleted(Self, O);
      O.Free;
      FChanged := True;
    end;
  end;
end;

function TSerializableCollection.ApplyChanges: TAppChangesResult;
var
  ToDel, ToIns: TSerializableObject;
  I: Integer;
begin
  Result := appChangesOk;
  while FDeletedCount > 0 do
  begin
    Dec(FDeletedCount);
    ToDel := FDeletedItems^[FDeletedCount];
    I := IntDescIndexOf(ToDel.FID, FInsertedItems, FInsertedCount);
    if I < FInsertedCount then
    begin
      ToIns := FInsertedItems^[I];
      if ToIns.FID = ToDel.FID then
      begin
        Dec(FInsertedCount);
        if I < FInsertedCount then
          G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I)
      end else
        ToIns := nil;
    end else
      ToIns := nil;
    Result := InternalApplyChanges(ToIns, ToDel);
    if Result <> appChangesOk then
    begin
      RejectChanges;
      Exit;
    end;
  end;
  while FInsertedCount > 0 do
  begin
    Dec(FInsertedCount);
    Result := InternalApplyChanges(FInsertedItems^[FInsertedCount], nil);
    if Result <> appChangesOk then
    begin
      RejectChanges;
      Exit;
    end;
  end;
end;

function TSerializableCollection.ApplyChanges(ID: Integer): TAppChangesResult;
var
  I: Integer;
  ToIns, ToDel: TSerializableObject;
begin
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    ToIns := FInsertedItems^[I];
    if ToIns.FID = ID then
    begin
      Dec(FInsertedCount);
      if I < FInsertedCount then
        G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I)
    end else
      ToIns := nil;
  end else
    ToIns := nil;
  I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
  if I < FDeletedCount then
  begin
    ToDel := FDeletedItems^[I];
    if ToDel.FID = ID then
    begin
      Dec(FDeletedCount);
      if I < FDeletedCount then
        G_MoveLongs(@FDeletedItems^[I + 1], @FDeletedItems^[I], FDeletedCount - I)
    end else
      ToDel := nil;
  end else
    ToDel := nil;
  if (ToIns <> nil) or (ToDel <> nil) then
    Result := InternalApplyChanges(ToIns, ToDel)
  else
    Result := appChangesOk;
end;

function TSerializableCollection.InternalApplyChanges(ToIns, ToDel:
  TSerializableObject): TAppChangesResult;
var
  I, DelPos: Integer;
  DataIndex: TDataIndex;
  X, HashSize, HashStep: LongWord;
begin
  DelPos := 0;
  if ToDel <> nil then
  begin
    DelPos := IndexOf(ToDel.FID);
    if DelPos >= 0 then
    begin
      if not FItems^[DelPos].Equals(ToDel) then
      begin
        ToDel.Free;
        if ToIns <> nil then
          ToIns.Free;
        Result := appChangesOriginalObjectChanged;
        Exit;
      end;
      ToDel.Free;
      ToDel := FItems^[DelPos];
      if ToIns = nil then
      begin
        if FHash <> nil then
        begin
          X := LongWord(ToDel.FID);
          HashSize := LongWord(FHashCapacity);
          HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
          while True do
          begin
            X := X mod HashSize;
            if FHash^[X] = ToDel then
            begin
              FHash^[X] := EmptyObject;
              Break;
            end;
            Inc(X, HashStep);
          end;
        end;
        for I := FIndexCount - 1 downto 0 do
        begin
          DataIndex := FIndices^[I];
          if DataIndex.FActive then
            DataIndex.Delete(ToDel);
        end;
        Dec(FCount);
        if DelPos < FCount then
          G_MoveLongs(@FItems^[DelPos + 1], @FItems^[DelPos], FCount - DelPos);
        if Assigned(FOnItemDeleted) then
          FOnItemDeleted(Self, ToDel);
        ToDel.Free;
      end;
    end else
    begin
      ToDel.Free;
      ToDel := nil;
    end;
  end;
  if ToIns <> nil then
  begin
    for I := FIndexCount - 1 downto 0 do
      if not FIndices^[I].CanInsert(ToIns) then
      begin
        ToIns.Free;
        Result := appChangesUniqueIndexViolation;
        Exit;
      end;
    if ToDel <> nil then
    begin
      if FHash <> nil then
      begin
        X := LongWord(ToDel.FID);
        HashSize := LongWord(FHashCapacity);
        HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
        while True do
        begin
          X := X mod HashSize;
          if FHash^[X] = ToDel then
          begin
            FHash^[X] := ToIns;
            Break;
          end;
          Inc(X, HashStep);
        end;
      end;
      FItems^[DelPos] := ToIns;
      for I := FIndexCount - 1 downto 0 do
      begin
        DataIndex := FIndices^[I];
        if DataIndex.FActive then
        begin
          DataIndex.Delete(ToDel);
          Dec(FCount);
          DataIndex.Insert(ToIns);
          Inc(FCount);
        end;
      end;
      if Assigned(FOnItemChanged) then
        FOnItemChanged(Self, ToIns, ToDel);
      ToDel.Free;
    end else
    begin
      if ToIns.FID < 0 then
      begin
        I := ToIns.FID;
        ToIns.FID := GenerateID;
        if Assigned(FOnItemIDChanged) then
          FOnItemIDChanged(Self, ToIns, I);
      end;
      if FHash <> nil then
      begin
        if FHashUsedCount < FHashMaxCount then
        begin
          X := LongWord(ToIns.FID);
          HashSize := LongWord(FHashCapacity);
          HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
          while True do
          begin
            X := X mod HashSize;
            if FHash^[X] = nil then
            begin
              FHash^[X] := ToIns;
              Inc(FHashUsedCount);
              Break;
            end;
            if FHash^[X] = EmptyObject then
            begin
              FHash^[X] := ToIns;
              Break;
            end;
            Inc(X, HashStep);
          end;
        end else
        begin
          if FCount + FCount > FHashUsedCount then
            I := G_EnlargePrimeCapacity(FHashCapacity)
          else
            I := FHashCapacity;
          SetHashCapacity(I);
          PutInHash(ToIns);
          Inc(FHashUsedCount);
        end;
      end;
      if FCount >= FCapacity then
        SetCapacity(G_EnlargeCapacity(FCapacity));
      I := IntAscIndexOf(ToIns.FID, FItems, FCount);
      if I < FCount then
        G_MoveLongs(@FItems^[I], @FItems^[I + 1], FCount - I);
      FItems^[I] := ToIns;
      for I := FIndexCount - 1 downto 0 do
      begin
        DataIndex := FIndices^[I];
        if DataIndex.FActive then
          DataIndex.Insert(ToIns);
      end;
      Inc(FCount);
      if Assigned(FOnItemInserted) then
        FOnItemInserted(Self, ToIns);
    end;
  end;
  Result := appChangesOk;
  FChanged := True;
end;

procedure TSerializableCollection.RejectChanges;
var
  I: Integer;
begin
  FLastAddedTempID := 0;
  for I := FInsertedCount - 1 downto 0 do
    FInsertedItems^[I].Free;
  FInsertedCount := 0;
  for I := FDeletedCount - 1 downto 0 do
    FDeletedItems^[I].Free;
  FDeletedCount := 0;
end;

procedure TSerializableCollection.RejectChanges(ID: Integer);
var
  I: Integer;
  O: TSerializableObject;
begin
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if I < FInsertedCount then
  begin
    O := FInsertedItems^[I];
    if O.FID = ID then
    begin
      Dec(FInsertedCount);
      if I < FInsertedCount then
        G_MoveLongs(@FInsertedItems^[I + 1], @FInsertedItems^[I], FInsertedCount - I);
      O.Free;
    end;
  end;
  I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
  if I < FDeletedCount then
  begin
    O := FDeletedItems^[I];
    if O.FID = ID then
    begin
      Dec(FDeletedCount);
      if I < FDeletedCount then
        G_MoveLongs(@FDeletedItems^[I + 1], @FDeletedItems^[I], FDeletedCount - I);
      O.Free;
    end;
  end;
end;

function TSerializableCollection.HasChanges: Boolean;
begin
  Result := (FInsertedCount + FDeletedCount) > 0;
end;

function TSerializableCollection.HasChanges(ID: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  I := IntDescIndexOf(ID, FInsertedItems, FInsertedCount);
  if (I < FInsertedCount) and (FInsertedItems^[I].FID = ID) then
    Exit;
  I := IntDescIndexOf(ID, FDeletedItems, FDeletedCount);
  if (I < FDeletedCount) and (FDeletedItems^[I].FID = ID) then
    Exit;
  Result := False;
end;

function TSerializableCollection.ScanPointer(SO: TSerializableObject): Integer;
begin
  Result := G_Scan_Pointer(SO, FItems, FCount);
end;

function TSerializableCollection.Search(ID: Integer): TSerializableObject;
var
  X, HashSize, HashStep: LongWord;
  I: Integer;
begin
  if FHash <> nil then
  begin
    X := LongWord(ID);
    HashSize := LongWord(FHashCapacity);
    HashStep := (((X shr 5) + 1) mod (HashSize - 1)) + 1;
    while True do
    begin
      X := X mod HashSize;
      if FHash^[X] = nil then
        Break;
      if FHash^[X].FID = ID then
      begin
        Result := FHash^[X];
        Exit;
      end;
      Inc(X, HashStep);
    end;
    Result := nil;
  end else
  begin
    I := IntAscIndexOf(ID, FItems, FCount);
    if I < FCount then
    begin
      Result := FItems^[I];
      if Result.FID <> ID then
        Result := nil;
    end else
      Result := nil;
  end;
end;

function TSerializableCollection.IndexOf(ID: Integer): Integer;
begin
  Result := IntAscIndexOf(ID, FItems, FCount);
  if (Result >= FCount) or (FItems^[Result].FID <> ID) then
    Result := -1;
end;

{ TFakePrimaryKeyCollection }

procedure TFakePrimaryKeyCollection.LoadExtra(Reader: TBinaryReader; Version: Integer);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    FItems^[I].FID := I + 1;
  FMaxAddedID := FCount;
end;

procedure TFakePrimaryKeyCollection.SaveExtra(Writer: TBinaryWriter);
begin
end;

{ TBytePrimaryKeyCollection }

function TBytePrimaryKeyCollection.GenerateID: Integer;
var
  I: Integer;
begin
  if FMaxAddedID < $FF then
  begin
    Inc(FMaxAddedID);
    Result := FMaxAddedID;
  end
  else if FCount < $FF then
  begin
    I := 0;
    while (I < FCount) and (TSerializableObject(FItems^[I]).FID = I + 1) do
      Inc(I);
    Result := I + 1;
  end else
  begin
    RaiseError(SErrNoMoreAvailableID);
    Result := 0;
  end;
end;

procedure TBytePrimaryKeyCollection.LoadExtra(Reader: TBinaryReader;
  Version: Integer);
begin
  FMaxAddedID := Reader.ReadByte;
end;

procedure TBytePrimaryKeyCollection.SaveExtra(Writer: TBinaryWriter);
begin
  Writer.WriteByte(Byte(FMaxAddedID));
end;

{ TWordPrimaryKeyCollection }

function TWordPrimaryKeyCollection.GenerateID: Integer;
var
  I: Integer;
begin
  if FMaxAddedID < $FFFF then
  begin
    Inc(FMaxAddedID);
    Result := FMaxAddedID;
  end
  else if FCount < $FFFF then
  begin
    I := 0;
    while (I < FCount) and (TSerializableObject(FItems^[I]).FID = I + 1) do
      Inc(I);
    Result := I + 1;
  end else
  begin
    RaiseError(SErrNoMoreAvailableID);
    Result := 0;
  end;
end;

procedure TWordPrimaryKeyCollection.LoadExtra(Reader: TBinaryReader;
  Version: Integer);
begin
  FMaxAddedID := Reader.ReadWord;
end;

procedure TWordPrimaryKeyCollection.SaveExtra(Writer: TBinaryWriter);
begin
  Writer.WriteWord(Word(FMaxAddedID));
end;

{ TDataIndex }

destructor TDataIndex.Destroy;
begin
  if FItems <> nil then
    FreeMem(FItems);
end;

procedure TDataIndex.SetCapacity(OldCapacity, NewCapacity, Count: Integer);
var
  NewItems: PSerializableObjectList;
begin
  if FActive then
  begin
    if NewCapacity > 0 then
    begin
      GetMem(NewItems, NewCapacity * SizeOf(Pointer));
      if Count > 0 then
        G_CopyLongs(FItems, NewItems, Count);
    end else
      NewItems := nil;
    if OldCapacity > 0 then
      FreeMem(FItems);
    FItems := NewItems;
  end;
end;

function TDataIndex.GetItemList: PSerializableObjectList;
begin
  if not FActive then
    Activate;
  Result := FItems;
end;

procedure TDataIndex.SetActive(V: Boolean);
begin
  if V then
  begin
    if not FActive then
      Activate;
  end else
  begin
    if FItems <> nil then
    begin
      FreeMem(FItems);
      FItems := nil;
    end;
    FActive := False;
  end;
end;

procedure TDataIndex.Activate;
begin
  if FOwner.FCapacity > 0 then
  begin
    GetMem(FItems, FOwner.FCapacity * SizeOf(Pointer));
    if FOwner.FCount > 0 then
    begin
      G_CopyLongs(FOwner.FItems, FItems, FOwner.FCount);
      SortItems;
    end;
  end;
  FActive := True;
end;

procedure TDataIndex.SetDescending(V: Boolean);
begin
  if FDescending <> V then
  begin
    if FActive and (FOwner.FCount > 1) then
      G_ReverseLongs(FItems, FOwner.FCount);
    FDescending := V;
  end;
end;

procedure TDataIndex.Delete(SO: TSerializableObject);
var
  I, C: Integer;
begin
  C := FOwner.FCount;
  I := G_Scan_Pointer(SO, FItems, C);
  Dec(C);
  if I < C then
    G_MoveLongs(@FItems^[I + 1], @FItems^[I], C - I)
end;

procedure TDataIndex.UpdateItems;
begin
  if FActive then
  begin
    G_CopyLongs(FOwner.FItems, FItems, FOwner.FCount);
    SortItems;
  end;
end;

function TDataIndex.ScanPointer(SO: TSerializableObject): Integer;
begin
  Result := G_Scan_Pointer(SO, FItems, FOwner.FCount);
end;

{ TStringIndex }

constructor TStringIndex.Create(KeyOf: TKeyOfFunction_String; Unique, CaseSensitive: Boolean);
begin
  FKeyOf := KeyOf;
  FCaseSensitive := CaseSensitive;
  FUnique := Unique;
end;

procedure TStringIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FCaseSensitive then
    begin
      if not FDescending then
        QuickSortTextAsc(0, L)
      else
        QuickSortTextDesc(0, L);
    end else
    begin
      if not FDescending then
        QuickSortStrAsc(0, L)
      else
        QuickSortStrDesc(0, L);
    end;
end;

procedure TStringIndex.QuickSortTextAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: string;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while G_CompareText(FKeyOf(FItems^[I]), P) < 0 do Inc(I);
    while G_CompareText(FKeyOf(FItems^[J]), P) > 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortTextAsc(L, J);
  if I < R then QuickSortTextAsc(I, R);
end;

procedure TStringIndex.QuickSortTextDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: string;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while G_CompareText(FKeyOf(FItems^[I]), P) > 0 do Inc(I);
    while G_CompareText(FKeyOf(FItems^[J]), P) < 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortTextDesc(L, J);
  if I < R then QuickSortTextDesc(I, R);
end;

procedure TStringIndex.QuickSortStrAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: string;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while G_CompareStr(FKeyOf(FItems^[I]), P) < 0 do Inc(I);
    while G_CompareStr(FKeyOf(FItems^[J]), P) > 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortStrAsc(L, J);
  if I < R then QuickSortStrAsc(I, R);
end;

procedure TStringIndex.QuickSortStrDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: string;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while G_CompareStr(FKeyOf(FItems^[I]), P) > 0 do Inc(I);
    while G_CompareStr(FKeyOf(FItems^[J]), P) < 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortStrDesc(L, J);
  if I < R then QuickSortStrDesc(I, R);
end;

function TStringIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: string;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    if not FCaseSensitive then
    begin
      for I := FOwner.Count - 1 downto 0 do
        if G_SameText(FKeyOf(Items^[I]), Key) then
        begin
          Result := Items^[I].FID = SO.FID;
          Break;
        end;
    end else
    begin
      for I := FOwner.Count - 1 downto 0 do
        if G_SameStr(FKeyOf(Items^[I]), Key) then
        begin
          Result := Items^[I].FID = SO.FID;
          Break;
        end;
    end;
  end;
end;

procedure TStringIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: string;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FCaseSensitive then
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareText(FKeyOf(FItems^[I]), Key) < 0 then
          L := I + 1
        else
          H := I - 1;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareText(FKeyOf(FItems^[I]), Key) > 0 then
          L := I + 1
        else
          H := I - 1;
      end;
  end else
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStr(FKeyOf(FItems^[I]), Key) < 0 then
          L := I + 1
        else
          H := I - 1;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStr(FKeyOf(FItems^[I]), Key) > 0 then
          L := I + 1
        else
          H := I - 1;
      end;
  end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TStringIndex.Clone: TDataIndex;
begin
  Result := TStringIndex.Create(FKeyOf, FUnique, FCaseSensitive);
end;

function TStringIndex.Compare(SO1, SO2: TSerializableObject): Integer;
begin
  if not FCaseSensitive then
  begin
    if not FDescending then
      Result := G_CompareText(FKeyOf(SO1), FKeyOf(SO2))
    else
      Result := -G_CompareText(FKeyOf(SO1), FKeyOf(SO2));
  end else
  begin
    if not FDescending then
      Result := G_CompareStr(FKeyOf(SO1), FKeyOf(SO2))
    else
      Result := -G_CompareStr(FKeyOf(SO1), FKeyOf(SO2));
  end;
end;

function TStringIndex.Contains(const Key: string): Boolean;
var
  L, H, C, I: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FCaseSensitive then
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C <= 0 then
        begin
          if C = 0 then
          begin
            Result := True;
            Exit;
          end;
          L := I + 1;
        end else
          H := I - 1;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C >= 0 then
        begin
          if C = 0 then
          begin
            Result := True;
            Exit;
          end;
          L := I + 1;
        end else
          H := I - 1;
      end;
  end else
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C <= 0 then
        begin
          if C = 0 then
          begin
            Result := True;
            Exit;
          end;
          L := I + 1;
        end else
          H := I - 1;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C >= 0 then
        begin
          if C = 0 then
          begin
            Result := True;
            Exit;
          end;
          L := I + 1;
        end else
          H := I - 1;
      end;
  end;
  Result := False;
end;

function TStringIndex.Search(const Key: string): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TStringIndex.IndexOf(const Key: string): Integer;
var
  L, H, C, I: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FCaseSensitive then
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C < 0 then
          L := I + 1
        else
        begin
          if C = 0 then
          begin
            Result := I;
            if FUnique then
              Exit;
          end;
          H := I - 1;
        end;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C > 0 then
          L := I + 1
        else
        begin
          if C = 0 then
          begin
            Result := I;
            if FUnique then
              Exit;
          end;
          H := I - 1;
        end;
      end;
  end else
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C < 0 then
          L := I + 1
        else
        begin
          if C = 0 then
          begin
            Result := I;
            if FUnique then
              Exit;
          end;
          H := I - 1;
        end;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C > 0 then
          L := I + 1
        else
        begin
          if C = 0 then
          begin
            Result := I;
            if FUnique then
              Exit;
          end;
          H := I - 1;
        end;
      end;
  end;
end;

function TStringIndex.SelectRange(const Key1, Key2: string; var Index: Integer): Integer;
var
  L, H, C, I: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FCaseSensitive then
  begin
    if not FDescending then
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key1);
        if C < 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareText(FKeyOf(FItems^[I]), Key2) >= 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end else
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key1);
        if C > 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareText(FKeyOf(FItems^[I]), Key2) <= 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end;
  end else
  begin
    if not FDescending then
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key1);
        if C < 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStr(FKeyOf(FItems^[I]), Key2) >= 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end else
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key1);
        if C > 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStr(FKeyOf(FItems^[I]), Key2) <= 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end;
  end;
  Result := H - Index + 1;
end;

function TStringIndex.SelectRange(const Key: string): Integer;
var
  L, H, C, I: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FCaseSensitive then
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C < 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareText(FKeyOf(FItems^[I]), Key);
        if C > 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
  end else
  begin
    if not FDescending then
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C < 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end
    else
      while L <= H do
      begin
        I := (L + H) shr 1;
        C := G_CompareStr(FKeyOf(FItems^[I]), Key);
        if C > 0 then
          L := I + 1
        else
        begin
          if (C = 0) and FUnique then
          begin
            L := I;
            Break;
          end;
          H := I - 1;
        end;
      end;
  end;
  Result := L;
end;

function TStringIndex.StartsWith(const S: string; var Index: Integer): Integer;
var
  L, H, I, X: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  X := Length(S);
  if not FCaseSensitive then
  begin
    if not FDescending then
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareTextL(FKeyOf(FItems^[I]), S, X) < 0 then
          L := I + 1
        else
          H := I - 1;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareTextL(FKeyOf(FItems^[I]), S, X) > 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end else
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareTextL(FKeyOf(FItems^[I]), S, X) > 0 then
          L := I + 1
        else
          H := I - 1;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareTextL(FKeyOf(FItems^[I]), S, X) < 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end;
  end else
  begin
    if not FDescending then
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStrL(FKeyOf(FItems^[I]), S, X) < 0 then
          L := I + 1
        else
          H := I - 1;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStrL(FKeyOf(FItems^[I]), S, X) > 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end else
    begin
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStrL(FKeyOf(FItems^[I]), S, X) > 0 then
          L := I + 1
        else
          H := I - 1;
      end;
      Index := L;
      H := FOwner.FCount - 1;
      while L <= H do
      begin
        I := (L + H) shr 1;
        if G_CompareStrL(FKeyOf(FItems^[I]), S, X) < 0 then
          H := I - 1
        else
          L := I + 1;
      end;
    end;
  end;
  Result := H - Index + 1;
end;

{ TShortIntIndex }

constructor TShortIntIndex.Create(KeyOf: TKeyOfFunction_ShortInt; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TShortIntIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TShortIntIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: ShortInt;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TShortIntIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: ShortInt;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TShortIntIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: ShortInt;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TShortIntIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: ShortInt;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TShortIntIndex.Clone: TDataIndex;
begin
  Result := TShortIntIndex.Create(FKeyOf, FUnique);
end;

function TShortIntIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: ShortInt;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TShortIntIndex.Contains(Key: ShortInt): Boolean;
var
  L, H, I: Integer;
  C: ShortInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TShortIntIndex.Search(Key: ShortInt): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TShortIntIndex.IndexOf(Key: ShortInt): Integer;
var
  L, H, I: Integer;
  C: ShortInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TShortIntIndex.SelectRange(Key1, Key2: ShortInt; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: ShortInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TShortIntIndex.SelectRange(Key: ShortInt): Integer;
var
  L, H, I: Integer;
  C: ShortInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TByteIndex }

constructor TByteIndex.Create(KeyOf: TKeyOfFunction_Byte; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TByteIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TByteIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Byte;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TByteIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Byte;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TByteIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Byte;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TByteIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Byte;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TByteIndex.Clone: TDataIndex;
begin
  Result := TByteIndex.Create(FKeyOf, FUnique);
end;

function TByteIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Byte;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TByteIndex.Contains(Key: Byte): Boolean;
var
  L, H, I: Integer;
  C: Byte;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TByteIndex.Search(Key: Byte): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TByteIndex.IndexOf(Key: Byte): Integer;
var
  L, H, I: Integer;
  C: Byte;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TByteIndex.SelectRange(Key1, Key2: Byte; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Byte;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TByteIndex.SelectRange(Key: Byte): Integer;
var
  L, H, I: Integer;
  C: Byte;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TSmallIntIndex }

constructor TSmallIntIndex.Create(KeyOf: TKeyOfFunction_SmallInt; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TSmallIntIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TSmallIntIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: SmallInt;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TSmallIntIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: SmallInt;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TSmallIntIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: SmallInt;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TSmallIntIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: SmallInt;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TSmallIntIndex.Clone: TDataIndex;
begin
  Result := TSmallIntIndex.Create(FKeyOf, FUnique);
end;

function TSmallIntIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: SmallInt;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TSmallIntIndex.Contains(Key: SmallInt): Boolean;
var
  L, H, I: Integer;
  C: SmallInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TSmallIntIndex.Search(Key: SmallInt): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TSmallIntIndex.IndexOf(Key: SmallInt): Integer;
var
  L, H, I: Integer;
  C: SmallInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TSmallIntIndex.SelectRange(Key1, Key2: SmallInt; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: SmallInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TSmallIntIndex.SelectRange(Key: SmallInt): Integer;
var
  L, H, I: Integer;
  C: SmallInt;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TWordIndex }

constructor TWordIndex.Create(KeyOf: TKeyOfFunction_Word; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TWordIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TWordIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Word;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TWordIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Word;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TWordIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Word;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TWordIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Word;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TWordIndex.Clone: TDataIndex;
begin
  Result := TWordIndex.Create(FKeyOf, FUnique);
end;

function TWordIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Word;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TWordIndex.Contains(Key: Word): Boolean;
var
  L, H, I: Integer;
  C: Word;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TWordIndex.Search(Key: Word): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TWordIndex.IndexOf(Key: Word): Integer;
var
  L, H, I: Integer;
  C: Word;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TWordIndex.SelectRange(Key1, Key2: Word; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Word;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TWordIndex.SelectRange(Key: Word): Integer;
var
  L, H, I: Integer;
  C: Word;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TIntegerIndex }

constructor TIntegerIndex.Create(KeyOf: TKeyOfFunction_Integer; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TIntegerIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TIntegerIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Integer;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TIntegerIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Integer;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TIntegerIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Integer;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TIntegerIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Integer;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TIntegerIndex.Clone: TDataIndex;
begin
  Result := TIntegerIndex.Create(FKeyOf, FUnique);
end;

function TIntegerIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Integer;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TIntegerIndex.Contains(Key: Integer): Boolean;
var
  L, H, I: Integer;
  C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TIntegerIndex.Search(Key: Integer): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TIntegerIndex.IndexOf(Key: Integer): Integer;
var
  L, H, I: Integer;
  C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TIntegerIndex.SelectRange(Key1, Key2: Integer; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TIntegerIndex.SelectRange(Key: Integer): Integer;
var
  L, H, I: Integer;
  C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TLongWordIndex }

constructor TLongWordIndex.Create(KeyOf: TKeyOfFunction_LongWord; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TLongWordIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TLongWordIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: LongWord;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TLongWordIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: LongWord;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TLongWordIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: LongWord;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TLongWordIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: LongWord;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TLongWordIndex.Clone: TDataIndex;
begin
  Result := TLongWordIndex.Create(FKeyOf, FUnique);
end;

function TLongWordIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: LongWord;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TLongWordIndex.Contains(Key: LongWord): Boolean;
var
  L, H, I: Integer;
  C: LongWord;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TLongWordIndex.Search(Key: LongWord): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TLongWordIndex.IndexOf(Key: LongWord): Integer;
var
  L, H, I: Integer;
  C: LongWord;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TLongWordIndex.SelectRange(Key1, Key2: LongWord; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: LongWord;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TLongWordIndex.SelectRange(Key: LongWord): Integer;
var
  L, H, I: Integer;
  C: LongWord;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TInt64Index }

constructor TInt64Index.Create(KeyOf: TKeyOfFunction_Int64; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TInt64Index.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TInt64Index.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Int64;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TInt64Index.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Int64;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TInt64Index.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Int64;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TInt64Index.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Int64;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TInt64Index.Clone: TDataIndex;
begin
  Result := TInt64Index.Create(FKeyOf, FUnique);
end;

function TInt64Index.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Int64;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TInt64Index.Contains(const Key: Int64): Boolean;
var
  L, H, I: Integer;
  C: Int64;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TInt64Index.Search(const Key: Int64): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TInt64Index.IndexOf(const Key: Int64): Integer;
var
  L, H, I: Integer;
  C: Int64;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TInt64Index.SelectRange(const Key1, Key2: Int64; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Int64;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TInt64Index.SelectRange(const Key: Int64): Integer;
var
  L, H, I: Integer;
  C: Int64;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TDateTimeIndex }

constructor TDateTimeIndex.Create(KeyOf: TKeyOfFunction_DateTime; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TDateTimeIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TDateTimeIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: TDateTime;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TDateTimeIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: TDateTime;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TDateTimeIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: TDateTime;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TDateTimeIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: TDateTime;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TDateTimeIndex.Clone: TDataIndex;
begin
  Result := TDateTimeIndex.Create(FKeyOf, FUnique);
end;

function TDateTimeIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: TDateTime;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TDateTimeIndex.Contains(const Key: TDateTime): Boolean;
var
  L, H, I: Integer;
  C: TDateTime;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TDateTimeIndex.Search(const Key: TDateTime): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TDateTimeIndex.IndexOf(const Key: TDateTime): Integer;
var
  L, H, I: Integer;
  C: TDateTime;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TDateTimeIndex.SelectRange(const Key1, Key2: TDateTime; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: TDateTime;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TDateTimeIndex.SelectRange(const Key: TDateTime): Integer;
var
  L, H, I: Integer;
  C: TDateTime;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TSingleIndex }

constructor TSingleIndex.Create(KeyOf: TKeyOfFunction_Single; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TSingleIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TSingleIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Single;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TSingleIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Single;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TSingleIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Single;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TSingleIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Single;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TSingleIndex.Clone: TDataIndex;
begin
  Result := TSingleIndex.Create(FKeyOf, FUnique);
end;

function TSingleIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Single;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TSingleIndex.Contains(const Key: Single): Boolean;
var
  L, H, I: Integer;
  C: Single;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TSingleIndex.Search(const Key: Single): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TSingleIndex.IndexOf(const Key: Single): Integer;
var
  L, H, I: Integer;
  C: Single;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TSingleIndex.SelectRange(const Key1, Key2: Single; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Single;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TSingleIndex.SelectRange(const Key: Single): Integer;
var
  L, H, I: Integer;
  C: Single;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TDoubleIndex }

constructor TDoubleIndex.Create(KeyOf: TKeyOfFunction_Double; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TDoubleIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TDoubleIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Double;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TDoubleIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Double;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TDoubleIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Double;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TDoubleIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Double;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TDoubleIndex.Clone: TDataIndex;
begin
  Result := TDoubleIndex.Create(FKeyOf, FUnique);
end;

function TDoubleIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Double;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TDoubleIndex.Contains(const Key: Double): Boolean;
var
  L, H, I: Integer;
  C: Double;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TDoubleIndex.Search(const Key: Double): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TDoubleIndex.IndexOf(const Key: Double): Integer;
var
  L, H, I: Integer;
  C: Double;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TDoubleIndex.SelectRange(const Key1, Key2: Double; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Double;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TDoubleIndex.SelectRange(const Key: Double): Integer;
var
  L, H, I: Integer;
  C: Double;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TCurrencyIndex }

constructor TCurrencyIndex.Create(KeyOf: TKeyOfFunction_Currency; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TCurrencyIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TCurrencyIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Currency;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TCurrencyIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Currency;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TCurrencyIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Currency;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TCurrencyIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Currency;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TCurrencyIndex.Clone: TDataIndex;
begin
  Result := TCurrencyIndex.Create(FKeyOf, FUnique);
end;

function TCurrencyIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Currency;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TCurrencyIndex.Contains(const Key: Currency): Boolean;
var
  L, H, I: Integer;
  C: Currency;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TCurrencyIndex.Search(const Key: Currency): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TCurrencyIndex.IndexOf(const Key: Currency): Integer;
var
  L, H, I: Integer;
  C: Currency;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TCurrencyIndex.SelectRange(const Key1, Key2: Currency; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Currency;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TCurrencyIndex.SelectRange(const Key: Currency): Integer;
var
  L, H, I: Integer;
  C: Currency;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TCharIndex }

constructor TCharIndex.Create(KeyOf: TKeyOfFunction_Char; Unique: Boolean);
begin
  FKeyOf := KeyOf;
  FUnique := Unique;
end;

procedure TCharIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TCharIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Char;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) < P do Inc(I);
    while FKeyOf(FItems^[J]) > P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TCharIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  T: TSerializableObject;
  P: Char;
begin
  I := L;
  J := R;
  P := FKeyOf(FItems^[(I + J) shr 1]);
  repeat
    while FKeyOf(FItems^[I]) > P do Inc(I);
    while FKeyOf(FItems^[J]) < P do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TCharIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
  Key: Char;
begin
  Result := True;
  if not FUnique then
    Exit;
  Key := FKeyOf(SO);
  if FActive then
  begin
    I := IndexOf(Key);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FKeyOf(Items^[I]) = Key then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TCharIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
  Key: Char;
begin
  L := 0;
  H := FOwner.FCount - 1;
  Key := FKeyOf(SO);
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) < Key then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) > Key then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TCharIndex.Clone: TDataIndex;
begin
  Result := TCharIndex.Create(FKeyOf, FUnique);
end;

function TCharIndex.Compare(SO1, SO2: TSerializableObject): Integer;
var
  C1, C2: Char;
begin
  C1 := FKeyOf(SO1);
  C2 := FKeyOf(SO2);
  if not FDescending then
  begin
    if C1 < C2 then
      Result := -1
    else if C1 > C2 then
      Result := 1
    else
      Result := 0;
  end else
  begin
    if C1 < C2 then
      Result := 1
    else if C1 > C2 then
      Result := -1
    else
      Result := 0;
  end;
end;

function TCharIndex.Contains(Key: Char): Boolean;
var
  L, H, I: Integer;
  C: Char;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C <= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C >= Key then
      begin
        if C = Key then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TCharIndex.Search(Key: Char): TSerializableObject;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := FItems^[I]
  else
    Result := nil;
end;

function TCharIndex.IndexOf(Key: Char): Integer;
var
  L, H, I: Integer;
  C: Char;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if C = Key then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

function TCharIndex.SelectRange(Key1, Key2: Char; var Index: Integer): Integer;
var
  L, H, I: Integer;
  C: Char;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) >= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end else
  begin
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key1 then
        L := I + 1
      else
      begin
        if FUnique and (C = Key1) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
    Index := L;
    H := FOwner.FCount - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FKeyOf(FItems^[I]) <= Key2 then
        H := I - 1
      else
        L := I + 1;
    end;
  end;
  Result := H - Index + 1;
end;

function TCharIndex.SelectRange(Key: Char): Integer;
var
  L, H, I: Integer;
  C: Char;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C < Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FKeyOf(FItems^[I]);
      if C > Key then
        L := I + 1
      else
      begin
        if FUnique and (C = Key) then
        begin
          L := I;
          Break;
        end;
        H := I - 1;
      end;
    end;
  Result := L;
end;

{ TCompoundIndex }

constructor TCompoundIndex.Create(CompareFunction: TCompareObjectsFunction; Unique: Boolean);
begin
  FCompareFunction := CompareFunction;
  FUnique := Unique;
end;

procedure TCompoundIndex.SortItems;
var
  L: Integer;
begin
  L := FOwner.FCount - 1;
  if L > 0 then
    if not FDescending then
      QuickSortAsc(0, L)
    else
      QuickSortDesc(0, L);
end;

procedure TCompoundIndex.QuickSortAsc(L, R: Integer);
var
  I, J: Integer;
  P, T: TSerializableObject;
begin
  I := L;
  J := R;
  P := FItems^[(I + J) shr 1];
  repeat
    while FCompareFunction(FItems^[I], P) < 0 do Inc(I);
    while FCompareFunction(FItems^[J], P) > 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortAsc(L, J);
  if I < R then QuickSortAsc(I, R);
end;

procedure TCompoundIndex.QuickSortDesc(L, R: Integer);
var
  I, J: Integer;
  P, T: TSerializableObject;
begin
  I := L;
  J := R;
  P := FItems^[(I + J) shr 1];
  repeat
    while FCompareFunction(FItems^[I], P) > 0 do Inc(I);
    while FCompareFunction(FItems^[J], P) < 0 do Dec(J);
    if I <= J then
    begin
      T := FItems^[I];
      FItems^[I] := FItems^[J];
      FItems^[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSortDesc(L, J);
  if I < R then QuickSortDesc(I, R);
end;

function TCompoundIndex.CanInsert(SO: TSerializableObject): Boolean;
var
  Items: PSerializableObjectList;
  I: Integer;
begin
  Result := True;
  if not FUnique then
    Exit;
  if FActive then
  begin
    I := IndexOf(SO);
    if I >= 0 then
      Result := FItems^[I].FID = SO.FID;
  end else
  begin
    Items := FOwner.FItems;
    for I := FOwner.Count - 1 downto 0 do
      if FCompareFunction(Items^[I], SO) = 0 then
      begin
        Result := Items^[I].FID = SO.FID;
        Break;
      end;
  end;
end;

procedure TCompoundIndex.Insert(SO: TSerializableObject);
var
  L, H, I: Integer;
begin
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FCompareFunction(FItems^[I], SO) < 0 then
        L := I + 1
      else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      if FCompareFunction(FItems^[I], SO) > 0 then
        L := I + 1
      else
        H := I - 1;
    end;
  if L < FOwner.FCount then
    G_MoveLongs(@FItems^[L], @FItems^[L + 1], FOwner.FCount - L);
  FItems^[L] := SO;
end;

function TCompoundIndex.Clone: TDataIndex;
begin
  Result := TCompoundIndex.Create(FCompareFunction, FUnique);
end;

function TCompoundIndex.Compare(SO1, SO2: TSerializableObject): Integer;
begin
  if not FDescending then
    Result := FCompareFunction(SO1, SO2)
  else
    Result := -FCompareFunction(SO1, SO2);
end;

function TCompoundIndex.Contains(SO: TSerializableObject): Boolean;
var
  L, H, I, C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FCompareFunction(FItems^[I], SO);
      if C <= 0 then
      begin
        if C = 0 then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FCompareFunction(FItems^[I], SO);
      if C >= 0 then
      begin
        if C = 0 then
        begin
          Result := True;
          Exit;
        end;
        L := I + 1;
      end else
        H := I - 1;
    end;
  Result := False;
end;

function TCompoundIndex.IndexOf(SO: TSerializableObject): Integer;
var
  L, H, I, C: Integer;
begin
  if not FActive then
    Activate;
  L := 0;
  H := FOwner.FCount - 1;
  Result := -1;
  if not FDescending then
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FCompareFunction(FItems^[I], SO);
      if C < 0 then
        L := I + 1
      else
      begin
        if C = 0 then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end
  else
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := FCompareFunction(FItems^[I], SO);
      if C > 0 then
        L := I + 1
      else
      begin
        if C = 0 then
        begin
          Result := I;
          if FUnique then
            Exit;
        end;
        H := I - 1;
      end;
    end;
end;

initialization
  EmptyObject := TSerializableObject(G_AllocMem(8));

finalization
  if not IsMultiThread then
    FreeMem(Pointer(EmptyObject));

end.
