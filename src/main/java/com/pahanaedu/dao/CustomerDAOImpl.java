package com.pahanaedu.dao;
import com.pahanaedu.model.Customer;
import com.pahanaedu.util.DataManager;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

public class CustomerDAOImpl implements CustomerDAO {
    private final DataManager dataManager = DataManager.getInstance();

    @Override
    public void loadCustomers(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT account_number, username, name, address, telephone, units_consumed FROM customers");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer(
                        rs.getString("account_number"),
                        rs.getString("username"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("telephone"),
                        rs.getInt("units_consumed")
                );
                dataManager.getCustomers().put(customer.getAccountNumber(), customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void saveCustomers(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("REPLACE INTO customers (account_number, username, name, address, telephone, units_consumed) VALUES (?, ?, ?, ?, ?, ?)")) {
            for (Customer customer : dataManager.getCustomers().values()) {
                stmt.setString(1, customer.getAccountNumber());
                stmt.setString(2, customer.getUsername());
                stmt.setString(3, customer.getName());
                stmt.setString(4, customer.getAddress());
                stmt.setString(5, customer.getTelephone());
                stmt.setInt(6, customer.getUnitsConsumed());
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Map<String, Customer> getCustomers() {
        return dataManager.getCustomers();
    }

    @Override
    public void addCustomer(Customer customer) {
        dataManager.getCustomers().put(customer.getAccountNumber(), customer);
    }

    @Override
    public void updateCustomer(Customer customer) {
        dataManager.getCustomers().put(customer.getAccountNumber(), customer);
    }

    @Override
    public Customer getCustomerByUsername(String username) {
        for (Customer customer : dataManager.getCustomers().values()) {
            if (customer.getUsername().equals(username)) {
                return customer;
            }
        }
        return null;
    }

    public int getCustomerCount() {
        return dataManager.getCustomers().size();
    }

    @Override
    public void deleteCustomer(String accountNumber) {
        dataManager.getCustomers().remove(accountNumber);
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM customers WHERE account_number = ?")) {
            stmt.setString(1, accountNumber);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
