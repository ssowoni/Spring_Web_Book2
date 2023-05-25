package com.zerock.domain;


import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

  private int startPage;
  private int endPage;
  private boolean prev, next;

  private int total;
  private Criteria cri;

  public PageDTO(Criteria cri, int total) {

    this.cri = cri; // 현재페이지, 한 페이지에 보여질 데이터 양
    this.total = total; //전체 데이티 개수

    //끝 페이지 번호 10단위, 21개 데이터면 30
    this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;

    //시작 페이지 번호 
    this.startPage = this.endPage - 9;

    //진짜 끝번호, 21개 데이터면 21페이지까지 
    int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));

    //데이터가 10개 미만이면 
    if (realEnd <= this.endPage) {
      this.endPage = realEnd;
    }

    this.prev = this.startPage > 1;

    this.next = this.endPage < realEnd;
  }
  
}

