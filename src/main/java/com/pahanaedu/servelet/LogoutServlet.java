package com.pahanaedu.servelet;
import com.pahanaedu.dao.DAOFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        DAOFactory.getCustomerDAO().saveCustomers(getServletContext());
//        DAOFactory.getItemDAO().saveItems(getServletContext());
//        DAOFactory.getBillDAO().saveBills(getServletContext());
        DAOFactory.getUserDAO().saveUsers(getServletContext());
        DAOFactory.getRoleDAO().saveRoles(getServletContext());
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
