<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create SqlConnection object
        string ConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(ConnectionString);

        try
        {
            // create the command
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConnection;

            // setup the command
            myCommand.CommandText = "spGetManufacturers";
            myCommand.CommandType = CommandType.StoredProcedure;

            // open the connection
            myConnection.Open();
            
            // run query
            SqlDataReader myReader = myCommand.ExecuteReader();

            // setup the grid
            GridView1.DataSource = myReader;
            GridView1.DataBind();

            // close the reader
            myReader.Close();
        }
        finally
        {
            // close the connection
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
