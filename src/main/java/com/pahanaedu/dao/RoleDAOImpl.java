package com.pahanaedu;

import com.pahanaedu.model.Role;
import com.pahanaedu.model.UserRole;

import com.pahanaedu.util.DataManager;
import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
public class RoleDAOImpl implements RoleDAO {
    private final DataManager dataManager = DataManager.getInstance();

    @Override
    public void loadRoles(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT role_id, role_name FROM roles");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Role role = new Role(rs.getString("role_id"), rs.getString("role_name"));
                dataManager.getRoles().put(role.getRoleId(), role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT username, role_id FROM user_roles");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                dataManager.getUserRoles().add(new UserRole(rs.getString("username"), rs.getString("role_id")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void saveRoles(ServletContext context) {
        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("REPLACE INTO roles (role_id, role_name) VALUES (?, ?)")) {
            for (Role role : dataManager.getRoles().values()) {
                stmt.setString(1, role.getRoleId());
                stmt.setString(2, role.getRoleName());
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try (Connection conn = dataManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement("REPLACE INTO user_roles (username, role_id) VALUES (?, ?)")) {
            for (UserRole userRole : dataManager.getUserRoles()) {
                stmt.setString(1, userRole.getUsername());
                stmt.setString(2, userRole.getRoleId());
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Map<String, Role> getRoles() {
        return dataManager.getRoles();
    }

    @Override
    public List<UserRole> getUserRoles() {
        return dataManager.getUserRoles();
    }
}
