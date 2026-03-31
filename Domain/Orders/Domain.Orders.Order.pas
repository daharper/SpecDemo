unit Domain.Orders.Order;

interface

uses
  System.Generics.Collections;

type
  /// <summary>
  ///  The order details for our domain.
  /// </summary>
  TOrder = record
    Id: Integer;
    CustomerName: string;
    TotalAmount: Currency;
    IsInternational: Boolean;
    IsPriorityCustomer: Boolean;
    PaymentConfirmed: Boolean;
    ContainsFragileItems: Boolean;
    RequiresSignature: Boolean;
    ItemCount: Integer;
    RiskScore: Integer;
  end;

  TOrders = TList<TOrder>;

const
  Orders: array[0..27] of TOrder = (
    (Id: 1001; CustomerName: 'Acme Ltd';            TotalAmount: 120.50;  IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 3;  RiskScore: 12),
    (Id: 1002; CustomerName: 'Globex Corp';         TotalAmount: 2499.99; IsInternational: True;  IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 12; RiskScore: 18),
    (Id: 1003; CustomerName: 'Smith Retail';        TotalAmount: 89.90;   IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: False; ContainsFragileItems: False; RequiresSignature: False; ItemCount: 1;  RiskScore: 35),
    (Id: 1004; CustomerName: 'Blue Ocean GmbH';     TotalAmount: 780.00;  IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 5;  RiskScore: 22),
    (Id: 1005; CustomerName: 'Northwind Traders';   TotalAmount: 1500.00; IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: False; ItemCount: 8;  RiskScore: 10),
    (Id: 1006; CustomerName: 'Sunrise Market';      TotalAmount: 45.00;   IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 2;  RiskScore: 5),
    (Id: 1007; CustomerName: 'Pioneer Imports';     TotalAmount: 3200.75; IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: False; ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 20; RiskScore: 84),
    (Id: 1008; CustomerName: 'Evergreen Stores';    TotalAmount: 640.40;  IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: False; ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 6;  RiskScore: 41),
    (Id: 1009; CustomerName: 'Red Maple Stores';    TotalAmount: 210.25;  IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: False; ItemCount: 4;  RiskScore: 14),
    (Id: 1010; CustomerName: 'Atlas Export BV';     TotalAmount: 4120.00; IsInternational: True;  IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 18; RiskScore: 28),
    (Id: 1011; CustomerName: 'Corner Shop Group';   TotalAmount: 67.80;   IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: False; ContainsFragileItems: False; RequiresSignature: False; ItemCount: 1;  RiskScore: 31),
    (Id: 1012; CustomerName: 'Silverline Retail';   TotalAmount: 980.00;  IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 7;  RiskScore: 16),
    (Id: 1013; CustomerName: 'Nordic Parts AB';     TotalAmount: 1325.40; IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 9;  RiskScore: 44),
    (Id: 1014; CustomerName: 'Green Valley Foods';  TotalAmount: 305.60;  IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 11; RiskScore: 9),
    (Id: 1015; CustomerName: 'Urban House Ltd';     TotalAmount: 2750.00; IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: False; ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 14; RiskScore: 52),
    (Id: 1016; CustomerName: 'Pacific Wholesale';   TotalAmount: 5400.90; IsInternational: True;  IsPriorityCustomer: True;  PaymentConfirmed: False; ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 25; RiskScore: 91),
    (Id: 1017; CustomerName: 'Beacon Medical';      TotalAmount: 860.45;  IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 5;  RiskScore: 19),
    (Id: 1018; CustomerName: 'Lighthouse Imports';  TotalAmount: 1499.99; IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: False; ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 10; RiskScore: 63),
    (Id: 1019; CustomerName: 'Oak & Pine Retail';   TotalAmount: 125.00;  IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 2;  RiskScore: 6),
    (Id: 1020; CustomerName: 'Metro Office Supply'; TotalAmount: 2220.75; IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 16; RiskScore: 13),
    (Id: 1021; CustomerName: 'Delta Components';    TotalAmount: 715.30;  IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: False; ItemCount: 6;  RiskScore: 47),
    (Id: 1022; CustomerName: 'Bluebird Fashion';    TotalAmount: 58.49;   IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 3;  RiskScore: 4),
    (Id: 1023; CustomerName: 'Eastern Trade Co';    TotalAmount: 3850.00; IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 19; RiskScore: 72),
    (Id: 1024; CustomerName: 'Prime Auto Parts';    TotalAmount: 1105.10; IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: True;  ItemCount: 8;  RiskScore: 22),
    (Id: 1025; CustomerName: 'Heritage Books';      TotalAmount: 412.95;  IsInternational: False; IsPriorityCustomer: False; PaymentConfirmed: False; ContainsFragileItems: True;  RequiresSignature: False; ItemCount: 12; RiskScore: 26),
    (Id: 1026; CustomerName: 'Global Tech SARL';    TotalAmount: 6200.00; IsInternational: True;  IsPriorityCustomer: True;  PaymentConfirmed: True;  ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 30; RiskScore: 38),
    (Id: 1027; CustomerName: 'Sunset Pharmacy';     TotalAmount: 935.70;  IsInternational: False; IsPriorityCustomer: True;  PaymentConfirmed: False; ContainsFragileItems: True;  RequiresSignature: True;  ItemCount: 4;  RiskScore: 58),
    (Id: 1028; CustomerName: 'Harbor Industrial';   TotalAmount: 1750.00; IsInternational: True;  IsPriorityCustomer: False; PaymentConfirmed: True;  ContainsFragileItems: False; RequiresSignature: False; ItemCount: 13; RiskScore: 34)
  );

implementation

end.
