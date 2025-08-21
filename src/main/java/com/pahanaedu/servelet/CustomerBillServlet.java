package com.pahanaedu.servelet;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.Customer;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CustomerBillServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CustomerBillServlet.class.getName());
    private static final int PAGE_SIZE = 10; // Number of bills per page
    private CustomerDAO customerDAO;
    private BillDAO billDAO;

    @Override
    public void init() throws ServletException {
        try {
            customerDAO = DAOFactory.getCustomerDAO();
            billDAO = DAOFactory.getBillDAO();
            LOGGER.info("CustomerBillServlet initialized successfully.");
        } catch (Exception e) {
            LOGGER.severe("Failed to initialize DAOs: " + e.getMessage());
            throw new ServletException("Initialization failed", e);
        }
    }

    private boolean isCustomer(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            LOGGER.warning("No active session found.");
            return false;
        }
        List<String> roles = (List<String>) session.getAttribute("roles");
        return roles != null && roles.contains("CUSTOMER");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Validate session and role
        if (!isCustomer(request)) {
            request.setAttribute("error", "Please log in as a customer to view bills.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        if (username == null) {
            LOGGER.warning("Username not found in session.");
            request.setAttribute("error", "Session expired. Please log in again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Retrieve customer
            Customer customer = customerDAO.getCustomerByUsername(username);
            if (customer == null) {
                LOGGER.warning("Customer not found for username: " + username);
                request.setAttribute("error", "Customer profile not found. Contact support.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Retrieve and paginate bills
            List<Bill> allBills = billDAO.getBills().stream()
                    .filter(bill -> bill.getAccountNumber().equals(customer.getAccountNumber()))
                    .collect(Collectors.toList());

            if (allBills.isEmpty()) {
                request.setAttribute("info", "No bills found for your account.");
            }

            // Pagination logic
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid page parameter: " + pageParam);
                    page = 1;
                }
            }

            int totalBills = allBills.size();
            int totalPages = (int) Math.ceil((double) totalBills / PAGE_SIZE);
            int start = (page - 1) * PAGE_SIZE;
            int end = Math.min(start + PAGE_SIZE, totalBills);

            List<Bill> paginatedBills = allBills.subList(start, end);

            // Set attributes for JSP
            request.setAttribute("customer", customer);
            request.setAttribute("bills", paginatedBills);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("menuOptions", List.of(
                    new MenuOption("View Profile", "customer-profile"),
                    new MenuOption("Logout", "logout")
            ));

            request.getRequestDispatcher("/customer-bills.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error retrieving bills: " + e.getMessage());
            request.setAttribute("error", "An error occurred while retrieving your bills. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // Helper class for menu options
    public static class MenuOption {
        private String label;
        private String url;

        public MenuOption(String label, String url) {
            this.label = label;
            this.url = url;
        }

        public String getLabel() { return label; }
        public String getUrl() { return url; }
    }
}