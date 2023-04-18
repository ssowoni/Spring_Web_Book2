<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@include file="../includes/header.jsp" %>


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



<%@include file="../includes/footer.jsp" %>