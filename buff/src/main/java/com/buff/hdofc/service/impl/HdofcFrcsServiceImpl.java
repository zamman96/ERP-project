package com.buff.hdofc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.buff.com.mapper.ComMapper;
import com.buff.hdofc.mapper.HdofcFrcsMapper;
import com.buff.hdofc.service.HdofcFrcsService;
import com.buff.vo.BzentVO;
import com.buff.vo.FrcsDscsnVO;
import com.buff.vo.FrcsVO;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
* @packageName  : com.buff.service.hdofc.impl
* @fileName     : FrcsServiceImpl.java
* @author       : 송예진
* @date         : 2024.09.12
* @description  : 가맹점 Service Impl
* ===========================================================
* DATE              AUTHOR             NOTE
* -----------------------------------------------------------
* 2024.09.12        송예진     	  			최초 생성
*/
@Service
@Slf4j
public class HdofcFrcsServiceImpl implements HdofcFrcsService{
	
	@Autowired
	HdofcFrcsMapper frcsMapper;
	
	@Autowired
	ComMapper comMapper;
// <----------------------------- 가맹점 조회 시작 ------------------------------>
	/**
	* @methodName  : selectFrcs
	* @author      : 송예진
	* @date        : 2024.09.12
	* @param 	   : 검색 조건
	* @return      : 검색조건에 맞는 페이징 된 가맹점 리스트
	*/
	@Override
	public List<FrcsVO> selectFrcs(Map<String, Object> map) {
		return this.frcsMapper.selectFrcs(map);
	}

	/**
	* @methodName  : selectTotalFrcs
	* @author      : 송예진
	* @date        : 2024.09.12
	* @param 	   : 검색 조건
	* @return      : 검색조건에 맞는 가맹점 리스트 총 갯수
	*/
	public Map<String, Object> selectTotalFrcs(Map<String, Object> map){
		Map<String, Object> cnt = new HashMap<String, Object>();
		cnt.put("total", this.frcsMapper.selectTotalFrcs(map));
		
		map.put("frcsType", "FRS01");
		cnt.put("open", this.frcsMapper.selectTotalFrcs(map));
		map.put("frcsType", "FRS02");
		cnt.put("cls", this.frcsMapper.selectTotalFrcs(map));
		map.put("frcsType", "FRS03");
		cnt.put("clsing", this.frcsMapper.selectTotalFrcs(map));
		map.remove("frcsType");
		cnt.put("all", this.frcsMapper.selectTotalFrcs(map));
		return cnt;
	};

// <----------------------------- 가맹점 조회 끝 ------------------------------>
	
// <----------------------------- 가맹점 상세 조회 시작 ------------------------------>
	
	/**
	* @methodName  : selectDtlFrcs
	* @author      : 송예진
	* @date        : 2024.09.13
	* @return      : 하나의 가맹점 정보
	*/
	public FrcsVO selectDtlFrcs(String frcsNo) {
		return this.frcsMapper.selectDtlFrcs(frcsNo);
	};
	
	/**
	* @methodName  : updateBzentMbr
	* @author      : 송예진
	* @date        : 2024.09.14
	* @param       : bzentVO (bzentNo, bzentNm, bzentZip, bzentAddr, bzentDaddr, bzentTelno, mbrId, mngrId, rgnNo)
		rgnNo 추가하여 입력
	*/
	@Transactional
	public int updateBzent(BzentVO bzentVO) {
		String addr = bzentVO.getBzentAddr();
		String rgnNo = this.comMapper.rgnNoSearch(addr);
		
		bzentVO.setRgnNo(rgnNo);
		
		int cnt = this.deleteRoleFrcs(bzentVO);
		cnt+= this.insertRoleFrcs(bzentVO);
		cnt+= this.frcsMapper.updateBzent(bzentVO);
		return cnt;
	};
	
	/**
	 * @methodName  : updateFrcs
	 * @author      : 송예진
	 * @date        : 2024.09.14
	 * @param       : frcsVO (bzentNo, opbizYmd)
	 */
	public int updateFrcs(FrcsVO frcsVO) {
		return this.frcsMapper.updateFrcs(frcsVO);
	};
	
	/**
	* @methodName  : deleteRoleFrcs
	* @author      : 송예진
	* @date        : 2024.09.14
	* @param       : bzentVO(bzentNo) 이전에 가지고있는 사람 권한 삭제, 필수로 가맹점주 수정 이전에 수행할 것
	*/
	public int deleteRoleFrcs(BzentVO bzentVO) {
		return this.frcsMapper.deleteRoleFrcs(bzentVO);
	};
	
	/**
	 * @methodName  : updateMbrType
	 * @author      : 송예진
	 * @date        : 2024.09.22
	 * @param       : bzentVO(bzentNo) 회원 구분 고객으로 바꿈(폐업시)
	 */
	public int updateMbrType(BzentVO bzentVO) {
		return this.frcsMapper.updateMbrType(bzentVO);
	};
	
	/**
	* @methodName  : insertRoleFrcs
	* @author      : 송예진
	* @date        : 2024.09.14
	* @param       : bzentVO(mbrId) 가맹점주 권한 추가
	*/
	public int insertRoleFrcs(BzentVO bzentVO) {
		return this.frcsMapper.insertRoleFrcs(bzentVO);
	};
	
	/**
	* @methodName  : deleteDscsnFrcs
	* @author      : 송예진
	* @date        : 2024.09.23
	* @param bzentVO
	* @return      : 변경시 기존 상담정보 삭제
	*/
	public int deleteDscsnFrcs(BzentVO bzentVO) {
		return this.frcsMapper.deleteDscsnFrcs(bzentVO);
	};
	
	/**
	* @methodName  : updateDscsnFrcs
	* @author      : 송예진
	* @date        : 2024.09.23
	* @param frcsDscsnVO
	* @return      : 상담에 대한 정보 매칭
	*/
	public int updateDscsnFrcs(FrcsDscsnVO frcsDscsnVO) {
		return this.frcsMapper.updateDscsnFrcs(frcsDscsnVO);
	};
	
	
	/**
	* @methodName  : updateAllBzent
	* @author      : 송예진
	* @date        : 2024.09.28
	* @param map
	* @return      : 전체 수정
	*/
	@Transactional
	public int updateAllBzent(Map<String, Object> map) {
		ObjectMapper objectMapper = new ObjectMapper();
	    // Map 데이터를 VO로 변환
	    FrcsVO frcsVO = objectMapper.convertValue(map.get("frcsVO"), FrcsVO.class);
	    BzentVO bzentVO = objectMapper.convertValue(map.get("bzentVO"), BzentVO.class);
	    FrcsDscsnVO frcsDscsnVO = objectMapper.convertValue(map.get("frcsDscsnVO"), FrcsDscsnVO.class);
	    
		int cnt = this.updateBzent(bzentVO);
		cnt += this.updateFrcs(frcsVO);
		cnt += this.deleteDscsnFrcs(bzentVO);
		cnt += this.updateDscsnFrcs(frcsDscsnVO);
		return cnt;
	};
// <----------------------------- 가맹점 상세 조회 끝 ------------------------------>
	
	// <----------------------------- 가맹점 추가 시작 ------------------------------>
	
	/**
	* @methodName  : selectPreFrcsMbr
	* @author      : 송예진
	* @date        : 2024.09.13
	* @param map   : 검색조건 + 페이징 
	* @return      : 상담을 마친 가맹점을 배정받지 않은 회원 리스트
	*/
	public List<FrcsDscsnVO> selectPreFrcsMbr(Map<String, Object> map){
		return this.frcsMapper.selectPreFrcsMbr(map);
	};
	
	/**
	* @methodName  : selectTotalPreFrcsMbr
	* @author      : 송예진
	* @date        : 2024.09.13
	* @param map   : 검색조건 + 페이징 
	* @return      : 상담을 마친 가맹점을 배정받지 않은 회원 총 갯수
	*/
	public int selectTotalPreFrcsMbr(Map<String, Object> map) {
		return this.frcsMapper.selectTotalPreFrcsMbr(map);
	};
	
	/**
	* @methodName  : insertBzentFrcs
	* @author      : 송예진
	* @date        : 2024.09.16
	* @param frcsVO
	* @param bzentVO : 가맹점 추가
	* @return
	*/
	@Transactional
	public String insertBzentFrcs(FrcsVO frcsVO, BzentVO bzentVO, FrcsDscsnVO frcsDscsnVO) {
		String addr = bzentVO.getBzentAddr();
		String rgnNo = comMapper.rgnNoSearch(addr);
		bzentVO.setRgnNo(rgnNo);
		
		// 권한 추가
		int cnt = this.insertRoleFrcs(bzentVO);
		// BZENT 테이블추가
		cnt+= this.frcsMapper.insertBzent(bzentVO);
		// FRCS 테이블 추가
		cnt+= this.frcsMapper.insertFrcs(frcsVO);
		
		// 이전 상담정보에서 가맹점 번호 추가
		String frcsNo = bzentVO.getBzentNo();
		
		frcsDscsnVO.setFrcsNo(frcsNo);
		
		// 현재 상담정보 추가
		cnt += this.updateDscsnFrcs(frcsDscsnVO);
		return bzentVO.getBzentNo();
	};
// <----------------------------- 가맹점 추가 끝 ------------------------------>
}
