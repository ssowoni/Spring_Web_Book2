package com.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j2;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j2
public class UploadController {
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		
		String uploadFolder = "C:\\uploadBook";
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("==========================");
			log.info("upload file name: "+ multipartFile.getOriginalFilename());
			log.info("upload file size: " + multipartFile.getSize());
			
			//java.io.File.File(String parent, String child)
			// 원래 파일의 이름으로 c드라이브 upload 폴더에 저장된다. 
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	
	@PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<>();
		log.info("update ajax post......");
		String uploadFolder = "C:\\uploadBook";
		
		//make folder ----------
		//java.io.File.File(String parent, String child)
		// 오늘 날짜 이름으로 파일 생성해서 c드라이브 upload 폴더에 저장된다. 
		File uploadPath = new File(uploadFolder, getFolder());
		log.info("upload path: " + uploadPath);
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs(); // 새로운 폴더 생성 
		}
		
		
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			log.info("==========================");
			log.info("upload file name: "+ multipartFile.getOriginalFilename());
			log.info("upload file size: " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			//IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
			log.info("only file name: " + uploadFileName );
			
			//중복 방지 UUID 적용
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			
			
			try {
				//File savaFile = new File(uploadFolder, uploadFileName);
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolder);
				
				
				
				//check image type file
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail,100,100);
					thumbnail.close();
				}
				
				list.add(attachDTO);

			}catch(Exception e) {
				log.error(e.getMessage());
			}
			
		}
		
		return new ResponseEntity<>(list,HttpStatus.OK);
		
	}
	
	
	/*
	 * @PostMapping("/uploadAjaxAction") public void uploadAjaxPost(MultipartFile[]
	 * uploadFile) {
	 * 
	 * log.info("update ajax post......"); String uploadFolder = "C:\\uploadBook";
	 * 
	 * //make folder ---------- //java.io.File.File(String parent, String child) //
	 * 오늘 날짜 이름으로 파일 생성해서 c드라이브 upload 폴더에 저장된다. File uploadPath = new
	 * File(uploadFolder, getFolder()); log.info("upload path: " + uploadPath);
	 * 
	 * if(uploadPath.exists() == false) { uploadPath.mkdirs(); // 새로운 폴더 생성 }
	 * 
	 * 
	 * for(MultipartFile multipartFile : uploadFile) {
	 * log.info("=========================="); log.info("upload file name: "+
	 * multipartFile.getOriginalFilename()); log.info("upload file size: " +
	 * multipartFile.getSize());
	 * 
	 * String uploadFileName = multipartFile.getOriginalFilename();
	 * 
	 * //IE has file path uploadFileName =
	 * uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
	 * log.info("only file name: " + uploadFileName );
	 * 
	 * //중복 방지 UUID 적용 UUID uuid = UUID.randomUUID(); uploadFileName =
	 * uuid.toString()+"_"+uploadFileName;
	 * 
	 * 
	 * //File savaFile = new File(uploadFolder, uploadFileName); File saveFile = new
	 * File(uploadPath, uploadFileName);
	 * 
	 * try { multipartFile.transferTo(saveFile);
	 * 
	 * //check image type file if(checkImageType(saveFile)) { FileOutputStream
	 * thumbnail = new FileOutputStream(new File(uploadPath, "s_" +
	 * uploadFileName));
	 * Thumbnailator.createThumbnail(multipartFile.getInputStream(),
	 * thumbnail,100,100); thumbnail.close(); }
	 * 
	 * }catch(Exception e) { log.error(e.getMessage()); }
	 * 
	 * }
	 * 
	 * }
	 */
	
	
	
	//폴더 생성 위한 현재 날짜 추출
	private String getFolder() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		//File.separator 는 프로그램이 실행 중인 OS에 해당하는 구분자를 리턴
		return str.replace("-", File.separator);
		
	}
	
	
	// 섬네일 이미지 생성 위한 이미지 파일 판단
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			//startsWith() 메서드는 어떤 문자열이 특정 문자로 시작하는지 확인하여 결과를 true 혹은 false로 반환합니다.
			return contentType.startsWith("image");
		}catch(IOException e){
			e.printStackTrace();
		}
		return false;
	}
	
	

}
