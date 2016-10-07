<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // set up connection string and SQL query
        string ConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        string CommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer";

        // create SqlConnection and SqlCommand objects
        SqlConnection myConnection = new SqlConnection(ConnectionString);
        SqlCommand myCommand = new SqlCommand(CommandText, myConnection);

        // create a new DataAdapter
        SqlDataAdapter myAdapter = new SqlDataAdapter();
        myAdapter.SelectCommand = myCommand;

        // create the DataSet
        DataSet myDataSet = new DataSet();
        
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

        // show the first results
        DataRow myFirstRow = myDataSet.Tables["Manufacturer"].Rows[0];
        lblName.Text = Convert.ToString(myFirstRow["ManufacturerName"]);
        lblCountry.Text = Convert.ToString(myFirstRow["ManufacturerCountry"]);
        lnkEmail.Text = Convert.ToString(myFirstRow["ManufacturerEmail"]);
        lnkEmail.NavigateUrl = "mailto:" + Convert.ToString(myFirstRow["ManufacturerEmail"]);
        lnkWebsite.Text = Convert.ToString(myFirstRow["ManufacturerWebsite"]);
        lnkWebsite.NavigateUrl = Convert.ToString(myFirstRow["ManufacturerWebsite"]);

        // show the second results
        DataRow mySecondRow = myDataSet.Tables["Manufacturer"].Rows[4];
        lblName2.Text = Convert.ToString(mySecondRow["ManufacturerName"]);
        lblCountry2.Text = Convert.ToString(mySecondRow["ManufacturerCountry"]);
        lnkEmail2.Text = Convert.ToString(mySecondRow["ManufacturerEmail"]);
        lnkEmail2.NavigateUrl = "mailto:" + Convert.ToString(mySecondRow["ManufacturerEmail"]);
        lnkWebsite2.Text = Convert.ToString(mySecondRow["ManufacturerWebsite"]);
        lnkWebsite2.NavigateUrl = Convert.ToString(mySecondRow["ManufacturerWebsite"]);
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Showing from a DataSet</title>
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
        Contact:
        <asp:HyperLink ID="lnkEmail" runat="server"></asp:HyperLink>
        <br />
        Homesite:
        <asp:HyperLink ID="lnkWebsite" runat="server"></asp:HyperLink>
        <br /><br />
        Name:
        <asp:Label ID="lblName2" runat="server"></asp:Label>
        <br />
        Country:
        <asp:Label ID="lblCountry2" runat="server"></asp:Label>
        <br />
        Contact:
        <asp:HyperLink ID="lnkEmail2" runat="server"></asp:HyperLink>
        <br />
        Homesite:
        <asp:HyperLink ID="lnkWebsite2" runat="server"></asp:HyperLink>
        <br /><br />
        <asp:Label ID="lblError" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>