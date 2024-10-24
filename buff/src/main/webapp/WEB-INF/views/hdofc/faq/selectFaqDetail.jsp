<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet" href="/resources/frcs/css/frcsPoList.css">
<link rel="stylesheet" href="/resources/css/global/common.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="/resources/hdofc/css/faqDetail.css">
<script src="/resources/js/jquery-3.6.0.js"></script>

<sec:authorize access="isAuthenticated()">
	<!-- 로그인 한(isAuthenticated()) 사용자 정보 -->
	<sec:authentication property="principal.MemberVO" var="user"/>
</sec:authorize>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script type="text/javascript">
$(document).ready(function() {
	$("#div2").hide();  // div2 숨기기
	//목록으로 버튼 클릭 시 selectFaqList 페이지로 이동
	$("#backToListBtn").on("click", function() {
		// FAQ 목록으로 복귀
		window.location.href = "/hdofc/faq/selectFaqList";  // 목록 페이지로 이동
	});
	
	// 원래 데이터를 저장할 객체
	let originalData = {};
	
	// 수정 모드 버튼 클릭 시 동작
	$("#submitModeBtn").on("click", function() {
		// div1을 숨기고 div2를 보여줌
		$("#div1").hide();  // div1 숨기기
		$("#div2").show();  // div2 보이기
		
		// 문의 유형을 input에서 select로 전환
	    $("#qsTypeText").hide();  // input:hidden
		$("#qsTypeSelectWrap").show();  // select:visible
		
		// 제목을 텍스트에서 input으로 전환
		$("#faqTtlText").hide();  // span:hidden
		$("#faqTtlInput").show();  // input:visible
		
		// 현재 입력된 값을 저장 (수정 취소 시 복원할 데이터)
		originalData = {
			"faqTtl": $("#faqTtl").val(),
			"faqCn": $("#faqCn").val(),
			"qsType": $("#qsType").val()
		};

		// 모든 input 태그의 disabled 속성 제거, 작성자 필드는 제외
		$("input:text").not("#mbrNm").removeAttr("disabled");

		// textarea의 disabled 속성 제거
		$("textarea").removeAttr("disabled");

		// select 태그의 disabled 속성 제거
		$("#qsType").removeAttr("disabled");
	});
	
	// 취소 버튼 클릭 시 수정 모드 종료
	$("#cancleBtn").on("click", function() {
		// div2을 숨기고 div1를 보여줌
		$("#div2").hide();  // div1 숨기기
		$("#div1").show();  // div2 보이기
		
		// 문의 유형을 다시 input으로 전환
		$("#qsTypeText").show();  // input:visible
		$("#qsTypeSelectWrap").hide();  // select:hidden
		
		// 제목을 다시 텍스트로 전환
		$("#faqTtlText").show();  // span:visible
		$("#faqTtlInput").hide();  // input:hidden
		
		// 저장해둔 원래 데이터로 복원
		$("#faqTtl").val(originalData.faqTtl);
		$("#faqCn").val(originalData.faqCn);
		$("#qsType").val(originalData.qsType);

		// 모든 input 태그에 다시 disabled 속성 추가
		$("input:text").not("#mbrNm").attr("disabled", true);

		// textarea와 select에 다시 disabled 속성 추가
		$("textarea").attr("disabled", true);
		$("#qsType").attr("disabled", true);
	});
	
	$("#submitBtn").on("click", function() {
		console.log("업데이트한다!");
		
		let faqSeq = $("#faqSeq").val();
		let faqTtl = $("#faqTtlInput").val();
		let faqCn = $("#faqCn").val();
		let qsType = $("#qsType").val();
			
		let data = {
			"faqSeq":faqSeq,
			"faqTtl":faqTtl,
			"faqCn":faqCn, 
			"qsType":qsType
		};
		
		$.ajax({
			url:"/hdofc/faq/updateFaqDetail",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				console.log("result(수정작업) : ", result);
				if (result === 1) {
					Swal.fire({
	                    icon: "success",
	                    title: "수정에 성공하였습니다",
	                    showConfirmButton: true,  // 확인 버튼을 활성화
	                    confirmButtonText: "확인"
	                }).then((result) => {
	                    // 확인 버튼을 눌렀을 때 페이지 이동 또는 새로고침
	                    if (result.isConfirmed) {
	                    	// div2 숨기고 div1 보여주기
							$("#div2").hide();   // div2 (수정 버튼이 있는 부분) 숨김
							$("#div1").show();   // div1 (수정 모드로 전환 버튼이 있는 부분) 보임
							// 모든 input 태그 및 textarea 다시 비활성화
							$("input:text").attr("disabled", true);
							$("textarea").attr("disabled", true);
							// 페이지 새로고침
							location.reload();   // 새로고침하여 변경된 내용을 다시 로드
	                    }else {
	                    	// 확인버튼 말고 모달밖 다른쪽을 클릭해도 동일하게
	                    	// div2 숨기고 div1 보여주기
							$("#div2").hide();   // div2 (수정 버튼이 있는 부분) 숨김
							$("#div1").show();   // div1 (수정 모드로 전환 버튼이 있는 부분) 보임
							// 모든 input 태그 및 textarea 다시 비활성화
							$("input:text").attr("disabled", true);
							$("textarea").attr("disabled", true);
							// 페이지 새로고침
							location.reload();   // 새로고침하여 변경된 내용을 다시 로드
	                    }
	                });
                 	
                } else {
                    alert("FAQ 수정에 실패했습니다.");
                }
			},
            error: function(xhr, status, error) {
            	console.log("FAQ 수정 오류: " + error);
                console.log("상태 코드: " + status);
                console.log("응답 내용: " + xhr.responseText);
                alert("FAQ 수정 중 문제가 발생했습니다.");
            }
		});
		
	});
	
	$("#deleteBtn").on("click", function() {
		console.log("삭제드가자!");
		
		let faqSeq = $("#faqSeq").val();
		
		$.ajax({
			url:"/hdofc/faq/deleteFaq",
			contentType:"application/json;charset=utf-8",
			data:faqSeq,
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				console.log("result : ", result);
				
				if (result === 1) {
					Swal.fire({
	                    icon: "success",
	                    title: "삭제에 성공하였습니다",
	                    showConfirmButton: true,  // 확인 버튼을 활성화
	                    confirmButtonText: "확인"
	                }).then((result) => {
	                    // 확인 버튼을 눌렀을 때 페이지 이동 또는 새로고침
	                    if (result.isConfirmed) {
	                        window.location.href = "/hdofc/faq/selectFaqList";  // 목록 페이지로 이동
	                    }else {
	                    	// 확인버튼 말고 모달밖 다른쪽을 클릭해도 동일하게
	                    	window.location.href = "/hdofc/faq/selectFaqList";  // 목록 페이지로 이동
	                    }
	                });
                } else {
                    alert("문의사항 삭제에 실패했습니다.");
                }
			},
            error: function(xhr, status, error) {
                console.log("문의사항 삭제 오류: " + error);
                alert("FAQ 삭제 중 문제가 발생했습니다.");
            }
		});
	});
});
</script>
<div class="content-header">
	<div class="container-fluid">
		<div class="row mb-2 justify-content-between">
			<div class="row align-items-center">
				<button type="button" class="btn btn-default mr-3" id="backToListBtn">
					<span class="icon material-symbols-outlined">keyboard_backspace</span> 목록으로
				</button>
				<h1 class="m-0">FAQ 상세</h1>
			</div>
			<div id="div1" class="btn-wrap">
				<button type="button" class="btn-active" id="submitModeBtn">수정</button>
				<button type="button" class="btn-danger" id="deleteBtn">삭제</button>
			</div>
			<!-- 수정모드로 전환 -->
			<div id="div2" class="btn-wrap">
				<button type="button" class="btn-default" id="cancleBtn">취소</button>
				<button type="button" class="btn-active" id="submitBtn">저장</button>
			</div>
		</div><!-- /.row -->
	</div><!-- /.container-fluid -->
</div>

<div class="wrap">
	<div class="cont">
		<!-- table-wrap -->
		<div class="table-wrap">
			<div class="table-title">
				<div class="cont-title"><span class="material-symbols-outlined title-icon">playlist_add</span>상세내용</div>
			</div>
			<table class="table-blue faq-info">
				<tbody>
					<tr>
						<th>작성자</th>
						<td>
							${faqVO.mngrVO.memberVO.mbrNm}
							<input type="hidden" id="faqSeq" value="${faqVO.faqSeq}">
						</td>
						<th>문의 유형</th>
						<td>
							<!-- 수정 전에는 input으로 출력 -->
						    <span id="qsTypeText">${faqVO.qsTypeNm}</span>
						    
						    <!-- 수정 모드에서는 select로 변경, 처음에는 hidden 상태 -->
						    <div class="select-custom" style="width:150px; display:none;" id="qsTypeSelectWrap">
						        <select name="qsType" id="qsType">
						            <c:forEach var="qsType" items="${qsType}">
						                <option value="${qsType.comNo}" <c:if test="${faqVO.qsType == qsType.comNo}">selected</c:if>>
						                    ${qsType.comNm}
						                </option>
						            </c:forEach>
						        </select>
						    </div>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3">
						    <!-- 수정 전에는 그냥 텍스트로 출력 -->
						    <span id="faqTtlText">${faqVO.faqTtl}</span>
						    
						    <!-- 수정 모드에서는 input으로 변경, 처음에는 hidden 상태 -->
						    <input type="text" id="faqTtlInput" class="text-input" value="${faqVO.faqTtl}" style="display:none;">
						</td>
					</tr>
					
					<tr>
						<th>내용</th>
						<td colspan="3">
							<textarea id="faqCn" rows="8" cols="1" spellcheck="false" disabled>${faqVO.faqCn}</textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- table-wrap -->
	</div>
</div>