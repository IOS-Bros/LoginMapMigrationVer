<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
  request.setCharacterEncoding("utf-8");

  String email = request.getParameter("email");

	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String WhereDefault = "select Email, API, Image, NickName from User WHERE Email = '" + email + "'";
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
          if( rs.getString(2) == null){
%>
            {

            "email" : "<%=rs.getString(1) %>",
            "API" : "0",
            "image" : "0",
            "nickName" : "0"
            }

<%
          }else{
%>

			{

			"email" : "<%=rs.getString(1) %>",
      "API" : "<%=rs.getString(2)%>",
      "image" : "<%=rs.getString(3)%>",
      "nickName" : "<%=rs.getString(4)%>"
			}
<%
}
} else {
  %>
              {

              "email" : "0",
              "API" : "0",
              "image" : "0",
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
