<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 20/08/2025
  Time: 09:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("CUSTOMER")) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Customer Profile - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Customer Profile</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <% Customer customer = (Customer) request.getAttribute("customer"); %>
    <div class="card w-50 mx-auto">
        <div class="card-body">
            <h5 class="card-title">Profile Details</h5>
            <p class="card-text"><strong>Account Number:</strong> <%= customer.getAccountNumber() %></p>
            <p class="card-text"><strong>Name:</strong> <%= customer.getName() %></p>
            <p class="card-text"><strong>Address:</strong> <%= customer.getAddress() %></p>
            <p class="card-text"><strong>Telephone:</strong> <%= customer.getTelephone() %></p>
            <p class="card-text"><strong>Units Consumed:</strong> <%= customer.getUnitsConsumed() %></p>
            <a href="customer-bills" class="btn btn-primary">View Bills</a>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
