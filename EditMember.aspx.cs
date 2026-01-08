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
	public partial class EditMember : System.Web.UI.Page
	{
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string memberId = Request.QueryString["id"];
                if (string.IsNullOrEmpty(memberId))
                {
                    // If no ID provided, go back to MemberManagement
                    Response.Redirect("MemberManagement.aspx");
                    return;
                }

                LoadMemberData(memberId);
            }
        }

        private void LoadMemberData(string memberId)
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
                    var reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblMemberID.Text = reader["MemberID"].ToString();
                        txtFullName.Text = reader["FullName"].ToString();
                        txtEmail.Text = reader["Email"].ToString();
                        txtPhone.Text = reader["Phone"].ToString();
                        txtAddress.Text = reader["Address"].ToString();
                        lblMembershipDate.Text = Convert.ToDateTime(reader["MembershipDate"]).ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        // If no matching member found, redirect or show error
                        Response.Redirect("MemberManagement.aspx");
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Confirm was pressed in JavaScript; proceed with saving
            string memberId = lblMemberID.Text;
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string updateQuery = @"
                    UPDATE Members
                    SET FullName = @FullName,
                        Email = @Email,
                        Phone = @Phone,
                        Address = @Address
                    WHERE MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Show success message
            lblMessage.CssClass = "text-success";
            lblMessage.Text = "Member information updated successfully!";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Simply redirect back to the Member Management page (or wherever you want)
            Response.Redirect("MemberManagement.aspx");
        }

    }
}