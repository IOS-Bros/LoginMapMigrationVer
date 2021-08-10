<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@page import="java.sql.*"%>

<%

	String savePath = "/Library/Tomcat/webapps/ROOT/dogtor/image";
	int sizeLimit = 10 * 1024 * 1024;

	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());

	File file = multi.getFile("file");

	String petName = multi.getParameter("petName");
  	String petAge = multi.getParameter("petAge");
  	String petSpecies = multi.getParameter("petSpecies");
  	String petGender = multi.getParameter("petGender");
  	String petId = multi.getParameter("petId");


	// DB
	String url_mysql = "jdbc:mysql://localhost/dogtorYJ2?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	int result = 0;

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();

	    String A = "UPDATE Pet SET PetName = ?, PetImage = ?, PetSpecies = ?, PetGender = ?, PetAge = ? WHERE PetId = ?";

	    ps = conn_mysql.prepareStatement(A);

	    ps.setString(1, petName.trim());
	ps.setString(2, file.getName());
	ps.setString(3, petSpecies.trim());
	   ps.setString(4, petGender.trim());
	   ps.setString(5, petAge.trim());
	   ps.setString(6, petId.trim());

	result = ps.executeUpdate();
		%>
		{
			"result" : "<%=result%>"
		}

<%		
	    conn_mysql.close();
	} 
	catch (Exception e){
%>
		{
			"result" : "<%=result%>"
		}
<%		
	    e.printStackTrace();
	} 
	
%>