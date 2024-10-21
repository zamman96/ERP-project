<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

<sec:authentication property="principal.MemberVO" var="user" />

<script>
let bzentNo = "${user.bzentNo}";
let bzentType = "${bzentType}";
const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

let gdsAllList = '${gdsAllList}';
let regDate = "${formatDate}";

// 추가된 상품 목록을 저장하는 배열
let gdsList = [];

$(function(){
	// 셀렉트 디자인 라이브러리. common.js에서 호출 됨
	select2Custom(); 
	
	// 양식 다운로드 버튼 클릭
    $("#downloadTemp").on("click", function() {
        window.location.href = '/cnpt/stock/downloadTemp?bzentNo='+bzentNo;
    });
	
	// 추가버튼 이벤트 핸들러
	$("#insertNewGds").on("click", function(){
		insertNewGdsBtn();
		
	// 추가 버튼 이벤트 끝	
	});
	
	// 삭제버튼 클릭 시 이벤트 핸들러
	$(document).on("click", ".delete-btn", function(){
		let rowIndex = $(this).closest("tr").index();
		// 배열에서 삭제
		gdsList.splice(rowIndex, 1);
		// 테이블에서 삭제
		$(this).closest("tr").remove();
	
	// 삭제버튼 클릭 이벤트 끝	
	});
	
	// 저장 버튼 클릭시 이벤트 핸들러
	$("#gdsSaveBtn").on("click", function(){
		console.log("gdsList.length : ", gdsList.length);
		if(gdsList.length === 0){
			Swal.fire({
			      icon: 'error',
			      title: '추가 오류!',
			      text: '추가된 상품이 없습니다.'
			});
			return;
		}
		
		// 비동기 ajax요청
		$.ajax({
			url : '/cnpt/stock/insertNewAll',
			type : 'POST',
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify({'gdsList':gdsList}),
			beforeSend : function(xhr){
				xhr.setRequestHeader(csrfHeader, csrfToken);
			},
			success : function(res){
				if(res.status === 'success'){
					// 성공인 경우	
					Swal.fire({
					      icon: 'success',
					      title: '성 공!',
					      text: '상품 등록이 완료되었습니다.'
					    }).then(() => {
							// 성공시 페이지 이동 -> 재고 조정 현황
							location.href="/cnpt/gds/list";
					    });
				} else if(res.status === 'error'){
					// 이미 등록된 상품일 경우 , 경고창 표시
					Swal.fire({
				      icon: 'error',
				      title: '등록 오류!',
				      text: res.message
				    });
				}
			},
			error : function(xhr, status, error){
				// 네트워크 또는 서버 오류 시
				Swal.fire({
				      icon: 'error',
				      title: 'Error!',
				      text: '상품 등록에 실패하였습니다.'
				    });
			}
			
		// ajax 끝	
		});
	// 저장버튼 이벤트 핸들러 끝		
	});
	
	// 상품명 선택 시 상품 유형과 단위 자동 입력 처리
	$("#gdsNm").on('change', function(){
		 const selectedOption = $(this).find('option:selected'); 
		 console.log("selectedOption", selectedOption);
			const gdsType = selectedOption.data('type');
            const gdsTypeNm = selectedOption.data('type-nm');
            const unitNm = selectedOption.data('unit');
			
            console.log("선택된 상품 유형 코드 :", gdsType);
            console.log("선택된 상품 유형:", gdsTypeNm);
            console.log("선택된 단위:", unitNm);

            // 상품 유형과 단위 자동 입력
            $('#gdsType').val(gdsType);
            $('#gdsTypeNm').val(gdsTypeNm);
            $('#unitNm').val(unitNm).attr('disabled', true);
     
	// 상품명 클릭시 이벤트 핸들러 끝	
	});
	
	// 판매상태 명 값 가져오기
	$("#ntslType").on('change', function() {
	    const ntslType = $(this).val(); 
	    // 선택된 텍스트
	    const ntslTypeNm = $("#ntslType option:selected").text(); 
	    
	    console.log("선택된 판매 상태:", ntslType);
	    console.log("선택된 판매 상태명:", ntslTypeNm);
	    
	});
	
// function 끝	
});

</script>
<div class="content-header">
  <div class="container-fluid">
    <div class="crow mb-2 justify-content-between">
      <div class="crow align-items-center">
        <h1 class="m-0">신규 기초 재고 등록</h1>
      </div><!-- /.col -->
      <div class="btn-wrap">
		<button type="button" class="btn-active gds-qty" id="gdsSaveBtn">저장<span class="icon material-symbols-outlined">East</span></button>
	</div> 
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>

<div class="wrap">
	<div class="cont">
		
		<!-- table-wrap -->
		<div class="table-wrap">
			<table class="table-default">
				<tbody id="table-body" class="table-error">
					<tr>
						<td class="error-info" colspan="7">
							<span class="icon material-symbols-outlined">notifications_active</span>
							<div class="error-msg">
								<span class="material-symbols-outlined">arrow_right</span>
								상품의 기초 재고를 등록하는 페이지입니다.
							</div>
							<div class="error-msg">	
								<span class="material-symbols-outlined">arrow_right</span>
								이 페이지는 신규 거래처 고객 전용 페이지 이며,
							</div>	
							<div class="error-msg">	
								<span class="material-symbols-outlined">arrow_right</span>
								<span style="color:red;"> 최종 저장 이후에는 이 페이지는 이용하실 수 없습니다.</span>
							</div>	
							<div class="error-msg">	
								<span class="material-symbols-outlined">arrow_right</span>
								* 표기된 항목은 필수입력 항목입니다.
							</div>	
						</td>
					</tr>
				</tbody>
			</table>
			<!-- table-wrap -->
		</div>
		<!-- cont 끝 -->
	</div>
	
		<div class="cont">
		<!-- table-wrap 가맹점 정보-->
		<div class="table-wrap" style="overflow-x: inherit !important;">
			<div class="table-title">
				<div class="cont-title"><span class="material-symbols-outlined title-icon">package_2</span>상품 정보</div> 
				<div class="btn-wrap">
					<button type="button" class="btn-default gds-qty" id="autoBtn">자동입력</button>
					<button type="button" class="btn-default gds-qty" 
							style="margin-left:10px;" id="insertNewGds">추가<span class="icon material-symbols-outlined">East</span></button>
				</div>
			</div>
			<table class="table-blue">
				<tr>
					<th>상품 명<span class="es gds-insert">*</span></th>
					<td style="width: 20%" class="gdsNm">
						<div class="gds-select" style="width:320px;">
							<select name="gdsNm" id="gdsNm" class="input-reset input-gds select2-custom">
								<option value="" selected>선택해 주세요.</option>
								<c:forEach var="gdsVO" items="${gdsAllList}">
									<option value="${gdsVO.gdsCode}" data-type="${gdsVO.gdsType}" 
									        data-type-nm="${gdsVO.gdsTypeNm}" 
            							    data-unit="${gdsVO.unitNm}">${gdsVO.gdsNm}</option>
								</c:forEach>
							</select>
						</div>	
					</td>
					<th>상품 유형<span class="es gds-insert">*</span></th>
					<td style="width: 37%" class="gdsType">
						<input type="hidden" id="gdsType" name="gdsType">
				        <input type="text" id="gdsTypeNm" class="input-gds" 
				               style="width: 320px;" placeholder="상품 유형" disabled />
					</td>
				</tr>
				<tr>
					<th>단위<span class="es gds-insert">*</span></th>
					<td style="width:320px;" class="unitNm">
						<input id="unitNm" type="text" 
							   class="text-input input-reset input-gds" placeholder="단위를 입력하세요" disabled/>
					</td>
					<th>등록 일자<span class="es gds-insert">*</span></th>
					<td>
						<% 
					        java.util.Date now = new java.util.Date(); 
					        request.setAttribute("now", now);
					    %>
					    <fmt:formatDate value="${now}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr class="gds-dtl">
					<th>수량<span class="es gds-insert">*</span></th>
					<td>
						<input id="qty" type="text" 
							   class="text-input input-reset input-gds" placeholder="수량을 입력하세요" />
					</td>
					<th>판매 유형 <span class="es gds-insert">*</span></th>
					<td>
						<div class="select-custom" style="width:320px;">
							<select name="ntslType" id="ntslType">
								<option value='' selected>선택해 주세요.</option>
								<option value="GDNT02">미판매</option>
								<option value="GDNT03">판매중</option>
							</select>
						</div>
					</td>
				</tr>
				<tr class="gds-dtl">
					<th>단가<span class="es gds-insert">*</span></th>
					<td>
						<input id="amt" type="text" 
							   class="text-input input-reset input-amt" placeholder="단가을 입력하세요" />
					</td>
				</tr>
			</table>
			<div></div>
		</div>
		<!-- /.table-wrap -->
	<!-- cont 끝 -->	
	</div>
	
		<div class="cont">
			<div class="table-wrap">
				<div class="table-title">
						<div class="cont-title"><span class="material-symbols-outlined title-icon">list_alt</span>구매 목록</div>
				</div>
				<table class="table-blue gds-table">
				<thead>
					<tr>
						<th style="text-align:center; width: 7%;">삭제</th>
						<th style="text-align:center; width: 18%;">상품명</th>
						<th style="text-align:center; width: 12%;">상품유형</th>
						<th style="text-align:center; width: 10%;">단위</th>
						<th style="text-align:center; width: 11%;">수량</th>
						<th style="text-align:center; width: 11%;">판매유형</th>
						<th style="text-align:center; width: 11%;">단가</th>
					</tr>
				</thead>
				<tbody id="gds-list">
				</tbody>
				<tfoot>
					<tr>
						<th colspan="2" style="text-align:center; width: 20%;">총 상품 수</th>
						<td colspan="6"><span id="clclnAmt"></span></td>
					</tr>
				</tfoot>
			</table>
			</div>
			<!-- /.table-wrap 관리자 정보 -->
		</div>
		<!-- /cont 발주 목록 -->
</div>	

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/resources/cnpt/js/stock.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>