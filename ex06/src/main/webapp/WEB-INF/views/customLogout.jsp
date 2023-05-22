<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Logout Page</h1>
	<form action="/customLogout" method='post'>
		<!-- csrf token 서버에 들어온 요청이 실제 서버에서 허용한 요청이 맞는지 확인하기 위한 토큰 
			CSRF는 사용자가 임의로 변하는 특정한 토큰값을 서버에서 체크하는 방식이다. 
			서버에는 브라우저에 데이터를 전송할 때 CSRF 토큰을 같이 전송한다.
			사용자가 POST 방식 등으로 특정 작업을 할 때 브라우저에서 전송된 CSRF 토큰의 값과 서버가 보관하고 있는 값을 비교한다. 
			만일 CSRF 토큰 값이 다르면 작업을 처리하지 않는 방식이다. 
			-->
		<!-- <input type="hidden" name="_csrf" value="a63a6e1f-9a02-426a-b2e1-7b65f11c4dc4"> -->
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		<button>로그아웃</button>
		
	</form>
</body>
</html>