<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Players")
        {
            int intIndex = Convert.ToInt32(e.CommandArgument);
            string strManufacuterID = Convert.ToString(GridView1.DataKeys[intIndex].Value);
            Response.Redirect("./GridView_Players.aspx?ManufacturerID=" + strManufacuterID);
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Manufacturers in a GridView</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
            SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer]">
        </asp:SqlDataSource>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="ManufacturerID" DataSourceID="SqlDataSource1" ForeColor="#333333"
            GridLines="None" OnRowCommand="GridView1_RowCommand">
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="ManufacturerID" HeaderText="ManufacturerID" InsertVisible="False" ReadOnly="True" SortExpression="ManufacturerID" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                <asp:ButtonField ButtonType="Link" CommandName="Players" Text="View Players" />
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
