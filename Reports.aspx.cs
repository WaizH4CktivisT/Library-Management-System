using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.Services;
using Newtonsoft.Json;
using iTextSharp.text;
using iTextSharp.text.pdf;
using ClosedXML.Excel;
using System.IO;
using System.Text;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;

namespace LMSPJ
{
    public partial class Reports : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllReports();
            }
        }


        private void LoadAllReports()
        {
            try
            {
                var startDate = !string.IsNullOrEmpty(txtStartDate.Text) ?
                    DateTime.Parse(txtStartDate.Text) : DateTime.Now.AddMonths(-6);
                var endDate = !string.IsNullOrEmpty(txtEndDate.Text) ?
                    DateTime.Parse(txtEndDate.Text) : DateTime.Now;

                // Get all data first
                var chartData = new
                {
                    memberStats = GetMemberStatistics(),
                    topBorrowers = GetTopBorrowers(startDate, endDate),
                    registrationTrends = GetRegistrationTrends(startDate, endDate),
                    fineHistory = GetFinePaymentHistory(startDate, endDate),
                    popularBooks = GetPopularBooks(startDate, endDate),
                    categoryDistribution = GetCategoryDistribution(),
                    transactionTrends = GetTransactionTrends(startDate, endDate),
                    returnRates = GetReturnRateAnalysis(startDate, endDate),
                    borrowingDuration = GetBorrowingDurationStats(),
                    categoryBorrowing = GetCategoryBorrowingPatterns(startDate, endDate)
                };

                string script = $@"
        document.addEventListener('DOMContentLoaded', function() {{
            try {{
                var chartData = {JsonConvert.SerializeObject(chartData)};
                console.log('Initializing charts with data:', chartData);
                
                if (chartData.memberStats) {{
                    LibraryCharts.initMemberStatusChart(chartData.memberStats);
                }}
                
                if (chartData.topBorrowers) {{
                    LibraryCharts.initTopBorrowersChart(
                        chartData.topBorrowers.Item1, 
                        chartData.topBorrowers.Item2
                    );
                }}
                
                if (chartData.registrationTrends) {{
                    LibraryCharts.initRegistrationTrendsChart(
                        chartData.registrationTrends.Item1,
                        chartData.registrationTrends.Item2
                    );
                }}
                
                if (chartData.fineHistory) {{
                    LibraryCharts.initFinePaymentChart(
                        chartData.fineHistory.Item1,
                        chartData.fineHistory.Item2
                    );
                }}
                
                if (chartData.popularBooks) {{
                    LibraryCharts.initPopularBooksChart(
                        chartData.popularBooks.Item1,
                        chartData.popularBooks.Item2
                    );
                }}
                
                if (chartData.categoryDistribution) {{
                    LibraryCharts.initCategoryDistributionChart(
                        chartData.categoryDistribution.Item1,
                        chartData.categoryDistribution.Item2
                    );
                }}
                
                if (chartData.transactionTrends) {{
                    LibraryCharts.initTransactionTrendsChart(
                        chartData.transactionTrends.Item1,
                        chartData.transactionTrends.Item2
                    );
                }}
                
                if (chartData.returnRates) {{
                    LibraryCharts.initReturnRateChart([
                        chartData.returnRates.Item1,
                        chartData.returnRates.Item2,
                        chartData.returnRates.Item3
                    ]);
                }}
                
                if (chartData.borrowingDuration) {{
                    LibraryCharts.initBorrowingDurationChart(
                        chartData.borrowingDuration.Item1,
                        chartData.borrowingDuration.Item2
                    );
                }}
                
                if (chartData.categoryBorrowing) {{
                    LibraryCharts.initCategoryBorrowingChart(
                        chartData.categoryBorrowing.Item1,
                        chartData.categoryBorrowing.Item2
                    );
                }}
                
                console.log('All charts initialized successfully');
            }} catch (error) {{
                console.error('Error initializing charts:', error);
                console.error('Chart data:', chartData);
                alert('There was an error loading the charts. Please check the console for details.');
            }}
        }});";

                ScriptManager.RegisterStartupScript(this, GetType(), "ChartInit", script, true);
            }
            catch (Exception ex)
            {
                string errorScript = $@"console.error('Server error:', {JsonConvert.SerializeObject(ex.Message)});";
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorLog", errorScript, true);
            }
        }
        private DataTable GetPeakBorrowingPeriods(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH DailyStats AS (
                SELECT 
                    CAST(IssueDate AS DATE) as BorrowDate,
                    DATEPART(WEEKDAY, IssueDate) as WeekDay,
                    DATEPART(HOUR, IssueDate) as HourOfDay,
                    COUNT(*) as TransactionCount
                FROM Transactions
                WHERE IssueDate BETWEEN @StartDate AND @EndDate
                GROUP BY CAST(IssueDate AS DATE), 
                         DATEPART(WEEKDAY, IssueDate),
                         DATEPART(HOUR, IssueDate)
            )
            SELECT 
                CASE WeekDay
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                END as DayOfWeek,
                HourOfDay,
                AVG(TransactionCount) as AverageTransactions,
                MAX(TransactionCount) as PeakTransactions,
                COUNT(*) as TotalOccurrences
            FROM DailyStats
            GROUP BY WeekDay, HourOfDay
            ORDER BY AVG(TransactionCount) DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        private Tuple<List<string>, List<int>> GetCategoryBorrowingPatterns(DateTime startDate, DateTime endDate)
        {
            List<string> categories = new List<string>();
            List<int> borrowCounts = new List<int>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH CategoryStats AS (
                SELECT 
                    c.CategoryName,
                    COUNT(t.TransactionID) as TotalBorrows
                FROM Categories c
                LEFT JOIN Books b ON c.CategoryID = b.CategoryID
                LEFT JOIN Transactions t ON b.BookID = t.BookID
                    AND t.IssueDate BETWEEN @StartDate AND @EndDate
                GROUP BY c.CategoryName
            )
            SELECT CategoryName, TotalBorrows
            FROM CategoryStats
            ORDER BY TotalBorrows DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            categories.Add(reader["CategoryName"].ToString());
                            borrowCounts.Add(Convert.ToInt32(reader["TotalBorrows"]));
                        }
                    }
                }
            }

            return Tuple.Create(categories, borrowCounts);
        }
        private Tuple<int, decimal, double> GetOverdueStatistics(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH OverdueStats AS (
                SELECT 
                    COUNT(*) as TotalOverdue,
                    SUM(CalculatedFineAmount) as TotalFines,
                    AVG(CAST(DaysOverdue as float)) as AverageDaysOverdue
                FROM Transactions
                WHERE Status = 'Returned'
                AND ReturnDate > DueDate
                AND ReturnDate BETWEEN @StartDate AND @EndDate
            )
            SELECT 
                ISNULL(TotalOverdue, 0) as TotalOverdue,
                ISNULL(TotalFines, 0) as TotalFines,
                ISNULL(AverageDaysOverdue, 0) as AverageDaysOverdue
            FROM OverdueStats";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return Tuple.Create(
                                Convert.ToInt32(reader["TotalOverdue"]),
                                Convert.ToDecimal(reader["TotalFines"]),
                                Convert.ToDouble(reader["AverageDaysOverdue"])
                            );
                        }
                        return Tuple.Create(0, 0m, 0.0);
                    }
                }
            }
        }
        private DataTable GetLeastBorrowedBooks(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH BookBorrowCount AS (
                SELECT 
                    b.BookID,
                    b.Title,
                    b.Author,
                    COUNT(t.TransactionID) as BorrowCount
                FROM Books b
                LEFT JOIN Transactions t ON b.BookID = t.BookID 
                    AND t.IssueDate BETWEEN @StartDate AND @EndDate
                GROUP BY b.BookID, b.Title, b.Author
            )
            SELECT TOP 10
                Title,
                Author,
                BorrowCount,
                CASE 
                    WHEN BorrowCount = 0 THEN 'Never borrowed'
                    ELSE CAST(BorrowCount as VARCHAR) + ' times'
                END as BorrowStatus
            FROM BookBorrowCount
            ORDER BY BorrowCount ASC, Title ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        private Tuple<int, int, int> GetReturnRateAnalysis(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                COUNT(CASE WHEN Status = 'Returned' AND ReturnDate <= DueDate THEN 1 END) as OnTimeReturns,
                COUNT(CASE WHEN Status = 'Returned' AND ReturnDate > DueDate THEN 1 END) as LateReturns,
                COUNT(CASE WHEN Status = 'Issued' AND DueDate < GETDATE() THEN 1 END) as CurrentlyOverdue
            FROM Transactions
            WHERE IssueDate BETWEEN @StartDate AND @EndDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return Tuple.Create(
                                Convert.ToInt32(reader["OnTimeReturns"]),
                                Convert.ToInt32(reader["LateReturns"]),
                                Convert.ToInt32(reader["CurrentlyOverdue"])
                            );
                        }
                        return Tuple.Create(0, 0, 0);
                    }
                }
            }
        }
        private Tuple<decimal, decimal, int> GetFineCollectionStats(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                SUM(Amount) as TotalFines,
                SUM(CASE WHEN PaymentStatus = 'Paid' THEN Amount ELSE 0 END) as CollectedFines,
                COUNT(CASE WHEN PaymentStatus = 'Pending' THEN 1 END) as PendingPayments
            FROM Payments
            WHERE PaymentType = 'Fine'
            AND PaymentDate BETWEEN @StartDate AND @EndDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal totalFines = reader["TotalFines"] != DBNull.Value ? Convert.ToDecimal(reader["TotalFines"]) : 0;
                            decimal collectedFines = reader["CollectedFines"] != DBNull.Value ? Convert.ToDecimal(reader["CollectedFines"]) : 0;
                            int pendingPayments = reader["PendingPayments"] != DBNull.Value ? Convert.ToInt32(reader["PendingPayments"]) : 0;

                            return Tuple.Create(totalFines, collectedFines, pendingPayments);
                        }
                        return Tuple.Create(0m, 0m, 0);
                    }
                }
            }
        }
        private Tuple<List<string>, List<int>> GetBorrowingDurationStats()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH DurationStats AS (
                SELECT 
                    CASE 
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 7 THEN '1-7 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 14 THEN '8-14 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 21 THEN '15-21 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 30 THEN '22-30 days'
                        ELSE 'Over 30 days'
                    END as DurationRange,
                    COUNT(*) as Frequency
                FROM Transactions
                WHERE Status = 'Returned'
                GROUP BY 
                    CASE 
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 7 THEN '1-7 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 14 THEN '8-14 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 21 THEN '15-21 days'
                        WHEN DATEDIFF(day, IssueDate, ISNULL(ReturnDate, GETDATE())) <= 30 THEN '22-30 days'
                        ELSE 'Over 30 days'
                    END
            )
            SELECT DurationRange, Frequency 
            FROM DurationStats
            ORDER BY 
                CASE DurationRange
                    WHEN '1-7 days' THEN 1
                    WHEN '8-14 days' THEN 2
                    WHEN '15-21 days' THEN 3
                    WHEN '22-30 days' THEN 4
                    ELSE 5
                END";

                List<string> labels = new List<string>();
                List<int> data = new List<int>();

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            labels.Add(reader["DurationRange"].ToString());
                            data.Add(Convert.ToInt32(reader["Frequency"]));
                        }
                    }
                }

                return Tuple.Create(labels, data);
            }
        }
        private decimal GetAverageBorrowingDuration(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT AVG(CAST(
                DATEDIFF(day, IssueDate, 
                    CASE 
                        WHEN ReturnDate IS NOT NULL THEN ReturnDate 
                        ELSE GETDATE() 
                    END) AS decimal(10,2)
                )) as AvgDuration
            FROM Transactions
            WHERE IssueDate BETWEEN @StartDate AND @EndDate
            AND Status = 'Returned'";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                }
            }
        }
        private DataTable GetBookAvailability()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                b.BookID,
                b.Title,
                b.Author,
                b.TotalCopies,
                b.AvailableCopies,
                (b.TotalCopies - b.AvailableCopies) as CheckedOutCopies,
                (SELECT COUNT(*) 
                 FROM Transactions t 
                 WHERE t.BookID = b.BookID 
                 AND t.Status = 'Issued' 
                 AND t.DueDate < GETDATE()) as OverdueCopies,
                CASE 
                    WHEN b.AvailableCopies = 0 THEN 'Not Available'
                    WHEN b.AvailableCopies < (b.TotalCopies * 0.2) THEN 'Low Availability'
                    ELSE 'Available'
                END as AvailabilityStatus
            FROM Books b
            ORDER BY b.Title";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        private DataTable GetMemberCategories()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            WITH MemberBorrowStats AS (
                SELECT 
                    m.MemberID,
                    m.FullName,
                    COUNT(t.TransactionID) as TotalBorrows,
                    SUM(CASE WHEN t.DueDate < GETDATE() AND t.Status = 'Issued' THEN 1 ELSE 0 END) as CurrentOverdue,
                    SUM(ISNULL(t.CalculatedFineAmount, 0)) as TotalFines
                FROM Members m
                LEFT JOIN Transactions t ON m.MemberID = t.MemberID
                GROUP BY m.MemberID, m.FullName
            )
            SELECT 
                CASE 
                    WHEN TotalBorrows = 0 THEN 'Inactive'
                    WHEN TotalBorrows > 20 AND CurrentOverdue = 0 THEN 'Premium'
                    WHEN CurrentOverdue > 0 THEN 'Restricted'
                    ELSE 'Regular'
                END as MemberCategory,
                COUNT(*) as MemberCount,
                AVG(TotalFines) as AverageFines
            FROM MemberBorrowStats
            GROUP BY 
                CASE 
                    WHEN TotalBorrows = 0 THEN 'Inactive'
                    WHEN TotalBorrows > 20 AND CurrentOverdue = 0 THEN 'Premium'
                    WHEN CurrentOverdue > 0 THEN 'Restricted'
                    ELSE 'Regular'
                END
            ORDER BY MemberCategory";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        private DataTable GetOverdueMembers()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT DISTINCT 
                m.MemberID,
                m.FullName,
                m.Email,
                COUNT(t.TransactionID) as OverdueBooks,
                MAX(DATEDIFF(day, t.DueDate, GETDATE())) as MaxDaysOverdue,
                SUM(fr.FinePerDay * DATEDIFF(day, t.DueDate, GETDATE())) as TotalPendingFines
            FROM Members m
            JOIN Transactions t ON m.MemberID = t.MemberID
            JOIN FineRules fr ON t.FineRuleID = fr.RuleID
            WHERE t.Status = 'Issued' 
            AND t.DueDate < GETDATE()
            GROUP BY m.MemberID, m.FullName, m.Email
            ORDER BY MaxDaysOverdue DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        private int[] GetMemberStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                COUNT(*) as TotalMembers,
                SUM(CASE 
                    WHEN MembershipDate >= DATEADD(MONTH, -1, GETDATE()) 
                    THEN 1 ELSE 0 
                END) as NewMembersThisMonth
            FROM Members";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new int[] {
                        Convert.ToInt32(reader["TotalMembers"]),
                        Convert.ToInt32(reader["NewMembersThisMonth"])
                    };
                        }
                    }
                }
            }
            return new int[] { 0, 0 };
        }
        private Tuple<string[], int[]> GetTopBorrowers(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 10 m.FullName,
                           COUNT(t.TransactionID) as BorrowCount
                    FROM Members m
                    JOIN Transactions t ON m.MemberID = t.MemberID
                    WHERE t.IssueDate BETWEEN @StartDate AND @EndDate
                    GROUP BY m.FullName
                    ORDER BY BorrowCount DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();

                    var names = new List<string>();
                    var counts = new List<int>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            names.Add(reader["FullName"].ToString());
                            counts.Add(Convert.ToInt32(reader["BorrowCount"]));
                        }
                    }
                    return new Tuple<string[], int[]>(names.ToArray(), counts.ToArray());
                }
            }
        }

        private Tuple<string[], decimal[]> GetFinePaymentHistory(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT FORMAT(PaymentDate, 'yyyy-MM') as Month,
                           SUM(Amount) as TotalFines
                    FROM Payments
                    WHERE PaymentDate BETWEEN @StartDate AND @EndDate
                    GROUP BY FORMAT(PaymentDate, 'yyyy-MM')
                    ORDER BY Month";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();

                    var months = new List<string>();
                    var amounts = new List<decimal>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            months.Add(reader["Month"].ToString());
                            amounts.Add(Convert.ToDecimal(reader["TotalFines"]));
                        }
                    }
                    return new Tuple<string[], decimal[]>(months.ToArray(), amounts.ToArray());
                }
            }
        }

        private Tuple<string[], int[]> GetRegistrationTrends(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT FORMAT(MembershipDate, 'yyyy-MM') as Month,
                           COUNT(*) as NewMembers
                    FROM Members
                    WHERE MembershipDate BETWEEN @StartDate AND @EndDate
                    GROUP BY FORMAT(MembershipDate, 'yyyy-MM')
                    ORDER BY Month";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();

                    var months = new List<string>();
                    var counts = new List<int>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            months.Add(reader["Month"].ToString());
                            counts.Add(Convert.ToInt32(reader["NewMembers"]));
                        }
                    }
                    return new Tuple<string[], int[]>(months.ToArray(), counts.ToArray());
                }
            }
        }

        private Tuple<string[], int[]> GetPopularBooks(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 10 b.Title,
                           COUNT(t.TransactionID) as BorrowCount
                    FROM Books b
                    JOIN Transactions t ON b.BookID = t.BookID
                    WHERE t.IssueDate BETWEEN @StartDate AND @EndDate
                    GROUP BY b.Title
                    ORDER BY BorrowCount DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();

                    var titles = new List<string>();
                    var counts = new List<int>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            titles.Add(reader["Title"].ToString());
                            counts.Add(Convert.ToInt32(reader["BorrowCount"]));
                        }
                    }
                    return new Tuple<string[], int[]>(titles.ToArray(), counts.ToArray());
                }
            }
        }

        private Tuple<string[], int[]> GetCategoryDistribution()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT c.CategoryName,
                           COUNT(b.BookID) as BookCount
                    FROM Categories c
                    LEFT JOIN Books b ON c.CategoryID = b.CategoryID
                    GROUP BY c.CategoryName
                    ORDER BY BookCount DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    var categories = new List<string>();
                    var counts = new List<int>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            categories.Add(reader["CategoryName"].ToString());
                            counts.Add(Convert.ToInt32(reader["BookCount"]));
                        }
                    }
                    return new Tuple<string[], int[]>(categories.ToArray(), counts.ToArray());
                }
            }
        }

        private Tuple<string[], int[]> GetTransactionTrends(DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT FORMAT(IssueDate, 'yyyy-MM-dd') as Date,
                           COUNT(*) as TransactionCount
                    FROM Transactions
                    WHERE IssueDate BETWEEN @StartDate AND @EndDate
                    GROUP BY FORMAT(IssueDate, 'yyyy-MM-dd')
                    ORDER BY Date";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();

                    var dates = new List<string>();
                    var counts = new List<int>();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            dates.Add(reader["Date"].ToString());
                            counts.Add(Convert.ToInt32(reader["TransactionCount"]));
                        }
                    }
                    return new Tuple<string[], int[]>(dates.ToArray(), counts.ToArray());
                }
            }
        }

        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            LoadAllReports();
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                Document document = new Document(PageSize.A4, 25, 25, 30, 30);
                PdfWriter writer = PdfWriter.GetInstance(document, ms);
                document.Open();

                document.Add(new Paragraph("Library Statistics Report"));
                document.Add(new Paragraph($"Generated on: {DateTime.Now:dd/MM/yyyy}"));
                document.Add(new Paragraph("----------------------------------------"));

                var startDate = !string.IsNullOrEmpty(txtStartDate.Text) ?
                    DateTime.Parse(txtStartDate.Text) : DateTime.Now.AddMonths(-6);
                var endDate = !string.IsNullOrEmpty(txtEndDate.Text) ?
                    DateTime.Parse(txtEndDate.Text) : DateTime.Now;

                AddPDFSection(document, "Member Statistics", GetMemberStatistics());
                AddPDFSection(document, "Top Borrowers", GetTopBorrowers(startDate, endDate));
                AddPDFSection(document, "Popular Books", GetPopularBooks(startDate, endDate));
                AddPDFSection(document, "Category Distribution", GetCategoryDistribution());

                document.Close();

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment;filename=LibraryReport.pdf");
                Response.BinaryWrite(ms.ToArray());
                Response.End();
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            using (XLWorkbook workbook = new XLWorkbook())
            {
                // Export Transaction History
                DataTable historyData = GetTransactionHistoryData();
                var historySheet = workbook.Worksheets.Add("Transaction History");
                historySheet.Cell(1, 1).InsertTable(historyData);
                historySheet.Columns().AdjustToContents();

                // Export Overdue Books
                DataTable overdueData = GetOverdueData();
                var overdueSheet = workbook.Worksheets.Add("Overdue Books");
                overdueSheet.Cell(1, 1).InsertTable(overdueData);
                overdueSheet.Columns().AdjustToContents();

                // Export Pending Returns
                DataTable pendingData = GetPendingReturnsData();
                var pendingSheet = workbook.Worksheets.Add("Pending Returns");
                pendingSheet.Cell(1, 1).InsertTable(pendingData);
                pendingSheet.Columns().AdjustToContents();

                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=TransactionReport.xlsx");

                using (MemoryStream ms = new MemoryStream())
                {
                    workbook.SaveAs(ms);
                    Response.BinaryWrite(ms.ToArray());
                    Response.End();
                }
            }
        }

        private DataTable GetTransactionHistoryData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                        t.IssueDate, t.DueDate, t.ReturnDate, t.CalculatedFineAmount, t.Status
                        FROM Transactions t
                        JOIN Books b ON t.BookID = b.BookID
                        JOIN Members m ON t.MemberID = m.MemberID
                        ORDER BY t.TransactionID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        private DataTable GetOverdueData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                        m.Email, t.DueDate, DATEDIFF(day, t.DueDate, GETDATE()) as DaysOverdue
                        FROM Transactions t
                        JOIN Books b ON t.BookID = b.BookID
                        JOIN Members m ON t.MemberID = m.MemberID
                        WHERE t.Status = 'Issued' AND t.DueDate < GETDATE()
                        ORDER BY t.DueDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        private DataTable GetPendingReturnsData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, b.Title as BookTitle, m.FullName as MemberName,
                        t.IssueDate, t.DueDate
                        FROM Transactions t
                        JOIN Books b ON t.BookID = b.BookID
                        JOIN Members m ON t.MemberID = m.MemberID
                        WHERE t.Status = 'Issued'
                        ORDER BY t.DueDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        protected void btnExportCSV_Click(object sender, EventArgs e)
        {
            var startDate = !string.IsNullOrEmpty(txtStartDate.Text) ?
                DateTime.Parse(txtStartDate.Text) : DateTime.Now.AddMonths(-6);
            var endDate = !string.IsNullOrEmpty(txtEndDate.Text) ?
                DateTime.Parse(txtEndDate.Text) : DateTime.Now;

            StringBuilder csv = new StringBuilder();

            // Member Statistics
            csv.AppendLine("Member Statistics");
            var memberStats = GetMemberStatistics();
            csv.AppendLine("Active Members,Inactive Members");
            csv.AppendLine($"{memberStats[0]},{memberStats[1]}");
            csv.AppendLine();

            // Top Borrowers
            csv.AppendLine("Top Borrowers");
            var topBorrowers = GetTopBorrowers(startDate, endDate);
            csv.AppendLine("Member Name,Books Borrowed");
            for (int i = 0; i < topBorrowers.Item1.Length; i++)
            {
                csv.AppendLine($"{topBorrowers.Item1[i]},{topBorrowers.Item2[i]}");
            }
            csv.AppendLine();

            // Popular Books
            csv.AppendLine("Popular Books");
            var popularBooks = GetPopularBooks(startDate, endDate);
            csv.AppendLine("Book Title,Times Borrowed");
            for (int i = 0; i < popularBooks.Item1.Length; i++)
            {
                csv.AppendLine($"{popularBooks.Item1[i]},{popularBooks.Item2[i]}");
            }

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("content-disposition", "attachment;filename=LibraryReport.csv");
            Response.Write(csv.ToString());
            Response.End();
        }

        private void RegisterChartData(string chartId, object data)
        {
            string script = $"document.addEventListener('DOMContentLoaded', function() {{ " +
                          $"LibraryCharts.init{chartId}({JsonConvert.SerializeObject(data)}); }});";
            ScriptManager.RegisterStartupScript(this, GetType(), $"init{chartId}", script, true);
        }

        private void RegisterChartData(string chartId, object labels, object data)
        {
            string script = $"document.addEventListener('DOMContentLoaded', function() {{ " +
                          $"LibraryCharts.init{chartId}({JsonConvert.SerializeObject(labels)}, " +
                          $"{JsonConvert.SerializeObject(data)}); }});";
            ScriptManager.RegisterStartupScript(this, GetType(), $"init{chartId}", script, true);
        }

        private void AddPDFSection(Document document, string title, object data)
        {
            document.Add(new Paragraph(title));
            PdfPTable table = new PdfPTable(2);
            table.AddCell("Name");
            table.AddCell("Value");

            if (data is Tuple<string[], int[]> tupleData)
            {
                for (int i = 0; i < tupleData.Item1.Length; i++)
                {
                    table.AddCell(tupleData.Item1[i]);
                    table.AddCell(tupleData.Item2[i].ToString());
                }
            }
            else if (data is int[] arrayData)
            {
                table.AddCell("Active");
                table.AddCell(arrayData[0].ToString());
                table.AddCell("Inactive");
                table.AddCell(arrayData[1].ToString());
            }

            document.Add(table);
            document.Add(new Paragraph("\n"));
        }

        private void AddExcelWorksheet(XLWorkbook workbook, string sheetName, object data)
        {
            var worksheet = workbook.Worksheets.Add(sheetName);
            worksheet.Cell(1, 1).Value = "Name";
            worksheet.Cell(1, 2).Value = "Value";

            if (data is Tuple<string[], int[]> tupleData)
            {
                for (int i = 0; i < tupleData.Item1.Length; i++)
                {
                    worksheet.Cell(i + 2, 1).Value = tupleData.Item1[i];
                    worksheet.Cell(i + 2, 2).Value = tupleData.Item2[i];
                }
            }
            else if (data is int[] arrayData)
            {
                worksheet.Cell(2, 1).Value = "Active";
                worksheet.Cell(2, 2).Value = arrayData[0];
                worksheet.Cell(3, 1).Value = "Inactive";
                worksheet.Cell(3, 2).Value = arrayData[1];
            }

            worksheet.Columns().AdjustToContents();
        }
    }
}