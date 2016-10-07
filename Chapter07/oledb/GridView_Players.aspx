<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // get the item that we're binding to
            DataRowView objData = (DataRowView)e.Row.DataItem;

            // set the correct image
            if (objData["PlayerStorage"].ToString() == "Hard Disk")
            {
                ((Image)e.Row.FindControl("imgType")).ImageUrl = "../images/disk.gif";
            }
            else
            {
                ((Image)e.Row.FindControl("imgType")).ImageUrl ="../images/solid.gif";
            }
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Players in a GridView</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            SelectCommand="SELECT Player.PlayerID, Player.PlayerName, Manufacturer.ManufacturerName, Player.PlayerCost, Player.PlayerStorage FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID WHERE Player.PlayerManufacturerID = ?">
            <SelectParameters>
                <asp:QueryStringParameter Name="PlayerManufacturerID" QueryStringField="ManufacturerID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" OnRowDataBound="GridView1_RowDataBound" AllowSorting="True" AllowPaging="True" PageSize="5">
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="Gainsboro" />
            <Columns>
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" SortExpression="PlayerID" />
                <asp:BoundField DataField="PlayerName" HeaderText="Name" SortExpression="PlayerName" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="Manufacturer" SortExpression="ManufacturerName" />
                <asp:BoundField DataField="PlayerCost" DataFormatString="{0:n}" HeaderText="Cost" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Image ID="imgType" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
