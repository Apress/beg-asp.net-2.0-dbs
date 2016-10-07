<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    // must declare the DataSet globally else the page can't see it.
    DataSet myDataSet = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        // set up connection string and SQL query
        string ConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        string CommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer";

        // create OdbcConnection and OdbcCommand objects
        OdbcConnection myConnection = new OdbcConnection(ConnectionString);
        OdbcCommand myCommand = new OdbcCommand(CommandText, myConnection);

        // create a new DataAdapter
        OdbcDataAdapter myAdapter = new OdbcDataAdapter();
        myAdapter.SelectCommand = myCommand;

        // use try finally when the connection is open.
        try
        {
            // open the database connection
            myConnection.Open();

            // use the DataAdapter to fill the DataSet
            myAdapter.Fill(myDataSet, "Manufacturer");
        }
        finally
        {
            // always close the database connection
            myConnection.Close();
        }

        // bind the data
        Page.DataBind();
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Inline Binding to a DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lblName" runat="server">
          Name: <%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[ManufacturerName]") %>
        </asp:Label>
        <br />
        Country:
        <asp:Label ID="lblCountry" runat="server" Text='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[ManufacturerCountry]") %>'></asp:Label>
        <br />
        Email:
        <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[2]", "mailto:{0}") %>' Text='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[ManufacturerEmail]") %>'></asp:HyperLink>
        <br />
        Website:
        <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[3]") %>'><%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[0], "[ManufacturerWebsite]") %></asp:HyperLink>
        <br />
        <br />
        <asp:Label ID="lblName2" runat="server">
          Name: <%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[ManufacturerName]") %>
        </asp:Label>
        <br />
        Country:
        <asp:Label ID="lblCountry2" runat="server" Text='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[ManufacturerCountry]") %>'></asp:Label>
        <br />
        Email:
        <asp:HyperLink ID="lnkEmail2" runat="server" NavigateUrl='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[2]", "mailto:{0}") %>' Text='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[ManufacturerEmail]") %>'></asp:HyperLink>
        <br />
        Website:
        <asp:HyperLink ID="lnkWebsite2" runat="server" NavigateUrl='<%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[3]") %>'>
          <%# DataBinder.Eval (myDataSet.Tables["Manufacturer"].Rows[4], "[ManufacturerWebsite]") %>
        </asp:HyperLink>
        <br />
        <br />        
        <asp:Label ID="lblError" runat="server"></asp:Label></div>
    </form>
</body>
</html>