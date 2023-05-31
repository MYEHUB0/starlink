package com.kh.idolsns.restcontroller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.idolsns.dto.MemberDto;
import com.kh.idolsns.dto.MemberProfileDto;
import com.kh.idolsns.dto.MemberSimpleProfileDto;
import com.kh.idolsns.repo.MemberRepo;
import com.kh.idolsns.repo.MemberSimpleProfileRepo;

@CrossOrigin
@RestController
@RequestMapping("/rest/member")
public class MemberRestController {

	@Autowired 
	private MemberRepo memberRepo;
	@Autowired
	private MemberSimpleProfileRepo memberSimpleProfileRepo;
	
	 @GetMapping("/{memberId}")
	 public MemberDto getMember(@PathVariable String memberId) {
        // memberId를 사용하여 멤버 정보를 조회하고 MemberDto로 반환하는 로직을 작성해주세요
        // 예시로 임시로 생성한 MemberDto를 반환합니다.
      
		 MemberDto memberDto = memberRepo.selectOne(memberId);
	     memberDto.setMemberPoint(memberDto.getMemberPoint()); 
	        
        return memberDto;
	 }

	
	@GetMapping("/memberId/{memberId}")
	public String memberId(@PathVariable String memberId) {
		return memberRepo.selectOne(memberId) == null ? "Y":"N";
	}
	
	@GetMapping("memberNick/{memberNick}")
	public String memberNick(@PathVariable String memberNick) {
		return memberRepo.joinNick(memberNick) == null? "Y":"N";
	}
	
	@GetMapping("memberEmail/{memberEmail}")
	public String memberEmail(@PathVariable String memberEmail) {
		return memberRepo.joinEmail(memberEmail) == null? "Y":"N";
	}



	// 회원 아이디 목록 받아서 회원프로필정보 반환
	@GetMapping("/getMemberProfile")
	public List<MemberSimpleProfileDto> getMemberProfile(@RequestParam List<String> memberIdList){
		return memberSimpleProfileRepo.profile(memberIdList);
	}

}
