package com.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.zerock.domain.Criteria;
import com.zerock.domain.ReplyPageDTO;
import com.zerock.domain.ReplyVO;
import com.zerock.service.ReplyService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RequestMapping("/replies/")
@RestController
@Log4j2
@RequiredArgsConstructor
public class ReplyController {
	
	private final ReplyService service;
	
	
	//★Rest 방식으로 처리할 때는 브라우저나 외부에서 서버를 호출할 때
	//데이터 포맷과 서버에서 보내주는 데이터 타입을 명확히 설계해야된다. 
	//ex) 댓글 등록의 경우 브라우저에서는 JSON 타입으로된 댓글 데이터 전송,
	// 서버에서는 댓글 처리 결과가 정상적으로 처리 되었는지 문자열로 알려줌. 
	
	
	/*
	 * consumes는 브라우저에서 서버로 들어오는 데이터 타입을 정의할 때 이용한다. 
	 * 예를 들어 내가 json타입을 받고 싶다면 아래와 같이 설정. 
	 * produces는 서버에서 브라우저로 반환하는 데이터 타입을 정의한다. 
	 * @RequestBody를 적용해 JSON 데이터를 ReplyVO 타입으로 변환하도록 지정
	 * 즉) HTTP message body 내용을 읽어와서  다음과 같이 작업함. JSON -> HTTP 메시지 컨버터 -> 객체
	 */	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/new"
				,consumes = "application/json"
				,produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("======== Replycontroller create . ReplyVO: " + vo);
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT: " + insertCount);
		
		return insertCount ==1 ? new ResponseEntity<>("success", HttpStatus.OK)
								: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	
	//요청 파라미터와 다르게, HTTP BODY를 통해 데이터가 들어오는 경우는 @RequestParam, @ModelAttribute 사용 불가.
	//요청 파라미터는 get방식의 쿼리 스트링, post 방식에 form으로 전송한 쿼리 데이터들! 
	
	// ResponseEntity는 사용자의 HttpRequest에 대한 응답 데이터를 포함하는 클래스이다. 
	//따라서 HttpStatus, HttpHeaders, HttpBody를 포함한다. 
	
	@GetMapping(value="/pages/{bno}/{page}"
				,produces = MediaType.APPLICATION_JSON_VALUE
				 )
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno") Long bno, @PathVariable("page") int page){
		
		Criteria cri = new Criteria(page,10);
		//List<ReplyVO> list = service.getList(cri, bno);
		ReplyPageDTO list = service.getListPage(cri, bno);
		log.info("========== Replycontroller getListPage " + list);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	
	
	
	
	
	
	@GetMapping(value="/{rno}"
				,produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("======== Replycontroller get . rno: " + rno);
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);
	}
	
	@DeleteMapping(value="/{rno}"
			,produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		
		log.info("======== Replycontroller remove . rno: " + rno);
		int result = service.remove(rno);
		
		return result ==1 ? new ResponseEntity<>("success",HttpStatus.OK)
							: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	
	@PatchMapping(value="/{rno}"
					,consumes = "application/json"
					,produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@PathVariable("rno") Long rno, @RequestBody ReplyVO vo){
		
		vo.setRno(rno);
		log.info("======== Replycontroller remove . rno: " + rno);
		int result = service.modify(vo);
		
		return result ==1 ? new ResponseEntity<>("success",HttpStatus.OK)
							: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
		
	
	
	
	

}
