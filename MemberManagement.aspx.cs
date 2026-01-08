using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZXing;

namespace LibraryManagementSystem
{
    public partial class MemberManagement : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMemberList();
                
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string memberId = GenerateMemberId();

            // Insert new member into the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Members (MemberID,FullName, Email, Phone, Address) VALUES (@MemberID, @FullName, @Email, @Phone, @Address)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Address", address);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Send the member card email with a unique QR code
            string qrCodeData = $"{memberId}|{fullName}|{email}|{phone}";
            string qrCodeImagePath = GenerateQRCode(qrCodeData);
            SendMemberCardEmail(fullName,phone,address, email, qrCodeImagePath,memberId);

            lblMessage.CssClass = "text-success";
            lblMessage.Text = "Member successfully registered! A member card has been sent to the provided email.";
        }
        private string GenerateMemberId()
        {
            return "LIB" + DateTime.Now.ToString("yyMMdd") + new Random().Next(1000, 9999).ToString();
        }
        private string GenerateQRCode(string data)
        {
            BarcodeWriter barcodeWriter = new BarcodeWriter();
            barcodeWriter.Format = BarcodeFormat.QR_CODE;
            var qrCodeBitmap = barcodeWriter.Write(data);

            string filePath = Server.MapPath("~/QRCodeImages/") + Guid.NewGuid().ToString() + ".png";
            qrCodeBitmap.Save(filePath);
            return filePath;
        }

        private void SendMemberCardEmail(string fullName,string phone,string address, string email, string qrCodeImagePath, string memberId)
        {
            string subject = "Your Library Member Card";
            string body = $@"
            <h2>Your Library Member Card</h2>
            <p><strong>Member ID:</strong> {memberId}</p>
            <p><strong>Name:</strong> {fullName}</p>
            <p><strong>Email:</strong> {email}</p>
            <p><strong>Phone:</strong> {phone}</p>
            <p><strong>Address:</strong> {address}</p>
            <p>Your unique Member Card QR Code:</p>
            <img src='cid:QRCode' alt='QR Code' />

            <p>Thank you for being part of our library system!</p>
        ";

            var fromAddress = new MailAddress("waiphyoaung@ucspathein.edu.mm", "Library Admin");
            var toAddress = new MailAddress(email);
            string fromPassword = "Ttyy44@#";  // Use your SMTP2GO credentials or API key

            var smtp = new SmtpClient
            {
                Host = "mail.smtp2go.com",    // SMTP2GO host
                Port = 2525,                   // SMTP2GO port (587 for TLS, 465 for SSL)
                Credentials = new NetworkCredential("waiphyoaung4622", fromPassword),
                EnableSsl = true              // Make sure SSL is enabled
            };

            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            })
            {
                var inlineImage = new LinkedResource(qrCodeImagePath) { ContentId = "QRCode" };
                var alternateView = AlternateView.CreateAlternateViewFromString(body, null, "text/html");
                alternateView.LinkedResources.Add(inlineImage);
                message.AlternateViews.Add(alternateView);

                try
                {
                    smtp.Send(message);
                }
                catch (SmtpException smtpEx)
                {
                    Console.WriteLine("SMTP Error: " + smtpEx.Message);  // Log or handle the error appropriately
                }
            }
        }


        // ============================
        // Member List Section
        // ============================

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchQuery = txtSearch.Text.Trim();
            LoadMemberList(searchQuery);
        }

        private void LoadMemberList(string searchQuery = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query;
                if (string.IsNullOrEmpty(searchQuery))
                {
                    query = "SELECT MemberID, FullName, Email, Phone, Address, MembershipDate FROM Members ORDER BY MembershipDate DESC";
                }
                else
                {
                    query = "SELECT MemberID, FullName, Email, Phone, Address, MembershipDate FROM Members " +
                            "WHERE FullName LIKE @Search OR Email LIKE @Search OR Phone LIKE @Search OR Address LIKE @Search";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(searchQuery))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchQuery + "%");
                    }
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvMembers.DataSource = dt;
                    gvMembers.DataBind();
                }
            }
        }


        // ============================
        // Member Analysis Section
        // ============================
        


        protected Label lblTotalMembers;
        protected Label lblActiveMembers;
        protected GridView gvMembers;
        protected TextBox txtFullName;
        protected TextBox txtEmail;
        protected TextBox txtPhone;
        protected TextBox txtAddress;
        protected Label lblMessage;
    }
}