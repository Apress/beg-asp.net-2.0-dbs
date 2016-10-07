<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create the connection
        SqlConnection myConnection = new SqlConnection();

        // create the DataSet
        DataSet myDataSet = new DataSet();
        
        try
        {
            // configure the connection
            string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
            myConnection.ConnectionString = strConnectionString;

            // create the command
            string strCommandText = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer ORDER BY ManufacturerName";
            SqlCommand myCommand = new SqlCommand(strCommandText, myConnection);

            // create a DataAdapter
            SqlDataAdapter myAdapter = new SqlDataAdapter();
            myAdapter.SelectCommand = myCommand;

            // open the database connection
            myConnection.Open();

            // populate the DataSet
            myAdapter.Fill(myDataSet);
        }
        finally
        {
            // close the database connection
            myConnection.Close();
        }

        // bind the data 
        GridView1.DataSource = myDataSet;
        GridView1.DataBind();        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Simple DataSet binding</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        &nbsp;<asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333"
            GridLines="None">
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
    </div>
    </form>
</body>
</html>
