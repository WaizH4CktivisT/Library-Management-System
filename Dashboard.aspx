<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LibraryManagementSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #4895ef;
            --secondary: #3f37c9;
            --success: #0cce6b;
            --danger: #ef476f;
            --warning: #ffd166;
            --info: #4cc9f0;
            --dark: #2b2d42;
            --gray: #8d99ae;
            --light: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.08);
            --shadow-sm: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.05);
            --shadow-lg: 0 1rem 3rem rgba(0, 0, 0, 0.1);
            --border-radius: 0.75rem;
            --transition: all 0.25s ease-in-out;
        }

        body {
            background-color: #f5f7ff;
            font-family: 'Inter', 'Segoe UI', Roboto, sans-serif;
        }

        .dashboard-container {
            padding: 1.5rem;
        }

        .card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            transition: var(--transition);
            overflow: hidden;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-3px);
        }

        .card-header {
            background-color: var(--white);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            padding: 1.25rem 1.5rem;
        }

        .card-header h5 {
            font-weight: 600;
            font-size: 1.1rem;
            margin: 0;
            color: var(--dark);
        }

        .card-body {
            padding: 1.5rem;
        }

        .welcome-section {
            position: relative;
            margin-bottom: 1.75rem;
        }

        .welcome-card {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border-radius: var(--border-radius);
            padding: 2.25rem;
            color: var(--white);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .welcome-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            transform: translate(30%, -30%);
            z-index: -1;
        }

        .welcome-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            transform: translate(-30%, 30%);
            z-index: -1;
        }

        .display-4 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            font-size: 2.5rem;
        }

        .lead {
            font-weight: 400;
            opacity: 0.9;
        }

        .stats-card .card-body {
            padding: 1.25rem;
        }

        .icon-shape {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            border-radius: 0.75rem;
            padding: 12px;
            font-size: 1rem;
            box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.1);
        }

        .bg-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%) !important;
        }

        .bg-success {
            background: linear-gradient(135deg, #06d6a0 0%, var(--success) 100%) !important;
        }

        .bg-warning {
            background: linear-gradient(135deg, #ffd166 0%, #fda403 100%) !important;
        }

        .bg-danger {
            background: linear-gradient(135deg, #ff5e7e 0%, var(--danger) 100%) !important;
        }

        .text-capitalize {
            text-transform: capitalize;
        }

        .font-weight-bold {
            font-weight: 600 !important;
        }

        .text-sm {
            font-size: 0.875rem;
            color: var(--gray);
        }

        .btn {
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .btn-primary {
            background: var(--primary);
            border-color: var(--primary);
        }

        .btn-success {
            background: var(--success);
            border-color: var(--success);
        }

        .btn-info {
            background: var(--info);
            border-color: var(--info);
        }

        .btn-warning {
            background: var(--warning);
            border-color: var(--warning);
            color: #212529;
        }

        .btn i {
            font-size: 0.9rem;
        }

        .quick-actions .btn {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            text-align: center;
            flex-direction: column;
            gap: 0.5rem;
        }

        .quick-actions .btn i {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }

        .table {
            margin-bottom: 0;
        }

        .table td, .table th {
            padding: 1rem 1.25rem;
            vertical-align: middle;
            border-color: rgba(0, 0, 0, 0.05);
        }

        .table thead th {
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            font-weight: 600;
            color: var(--dark);
        }

        .table-hover tbody tr:hover {
            background-color: rgba(0, 0, 0, 0.02);
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .quick-actions .btn {
                margin-bottom: 1rem;
            }
        }
    </style>

    <div class="dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-card">
                <h1 class="display-4">Welcome, <asp:Label ID="lblUserName" runat="server" /></h1>
                <p class="lead">Here's your library overview for today</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="icon-shape bg-primary text-white">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="ms-3">
                                <p class="text-sm mb-1 text-capitalize font-weight-bold">Total Books</p>
                                <h3 class="mb-0 font-weight-bold"><asp:Label ID="lblTotalBooks" runat="server" /></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="icon-shape bg-success text-white">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="ms-3">
                                <p class="text-sm mb-1 text-capitalize font-weight-bold">Active Members</p>
                                <h3 class="mb-0 font-weight-bold"><asp:Label ID="lblActiveMembers" runat="server" /></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="icon-shape bg-warning text-white">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="ms-3">
                                <p class="text-sm mb-1 text-capitalize font-weight-bold">Due Today</p>
                                <h3 class="mb-0 font-weight-bold"><asp:Label ID="lblDueToday" runat="server" /></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="icon-shape bg-danger text-white">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="ms-3">
                                <p class="text-sm mb-1 text-capitalize font-weight-bold">Overdue Books</p>
                                <h3 class="mb-0 font-weight-bold"><asp:Label ID="lblOverdueBooks" runat="server" /></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3 quick-actions">
                            <div class="col-lg-3 col-md-6">
                                <asp:LinkButton ID="btnIssueBook" runat="server" CssClass="btn btn-primary w-100" OnClick="btnIssueBook_Click">
                                    <i class="fas fa-book-reader"></i>
                                    Issue Book
                                </asp:LinkButton>
                            </div>
                            <div class="col-lg-3 col-md-6">
                                <asp:LinkButton ID="btnReturnBook" runat="server" CssClass="btn btn-success w-100" OnClick="btnReturnBook_Click">
                                    <i class="fas fa-undo"></i>
                                    Return Book
                                </asp:LinkButton>
                            </div>
                            <div class="col-lg-3 col-md-6">
                                <asp:LinkButton ID="btnAddMember" runat="server" CssClass="btn btn-info w-100" OnClick="btnAddMember_Click">
                                    <i class="fas fa-user-plus"></i>
                                    Add Member
                                </asp:LinkButton>
                            </div>
                            <div class="col-lg-3 col-md-6">
                                <asp:LinkButton ID="btnViewReports" runat="server" CssClass="btn btn-warning w-100" OnClick="btnViewReports_Click">
                                    <i class="fas fa-chart-bar"></i>
                                    View Reports
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activities and Due Today -->
        <div class="row">
            <div class="col-xl-8 mb-4">
                <div class="card">
                    
                    <div class="card-body p-0">
                        <asp:GridView ID="gvRecentActivities" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" 
                            GridLines="None" ShowHeaderWhenEmpty="true" EmptyDataText="No recent activities">
                            <Columns>
                                <asp:BoundField DataField="ActivityDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}" />
                                <asp:BoundField DataField="ActivityType" HeaderText="Type" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 mb-4">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Due Today</h5>
                        <span class="badge bg-warning text-dark"><asp:Label ID="lblDueTodayCount" runat="server" /></span>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvDueToday" runat="server" CssClass="table table-hover" AutoGenerateColumns="false"
                            GridLines="None" ShowHeaderWhenEmpty="true" EmptyDataText="No books due today">
                            <Columns>
                                <asp:BoundField DataField="BookTitle" HeaderText="Book" />
                                <asp:BoundField DataField="MemberName" HeaderText="Member" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>