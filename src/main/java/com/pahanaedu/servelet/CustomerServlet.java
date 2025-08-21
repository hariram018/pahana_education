package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.RoleDAO;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.User;
import com.pahanaedu.model.UserRole;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = DAOFactory.getCustomerDAO();
        userDAO = DAOFactory.getUserDAO();
        roleDAO = DAOFactory.getRoleDAO();
        customerDAO.loadCustomers(getServletContext());
    }

    private boolean isAdmin(HttpServletRequest request) {
        List<String> roles = (List<String>) request.getSession().getAttribute("roles");
        return roles != null && roles.contains("ADMIN");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        request.setAttribute("customers", customerDAO.getCustomers().values()); // Always set customers
        if (pathInfo == null || pathInfo.equals("/")) {
            request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String accountNumber = pathInfo.substring(6);
            Customer customer = customerDAO.getCustomers().get(accountNumber);
            if (customer != null) {
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Customer not found");
                request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            String accountNumber = pathInfo.substring(8);
            Customer customer = customerDAO.getCustomers().get(accountNumber);
            if (customer != null) {
                customerDAO.deleteCustomer(accountNumber);
                String username = customer.getUsername();
                userDAO.getUsers().remove(username);
                roleDAO.getUserRoles().removeIf(userRole -> userRole.getUsername().equals(username));
                userDAO.saveUsers(getServletContext());
                roleDAO.saveRoles(getServletContext());
                customerDAO.saveCustomers(getServletContext());
                request.getSession().setAttribute("message", "Customer deleted successfully");
                response.sendRedirect(request.getContextPath() + "/customers");
            } else {
                request.setAttribute("error", "Customer not found");
                request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            request.setAttribute("error", "Unauthorized access");
            request.setAttribute("customers", customerDAO.getCustomers().values());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        Map<String, String> errors = new HashMap<>();

        if (pathInfo.equals("/add")) {
            String accountNumber = request.getParameter("accountNumber");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");

            // Validation
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                errors.put("accountNumber", "Account number is required");
            }
            if (username == null || username.trim().isEmpty()) {
                errors.put("username", "Username is required");
            }
            if (password == null || password.trim().isEmpty()) {
                errors.put("password", "Password is required");
            }
            if (name == null || name.trim().isEmpty()) {
                errors.put("name", "Name is required");
            }
            if (!telephone.matches("\\d+")) {
                errors.put("telephone", "Invalid telephone number");
            }
            if (customerDAO.getCustomers().containsKey(accountNumber)) {
                errors.put("accountNumber", "Account number already exists");
            }
            if (userDAO.getUsers().containsKey(username)) {
                errors.put("username", "Username already exists");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("customers", customerDAO.getCustomers().values());
                request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
                return;
            }

            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
            userDAO.getUsers().put(username, new User(username, passwordHash));
            roleDAO.getUserRoles().add(new UserRole(username, "ROLE_CUSTOMER"));
            Customer customer = new Customer(accountNumber, username, name, address, telephone, 0);
            customerDAO.addCustomer(customer);
            userDAO.saveUsers(getServletContext());
            roleDAO.saveRoles(getServletContext());
            customerDAO.saveCustomers(getServletContext());
            request.getSession().setAttribute("message", "Customer added successfully");
            response.sendRedirect(request.getContextPath() + "/customers");
        } else if (pathInfo.equals("/edit")) {
            String accountNumber = request.getParameter("accountNumber");
            Customer customer = customerDAO.getCustomers().get(accountNumber);
            if (customer != null) {
                String name = request.getParameter("name");
                String address = request.getParameter("address");
                String telephone = request.getParameter("telephone");
                String unitsConsumedStr = request.getParameter("unitsConsumed");
                int unitsConsumed = 0;

                try {
                    unitsConsumed = Integer.parseInt(unitsConsumedStr);
                    if (unitsConsumed < 0) throw new NumberFormatException();
                } catch (NumberFormatException e) {
                    errors.put("unitsConsumed", "Invalid units consumed");
                }

                if (name == null || name.trim().isEmpty()) {
                    errors.put("name", "Name is required");
                }
                if (!telephone.matches("\\d+")) {
                    errors.put("telephone", "Invalid telephone number");
                }

                if (!errors.isEmpty()) {
                    request.setAttribute("errors", errors);
                    request.setAttribute("customer", customer);
                    request.setAttribute("customers", customerDAO.getCustomers().values());
                    request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
                    return;
                }

                customer.setName(name);
                customer.setAddress(address);
                customer.setTelephone(telephone);
                customer.setUnitsConsumed(unitsConsumed);
                customerDAO.updateCustomer(customer);
                customerDAO.saveCustomers(getServletContext());
                request.getSession().setAttribute("message", "Customer updated successfully");
                response.sendRedirect(request.getContextPath() + "/customers");
            } else {
                request.setAttribute("error", "Customer not found");
                request.setAttribute("customers", customerDAO.getCustomers().values());
                request.getRequestDispatcher("/display-customers.jsp").forward(request, response);
            }
        }
    }
}