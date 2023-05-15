package com.zerock.mapper;

import java.util.List;

import com.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	
	//특정 게시물의 번호로 첨부파일을 찾는 작업이 필요하므로 작성
	public List<BoardAttachVO> findByBno(Long bno);

	public void deleteAll(Long bno);
}
