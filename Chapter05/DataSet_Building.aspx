<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(strConnectionString);

        // create a new DataSet
        DataSet myDataSet = new DataSet();

        // create the data
        GenerateDataSet(myDataSet, myConnection);

        // bind each to table to a grid
        grdManufacturer.DataSource = myDataSet.Tables["Manufacturer"];
        grdPlayer.DataSource = myDataSet.Tables["Player"];
        grdFormat.DataSource = myDataSet.Tables["Format"];
        grdWPWF.DataSource = myDataSet.Tables["WhatPlaysWhatFormat"];

        // databind the page
        Page.DataBind();
    }

    void GenerateDataSet(DataSet dset, SqlConnection conn)
    {
        // add four tables
        AddPlayerTable(dset);
        AddManufacturerTable(dset);
        AddFormatTable(dset);
        AddWhatPlaysWhatFormatTable(dset);

        // add the relationships
        AddRelationships(dset);

        // fill the tables
        FillManufacturerTable(dset, conn);
        FillPlayerTable(dset, conn);
        FillFormatTable(dset, conn);
        FillWhatPlaysWhatFormatTable(dset, conn);
    }

    void AddPlayerTable(DataSet dset)
    {
        // create the table
        DataTable PlayerTable = new DataTable("Player");

        // create the columns
        DataColumn PlayerID = PlayerTable.Columns.Add("PlayerID", typeof(Int32));
        PlayerTable.Columns.Add("PlayerName", typeof(String));
        PlayerTable.Columns.Add("PlayerManufacturerID", typeof(Int32));
        PlayerTable.Columns.Add("PlayerCost", typeof(Decimal));
        PlayerTable.Columns.Add("PlayerStorage", typeof(String));
        
        // set the column properties
        PlayerTable.Columns["PlayerName"].MaxLength = 50;
        PlayerTable.Columns["PlayerName"].AllowDBNull = false;
        PlayerTable.Columns["PlayerManufacturerID"].AllowDBNull = false;
        PlayerTable.Columns["PlayerCost"].AllowDBNull = false;
        PlayerTable.Columns["PlayerStorage"].MaxLength = 50;
        PlayerTable.Columns["PlayerStorage"].AllowDBNull = false;

        // set the primary key
        PlayerTable.PrimaryKey = new DataColumn[] { PlayerID };
        PlayerTable.Columns["PlayerID"].AutoIncrement = true;
        PlayerTable.Columns["PlayerID"].AutoIncrementSeed = 1;

        // add the table
        dset.Tables.Add(PlayerTable);
    }

    void AddManufacturerTable(DataSet dset)
    {
        // create and add the table
        DataTable ManufacturerTable = dset.Tables.Add("Manufacturer");

        // create the columns
        DataColumn ManufacturerID = ManufacturerTable.Columns.Add("ManufacturerID", typeof(Int32));
        ManufacturerTable.Columns.Add("ManufacturerName", typeof(String));
        ManufacturerTable.Columns.Add("ManufacturerCountry", typeof(String));
        ManufacturerTable.Columns.Add("ManufacturerEmail", typeof(String));
        ManufacturerTable.Columns.Add("ManufacturerWebsite", typeof(String));

        // set the properties
        ManufacturerTable.Columns["ManufacturerName"].MaxLength = 50;
        ManufacturerTable.Columns["ManufacturerName"].AllowDBNull = false;
        ManufacturerTable.Columns["ManufacturerCountry"].MaxLength = 50;
        ManufacturerTable.Columns["ManufacturerEmail"].MaxLength = 50;
        ManufacturerTable.Columns["ManufacturerWebsite"].MaxLength = 50;

        // set the primary key
        ManufacturerTable.PrimaryKey = new DataColumn[] { ManufacturerID };
        ManufacturerTable.Columns["ManufacturerID"].AutoIncrement = true;
        ManufacturerTable.Columns["ManufacturerID"].AutoIncrementSeed = 1;
    }

    void AddFormatTable(DataSet dset)
    {
        // create and add the table
        DataTable FormatTable = dset.Tables.Add("Format");

        // create the columns
        DataColumn FormatID = FormatTable.Columns.Add("FormatID", typeof(Int32));
        FormatTable.Columns.Add("FormatAbbreviation", typeof(String));

        // set the properties
        FormatTable.Columns["FormatAbbreviation"].MaxLength = 50;
        FormatTable.Columns["FormatAbbreviation"].AllowDBNull = false;

        // set the primary key
        FormatTable.PrimaryKey = new DataColumn[] { FormatID };
        FormatTable.Columns["FormatID"].AutoIncrement = true;
        FormatTable.Columns["FormatID"].AutoIncrementSeed = 1;
    }

    void AddWhatPlaysWhatFormatTable(DataSet dset)
    {
        // create the table
        DataTable WhatPlaysWhatFormatTable = new DataTable("WhatPlaysWhatFormat");

        // add the columns
        WhatPlaysWhatFormatTable.Columns.Add("WPWFPlayerID", typeof(Int32));
        WhatPlaysWhatFormatTable.Columns.Add("WPWFFormatID", typeof(Int32));

        // set the primary key
        WhatPlaysWhatFormatTable.PrimaryKey = new DataColumn[] { WhatPlaysWhatFormatTable.Columns["WPWFPlayerID"], WhatPlaysWhatFormatTable.Columns["WPWFFormatID"] };

        // add the table
        dset.Tables.Add(WhatPlaysWhatFormatTable);
    }

    void AddRelationships(DataSet dset)
    {
        // create the Manufacturer to Player relationship
        DataRelation ManufacturerToPlayerRelation = new DataRelation("ManufacturerToPlayer", dset.Tables["Manufacturer"].Columns["ManufacturerID"], dset.Tables["Player"].Columns["PlayerManufacturerID"]);
        dset.Relations.Add(ManufacturerToPlayerRelation);
        ForeignKeyConstraint ManufacturerToPlayerConstraint = ManufacturerToPlayerRelation.ChildKeyConstraint;
        ManufacturerToPlayerConstraint.DeleteRule = Rule.None;
        ManufacturerToPlayerConstraint.UpdateRule = Rule.None;

        // create the Player to WhatPlaysWhatFormat relationship
        DataRelation PlayerToWhatPlaysWhatFormatRelation = new DataRelation("PlayerToWhatPlaysWhatFormat", dset.Tables["Player"].Columns["PlayerID"], dset.Tables["WhatPlaysWhatFormat"].Columns["WPWFPlayerID"]);
        dset.Relations.Add(PlayerToWhatPlaysWhatFormatRelation);
        ForeignKeyConstraint PlayerToWhatPlaysWhatFormatConstraint = PlayerToWhatPlaysWhatFormatRelation.ChildKeyConstraint;
        PlayerToWhatPlaysWhatFormatConstraint.DeleteRule = Rule.None;
        PlayerToWhatPlaysWhatFormatConstraint.UpdateRule = Rule.None;

        // create the Player to Manufacturer relationship
        DataRelation FormatToWhatPlaysWhatFormatRelation = new DataRelation("FormatToWhatPlaysWhatFormat", dset.Tables["Format"].Columns["FormatID"], dset.Tables["WhatPlaysWhatFormat"].Columns["WPWFFormatID"]);
        dset.Relations.Add(FormatToWhatPlaysWhatFormatRelation);
        ForeignKeyConstraint FormatToWhatPlaysWhatFormatConstraint = FormatToWhatPlaysWhatFormatRelation.ChildKeyConstraint;
        FormatToWhatPlaysWhatFormatConstraint.DeleteRule = Rule.None;
        FormatToWhatPlaysWhatFormatConstraint.UpdateRule = Rule.None;
    }
    
    void FillManufacturerTable(DataSet dset, SqlConnection conn)
    {
        // create a row on the table
        DataRow NewRow = dset.Tables["Manufacturer"].NewRow();
        NewRow["ManufacturerID"] = 1;
        NewRow["ManufacturerName"] = "Apple";
        NewRow["ManufacturerCountry"] = "USA";
        NewRow["ManufacturerEmail"] = "lackey@apple.com";
        NewRow["ManufacturerWebsite"] = "http:/www.apple.com";
        dset.Tables["Manufacturer"].Rows.Add(NewRow);

        // create a row from an array
        Object[] NewRowFields = new Object[5];
        NewRowFields[0] = 2;
        NewRowFields[1] = "Cowon";
        NewRowFields[2] = "Korea";
        NewRowFields[3] = "moomoo@cowon.com";
        NewRowFields[4] = "http://www.cowon.com";
        dset.Tables["Manufacturer"].Rows.Add(NewRowFields);

        // create the Command and DataAdapter  
        SqlDataAdapter ManufacturerAdapter = new SqlDataAdapter();
        SqlCommand ManufacturerCommand = new SqlCommand("SELECT * FROM Manufacturer ORDER BY ManufacturerID", conn);
        ManufacturerAdapter.SelectCommand = ManufacturerCommand;

        // fill the DataTable
        ManufacturerAdapter.Fill(dset, 2, 0, "Manufacturer");
    }

    void FillPlayerTable(DataSet dset, SqlConnection conn)
    {
        // create the Command and DataAdapter  
        SqlDataAdapter PlayerAdapter = new SqlDataAdapter();
        SqlCommand PlayerCommand = new SqlCommand("SELECT * FROM Player ORDER BY PlayerID", conn);
        PlayerAdapter.SelectCommand = PlayerCommand;

        // fill the DataTable
        PlayerAdapter.Fill(dset, "Player");
    }

    void FillFormatTable(DataSet dset, SqlConnection conn)
    {
        // create the Command and DataAdapter  
        SqlDataAdapter FormatAdapter = new SqlDataAdapter();
        SqlCommand FormatCommand = new SqlCommand("SELECT * FROM Format ORDER BY FormatID", conn);
        FormatAdapter.SelectCommand = FormatCommand;

        // fill the DataTable
        FormatAdapter.Fill(dset, "Format");
    }

    void FillWhatPlaysWhatFormatTable(DataSet dset, SqlConnection conn)
    {
        // create the Command and DataAdapter  
        SqlDataAdapter WhatPlaysWhatFormatAdapter = new SqlDataAdapter();
        SqlCommand WhatPlaysWhatFormatCommand = new SqlCommand("SELECT * FROM WhatPlaysWhatFormat", conn);
        WhatPlaysWhatFormatAdapter.SelectCommand = WhatPlaysWhatFormatCommand;

        // fill the DataTable
        WhatPlaysWhatFormatAdapter.Fill(dset, "WhatPlaysWhatFormat");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
  <form id="form1" runat="server">
  <div>
    <asp:GridView ID="grdManufacturer" runat="server">
    </asp:GridView>
    <asp:GridView ID="grdPlayer" runat="server">
    </asp:GridView>
    <asp:GridView ID="grdFormat" runat="server">
    </asp:GridView>
    <asp:GridView ID="grdWPWF" runat="server">
    </asp:GridView>
  </div>
  </form>
</body> 

</html>
