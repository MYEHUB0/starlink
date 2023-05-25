package com.kh.idolsns.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.idolsns.dto.ReplyDto;
import com.kh.idolsns.repo.ReplyRepo;

@CrossOrigin
@RestController
@RequestMapping("/rest/reply")
public class ReplyRestController {

	@Autowired
	private ReplyRepo replyRepo;
	
	// 펀딩페이지 reply 조회 
//	@GetMapping("/fund/{postNo}")
	
	// 펀딩페이지 reply 작성 
	@PostMapping("/fund/{postNo}")
	public void write(@RequestBody ReplyDto replyDto, @PathVariable("postNo") Long postNo) {
	    // reply sequence 발행
	    Long sequence = replyRepo.sequence();
	    
	    replyDto.setPostNo(postNo);
	    replyDto.setReplyNo(sequence);
	    replyDto.setReplyGroup(null);
	    replyRepo.addReply(replyDto);
	}
}

