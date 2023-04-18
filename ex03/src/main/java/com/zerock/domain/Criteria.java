package com.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum; //페이지 번호
	private int amount;//한 페이지당 보여질 데이터 개수 
	
	private String type;
	private String keyword;
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public Criteria() {
		this(1,10);
	}
	
	//split 함수는 입력받은 정규 표현식 또는 특정 문자를 기준으로 문자열을 나누어 배열(array)에 저장한다. 
	public String[] getTypeArr() {
		return type==null? new String[] {} : type.split("");
	}
}
