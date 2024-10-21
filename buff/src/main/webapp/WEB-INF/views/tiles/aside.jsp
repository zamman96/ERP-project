
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<sec:authentication property="principal.MemberVO" var="user" />
<script type ="text/javascript">
var userRole = '<c:out value="${user}" />';
let url = '';
$(document).ready(function() {
	
	checkStock();
	
    // .main-sidebar 요소에서 hover 상태일 때 동작 실행
    $('.main-sidebar:not(.sidebar-no-expand)').on('mouseleave', function() {
        // 조건에 맞는 경우 실행할 동작
        $('.nav-title').removeClass('active');
        $('.nav-sub-detph1-title').removeClass('active');
        $('.nav-sub').slideUp();
    });
    
    /* 거래처 상품 관리 - 클릭 시, 재고 유무 확인에 따른 페이지 이동 이벤트 */
	// 상품 관리 하위 메뉴 선택 시
	$(".move-cnpt").on("click", function(e){
		// 기본 동작을 막음
		e.preventDefault();
		
		// 이동할 URL
		let targetUrl = $(this).attr("href");
		// 인증된 사용자로부터 받은 거래처 번호
		let bzentNo = "${user.bzentNo}";
		
		// ajax로 해당 거래처의 재고가 있는지 확인
		$.ajax({
			url : "/cnpt/gds/hasStock",
			type : "GET",
			data : { bzentNo : bzentNo },
			success : function(hasStock) {
				if(!hasStock){
					// 재고가 없으면 알림 창을 띄우고 재고 등록 페이지로 리다이렉트
					Swal.fire({
					      icon: 'success',
					      title: '신규 거래처이시군요?',
					      text: '재고 등록 페이지로 이동합니다!'
					    });
						
						// 3초 후에 이동
						setTimeout(function(){
							location.href="/cnpt/stock/insertNewStock";
						},3000);
					
				} else {
					// 재고가 있으면 원래 가고자 했던 페이지로 이동
					window.location.href = targetUrl;
				}
			// success 끝
			}
		// ajax 끝	
		});
	// move-cnpt 이벤트 끝	
	});
    
    $('.brand-link').on('click', function(){
    	
    	console.log(userRole);
    	if (userRole.includes('ROLE_CNPT')) {
            window.location.href = '/cnpt/main';
        } else if (userRole.includes('ROLE_HDOFC')) {
            window.location.href = '/hdofc/main';
        } else if (userRole.includes('ROLE_FRCS')) {
            window.location.href = '/frcs/main';
        } else {
            alert('권한이 없습니다.');
        }
    })
    
    var pwChk = new bootstrap.Modal(document.getElementById('pswdOneCheck'))
    
	$('.myPage').on('click', function(){
		url = $(this).data('url');	
		pwChk.show();
	})
		
	// 	비밀번호 확인 버튼 클릭시 이벤트 핸들러
	$("#oneModalBtnCheck").on("click", function(){
		
		var inputPswd = $("#onePswdInput").val();
		$("#onePswdInput").val('');
		console.log("inputPswd : " + inputPswd);
		
		// 비밀번호 검증 Ajax 비동기 처리
		$.ajax({
			url : "/find/checkPswd",
			type : "POST",
			data : { inputPswd : inputPswd },
			dataType:"text",
			beforeSend : function(xhr){ 
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}"); 
			},
			success : function(res){
				console.log("res : ", res);
				
				if(res === "success"){
					pwChk.hide();
					location.href = url;
				} else {
					pwChk.hide();
					// 	비밀번호 불일치
					Swal.fire({
					      icon: 'error',
					      title: 'Error!',
					      text: '비밀번호가 일치하지 않습니다..'
					    });
					
				}
			},
			error : function(xhr, status, error){
					console.log("xhr: ", xhr);
			    	console.log("status: ", status);
			    	console.log("error: ", error);
			}
			
		});
		
	// 모달창 이벤트 핸들러 끝.	
	});
    
    $('#modalClose').on('click', function(){
    	pwChk.hide();
    })
    
    
})
function checkStock(){
    let bzentNo = "${user.bzentNo}";
    console.log("aside-bzentNo", bzentNo);
    
    // 해당 거래처의 재고 유무확인
    $.ajax({
    	url : "/cnpt/gds/hasStock",
    	type : "GET",
    	data : { bzentNo:bzentNo },
    	success : function(hasStock){
    		if(!hasStock){
    			// 재고가 없으면 신규 거래처 버튼 보이기
    			$("#new-cnpt-btn").show();
    		}
    	},
    	error : function(xhr, status, error){
    		console.error("재고 확인 중 오류 : ", error);
    	}
    // 재고 유무 ajax 끝	
    });
}


/* 1뎁스 메뉴를 클릭한 경우 2뎁스 영역이 보이는 이벤트 */
function navTitle(event){
    var target = $(event.currentTarget);
	
	// 클릭한 메뉴 외에 모든 active 클래스 제거 및 서브 메뉴 숨김
    $('.nav-title').not(target).removeClass('active');
    $('.nav-sub').not(target.parent().find('.nav-sub')).slideUp();
    $('.nav-sub-detph1 .icon').not(target.find('.nav-sub-detph1 .icon')).html('Add');
	
    if(target.hasClass('active')){
    	target.removeClass('active');
    	target.parent().find('.nav-sub').slideUp();
    }else {
		target.addClass('active');
		target.parent().find('.nav-sub').slideDown();
    }
}
/* 2뎁스 메뉴를 클릭한 경우 3뎁스 영역이 보이는 이벤트 */
function navSubDetph1(event){
 	var target = $(event.target).closest('.nav-sub-detph1-title');
	
	// 클릭한 메뉴 외에 모든 active 클래스 제거 및 서브 메뉴 숨김
    $('.nav-sub-detph1-title').not(target).removeClass('active');
	$('.nav-sub-detph1 .icon').not(target.find('.nav-sub-detph1 .icon')).html('Add');
	
   	if (target.hasClass('active')){
   		target.removeClass('active');
   		target.find('.icon').html('Add');
   	} else {
   		target.addClass('active');
   		target.find('.icon').html('Remove');
   	} 
}


</script>
<%--
 	@programName : 사이드 메뉴 화면
 	@description : 권한 시큐리티를 통해 권한에 따라 사이드 메뉴를 다르게 보여준다.
 				   개발이 어느정도 완료 되면 실행 될 예정.
 	@author      : 정기쁨
 	@date        : 2024. 09. 13
--%>
<aside class="main-sidebar">
	<!-- Brand Logo -->
	<div class="brand-link" style="cursor: pointer;"> 
		<img src="/resources/images/common/logo.png" alt="Buff Logo" class="brand-image">
		<span class="logo-text">BUFF ERP</span>
	</div>

	<!-- Sidebar -->
	<div class="sidebar">
		
		<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.memberVO" var="user"/>
		
		<!-- 본사 Sidebar Menu -->
		<c:if test="${user.mbrType == 'MBR04'}">
 		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<li class="nav-cont">
					<div class="nav-title" onclick="navTitle(event)">
						<span class="material-symbols-outlined">handshake</span>파트너 관리	
					</div>
					<div class="nav-sub" style="display:none;">
						<div class="nav-sub-detph1">
							<div class="nav-sub-detph1-title" onclick="navSubDetph1(event)">
								<a href="/hdofc/frcs/list">가맹점 관리</a>
							</div>
							<div class="nav-sub-detph2"> 
								<a href="/hdofc/frcs/dscsn/list" class="move-link" style="padding-left: var(--pd--s);"> - 상담 관리</a>
								<a href="/hdofc/frcs/check/list" class="move-link" style="padding-left: var(--pd--s);"> - 점검 관리</a>
								<a href="/hdofc/frcs/clsbiz/list" class="move-link" style="padding-left: var(--pd--s);"> - 폐업 관리</a>
							</div>
						</div>
						<a href="/hdofc/cnpt/list" class="move-link">거래처 관리</a>
						<a href="/hdofc/mngr/selectMngrList" class="move-link">사원 관리</a>
						<a href="/hdofc/member/selectMemberList" class="move-link">회원 관리</a>
					</div>		
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="navTitle(event)">
						<span class="material-symbols-outlined">local_shipping</span>물류 관리		
					</div>
					<div class="nav-sub" style="display:none;">
<!-- 						<a href="/hdofc/gds/list" class="move-link">상품 관리</a> -->
							<div class="nav-sub-detph1">
							<div class="nav-sub-detph1-title" onclick="navSubDetph1(event)">
								<a href="/hdofc/gds/list">재고 관리</a>
							</div>
							<div class="nav-sub-detph2"> 
								<a href="/hdofc/stockAjmt/list" class="move-link" style="padding-left: var(--pd--s);"> - 재고 조정 현황</a>
<!-- 								<a href="/hdofc/stockAjmt/selectStockAjmtList" class="move-link" style="padding-left: var(--pd--s);"> - 상품 소모량 조회</a> -->
<!-- 								<a href="/hdofc/gds/safe/list" class="move-link" style="padding-left: var(--pd--s);"> - 안전 재고 관리</a> -->
							</div>
						</div>
						<a href="/hdofc/deal/list?type=po" class="move-link">구매 관리</a>
						<a href="/hdofc/deal/list?type=so" class="move-link">판매 관리</a>
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="navTitle(event)">
						<span class="material-symbols-outlined">savings</span>회계 관리
					</div>
					<div class="nav-sub" style="display:none;">
						<a href="/hdofc/frcsClcln/list" class="move-link">가맹점 정산</a>
<!-- 						<div class="nav-sub-detph1-title" onclick="navSubDetph1(event)"> -->
<!-- 							<a href="/hdofc/clcln/list?type=po" class="move-link">구매/판매 정산</a> -->
<!-- 						</div> -->
<!-- 							<div class="nav-sub-detph2">  -->
<!-- 								<a href="/hdofc/clcln/list?type=po" class="move-link" style="padding-left: var(--pd--s);"> - 구매 정산</a> -->
<!-- 								<a href="/hdofc/clcln/list?type=so" class="move-link" style="padding-left: var(--pd--s);"> - 판매 정산</a> -->
<!-- 							</div> -->
						<a href="/hdofc/analyze/selectFrcsAnalyzeList" class="move-link">가맹점 매출 분석</a>
						<a href="/hdofc/analyze/selectAnalyzeList" class="move-link">메뉴 매출 분석</a>
					</div>		
				</li>
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/hdofc/menu/list'">
						<span class="material-symbols-outlined">lunch_dining</span>판매 메뉴 관리
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="window.location.href='/hdofc/event/selectEventList'">
						<span class="material-symbols-outlined">festival</span>이벤트 관리		
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="navTitle(event)">
						<span class="material-symbols-outlined">assignment</span>게시판 관리		
					</div>
					<div class="nav-sub" style="display:none;">
						<a href="/hdofc/notice/selectNoticeList" class="move-link">공지사항 관리</a>
						<a href="/hdofc/qs/selectQsList" class="move-link">문의사항 관리</a>
						<a href="/hdofc/faq/selectFaqList" class="move-link">FAQ 관리</a>
					</div>	
				</li>
				<li class="nav-cont">
<!-- 					<div class="nav-title" onclick="window.location.href='/hdofc/myPage/'"> -->
					<div class="nav-title myPage" data-url="/hdofc/myPage/">
						<span class="material-symbols-outlined">person</span>마이 페이지			
					</div>
				</li>
			</ul>
		</nav>
		</c:if>
		<!-- /.본사 sidebar-menu -->
		
		<!-- 거래처 Sidebar Menu -->
		<c:if test="${user.mbrType == 'MBR03'}">
 		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<li class="nav-cont">
					<div class="nav-title" onclick="navTitle(event)" >
						<span class="material-symbols-outlined">inventory_2</span>재고 관리			
					</div>
					<div class="nav-sub" style="display:none;">
						<a href="/cnpt/gds/list" class="move-link move-cnpt">재고 현황</a>
						<a href="/cnpt/stockAjmt/list" class="move-link move-cnpt">재고 조정 현황</a>
<!-- 						<a href="/cnpt/stock/insertStockQty" class="move-link move-cnpt">재고 조정</a> -->
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/cnpt/deal/list'">
						<span class="material-symbols-outlined">local_shipping</span>납품 관리			
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="window.location.href='/cnpt/sls/selectSales'">
						<span class="material-symbols-outlined">paid</span>매출 분석		
					</div>
				</li>
<!-- 				<li class="nav-cont"> -->
<!-- 					<div class="nav-title" onclick="window.location.href=''"> -->
<!-- 						<span class="material-symbols-outlined">person</span>정산 관리			 -->
<!-- 					</div> -->
<!-- 				</li> -->
				<li class="nav-cont">
					<sec:authentication property="principal.MemberVO" var="user"/>
					<div class="nav-title myPage" data-url="/cnpt/selectCnpt">
						<span class="material-symbols-outlined">person</span>마이 페이지			
					</div>
				</li>
				<li class="nav-cont" style="display:none;" id="new-cnpt-btn">
					<div class="nav-title">
						<a href="/cnpt/stock/insertNewStock" class="move-link">
							<button class="btn-default">신규 거래처이신가요?</button>
						</a>
					</div>
				</li>
			</ul>
		</nav>
		</c:if>
		<!-- /.거래처 Sidebar Menu -->
		
		<!-- 가맹점 Sidebar Menu -->
		<c:if test="${user.mbrType == 'MBR02'}">		
 		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/frcs/frcsClcln/list'">
						<span class="material-symbols-outlined">savings</span>월간 정산 관리
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="navTitle(event)">
						<span class="material-symbols-outlined">paid</span>매출 관리		
					</div>
					<div class="nav-sub" style="display:none;">
						<a href="/frcs/periodSlsList" class="move-link">기간별 매출 조회</a>
						<a href="/frcs/menuSlsList" class="move-link">메뉴별 매출 조회</a>
						<a href="/frcs/netProfitList" class="move-link">순이익 조회</a>
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/frcs/deal/list'">
						<span class="material-symbols-outlined">local_shipping</span>발주 관리			
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title"  onclick="navTitle(event)">
						<span class="material-symbols-outlined">inventory_2</span>재고 관리		
					</div>
					<div class="nav-sub" style="display:none;">
						<a href="/frcs/stockList" class="move-link">재고 현황 조회</a>
<!-- 						<a href="#none" class="move-link">안전 재고 설정</a> -->
<!-- 						<a href="/frcs/stockAjmtList" class="move-link">재고 조정 관리</a> -->
						<a href="/frcs/stockAjmt/list" class="move-link">재고 조정 현황</a>
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/frcs/menuList'">
						<span class="material-symbols-outlined">lunch_dining</span>판매 메뉴 관리	
					</div>
				</li>
				<li class="nav-cont">
					<div class="nav-title" onclick="window.location.href='/frcs/couponList'">
						<span class="material-symbols-outlined">search</span>쿠폰 사용 내역 조회
					</div>
				</li>
				<li class="nav-cont">
<!-- 					<div class="nav-title" onclick="window.location.href='/frcs/myPage'"> -->
					<div class="nav-title myPage" data-url="/frcs/myPage">
						<span class="material-symbols-outlined">person</span>마이 페이지			
					</div>
				</li>
			</ul>
		</nav>
		</c:if>
		<!-- /.가맹점 Sidebar Menu -->
		
		</sec:authorize>
		
	</div>
	<!-- /.sidebar -->
</aside>


 <!-- 비밀번호 확인 모달 -->
 <div class="modal fade" id="pswdOneCheck" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">비밀번호 확인</h4>
					<div class="btn-wrap">
						<button type="button" id="modalClose" class="modal-close" data-bs-dismiss="modal">닫기</button>
						<button type="button" id="oneModalBtnCheck" class="btn-active">확인</button>
					</div>
				</div>
<!-- Modal body -->
				<div class="modal-body">
					<div class="form-group">
						<label for="pswdInput">비밀번호를 입력하세요.</label>
						<input type="password" class="text-input" id="onePswdInput" 
							   name="pswdInput" placeholder="비밀번호를 입력하세요." />
					</div>
				</div>
<!-- Modal footer -->
			</div>
		</div>
<!-- modal창 끝--> 
</div>





