package com.pahanaedu.model;

public class Item {
    private String itemId;
    private String name;
    private double price;
    private int stockQuantity;

    public Item(String itemId, String name, double price, int stockQuantity) {
        this.itemId = itemId;
        this.name = name;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public String getItemId() { return itemId; }
    public void setItemId(String itemId) { this.itemId = itemId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String toCSV() {
        return String.format("%s,%s,%.2f,%d", itemId, name, price, stockQuantity);
    }
}
