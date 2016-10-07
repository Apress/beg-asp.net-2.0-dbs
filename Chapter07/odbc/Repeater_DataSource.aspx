<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // get the item that we're binding to
            DataRowView objData = (DataRowView)e.Item.DataItem;

            // set the two labels
            ((Label)e.Item.FindControl("lblName")).Text = objData["PlayerName"].ToString();
            ((Label)e.Item.FindControl("lblCost")).Text = String.Format("{0:n}", objData["PlayerCost"]);

            // set the correct image
            if (objData["PlayerStorage"].ToString() == "Hard Disk")
            {
                ((Image)e.Item.FindControl("imgType")).ImageUrl = "../images/disk.gif";
            }
            else
            {
                ((Image)e.Item.FindControl("imgType")).ImageUrl = "../images/solid.gif";
            }
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Binding a DataSource to a Repeater</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OdbcConnectionString %>" ProviderName="<%$ ConnectionStrings:OdbcConnectionString.ProviderName %>"
            SelectCommand="SELECT PlayerName, PlayerCost, PlayerStorage FROM Player WHERE (PlayerManufacturerID = ?)">
            <SelectParameters>
                <asp:QueryStringParameter Name="PlayerManufacturerID" QueryStringField="ManufacturerID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1" OnItemDataBound="Repeater1_ItemDataBound">
            <HeaderTemplate>
                <div style="background-color:Bisque">
                    <font size="+2">Players</font>
                </div>
                <hr style="color:blue"/>
            </HeaderTemplate>
            <ItemTemplate>
                <table>
                    <tr>
                    <td rowspan="2">
                        <asp:Image ID="imgType" runat="server" />
                    </td>
                    <td>
                        <b><asp:Label ID="lblName" runat="server" text="name" /></b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblCost" runat="server" text="cost" />
                    </td>
                </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>
