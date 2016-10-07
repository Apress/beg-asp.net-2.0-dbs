<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>TableBinding.aspx</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
            SelectCommand="SELECT [PlayerID], [PlayerName], [PlayerManufacturerID], [PlayerCost], [PlayerStorage] FROM [Player]">
        </asp:SqlDataSource>
        <table>
        <tr>
        <td width="50%" valign="top">
            <h1>GridView</h1>
            <asp:GridView id="DataGrid1" runat="server" DataSourceID="SqlDataSource1"></asp:GridView>
        </td>
        <td width="25%" valign="top">
            <h1>DataList</h1>
            <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <asp:Label ID="PlayerIDLabel" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PlayerID") %>'></asp:Label>
                    <asp:Label ID="PlayerNameLabel" runat="server" Text='<%# Eval("PlayerName") %>'></asp:Label>
                    <asp:Label ID="PlayerManufacturerIDLabel" runat="server" Text='<%# Eval("PlayerManufacturerID") %>'></asp:Label>
                    <asp:Label ID="PlayerCostLabel" runat="server" Text='<%# Eval("PlayerCost") %>'></asp:Label>
                    <asp:Label ID="PlayerStorageLabel" runat="server" Text='<%# Eval("PlayerStorage") %>'></asp:Label>
                </ItemTemplate>
            </asp:DataList>
        </td>
        <td width="25%" valign="top">
            <h1>Repeater</h1>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
            <ItemTemplate>
                    <asp:Label ID="PlayerIDLabel" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PlayerID") %>'></asp:Label>
                    <asp:Label ID="PlayerNameLabel" runat="server" Text='<%# Eval("PlayerName") %>'></asp:Label>
                    <asp:Label ID="PlayerManufacturerIDLabel" runat="server" Text='<%# Eval("PlayerManufacturerID") %>'></asp:Label>
                    <asp:Label ID="PlayerCostLabel" runat="server" Text='<%# Eval("PlayerCost") %>'></asp:Label>
                    <asp:Label ID="PlayerStorageLabel" runat="server" Text='<%# Eval("PlayerStorage") %>'></asp:Label>
            </ItemTemplate>
            </asp:Repeater>
        </td>
        </tr>
        </table>
    </div>
    </form>
</body>
</html>
