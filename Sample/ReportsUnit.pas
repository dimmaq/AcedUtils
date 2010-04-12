unit ReportsUnit;

interface

{ Товары по выбранному поставщику }

procedure MakeProductBySupplierReport;

{ Товары по выбранным категориям }

procedure MakeProductByCategoryReport;

{ Сводная таблица: "Поставщики - Категории" }

procedure MakeSuppliersCategoriesReport;

{ Список поставщиков }

procedure MakeSupplierReport;

implementation

uses SysUtils, Dialogs, Variants, ActiveX, ComObj, Excel97, ComCtrls,
  AcedConsts, AcedBinary, AcedStrings, AcedCommon, AcedContainers,
  AcedAlgorithm, AcedStorage, AcedExcelReport, DataTypes;

function CompareProducts(Item1, Item2: Pointer): Integer;
var
  P1, P2: TProductObject;
  C1, C2: TCategoryObject;
begin
  P1 := TProductObject(Item1);
  P2 := TProductObject(Item2);
  C1 := nil;
  if P1.CategoryID <> 0 then
    C1 := TCategoryObject(Categories.Search(P1.CategoryID));
  C2 := nil;
  if P2.CategoryID <> 0 then
    C2 := TCategoryObject(Categories.Search(P2.CategoryID));
  Result := 0;
  if C1 <> nil then
  begin
    if C2 <> nil then
      Result := G_CompareText(C1.CategoryName, C2.CategoryName)
    else
      Result := -1;
  end
  else if C2 <> nil then
    Result := 1;
  if Result = 0 then
    Result := G_CompareText(P1.ProductName, P2.ProductName);
end;

procedure MakeProductBySupplierReport;
var
  Index, Count: Integer;
  AL: TArrayList;
  CN: TIntegerList;
  I, NextC, X: Integer;
  P, PP: TProductObject;
  V: Variant;
  C: TCategoryObject;
  Cells, R: ExcelRange;
  WS: _Worksheet;
  WB: _Workbook;

begin
  Count := ProductsSupplierIDIndex.SelectRange(SelectedSupplierID,
    SelectedSupplierID + 1, Index);
  AL := TArrayList.Create(Count);
  for I := 0 to Count - 1 do
  begin
    P := TProductObject(ProductsSupplierIDIndex.ItemList^[I + Index]);
    if P.UnitsInStock > 0 then
      AL.Add(P);
  end;
  Count := AL.Count;
  if Count = 0 then
  begin
    AL.Free;
    ShowMessage('Нет данных для построения отчета.');
    Exit;
  end;
  AL.Sort(CompareProducts);
  CN := TIntegerList.Create;
  CN.Add(0);
  P := TProductObject(AL.ItemList^[0]);
  for I := 1 to Count - 1 do
  begin
    PP := TProductObject(AL.ItemList^[I]);
    if PP.CategoryID <> P.CategoryID then
    begin
      CN.Add(I);
      P := PP;
    end;
  end;

  V := VarArrayCreate([1, Count, 1, 6], varVariant);
  for I := Count downto 1 do
  begin
    P := TProductObject(AL.ItemList^[I - 1]);
    V[I, 1] := G_IntToStr(I);
    if CN.IndexOf(I - 1) >= 0 then
    begin
      C := nil;
      if P.CategoryID <> 0 then
        C := TCategoryObject(Categories.Search(P.CategoryID));
      if C <> nil then
        V[I, 2] := C.CategoryName
      else
        V[I, 2] := '(без категории)';
    end;
    V[I, 3] := P.ProductName;
    V[I, 4] := P.QuantityPerUnit;
    V[I, 5] := G_ToDouble(P.UnitPrice);
    V[I, 6] := P.UnitsInStock;
  end;
  AL.Free;

  if not (StartExcel and CreateExcelWorkbook(WB, TemplatesPath + rpProducts)) then
  begin
    CN.Free;
    Exit;
  end;
  InitializeExcelWorkbook(WB, 'Товары по выбранному поставщику', False);
  WS := WB.Worksheets[1] as _Worksheet;
  Cells := WS.Get_Cells;
  GetExcelCell(Cells, 1, 7).Value := G_FormatDate(SysUtils.Date, dfShort);
  InsertExcelRows(Cells, 4, 2);
  R := GetExcelCell(Cells, 4, 2);
  R.Value := 'Поставщик: "' +
    TSupplierObject(Suppliers.Search(SelectedSupplierID)).CompanyName + '"';
  R.Font.Bold := True;
  R.Font.Size := 12;
  R := GetExcelRange(Cells, 4, 2, 1, 6);
  R.Merge(True);
  R.HorizontalAlignment := xlHAlignCenter;
  ExcelRowOffset := 7;
  ExcelColumnOffset := 2;
  GetExcelRange(Cells, 0, 0, Count, 6).Value := V;
  NextC := Count;
  for I := CN.Count - 1 downto 0 do
  begin
    X := CN.ItemList^[I];
    if NextC - X > 1 then
    begin
      R := GetExcelRange(Cells, X, 1, NextC - X, 1);
      R.Merge(False);
      R.VerticalAlignment := xlVAlignTop;
      R.WrapText := True;
    end;
    NextC := X;
  end;
  GetExcelRange(Cells, 0, 0, Count, 1).HorizontalAlignment := xlHAlignCenter;
  GetExcelRange(Cells, 0, 4, Count, 1).NumberFormatLocal := '# ##0,00р.';
  DrawExcelBorders(GetExcelRange(Cells, -1, 0, Count + 1, 6), xlcbAll);
  CN.Free;

  ProtectExcelWorksheet(WS);
  G_ToggleKey(tkScrollLock, True);
  ShowExcelWorkbook(WB);
end;

procedure MakeProductByCategoryReport;
var
  Count: Integer;
  AL: TArrayList;
  CN: TIntegerList;
  I, NextC, X: Integer;
  P, PP: TProductObject;
  V: Variant;
  C: TCategoryObject;
  Cells, R: ExcelRange;
  WS: _Worksheet;
  WB: _Workbook;

begin
  Count := Products.Count;
  AL := TArrayList.Create(Count);
  for I := 0 to Count - 1 do
  begin
    P := TProductObject(Products.ItemList^[I]);
    if (P.UnitsInStock > 0) and (CheckedCategories.IndexOf(P.CategoryID) >= 0) then
      AL.Add(P);
  end;
  Count := AL.Count;
  if Count = 0 then
  begin
    AL.Free;
    ShowMessage('Нет данных для построения отчета.');
    Exit;
  end;
  AL.Sort(CompareProducts);
  CN := TIntegerList.Create;
  CN.Add(0);
  P := TProductObject(AL.ItemList^[0]);
  for I := 1 to Count - 1 do
  begin
    PP := TProductObject(AL.ItemList^[I]);
    if PP.CategoryID <> P.CategoryID then
    begin
      CN.Add(I);
      P := PP;
    end;
  end;

  V := VarArrayCreate([1, Count, 1, 6], varVariant);
  for I := Count downto 1 do
  begin
    P := TProductObject(AL.ItemList^[I - 1]);
    V[I, 1] := G_IntToStr(I);
    if CN.IndexOf(I - 1) >= 0 then
    begin
      C := nil;
      if P.CategoryID <> 0 then
        C := TCategoryObject(Categories.Search(P.CategoryID));
      if C <> nil then
        V[I, 2] := C.CategoryName
      else
        V[I, 2] := '(без категории)';
    end;
    V[I, 3] := P.ProductName;
    V[I, 4] := P.QuantityPerUnit;
    V[I, 5] := G_ToDouble(P.UnitPrice);
    V[I, 6] := P.UnitsInStock;
  end;
  AL.Free;

  if not (StartExcel and CreateExcelWorkbook(WB, TemplatesPath + rpProducts)) then
  begin
    CN.Free;
    Exit;
  end;
  InitializeExcelWorkbook(WB, 'Товары по выбранным категориям', False);
  WS := WB.Worksheets[1] as _Worksheet;
  Cells := WS.Get_Cells;
  GetExcelCell(Cells, 1, 7).Value := G_FormatDate(SysUtils.Date, dfShort);
  InsertExcelRows(Cells, 4);
  GetExcelCell(Cells, 4, 2).Value := 'по выбранным категориям товаров';
  ExcelRowOffset := 6;
  ExcelColumnOffset := 2;
  GetExcelRange(Cells, 0, 0, Count, 6).Value := V;
  NextC := Count;
  for I := CN.Count - 1 downto 0 do
  begin
    X := CN.ItemList^[I];
    if NextC - X > 1 then
    begin
      R := GetExcelRange(Cells, X, 1, NextC - X, 1);
      R.Merge(False);
      R.VerticalAlignment := xlVAlignTop;
      R.WrapText := True;
    end;
    NextC := X;
  end;
  GetExcelRange(Cells, 0, 0, Count, 1).HorizontalAlignment := xlHAlignCenter;
  GetExcelRange(Cells, 0, 4, Count, 1).NumberFormatLocal := '# ##0,00р.';
  DrawExcelBorders(GetExcelRange(Cells, -1, 0, Count + 1, 6), xlcbAll);
  CN.Free;

  ProtectExcelWorksheet(WS);
  G_ToggleKey(tkScrollLock, True);
  ShowExcelWorkbook(WB);
end;

function MatchSupplier(Value, Item: Pointer): Integer;
var
  S1, S2: TSupplierObject;
begin
  S1 := TSupplierObject(Value);
  S2 := TSupplierObject(Item);
  Result := 0;
  if (S1 <> nil) and (S2 <> nil) then
  begin
    if S1.ID <> S2.ID then
      Result := G_CompareText(S1.CompanyName, S2.CompanyName);
  end
  else if S1 <> nil then
    Result := -1
  else if S2 <> nil then
    Result := 1;
end;

function MatchCategory(Value, Item: Pointer): Integer;
var
  C1, C2: TCategoryObject;
begin
  C1 := TCategoryObject(Value);
  C2 := TCategoryObject(Item);
  Result := 0;
  if (C1 <> nil) and (C2 <> nil) then
  begin
    if C1.ID <> C2.ID then
      Result := G_CompareText(C1.CategoryName, C2.CategoryName);
  end
  else if C1 <> nil then
    Result := -1
  else if C2 <> nil then
    Result := 1;
end;

procedure MakeSuppliersCategoriesReport;
var
  I, J, SI, CI: Integer;
  SL, CL: TArrayList;
  DL: PCurrencyItemList;
  P: TProductObject;
  S: TSupplierObject;
  C: TCategoryObject;
  RowCount, ColumnCount: Integer;
  V: Variant;
  D: Double;
  Cells, R: ExcelRange;
  WS: _Worksheet;
  WB: _Workbook;

begin
  SL := TArrayList.Create;
  CL := TArrayList.Create;
  for I := Products.Count - 1 downto 0 do
  begin
    P := TProductObject(Products.ItemList^[I]);
    S := nil;
    if P.SupplierID <> 0 then
      S := TSupplierObject(Suppliers.Search(P.SupplierID));
    if not G_BinarySearch(S, SL.ItemList, SL.Count, MatchSupplier, SI) then
      SL.Insert(SI, S);
    C := nil;
    if P.CategoryID <> 0 then
      C := TCategoryObject(Categories.Search(P.CategoryID));
    if not G_BinarySearch(C, CL.ItemList, CL.Count, MatchCategory, CI) then
      CL.Insert(CI, C);
  end;
  if SL.Count = 0 then
  begin
    SL.Free;
    CL.Free;
    ShowMessage('Нет данных для построения отчета.');
    Exit;
  end;
  I := SL.Count * CL.Count * SizeOf(Currency);
  GetMem(DL, I);
  G_FillLongs(0, DL, I shr 2);
  for I := Products.Count - 1 downto 0 do
  begin
    P := TProductObject(Products.ItemList^[I]);
    S := nil;
    if P.SupplierID <> 0 then
      S := TSupplierObject(Suppliers.Search(P.SupplierID));
    G_BinarySearch(S, SL.ItemList, SL.Count, MatchSupplier, SI);
    C := nil;
    if P.CategoryID <> 0 then
      C := TCategoryObject(Categories.Search(P.CategoryID));
    G_BinarySearch(C, CL.ItemList, CL.Count, MatchCategory, CI);
    G_Inc(DL^[CL.Count * SI + CI],
      P.UnitPrice * (P.UnitsInStock + P.UnitsOnOrder));
  end;

  RowCount := SL.Count + 1;
  ColumnCount := CL.Count + 1;
  V := VarArrayCreate([1, RowCount, 1, ColumnCount], varVariant);
  for I := 0 to SL.Count - 1 do
  begin
    S := TSupplierObject(SL.ItemList^[I]);
    if S <> nil then
      V[I + 2, 1] := S.CompanyName
    else
      V[I + 2, 1] := '(поставщик не указан)';
  end;
  for I := 0 to CL.Count - 1 do
  begin
    C := TCategoryObject(CL.ItemList^[I]);
    if C <> nil then
      V[1, I + 2] := C.CategoryName
    else
      V[1, I + 2] := '(без категории)';
  end;
  for I := SL.Count - 1 downto 0 do
    for J := CL.Count - 1 downto 0 do
    begin
      D := G_ToDouble(DL^[CL.Count * I + J]);
      if D >= 0.01 then
        V[I + 2, J + 2] := D;
    end;

  if not (StartExcel and CreateExcelWorkbook(WB)) then
    Exit;
  InitializeExcelWorkbook(WB, 'Сводная таблица по поставщикам и категориям товаров', False);
  WS := WB.Worksheets[1] as _Worksheet;
  Cells := WS.Get_Cells;
  Cells.Font.Italic := True;
  GetExcelColumns(Cells, 1, 1).ColumnWidth := 0.1;
  GetExcelCell(Cells, 1, 2).Value := G_FormatDate(SysUtils.Date, dfShort);
  R := GetExcelCell(Cells, 2, 2);
  R.Value := 'Стоимость товара по поставщикам и категориям';
  R.Font.Size := 18;
  ExcelRowOffset := 4;
  ExcelColumnOffset := 2;
  R := GetExcelRange(Cells, 0, 0, RowCount, ColumnCount);
  R.Value := V;
  GetExcelCell(Cells, 0, 0).Value := 'Поставщик\Категория';
  GetExcelCell(Cells, RowCount, 0).Value := 'Итого:';
  GetExcelCell(Cells, 0, ColumnCount).Value := 'Всего';
  R := GetExcelRange(Cells, 0, 1, 1, ColumnCount);
  R.HorizontalAlignment := xlHAlignCenter;
  R.Font.Bold := True;
  GetExcelRange(Cells, 1, 0, RowCount, 1).Font.Bold := True;
  AssignRelativeFormula(1, ColumnCount, 1, 1, 1, CL.Count, xlrfSum,
    GetExcelRange(Cells, 1, ColumnCount, SL.Count, 1));
  AssignRelativeFormula(RowCount, 1, 1, 1, SL.Count, 1, xlrfSum,
    GetExcelRange(Cells, RowCount, 1, 1, CL.Count + 1));
  GetExcelRange(Cells, 1, 1, RowCount, ColumnCount).NumberFormatLocal := '# ##0,00р.';
  R := GetExcelRange(Cells, 0, 0, RowCount + 1, ColumnCount + 1);
  DrawExcelBorders(R, xlcbAll);
  R.Columns.AutoFit;
  FreeMem(DL);
  SL.Free;
  CL.Free;

  G_ToggleKey(tkScrollLock, False);
  ShowExcelWorkbook(WB);
end;

procedure MakeSupplierReport;
var
  I, J, Count: Integer;
  WS: _Worksheet;
  WB: _Workbook;
  Cells, R: ExcelRange;
  InStock, OnOrder: Currency;
  V: Variant;
  S: TSupplierObject;
  P: TProductObject;
  PI, PC: Integer;
begin
  Count := Suppliers.Count;
  if Count = 0 then
  begin
    ShowMessage('Нет данных для построения отчета.');
    Exit;
  end;

  V := VarArrayCreate([1, Count, 1, 5], varVariant);
  for I := Count downto 1 do
  begin
    S := TSupplierObject(SuppliersCompanyNameIndex.ItemList^[I - 1]);
    V[I, 1] := G_IntToStr(I) + '. ' + S.CompanyName;
    V[I, 2] := S.CityRegion;
    PC := ProductsSupplierIDIndex.SelectRange(S.ID, S.ID + 1, PI);
    InStock := 0;
    OnOrder := 0;
    for J := 0 to PC - 1 do
    begin
      P := TProductObject(ProductsSupplierIDIndex.ItemList^[PI + J]);
      G_Inc(InStock, P.UnitPrice * P.UnitsInStock);
      G_Inc(OnOrder, P.UnitPrice * P.UnitsOnOrder);
    end;
    V[I, 3] := G_ToDouble(InStock);
    V[I, 4] := G_ToDouble(OnOrder);
    V[I, 5] := S.Comments;
  end;

  if not (StartExcel and CreateExcelWorkbook(WB, TemplatesPath + rpSuppliers)) then
    Exit;
  InitializeExcelWorkbook(WB, 'Список поставщиков', False);
  WS := WB.Worksheets[1] as _Worksheet;
  Cells := WS.Get_Cells;
  GetExcelCell(Cells, 1, 6).Value := G_FormatDate(SysUtils.Date, dfShort);
  ExcelRowOffset := 5;
  ExcelColumnOffset := 2;
  GetExcelRange(Cells, 0, 0, Count, 5).Value := V;
  R := GetExcelCell(Cells, Count, 0);
  R.Value := 'Итого:';
  R.Font.Bold := True;
  AssignRelativeFormula(Count, 2, 0, 2, Count, 1, xlrfSum,
    GetExcelRange(Cells, Count, 2, 1, 2));
  GetExcelRange(Cells, 0, 2, Count + 1, 2).NumberFormatLocal := '# ##0,00р.';
  DrawExcelBorders(GetExcelRange(Cells, -1, 0, Count + 2, 5), xlcbAll);

  ProtectExcelWorksheet(WS);
  G_ToggleKey(tkScrollLock, True);
  ShowExcelWorkbook(WB);
end;

end.

