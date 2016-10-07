<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create the connection
        OdbcConnection myConnection = new OdbcConnection();

        try
        {
            // configure the connection
            string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
            myConnection.ConnectionString = strConnectionString;

            // create the command
            string strCommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer ORDER BY ManufacturerName";
            OdbcCommand myCommand = new OdbcCommand(strCommandText, myConnection);

            // open the database connection
            myConnection.Open();

            // run query
            OdbcDataReader myReader = myCommand.ExecuteReader();

            while (myReader.Read())
            {
                // create the manufacturer object
                Manufacturer objManufacturer = new Manufacturer();
                objManufacturer.Name = Convert.ToString(myReader["ManufacturerName"]);
                objManufacturer.Country = Convert.ToString(myReader["ManufacturerCountry"]);
                objManufacturer.Email = Convert.ToString(myReader["ManufacturerEmail"]);
                objManufacturer.Website = Convert.ToString(myReader["ManufacturerWebsite"]);

                // output the manufacturer object details
                Label1.Text += objManufacturer.ToString() + "<BR/>";
            }

            // close the reader
            myReader.Close();
        }
        finally
        {
            // close the database connection
            myConnection.Close();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Iterating through a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="Label1" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
