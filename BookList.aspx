<%@ Page Title="Book List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookList.aspx.cs" Inherits="LibraryManagementSystem.BookList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary-color:  #2c3e50;
            --primary-light: #4895ef;
            --primary-dark: #3f37c9;
            --secondary-color: #2b2d42;
            --secondary-light: #8d99ae;
            --accent-success: #0cce6b;
            --accent-warning: #ffd166;
            --accent-danger: #ef476f;
            --neutral-100: #f8f9fa;
            --neutral-200: #e9ecef;
            --neutral-300: #dee2e6;
            --neutral-600: #6c757d;
            --neutral-700: #495057;
        }

        body {
            background-color: #f5f7ff;
            font-family: 'Inter', 'Segoe UI', Roboto, sans-serif;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
            position: relative;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .page-title i {
            color: var(--primary-color);
        }

        .page-description {
            color: var(--secondary-light);
            font-size: 1rem;
            max-width: 600px;
        }

        .search-container {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--neutral-200);
            position: relative;
            overflow: hidden;
        }

        .search-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
        }

        .search-box {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input-wrapper {
            flex: 2;
            min-width: 300px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 0.875rem 1rem 0.875rem 3rem;
            border: 1px solid var(--neutral-200);
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.2s ease;
            background: var(--neutral-100);
        }

        .search-input:focus {
            background: white;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
            outline: none;
        }

        .search-input-wrapper::before {
            content: '\f002';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--neutral-600);
            font-size: 1rem;
            pointer-events: none;
        }

        .search-button {
            position: absolute;
            right: 0.5rem;
            top: 50%;
            transform: translateY(-50%);
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .search-button:hover {
            background: var(--primary-dark);
            transform: translateY(-50%) scale(1.05);
        }

        .management-container {
            background: white;
            padding: 1.25rem 1.5rem;
            border-radius: 16px;
            margin-bottom: 2.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--neutral-200);
            position: relative;
        }

        .management-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-success), var(--primary-light));
        }

        .management-box {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            justify-content: space-between;
        }

        .export-section {
            flex: 1;
            min-width: 250px;
            display: flex;
            gap: 0.75rem;
        }

        .category-select {
            flex: 1;
            padding: 0.875rem 1rem;
            border-radius: 12px;
            border: 1px solid var(--neutral-200);
            background-color: var(--neutral-100);
            font-size: 0.95rem;
            color: var(--neutral-700);
            transition: all 0.2s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        .category-select:focus {
            background: white;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
            outline: none;
        }

        .btn-export {
            padding: 0.875rem 1.25rem;
            border-radius: 12px;
            background: var(--neutral-100);
            color: var(--neutral-700);
            border: 1px solid var(--neutral-200);
            font-weight: 500;
            transition: all 0.25s ease;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        .btn-export:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(67, 97, 238, 0.2);
        }

        .btn-add-book {
            padding: 0.875rem 1.5rem;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            font-weight: 600;
            transition: all 0.25s ease;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.25);
        }

        .btn-add-book:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-color) 100%);
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.3);
        }

        .category-section {
            margin-bottom: 3rem;
        }

        .category-card {
            background: white;
            border: 1px solid var(--neutral-200);
            border-radius: 16px;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
            position: relative;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            height: 100%;
        }

        .category-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, var(--primary-color), var(--primary-light));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .category-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-light);
            box-shadow: 0 12px 30px rgba(67, 97, 238, 0.15);
        }

        .category-card:hover::before {
            opacity: 1;
        }

        .category-card .card-body {
            padding: 2rem;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100%;
        }

        .category-icon {
            font-size: 2rem;
            color: white;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            padding: 1.25rem;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(67, 97, 238, 0.2);
        }

        .category-card:hover .category-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 30px rgba(67, 97, 238, 0.3);
        }

        .category-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .category-card:hover .category-title {
            color: var(--primary-color);
        }

        .btn-browse {
            background: var(--neutral-100);
            color: var(--neutral-700);
            border: 1px solid var(--neutral-200);
            border-radius: 12px;
            padding: 0.875rem 1.5rem;
            font-weight: 500;
            transition: all 0.25s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: auto;
        }

        .btn-browse:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(67, 97, 238, 0.2);
        }

        .book-card {
            background: white;
            border: 1px solid var(--neutral-200);
            border-radius: 16px;
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
            position: relative;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .book-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, var(--primary-color), var(--primary-light));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .book-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-light);
            box-shadow: 0 12px 30px rgba(67, 97, 238, 0.15);
        }

        .book-card:hover::before {
            opacity: 1;
        }

        .book-card .card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .book-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
            line-height: 1.4;
            transition: all 0.3s ease;
        }

        .book-card:hover .book-title {
            color: var(--primary-color);
        }

        .book-author {
            color: var(--secondary-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .book-category {
            display: inline-block;
            padding: 0.4rem 1rem;
            background: var(--neutral-100);
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            border: 1px solid var(--neutral-200);
            transition: all 0.3s ease;
        }

        .book-card:hover .book-category {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .action-buttons {
            margin-top: auto;
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            flex: 1;
            padding: 0.6rem;
            border-radius: 10px;
            border: none;
            font-size: 0.9rem;
            transition: all 0.25s ease;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .action-btn.btn-info {
            background: var(--primary-color);
            color: white;
        }

        .action-btn.btn-warning {
            background: var(--accent-warning);
            color: #212529;
        }

        .action-btn.btn-danger {
            background: var(--accent-danger);
            color: white;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            color: white;
        }

        .action-btn.btn-warning:hover {
            color: #212529;
        }

        .section-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
            padding-bottom: 0.75rem;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(to right, var(--primary-color), var(--primary-light));
            border-radius: 2px;
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .no-results-icon {
            font-size: 3rem;
            color: var(--neutral-300);
            margin-bottom: 1rem;
        }

        .no-results-text {
            font-size: 1.25rem;
            color: var(--neutral-600);
            margin-bottom: 1.5rem;
        }

        @media (max-width: 991px) {
            .container {
                padding: 1.5rem;
            }

            .page-title {
                font-size: 1.75rem;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .search-container, .management-container {
                padding: 1.25rem;
            }

            .search-box {
                flex-direction: column;
                gap: 1rem;
            }

            .search-input-wrapper,
            .export-section {
                width: 100%;
                min-width: 100%;
            }

            .management-box {
                flex-direction: column;
                gap: 1rem;
            }

            .management-box .export-section,
            .management-box .btn-add-book {
                width: 100%;
            }

            .btn-add-book {
                width: 100%;
                justify-content: center;
            }

            .action-buttons {
                flex-direction: column;
            }

            .section-title {
                font-size: 1.5rem;
            }
        }

        .empty-state {
            padding: 3rem;
            text-align: center;
            background: white;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .empty-state-icon {
            font-size: 4rem;
            color: var(--neutral-300);
            margin-bottom: 1.5rem;
        }

        .empty-state-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 1rem;
        }

        .empty-state-text {
            color: var(--neutral-600);
            margin-bottom: 2rem;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Animation for cards */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .book-card, .category-card {
            animation: fadeInUp 0.5s ease-out forwards;
        }

        .book-card:nth-child(2n), .category-card:nth-child(2n) {
            animation-delay: 0.1s;
        }

        .book-card:nth-child(3n), .category-card:nth-child(3n) {
            animation-delay: 0.2s;
        }

        .book-card:nth-child(4n), .category-card:nth-child(4n) {
            animation-delay: 0.3s;
        }
    </style>

    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-books"></i>Book Catalog</h1>
            <p class="page-description">Browse our collection, search for specific titles, or manage the library inventory</p>
        </div>

        <!-- Search Container -->
        <div class="search-container">
            <div class="search-box">
                <div class="search-input-wrapper">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
                        placeholder="Search by title, author, or ISBN..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" 
                        CssClass="search-button" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>

        <!-- Management Container -->
        <div class="management-container">
            <div class="management-box">
                <div class="export-section">
                    <asp:DropDownList ID="ddlExportCategory" runat="server" CssClass="category-select">
                        <asp:ListItem Text="-- Select Category --" Value="-1" />
                        <asp:ListItem Text="All Categories" Value="0" />
                    </asp:DropDownList>
                    <asp:LinkButton ID="btnExport" runat="server" CssClass="btn-export" OnClick="btnExport_Click">
                        <i class="fas fa-file-export"></i> Export
                    </asp:LinkButton>
                </div>
                <a href="BookManagement.aspx" class="btn-add-book">
                    <i class="fas fa-plus"></i> Add Book
                </a>
            </div>
        </div>

        <asp:Panel ID="pnlSearchResults" runat="server" Visible="false">
            <h2 class="section-title">Search Results</h2>
            
            <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-search empty-state-icon"></i>
                <h3 class="empty-state-title">No books found</h3>
                <p class="empty-state-text">We couldn't find any books matching your search criteria. Try using different keywords or browse by category.</p>
                <a href="BookList.aspx" class="btn-add-book">
                    <i class="fas fa-list"></i> View All Books
                </a>
            </asp:Panel>
            
            <div class="row g-4">
                <asp:Repeater ID="rptSearchResults" runat="server">
                    <ItemTemplate>
                        <div class="col-xl-3 col-lg-4 col-md-6">
                            <div class="book-card">
                                <div class="card-body">
                                    <h5 class="book-title"><%# Eval("Title") %></h5>
                                    <p class="book-author">by <%# Eval("Author") %></p>
                                    <span class="book-category"><%# Eval("CategoryName") %></span>
                                    <div class="action-buttons">
                                        <a href='BookDetails.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-info">
                                            <i class="fas fa-info-circle"></i> Details
                                        </a>
                                        <a href='EditBook.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-warning">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href='DeleteBook.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this book?');">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlCategories" runat="server" Visible="false" CssClass="category-section">
            <h2 class="section-title">Browse Categories</h2>
            <div class="row g-4">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <div class="col-xl-3 col-lg-4 col-md-6">
                            <div class="category-card">
                                <div class="card-body">
                                    <div class="category-icon">
                                        <i class="fas fa-book-open"></i>
                                    </div>
                                    <h3 class="category-title"><%# Eval("CategoryName") %></h3>
                                    <a href="BookList.aspx?catId=<%# Eval("CategoryID") %>" 
                                       class="btn-browse">
                                       <i class="fas fa-arrow-right"></i> Explore Books
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlCategoryBooks" runat="server" Visible="false">
            <h2 class="section-title">
                <asp:Label ID="lblCategoryName" runat="server"></asp:Label>
            </h2>
            
            <asp:Panel ID="pnlNoBooks" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-books empty-state-icon"></i>
                <h3 class="empty-state-title">No books in this category</h3>
                <p class="empty-state-text">There are currently no books in this category. Add a new book or browse other categories.</p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="BookList.aspx" class="btn-browse">
                        <i class="fas fa-list"></i> View All Categories
                    </a>
                    <a href="BookManagement.aspx" class="btn-add-book">
                        <i class="fas fa-plus"></i> Add Book
                    </a>
                </div>
            </asp:Panel>
            
            <div class="row g-4">
                <asp:Repeater ID="rptCategoryBooks" runat="server">
                    <ItemTemplate>
                        <div class="col-xl-3 col-lg-4 col-md-6">
                            <div class="book-card">
                                <div class="card-body">
                                    <h5 class="book-title"><%# Eval("Title") %></h5>
                                    <p class="book-author">by <%# Eval("Author") %></p>
                                    <span class="book-category"><%# Eval("CategoryName") %></span>
                                    <div class="action-buttons">
                                        <a href='BookDetails.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-info">
                                            <i class="fas fa-info-circle"></i> Details
                                        </a>
                                        <a href='EditBook.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-warning">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href='DeleteBook.aspx?bookId=<%# Eval("BookID") %>' 
                                           class="action-btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this book?');">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
    </div>
</asp:Content>