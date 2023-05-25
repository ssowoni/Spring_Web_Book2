<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
<script type="text/javascript" src="/resources/js/reply.js"></script>

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

<!-- 게시글 조회에 관한 스크립트 -->
<script>
   $(document).ready(function(){
      
      var operForm = $("#operForm");
      
      
      $("button[data-oper='modify']").on("click",function(e){
         operForm.attr("action", "/board/modify").submit();
      });
      
      $("button[data-oper='list']").on("click",function(e){
         operForm.find("#bno").remove();
         operForm.attr("action", "/board/list");
         operForm.submit();
      });
      
      
      
      
      
   })
</script>

<!-- 게시물 댓글 첨부파일 불러오기 -->
<script>
	$(document).ready(function(){
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList",{bno:bno},function(arr){
			console.log(arr);
			
			var str = "";
			
			 $(arr).each(function(i, attach){
			       
		         //image type
		         if(attach.fileType){
		           var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
		           
		           str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
		           str += "<img src='/display?fileName="+fileCallPath+"'>";
		           str += "</div>";
		           str +"</li>";
		         }else{
		             
		           str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
		           str += "<span> "+ attach.fileName+"</span><br/>";
		           str += "<img src='/resources/img/attach.PNG'></a>";
		           str += "</div>";
		           str +"</li>";
		         }
		       });
		       
		       $(".uploadResult ul").html(str);
			
		})
		
			
		  $(".uploadResult").on("click","li", function(e){
		      
		    console.log("view image");
		    
		    var liObj = $(this);
		    
		    //파일 저장되어 있는 경로 찾아가기 
		    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
		    
		    //이미지면 1, 다른 파일이면 0
		    if(liObj.data("type")){
		    	//https://heropy.blog/2018/10/28/regexp/ 정규표현식 블로그 참고 
		    	//정규표현식 /표현식/플래그 이렇게 적는다. 
		    	//플래그 g는 모든 문자와 여러 줄 일치(global)
		      showImage(path.replace(new RegExp(/\\/g),"/"));
		    }else {
		      //download 
		      self.location ="/download?fileName="+path
		    }
		    
		    
		  });
		  
		  function showImage(fileCallPath){
			    
		    alert(fileCallPath);
		    
		    $(".bigPictureWrapper").css("display","flex").show();
		    
		    $(".bigPicture")
		    .html("<img src='/display?fileName="+fileCallPath+"' >")
		    .animate({width:'100%', height: '100%'}, 1000);
		    
		  }

		  $(".bigPictureWrapper").on("click", function(e){
		    $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
		    setTimeout(function(){
		      $('.bigPictureWrapper').hide();
		    }, 1000);
		  });
		  
	})
	
	
</script>


<!-- 댓글 처리에 관한 스크립트 -->
<script>
   $(document).ready(function(){
      console.log("==============");
      console.log("JS TEST");
      
      var bnoValue = '<c:out value="${board.bno}"/>';
      var replyUL = $(".chat");
      
      showList(1);
      
 
      
      function showList(page){
      	
      	  console.log("show list " + page);
          
          replyService.getList({bno:bnoValue,page: page|| 1 }, function(replyCnt, list) {
            
          console.log("replyCnt: "+ replyCnt );
          console.log("list: " + list);
          console.log(list);
          
          //-1이 들어오면 마지막 페이지를 찾아 다시 호출한다. 
          if(page == -1){
            pageNum = Math.ceil(replyCnt/10.0);
            showList(pageNum);
            return;
          }
            
           var str="";
           
           if(list == null || list.length == 0){
             return;
           }
           
           for (var i = 0, len = list.length || 0; i < len; i++) {
             str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
             str +="  <div><div class='header'><strong class='primary-font'>["
          	   +list[i].rno+"] "+list[i].replyer+"</strong>"; 
             str +="    <small class='pull-right text-muted'>"
                 +replyService.displayTime(list[i].replyDate)+"</small></div>";
             str +="    <p>"+list[i].reply+"</p></div></li>";
           }
           
           replyUL.html(str);
           
           showReplyPage(replyCnt);

       
         });//end function
           
       }//end showList
          
          var pageNum = 1;
          var replyPageFooter = $(".panel-footer");
          
          function showReplyPage(replyCnt){
            
            var endNum = Math.ceil(pageNum / 10.0) * 10;  
            var startNum = endNum - 9; 
            
            var prev = startNum != 1;
            var next = false;
            
            if(endNum * 10 >= replyCnt){
              endNum = Math.ceil(replyCnt/10.0);
            }
            
            if(endNum * 10 < replyCnt){
              next = true;
            }
            
            var str = "<ul class='pagination pull-right'>";
            
            if(prev){
              str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
            }
            
            for(var i = startNum ; i <= endNum; i++){
              
              var active = pageNum == i? "active":"";
              
              str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
            }
            
            if(next){
              str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
            }
            
            str += "</ul></div>";
            
            console.log(str);
            
            replyPageFooter.html(str);
          }
      
      
          //댓글 페이지 번호 클릭 시 해당 페이지로 이동
          replyPageFooter.on("click","li a", function(e){
              e.preventDefault();
              console.log("page click");
              
              // attr(attributeName) : 선택한 요소의 속성 값을 가져온다. 
              // href의 속성값은 페이지 번호 
              var targetPageNum = $(this).attr("href");
              
              console.log("targetPageNum: " + targetPageNum);
              
              pageNum = targetPageNum;
              
              showList(pageNum);
            });     

          
      
      //댓글 목록 보여주기 
      /*
       function showList(page){
         
         replyService.getList({bno:bnoValue, page:page || 1},function(list){
            var str = "";
            if(list ==null || list.length ==0){
               //ul채그의 chat class를 비운다 
               replyUL.html("");
               returnl;
            }
                for (var i = 0, len = list.length || 0; i < len; i++) {
                    str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                    str +="  <div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>"; 
                    str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
                    str +="    <p>"+list[i].reply+"</p></div></li>";
                  }
            
            replyUL.html(str);
            
         })   ;
      } //end showList */
      
     
      
 
      
        
       var modal = $(".modal");
      //사용자가 입력한 댓글 내용
       var modalInputReply = modal.find("input[name='reply']");
       var modalInputReplyer = modal.find("input[name='replyer']");
       var modalInputReplyDate = modal.find("input[name='replyDate']");
       
       var modalModBtn = $("#modalModBtn");
       var modalRemoveBtn = $("#modalRemoveBtn");
       var modalRegisterBtn = $("#modalRegisterBtn");
       
       var replyer= null;
       
       <sec:authorize access="isAuthenticated()">
       	replyer = '<sec:authentication property="principal.username"/>';
       </sec:authorize>
       
       
   	
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
       
       $("#modalCloseBtn").on("click", function(e){
          
          modal.modal('hide');
       });
       
       
       //새로운 댓글 작성하기
       $("#addReplyBtn").on("click", function(e){
         
         modal.find("input").val("");
         //로그인한 사용자 이름을 작성자로 넣어준다.
         modal.find("input[name='replyer']").val(replyer);
         modalInputReplyDate.closest("div").hide();//이 태그에서 가장 가까운 div 태그를 찾아서 숨긴다. 
         modal.find("button[id !='modalCloseBtn']").hide();//닫기 버튼 빼고 나머지들을 숨긴다. 
         
         modalRegisterBtn.show();
         
         $(".modal").modal("show");
         
       });
       
       //ajaxSend()를 이용하면 모든 ajax 전송시 CSRF 토큰을 같이 전송하도록 세팅되기 때문에
       //매번 ajax 사용 시 beforeSend를 호출해야 하는 번거로움을 줄일 수 있다. 
       $(document).ajaxSend(function(e,xhr,options){
    	   xhr.sendRequestHeader(csrfHeaderName, csrfTokenValue);
       });
       
       
       //모달창에서 댓글 등록하기 
        modalRegisterBtn.on("click",function(e){
           
           var reply = {
              reply : modalInputReply.val(),
              replyer : modalInputReplyer.val(),
              bno : bnoValue
           };
           
           replyService.add(reply, function(result){
              alert(result);
              modal.find("input").val("");
              modal.modal("hide");
              showList(-1);
           })
           
        })
        
        //댓글 조회하기
        //<ul>태그 클래스 'chat'을 이용해 이벤트를 걸고 실제 이벤트 대상은 <li> 태그가 되도록한다. 
         $(".chat").on("click","li",function(e){
           var rno = $(this).data("rno");
           console.log(rno);
           replyService.get(rno,function(reply){
              modalInputReply.val(reply.reply);
              modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
              modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
              modal.data("rno", reply.rno);
              
              modal.find("button[id !='modalCloseBtn']").hide();//닫기 버튼 빼고 나머지들을 숨긴다. 
                 
               modalModBtn.show();
               modalRemoveBtn.show();
              
               $(".modal").modal("show");
              
           });
        }); 

        
        
         modalModBtn.on("click", function(e){
              console.log(modal.data("rno"));
              var reply = {rno:modal.data("rno") , reply: modalInputReply.val()};
              
              replyService.update(reply, function(result){
                    
                alert(result);
                modal.modal("hide");
                showList(pageNum);
                
              });
              
            });

         modalRemoveBtn.on("click", function (e){
              
            var rno = modal.data("rno");
            
            replyService.remove(rno, function(result){
                  
                alert(result);
                modal.modal("hide");
                showList(pageNum);
                
            });
            
          });
        
     
        

       
       
       
       
      
      
      
      //reply.js에서 replyService라는 이름의 객체를 생성하였다.
      //이 객체의 add함수의 파라미터로 (reply,callback,error)를 받는다.
      //js는 함수의 파라미터 개수를 일치시킬 필요가 없기 때문에, callback이나 error는 필요에 따라 작성.
    /*  replyService.add(
         {reply : "JS TEST22", replyer:"tester22", bno:bnoValue}
         ,
         function(result){
            alert("RESULT : " +result);
         }
      );   */
      
      
      
/*       replyService.remove(26, function(count){
         console.log(count);
         if(count === "success"){
            alert("removed");
         }
      }, function(err){
         alert('error');
      });  */
      
/*        replyService.update({
         rno : 5,
         reply : "JS update TEST", replyer:"update tester"
      }, function(result){
         alert("수정 : " + result);
      })  */
      
   /*    replyService.get(5,function(data){
         console.log(data);
      }) */

      
   });

</script>



            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Detail</h1>
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
                             <div class="form-group">
                                <label>Bno</label>
                                <input class="form-control" name='bno'
                                   value='<c:out value="${board.bno}"/>' readonly="readonly">
                             </div>
                          
                             <div class="form-group">
                                <label>Title</label>
                                <input class="form-control" name='title'
                                value='<c:out value="${board.title}"/>' readonly="readonly">
                             </div>
                             <div class="form-group">
                                <label>Text area</label>
                                <textarea class="form-control" rows="3" name='content'  readonly="readonly">
                                <c:out value="${board.content}"></c:out></textarea>
                             </div>
                             <div class="form-group">
                                <label>Writer</label>
                                <input class="form-control" name='writer'
                                value='<c:out value="${board.writer}"/>' readonly="readonly">
                             </div>
<%--                              <button data-oper='modify' class="btn btn-default" 
                                 onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
                             <button data-oper='list' class="btn btn-default"
                                onclick="location.href='/board/list'">List</button> --%>
                                
                                
                              <sec:authentication property="principal" var="pinfo"/>
                              	<sec:authorize access="isAuthenticated()">
                              		<c:if test="${pinfo.username eq board.writer }">
                           				<button data-oper='modify' class="btn btn-default">Modify</button>
                              		</c:if>
                              	</sec:authorize>  
                                
                             <!-- <button data-oper='modify' class="btn btn-default">Modify</button> -->
                             <button data-oper='list' class="btn btn-default">List</button>
                             <form id="operForm" action="/board/modify" method="get">
                                <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno }"/>'>
                                <input type='hidden' name='pageNum' value='${cri.pageNum}'>
		                        <input type='hidden' name='amount' value='${cri.amount}'>
		                        <input type='hidden' name='type' value='<c:out value="${ cri.type}"/>'>
		                        <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
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
            
            
            
            
            
	         <!-- 댓글창 보여주기 -->   
	         <div class='row'>
	         
	           <div class="col-lg-12">
	         
	             <!-- /.panel -->
	             <div class="panel panel-default">
	           <!--     <div class="panel-heading">
	                 <i class="fa fa-comments fa-fw"></i> Reply
	               </div> -->
	               <div class="pamel-heading">
	                  <i class="fa fa-comments fa-fw"></i> Reply 
	                  <sec:authorize access="isAuthenticated()">
	                  <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
	                  </sec:authorize>
	               </div>
	                 
	               
	               
	               <!-- /.panel-heading -->
	               <div class="panel-body">        
	               
	                 <ul class="chat">
	                  <!-- start reply -->
	                  <li class="left clearfix" data-rno='12'>
	                     <div>
	                        <!-- <div class="header">
	                           <strong class ="primary-font">user00</strong>
	                           <small class="pull-right text-muted">2020-05-02 13:13</small>
	                        </div>
	                        <p>Good job!</p> -->
	                     </div>
	                  
	                  </li>
	                 </ul>
	                 <!-- ./ end ul -->
	               </div>
	               <!-- /.panel .chat-panel -->
	               
	               
	               
	               
	               <!-- 댓글 모달창 -->
	               
	            <!-- Modal -->
	                  <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	                    aria-labelledby="myModalLabel" aria-hidden="true">
	                    <div class="modal-dialog">
	                      <div class="modal-content">
	                        <div class="modal-header">
	                          <button type="button" class="close" data-dismiss="modal"
	                            aria-hidden="true">&times;</button>
	                          <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
	                        </div>
	                        <div class="modal-body">
	                          <div class="form-group">
	                            <label>Reply</label> 
	                            <input class="form-control" name='reply' value='New Reply!!!!'>
	                          </div>      
	                          <div class="form-group">
	                            <label>Replyer</label> 
	                            <input class="form-control" name='replyer' value='replyer'>
	                          </div>
	                          <div class="form-group">
	                            <label>Reply Date</label> 
	                            <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
	                          </div>
	                  
	                        </div>
	                     <div class="modal-footer">
	                             <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
	                             <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
	                             <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
	                             <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
	                     </div>          
	                     </div>
	                      <!-- /.modal-content -->
	                    </div>
	                    <!-- /.modal-dialog -->
	                  </div>
	                  <!-- /.modal -->
	               
	               
	               
	               
	         
	            	<div class="panel-footer"></div>
	         
	         
	               </div>
	           </div>
	           <!-- ./ end row -->
	         </div>
	         
            
            
            



<%@include file="../includes/footer.jsp" %>