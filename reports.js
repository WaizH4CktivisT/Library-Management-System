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

    static initPopularBooksChart(labels, data) {
        new Chart(document.getElementById('popularBooksChart'), {
            type: 'horizontalBar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Times Borrowed',
                    data: data,
                    backgroundColor: '#4bc0c0'
                }]
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