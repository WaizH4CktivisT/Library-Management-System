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
	public partial class DeleteMember : System.Web.UI.Page
	{
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string memberId = Request.QueryString["id"];
                if (string.IsNullOrEmpty(memberId))
                {
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
                    SELECT MemberID, FullName
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
                        lblFullName.Text = reader["FullName"].ToString();
                    }
                    else
                    {
                        // If no record found, redirect
                        Response.Redirect("MemberManagement.aspx");
                    }
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            // Confirm was pressed in JavaScript; proceed with deletion
            string memberId = lblMemberID.Text;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string deleteQuery = "DELETE FROM Members WHERE MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Show success message, hide confirmation panel
            lblMessage.CssClass = "text-success";
            lblMessage.Text = "Member has been successfully deleted.";
            pnlConfirmation.Visible = false;
            Response.Redirect("MemberManagement.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("MemberManagement.aspx");
        }

    }
}