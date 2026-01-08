<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="LibraryManagementSystem.Signup" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Library Management System - Sign Up</title>
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
            overflow-x: hidden;
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
        
        .signup-wrapper {
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
        
        .signup-side {
            flex: 1;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .signup-image {
            flex: 1;
            background: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: flex-end;
            padding: 2rem;
            position: relative;
            min-height: 600px;
        }
        
        .signup-image::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 50%);
        }
        
        .signup-image-text {
            color: white;
            z-index: 1;
            max-width: 400px;
        }
        
        .signup-form {
            max-width: 400px;
            width: 100%;
        }
        
        .signup-header {
            margin-bottom: 2rem;
        }
        
        .signup-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--light-color);
            margin-bottom: 0.5rem;
        }
        
        .signup-header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
        }
        
        .form-floating {
            margin-bottom: 1.2rem;
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
        
        .btn-signup {
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            background: linear-gradient(90deg, var(--success-color) 0%, #0d9488 100%);
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }
        
        .btn-signup:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        .btn-signup:active {
            transform: translateY(-1px);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: rgba(255, 255, 255, 0.5);
            z-index: 10;
        }
        
        .password-toggle:hover {
            color: rgba(255, 255, 255, 0.8);
        }
        
        .password-requirements {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .password-requirements h6 {
            color: var(--light-color);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .password-requirements ul {
            list-style: none;
            padding-left: 0;
            margin-bottom: 0;
        }
        
        .password-requirements li {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
        }
        
        .password-requirements li i {
            margin-right: 0.5rem;
            font-size: 0.75rem;
        }
        
        .requirement-met {
            color: var(--success-color);
        }
        
        .requirement-not-met {
            color: rgba(255, 255, 255, 0.5);
        }
        
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
        
        /* Success notification styling */
        .alert-success {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
            background-color: rgba(16, 185, 129, 0.9) !important;
            color: white;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            backdrop-filter: blur(10px);
            min-width: 300px;
            text-align: center;
            justify-content: center;
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
        
        .form-field-wrapper {
            position: relative;
        }
        
        /* Responsive styles */
        @media (max-width: 991.98px) {
            .signup-image {
                display: none;
            }
            
            .signup-side {
                width: 100%;
                align-items: center;
            }
        }
        
        @media (max-width: 575.98px) {
            .signup-side {
                padding: 2rem 1.5rem;
            }
            
            .signup-header h1 {
                font-size: 2rem;
            }
            
            .alert-success {
                width: 90%;
                max-width: 400px;
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
    
    <!-- Success notification panel - IMPORTANT: Placed outside the form -->
    <asp:Panel ID="pnlNotification" runat="server" CssClass="alert alert-success" Visible="false">
        <i class="fas fa-check-circle"></i>
        Signup successful! Redirecting to the login page...
    </asp:Panel>
    
    <div class="container">
        <div class="signup-wrapper">
            <div class="signup-side">
                <form id="form1" runat="server" class="signup-form">
                    <div class="signup-header">
                        <h1><i class="fas fa-book-reader logo"></i> Join Us</h1>
                        <p>Create an account to access our library services</p>
                    </div>
                    
                    <!-- Error message panel -->
                    <asp:Panel ID="errorPanel" runat="server" CssClass="error-message" Visible="false">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>
                    
                    <div class="form-floating">
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"></asp:TextBox>
                        <label for="txtUsername"><i class="fas fa-user me-2"></i>Username</label>
                    </div>
                    
                    <div class="form-floating">
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Full Name"></asp:TextBox>
                        <label for="txtFullName"><i class="fas fa-id-card me-2"></i>Full Name</label>
                    </div>
                    
                    <div class="form-floating">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                        <label for="txtEmail"><i class="fas fa-envelope me-2"></i>Email</label>
                    </div>
                    
                    <div class="form-field-wrapper">
                        <div class="form-floating mb-1">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                            <label for="txtPassword"><i class="fas fa-lock me-2"></i>Password</label>
                            <div class="password-toggle" onclick="togglePasswordVisibility('txtPassword')">
                                <i class="far fa-eye"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
                        <label for="txtConfirmPassword"><i class="fas fa-lock me-2"></i>Confirm Password</label>
                        <div class="password-toggle" onclick="togglePasswordVisibility('txtConfirmPassword')">
                            <i class="far fa-eye"></i>
                        </div>
                    </div>
                    
                    <div class="password-requirements">
                        <h6><i class="fas fa-shield-alt me-2"></i>Password Requirements</h6>
                        <ul>
                            <li id="length" class="requirement-not-met"><i class="far fa-circle"></i>At least 8 characters</li>
                            <li id="uppercase" class="requirement-not-met"><i class="far fa-circle"></i>At least one uppercase letter</li>
                            <li id="lowercase" class="requirement-not-met"><i class="far fa-circle"></i>At least one lowercase letter</li>
                            <li id="number" class="requirement-not-met"><i class="far fa-circle"></i>At least one number</li>
                            <li id="special" class="requirement-not-met"><i class="far fa-circle"></i>At least one special character</li>
                            <li id="match" class="requirement-not-met"><i class="far fa-circle"></i>Passwords match</li>
                        </ul>
                    </div>
                    
                    
                    
                    <!-- Standard button without extra attributes that might interfere -->
                    <asp:Button ID="btnSignUp" runat="server" Text="Sign Up" CssClass="btn-signup" OnClick="btnSignUp_Click" />
                    
                    <div class="text-center mt-3">
                        <span style="color: rgba(255, 255, 255, 0.7);">Already have an account?</span>
                        <a href="Login.aspx" class="ms-2" style="color: var(--primary-color);">Sign In</a>
                    </div>
                    
                    <!-- Hidden Label for compatibility -->
                    <asp:Label ID="Label1" runat="server" CssClass="d-none"></asp:Label>
                </form>
            </div>
            
            <div class="signup-image">
                <div class="signup-image-text">
                    <h2 class="text-white mb-4">Library Management System</h2>
                    
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Check for error message and show panel if needed
            var lblMessage = document.getElementById('<%= lblMessage.ClientID %>');
            var errorPanel = document.getElementById('<%= errorPanel.ClientID %>');

            if (lblMessage && lblMessage.innerHTML.trim() !== '') {
                if (errorPanel) {
                    errorPanel.style.display = 'flex';
                    errorPanel.style.visibility = 'visible';
                }
            }

            // Password validation
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            
            if (password && confirmPassword) {
                function checkPasswordRequirements() {
                    var value = password.value;
                    var confirmValue = confirmPassword.value;
                    
                    // Check requirements
                    var hasLength = value.length >= 8;
                    var hasUppercase = /[A-Z]/.test(value);
                    var hasLowercase = /[a-z]/.test(value);
                    var hasNumber = /[0-9]/.test(value);
                    var hasSpecial = /[^A-Za-z0-9]/.test(value);
                    var passwordsMatch = value === confirmValue && value.length > 0;
                    
                    // Update UI
                    updateRequirement('length', hasLength);
                    updateRequirement('uppercase', hasUppercase);
                    updateRequirement('lowercase', hasLowercase);
                    updateRequirement('number', hasNumber);
                    updateRequirement('special', hasSpecial);
                    updateRequirement('match', passwordsMatch);
                }
                
                function updateRequirement(id, isMet) {
                    var element = document.getElementById(id);
                    if (!element) return;
                    
                    if (isMet) {
                        element.classList.remove('requirement-not-met');
                        element.classList.add('requirement-met');
                        element.querySelector('i').className = 'fas fa-check-circle';
                    } else {
                        element.classList.remove('requirement-met');
                        element.classList.add('requirement-not-met');
                        element.querySelector('i').className = 'far fa-circle';
                    }
                }
                
                password.addEventListener('input', checkPasswordRequirements);
                confirmPassword.addEventListener('input', checkPasswordRequirements);
            }
            
            // Terms checkbox validation
            
            
            
            
            // Check if notification is visible (success case)
            var notification = document.getElementById('<%= pnlNotification.ClientID %>');
            if (notification && notification.style.display !== 'none') {
                console.log("Success notification is visible!");
            }
        });

        // Toggle password visibility
        function togglePasswordVisibility(controlId) {
            var passwordInput = document.getElementById(controlId);
            if (!passwordInput) return;

            var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            var icon = event.currentTarget.querySelector('i');
            if (type === 'password') {
                icon.className = 'far fa-eye';
            } else {
                icon.className = 'far fa-eye-slash';
            }
        }
    </script>
</body>
</html>