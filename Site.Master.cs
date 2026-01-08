using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace LibraryManagementSystem
{
    public partial class Site : System.Web.UI.MasterPage
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    string username = Session["Username"].ToString();
                    LoadUserProfile(username);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadUserProfile(string username)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FullName, Email FROM Admin WHERE Username = @Username";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblUserFullName.Text = reader["FullName"].ToString();
                            txtFullName.Text = reader["FullName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            try
            {
                string username = Session["Username"].ToString();
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Admin SET FullName = @FullName, Email = @Email WHERE Username = @Username";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblUserFullName.Text = txtFullName.Text.Trim();
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateSuccess",
                    "alert('Profile updated successfully.'); $('#editProfileModal').modal('hide');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateError",
                    $"alert('Error updating profile: {ex.Message}');", true);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtNewPassword.Text != txtConfirmPassword.Text)
                {
                    throw new Exception("New passwords do not match!");
                }

                string username = Session["Username"].ToString();
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string verifyQuery = "SELECT COUNT(*) FROM Admin WHERE Username = @Username AND Password = @CurrentPassword";
                    using (SqlCommand cmd = new SqlCommand(verifyQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@CurrentPassword", txtCurrentPassword.Text);

                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        if (count == 0)
                        {
                            throw new Exception("Current password is incorrect!");
                        }

                        string updateQuery = "UPDATE Admin SET Password = @NewPassword WHERE Username = @Username";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@Username", username);
                            updateCmd.Parameters.AddWithValue("@NewPassword", txtNewPassword.Text);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "PasswordSuccess",
                    "alert('Password changed successfully.'); $('#changePasswordModal').modal('hide');", true);

                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "PasswordError",
                    $"alert('Error changing password: {ex.Message}');", true);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

    }
}
