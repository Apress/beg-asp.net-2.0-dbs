<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("./Players.aspx");
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        SqlConnection myConnection = new SqlConnection(strConnectionString);

        try
        {
            // query to execute
            string strQuery = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID; DELETE FROM Player WHERE PlayerID = @PlayerID;";

            // create the command
            SqlCommand myCommand = new SqlCommand(strQuery, myConnection);

            // add the parameter
            myCommand.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);

            // open the connection
            myConnection.Open();

            // execute the query
            int intCount = myCommand.ExecuteNonQuery();

            // show the result
            QueryResult.Text = "Delete of player '" + Request.QueryString["PlayerID"] + "' was successful";

            // disable the submit button
            SubmitButton.Enabled = false;            
        }
        catch (Exception ex)
        {
            // show the error
            QueryResult.Text = "An error has occurred: " + ex.Message;
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
    <title>DELETE Player</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Are you sure you want to delete this player?<br />
        <br />
        <asp:Button ID="SubmitButton" runat="server" Text="Delete Player" OnClick="SubmitButton_Click" /><br />
        <br />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return to Player List" /><br />
        <br />
        <asp:Label ID="QueryResult" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>
