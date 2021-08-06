<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
  request.setCharacterEncoding("utf-8");

  String email = request.getParameter("email");

	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String WhereDefault = "select PetName, PetImage , PetSpecies , PetGender , PetAge, PetId from Pet WHERE User_Email = '" + email + "'";
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
%>
              {
                "PetName" : "<%=rs.getString(1) %>",
                "PetImage" : "<%=rs.getString(2)%>",
                "PetSpecies" : "<%=rs.getString(3)%>",
                "PetGender" : "<%=rs.getString(4)%>",
                "PetAge" : "<%=rs.getString(5)%>",
                "PetId" : "<%=rs.getString(6)%>"
              }

              <%
                      count++;
                      }
              %>
              		  ]
              		
              <%
                      conn_mysql.close();
                  } catch (Exception e) {
                      e.printStackTrace();
                  }

              %>
