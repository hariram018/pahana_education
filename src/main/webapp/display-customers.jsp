<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Customer, java.util.Collection" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("username") == null ||
            !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
        response.sendRedirect("login");
        return;
    }
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    Customer editCustomer = (Customer) request.getAttribute("customer");
    Collection<Customer> customers = (Collection<Customer>) request.getAttribute("customers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customers - Pahana Edu Bookshop</title>
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

        .is-invalid {
            border-color: var(--danger);
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/customers">
                    <i class="fas fa-users"></i>
                    <span>Manage Customers</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/items">
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
            <input type="text" class="form-control" placeholder="Search customers...">
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
        <h1 class="page-title">Customer Management</h1>
        <a href="#" class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
            <i class="fas fa-plus me-2"></i>Add New Customer
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
                <th>Account Number</th>
                <th>Username</th>
                <th>Name</th>
                <th>Address</th>
                <th>Telephone</th>
                <th>Units Consumed</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (customers != null) { %>
            <% for (Customer customer : customers) { %>
            <tr>
                <td><strong><%= customer.getAccountNumber() %></strong></td>
                <td><%= customer.getUsername() %></td>
                <td><%= customer.getName() %></td>
                <td><%= customer.getAddress() %></td>
                <td><%= customer.getTelephone() %></td>
                <td><span class="badge bg-primary"><%= customer.getUnitsConsumed() %></span></td>
                <td>
                    <a href="#" class="btn btn-action btn-edit" data-bs-toggle="modal" data-bs-target="#editCustomerModal"
                       data-account-number="<%= customer.getAccountNumber() %>"
                       data-username="<%= customer.getUsername() %>"
                       data-name="<%= customer.getName() %>"
                       data-address="<%= customer.getAddress() %>"
                       data-telephone="<%= customer.getTelephone() %>"
                       data-units-consumed="<%= customer.getUnitsConsumed() %>">
                        <i class="fas fa-edit me-1"></i>Edit
                    </a>
                    <a href="customers/delete/<%= customer.getAccountNumber() %>" class="btn btn-action btn-delete"
                       onclick="return confirm('Are you sure you want to delete this customer?')">
                        <i class="fas fa-trash me-1"></i>Delete
                    </a>
                </td>
            </tr>
            <% } %>
            <% } %>
            </tbody>
        </table>
    </div>

    <a href="dashboard.jsp" class="btn btn-back">
        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
    </a>
</div>

<!-- Add Customer Modal -->
<div class="modal fade <%= errors != null && editCustomer == null ? "show d-block" : "" %>" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCustomerModalLabel">Add New Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addCustomerForm" action="${pageContext.request.contextPath}/customers/add" method="post">
                    <div class="mb-3">
                        <label for="addAccountNumber" class="form-label">Account Number</label>
                        <input type="text" class="form-control <%= errors != null && errors.containsKey("accountNumber") ? "is-invalid" : "" %>" id="addAccountNumber" name="accountNumber" value="<%= request.getParameter("accountNumber") != null ? request.getParameter("accountNumber") : "" %>" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("accountNumber", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addUsername" class="form-label">Username</label>
                        <input type="text" class="form-control <%= errors != null && errors.containsKey("username") ? "is-invalid" : "" %>" id="addUsername" name="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("username", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addPassword" class="form-label">Password</label>
                        <input type="password" class="form-control <%= errors != null && errors.containsKey("password") ? "is-invalid" : "" %>" id="addPassword" name="password" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("password", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addName" class="form-label">Full Name</label>
                        <input type="text" class="form-control <%= errors != null && errors.containsKey("name") ? "is-invalid" : "" %>" id="addName" name="name" value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("name", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addAddress" class="form-label">Address</label>
                        <textarea class="form-control <%= errors != null && errors.containsKey("address") ? "is-invalid" : "" %>" id="addAddress" name="address" rows="2"><%= request.getParameter("address") != null ? request.getParameter("address") : "" %></textarea>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("address", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="addTelephone" class="form-label">Telephone</label>
                        <input type="tel" class="form-control <%= errors != null && errors.containsKey("telephone") ? "is-invalid" : "" %>" id="addTelephone" name="telephone" value="<%= request.getParameter("telephone") != null ? request.getParameter("telephone") : "" %>">
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("telephone", "") : "" %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Customer Modal -->
<div class="modal fade <%= editCustomer != null && errors != null ? "show d-block" : "" %>" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editCustomerModalLabel">Edit Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editCustomerForm" action="${pageContext.request.contextPath}/customers/edit" method="post">
                    <input type="hidden" id="editAccountNumber" name="accountNumber" value="<%= editCustomer != null ? editCustomer.getAccountNumber() : "" %>">
                    <div class="mb-3">
                        <label for="editUsername" class="form-label">Username</label>
                        <input type="text" class="form-control" id="editUsername" name="username" value="<%= editCustomer != null ? editCustomer.getUsername() : "" %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editName" class="form-label">Full Name</label>
                        <input type="text" class="form-control <%= errors != null && errors.containsKey("name") ? "is-invalid" : "" %>" id="editName" name="name" value="<%= editCustomer != null ? editCustomer.getName() : (request.getParameter("name") != null ? request.getParameter("name") : "") %>" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("name", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editAddress" class="form-label">Address</label>
                        <textarea class="form-control <%= errors != null && errors.containsKey("address") ? "is-invalid" : "" %>" id="editAddress" name="address" rows="2"><%= editCustomer != null ? editCustomer.getAddress() : (request.getParameter("address") != null ? request.getParameter("address") : "") %></textarea>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("address", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editTelephone" class="form-label">Telephone</label>
                        <input type="tel" class="form-control <%= errors != null && errors.containsKey("telephone") ? "is-invalid" : "" %>" id="editTelephone" name="telephone" value="<%= editCustomer != null ? editCustomer.getTelephone() : (request.getParameter("telephone") != null ? request.getParameter("telephone") : "") %>">
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("telephone", "") : "" %>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editUnitsConsumed" class="form-label">Units Consumed</label>
                        <input type="number" class="form-control <%= errors != null && errors.containsKey("unitsConsumed") ? "is-invalid" : "" %>" id="editUnitsConsumed" name="unitsConsumed" value="<%= editCustomer != null ? editCustomer.getUnitsConsumed() : (request.getParameter("unitsConsumed") != null ? request.getParameter("unitsConsumed") : "0") %>" min="0" required>
                        <div class="invalid-feedback">
                            <%= errors != null ? errors.getOrDefault("unitsConsumed", "") : "" %>
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
            const modal = document.getElementById('editCustomerModal');
            const accountNumber = this.getAttribute('data-account-number');
            const username = this.getAttribute('data-username');
            const name = this.getAttribute('data-name');
            const address = this.getAttribute('data-address');
            const telephone = this.getAttribute('data-telephone');
            const unitsConsumed = this.getAttribute('data-units-consumed');

            modal.querySelector('#editAccountNumber').value = accountNumber;
            modal.querySelector('#editUsername').value = username;
            modal.querySelector('#editName').value = name;
            modal.querySelector('#editAddress').value = address;
            modal.querySelector('#editTelephone').value = telephone;
            modal.querySelector('#editUnitsConsumed').value = unitsConsumed;
        });
    });

    // Show modals if errors exist
    <% if (errors != null) { %>
    <% if (editCustomer != null) { %>
    new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
    <% } else { %>
    new bootstrap.Modal(document.getElementById('addCustomerModal')).show();
    <% } %>
    <% } %>
</script>
</body>
</html>