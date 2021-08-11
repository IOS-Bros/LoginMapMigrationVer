<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String url_mysql = "jdbc:mysql://localhost/dogtor_tmep?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
  String WhereDefault = "select * from feed ORDER BY fno DESC";
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
    "fNo" : "<%=rs.getInt(1) %>",
    "fSubmitDate" : "<%=rs.getString(2) %>",
    "fContent" : "<%=rs.getString(3) %>",
    "fWirter" : "<%=rs.getString(4).trim() %>",
    "fHashTag" : "<%=rs.getString(5).trim() %>"
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
