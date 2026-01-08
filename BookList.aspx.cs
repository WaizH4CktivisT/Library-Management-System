using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.Web.UI;

namespace LibraryManagementSystem
{
    public partial class BookList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadExportCategories();
                string searchQuery = Request.QueryString["q"];
                string catIdStr = Request.QueryString["catId"];

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    pnlSearchResults.Visible = true;
                    pnlCategories.Visible = false;
                    pnlCategoryBooks.Visible = false;
                    LoadSearchResults(searchQuery);
                }
                else if (!string.IsNullOrEmpty(catIdStr))
                {
                    pnlSearchResults.Visible = false;
                    pnlCategories.Visible = false;
                    pnlCategoryBooks.Visible = true;
                    if (int.TryParse(catIdStr, out int catId))
                    {
                        LoadCategoryBooks(catId);
                    }
                    else
                    {
                        lblCategoryName.Text = "Invalid category ID";
                    }
                }
                else
                {
                    pnlSearchResults.Visible = false;
                    pnlCategories.Visible = true;
                    pnlCategoryBooks.Visible = false;
                    LoadMainCategories();
                }
            }
        }

        private void LoadExportCategories()
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
                    ddlExportCategory.Items.Clear();
                    ddlExportCategory.Items.Add(new ListItem("-- Select Category --", "-1"));
                    ddlExportCategory.Items.Add(new ListItem("All Categories", "0"));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlExportCategory.Items.Add(new ListItem(
                                reader["CategoryName"].ToString(),
                                reader["CategoryID"].ToString()
                            ));
                        }
                    }
                }
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)

        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            if (ddlExportCategory.SelectedValue == "-1")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Please select a category before exporting.');", true);
                return;
            }

            int categoryId = Convert.ToInt32(ddlExportCategory.SelectedValue);

            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query;
                if (categoryId == 0)
                {
                    // Query for All Categories without using @CategoryID parameter
                    query = @"SELECT b.Title, b.Author, b.ISBN, b.Publisher, 
                           b.TotalCopies, b.AvailableCopies, b.AddedDate,
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
                    ORDER BY CategoryPath, b.Title";
                }
                else
                {
                    // Query for specific category using @CategoryID parameter
                    query = @"WITH RecursiveCategories AS (
                        SELECT CategoryID FROM Categories 
                        WHERE CategoryID = @CategoryID
                        UNION ALL
                        SELECT c.CategoryID FROM Categories c
                        INNER JOIN RecursiveCategories rc ON c.ParentCategoryID = rc.CategoryID
                    )
                    SELECT b.Title, b.Author, b.ISBN, b.Publisher, 
                           b.TotalCopies, b.AvailableCopies, b.AddedDate,
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
                    WHERE b.CategoryID IN (SELECT CategoryID FROM RecursiveCategories)
                    ORDER BY CategoryPath, b.Title";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (categoryId != 0)
                        cmd.Parameters.AddWithValue("@CategoryID", categoryId);

                    DataTable dt = new DataTable();
                    con.Open();
                    dt.Load(cmd.ExecuteReader());

                    if (dt.Rows.Count == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "alert('No books found in the selected category.');", true);
                        return;
                    }

                    using (ExcelPackage package = new ExcelPackage())
                    {
                        ExcelWorksheet worksheet = package.Workbook.Worksheets.Add("Books");

                        string[] headers = new string[] {
                            "Title", "Author", "ISBN", "Publisher", "Category",
                            "Total Copies", "Available Copies", "Added Date"
                        };

                        for (int i = 0; i < headers.Length; i++)
                        {
                            worksheet.Cells[1, i + 1].Value = headers[i];
                        }

                        using (var range = worksheet.Cells[1, 1, 1, headers.Length])
                        {
                            range.Style.Font.Bold = true;
                            range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));
                            range.Style.Font.Color.SetColor(Color.White);
                            range.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        }

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            worksheet.Cells[i + 2, 1].Value = dt.Rows[i]["Title"];
                            worksheet.Cells[i + 2, 2].Value = dt.Rows[i]["Author"];
                            worksheet.Cells[i + 2, 3].Value = dt.Rows[i]["ISBN"];
                            worksheet.Cells[i + 2, 4].Value = dt.Rows[i]["Publisher"];
                            worksheet.Cells[i + 2, 5].Value = dt.Rows[i]["CategoryPath"];
                            worksheet.Cells[i + 2, 6].Value = dt.Rows[i]["TotalCopies"];
                            worksheet.Cells[i + 2, 7].Value = dt.Rows[i]["AvailableCopies"];
                            worksheet.Cells[i + 2, 8].Value = Convert.ToDateTime(dt.Rows[i]["AddedDate"]).ToString("yyyy-MM-dd");

                            if (i % 2 == 1)
                            {
                                using (var range = worksheet.Cells[i + 2, 1, i + 2, headers.Length])
                                {
                                    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                    range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(242, 242, 242));
                                }
                            }
                        }

                        worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

                        string fileName = categoryId == 0 ? "AllBooks.xlsx" :
                            $"Books_{ddlExportCategory.SelectedItem.Text.Replace(" > ", "_")}.xlsx";

                        Response.Clear();
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                        Response.AddHeader("content-disposition", $"attachment;filename={fileName}");
                        Response.BinaryWrite(package.GetAsByteArray());
                        Response.End();
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim();
            Response.Redirect("BookList.aspx?q=" + Server.UrlEncode(keyword));
        }

        private void LoadSearchResults(string keyword)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
SELECT b.BookID, b.Title, b.Author, c.CategoryName
FROM Books b
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE b.Title LIKE @keyword OR b.Author LIKE @keyword";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptSearchResults.DataSource = dt;
                    rptSearchResults.DataBind();
                }
            }
        }

        private void LoadMainCategories()
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
SELECT CategoryID, CategoryName
FROM Categories
WHERE ParentCategoryID IS NULL
ORDER BY CategoryName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
            }
        }

        private void LoadCategoryBooks(int catId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string queryCat = "SELECT CategoryName FROM Categories WHERE CategoryID = @catId";
                using (SqlCommand cmd = new SqlCommand(queryCat, con))
                {
                    cmd.Parameters.AddWithValue("@catId", catId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    lblCategoryName.Text = (result != null) ? result.ToString() : "Unknown Category";
                    con.Close();
                }
            }

            DataTable dtBooks = new DataTable();
            using (SqlConnection con = new SqlConnection(cs))
            {
                string queryBooks = @"
WITH DescendantCategories AS (
    SELECT CategoryID FROM Categories WHERE CategoryID = @catId
    UNION ALL
    SELECT c.CategoryID
    FROM Categories c
    INNER JOIN DescendantCategories dc ON c.ParentCategoryID = dc.CategoryID
)
SELECT b.BookID, b.Title, b.Author, c.CategoryName
FROM Books b
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE b.CategoryID IN (SELECT CategoryID FROM DescendantCategories)
ORDER BY b.Title;";

                using (SqlCommand cmd = new SqlCommand(queryBooks, con))
                {
                    cmd.Parameters.AddWithValue("@catId", catId);
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtBooks);
                    con.Close();
                }
            }

            lblCategoryName.Text += $" ({dtBooks.Rows.Count} books found)";
            rptCategoryBooks.DataSource = dtBooks;
            rptCategoryBooks.DataBind();
        }
    }
}