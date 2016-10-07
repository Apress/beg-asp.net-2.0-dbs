<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    protected void Button1_Click(object sender, EventArgs e)
    {
        DetailsView1.ChangeMode(DetailsViewMode.Insert);
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
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
    
    protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GridView1.DataBind();
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

    protected void DetailsView1_ItemDeleting(object sender, DetailsViewDeleteEventArgs e)
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT COUNT(*) FROM Player WHERE PlayerManufacturerID = @ManufacturerID";

            // create the command
            SqlCommand myCommand = new SqlCommand(strQuery, myConnection);

            // add the 
            myCommand.Parameters.AddWithValue("@ManufacturerID", e.Keys["ManufacturerID"]);

            // open the connection
            myConnection.Open();

            // execute the command
            if (Convert.ToInt32(myCommand.ExecuteScalar()) > 0)
            {
                // cancel the delete
                e.Cancel = true;

                // register a warning for the user 
                this.ClientScript.RegisterStartupScript(this.GetType(), "WARNING", "window.alert('Cannot delete a manufacturer that is in use');", true);
            }
        }
        finally
        {
            // close the connection
            myConnection.Close();
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Manufacturers</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>" DeleteCommand="DELETE FROM [Manufacturer] WHERE [ManufacturerID] = @ManufacturerID" InsertCommand="INSERT INTO [Manufacturer] ([ManufacturerName], [ManufacturerCountry], [ManufacturerEmail], [ManufacturerWebsite]) VALUES (@ManufacturerName, @ManufacturerCountry, @ManufacturerEmail, @ManufacturerWebsite)" SelectCommand="SELECT [ManufacturerID], [ManufacturerName], [ManufacturerCountry], [ManufacturerEmail], [ManufacturerWebsite] FROM [Manufacturer] WHERE ([ManufacturerID] = @ManufacturerID)" UpdateCommand="UPDATE [Manufacturer] SET [ManufacturerName] = @ManufacturerName, [ManufacturerCountry] = @ManufacturerCountry, [ManufacturerEmail] = @ManufacturerEmail, [ManufacturerWebsite] = @ManufacturerWebsite WHERE [ManufacturerID] = @ManufacturerID">
            <DeleteParameters>
                <asp:Parameter Name="ManufacturerID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="ManufacturerName" Type="String" />
                <asp:Parameter Name="ManufacturerCountry" Type="String" />
                <asp:Parameter Name="ManufacturerEmail" Type="String" />
                <asp:Parameter Name="ManufacturerWebsite" Type="String" />
                <asp:Parameter Name="ManufacturerID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="ManufacturerName" Type="String" />
                <asp:Parameter Name="ManufacturerCountry" Type="String" />
                <asp:Parameter Name="ManufacturerEmail" Type="String" />
                <asp:Parameter Name="ManufacturerWebsite" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="ManufacturerID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:LinkButton ID="Button1" runat="server" OnClick="Button1_Click" Text="Add New Manufacturer" />
        <table>
            <tr>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="ManufacturerID" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" />
                            <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                        </Columns>
                    </asp:GridView>
                </td>
                <td valign="top">
                    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource2" Height="50px" Width="125px" OnItemUpdated="DetailsView1_ItemUpdated" OnPreRender="DetailsView1_PreRender" OnItemInserted="DetailsView1_ItemInserted" OnItemDeleted="DetailsView1_ItemDeleted" OnItemDeleting="DetailsView1_ItemDeleting" DataKeyNames="ManufacturerID">
                        <Fields>
                            <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                            <asp:BoundField DataField="ManufacturerCountry" HeaderText="ManufacturerCountry" SortExpression="ManufacturerCountry" />
                            <asp:BoundField DataField="ManufacturerEmail" HeaderText="ManufacturerEmail" SortExpression="ManufacturerEmail" />
                            <asp:BoundField DataField="ManufacturerWebsite" HeaderText="ManufacturerWebsite" SortExpression="ManufacturerWebsite" />
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
