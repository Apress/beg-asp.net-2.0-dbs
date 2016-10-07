<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create OdbcConnection object
        string ConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(ConnectionString);

        // create OdbcCommand object
        OdbcCommand myCommand = new OdbcCommand();
        myCommand.Connection = myConnection;

        try
        {
            // open the database connection
            myConnection.Open();

            if (Page.IsPostBack == false)
            {
                // If this page isn't posted back
                // you need to set up the list control
                
                // set up SQL query for the Manufacturer table
                myCommand.CommandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

                // run query
                OdbcDataReader myReader = myCommand.ExecuteReader();

                // setup the list
                lstManufacturers.DataSource = myReader;
                lstManufacturers.DataBind();

                // close the reader
                myReader.Close();
            }
            else
            {
                // If this page is posted back get the selected value and display
                // players made by manufacturer. you don't need to rebind the value
                // for the lists either. They are stored in the viewstate.

                // set up SQL query for the Player table
                myCommand.CommandText = "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player WHERE PlayerManufacturerID = " + lstManufacturers.SelectedItem.Value;

                // run query
                OdbcDataReader myReader = myCommand.ExecuteReader();

                // setup the GridView
                GridView1.DataSource = myReader;
                GridView1.DataBind();

                // close the reader
                myReader.Close();
            }
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
    <title>List Binding to a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td valign="top">
                    <asp:DropDownList ID="lstManufacturers" runat="server" DataTextField="ManufacturerName" DataValueField="ManufacturerID" AutoPostBack="True"></asp:DropDownList>&nbsp;<br />
                </td>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server"></asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
