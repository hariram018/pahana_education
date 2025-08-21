package com.pahanaedu.dao;

import com.pahanaedu.model.Item;

import javax.servlet.ServletContext;
import java.util.Map;
public interface ItemDAO {
    void loadItems(ServletContext context);
    void saveItems(ServletContext context);
    Map<String, Item> getItems();
    void addItem(Item item);
    void updateItem(Item item);
    void deleteItem(String itemId);
}
