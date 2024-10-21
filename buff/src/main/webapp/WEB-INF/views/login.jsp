<%--
 	@fileName    : Login.jsp
 	@programName : 로그인 화면
 	@description : 사용자 로그인을 위한 화면
 				   유형 선택이 아닌 로그인 시, 권한에 따라 
 				   페이지가 나뉘어질 예정이라 추후 바뀔 예정임.
 	@author      : 이병훈
 	@date        : 2024. 09. 11
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<link href="/resources/cust/css/login.css" rel="stylesheet"/>
<link rel="stylesheet" href="/resources/css/sweetalert2.min.css">

<!-- 인증된 사용자일 때 표시할 내용: 사용 안함 -->
<%-- <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.MemberVO" var="user" />
</sec:authorize> --%>

<!-- 비로그인 사용자일 때 표시할 내용: 사용 안함 -->
<%-- <sec:authorize access="isAnonymous()">
    <!-- <p>로그인하지 않은 사용자입니다.</p> -->
</sec:authorize> --%>

<div class="wrap login-wrap">
	
	<div class="wrap-cont">
	
		<!-- 공통 타이틀 영역 -->
		<div class="wrap-title login">고객 로그인</div>
		<!-- /.wrap-title -->

		<!-- 로그인 박스 영역 시작 -->
		<div class="login-inner">
		
			<div class="login-button-wrap">
				<button type="button" class="btn btn-default login-button" data-pw="java" data-id="i0bzrqwo">고객</button>
			</div>
		
			<!-- 로그인 폼 시작 -->
			<form id="loginf" action="/login" method="post">
				
				<!-- id 입력 시작 -->
				<div class="mb-3">
					<div class="input-group">
						<input type="text" id="username" class="input-cont" name="username" placeholder="아이디를 입력하세요" autocomplete="username" required/>
						<span class="input-icon material-symbols-outlined">person</span>
					</div> 
					<div id="warning" style="color: red; display: none; font-size: small; margin-top: 10px;">
						<span class="material-symbols-outlined icon" style="color: red;">warning</span> 대문자가 포함되어 있습니다.
					</div>
				</div>
				<!-- id 입력 끝 -->
				
				<!-- pw 입력 시작 -->
				<div class="mb-3">
					<div class="input-group">
						<input type="password" id="password" name="password" class="input-cont" placeholder="비밀번호를 입력하세요" autocomplete="current-password" required />
						<span class="input-icon material-symbols-outlined">lock</span>
					</div>
				</div>
				<!-- pw 입력 끝 -->
				
				<!-- 로그인 버튼 시작 -->
				<div class="btn-wrap">
					<button class="btn-cont login-btn btn-active" type="submit">로그인</button>
			        <button class="btn-cont join-btn" type="button" onclick="javascript:location.href='/join?type=member'">회원 가입</button>
				</div>
				<!-- 로그인 버튼 끝 -->
				
				<!-- 아이디 & 비번 찾기 시작 -->
				<div class="find-wrap">
					<div class="find-cont">
						<div class="find-btn" data-bs-toggle="modal" data-bs-target="#idFindModal">아이디 찾기</div>
					</div>
	               	<div class="find-cont">
	               		<div class="find-btn" data-bs-toggle="modal" data-bs-target="#pwdFindModal">비밀번호 찾기</div>
               		</div>
				</div>
				<!-- 아이디 & 비번 찾기 끝 -->
				
				<!-- csrf : Cross Site(크로스 사이트) Request(요청) Forgery(위조) 보안 -->
				<sec:csrfInput/>
			
			</form>
			<!-- /.form -->

		</div>
		<!-- login-cont -->		

	</div>
	<!-- /.wrap-cont -->
	
	
</div>
<!-- /.wrap -->


<!-- ID찾기 Modal -->
<div class="modal" id="idFindModal" aria-labelledby="idFindModal" aria-hidden="true">
	
	<!-- modal-dialog -->
	<div class="modal-dialog modal-dialog-centered">
		
		<!-- /.modal-content -->
		<div class="modal-content">
			
			<!-- modal-header -->
			<div class="modal-header align-items-center justify-content-between">
		        <div>
		         	<h4 class="modal-title">
		          		<span class="modalTitle-icon material-symbols-outlined">person_search</span> 아이디 찾기
	          		</h4>
		        </div>
		        <div>
		          <!-- Bootstrap 5에서는 data-dismiss를 data-bs-dismiss로 변경 -->
		          <button type="button" class="btn-icon" data-bs-dismiss="modal">
		            <span class="material-symbols-outlined close-btn">close</span>
		          </button>
		        </div>
	      	</div>
	      	<!-- /.modal-header -->

			<!-- Modal body -->
			<div class="modal-body">
				<form id="idform" name="idform">
					<div class="loginSearch-wrap">
						<div class="modal-cont">
							<div class="cont-title">이름</div>
				          	<div class="cont-cont">
								<input type="text" class="data" name="idName" id="idName">
				          	</div>
						</div>
						<div class="modal-cont">	
							<div class="cont-title">이메일</div>
				          	<div class="cont-cont">
								<input type="text" class="data" name="idMail" id="idMail">
				          	</div>
			          	</div>
					</div>
				</form>
			</div>
			<!-- /.modal-body -->

			<!-- Modal footer -->
			<div class="modal-footer" id="idCheck">확인</div>
			
		</div>
		<!-- /.modal-content -->
		
	</div>
	<!-- /.modal-dialog -->
	
</div>
<!-- /.modal -->

<!-- PassWord찾기 Modal -->
<div class="modal" id="pwdFindModal"  aria-labelledby="pwdFindModal" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			
			<!-- modal-header -->
			<div class="modal-header align-items-center justify-content-between">
		        <div>
		         	<h4 class="modal-title">
		          		<span class="modalTitle-icon material-symbols-outlined">lock_open</span> 비밀번호 찾기
	          		</h4>
		        </div>
		        <div>
		          <!-- Bootstrap 5에서는 data-dismiss를 data-bs-dismiss로 변경 -->
		          <button type="button" class="btn-icon" data-bs-dismiss="modal">
		            <span class="material-symbols-outlined close-btn">close</span>
		          </button>
		        </div>
	      	</div>
	      	<!-- /.modal-header -->

			<!-- Modal body -->
			<div class="modal-body">
				<form id="passform" name="passform">
					<div class="loginSearch-wrap">
						<div class="modal-cont">
							<div class="cont-title">아이디</div>
				          	<div class="cont-cont">
								<input type="text" class="data" name="passId" id="passId">
				          	</div>
						</div>
						<div class="modal-cont">
							<div class="cont-title">이름</div>
				          	<div class="cont-cont">
								<input type="text" class="data" name="passName" id="passName">
				          	</div>
						</div>
						<div class="modal-cont">	
							<div class="cont-title">이메일</div>
				          	<div class="cont-cont">
								<input type="text" class="data" name="passMail" id="passMail">
				          	</div>
			          	</div>
					</div>
				</form>
			</div>

			<!-- Modal footer -->
			<div class="modal-footer" id="passCheck">전송</div>

		</div>
	</div>
</div>

<!-- ID 찾기 결과 Modal -->
<div class="modal" id="idResultModal">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			
			<!-- modal-header -->
			<div class="modal-header align-items-center justify-content-between">
		        <div>
		         	<h4 class="modal-title">
		          		<span class="modalTitle-icon material-symbols-outlined">person_search</span> 아이디 찾기 결과
	          		</h4>
		        </div>
		        <div>
		          <!-- Bootstrap 5에서는 data-dismiss를 data-bs-dismiss로 변경 -->
		          <button type="button" class="btn-icon" data-bs-dismiss="modal">
		            <span class="material-symbols-outlined close-btn">close</span>
		          </button>
		        </div>
	      	</div>
	      	<!-- /.modal-header -->

			<!-- Modal body -->
			<div class="modal-body">
				<p id="idResult"></p>
			</div>

			<!-- Modal footer -->
			<div class="modal-footer" data-bs-dismiss="modal">닫기</div>

		</div>
	</div>
</div>

<!-- Password 찾기 결과 Modal -->
<div class="modal" id="passResultModal">
	<div class="modal-dialog">
		<div class="modal-content">

			<!-- Modal Header -->
			<div class="modal-header modal-title">
				비밀번호 찾기 결과
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<!-- Modal body -->
			<div class="modal-body">
				<p id="passResult"></p>
			</div>

			<!-- Modal footer -->
			<div class="modal-footer">
				<button type="button" class="btn btn-danger"
					data-bs-dismiss="modal">닫기</button>
			</div>

			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		</div>
	</div>
</div>
<!-- Password 찾기 결과 Modal 끝 -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="/resources/js/sweetalert2.min.js"></script>

<script type="text/javascript">
$(function(){
	
	// ID찾기 모달 이벤트 핸들러
	$("#idCheck").on("click", function(){
		var userName = $('#idName').val().trim();
		var userEmail = $('#idMail').val().trim();
		
		// 정규식: 이메일 유효성 검사
	    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		
		// 필수 입력값 확인 예외처리 (입력값이 비었으면 경고 표시)
		if(!userName || !userEmail){
			Swal.fire({
			      icon: 'error',
			      title: 'Error!',
			      text: '이름과 이메일을 모두 입력하세요.'
			    });
			return;
		}
		
		// 이메일 유효성 검사에 따른 alert창 표시
		if (!emailRegex.test(userEmail)) {
	        Swal.fire({
	            icon: 'error',
	            title: 'Error!',
	            text: '올바른 이메일 형식을 입력하세요.'
	        });
	        return;
	    }
		// 로딩 애니메이션
		showLoading();
		
		$.ajax({
			url : "/find/idAjax",
			data : {userName : userName, userEmail : userEmail},
			type : "POST",
			beforeSend:function(xhr){ 
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}"); 
			},
			success : function(res){
				console.log(res);
				// 응답 데이터를 결과 모달에 표시
				// ID가 정상적으로 조회된 경우 결과 모달에 표시
				if(res){
				
				// 애니메이션 닫기
				Swal.close();
				
				$("#idResult").text("회원님의 ID는 " + res + "입니다.");
				// 기본 모달 숨기기
				$("#idFindModal").modal("hide"); 
				// 결과 모달 열기
				$("#idResultModal").modal("show");
				
				} else{
					// ID값을 찾지 못한 경우 메시지 표시
					Swal.fire({
					      icon: 'error',
					      title: '아이디 찾기 실패!',
					      text: '입력한 정보로 일치하는 ID를 찾을 수 없습니다.'
					    });
				}
			},
		 	error : function(xhr, status, error){
		 		// 서버와의 통신 실패 시 에러 메시지 표시
		 		Swal.fire({
				      icon: 'error',
				      title: '아이디 찾기 실패!',
				      text: 'ID찾기 요청 중 오류가 발생하였습니다!'
				    });
		 		console.error("Error : ", status, error);
		 	}
			
		}); // ajax 끝.
		
	}); // ID찾기 모달 끝.
	
	// Password찾기 모달 이벤트 핸들러
	$("#passCheck").on("click", function(){
		var userId = $("#passId").val().trim();
		var userName = $("#passName").val().trim();
		var userEmail = $("#passMail").val().trim();
		
		let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		
		// 필수 입력값 확인 (입력값이 비었으면 경고 표시)
		if(!userId || !userName || !userEmail){
			Swal.fire({
			      icon: 'error',
			      title: 'Error!',
			      text: 'ID, 이름, 이메일을 모두 입력하세요.'
			    });
			return;
		}
		
		if (!emailRegex.test(userEmail)) {
	        Swal.fire({
	            icon: 'error',
	            title: 'Error!',
	            text: '올바른 이메일 형식을 입력하세요.'
	        });
	        return;
	    }
		
		let data = {"userId":userId,"userName":userName,"userEmail":userEmail};
		console.log("data : ", data);
		
		// 로딩 애니메이션
		showLoading();
		
		// 비밀번호 찾기 Ajax
		// CSRF 토큰을 요청 헤더에 추가
		$.ajax({
			url : "/find/pswdAjax?mbrId=" + userId + "&mbrNm=" + userName + "&mbrEmlAddr=" + userEmail,
			type : "GET",
			dataType:"text",
			beforSend : function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				
			},
			success : function(res){
					console.log("res : ", res);
// 					// 비밀번호 앞 5자리만 보여주고, 뒷자리는 *로 표시
// 					var startPswd = res.subString(0, 5);
// 					var hiddenPswd = '*'.repeat(res.length - 5);
					
// 					// 최종적으로 보여줄 비밀번호
// 					var pswd = startPswd + hiddenPswd;
					
					// 비밀번호가 정상적으로 조회한 경우 결과 모달에 표시
// 					$("#passResult").text("회원님의 비밀번호는 " + res + "입니다.");
					
					// 애니메이션 닫기
					Swal.close();
					
					Swal.fire({
					      icon: 'success',
					      title: '성 공!',
					      text: '입력하신 이메일로 임시 비밀번호가 전송되었습니다.'
					    });
					
					
					// 기존 모달 창 닫기
					$("#pwdFindModal").modal("hide");
					// 결과 모달 창 열기
// 					$("#pwdResultModel").modal("show");
					
// 				} else{
// 					// 비밀번호를 찾지 못한 경우, 경고창 표시
// 					Swal.fire({
// 					      icon: 'error',
// 					      title: 'Error!',
// 					      text: '입력한 정보로 일치하는 비밀번호를 찾을 수 없습니다.'
// 					    });
// 				}
			},
			error : function(xhr, status, error){
				// 서버와의 통신 오류시, 에러메세지
				Swal.fire({
				      icon: 'error',
				      title: '비밀번호 찾기 실패!',
				      text: '회원 정보를 찾을 수 없습니다. 다시 입력해주세요'
				    });
				console.error("Error :" + status, error);		
					
			}
			
		}) // Ajax 끝.
		
		
	});	// 비밀번호 찾기 모달 끝.
	
	// id 입력시 대문자 포함될 경우, 감지
	$("#username").on("input", function(){
		//  id창 입력하는 값
		let inputVal = $(this).val(); 
		
		// 대문자가 포함되어있는지 확인하는 정규식
		let hasUpperCase = /[A-Z]/.test(inputVal);
		// 특수문자가 포함되어있는지 확인하는 정규식
		let hasSpecialChar = /[^a-zA-Z0-9]/.test(inputVal);
		         
		if(hasUpperCase || hasSpecialChar){
			$("#warning").show();
		}else{
			$("#warning").hide();
		}
		
		
	});
	
	$(".btn-close").on("click", function(){
		$(this).modal("hide");
		
	});
	
	$('.login-button').on('click', function(){
		let pw = $(this).data("pw");
		let id = $(this).data("id");
		
		$('#username').val(id);
		$('#password').val(pw);
	})
	
	// ID찾기 모달 창이 닫힐 때 입력 필드 초기화
	$('#idFindModal').on('hidden.bs.modal', function () {
	    $('#idName').val('');
	    $('#idMail').val('');
	});
	
	// Password찾기 모달 창이 닫힐 때 입력 필드 초기화
	$('#pwdFindModal').on('hidden.bs.modal', function () {
	    $('#passId').val('');
	    $('#passName').val('');
	    $('#passMail').val('');
	});
	
	// 결과 모달 닫기 시 이벤트
    $("#idResultModal").on('hidden.bs.modal', function () {
        $("#idResult").text(''); // 결과 초기화
    });

	
	
});

// 전송 시 로딩 애니메이션 추가
function showLoading(){
	Swal.fire({
        title: '처리 중...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
}

</script>