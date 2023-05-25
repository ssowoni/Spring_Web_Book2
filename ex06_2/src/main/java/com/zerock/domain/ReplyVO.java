package com.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {

	private Long rno; //댓글번호
	private Long bno; //게시글 번호
	
	private String reply;
	private String replyer;
	private Date replyDate;
	private Date updateDate;
}
