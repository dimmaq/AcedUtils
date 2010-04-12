
////////////////////////////////////////////////////
//                                                //
//   AcedViewFrame 1.03                           //
//                                                //
//   Фрейм для просмотра данных в виде таблицы.   //
//                                                //
//   mailto: acedutils@yandex.ru                  //
//                                                //
////////////////////////////////////////////////////

unit AcedViewFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, AcedGrids, AcedConsts;

{ Фрейм TViewFrame отображает данные в виде таблицы. Текст в столбцах и
  заголовках столбцов может выравниваться по левому краю, по правому краю
  или по центру. Если текст не помещается в ячейке, он может переноситься
  по словам, а ячейка раздвигаться по высоте так, чтобы ее содержимое было
  видно полностью. Текст в каждой ячейке может выводиться своим цветом.
  Для скроллирования фрейма необходимо вызвать методы: RowUp, RowDown,
  PageUp, PageDown, GoHome, GoEnd. Сам по себе фрейм игнорирует события
  от клавиатуры. }

type
  TVFDrawGrid = class(TDrawGrid)
  protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure ColWidthsChanged; override;
  end;

  TViewFrame = class(TFrame)
    DesignRect: TShape;

  private
    FItemList: PStringItemList;
    FRowCount: Integer;
    FColumnInfo: PGridColumnList;
    FColumnCount: Integer;
    FHintHidePause: Cardinal;
    FMDRowIndex: Integer;
    FOnGetData: TGridGetDataEvent;
    FOnGetColor: TViewCellGetColorEvent;
    FOnDoubleClick: TGridFrameEvent;
    FOnKeyPress: TViewKeyPressEvent;
    FOnKeyDown: TViewKeyDownEvent;
    FOnEnterFrame: TGridEnterExitEvent;
    FOnExitFrame: TGridEnterExitEvent;
    FInfoApp: Boolean;
    FTitleMultiline: Boolean;
    FMultiline: Boolean;

    procedure dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer; Rect: TRect; AState: TGridDrawState);
    procedure dgInfoDblClick(Sender: TObject);
    procedure dgInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dgInfoKeyPress(Sender: TObject; var Key: Char);
    procedure dgInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

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
    procedure UpdateTitleHeight;
    procedure UpdateRowHeights;
    procedure ProcessColumnResize;

  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    DataGrid: TVFDrawGrid;

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

  { Методы для навигации по гриду. }

    procedure RowUp;
    procedure RowDown;
    procedure PageUp;
    procedure PageDown;
    procedure GoHome;
    procedure GoEnd;

  { SetFocus устанавливает фокус ввода на данный фрейм. }

    procedure SetFocus; override;

  { IsFocused возвращает True, если фрейм владеет фокусом ввода. }

    function Focused: Boolean; override;

  { SelectRow выделяет запись с индексом Index (нумерация с нуля). }

    procedure SelectRow(Index: Integer);

  { GetSelectedRowIndex возвращает индекс выделенной строки (или -1). }

    function GetSelectedRowIndex: Integer;

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

  { Если False, то сама сетка не прорисовывается. }

    property GridVisible: Boolean read GetGridVisible write SetGridVisible;

  { Если False, то заголовки столбцов не выводятся в первой строке. }

    property Entitled: Boolean read GetEntitled write SetEntitled;

  { Если True, то строка с заголовками столбцов раздвигается по высоте и текст
    в ней переносится по словам, чтобы все содержимое было видно полностью. }

    property TitleMultiline: Boolean read FTitleMultiline write FTitleMultiline;

  { Если True, то ячейки раздвигаются по высоте и текст в них переносится по
    словам так, чтобы все содержимое ячеек было видно полностью. }

    property Multiline: Boolean read FMultiline write FMultiline;

  { Свойство, определяющее, на сколько миллисекунд выводится подсказка для
    тех ячеек, содержимое которых видно не полностью (по умолчанию 10000). }

    property HintHidePause: Cardinal read FHintHidePause write FHintHidePause;

  { Функция, заполняющая текст в ячейках (должна быть назначена до вызова
    процедуры ApplyFormats). }

    property OnGetData: TGridGetDataEvent read FOnGetData write FOnGetData;

  { Функция, возвращающая цвет текста в ячейках (можно не назначать). }

    property OnGetColor: TViewCellGetColorEvent read FOnGetColor write FOnGetColor;

  { Процедура, вызываемая при двойном щелчке мышью на записи. }

    property OnDoubleClick: TGridFrameEvent read FOnDoubleClick write FOnDoubleClick;

  { Процедура, вызываемая при вводе символа. }

    property OnKeyPress: TViewKeyPressEvent read FOnKeyPress write FOnKeyPress;

  { Процедура, вызываемая при нажатии клавиши. }

    property OnKeyDown: TViewKeyDownEvent read FOnKeyDown write FOnKeyDown;

  { Процедура, вызываемая при перемещении фокуса ввода на фрейм. }

    property OnEnterFrame: TGridEnterExitEvent read FOnEnterFrame write FOnEnterFrame;

  { Процедура, вызываемая перед потерей фреймом фокуса ввода. }

    property OnExitFrame: TGridEnterExitEvent read FOnExitFrame write FOnExitFrame;
  end;

implementation

uses AcedBinary, AcedStrings;

{$R *.DFM}

{ TVFDrawGrid }

procedure TVFDrawGrid.ColWidthsChanged;
begin
  inherited;
  TViewFrame(Parent).ProcessColumnResize;
end;

function TVFDrawGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  TViewFrame(Parent).RowDown;
  Result := True;
end;

function TVFDrawGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  TViewFrame(Parent).RowUp;
  Result := True;
end;

{ TViewFrame }

constructor TViewFrame.Create(AOwner: TComponent);
begin
  inherited;
  DesignRect.Pen.Style := psClear;
  DataGrid := TVFDrawGrid.Create(Owner);
  with DataGrid do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := Self.Width;
    Height := Self.Height;
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
    OnDrawCell := dgInfoDrawCell;
    OnDblClick := dgInfoDblClick;
    OnKeyDown := dgInfoKeyDown;
    OnKeyPress := dgInfoKeyPress;
    OnMouseMove := dgInfoMouseMove;
    OnMouseDown := dgInfoMouseDown;
    OnMouseUp := dgInfoMouseUp;
  end;
  FHintHidePause := 10000;
  FMDRowIndex := -1;
end;

destructor TViewFrame.Destroy;
begin
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
  inherited;
end;

procedure TViewFrame.Init(AColumnCount: Integer);
var
  I: Integer;
begin
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
      TitleAlignment := taCenter;
    end;
end;

procedure TViewFrame.ApplyFormats;
var
  I: Integer;
begin
  if FColumnInfo = nil then
    RaiseError(SErrFrameNotInitialized);
  if not Assigned(FOnGetData) then
    RaiseError(SErrOnGetDataNotAssigned);
  for I := FColumnCount - 1 downto 0 do
    DataGrid.ColWidths[I] := FColumnInfo^[I].Width;
  FInfoApp := True;
end;

procedure TViewFrame.Activate;
begin
  FOnGetData(Self);
  DataGrid.Color := Color;
  if (DataGrid.FixedRows > 0) and FTitleMultiline then
    UpdateTitleHeight;
  if FMultiline then
    UpdateRowHeights;
  DataGrid.Invalidate;
end;

procedure TViewFrame.Deactivate;
begin
  SetRowCount(-1);
end;

procedure TViewFrame.dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer;
  Rect: TRect; AState: TGridDrawState);
var
  C: TColor;
  TempRect: TRect;
begin
  if not FInfoApp then
    Exit;
  Dec(ARow, DataGrid.FixedRows);
  if ARow >= 0 then
  begin
    if FRowCount > 0 then
    begin
      C := clDefault;
      if Assigned(FOnGetColor) then
        C := FOnGetColor(Self, ARow, AColumn);
      if C = clDefault then
        C := clWindowText;
      with DataGrid.Canvas do
      begin
        Brush.Color := Self.Color;
        Font := DataGrid.Font;
        Font.Color := C;
      end;
      WriteValue(Rect, AColumn, FItemList^[ARow * FColumnCount + AColumn]);
    end else
      with DataGrid.Canvas do
      begin
        Brush.Color := Self.Color;
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

procedure TViewFrame.dgInfoDblClick(Sender: TObject);
begin
  if Assigned(FOnDoubleClick) then
    FOnDoubleClick(Self, GetSelectedRowIndex);
end;

procedure TViewFrame.dgInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self, Key, Shift);
  Key := 0;
end;

procedure TViewFrame.dgInfoKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self, Key);
  Key := #0;
end;

procedure TViewFrame.dgInfoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Column, Row, W: Integer;
  S: string;
  P: TPoint;
begin
  if not FMultiline and (Shift = []) then
  begin
    DataGrid.MouseToCell(X, Y, Column, Row);
    if (Column<>-1) and (Row >= DataGrid.FixedRows) and (Row < DataGrid.FixedRows + FRowCount) then
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

procedure TViewFrame.dgInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMDRowIndex := DataGrid.Row;
end;

procedure TViewFrame.dgInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FMDRowIndex >= 0) and (DataGrid.Selection.Top <> FMDRowIndex) then
  begin
    SelectRow(FMDRowIndex - 1);
    FMDRowIndex := -1;
  end;
end;

function TViewFrame.GetColumnInfo(ColumnIndex: Integer): PGridColumnInfo;
begin
  if (FColumnInfo <> nil) and (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
    Result := @FColumnInfo^[ColumnIndex]
  else
  begin
    RaiseError(SErrWrongGridColumnIndex);
    Result := nil;
  end;
end;

procedure TViewFrame.SetRowCount(Value: Integer);
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
      DataGrid.RowCount := DataGrid.FixedRows + Value;
    end else
    begin
      FItemList := nil;
      FRowCount := 0;
      DataGrid.RowCount := DataGrid.FixedRows + 1;
    end;
  end;
end;

function TViewFrame.GetCells(RowIndex, ColumnIndex: Integer): string;
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

procedure TViewFrame.SetCells(RowIndex, ColumnIndex: Integer; const Value: string);
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

procedure TViewFrame.WriteTitle(var Rect: TRect; AColumn: Integer);
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

procedure TViewFrame.WriteValue(var Rect: TRect; AColumn: Integer; const S: string);
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

function TViewFrame.GetGridVisible: Boolean;
begin
  Result := DataGrid.GridLineWidth <> 0;
end;

procedure TViewFrame.SetGridVisible(Value: Boolean);
begin
  DataGrid.GridLineWidth := Integer(Value);
end;

function TViewFrame.GetEntitled: Boolean;
begin
  Result := DataGrid.FixedRows > 0;
end;

procedure TViewFrame.SetEntitled(APresent: Boolean);
begin
  if APresent then
    DataGrid.FixedRows := 1
  else
    DataGrid.FixedRows := 0;
end;

procedure TViewFrame.UpdateTitleHeight;
var
  J,RwH: Integer;
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

procedure TViewFrame.UpdateRowHeights;
var
  I,J,RwH: Integer;
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
    for I := 0 to FRowCount - 1 do
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

procedure TViewFrame.ProcessColumnResize;
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

procedure TViewFrame.DoEnter;
begin
  if Assigned(FOnEnterFrame) then
    FOnEnterFrame(Self);
  inherited;
end;

procedure TViewFrame.DoExit;
begin
  if Assigned(FOnExitFrame) then
    FOnExitFrame(Self);
  inherited;
end;

procedure TViewFrame.RowUp;
var
  R, F: Integer;
begin
  with DataGrid do
  begin
    F := FixedRows;
    R := TopRow;
    if R > F then
      TopRow := R - 1;
  end;
end;

procedure TViewFrame.RowDown;
var
  R, F, V: Integer;
begin
  with DataGrid do
  begin
    F := FixedRows;
    R := TopRow;
    V := VisibleRowCount;
    if R - F + V < FRowCount then
      TopRow := R + 1;
  end;
end;

procedure TViewFrame.PageUp;
var
  R, F, V: Integer;
begin
  with DataGrid do
  begin
    F := FixedRows;
    V := VisibleRowCount;
    R := TopRow;
    if R > F then
    begin
      Dec(R, V);
      if R > F then
        TopRow := R
      else
        TopRow := F;
    end;
  end;
end;

procedure TViewFrame.PageDown;
var
  R, F, V: Integer;
begin
  with DataGrid do
  begin
    R := TopRow;
    V := VisibleRowCount;
    F := V - FixedRows;
    if R + F < FRowCount then
    begin
      Inc(R, V);
      if R + F < FRowCount then
        TopRow := R
      else
        TopRow := FRowCount - F;
    end;
  end;
end;

procedure TViewFrame.GoHome;
var
  F: Integer;
begin
  with DataGrid do
  begin
    F := FixedRows;
    if TopRow > F then
      TopRow := F;
  end;
end;

procedure TViewFrame.GoEnd;
var
  F, V: Integer;
begin
  with DataGrid do
  begin
    F := FixedRows;
    V := VisibleRowCount;
    if TopRow - F + V < FRowCount then
      TopRow := FRowCount - V + F;
  end;
end;

procedure TViewFrame.SetFocus;
begin
  Windows.SetFocus(DataGrid.Handle);
end;

function TViewFrame.Focused: Boolean;
begin
  Result := Screen.ActiveControl = DataGrid;
end;

procedure TViewFrame.SelectRow(Index: Integer);
var
  CurrentTop, NewTop, VC: Integer;
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
  end;
end;

function TViewFrame.GetSelectedRowIndex: Integer;
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
      Result := FRowCount-1;
      SelectRow(Result);
    end;
  end else
    Result := -1;
end;

end.

