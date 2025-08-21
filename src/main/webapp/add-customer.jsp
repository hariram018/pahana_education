<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 16/08/2025
  Time: 20:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Add Customer - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Add New Customer</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="customers/add" method="post" class="w-50 mx-auto" id="customerForm">
        <div class="mb-3">
            <label for="accountNumber" class="form-label">Account Number</label>
            <input type="text" class="form-control" id="accountNumber" name="accountNumber" required>
        </div>
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <div class="mb-3">
            <label for="name" class="form-label">Name</label>
            <input type="text" class="form-control" id="name" name="name" required>
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <input type="text" class="form-control" id="address" name="address" required>
        </div>
        <div class="mb-3">
            <label for="telephone" class="form-label">Telephone</label>
            <input type="text" class="form-control" id="telephone" name="telephone" required>
        </div>
        <div class="mb-3">
            <label for="unitsConsumed" class="form-label">Units Consumed</label>
            <input type="number" class="form-control" id="unitsConsumed" name="unitsConsumed" value="0" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Customer</button>
        <a href="customers" class="btn btn-secondary">Cancel</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('customerForm').addEventListener('submit', function(e) {
        const accountNumber = document.getElementById('accountNumber').value;
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const telephone = document.getElementById('telephone').value;
        const unitsConsumed = document.getElementById('unitsConsumed').value;

        if (!accountNumber.match(/^[A-Z0-9]+$/) ) {
            alert('Account number must be alphanumeric');
            e.preventDefault();
            return;
        }
        if (!username.match(/^[A-Za-z0-9]+$/)) {
            alert('Username must be alphanumeric');
            e.preventDefault();
            return;
        }
        if (password.length < 6) {
            alert('Password must be at least 6 characters');
            e.preventDefault();
            return;
        }
        if (!telephone.match(/^\d+$/)) {
            alert('Telephone must contain only digits');
            e.preventDefault();
            return;
        }
        if (unitsConsumed < 0) {
            alert('Units consumed cannot be negative');
            e.preventDefault();
        }
    });
</script>
</body>
</html>
