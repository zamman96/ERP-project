package com.buff.frcs.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.buff.com.mapper.ComMapper;
import com.buff.frcs.service.FrcsStockService;
import com.buff.util.ArticlePage;
import com.buff.vo.GdsVO;

import lombok.extern.slf4j.Slf4j;

/**
* @packageName  : com.buff.frcs.controller
* @fileName     : FrcsStockController.java
* @author       : 정현종
* @date         : 2024.09.20
* @description  : 가맹점 재고 현황 조회 컨트롤러
* ===========================================================
* DATE              AUTHOR             NOTE
* -----------------------------------------------------------
* 2024.09.20                정현종     	  		      최초 생성
*/

@PreAuthorize("hasRole('ROLE_FRCS')")
@RequestMapping("/frcs")
@Slf4j
@Controller
public class FrcsStockController {
	
	@Autowired
	FrcsStockService frcsStockService;
	
	@Autowired
	ComMapper comMapper;
	
	/**
	* @methodName  : selectFrcsStockList
	* @author      : 정현종
	* @date        : 2024.09.20
	* @param  	   : 회원아이디, 상품 유형, 상품 이름
	* @return      : 가맹점 재고 현황 목록
	*/
	@GetMapping("/stockList")
	public String selectFrcsStockList(Model model, Principal principal,
			@RequestParam(name = "gdsClass", required = false, defaultValue = "") String gdsClass, // 상품 대유형
			@RequestParam(name = "gdsType", required = false, defaultValue = "") String gdsType, // 상품 소유형
			@RequestParam(name = "keyword", required = false, defaultValue = "") String keyword, // 상품 명
			@RequestParam(name = "sfStockQty", required = false, defaultValue = "") String sfStockQty,  // 안전 재고 수량
			@RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage // 현재 페이지
		) { 
		
		// 페이징 크기
		int size = 10;
		
		//principal == CustomUser
		//principal.getName() : 로그인 한 아이디
		String mbrId = principal.getName();
		log.info("selectFrcsStockList -> mbrId : " + mbrId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", mbrId); // 로그인 한 아이디
		map.put("gdsClass", gdsClass); // 상품 대유형
		map.put("gdsType", gdsType); // 상품 소유형
		map.put("keyword", keyword); // 상품 명
		map.put("sfStockQty", sfStockQty); // 안전 재고 수량
		map.put("currentPage", currentPage); // 현재 페이지
		map.put("size", size); // 페이징 크기
		
		// 전체 재고 현황 조회
		List<GdsVO> stockVOList = this.frcsStockService.selectFrcsStockList(map);
		log.info("selectFrcsStockList -> stockVOList : " + stockVOList);
		
		// 총 행의 수
		int total = this.frcsStockService.selectTotalFrcsStock(map);
		log.info("selectFrcsStockList -> total : " + total);
 		
		// 페이징 처리
		ArticlePage<GdsVO> articlePage = new ArticlePage<GdsVO>(total, currentPage, size, stockVOList, map);
		log.info("selectFrcsStockList -> articlePage : " + articlePage);
		
		// 상품 유형별 갯수
		int allStockQty = this.frcsStockService.selectAllstock(map); // 전체
		int fdStockQty = this.frcsStockService.selectFdStock(map); // 식품
		int smStockQty = this.frcsStockService.selectSmStock(map); // 부자재
		int pmStockQty = this.frcsStockService.selectPmStock(map); // 포장재
		
		Map<String, Object> gdsTypeQtyMap = new HashMap<String, Object>();
		
		gdsTypeQtyMap.put("allStockQty", allStockQty);
		gdsTypeQtyMap.put("fdStockQty", fdStockQty);
		gdsTypeQtyMap.put("smStockQty", smStockQty);
		gdsTypeQtyMap.put("pmStockQty", pmStockQty);

		log.info("selectFrcsStockList -> gdsTypeQtyMap : " + gdsTypeQtyMap);
		
		// 모델에 속성 추가
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("gd", this.comMapper.selectCom("GD"));
		model.addAttribute("gdsTypeQtyMap", gdsTypeQtyMap);
		
		return "frcs/selectFrcsStockList";
	}
	
	/**
	* @methodName  : selectFrcsStockDetail
	* @author      : 정현종
	* @date        : 2024.09.24
	* @param  	   : 회원아이디, 상품 번호
	* @return      : 가맹점 재고 상세
	*/
	@GetMapping("/stockDetail")
	public String selectFrcsStockDetail(Model model, Principal principal, String gdsCode) {
		
		//principal == CustomUser
		//principal.getName() : 로그인 한 아이디
		String mbrId = principal.getName();
		log.info("selectFrcsStockDetail -> mbrId : " + mbrId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", mbrId); // 로그인 한 아이디
		map.put("gdsCode", gdsCode); // 상품 번호
		log.info("selectFrcsStockDetail -> map : " + map);
		
		// 상품 상세
		GdsVO gdsVO = this.frcsStockService.selectFrcsStockDetail(map);
		log.info("selectFrcsStockDetail -> gdsVO : " + gdsVO);
		
		// 모델 속성 추가
		model.addAttribute("gdsVO", gdsVO);
		
		return "frcs/selectFrcsStockDetail";
	}
	
	/**
	 * @methodName  : safeStockFrcsUpdateAjax
	 * @description : 가맹점 안전 재고 설정을 처리하는 메서드
	 * @author      : 정현종
	 * @date        : 2024.09.24
	 * @param       : principal, map (gdsCode, sfStockQty)
	 * @return      : int (1: 성공, 0: 실패)
	 */
	@ResponseBody
	@PostMapping("/safeStockFrcsUpdateAjax")
	public int safeStockFrcsUpdateAjax(Principal principal, @RequestBody Map<String, Object> map) {
		//map: {gdsCode=SMS001, sfStockQty=50}
		log.info("safeStockFrcsUpdateAjax -> map: " + map);
	    
		// principal.getName() 메서드를 통해 로그인 한 사용자의 아이디를 가져옵니다.
	    String mbrId = principal.getName();
	    log.info("safeStockFrcsUpdateAjax -> mbrId: " + mbrId);

	    // map 객체에 mbrId를 추가합니다.
	    map.put("mbrId", mbrId);

	    // gdsCode와 selfStockQty를 요청 본문에서 추출
	    String gdsCode = (String) map.get("gdsCode");
	    //파라미터는 String타입임.
	    int sfStockQty = Integer.parseInt(map.get("sfStockQty").toString());
	    log.info("gdsCode: " + gdsCode + ", sfStockQty: " + sfStockQty + ", mbrId: " + mbrId);
	    
	    
	    // 서비스 메서드 호출하여 안전 재고 설정을 처리합니다.
	    int result = this.frcsStockService.safeStockFrcsUpdateAjax(map);
	    log.info("safeStockFrcsUpdateAjax -> result: " + result);

	    return result; // 성공 시 1, 실패 시 0을 반환
	}
	
	/**
	* @methodName  : stockFrcsUpdateAjax
	* @description : 가맹점 재고 조정을 처리하는 메서드
	* @author      : 정현종
	* @date        : 2024.09.25
	* @param 	   : map(상품코드, 사업체번호, 조정수량, 조정사유)
	* @return	   : 0 또는 1 이상
	*/
	@ResponseBody
	@PostMapping("/stockFrcsUpdateAjax")
	public int stockFrcsUpdateAjax(@RequestBody Map<String, Object> map) {
	    
	    int result = 0;

	    // 1. 재고 조정 기록 입력
	    Map<String, Object> insertMap = new HashMap<String, Object>();
	    insertMap.put("gdsCode", map.get("gdsCode")); // 상품번호
	    insertMap.put("bzentNo", map.get("bzentNo")); // 사업체번호
	    insertMap.put("qty", map.get("qty")); // 조정 수량
	    insertMap.put("ajmtRsn", map.get("ajmtRsn")); // 조정 사유 
	    log.info("stockFrcsUpdateAjax -> insertMap: " + insertMap);
	    
	    // INSERT 작업 수행
	    result += this.frcsStockService.stockAjmtFrcsInsertAjax(insertMap);
	    log.info("stockFrcsUpdateAjax -> result(stockAjmtFrcsInsertAjax): " + result);
	    
	    // 2. 재고 수량 업데이트
	    Map<String, Object> updateMap = new HashMap<String, Object>();
	    updateMap.put("bzentNo", map.get("bzentNo"));
	    updateMap.put("gdsCode", map.get("gdsCode"));
	    log.info("stockFrcsUpdateAjax -> updateMap: " + updateMap);
	    
	    // UPDATE 작업 수행
	    result += this.frcsStockService.stockFrcsUpdateAjax(updateMap);
	    log.info("stockFrcsUpdateAjax -> result(stockFrcsUpdateAjax): " + result);
	    
	    return result;
	}
	
}
