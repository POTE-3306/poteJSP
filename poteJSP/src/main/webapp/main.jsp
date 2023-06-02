<%@ page import="com.example.potejsp.login.JWToken" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String token = (String) session.getAttribute("token");
    if (token == null || !JWToken.isValidToken(token)) {
        response.sendRedirect("index.jsp");
    }
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
  <h1> H I H I </h1>
</body>
</html>
