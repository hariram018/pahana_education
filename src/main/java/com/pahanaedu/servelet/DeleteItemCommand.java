package com.pahanaedu.servelet;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.ItemDAO;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

public class DeleteItemCommand implements ItemCommand {
    @Override
    public void execute(HttpServletRequest request, ServletContext context) {
        ItemDAO itemDAO = DAOFactory.getItemDAO();
        String itemId = request.getParameter("itemId");
        itemDAO.deleteItem(itemId);
        itemDAO.saveItems(context);
        request.setAttribute("message", "Item deleted successfully");
    }
}
