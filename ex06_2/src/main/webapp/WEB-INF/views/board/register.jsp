<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>

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

.uploadResult ul li img {
	width: 100px;
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
</style>
<script type="text/javascript">
	$(document).ready(function(e){
		
		var formObj = $("form[role='form']");
		
		//게시글 등록 버튼 클릭
		$("button[type='submit']").on("click",function(e){
			e.preventDefault(); //원래 submit 기능을 막는다. 
			console.log("submit clicked");
			
			 var str = "";
			    
			 	//첨부된 파일 각각 하나 ( 즉 여러개 첨부했을 때 하나의 파일 )
			    $(".uploadResult ul li").each(function(i, obj){
			      
			      var jobj = $(obj);
			      
			      console.dir(jobj);
			      console.log("-------------------------");
			      console.log(jobj.data("filename"));
			      
			      //브라우저에서 게시물 등록을 선택하면 이미 업로드된 항목들을 내부적으로 hidden 태그로 만들어 form 태그가 submit 될때 같이 전송
			      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			      
			    });
			    
			    console.log(str);
			    
			    formObj.append(str).submit();
			
		});
		
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
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		//파일 업로드 되면 
		$("input[type='file']").change(function(e){
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
				//beforeSend는 ajax로 데이터 전송할 떄 추가적인 헤더를 지정해서 전송한다.
				beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				}
				data : formData,
				type : 'POST',
				dataType : 'json',
				success : function(result){
					alert("uploaded");
					//result값에 null이 들어온다.. file 이름만 
					console.log(result);
					showUploadFile(result);
					//$('.uploadDiv').html(cloneObj.html());
				}
			}); //$.ajax
		})
		
		//섬네일 보여주기 
		function showUploadFile(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.length ==0){return;}
			var uploadUL = $(".uploadResult ul");
			var str ="";
			
			   var str = "";
			 //http://localhost:8080/display?fileName=2023%5C05%5C15%2Fs_e48c1b7a-e0bf-41a3-aa60-2a83eb7bbe42_KakaoTalk_20220318_182725289.jpg
			   $(uploadResultArr).each(function(i, obj){
			     
				 //image type
					
				if(obj.image){
					var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"'";
					str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
					str +" ><div>";
					str += "<span> "+ obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' "
					str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str +"</li>";
				}else{
					var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
				    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				      
					str += "<li "
					str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
					str += "<span> "+ obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.PNG'></a>";
					str += "</div>";
					str +"</li>";
				}
		   });
			   
			   uploadUL.append(str);
		 }
		
		//섬네일에서 파일 업로드하려한 거 삭제하기 
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			
			 var targetFile = $(this).data("file");
			 var type = $(this).data("type");
			 console.log(targetFile);
			 
			 //현재 미리보기로 보여지는 섬네일 이미지도 삭제 
			 var targetLi = $(this).closest("li");
			 
			 
			 $.ajax({
				 url : '/deleteFile',
				 data : {fileName: targetFile, type:type},
				 //beforeSend는 ajax로 데이터 전송할 떄 추가적인 헤더를 지정해서 전송한다.
				 beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				 },
				 dataType: 'text',
				 type : 'POST',
				 success : function(result){
					 alert(result);
					 targetLi.remove(); 
					
				 }
			 })
		})
		
		
		
	});
	
</script>


            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Register</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Register
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                        	<form role="form" action="/board/register" method="post">
                        	<!-- 스프링 시큐리티 사용할 때 POST 방식의 전송은 반드시 CSRF 토큰을 사용하도록 추가한다.  -->
                        	<input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />
                        		<div class="form-group">
                        			<label>Title</label>
                        			<input class="form-control" name='title'>
                        		</div>
                        		<div class="form-group">
                        			<label>Text area</label>
                        			<textarea class="form-control" rows="3" name='content'></textarea>
                        		</div>
                        		<div class="form-group">
                        			<label>Writer</label>
                        			<input class="form-control" name='writer'
                        				value='<sec:authentication property="principal.username"/>' readonly='readonly'>
                        		</div>
                        		<button type="submit" class="btn btn-default">Submit Button</button>
                        		<button type="reset" class="btn btn-default">Reset Button</button>
                        		<button type="button" class="btn btn-default" onClick="location.href='/board/list'">List</button>
                        	</form>
                            
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
            
            
           
			<div class="row">
			  <div class="col-lg-12">
			    <div class="panel panel-default">
			
			      <div class="panel-heading">File Attach</div>
			      <!-- /.panel-heading -->
			      <div class="panel-body">
			        <div class="form-group uploadDiv">
			            <input type="file" name='uploadFile' multiple>
			        </div>
			        
			        <div class='uploadResult'> 
			          <ul>
			          
			          </ul>
			        </div>
			        
			        
			      </div>
			      <!--  end panel-body -->
			
			    </div>
			    <!--  end panel-body -->
			  </div>
			  <!-- end panel -->
			</div>
			<!-- /.row -->
            
            



<%@include file="../includes/footer.jsp" %>