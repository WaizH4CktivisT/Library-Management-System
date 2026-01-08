<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditMember.aspx.cs" Inherits="LMSPJ.EditMember" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
    <h2><i class="fas fa-edit"></i> Edit Member</h2>
    <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>

    <div class="card mt-3 shadow">
      <div class="card-header bg-warning">
        <h4 class="text-dark">Member Information</h4>
      </div>
      <div class="card-body">
        <div class="mb-3">
          <label class="form-label">Member ID (Read Only)</label>
          <asp:Label ID="lblMemberID" runat="server" CssClass="form-control"></asp:Label>
        </div>

        <div class="mb-3">
          <label class="form-label">Full Name</label>
          <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-3">
          <label class="form-label">Email</label>
          <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-3">
          <label class="form-label">Phone</label>
          <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-3">
          <label class="form-label">Address</label>
          <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-3">
          <label class="form-label">Member Since (Read Only)</label>
          <asp:Label ID="lblMembershipDate" runat="server" CssClass="form-control"></asp:Label>
        </div>

        <asp:Button ID="btnSave" runat="server" Text="Save Changes" 
            CssClass="btn btn-primary"
            OnClick="btnSave_Click"
            OnClientClick="return confirm('Are you sure you want to save these changes?');" />

        <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
            CssClass="btn btn-secondary ms-2"
            OnClick="btnCancel_Click" />
      </div>
    </div>
  </div>
</asp:Content>
