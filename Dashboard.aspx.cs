using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LibraryManagementSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    lblUserName.Text = Session["Username"].ToString();
                    LoadDashboardData();
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadDashboardData()
        {
            LoadStatistics();
            LoadRecentActivities();
            LoadDueToday();
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    conn.Open();

                    // Total Books
                    cmd.CommandText = "SELECT COUNT(*) FROM Books";
                    lblTotalBooks.Text = cmd.ExecuteScalar().ToString();

                    // Active Members (members who have transactions in the last 6 months)
                    cmd.CommandText = @"
                SELECT COUNT(DISTINCT m.MemberID) 
                FROM Members m
                LEFT JOIN Transactions t ON m.MemberID = t.MemberID
                WHERE t.IssueDate >= DATEADD(MONTH, -6, GETDATE())
                OR m.MembershipDate >= DATEADD(MONTH, -6, GETDATE())";
                    lblActiveMembers.Text = cmd.ExecuteScalar().ToString();

                    // Due Today
                    cmd.CommandText = "SELECT COUNT(*) FROM Transactions WHERE DueDate = CAST(GETDATE() AS DATE)";
                    lblDueToday.Text = cmd.ExecuteScalar().ToString();

                    // Overdue Books
                    cmd.CommandText = "SELECT COUNT(*) FROM Transactions WHERE DueDate < CAST(GETDATE() AS DATE)";
                    lblOverdueBooks.Text = cmd.ExecuteScalar().ToString();
                }
            }
        }

        private void LoadRecentActivities()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 10 
                        t.IssueDate as ActivityDate,
                        t.Status as ActivityType,
                        CONCAT(m.FullName, ' ', 
                            CASE t.Status 
                                WHEN 'Issue' THEN 'borrowed' 
                                WHEN 'Return' THEN 'returned' 
                            END,
                            ' ', b.Title) as Description
                    FROM Transactions t
                    JOIN Members m ON t.MemberID = m.MemberID
                    JOIN Books b ON t.BookID = b.BookID
                    ORDER BY t.IssueDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvRecentActivities.DataSource = dt;
                        gvRecentActivities.DataBind();
                    }
                }
            }
        }

        private void LoadDueToday()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT b.Title as BookTitle, m.FullName as MemberName
                    FROM Transactions t
                    JOIN Books b ON t.BookID = b.BookID
                    JOIN Members m ON t.MemberID = m.MemberID
                    where t.DueDate = CAST(GETDATE() AS DATE)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvDueToday.DataSource = dt;
                        gvDueToday.DataBind();
                    }
                }
            }
        }

        protected void btnIssueBook_Click(object sender, EventArgs e)
        {
            Response.Redirect("TransactionManagement.aspx");
        }

        protected void btnReturnBook_Click(object sender, EventArgs e)
        {
            Response.Redirect("TransactionManagement.aspx");
        }

        protected void btnAddMember_Click(object sender, EventArgs e)
        {
            Response.Redirect("MemberManagement.aspx");
        }

        protected void btnViewReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reports.aspx");
        }

    }
}
