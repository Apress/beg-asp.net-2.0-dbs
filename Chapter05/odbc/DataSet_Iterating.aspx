<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create the connection
        OdbcConnection myConnection = new OdbcConnection();

        // create the DataSet object
        DataSet myDataSet = new DataSet();

        // configure the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        myConnection.ConnectionString = strConnectionString;

        // create the command
        string strCommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer ORDER BY ManufacturerName";
        OdbcCommand myCommand = new OdbcCommand(strCommandText, myConnection);
        
        // create a DataAdapter
        OdbcDataAdapter myAdapter = new OdbcDataAdapter();
        myAdapter.SelectCommand = myCommand;
        
        // open the database connection
        myConnection.Open();

        // populate the DataSet
        myAdapter.Fill(myDataSet, "Manufacturer");

        // now iterate through the rows in the table
        for (int i = 0; i <= myDataSet.Tables["Manufacturer"].Rows.Count - 1; i++)
        {
            Manufacturer objManufacturer = new Manufacturer();
            objManufacturer.Name = Convert.ToString(myDataSet.Tables["Manufacturer"].Rows[i]["ManufacturerName"]);
            objManufacturer.Country = Convert.ToString(myDataSet.Tables["Manufacturer"].Rows[i]["ManufacturerCountry"]);
            objManufacturer.Email = Convert.ToString(myDataSet.Tables["Manufacturer"].Rows[i]["ManufacturerEmail"]);
            objManufacturer.Website = Convert.ToString(myDataSet.Tables["Manufacturer"].Rows[i]["ManufacturerWebsite"]);

            Label1.Text += objManufacturer.ToString() + "<BR/>";
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Iterating through a DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="Label1" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
