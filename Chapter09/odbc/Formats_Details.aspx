<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

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
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT COUNT(*) FROM WhatPlaysWhatFormat WHERE WPWFFormatID = ?";

            // create the command
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);

            // add the 
            myCommand.Parameters.AddWithValue("@FormatID", e.Keys["FormatID"]);

            // open the connection
            myConnection.Open();

            // execute the command
            if (Convert.ToInt32(myCommand.ExecuteScalar()) > 0)
            {
                // cancel the delete
                e.Cancel = true;

                // register a warning for the user 
                this.ClientScript.RegisterStartupScript(this.GetType(), "WARNING", "window.alert('Cannot delete a format that is in use');", true);
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
    <title>Formats</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:OdbcConnectionString %>" ProviderName="<%$ ConnectionStrings:OdbcConnectionString.ProviderName %>" SelectCommand="SELECT FormatID, FormatName FROM Format ORDER BY FormatName">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:OdbcConnectionString %>" ProviderName="<%$ ConnectionStrings:OdbcConnectionString.ProviderName %>" DeleteCommand="DELETE FROM Format WHERE FormatID = ?" InsertCommand="INSERT INTO Format (FormatName) VALUES (?)" SelectCommand="SELECT FormatID, FormatName FROM Format WHERE FormatID = ?" UpdateCommand="UPDATE Format SET FormatName = ? WHERE FormatID = ?">
            <DeleteParameters>
                <asp:Parameter Name="FormatID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="FormatName" Type="String" />
                <asp:Parameter Name="FormatID" Type="Int32" />
            </UpdateParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="FormatID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="FormatName" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:LinkButton ID="Button1" runat="server" OnClick="Button1_Click" Text="Add New Format" />
        <table>
            <tr>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="FormatID" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" />
                            <asp:BoundField DataField="FormatName" HeaderText="FormatName" SortExpression="FormatName" />
                        </Columns>
                    </asp:GridView>
                </td>
                <td valign="top">
                    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource2" Height="50px" Width="125px" OnItemUpdated="DetailsView1_ItemUpdated" OnPreRender="DetailsView1_PreRender" OnItemInserted="DetailsView1_ItemInserted" OnItemDeleted="DetailsView1_ItemDeleted" OnItemDeleting="DetailsView1_ItemDeleting" DataKeyNames="FormatID">
                        <Fields>
                            <asp:BoundField DataField="FormatName" HeaderText="FormatName" SortExpression="FormatName" />
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
