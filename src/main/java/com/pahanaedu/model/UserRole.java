package com.pahanaedu.model;

public class UserRole {
    private String username;
    private String roleId;

    public UserRole(String username, String roleId) {
        this.username = username;
        this.roleId = roleId;
    }

    public String getUsername() { return username; }
    public String getRoleId() { return roleId; }
}
