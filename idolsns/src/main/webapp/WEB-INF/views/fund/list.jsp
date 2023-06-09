<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>



<style scoped>
      
   
        /*메인 스타일 - 데스크톱*/
        * {
            box-sizing : border-box;
            
              }
            
              
      
        .funding-list {
            display:flex;
            flex-wrap: wrap;
   
        }
        
    
        
        .funding-list > .funding-item {
            width : 32%;
            transition: width 0.1s ease-out;
        }
      
        /*조건부 스타일 - 태블릿*/
        @media screen and (max-width:1200px) {
    
        .col-6 {
          width: 100%;
        }
            .funding-list > .funding-item  {
            width : 49%;
           }
       }

        /*조건부 스타일 - 모바일*/
        @media screen and (max-width:800px) {
       
            .funding-list > .funding-item  {
            width : 100%;
        }
        
    }
               
         .funding-list {
           display: flex;
           flex-wrap: wrap;
           gap: 10px;
         }
         
         .funding-item {
         
           box-sizing: border-box;
           padding: 10px;
           border: 1px solid #ccc;
           border-radius: 5px;
           
           
         }
         
         
         .funding-item img {
           width: 100%;
           border-radius: 5px;
           
           }
         
         .funding-item .title {
            margin: 10px 0;
            font-size: 1.2em;
            font-weight: bold;
            }
         
         .funding-item .description {
            margin: 10px 0;
            font-size: 0.9em;
            color: #666;
            }
         
         .progress-bar {
            height: 10px;
            background-color: #eee;
            border-radius: 5px;
            overflow: hidden;
            margin: 10px 0;
            }
         
         .progress {
            height: 100%;
            background-color: #2ecc71;
            }
         
         .info {
            display: flex;
            justify-content: space-between;
            }
         
         .info .col {
            text-align: center;
            color: #888;
            }
         
         .info .col .value {
            font-size: 1.2em;
            font-weight: bold;
            }
            
         .info .col .label {
            font-size: 0.9em;
            }
      </style>
      
        <div id="app">
               <div class="custom-container">
			
				
				
					<div class="rounded bg-light p-3" style="width:100%; height:300px;">
						
						<div class="font-bold" style="font-size:30px;">아이돌의 펀딩을 받아봅시다
						</div>
						<button class="custom-btn btn-round btn-purple1" @click="startFunding">프로젝트 올리기</button>
					</div>
				
				
				
					<!-- 펀딩 글 작성 -->
					<div class="d-flex align-items-center mt-4">
					
		             	<!-- 검색창 -->
		               	<div class="search-box w-30" style="width:30%">
		                    <input class="search-input" type="text" v-model="searchQuery" placeholder="검색창" @keyup.enter="searchFunding">
		                </div>
		                
		                	<!-- 정렬 -->
						<button v-if="dateSort" class="btn-purple1 ms-1" @click="sortByDate">최신순</button>
<<<<<<< HEAD
						<button v-else class="btn-purple1 ms-1" @click="sortByDate">오랜된순</button>
					
		                
=======
						<button v-else class="btn-purple1 ms-1" @click="sortByDate">오래된순</button>
					</div>
	             	<!-- 검색창 -->
	               	<div class="search-box w-35 ms-auto me-4">
	                    <input class="search-input" type="text" v-model="searchQuery" @keyup.enter="fetchOrderedFundingList">
>>>>>>> refs/remotes/origin/main
	                </div>
               
               	
               	<!-- 펀딩 리스트 -->
                 <div class="funding-list justify-content-center mt-4">
                 
                   <div class="funding-item" v-for="(funding, index) in fundings" :key="index"
                                              v-on:click="link(funding)">
                     <img :src="getImageUrl(funding)" alt="Funding Image" style="height:200px">
                     <h3 class="title">{{ funding.fundTitle }}</h3>
                     <p class="description">{{ funding.fundShortTitle }}</p>
                     <div class="progress-bar">
                       	<div class="progress" :style="{ width: (funding.totalPrice / funding.fundGoal * 100).toFixed(1) + '%' }"></div>
                     </div>
                     <div class="info">
	                       <div>
		                     <span style="font-weight:bold">
		                     {{ (funding.totalPrice / funding.fundGoal * 100).toFixed(1) }}
		                     </span>%
	                         <span class="fund_span">{{ formatCurrency(funding.totalPrice) }}</span>원
	                       </div>
	                       <div>
	                         <span class="value">{{ getTimeDiff(funding) }}</span>
	                       </div>
                     </div>
                   </div>
                   
                 </div>
               </div>
               
            </div>   
                 
      <script src="https://unpkg.com/vue@3.2.36"></script>
       <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
       
      <script>
       Vue.createApp({
               //데이터 설정 영역
               data(){
                  return{
                  // 목록을 위한 데이터
                    percent: 0,
                    page: 1,
                    searchPage: 1,
                    finish: false,
                 	fundings: [],
                	initFundings: false,
                 // 무한스크롤 안전장치
                	loading: false,
                 // 검색 키워드
                	searchQuery: "",
                	searchQueryTemp: "",
                	
                	// 정렬
                	orderList: ["post_time desc"],
                	
                	// 시간순 정렬 버튼
                	dateSort: false,
                	 
                  };
                  },
               computed: {
                  currentDate() {
                     return new Date().toISOString().split('T')[0];
                  }
                  
               },
               methods: {
            	   
            	   // # 펀딩 리스트 불러오기
                   async fetchFundingList() {
                 	  
		                  // funding 리스트 초기화
// 		                  if(!this.initFundings || this.searchQueryTemp != this.searchQuery) {
// 		                     this.fundings = [];
// 		                     this.initFundings = true; 
// 		                     this.finish = false; // 검색어가 다르면 초기화
// 		                  }
	                      // 다 불러왔으면
// 	                      if(this.finish == true) return; 
		                  
		                  // 다른 검색어로 검색했을때
// 		                  if(this.searchQueryTemp != this.searchQuery) {
// 		                     this.searchPage = 1;
// 		                  }
		                  
		                  // searchQueryTemp에 이전 검색어 저장
// 		                  this.searchQueryTemp = this.searchQuery;
		                       
		                  const resp = await axios.get("http://localhost:8080/rest/fund/page/"+this.searchPage,
		                        {
		                	  params: {
		                		  	// 검색어
		                        	searchKeyword : this.searchQuery,
		                        	// 정렬 조건
		                        	orderList : this.orderList
		                        },
		                        paramsSerializer: params => {
		                    		return new URLSearchParams(params).toString();
		                    	}
		                        });     
		                  this.fundings.push(...resp.data);
		                  this.searchPage++;
		                  
		                  // 데이터가 12개 미만이면 더 읽을게 없다
		                       if(resp.data.length < 12){
		                           this.finish = true;
		                          }
                   },
                   
                   async fetchOrderedFundingList(){
                	   	  this.searchPage=1;
                	   	  
		                  const resp = await axios.get("http://localhost:8080/rest/fund/page/"+this.searchPage,
		                        {
		                	  params: {
		                		  	// 검색어
		                        	searchKeyword : this.searchQuery,
		                        	// 정렬 조건
		                        	orderList : this.orderList
		                        },
		                        paramsSerializer: params => {
		                    		return new URLSearchParams(params).toString();
		                    	}
		                        });
// 		                  console.log(resp.data)
		                  this.fundings = [...resp.data];
		                  this.searchPage++;
		                  
		                  // 데이터가 12개 미만이면 더 읽을게 없다
		                       if(resp.data.length < 12){
		                           this.finish = true;
		                          }
                   },
                    
                    // 남은 시간 설정
                    getTimeDiff(funding) {
                          const startDate = new Date(funding.postStart);
                          const endDate = new Date(funding.postEnd);
                          console.log(startDate);
                          console.log(endDate);
                          const currentDate = new Date();
                          const fundState = funding.fundState;
                          const timeDiff = endDate.getTime() - startDate.getTime();
                          
                          // 마간기간이 남은 경우
                          if(timeDiff >= 0){
	                          // 1일 이상인 경우
	                          if (timeDiff >= 24 * 60 * 60 * 1000) {
	                            return Math.ceil(timeDiff / (24 * 60 * 60 * 1000))+"일 남음";
	                          } 
	                          // 당일인 경우
	                          else {
	                              return "오늘 마감";
	                          }
                          }
                          // 이미 마감된 경우
                          else {
                        	  return fundState;
                          }
                    },
                    
                    // 상세페이지로 이동
                    link(funding){
                       window.location.href = "/fund/detail?postNo="+funding.postNo;;
                    },
                    getImageUrl(funding) {
                     const imageUrl = "/rest/attachment/download/" + funding.attachmentNo;
                       return imageUrl;
                       },
                       
                    // 3자리 마다 ,
                     formatCurrency(value) {
                        return value.toLocaleString();
                      },
                      
                      // 펀딩 글쓰기로 이동
                      startFunding() {
                    	  window.location.href = "/fund/write";
                      },
                      
                      // 시간순 정렬
                      sortByDate() {
                    	  const descOrder = "post_time desc";
                    	    const ascOrder = "post_time asc";

                    	    // 최신순
                    	    if (this.dateSort) {
                    	        this.dateSort = false;
                    	        if (!this.orderList.includes(descOrder)) {
                    	            this.orderList = [descOrder];
//                     	            this.fetchFundingList();
                    	        }
                    	    }
                    	    // 오래된순
                    	    else {
                    	        this.dateSort = true;
                    	        if (!this.orderList.includes(ascOrder)) {
                    	            this.orderList = [ascOrder];
//                     	            this.fetchFundingList();
                    	        }
                    	    }
                    	    console.log(this.orderList);
                    	    console.log(this.fundings);
                      }
                 },
                 watch: {
                   // percent가 변하면 percent의 값을 읽어와서 80% 이상인지 판정
                   percent(){
                       if(this.percent >= 80) {
                           // console.log("데이터를 불러올 때가 된거 같아");
//                            this.loadFundPostImageList();
                           this.fetchFundingList();
                       }
                   },
                   // 정렬하면
                   orderList() {
//                 	   this.fetchFundingList();
						this.fetchOrderedFundingList();
                   }
               },
               mounted() {
                  window.addEventListener("scroll", _.throttle(()=>{
                       // - 현재 스크롤의 위치(window.scrollY)
                       // - 브라우저의 높이(window.innerHeight)
                       // - ScreenFull.js나 Rallax.js 등 라이브러리 사용 가능
                       const height = document.body.clientHeight - window.innerHeight;
                       const current = window.scrollY;
                       const percent = (current/ height) * 100;
                       // console.log("percentage = " + Math.round(percent)+"%");

                       // data의 percent를 계산된 값으로 갱신
                       this.percent = Math.round(percent);
                   },100));
               },
                 created() {
//                     this.loadFundPostImageList();
                    this.fetchFundingList();
                 }
           }).mount("#app");


      </script>

      
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
