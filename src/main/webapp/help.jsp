<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 20/08/2025
  Time: 09:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }
%>
<html>
<head>
  <title>Help - Pahana Edu Bookshop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
  <h2 class="text-center">Help</h2>
  <ul class="list-group">
    <li class="list-group-item">Login: Use your username and password to access the system.</li>
    <li class="list-group-item">Admin: Manage customers, items, bills, and reports.</li>
    <li class="list-group-item">Customer: View profile and bills.</li>
    <li class="list-group-item">Logout: Save data and exit.</li>
  </ul>
  <a href="<%= ((List<String>) session.getAttribute("roles")).contains("ADMIN") ? "dashboard.jsp" : "customer-profile" %>" class="btn btn-secondary mt-3">Back</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
