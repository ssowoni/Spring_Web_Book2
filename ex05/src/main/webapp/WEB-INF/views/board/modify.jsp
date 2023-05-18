<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@include file="../includes/header.jsp" %>


<style>
.uploadResult {
  width:100%;
  background-color: gray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
}
.uploadResult ul li span {
  color:white;
}
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
  background:rgba(255,255,255,0.5);
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
<!-- 첨부파일 삭제 후 새로 생성 스크립트  -->
<script>
	$(document).ready(function(){
		
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList",{bno:bno},function(arr){
			console.log(arr);
			
			var str = "";
		$(arr).each(function(i,attach){
	         //image type
	          if(attach.fileType){
	            var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
	            
	            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
	            str +=" data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
	            str += "<span> "+ attach.fileName+"</span>";
	            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "
	            str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
	            str += "<img src='/display?fileName="+fileCallPath+"'>";
	            str += "</div>";
	            str +"</li>";
	          }else{
	              
	            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
	            str += "data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
	            str += "<span> "+ attach.fileName+"</span><br/>";
	            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
	            str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
	            str += "<img src='/resources/img/attach.PNG'></a>";
	            str += "</div>";
	            str +"</li>";
	          }
	       });

		       
		       $(".uploadResult ul").html(str);
		});
		
		
		//  x 버튼 누르면 일단 화면에서만 삭제한다. 
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			if(confirm("Remove this file?")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		
		
		//파일 수정하려고 다시 등록 
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
		
		
		
		

	});
		

	
	
</script>
<!-- 게시글 관련 스크립트  -->
<script>
	$(document).ready(function(){
		
		//★ form이라는 태그 가져오기 
		//그럼 안에 있는 요소 모두가 가져오게 된다. bno, title, content, writer ....... 
		var formObj = $("form");
		
		//$("button[name='modify']").click(function ()
		//버튼 태그를 눌렀을 때 아래 js 실행. 
		
		//이벤트가 발생하면 이벤트 객체가 생성되고 그 이벤트 객체가 e라는 매개변수에 할당이 된다.
		//따라서 e를 적지 않으면 아래 operation 변수에 값이 할당되지 않는 것. 
		$('button').on("click",function(e){
			
			//<form> 태그의 모든 버튼이 기본적으로 submit으로 처리하기 때문에
			//↓ 없을 경우 submit 됨과 동시에 창이 다시 실행됨
			e.preventDefault();
			
			var operation = $(this).data("oper");
			console.log(operation);
			
		
		  if(operation === 'remove'){
			  //선택한 요소에 속성을 추가한다.
		      formObj.attr("action", "/board/remove");	
			}else if(operation ==='list'){
				/* self.location = "/board/list";
				return; */
				formObj.attr("action", "/board/list").attr("method","get");
				
				//input 태그에 name이 pageNum인 값
				//clone은 해당 요소의 값을 복제한다. 
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
				
			}else if(operation === 'modify'){
		        
		        console.log("submit clicked");
		        
		        var str = "";
		        
		        $(".uploadResult ul li").each(function(i, obj){
		          
		          var jobj = $(obj);
		          
		          console.dir(jobj);
		          
		          str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
		          str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
		          str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
		          str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
		          
		        });
		        formObj.append(str).submit();
	        }
		  formObj.submit();
			
		});
		
		
	});
	
	 

	
	
</script>



            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Modify
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                        	<form role="form" action="/board/modify" method="post">
                        	<input type='hidden' name='pageNum' value='${cri.pageNum}'>
							<input type='hidden' name='amount' value='${cri.amount}'>
							<input type='hidden' name='type' value='<c:out value="${ cri.type}"/>'>
							<input type='hidden' name='keyword' value='<c:out value="${ cri.keyword}"/>'>
                        	
                       		<div class="form-group">
                       			<label>Bno</label>
                       			<input class="form-control" name='bno'
                       				value='<c:out value="${board.bno}"/>' readonly="readonly">
                       		</div>
                       	
                       		<div class="form-group">
                       			<label>Title</label>
                       			<input class="form-control" name='title'
                       			value='<c:out value="${board.title}"/>' >
                       		</div>
                       		<div class="form-group">
                       			<label>Text area</label>
                       			<textarea class="form-control" rows="3" name='content' >
                       			<c:out value="${board.content}"></c:out></textarea>
                       		</div>
                       		<div class="form-group">
                       			<label>Writer</label>
                       			<input class="form-control" name='writer'
                       			value='<c:out value="${board.writer}"/>' >
                       		</div>
           		      		<div class="form-group">
                       			<label>RegDate</label>
                       			<input class="form-control" name='regDate'
                       			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly="readonly" >
                       		</div>
                       		<div class="form-group">
                       			<label>UpdateDate</label>
                       			<input class="form-control" name='updateDate'
                       			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly">
                       		</div>
                       		<!-- data- 로 시작하는 속성을 임의로 만들 수 있다.
                       			여기선 data-oper로 만들어두고 js에서 var operation = $(this).data("oper"); 이런식으로 사용.  -->
                       		<button type='submit' data-oper='modify' class="btn btn-default">Modify</button>
                       		<button type='submit' data-oper='remove' class="btn btn-default">Remove</button>
                       		<button data-oper='list' class="btn btn-default">List</button>
                       		
                       		
                       		</form>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
            
            
            
             <!-- 첨부 파일 원본 이미지 보여주기 -->
            <div class='bigPictureWrapper'>
            	<div class='bigPicture'></div>
            </div>
            
            
           
			<!-- 첨부 파일 목록 보여주기  -->
			<div class="row">
			  <div class="col-lg-12">
			    <div class="panel panel-default">
			
			      <div class="panel-heading">Files</div>
			      <!-- /.panel-heading -->
			      <div class="panel-body">
			        <div class="form-group uploadDiv">
			       		<input type="file"  name='uploadFile' multiple = "multiple">
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