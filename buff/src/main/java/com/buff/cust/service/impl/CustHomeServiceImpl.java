package com.buff.cust.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.buff.cust.mapper.CustHomeMapper;
import com.buff.cust.mapper.CustMyPageMapper;
import com.buff.cust.mapper.MemberMapper;
import com.buff.cust.service.CustHomeService;
import com.buff.vo.BzentVO;
import com.buff.vo.EventVO;
import com.buff.vo.FrcsDscsnVO;
import com.buff.vo.MenuVO;

@Service
public class CustHomeServiceImpl implements CustHomeService {

	@Inject
	MemberMapper memberMapper;
	
	@Inject
	CustHomeMapper custHomeMapper;
	
	@Inject
	CustMyPageMapper myPageMapper;
	
	
	/**
	* @methodName  : home
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 고객 메인화면_ 가맹점 카드 리스트 
	*/
	@Override
	public List<BzentVO> selectBzentInfo() {
		return this.custHomeMapper.selectBzentInfo();
	}

	/**
	* @methodName  : selectStore
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 전제 매장 조회
	*/
	@Override
	public List<BzentVO> selectStore(Map<String, Object> map) {
		return this.custHomeMapper.selectStore(map);
	}
	
	

	/**
	* @methodName  : selectStore
	* @author      : 서윤정
	* @date        : 2024.09.20
	* @param  	   : 
	* @return      : 매장 조회 , 페이징처리
	*/
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.memberMapper.getTotal(map);
	}
	
	
	
	
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 이벤트 조회
	*/
	
	
	@Override
	public List<EventVO> selectEvent() {
		return this.custHomeMapper.selectEvent();
	}

	
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 가맹점 상담신청
	*/
	
	@Override
	public int insertDscsnPost(FrcsDscsnVO frcsDscsnVO) {
		return this.custHomeMapper.insertDscsnPost(frcsDscsnVO);
	}
	
	
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 가맹점 상담신청 id 중복 확인
	*/
	@Override
	public int checkId(String mbrId) {
		return this.custHomeMapper.checkId(mbrId);
	}
	
	
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 주문시 , 가맹점 조회
	*/
	@Override
	public List<BzentVO> selectOrdrStore(Map<String, Object> map) {
		return this.custHomeMapper.selectOrdrStore(map);
	}

	
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @date        : 2024.09.13
	* @param  	   : 
	* @return      : 메뉴 조회
	*/
	
	
	@Override
	public List<MenuVO> selectMenu(String menuGubun) {
		return this.custHomeMapper.selectMenu(menuGubun);
	}
	/**
	* @methodName  : selectMenu
	* @author      : 서윤정
	* @param  	   : 
	* @return      : 가맹점 메뉴 조회
	*/
	
	@Override
	public List<MenuVO> selectOrdrMenu(Map<String, Object> map) {
		return this.custHomeMapper.selectOrdrMenu(map);
	}
	
	/**
    * @methodName  : insertEventCoupon
    * @author      : 서윤정
    * @param mbrId
    * @return      : 이벤트 상세 조회
    */
	@Override
	public EventVO insertEventCoupon(String eventNo) {
		return this.myPageMapper.insertEventCoupon(eventNo);
	}
	
	/**
	    * @methodName  : insertEventCoupon
	    * @author      : 서윤정
	    * @param mbrId
	    * @return      : 쿠폰 발급
	    */
	@Override
	public int insertEventCouponPost(Map<String, Object> map) {
		return this.myPageMapper.insertEventCouponPost(map);
	}
	
	/**
     * @methodName  : insertEventCouponPost
     * @author      : 서윤정
     * @param mbrId
     * @return      : 쿠폰 중복 체크
     */
	@Override
	public int chkCoupon(Map<String, Object> map) {
		return this.custHomeMapper.chkCoupon(map);
	}

	
	/**
     * @methodName  : selectStore
     * @author      : 서윤정
     * @date        : 2024.10.06
     * @param mbrId
     * @return      : 고객 관심 매장 중복 확인
     */
	@Override
	public int chkLikeStore(Map<String, Object> map) {
		return this.memberMapper.chkLikeStore(map);
	}
	/**
     * @methodName  : selectStore
     * @author      : 서윤정
     * @date        : 2024.10.06
     * @param mbrId
     * @return      : 고객 관심 매장 삭제
     */
	@Override
	public int deleteLikeStore(Map<String, Object> map) {
		return this.memberMapper.deleteLikeStore(map);
	}
	/**
     * @methodName  : selectStore
     * @author      : 서윤정
     * @date        : 2024.10.06
     * @param mbrId
     * @return      : 고객 관심 매장 등록
     */
	@Override
	public int insertLikeStore(Map<String, Object> map) {
		return this.memberMapper.insertLikeStore(map);
	}


	/**
	* @methodName  : selectDscsn
	* @author      : 정기쁨
	* @date        : 2024.10.08
	* @param  	   : mbrId
	* @return      : 가맹점 문의 조회
	*/
	@Override
	public Map<String, Object> selectFrcsDscsn(String mbrId) {
		// 가맹점 상담 신청 조회 (지역, 희망날짜)
		Map<String, Object> map = this.custHomeMapper.selectFrcsDscsn(mbrId); 
		return map;
	}


	
	/**
	* @methodName  : selectEvent
	* @author      : 서윤정
	 * @param faqCategory 
	* @param FaqVO : 이벤트 진행, 종료 조회
	* @return : EventVO
	*/
	
	@Override
	public List<EventVO> selectEndEventAjax() {
		return this.custHomeMapper.selectEndEventAjax();
	}

	
	/**
	* @methodName  : selectMainMenu
	* @author      : 서윤정
	* @param  menuVO
	* @return : 메인 메뉴 메뉴 조회
	*/
	@Override
	public List<MenuVO> selectMainMenu() {
		return this.custHomeMapper.selectMainMenu();
	}
	
	
	
	
	

}
