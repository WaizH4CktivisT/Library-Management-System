<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MemberDetails.aspx.cs" Inherits="LMSPJ.MemberDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- CSS for animations and enhanced styling -->
    <style>
        /* Card animations and effects */
        .card {
            transition: all 0.3s ease;
            border-radius: 10px;
            overflow: hidden;
            border: none;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15) !important;
        }
        
        .card-header {
            border-bottom: none;
            padding: 1.25rem;
        }
        
        /* Stats counters */
        .stat-counter {
            font-size: 2.5rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0;
            opacity: 0;
            animation: fadeInUp 0.8s ease forwards;
        }
        
        /* Member info styling */
        .member-info-item {
            padding: 8px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            opacity: 0;
            animation: fadeInLeft 0.5s ease forwards;
        }
        
        .member-info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            width: 120px;
            color: #555;
        }
        
        .info-value {
            flex-grow: 1;
        }
        
        /* Status badges */
        .status-active {
            background-color: #28a745;
        }
        
        .status-returned {
            background-color: #17a2b8;
        }
        
        .status-overdue {
            background-color: #dc3545;
        }
        
        /* Grid customization */
        .custom-grid {
            border-radius: 8px;
            overflow: hidden;
        }
        
        .custom-grid th {
            background-color: #343a40;
            color: white;
            border: none;
            padding: 15px;
        }
        
        .custom-grid td {
            padding: 12px;
            vertical-align: middle;
        }
        
        /* Animation keyframes */
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
        
        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        /* Page header */
        .page-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f8f9fa;
            animation: fadeIn 0.5s ease;
        }
        
        .page-header h2 {
            font-weight: 600;
            display: inline-flex;
            align-items: center;
        }
        
        .page-header i {
            margin-right: 12px;
            background: linear-gradient(45deg, #4e73df, #36b9cc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.8rem;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .stats-container {
                margin-top: 20px;
            }
        }
        
        /* Transaction status indicator */
        .status-badge {
            padding: 5px 10px;
            border-radius: 50px;
            color: white;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }
        
        /* Card activity indicators */
        .activity-pulse {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(66, 133, 244, 0.7);
            }
            70% {
                transform: scale(1);
                box-shadow: 0 0 0 10px rgba(66, 133, 244, 0);
            }
            100% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(66, 133, 244, 0);
            }
        }
    </style>

    <div class="container mt-4">
        <div class="page-header">
            <h2><i class="fas fa-user-circle" style="color:black">Member Details</span> </h2>
        </div>></i><span style="color:black">Member Details</span> </h2>
        </div>
        
        <div class="row">
            <!-- Member Information Card -->
            <div class="col-lg-4">
                <div class="card mb-4 shadow" style="animation-delay: 0.1s; animation: fadeIn 0.6s ease;">
                    <div class="card-header bg-gradient-primary text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4 class="mb-0"><i class="fas fa-id-card mr-2" style="color:black"></i> <span style="color:black">Member Profile</span></h4>
                            <span class="activity-pulse bg-white"></span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <div class="rounded-circle bg-light d-inline-flex justify-content-center align-items-center" style="width: 100px; height: 100px; animation: fadeIn 0.8s ease;">
                                <i class="fas fa-user fa-3x text-primary"></i>
                            </div>
                        </div>
                        
                        <div class="member-info-item" style="animation-delay: 0.1s">
                            <div class="info-label">Member ID:</div>
                            <div class="info-value"><asp:Label ID="lblMemberID" runat="server"></asp:Label></div>
                        </div>
                        <div class="member-info-item" style="animation-delay: 0.2s">
                            <div class="info-label">Name:</div>
                            <div class="info-value"><asp:Label ID="lblFullName" runat="server"></asp:Label></div>
                        </div>
                        <div class="member-info-item" style="animation-delay: 0.3s">
                            <div class="info-label">Email:</div>
                            <div class="info-value"><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                        </div>
                        <div class="member-info-item" style="animation-delay: 0.4s">
                            <div class="info-label">Phone:</div>
                            <div class="info-value"><asp:Label ID="lblPhone" runat="server"></asp:Label></div>
                        </div>
                        <div class="member-info-item" style="animation-delay: 0.5s">
                            <div class="info-label">Address:</div>
                            <div class="info-value"><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                        </div>
                        <div class="member-info-item" style="animation-delay: 0.6s">
                            <div class="info-label">Member Since:</div>
                            <div class="info-value"><asp:Label ID="lblMembershipDate" runat="server"></asp:Label></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction Summary Cards -->
            <div class="col-lg-8">
                <div class="card mb-4 shadow" style="animation: fadeIn 0.8s ease;">
                    <div class="card-header bg-gradient-info text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4 class="mb-0"><i class="fas fa-chart-line mr-2" style="color:black"></i> <span style="color:black">Transaction Summary</span></h4>
                            <button class="btn btn-sm btn-light" data-toggle="tooltip" title="Refresh Data">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-4">
                                <div class="p-3 rounded mb-3" style="background-color: rgba(78, 115, 223, 0.1);">
                                    <div class="text-primary mb-1">
                                        <i class="fas fa-book fa-2x"></i>
                                    </div>
                                    <h5>Total Transactions</h5>
                                    <h3 class="stat-counter" style="animation-delay: 0.2s">
                                        <asp:Label ID="lblTotalTransactions" runat="server" Text="0"></asp:Label>
                                    </h3>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 rounded mb-3" style="background-color: rgba(54, 185, 204, 0.1);">
                                    <div class="text-info mb-1">
                                        <i class="fas fa-spinner fa-2x"></i>
                                    </div>
                                    <h5>Active Transactions</h5>
                                    <h3 class="stat-counter" style="animation-delay: 0.4s">
                                        <asp:Label ID="lblActiveTransactions" runat="server" Text="0"></asp:Label>
                                    </h3>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 rounded mb-3" style="background-color: rgba(246, 194, 62, 0.1);">
                                    <div class="text-warning mb-1">
                                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                                    </div>
                                    <h5>Overdue</h5>
                                    <h3 class="stat-counter" style="animation-delay: 0.6s">
                                        <asp:Label ID="lblOverdueTransactions" runat="server" Text="0"></asp:Label>
                                    </h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                
            </div>
        </div>

        <!-- Detailed Transaction History -->
        <div class="card shadow mb-4" style="animation: fadeIn 1.2s ease;">
            <div class="card-header bg-gradient-dark text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="fas fa-history mr-2" style="color:black"></i> <span style="color:black">Transaction History</span></h4>
                    
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="gvTransactionHistory" runat="server" 
                        CssClass="table table-bordered table-hover custom-grid" 
                        AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="TransactionID" HeaderText="ID" />
                            <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:MM/dd/yyyy}" />
                            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:MM/dd/yyyy}" />
                            <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" DataFormatString="{0:MM/dd/yyyy}" />
                            <asp:BoundField DataField="FineAmount" HeaderText="Fine Amount" DataFormatString="{0:C}" />
                            
                            
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for enhanced interactivity -->
    <script>
        // Initialize tooltips
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();

            // Animate stats on scroll
            const animateStats = () => {
                $('.stat-counter').each(function () {
                    const $this = $(this);
                    const value = parseInt($this.text());

                    $({ Counter: 0 }).animate({
                        Counter: value
                    }, {
                        duration: 1500,
                        easing: 'swing',
                        step: function () {
                            $this.text(Math.ceil(this.Counter));
                        }
                    });
                });
            };

            // Run animations when page loads
            setTimeout(animateStats, 500);

            // Add hover effects to transaction rows
            $('.custom-grid tr').not(':first').hover(
                function () {
                    $(this).addClass('bg-light');
                },
                function () {
                    $(this).removeClass('bg-light');
                }
            );
        });
    </script>
</asp:Content>