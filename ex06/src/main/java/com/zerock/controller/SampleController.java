package com.zerock.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j2;

@Log4j2
@RequestMapping("/sample/*")
@Controller
public class SampleController {

	@GetMapping("/all")
	public String doAll() {
		log.info("do all can access everybody");
		return "sample/all";
	}
	
	@GetMapping("/member")
	public String doMember() {
		log.info("logined member");
		return "sample/member";
	}
	
	@GetMapping("/admin")
	public String doAdmin() {
		log.info("admin only");
		return "sample/admin";
	}	
	
	/*
	 * hasRole([role]), hasAuthority([authority]) -> 해당 권한이 있으면 true
	 * hasAnyRole([role,role2]), hasAnyAuthority([authority]) -> 여러 권한들 중 하나라도 해당하는 권한이 있음 true
	 * principal -> 현재 사용자 정보 의미 
	 * permitAll -> 모든 사용자에게 허용
	 * denyAll -> 모든 사용자에게 거부
	 * 
	 * 
	 * */
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
	@GetMapping("/annoMember")
	public void doMember2() {
		log.info("logined annotation member");
	}
	
	//Secured는 단순히 값만 추가할 수 있으므로 여러 개를 사용할 때에는 배열로 표현한다.
	@Secured({"ROLE_ADMIN"})
	@GetMapping("/annoAdmin")
	public void doAdmin2() {
		
	}
	
}
