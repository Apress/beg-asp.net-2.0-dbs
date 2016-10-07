<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // retrieve the Manufacturers from cache
            ArrayList colManufacturers = (ArrayList)Cache["Manufacturers"];

            // only load if not cached
            if (colManufacturers == null)
            {
                // create the connection
                string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
                OdbcConnection myConnection = new OdbcConnection(strConnectionString);

                try
                {
                    // query to execute
                    string strQuery = "SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer ORDER BY ManufacturerName";

                    // create the command
                    OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);

                    // open the database connection
                    myConnection.Open();

                    // run query
                    OdbcDataReader myReader = myCommand.ExecuteReader();

                    // create a new collection
                    colManufacturers = new ArrayList();
                    foreach (System.Data.Common.DbDataRecord objRecord in myReader)
                    {
                        colManufacturers.Add(objRecord);
                    }

                    // close the reader
                    myReader.Close();

                    // cache the collection
                    Cache.Insert("Manufacturers", colManufacturers, null, Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(5));
                }
                finally
                {
                    // always close the database connection
                    myConnection.Close();
                }
            }

            // set the data source and bind
            GridView1.DataSource = colManufacturers;
            GridView1.DataBind();
        }
    }
    
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // get the ManufacturerID
        int intIndex = Convert.ToInt32(e.CommandArgument);
        string strManufacturerID = Convert.ToString(GridView1.DataKeys[intIndex].Value);
        
        // work out the correct command
        if (e.CommandName == "EditCommand")
        {
            Response.Redirect("./Manufacturer_Edit_Command.aspx?Type=DR&ManufacturerID=" + strManufacturerID);
        }
        else if (e.CommandName == "EditDataSource")
        {
            Response.Redirect("./Manufacturer_Edit_DataSource.aspx?Type=DR&ManufacturerID=" + strManufacturerID);
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Manufacturers</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnRowCommand="GridView1_RowCommand" DataKeyNames="ManufacturerID">
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" SortExpression="ManufacturerName" />
                <asp:BoundField DataField="ManufacturerCountry" HeaderText="ManufacturerCountry"
                    SortExpression="ManufacturerCountry" />
                <asp:BoundField DataField="ManufacturerEmail" HeaderText="ManufacturerEmail" SortExpression="ManufacturerEmail" />
                <asp:BoundField DataField="ManufacturerWebsite" HeaderText="ManufacturerWebsite"
                    SortExpression="ManufacturerWebsite" />
                <asp:ButtonField ButtonType="Button" CommandName="EditCommand" Text="Edit Command" />
                <asp:ButtonField ButtonType="Button" CommandName="EditDataSource" Text="Edit DataSource" />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
