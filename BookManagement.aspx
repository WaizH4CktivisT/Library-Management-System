<%@ Page Title="Book Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookManagement.aspx.cs" Inherits="LibraryManagementSystem.BookManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .category-tree {
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid #ddd;
            padding: 10px;
            background: #f8f9fa;
        }
        .card-header {
            font-weight: bold;
            font-size: 1.2rem;
        }
    </style>

    <div class="container mt-4">
        <h2><i class="fa fa-book"></i> Book Management</h2>

        <!-- Tabs for Manual Entry and Excel Import -->
        <ul class="nav nav-tabs mt-3" id="bookTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="manual-tab" data-bs-toggle="tab" data-bs-target="#manual" type="button"
                        role="tab" aria-controls="manual" aria-selected="true">
                    <i class="fa fa-edit"></i> Add Manually
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="import-tab" data-bs-toggle="tab" data-bs-target="#import" type="button"
                        role="tab" aria-controls="import" aria-selected="false">
                    <i class="fa fa-file-import"></i> Import from Excel
                </button>
            </li>
        </ul>

        <div class="tab-content mt-3" id="bookTabsContent">
            <!-- Manual Entry Tab -->
            <div class="tab-pane fade show active" id="manual" role="tabpanel" aria-labelledby="manual-tab">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <i class="fa fa-plus"></i> Add a Book Manually
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <label>Book Title</label>
                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Author</label>
                                <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label>ISBN</label>
                                <asp:TextBox ID="txtISBN" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Publisher</label>
                                <asp:TextBox ID="txtPublisher" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label>Total Copies</label>
                                <asp:TextBox ID="txtCopies" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Category</label>
                                <div class="category-tree">
                                    <asp:TreeView ID="tvCategories" runat="server"></asp:TreeView>
                                </div>
                            </div>
                        </div>

                        <div class="mt-3">
                            <asp:Button ID="btnAddBook" runat="server" CssClass="btn btn-success" Text="Add Book"
                                        OnClick="btnAddBook_Click" />
                            <asp:Label ID="lblManualMessage" runat="server" CssClass="text-success ms-3"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Excel Import Tab -->
            <div class="tab-pane fade" id="import" role="tabpanel" aria-labelledby="import-tab">
                <div class="card shadow">
                    <div class="card-header bg-secondary text-white">
                        <i class="fa fa-file-import"></i> Import from Excel
                    </div>
                    <div class="card-body">
                        <p>Ensure your file follows the <a href="SampleBook.csv" download>correct format</a>.</p>
                        <asp:FileUpload ID="fileUploadExcel" runat="server" CssClass="form-control mb-3" />
                        <asp:Button ID="btnUploadExcel" runat="server" CssClass="btn btn-primary" Text="Upload & Import"
                                    OnClick="btnUploadExcel_Click" />
                        <asp:Label ID="lblImportMessage" runat="server" CssClass="text-danger mt-2"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add New Category Panel -->
        <div class="card mt-4 shadow">
            <div class="card-header bg-info text-white">
                <i class="fa fa-sitemap"></i> Add New Category
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <label>Parent Category (Optional)</label>
                        <asp:DropDownList ID="ddlParentCategory" runat="server" CssClass="form-select">
                            <asp:ListItem Text="None (Top-Level)" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <label>New Category Name</label>
                        <asp:TextBox ID="txtNewCategory" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="mt-3">
                    <asp:Button ID="btnAddCategory" runat="server" CssClass="btn btn-info" Text="Add Category"
                                OnClick="btnAddCategory_Click" />
                    <asp:Label ID="lblCategoryMessage" runat="server" CssClass="ms-3"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
