<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            // set up connection string and SQL query
            string ConnectionString = ConfigurationManager.ConnectionStrings["OleDbConnectionString"].ConnectionString;
            string CommandText = "SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite FROM Manufacturer";

            // create OleDbConnection and OleDbCommand objects
            OleDbConnection myConnection = new OleDbConnection(ConnectionString);
            OleDbCommand myCommand = new OleDbCommand(CommandText, myConnection);

            // use try finally when the connection is open
            try
            {
                // open the database connection
                myConnection.Open();

                // run query
                OleDbDataReader myReader = myCommand.ExecuteReader();

                // set the data source and bind
                Repeater1.DataSource = myReader;
                Repeater1.DataBind();

                // close the reader
                myReader.Close();
            }
            finally
            {
                // always close the database connection
                myConnection.Close();
            }
        }
    }

    protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Players")
        {
            Response.Redirect("./Repeater_DataSource.aspx?ManufacturerID=" + e.CommandArgument);
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Binding a DataReader to a Repeater</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand">
            <HeaderTemplate>
                <div style="background-color:Bisque">
                    <font size="+2">Manufacturers</font>
                </div>
                <hr style="color:blue"/>
            </HeaderTemplate>
            <ItemTemplate>
                <div style="background-color:Ivory">
                    <b>
                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("[ManufacturerName]") %>'></asp:Label>
                    </b>
                    <br />
                    Country:
                    <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("[ManufacturerCountry]") %>'></asp:Label>
                    <br />
                    Email:
                    <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# Eval("[ManufacturerEmail]", "mailto:{0}") %>' Text='<%# Eval("[ManufacturerEmail]") %>'></asp:HyperLink>
                    <br />
                    Website:
                    <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# Eval("[ManufacturerWebsite]") %>'>
                        <%# Eval("[ManufacturerWebsite]") %>
                    </asp:HyperLink>
                    <br />
                    <asp:LinkButton ID="btnProducts" runat="server" CommandName="Players" Text="View Players" CommandArgument='<%# Eval("[ManufacturerID]") %>' />
                </div>
            </ItemTemplate>
            <SeparatorTemplate>
                <hr style="color:blue"/>
            </SeparatorTemplate>
            <AlternatingItemTemplate>
                <div style="background-color:Azure">
                    <b>
                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("[ManufacturerName]") %>'></asp:Label>
                    </b>
                    <br />
                    Country:
                    <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("[ManufacturerCountry]") %>'></asp:Label>
                    <br />
                    Email:
                    <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# Eval("[ManufacturerEmail]", "mailto:{0}") %>' Text='<%# Eval("[ManufacturerEmail]") %>'></asp:HyperLink>
                    <br />
                    Website:
                    <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# Eval("[ManufacturerWebsite]") %>'>
                        <%# Eval("[ManufacturerWebsite]") %>
                    </asp:HyperLink>
                    <br />
                    <asp:LinkButton ID="btnProducts" runat="server" CommandName="Players" Text="View Players" CommandArgument='<%# Eval("[ManufacturerID]") %>' />
                </div>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    <hr style="color:blue"/>
                    <div style="background-color:Bisque">
                        <br />
                    </div>
                </FooterTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>
