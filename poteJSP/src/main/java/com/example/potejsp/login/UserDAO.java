package com.example.potejsp.login;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static void getBookFromResultSet(ResultSet rs, User user) throws SQLException {
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setAddress(rs.getString("address"));
        user.setAge(rs.getInt("age"));
    }
    public static void userInsert(User user) {
        Connection conn = GetConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(UserQuerry.ADD_USERS, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getNickname());
            pstmt.setString(4, user.getAddress());
            pstmt.setInt(5, user.getAge());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        try {
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<User> userSelectAll() {
        List<User> userList = new ArrayList<>();
        Connection conn = GetConnection.getConnection();

        try (Statement stmt = conn.createStatement()){
            ResultSet rs = stmt.executeQuery(UserQuerry.SELECT_ALL);
            while(rs.next()) {
                User user = new User();
                getBookFromResultSet(rs, user);
                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        try {
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    public static User userSelectByEmail(String email) {
        User user = null;
        Connection conn = GetConnection.getConnection();

        try (PreparedStatement pstmt = conn.prepareStatement(UserQuerry.SELECT_BY_EMAIL)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
                user = new User();
                getBookFromResultSet(rs, user);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        try {
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public static User userSelectByIdAndEmail(int id, String email) {
        User user = null;
        Connection conn = GetConnection.getConnection();

        try (PreparedStatement pstmt = conn.prepareStatement(UserQuerry.SELECT_BY_ID_AND_EMAIL)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, email);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
                user = new User();
                getBookFromResultSet(rs, user);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        try {
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}
