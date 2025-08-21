package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

public class UpdateItemCommand implements ItemCommand{
    @Override
    public void execute(HttpServletRequest request, ServletContext context) {
        ItemDAO itemDAO = DAOFactory.getItemDAO();
        String itemId = request.getParameter("itemId");
        Item item = itemDAO.getItems().get(itemId);
        if (item != null) {
            item.setName(request.getParameter("name"));
            try {
                double price = Double.parseDouble(request.getParameter("price"));
                int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
                if (price < 0 || stockQuantity < 0) {
                    request.setAttribute("error", "Invalid price or stock quantity");
                    return;
                }
                item.setPrice(price);
                item.setStockQuantity(stockQuantity);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price or stock quantity");
                return;
            }
            itemDAO.updateItem(item);
            itemDAO.saveItems(context);
            request.setAttribute("message", "Item updated successfully");
        } else {
            request.setAttribute("error", "Item not found");
        }
    }
}
