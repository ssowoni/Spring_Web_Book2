package com.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.zerock.domain.BoardAttachVO;
import com.zerock.domain.BoardVO;
import com.zerock.domain.Criteria;
import com.zerock.domain.PageDTO;
import com.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/board")
@Log4j2
@AllArgsConstructor
public class BoardController {

	private BoardService service;
	
	//Criteria 클래스를 하나 만들어두면 아래와 같이 하나의 타입만으로 파라미터나 리턴 타입을 사용할 수 있음.
	//만약 Criteria를 클래스로 만들지 않는다면? 
	//@RequestParam Map<String, Object> paramMap 이런식으로 paramMap으로 가져와서 사용해야됨
	//아니면 따로 각각의 값을 받아올 수도 있고 
	@GetMapping("/list")
	public void list(Model model, @ModelAttribute Criteria cri) {
		log.info("===========list");
		//List<BoardVO> boardList = service.getList();
		List<BoardVO> boardList = service.getList(cri);
		int totalCount = service.getTotalCount(cri);
		model.addAttribute("list", boardList);
		model.addAttribute("pageMaker", new PageDTO(cri, totalCount));
		
	}
	
	
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	
	@PostMapping("/register")
	public String register(@ModelAttribute BoardVO board, RedirectAttributes rttr) {
		log.info("===========================");
		log.info("register : " + board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		log.info("===========================");
		
		  service.register(board); 
		  rttr.addFlashAttribute("result", board.getBno());
		 
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
	//@ModelAttribute는 자동으로 Model에 데이터를 지정한 이름으로 담아준다. 
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("==========get : " + bno);
		BoardVO board = service.get(bno);
		model.addAttribute("board", board);
	}
	
	
	@PostMapping("/modify")
	public String modify(@ModelAttribute BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("==========modify : " + board);
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		//paramMap을 같은 map 형식으로 데이터를 넘겨줄 수도 있고
		//따로 클래스 객체로 생성해서 사용할 수도 있다. 
		//삭제에서는 파라미터를 처리하는 getListLink 메서드를 cri 클래스에 만들어뒀다. 참고! 
		rttr.addAttribute("pageNum",cri.getPageNum() );
		rttr.addAttribute("amount",cri.getAmount() );
		rttr.addAttribute("type",cri.getType() );
		rttr.addAttribute("keyword",cri.getKeyword() );
		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,  RedirectAttributes rttr) {
		log.info("==========remove : " + bno);
		
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			log.info("controller: remove true from service");
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		//addAttribute는 URL에 붙어서 전달되어 값이 유지가 되지만 
		//addFlashAttribute는 일회성으로 URL에 붙지 않고 세션 후 재지정 요청이 들어오면 값은 사라지게 됩니다.

		
		/*
		 * rttr.addAttribute("pageNum",cri.getPageNum() );
		 * rttr.addAttribute("amount",cri.getAmount() );
		 * rttr.addAttribute("type",cri.getType() );
		 * rttr.addAttribute("keyword",cri.getKeyword() );
		 */
		
		return "redirect:/board/list" + cri.getListLink();
		
	}
	
	@GetMapping(value="/getAttachList",
				produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList" + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	
		private void deleteFiles(List<BoardAttachVO> attachList) {
	    
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files...................");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("C:\\uploadBook\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
	        
	        Files.deleteIfExists(file);
	        
	        if(Files.probeContentType(file).startsWith("image")) {
	        
	          Path thumbNail = Paths.get("C:\\uploadBook\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
	          
	          Files.delete(thumbNail);
	        }
	
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }//end catch
	    });//end foreachd
	  }
	
	
	
}
