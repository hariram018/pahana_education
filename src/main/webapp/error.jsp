<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 21/08/2025
  Time: 14:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html><%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Error</h2>
    <div class="alert alert-danger"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "An unexpected error occurred." %></div>
    <a href="login" class="btn btn-primary">Back to Login</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
