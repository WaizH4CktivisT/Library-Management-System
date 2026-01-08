<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MemberManagement.aspx.cs" Inherits="LibraryManagementSystem.MemberManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Custom CSS for animations and modern design -->
    <style>
        .page-header {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            transform: translateY(0);
            transition: transform 0.3s ease;
        }
        
        .page-header:hover {
            transform: translateY(-5px);
        }
        
        .page-header h2 {
            font-weight: 700;
            margin: 0;
            font-size: 2.5rem;
        }
        
        .nav-tabs {
            border-bottom: none;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border-radius: 10px;
            font-weight: 600;
            padding: 12px 25px;
            margin-right: 10px;
            transition: all 0.3s ease;
            border: none;
            color: #495057;
            background-color: #f8f9fa;
        }
        
        .nav-tabs .nav-link:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .nav-tabs .nav-link.active {
            color: white;
            background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%);
            box-shadow: 0 5px 15px rgba(106, 17, 203, 0.3);
        }
        
        .tab-content {
            background-color: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        
        .tab-pane {
            animation: fadeIn 0.5s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-control {
            border-radius: 10px;
            padding: 12px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(37, 117, 252, 0.2);
            border-color: #2575fc;
        }
        
        .btn {
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%);
            border: none;
            box-shadow: 0 5px 15px rgba(37, 117, 252, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(37, 117, 252, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(45deg, #3f4c6b 0%, #606c88 100%);
            border: none;
        }
        
        .btn-info, .btn-warning, .btn-danger {
            border: none;
            padding: 8px 16px;
            margin: 0 5px;
            transition: all 0.3s ease;
        }
        
        .btn-info:hover, .btn-warning:hover, .btn-danger:hover {
            transform: translateY(-2px);
        }
        
        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .table thead th {
            background: linear-gradient(45deg, #3f4c6b 0%, #606c88 100%);
            color: white;
            border: none;
            padding: 15px;
        }
        
        .table tbody tr {
            transition: all 0.2s ease;
        }
        
        .table tbody tr:hover {
            background-color: rgba(37, 117, 252, 0.05);
            transform: scale(1.01);
        }
        
        .card {
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        
        .form-label {
            font-weight: 600;
            margin-bottom: 10px;
            color: #495057;
        }
        
        .text-success {
            background-color: #d4edda;
            color: #155724;
            padding: 10px 15px;
            border-radius: 10px;
            display: inline-block;
            margin-bottom: 20px;
            animation: fadeIn 1s ease;
        }
        
        .search-container {
            position: relative;
            margin-bottom: 30px;
        }
        
        .search-container i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        /* Enhanced Form Design */
        .registration-form {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .registration-form::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(106, 17, 203, 0.1);
            z-index: 0;
        }
        
        .registration-form::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(37, 117, 252, 0.1);
            z-index: 0;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            z-index: 1;
        }
        
        .form-header h3 {
            color: #2575fc;
            font-weight: 700;
            font-size: 2.2rem;
            margin-bottom: 10px;
        }
        
        .form-header p {
            color: #606c88;
            font-size: 1.1rem;
        }
        
        .input-group {
            margin-bottom: 25px;
            position: relative;
            z-index: 1;
        }
        
        .input-group-text {
            background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            border: none;
            border-radius: 10px 0 0 10px;
            width: 50px;
            display: flex;
            justify-content: center;
        }
        
        .form-control {
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .form-floating {
            position: relative;
            margin-bottom: 25px;
        }
        
        .form-floating label {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            padding: 1rem 0.75rem;
            pointer-events: none;
            border: 1px solid transparent;
            transform-origin: 0 0;
            transition: opacity .1s ease-in-out,transform .1s ease-in-out;
            color: #6c757d;
        }
        
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            opacity: .65;
            transform: scale(.85) translateY(-0.5rem) translateX(0.15rem);
        }
        
        .form-floating > .form-control:focus,
        .form-floating > .form-control:not(:placeholder-shown) {
            padding-top: 1.625rem;
            padding-bottom: 0.625rem;
        }
        
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #2575fc;
        }
        
        .btn-register {
            background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 15px 30px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            box-shadow: 0 10px 20px rgba(37, 117, 252, 0.3);
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
            overflow: hidden;
        }
        
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(37, 117, 252, 0.4);
        }
        
        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #6a11cb 0%, #2575fc 100%);
            transition: all 0.4s ease;
            z-index: -1;
        }
        
        .btn-register:hover::before {
            left: 0;
        }
        
        .input-icon {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            right: 15px;
            color: #2575fc;
            transition: all 0.3s ease;
        }
        
        .form-control:focus + .input-icon {
            color: #6a11cb;
            transform: translateY(-50%) scale(1.2);
        }
        
        .form-field {
            position: relative;
            margin-bottom: 25px;
        }
        
        .field-icon {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            right: 15px;
            color: #2575fc;
            transition: all 0.3s ease;
        }
        
        .form-field .form-control:focus + .field-icon {
            color: #6a11cb;
            transform: translateY(-50%) scale(1.2);
        }
        
        /* Animated success message */
        @keyframes successPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            display: inline-block;
            margin-bottom: 20px;
            animation: successPulse 2s infinite, fadeIn 1s ease;
            border-left: 5px solid #28a745;
        }

        .table-container {
            max-height: 500px;
            overflow-y: auto;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        /* Custom scrollbar for the table container */
        .table-container::-webkit-scrollbar {
            width: 8px;
        }
        
        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .table-container::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, #3f4c6b 0%, #606c88 100%);
            border-radius: 10px;
        }
        
        .table-container::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%);
        }
        
    </style>

    <!-- Page Header with Animation -->
    <div class="page-header">
        <h2><i class="fas fa-users"></i> Member Management</h2>
        <p class="mt-2 mb-0">Register and manage library members</p>
    </div>

    <!-- Tab Navigation with Improved Design -->
    <ul class="nav nav-tabs" id="memberTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="register-tab" data-bs-toggle="tab" href="#register" role="tab" aria-controls="register" aria-selected="true">
                <i class="fas fa-user-plus" style="color:black"></i> <span style="color:black">Register Member</span>
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="list-tab" data-bs-toggle="tab" href="#list" role="tab" aria-controls="list" aria-selected="false">
                <i class="fas fa-users" style="color:black"></i><span style="color:black">Member List</span>
            </a>
        </li>
    </ul>

    <!-- Tab Content with Animation -->
    <div class="tab-content" id="memberTabsContent">

        <!-- Register Tab with Enhanced Form Design -->
        <div class="tab-pane fade show active p-4" id="register" role="tabpanel" aria-labelledby="register-tab">
            <div class="registration-form">
                <div class="form-header">
                    <h3><i class="fas fa-user-plus"></i> Register New Member</h3>
                    <p>Add a new member to the library system</p>
                </div>
                
                <asp:Label ID="lblMessage" runat="server" CssClass="success-message w-100 text-center" Visible="false"></asp:Label>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-field">
                            <label for="txtFullName" class="form-label">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter full name"></asp:TextBox>
                            <i class="fas fa-user field-icon"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-field">
                            <label for="txtEmail" class="form-label">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email address"></asp:TextBox>
                            <i class="fas fa-envelope field-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-field">
                            <label for="txtPhone" class="form-label">Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number"></asp:TextBox>
                            <i class="fas fa-phone field-icon"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-field">
                            <label for="txtAddress" class="form-label">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter address" TextMode="MultiLine" Rows="1"></asp:TextBox>
                            <i class="fas fa-home field-icon"></i>
                        </div>
                    </div>
                </div>
                
                
                
                <div class="text-center mt-5">
                    <asp:Button ID="btnRegister" runat="server" CssClass="btn-register" Text="Register Member" OnClick="btnRegister_Click" />
                </div>
            </div>
        </div>

        <!-- Member List Tab -->
        <div class="tab-pane fade p-4" id="list" role="tabpanel" aria-labelledby="list-tab">
            <h3 class="mb-4">Library Members Directory</h3>
            
            <div class="card mb-4">
                <div class="card-body p-4">
                    <div class="search-container mb-3">
                        <label for="txtSearch" class="form-label">Search Members</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, phone, or address"></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-secondary" Text="Search" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                    
                   <div class="table-container"> <div class="table-responsive">
                        <asp:GridView ID="gvMembers" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName" />
                                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                                <asp:BoundField DataField="Address" HeaderText="Address" SortExpression="Address" />
                                <asp:BoundField DataField="MembershipDate" HeaderText="Membership Date" SortExpression="MembershipDate" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="btn-group" role="group">
                                            <a href="MemberDetails.aspx?id=<%# Eval("MemberID") %>" class="btn btn-info btn-sm" data-bs-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="EditMember.aspx?id=<%# Eval("MemberID") %>" class="btn btn-warning btn-sm" data-bs-toggle="tooltip" title="Edit Member">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="DeleteMember.aspx?id=<%# Eval("MemberID") %>" class="btn btn-danger btn-sm" data-bs-toggle="tooltip" title="Delete Member">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center p-4">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <p class="lead">No members found. Register new members to see them here.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div> </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for enhanced interactivity -->
    <script>
        // Initialize tooltips and other interactive elements
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Smooth tab transitions
            var triggerTabList = [].slice.call(document.querySelectorAll('#memberTabs a'));
            triggerTabList.forEach(function(triggerEl) {
                triggerEl.addEventListener('click', function(event) {
                    event.preventDefault();
                    var tabTrigger = new bootstrap.Tab(triggerEl);
                    tabTrigger.show();
                });
            });
            
            // Add row highlight effect
            const tableRows = document.querySelectorAll('#gvMembers tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transition = 'background-color 0.3s ease';
                });
            });
            
            // Form field focus effects
            const formFields = document.querySelectorAll('.form-field .form-control');
            formFields.forEach(field => {
                field.addEventListener('focus', function() {
                    const icon = this.nextElementSibling;
                    if (icon) {
                        icon.style.color = '#6a11cb';
                        icon.style.transform = 'translateY(-50%) scale(1.2)';
                    }
                });
                
                field.addEventListener('blur', function() {
                    const icon = this.nextElementSibling;
                    if (icon) {
                        icon.style.color = '#2575fc';
                        icon.style.transform = 'translateY(-50%) scale(1)';
                    }
                });
            });
            
            
        });
    </script>
</asp:Content>