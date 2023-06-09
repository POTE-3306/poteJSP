<%@ page import="com.example.potejsp.login.JWToken" %>
<%@ page import="com.example.potejsp.repository.BoardRepository" %>
<%@ page import="com.example.potejsp.domain.Board" %>
<%@ page import="com.example.potejsp.domain.Item" %>
<%@ page import="com.example.potejsp.repository.ItemRepository"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.potejsp.domain.User" %>
<%@ page import="com.example.potejsp.repository.VoterRepository" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%! User user = null; %>
<%
        String token = (String) session.getAttribute("token");
    if (token == null) {
        response.sendRedirect("index.jsp");
        return ;
    }
    user = JWToken.validTokenAndGetUser(token);
    if (user == null) {
        response.sendRedirect("index.jsp");
        return ;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Index Page</title>
    <style>
        body{
            margin:0;
            padding:0;
            width:100%;
        }
        .header {
            height: 70px;
            width: 100%;
            background-color: #FFFFFF;
            box-sizing: border-box;
            padding-right: 20px;
        }

        .divider {
            height: 2px;
            width: 100%;
            background-color: #DBDBDB;
            margin-bottom: 50px;
        }

        .indexBody{
            width: 100%;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .indexHeader{
            display: flex;
            flex-direction: row;
            margin-bottom: 20px;
            width: 1000px;
            justify-content: left;
        }

        .indexHeaderTitle{
            font-size: 30px;
            font-weight: bold;
            margin-right: 30px;
        }

        .buttons {
            float: right;
            margin-top: 25px;
        }

        .buttons button {
            font-weight: bold;
            font-size: 18px;
            border: none;
            background: none;
            padding: 0;
            margin-right: 10px;
        }

        .loggedOut {
            display: none;
        }

        .loggedIn {
            display: none;
        }

        .component {
            width: 1000px;
            height: 160px;
            padding: 30px;
            box-sizing: border-box;
            background-color: #CDDBF6;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.5s;
            margin-bottom: 10px;
        }

        .details {
            width: 1000px;
            display: none;
            background-color: #EBF0F9;
            padding: 10px;
            box-sizing: border-box;
            margin-bottom: 10px;
        }

        .details .item div {
            width: 800px;
            margin: 10px;
            padding: 10px;
            box-sizing: border-box;
            background-color: #FFFFFF;
            font-weight: bold;
        }

        .btn {
            background-color: #CDDBF6;
            padding: 10px 20px;
            border-radius: 5px;
            display: inline-block;
            cursor: pointer;
            font-weight: bold;
            border-color: #CDDBF6;
            margin-left: 5px;
        }


        /*페이지 css*/
        .pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 20px;
        }

        .page-button {
            background-color: #CDDBF6;
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            margin: 0 4px;
            cursor: pointer;
            font-weight: bold;
            color: #333333;
            transition: background-color 0.3s;
        }

        .page-button:hover {
            background-color: #8FB1F2;
            color: #FFFFFF;
        }

        .current-page {
            font-weight: bold;
            margin: 0 4px;
        }
    </style>
</head>
<script>
    var condition = 2; // 조건 변수, 1 또는 2로 설정
    var selectedItemId = null; // 선택된 아이템의 ID를 저장할 변수

    window.onload = function() {
        if (condition === 1) {
            document.querySelector('.loggedOut').style.display = 'block';
        } else if (condition === 2) {
            document.querySelector('.loggedIn').style.display = 'block';
        }
    };

    function toggleDetails(boardId) {
        var details = document.getElementById("details" + boardId);
        details.style.display = (details.style.display === "none") ? "block" : "none";

        var component = document.querySelector(".component[data-boardId='" + boardId + "']");
        component.style.border = (details.style.display === "none") ? "none" : "2px solid red";
    }
</script>



<body>
<div class="header">
    <div class="buttons loggedOut">
        <button>로그인</button>
        <button>회원가입</button>
    </div>
    <div class="buttons loggedIn">
        <button onclick="location='mypage.jsp'">내정보</button>
        <button onclick="location='search.jsp'">검색하기</button>
        <button onclick="location='voteGenerate.jsp'">투표생성</button>
        <button onclick="location='logout.jsp'">로그아웃</button>
    </div>
</div>
<div class="divider"></div>

<div class="indexBody">
    <div class="indexHeader">
        <div class="indexHeaderTitle">투표 목록</div>
    </div>

    <%
        BoardRepository boardRepository = new BoardRepository();
        ItemRepository itemRepository = new ItemRepository();
        VoterRepository voterRepository = new VoterRepository();

        List<Board> boardList = null;
        List<Item> itemList = null;

        int currentPage=1; // 현재 페이지 번호
        int pageSize = 5; // 페이지당 게시물 수

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        int totalBoardCount = boardRepository.getTotalBoardCount();
        int totalPages = (int) Math.ceil((double) totalBoardCount / pageSize);

        // 현재 페이지 번호가 범위를 벗어나는 경우 첫 번째 또는 마지막 페이지로 이동
        if (currentPage < 1) {
            currentPage = 1;
        } else if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        }

        try {
            boardList = boardRepository.findAll(currentPage);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 게시물 목록 출력
        for (Board board : boardList) {
            HashMap<String, Integer> map;
            try {
                map = voterRepository.getVoteCount(board.getBoardId());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
    %>
    <div class="component" onclick="toggleDetails(<%=board.getBoardId()%>)" style="<%= board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>">
        <div style="font-weight: bold; font-size: 30px; margin-top:20px; color: <%= board.getIsProgressed() == false ? "darkgray" : "black" %>"><%= board.getTitle()%></div>
        <div style="font-weight: bold; font-size: 17px; margin-top:5px; color: <%= board.getIsProgressed() == false ? "darkgray" : "black" %>"><%= board.getStartDate()%> / 투표수 : <%= board.getUsersCount()%> / <%= board.getAddress()%> / <%= board.getNickname()%></div>
    </div>

    <div
            class="details" id="details<%=board.getBoardId()%>"
            style="<%=board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>">
        <form id="itemForm<%=board.getBoardId()%>" method="POST" action="doVote.jsp">
            <div class="item">
                <%
                    itemList = itemRepository.getItemList(board.getBoardId());
                    int maxVoteCount = 0;
                    List<String> maxVotedItems = new ArrayList<>();
                    if (board.getIsProgressed() == false) {
                        for (Item item : itemList) {
                            int voteCount = map.get(item.getName()) == null ? 0 : map.get(item.getName());
                            if (voteCount > maxVoteCount) {
                                maxVoteCount = voteCount;
                            }
                        }
                        for (Item item : itemList) {
                            int voteCount = map.get(item.getName()) == null ? 0 : map.get(item.getName());
                            if (voteCount == maxVoteCount) {
                                maxVotedItems.add(item.getName());
                            }
                        }
                    }
                    for (Item item : itemList) {
                        int voteCount = map.get(item.getName()) == null ? 0 : map.get(item.getName());
            %>

            <div onclick="toggleItem(this)" data-itemId="<%= item.getItemId() %>"
                 style="background-color: <%= maxVotedItems.contains(item.getName()) ? "#8FB1F2" : "" %>">
                <input type="radio" name="item_id" value="<%=item.getItemId()%>" onclick="toggleItem(this)"
                    <%= board.getIsProgressed() == false ? "disabled" : "" %>>
                <input type="hidden" name="board_id" value="<%=board.getBoardId()%>">
                <%= item.getName() %> <%= voteCount %>
            </div>
            <%
                    }
                %>
            </div>
            <button type="submit" class="btn"
                    style="<%= board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>"
                    <%= board.getIsProgressed() == false ? "disabled" : "" %>
                    onclick="toggleDetails(<%=board.getBoardId()%>).submit();">확인</button>

        <button type="submit" class="btn" formaction="reVote.jsp" style="<%= board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>" <%= board.getIsProgressed() == false ? "disabled" : "" %>>다시 투표하기</button><!--다중투표일경우 없어도 됨-->
        <button type="submit" class="btn" formaction="undoVote.jsp" style="<%= board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>" <%= board.getIsProgressed() == false ? "disabled" : "" %>>투표 취소하기</button>
        <button type="submit" class="btn" formaction="viewVoter.jsp" style="<%= board.getIsProgressed() == false ? "background-color: #F5F5F5;" : ""%>" <%= board.getIsProgressed() == false ? "disabled" : "" %>>투표 현황보기</button>


        </form>

    </div>
    <%
        }
    %>


    <div class="pagination">
        <% if (currentPage > 1) { %>
        <button class="page-button" onclick="location.href='main.jsp?page=<%= currentPage - 1 %>'">이전</button>
        <% } %>
        <span class="current-page"><%= currentPage %></span>
        <% if (currentPage < totalPages) { %>
        <button class="page-button" onclick="location.href='main.jsp?page=<%= currentPage + 1 %>'">다음</button>
        <% } %>
    </div>


</div>
</body>
</html>