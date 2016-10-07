<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

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
        string strConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName";

            // create the command
            OleDbCommand myCommand = new OleDbCommand(strQuery, myConnection);

            // open the database connection
            myConnection.Open();

            // run query
            OleDbDataReader myReader = myCommand.ExecuteReader();

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
            // save the player to the database
            int intPlayerID = SavePlayer();

            // did an error occur?
            if (intPlayerID == -1)
            {
                QueryResult.Text = "An error has occurred!";
            }
            else
            {
                // save the formats for the player
                bool blnError = SaveFormats(intPlayerID);

                // did an error occur?
                if (blnError == true)
                {
                    QueryResult.Text = "An error has occurred!";
                }
                else
                {
                    // show the result
                    QueryResult.Text = "Save of player '" + intPlayerID.ToString() + "' was successful";

                    // disable the submit button
                    SubmitButton.Enabled = false;
                }
            }
        }
    }
    
    private int SavePlayer()
    {
        int intPlayerID = 0;

        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(strConnectionString);

        try
        {
            // create the INSERT query
            string strQuery1 = "INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage) VALUES (?, ?, ?, ?);";
            OleDbCommand myCommand1 = new OleDbCommand(strQuery1, myConnection);

            // add the parameters
            myCommand1.Parameters.AddWithValue("?", PlayerName.Text);
            myCommand1.Parameters.AddWithValue("?", ManufacturerList.SelectedValue);
            myCommand1.Parameters.AddWithValue("?", PlayerCost.Text);
            myCommand1.Parameters.AddWithValue("?", PlayerStorage.Text);

            // create the SELECT query
            string strQuery2 = "SELECT @@IDENTITY;";
            OleDbCommand myCommand2 = new OleDbCommand(strQuery2, myConnection);

            // open the connection
            myConnection.Open();

            // execute the queries we need to execute
            myCommand1.ExecuteNonQuery();
            intPlayerID = Convert.ToInt32(myCommand2.ExecuteScalar());
        }
        catch
        {
            // return -1 to indicate error
            intPlayerID = -1;
        }            
        finally
        {
            // close the connection
            myConnection.Close();
        }

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
        string strConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "SELECT FormatID, FormatName FROM Format ORDER BY FormatName";

            // create the command
            OleDbCommand myCommand = new OleDbCommand(strQuery, myConnection);

            // open the database connection
            myConnection.Open();

            // run query
            OleDbDataReader myReader = myCommand.ExecuteReader();

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

    private bool SaveFormats(int intPlayerID)
    {
        bool blnError = false;

        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "INSERT INTO WhatPlaysWhatFormat(WPWFPlayerID, WPWFFormatID) VALUES (@PlayerID, @FormatID)";

            // create the command
            OleDbCommand myCommand = new OleDbCommand(strQuery, myConnection);

            // add the two parameters
            myCommand.Parameters.AddWithValue("@PlayerID", intPlayerID);
            myCommand.Parameters.Add("@FormatID", System.Data.OleDb.OleDbType.Integer);

            // open the connection
            myConnection.Open();

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
        catch
        {
            // indicate that we have an error
            blnError = true;
        }
        finally
        {
            // close the connection
            myConnection.Close();
        }

        // return the error flag
        return (blnError);
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
        <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="You must select at least one format"
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
