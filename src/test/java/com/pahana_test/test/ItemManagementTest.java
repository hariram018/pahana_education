package com.pahana_test.test;

import com.pahanaedu.dao.DAOFactory;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import com.pahanaedu.servelet.ItemServlet;
import com.pahanaedu.util.DataManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class ItemManagementTest {

    @Mock private ServletContext servletContext;
    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;
    @Mock private RequestDispatcher requestDispatcher;
    @Mock private Connection connection;
    @Mock private PreparedStatement preparedStatement;
    @Mock private ResultSet resultSet;

    private ItemDAO itemDAO;
    private ItemServlet itemServlet;
    private DataManager dataManager;

    @BeforeEach
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);

        // Initialize DataManager and ItemDAO
        dataManager = DataManager.getInstance();
        itemDAO = DAOFactory.getItemDAO();

        // Mock DataManager's connection
        when(dataManager.getConnection()).thenReturn(connection);
        when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);

        // Initialize ItemServlet
        itemServlet = new ItemServlet();
        itemServlet.init(); // Calls loadItems

        // Mock ServletContext for save/loadItems
        when(servletContext.getRealPath(anyString())).thenReturn("");

        // Mock session
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("roles")).thenReturn(Arrays.asList("ADMIN"));
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    // ItemDAOImpl Tests
    @Test
    public void testLoadItems() throws SQLException {
        // Mock ResultSet for loadItems
        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true, false);
        when(resultSet.getString("item_id")).thenReturn("I001");
        when(resultSet.getString("name")).thenReturn("Book");
        when(resultSet.getDouble("price")).thenReturn(10.99);
        when(resultSet.getInt("stock_quantity")).thenReturn(100);

        itemDAO.loadItems(servletContext);
        Map<String, Item> items = itemDAO.getItems();

        assertEquals(1, items.size());
        Item item = items.get("I001");
        assertNotNull(item);
        assertEquals("Book", item.getName());
        assertEquals(10.99, item.getPrice(), 0.01);
        assertEquals(100, item.getStockQuantity());
    }

    @Test
    public void testAddItem() {
        Item item = new Item("I002", "Pen", 1.99, 50);
        itemDAO.addItem(item);
        itemDAO.saveItems(servletContext);

        Map<String, Item> items = itemDAO.getItems();
        assertTrue(items.containsKey("I002"));
        assertEquals("Pen", items.get("I002").getName());
    }

    @Test
    public void testUpdateItem() {
        Item item = new Item("I003", "Notebook", 5.99, 20);
        itemDAO.addItem(item);
        Item updatedItem = new Item("I003", "Updated Notebook", 6.99, 30);
        itemDAO.updateItem(updatedItem);
        itemDAO.saveItems(servletContext);

        Item retrieved = itemDAO.getItems().get("I003");
        assertEquals("Updated Notebook", retrieved.getName());
        assertEquals(6.99, retrieved.getPrice(), 0.01);
        assertEquals(30, retrieved.getStockQuantity());
    }

    @Test
    public void testDeleteItem() throws SQLException {
        Item item = new Item("I004", "Eraser", 0.99, 10);
        itemDAO.addItem(item);
        itemDAO.deleteItem("I004");
        itemDAO.saveItems(servletContext);

        assertFalse(itemDAO.getItems().containsKey("I004"));
        verify(preparedStatement).executeUpdate();
    }

    // ItemServlet Tests
    @Test
    public void testDoGetViewItems() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/");
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("roles")).thenReturn(Arrays.asList("ADMIN"));

        itemDAO.addItem(new Item("I005", "Pencil", 0.50, 200));
        itemDAO.loadItems(servletContext);

        itemServlet.doGet(request, response);

        verify(request).setAttribute(eq("items"), any());
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetAddItemPage() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/add");

        itemServlet.doGet(request, response);

        verify(request).setAttribute(eq("items"), any());
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetEditItem() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/edit/I006");
        itemDAO.addItem(new Item("I006", "Ruler", 2.99, 15));

        itemServlet.doGet(request, response);

        verify(request).setAttribute(eq("item"), any(Item.class));
        verify(request).setAttribute(eq("items"), any());
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetEditItemNotFound() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/edit/I999");

        itemServlet.doGet(request, response);

        verify(request).setAttribute("error", "Item not found");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetDeleteItem() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/delete/I007");
        itemDAO.addItem(new Item("I007", "Marker", 3.99, 25));

        itemServlet.doGet(request, response);

        assertFalse(itemDAO.getItems().containsKey("I007"));
        verify(session).setAttribute("message", "Item deleted successfully");
        verify(response).sendRedirect(anyString());
    }

    @Test
    public void testDoGetDeleteItemNotFound() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/delete/I999");

        itemServlet.doGet(request, response);

        verify(request).setAttribute("error", "Item not found");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostAddItem() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/add");
        when(request.getParameter("itemId")).thenReturn("I008");
        when(request.getParameter("name")).thenReturn("Crayon");
        when(request.getParameter("price")).thenReturn("4.99");
        when(request.getParameter("stockQuantity")).thenReturn("30");

        itemServlet.doPost(request, response);

        Map<String, Item> items = itemDAO.getItems();
        assertTrue(items.containsKey("I008"));
        assertEquals("Crayon", items.get("I008").getName());
        verify(session).setAttribute("message", "Item added successfully");
        verify(response).sendRedirect(anyString());
    }

    @Test
    public void testDoPostAddItemInvalidInput() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/add");
        when(request.getParameter("itemId")).thenReturn("");
        when(request.getParameter("name")).thenReturn("");
        when(request.getParameter("price")).thenReturn("-1");
        when(request.getParameter("stockQuantity")).thenReturn("-10");

        itemServlet.doPost(request, response);

        verify(request).setAttribute(eq("errors"), any(Map.class));
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostEditItem() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/edit");
        when(request.getParameter("itemId")).thenReturn("I009");
        when(request.getParameter("name")).thenReturn("Updated Pen");
        when(request.getParameter("price")).thenReturn("2.99");
        when(request.getParameter("stockQuantity")).thenReturn("40");
        itemDAO.addItem(new Item("I009", "Pen", 1.99, 50));

        itemServlet.doPost(request, response);

        Item updated = itemDAO.getItems().get("I009");
        assertEquals("Updated Pen", updated.getName());
        assertEquals(2.99, updated.getPrice(), 0.01);
        assertEquals(40, updated.getStockQuantity());
        verify(session).setAttribute("message", "Item updated successfully");
        verify(response).sendRedirect(anyString());
    }

    @Test
    public void testDoPostEditItemNotFound() throws ServletException, IOException {
        when(request.getPathInfo()).thenReturn("/edit");
        when(request.getParameter("itemId")).thenReturn("I999");
        when(request.getParameter("name")).thenReturn("Book");
        when(request.getParameter("price")).thenReturn("10.99");
        when(request.getParameter("stockQuantity")).thenReturn("100");

        itemServlet.doPost(request, response);

        verify(request).setAttribute(eq("errors"), any(Map.class));
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetUnauthorizedAccess() throws ServletException, IOException {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("roles")).thenReturn(Arrays.asList("USER"));

        itemServlet.doGet(request, response);

        verify(request).setAttribute("error", "Unauthorized access");
        verify(requestDispatcher).forward(request, response);
    }
}