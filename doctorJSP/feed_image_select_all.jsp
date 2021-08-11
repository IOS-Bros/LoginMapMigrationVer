<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String url_mysql = "jdbc:mysql://localhost/dogtor_tmep?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
  String WhereDefault = "select * from FeedImage ORDER BY fiNo DESC";
  int count = 0;

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
    Statement stmt_mysql = conn_mysql.createStatement();

    ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;
%>
  	[
<%
        while (rs.next()) {
            if (count == 0) {

            }else{
%>
            ,
<%
            }
            count++;
%>
			{
			"fiNo" : "<%=rs.getInt(1) %>",
			"fiName" : "<%=rs.getString(2) %>",
			"fNo" : "<%=rs.getInt(3) %>"
			}
<%
        }
%>
		  ]
<%
        conn_mysql.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println(e);
    }

%>
