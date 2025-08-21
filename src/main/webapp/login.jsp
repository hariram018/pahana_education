<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List"%>
<%
    String username = (String) session.getAttribute("username");
    List<String> roles = (List<String>) session.getAttribute("roles");

    if (username != null && roles != null) {
        if (roles.contains("ADMIN")) {
            response.sendRedirect("dashboard.jsp");
            return;
        } else if (roles.contains("CUSTOMER")) {
            response.sendRedirect("customer-profile.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<div class="animation-container" id="animation-container"></div>

<div class="login-container">
    <div class="login-card">
        <div class="card-header">
            <div class="logo mb-2">Pahana Edu</div>
            <h2>Welcome Back</h2>
        </div>

        <div class="card-body">
            <!-- Error message display -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="login" method="post" id="loginForm">
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                </div>

                <div class="options">
                    <div class="remember">
                        <input type="checkbox" id="remember">
                        <label for="remember">Remember me</label>
                    </div>
                    <a href="#" class="forgot-password">Forgot Password?</a>
                </div>

                <button type="submit" class="btn btn-login">Login</button>

                <div class="signup">
                    Don't have an account? <a href="#">Sign Up</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Background animation
    function createCircle() {
        const container = document.getElementById('animation-container');
        const circle = document.createElement('div');
        circle.classList.add('circle');

        const size = Math.random() * 150 + 50;
        const posX = Math.random() * 100;
        const posY = Math.random() * 100;

        circle.style.width = `${size}px`;
        circle.style.height = `${size}px`;
        circle.style.left = `${posX}%`;
        circle.style.top = `${posY}%`;

        container.appendChild(circle);

        setTimeout(() => {
            circle.remove();
        }, 10000);
    }

    // Create initial circles
    for(let i = 0; i < 5; i++) {
        setTimeout(createCircle, i * 1000);
    }

    // Continue creating circles
    setInterval(createCircle, 2000);

    // Form validation
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        if (!username || !password) {
            e.preventDefault();
            // Create error alert if it doesn't exist
            let errorAlert = document.querySelector('.alert-danger');
            if (!errorAlert) {
                errorAlert = document.createElement('div');
                errorAlert.className = 'alert alert-danger';
                errorAlert.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Username and password are required';
                document.querySelector('.card-body').insertBefore(errorAlert, document.getElementById('loginForm'));
            } else {
                errorAlert.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Username and password are required';
                errorAlert.style.display = 'block';
            }
        }
    });
</script>
</body>
</html>
