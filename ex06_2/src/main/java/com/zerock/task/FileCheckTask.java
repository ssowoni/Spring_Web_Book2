package com.zerock.task;



import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.zerock.domain.BoardAttachVO;
import com.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = { @Autowired })
	private BoardAttachMapper attachMapper;

	private String getFolderYesterDay() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Calendar cal = Calendar.getInstance();

		cal.add(Calendar.DATE, -1);

		String str = sdf.format(cal.getTime());

		return str.replace("-", File.separator);
	}

	@Scheduled(cron = "0 0 2 * * *")
	public void checkFiles() throws Exception {

		log.warn("File Check Task run.................");
		log.warn(new Date());
		// file list in database
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();

		// ready for check file in directory with database file list
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());

		// image file has thumnail file
		fileList.stream().filter(vo -> vo.isFileType() == true)
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));

		log.warn("===========================================");

		fileListPaths.forEach(p -> log.warn(p));

		// files in yesterday directory
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();

		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);

		log.warn("-----------------------------------------");
		for (File file : removeFiles) {

			log.warn(file.getAbsolutePath());

			file.delete();

		}
	}
	
	/*
	 * //서버를 실행하고 1분에 한 번씩 로그가 찍히는지 확인한다. //아래 뜻은 매분 0초가 될때마다 실행된다. //각각의 별은 다음을
	 * 뜻한다. -> second, minutes, hours, day, month, day or week , (year)
	 * 
	 * @Scheduled(cron="0 * * * * *") public void checkFiles() throws Exception{
	 * log.warn("File Check Task run .......");
	 * log.warn("=============================="); }
	 */
	

}