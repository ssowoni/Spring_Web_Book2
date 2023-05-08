package com.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j2;

// aspect:관점 , 해당 클래스 객체가 Aspect를 구현함.
@Aspect
@Log4j2
// 스프링에 빈으로 등록하기 위해 사용한다. 
@Component 
public class LogAdvice {
	
	//BeforeAdvice를 구현한 메서드에 추가한다. 
	//execution은 접근제한자와 특정 클래스의 메서드를 지정할 수 있다. 
	@Before("execution(* com.zerock.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("===============================");
	}
	
	//execution으로 시작하는 pointcut 설정에 doAdd() 메서드를 명시하고, 파라미터 타입 지정
	//&&args(.. 뒷 부분에는 변수명을 지정하는데, 이 2종류의 정보를 이용해 아래 메서드의 파라미터를 설정. 
	@Before("execution(* com.zerock.service.SampleService*.doAdd(String, String)) && args(str1,str2)")
	public void logBeforeWhitParam(String str1, String str2) {
		log.info("str1 : " + str1);
		log.info("str2 : " + str2);
	}
	
	//지정된 대상이 예외를 발생한 후에 동작하면서 문제를 찾을 수 있도록 도와준다. 
	@AfterThrowing(pointcut = "execution(* com.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		log.info("Exception....!!");
		log.info("exception : " + exception);
	}
	
	
	//ProceedingJoinPoint는 AOP 대상이 되는 Target이나 파라미터 등을 파악할 뿐만 아니라 직접 실행을 결정할 수도 있다. 
	//@Before과 달리 @Around가 적용되는 메서드의 경우 리턴 타입이 void가 아닌 타입으로 설정
	@Around("execution(* com.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("Target" + pjp.getTarget());
		log.info("Param : "+ Arrays.toString(pjp.getArgs()));
		
		Object result = null;
		
		try {
			result = pjp.proceed();
		}catch (Throwable e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("Time:" + (end-start));
		return result;
		
	}
	

}
