package com.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.zerock.domain.MemberVO;
import com.zerock.mapper.MemberMapper;
import com.zerock.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Log4j2
//@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
	
	//private final MemberMapper mapper;
	@Setter(onMethod_= {@Autowired})
	private MemberMapper mapper;
	 
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("Load User By UserName : " + username);
		MemberVO vo = mapper.read(username);
		log.warn("queried by member mapper: " + vo);
		
		return vo == null? null : new CustomUser(vo);
	}
	
	

}
