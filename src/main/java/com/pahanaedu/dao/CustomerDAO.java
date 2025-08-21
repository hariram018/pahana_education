package com.pahanaedu.dao;
import com.pahanaedu.model.Customer;

import javax.servlet.ServletContext;
import java.util.Map;

public interface CustomerDAO {
    void loadCustomers(ServletContext context);
    void saveCustomers(ServletContext context);
    Map<String, Customer> getCustomers();
    void addCustomer(Customer customer);
    void updateCustomer(Customer customer);
    Customer getCustomerByUsername(String username);
    int getCustomerCount();
    void deleteCustomer(String accountNumber);
}
