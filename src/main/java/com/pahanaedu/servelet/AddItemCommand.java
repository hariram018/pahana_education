package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
public class AddItemCommand implements ItemCommand{
    @Override
    public void execute(HttpServletRequest request, ServletContext context) {
        ItemDAO itemDAO = DAOFactory.getItemDAO();
        String itemId = request.getParameter("itemId");
        String name = request.getParameter("name");
        double price;
        int stockQuantity;
        try {
            price = Double.parseDouble(request.getParameter("price"));
            stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            if (price < 0 || stockQuantity < 0) {
                request.setAttribute("error", "Invalid price or stock quantity");
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price or stock quantity");
            return;
        }

        if (itemDAO.getItems().containsKey(itemId)) {
            request.setAttribute("error", "Item ID already exists");
            return;
        }

        Item item = new Item(itemId, name, price, stockQuantity);
        itemDAO.addItem(item);
        itemDAO.saveItems(context);
        request.setAttribute("message", "Item added successfully");
    }
}
