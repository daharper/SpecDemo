unit Domain.Orders.Specifications;

interface

uses
  Base.Collections,
  Domain.Orders.Order;

type
  TOrderTotalAtLeastSpecification = class(TSpecification<TOrder>)
  private
    fMinimumAmount: Currency;
  public
    constructor Create(const aMinimumAmount: Currency);
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  TPaymentConfirmedSpecification = class(TSpecification<TOrder>)
  public
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  TInternationalOrderSpecification = class(TSpecification<TOrder>)
  public
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  THighRiskOrderSpecification = class(TSpecification<TOrder>)
  private
    fMinimumRiskScore: Integer;
  public
    constructor Create(const aMinimumRiskScore: Integer);
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  TPriorityCustomerSpecification = class(TSpecification<TOrder>)
  public
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  TFragileOrderSpecification = class(TSpecification<TOrder>)
  public
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

  TRequiresSignatureSpecification = class(TSpecification<TOrder>)
  public
    function IsSatisfiedBy(const aCandidate: TOrder): Boolean; override;
  end;

implementation

{ TOrderTotalAtLeastSpecification }

{----------------------------------------------------------------------------------------------------------------------}
constructor TOrderTotalAtLeastSpecification.Create(const aMinimumAmount: Currency);
begin
  inherited Create;

  fMinimumAmount := aMinimumAmount;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TOrderTotalAtLeastSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.TotalAmount >= fMinimumAmount;
end;

{ TPaymentConfirmedSpecification }

{----------------------------------------------------------------------------------------------------------------------}
function TPaymentConfirmedSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.PaymentConfirmed;
end;

{ TInternationalOrderSpecification }

{----------------------------------------------------------------------------------------------------------------------}
function TInternationalOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.IsInternational;
end;


{ THighRiskOrderSpecification }

{----------------------------------------------------------------------------------------------------------------------}
constructor THighRiskOrderSpecification.Create(const aMinimumRiskScore: Integer);
begin
  inherited Create;
  fMinimumRiskScore := aMinimumRiskScore;
end;

{----------------------------------------------------------------------------------------------------------------------}
function THighRiskOrderSpecification.IsSatisfiedBy(
  const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.RiskScore >= fMinimumRiskScore;
end;

{ TPriorityCustomerSpecification }

{----------------------------------------------------------------------------------------------------------------------}
function TPriorityCustomerSpecification.IsSatisfiedBy(
  const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.IsPriorityCustomer;
end;

{ TFragileOrderSpecification }

{----------------------------------------------------------------------------------------------------------------------}
function TFragileOrderSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.ContainsFragileItems;
end;

{ TFragileOrderSpecification }

{----------------------------------------------------------------------------------------------------------------------}
function TRequiresSignatureSpecification.IsSatisfiedBy(const aCandidate: TOrder): Boolean;
begin
  Result := aCandidate.RequiresSignature;
end;

end.
