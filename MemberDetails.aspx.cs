using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMSPJ
{
	public partial class MemberDetails : System.Web.UI.Page
	{
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the MemberID from query string
                string memberId = Request.QueryString["id"];
                if (string.IsNullOrEmpty(memberId))
                {
                    // If no MemberID is provided, redirect back
                    Response.Redirect("MemberManagement.aspx");
                    return;
                }

                // Load all data for this member
                LoadMemberDetails(memberId);
                LoadTransactionHistory(memberId);
                LoadTransactionSummary(memberId);
            }
        }

        // 1) Load the member's personal info from Members table
        private void LoadMemberDetails(string memberId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT MemberID, FullName, Email, Phone, Address, MembershipDate
                    FROM Members
                    WHERE MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblMemberID.Text = reader["MemberID"].ToString();
                        lblFullName.Text = reader["FullName"].ToString();
                        lblEmail.Text = reader["Email"].ToString();
                        lblPhone.Text = reader["Phone"].ToString();
                        lblAddress.Text = reader["Address"].ToString();

                        DateTime membershipDate = Convert.ToDateTime(reader["MembershipDate"]);
                        lblMembershipDate.Text = membershipDate.ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        // If no record found, redirect or handle error
                        Response.Redirect("MemberManagement.aspx");
                    }
                }
            }
        }

        // 2) Load transaction history by joining Transactions and Books
        private void LoadTransactionHistory(string memberId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT t.TransactionID,
                           b.Title AS BookTitle,
                           t.IssueDate,
                           t.DueDate,
                           t.ReturnDate,
                           t.FineAmount,
                           t.Status
                    FROM Transactions t
                    JOIN Books b ON t.BookID = b.BookID
                    WHERE t.MemberID = @MemberID
                    ORDER BY t.IssueDate DESC
                ";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvTransactionHistory.DataSource = dt;
                    gvTransactionHistory.DataBind();
                }
            }
        }

        // 3) Load transaction summary (total, active, overdue)
        private void LoadTransactionSummary(string memberId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // (a) Total transactions
                string totalQuery = "SELECT COUNT(*) FROM Transactions WHERE MemberID = @MemberID";
                int totalTransactions = 0;
                using (SqlCommand cmd = new SqlCommand(totalQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    totalTransactions = (int)cmd.ExecuteScalar();
                }

                // (b) Active transactions (not returned yet)
                string activeQuery = @"
                    SELECT COUNT(*)
                    FROM Transactions
                    WHERE MemberID = @MemberID
                      AND ReturnDate IS NULL";
                int activeTransactions = 0;
                using (SqlCommand cmd = new SqlCommand(activeQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    activeTransactions = (int)cmd.ExecuteScalar();
                }

                // (c) Overdue transactions (ReturnDate IS NULL, DueDate < today)
                string overdueQuery = @"
                    SELECT COUNT(*)
                    FROM Transactions
                    WHERE MemberID = @MemberID
                      AND ReturnDate IS NULL
                      AND DueDate < GETDATE()";
                int overdueTransactions = 0;
                using (SqlCommand cmd = new SqlCommand(overdueQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    overdueTransactions = (int)cmd.ExecuteScalar();
                }

                // Display in labels
                lblTotalTransactions.Text = totalTransactions.ToString();
                lblActiveTransactions.Text = activeTransactions.ToString();
                lblOverdueTransactions.Text = overdueTransactions.ToString();
            }
        }


    }
}