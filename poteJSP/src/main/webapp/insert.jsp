<%@ page import="com.example.potejsp.login.UserDAO" %>
<%@ page import="com.example.potejsp.login.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String nickname = request.getParameter("nickname");
    String address = request.getParameter("address");
    int age = Integer.parseInt(request.getParameter("age"));
    User newUser = new User();
    newUser.setEmail(email);
    newUser.setPassword(password);
    newUser.setNickname(nickname);
    newUser.setAddress(address);
    newUser.setAge(age);
    UserDAO.userInsert(newUser);
%>

<script>
    alert("추가되었습니다");
    location.href='index.jsp';
</script>
