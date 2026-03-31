unit App.Reports.CodeRegistry;

interface

uses
  System.Generics.Collections;

type
  /// <summary>
  ///  A simple registry for code samples.
  /// </summary>
  TCodeRegistry = class
  private
    fCode: TDictionary<string, string>;

    class var fInstance: TCodeRegistry;

    function GetSnippet(const aName: string): string;

    procedure AddHighValueOrdersSnippet;
    procedure AddInternationalOrders;

    procedure AddConfirmedHighValueOrders;
    procedure AddPriorityInternationalOrders;
    procedure AddUnconfirmedHighRiskInternationalOrders;
    procedure AddOrdersNeedingSpecialHandling;

    procedure AddOrdersReadyForPriorityFulfillment;
    procedure AddPremiumInternationalOrders;
    procedure AddTrustedSpecialHandlingOrders;
    procedure AddOrdersForEscalatedReview;

    procedure AddStream;
    procedure AddDynamicObject;
    procedure AddScope;
  public
    property Snippet[const aName: string]: string read GetSnippet; default;

    constructor Create;
    destructor Destroy; override;

    class constructor Create;
    class destructor Destroy;
  end;

  function CodeRegistry: TCodeRegistry;

implementation

uses
  System.SysUtils,
  System.Generics.Defaults;

{ TCodeRegistry }

{----------------------------------------------------------------------------------------------------------------------}
function CodeRegistry: TCodeRegistry;
begin
  Result := TCodeRegistry.fInstance;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TCodeRegistry.GetSnippet(const aName: string): string;
begin
  Result := fCode[aName];
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddHighValueOrdersSnippet;
const
  CODE =  '''
          { Example 1: basic }

          // Order Service

          function TOrderService.GetHighValueOrders: ISpecification<TOrder>;
          begin
            Result := TOrderTotalAtLeastSpecification.Create(1000.00);
          end;

          // Specifications

          function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.TotalAmount >= fMinimumAmount;
          end;
          ''';
begin
  fCode.Add('HighValueOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddInternationalOrders;
const
  CODE =  '''
          { Example 2: basic }

          // Order Service

          function TOrderService.GetInternationalOrders: ISpecification<TOrder>;
          begin
            Result := TInternationalOrderSpecification.Create;
          end;

          // Specifications

          function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsInternational;
          end;
          ''';
begin
  fCode.Add('InternationalOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddConfirmedHighValueOrders;
const
  CODE =  '''
          { Example 3: composed }

          // Order Service

          function TOrderService.GetConfirmedHighValueOrders: ISpecification<TOrder>;
          begin
            Result := TOrderTotalAtLeastSpecification.Create(1000.00)
              .AndAlso(TPaymentConfirmedSpecification.Create);
          end;

          // Specifications

          function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.TotalAmount >= fMinimumAmount;
          end;

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;
          ''';
begin
  fCode.Add('ConfirmedHighValueOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddPriorityInternationalOrders;
const
  CODE =  '''
          { Example 4: composed }

          // Order Service

          function TOrderService.GetPriorityInternationalOrders: ISpecification<TOrder>;
          begin
            Result := TPriorityCustomerSpecification.Create
              .AndAlso(TInternationalOrderSpecification.Create);
          end;

          // Specifications

          function TPriorityCustomerSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsPriorityCustomer;
          end;

          function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsInternational;
          end;
          ''';
begin
  fCode.Add('PriorityInternationalOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddUnconfirmedHighRiskInternationalOrders;
const
  CODE =  '''
          { Example 5: composed }

          // Order Service

          function TOrderService.GetHighRiskUnconfirmedInternationalOrders: ISpecification<TOrder>;
          begin
            Result := THighRiskOrderSpecification.Create(40)
              .AndAlso(TInternationalOrderSpecification.Create)
              .AndAlso(TPaymentConfirmedSpecification.Create.NotThis);
          end;

          // Specifications

          function THighRiskOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RiskScore >= fMinimumRiskScore;
          end;

          function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsInternational;
          end;

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;
          ''';
begin
  fCode.Add('UnconfirmedHighRiskInternationalOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddOrdersNeedingSpecialHandling;
const
  CODE =  '''
          { Example 6: composed }

          // Order Service

          function TOrderService.GetOrdersNeedingSpecialHandling: ISpecification<TOrder>;
          begin
            Result := TFragileOrderSpecification.Create
              .OrElse(TRequiresSignatureSpecification.Create);
          end;

          // Specifications

          function TFragileOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.ContainsFragileItems;
          end;

          function TRequiresSignatureSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RequiresSignature;
          end;
          ''';
begin
  fCode.Add('OrdersNeedingSpecialHandling', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddOrdersReadyForPriorityFulfillment;
const
  CODE =  '''
          { Example 7: advanced }

          // Order Service

          function TOrderService.GetOrdersReadyForPriorityFulfillment: ISpecification<TOrder>;
          begin
            Result := TOrderTotalAtLeastSpecification.Create(1000.00)
              .AndAlso(TPriorityCustomerSpecification.Create)
              .AndAlso(TPaymentConfirmedSpecification.Create)
              .AndAlso(THighRiskOrderSpecification.Create(40).NotThis);
          end;

          // Specifications

          function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.TotalAmount >= fMinimumAmount;
          end;

          function TPriorityCustomerSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsPriorityCustomer;
          end;

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;

          function THighRiskOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RiskScore >= fMinimumRiskScore;
          end;
          ''';
begin
  fCode.Add('OrdersReadyForPriorityFulfillment', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddPremiumInternationalOrders;
const
  CODE =  '''
          { Example 8: advanced }

          // Order Service

          function TOrderService.GetPremiumInternationalOrders: ISpecification<TOrder>;
          begin
            Result := TOrderTotalAtLeastSpecification.Create(1000.00)
              .AndAlso(TInternationalOrderSpecification.Create)
              .AndAlso(TPriorityCustomerSpecification.Create)
              .AndAlso(TPaymentConfirmedSpecification.Create);
          end;

          // Specifications

          function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.TotalAmount >= fMinimumAmount;
          end;

          function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsInternational;
          end;

          function TPriorityCustomerSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsPriorityCustomer;
          end;

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;
          ''';
begin
  fCode.Add('PremiumInternationalOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddTrustedSpecialHandlingOrders;
const
  CODE =  '''
          { Example 9: advanced }

          // Order Service

          function TOrderService.GetTrustedSpecialHandlingOrders: ISpecification<TOrder>;
          begin
            Result := TPaymentConfirmedSpecification.Create
              .AndAlso(THighRiskOrderSpecification.Create(40).NotThis)
              .AndAlso(
                TFragileOrderSpecification.Create
                  .OrElse(TRequiresSignatureSpecification.Create)
              );
          end;

          // Specifications

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;

          function THighRiskOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RiskScore >= fMinimumRiskScore;
          end;

          function TFragileOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.ContainsFragileItems;
          end;

          function TRequiresSignatureSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RequiresSignature;
          end;
          ''';
begin
  fCode.Add('TrustedSpecialHandlingOrders', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddOrdersForEscalatedReview;
const
  CODE =  '''
          { Example 10: advanced }

          // Order Service

          function TOrderService.GetOrdersForEscalatedReview: ISpecification<TOrder>;
          begin
            Result := TPaymentConfirmedSpecification.Create.NotThis
              .AndAlso(
                THighRiskOrderSpecification.Create(40)
                  .OrElse(TInternationalOrderSpecification.Create)
              )
              .AndAlso(TOrderTotalAtLeastSpecification.Create(1000.00));
          end;

          // Specifications

          function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.PaymentConfirmed;
          end;

          function THighRiskOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.RiskScore >= fMinimumRiskScore;
          end;

          function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.IsInternational;
          end;

          function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
          begin
            Result := aCandidate.TotalAmount >= fMinimumAmount;
          end;
          ''';
begin
  fCode.Add('OrdersForEscalatedReview', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddStream;
const
  CODE =  '''
          { using Stream to build the table rows }

          Stream
            .From<TOrder>(Orders)
            .Filter(item.Spec)
            .ForEach(
              procedure(const o: TOrder)
              begin
                var row := rowTemplate
                              .Replace('[ID]',    o.Id.ToString)
                              .Replace('[NAME]',  o.CustomerName)
                              .Replace('[TOTAL]', o.TotalAmount.ToString)
                              .Replace('[PAID]',  PAID[o.PaymentConfirmed])
                              .Replace('[TEXT]',  TEXT[o.PaymentConfirmed]);
                rows := rows + row;
              end);


          ''';
begin
  fCode.Add('Stream', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddDynamicObject;
const
  CODE =  '''
          { Using DynamicObject for the report }

          TOrderReport = class(TDynamicObject)
            // ...
          end;

          // Building the sections of the report dynamically

          function TOrderReport.MethodMissing(const aName: string; const aHint: TInvokeHint; const aArgs...)
          begin
            if (aHint <> ivPropertySetRef) or (Length(aArgs) <> 1) then exit;

            var spec  := IUnknown(aArgs[0]) as ISpecification<TOrder>;
            var title := ToTitle(aName);
            var code  := CodeRegistry[aName];

            var section := TOrderReportSection.Create(aName, title, code, spec);

            fSections.Add(section);
          end;

          // Adding report items dynamically

          report.HighValueOrders     := service.GetHighValueOrders;
          report.InternationalOrders := service.GetInternationalOrders;

          ''';
begin
  fCode.Add('DynamicObject', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.AddScope;
const
  CODE =  '''
          { Scope manages the lifetime of the objects }

          var
            scope: TScope;
          begin
            var report  := scope.Owns(TOrderReport.Create);
            var service := scope.Owns(TOrderService.Create);

            // report and service are automatically cleaned up
          end;
          ''';
begin
  fCode.Add('Scope', CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
constructor TCodeRegistry.Create;
begin
  fCode := TDictionary<string, string>.Create(TIStringComparer.Ordinal);

  // basic
  AddHighValueOrdersSnippet;
  AddInternationalOrders;

  // intermediate
  AddConfirmedHighValueOrders;
  AddPriorityInternationalOrders;
  AddUnconfirmedHighRiskInternationalOrders;
  AddOrdersNeedingSpecialHandling;

  // advanced
  AddOrdersReadyForPriorityFulfillment;
  AddPremiumInternationalOrders;
  AddTrustedSpecialHandlingOrders;
  AddOrdersForEscalatedReview;

  // snippets
  AddStream;
  AddDynamicObject;
  AddScope;
end;

{----------------------------------------------------------------------------------------------------------------------}
destructor TCodeRegistry.Destroy;
begin
  fCode.Free;
end;

{----------------------------------------------------------------------------------------------------------------------}
class constructor TCodeRegistry.Create;
begin
  fInstance := TCodeRegistry.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
class destructor TCodeRegistry.Destroy;
begin
  FreeAndNil(fInstance);
end;

end.
