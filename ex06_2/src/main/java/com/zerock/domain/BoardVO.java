package com.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

//VO는 주로 Read Only 목적이 강하다. 데이터 자체도 불변하게 설계하는 것이 정석.
//테이블과 관련된 데이터를 VO로 사용.


@Data
public class BoardVO {

	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regDate;
	private Date updateDate;
	
	private int replyCnt;
	
	private List<BoardAttachVO> attachList;
}
