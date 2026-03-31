program SpecDemo;

uses
  Vcl.Forms,
  Forms.Main in 'Forms\Forms.Main.pas' {MainForm},
  App.Reports.OrderReport in 'App\Reports\App.Reports.OrderReport.pas',
  Base.Collections in 'Base\Base.Collections.pas',
  Base.Core in 'Base\Base.Core.pas',
  Base.Dynamic in 'Base\Base.Dynamic.pas',
  Base.Integrity in 'Base\Base.Integrity.pas',
  Base.Messaging in 'Base\Base.Messaging.pas',
  Base.Reflection in 'Base\Base.Reflection.pas',
  Domain.Orders.Order in 'Domain\Orders\Domain.Orders.Order.pas',
  Domain.Orders.Service in 'Domain\Orders\Domain.Orders.Service.pas',
  Domain.Orders.Specifications in 'Domain\Orders\Domain.Orders.Specifications.pas',
  Vcl.Themes,
  Vcl.Styles,
  Infrastructure.Reports.OrderHtml in 'Infrastructure\Reports\Infrastructure.Reports.OrderHtml.pas',
  App.Reports.CodeRegistry in 'App\Reports\App.Reports.CodeRegistry.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Impressive Dark SE');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
