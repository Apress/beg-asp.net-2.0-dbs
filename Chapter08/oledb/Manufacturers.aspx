<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // get the ManufacturerID
        int intIndex = Convert.ToInt32(e.CommandArgument);
        string strManufacturerID = Convert.ToString(
          GridView1.DataKeys[intIndex].Value);

        // perform the correct action
        if (e.CommandName == "EditManufacturer")
        {
            Response.Redirect("./Manufacturer_Edit.aspx?ManufacturerID=" + strManufacturerID);
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Manufacturers</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            SelectCommand="SELECT ManufacturerID, ManufacturerName, ManufacturerCountry FROM Manufacturer">
        </asp:SqlDataSource>
        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="./Manufacturer_Edit.aspx">Add manufacturer</asp:HyperLink>
        <br /><br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="ManufacturerID" OnRowCommand="GridView1_RowCommand" >
          <Columns>
            <asp:BoundField DataField="ManufacturerID" HeaderText="ManufacturerID" />
            <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" />
            <asp:BoundField DataField="ManufacturerCountry" HeaderText="ManufacturerCountry" />
            <asp:ButtonField Text="Edit" ButtonType="Button" CommandName="EditManufacturer" />
          </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
