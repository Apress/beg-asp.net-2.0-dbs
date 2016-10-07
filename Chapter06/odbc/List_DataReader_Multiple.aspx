<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>
<%@ Import Namespace="System.Text" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
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

                // set up SQL query for Manufacturer table
                myCommand.CommandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

                // run query
                OdbcDataReader myReader = myCommand.ExecuteReader();

                // setup the list control
                ListBox1.DataSource = myReader;
                ListBox1.DataBind();

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

    protected void Button1_Click(object sender, EventArgs e)
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
                // set the query to execute
                myCommand.CommandText = Query.ToString();

                // run the query
                OdbcDataReader myReader = myCommand.ExecuteReader();

                // setup the GridView
                GridView1.DataSource = myReader;
                GridView1.DataBind();

                // close the reader
                myReader.Close();
            }
            else
            {
                // clear the GridView
                GridView1.DataSource = null;
                GridView1.DataBind();
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
    <title>Multiple Selection Using a DataReader</title>
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
