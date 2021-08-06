<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String imageURL = request.getParameter("imageURL");
  String petName = request.getParameter("petName");
  String petAge = request.getParameter("petAge");
  String petSpecies = request.getParameter("petSpecies");
  String petGender = request.getParameter("petGender");
  String userEmail = request.getParameter("userEmail");

//------
	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();

	    String A = "insert into Pet (PetName, PetImage, PetSpecies, PetGender , PetAge , User_Email";
	    String B = ") values (?,?,?,?,?,?)";

	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, petName);
	    ps.setString(2, imageURL);
      ps.setString(3, petSpecies);
      ps.setString(4, petGender);
      ps.setString(5, petAge);
      ps.setString(6, userEmail);




	    ps.executeUpdate();

	    conn_mysql.close();
      out.print("SUCESS");
	}

	catch (Exception e){
	    e.printStackTrace();
      out.print(e);
	}

%>
