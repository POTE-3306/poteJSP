package com.example.potejsp.login;

public class UserQuerry {
    public static final String ADD_USERS = "insert into users(email, password, nickname, address, age) " +
            "values (?, ?, ?, ? ,?)";
    public static final String SELECT_ALL = "select * from users";
    public static final String SELECT_BY_EMAIL = "select * from users where email = ?";
    public static final String SELECT_BY_ID_AND_EMAIL = "select * from users where id = ? and email = ?";

}
