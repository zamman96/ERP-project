/*******************************************
  @fileName    : gds.js
  @author      : 이병훈
  @date        : 2024. 09. 23
  @description : 거래처 상품 조회 코드
********************************************/
document.write("<script src='/resources/js/global/value.js'></script>");

// @methodName  : selectGdsAjax
// @author      : 이병훈
// @date        : 2024.09.23
// @jsp         : cnpt/gds/selectGds
// @description : 거래처 상품 리스트 및 검색 조건에 따른 리스트 조회

function selectGdsAjax(){
	
	let gubun = $("#gubun").val();
	let keyword = $("#keyword").val();
	let ntslType = $('#ntslType').val();  // 선택된 판매 유형
    let gdsType = $('#gdsType').val();  // 대유형
	let gdsNm = $("#gdsNm").val();
	
	console.log("bzentNo : " + bzentNo);
	
	let data = { };
	// 값이 빈 문자열이 아니면 data 객체에 추가
	if (gdsType) {
	    data.gdsType = gdsType;
	}
	if (gdsNm) {
	    data.gdsNm = gdsNm;
	}
	if (ntslType) {
	    data.ntslType = ntslType;
	}
	
	data.currentPage = currentPage;
	data.sort = sort;
	data.orderby = orderby;
	data.gubun = gubun;
	data.keyword = keyword;
	data.bzentNo = bzentNo;
	
	console.log("data : ", data);
	
	$.ajax({
		url : "/cnpt/gds/listAjax",
		type : "GET",
		data : data, 
		success : function(res){
			console.log("res : ",res);
			
			// 전체 상품 수 all값을 동적으로 업데이트 
			$("#tap-all").text(res.all);
			$("#tap-selling").text(res.selling);
			$("#tap-notSelling").text(res.notSelling);
			
			let strTbl = '';
			if(res.articlePage.total == 0){ // 검색 결과가 0인 경우
				strTbl += 
						`<tr>
							<td class="error-info center" colspan="8"> 
								<span class="icon material-symbols-outlined" style="font-size: 5rem !important;
    								font-variation-settings: 'FILL' 0, 'wght' 100, 'GRAD' 0, 'opsz' 24;">error</span>
								<div class="error-msg">검색 결과가 없습니다</div>
							</td>
						</tr>`;
			
			} else {
				res.articlePage.content.forEach(list => {
					// 각각의 재고 정보를 반복하여 출력
					console.log(list);
					
					let qty = list.stockVOList[0].qty;
					// 천 단위 구분 기호 적용
					let formatQty = qty.toLocaleString();
					
					let amt = list.stockVOList[0].gdsAmtVOList[0].amt;
					
					let formatAmt = amt.toLocaleString();
					
					// 판매 유형
					let ntsl = `<span class='bge ${
					    list.stockVOList[0].ntslType=='GDNT01' ? 'bge-info-border' 
					    : list.stockVOList[0].ntslType=='GDNT02' ? 'bge-danger-border' 
					    : 'bge-active-border'}'>${list.stockVOList[0].ntslTypeNm}</span>`;
					// 유형
					let type = `<span class='bge ${
					    list.gdsType.substring(0, 2) == 'FD' ? 'bge-active' 
					    : list.gdsType.substring(0, 2) == 'SM' ? 'bge-warning' 
					    : 'bge-danger'}'>${list.gdsTypeNm}</span>`;
					
					
					strTbl += 
	 						`
	 						<tr class="product-row" data-gds-code="${list.gdsCode}">
	 							<td class="center">${list.rnum}</td>
	 							<td>${list.gdsNm}</td>
	 							<td class="right">${formatQty}</td>
	 							<td class="center">${list.unitNm}</td>
	 							<td class="right">${formatAmt}</td>
	 							<td class="center">${ntsl}</td>
				        		<td class="center">${type}</td>
	 						</tr>
	 						`;
					
					});
				}
				// 테이블 바디에 데이터 삽입
				$('#table-body').html(strTbl);
	
				// 페이징 처리
				let page = '';
				if (res.articlePage.startPage > res.articlePage.blockSize) {
				    page += `<a href="#page" class="page-link" data-page="${res.articlePage.startPage - res.articlePage.blockSize}">
				            <span class="icon material-symbols-outlined">chevron_left</span></a>`;
				}
				for (let pnum = res.articlePage.startPage; pnum <= res.articlePage.endPage; pnum++) {
					if (res.articlePage.currentPage === pnum) {
						page += `<a href="#page" class="page-link active" data-page="${pnum}">${pnum}</a>`;
					} else {
						page += `<a href="#page" class="page-link" data-page="${pnum}">${pnum}</a>`;
					}
				}
				if (res.articlePage.endPage < res.articlePage.totalPages) {
					page += `<a href="#page" class="page-link" data-page="${res.articlePage.startPage + res.articlePage.blockSize}">
				            <span class="icon material-symbols-outlined">chevron_right</span></a>`;
				}
				
				$('.pagination').html(page);
				
		}
	// ajax 끝	
	});
// selectGdsAjax 끝	
}
 /*******************************************
	상품 단가 변동 추이 조회 - 6개월의 월수 데이터 뽑기
********************************************/
 // @methodName  : getSixMonths
// @author      : 이병훈
// @date        : 2024.09.25
// @jsp         : /cnpt/gds/selectGds, /cnpt/gds/amtTrend
// @description : chart.js x행에 들어갈 6개월 간의 월 수


// 지난 6개월의 월 단위 추출 함수
function getSixMonths(){
	const months = [];
	const currentDate = new Date();
	
	for(let i=0; i<6; i++){
		// 월은 0부터 시작하므로 +1
		const month = new Date(currentDate.getFullYear(), currentDate.getMonth()-i, 1);
		months.unshift(month.toLocaleDateString('ko-KR', { year: '2-digit', month : '2-digit' }));
		}		

	// 최신날짜가 앞에 오도록 순서 반전
	return months;

// getSixMonths 함수 끝	
}

 /*******************************************
	단가 변동에 의한 차트 데이터 변동 사항 추가 , 변동이력이 없으면 이전 단가 동일
********************************************/
function createChartData(gdsAmtVOList, months, defaultAmt){
	let chartData = [];
	// 이전 단가 또는 기본 단가를 저장하는 변수
	let lastAmt = defaultAmt;
	
	// 월별 데이터에 맞춰 실제 변동단가를 매칭
	months.forEach(month => {
		let found = false;
		
		// 해당 월에 맞는 데이터가 있으면 사용
        for (let amtData of gdsAmtVOList) {
            let ajmtMonth = new Date(amtData.ajmtDt).toLocaleString('ko-KR', { year: '2-digit', month: '2-digit' });
            if (ajmtMonth === month) {
                chartData.push(amtData.amt);  // 매칭된 단가 사용
                lastAmt = amtData.amt;        // 이후 월에 적용할 마지막 단가로 저장
                found = true;
                break;  // 매칭되면 더 이상 비교할 필요 없으니 루프 종료
            }
        }
		// 해당 월에 맞는 데이터가 없으면 이전 단가 또는 기본값을 유지
		if(!found){
			// 이전 데이터 혹은 0
			chartData.push(lastAmt);
			
		}	
	 });
	 return chartData;
}
/*******************************************
	상품 상세 페이지 
********************************************/

function selectGdsDtlAjax(){
	
let stockVO = {};

stockVO.gdsCode = gdsCode;
stockVO.bzentNo = bzentNo;

// 서버 전송
$.ajax({
	url : "/cnpt/gds/dtlAjax",
	type : "POST",
	data : JSON.stringify(stockVO),
	contentType : "application/json; charset=utf-8",
	// csrf 설정 security 설정된 경우 필수
	beforeSend : function(xhr){
		// CSRF 헤더와 토큰을 설정
		xhr.setRequestHeader(csrfHeader, csrfToken); 
	},
	success : function(res){
		let gds = res.gdsVO;
		console.log(res);
		if(res.chk>0){
			// 재고에 이미 있는 경우
			$(".input-gds").prop("disabled", true);
			$(".gds-update").hide();
			let type = `<span class='bge ${
				gds.gdsType.substring(0, 2) == 'FD' ? 'bge-active'
				: gds.gdsType.substring(0,2) == 'SM' ? 'bge-warning'
				: 'bge-danger'}'>${gds.gdsTypeNm}</span>`;
			$(".gdsType").html(type);
		} else{
			// 없을 경우
			$("#gdsType").val(gds.gdsType);
			$(".amt-update").hide();
			
		}
		
		$("#gdsNm").val(gds.gdsNm);
		
		$("#unitNm").val(gds.unitNm);
		let amt = "";
		
		if(gds.stockVOList[0].gdsAmtVOList){
			amt = gds.stockVOList[0].gdsAmtVOList[gds.stockVOList[0].gdsAmtVOList.length-1].amt;
		}
		
		ntslType = gds.stockVOList[0].ntslType;
		
		// 판매 유형
		let ntsl = `<span class='bge ${
			gds.stockVOList[0].ntslType=='GDNT01' ? 'bge-info-border'
			: gds.stockVOList[0].ntslType=='GDNT02' ? 'bge-danger-border'
			: 'bge-active-border'}'>${gds.stockVOList[0].ntslTypeNm}</span>`;
			
		if(ntslType=="GDNT01"){
			amt = "";
			$("#ntslTypeTd").html(ntsl);
		} else{
			$("#ntslType").val(gds.stockVOList[0].ntslType);
		}
		// 보이지 않아도 값은 이걸 통해 가져온다
		var selectedOptionText = $("#ntslType option:selected").text(); 
		// view 창에 담을 text를 담는 변수
		$("#ntslType").parent().find('.select-selected').text(selectedOptionText);
		
		
		$("#amt").val(amt);
		$("#qty").text(gds.stockVOList[0].qty.toLocaleString());
		
		// gdsAmtVOList의 마지막 값이 아니라, 변경되기 직전의 단가를 가져오기 위해
		let defaultAmt = gds.stockVOList[0].gdsAmtVOList.length > 1
		    ? gds.stockVOList[0].gdsAmtVOList[gds.stockVOList[0].gdsAmtVOList.length - 2].amt
		    : gds.stockVOList[0].gdsAmtVOList[0].amt;
		console.log("defaultAmt : ", defaultAmt);
		
		// 현재부터 6개월 전까지의 월
		const months = getSixMonths();
		const chartData = createChartData(gds.stockVOList[0].gdsAmtVOList, months, defaultAmt);
		
		console.log("차트 데이터 : ", chartData);
		
		// 차트 js 시작
		// 차트 업데이트 (이미 존재하면 새로 그리지 않고 업데이트)
		if(myChart){
			myChart.data.labels = months;
			myChart.data.datasets[0].data = chartData;
			myChart.update();
		} else {
		
		 myChart = new Chart(
			document.getElementById("amtChart"),
			{
				type : "line",
				data : {
						labels : months,
						datasets : [{
				            label: "단가 변동 추이",
				            data: chartData,
				            fill: false,
				            borderColor: 'rgb(0, 193, 87)',
				            tension: 0.5
				        }]
				},
				options :{
					scales: {
						x : {
							title : { display : true, text : "날짜" },
						},
						y : {
							title : { display : true, text : "단가 (원)" },
		                    ticks : {
		                    	// y축에 표시할 값을 지정
		                    	callback : function(value){
		                    		// 차트 데이터의 단가 값만 y축에 표시
		                    		if(chartData.includes(value)){
		                    			console.log("y축 단가 값 체므 : ", value);
		                    			return value.toLocaleString() + " 원";
		                    		}	
		                    			// 그 외의 값은 표시하지 않음.
		                    			return null;
		                    	    }
		                    	},
		                    	// Y축의 최소/최대 값 설정
			                    min: Math.min(...chartData) - 50,
			                    max: Math.max(...chartData) + 50
							}
			            },
			    legend: {
			        display: false
			    	},	
			    tooltips: {
			        callbacks: {
			           label: function(tooltipItem) {
			                  return tooltipItem.yLabel.toLocaleString() + " 원";
				           }
				        }
				    }
				// options 종료
				}
			}
		// chart 끝	
		)
	};
	
	let strTbl = "";
	
	if(gds.stockVOList[0].gdsAmtVOList[0].amt == 0){
		// 검색 결과가 0인 경우
		strTbl += `
					<tr>
						<td class="error-info" colspan="3"> 
							<span class="icon material-symbols-outlined">error</span>
							<div class="error-msg">단가 변동 결과가 없습니다</div>
						</td>
					</tr>
				  `;
	} else {
		gds.stockVOList[0].gdsAmtVOList.reverse().forEach(list => {
			// 조정 일자
			let ajmt = dtToStr(list.ajmtDt)
    		strTbl += `
					    <tr class="frcsChkDtl" data-no="${list.bzentNo}" data-seq="${list.chckSeq}">
					        <td class="center" style="width: 20%">${list.amtSeq}</td>
					        <td class="center" style="width: 50%">${ajmt}</td>
					        <td class="center" style="width: 30%">${list.amt.toLocaleString()} 원</td>
					    </tr>
					 `;
			
			});
		}
			// 새로 받은 데이터를 기존 테이블에 누적(기존 내용을 유지하고 추가)
			$("#table-body-amt").prepend(strTbl);
		
	// success 끝	
	}
  // ajax 끝	
  })
// 상세페이지 function 끝  
}	

/*******************************************
	상품 단가 및 판매 상태 유형(ntsl) 변경
********************************************/
	
// 판매 상태와 단가 변경
function updateAmtAjax(){
	// bzentNo, gdsCode, ntslType 판매 상태 변경
	let stockVO = {};
	//gdsAmtVO(bzentNo, gdsCode, amt) 단가 변경
	let gdsAmtVO = {};
	
	// gdsType을 제대로 가져오는지 확인
    let gdsType = $("#gdsType").val(); 
    console.log("gdsType:", gdsType);
	
	let ntslType = $("#ntslType").val();
	
	let amt = parseFloat($("#amt").val());
	let newMonth = new Date().toLocaleString('ko-KR', { year : '2-digit', month : '2-digit' });
	
	gdsAmtVO.amt = amt;
	gdsAmtVO.bzentNo = bzentNo;
	gdsAmtVO.gdsCode = gdsCode;
	
	stockVO.bzentNo = bzentNo;
	stockVO.gdsCode = gdsCode;
	stockVO.ntslType = ntslType;
	
	// 서버전송
	$.ajax({
		url : "/cnpt/gds/updateAmtAjax",
		type : "POST",
		data : JSON.stringify({
			stockVO : stockVO,
			gdsAmtVO : gdsAmtVO				
		}),
		contentType : "application/json; charset=utf-8;",
		beforeSend : function(xhr){
			// csrf 헤더와 토큰 설정
			xhr.setRequestHeader(csrfHeader, csrfToken);
		},
		success : function(res){
			// 차트 업데이트
			if(myChart) {
				myChart.data.labels.push(newMonth);
				myChart.data.datasets[0].data.push(amt);
				myChart.update();
			}
			
			 // 테이블 업데이트
            let newRow = `
		                <tr class="frcsChkDtl">
		                    <td class="center" style="width: 20%">새로운 순번</td>
		                    <td class="center" style="width: 50%">${newMonth}</td>
		                    <td class="center" style="width: 30%">${amt.toLocaleString()} 원</td>
		                </tr>`;
            
            $("#table-body-amt").prepend(newRow);
            
			setTimeout(function(){
				location.reload();
			}, 1000);
		},
		error : function(xhr, status, error){
			console.error("에러 발생 : ", error);
		}
	// 단가 변경 ajax 끝	
	});
	
// function updateAmtAjax 끝	
}	

/*******************************************
			상품 등록 
********************************************/
function insertGds(){
	// gdsNm, gdsType, unitNm, mbrId, gdsCode
	let gdsVO = {};
	// bzentNo, gdsCode, amt
	let gdsAmtVO = {};
	
	let gdsNm = $("#gdsNm").val();
	let gdsType = $("#gdsType").val();
	let unitNm = $("#unitNm").val();
	let mbrId = $("#mbrId").val();
		
	let amt = $("#amt").val();
	
	gdsVO.gdsNm = gdsNm;
	gdsVO.gdsType = gdsType;
	gdsVO.unitNm = unitNm;
	gdsVO.mbrId = mbrId;
	
	if(amt){
		gdsAmtVO.amt = amt;
	}
	gdsAmtVO.bzentNo = bzentNo;
	
	console.log("gdsVO : ",  gdsVO);
	console.log("gdsAmtVO : ", gdsAmtVO);
	
	// 비동기 ajax 서버전송
	$.ajax({
		url : "/cnpt/gds/registAjax",
		type : "POST",
		data : JSON.stringify({
			// JSON으로 변환
			gdsVO : gdsVO,
			gdsAmtVO : gdsAmtVO
		}),
		contentType : "application/json; charset=utf-8",
		// csrf설정 secuity설정된 경우 필수!!
		beforeSend:function(xhr){ 
			// CSRF 헤더와 토큰을 설정
			xhr.setRequestHeader(csrfHeader, csrfToken); 
		},
		success : function(res){
			console.log("res" , res);
			
			Swal.fire({
					  icon: "success",
					  title: "상품 등록이 완료되었습니다",
					  showConfirmButton: false,
					  timer: 1000
					});
					let gdsCode = res;
					console.log("gdsCode :", gdsCode);
	
					    Swal.fire({
					      title: '상품을 등록하셨군요?',
					      text: "재고 조정페이지로 이동합니다.",
					      icon: 'warning',
					      showCancelButton: true,
					      confirmButtonColor: '#00C157',
					      confirmButtonText: '다음',
					      timer: 5000, // 5초 후에 자동으로 넘어가게 설정
					      timerProgressBar: true, // 타이머 진행 막대 표시
					      
					    }).then((result) => {
					    	if (result.isConfirmed) {
					    	    // Ajax 요청을 통해 gdsCode를 성공적으로 받아온 후 이동
					    	    
					    	    console.log("gdsCode :", gdsCode);
					    	 	setTimeout(function(){
										location.href="/cnpt/stock/insertStockQty?gdsCode="+res;
									}, 1000);
 					 //   	    window.location.href = "/cnpt/stock/insertStockQty?gdsCode=${gdsCode}";
					    	} else if (result.dismiss === Swal.DismissReason.timer) {
					    	    // 타이머에 의해 자동으로 넘어갈 경우에도 지정된 URL로 이동
 					    	    window.location.href = "/cnpt/stock/insertStockQty?gdsCode="+res;
					    	}
					    })
					
		},
		error : function(xhr, status, error){
			console.err("에러 : ", error);
		}
		
	  // ajax 비동기 끝.	
	  });
// function insertGds 끝
}	
 /*******************************************
		단가 최근거 삭제
********************************************/
function deleteLastAmt(){
	// bzentNo, gdsCode
	let gdsAmtVO = {};
	
	gdsAmtVO.bzentNo = bzentNo;
	gdsAmtVO.gdsCode = gdsCode;
	
	// 비동기 ajax 서버 전송
	$.ajax({
		url : "/cnpt/gds/deleteLastAmt",
		type : "POST",
		data : JSON.stringify(gdsAmtVO),
		contentType : "application/json; charset=utf-8",
		// csrf 설정 security설정된 경우 필수
		beforeSend : function(xhr){
			// CSRF 헤더와 토큰을 설정
			xhr.setRequestHeader(csrfHeader, csrfToken);
		},
		success : function(res){
			setTimeout(function(){
				location.reload();
			}, 1000);
		},
		error : function(xhr, status, error){
			console.error("에러 발생 : ", error);
		}
	// ajax 끝	
	});
// deleteLastAmt 함수 끝	
} 

 /*******************************************
		상품 삭제
********************************************/
function deleteGdsAjax(){
	// 서버 전송
	$.ajax({
		url : "/cnpt/gds/deleteAjax",
		type : "POST",
		data : {
				gdsCode : gdsCode,
				bzentNo : bzentNo
				},
		//csrf 설정 security 설정된 경우 필수!
		beforeSend : function(xhr){
			xhr.setRequestHeader(csrfHeader, csrfToken);
		},
		success : function(res){
			if(res>0){
				Swal.fire({
					  title: "완료",
					  text: "상품이 성공적으로 삭제되었습니다",
					  icon: "success"
					}).then((result) => {
					 if (result.isConfirmed) {
						 location.href="/cnpt/gds/list";
						}
					});
			}
		// success 끝	
		},
		 error: function(xhr, status, error) {
            // 참조 무결성 제약 조건 오류 처리
                Swal.fire({
                    title: "참조된 데이터가 있어 삭제할 수 없습니다!",
                    text: "재고 조정 후 다시 시도해주세요.",
                    icon: "error"
                });
        // error 끝    
        }
	// ajax 끝		
	})
// deleteGdsAjax function 끝	
}




