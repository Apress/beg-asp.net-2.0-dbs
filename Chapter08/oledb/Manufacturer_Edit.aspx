<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    OleDbDataAdapter myAdapter;
    DataSet myDataSet;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // only load if we have a manufacturer
            if (Request.QueryString["ManufacturerID"] != null)
            {
                // load all the manufacturers
                RetrieveManufacturers();

                // find the one we're after
                DataRow drManufacturer = myDataSet.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);

                // set the four controls
                ManufacturerName.Text = drManufacturer["ManufacturerName"].ToString();
                ManufacturerCountry.Text = drManufacturer["ManufacturerCountry"].ToString();
                ManufacturerEmail.Text = drManufacturer["ManufacturerEmail"].ToString();
                ManufacturerWebsite.Text = drManufacturer["ManufacturerWebsite"].ToString();
            }
            else
            {
                // we want to disable the delete button
                DeleteButton.Enabled = false;
            }
        }
    }
            
    private void RetrieveManufacturers()
    {
        // set the SQL query we need to get the manufacturers
        string strQuery = "SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer";

        // create the Connection to the database
        string ConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
        OleDbConnection myConnection = new OleDbConnection(ConnectionString);

        // create the DataAdapter
        myAdapter = new OleDbDataAdapter(strQuery, myConnection);

        // set the INSERT/UPDATE/DELETE queries up
        OleDbCommandBuilder myCommandBuilder = new OleDbCommandBuilder(myAdapter);
        
        // create a new DataSet
        myDataSet = new DataSet();

        // fill the DataSet
        myAdapter.Fill(myDataSet, "Manufacturer");
        
        // now add the primary key details
        DataColumn[] myPrimaryKey = { myDataSet.Tables["Manufacturer"].Columns["ManufacturerID"] };
        myDataSet.Tables["Manufacturer"].PrimaryKey = myPrimaryKey;
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        // only save if valid
        if (Page.IsValid == true)
        {
            // get the Manufacturers
            RetrieveManufacturers();

            // create new or use existing?
            DataRow drManufacturer = null;
            if (Request.QueryString["ManufacturerID"] == null)
            {
                // create a new DataRow
                drManufacturer = myDataSet.Tables["Manufacturer"].NewRow();
            }
            else
            {
                // find the one we're after
                drManufacturer = myDataSet.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);
            }

            // now set the column values
            drManufacturer["ManufacturerName"] = ManufacturerName.Text;
            drManufacturer["ManufacturerCountry"] = ManufacturerCountry.Text;
            drManufacturer["ManufacturerEmail"] = ManufacturerEmail.Text;
            drManufacturer["ManufacturerWebsite"] = ManufacturerWebsite.Text;

            // if new must add to table
            if (Request.QueryString["ManufacturerID"] == null)
            {
                // add a temporary primary key value
                drManufacturer["ManufacturerID"] = "-1";

                // add the DataRow to the table
                myDataSet.Tables["Manufacturer"].Rows.Add(drManufacturer);
            }

            try
            {
                // now update the database
                myAdapter.Update(myDataSet, "Manufacturer");

                // show the result
                QueryResult.Text = "Save of manufacturer was successful";

                // disable all the controls we don't want to allow changes to
                SaveButton.Enabled = false;
                DeleteButton.Enabled = false;
                ManufacturerName.Enabled = false;
                ManufacturerCountry.Enabled = false;
                ManufacturerEmail.Enabled = false;
                ManufacturerWebsite.Enabled = false;
            }
            catch (Exception ex)
            {
                // show the error
                QueryResult.Text = "An error has occurred: " + ex.Message;
            }
        }
    }

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("./Manufacturers.aspx");
    }


    protected void DeleteButton_Click(object sender, EventArgs e)
    {
        // load all the manufacturers
        RetrieveManufacturers();

        // find the one we're after
        DataRow drManufacturer = myDataSet.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);

        // delete it
        drManufacturer.Delete();

        try
        {
            // now update the database
            myAdapter.Update(myDataSet, "Manufacturer");

            // show the result
            QueryResult.Text = "Delete of manufacturer was successful";
            
            // disable all the controls we don't want to allow changes to
            SaveButton.Enabled = false;
            DeleteButton.Enabled = false;
            ManufacturerName.Enabled = false;
            ManufacturerCountry.Enabled = false;
            ManufacturerEmail.Enabled = false;
            ManufacturerWebsite.Enabled = false;            
        }
        catch (Exception ex)
        {
            // show the error
            QueryResult.Text = "An error has occurred: " + ex.Message;
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Edit Manufacturer</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Manufacturer Name: <asp:TextBox ID="ManufacturerName" runat="server"></asp:TextBox>
        <br />
        <br />
        Manufacturer Country: <asp:TextBox ID="ManufacturerCountry" runat="server"></asp:TextBox>
        <br />
        <br />
        Manufacturer Email: <asp:TextBox ID="ManufacturerEmail" runat="server"></asp:TextBox>
        <br />
        <br />
        Manufacturer Website: <asp:TextBox ID="ManufacturerWebsite" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="SaveButton" runat="server" Text="Save Manufacturer" OnClick="SaveButton_Click" />
        <asp:Button ID="DeleteButton" runat="server" Text="Delete Manufacturer" OnClick="DeleteButton_Click" /><br />
        <br />
        <asp:Button ID="ReturnButton" runat="server" Text="Return to Manufacturer List" OnClick="ReturnButton_Click" /><br />
        <br />
        <asp:Label ID="QueryResult" runat="server"></asp:Label><br />
    </div>
    </form>
</body>
</html>
