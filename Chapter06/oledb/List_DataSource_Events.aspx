<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void lstManufacturers_DataBound(object sender, EventArgs e)
    {
        ListItem myListItem = new ListItem();
        myListItem.Text = "please select...";
        myListItem.Value = "-1";
        lstManufacturers.Items.Insert(0, myListItem);
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>List Binding with Events to a SqlDataSource</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="OleDbDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>"
            ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer]">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="OleDbDataSource2" runat="server"
            ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>"
            ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            SelectCommand="SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player WHERE (PlayerManufacturerID = @ManufacturerID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="lstManufacturers" Name="ManufacturerID" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <table>
            <tr>
                <td valign="top">
                    <asp:DropDownList ID="lstManufacturers" runat="server" DataTextField="ManufacturerName" DataValueField="ManufacturerID" AutoPostBack="True" DataSourceID="OleDbDataSource1" OnDataBound="lstManufacturers_DataBound"></asp:DropDownList>
                </td>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" DataSourceID="OleDbDataSource2"></asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
