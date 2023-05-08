package com.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.zerock.domain.Criteria;
import com.zerock.domain.ReplyPageDTO;
import com.zerock.domain.ReplyVO;
import com.zerock.mapper.ReplyMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService{
	
	private final ReplyMapper mapper;

	@Override
	public int register(ReplyVO vo) {
		log.info("==========service register" + vo );
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("==========service get" + rno );
		return mapper.read(rno);
	}

	@Override
	public int remove(Long rno) {
		log.info("==========service remove" + rno );
		return mapper.delete(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("==========service modify" + vo );
		return mapper.update(vo);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("==========service getList" + bno );
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno)
				);
	}
	
	

}
