package com.pahanaedu.dao;

public class DAOFactory {
    public static UserDAO getUserDAO() {
        return new UserDAOImpl();
    }

    public static RoleDAO getRoleDAO() {
        return new RoleDAOImpl();
    }

    public static CustomerDAO getCustomerDAO() {
        return new CustomerDAOImpl();
    }
    public static ItemDAO getItemDAO() {
        return new ItemDAOImpl();
    }

    public static BillDAO getBillDAO() {
        return new BillDAOImpl();
    }

}
