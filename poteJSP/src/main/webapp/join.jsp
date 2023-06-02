<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sign up</title>
</head>
<body>
    <h2>회원가입</h2>
    <form action="insert.jsp" method="post">
        <input type="text" id="email" name="email" placeholder="Email">
        <input type="password" id="password" name="password" placeholder="Password">
        <input type="text" id="nickname" name="nickname" placeholder="Nickname">
        <input type="text" id="address" name="address" placeholder="Address">
        <input type="text" id="age" name="age" placeholder="Age">
        <button type="submit" class="insert-button">가입</button>
    </form>
</body>
</html>
