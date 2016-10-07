<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // get the PlayerID
        int intIndex = Convert.ToInt32(e.CommandArgument);
        string strPlayerID = Convert.ToString(GridView1.DataKeys[intIndex].Value);
        
        // perform the correct action
        if (e.CommandName == "DeletePlayer")
        {
            Response.Redirect("./Player_Delete.aspx?PlayerID=" + strPlayerID);
        }
        else if (e.CommandName == "EditPlayer")
        {
            Response.Redirect("./Player_Update.aspx?PlayerID=" + strPlayerID);
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Players</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            SelectCommand="SELECT PlayerID, PlayerName, PlayerCost FROM Player"></asp:SqlDataSource>
        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="./Player_Insert.aspx">Add player</asp:HyperLink>
        <br /><br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand" DataKeyNames="PlayerID">
            <Columns>
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" />
                <asp:BoundField DataField="PlayerName" HeaderText="Name" />
                <asp:BoundField DataField="PlayerCost" DataFormatString="{0:c}" HeaderText="Cost" />
                <asp:ButtonField Text="Delete" ButtonType="Button" CommandName="DeletePlayer" />
                <asp:ButtonField Text="Edit" ButtonType="Button" CommandName="EditPlayer" />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
