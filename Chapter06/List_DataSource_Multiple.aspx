<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        // set up SQL query for Player table
        StringBuilder Query = new StringBuilder("SELECT PlayerID,PlayerName,PlayerManufacturerID,PlayerCost,PlayerStorage FROM Player WHERE PlayerManufacturerID IN (");

        bool gotResult = false;

        for (int i = 0; i < ListBox1.Items.Count; i++)
        {
            if (ListBox1.Items[i].Selected)
            {
                if (gotResult == true) Query.Append(",");
                Query.Append(ListBox1.Items[i].Value);
                gotResult = true;
            }
        }

        Query.Append(")");

        if (gotResult)
        {
            // set the correct SelectCommand
            SqlDataSource2.SelectCommand = Query.ToString();
        }
        else
        {
            // clear the GridView
            SqlDataSource2.SelectCommand = null;
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Multiple Selection Using a SqlDataSource</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
      ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
      SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
      ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>">
    </asp:SqlDataSource>
    <table>
        <tr>
            <td valign="top">
                <asp:ListBox ID="ListBox1" runat="server" SelectionMode="Multiple" DataTextField="ManufacturerName" DataValueField="ManufacturerID" DataSourceID="SqlDataSource1"></asp:ListBox>
                <br />
                <asp:Button ID="Button1" runat="server" Text="Select" OnClick="Button1_Click" />
            </td>
            <td valign="top">
                <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource2">
                </asp:GridView>
            </td>
        </tr>
    </table>
    </div>
    </form>
</body>
</html>
