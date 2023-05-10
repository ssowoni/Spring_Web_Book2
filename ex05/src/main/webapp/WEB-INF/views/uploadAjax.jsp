<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 이 DTD는 모든 HTML 요소와 속성들뿐만 아니라 더 이상 사용되지 않거나 아직 정식으로 포함되지 못한 요소들까지도 포함하고 있습니다. 
하지만 프레임셋(frameset) 콘텐츠의 사용은 허용하지 않습니다. --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>upload whit ajax</title>
</head>
<script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		
		//파일 크기와 확장자 처리
		//regex = Regular Expression 정규표현식
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz$)");
		var maxSize = 5242880; // 5MB
		
		function checkExtension(fileName, fileSize){
			if(fileSize > maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		
		
		$("#uploadBtn").on("click", function(e){
			
			//FormData는 가상의 <form> 태그와 같다. 
			//ajax를 이용하는 파일 업로드는 FormData를 이용해 필요한 파라미터를 담아 전송한다. 
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			//<input>태그 그 자체를 가져온다. 
			console.log(inputFile[0]);
			//.files로 files에 배열 객체를 참조할 수 있다. 
			var files = inputFile[0].files; 
		
			console.log(files);
			
			//add file data to format
			for(var i=0; i<files.length; i++){
				
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
				formData.append("uploadFile", files[i]);
				
			}
			
			//ajax를 통해 서버의 url로 요청을 보낸다. 그때 formData 객체 자체를 전달함 
			// processData와 contentType은 반드시 false로 지정해야 됨. 
			$.ajax({
				url : '/uploadAjaxAction',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				dataType : 'json',
				success : function(result){
					console.log(result);
					alert("uploaded");
				}
			}); //$.ajax
			
			
		});
	});

</script>

<body>

	<h1>Upload with Ajax</h1>
	
	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>
	
	<button id='uploadBtn'>Upload</button>


</body>
</html>