<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String cWriter = request.getParameter("cWriter");
	String cContent = request.getParameter("cContent");
	String fNo = request.getParameter("fNo");	
		
//------
	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	
	    String A = "insert into FeedComment (cWriter, cSubmitDate, cContent, fNo";
	    String B = ") values (?,now(),?,?)";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, cWriter);
	    ps.setString(2, cContent);
	    ps.setString(3, fNo);
	    
	    ps.executeUpdate();
		ps.close();

		

		String WhereDefault = "select cNo, cWriter, cSubmitDate, cContent from FeedComment where fNo = " + fNo;
		int count = 0;
		
		Statement stmt_mysql = conn_mysql.createStatement();
        ResultSet rs = stmt_mysql.executeQuery(WhereDefault);

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
			"cNo" : "<%=rs.getString(1) %>",
			"cWriter" : "<%=rs.getString(2) %>",
			"cSubmitDate" : "<%=rs.getString(3) %>", 
            "cContent" : "<%=rs.getString(4) %>"
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