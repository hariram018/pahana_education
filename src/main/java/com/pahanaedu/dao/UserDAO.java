package com.pahanaedu.dao;
import com.pahanaedu.model.User;
import javax.servlet.ServletContext;
import java.util.Map;
public interface UserDAO {
    void loadUsers(ServletContext context);
    void saveUsers(ServletContext context);
    Map<String, User> getUsers();
}
