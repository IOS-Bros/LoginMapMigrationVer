<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

  String nickName = request.getParameter("nickName");
	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
  String WhereDefault = "SELECT Image FROM User WHERE NickName = '" + nickName  + "'";

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
    Statement stmt_mysql = conn_mysql.createStatement();

    ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;

    if (rs.next()){
      out.println(rs.getString(1));
    } else {
      out.println("none");
    }

     conn_mysql.close();

  } catch (Exception e) {
        e.printStackTrace();
        out.println(e);
  }

%>
