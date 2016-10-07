<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.Odbc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        lblError.Visible = false;
        
        if (Page.IsPostBack == false)
        {
            LoadManufacturer();
        }
    }

    private void LoadManufacturer()
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // create the SELECT command
            string strQuery = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer WHERE ManufacturerID = ?";
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);
            myCommand.Parameters.AddWithValue("@ManufacturerID", Request.QueryString["ManufacturerID"]);

            // open the connection
            myConnection.Open();

            // execute the query
            OdbcDataReader myReader = myCommand.ExecuteReader();

            // if we have results then we need to parse them
            if (myReader.Read() == true)
            {
                // set the controls
                txtName.Text = myReader.GetString(myReader.GetOrdinal("ManufacturerName"));
                txtCountry.Text = myReader.GetString(myReader.GetOrdinal("ManufacturerCountry"));
                txtEmail.Text = myReader.GetString(myReader.GetOrdinal("ManufacturerEmail"));
                txtWebsite.Text = myReader.GetString(myReader.GetOrdinal("ManufacturerWebsite"));
                
                // save values into viewstate
                ViewState["ManufacturerName"] = txtName.Text;
                ViewState["ManufacturerCountry"] = txtCountry.Text;
                ViewState["ManufacturerEmail"] = txtEmail.Text;
                ViewState["ManufacturerWebsite"] = txtWebsite.Text;
            }

            // close the reader
            myReader.Close();
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
            lblError.Visible = true;
        }
        finally
        {
            // always close the connection
            myConnection.Close();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (Page.IsValid == true)
        {
            SaveManufacturer();
        }
    }

    private void SaveManufacturer()
    {
        // create the connection
        string strConnectionString = ConfigurationManager.ConnectionStrings["OdbcConnectionString"].ConnectionString;
        OdbcConnection myConnection = new OdbcConnection(strConnectionString);

        try
        {
            // create the SELECT command
            string strQuery = "UPDATE Manufacturer SET ManufacturerName = ?, ManufacturerCountry = ?, ManufacturerEmail = ?, ManufacturerWebsite = ? WHERE ManufacturerID = ? AND ManufacturerName = ? AND ManufacturerCountry = ? AND ManufacturerEmail = ? AND ManufacturerWebsite = ?";
            OdbcCommand myCommand = new OdbcCommand(strQuery, myConnection);
            
            // add the parameters
            myCommand.Parameters.AddWithValue("@ManufacturerName", txtName.Text);
            myCommand.Parameters.AddWithValue("@ManufacturerCountry", txtCountry.Text);
            myCommand.Parameters.AddWithValue("@ManufacturerEmail", txtEmail.Text);
            myCommand.Parameters.AddWithValue("@ManufacturerWebsite", txtWebsite.Text);
            myCommand.Parameters.AddWithValue("@ManufacturerID", Request.QueryString["ManufacturerID"]);
            myCommand.Parameters.AddWithValue("@originalManufacturerName", ViewState["ManufacturerName"]);
            myCommand.Parameters.AddWithValue("@originalManufacturerCountry", ViewState["ManufacturerCountry"]);
            myCommand.Parameters.AddWithValue("@originalManufacturerEmail", ViewState["ManufacturerEmail"]);
            myCommand.Parameters.AddWithValue("@originalManufacturerWebsite", ViewState["ManufacturerWebsite"]);

            // open the connection
            myConnection.Open();

            // execute the query
            int intCount = myCommand.ExecuteNonQuery();
            
            // no records affected is error
            if (intCount == 0)
            {
                lblError.Text = "No update was made.  Concurrency problem.";
                lblError.Visible = true;
            }
            else
            {
                // disable controls
                txtName.Enabled = false;
                txtCountry.Enabled = false;
                txtEmail.Enabled = false;
                txtWebsite.Enabled = false;
                btnUpdate.Enabled = false;

                // change the cancel to continue
                btnCancel.Text = "Continue";

                // remove from the Cache
                Cache.Remove("Manufacturers");
            }
        }
        catch (Exception ex)
        {
            lblError.Text = ex.Message;
            lblError.Visible = true;
        }
        finally
        {
            // always close the connection
            myConnection.Close();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["Type"] == "DS")
        {
            Response.Redirect("./Manufacturers_DataSource.aspx");
        }
        else if (Request.QueryString["Type"] == "DR")
        {
            Response.Redirect("./Manufacturers_DataReader.aspx");
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Edit Manufacturer Using Command</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        <table>
            <tr>
                <td>Name:</td>
                <td><asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Country:</td>
                <td><asp:TextBox ID="txtCountry" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Website:</td>
                <td><asp:TextBox ID="txtWebsite" runat="server"></asp:TextBox></td>
            </tr>
        </table>
        </div>
        <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
    </form>
</body>
</html>
