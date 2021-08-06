<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String google = request.getParameter("google");
  String email = request.getParameter("userEmail");
  String image = request.getParameter("userImage");
  String nickName = request.getParameter("userNickName");

//------
	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();

	    String A = "insert into User (Email, API, Image, NickName";
	    String B = ") values (?,?,?,?)";

	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, email);
	    ps.setString(2, google);
      ps.setString(3, image);
      ps.setString(4, nickName);



	    ps.executeUpdate();

	    conn_mysql.close();
	}

	catch (Exception e){
	    e.printStackTrace();
	}

%>
