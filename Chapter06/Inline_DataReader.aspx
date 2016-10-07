<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    // must declare the DataReader globally else the page can't see it.
    SqlDataReader myReader;

    protected void Page_Load(object sender, EventArgs e)
    {
        // set up connection string and SQL query
        string ConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        string CommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer WHERE ManufacturerID = 1";

        // create SqlConnection and SqlCommand objects
        SqlConnection myConnection = new SqlConnection(ConnectionString);
        SqlCommand myCommand = new SqlCommand(CommandText, myConnection);

        // use try finally when the connection is open.
        try
        {
            // open the database connection
            myConnection.Open();

            // run query
            myReader = myCommand.ExecuteReader();

            if (myReader.Read())
            {
                // bind the data
                Page.DataBind();
            }
            else
            {
                // show the error
                lblError.Text = "No results to databind to.";
            }

            // close the reader
            myReader.Close();
        }
        finally
        {
            // always close the database connection
            myConnection.Close();
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Inline Binding to a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lblName" runat="server">
          Name: <%# DataBinder.Eval (myReader, "[ManufacturerName]") %>
        </asp:Label>
        <br />
        Country:
        <asp:Label ID="lblCountry" runat="server" Text='<%# DataBinder.Eval (myReader, "[ManufacturerCountry]") %>'></asp:Label>
        <br />
        Email:
        <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# DataBinder.Eval (myReader, "[2]", "mailto:{0}") %>' Text='<%# DataBinder.Eval (myReader, "[ManufacturerEmail]") %>'></asp:HyperLink>
        <br />
        Website:
        <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# DataBinder.Eval (myReader, "[3]") %>'>
          <%# DataBinder.Eval (myReader, "[ManufacturerWebsite]") %>
        </asp:HyperLink>
        <br />
        <br />
        <asp:Label ID="lblError" runat="server"></asp:Label></div>
    </form>
</body>
</html>