package com.pahanaedu.servelet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class HelpServlet extends HttpServlet {
    private boolean isAuthenticated(HttpServletRequest request) {
        List<String> roles = (List<String>) request.getSession().getAttribute("roles");
        return roles != null && (roles.contains("ADMIN") || roles.contains("CUSTOMER"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthenticated(request)) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/help.jsp").forward(request, response);
    }
}
