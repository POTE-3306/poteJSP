<%@ page import="com.example.potejsp.login.JWToken" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String token = (String) session.getAttribute("token");
    if (token != null) {
        if (JWToken.isValidToken(token)) {
%>
        <jsp:forward page="main.jsp" />
<%
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <form action="login.jsp" method="post">
        <input type="text" id="email" name="email" placeholder="Email">
        <input type="password" id="password" name="password" placeholder="Password">
        <button type="submit" class="login-button">로그인</button>
    </form>
    <button onclick="location.href='join.jsp'">회원가입</button>
</body>
</html>