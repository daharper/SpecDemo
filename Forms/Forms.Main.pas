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
  var report  := TOrderReport.Create;
  var section := report.AsDynamic;
  var service := scope.Owns(TOrderService.Create);

  section.HighValueOrders                        := service.GetHighValueOrders;
  section.InternationalOrders                    := service.GetInternationalOrders;

  section.ConfirmedHighValueOrders               := service.GetConfirmedHighValueOrders;
  section.PriorityInternationalOrders            := service.GetPriorityInternationalOrders;
  section.UnconfirmedHighRiskInternationalOrders := service.GetHighRiskUnconfirmedInternationalOrders;
  section.OrdersNeedingSpecialHandling           := service.GetOrdersNeedingSpecialHandling;

  section.OrdersReadyForPriorityFulfillment      := service.GetOrdersReadyForPriorityFulfillment;
  section.PremiumInternationalOrders	           := service.GetPremiumInternationalOrders;
  section.TrustedSpecialHandlingOrders           := service.GetTrustedSpecialHandlingOrders;
  section.OrdersForEscalatedReview               := service.GetOrdersForEscalatedReview;

  fHtmlPath := TOrdersHtmlRenderer.Execute(report);

  Browser.CreateWebView;
end;

end.
