package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ItemServlet extends HttpServlet {

    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        itemDAO = DAOFactory.getItemDAO();
        itemDAO.loadItems(getServletContext()); // Load items when servlet initializes
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roles") == null
                || !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        itemDAO.loadItems(getServletContext()); // Load items before handling request

        if (pathInfo == null || pathInfo.equals("/")) {
            request.setAttribute("items", itemDAO.getItems().values());
            request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            request.setAttribute("items", itemDAO.getItems().values());
            request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String itemId = pathInfo.substring(6);
            Item item = itemDAO.getItems().get(itemId);
            if (item != null) {
                request.setAttribute("item", item);
            } else {
                request.setAttribute("error", "Item not found");
            }
            request.setAttribute("items", itemDAO.getItems().values());
            request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            String itemId = pathInfo.substring(8);
            Item item = itemDAO.getItems().get(itemId);
            if (item != null) {
                itemDAO.deleteItem(itemId);
                itemDAO.saveItems(getServletContext());
                itemDAO.loadItems(getServletContext()); // Reload items after deletion
                session.setAttribute("message", "Item deleted successfully");
                response.sendRedirect(request.getContextPath() + "/items");
            } else {
                request.setAttribute("error", "Item not found");
                request.setAttribute("items", itemDAO.getItems().values());
                request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
            }
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roles") == null
                || !((List<String>) session.getAttribute("roles")).contains("ADMIN")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        Map<String, String> errors = new HashMap<>();

        String itemId = request.getParameter("itemId");
        String name = request.getParameter("name");
        double price;
        int stockQuantity;

        // Validation
        if (itemId == null || itemId.trim().isEmpty()) {
            errors.put("itemId", "Item ID is required");
        }
        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Name is required");
        }
        try {
            price = Double.parseDouble(request.getParameter("price"));
            if (price < 0) {
                errors.put("price", "Price must be non-negative");
            }
        } catch (NumberFormatException e) {
            errors.put("price", "Invalid price format");
            price = 0;
        }
        try {
            stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            if (stockQuantity < 0) {
                errors.put("stockQuantity", "Stock quantity must be non-negative");
            }
        } catch (NumberFormatException e) {
            errors.put("stockQuantity", "Invalid stock quantity format");
            stockQuantity = 0;
        }

        if (pathInfo.equals("/add") && itemDAO.getItems().containsKey(itemId)) {
            errors.put("itemId", "Item ID already exists");
        } else if (pathInfo.equals("/edit") && !itemDAO.getItems().containsKey(itemId)) {
            errors.put("itemId", "Item not found");
        }

        if (!errors.isEmpty()) {
            itemDAO.loadItems(getServletContext()); // Reload items before forwarding
            request.setAttribute("errors", errors);
            if (pathInfo.equals("/edit")) {
                request.setAttribute("item", new Item(itemId, name, price, stockQuantity));
            }
            request.setAttribute("items", itemDAO.getItems().values());
            request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
            return;
        }

        Item item = new Item(itemId, name, price, stockQuantity);

        if (pathInfo.equals("/add")) {
            itemDAO.addItem(item);
            itemDAO.saveItems(getServletContext());
            itemDAO.loadItems(getServletContext()); // Reload items after adding
            session.setAttribute("message", "Item added successfully");
            response.sendRedirect(request.getContextPath() + "/items");
        } else if (pathInfo.equals("/edit")) {
            itemDAO.updateItem(item);
            itemDAO.saveItems(getServletContext());
            itemDAO.loadItems(getServletContext()); // Reload items after updating
            session.setAttribute("message", "Item updated successfully");
            response.sendRedirect(request.getContextPath() + "/items");
        } else {
            itemDAO.loadItems(getServletContext()); // Reload items before forwarding
            request.setAttribute("error", "Invalid request");
            request.setAttribute("items", itemDAO.getItems().values());
            request.getRequestDispatcher("/manage-items.jsp").forward(request, response);
        }
    }
}