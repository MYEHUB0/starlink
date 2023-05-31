package com.kh.idolsns.restcontroller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.idolsns.dto.FundDto;
import com.kh.idolsns.dto.FundPostImageDto;
import com.kh.idolsns.dto.PostImageDto;
import com.kh.idolsns.dto.TagDto;
import com.kh.idolsns.repo.FundPostImageRepo;
import com.kh.idolsns.repo.FundPostRepo;
import com.kh.idolsns.repo.FundRepo;
import com.kh.idolsns.vo.FundDetailVO;
import com.kh.idolsns.vo.FundListVO;
import com.kh.idolsns.vo.FundVO;

@CrossOrigin
@RestController
@RequestMapping("/rest/fund")
public class FundRestController {

	@Autowired
	private FundRepo fundRepo;
	
	@Autowired
	private FundPostRepo fundPostRepo;
	
	@Autowired
	private FundPostImageRepo fundPostImageRepo;
	
	// 펀딩게시물 목록 조회
	@GetMapping("/")
	public List<FundPostImageDto> fundPostList(){
		return fundPostImageRepo.selectList();
	}
	
	// 무한스크롤을 위한 백엔드 페이징 목록 구현
	// - 페이지번호를 알려준다면 10개를 기준으로 해당 페이지 번호의 데이터를 반환
	@GetMapping("/page/{page}")
	public FundListVO paging(@PathVariable int page,
		@RequestParam(required=false) String searchKeyword) {
		FundListVO vo = new FundListVO();
		// 검색어가 없을 경우
		if (searchKeyword == null || searchKeyword.equals("")) {
			vo.setFundPostImageDtos(fundPostImageRepo.selectListByPaging(page));
			return vo;
		}
		// 검색어가 있을 경우
		else {
			System.out.println("------------------Keyword------------"+searchKeyword);
			vo.setFundListWithTagDtos(fundPostImageRepo.selectListWithTag(page, searchKeyword));
			return vo;
		}
	}
		
	
	// 펀딩상세 
	@GetMapping("/{postNo}")
	public FundPostImageDto detail(@PathVariable Long postNo) {
		FundDetailVO vo = fundPostImageRepo.selectOne(postNo);
		FundPostImageDto fundPostImageDto = vo.getFundPostImageDto();
//		System.out.println(fundPostImageDto);
		return fundPostImageDto;
	}
	
	// 상세이미지 attachmentNos 
	@GetMapping("/attaches/{postNo}")
	public List<Integer> list(@PathVariable Long postNo) {
		List<PostImageDto> list = fundPostImageRepo.selectAttachList(postNo);
		List<Integer> attachList = new ArrayList<>();
		
		for(PostImageDto dto : list) {
			attachList.add(dto.getAttachmentNo());
		}
		
		return attachList;
	}
	
	
	// 후원한 total금액 & 후원자 
	@GetMapping("/fundlist/{postNo}")
	public FundVO fundList(@PathVariable Long postNo){
		
		// total 금액
		List<FundDto> fundList = fundPostImageRepo.selectFundList(postNo);
		int fundTotal = 0;
		for(FundDto dto : fundList) {
			fundTotal += dto.getFundPrice();
		}
		
		// 후원자 수
		int sponsorCount = fundRepo.count(postNo);
		
		FundVO vo = new FundVO();
		vo.setFundTotal(fundTotal);
		vo.setFundSponsorCount(sponsorCount);
		
	    return vo;
	}
	
	
	@GetMapping("/order/{fundNo}")
	public FundDto getFund(@PathVariable long fundNo) {
		FundDto fundDto = fundRepo.find(fundNo);
		return fundDto;
	}
	
	// 펀딩 상세페이지 태그 조회
	@GetMapping("/tag/{postNo}")
	public List<String> getTagList(@PathVariable Long postNo) {
		List<String> list = new ArrayList<>();
		for(TagDto dto : fundPostImageRepo.selectTagList(postNo)) {
			list.add(dto.getTagName());
		}
		return list;
	}
	
	
	// 펀딩 종료일이 지난 펀딩들 확인 & 펀딩 상태 업데이트
	@PostMapping("/update")
	public void updateFundState() {
		// 목록 조회
		List<FundPostImageDto> list = fundPostImageRepo.selectList();
		List<FundPostImageDto> templist = new ArrayList<>();
		LocalDate currentDate = LocalDate.now();
		for(FundPostImageDto dto : list) {
			LocalDate postEnd = dto.getPostEnd().toLocalDate();
			if(currentDate.isAfter(postEnd)) { // 현재날짜가 마감날짜를 지났으면
				templist.add(dto);
			}
		}
		System.out.println(templist);
	}
	
	
	  
	  
	
	
}
