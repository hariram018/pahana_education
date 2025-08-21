<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 16/08/2025
  Time: 20:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Edit Customer - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Edit Customer</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <% Customer customer = (Customer) request.getAttribute("customer"); %>
    <form action="../edit" method="post" class="w-50 mx-auto" id="editCustomerForm">
        <input type="hidden" name="accountNumber" value="<%= customer.getAccountNumber() %>">
        <div class="mb-3">
            <label for="name" class="form-label">Name</label>
            <input type="text" class="form-control" id="name" name="name" value="<%= customer.getName() %>" required>
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <input type="text" class="form-control" id="address" name="address" value="<%= customer.getAddress() %>" required>
        </div>
        <div class="mb-3">
            <label for="telephone" class="form-label">Telephone</label>
            <input type="text" class="form-control" id="telephone" name="telephone" value="<%= customer.getTelephone() %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Update Customer</button>
        <a href="../customers" class="btn btn-secondary">Cancel</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('editCustomerForm').addEventListener('submit', function(e) {
        const telephone = document.getElementById('telephone').value;

        if (!telephone.match(/^\d+$/)) {
            alert('Telephone must contain only digits');
            e.preventDefault();
        }
    });
</script>
</body>
</html>
