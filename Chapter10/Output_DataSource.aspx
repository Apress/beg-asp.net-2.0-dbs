<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        Label1.Text = Convert.ToString(e.Command.Parameters["@rowcount"].Value);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Calling a Stored Procedure in a SqlDataSource</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
            ProviderName="<%$ ConnectionStrings:SqlConnectionString.ProviderName %>" SelectCommand="spGetPlayersWithCountByManufacturer"
            SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="manufacturer" QueryStringField="manufacturerid" Type="Int32" />
                <asp:Parameter Direction="Output" Name="rowcount" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <p>Returned <asp:Label id="Label1" runat="server">0</asp:Label> players.</p>
        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1">
        </asp:GridView>
    </div>
        
    </form>
</body>
</html>
