<%@ page import="com.example.potejsp.login.UserDAO" %>
<%@ page import="com.example.potejsp.login.User" %>
<%@ page import="com.example.potejsp.login.APIUser" %>
<%@ page import="com.example.potejsp.login.JWToken" %>
<%@ page import="com.example.potejsp.domain.APIUser" %>
<%@ page import="com.example.potejsp.domain.User" %>
<%@ page import="com.example.potejsp.repository.UserRepository" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    APIUser apiUser = (APIUser) session.getAttribute("apiUser");
    if (apiUser == null) {
        response.sendRedirect("index.jsp");
        return ;
    }
    session.removeAttribute("apiUser");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String address = request.getParameter("address");
    if (nickname.trim().isEmpty()) {

%>
<script>
    alert("회원가입 실패");
    location.href = "join.jsp";
</script>
<%

    } else {
        String naverId = request.getParameter("naverId");
        int age = Integer.parseInt(request.getParameter("age"));
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setNickname(nickname);
        newUser.setAddress(address);
        newUser.setAge(age);
        newUser.setNaverId(naverId);
        newUser = UserRepository.userInsert(newUser);
        if (newUser.getId() == 0) {
%>
    <script>
        alert("회원가입 실패");
        location.href = "join.jsp";
    </script>
<%
        } else {
            session.setAttribute("token", JWToken.getToken(newUser));
            response.sendRedirect("main.jsp");
        }
    }
%>