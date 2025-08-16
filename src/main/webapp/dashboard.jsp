<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 16/08/2025
  Time: 09:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List" %>
<%
  if (session.getAttribute("username") == null ||
          !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
    response.sendRedirect("login");
    return;
  }
%>
<html>
<head>
  <title>Dashboard - Pahana Edu Bookshop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
  <h2 class="text-center">Pahana Edu Bookshop Dashboard</h2>
  <div class="row mt-4">
    <%--        <div class="col-md-4">--%>
    <%--            <a href="customers" class="btn btn-primary w-100 mb-3">Manage Customers</a>--%>
    <%--        </div>--%>
    <%--        <div class="col-md-4">--%>
    <%--            <a href="items" class="btn btn-primary w-100 mb-3">Manage Items</a>--%>
    <%--        </div>--%>
    <%--        <div class="col-md-4">--%>
    <%--            <a href="bills" class="btn btn-primary w-100 mb-3">Create Bill</a>--%>
    <%--        </div>--%>
  </div>
  <div class="row mt-4">
    <%--        <div class="col-md-4">--%>
    <%--            <a href="reports" class="btn btn-primary w-100 mb-3">View Reports</a>--%>
    <%--        </div>--%>
    <%--        <div class="col-md-4">--%>
    <%--            <a href="help" class="btn btn-primary w-100 mb-3">Help</a>--%>
    <%--        </div>--%>
    <div class="col-md-4">
      <a href="logout" class="btn btn-danger w-100 mb-3">Logout</a>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
