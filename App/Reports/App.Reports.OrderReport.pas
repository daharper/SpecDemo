unit App.Reports.OrderReport;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  Base.Collections,
  Base.Dynamic,
  Domain.Orders.Order;

type
  IOrderReportSection = interface
    ['{3581D542-90E1-428C-BF09-ECEA3D51706E}']
    function Name: string;
    function Title: string;
    function Code: string;
    function Spec: ISpecification<TOrder>;
  end;

  /// <summary>
  ///  Represents a section of the report, for example: international orders.
  /// </summary>
  TOrderReportSection = class(TInterfacedObject, IOrderReportSection)
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
  ///  Represents the order report, contains a number of report sections.
  /// </summary>
  TOrderReport = class(TDynamicObject)
  private
    fSections: TList<IOrderReportSection>;

    function ToTitle(const aTitle: string): string;
  public
    function GetEnumerator: TEnumerator<IOrderReportSection>;
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

  var section := TOrderReportSection.Create(aName, title, code, spec);

  fSections.Add(section);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReport.GetEnumerator: TEnumerator<IOrderReportSection>;
begin
  Result := fSections.GetEnumerator;
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
  fSections := TList<IOrderReportSection>.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
destructor TOrderReport.Destroy;
begin
  fSections.Free;

  inherited;
end;

{----------------------------------------------------------------------------------------------------------------------}
class function TOrderReport.New: TDynamic;
begin
  Result := TOrderReport.Create.AsDynamic;
end;

{ TOrderReportSection }

{----------------------------------------------------------------------------------------------------------------------}
constructor TOrderReportSection.Create(const aName: string; const aTitle: string; const aCode: string; const aSpec: ISpecification<TOrder>);
begin
  fName  := aName;
  fTitle := aTitle;
  fCode  := aCode;
  fSpec  := aSpec;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportSection.Name: string;
begin
  Result := fName;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportSection.Title: string;
begin
  Result := fTitle;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportSection.Code: string;
begin
  Result := fCode;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderReportSection.Spec: ISpecification<TOrder>;
begin
  Result := fSpec;
end;

end.
