using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net;

namespace LMSPJ
{
	public partial class TransactionManagement : System.Web.UI.Page
	{
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTransactionHistory();
                LoadPendingReturns();
                LoadFineRules();
                LoadOverdueTransactions();
                LoadFineRulesDropdown();
                LoadPaymentHistory();
            }
        }
        // Remove this line from the class-level declarations
        // private object ddlFineRule;

        private void LoadFineRulesDropdown()
        {
            if (ddlFineRule == null) return;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT RuleID, Description + ' (' + CAST(FinePerDay as varchar) + ' MMK per day)' as RuleDescription FROM FineRules WHERE IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ((DropDownList)ddlFineRule).DataSource = reader;
                            ((DropDownList)ddlFineRule).DataTextField = "RuleDescription";
                            ((DropDownList)ddlFineRule).DataValueField = "RuleID";
                            ((DropDownList)ddlFineRule).DataBind();
                            ((DropDownList)ddlFineRule).Items.Insert(0, new ListItem("Select Fine Rule", ""));
                        }
                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            $"alert('Error loading fine rules: {ex.Message}');", true);
                    }
                }
            }
        }
        private void LoadPaymentHistory(string memberId = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                p.PaymentID,
                m.FullName as MemberName,
                p.PaymentDate,
                p.Amount,
                p.PaymentType,
                t.TransactionID,
                b.Title as BookTitle
                
                    FROM Payments p
                    JOIN Members m ON p.MemberID = m.MemberID
                    LEFT JOIN Transactions t ON p.TransactionID = t.TransactionID
                    LEFT JOIN Books b ON t.BookID = b.BookID
                    WHERE (@MemberID = '' OR m.MemberID = @MemberID)
                    ORDER BY p.PaymentDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvPaymentHistory.DataSource = dt;
                        gvPaymentHistory.DataBind();
                    }
                }
            }
        }
        protected void btnSearchPayment_Click(object sender, EventArgs e)
        {
            string searchTerm = txtPaymentSearch.Text.Trim();
            LoadPaymentHistory(searchTerm);
        }

        protected void gvPaymentHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPaymentHistory.PageIndex = e.NewPageIndex;
            LoadPaymentHistory(txtPaymentSearch.Text.Trim());
        }


        private DataTable SelectedBooks
        {
            get
            {
                if (ViewState["SelectedBooks"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("BookID", typeof(int));
                    dt.Columns.Add("Title", typeof(string));
                    dt.Columns.Add("Author", typeof(string));
                    ViewState["SelectedBooks"] = dt;
                }
                return (DataTable)ViewState["SelectedBooks"];
            }
            set
            {
                ViewState["SelectedBooks"] = value;
            }
        }
        private void LoadFineRules()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT RuleID, BorrowPeriod, FinePerDay, Description, 
                CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END as Status 
                FROM FineRules 
                ORDER BY RuleID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvFineRules.DataSource = dt;
                        gvFineRules.DataBind();
                    }
                }
            }
        }

        protected void btnAddFineRule_Click(object sender, EventArgs e)
        {
            try
            {
                if ( string.IsNullOrEmpty(txtFinePerDay.Text))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('Please fill in all required fields.');", true);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO FineRules ( FinePerDay, Description, IsActive)
                    VALUES (@FinePerDay, @Description, 1)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        string description = !string.IsNullOrEmpty(txtRuleDescription.Text)
                            ? txtRuleDescription.Text
                            : $" {txtFinePerDay.Text} MMK per day fine";

                        //cmd.Parameters.AddWithValue("@BorrowPeriod", Convert.ToInt32(txtBorrowPeriod.Text));
                        cmd.Parameters.AddWithValue("@FinePerDay", Convert.ToDecimal(txtFinePerDay.Text));
                        cmd.Parameters.AddWithValue("@Description", description);

                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            // Clear form
                            //txtBorrowPeriod.Text = string.Empty;
                            txtFinePerDay.Text = string.Empty;
                            txtRuleDescription.Text = string.Empty;

                            // Reload grids
                            LoadFineRules();
                            LoadFineRulesDropdown();

                            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                "alert('Fine rule added successfully.');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                "alert('Failed to add fine rule.');", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        protected void gvFineRules_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                int ruleId = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE FineRules SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE RuleID = @RuleID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@RuleID", ruleId);
                        try
                        {
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            LoadFineRules();
                            LoadFineRulesDropdown();
                        }
                        catch (Exception ex)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                $"alert('Error: {ex.Message}');", true);
                        }
                    }
                }
            }
        }
        protected void btnSearchMember_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT MemberID, FullName, Email FROM Members WHERE MemberID = @Search OR FullName LIKE @SearchName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", txtMemberSearch.Text);
                    cmd.Parameters.AddWithValue("@SearchName", "%" + txtMemberSearch.Text + "%");

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            ViewState["SelectedMemberID"] = reader["MemberID"];
                            lblMemberInfo.Text = $"Name: {reader["FullName"]}<br/>Email: {reader["Email"]}";
                            pnlMemberInfo.Visible = true;
                        }
                        else
                        {
                            lblMemberInfo.Text = "No member found.";
                            pnlMemberInfo.Visible = true;
                            ViewState["SelectedMemberID"] = null;
                        }
                    }
                }
            }
        }

        protected void btnSearchBook_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT BookID, Title, Author, AvailableCopies 
                        FROM Books 
                        WHERE (ISNUMERIC(@Search) = 1 AND BookID = TRY_CONVERT(int, @Search))
                        OR (Title LIKE @SearchTitle)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    string searchText = txtBookSearch.Text.Trim();
                    cmd.Parameters.AddWithValue("@Search", searchText);
                    cmd.Parameters.AddWithValue("@SearchTitle", "%" + searchText + "%");

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            if (Convert.ToInt32(reader["AvailableCopies"]) > 0)
                            {
                                DataTable dt = SelectedBooks;
                                if (dt.Select($"BookID = {reader["BookID"]}").Length == 0)
                                {
                                    DataRow dr = dt.NewRow();
                                    dr["BookID"] = reader["BookID"];
                                    dr["Title"] = reader["Title"];
                                    dr["Author"] = reader["Author"];
                                    dt.Rows.Add(dr);
                                    SelectedBooks = dt;
                                    gvSelectedBooks.DataSource = dt;
                                    gvSelectedBooks.DataBind();
                                    lblBookInfo.Text = "Book added to selection.";
                                }
                                else
                                {
                                    lblBookInfo.Text = "This book is already selected.";
                                }
                            }
                            else
                            {
                                lblBookInfo.Text = "No copies available for this book.";
                            }
                        }
                        else
                        {
                            lblBookInfo.Text = "No book found.";
                        }
                        pnlBookInfo.Visible = true;
                    }
                }
            }
        }

        protected void btnRemoveBook_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int bookId = Convert.ToInt32(btn.CommandArgument);
            DataTable dt = SelectedBooks;
            dt.Select($"BookID = {bookId}").FirstOrDefault()?.Delete();
            dt.AcceptChanges();
            SelectedBooks = dt;
            gvSelectedBooks.DataSource = dt;
            gvSelectedBooks.DataBind();
        }

        protected void btnIssue_Click(object sender, EventArgs e)
        {
            if (ViewState["SelectedMemberID"] == null || SelectedBooks.Rows.Count == 0 || ddlFineRule.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Please select member, books, and fine rule.');", true);
                return;
            }
            DateTime dueDat;
            if (!DateTime.TryParse(txtDueDate.Text, out dueDat) || dueDat <= DateTime.Now)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Please enter a valid due date that is after today.');", true);
                return;
            }


            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        string memberEmail = "";
                        string memberName = "";
                        System.Text.StringBuilder bookTitles = new System.Text.StringBuilder();

                        // Get member details
                        string getMemberQuery = "SELECT Email, FullName FROM Members WHERE MemberID = @MemberID";
                        using (SqlCommand cmd = new SqlCommand(getMemberQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@MemberID", ViewState["SelectedMemberID"]);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    memberEmail = reader["Email"].ToString();
                                    memberName = reader["FullName"].ToString();
                                }
                            }
                        }

                        DateTime issueDate = DateTime.Now;
                        DateTime dueDate = DateTime.Parse(txtDueDate.Text);
                        int fineRuleId = Convert.ToInt32(ddlFineRule.SelectedValue);

                        foreach (DataRow book in SelectedBooks.Rows)
                        {
                            // Check available copies
                            string checkQuery = "SELECT AvailableCopies FROM Books WHERE BookID = @BookID";
                            int availableCopies = 0;

                            using (SqlCommand cmd = new SqlCommand(checkQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@BookID", book["BookID"]);
                                availableCopies = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            if (availableCopies <= 0)
                            {
                                throw new Exception($"No copies available for book: {book["Title"]}");
                            }

                            // Update available copies
                            string updateBookQuery = @"UPDATE Books 
                        SET AvailableCopies = AvailableCopies - 1 
                        WHERE BookID = @BookID AND AvailableCopies > 0";

                            using (SqlCommand cmd = new SqlCommand(updateBookQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@BookID", book["BookID"]);
                                int rowsAffected = cmd.ExecuteNonQuery();
                                if (rowsAffected == 0)
                                {
                                    throw new Exception($"Book is no longer available: {book["Title"]}");
                                }
                            }

                            // Insert transaction record with FineRuleID
                            string insertQuery = @"INSERT INTO Transactions 
                        (BookID, MemberID, IssueDate, DueDate, Status, FineRuleID) 
                        VALUES (@BookID, @MemberID, @IssueDate, @DueDate, 'Issued', @FineRuleID)";

                            using (SqlCommand cmd = new SqlCommand(insertQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@BookID", book["BookID"]);
                                cmd.Parameters.AddWithValue("@MemberID", ViewState["SelectedMemberID"]);
                                cmd.Parameters.AddWithValue("@IssueDate", issueDate);
                                cmd.Parameters.AddWithValue("@DueDate", dueDate);
                                cmd.Parameters.AddWithValue("@FineRuleID", fineRuleId);
                                cmd.ExecuteNonQuery();
                            }

                            bookTitles.AppendLine(book["Title"].ToString());
                        }

                        transaction.Commit();

                        // Send email receipt
                        SendIssueReceipt(memberEmail, memberName, bookTitles.ToString(), issueDate, dueDate);

                        ClearIssueForm();
                        LoadTransactionHistory();
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "alert('Books issued successfully and receipt sent to member email.');", true);
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            $"alert('Error: {ex.Message}');", true);
                    }
                }
            }
        }






        private void SendIssueReceipt(string memberEmail, string memberName, string bookTitles,
            DateTime issueDate, DateTime dueDate)
        {
            string subject = "Library Book Issue Receipt";
            string body = $@"
                <h2>Book Issue Receipt</h2>
                <p><strong>Member Name:</strong> {memberName}</p>
                <p><strong>Books:</strong></p>
                <pre>{bookTitles}</pre>
                <p><strong>Issue Date:</strong> {issueDate:dd/MM/yyyy}</p>
                <p><strong>Due Date:</strong> {dueDate:dd/MM/yyyy}</p>
                <p><strong>Note:</strong> Please return the books by the due date to avoid fines.</p>
                <p>Thank you for using our library services!</p>";

            SendEmail(memberEmail, subject, body);
        }

        private void SendOverdueWarning(string email, string memberName, string bookTitle,
            DateTime dueDate, int daysOverdue)
        {
            string subject = "Library Book Overdue Notice";
            string body = $@"
                <h2>Overdue Book Notice</h2>
                <p>Dear {memberName},</p>
                <p>Our records show that you have an overdue book:</p>
                <p><strong>Book Title:</strong> {bookTitle}</p>
                <p><strong>Due Date:</strong> {dueDate:dd/MM/yyyy}</p>
                <p><strong>Days Overdue:</strong> {daysOverdue}</p>
                <p>Please return the book as soon as possible to avoid additional fines.</p>
                <p>Thank you for your cooperation.</p>";

            SendEmail(email, subject, body);
        }

        private void SendEmail(string toEmail, string subject, string body)
        {
            var fromAddress = new MailAddress("waiphyoaung@ucspathein.edu.mm", "Library Admin");
            var toAddress = new MailAddress(toEmail);
            string fromPassword = "Ttyy44@#";

            var smtp = new SmtpClient
            {
                Host = "mail.smtp2go.com",
                Port = 2525,
                Credentials = new NetworkCredential("waiphyoaung4622", fromPassword),
                EnableSsl = true
            };

            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            })
            {
                smtp.Send(message);
            }
        }

        protected void btnSearchTransaction_Click(object sender, EventArgs e)
        {
            string searchTerm = txtTransactionSearch.Text.Trim();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                        t.IssueDate, t.DueDate
                        FROM Transactions t
                        JOIN Books b ON t.BookID = b.BookID
                        JOIN Members m ON t.MemberID = m.MemberID
                        WHERE t.Status = 'Issued'
                        AND (CAST(t.TransactionID as NVARCHAR) LIKE @Search
                        OR b.Title LIKE @Search
                        OR m.FullName LIKE @Search)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvPendingReturns.DataSource = dt;
                        gvPendingReturns.DataBind();
                    }
                }
            }
        }

        protected void gvPendingReturns_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnBook")
            {
                try
                {
                    string commandArg = e.CommandArgument.ToString().Trim();

                    if (int.TryParse(commandArg, out int transactionId))
                    {
                        ProcessBookReturn(transactionId);
                    }
                    else
                    {
                        throw new Exception($"Invalid Transaction ID: '{commandArg}'");
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        $"alert('Error processing return: {ex.Message.Replace("'", "\\'")}');", true);
                }
            }
        }


        private void ProcessBookReturn(int transactionId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        int bookId = 0;
                        string memberId="";
                        decimal fineAmount = 0;
                        DateTime dueDate = DateTime.Now;
                        int daysOverdue = 0;

                        // Get transaction details
                        string getDetailsQuery = @"SELECT t.BookID, t.MemberID, t.DueDate, f.FinePerDay, b.Title, m.Email, m.FullName 
                                FROM Transactions t
                                JOIN FineRules f ON t.FineRuleID = f.RuleID
                                JOIN Books b ON t.BookID = b.BookID
                                JOIN Members m ON t.MemberID = m.MemberID
                                WHERE t.TransactionID = @TransactionID";

                        string memberEmail = "";
                        string memberName = "";
                        string bookTitle = "";

                        using (SqlCommand cmd = new SqlCommand(getDetailsQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    bookId = Convert.ToInt32(reader["BookID"]);
                                    memberId = reader["MemberID"].ToString();
                                    dueDate = Convert.ToDateTime(reader["DueDate"]);
                                    decimal finePerDay = Convert.ToDecimal(reader["FinePerDay"]);
                                    memberEmail = reader["Email"].ToString();
                                    memberName = reader["FullName"].ToString();
                                    bookTitle = reader["Title"].ToString();

                                    // Calculate overdue days and fine
                                    if (DateTime.Now > dueDate)
                                    {
                                        daysOverdue = (int)(DateTime.Now - dueDate).TotalDays;
                                        fineAmount = daysOverdue * finePerDay;
                                    }
                                }
                            }
                        }

                        // Update transaction status
                        string updateTransactionQuery = @"UPDATE Transactions 
                    SET ReturnDate = @ReturnDate, 
                        Status = 'Returned',
                        DaysOverdue = @DaysOverdue,
                        CalculatedFineAmount = @FineAmount 
                    WHERE TransactionID = @TransactionID";

                        using (SqlCommand cmd = new SqlCommand(updateTransactionQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                            cmd.Parameters.AddWithValue("@ReturnDate", DateTime.Now);
                            cmd.Parameters.AddWithValue("@DaysOverdue", daysOverdue);
                            cmd.Parameters.AddWithValue("@FineAmount", fineAmount);
                            cmd.ExecuteNonQuery();
                        }

                        // Update book availability
                        string updateBookQuery = "UPDATE Books SET AvailableCopies = AvailableCopies + 1 WHERE BookID = @BookID";
                        using (SqlCommand cmd = new SqlCommand(updateBookQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@BookID", bookId);
                            cmd.ExecuteNonQuery();
                        }

                        // Create payment record if fine exists
                        if (fineAmount > 0)
                        {
                            string insertPaymentQuery = @"INSERT INTO Payments 
                        (MemberID, TransactionID, PaymentDate, Amount, PaymentType, PaymentStatus)
                        VALUES (@MemberID, @TransactionID, @PaymentDate, @Amount, 'Fine', 'Pending')";

                            using (SqlCommand cmd = new SqlCommand(insertPaymentQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@MemberID", memberId);
                                cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                                cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                                cmd.Parameters.AddWithValue("@Amount", fineAmount);
                                cmd.ExecuteNonQuery();
                            }

                            // Send fine notification email
                            string subject = "Library Book Return - Fine Notice";
                            string body = $@"
                        <h2>Fine Notice</h2>
                        <p>Dear {memberName},</p>
                        <p>The following book has been returned with an overdue fine:</p>
                        <p><strong>Book:</strong> {bookTitle}</p>
                        <p><strong>Days Overdue:</strong> {daysOverdue}</p>
                        <p><strong>Fine Amount:</strong> {fineAmount:N2} MMK</p>
                        <p>Please settle the fine at your earliest convenience.</p>
                        <p>Thank you for using our library services.</p>";

                            SendEmail(memberEmail, subject, body);
                        }

                        transaction.Commit();

                        // Show return confirmation
                        string message = "Book returned successfully.";
                        if (daysOverdue > 0)
                        {
                            message += $"\nDays Overdue: {daysOverdue}\nFine Amount: {fineAmount:N2} MMK";
                        }

                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            $"alert('{message}');", true);

                        // Refresh relevant grids
                        LoadTransactionHistory();
                        LoadPendingReturns();
                        LoadOverdueTransactions();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            $"alert('Error processing return: {ex.Message}');", true);
                    }
                }
            }
        }

        private void LoadTransactionHistory(string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                           t.IssueDate, t.DueDate, t.ReturnDate, t.CalculatedFineAmount, t.Status
                    FROM Transactions t
                    JOIN Books b ON t.BookID = b.BookID
                    JOIN Members m ON t.MemberID = m.MemberID
                    WHERE (@Search = '' OR 
                          b.Title LIKE @Search OR 
                          m.FullName LIKE @Search OR
                          CAST(t.TransactionID as NVARCHAR) LIKE @Search)
                    AND (@Status = '' OR t.Status = @Status)
                    AND (@DateFrom IS NULL OR t.IssueDate >= @DateFrom)
                    AND (@DateTo IS NULL OR t.IssueDate <= @DateTo)
                    ORDER BY t.TransactionID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@DateFrom", string.IsNullOrEmpty(txtDateFrom.Text) ?
                        (object)DBNull.Value : DateTime.Parse(txtDateFrom.Text));
                    cmd.Parameters.AddWithValue("@DateTo", string.IsNullOrEmpty(txtDateTo.Text) ?
                        (object)DBNull.Value : DateTime.Parse(txtDateTo.Text));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvTransactionHistory.DataSource = dt;
                        gvTransactionHistory.DataBind();
                    }
                }
            }
        }

        private void LoadPendingReturns(string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                           t.IssueDate, t.DueDate
                    FROM Transactions t
                    JOIN Books b ON t.BookID = b.BookID
                    JOIN Members m ON t.MemberID = m.MemberID
                    WHERE t.Status = 'Issued'
                    AND (@Search = '' OR 
                         b.Title LIKE @Search OR 
                         m.FullName LIKE @Search OR
                         CAST(t.TransactionID as NVARCHAR) LIKE @Search)
                    ORDER BY t.DueDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvPendingReturns.DataSource = dt;
                        gvPendingReturns.DataBind();
                    }
                }
            }
        }

        private void LoadOverdueTransactions()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName, 
                           m.Email, t.DueDate, DATEDIFF(day, t.DueDate, GETDATE()) as DaysOverdue
                    FROM Transactions t
                    JOIN Books b ON t.BookID = b.BookID
                    JOIN Members m ON t.MemberID = m.MemberID
                    WHERE t.Status = 'Issued' 
                    AND t.DueDate < GETDATE()
                    ORDER BY t.DueDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvOverdueBooks.DataSource = dt;
                        gvOverdueBooks.DataBind();
                    }
                }
            }
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string searchTerm = txtHistorySearch.Text.Trim();
            string status = ddlStatus.SelectedValue;
            DateTime? dateFrom = !string.IsNullOrEmpty(txtDateFrom.Text) ?
                (DateTime?)DateTime.Parse(txtDateFrom.Text) : null;
            DateTime? dateTo = !string.IsNullOrEmpty(txtDateTo.Text) ?
                (DateTime?)DateTime.Parse(txtDateTo.Text) : null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                        t.IssueDate, t.DueDate, t.ReturnDate, t.CalculatedFineAmount, t.Status
                        FROM Transactions t
                        JOIN Books b ON t.BookID = b.BookID
                        JOIN Members m ON t.MemberID = m.MemberID
                        WHERE (@Search = '' OR b.Title LIKE @Search 
                            OR m.FullName LIKE @Search 
                            OR CAST(t.TransactionID as NVARCHAR) LIKE @Search)
                        AND (@Status = '' OR t.Status = @Status)
                        AND (@DateFrom IS NULL OR t.IssueDate >= @DateFrom)
                        AND (@DateTo IS NULL OR t.IssueDate <= @DateTo)
                        ORDER BY t.TransactionID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@DateFrom", dateFrom ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateTo", dateTo ?? (object)DBNull.Value);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvTransactionHistory.DataSource = dt;
                        gvTransactionHistory.DataBind();
                    }
                }
            }
        }

        protected void btnSendWarning_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int transactionId = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT m.Email, m.FullName, b.Title, t.DueDate, 
                           DATEDIFF(day, t.DueDate, GETDATE()) as DaysOverdue
                    FROM Transactions t
                    JOIN Members m ON t.MemberID = m.MemberID
                    JOIN Books b ON t.BookID = b.BookID
                    WHERE t.TransactionID = @TransactionID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            SendOverdueWarning(
                                reader["Email"].ToString(),
                                reader["FullName"].ToString(),
                                reader["Title"].ToString(),
                                Convert.ToDateTime(reader["DueDate"]),
                                Convert.ToInt32(reader["DaysOverdue"])
                            );
                        }
                    }
                }
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "alert('Overdue warning sent successfully.');", true);
        }

        

        protected void gvTransactionHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTransactionHistory.PageIndex = e.NewPageIndex;
            LoadTransactionHistory(txtHistorySearch.Text);
        }

        private void ClearIssueForm()
        {
            txtMemberSearch.Text = string.Empty;
            txtBookSearch.Text = string.Empty;
            txtDueDate.Text = string.Empty;
            pnlMemberInfo.Visible = false;
            pnlBookInfo.Visible = false;
            ViewState["SelectedMemberID"] = null;
            SelectedBooks.Clear();
            gvSelectedBooks.DataSource = null;
            gvSelectedBooks.DataBind();
        }

    }
}