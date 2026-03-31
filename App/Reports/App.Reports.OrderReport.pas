unit App.Reports.OrderReport;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  Base.Collections,
  Base.Dynamic,
  Domain.Orders.Order;

type
  IOrderReportItem = interface
    ['{3581D542-90E1-428C-BF09-ECEA3D51706E}']
    function Name: string;
    function Title: string;
    function Code: string;
    function Spec: ISpecification<TOrder>;
  end;

  /// <summary>
  ///  Represents a section of the report, for example: international orders.
  /// </summary>
  TOrderReportItem = class(TInterfacedObject, IOrderReportItem)
  private
    fName:  string;
    fTitle: string;
    fCode:  string;
    fSpec: ISpecification<TOrder>;
  public
    function Name:  string;
    function Title: string;
    function Code:  string;
    function Spec:  ISpecification<TOrder>;

    constructor Create(const aName: string; const aTitle: string; const aCode: string; const aSpec: ISpecification<TOrder>);
  end;

  /// <summary>
  ///  Represents the order report, contains a number of report items.
  /// </summary>
  TOrderReport = class(TDynamicObject)
  private
    fItems: TList<IOrderReportItem>;

    function ToTitle(const aTitle: string): string;
  public
    function GetEnumerator: TEnumerator<IOrderReportItem>;
    function MethodMissing(const aName: string; const aHint: TInvokeHint; const aArgs: TArray<Variant>): Variant; override;

    constructor Create;
    destructor Destroy; override;

    class function New: TDynamic;
  end;

implementation

uses
  System.SysUtils,
  System.Character,
  App.Reports.CodeRegistry;

{ TOrderReport }

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReport.MethodMissing(const aName: string; const aHint: TInvokeHint; const aArgs: TArray<Variant>): Variant;
begin
  if (aHint <> ivPropertySetRef) or (Length(aArgs) <> 1) then exit;

  var spec  := IUnknown(aArgs[0]) as ISpecification<TOrder>;
  var title := ToTitle(aName);
  var code  := CodeRegistry[aName];
  var item  := TOrderReportItem.Create(aName, title, code, spec);

  fItems.Add(item);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReport.GetEnumerator: TEnumerator<IOrderReportItem>;
begin
  Result := fItems.GetEnumerator;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReport.ToTitle(const aTitle: string): string;
begin
  for var ch in aTitle do
    if ch.IsUpper then
      Result := Result + ' ' + ch
    else
      Result := Result + ch;

  Result := Result.Trim;
end;

{----------------------------------------------------------------------------------------------------------------------}
constructor TOrderReport.Create;
begin
  fItems := TList<IOrderReportItem>.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
destructor TOrderReport.Destroy;
begin
  fItems.Free;

  inherited;
end;

{----------------------------------------------------------------------------------------------------------------------}
class function TOrderReport.New: TDynamic;
begin
  Result := TOrderReport.Create.AsDynamic;
end;

{ TOrderReportItem }

{----------------------------------------------------------------------------------------------------------------------}
constructor TOrderReportItem.Create(const aName: string; const aTitle: string; const aCode: string; const aSpec: ISpecification<TOrder>);
begin
  fName  := aName;
  fTitle := aTitle;
  fCode  := aCode;
  fSpec  := aSpec;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportItem.Name: string;
begin
  Result := fName;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportItem.Title: string;
begin
  Result := fTitle;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportItem.Code: string;
begin
  Result := fCode;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportItem.Spec: ISpecification<TOrder>;
begin
  Result := fSpec;
end;

end.
