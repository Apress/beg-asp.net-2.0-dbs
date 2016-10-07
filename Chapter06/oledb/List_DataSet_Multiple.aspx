<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Text" %>

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

            // setup the list control
            ListBox1.DataSource = myDataSet;
            ListBox1.DataMember = "Manufacturer";
            ListBox1.DataBind();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        // set up SQL query for Player table
        StringBuilder Query = new StringBuilder("SELECT PlayerID,PlayerName,PlayerManufacturerID,PlayerCost,PlayerStorage FROM Player WHERE PlayerManufacturerID IN (");

        bool gotResult = false;

        for (int i = 0; i < ListBox1.Items.Count; i++)
        {
            if (ListBox1.Items[i].Selected)
            {
                if (gotResult == true) Query.Append(",");
                Query.Append(ListBox1.Items[i].Value);
                gotResult = true;
            }
        }

        Query.Append(")");

        // get results if we have a selection
        if (gotResult)
        {
            // setup the GridView
            GridView1.DataSource = BuildDataSet(Query.ToString(), "Player");
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
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Multiple Selection Using a DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table>
        <tr>
            <td valign="top">
                <asp:ListBox ID="ListBox1" runat="server" SelectionMode="Multiple" DataTextField="ManufacturerName" DataValueField="ManufacturerID"></asp:ListBox>
                <br />
                <asp:Button ID="Button1" runat="server" Text="Select" OnClick="Button1_Click" />
            </td>
            <td valign="top">
                <asp:GridView ID="GridView1" runat="server">
                </asp:GridView>
            </td>
        </tr>
    </table>
    </div>
    </form>
</body>
</html>
