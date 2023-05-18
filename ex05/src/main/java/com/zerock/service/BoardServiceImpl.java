package com.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zerock.domain.BoardAttachVO;
import com.zerock.domain.BoardVO;
import com.zerock.domain.Criteria;
import com.zerock.mapper.BoardAttachMapper;
import com.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
//@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	
	//private final BoardMapper mapper;
	@Setter(onMethod_= @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;
	
	
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

	
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		log.info("register....." + board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList()==null || board.getAttachList().size()<=0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
	}

	@Override
	public BoardVO get(Long bno) {
		
		BoardVO board = mapper.read(bno);
		log.info("get....." + board);
		return board;
	}

	@Override
	@Transactional
	public boolean remove(Long bno) {
		log.info("service: delete....." + bno);
		//게시글 삭제 시 첨부파일 모두 삭제 
		attachMapper.deleteAll(bno);
		log.info("service: delete.....complete " + bno);
		return mapper.delete(bno) == 1 ;
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify....." + board);
		
		// 게시물의 모든 첨부파일을 삭제하고 다시 첨부파일 목록을 추가하는 형태로 처리 
		// why? 넘어온 데이터 중 어떤 게 수정된 파일이고 어떤 파일이 삭제되었는지 알아야하기에  
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board) == 1;
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		
		return modifyResult;
	}




	@Override
	public int getTotalCount(Criteria cri) {
		return mapper.getTotalCount(cri);
	}


	//게시물에 있는 첨부파일 리스트 확인하기 
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}
	
	
	
	

}
