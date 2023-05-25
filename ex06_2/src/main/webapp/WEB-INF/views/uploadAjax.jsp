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
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

/*이미지 크기 설정 */
.uploadResult ul li img {
	width: 20px;
}
</style>

<style>
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}
.bigPicture img {
	width:600px;
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
<script type="text/javascript">

	//a태그에 직접 showImage를 호출할 수 있는 방식으로 작성하기 위해 document.. 밖에 작성한다. 
	function showImage(fileCallPath){
	  
		  //alert(fileCallPath);
			console.log("사진 클릭함! 커져랏");
		  $(".bigPictureWrapper").css("display","flex").show();
		  
		  $(".bigPicture")
		  .html("<img src='/display?fileName="+ encodeURI(fileCallPath)+"'>")
		  .animate({width:'100%', height: '100%'}, 1000);
	
		}
		
	



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
		
		var uploadResult = $(".uploadResult ul");

		 function showUploadFile(uploadResultArr){
		 
		   var str = "";
		 //http://localhost:8080/display?fileName=2023%5C05%5C15%2Fs_e48c1b7a-e0bf-41a3-aa60-2a83eb7bbe42_KakaoTalk_20220318_182725289.jpg
		   $(uploadResultArr).each(function(i, obj){
		     
		     if(!obj.image){
		       
		       var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
		       
		       var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
		       
		       str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"+
		           "<img src='/resources/img/attach.PNG'>"+obj.fileName+"</a>"+
		           "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"+
		           "<div></li>"
		           
		     }else{
		       
		       var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
		       
		       var originPath = obj.uploadPath+ "\\"+obj.uuid +"_"+obj.fileName;
		       
		       originPath = originPath.replace(new RegExp(/\\/g),"/");
		       
		       str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+
		              "<img src='display?fileName="+fileCallPath+"'></a>"+
		              "<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+
		              "<li>";
		     }
		   });
		   
		   uploadResult.append(str);
		 }
		 
		 /*
			제이쿼리는 이벤트의 위임을 통해 다수의 요소에 공통으로 적용되는 이벤트 핸들러를 공통된 조상 요소에 단 한 번만 연결하면 동작할 수 있도록 해줍니다.		 
			.on() 메소드는 해당 요소에 첫 번째 인수로 전달받은 이벤트가 전파되었을 때, 그 이벤트를 발생한 요소가 두 번째 인수로 전달받은 선택자와 같은지를 검사합니다.
			만약 이벤트가 발생한 요소와 두 번째 인수로 전달받은 선택자가 같으면, 연결된 이벤트 핸들러를 실행합니다.
		 */
		 
		 //<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>
		 $(".uploadResult").on("click","span",function(e){
			 
			 var targetFile = $(this).data("file");
			 var type = $(this).data("type");
			 console.log(targetFile);
			 
			 $.ajax({
				 url : '/deleteFile',
				 data : {fileName: targetFile, type:type},
				 dataType: 'text',
				 type : 'POST',
				 success : function(result){
					 alert(result);
				 }
			 })
			 
		 })
		 
		 
		 
		 
		// 첨부파일 업로드 하기 전에 아무 내용 없는 <input type='file'> 객체가 포함된 <div>를 복사한다. 
		var cloneObj = $(".uploadDiv").clone();
		
		//파일 업로드 버튼 클릭 시 
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
					alert("uploaded");
					//result값에 null이 들어온다.. file 이름만 
					console.log(result);
					showUploadFile(result);
					$('.uploadDiv').html(cloneObj.html());
				}
			}); //$.ajax
			
			
		});
		
		
		$(".bigPictureWrapper").on("click", function(e){
			console.log("사진 클릭함! 줄어드러랏");
		  $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
	/* 	  setTimeout(() => {
		    $(this).hide();
		  }, 1000); */
		  
		  setTimeout(function() {
			  $(".bigPicture").hide();
		  }, 1000);
		  
		});
		
	});

</script>

<body>

	<h1>Upload with Ajax</h1>
	
	<div class='uploadDiv'>
		<!-- readOnly라 안쪽의 내용을 수정할 수 없다. 
			따라서 별도의 방법으로 초기화가 필요하다. (파일을 추가하기 위해서) -->
		<input type='file' name='uploadFile' multiple>
	</div>
	
	<button id='uploadBtn'>Upload</button>
	
	<div class='uploadResult'>
		<ul>
			<!-- 업로드된 파일 섬네일을 , 파일명을 보여줄 예정  -->
		</ul>
	</div>
	
	<div class='bigPictureWrapper'>
		<div class='bigPicture'>
		</div>
	</div>


</body>
</html>