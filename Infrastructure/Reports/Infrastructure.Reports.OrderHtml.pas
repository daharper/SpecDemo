unit Infrastructure.Reports.OrderHtml;

interface

uses
  App.Reports.OrderReport;

type
  TTemplate = (ttPage, ttLink, ttSection, ttRow);

  /// <summary>
  ///  Renders the order report and its sections to HTML.
  /// </summary>
  TOrdersHtmlRenderer = class
  private
    class function GetTemplate(const aTemplate: TTemplate): string;

    class var fStartupPath:  string;
    class var fTemplatePath: string;
  public
    class function Execute(const aReport: TOrderReport): string;
  end;

const
  Template: array [TTemplate] of string = ('page.html', 'link.html', 'section.html', 'row.html');

implementation

uses
  idURI,
  System.SysUtils,
  System.IOUtils,
  System.NetEncoding,
  Base.Integrity,
  Base.Collections,
  Domain.Orders.Order,
  App.Reports.CodeRegistry;

{ TOrdersHtmlGenerator }

{----------------------------------------------------------------------------------------------------------------------}
class function TOrdersHtmlRenderer.Execute(const aReport: TOrderReport): string;
const
  PAID: array[boolean] of string = ('', 'bg-success');
  TEXT: array[boolean] of string = ('', 'paid');
begin
  fStartupPath  := ExtractFilePath(ParamStr(0));
  fTemplatePath := TPath.Combine(fStartupPath, 'templates');

  var pageTemplate    := GetTemplate(ttPage);
  var linkTemplate    := GetTemplate(ttLink);
  var sectionTemplate := GetTemplate(ttSection);
  var rowTemplate     := GetTemplate(ttRow);

  var content := '';
  var links   := '';
  var i       := 0;

  for var section in aReport do
  begin
    var rows := '';

    Stream
      .From<TOrder>(Orders)
      .Filter(section.Spec)
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

    Inc(i);

    var sect := sectionTemplate
                    .Replace('[SEC_ID]', i.ToString)
                    .Replace('[TITLE]',  section.Title)
                    .Replace('[CODE]',   section.Code)
                    .Replace('[ROWS]',   rows);

    var lnk := linkTemplate
                    .Replace('[SEC_ID]', i.ToString)
                    .Replace('[TITLE]',  section.Title);

    content := content + sect;
    links := links + lnk;
  end;

  var page := pageTemplate
                    .Replace('[LINKS]',   links)
                    .Replace('[STREAM]',  CodeRegistry['Stream'])
                    .Replace('[DYNAMIC]', CodeRegistry['DynamicObject'])
                    .Replace('[SCOPE]',   CodeRegistry['Scope'])
                    .Replace('[CONTENT]', content);

  var filename := TPath.Combine(fStartupPath, 'orders.html');
  var filepath := 'file://' + TIdURI.PathEncode(filename).Replace('%5C', '/');

  TFile.WriteAllText(filename, page, TEncoding.UTF8);

  Result := filepath;
end;

{----------------------------------------------------------------------------------------------------------------------}
class function TOrdersHtmlRenderer.GetTemplate(const aTemplate: TTemplate): string;
begin
  var path := TPath.Combine(fTemplatePath, Template[aTemplate]);
  Result := TFile.ReadAllText(path);
end;

end.
