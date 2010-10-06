
////////////////////////////////////////////////////
//                                                //
//   AcedGrids 1.03                               //
//                                                //
//   Общие типы для Grid, Check и View фреймов.   //
//                                                //
//   mailto: acedutils@yandex.ru                  //
//                                                //
////////////////////////////////////////////////////

unit AcedGrids;

interface

uses Classes, Graphics, Grids, AcedConsts;

const
  MaxLastGridColumn = 9999;

type

{ Запись, описывающая столбец грида. }

  PGridColumnInfo = ^TGridColumnInfo;
  TGridColumnInfo = record
    Title: AnsiString;              // Заголовок столбца
    Alignment: TAlignment;      // Выравнивание текста в столбце
    TitleAlignment: TAlignment; // Выравнивание текста в заголовке
    Width: Integer;             // Ширина столбца (в пикселах)
    LeftIndent: Integer;        // Отступ с левого края ячейки
    RightIndent: Integer;       // Отступ с правого края
    Searched: Boolean;          // Если False, столбец не участвует в поиске
  end;

  PGridColumnList = ^TGridColumnList;
  TGridColumnList = array[0..MaxLastGridColumn] of TGridColumnInfo;

{ Описание типа функции обратного вызова, используемой для получения текста,
  выводимого в ячейках сетки. }

  TGridGetDataEvent = procedure (Sender: TObject) of object;

{ Описание типа функции обратного вызова, которая может использоваться для
  задания цвета, которым выводится текст в конкретной ячейке. RowIndex -
  индекс записи (первая строка после шапки имеет индекс ноль), ColumnIndex -
  номер столбца (нумерация с нуля). Если Selected равно True, текущая запись
  является выделенной. Если Inactive равно True, фрейм сейчас не является
  активным, т.е. не владеет фокусом ввода. Функция должна вернуть цвет,
  которым выводится текст в текущей ячейке или clDefault. }

  TGridCellGetColorEvent = function (Sender: TObject; RowIndex,
    ColumnIndex: Integer; Selected, Inactive: Boolean): TColor of object;

  TViewCellGetColorEvent = function (Sender: TObject; RowIndex,
    ColumnIndex: Integer): TColor of object;

{ Описание типа процедуры, которая может вызываться при выделении записи или
  при двойном щелчке мышью на записи. Sender - как обычно, источник события,
  а RowIndex - индекс выбранной записи. }

  TGridFrameEvent = procedure (Sender: TObject; RowIndex: Integer) of object;

{ Описание типа процедуры, которая может вызываться при перемещение фокуса
  ввода на данный фрейм, или, наоборот, при потере фреймом фокуса ввода. }

  TGridEnterExitEvent = procedure (Sender: TObject) of object;

{ Описание типа процедуры, которая вызывается при нажатии на клавишу. }

  TGridKeyDownEvent = procedure (Sender: TObject; RowIndex: Integer;
    Key: Word; Shift: TShiftState) of object;

  TViewKeyDownEvent = procedure (Sender: TObject; Key: Word;
    Shift: TShiftState) of object;

  TViewKeyPressEvent = procedure (Sender: TObject; Key: AnsiChar) of object;

{ Описание типа процедуры, которая вызывается при пометке или разметке записей. }

  TCheckStateChangedEvent = procedure (Sender: TObject) of object;

implementation

end.

