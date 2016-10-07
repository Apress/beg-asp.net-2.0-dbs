<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // create OleDbConnection object
            string ConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
            OleDbConnection myConnection = new OleDbConnection(ConnectionString);

            // create OleDbCommand object
            OleDbCommand myCommand = new OleDbCommand();
            myCommand.Connection = myConnection;

            try
            {
                // open the database connection
                myConnection.Open();

                // set up SQL query for Manufacturer table
                myCommand.CommandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

                // run query
                OleDbDataReader myReader = myCommand.ExecuteReader();

                // setup the list
                lstManufacturers.DataSource = myReader;
                lstManufacturers.DataBind();

                // close the reader
                myReader.Close();
            }
            finally
            {
                // always close the connection
                myConnection.Close();
            }
        }
    }

    protected void lstManufacturers_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstManufacturers.SelectedValue != "-1")
        {
            // create OleDbConnection object
            string ConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
            OleDbConnection myConnection = new OleDbConnection(ConnectionString);

            // create OleDbCommand object
            string CommandText = "SELECT PlayerID,PlayerName,PlayerManufacturerID,PlayerCost,PlayerStorage FROM Player WHERE PlayerManufacturerID = " + lstManufacturers.SelectedItem.Value;
            OleDbCommand myCommand = new OleDbCommand(CommandText, myConnection);

            try
            {
                // open the database connection
                myConnection.Open();

                // run query
                OleDbDataReader myReader = myCommand.ExecuteReader();

                // setup the GridView
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
        else
        {
            // clear the GridView
            GridView1.DataSource = null;
            GridView1.DataBind();
        }
    }
    
    protected void lstManufacturers_DataBound(object sender, EventArgs e)
    {
        ListItem myListItem = new ListItem();
        myListItem.Text = "please select...";
        myListItem.Value = "-1";
        lstManufacturers.Items.Insert(0, myListItem);
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>List Binding with Events to a DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td valign="top">
                    <asp:DropDownList ID="lstManufacturers" runat="server" DataTextField="ManufacturerName" DataValueField="ManufacturerID" AutoPostBack="True" OnSelectedIndexChanged="lstManufacturers_SelectedIndexChanged" OnDataBound="lstManufacturers_DataBound"></asp:DropDownList>
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
