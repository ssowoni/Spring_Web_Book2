package com.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

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
	
	public String getListLink() {
		// 브라우저에서 get 방식 등 파라미터 전송에 사용되는 문자열(쿼리스트링)을 손쉽게 처리할 수 있다. 
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
										.queryParam("pageNum", this.pageNum)
										.queryParam("amount", this.getAmount())
										.queryParam("type",this.getType())
										.queryParam("keyword",this.getKeyword());
		return builder.toUriString();
		
	}
	
}
