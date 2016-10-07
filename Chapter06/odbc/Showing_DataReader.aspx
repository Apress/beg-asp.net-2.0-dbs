<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // set up connection string and SQL query
        string ConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        string CommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer WHERE ManufacturerID = 1";

        // create OdbcConnection and OdbcCommand objects
        OdbcConnection myConnection = new OdbcConnection(ConnectionString);
        OdbcCommand myCommand = new OdbcCommand(CommandText, myConnection);

        // use try finally when the connection is open.
        try
        {
            // open the database connection
            myConnection.Open();

            // run query
            OdbcDataReader myReader = myCommand.ExecuteReader();

            if (myReader.Read())
            {
                // set the properties on the controls
                lblName.Text = Convert.ToString(myReader["ManufacturerName"]);
                lblCountry.Text = Convert.ToString(myReader["ManufacturerCountry"]);
                lnkEmail.Text = Convert.ToString(myReader["ManufacturerEmail"]);
                lnkEmail.NavigateUrl = "mailto:" + Convert.ToString(myReader["ManufacturerEmail"]);
                lnkWebsite.Text = Convert.ToString(myReader["ManufacturerWebsite"]);
                lnkWebsite.NavigateUrl = Convert.ToString(myReader["ManufacturerWebsite"]);
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
    <title>Showing from a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Name:
        <asp:Label ID="lblName" runat="server"></asp:Label>
        <br />
        Country:
        <asp:Label ID="lblCountry" runat="server"></asp:Label>
        <br />
        Email:
        <asp:HyperLink ID="lnkEmail" runat="server"></asp:HyperLink>
        <br />
        Website:
        <asp:HyperLink ID="lnkWebsite" runat="server"></asp:HyperLink>
        <br /><br />
        <asp:Label ID="lblError" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>