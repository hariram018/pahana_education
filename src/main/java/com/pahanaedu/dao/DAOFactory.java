package com.pahanaedu.dao;

public class DAOFactory {
    public static UserDAO getUserDAO() {
        return new UserDAOImpl();
    }

    public static RoleDAO getRoleDAO() {
        return new RoleDAOImpl();
    }
}
