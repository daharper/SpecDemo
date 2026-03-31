unit Domain.Orders.Service;

interface

uses
  System.Generics.Collections,
  Base.Integrity,
  Base.Collections,
  Domain.Orders.Order,
  Domain.Orders.Specifications;

type
  /// <summary>
  ///  The business service for our orders.
  /// </summary>
  TOrderService = class
  public
    function GetHighValueOrders: ISpecification<TOrder>;
    function GetConfirmedHighValueOrders: ISpecification<TOrder>;
    function GetConfirmedInternationalOrders: ISpecification<TOrder>;
    function GetInternationalOrders: ISpecification<TOrder>;
    function GetHighRiskOrders: ISpecification<TOrder>;
    function GetVeryHighRiskOrders: ISpecification<TOrder>;
    function GetHighRiskInternationalOrders: ISpecification<TOrder>;
    function GetHighRiskUnconfirmedInternationalOrders: ISpecification<TOrder>;
    function GetPriorityCustomerOrders: ISpecification<TOrder>;
    function GetPriorityInternationalOrders: ISpecification<TOrder>;
    function GetConfirmedPriorityOrders: ISpecification<TOrder>;
    function GetHighValuePriorityOrders: ISpecification<TOrder>;
    function GetFragileOrders: ISpecification<TOrder>;
    function GetFragileInternationalOrders: ISpecification<TOrder>;
    function GetConfirmedFragileOrders: ISpecification<TOrder>;
    function GetOrdersNeedingSpecialHandling: ISpecification<TOrder>;
    function GetOrdersRequiringSignature: ISpecification<TOrder>;
    function GetOrdersReadyForPriorityFulfillment: ISpecification<TOrder>;
    function GetPremiumInternationalOrders: ISpecification<TOrder>;
    function GetTrustedSpecialHandlingOrders: ISpecification<TOrder>;
    function GetOrdersForEscalatedReview: ISpecification<TOrder>;
  end;

implementation

uses
  System.SysUtils;

{ TOrderService }

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetHighValueOrders: ISpecification<TOrder>;
begin
  Result := TOrderTotalAtLeastSpecification.Create(1000.00);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetConfirmedHighValueOrders: ISpecification<TOrder>;
begin
  Result := TOrderTotalAtLeastSpecification.Create(1000.00)
    .AndAlso(TPaymentConfirmedSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetInternationalOrders: ISpecification<TOrder>;
begin
  Result := TInternationalOrderSpecification.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetConfirmedInternationalOrders: ISpecification<TOrder>;
begin
  Result := TInternationalOrderSpecification.Create
    .AndAlso(TPaymentConfirmedSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetHighRiskOrders: ISpecification<TOrder>;
begin
  Result := THighRiskOrderSpecification.Create(40);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetHighRiskInternationalOrders: ISpecification<TOrder>;
begin
  Result := THighRiskOrderSpecification.Create(40)
    .AndAlso(TInternationalOrderSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetVeryHighRiskOrders: ISpecification<TOrder>;
begin
  Result := THighRiskOrderSpecification.Create(80);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetHighRiskUnconfirmedInternationalOrders: ISpecification<TOrder>;
begin
  Result := THighRiskOrderSpecification.Create(40)
    .AndAlso(TInternationalOrderSpecification.Create)
    .AndAlso(TPaymentConfirmedSpecification.Create.NotThis);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetPriorityCustomerOrders: ISpecification<TOrder>;
begin
  Result := TPriorityCustomerSpecification.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetPriorityInternationalOrders: ISpecification<TOrder>;
begin
  Result := TPriorityCustomerSpecification.Create
    .AndAlso(TInternationalOrderSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetConfirmedPriorityOrders: ISpecification<TOrder>;
begin
  Result := TPriorityCustomerSpecification.Create
    .AndAlso(TPaymentConfirmedSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetHighValuePriorityOrders: ISpecification<TOrder>;
begin
  Result := TPriorityCustomerSpecification.Create
    .AndAlso(TOrderTotalAtLeastSpecification.Create(1000.00));
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetFragileOrders: ISpecification<TOrder>;
begin
  Result := TFragileOrderSpecification.Create
    .AndAlso(TInternationalOrderSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetFragileInternationalOrders: ISpecification<TOrder>;
begin
  Result := TFragileOrderSpecification.Create
    .AndAlso(TInternationalOrderSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetConfirmedFragileOrders: ISpecification<TOrder>;
begin
  Result := TFragileOrderSpecification.Create
    .AndAlso(TPaymentConfirmedSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetOrdersRequiringSignature: ISpecification<TOrder>;
begin
  Result := TRequiresSignatureSpecification.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetOrdersNeedingSpecialHandling: ISpecification<TOrder>;
begin
  Result := TFragileOrderSpecification.Create
    .OrElse(TRequiresSignatureSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetOrdersReadyForPriorityFulfillment: ISpecification<TOrder>;
begin
  Result := TOrderTotalAtLeastSpecification.Create(1000.00)
    .AndAlso(TPriorityCustomerSpecification.Create)
    .AndAlso(TPaymentConfirmedSpecification.Create)
    .AndAlso(THighRiskOrderSpecification.Create(40).NotThis);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetPremiumInternationalOrders: ISpecification<TOrder>;
begin
  Result := TOrderTotalAtLeastSpecification.Create(1000.00)
    .AndAlso(TInternationalOrderSpecification.Create)
    .AndAlso(TPriorityCustomerSpecification.Create)
    .AndAlso(TPaymentConfirmedSpecification.Create);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetTrustedSpecialHandlingOrders: ISpecification<TOrder>;
begin
  Result := TPaymentConfirmedSpecification.Create
    .AndAlso(THighRiskOrderSpecification.Create(40).NotThis)
    .AndAlso(
      TFragileOrderSpecification.Create
        .OrElse(TRequiresSignatureSpecification.Create)
    );
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderService.GetOrdersForEscalatedReview: ISpecification<TOrder>;
begin
  Result := TPaymentConfirmedSpecification.Create.NotThis
    .AndAlso(
      THighRiskOrderSpecification.Create(40)
        .OrElse(TInternationalOrderSpecification.Create)
    )
    .AndAlso(TOrderTotalAtLeastSpecification.Create(1000.00));
end;

end.
