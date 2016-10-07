<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void DataList1_ItemDataBound(object sender, DataListItemEventArgs e)
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
                ((Image)e.Item.FindControl("imgType")).ImageUrl = "./images/disk.gif";
            }
            else
            {
                ((Image)e.Item.FindControl("imgType")).ImageUrl = "./images/solid.gif";
            }
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Binding a DataSource to a DataList</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
            SelectCommand="SELECT [PlayerName], [PlayerCost], [PlayerStorage] FROM [Player] ORDER BY [PlayerName]">
        </asp:SqlDataSource>
        <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" RepeatDirection="Horizontal" OnItemDataBound="DataList1_ItemDataBound" RepeatColumns="3">
            <ItemTemplate>
                <table bgcolor="Ivory">
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
            <AlternatingItemTemplate>
                <table bgcolor="Azure">
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
            </AlternatingItemTemplate>
        </asp:DataList>
    </div>
    </form>
</body>
</html>
