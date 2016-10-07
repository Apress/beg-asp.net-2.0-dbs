<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // create the connection
            string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
            SqlConnection myConnection = new SqlConnection(strConnectionString);
                    
            // create the command
            string strCommandText = @"
              SELECT ManufacturerID, ManufacturerName
              FROM Manufacturer
              ORDER BY ManufacturerName";
            SqlCommand myCommand = new SqlCommand(strCommandText, myConnection);

            // open the database connection
            myConnection.Open();
                  
            // show the data
            DropDownList1.DataSource = myCommand.ExecuteReader();
            DropDownList1.DataTextField = "ManufacturerName";
            DropDownList1.DataValueField = "ManufacturerID";
            DropDownList1.DataBind();
                    
            // close the database connection
            myConnection.Close();

            // force the first data bind
            DropDownList1_SelectedIndexChanged(null,null);
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(strConnectionString);

        // build the basic query
        string strCommandText = @"
          SELECT Player.PlayerName, Manufacturer.ManufacturerName
          FROM Player INNER JOIN Manufacturer
            ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID
          WHERE @ManufacturerID = 0 OR Player.PlayerManufacturerID = @ManufacturerID";

        // create the command
        SqlCommand myCommand = new SqlCommand(strCommandText, myConnection);

        // add the parameter
        SqlParameter myParameter = new SqlParameter();
        myParameter.ParameterName = "@ManufacturerID";
        myParameter.SqlDbType = SqlDbType.Int;
        myParameter.Value = DropDownList1.SelectedValue;
        myCommand.Parameters.Add(myParameter);

        // create the count query
        string strCommandTextCount = @"
          SELECT COUNT(*)
          FROM Player
          WHERE @ManufacturerID = 0 OR Player.PlayerManufacturerID = @ManufacturerID";
        SqlCommand myCommandCount = new SqlCommand(strCommandTextCount, myConnection);
        SqlParameter myParameterCount = new SqlParameter();
        myParameterCount.ParameterName = "@ManufacturerID";
        myParameterCount.SqlDbType = SqlDbType.Int;
        myParameterCount.Value = DropDownList1.SelectedValue;
        myCommandCount.Parameters.Add(myParameterCount);

        // open the database connection
        myConnection.Open();

        // count the players for the manufacturer
        lblCount.Text = Convert.ToString(myCommandCount.ExecuteScalar());
        
        // show the data
        GridView1.DataSource = myCommand.ExecuteReader();
        GridView1.DataBind();

        // close the database connection
        myConnection.Close();
    }

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        DropDownList1.Items.Insert(0, new ListItem("-- All Manufacturers --", "0"));
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Displaying Data with SqlClient</title>
</head>
<body>
    <form id="form2" runat="server">
    <div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" OnDataBound="DropDownList1_DataBound">
        </asp:DropDownList><br />
        Players for this Manufacturer: &nbsp;<asp:Label ID="lblCount" runat="server"></asp:Label><br />
        <asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
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
