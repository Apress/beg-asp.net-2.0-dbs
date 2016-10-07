<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Calling a Stored Procedure in a SqlDataSource</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:SqlConnectionString %>"
            SelectCommand="spGetPlayersByManufacturer"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Direction="Input" DefaultValue="0" Name="manufacturer" QueryStringField="manufacturerid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1">
        </asp:GridView>
    </form>
</body>
</html>
