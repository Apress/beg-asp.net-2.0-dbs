<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        lblError.Visible = false;
    
        if (Page.IsPostBack == false)
        {
            DetailsView1.ChangeMode(DetailsViewMode.Edit);
        }
    }

    protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            lblError.Text = e.Exception.Message;
            lblError.Visible = true;
            e.ExceptionHandled = true;
            e.KeepInEditMode = true;
        }
        else if (e.AffectedRows == 0)
        {
            lblError.Text = "No update was made.  Concurrency problem.";
            lblError.Visible = true;
            e.KeepInEditMode = true;
        }
        else
        {
            // remove from the Cache
            Cache.Remove("Manufacturers");
        }
    }
    
    protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            if (Request.QueryString["Type"] == "DS")
            {
                Response.Redirect("./Manufacturers_DataSource.aspx");
            }
            else if (Request.QueryString["Type"] == "DR")
            {
                Response.Redirect("./Manufacturers_DataReader.aspx");
            }
        }
    }

    protected void DetailsView1_DataBound(object sender, EventArgs e)
    {
        // set the buttons correctly
        if (DetailsView1.CurrentMode == DetailsViewMode.ReadOnly)
        {
            ((Button)DetailsView1.FooterRow.FindControl("btnUpdate")).Enabled = false;
            ((Button)DetailsView1.FindControl("btnCancel")).Text = "Continue";
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Edit Manufacturer Using DataSource</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:OleDbConnectionString %>"
            ProviderName="<%$ ConnectionStrings:OleDbConnectionString.ProviderName %>"
            ConflictDetection="CompareAllValues"
            OldValuesParameterFormatString="original_{0}"
            SelectCommand="SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer WHERE (ManufacturerID = ?)"
            UpdateCommand="UPDATE Manufacturer SET ManufacturerName = ?, ManufacturerCountry = ?, ManufacturerEmail = ?, ManufacturerWebsite = ? WHERE ManufacturerID = ? AND ManufacturerName = ? AND ManufacturerCountry = ? AND ManufacturerEmail = ? AND ManufacturerWebsite = ?"
            DeleteCommand="DELETE FROM Manufacturer WHERE ManufacturerID = ? AND ManufacturerName = ? AND ManufacturerCountry = ? AND ManufacturerEmail = ? AND ManufacturerWebsite = ?"
            InsertCommand="INSERT INTO Manufacturer (ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite) VALUES (?, ?, ?, ?)">
            <DeleteParameters>
                <asp:Parameter Name="original_ManufacturerID" Type="Int32" />
                <asp:Parameter Name="original_ManufacturerName" Type="String" />
                <asp:Parameter Name="original_ManufacturerCountry" Type="String" />
                <asp:Parameter Name="original_ManufacturerEmail" Type="String" />
                <asp:Parameter Name="original_ManufacturerWebsite" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="ManufacturerName" Type="String" />
                <asp:Parameter Name="ManufacturerCountry" Type="String" />
                <asp:Parameter Name="ManufacturerEmail" Type="String" />
                <asp:Parameter Name="ManufacturerWebsite" Type="String" />
                <asp:Parameter Name="original_ManufacturerID" Type="Int32" />
                <asp:Parameter Name="original_ManufacturerName" Type="String" />
                <asp:Parameter Name="original_ManufacturerCountry" Type="String" />
                <asp:Parameter Name="original_ManufacturerEmail" Type="String" />
                <asp:Parameter Name="original_ManufacturerWebsite" Type="String" />
            </UpdateParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="ManufacturerID" QueryStringField="ManufacturerID" Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="ManufacturerName" Type="String" />
                <asp:Parameter Name="ManufacturerCountry" Type="String" />
                <asp:Parameter Name="ManufacturerEmail" Type="String" />
                <asp:Parameter Name="ManufacturerWebsite" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label></div>
        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource1" Height="50px" Width="125px" OnItemUpdated="DetailsView1_ItemUpdated" OnItemCommand="DetailsView1_ItemCommand" OnDataBound="DetailsView1_DataBound">
            <Fields>
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                <asp:BoundField DataField="ManufacturerCountry" HeaderText="ManufacturerCountry" SortExpression="ManufacturerCountry" />
                <asp:BoundField DataField="ManufacturerEmail" HeaderText="ManufacturerEmail" SortExpression="ManufacturerEmail" />
                <asp:BoundField DataField="ManufacturerWebsite" HeaderText="ManufacturerWebsite" SortExpression="ManufacturerWebsite" />
            </Fields>
            <FooterTemplate>
                <asp:Button ID="btnUpdate" CommandName="Update" runat="server" Text="Update" />
                <asp:Button ID="btnCancel" CommandName="Cancel" runat="server" Text="Cancel" />
            </FooterTemplate>
        </asp:DetailsView>
    </form>
</body>
</html>
