<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@page import="java.sql.*"%>

<%

	String savePath = "/Library/Tomcat/webapps/ROOT/dogtor/feedImage/";
	int sizeLimit = 10 * 1024 * 1024;

	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "UTF-8");

	File file = multi.getFile("file");
  String fContent = multi.getParameter("fContent");
  String fWriter = multi.getParameter("fWriter");
  String fHashTag = multi.getParameter("fHashTag");
  int recentlyID = 0;

	// DB
	String url_mysql = "jdbc:mysql://localhost/dogtor_tmep?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);

      //일반 insert
	    String A = "INSERT INTO Feed (fSubmitDate, fContent, fWriter, fHashTag) ";
	    String B = "VALUES(now(), ?, ?, ?)";

	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, fContent);
	    ps.setString(2, fWriter);
	    ps.setString(3, fHashTag);
	    ps.executeUpdate();
      ps.close();


      //방금 수행한 쿼리의 no 구하기
      A = "SELECT LAST_INSERT_ID()";
      Statement stmt = conn_mysql.createStatement();
      ResultSet rs = stmt.executeQuery(A);

      if(rs.next()) {
        recentlyID = rs.getInt(1);
      }
      rs.close();
      stmt.close();

      //이미지 테이블에 Insert
      A = "INSERT INTO FeedImage (fiName, fNo) ";
	    B = "VALUES(?, ?)";

      ps = conn_mysql.prepareStatement(A+B);
      ps.setString(1, file.getName());
      ps.setInt(2, recentlyID);
      ps.executeUpdate();
      ps.close();

	    conn_mysql.close();
      out.println("done");
	}

	catch (Exception e){
	    e.printStackTrace();
      out.println(e);
    }

%>
