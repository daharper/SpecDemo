unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Winapi.WebView2, Winapi.ActiveX, System.ImageList,
  Vcl.ImgList, Vcl.Edge, Vcl.ExtCtrls, App.Reports.OrderReport;

type
  TMainForm = class(TForm)
    Browser: TEdgeBrowser;
    procedure BrowserCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
    procedure FormShow(Sender: TObject);
  private
    fHtmlPath: string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  idURI,
  System.IOUtils,
  System.NetEncoding,
  Base.Integrity,
  Base.Collections,
  Domain.Orders.Service,
  Infrastructure.Reports.OrderHtml;

{$R *.dfm}

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.BrowserCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  if Succeeded(AResult) then
    Browser.Navigate(fHtmlPath);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
var
  scope: TScope;
begin
  var orderReport := TOrderReport.Create;

  var service := scope.Owns(TOrderService.Create);
  var report  := orderReport.AsDynamic;

  report.HighValueOrders                        := service.GetHighValueOrders;
  report.InternationalOrders                    := service.GetInternationalOrders;

  report.ConfirmedHighValueOrders               := service.GetConfirmedHighValueOrders;
  report.PriorityInternationalOrders            := service.GetPriorityInternationalOrders;
  report.UnconfirmedHighRiskInternationalOrders := service.GetHighRiskUnconfirmedInternationalOrders;
  report.OrdersNeedingSpecialHandling           := service.GetOrdersNeedingSpecialHandling;

  report.OrdersReadyForPriorityFulfillment      := service.GetOrdersReadyForPriorityFulfillment;
  report.PremiumInternationalOrders	            := service.GetPremiumInternationalOrders;
  report.TrustedSpecialHandlingOrders           := service.GetTrustedSpecialHandlingOrders;
  report.OrdersForEscalatedReview               := service.GetOrdersForEscalatedReview;

  fHtmlPath := TOrdersHtmlRenderer.Execute(orderReport);

  Browser.CreateWebView;
end;

end.
