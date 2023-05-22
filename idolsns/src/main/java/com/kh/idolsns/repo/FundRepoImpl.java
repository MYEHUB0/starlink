package com.kh.idolsns.repo;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.idolsns.dto.FundDto;

@Repository
public class FundRepoImpl implements FundRepo{

	
	
	@Autowired
	private SqlSession sqlSession;
	
	
	@Override
	public Long sequence() {
		return sqlSession.selectOne("fund.sequence");
	}

	

	@Override
	public void insert(FundDto dto) {
//			if(dto.getFundTime()==null) {
//				sqlSession.insert("fund.add2", dto);
//			} else {
//				sqlSession.insert("fund.add", dto);
//			}
			sqlSession.insert("fund.add2", dto);
		}

	
	@Override
	public List<FundDto> selectAll() {
		return sqlSession.selectList("fund.selectAll");
	}

	@Override
	public List<FundDto> selectByMember(String memberId) {
		return sqlSession.selectList("fund.selectByMember", memberId);
	}
	
	@Override
	public FundDto find(Long fundNo) {
		return sqlSession.selectOne("fund.find", fundNo);
	}



	@Override
	public FundDto selectOneWithTotal(Long postNo) {
		return sqlSession.selectOne("fund.fundtotal", postNo);
	}


		

	
}
