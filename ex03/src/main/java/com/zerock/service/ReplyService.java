package com.zerock.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zerock.domain.Criteria;
import com.zerock.domain.ReplyVO;

public interface ReplyService {
	
	public int register(ReplyVO vo);
	
	public ReplyVO get(Long rno); //특정 댓글 읽기
	
	public int remove(Long rno); 
	
	public int modify(ReplyVO vo);
	
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") Long bno);

}
