## -*- coding: utf-8 -*-
<html>
<head>
    <style type="text/css">
        ${css}

.info_picking_table {
    border: thin solid #000000;
    border-collapse: collapse;
    font-size:14px;
    }

.info_picking_table th {
    font-weight:bold;
    border-bottom: thin solid #000000;
    border-left: thin solid #000000;
    padding-right:3px;
    padding-left:3px;
    }

.info_picking_table td {
    border-top : thin solid #EEEEEE;
    border-left: thin solid #000000;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:10px;
}

.list_picking_table {
    border: thin solid #000000;
    border-collapse: collapse;
    font-size:14px;
    }

.list_picking_table th {
    background-color: #EEEEEE;
    font-weight:bold;
    border-bottom: thin solid #000000;
    border-left: thin solid #000000;
    padding-right:3px;
    padding-left:3px;
    }

.list_picking_table td {
    border-top : thin solid #EEEEEE;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:10px;
}

.std_text {
    font-size:12px;
    page-break-inside: avoid
    }
    </style>
</head>

<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>
    %for picking in objects:
        <% setLang(picking.partner_id.lang) %>
        <div class="address">
            <%
            invoice_addr = invoice_address(picking)
            %>
            <table class="recipient" style="float: left; font-size:16px">
                <tr><td class="address_title">${_("Invoiced to:")}</td></tr>
                <tr><td>${invoice_addr.title and invoice_addr.title.name or ''} ${invoice_addr.name }</td></tr>
                %if invoice_addr.contact_address:
                    <% address_lines = invoice_addr.contact_address.split("\n") %>
                    %for part in address_lines:
                        %if part:
                        <tr><td>${part}</td></tr>
                        %endif
                    %endfor
                %endif
            </table>
            <table class="recipient" style="float: right; font-size:16px">
                <tr><td class="name"><b>${picking.partner_id.company_id and picking.partner_id.company_id.name or '' }</b></td></tr>
                <tr><td><b>${picking.partner_id.title and picking.partner_id.title.name or ''}  ${picking.partner_id and picking.partner_id.name or '' }</b></td></tr>
                <tr><td>${picking.partner_id.street or ''}</td></tr>
                <tr><td>${picking.partner_id.street2 or ''}</td></tr>
                <tr><td>${picking.partner_id.zip or ''} ${picking.partner_id.city or ''}</td></tr>
                %if picking.partner_id.country_id:
                <tr><td>${picking.partner_id.country_id.name or ''} </td></tr>
                %endif
            </table>
        </div>
        <br/>
        <h1 style="clear:both;">${_('Delivery Order ') } ${picking.name}</h1>
        <table class="info_picking_table" width="100%">
            <thead>
                <tr>
                    <th style="text-align:center;">${_("Order Ref.")}</th>
                    <th style="text-align:center;">${_("Order Date")}</th>
                    <th style="text-align:center;">${_('Shipping Date')}</th>
                    <th style="text-align:center;">${_("Carrier")}</th>
                    <th style="text-align:center;">${_("Weight")}</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="text-align:center;">${picking.sale_id and picking.sale_id.name or ''}</td>
                    <td style="text-align:center;">${picking.date and formatLang(picking.date,date_time=True,date=True) or ''}</td>
                    <td style="text-align:center;">${picking.min_date and formatLang(picking.min_date,date_time=True,date=True) or ''}</td>
                    <td style="text-align:center;">${picking.carrier_id and picking.carrier_id.name or ''}</td>
                    <td style="text-align:center;">${picking.weight or ''}</td>
                </tr>
            </tbody>
        </table>
        <table class="list_picking_table" width="100%" style="margin-top: 20px;">
            <thead>
                <tr>
                    <th style="text-align:left; ">${_("Description")}</th>
                    <th style="text-align:left; ">${_("Lot")}</th>
                    <th style="text-align:left; ">${_("Quantity")}</th>
                </tr>
            </thead>
            <tbody>
            %for line in picking.move_lines:
                <tr class="line">
                    <td style="text-align:left; " >${ line.product_id and line.product_id.name or '' }</td>
                    <td style="text-align:left; " >${ line.prodlot_id and line.prodlot_id.name or '' }</td>
                    <td style="text-align:left; " >${ formatLang(line.product_qty) } ${ line.product_uom and line.product_uom.name }</td>
                </tr>
            %endfor
            </tbody>
        </table>
        <br/>
        %if picking.note :
            <p class="std_text" style="font-weight: bold;">${ _("Comments:")}</p>
            <p class="std_text">${picking.note | carriage_returns}</p>
        %endif

        <p style="page-break-after: always"/>
        <br/>
    %endfor
</body>
</html>
