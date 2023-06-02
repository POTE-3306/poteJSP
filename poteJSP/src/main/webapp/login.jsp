<%@ page import="com.example.potejsp.login.User" %>
<%@ page import="com.example.potejsp.login.UserDAO" %>
<%@ page import="com.example.potejsp.login.JWToken" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    User user = UserDAO.userSelectByEmail(email);
    if (user == null) {
%>

    <script>
        alert("존재하지 않는 이메일입니다.");
        location.href='index.jsp';
    </script>

<%
    } else {
        if (!user.getPassword().equals(password)) {

%>

    <script>
        alert("비밀번호가 일치하지 않습니다.");
        location.href='index.jsp';
    </script>

<%
        } else {
            session.setAttribute("userID", user.getId());
            session.setAttribute("token", JWToken.getToken(user));
%>

    <script>
        alert("로그인 성공");
        location.href='main.jsp';
    </script>

<%
        }
    }
%>