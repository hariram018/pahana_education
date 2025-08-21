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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            overflow-x: hidden;
        }

        /* Sidebar styling */
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

        /* Main content */
        #content {
            margin-left: var(--sidebar-width);
            transition: var(--transition);
        }

        /* Header */
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

        /* Dashboard content */
        .dashboard-content {
            padding: 20px;
        }

        .welcome-card {
            background: linear-gradient(120deg, var(--primary), var(--accent));
            color: white;
            border-radius: var(--card-border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        .stat-card {
            background: white;
            border-radius: var(--card-border-radius);
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: var(--transition);
            height: 100%;
            border: none;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }

        .icon-customers {
            background: rgba(76, 201, 240, 0.1);
            color: var(--success);
        }

        .icon-sales {
            background: rgba(247, 37, 133, 0.1);
            color: var(--danger);
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-title {
            color: #6c757d;
            font-weight: 500;
        }

        /* Alert styling */
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
        }

        .alert-danger {
            background: rgba(247, 37, 133, 0.1);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        /* Responsive adjustments */
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
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
            <input type="text" class="form-control" placeholder="Search...">
        </div>

        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=Admin+User&background=4361ee&color=fff" alt="User">
            <div>
                <div class="fw-bold">Admin User</div>
                <small class="text-muted">Administrator</small>
            </div>
        </div>
    </header>

    <!-- Dashboard Content -->
    <div class="dashboard-content">
        <div class="welcome-card">
            <h2>Welcome back, Admin!</h2>
            <p class="mb-0">Here's what's happening with your bookshop today.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-customers">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-value">${totalCustomers}</div>
                    <div class="stat-title">Total Customers</div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-sales">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-value">$${String.format("%.2f", totalSales)}</div>
                    <div class="stat-title">Total Sales</div>
                </div>
            </div>
        </div>

        <!-- Additional dashboard content can be added here -->
        <div class="row mt-4 g-4">
            <div class="col-12">
                <div class="stat-card">
                    <h4 class="mb-4">Recent Activity</h4>
                    <div class="d-flex align-items-center mb-3">
                        <div class="bg-light rounded p-3 me-3">
                            <i class="fas fa-user-plus text-success"></i>
                        </div>
                        <div>
                            <div>New customer registered</div>
                            <small class="text-muted">2 minutes ago</small>
                        </div>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <div class="bg-light rounded p-3 me-3">
                            <i class="fas fa-shopping-cart text-primary"></i>
                        </div>
                        <div>
                            <div>New order placed</div>
                            <small class="text-muted">15 minutes ago</small>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="bg-light rounded p-3 me-3">
                            <i class="fas fa-book text-warning"></i>
                        </div>
                        <div>
                            <div>New book added to inventory</div>
                            <small class="text-muted">1 hour ago</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
</script>
</body>
</html>