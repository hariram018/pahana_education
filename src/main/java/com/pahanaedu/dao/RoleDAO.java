package com.pahanaedu.dao;

import com.pahanaedu.model.Role;
import com.pahanaedu.model.UserRole;
import javax.servlet.ServletContext;
import java.util.List;
import java.util.Map;
public interface RoleDAO {
    void loadRoles(ServletContext context);
    abstract void saveRoles(ServletContext context);
    abstract Map<String, Role> getRoles();
    abstract List<UserRole> getUserRoles();
}
