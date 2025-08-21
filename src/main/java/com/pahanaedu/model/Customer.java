package com.pahanaedu.model;

public class Customer {
    private String accountNumber;
    private String username;
    private String name;
    private String address;
    private String telephone;
    private int unitsConsumed;

    public Customer(String accountNumber, String username, String name, String address, String telephone, int unitsConsumed) {
        this.accountNumber = accountNumber;
        this.username = username;
        this.name = name;
        this.address = address;
        this.telephone = telephone;
        this.unitsConsumed = unitsConsumed;
    }

    public String getAccountNumber() { return accountNumber; }
    public String getUsername() { return username; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public int getUnitsConsumed() { return unitsConsumed; }
    public void setUnitsConsumed(int unitsConsumed) { this.unitsConsumed = unitsConsumed; }

    public String toCSV() {
        return String.format("%s,%s,%s,%s,%d", accountNumber, name, address, telephone, unitsConsumed);
    }
}
