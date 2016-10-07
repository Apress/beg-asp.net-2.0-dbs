<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // create the connection
            string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
            OdbcConnection myConnection = new OdbcConnection(strConnectionString);
                    
            // create the command
            string strCommandText = @"
              SELECT ManufacturerID, ManufacturerName
              FROM Manufacturer
              ORDER BY ManufacturerName";
            OdbcCommand myCommand = new OdbcCommand(strCommandText, myConnection);

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
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        // build the basic query
        string strCommandText = @"
          SELECT Player.PlayerName, Manufacturer.ManufacturerName
          FROM Player INNER JOIN Manufacturer
            ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID
          WHERE ? = 0 OR Player.PlayerManufacturerID = ?";

        // create the command
        OdbcCommand myCommand = new OdbcCommand(strCommandText, myConnection);

        // add the first parameter
        OdbcParameter myParameter1 = new OdbcParameter();
        myParameter1.OdbcType = OdbcType.Int;
        myParameter1.Value = DropDownList1.SelectedValue;
        myCommand.Parameters.Add(myParameter1);

        // add the second parameter
        OdbcParameter myParameter2 = new OdbcParameter();
        myParameter2.OdbcType = OdbcType.Int;
        myParameter2.Value = DropDownList1.SelectedValue;
        myCommand.Parameters.Add(myParameter2);

        // create the count query
        string strCommandTextCount = @"
          SELECT COUNT(*)
          FROM Player
          WHERE ? = 0 OR Player.PlayerManufacturerID = ?";
        OdbcCommand myCommandCount = new OdbcCommand(strCommandTextCount, myConnection);
        OdbcParameter myParameterCount1 = new OdbcParameter();
        myParameterCount1.OdbcType = OdbcType.Int;
        myParameterCount1.Value = DropDownList1.SelectedValue;
        myCommandCount.Parameters.Add(myParameterCount1);
        OdbcParameter myParameterCount2 = new OdbcParameter();
        myParameterCount2.OdbcType = OdbcType.Int;
        myParameterCount2.Value = DropDownList1.SelectedValue;
        myCommandCount.Parameters.Add(myParameterCount2);

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
    <title>Displaying Data with OdbcClient</title>
</head>
<body>
    <form id="form2" runat="server">
    <div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" OnDataBound="DropDownList1_DataBound">
        </asp:DropDownList><br />
        Players for this manufactuer: &nbsp;<asp:Label ID="lblCount" runat="server"></asp:Label><br />
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
