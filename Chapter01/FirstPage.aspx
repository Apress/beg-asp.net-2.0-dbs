<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\BAND\players.mdb"
            ProviderName="System.Data.OleDb" SelectCommand="SELECT * FROM [Manufacturer]"></asp:SqlDataSource>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="ManufacturerID" DataSourceID="SqlDataSource1" ForeColor="#333333"
            GridLines="None">
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="ManufacturerID" HeaderText="ManufacturerID" InsertVisible="False"
                    ReadOnly="True" SortExpression="ManufacturerID" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                <asp:BoundField DataField="ManufacturerCountry" HeaderText="ManufacturerCountry"
                    SortExpression="ManufacturerCountry" />
                <asp:BoundField DataField="ManufacturerEmail" HeaderText="ManufacturerEmail" SortExpression="ManufacturerEmail" />
                <asp:BoundField DataField="ManufacturerWebsite" HeaderText="ManufacturerWebsite"
                    SortExpression="ManufacturerWebsite" />
            </Columns>
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>
