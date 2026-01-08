<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditBook.aspx.cs" Inherits="LMSPJ.EditBook" %>
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
            --danger-dark: #dc2626;
            --neutral-50: #f8fafc;
            --neutral-100: #f1f5f9;
            --neutral-200: #e2e8f0;
            --neutral-300: #cbd5e1;
            --neutral-400: #94a3b8;
            --neutral-500: #64748b;
            --neutral-600: #475569;
            --neutral-700: #334155;
            --neutral-800: #1e293b;
            --neutral-900: #0f172a;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --transition-default: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        /* Animations */
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

        @keyframes float {
            0% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0); }
        }

        /* Container */
        .container {
            max-width: 1000px;
            margin: 3rem auto;
            padding: 0 1.5rem;
            animation: fadeIn 0.8s ease forwards;
        }

        /* Card */
        .edit-book-card {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--neutral-200);
            overflow: hidden;
            transition: var(--transition-default);
            position: relative;
        }

        .edit-book-card:hover {
            box-shadow: var(--shadow-xl), 0 0 0 5px rgba(37, 99, 235, 0.1);
            transform: translateY(-5px);
        }

        /* Header */
        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            padding: 2rem;
            position: relative;
            overflow: hidden;
            margin-bottom: 1.5rem;
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

        .header-title {
            color: white;
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
            animation: slideInUp 0.6s ease forwards;
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
            transition: var(--transition-default);
        }

        .header-title:hover i {
            transform: rotate(15deg);
        }

        /* Card Body */
        .card-body {
            padding: 0 2.5rem 2.5rem;
        }

        /* Form */
        .form-group {
            margin-bottom: 1.5rem;
            animation: slideInUp 0.6s ease forwards;
            opacity: 0;
            position: relative;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--neutral-800);
            font-size: 0.95rem;
            transition: var(--transition-default);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: var(--primary-light);
            opacity: 0;
            transform: translateX(-10px);
            transition: var(--transition-default);
        }

        .form-group:hover .form-label i {
            opacity: 1;
            transform: translateX(0);
        }

        .form-control {
            width: 100%;
            padding: 0.85rem 1rem;
            font-size: 1rem;
            border: 2px solid var(--neutral-200);
            border-radius: 12px;
            background-color: white;
            transition: var(--transition-default);
            color: var(--neutral-900);
            box-shadow: var(--shadow-sm);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-light);
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
        }

        .form-control:hover:not(:focus) {
            border-color: var(--neutral-400);
        }

        /* Input focus effect */
        .input-focused .form-label {
            color: var(--primary-color);
            transform: translateY(-3px);
        }

        /* Validation */
        .validation-error {
            color: var(--danger-color);
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: block;
            animation: fadeIn 0.3s ease-in-out;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .validation-error::before {
            content: '\f071';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
        }

        /* Invalid input styling */
        .form-control.input-invalid {
            border-color: var(--danger-color);
        }

        .form-control.input-invalid:focus {
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.15);
        }

        /* Input icon indicators */
        .input-icon-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--neutral-400);
            transition: var(--transition-default);
        }

        .input-icon-wrapper:hover .input-icon {
            color: var(--primary-color);
        }

        /* Buttons */
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 3rem;
            animation: slideInUp 0.8s ease forwards;
            animation-delay: 0.7s;
            opacity: 0;
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
            transition: var(--transition-default);
            border: none;
            text-decoration: none;
            font-size: 1rem;
            position: relative;
            overflow: hidden;
        }

        .btn::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 5px;
            height: 5px;
            background: rgba(255, 255, 255, 0.5);
            opacity: 0;
            border-radius: 100%;
            transform: scale(1, 1) translate(-50%);
            transform-origin: 50% 50%;
        }

        .btn:focus:not(:active)::after {
            animation: ripple 1s ease-out;
        }

        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 0.5;
            }
            20% {
                transform: scale(25, 25);
                opacity: 0.5;
            }
            100% {
                opacity: 0;
                transform: scale(40, 40);
            }
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

        .btn-danger {
            background: var(--danger-color);
            color: white;
            box-shadow: 0 4px 6px rgba(239, 68, 68, 0.2);
        }

        .btn-danger:hover {
            background: var(--danger-dark);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(239, 68, 68, 0.3);
        }

        .btn-back {
            background: white;
            color: var(--neutral-700);
            border: 2px solid var(--neutral-200);
            box-shadow: var(--shadow-sm);
        }

        .btn-back:hover {
            background: var(--neutral-50);
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .btn i {
            transition: var(--transition-default);
        }

        .btn:hover i {
            transform: translateY(-2px);
        }

        .btn-back:hover i {
            transform: translateX(-5px);
        }

        /* Floating shapes for visual interest */
        .floating-shape {
            position: absolute;
            opacity: 0.05;
            z-index: 0;
            pointer-events: none;
        }

        .shape-1 {
            top: 10%;
            right: 5%;
            width: 150px;
            height: 150px;
            border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
            background-color: var(--primary-color);
            animation: float 8s ease-in-out infinite;
        }

        .shape-2 {
            bottom: 15%;
            left: 5%;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: var(--accent-color);
            animation: float 6s ease-in-out infinite 1s;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .button-group {
                flex-direction: column;
            }
            
            .card-header {
                padding: 1.5rem;
            }
            
            .card-body {
                padding: 0 1.5rem 1.5rem;
            }
        }
    </style>

    <div class="container">
        <div class="edit-book-card">
            <!-- Floating shapes for visual interest -->
            <div class="floating-shape shape-1"></div>
            <div class="floating-shape shape-2"></div>
            
            <div class="card-header">
                <h4 class="header-title">
                    <i class="fas fa-edit"></i>
                    Edit Book Information
                </h4>
            </div>
            
            <div class="card-body">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtTitle">
                        <i class="fas fa-book"></i> Title
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter book title"></asp:TextBox>
                        <i class="fas fa-heading input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                        CssClass="validation-error" Display="Dynamic" 
                        ErrorMessage="Title is required." />
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtAuthor">
                        <i class="fas fa-user-edit"></i> Author
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control" placeholder="Enter author name"></asp:TextBox>
                        <i class="fas fa-pen-fancy input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAuthor"
                        CssClass="validation-error" Display="Dynamic" 
                        ErrorMessage="Author is required." />
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtISBN">
                        <i class="fas fa-barcode"></i> ISBN
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtISBN" runat="server" CssClass="form-control" placeholder="Enter ISBN number"></asp:TextBox>
                        <i class="fas fa-fingerprint input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtISBN"
                        CssClass="validation-error" Display="Dynamic" 
                        ErrorMessage="ISBN is required." />
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtPublisher">
                        <i class="fas fa-building"></i> Publisher
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtPublisher" runat="server" CssClass="form-control" placeholder="Enter publisher name"></asp:TextBox>
                        <i class="fas fa-landmark input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPublisher"
                        CssClass="validation-error" Display="Dynamic" 
                        ErrorMessage="Publisher is required." />
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="ddlCategory">
                        <i class="fas fa-tags"></i> Category
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                        <i class="fas fa-chevron-down input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategory"
                        CssClass="validation-error" Display="Dynamic" InitialValue="0"
                        ErrorMessage="Please select a category." />
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtTotalCopies">
                        <i class="fas fa-copy"></i> Total Copies
                    </asp:Label>
                    <div class="input-icon-wrapper">
                        <asp:TextBox ID="txtTotalCopies" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter number of copies"></asp:TextBox>
                        <i class="fas fa-sort-numeric-up input-icon"></i>
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTotalCopies"
                        CssClass="validation-error" Display="Dynamic" 
                        ErrorMessage="Total copies is required." />
                    <asp:RangeValidator runat="server" ControlToValidate="txtTotalCopies"
                        CssClass="validation-error" Display="Dynamic" MinimumValue="1" MaximumValue="999999"
                        Type="Integer" ErrorMessage="Please enter a valid number of copies (1-999999)." />
                </div>

                <div class="button-group">
                    <asp:Button ID="btnUpdate" runat="server" Text="Update Book" 
                        CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
                    <asp:Button ID="btnDelete" runat="server" Text="Delete Book" 
                        CssClass="btn btn-danger" OnClick="btnDelete_Click" 
                        OnClientClick="return confirmDelete();" />
                    <a href="javascript:history.back()" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Back
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Wait for document to be ready
        document.addEventListener('DOMContentLoaded', function() {
            // Add focus effects to form controls
            const formControls = document.querySelectorAll('.form-control');
            
            formControls.forEach(control => {
                // Focus event
                control.addEventListener('focus', function() {
                    this.closest('.form-group').classList.add('input-focused');
                });
                
                // Blur event
                control.addEventListener('blur', function() {
                    this.closest('.form-group').classList.remove('input-focused');
                    
                    // Check validation state
                    if (this.value === '' && this.hasAttribute('required')) {
                        this.classList.add('input-invalid');
                    } else {
                        this.classList.remove('input-invalid');
                    }
                });
                
                // Input event
                control.addEventListener('input', function() {
                    if (this.classList.contains('input-invalid') && this.value !== '') {
                        this.classList.remove('input-invalid');
                    }
                });
            });
            
            // Enhanced delete confirmation
            window.confirmDelete = function() {
                return new Promise((resolve) => {
                    // Create modal backdrop
                    const backdrop = document.createElement('div');
                    backdrop.style.position = 'fixed';
                    backdrop.style.top = '0';
                    backdrop.style.left = '0';
                    backdrop.style.width = '100%';
                    backdrop.style.height = '100%';
                    backdrop.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
                    backdrop.style.zIndex = '1000';
                    backdrop.style.display = 'flex';
                    backdrop.style.alignItems = 'center';
                    backdrop.style.justifyContent = 'center';
                    backdrop.style.opacity = '0';
                    backdrop.style.transition = 'opacity 0.3s ease';
                    
                    // Create modal dialog
                    const modal = document.createElement('div');
                    modal.style.backgroundColor = 'white';
                    modal.style.borderRadius = '16px';
                    modal.style.padding = '2rem';
                    modal.style.maxWidth = '400px';
                    modal.style.width = '90%';
                    modal.style.boxShadow = '0 25px 50px -12px rgba(0, 0, 0, 0.25)';
                    modal.style.transform = 'translateY(20px)';
                    modal.style.transition = 'transform 0.3s ease';
                    
                    modal.innerHTML = `
                        <div style="text-align: center; margin-bottom: 1.5rem;">
                            <div style="font-size: 3rem; color: #ef4444; margin-bottom: 1rem;">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <h3 style="margin: 0 0 0.5rem; font-size: 1.5rem; color: #1e293b;">Confirm Deletion</h3>
                            <p style="margin: 0; color: #64748b;">Are you sure you want to delete this book? This action cannot be undone.</p>
                        </div>
                        <div style="display: flex; gap: 1rem;">
                            <button id="cancelDelete" style="flex: 1; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0; background: white; font-weight: 600; cursor: pointer;">Cancel</button>
                            <button id="confirmDelete" style="flex: 1; padding: 0.75rem; border-radius: 8px; border: none; background: #ef4444; color: white; font-weight: 600; cursor: pointer;">Delete</button>
                        </div>
                    `;
                    
                    backdrop.appendChild(modal);
                    document.body.appendChild(backdrop);
                    
                    // Animate in
                    setTimeout(() => {
                        backdrop.style.opacity = '1';
                        modal.style.transform = 'translateY(0)';
                    }, 10);
                    
                    // Handle buttons
                    document.getElementById('cancelDelete').addEventListener('click', function() {
                        closeModal(false);
                    });
                    
                    document.getElementById('confirmDelete').addEventListener('click', function() {
                        closeModal(true);
                    });
                    
                    function closeModal(result) {
                        backdrop.style.opacity = '0';
                        modal.style.transform = 'translateY(20px)';
                        
                        setTimeout(() => {
                            document.body.removeChild(backdrop);
                            resolve(result);
                        }, 300);
                    }
                });
            };
            
            // Add ripple effect to buttons
            const buttons = document.querySelectorAll('.btn');
            
            buttons.forEach(button => {
                button.addEventListener('mousedown', function(e) {
                    const rect = this.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    const ripple = document.createElement('span');
                    ripple.classList.add('ripple');
                    ripple.style.position = 'absolute';
                    ripple.style.width = '1px';
                    ripple.style.height = '1px';
                    ripple.style.borderRadius = '50%';
                    ripple.style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
                    ripple.style.transform = 'scale(0)';
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.style.animation = 'ripple 0.6s linear';
                    ripple.style.opacity = '1';
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });
        });
    </script>
</asp:Content>