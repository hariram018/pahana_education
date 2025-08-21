package com.pahanaedu.servelet;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class CustomerProfileServlet extends HttpServlet{
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = DAOFactory.getCustomerDAO();
    }

    private boolean isCustomer(HttpServletRequest request) {
        List<String> roles = (List<String>) request.getSession().getAttribute("roles");
        return roles != null && roles.contains("CUSTOMER");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isCustomer(request)) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String username = (String) request.getSession().getAttribute("username");
        Customer customer = customerDAO.getCustomerByUsername(username);
        if (customer != null) {
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/customer-profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Customer profile not found");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
