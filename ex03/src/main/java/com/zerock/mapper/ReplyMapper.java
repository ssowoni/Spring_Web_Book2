package com.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zerock.domain.Criteria;
import com.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	public int insert(ReplyVO vo);
	
	public ReplyVO read(Long rno); //특정 댓글 읽기
	
	public int delete(Long rno); 
	
	public int update(ReplyVO vo);
	
	//MyBatis에 파라미터를 2개이상 전달할 수 있는 방법은 다음과 같다.
	// 1) 별도의 객체로 구성 , 2) Map을 이용하는 방식, 3) @Param을 이용하는 방식
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);

}
