<%@ Page Title="Transaction Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TransactionManagement.aspx.cs" Inherits="LMSPJ.TransactionManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap 5 CSS and JS -->
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom CSS for tab button and tab content colors -->
    <style>
        /* Inactive tab text set to black */
        .nav-tabs .nav-link {
            color: #000 !important;
        }
        /* Active tab button: yellow background with black text */
        .nav-tabs .nav-link.active {
            background-color: #FFD700 !important; /* Gold Yellow */
            color: #000 !important;
        }
        /* Tab content background: light yellow */
        .tab-pane {
            background-color: #AFDBF5 !important;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 10px; 
        }
        /* If using cards inside tab content, remove default background */
        .card {
            background-color: transparent !important;
            border: none;
        }
        .mt-3 { margin-top: 15px; }
        .mb-3 { margin-bottom: 15px; }
    </style>
    
    <div class="container mt-4">
        <h2>Transaction Management</h2>
        <!-- Tab Navigation -->
        <ul class="nav nav-tabs" id="transactionTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="issueBooks-tab" data-bs-toggle="tab" data-bs-target="#issueBooks" type="button" role="tab" aria-controls="issueBooks" aria-selected="true">
                    Issue Books
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pendingReturns-tab" data-bs-toggle="tab" data-bs-target="#pendingReturns" type="button" role="tab" aria-controls="pendingReturns" aria-selected="false">
                    Pending Returns
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="transactionHistory-tab" data-bs-toggle="tab" data-bs-target="#transactionHistory" type="button" role="tab" aria-controls="transactionHistory" aria-selected="false">
                    Transaction History
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="overdueBooks-tab" data-bs-toggle="tab" data-bs-target="#overdueBooks" type="button" role="tab" aria-controls="overdueBooks" aria-selected="false">
                    Overdue Books
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="fineRules-tab" data-bs-toggle="tab" data-bs-target="#fineRules" type="button" role="tab" aria-controls="fineRules" aria-selected="false">
                    Fine Rules
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="paymentHistory-tab" data-bs-toggle="tab" data-bs-target="#paymentHistory" type="button" role="tab" aria-controls="paymentHistory" aria-selected="false">
                    Payment History
                </button>
            </li>
        </ul>
        
        <!-- Tab Content -->
        <div class="tab-content mt-3" id="transactionTabContent">
            <!-- Issue Books Tab -->
            <div class="tab-pane fade show active" id="issueBooks" role="tabpanel" aria-labelledby="issueBooks-tab">
                <div class="container">
                    <div class="row">
                        <!-- Member Search -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="txtMemberSearch" class="form-label">Search Member:</label>
                                <div class="input-group">
                                    <asp:TextBox ID="txtMemberSearch" runat="server" CssClass="form-control" placeholder="Enter Member ID or Name"></asp:TextBox>
                                    <asp:Button ID="btnSearchMember" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearchMember_Click" />
                                </div>
                            </div>
                            <asp:Panel ID="pnlMemberInfo" runat="server" Visible="false">
                                <div class="alert alert-info">
                                    <asp:Label ID="lblMemberInfo" runat="server"></asp:Label>
                                </div>
                            </asp:Panel>
                        </div>
                        <!-- Book Search -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="txtBookSearch" class="form-label">Search Book:</label>
                                <div class="input-group">
                                    <asp:TextBox ID="txtBookSearch" runat="server" CssClass="form-control" placeholder="Enter Book ID or Title"></asp:TextBox>
                                    <asp:Button ID="btnSearchBook" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearchBook_Click" />
                                </div>
                            </div>
                            <asp:Panel ID="pnlBookInfo" runat="server" Visible="false">
                                <div class="alert alert-info">
                                    <asp:Label ID="lblBookInfo" runat="server"></asp:Label>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                    <!-- Selected Books Grid -->
                    <div class="mb-3">
                        <h4>Selected Books</h4>
                        <asp:GridView ID="gvSelectedBooks" runat="server" CssClass="table table-striped" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="BookID" HeaderText="Book ID" />
                                <asp:BoundField DataField="Title" HeaderText="Title" />
                                <asp:BoundField DataField="Author" HeaderText="Author" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn btn-danger btn-sm"
                                            CommandName="Remove" OnClick="btnRemoveBook_Click" CommandArgument='<%# Eval("BookID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <!-- Due Date, Fine Rule and Issue Button -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="txtDueDate" class="form-label">Due Date:</label>
                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="ddlFineRule" class="form-label">Fine Rule:</label>
                                <asp:DropDownList ID="ddlFineRule" runat="server" CssClass="form-select">
                                   
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <label class="form-label">&nbsp;</label>
                                <asp:Button ID="btnIssue" runat="server" Text="Issue Books" CssClass="btn btn-success form-control" OnClick="btnIssue_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Pending Returns Tab -->
            <div class="tab-pane fade" id="pendingReturns" role="tabpanel" aria-labelledby="pendingReturns-tab">
                <div class="container">
                    <div class="mb-3">
                        <div class="input-group">
                            <asp:TextBox ID="txtTransactionSearch" runat="server" CssClass="form-control" placeholder="Search by Transaction ID, Book, or Member"></asp:TextBox>
                            <asp:Button ID="btnSearchTransaction" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearchTransaction_Click" />
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvPendingReturns" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" OnRowCommand="gvPendingReturns_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" />
                                <asp:BoundField DataField="BookTitle" HeaderText="Book" />
                                <asp:BoundField DataField="MemberName" HeaderText="Member" />
                                <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Button ID="btnReturn" runat="server" Text="Return" CssClass="btn btn-success btn-sm"
                                            CommandName="ReturnBook" CommandArgument='<%# Eval("TransactionID").ToString().Trim() %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <!-- Transaction History Tab -->
            <div class="tab-pane fade" id="transactionHistory" role="tabpanel" aria-labelledby="transactionHistory-tab">
                <div class="container">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <asp:TextBox ID="txtHistorySearch" runat="server" CssClass="form-control" placeholder="Search transactions"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="All Status" Value="" />
                                <asp:ListItem Text="Issued" Value="Issued" />
                                <asp:ListItem Text="Returned" Value="Returned" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" placeholder="From Date"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" placeholder="To Date"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary form-control" OnClick="btnFilter_Click" />
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvTransactionHistory" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvTransactionHistory_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" />
                                <asp:BoundField DataField="BookTitle" HeaderText="Book" />
                                <asp:BoundField DataField="MemberName" HeaderText="Member" />
                                <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="CalculatedFineAmount" HeaderText="Fine Amount" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <!-- Overdue Books Tab -->
            <div class="tab-pane fade" id="overdueBooks" role="tabpanel" aria-labelledby="overdueBooks-tab">
                <div class="container">
                    <div class="table-responsive">
                        <asp:GridView ID="gvOverdueBooks" runat="server" CssClass="table table-striped" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" />
                                <asp:BoundField DataField="BookTitle" HeaderText="Book" />
                                <asp:BoundField DataField="MemberName" HeaderText="Member" />
                                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="DaysOverdue" HeaderText="Days Overdue" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Button ID="btnSendWarning" runat="server" Text="Send Warning" CssClass="btn btn-warning btn-sm"
                                            OnClick="btnSendWarning_Click" CommandArgument='<%# Eval("TransactionID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <!-- Fine Rules Tab -->
            <div class="tab-pane fade" id="fineRules" role="tabpanel" aria-labelledby="fineRules-tab">
                <div class="container">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="txtFinePerDay" class="form-label">Fine Amount per Day (MMK):</label>
                                <asp:TextBox ID="txtFinePerDay" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="txtRuleDescription" class="form-label">Description:</label>
                                <asp:TextBox ID="txtRuleDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <label class="form-label">&nbsp;</label>
                                <asp:Button ID="btnAddFineRule" runat="server" Text="Add Rule" CssClass="btn btn-success form-control" OnClick="btnAddFineRule_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvFineRules" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" OnRowCommand="gvFineRules_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="RuleID" HeaderText="Rule ID" />
                                <asp:BoundField DataField="FinePerDay" HeaderText="Fine per Day (MMK)" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Button runat="server" Text='<%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                                            CommandName="ToggleStatus" CommandArgument='<%# Eval("RuleID") %>' 
                                            CssClass='<%# Eval("Status").ToString() == "Active" ? "btn btn-warning btn-sm" : "btn btn-success btn-sm" %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <!-- Payment History Tab -->
            <div class="tab-pane fade" id="paymentHistory" role="tabpanel" aria-labelledby="paymentHistory-tab">
                <div class="container">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <asp:TextBox ID="txtPaymentSearch" runat="server" CssClass="form-control" placeholder="Search by Member ID or Name"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearchPayment" runat="server" Text="Search" CssClass="btn btn-primary form-control" OnClick="btnSearchPayment_Click" />
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvPaymentHistory" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvPaymentHistory_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" />
                                <asp:BoundField DataField="MemberName" HeaderText="Member Name" />
                                <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2} MMK" />
                                <asp:BoundField DataField="PaymentType" HeaderText="Payment Type" />
                                <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div><!-- End Tab Content -->
    </div><!-- End Container -->
</asp:Content>
