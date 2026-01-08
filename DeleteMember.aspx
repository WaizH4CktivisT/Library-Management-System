<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DeleteMember.aspx.cs" Inherits="LMSPJ.DeleteMember" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
    <h2><i class="fas fa-trash-alt"></i> Delete Member</h2>
    <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>

    <div class="card mt-3 shadow">
      <div class="card-header bg-danger text-white">
        <h4>Confirm Deletion</h4>
      </div>
      <div class="card-body">
        <asp:Panel ID="pnlConfirmation" runat="server">
          <p>Are you sure you want to delete this member?</p>
          <p><strong>Member ID:</strong> <asp:Label ID="lblMemberID" runat="server"></asp:Label></p>
          <p><strong>Name:</strong> <asp:Label ID="lblFullName" runat="server"></asp:Label></p>
          <asp:Button ID="btnDelete" runat="server" Text="Yes, Delete" 
              CssClass="btn btn-danger"
              OnClick="btnDelete_Click"
              OnClientClick="return confirm('Are you absolutely sure you want to delete this member?');" />
          <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
              CssClass="btn btn-secondary ms-2"
              OnClick="btnCancel_Click" />
        </asp:Panel>
      </div>
    </div>
  </div>

</asp:Content>
