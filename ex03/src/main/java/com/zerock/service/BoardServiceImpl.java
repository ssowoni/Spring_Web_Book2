package com.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.zerock.domain.BoardVO;
import com.zerock.domain.Criteria;
import com.zerock.mapper.BoardMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	
	private final BoardMapper mapper;
	
	
//	@Override
//	public List<BoardVO> getList() {
//		log.info("getList....." );
//		return mapper.getList();
//	}
	
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList whit criteria....." + cri);
		return mapper.getListWithPaging(cri);
	}

	
	
	
	@Override
	public void register(BoardVO board) {

		log.info("register....." + board);
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		
		BoardVO board = mapper.read(bno);
		log.info("get....." + board);
		return board;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("delete....." + bno);
		return mapper.delete(bno) == 1 ;
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify....." + board);
		return mapper.update(board) == 1;
	}




	@Override
	public int getTotalCount(Criteria cri) {
		return mapper.getTotalCount(cri);
	}

}
