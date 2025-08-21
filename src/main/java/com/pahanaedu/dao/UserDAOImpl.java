package com.pahanaedu;

import com.pahanaedu.model.User;
import com.pahanaedu.util.DataManager;
import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
public class UserDAOImpl implements UserDAO {

    private final DataManager dataManager = DataManager.getInstance();

    @Override
    public void loadUsers(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT username, password_hash FROM users");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                dataManager.getUsers().put(rs.getString("username"), new User(rs.getString("username"), rs.getString("password_hash")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void saveUsers(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("REPLACE INTO users (username, password_hash) VALUES (?, ?)")) {
            for (User user : dataManager.getUsers().values()) {
                stmt.setString(1, user.getUsername());
                stmt.setString(2, user.getPasswordHash());
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Map<String, User> getUsers() {
        return dataManager.getUsers();
    }
}
