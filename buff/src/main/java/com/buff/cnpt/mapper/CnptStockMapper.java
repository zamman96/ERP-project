package com.buff.cnpt.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.buff.vo.GdsAmtVO;
import com.buff.vo.GdsVO;
import com.buff.vo.StockAjmtVO;
import com.buff.vo.StockVO;

/**
* @packageName  : com.buff.cnpt.mapper
* @fileName     : CnptStockMapper.java
* @author       : 이병훈
* @date         : 2024.10.01
* @description  : 거래처 재고 조정 관련 mapper
* ===========================================================
* DATE              AUTHOR             NOTE
* -----------------------------------------------------------
* 2024.10.01        이병훈     	  			최초 생성
*/
@Mapper
public interface CnptStockMapper {


	/**
	* @methodName  : insertStockAjmt
	* @author      : 이병훈
	* @date        : 2024.10.01
	* @param stockAjmtVO
	* @return      : 재고조정 테이블에 재고 및 데이터 추가
	*/
	public int insertStockAjmt(StockAjmtVO stockAjmtVO);

	/**
	* @methodName  : selectGdsList
	* @author      : 이병훈
	* @date        : 2024.10.01
	* @param bzentNo
	* @return      : 해당 거래처 보유 상품 리스트
	*/
	public List<GdsVO> selectGdsList(String bzentNo);

	/**
	* @methodName  : insertNewGds
	* @author      : 이병훈
	* @date        : 2024.10.02
	* @param gdsNm
	* @param unitNm
	* 상품테이블에 재고 임포트
	*/
	public void insertNewGds(GdsVO gdsVO);

	/**
	* @methodName  : insertNewStock
	* @author      : 이병훈
	* @date        : 2024.10.02
	* @param bzentNo
	* @param gdsNm
	* @param qty
	* @param unitNm
	* @param amt
	* 재고테이블에 재고 임포트
	*/
	public void insertNewStock(StockVO stockVO);

	/**
	* @methodName  : insertNewStockAmt
	* @author      : 이병훈
	* @date        : 2024.10.02
	* @param gdsNm
	* @param amt
	* 상품단가 테이블에 재고 임포트
	*/
	public void insertNewGdsAmt(GdsAmtVO gdsAmtVO);

	/**
	* @methodName  : selectGdsAll
	* @author      : 이병훈
	* @date        : 2024.10.05
	* @return      : 상품 총 갯수
	*/
	public List<GdsVO> selectGdsAll(String bzentType);
	
	
	/**
	* @methodName  : selectGdsNm
	* @author      : 이병훈
	* @date        : 2024.10.07
	* @param gdsCode
	* @return      : 상품 명 가져오기
	*/
	public String selectGdsNm(String gdsCode);


	/**
	* @methodName  : mergeStockQty
	* @author      : 이병훈
	* @date        : 2024.10.07
	* @param params
	* @return      : 조정 유형에 따른 재고 조정(입고/ 출고)
	*/
	public int mergeStockQty(Map<String, Object> params);
	
	
	/**
	* @methodName  : selectStockExists
	* @author      : 이병훈
	* @date        : 2024.10.17
	* @param map
	* @return      : 재고 이미 존재 하는지 유무 체크
	*/
	public int selectStockExists(Map<String, Object> map);
}
