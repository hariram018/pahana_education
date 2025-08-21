package com.pahanaedu.servelet;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.model.Bill;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    private BillDAO billDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = DAOFactory.getCustomerDAO();
        billDAO = DAOFactory.getBillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roles") == null
                || !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
            request.setAttribute("error", "Unauthorized access");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Get total customers
        int totalCustomers = customerDAO.getCustomerCount();

        // Calculate total sales
        List<Bill> bills = billDAO.getBills();
        double totalSales = bills.stream().mapToDouble(Bill::getTotalAmount).sum();

        // Set attributes for JSP
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalSales", totalSales);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
