<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 20/08/2025
  Time: 10:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Bill, com.pahanaedu.model.Customer, com.pahanaedu.model.Item, com.pahanaedu.dao.DAOFactory, java.util.List" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("CUSTOMER")) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Your Bills - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Your Bills</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } else if (request.getAttribute("info") != null) { %>
    <div class="alert alert-info"><%= request.getAttribute("info") %></div>
    <% } %>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Bill ID</th>
            <th>Items</th>
            <th>Total Amount</th>
        </tr>
        </thead>
        <tbody>
        <% for (Bill bill : (List<Bill>) request.getAttribute("bills")) { %>
        <tr>
            <td><%= bill.getBillId() %></td>
            <td>
                <% for (java.util.Map.Entry<String, Integer> entry : bill.getItems().entrySet()) { %>
                <% Item item = DAOFactory.getItemDAO().getItems().get(entry.getKey()); %>
                <%= item.getName() %> - <%= entry.getValue() %> x <%= String.format("%.2f", item.getPrice()) %> = <%= String.format("%.2f", item.getPrice() * entry.getValue()) %><br>
                <% } %>
            </td>
            <td><%= String.format("%.2f", bill.getTotalAmount()) %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <!-- Pagination -->
    <nav aria-label="Bill pagination">
        <ul class="pagination justify-content-center">
            <% int currentPage = (int) request.getAttribute("currentPage"); %>
            <% int totalPages = (int) request.getAttribute("totalPages"); %>
            <% if (currentPage > 1) { %>
            <li class="page-item">
                <a class="page-link" href="customer-bills?page=<%= currentPage - 1 %>">Previous</a>
            </li>
            <% } %>
            <% for (int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= i == currentPage ? "active" : "" %>">
                <a class="page-link" href="customer-bills?page=<%= i %>"><%= i %></a>
            </li>
            <% } %>
            <% if (currentPage < totalPages) { %>
            <li class="page-item">
                <a class="page-link" href="customer-bills?page=<%= currentPage + 1 %>">Next</a>
            </li>
            <% } %>
        </ul>
    </nav>
    <!-- Menu Options -->
    <div class="d-flex justify-content-center mt-3">
        <% for (com.pahanaedu.servelet.CustomerBillServlet.MenuOption option : (List<com.pahanaedu.servelet.CustomerBillServlet.MenuOption>) request.getAttribute("menuOptions")) { %>
        <a href="<%= option.getUrl() %>" class="btn btn-primary mx-2"><%= option.getLabel() %></a>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>