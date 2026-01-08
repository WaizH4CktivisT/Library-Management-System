using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMSPJ
{
	public partial class BookDetails : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string bookIdStr = Request.QueryString["bookId"];
                if (int.TryParse(bookIdStr, out int bookId))
                {
                    LoadBookDetails(bookId);
                }
                else
                {
                    // Invalid book ID
                    lblTitle.Text = "Invalid Book ID.";
                }
            }
        }

        private void LoadBookDetails(int bookId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            int categoryId = 0;

            // 1) Load the book row from the Books table
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
SELECT BookID, Title, Author, Publisher, ISBN, CategoryID,
       TotalCopies, AvailableCopies, AddedDate
FROM Books
WHERE BookID = @bookId;
";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@bookId", bookId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTitle.Text = reader["Title"].ToString();
                            lblAuthor.Text = reader["Author"].ToString();
                            lblPublisher.Text = reader["Publisher"].ToString();
                            lblISBN.Text = reader["ISBN"].ToString();
                            lblTotalCopies.Text = reader["TotalCopies"].ToString();
                            lblAvailableCopies.Text = reader["AvailableCopies"].ToString();

                            DateTime addedDate = Convert.ToDateTime(reader["AddedDate"]);
                            lblAddedDate.Text = addedDate.ToString("yyyy-MM-dd");

                            categoryId = Convert.ToInt32(reader["CategoryID"]);
                        }
                        else
                        {
                            lblTitle.Text = "Book not found.";
                            return;
                        }
                    }
                }
            }

            // 2) Build the category chain from subcategory up to root
            if (categoryId > 0)
            {
                lblCategoryChain.Text = GetCategoryChain(categoryId);
            }
        }

        // Build a chain like "Education > Physics > Fiction"
        private string GetCategoryChain(int leafCategoryId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

            // We'll build a list of categories from leaf up to root
            // then reverse them to show root -> leaf
            var chain = new System.Collections.Generic.List<string>();

            int currentId = leafCategoryId;
            while (currentId != 0)
            {
                // 1) Get category name + parent
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT CategoryName, ParentCategoryID FROM Categories WHERE CategoryID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@id", currentId);
                        con.Open();
                        using (SqlDataReader rd = cmd.ExecuteReader())
                        {
                            if (rd.Read())
                            {
                                string catName = rd["CategoryName"].ToString();
                                chain.Add(catName);

                                object parentObj = rd["ParentCategoryID"];
                                if (parentObj == DBNull.Value)
                                {
                                    // No parent => top-level
                                    currentId = 0;
                                }
                                else
                                {
                                    currentId = Convert.ToInt32(parentObj);
                                }
                            }
                            else
                            {
                                // If not found, break
                                break;
                            }
                        }
                    }
                }
            }

            // 2) Reverse the chain so root is first
            chain.Reverse();

            // 3) Join with " > "
            return string.Join(" > ", chain);
        }

    }
}