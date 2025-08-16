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
<html>
<head>
    <title>Login - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Login</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="login" method="post" class="w-50 mx-auto" id="loginForm">
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary">Login</button>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        if (!username || !password) {
            alert('Username and password are required');
            e.preventDefault();
        }
    });
</script>
</body>
</html>
