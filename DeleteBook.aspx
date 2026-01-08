<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DeleteBook.aspx.cs" Inherits="LMSPJ.DeleteBook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <style>
        :root {
            --primary-color: #2563eb;
            --primary-light: #3b82f6;
            --primary-dark: #1d4ed8;
            --neutral-100: #f1f5f9;
            --neutral-200: #e2e8f0;
            --neutral-600: #475569;
            --neutral-700: #334155;
            --danger: #dc2626;
            --danger-dark: #b91c1c;
        }

        .container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .delete-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--neutral-200);
            overflow: hidden;
        }

        .card-header {
            background: var(--danger);
            padding: 1.5rem 2rem;
        }

        .header-title {
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-body {
            padding: 2rem;
        }

        .warning-message {
            text-align: center;
            margin-bottom: 2rem;
        }

        .warning-icon {
            font-size: 3rem;
            color: var(--danger);
            margin-bottom: 1rem;
        }

        .warning-text {
            font-size: 1.1rem;
            color: var(--neutral-700);
            margin-bottom: 0.5rem;
        }

        .book-details {
            background: var(--neutral-100);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-item {
            margin-bottom: 1rem;
        }

        .detail-item:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            font-size: 0.875rem;
            color: var(--neutral-600);
            margin-bottom: 0.25rem;
        }

        .detail-value {
            font-size: 1rem;
            color: var(--neutral-700);
            font-weight: 500;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 0.875rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            text-align: center;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: var(--danger-dark);
        }

        .btn-back {
            background: white;
            border: 1px solid var(--neutral-200);
            color: var(--neutral-700);
        }

        .btn-back:hover {
            background: var(--neutral-100);
            color: var(--primary-color);
        }

        @media (max-width: 640px) {
            .card-header {
                padding: 1.25rem;
            }

            .card-body {
                padding: 1.25rem;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>

    <div class="container">
        <div class="delete-card">
            <div class="card-header">
                <h4 class="header-title">
                    <i class="fas fa-trash-alt"></i>
                    Delete Book
                </h4>
            </div>
            <div class="card-body">
                <div class="warning-message">
                    <i class="fas fa-exclamation-triangle warning-icon"></i>
                    <p class="warning-text">Are you sure you want to delete this book?</p>
                    <p style="color: var(--neutral-600);">This action cannot be undone.</p>
                </div>

                <div class="book-details">
                    <div class="detail-item">
                        <div class="detail-label">Title</div>
                        <asp:Label ID="lblTitle" runat="server" CssClass="detail-value"></asp:Label>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Author</div>
                        <asp:Label ID="lblAuthor" runat="server" CssClass="detail-value"></asp:Label>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">ISBN</div>
                        <asp:Label ID="lblISBN" runat="server" CssClass="detail-value"></asp:Label>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Category</div>
                        <asp:Label ID="lblCategory" runat="server" CssClass="detail-value"></asp:Label>
                    </div>
                </div>

                <div class="button-group">
                    <asp:Button ID="btnDelete" runat="server" Text="Delete Book" 
                        CssClass="btn btn-danger" OnClick="btnDelete_Click" />
                    <a href="javascript:history.back()" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Cancel
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
