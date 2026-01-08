<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="LMSPJ.Reports" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script >
        class LibraryCharts {
            static initMemberStatusChart(data) {
                new Chart(document.getElementById('memberStatusChart'), {
                    type: 'pie',
                    data: {
                        labels: ['Active', 'Inactive'],
                        datasets: [{
                            data: data,
                            backgroundColor: ['#36a2eb', '#ff6384']
                        }]
                    }
                });
            }

            static initTopBorrowersChart(labels, data) {
                new Chart(document.getElementById('topBorrowersChart'), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Number of Books Borrowed',
                            data: data,
                            backgroundColor: '#36a2eb'
                        }]
                    },
                    options: {
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                });
            }

            static initRegistrationTrendsChart(labels, data) {
                new Chart(document.getElementById('registrationTrendsChart'), {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'New Registrations',
                            data: data,
                            borderColor: '#4bc0c0',
                            tension: 0.1
                        }]
                    }
                });
            }

            static initFinePaymentChart(labels, data) {
                new Chart(document.getElementById('finePaymentChart'), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Fine Amount (MMK)',
                            data: data,
                            backgroundColor: '#ff9f40'
                        }]
                    }
                });
            }

            static initPopularBooksChart(data) {
                new Chart(document.getElementById('popularBooksChart'), {
                    type: 'bar',  // Changed from 'horizontalBar' to 'bar'
                    data: {
                        labels: data.labels,
                        datasets: [{
                            label: 'Times Borrowed',
                            data: data.data,
                            backgroundColor: '#4bc0c0'
                        }]
                    },
                    options: {
                        indexAxis: 'y',  // This makes the bar chart horizontal
                        scales: {
                            x: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }

            static initCategoryDistributionChart(labels, data) {
                new Chart(document.getElementById('categoryDistributionChart'), {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: [
                                '#ff6384', '#36a2eb', '#cc65fe',
                                '#ffce56', '#4bc0c0', '#ff9f40'
                            ]
                        }]
                    }
                });
            }

            static initTransactionTrendsChart(labels, data) {
                new Chart(document.getElementById('transactionTrendsChart'), {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Number of Transactions',
                            data: data,
                            borderColor: '#36a2eb',
                            tension: 0.1
                        }]
                    }
                });
            }

            static initReturnRateChart(data) {
                new Chart(document.getElementById('returnRateChart'), {
                    type: 'pie',
                    data: {
                        labels: ['Returned On Time', 'Returned Late', 'Not Returned'],
                        datasets: [{
                            data: data,
                            backgroundColor: ['#4bc0c0', '#ffce56', '#ff6384']
                        }]
                    }
                });
            }

            static initBorrowingDurationChart(labels, data) {
                new Chart(document.getElementById('borrowingDurationChart'), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Average Days',
                            data: data,
                            backgroundColor: '#cc65fe'
                        }]
                    }
                });
            }

            static initCategoryBorrowingChart(labels, data) {
                new Chart(document.getElementById('categoryBorrowingChart'), {
                    type: 'radar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Borrowing Frequency',
                            data: data,
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: '#36a2eb'
                        }]
                    }
                });
            }
        }
    </script>

    <div class="container">
        <!-- Date Range Filter -->
        <div class="row mb-3">
            <div class="col-md-3">
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date" />
            </div>
            <div class="col-md-3">
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date" />
            </div>
            <div class="col-md-3">
                <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" 
                    CssClass="btn btn-primary" OnClick="btnGenerateReport_Click" />
            </div>
            <div class="col-md-3">
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle" type="button" id="exportDropdown" 
                            data-bs-toggle="dropdown" aria-expanded="false">
                        Export As
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="exportDropdown">
                        <li><asp:LinkButton ID="btnExportPDF" runat="server" CssClass="dropdown-item" 
                                OnClick="btnExportPDF_Click">PDF</asp:LinkButton></li>
                        <li><asp:LinkButton ID="btnExportExcel" runat="server" CssClass="dropdown-item" 
                                OnClick="btnExportExcel_Click">Excel</asp:LinkButton></li>
                        <li><asp:LinkButton ID="btnExportCSV" runat="server" CssClass="dropdown-item" 
                                OnClick="btnExportCSV_Click">CSV</asp:LinkButton></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Member Analysis Section -->
        <div class="row mb-4">
            <h3>Member Analysis</h3>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Member Status Distribution</div>
                    <div class="card-body">
                        <canvas id="memberStatusChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Top Borrowers</div>
                    <div class="card-body">
                        <canvas id="topBorrowersChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Member Registration Trends</div>
                    <div class="card-body">
                        <canvas id="registrationTrendsChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Fine Payment History</div>
                    <div class="card-body">
                        <canvas id="finePaymentChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Book Analysis Section -->
        <div class="row mb-4">
            <h3>Book Analysis</h3>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Most Popular Books</div>
                    <div class="card-body">
                        <canvas id="popularBooksChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Books by Category</div>
                    <div class="card-body">
                        <canvas id="categoryDistributionChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Transaction Analysis Section -->
        <div class="row mb-4">
            <h3>Transaction Analysis</h3>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Transaction Trends</div>
                    <div class="card-body">
                        <canvas id="transactionTrendsChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Return Rate Analysis</div>
                    <div class="card-body">
                        <canvas id="returnRateChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Average Borrowing Duration</div>
                    <div class="card-body">
                        <canvas id="borrowingDurationChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Category-wise Borrowing Patterns</div>
                    <div class="card-body">
                        <canvas id="categoryBorrowingChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>