using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using OfficeOpenXml; // Requires EPPlus via NuGet

namespace LibraryManagementSystem
{
    public partial class BookManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadParentCategoryDropdown();
            }
        }

        // ========== CATEGORY UI ==========

        private void LoadCategories()
        {
            // Populate the TreeView
            tvCategories.Nodes.Clear();
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT CategoryID, CategoryName, ParentCategoryID FROM Categories";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    TreeNode root = new TreeNode("All Categories", "0");
                    BuildCategoryTree(dt, root, null); // null => top-level
                    tvCategories.Nodes.Add(root);
                    tvCategories.ExpandAll();
                }
            }
        }

        private void BuildCategoryTree(DataTable dt, TreeNode parentNode, int? parentId)
        {
            // parentId = null => top-level
            string filter = parentId == null ? "ParentCategoryID IS NULL" : "ParentCategoryID = " + parentId;
            DataRow[] rows = dt.Select(filter);
            foreach (DataRow row in rows)
            {
                TreeNode child = new TreeNode(row["CategoryName"].ToString(), row["CategoryID"].ToString());
                parentNode.ChildNodes.Add(child);
                BuildCategoryTree(dt, child, Convert.ToInt32(row["CategoryID"]));
            }
        }

        private void LoadParentCategoryDropdown()
        {
            // Populate the dropdown with all existing categories
            ddlParentCategory.Items.Clear();
            ddlParentCategory.Items.Add(new ListItem("None (Top-Level)", "0"));

            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        ddlParentCategory.Items.Add(new ListItem(
                            reader["CategoryName"].ToString(),
                            reader["CategoryID"].ToString()
                        ));
                    }
                }
            }
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            lblCategoryMessage.Text = "";
            string newCatName = txtNewCategory.Text.Trim();
            if (string.IsNullOrEmpty(newCatName))
            {
                lblCategoryMessage.CssClass = "text-danger";
                lblCategoryMessage.Text = "Please enter a category name.";
                return;
            }

            int parentId = int.Parse(ddlParentCategory.SelectedValue); // 0 => top-level

            try
            {
                string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert new category
                    string query = "INSERT INTO Categories (CategoryName, ParentCategoryID) " +
                                   "OUTPUT INSERTED.CategoryID VALUES (@Name, @ParentID)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", newCatName);
                        if (parentId == 0)
                            cmd.Parameters.AddWithValue("@ParentID", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@ParentID", parentId);

                        int newCatID = (int)cmd.ExecuteScalar();

                        lblCategoryMessage.CssClass = "text-success";
                        lblCategoryMessage.Text = $"Category '{newCatName}' added successfully!";
                    }
                }

                // Refresh both the TreeView and the dropdown
                LoadCategories();
                LoadParentCategoryDropdown();

                // Clear input
                txtNewCategory.Text = "";
                ddlParentCategory.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                lblCategoryMessage.CssClass = "text-danger";
                lblCategoryMessage.Text = "Error: " + ex.Message;
            }
        }

        // ========== MANUAL BOOK ADDITION ==========

        protected void btnAddBook_Click(object sender, EventArgs e)
        {
            try
            {
                string title = txtTitle.Text.Trim();
                string author = txtAuthor.Text.Trim();
                string isbn = txtISBN.Text.Trim();
                string publisher = txtPublisher.Text.Trim();
                int copies = int.Parse(txtCopies.Text.Trim());

                // Ensure user selected a valid node (not the "All Categories" root)
                if (tvCategories.SelectedNode == null || tvCategories.SelectedNode.Value == "0")
                {
                    lblManualMessage.CssClass = "text-danger";
                    lblManualMessage.Text = "Please select a valid category.";
                    return;
                }

                int categoryId = int.Parse(tvCategories.SelectedNode.Value);

                string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"INSERT INTO Books (Title, Author, ISBN, Publisher, 
                                     TotalCopies, AvailableCopies, CategoryID)
                                     VALUES (@Title, @Author, @ISBN, @Publisher, @Copies, @Copies, @CatID)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Author", author);
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@Publisher", publisher);
                        cmd.Parameters.AddWithValue("@Copies", copies);
                        cmd.Parameters.AddWithValue("@CatID", categoryId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblManualMessage.CssClass = "text-success";
                lblManualMessage.Text = "Book added successfully!";
            }
            catch (Exception ex)
            {
                lblManualMessage.CssClass = "text-danger";
                lblManualMessage.Text = "Error: " + ex.Message;
            }
        }

        // ========== EXCEL IMPORT ==========

        protected void btnUploadExcel_Click(object sender, EventArgs e)
        {
            lblImportMessage.Text = "";
            if (!fileUploadExcel.HasFile)
            {
                lblImportMessage.CssClass = "text-danger";
                lblImportMessage.Text = "Please select an Excel file to upload.";
                return;
            }

            try
            {
                using (ExcelPackage package = new ExcelPackage(fileUploadExcel.FileContent))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[0];
                    int rowCount = worksheet.Dimension.Rows;
                    // Row 1 => headers
                    for (int row = 2; row <= rowCount; row++)
                    {
                        string title = worksheet.Cells[row, 1].Text.Trim();
                        string author = worksheet.Cells[row, 2].Text.Trim();
                        string isbn = worksheet.Cells[row, 3].Text.Trim();
                        string categoryPath = worksheet.Cells[row, 4].Text.Trim(); // e.g. "Fiction > Classics"
                        string publisher = worksheet.Cells[row, 5].Text.Trim();
                        int copies = int.Parse(worksheet.Cells[row, 6].Text.Trim());

                        int categoryId = GetOrCreateCategory(categoryPath);
                        InsertBook(title, author, isbn, publisher, copies, categoryId);
                    }
                }

                lblImportMessage.CssClass = "text-success";
                lblImportMessage.Text = "Books imported successfully!";
               
                LoadCategories();
                LoadParentCategoryDropdown();
            }
            catch (Exception ex)
            {
                lblImportMessage.CssClass = "text-danger";
                lblImportMessage.Text = "Error: " + ex.Message;
            }
        }

        private int GetOrCreateCategory(string path)
        {
            
            string[] parts = path.Split('>');
            int? parentID = null;
            foreach (string rawPart in parts)
            {
                string catName = rawPart.Trim();
                parentID = GetOrInsertCategory(catName, parentID);
            }
            return parentID ?? 0;
        }

        private int GetOrInsertCategory(string catName, int? parentID)
        {
            int catId = 0;
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                
                string checkQuery = @"SELECT CategoryID FROM Categories 
                                      WHERE CategoryName = @Name
                                      AND ((ParentCategoryID IS NULL AND @ParentID IS NULL)
                                       OR (ParentCategoryID = @ParentID))";
                using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Name", catName);
                    if (parentID.HasValue)
                        cmd.Parameters.AddWithValue("@ParentID", parentID.Value);
                    else
                        cmd.Parameters.AddWithValue("@ParentID", DBNull.Value);

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                        catId = (int)result;
                }

                // If not found, insert
                if (catId == 0)
                {
                    string insertQuery = @"INSERT INTO Categories (CategoryName, ParentCategoryID)
                                           OUTPUT INSERTED.CategoryID
                                           VALUES (@Name, @ParentID)";
                    using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", catName);
                        if (parentID.HasValue)
                            cmd.Parameters.AddWithValue("@ParentID", parentID.Value);
                        else
                            cmd.Parameters.AddWithValue("@ParentID", DBNull.Value);

                        catId = (int)cmd.ExecuteScalar();
                    }
                }
            }
            return catId;
        }

        private void InsertBook(string title, string author, string isbn, string publisher, int copies, int categoryId)
        {
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"INSERT INTO Books (Title, Author, ISBN, Publisher, 
                                 TotalCopies, AvailableCopies, CategoryID)
                                 VALUES (@Title, @Author, @ISBN, @Publisher, @Copies, @Copies, @CatID)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Author", author);
                    cmd.Parameters.AddWithValue("@ISBN", isbn);
                    cmd.Parameters.AddWithValue("@Publisher", publisher);
                    cmd.Parameters.AddWithValue("@Copies", copies);
                    cmd.Parameters.AddWithValue("@CatID", categoryId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
