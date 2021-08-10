<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
  request.setCharacterEncoding("utf-8");

  String nickName = request.getParameter("nickName");

	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String WhereDefault = "select NickName from User WHERE NickName = '" + nickName + "'";
    // int count = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();
        ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;


%>
  	[
<%
        if (rs.next()) {
          if(rs.getString(1) == "NULL"){
%>
            {
            "nickName" : "0"
            }

<%
          }else{
%>

      			{
      			"nickName" : "<%=rs.getString(1) %>"
      			}
<%
        }
      } else {
%>
        {
        "nickName" : "0"
      }
  <%    
      }
%>


		  ]
<%
        conn_mysql.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

%>
