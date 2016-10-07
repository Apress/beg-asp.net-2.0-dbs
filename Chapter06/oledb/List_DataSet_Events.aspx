<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    private DataSet BuildDataSet(string commandText, string tableName)
    {
        // DataSet we're going to return
        DataSet myDataSet = new DataSet();

        // set up connection string
        string ConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;

        // create OleDbConnection and OleDbCommand objects
        OleDbConnection myConnection = new OleDbConnection(ConnectionString);
        OleDbCommand myCommand = new OleDbCommand(commandText, myConnection);

        // Create the OleDbDataAdapter
        OleDbDataAdapter myAdapter = new OleDbDataAdapter(myCommand);

        try
        {
            // open the database connection
            myConnection.Open();

            // fill the DataSet
            myAdapter.Fill(myDataSet, tableName);
        }
        finally
        {
            // always close the connection
            myConnection.Close();
        }

        // return the DataSet
        return (myDataSet);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // set up SQL query for Manufacturer table
            string CommandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

            // DataSet with list of manufacturers
            DataSet myDataSet = BuildDataSet(CommandText, "Manufacturer");

            // setup the DropDownList
            lstManufacturers.DataSource = myDataSet;
            lstManufacturers.DataMember = "Manufacturer";
            lstManufacturers.DataBind();

            // setup the RadioButtonList
            RadioButtonList1.DataSource = myDataSet;
            RadioButtonList1.DataMember = "Manufacturer";
            RadioButtonList1.DataBind();
        }
    }

    protected void lstManufacturers_SelectedIndexChanged(object sender, EventArgs e)
    {
      if (lstManufacturers.SelectedValue != "-1")
      {
        // set up SQL query for Player table
        string CommandText = "SELECT PlayerID,PlayerName,PlayerManufacturerID,PlayerCost,PlayerStorage FROM Player WHERE PlayerManufacturerID = " + lstManufacturers.SelectedItem.Value;

        // setup the GridView
        GridView1.DataSource = BuildDataSet(CommandText, "Player");
        GridView1.DataMember = "Player";
        GridView1.DataBind();
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

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        // set up SQL query for Player table
        string CommandText = "SELECT PlayerID,PlayerName,PlayerManufacturerID,PlayerCost,PlayerStorage FROM Player WHERE PlayerManufacturerID = " + RadioButtonList1.SelectedItem.Value;

        // setup the GridView
        GridView1.DataSource = BuildDataSet(CommandText, "Player");
        GridView1.DataMember = "Player";
        GridView1.DataBind();
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>List Binding with Events to a DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td valign="top">
                    <asp:DropDownList ID="lstManufacturers" runat="server" DataTextField="ManufacturerName" DataValueField="ManufacturerID" AutoPostBack="True" OnSelectedIndexChanged="lstManufacturers_SelectedIndexChanged" OnDataBound="lstManufacturers_DataBound"></asp:DropDownList>
                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="True" DataTextField="ManufacturerName"
                        DataValueField="ManufacturerID" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged">
                    </asp:RadioButtonList></td>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server"></asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
