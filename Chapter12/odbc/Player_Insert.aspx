<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // populate the list of manufacturers
            PopulateManufacturers();

            // populate the list of formats
            PopulateFormats();
        }
    }

    private void PopulateManufacturers()
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName";

            // create the command
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);

            // open the database connection
            myConnection.Open();

            // run query
            OdbcDataReader myReader = myCommand.ExecuteReader();

            // set the data source and bind
            ManufacturerList.DataSource = myReader;
            ManufacturerList.DataTextField = "ManufacturerName";
            ManufacturerList.DataValueField = "ManufacturerID";
            ManufacturerList.DataBind();

            // close the reader
            myReader.Close();
        }
        finally
        {
            // always close the database connection
            myConnection.Close();
        }
    }

    protected void ManufacturerList_DataBound(object sender, EventArgs e)
    {
        ListItem myListItem = new ListItem();
        myListItem.Text = "please select...";
        myListItem.Value = "0";
        ManufacturerList.Items.Insert(0, myListItem);
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        // only save if valid
        if (Page.IsValid == true)
        {
            // create the connection
            string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
            OdbcConnection myConnection = new OdbcConnection(strConnectionString);

            try
            {
                // open the connection
                myConnection.Open();

                // begin the transaction
                OdbcTransaction myTransaction = myConnection.BeginTransaction();

                // save the player
                int intPlayerID = SavePlayer(myConnection, myTransaction);

                // save the formats
                SaveFormats(intPlayerID, myConnection, myTransaction);

                // commit the transaction
                myTransaction.Commit();

                // show the result
                QueryResult.Text = "Save of player '" + intPlayerID.ToString() + "' was successful";

                // disable the submit button
                SubmitButton.Enabled = false;
            }
            catch
            {
                // show the error 
                QueryResult.Text = "An error has occurred!";
            }
            finally
            {
                // always close the connection                
                myConnection.Close();
            }
        }
    }

    private int SavePlayer(OdbcConnection myConnection, OdbcTransaction myTransaction)
    {
        // create the INSERT query
        string strQuery1 = "INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage) VALUES (?, ?, ?, ?);";
        OdbcCommand myCommand1 = new OdbcCommand(strQuery1, myConnection, myTransaction);

        // add the four parameters
        myCommand1.Parameters.AddWithValue("?", PlayerName.Text);
        myCommand1.Parameters.AddWithValue("?", ManufacturerList.SelectedValue);
        myCommand1.Parameters.AddWithValue("?", PlayerCost.Text);
        myCommand1.Parameters.AddWithValue("?", PlayerStorage.Text);

        // create the SELECT query
        string strQuery2 = "SELECT LAST_INSERT_ID();";
        OdbcCommand myCommand2 = new OdbcCommand(strQuery2, myConnection, myTransaction);

        // execute the queries we need to execute
        myCommand1.ExecuteNonQuery();
        int intPlayerID = Convert.ToInt32(myCommand2.ExecuteScalar());
 
        // return the ID
        return (intPlayerID);
    }

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("./Players.aspx");
    }

    private void PopulateFormats()
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT FormatID, FormatName FROM Format ORDER BY FormatName";

            // create the command
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);

            // open the database connection
            myConnection.Open();

            // run query
            OdbcDataReader myReader = myCommand.ExecuteReader();

            // set the data source and bind
            FormatList.DataSource = myReader;
            FormatList.DataTextField = "FormatName";
            FormatList.DataValueField = "FormatID";
            FormatList.DataBind();

            // close the reader
            myReader.Close();
        }
        finally
        {
            // always close the database connection
            myConnection.Close();
        }
    }

    private void SaveFormats(int intPlayerID, OdbcConnection myConnection, OdbcTransaction myTransaction)
    {
        // query to execute
        string strQuery = "INSERT WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (?, ?)";

        // create the command object
        OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection, myTransaction);

        // add the two parameters
        myCommand.Parameters.AddWithValue("@PlayerID", intPlayerID);
        myCommand.Parameters.Add("@FormatID", System.Data.Odbc.OdbcType.Int);

        // loop through each of the formats
        foreach (ListItem objFormat in FormatList.Items)
        {
            // save if selected
            if (objFormat.Selected == true)
            {
                // set the parameter value
                myCommand.Parameters["@FormatID"].Value = objFormat.Value;

                // execute the query
                myCommand.ExecuteNonQuery();
            }
        }
    }

    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (FormatList.SelectedIndex == -1)
        {
            args.IsValid = false;
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>INSERT Player</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="PlayerName"
            Display="Dynamic" ErrorMessage="You must enter a name">*</asp:RequiredFieldValidator>Player Name: <asp:TextBox ID="PlayerName" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="ManufacturerList"
            Display="Dynamic" ErrorMessage="You must select a manufacturer" Operator="NotEqual"
            ValueToCompare="0">*</asp:CompareValidator>Manufacturer: <asp:DropDownList ID="ManufacturerList" runat="server" OnDataBound="ManufacturerList_DataBound"></asp:DropDownList>
        <br />
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="PlayerCost"
            Display="Dynamic" ErrorMessage="You must enter a cost">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="PlayerCost"
            Display="Dynamic" ErrorMessage="You must specify the cost as a decimal" ValidationExpression="^\d+(\.\d\d)">*</asp:RegularExpressionValidator>Player Cost: <asp:TextBox ID="PlayerCost" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="PlayerStorage"
            Display="Dynamic" ErrorMessage="You must enter a storage type">*</asp:RequiredFieldValidator>Player Storage: <asp:TextBox ID="PlayerStorage" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="You must select at least one media format"
            OnServerValidate="CustomValidator1_ServerValidate">*</asp:CustomValidator>Supported Formats:<br />
        <asp:CheckBoxList ID="FormatList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal"></asp:CheckBoxList>
        <br />
        <asp:Button ID="SubmitButton" runat="server" Text="Insert Player" OnClick="SubmitButton_Click" /><br />
        <br />
        <asp:Button ID="ReturnButton" runat="server" Text="Return to Player List" OnClick="ReturnButton_Click" /><br />
        <br />
        <asp:Label ID="QueryResult" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>
