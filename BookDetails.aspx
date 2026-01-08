<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookDetails.aspx.cs" Inherits="LMSPJ.BookDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary-color: #2c3e50;
            --primary-light: #3b82f6;
            --primary-dark: #1d4ed8;
            --accent-color: #8b5cf6;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --neutral-50: #f8fafc;
            --neutral-100: #f1f5f9;
            --neutral-200: #e2e8f0;
            --neutral-300: #cbd5e1;
            --neutral-600: #475569;
            --neutral-700: #334155;
            --neutral-900: #0f172a;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInUp {
            from {
                transform: translateY(30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        @keyframes slideInRight {
            from {
                transform: translateX(30px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideInLeft {
            from {
                transform: translateX(-30px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @keyframes shimmer {
            0% { background-position: -1000px 0; }
            100% { background-position: 1000px 0; }
        }

        .page-container {
            max-width: 900px;
            margin: 3rem auto;
            padding: 0 1.5rem;
            animation: fadeIn 0.8s ease forwards;
        }

        .book-details-card {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--neutral-200);
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        .book-details-card:hover {
            box-shadow: var(--shadow-xl), 0 0 0 5px rgba(37, 99, 235, 0.1);
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to right,
                rgba(255, 255, 255, 0) 0%,
                rgba(255, 255, 255, 0.3) 50%,
                rgba(255, 255, 255, 0) 100%
            );
            transform: rotate(45deg);
            animation: shimmer 3s infinite linear;
            pointer-events: none;
        }

        .header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            animation: slideInUp 0.6s ease forwards;
        }

        .header-title {
            color: white;
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header-title i {
            font-size: 1.5rem;
            background: white;
            color: var(--primary-color);
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
        }

        .header-title:hover i {
            transform: rotate(15deg);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1.5rem;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            color: white;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-5px);
        }

        .btn-back i {
            transition: transform 0.3s ease;
        }

        .btn-back:hover i {
            transform: translateX(-5px);
        }

        .card-body {
            padding: 2.5rem;
        }

        .book-cover {
            width: 180px;
            height: 250px;
            background: linear-gradient(135deg, var(--neutral-200), var(--neutral-100));
            border-radius: 8px;
            box-shadow: var(--shadow-lg);
            margin-bottom: 2rem;
            overflow: hidden;
            position: relative;
            animation: slideInLeft 0.8s ease forwards;
            transition: all 0.3s ease;
        }

        .book-cover:hover {
            transform: translateY(-8px) rotate(2deg);
            box-shadow: var(--shadow-xl);
        }

        .book-cover-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: var(--neutral-600);
        }

        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .book-content {
            display: flex;
            gap: 2.5rem;
        }

        .book-info {
            flex: 1;
        }

        .book-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--neutral-900);
            margin: 0 0 0.5rem 0;
            animation: slideInRight 0.6s ease forwards;
        }

        .book-author {
            font-size: 1.1rem;
            color: var(--primary-color);
            margin: 0 0 1.5rem 0;
            font-weight: 500;
            animation: slideInRight 0.7s ease forwards;
        }

        .detail-group {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            animation: fadeIn 0.8s ease forwards;
            animation-delay: calc(var(--item-index) * 0.1s);
            opacity: 0;
        }

        .label-text {
            font-size: 0.875rem;
            color: var(--neutral-600);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .label-text i {
            color: var(--primary-light);
        }

        .detail-value {
            font-size: 1.1rem;
            color: var(--neutral-900);
            font-weight: 600;
            padding: 0.5rem 0;
            border-bottom: 2px solid var(--neutral-100);
            transition: all 0.3s ease;
        }

        .detail-item:hover .detail-value {
            border-bottom-color: var(--primary-light);
            transform: translateX(5px);
        }

        .availability-indicator {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin: 1.5rem 0;
            padding: 1rem;
            border-radius: 12px;
            background: var(--neutral-50);
            border: 1px solid var(--neutral-200);
            animation: slideInUp 0.8s ease forwards;
            transition: all 0.3s ease;
        }

        .availability-indicator:hover {
            background: white;
            box-shadow: var(--shadow-md);
            transform: translateY(-3px);
        }

        .availability-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        .status-available {
            color: var(--success-color);
        }

        .status-limited {
            color: var(--warning-color);
        }

        .status-unavailable {
            color: var(--danger-color);
        }

        .availability-count {
            margin-left: auto;
            background: var(--primary-light);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .availability-indicator:hover .availability-count {
            transform: scale(1.1);
            background: var(--primary-dark);
        }

        .category-chain {
            margin-top: 2rem;
            padding: 1.25rem;
            border-radius: 12px;
            background: var(--neutral-50);
            border: 1px solid var(--neutral-200);
            font-size: 0.95rem;
            color: var(--neutral-700);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideInUp 1s ease forwards;
            transition: all 0.3s ease;
        }

        .category-chain:hover {
            background: white;
            box-shadow: var(--shadow-md);
        }

        .category-chain i {
            color: var(--primary-color);
        }

        .category-item {
            display: inline-flex;
            align-items: center;
        }

        .category-item:not(:last-child)::after {
            content: '›';
            margin: 0 0.5rem;
            color: var(--neutral-300);
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            animation: slideInUp 1.2s ease forwards;
        }

        .btn {
            padding: 0.85rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            font-size: 1rem;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-secondary {
            background: white;
            color: var(--neutral-700);
            border: 1px solid var(--neutral-300);
            box-shadow: var(--shadow-sm);
        }

        .btn-secondary:hover {
            background: var(--neutral-50);
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .btn i {
            transition: transform 0.3s ease;
        }

        .btn:hover i {
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .book-content {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .book-cover {
                margin-bottom: 1.5rem;
            }

            .detail-group {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }
            
            .card-header {
                padding: 1.5rem;
            }
            
            .card-body {
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .header-title {
                font-size: 1.5rem;
            }
            
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn-back {
                align-self: flex-start;
            }
        }
    </style>

    <div class="page-container">
        <div class="book-details-card">
            <div class="card-header">
                <div class="header-content">
                    <h4 class="header-title">
                        <i class="fas fa-book"></i>
                        Book Details
                    </h4>
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Back to Books
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="book-content">
                   
                    
                    <div class="book-info">
                        <h2 class="book-title">
                            <asp:Label ID="lblTitle" runat="server"></asp:Label>
                        </h2>
                        <p class="book-author">by 
                            <asp:Label ID="lblAuthor" runat="server"></asp:Label>
                        </p>
                        
                        <div class="detail-group">
                            <div class="detail-item" style="--item-index: 1">
                                <span class="label-text">
                                    <i class="fas fa-building"></i>
                                    Publisher
                                </span>
                                <asp:Label ID="lblPublisher" runat="server" CssClass="detail-value"></asp:Label>
                            </div>
                            <div class="detail-item" style="--item-index: 2">
                                <span class="label-text">
                                    <i class="fas fa-barcode"></i>
                                    ISBN
                                </span>
                                <asp:Label ID="lblISBN" runat="server" CssClass="detail-value"></asp:Label>
                            </div>
                            <div class="detail-item" style="--item-index: 3">
                                <span class="label-text">
                                    <i class="fas fa-calendar-alt"></i>
                                    Publication Year
                                </span>
                                <asp:Label ID="lblPublicationYear" runat="server" CssClass="detail-value"></asp:Label>
                            </div>
                            <div class="detail-item" style="--item-index: 4">
                                <span class="label-text">
                                    <i class="fas fa-calendar-plus"></i>
                                    Added Date
                                </span>
                                <asp:Label ID="lblAddedDate" runat="server" CssClass="detail-value"></asp:Label>
                            </div>
                        </div>
                        
                        <div class="availability-indicator">
                            <div class="availability-status">
                                <i id="statusIcon" runat="server" class="fas fa-circle"></i>
                                <span id="statusText" runat="server">Available</span>
                            </div>
                            <div class="availability-count">
                                <asp:Label ID="lblAvailableCopies" runat="server"></asp:Label> / 
                                <asp:Label ID="lblTotalCopies" runat="server"></asp:Label>
                                copies
                            </div>
                        </div>
                        
                        <div class="category-chain">
                            <i class="fas fa-sitemap"></i>
                            <div>
                                <asp:Label ID="lblCategoryChain" runat="server" />
                            </div>
                        </div>
                        
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // On page load
        document.addEventListener("DOMContentLoaded", function() {
            // Set appropriate status class and icon
            const statusText = document.getElementById('<%= statusText.ClientID %>');
            const statusIcon = document.getElementById('<%= statusIcon.ClientID %>');
            const availableCopies = parseInt('<%= lblAvailableCopies.Text %>');
            
            if (availableCopies <= 0) {
                statusText.textContent = "Unavailable";
                statusText.className = "status-unavailable";
                statusIcon.className = "fas fa-times-circle status-unavailable";
            } else if (availableCopies < 3) {
                statusText.textContent = "Limited Availability";
                statusText.className = "status-limited";
                statusIcon.className = "fas fa-exclamation-circle status-limited";
            } else {
                statusText.textContent = "Available";
                statusText.className = "status-available";
                statusIcon.className = "fas fa-check-circle status-available";
            }
            
            // Add animation delays to detail items
            const detailItems = document.querySelectorAll('.detail-item');
            detailItems.forEach((item, index) => {
                item.style.setProperty('--item-index', index + 1);
            });
            
            // Add hover effect to book cover
            const bookCover = document.querySelector('.book-cover');
            if (bookCover) {
                bookCover.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-8px) rotate(2deg)';
                });
                bookCover.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                });
            }
        });
    </script>
</asp:Content>