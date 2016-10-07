<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

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
        string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID";

            // create the command
            SqlCommand myCommand = new SqlCommand(strQuery, myConnection);

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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" DeleteCommand="DELETE FROM [Player] WHERE [PlayerID] = @PlayerID" InsertCommand="INSERT INTO [Player] ([PlayerName], [PlayerManufacturerID], [PlayerStorage], [PlayerCost]) VALUES (@PlayerName, @PlayerManufacturerID, @PlayerStorage, @PlayerCost)" SelectCommand="SELECT [PlayerID], [PlayerName], [ManufacturerName], [PlayerManufacturerID], [PlayerStorage], [PlayerCost] FROM [Player] INNER JOIN [Manufacturer] ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID" UpdateCommand="UPDATE [Player] SET [PlayerName] = @PlayerName, [PlayerManufacturerID] = @PlayerManufacturerID, [PlayerStorage] = @PlayerStorage, [PlayerCost] = @PlayerCost WHERE [PlayerID] = @PlayerID">
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
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]">
        </asp:SqlDataSource>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="PlayerID" DataSourceID="SqlDataSource1" OnRowDeleting="GridView1_RowDeleting" OnRowDeleted="GridView1_RowDeleted">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" InsertVisible="False" ReadOnly="True" SortExpression="PlayerID" />
                <asp:TemplateField HeaderText="PlayerName" SortExpression="PlayerName">
                    <ItemTemplate>
                        <asp:Literal ID="litPlayerName" runat="server" Text='<%# Eval("PlayerName") %>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox id="txtPlayerName" runat="server" Text='<%# Bind("PlayerName") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="You must enter a name" ControlToValidate="txtPlayerName" Display="Dynamic">*</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Manufacturer" SortExpression="ManufacturerName">
                    <ItemTemplate>
                        <asp:Literal ID="litManufacturer" runat="server" Text='<%# Eval("ManufacturerName") %>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList id="lstManufacturer" runat="server" DataSourceID="SqlDataSource2" DataTextField="ManufacturerName" DataValueField="ManufacturerID" SelectedValue='<%# Bind("PlayerManufacturerID") %>'></asp:DropDownList>                                    
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="PlayerCost" SortExpression="PlayerName">
                    <ItemTemplate>
                        <asp:Literal ID="litPlayerCost" runat="server" Text='<%# Eval("PlayerCost") %>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox id="txtPlayerCost" runat="server" Text='<%# Bind("PlayerCost") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must enter a cost">*</asp:RequiredFieldValidator><asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must specify the cost as a decimal" Operator="DataTypeCheck" Type="Currency">*</asp:CompareValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="PlayerStorage" SortExpression="PlayerName">
                    <ItemTemplate>
                        <asp:Literal ID="litPlayerStorage" runat="server" Text='<%# Eval("PlayerStorage") %>'></asp:Literal>
                      </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox id="txtPlayerStorage" runat="server" Text='<%# Bind("PlayerStorage") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPlayerStorage" Display="Dynamic" ErrorMessage="You must enter a storage type">*</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>   
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>