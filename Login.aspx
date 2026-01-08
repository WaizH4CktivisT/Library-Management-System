<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LibraryManagementSystem.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Library Management System - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        
        :root {
            --primary-color: #6366f1;
            --hover-color: #4f46e5;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
            position: relative;
            overflow: hidden;
        }
        
        /* Animated background elements */
        .bg-animation {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }
        
        .bg-animation li {
            position: absolute;
            display: block;
            list-style: none;
            width: 20px;
            height: 20px;
            background: rgba(255, 255, 255, 0.1);
            animation: animate 25s linear infinite;
            bottom: -150px;
            border-radius: 50%;
        }
        
        .bg-animation li:nth-child(1) {
            left: 25%;
            width: 80px;
            height: 80px;
            animation-delay: 0s;
        }
        
        .bg-animation li:nth-child(2) {
            left: 10%;
            width: 20px;
            height: 20px;
            animation-delay: 2s;
            animation-duration: 12s;
        }
        
        .bg-animation li:nth-child(3) {
            left: 70%;
            width: 20px;
            height: 20px;
            animation-delay: 4s;
        }
        
        .bg-animation li:nth-child(4) {
            left: 40%;
            width: 60px;
            height: 60px;
            animation-delay: 0s;
            animation-duration: 18s;
        }
        
        .bg-animation li:nth-child(5) {
            left: 65%;
            width: 20px;
            height: 20px;
            animation-delay: 0s;
        }
        
        .bg-animation li:nth-child(6) {
            left: 75%;
            width: 110px;
            height: 110px;
            animation-delay: 3s;
        }
        
        .bg-animation li:nth-child(7) {
            left: 35%;
            width: 150px;
            height: 150px;
            animation-delay: 7s;
        }
        
        .bg-animation li:nth-child(8) {
            left: 50%;
            width: 25px;
            height: 25px;
            animation-delay: 15s;
            animation-duration: 45s;
        }
        
        .bg-animation li:nth-child(9) {
            left: 20%;
            width: 15px;
            height: 15px;
            animation-delay: 2s;
            animation-duration: 35s;
        }
        
        .bg-animation li:nth-child(10) {
            left: 85%;
            width: 150px;
            height: 150px;
            animation-delay: 0s;
            animation-duration: 11s;
        }
        
        @keyframes animate {
            0% {
                transform: translateY(0) rotate(0deg);
                opacity: 1;
                border-radius: 0;
            }
            100% {
                transform: translateY(-1000px) rotate(720deg);
                opacity: 0;
                border-radius: 50%;
            }
        }
        
        .container {
            width: 100%;
            max-width: 1200px;
            padding: 0 20px;
            z-index: 10;
        }
        
        .login-wrapper {
            display: flex;
            align-items: stretch;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            max-width: 1000px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .login-side {
            flex: 1;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-image {
            flex: 1;
            background: url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1290&q=80');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: flex-end;
            padding: 2rem;
            position: relative;
            min-height: 500px;
        }
        
        .login-image::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 50%);
        }
        
        .login-image-text {
            color: white;
            z-index: 1;
            max-width: 400px;
        }
        
        .login-form {
            max-width: 400px;
            width: 100%;
        }
        
        .login-header {
            margin-bottom: 2rem;
        }
        
        .login-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--light-color);
            margin-bottom: 0.5rem;
        }
        
        .login-header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
        }
        
        .form-floating {
            margin-bottom: 1.5rem;
        }
        
        .form-floating > .form-control {
            padding: 1.5rem 1rem;
            height: calc(3.5rem + 2px);
            line-height: 1.25;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .form-floating > .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 0.25rem rgba(99, 102, 241, 0.25);
            border-color: var(--primary-color);
        }
        
        .form-floating > label {
            padding: 1rem;
            color: rgba(255, 255, 255, 0.7);
        }
        
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: rgba(255, 255, 255, 0.9);
            transform: scale(0.85) translateY(-0.75rem) translateX(0.15rem);
        }
        
        .form-floating > .form-control::-webkit-input-placeholder {
            color: transparent;
        }
        
        .form-check-input {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .form-check-label {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
        }
        
        .btn-login {
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            background: linear-gradient(90deg, var(--primary-color) 0%, var(--hover-color) 100%);
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.2) 50%, transparent 100%);
            transition: all 0.5s ease;
            z-index: -1;
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        .btn-login:active {
            transform: translateY(-1px);
        }
        
        .login-footer {
            margin-top: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .login-footer a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .login-footer a:hover {
            color: white;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }
        
        .error-message {
            background-color: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            padding: 0.75rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--danger-color);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
        }
        
        .error-message i {
            margin-right: 0.5rem;
            font-size: 1.1rem;
        }
        
        .divider {
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.5);
            margin: 1.5rem 0;
        }
        
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .divider::before {
            margin-right: 1rem;
        }
        
        .divider::after {
            margin-left: 1rem;
        }
        
        .social-login {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .social-btn {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .social-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
        }
        
        .social-btn i {
            font-size: 1.2rem;
        }
        
        .social-btn.google {
            color: #ea4335;
        }
        
        .social-btn.facebook {
            color: #1877f2;
        }
        
        .social-btn.twitter {
            color: #1da1f2;
        }
        
        /* Logo animation */
        .logo {
            display: inline-block;
            margin-right: 0.5rem;
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }
        
        /* Responsive styles */
        @media (max-width: 991.98px) {
            .login-image {
                display: none;
            }
            
            .login-side {
                width: 100%;
                align-items: center;
            }
        }
        
        @media (max-width: 575.98px) {
            .login-side {
                padding: 2rem 1.5rem;
            }
            
            .login-header h1 {
                font-size: 2rem;
            }
            
            .login-footer {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated background elements -->
    <ul class="bg-animation">
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>
    
    <div class="container">
        <div class="login-wrapper">
            <div class="login-side">
                <form id="form1" runat="server" class="login-form">
                    <div class="login-header">
                        <h1><i class="fas fa-book-reader logo"></i> Library</h1>
                        <p>Welcome back! Please login to your account.</p>
                    </div>
                    
                    <!-- Error message panel -->
                    <asp:Panel ID="pnlError" runat="server" CssClass="error-message" Visible="false">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>
                    
                    <div class="form-floating">
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"></asp:TextBox>
                        <label for="<%= txtUsername.ClientID %>"><i class="fas fa-user me-2"></i>Username</label>
                    </div>
                    
                    <div class="form-floating">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <label for="<%= txtPassword.ClientID %>"><i class="fas fa-lock me-2"></i>Password</label>
                    </div>
                    
                   
                    
                    <!-- This is the button that wasn't working - fixed by using UseSubmitBehavior="true" -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" UseSubmitBehavior="true" />
                    
                    
                    
                   
                    
                    <div class="text-center">
                        <span style="color: rgba(255, 255, 255, 0.7);">Don't have an account?</span>
                        <a href="Signup.aspx" class="ms-2">Sign Up</a>
                    </div>
                </form>
            </div>
            
            <div class="login-image">
                <div class="login-image-text">
                    <h2 class="text-white mb-4">Discover a world of knowledge</h2>
                    <p class="text-white-50">Access thousands of books, journals, and resources with our comprehensive library management system.</p>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Display error message if it exists
            const lblMessage = document.getElementById('<%= lblMessage.ClientID %>');
            const pnlError = document.getElementById('<%= pnlError.ClientID %>');
            
            if (lblMessage && lblMessage.innerHTML.trim() !== '') {
                if (pnlError) {
                    pnlError.style.display = 'flex';
                }
            }
            
            // Password visibility toggle functionality
            const togglePassword = document.querySelector('.toggle-password');
            const password = document.getElementById('<%= txtPassword.ClientID %>');
            
            if (togglePassword && password) {
                togglePassword.addEventListener('click', function() {
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);
                    this.classList.toggle('fa-eye');
                    this.classList.toggle('fa-eye-slash');
                });
            }
            
            // Login button animation (without preventing default behavior)
            const loginBtn = document.getElementById('<%= btnLogin.ClientID %>');
            const originalBtnText = loginBtn ? loginBtn.innerHTML : 'Sign In';

            if (loginBtn) {
                // Store original text when clicked
                loginBtn.addEventListener('mousedown', function () {
                    this.setAttribute('data-original-text', this.innerHTML);
                });

                // Show loading state
                loginBtn.addEventListener('click', function () {
                    this.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Signing in...';
                    // Don't prevent default - let the form submit normally
                });
            }
        });
    </script>
</body>
</html>