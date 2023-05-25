<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<!-- 파일 업로드에서 가장 신경써야 하는 부분이다.  -->
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type='file' name='uploadFile' multiple>
		<button>Submit</button>
	</form>

</body>
</html>