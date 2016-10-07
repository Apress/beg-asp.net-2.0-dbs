<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void FormView1_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        GridView1.DataBind();
    }

    protected void FormView1_ItemDeleting(object sender, FormViewDeleteEventArgs e)
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

    protected void FormView1_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        GridView1.SelectedIndex = -1;
        GridView1.DataBind();
    }

    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        GridView1.SelectedIndex = -1;
        GridView1.DataBind();
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        FormView1.ChangeMode(FormViewMode.Insert);
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        FormView1.ChangeMode(FormViewMode.ReadOnly);
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Players</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>" SelectCommand="SELECT PlayerID, PlayerName, ManufacturerName FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>" SelectCommand="SELECT PlayerID, PlayerName, ManufacturerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID WHERE (PlayerID = ?)" UpdateCommand="UPDATE Player SET PlayerName = ?, PlayerManufacturerID = ?, PlayerStorage = ?, PlayerCost = ? WHERE PlayerID = ?" DeleteCommand="DELETE FROM Player WHERE PlayerID = ?" InsertCommand="INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage) VALUES (?, ?, ?, ?)">
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
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>" ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>" SelectCommand="SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName">
        </asp:SqlDataSource>
        <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CausesValidation="False">Add New Player</asp:LinkButton>
        <br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <table>
            <tr>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="PlayerID" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" />
                            <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" InsertVisible="False"
                                SortExpression="PlayerID" />
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
                    <asp:FormView ID="FormView1" runat="server" Height="50px" Width="125px" DataKeyNames="PlayerID" DataSourceID="SqlDataSource2" OnItemUpdated="FormView1_ItemUpdated" OnItemDeleting="FormView1_ItemDeleting" OnItemDeleted="FormView1_ItemDeleted" OnItemInserted="FormView1_ItemInserted">
                        <EmptyDataTemplate>
                            Please select a player from the list
                        </EmptyDataTemplate>
                        <ItemTemplate>
                            <table bgcolor="LightBlue">
                                <tr>
                                    <td>PlayerID</td>
                                    <td><asp:Literal ID="litPlayerID" runat="server" Text='<%# Eval("ManufacturerName") %>'></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>PlayerName</td>
                                    <td><asp:Literal ID="litPlayerName" runat="server" Text='<%# Eval("PlayerName") %>'></asp:Literal></td>
                                </tr>  
                               <tr>
                                    <td>Manufacturer</td>
                                    <td><asp:Literal ID="litManufacturer" runat="server" Text='<%# Eval("ManufacturerName") %>'></asp:Literal></td>
                                </tr>
                               <tr>
                                    <td>PlayerCost</td>
                                    <td><asp:Literal ID="litPlayerCost" runat="server" Text='<%# Eval("PlayerCost") %>'></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td>PlayerStorage</td>
                                    <td><asp:Literal ID="litPlayerStorage" runat="server" Text='<%# Eval("PlayerStorage") %>'></asp:Literal></td>
                                </tr>
                            </table>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="Edit" /> <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" />
                        </ItemTemplate>
                        <InsertItemTemplate>
                            <table bgcolor="LightGreen">
                                <tr>
                                    <td>
                                        PlayerName
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerName" runat="server" Text='<%# Bind("PlayerName") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="You must enter a name" ControlToValidate="txtPlayerName" Display="Dynamic">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>  
                               <tr>
                                    <td>
                                        Manufacturer
                                    </td>
                                    <td>
                                        <asp:DropDownList id="lstManufacturer" runat="server" DataSourceID="SqlDataSource3" DataTextField="ManufacturerName" DataValueField="ManufacturerID" SelectedValue='<%# Bind("PlayerManufacturerID") %>'></asp:DropDownList>
                                    </td>
                                </tr>
                               <tr>
                                    <td>
                                        PlayerCost
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerCost" runat="server" Text='<%# Bind("PlayerCost") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must enter a cost">*</asp:RequiredFieldValidator><asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must specify the cost as a decimal" Operator="DataTypeCheck" Type="Currency">*</asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        PlayerStorage
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerStorage" runat="server" Text='<%# Bind("PlayerStorage") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPlayerStorage" Display="Dynamic" ErrorMessage="You must enter a storage type">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>
                            <asp:LinkButton ID="btnInsert" runat="server" CommandName="Insert" Text="Insert" /> <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="Cancel" CausesValidation="False" />
                        </InsertItemTemplate>
                        <EditItemTemplate>
                            <table bgcolor="LightSalmon">
                                <tr>
                                    <td>
                                        PlayerID
                                    </td>
                                    <td>
                                        <asp:Literal ID="litPlayerID" runat="server" Text='<%# Eval("ManufacturerName") %>'></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        PlayerName
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerName" runat="server" Text='<%# Bind("PlayerName") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="You must enter a name" ControlToValidate="txtPlayerName" Display="Dynamic">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>  
                               <tr>
                                    <td>
                                        Manufacturer
                                    </td>
                                    <td>
                                        <asp:DropDownList id="lstManufacturer" runat="server" DataSourceID="SqlDataSource3" DataTextField="ManufacturerName" DataValueField="ManufacturerID" SelectedValue='<%# Bind("PlayerManufacturerID") %>'></asp:DropDownList>
                                    </td>
                                </tr>
                               <tr>
                                    <td>
                                        PlayerCost
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerCost" runat="server" Text='<%# Bind("PlayerCost") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must enter a cost">*</asp:RequiredFieldValidator><asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtPlayerCost" Display="Dynamic" ErrorMessage="You must specify the cost as a decimal" Operator="DataTypeCheck" Type="Currency">*</asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        PlayerStorage
                                    </td>
                                    <td>
                                        <asp:TextBox id="txtPlayerStorage" runat="server" Text='<%# Bind("PlayerStorage") %>'></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPlayerStorage" Display="Dynamic" ErrorMessage="You must enter a storage type">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>
                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" Text="Update" /> <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="Cancel" CausesValidation="False" />
                        </EditItemTemplate>                                               
                    </asp:FormView>
                </td>
            </tr>
        </table>
        </div>
    </form>
</body>
</html>
