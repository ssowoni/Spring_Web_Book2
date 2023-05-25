/**
 * 
 */
 console.log("Reply Module....");
 
 var replyService = (function(){
	
	//만일 Ajax 호출이 성공하고, callback 값으로 적절한 함수가 존재한다면
	//해당 함수를 호출해서 결과를 반영하는 방식이다. 
	function add(reply, callback,error){
		console.log("add reply..........");
		
		$.ajax({
			type : 'post',
			url : '/replies/new', //클라이언트가 요청을 보낼 서버의 URL
			data : JSON.stringify(reply), //HTTP 요청과 함께 서버로 보낼 데이터
			contentType : "application/json; charset=utf-8", //서버에 보낼 데이터 전송 타입
			success : function(result,status,xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})
		
	}
	
		
	//댓글 페이징과 숫자 목록을 가져오게 변경
	function getList(param, callback, error) {
	
	    var bno = param.bno;
	    var page = param.page || 1;
	    //$.getJSON: 전달받은 주소로 GET 방식의 HTTP 요청을 전송하여, 응답으로 JSON 파일을 전송받음.
	    //url은 '/replies/pages/게시물번호/페이지번호' 형태이다.
	    $.getJSON("/replies/pages/" + bno + "/" + page,
	        function(data) {
	            if (callback) {
	                //callback(data); //댓글 목록만 가져오는 경우
	                callback(data.replyCnt,data.list);//댓글 숫자와 목록을 가져오는 경우
	            }
	        }).fail(function(xhr, status, err) {
	        if (error) {
	            error();
	        }
	    });
	}
	
	function remove(rno, callback,error){
		//console.log("rno : " + rno);
			$.ajax({
				type:'delete',
				url : '/replies/' + rno,
				success : function(deleteResult,status,xhr){
					if(callback){
						callback(deleteResult);
					}
				},
				error : function(xhr, status, er){
					if(error){
						error(er);
					}
				}
		});
		}
		
	function update(reply, callback, error){
		
		var rno = reply.rno;
		//console.log("rno : " + rno);
		$.ajax({
			type : 'patch',
			url : '/replies/' + rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	function get(rno, callback, error){
		$.get("/replies/"+rno, function(result){
			if(callback){
				callback(result);
			}
		}).fail(function(xhr,status,err){
			if(error){
				error();
			}
		});
	}	
	
	function displayTime(timeValue){
		
		var today = new Date();
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		//차이 값을 하루의 밀리초인(1000 * 60 * 60 * 24)으로 나눠주면 밀리초가 아닌 일 단위 값을 얻을 수 있습니다.
		//그러니 댓글 조회 날짜랑 댓글이 등록된 날짜랑 하루 차이가 나지 않는다면,
		if(gap < (1000*60*60*24)){
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [(hh>9?'':'0') + hh,':', (mi >9?'':'0')+mi,':',(ss>9?'':'0') +ss].join('');
		}else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1; //getMonth() is zero-based
			var dd = dateObj.getDate();
			
			return [yy,'/',(mm>9?'':'0')+mm, '/', (dd>9?'':'0')+dd].join('');
			
			}
		
	};
		
		
		
	
	

	
	return {
		add:add,
		getList:getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};
	
})();