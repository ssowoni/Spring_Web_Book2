package com.zerock.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
		log.info("==========register : " + board);
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
		rttr.addAttribute("pageNum",cri.getPageNum() );
		rttr.addAttribute("amount",cri.getAmount() );
		rttr.addAttribute("type",cri.getType() );
		rttr.addAttribute("keyword",cri.getKeyword() );
		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,  RedirectAttributes rttr) {
		log.info("==========remove : " + bno);
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		//addAttribute는 URL에 붙어서 전달되어 값이 유지가 되지만 
		//addFlashAttribute는 일회성으로 URL에 붙지 않고 세션 후 재지정 요청이 들어오면 값은 사라지게 됩니다.


		rttr.addAttribute("pageNum",cri.getPageNum() );
		rttr.addAttribute("amount",cri.getAmount() );
		rttr.addAttribute("type",cri.getType() );
		rttr.addAttribute("keyword",cri.getKeyword() );
		return "redirect:/board/list";
		
	}
	
	
}
