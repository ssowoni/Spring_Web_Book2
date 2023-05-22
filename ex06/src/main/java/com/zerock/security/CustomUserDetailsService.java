package com.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.zerock.mapper.MemberMapper;

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
		return null;
	}
	
	

}
