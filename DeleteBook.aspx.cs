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
	public partial class DeleteBook : System.Web.UI.Page
	{
        private int bookId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["bookId"]))
                {
                    if (int.TryParse(Request.QueryString["bookId"], out bookId))
                    {
                        LoadBookDetails(bookId);
                    }
                    else
                    {
                        ShowErrorAndRedirect("Invalid book ID.");
                    }
                }
                else
                {
                    ShowErrorAndRedirect("No book ID provided.");
                }
            }
        }

        private void LoadBookDetails(int bookId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT b.Title, b.Author, b.ISBN, 
                               COALESCE(p.FullPath, c.CategoryName) as CategoryPath
                               FROM Books b
                               INNER JOIN Categories c ON b.CategoryID = c.CategoryID
                               LEFT JOIN (
                                   SELECT c1.CategoryID,
                                          STUFF((
                                              SELECT ' > ' + c2.CategoryName
                                              FROM Categories c2
                                              WHERE c2.CategoryID IN (
                                                  SELECT c3.CategoryID
                                                  FROM Categories c3
                                                  WHERE c3.CategoryID = c1.ParentCategoryID
                                                  UNION ALL
                                                  SELECT c4.ParentCategoryID
                                                  FROM Categories c4
                                                  WHERE c4.CategoryID = c1.ParentCategoryID
                                                  AND c4.ParentCategoryID IS NOT NULL
                                              )
                                              ORDER BY c2.CategoryID
                                              FOR XML PATH('')
                                          ), 1, 3, '') + ' > ' + c1.CategoryName AS FullPath
                                   FROM Categories c1
                               ) p ON c.CategoryID = p.CategoryID
                               WHERE b.BookID = @BookID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTitle.Text = reader["Title"].ToString();
                            lblAuthor.Text = reader["Author"].ToString();
                            lblISBN.Text = reader["ISBN"].ToString();
                            lblCategory.Text = reader["CategoryPath"].ToString();
                        }
                        else
                        {
                            ShowErrorAndRedirect("Book not found.");
                        }
                    }
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["bookId"], out bookId))
            {
                string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "DELETE FROM Books WHERE BookID = @BookID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            Response.Redirect("BookList.aspx");
                        }
                        else
                        {
                            ShowErrorAndRedirect("Failed to delete the book.");
                        }
                    }
                }
            }
        }

        private void ShowErrorAndRedirect(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{message}'); window.location = 'BookList.aspx';", true);
        }
    }
}