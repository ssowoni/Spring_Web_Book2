package com.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	
	private String userid;
	private String userpw;
	private String userName;
	private boolean enabled;
	
	private Date regDate;
	private Date updateDate;
	//내부적으로 여러 개의 사용자 권한을 가질 수 있는 구조로 설계한다.
	//예를들어 멤버이면서 관리자일 수 있도록 
	private List<AuthVO> authList;
	
	
}
