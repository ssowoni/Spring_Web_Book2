package com.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.zerock.domain.Criteria;
import com.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
public class ReplyMapperTest {
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	private Long[] bnoArr = {518L,517L,516L,515L,514L};
	
	@Test
	public void testMapper() {
		log.info(mapper);
	}

	@Test
	public void insert() {
		
		IntStream.range(1, 10)
		.forEach(i->{
			
			ReplyVO vo = new ReplyVO();
			vo.setBno(bnoArr[i%5]);
			vo.setReply("댓글 테스트 " + i );
			vo.setReplyer("replyer " + i );
			
			mapper.insert(vo);
		});
		
	}
	
	@Test
	public void read() {
		log.info(mapper.read(1L));
	}
	
	@Test
	public void delete() {
		log.info(mapper.delete(9L));
	}
	
	@Test
	public void update() {
		
			ReplyVO vo = mapper.read(1L);		
			log.info(vo);
	
			vo.setReply("수정");
			vo.setReplyer("수정자");
			
			log.info("update count "+mapper.update(vo));
			
			
		
	}
	
	
	@Test
	public void getListWithPaging() {
		
		Criteria cri = new Criteria();
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[1]);
		replies.forEach(i-> log.info(i));
		
	}
	
	
	
	
}
