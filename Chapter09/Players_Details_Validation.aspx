<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GridView1.DataBind();
    }

    protected void DetailsView1_ItemDeleting(object sender, DetailsViewDeleteEventArgs e)
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

            // add the 
            myCommand.Parameters.AddWithValue("@PlayerID", e.Keys["PlayerID"]);

            // open the connection
            myConnection.Open();

            // execute the command
            myCommand.ExecuteNonQuery();
        }
        finally
        {
            // close the connection
            myConnection.Close();
        }
    }

    protected void DetailsView1_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
        GridView1.SelectedIndex = -1;
        GridView1.DataBind();
    }
    
    protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GridView1.SelectedIndex = -1;
        GridView1.DataBind();
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        DetailsView1.ChangeMode(DetailsViewMode.Insert);
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void DetailsView1_PreRender(object sender, EventArgs e)
    {
        if (DetailsView1.CurrentMode == DetailsViewMode.Insert)
        {
            DetailsView1.AutoGenerateInsertButton = true;
        }
        else
        {
            DetailsView1.AutoGenerateInsertButton = false;
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" SelectCommand="SELECT [PlayerID], [PlayerName], [ManufacturerName] FROM [Player] INNER JOIN [Manufacturer] ON [Player].PlayerManufacturerID = [Manufacturer].ManufacturerID">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" SelectCommand="SELECT PlayerID, PlayerName, ManufacturerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID WHERE (PlayerID = @PlayerID)" UpdateCommand="UPDATE Player SET PlayerName = @PlayerName, PlayerManufacturerID = @PlayerManufacturerID, PlayerStorage = @PlayerStorage, PlayerCost = @PlayerCost WHERE PlayerID = @PlayerID" DeleteCommand="DELETE FROM Player WHERE PlayerID = @PlayerID" InsertCommand="INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage) VALUES (@PlayerName, @PlayerManufacturerID, @PlayerCost, @PlayerStorage)">
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="PlayerID" PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="PlayerName" />
                <asp:Parameter Name="PlayerManufacturerID" />
                <asp:Parameter Name="PlayerStorage" />
                <asp:Parameter Name="PlayerCost" />
                <asp:Parameter Name="PlayerID" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="PlayerID" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="PlayerName" />
                <asp:Parameter Name="PlayerManufacturerID" />
                <asp:Parameter Name="PlayerCost" />
                <asp:Parameter Name="PlayerStorage" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]">
        </asp:SqlDataSource>
        <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CausesValidation="False">Add New Player</asp:LinkButton><br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <table>
            <tr>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="PlayerID" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" />
                            <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" InsertVisible="False" SortExpression="PlayerID" />
                            <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" SortExpression="PlayerName" />
                            <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                        </Columns>
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </td>
                <td valign="top">
                    <asp:DetailsView ID="DetailsView1" runat="server" Height="50px" Width="125px" AutoGenerateRows="False" DataKeyNames="PlayerID" DataSourceID="SqlDataSource2" OnItemUpdated="DetailsView1_ItemUpdated" OnItemDeleting="DetailsView1_ItemDeleting" OnItemDeleted="DetailsView1_ItemDeleted" OnItemInserted="DetailsView1_ItemInserted" OnPreRender="DetailsView1_PreRender" ShowHeader="true">
                        <Fields>
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
                                    <asp:DropDownList id="lstManufacturer" runat="server" DataSourceID="SqlDataSource3" DataTextField="ManufacturerName" DataValueField="ManufacturerID" SelectedValue='<%# Bind("PlayerManufacturerID") %>'></asp:DropDownList>                                    
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
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                        </Fields>
                    </asp:DetailsView>
                </td>
            </tr>
        </table>
        </div>
    </form>
</body>
</html>
