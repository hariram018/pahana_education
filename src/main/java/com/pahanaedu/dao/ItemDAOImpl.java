package com.pahanaedu.dao;
import com.pahanaedu.model.Item;
import com.pahanaedu.util.DataManager;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

public class ItemDAOImpl implements ItemDAO{
    private final DataManager dataManager = DataManager.getInstance();

    @Override
    public void loadItems(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT item_id, name, price, stock_quantity FROM items");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Item item = new Item(
                        rs.getString("item_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity")
                );
                dataManager.getItems().put(item.getItemId(), item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void saveItems(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("REPLACE INTO items (item_id, name, price, stock_quantity) VALUES (?, ?, ?, ?)")) {
            for (Item item : dataManager.getItems().values()) {
                stmt.setString(1, item.getItemId());
                stmt.setString(2, item.getName());
                stmt.setDouble(3, item.getPrice());
                stmt.setInt(4, item.getStockQuantity());
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Map<String, Item> getItems() {
        return dataManager.getItems();
    }

    @Override
    public void addItem(Item item) {
        dataManager.getItems().put(item.getItemId(), item);
    }

    @Override
    public void updateItem(Item item) {
        dataManager.getItems().put(item.getItemId(), item);
    }

    @Override
    public void deleteItem(String itemId) {
        dataManager.getItems().remove(itemId);
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM items WHERE item_id = ?")) {
            stmt.setString(1, itemId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
