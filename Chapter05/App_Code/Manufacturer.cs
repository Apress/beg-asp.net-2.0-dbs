using System.Text;

public class Manufacturer
{
    public string Name;
    public string Country;
    public string Email;
    public string Website;

    public Manufacturer()
    {
    }

    public override string ToString()
    {
        StringBuilder sbDescription = new StringBuilder();

        // add the name
        sbDescription.Append("Name: ");
        sbDescription.Append(this.Name);
        sbDescription.Append("<BR/>");

        // add the city
        sbDescription.Append("Country: ");
        sbDescription.Append(this.Country);
        sbDescription.Append("<BR/>");

        // add the email
        sbDescription.Append("Email: ");
        sbDescription.Append("<a href='mailto:");
        sbDescription.Append(this.Email);
        sbDescription.Append("'>");
        sbDescription.Append(this.Email);
        sbDescription.Append("</a>");
        sbDescription.Append("<BR/>");

        // add the website
        sbDescription.Append("Website: ");
        sbDescription.Append("<a href='");
        sbDescription.Append(this.Website);
        sbDescription.Append("'>");
        sbDescription.Append(this.Website);
        sbDescription.Append("</a>");
        sbDescription.Append("<BR/>");

        return (sbDescription.ToString());
    }
}
