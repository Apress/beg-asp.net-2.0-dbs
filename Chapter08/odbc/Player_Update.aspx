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

            // retrieve existing player
            RetrieveExistingPlayer();
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
            // save the player to the database
            bool blnPlayerError = SavePlayer();

            // did an error occur?
            if (blnPlayerError == true)
            {
                QueryResult.Text = "An error has occurred!";
            }
            else
            {
                // save the formats for the player
                bool blnFormatError = SaveFormats();

                // did an error occur?
                if (blnFormatError == true)
                {
                    QueryResult.Text = "An error has occurred!";
                }
                else
                {
                    // show the result
                    QueryResult.Text = "Save of player '" + Request.QueryString["PlayerID"].ToString() + "' was successful";

                    // disable the submit button
                    SubmitButton.Enabled = false;
                }
            }
        }
    }
    
    private bool SavePlayer()
    {
        bool blnError = false;

        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "UPDATE Player SET PlayerName = @Name, PlayerManufacturerID = @ManufacturerID, PlayerCost = @Cost, PlayerStorage = @Storage WHERE PlayerID = @PlayerID;";

            // create the command
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);

            // add the parameters
            myCommand.Parameters.AddWithValue("@Name", PlayerName.Text);
            myCommand.Parameters.AddWithValue("@ManufacturerID", ManufacturerList.SelectedValue);
            myCommand.Parameters.AddWithValue("@Cost", PlayerCost.Text);
            myCommand.Parameters.AddWithValue("@Storage", PlayerStorage.Text);
            myCommand.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);

            // open the connection
            myConnection.Open();

            // execute the query
            myCommand.ExecuteNonQuery();
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

    private bool SaveFormats()
    {
        bool blnError = false;

        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // create the DELETE query
            string strQuery1 = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID;";
            OdbcCommand myCommand1 = new OdbcCommand(strQuery1, myConnection);
            myCommand1.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);

            // create the INSERT query
            string strQuery2 = "INSERT WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID) VALUES (@PlayerID, @FormatID)";
            OdbcCommand myCommand2 = new OdbcCommand(strQuery2, myConnection);
            myCommand2.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);
            myCommand2.Parameters.Add("@FormatID", System.Data.Odbc.OdbcType.Int);

            // open the connection
            myConnection.Open();

            // execute the DELETE query
            myCommand1.ExecuteNonQuery();

            // loop through each of the formats
            foreach (ListItem objFormat in FormatList.Items)
            {
                // save if selected
                if (objFormat.Selected == true)
                {
                    // set the parameter value
                    myCommand2.Parameters["@FormatID"].Value = objFormat.Value;

                    // execute the query
                    myCommand2.ExecuteNonQuery();
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

    private void RetrieveExistingPlayer()
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // create the first SELECT command
            string strQuery1 = "SELECT PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player WHERE PlayerID=@PlayerID;";
            OdbcCommand myCommand1 = new OdbcCommand(strQuery1, myConnection);
            myCommand1.Parameters.AddWithValue("@PlayerID",
              Request.QueryString["PlayerID"]);

            // create the first SELECT command
            string strQuery2 = "SELECT WPWFFormatID FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID;";
            OdbcCommand myCommand2 = new OdbcCommand(strQuery2, myConnection);
            myCommand2.Parameters.AddWithValue("@PlayerID",
              Request.QueryString["PlayerID"]);

            // open the connection
            myConnection.Open();

            // execute the first query
            OdbcDataReader myReader1 = myCommand1.ExecuteReader();

            // if we have results then we need to parse them
            if (myReader1.Read() == true)
            {
                PlayerName.Text = myReader1.GetString(myReader1.GetOrdinal("PlayerName"));
                ManufacturerList.SelectedValue = myReader1.GetInt32(myReader1.GetOrdinal("PlayerManufacturerID")).ToString();
                PlayerCost.Text = myReader1.GetDecimal(myReader1.GetOrdinal("PlayerCost")).ToString();
                PlayerStorage.Text = myReader1.GetString(myReader1.GetOrdinal("PlayerStorage"));
            }

            // close the first data reader
            myReader1.Close();

            // execute the second query
            OdbcDataReader myReader2 = myCommand2.ExecuteReader();

            // if we have results then we need to parse them
            while (myReader2.Read() == true)
            {
                foreach (ListItem objFormat in FormatList.Items)
                {
                    if (objFormat.Value == myReader2.GetInt32(myReader2.GetOrdinal("WPWFFormatID")).ToString())
                    {
                        objFormat.Selected = true;
                        break;
                    }
                }
            }

            // close the second data reader
            myReader2.Close();
        }
        finally
        {
            // close the connection
            myConnection.Close();
        }
    }

    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>UPDATE Player</title>
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
        <asp:Button ID="SubmitButton" runat="server" Text="Update Player" OnClick="SubmitButton_Click" /><br />
        <br />
        <asp:Button ID="ReturnButton" runat="server" Text="Return to Player List" OnClick="ReturnButton_Click" /><br />
        <br />
        <asp:Label ID="QueryResult" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>
