package com.example.potejsp.domain;

import java.time.LocalDateTime;

public class Board {

    public int boardId;

    public String title;

    public LocalDateTime startDate;

    public int usersCount;

    public String nickname;
    public String address;
    public boolean isProgressed;


    public Board() {
    }

    public Board(int boardId, String title, LocalDateTime startDate, int usersCount, String nickname, String address,boolean isProgressed) {
        this.boardId = boardId;
        this.title = title;
        this.startDate = startDate;
        this.usersCount = usersCount;
        this.nickname = nickname;
        this.address = address;
        this.isProgressed = isProgressed;
    }

    public Board(String title, LocalDateTime startDate, int usersCount, String nickname, String address,boolean isProgressed) {
        this.title = title;
        this.startDate = startDate;
        this.usersCount = usersCount;
        this.nickname = nickname;
        this.address = address;
        this.isProgressed = isProgressed;
    }

    public Board(String title, LocalDateTime parse, LocalDateTime parse1, String nickname, String location) {
    }


    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public int getUsersCount() {
        return usersCount;
    }

    public void setUsersCount(int usersCount) {
        this.usersCount = usersCount;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean getIsProgressed(){return isProgressed;}

    public void setIsProgressed(boolean isProgressed) {this.isProgressed = isProgressed;}
}
