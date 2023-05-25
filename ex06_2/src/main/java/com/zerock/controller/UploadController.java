package com.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
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
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<>();
		log.info("update ajax post......");
		String uploadFolder = "C:\\uploadBook";
		
		String uploadFolderPath = getFolder();
		//make folder ----------
		//java.io.File.File(String parent, String child)
		// 오늘 날짜 이름으로 파일 생성해서 c드라이브 upload 폴더에 저장된다. 
		//String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder,uploadFolderPath);
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
			attachDTO.setFileName(uploadFileName);
			
			//중복 방지 UUID 적용
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			
			
			try {
				//File savaFile = new File(uploadFolder, uploadFileName);
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				
				
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
	
	
	
	@GetMapping("/display")
	@ResponseBody
	//문자열로 파일 경로가 포함된 fileName을 파라미터로 받는다. 
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName: " + fileName);
		File file = new File("c:\\uploadBook\\" + fileName);
		log.info("file");
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();

			//파일 종류에 따라 MIME 타입이 달리지는데, probeContentType 메서드를 통해 적절한 MIME 타입 데이터를 Http 헤더 메시지에 포함함.
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
		
	}
	
	//MIME은 Multipurpose Internet Mail Extensions의 약자로 HTTP 와 같은 통신 프로토콜의 기본 부분입니다 
	//MIME 타입을 다운로드할 수 있도록 produces를 지정한다. 
	//다운로드 시 저장되는 이름은 Content-Disposition을 이용해 지정한다. 
	/*
	 * @GetMapping(value="/download", produces =
	 * MediaType.APPLICATION_OCTET_STREAM_VALUE)
	 * 
	 * @ResponseBody public ResponseEntity<Resource> downloadFile(String fileName){
	 * log.info("dowonload file: " + fileName); FileSystemResource resource = new
	 * FileSystemResource("C:\\uploadBook\\" + fileName); log.info("resource: " +
	 * resource);
	 * 
	 * String resourceName = resource.getFilename(); HttpHeaders headers = new
	 * HttpHeaders(); //한글 파일 이름 저장 시 깨지는 문제 막기 위해 문자열 처리
	 * //C:\Users\thdnj\Downloads\test1.png try { headers.add("Content-Disposition",
	 * "attachment; filename=" + new String(resourceName.getBytes("UTF-8"),
	 * "ISO-8859-1")); } catch (UnsupportedEncodingException e) {
	 * e.printStackTrace(); } return new ResponseEntity<Resource>(resource, headers,
	 * HttpStatus.OK); }
	 */
	
	 @GetMapping(value="/download" ,
	 produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	 @ResponseBody
	 public ResponseEntity<Resource>
	 downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
	
	 Resource resource = new FileSystemResource("c:\\uploadBook\\" + fileName);
	
	 if(resource.exists() == false) {
	 return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	 }
	
	 String resourceName = resource.getFilename();
	
	 //remove UUID
	 String resourceOriginalName =
	 resourceName.substring(resourceName.indexOf("_")+1);
	
	 HttpHeaders headers = new HttpHeaders();
	 try {
	
	 boolean checkIE = (userAgent.indexOf("MSIE") > -1 ||
	 userAgent.indexOf("Trident") > -1);
	
	 String downloadName = null;
	
	 if(checkIE) {
	 downloadName = URLEncoder.encode(resourceOriginalName,
	 "UTF8").replaceAll("\\+", " ");
	 }else {
	 downloadName = new
	 String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
	 }
	
	 headers.add("Content-Disposition", "attachment; filename="+downloadName);
	
	 } catch (UnsupportedEncodingException e) {
	 e.printStackTrace();
	 }
	
	 return new ResponseEntity<Resource>(resource, headers,HttpStatus.OK);
	 }
		
	
	 @PreAuthorize("isAuthenticated()")
	 @PostMapping("/deleteFile")
	 @ResponseBody
	 public ResponseEntity<String> deleteFile(String fileName, String type){
		 log.info("deleteFile : " + fileName);
		 File file;
		 
		 try {
			 file = new File("c:\\uploadBook\\"+ URLDecoder.decode(fileName,"UTF-8"));
			 file.delete();
			 if(type.equals("image")) {
				 // getAbsolutePath() : 현재 실행 중인 Working directory에 File에 전달한 경로를 조합하여 절대 경로를 리턴합니다.
				 String largeFileName = file.getAbsolutePath().replace("s_","");
				 log.info("largeFileName: " + largeFileName);
				 file = new File(largeFileName);
				 file.delete();
			 }
		 }catch(UnsupportedEncodingException e) {
			 e.printStackTrace();
			 return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		 }
		 
		 return new ResponseEntity<String>("deleted", HttpStatus.OK);
		 
		 
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
