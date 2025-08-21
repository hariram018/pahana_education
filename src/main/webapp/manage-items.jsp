<%--
  Created by IntelliJ IDEA.
  User: harir
  Date: 20/08/2025
  Time: 09:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Item, java.util.Collection" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
        response.sendRedirect("login");
        return;
    }
    // Safely retrieve errors attribute
    Map<String, String> errors = null;
    Object errorsObj = request.getAttribute("errors");
    if (errorsObj instanceof Map) {
        errors = (Map<String, String>) errorsObj;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Items - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --accent: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --success: #4cc9f0;
            --warning: #f7b801;
            --danger: #f72585;
            --sidebar-width: 250px;
            --header-height: 70px;
            --card-border-radius: 15px;
            --transition: all 0.3s ease;
        }

        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        #sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: linear-gradient(to bottom, var(--primary), var(--secondary));
            color: white;
            transition: var(--transition);
            z-index: 1000;
            box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1);
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            font-weight: 700;
            margin: 0;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            margin: 5px 0;
            border-left: 3px solid transparent;
            transition: var(--transition);
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            border-left: 3px solid white;
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        #content {
            margin-left: var(--sidebar-width);
            transition: var(--transition);
            padding: 20px;
        }

        #header {
            height: var(--header-height);
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            position: sticky;
            top: 0;
            z-index: 100;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .search-bar {
            width: 300px;
            position: relative;
        }

        .search-bar input {
            padding-left: 40px;
            border-radius: 20px;
        }

        .search-bar i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-title {
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        .btn-add {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            color: white;
            transition: var(--transition);
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
        }

        .table-container {
            background: white;
            border-radius: var(--card-border-radius);
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            border: none;
            padding: 15px;
            font-weight: 600;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-color: #f1f3f7;
        }

        .table tbody tr {
            transition: var(--transition);
        }

        .table tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }

        .btn-action {
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 14px;
            transition: var(--transition);
        }

        .btn-edit {
            background: rgba(73, 149, 239, 0.1);
            color: var(--accent);
            border: 1px solid rgba(73, 149, 239, 0.2);
        }

        .btn-edit:hover {
            background: var(--accent);
            color: white;
        }

        .btn-delete {
            background: rgba(247, 37, 133, 0.1);
            color: var(--danger);
            border: 1px solid rgba(247, 37, 133, 0.2);
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
        }

        .alert-success {
            background: rgba(76, 201, 240, 0.1);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .alert-danger {
            background: rgba(247, 37, 133, 0.1);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        .btn-back {
            background: #f8f9fa;
            color: #6c757d;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 10px 20px;
            transition: var(--transition);
            margin-top: 20px;
        }

        .btn-back:hover {
            background: #e9ecef;
            color: var(--dark);
        }

        .invalid-feedback {
            font-size: 0.875rem;
            color: var(--danger);
        }

        @media (max-width: 992px) {
            #sidebar {
                width: 70px;
                text-align: center;
            }

            .sidebar-header h3 {
                display: none;
            }

            .nav-link span {
                display: none;
            }

            .nav-link i {
                margin-right: 0;
                font-size: 20px;
            }

            #content {
                margin-left: 70px;
            }
        }

        @media (max-width: 768px) {
            #sidebar {
                width: 0;
                overflow: hidden;
            }

            #content {
                margin-left: 0;
            }

            .search-bar {
                width: 200px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .table-container {
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav id="sidebar">
    <div class="sidebar-header">
        <h3>Pahana Edu</h3>
    </div>
    <div class="sidebar-menu">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/customers">
                    <i class="fas fa-users"></i>
                    <span>Manage Customers</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/items">
                    <i class="fas fa-book"></i>
                    <span>Manage Items</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/bills">
                    <i class="fas fa-receipt"></i>
                    <span>Manage Bills</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/reports">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reports</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/help">
                    <i class="fas fa-question-circle"></i>
                    <span>Help</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
</nav>

<!-- Main Content -->
<div id="content">
    <!-- Header -->
    <header id="header">
        <div class="menu-toggle">
            <i class="fas fa-bars"></i>
        </div>
        <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" class="form-control" placeholder="Search items...">
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=Admin+User&background=4361ee&color=fff" alt="User">
            <div>
                <div class="fw-bold">Admin User</div>
                <small class="text-muted">Administrator</small>
            </div>
        </div>
    </header>

    <!-- Page Content -->
    <div class="page-header">
        <h1 class="page-title">Item Management</h1>
        <a href="#" class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addItemModal">
            <i class="fas fa-plus me-2"></i>Add New Item
        </a>
    </div>

    <% if (session.getAttribute("message") != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle me-2"></i><%= session.getAttribute("message") %>
        <% session.removeAttribute("message"); %>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="table-container">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>Item ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Stock Quantity</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (Item item : (Collection<Item>) request.getAttribute("items")) { %>
            <tr>
                <td><strong><%= item.getItemId() %></strong></td>
                <td><%= item.getName() %></td>
                <td><%= String.format("%.2f", item.getPrice()) %></td>
                <td><span class="badge bg-primary"><%= item.getStockQuantity() %></span></td>
                <td>
                    <a href="#" class="btn btn-action btn-edit" data-bs-toggle="modal" data-bs-target="#editItemModal"
                       data-item-id="<%= item.getItemId() %>"
                       data-name="<%= item.getName() %>"
                       data-price="<%= item.getPrice() %>"
                       data-stock-quantity="<%= item.getStockQuantity() %>">
                        <i class="fas fa-edit me-1"></i>Edit
                    </a>
                    <a href="items/delete/<%= item.getItemId() %>" class="btn btn-action btn-delete"
                       onclick="return confirm('Are you sure you want to delete this item?')">
                        <i class="fas fa-trash me-1"></i>Delete
                    </a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <a href="dashboard.jsp" class="btn btn-back">
        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
    </a>
</div>

<!-- Add Item Modal -->
<div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addItemForm" action="${pageContext.request.contextPath}/items/add" method="post">
                    <div class="mb-3">
                        <label for="addItemId" class="form-label">Item ID</label>
                        <input type="text" class="form-control" id="addItemId" name="itemId" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("itemId", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addName" class="form-label">Name</label>
                        <input type="text" class="form-control" id="addName" name="name" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("name", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addPrice" class="form-label">Price</label>
                        <input type="number" step="0.01" class="form-control" id="addPrice" name="price" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("price", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addStockQuantity" class="form-label">Stock Quantity</label>
                        <input type="number" class="form-control" id="addStockQuantity" name="stockQuantity" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("stockQuantity", "") : "" %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Item</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Item Modal -->
<div class="modal fade" id="editItemModal" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editItemModalLabel">Edit Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editItemForm" action="${pageContext.request.contextPath}/items/edit" method="post">
                    <input type="hidden" id="editItemId" name="itemId">
                    <div class="mb-3">
                        <label for="editName" class="form-label">Name</label>
                        <input type="text" class="form-control" id="editName" name="name" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("name", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editPrice" class="form-label">Price</label>
                        <input type="number" step="0.01" class="form-control" id="editPrice" name="price" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("price", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editStockQuantity" class="form-label">Stock Quantity</label>
                        <input type="number" class="form-control" id="editStockQuantity" name="stockQuantity" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("stockQuantity", "") : "" %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle sidebar on small screens
    document.querySelector('.menu-toggle').addEventListener('click', function() {
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('content');

        if (window.innerWidth < 768) {
            if (sidebar.style.width === '250px') {
                sidebar.style.width = '0';
                content.style.marginLeft = '0';
            } else {
                sidebar.style.width = '250px';
                content.style.marginLeft = '250px';
            }
        } else {
            if (sidebar.style.width === '70px' || sidebar.style.width === '') {
                sidebar.style.width = '250px';
                content.style.marginLeft = '250px';
            } else {
                sidebar.style.width = '70px';
                content.style.marginLeft = '70px';
            }
        }
    });

    // Adjust sidebar on resize
    window.addEventListener('resize', function() {
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('content');

        if (window.innerWidth >= 768 && window.innerWidth < 992) {
            sidebar.style.width = '70px';
            content.style.marginLeft = '70px';
        } else if (window.innerWidth >= 992) {
            sidebar.style.width = '250px';
            content.style.marginLeft = '250px';
        } else {
            sidebar.style.width = '0';
            content.style.marginLeft = '0';
        }
    });

    // Search functionality
    document.querySelector('.search-bar input').addEventListener('keyup', function() {
        const searchText = this.value.toLowerCase();
        const rows = document.querySelectorAll('.table tbody tr');

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchText) ? '' : 'none';
        });
    });

    // Populate Edit Modal
    document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', function() {
            const modal = document.getElementById('editItemModal');
            const itemId = this.getAttribute('data-item-id');
            const name = this.getAttribute('data-name');
            const price = this.getAttribute('data-price');
            const stockQuantity = this.getAttribute('data-stock-quantity');

            modal.querySelector('#editItemId').value = itemId;
            modal.querySelector('#editName').value = name;
            modal.querySelector('#editPrice').value = price;
            modal.querySelector('#editStockQuantity').value = stockQuantity;
        });
    });

    // Show modals if there are errors
    <% if (errors != null) { %>
    <% if (request.getAttribute("item") != null) { %>
    const editModal = new bootstrap.Modal(document.getElementById('editItemModal'));
    editModal.show();
    document.getElementById('editItemId').value = '<%= ((Item) request.getAttribute("item")).getItemId() %>';
    document.getElementById('editName').value = '<%= ((Item) request.getAttribute("item")).getName() %>';
    document.getElementById('editPrice').value = '<%= ((Item) request.getAttribute("item")).getPrice() %>';
    document.getElementById('editStockQuantity').value = '<%= ((Item) request.getAttribute("item")).getStockQuantity() %>';
    <% for (String key : errors.keySet()) { %>
    document.getElementById('edit<%= key.substring(0, 1).toUpperCase() + key.substring(1) %>').classList.add('is-invalid');
    <% } %>
    <% } else { %>
    const addModal = new bootstrap.Modal(document.getElementById('addItemModal'));
    addModal.show();
    <% for (String key : errors.keySet()) { %>
    document.getElementById('add<%= key.substring(0, 1).toUpperCase() + key.substring(1) %>').classList.add('is-invalid');
    <% } %>
    <% } %>
    <% } %>
</script>
</body>
</html>