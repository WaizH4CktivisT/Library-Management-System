using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions; // Needed for regex validation

namespace LibraryManagementSystem
{
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Redirect if already logged in
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string username = txtUsername?.Text.Trim();
            string fullName = txtFullName?.Text.Trim();
            string email = txtEmail?.Text.Trim();
            string password = txtPassword?.Text.Trim();
            string confirmPassword = txtConfirmPassword?.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                lblMessage.Text = "All fields are required.";
                return;
            }

            // Check if passwords match
            if (password != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match.";
                return;
            }

            // Validate strong password policy
            if (!IsStrongPassword(password))
            {
                lblMessage.Text = "Password must be at least 8 characters long and include one uppercase letter, one lowercase letter, one digit, and one special character.";
                return;
            }

            string hashedPassword = HashPassword(password);
            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    // Check if the username already exists
                    string checkQuery = "SELECT COUNT(*) FROM Admin WHERE Username = @username";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@username", username);
                        con.Open();
                        int userExists = (int)checkCmd.ExecuteScalar();
                        con.Close();
                        if (userExists > 0)
                        {
                            lblMessage.Text = "Username already exists. Please choose a different username.";
                            return;
                        }
                    }

                    // Insert new admin record
                    string query = "INSERT INTO Admin (Username, PasswordHash, FullName, Email, CreatedDate) " +
                                   "VALUES (@username, @password, @fullName, @email, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", hashedPassword);
                        cmd.Parameters.AddWithValue("@fullName", fullName);
                        cmd.Parameters.AddWithValue("@email", email);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        if (result > 0)
                        {
                            // Make the notification panel visible
                            pnlNotification.Visible = true;

                            // Make the form invisible to ensure notification is seen
                            form1.Visible = false;

                            // Use JavaScript for more reliable redirect
                            ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                                "setTimeout(function(){ window.location.href = 'Login.aspx'; }, 3000);", true);

                            // As a fallback, also use the server-side redirect
                            Response.AddHeader("REFRESH", "3;URL=Login.aspx");
                        }
                        else
                        {
                            lblMessage.Text = "Error occurred during sign up. Please try again.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
            }
        }

        // Function to hash passwords using SHA256.
        private string HashPassword(string password)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        // Validate the strong password policy using Regex.
        private bool IsStrongPassword(string password)
        {
            // Regex pattern explanation:
            // ^                   : Start of string
            // (?=.*[a-z])         : At least one lowercase letter
            // (?=.*[A-Z])         : At least one uppercase letter
            // (?=.*\d)            : At least one digit
            // (?=.*[^\da-zA-Z])   : At least one special character (non-digit, non-letter)
            // .{8,}               : Minimum of 8 characters
            // $                   : End of string
            return Regex.IsMatch(password, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$");
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password);

            string cs = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT COUNT(*) FROM Admin WHERE Username = @username AND PasswordHash = @password";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@password", hashedPassword);
                    con.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    if (count > 0)
                    {
                        // Successful login, show notification and redirect to Dashboard
                        pnlNotification.Visible = true;
                        Response.AddHeader("REFRESH", "2;URL=Dashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password.";
                    }
                }
            }
        }
    }
}
