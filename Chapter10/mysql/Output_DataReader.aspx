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
            myCommand.CommandText = "spGetPlayersWithCountByManufacturer";
            myCommand.CommandType = CommandType.StoredProcedure;

            // determine the correct ManufacturerID
            string strManufacturerID = Request.QueryString["manufacturerid"];
            int intManufacturerID = 0;
            if (strManufacturerID != null)
            {
                intManufacturerID = Convert.ToInt32(strManufacturerID);
            }

            // add the @manufacturer parameter
            MySqlParameter myParameter1 = new MySqlParameter();
            myParameter1.ParameterName = "?manufacturer";
            myParameter1.MySqlDbType = MySqlDbType.Int32;
            myParameter1.Value = intManufacturerID;
            myCommand.Parameters.Add(myParameter1);

            // add the @rowcount parameter
            MySqlParameter myParameter2 = new MySqlParameter(); 
            myParameter2.ParameterName = "?rowcount";
            myParameter2.MySqlDbType = MySqlDbType.Int32;
            myParameter2.Direction = ParameterDirection.Output;
            myCommand.Parameters.Add(myParameter2);

            // open the database connection
            myConnection.Open();

            // run query
            MySqlDataReader myReader = myCommand.ExecuteReader();

            // setup the grid
            GridView1.DataSource = myReader;
            GridView1.DataBind();

            // close the reader
            myReader.Close();

            // now get the output parameter
            Label1.Text = Convert.ToString(myCommand.Parameters["?rowcount"].Value);
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
        <p>Returned <asp:Label id="Label1" runat="server">0</asp:Label> players.</p>
        <asp:GridView ID="GridView1" runat="server">
        </asp:GridView>
    </div>
    </form>
</body>
</html>
