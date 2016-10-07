<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        DropDownList1.Items.Insert(0, new ListItem("-- All Manufacturers --", "0"));
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>SELECT</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OdbcConnectionString %>"
            SelectCommand="SELECT Player.PlayerName, Manufacturer.ManufacturerName FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID WHERE (Manufacturer.ManufacturerID = ?) OR (? = 0) ORDER BY Player.PlayerName"
            ProviderName="<%$ ConnectionStrings:OdbcConnectionString.ProviderName %>">
            <SelectParameters>
               <asp:ControlParameter ControlID="DropDownList1" PropertyName="SelectedValue" />
               <asp:ControlParameter ControlID="DropDownList1" PropertyName="SelectedValue" />               
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
            ConnectionString="<%$ ConnectionStrings:OdbcConnectionString %>"
            SelectCommand="SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName"
            ProviderName="<%$ ConnectionStrings:OdbcConnectionString.ProviderName %>">
        </asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2" DataTextField="ManufacturerName" DataValueField="ManufacturerID" AutoPostBack="True" OnDataBound="DropDownList1_DataBound">
        </asp:DropDownList>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" CellPadding="4" ForeColor="#333333" GridLines="None">
            <Columns>
                <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" SortExpression="PlayerName" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
            </Columns>
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
    </div>
    </form>
</body>
</html>
