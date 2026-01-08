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
	public partial class EditBook : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                if (!string.IsNullOrEmpty(Request.QueryString["bookId"]))
                {
                    int bookId;
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

        private void LoadCategories()
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"WITH RecursiveCTE AS (
                            SELECT CategoryID, CategoryName, ParentCategoryID,
                                   CAST(CategoryName AS NVARCHAR(1000)) AS FullPath,
                                   1 as Level
                            FROM Categories
                            WHERE ParentCategoryID IS NULL
                            UNION ALL
                            SELECT c.CategoryID, c.CategoryName, c.ParentCategoryID,
                                   CAST(r.FullPath + ' > ' + c.CategoryName AS NVARCHAR(1000)),
                                   r.Level + 1
                            FROM Categories c
                            INNER JOIN RecursiveCTE r ON c.ParentCategoryID = r.CategoryID
                        )
                        SELECT CategoryID, FullPath as CategoryName
                        FROM RecursiveCTE
                        ORDER BY FullPath";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    ddlCategory.Items.Clear();
                    ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Category --", "0"));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(
                                reader["CategoryName"].ToString(),
                                reader["CategoryID"].ToString()
                            ));
                        }
                    }
                }
            }
        }

        private void LoadBookDetails(int bookId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT Title, Author, ISBN, Publisher, CategoryID, TotalCopies 
                               FROM Books WHERE BookID = @BookID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtTitle.Text = reader["Title"].ToString();
                            txtAuthor.Text = reader["Author"].ToString();
                            txtISBN.Text = reader["ISBN"].ToString();
                            txtPublisher.Text = reader["Publisher"].ToString();
                            ddlCategory.SelectedValue = reader["CategoryID"].ToString();
                            txtTotalCopies.Text = reader["TotalCopies"].ToString();
                        }
                        else
                        {
                            ShowErrorAndRedirect("Book not found.");
                        }
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int bookId = Convert.ToInt32(Request.QueryString["bookId"]);
                string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"UPDATE Books 
                                   SET Title = @Title, Author = @Author, ISBN = @ISBN, 
                                       Publisher = @Publisher, CategoryID = @CategoryID, 
                                       TotalCopies = @TotalCopies
                                   WHERE BookID = @BookID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookId);
                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Author", txtAuthor.Text.Trim());
                        cmd.Parameters.AddWithValue("@ISBN", txtISBN.Text.Trim());
                        cmd.Parameters.AddWithValue("@Publisher", txtPublisher.Text.Trim());
                        cmd.Parameters.AddWithValue("@CategoryID", Convert.ToInt32(ddlCategory.SelectedValue));
                        cmd.Parameters.AddWithValue("@TotalCopies", Convert.ToInt32(txtTotalCopies.Text));

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                Response.Redirect("BookList.aspx");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int bookId = Convert.ToInt32(Request.QueryString["bookId"]);
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "DELETE FROM Books WHERE BookID = @BookID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("BookList.aspx");
        }

        private void ShowErrorAndRedirect(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{message}'); window.location = 'BookList.aspx';", true);
        }

    }
}