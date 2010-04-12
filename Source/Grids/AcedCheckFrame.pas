
///////////////////////////////////////////////////////
//                                                   //
//   AcedCheckFrame 1.09                             //
//                                                   //
//   Фрейм для просмотра, поиска и пометки данных,   //
//   представленных в виде таблицы.                  //
//                                                   //
//   mailto: acedutils@yandex.ru                     //
//                                                   //
///////////////////////////////////////////////////////

unit AcedCheckFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, AcedContainers, ExtCtrls, AcedGrids, AcedConsts;

{ Фрейм TCheckFrame отображает данные в виде таблицы из нескольких колонок
  с возможностью поиска в этой таблице подстрок, вводимых пользователем
  с клавиатуры. Отдельные записи могут помечаться галочкой.

  Некоторые записи являются неактивными (их пометку нельзя изменить).
  Текст в столбцах может быть выровнен по левому краю, по правому краю или
  по центру. Если текст не помещается в ячейке, он может переноситься по
  словам, а ячейка раздвигаться по высоте так, чтобы ее содержимое было
  видно полностью. Текст в каждой ячейке может выводиться своим цветом,
  который зависит от состояния данной строки (обычная, выделенная,
  выделенная неактивная).

  Над таблицей располагается поле ввода. Текст, набираемый пользователем
  появляется в этом поле и, одновременно, ищется по ячейкам таблицы. Если
  строка поиска начинается с символа '*', ищутся любые вхождения следующей
  далее подстроки в ячейках таблицы. Если в начале строки поиска этот символ
  отсутствует, ищутся ячейки, содержимое которых начинается с введенной
  строки. Чтобы после нахождения строки продолжить ее поиск, надо нажать
  Ctrl+L.

  Чтобы пометить текущую запись надо нажать клавишу пробел (для поиска
  символа пробел, его следует нажимать вместе с Ctrl), при нажатии клавиши
  '+' помечаются все записи, при нажатии клавиши '-' со всех записей
  снимается пометка, при нажатии '*' все помеченные записи становятся
  непомеченными и наоборот. }

type
  TCFDrawGrid = class(TDrawGrid)
  protected
    procedure ColWidthsChanged; override;
  end;

  TCheckFrame = class(TFrame)
    DesignRect: TShape;
  private
    FItemList: PStringItemList;
    FRowCount: Integer;
    FColumnInfo: PGridColumnList;
    FColumnCount: Integer;
    FChecks: TBitList;
    FDisabledItems: TBitList;
    FTimerWnd: HWND;
    FDelayedSelectPause: Cardinal;
    FDelayedRowIndex: Integer;
    FHintHidePause: Cardinal;
    FOnGetData: TGridGetDataEvent;
    FOnGetColor: TGridCellGetColorEvent;
    FOnSelectItem: TGridFrameEvent;
    FOnDelayedSelectItem: TGridFrameEvent;
    FOnDoubleClick: TGridFrameEvent;
    FOnKeyDown: TGridKeyDownEvent;
    FOnEnterFrame: TGridEnterExitEvent;
    FOnExitFrame: TGridEnterExitEvent;
    FCheckStateChanged: TCheckStateChangedEvent;
    FMDRowIndex: Integer;
    FSearchInProgress: Boolean;
    FInfoApp: Boolean;
    FTimerWork: Boolean;
    FInactiveSelection: Boolean;
    FSearchByColumns: Boolean;
    FTitleMultiline: Boolean;
    FMultiline: Boolean;
    FFlatChecks: Boolean;
    FSpaceBarPressed: Boolean;
    FMultiplyPressed: Boolean;
    FPlusPressed: Boolean;
    FMinusPressed: Boolean;

    procedure dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer; Rect: TRect; AState: TGridDrawState);
    procedure dgInfoSelectCell(Sender: TObject; AColumn, ARow: Integer; var CanSelect: Boolean);
    procedure dgInfoDblClick(Sender: TObject);
    procedure dgInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dgInfoKeyPress(Sender: TObject; var Key: Char);
    procedure dgInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edSearchEnter(Sender: TObject);
    procedure edSearchChange(Sender: TObject);

    function GetColumnInfo(ColumnIndex: Integer): PGridColumnInfo;
    procedure SetRowCount(Value: Integer);
    function GetCells(RowIndex, ColumnIndex: Integer): string;
    procedure SetCells(RowIndex, ColumnIndex: Integer; const Value: string);
    procedure WriteTitle(var Rect: TRect; AColumn: Integer);
    procedure WriteValue(var Rect: TRect; AColumn: Integer; const S: string);
    function GetGridVisible: Boolean;
    procedure SetGridVisible(Value: Boolean);
    function GetEntitled: Boolean;
    procedure SetEntitled(APresent: Boolean);
    procedure SearchNext;
    procedure SetFlatChecks(Value: Boolean);
    procedure DrawCheck(R: TRect; AChecked, AEnabled: Boolean);
    procedure InverseItemCheck(Index: Integer);
    procedure SelectAllItems;
    procedure DeselectAllItems;
    procedure InverseAllChecks;
    procedure UpdateTitleHeight;
    procedure UpdateRowHeights;
    procedure SetDelayedSelectPause(Value: Cardinal);
    procedure TimerWndProc(var AMsg: TMessage);
    procedure ResetDelayedSelection(TestIndex: Integer);
    procedure ProcessColumnResize;

  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public

    DataGrid: TCFDrawGrid;
    SearchEdit: TEdit;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  { Init распределяет память под AColumnCount столбцов. }

    procedure Init(AColumnCount: Integer);

  { ApplyFormats устанавливает фактическую ширину столбцов на основе значений
    полей свойства ColumnInfo. Обычно эта процедура вызывается в конце процесса
    инициализации. }

    procedure ApplyFormats;

  { Activate используется для обновления содержимого сетки. Из этого метода
    вызывается пользовательская процедура, которая заполняет данными внутренний
    массив фрейма. Объект оповещается о том, что данные были изменены и
    необходима перерисовка сетки. }

    procedure Activate;

  { Deactivate очищает строку поиска и удаляет все данные из фрейма. }

    procedure Deactivate;

  { SetFocus устанавливает фокус ввода на данный фрейм. }

    procedure SetFocus; override;

  { IsFocused возвращает True, если фрейм владеет фокусом ввода. }

    function Focused: Boolean; override;

  { SelectRow выделяет запись с индексом Index (нумерация с нуля). Если
    параметр Immediate равен True и используется процедура обработки выделения
    с задержкой, то соответствующая процедура вызывается сразу, без всякой
    задержки. }

    procedure SelectRow(Index: Integer; Immediate: Boolean = False);

  { GetSelectedRowIndex возвращает индекс выделенной строки (или -1). }

    function GetSelectedRowIndex: Integer;

  { SetSearchText изменяет содержимое поля ввода на строку S. Если BeginSearch
    равно False, то поиск при этом не выполняется. }

    procedure SetSearchText(const S: string; BeginSearch: Boolean = True);

  { Объект, хранящий информацию о пометке записей. }

    property Checks: TBitList read FChecks;

  { Объект, хранящий информацию о том, какие записи (строки) являются
    неактивными (они выводятся серым цветом и не допускают изменение пометки). }

    property DisabledItems: TBitList read FDisabledItems;

  { Число строк в таблице (без учета шапки). Значение этому свойству должно
    присваиваться в методе, назначенном свойству OnGetData. }

    property RowCount: Integer read FRowCount write SetRowCount;

  { Число столбцов в таблице. }

    property ColumnCount: Integer read FColumnCount;

  { Информация о столбцах. }

    property ColumnInfo[ColumnIndex: Integer]: PGridColumnInfo read GetColumnInfo;

  { Текст, выводимый в ячейках сетки. }

    property Cells[RowIndex, ColumnIndex: Integer]: string read GetCells write SetCells;

  { Свойство, позволяющее напрямую обращаться к данным, выводимым в ячейках
    сетки. При использовании этого свойства проверка на допустимость индекса
    элемента массива не выполняется. }

    property ItemList: PStringItemList read FItemList;

  { Если True, то выбранная запись выводится на темном фоне, когда фрейм
    не является активным элементом. По умолчанию равно False. }

    property InactiveSelection: Boolean read FInactiveSelection write FInactiveSelection;

  { Если False, то сама сетка не прорисовывается. }

    property GridVisible: Boolean read GetGridVisible write SetGridVisible;

  { Если False, то заголовки столбцов не выводятся в первой строке. }

    property Entitled: Boolean read GetEntitled write SetEntitled;

  { Если False, то поиск производится по строкам, а не по столбцам. }

    property SearchByColumns: Boolean read FSearchByColumns write FSearchByColumns;

  { Если True, то строка с заголовками столбцов раздвигается по высоте и текст
    в ней переносится по словам, чтобы все содержимое было видно полностью. }

    property TitleMultiline: Boolean read FTitleMultiline write FTitleMultiline;

  { Если True, то ячейки раздвигаются по высоте и текст в них переносится по
    словам так, чтобы все содержимое ячеек было видно полностью. }

    property Multiline: Boolean read FMultiline write FMultiline;

  { Если значение этого свойства отлично от нуля, то через такое количество
    миллисекунд после выделения записи будет вызвана процедура, назначенная
    свойству OnDelayedSelectItem. Это произойдет, если в течении этого времени
    выделение не будет перемещено на другую запись. }

    property DelayedSelectPause: Cardinal read FDelayedSelectPause write SetDelayedSelectPause;

  { Свойство, определяющее, на сколько миллисекунд выводится подсказка для
    тех ячеек, содержимое которых видно не полностью (по умолчанию 10000). }

    property HintHidePause: Cardinal read FHintHidePause write FHintHidePause;

  { Если True, то окошки для пометки строк выводятся без эффекта трехмерности. }

    property FlatChecks: Boolean read FFlatChecks write SetFlatChecks;

  { Функция, заполняющая текст в ячейках (должна быть назначена до вызова
    процедуры ApplyFormats). }

    property OnGetData: TGridGetDataEvent read FOnGetData write FOnGetData;

  { Функция, возвращающая цвет текста в ячейках (можно не назначать). }

    property OnGetColor: TGridCellGetColorEvent read FOnGetColor write FOnGetColor;

  { Процедура, вызываемая при выборе (выделении) новой записи. }

    property OnSelectItem: TGridFrameEvent read FOnSelectItem write FOnSelectItem;

  { Если используется задержка при выделении записи (свойство DelayedSelectPause
    отлично от нуля), то процедура, назначенная данному свойству вызывается,
    когда проходит заданный промежуток времени и в течении этого времени другая
    запись не была выделена. }

    property OnDelayedSelectItem: TGridFrameEvent read FOnDelayedSelectItem write FOnDelayedSelectItem;

  { Процедура, вызываемая при двойном щелчке мышью на записи. }

    property OnDoubleClick: TGridFrameEvent read FOnDoubleClick write FOnDoubleClick;

  { Процедура, вызываемая при нажатии командной. }

    property OnKeyDown: TGridKeyDownEvent read FOnKeyDown write FOnKeyDown;

  { Процедура, вызываемая при установлении или снятии пометки с записей. }

    property OnCheckStateChanged: TCheckStateChangedEvent read FCheckStateChanged write FCheckStateChanged;

  { Процедура, вызываемая при перемещении фокуса ввода на фрейм. }

    property OnEnterFrame: TGridEnterExitEvent read FOnEnterFrame write FOnEnterFrame;

  { Процедура, вызываемая перед потерей фреймом фокуса ввода. }

    property OnExitFrame: TGridEnterExitEvent read FOnExitFrame write FOnExitFrame;
  end;

implementation

uses AcedBinary, AcedStrings;

{$R *.DFM}

var
  FCheckWidth, FCheckPlaceWidth, FCheckHeight: Integer;

procedure GetCheckSize;
begin
  with TBitmap.Create do
    try
      Handle := LoadBitmap(0, PChar(32759));
      FCheckWidth := Width shr 2;
      FCheckPlaceWidth := FCheckWidth + 4;
      FCheckHeight := Height div 3;
    finally
      Free;
    end;
end;

{ TCFDrawGrid }

procedure TCFDrawGrid.ColWidthsChanged;
begin
  inherited;
  TCheckFrame(Parent).ProcessColumnResize;
end;

{ TCheckFrame }

constructor TCheckFrame.Create(AOwner: TComponent);
begin
  inherited;
  DesignRect.Pen.Style := psClear;
  SearchEdit := TEdit.Create(Owner);
  with SearchEdit do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := Self.Width;
    Height := 19;
    TabStop := False;
    Anchors := [akLeft, akTop, akRight];
    AutoSelect := False;
    AutoSize := False;
    Color := clBtnFace;
    TabOrder := 0;
    OnChange := edSearchChange;
    OnEnter := edSearchEnter;
  end;
  DataGrid := TCFDrawGrid.Create(Owner);
  with DataGrid do
  begin
    Parent := Self;
    Left := 0;
    Top := 20;
    Width := Self.Width;
    Height := Self.Height - 20;
    Anchors := [akLeft, akTop, akRight, akBottom];
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    DefaultRowHeight := 19;
    DefaultDrawing := False;
    FixedCols := 0;
    RowCount := 2;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
      goColSizing, goRowSelect, goThumbTracking];
    ParentShowHint := False;
    ShowHint := True;
    TabOrder := 1;
    OnSelectCell := dgInfoSelectCell;
    OnDblClick := dgInfoDblClick;
    OnDrawCell := dgInfoDrawCell;
    OnKeyDown := dgInfoKeyDown;
    OnKeyPress := dgInfoKeyPress;
    OnMouseMove := dgInfoMouseMove;
    OnMouseDown := dgInfoMouseDown;
    OnMouseUp := dgInfoMouseUp;
  end;
  FChecks := TBitList.Create(0);
  FDisabledItems := TBitList.Create(0);
  FSearchByColumns := True;
  FHintHidePause := 10000;
  FTimerWnd := Classes.AllocateHWnd(TimerWndProc);
  FMDRowIndex := -1;
end;

destructor TCheckFrame.Destroy;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  if FColumnInfo <> nil then
  begin
    if FRowCount > 0 then
    begin
      Finalize(FItemList^[0], FRowCount * FColumnCount);
      FreeMem(FItemList);
    end;
    Finalize(FColumnInfo^[0], FColumnCount);
    FreeMem(FColumnInfo);
  end;
  Classes.DeallocateHWnd(FTimerWnd);
  FChecks.Free;
  FDisabledItems.Free;
  inherited;
end;

procedure TCheckFrame.Init(AColumnCount: Integer);
var
  I: Integer;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  if (AColumnCount < 1) or (AColumnCount > MaxLastGridColumn + 1) then
    RaiseError(SErrWrongNumberOfGridColumns);
  if FColumnInfo <> nil then
  begin
    if FRowCount > 0 then
      SetRowCount(-1);
    Finalize(FColumnInfo^[0], FColumnCount);
    FInfoApp := False;
    FreeMem(FColumnInfo);
  end;
  FColumnInfo := G_AllocMem(AColumnCount * SizeOf(TGridColumnInfo));
  FColumnCount := AColumnCount;
  DataGrid.ColCount := AColumnCount;
  DataGrid.FixedRows := 1;
  for I := FColumnCount - 1 downto 0 do
    with FColumnInfo^[I] do
    begin
      LeftIndent := 2;
      RightIndent := 3;
      Searched := True;
      TitleAlignment := taCenter;
    end;
end;

procedure TCheckFrame.ApplyFormats;
var
  I: Integer;
begin
  if FColumnInfo = nil then
    RaiseError(SErrFrameNotInitialized);
  if not Assigned(FOnGetData) then
    RaiseError(SErrOnGetDataNotAssigned);
  if (FDelayedSelectPause <> 0) and not Assigned(FOnDelayedSelectItem) then
    RaiseError(SErrOnDelayedSelectItemNotAssigned);
  DataGrid.ColWidths[0] := FColumnInfo^[0].Width + FCheckPlaceWidth;
  for I := FColumnCount - 1 downto 0 do
    DataGrid.ColWidths[I] := FColumnInfo^[I].Width;
  FInfoApp := True;
end;

procedure TCheckFrame.Activate;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  FOnGetData(Self);
  if (DataGrid.FixedRows > 0) and FTitleMultiline then
    UpdateTitleHeight;
  if FMultiline then
    UpdateRowHeights;
  DataGrid.Invalidate;
  if Assigned(FOnSelectItem) then
    FOnSelectItem(Self, GetSelectedRowIndex);
  if FDelayedSelectPause <> 0 then
    ResetDelayedSelection(GetSelectedRowIndex);
end;

procedure TCheckFrame.Deactivate;
begin
  SetSearchText('', False);
  SetRowCount(-1);
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
end;

procedure TCheckFrame.dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer;
  Rect: TRect; AState: TGridDrawState);
var
  RowIndex: Integer;
  C, BC, FC: TColor;
  TempRect: TRect;
  Selected, Inactive: Boolean;
  Disabled: Boolean;
begin
  if not FInfoApp then
    Exit;
  if ARow >= DataGrid.FixedRows then
  begin
    if FRowCount > 0 then
    begin
      Selected := gdSelected in AState;
      Inactive := False;
      if Selected then
      begin
        if Focused then
        begin
          BC := clHighlight;
          FC := clHighlightText;
        end
        else if FInactiveSelection then
        begin
          BC := clInactiveCaption;
          FC := clHighlightText;
          Inactive := True;
        end else
        begin
          BC := clWindow;
          FC := clWindowText;
          Selected := False;
        end;
      end else
      begin
        BC := clWindow;
        FC := clWindowText;
      end;
      RowIndex := ARow - DataGrid.FixedRows;
      Disabled := FDisabledItems[RowIndex];
      DataGrid.Canvas.Brush.Color := BC;
      if AColumn = 0 then
      begin
        TempRect := Rect;
        Inc(Rect.Left, FCheckPlaceWidth);
        TempRect.Right := Rect.Left;
        DrawCheck(TempRect, FChecks[RowIndex], not Disabled);
      end;
      if Disabled then
        FC := clGrayText
      else if Assigned(FOnGetColor) then
      begin
        C := FOnGetColor(Self, RowIndex, AColumn, Selected, Inactive);
        if C <> clDefault then
          FC := C;
      end;
      with DataGrid.Canvas do
      begin
        Font := DataGrid.Font;
        Font.Color := FC;
      end;
      WriteValue(Rect, AColumn, FItemList^[RowIndex * FColumnCount + AColumn]);
    end else
      with DataGrid.Canvas do
      begin
        Brush.Color := clWindow;
        Windows.FillRect(Handle, Rect, Brush.Handle);
      end;
  end else
  begin
    with DataGrid.Canvas do
    begin
      Brush.Color := clBtnFace;
      Font := DataGrid.Font;
      Font.Color := clBtnText;
    end;
    TempRect := Rect;
    WriteTitle(Rect, AColumn);
    with DataGrid.Canvas do
    begin
      DrawEdge(Handle, TempRect, BDR_RAISEDINNER, BF_RIGHT or BF_BOTTOM);
      DrawEdge(Handle, TempRect, BDR_RAISEDINNER, BF_LEFT or BF_TOP);
    end;
  end;
end;

procedure TCheckFrame.dgInfoSelectCell(Sender: TObject; AColumn, ARow: Integer;
  var CanSelect: Boolean);
begin
  if Focused then
  begin
    SearchEdit.Font.Color := clWindowText;
    SetSearchText('*', False);
    if Assigned(FOnSelectItem) then
      if FRowCount <> 0 then
        FOnSelectItem(Self, ARow - DataGrid.FixedRows)
      else
        FOnSelectItem(Self, -1);
    if FDelayedSelectPause <> 0 then
      if FRowCount <> 0 then
        ResetDelayedSelection(ARow - DataGrid.FixedRows)
      else
        ResetDelayedSelection(-1);
  end;
end;

procedure TCheckFrame.dgInfoDblClick(Sender: TObject);
begin
  InverseItemCheck(GetSelectedRowIndex);
  if Assigned(FOnDoubleClick) then
    FOnDoubleClick(Self, GetSelectedRowIndex);
end;

procedure TCheckFrame.dgInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_SPACE:     FSpaceBarPressed := ssCtrl in Shift;
    VK_MULTIPLY:  FMultiplyPressed := True;
    VK_ADD:       FPlusPressed := True;
    VK_SUBTRACT:  FMinusPressed := True;
  else
    if Assigned(FOnKeyDown) then
      FOnKeyDown(Self, GetSelectedRowIndex, Key, Shift);
  end;
end;

procedure TCheckFrame.dgInfoKeyPress(Sender: TObject; var Key: Char);
begin
  with SearchEdit do
    if (Key = #32) and not FSpaceBarPressed then
      InverseItemCheck(GetSelectedRowIndex)
    else if FPlusPressed then
    begin
      FPlusPressed := False;
      SelectAllItems;
    end
    else if FMinusPressed then
    begin
      FMinusPressed := False;
      DeselectAllItems;
    end
    else if FMultiplyPressed then
    begin
      FMultiplyPressed := False;
      InverseAllChecks;
    end
    else if Key >= #32 then
    begin
      Text := Text + Key;
      SelStart := Length(Text);
    end
    else if Key = #12 then
    begin
      SearchNext;
      Key := #0;
    end
    else if (Key = #8) and not G_IsEmpty(Text) then
    begin
      Text := Copy(Text, 1, Length(Text) - 1);
      SelStart := Length(Text);
    end;
end;

procedure TCheckFrame.dgInfoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Column,Row,W: Integer;
  S: string;
  P: TPoint;
begin
  if not FMultiline and (Shift = []) then
  begin
    DataGrid.MouseToCell(X, Y, Column, Row);
    if (Column <> -1) and (Row >= DataGrid.FixedRows) and (Row < DataGrid.FixedRows + FRowCount) then
    begin
      S := FItemList^[(Row - DataGrid.FixedRows) * FColumnCount + Column];
      if not G_IsEmpty(S) then
      begin
        if G_SameStr(S, DataGrid.Hint) then
          Exit;
        DataGrid.Canvas.Font := DataGrid.Font;
        with FColumnInfo^[Column] do
          W := Width - LeftIndent - RightIndent;
        if DataGrid.Canvas.TextExtent(S).cx > W then
          with Application do
          begin
            CancelHint;
            DataGrid.Hint := S;
            P.X := X;
            P.Y := Y;
            HintHidePause := FHintHidePause;
            ActivateHint(P);
            Exit;
          end;
      end;
    end;
  end;
  Application.CancelHint;
end;

procedure TCheckFrame.dgInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
  R: TRect;
begin
  FMDRowIndex := DataGrid.Row;
  if Button = mbLeft then
  begin
    DataGrid.MouseToCell(X, Y , Col, Row);
    if (Col=0) and (Row >= DataGrid.FixedRows) then
    begin
      R := DataGrid.CellRect(Col, Row);
      if X - R.Left < FCheckPlaceWidth then
        InverseItemCheck(Row - DataGrid.FixedRows);
    end;
  end;
end;

procedure TCheckFrame.dgInfoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (FMDRowIndex >= 0) and (DataGrid.Selection.Top <> FMDRowIndex) then
  begin
    SelectRow(FMDRowIndex - 1);
    FMDRowIndex := -1;
  end;
end;

procedure TCheckFrame.edSearchEnter(Sender: TObject);
begin
  Windows.SetFocus(DataGrid.Handle);
end;

procedure TCheckFrame.edSearchChange(Sender: TObject);
var
  S: string;
  I,J,N: Integer;
  Full: Boolean;
begin
  if FSearchInProgress then
  begin
    S := SearchEdit.Text;
    SearchEdit.Font.Color := clWindowText;
    if not G_IsEmpty(S) and (S[1] = '*') then
    begin
      G_Delete(S, 1, 1);
      Full := True;
    end else
      Full := False;
    N := Length(S);
    if N = 0 then
    begin
      SelectRow(0);
      Exit;
    end;
    if FSearchByColumns then
    begin
      if Full then
      begin
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            for I := 0 to FRowCount - 1 do
              if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
              begin
                SelectRow(I);
                Exit;
              end;
      end else
      begin
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            for I := 0 to FRowCount - 1 do
              if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
              begin
                SelectRow(I);
                Exit;
              end;
      end;
    end else
      if Full then
      begin
        for I := 0 to FRowCount - 1 do
          for J := 0 to FColumnCount - 1 do
            if FColumnInfo^[J].Searched then
              if G_PosText(S,FItemList^[I * FColumnCount + J]) <> 0 then
              begin
                SelectRow(I);
                Exit;
              end;
      end else
      begin
        for I := 0 to FRowCount - 1 do
          for J := 0 to FColumnCount - 1 do
            if FColumnInfo^[J].Searched then
              if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
              begin
                SelectRow(I);
                Exit;
              end;
      end;
    SearchEdit.Font.Color := clGrayText;
  end;
end;

function TCheckFrame.GetColumnInfo(ColumnIndex: Integer): PGridColumnInfo;
begin
  if (FColumnInfo <> nil) and (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
    Result := @FColumnInfo^[ColumnIndex]
  else
  begin
    RaiseError(SErrWrongGridColumnIndex);
    Result := nil;
  end;
end;

procedure TCheckFrame.SetRowCount(Value: Integer);
begin
  if Value <> FRowCount then
  begin
    if FRowCount > 0 then
    begin
      Finalize(FItemList^[0], FRowCount * FColumnCount);
      FreeMem(FItemList);
    end;
    if Value > 0 then
    begin
      FRowCount := Value;
      FItemList := G_AllocMem(Value * FColumnCount * SizeOf(Pointer));
      FDisabledItems.Count := 0;
      FChecks.Count := 0;
      FDisabledItems.Count := Value;
      FChecks.Count := Value;
      DataGrid.RowCount := DataGrid.FixedRows + Value;
    end else
    begin
      FItemList := nil;
      FRowCount := 0;
      FDisabledItems.Count := 0;
      FChecks.Count := 0;
      DataGrid.RowCount := DataGrid.FixedRows + 1;
      if Assigned(FOnSelectItem) then
        FOnSelectItem(Self, -1);
      if FDelayedSelectPause <> 0 then
        ResetDelayedSelection(-1);
    end;
  end;
  FDisabledItems.SetAll(False);
  FChecks.SetAll(False);
  if Assigned(FCheckStateChanged) then
    FCheckStateChanged(Self);
end;

function TCheckFrame.GetCells(RowIndex, ColumnIndex: Integer): string;
begin
  if (RowIndex >= 0) and (RowIndex < FRowCount) then
  begin
    if (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
      Result := FItemList^[RowIndex * FColumnCount + ColumnIndex]
    else
      RaiseError(SErrWrongGridColumnIndex);
  end else
    RaiseError(SErrWrongGridRowIndex);
end;

procedure TCheckFrame.SetCells(RowIndex, ColumnIndex: Integer;
  const Value: string);
begin
  if (RowIndex >= 0) and (RowIndex < FRowCount) then
  begin
    if (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
      FItemList^[RowIndex * FColumnCount + ColumnIndex] := Value
    else
      RaiseError(SErrWrongGridColumnIndex);
  end else
    RaiseError(SErrWrongGridRowIndex);
end;

procedure TCheckFrame.WriteTitle(var Rect: TRect; AColumn: Integer);
var
  DC: HDC;
begin
  with FColumnInfo^[AColumn], Rect, DataGrid.Canvas do
  begin
    Brush.Color := clBtnFace;
    Font.Color := clBtnText;
    DC := Handle;
    Windows.FillRect(DC, Rect, Brush.Handle);
    Inc(Left, LeftIndent);
    Dec(Right, RightIndent);
    Inc(Top, 2);
    if not FTitleMultiline then
      case TitleAlignment of
        taLeftJustify:
          Windows.ExtTextOut(DC, Left, Top, TextFlags or ETO_CLIPPED, @Rect,
            PChar(Title), Length(Title), nil);
        taRightJustify:
          Windows.ExtTextOut(DC, Right - TextWidth(Title), Top,
            TextFlags or ETO_CLIPPED, @Rect, PChar(Title), Length(Title), nil);
      else { taCenter }
        Windows.ExtTextOut(DC, Left + (Right - Left - TextWidth(Title)) div 2, Top,
          TextFlags or ETO_CLIPPED, @Rect, PChar(Title), Length(Title), nil);
      end
    else
      case TitleAlignment of
        taLeftJustify:
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_LEFT, nil);
        taRightJustify:
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_RIGHT, nil);
      else { taCenter }
        DrawTextEx(DC, PChar(Title), Length(Title), Rect,
          DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_CENTER, nil);
      end;
    Changed;
  end;
end;

procedure TCheckFrame.WriteValue(var Rect: TRect; AColumn: Integer; const S: string);
var
  DC: HDC;
begin
  with FColumnInfo^[AColumn], Rect, DataGrid.Canvas do
  begin
    DC := Handle;
    Windows.FillRect(DC, Rect, Brush.Handle);
    Inc(Left, LeftIndent);
    Dec(Right, RightIndent);
    Inc(Top, 2);
    if not FMultiline then
      case Alignment of
        taLeftJustify:
          Windows.ExtTextOut(DC, Left, Top, TextFlags or ETO_CLIPPED, @Rect,
            PChar(S), Length(S), nil);
        taRightJustify:
          Windows.ExtTextOut(DC, Right - TextWidth(S), Top,
            TextFlags or ETO_CLIPPED, @Rect, PChar(S), Length(S), nil);
      else { taCenter }
        Windows.ExtTextOut(DC, Left + (Right - Left - TextWidth(S)) div 2, Top,
          TextFlags or ETO_CLIPPED, @Rect, PChar(S), Length(S), nil);
      end
    else
      case Alignment of
        taLeftJustify:
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_LEFT, nil);
        taRightJustify:
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_RIGHT, nil);
      else { taCenter }
        DrawTextEx(DC, PChar(S), Length(S), Rect,
          DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_CENTER, nil);
      end;
    Changed;
  end;
end;

function TCheckFrame.GetGridVisible: Boolean;
begin
  Result := DataGrid.GridLineWidth <> 0;
end;

procedure TCheckFrame.SetGridVisible(Value: Boolean);
begin
  DataGrid.GridLineWidth := Integer(Value);
end;

function TCheckFrame.GetEntitled: Boolean;
begin
  Result := DataGrid.FixedRows > 0;
end;

procedure TCheckFrame.SetEntitled(APresent: Boolean);
begin
  if APresent then
    DataGrid.FixedRows := 1
  else
    DataGrid.FixedRows := 0;
end;

procedure TCheckFrame.SearchNext;
var
  S: string;
  I, J, N, RS: Integer;
  Full: Boolean;
begin
  RS := GetSelectedRowIndex;
  if RS >= FRowCount - 1 then
    Exit;
  Inc(RS);
  S := SearchEdit.Text;
  SearchEdit.Font.Color := clWindowText;
  if not G_IsEmpty(S) and (S[1] = '*') then
  begin
    G_Delete(S, 1, 1);
    Full := True;
  end else
    Full := False;
  N := Length(S);
  if N = 0 then
    Exit;
  if FSearchByColumns then
  begin
    if Full then
    begin
      for J := 0 to FColumnCount - 1 do
        if FColumnInfo^[J].Searched then
          for I := RS to FRowCount - 1 do
            if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
            begin
              SelectRow(I);
              Exit;
            end;
    end else
    begin
      for J := 0 to FColumnCount - 1 do
        if FColumnInfo^[J].Searched then
          for I := RS to FRowCount - 1 do
            if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
            begin
              SelectRow(I);
              Exit;
            end;
    end;
  end else
    if Full then
    begin
      for I := RS to FRowCount - 1 do
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
            begin
              SelectRow(I);
              Exit;
            end;
    end else
    begin
      for I := RS to FRowCount - 1 do
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
            begin
              SelectRow(I);
              Exit;
            end;
    end;
  SearchEdit.Font.Color := clGrayText;
end;

procedure TCheckFrame.SetFlatChecks(Value: Boolean);
begin
  if Value <> FFlatChecks then
  begin
    FFlatChecks := Value;
    DataGrid.Invalidate;
  end;
end;

procedure TCheckFrame.DrawCheck(R: TRect; AChecked, AEnabled: Boolean);
var
  DrawState: Integer;
  DrawRect: TRect;
  Rgn, SaveRgn: HRgn;
  ClipRs: Integer;
begin
  with DataGrid.Canvas do
  begin
    with R do
    begin
      DrawRect.Left := Left + (Right - Left - FCheckWidth) shr 1;
      DrawRect.Top := Top + 4 - Font.Height - FCheckHeight;
    end;
    with DrawRect do
    begin
      Right := Left + FCheckWidth;
      Bottom := Top + FCheckHeight;
    end;
    if AChecked then
      DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED
    else
      DrawState := DFCS_BUTTONCHECK;
    if not AEnabled then
      DrawState := DrawState or DFCS_INACTIVE;
    FillRect(R);
    if not FFlatChecks then
      DrawFrameControl(Handle, DrawRect, DFC_BUTTON, DrawState)
    else
    begin
      SaveRgn := CreateRectRgn(0, 0, 0, 0);
      ClipRs := GetClipRgn(Handle, SaveRgn);
      with DrawRect do
        Rgn := CreateRectRgn(Left + 2, Top + 2, Right - 2, Bottom - 2);
      SelectClipRgn(Handle, Rgn);
      DeleteObject(Rgn);
      DrawFrameControl(Handle, DrawRect, DFC_BUTTON, DrawState);
      if ClipRs = 1 then
        SelectClipRgn(Handle, SaveRgn)
      else
        SelectClipRgn(Handle, 0);
      DeleteObject(SaveRgn);
      Brush.Style := bsClear;
      Pen.Color := clBtnShadow;
      with DrawRect do
        Rectangle(Left + 1, Top + 1, Right - 1, Bottom - 1);
      Brush.Style := bsSolid;
    end;
  end;
end;

procedure TCheckFrame.InverseItemCheck(Index: Integer);
begin
  if (Index >= 0) and not FDisabledItems[Index] then
  begin
    FChecks.ToggleBit(Index);
    if Assigned(FCheckStateChanged) then
      FCheckStateChanged(Self);
    DataGrid.Invalidate;
  end;
end;

procedure TCheckFrame.SelectAllItems;
var
  I: Integer;
begin
  if FDisabledItems.CountOf(True) = 0 then
    FChecks.SetAll(True)
  else
  begin
    for I := 0 to FChecks.Count-1 do
      if not FDisabledItems[I] then
        FChecks[I] := True;
  end;
  if Assigned(FCheckStateChanged) then
    FCheckStateChanged(Self);
  DataGrid.Invalidate;
end;

procedure TCheckFrame.DeselectAllItems;
var
  I: Integer;
begin
  if FDisabledItems.CountOf(True) = 0 then
    FChecks.SetAll(False)
  else
  begin
    for I := 0 to FChecks.Count-1 do
      if not FDisabledItems[I] then
        FChecks[I] := False;
  end;
  if Assigned(FCheckStateChanged) then
    FCheckStateChanged(Self);
  DataGrid.Invalidate;
end;

procedure TCheckFrame.InverseAllChecks;
var
  I: Integer;
begin
  if FDisabledItems.CountOf(True) = 0 then
    FChecks.NotBits
  else
  begin
    for I := 0 to FChecks.Count-1 do
      if not FDisabledItems[I] then
        FChecks.ToggleBit(I);
  end;
  if Assigned(FCheckStateChanged) then
    FCheckStateChanged(Self);
  DataGrid.Invalidate;
end;

procedure TCheckFrame.UpdateTitleHeight;
var
  J, RwH: Integer;
  Rect: TRect;
  DC: HDC;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  with DataGrid.Canvas do
  begin
    Font := DataGrid.Font;
    DC := Handle;
    Lock;
    RwH := DataGrid.DefaultRowHeight;
    for J := FColumnCount - 1 downto 0 do
      with FColumnInfo^[J] do
      begin
        Rect.Right := Width - RightIndent - LeftIndent;
        if not G_IsEmpty(Title) then
        begin
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_CALCRECT or DT_EXPANDTABS or DT_NOPREFIX or DT_WORDBREAK, nil);
          Inc(Rect.Bottom, 4);
          if Rect.Bottom > RwH then
            RwH := Rect.Bottom;
        end;
      end;
    DataGrid.RowHeights[0] := RwH;
    UnLock;
    Changed;
  end;
end;

procedure TCheckFrame.UpdateRowHeights;
var
  I, J, RwH: Integer;
  Rect: TRect;
  S: string;
  DC: HDC;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  with DataGrid.Canvas do
  begin
    Font := DataGrid.Font;
    DC := Handle;
    Lock;
    for I := 0 to FRowCount-1 do
    begin
      RwH := DataGrid.DefaultRowHeight;
      for J := FColumnCount - 1 downto 0 do
      begin
        with FColumnInfo^[J] do
          Rect.Right := Width - RightIndent - LeftIndent;
        S := FItemList^[I * FColumnCount + J];
        if not G_IsEmpty(S) then
        begin
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_CALCRECT or DT_EXPANDTABS or DT_NOPREFIX or DT_WORDBREAK,nil);
          Inc(Rect.Bottom, 4);
          if Rect.Bottom > RwH then
            RwH := Rect.Bottom;
        end;
      end;
      DataGrid.RowHeights[DataGrid.FixedRows + I] := RwH;
    end;
    UnLock;
    Changed;
  end;
end;

procedure TCheckFrame.SetDelayedSelectPause(Value: Cardinal);
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  FDelayedSelectPause := Value;
end;

procedure TCheckFrame.TimerWndProc(var AMsg: TMessage);
var
  Index: Integer;
begin
  with AMsg do
    if Msg = WM_TIMER then
    begin
      if FTimerWork then
      begin
        KillTimer(FTimerWnd, 1);
        FTimerWork := False;
        Index := GetSelectedRowIndex;
        if Index = FDelayedRowIndex then
          FOnDelayedSelectItem(Self, Index);
      end;
    end else
      Result := DefWindowProc(FTimerWnd, Msg, wParam, lParam);
end;

procedure TCheckFrame.ResetDelayedSelection(TestIndex: Integer);
begin
  if FTimerWork then
    if TestIndex = FDelayedRowIndex then
      Exit
    else
    begin
      KillTimer(FTimerWnd, 1);
      FTimerWork := False;
    end;
  FDelayedRowIndex := TestIndex;
  if SetTimer(FTimerWnd, 1, FDelayedSelectPause, nil) = 0 then
    RaiseError(SErrNoAvailableTimers);
  FTimerWork := True;
end;

procedure TCheckFrame.ProcessColumnResize;
var
  J: Integer;
begin
  if FInfoApp then
  begin
    for J := FColumnCount - 1 downto 0 do
      FColumnInfo^[J].Width := DataGrid.ColWidths[J];
    if (DataGrid.FixedRows > 0) and FTitleMultiline then
      UpdateTitleHeight;
    if FMultiline then
      UpdateRowHeights;
  end;
end;

procedure TCheckFrame.DoEnter;
begin
  SearchEdit.Font.Color := clWindowText;
  SetSearchText('*', False);
  if Assigned(FOnEnterFrame) then
    FOnEnterFrame(Self);
  inherited;
end;

procedure TCheckFrame.DoExit;
begin
  SetSearchText('', False);
  if Assigned(FOnExitFrame) then
    FOnExitFrame(Self);
  inherited;
end;

procedure TCheckFrame.SetFocus;
begin
  Windows.SetFocus(DataGrid.Handle);
  SearchEdit.Font.Color := clWindowText;
  SetSearchText('*', False);
end;

function TCheckFrame.Focused: Boolean;
var
  WC: TWinControl;
begin
  WC := Screen.ActiveControl;
  Result := (WC = SearchEdit) or (WC = DataGrid);
end;

procedure TCheckFrame.SelectRow(Index: Integer; Immediate: Boolean);
var
  CurrentTop, NewTop, VC: Integer;
  Rect: TGridRect;
begin
  if (Index >= 0) and (Index < FRowCount) then
  begin
    CurrentTop := DataGrid.TopRow;
    VC := DataGrid.VisibleRowCount;
    Dec(CurrentTop, DataGrid.FixedRows);
    if Index < CurrentTop then
    begin
      if Index > 0 then
        NewTop := Index - 1
      else
        NewTop := 0;
      Inc(NewTop, DataGrid.FixedRows);
      DataGrid.TopRow := NewTop;
    end
    else if Index > CurrentTop + VC - 2 then
    begin
      if Index <= FRowCount - VC then
      begin
        if Index > 0 then
          NewTop := Index - 1
        else
          NewTop := 0;
      end else
        NewTop := FRowCount - VC;
      Inc(NewTop, DataGrid.FixedRows);
      DataGrid.TopRow := NewTop;
    end;
    Rect.Left := 0;
    Rect.Right := FColumnCount - 1;
    Rect.Top := DataGrid.FixedRows + Index;
    Rect.Bottom := Rect.Top;
    DataGrid.Selection := Rect;
    if Assigned(FOnSelectItem) then
      FOnSelectItem(Self, Index);
    if FDelayedSelectPause <> 0 then
      if Immediate then
      begin
        if FTimerWork then
        begin
          KillTimer(FTimerWnd, 1);
          FTimerWork := False;
        end;
        FOnDelayedSelectItem(Self, Index);
      end else
        ResetDelayedSelection(Index);
  end;
end;

function TCheckFrame.GetSelectedRowIndex: Integer;
begin
  if FRowCount > 0 then
  begin
    Result := DataGrid.Selection.Top - DataGrid.FixedRows;
    if Result < 0 then
    begin
      Result := 0;
      SelectRow(0);
    end
    else if Result >= FRowCount then
    begin
      Result := FRowCount - 1;
      SelectRow(Result);
    end;
  end else
    Result := -1;
end;

procedure TCheckFrame.SetSearchText(const S: string; BeginSearch: Boolean);
begin
  SearchEdit.Font.Color := clWindowText;
  if BeginSearch then
    with SearchEdit do
    begin
      Text := S;
      SelStart := Length(S);
    end
  else
  begin
    FSearchInProgress := False;
    with SearchEdit do
    begin
      Text := S;
      SelStart := Length(S);
    end;
    FSearchInProgress := True;
  end;
end;

initialization
  GetCheckSize;

end.

