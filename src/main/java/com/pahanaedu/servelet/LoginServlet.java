package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.RoleDAO;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = DAOFactory.getUserDAO();
        roleDAO = DAOFactory.getRoleDAO();
        userDAO.loadUsers(getServletContext());
        roleDAO.loadRoles(getServletContext());
//        DAOFactory.getCustomerDAO().loadCustomers(getServletContext());
//        DAOFactory.getItemDAO().loadItems(getServletContext());
//        DAOFactory.getBillDAO().loadBills(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.getUsers().get(username);
        if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            List<String> roles = roleDAO.getUserRoles().stream()
                    .filter(ur -> ur.getUsername().equals(username))
                    .map(ur -> roleDAO.getRoles().get(ur.getRoleId()).getRoleName())
                    .collect(Collectors.toList());
            session.setAttribute("roles", roles);

            if (roles.contains("ADMIN")) {
                response.sendRedirect("dashboard.jsp");
            } else if (roles.contains("CUSTOMER")) {
                response.sendRedirect("customer-profile");
            } else {
                request.setAttribute("error", "No valid role assigned");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
