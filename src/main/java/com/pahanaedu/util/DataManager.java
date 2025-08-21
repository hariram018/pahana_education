package com.pahanaedu.util;

import com.pahanaedu.model.*;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.*;

public class DataManager {
    private static volatile DataManager instance;
    private Map<String, User> users = new HashMap<>();
    private Map<String, Role> roles = new HashMap<>();
    private List<UserRole> userRoles = new ArrayList<>();
    private Map<String, Customer> customers = new HashMap<>();
    private Map<String, Item> items = new HashMap<>();
    private List<Bill> bills = new ArrayList<>();
    private Connection connection;
    String url;
    String username;
    String password;
    String driver;

    DataManager() {
        loadDbProperties();

    }

    public static DataManager getInstance() {
        if (instance == null) {
            synchronized (DataManager.class) {
                if (instance == null) {
                    instance = new DataManager();
                }
            }
        }
        return instance;
    }

    private void loadDbProperties() {
        try {
            Properties props = new Properties();
            InputStream input;
            input = getClass().getClassLoader().getResourceAsStream("db.properties");
            if (input == null) {
                throw new IllegalStateException("db.properties not found in classpath");
            }
            props.load(input);
            url = props.getProperty("jdbc.url");
            username = props.getProperty("jdbc.username");
            password = props.getProperty("jdbc.password");
            driver = props.getProperty("jdbc.driver");

            if (url == null || username == null || password == null) {
                throw new IllegalStateException("Missing required properties in db.properties");
            }

            Class.forName(driver);
            connection = DriverManager.getConnection(url, username, password);
            if (connection == null) {
                throw new SQLException("Failed to establish database connection");
            }
        } catch (Exception e) {
            throw new IllegalStateException("Failed to initialize DataManager: " + e.getMessage(), e);
        }
    }

    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(url, username, password);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to establish database connection: " + e.getMessage(), e);
        }
        return connection;
    }
//    public Connection getConnection() { return connection; }
    public Map<String, User> getUsers() { return users; }
    public Map<String, Role> getRoles() { return roles; }
    public List<UserRole> getUserRoles() { return userRoles; }
    public Map<String, Customer> getCustomers() { return customers; }
    public Map<String, Item> getItems() { return items; }
    public List<Bill> getBills() { return bills; }

    public void closeConnection() {
        try {
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
