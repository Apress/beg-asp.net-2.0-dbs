<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        lblError.Visible = false;
    }
    
    protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null)
        {
            lblError.Visible = true;
            lblError.Text = e.Exception.Message;
            e.ExceptionHandled = true;
        }
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = ?";

            // create the command
            OleDbCommand myCommand = new OleDbCommand(strQuery, myConnection);

            // add the parameter
            myCommand.Parameters.AddWithValue("@PlayerID", e.Keys["PlayerID"]);

            // open the connection
            myConnection.Open();

            // execute the command
            myCommand.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            lblError.Visible = true;
            lblError.Text = ex.Message;
            e.Cancel = true;
        }
        finally
        {
            // close the connection
            myConnection.Close();
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>" DeleteCommand="DELETE FROM Player WHERE PlayerID = ?" InsertCommand="INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerStorage, PlayerCost) VALUES (?, ?, ?, ?)" SelectCommand="SELECT PlayerID, PlayerName, ManufacturerName, PlayerManufacturerID, PlayerStorage, PlayerCost FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID" UpdateCommand="UPDATE Player SET PlayerName = ?, PlayerManufacturerID = ?, PlayerStorage = ?, PlayerCost = ? WHERE PlayerID = ?">
            <DeleteParameters>
                <asp:Parameter Name="PlayerID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="PlayerName" Type="String" />
                <asp:Parameter Name="PlayerManufacturerID" Type="Int32" />
                <asp:Parameter Name="PlayerStorage" Type="String" />
                <asp:Parameter Name="PlayerCost" Type="Decimal" />
                <asp:Parameter Name="PlayerID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="PlayerName" Type="String" />
                <asp:Parameter Name="PlayerManufacturerID" Type="Int32" />
                <asp:Parameter Name="PlayerStorage" Type="String" />
                <asp:Parameter Name="PlayerCost" Type="Decimal" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>" SelectCommand="SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName">
        </asp:SqlDataSource>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="PlayerID" DataSourceID="SqlDataSource1" OnRowDeleting="GridView1_RowDeleting" OnRowDeleted="GridView1_RowDeleted">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" InsertVisible="False" ReadOnly="True" SortExpression="PlayerID" />
                <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" SortExpression="PlayerName" />
                <asp:TemplateField HeaderText="Manufacturer" SortExpression="ManufacturerName">
                    <ItemTemplate>
                        <asp:Literal ID="litManufacturer" runat="server" Text='<%# Eval("ManufacturerName") %>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList id="lstManufacturer" runat="server" DataSourceID="SqlDataSource2" DataTextField="ManufacturerName" DataValueField="ManufacturerID" SelectedValue='<%# Bind("PlayerManufacturerID") %>'></asp:DropDownList>                                    
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PlayerCost" HeaderText="PlayerCost" SortExpression="PlayerCost" />
                <asp:BoundField DataField="PlayerStorage" HeaderText="PlayerStorage" SortExpression="PlayerStorage" />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>