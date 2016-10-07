<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create connection object
        string ConnectionString = ConfigurationManager.ConnectionStrings["MySqlConnectionString"].ConnectionString;
        MySqlConnection myConnection = new MySqlConnection(ConnectionString);

        try
        {
            // create the command
            MySqlCommand myCommand = new MySqlCommand();
            myCommand.Connection = myConnection;
        
            // setup the command
            myCommand.CommandText = "spGetPlayersByManufacturer";
            myCommand.CommandType = CommandType.StoredProcedure;

            // get the manufacturer value from the querystring
            string strManufacturerID = Request.QueryString["manufacturerid"];

            // determine the correct value as an integer
            int intManufacturerID = 0;
            if (strManufacturerID != null)
            {
                intManufacturerID = Convert.ToInt32(strManufacturerID);
            }

            // create the parameter
            MySqlParameter myParameter1 = new MySqlParameter();
            myParameter1.ParameterName = "?manufacturer";
            myParameter1.MySqlDbType = MySqlDbType.Int32;
            myParameter1.Value = intManufacturerID;

            // add it to the command object
            myCommand.Parameters.Add(myParameter1);

            // open the database connection
            myConnection.Open();
            
            // run query
            MySqlDataReader myReader = myCommand.ExecuteReader();

            // setup the grid
            GridView1.DataSource = myReader;
            GridView1.DataBind();

            // close the reader
            myReader.Close();
        }
        finally
        {
            // always close the connection
            myConnection.Close();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Calling a Stored Procedure using a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:GridView ID="GridView1" runat="server">
        </asp:GridView>
    </div>
    </form>
</body>
</html>
