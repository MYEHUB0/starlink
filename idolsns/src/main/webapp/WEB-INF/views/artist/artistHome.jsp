<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>


<!-- 카카오 api 키 등록 -->
	<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=047888df39ba653ff171c5d03dc23d6a&libraries=services"></script>
	<!-- 맵 관련 css -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/map.css">
	<!------- 카카오 지도 관련-------->



<!-- develope-css -->
<style>
   @media screen and (max-width:992px) {
		  	.col-6 {
		    width: 100%; 
		  }
    	}
		 
			   	

    .develope-back-forestgreen {
        background: forestgreen;
        min-height: 300px;
    }
    .develope-back-aqua {
        background: aquamarine;
        min-height: 300px;
    }
    .mh-300{
        min-height: 300px;
    }
    .artist-profile-img {
        width: 130px;
        height: 130px;
    }

	
	.arti_name {
		font-weight: bold;
		font-size: 30px;
	}

	.arti_title {
		font-weight: bold;
		font-size: 20px;
	}


</style>

<!-- 제어영역 설정 -->
<div id="app">
	<div class="custom-container">
	    <!-- # 대표페이지 프로필 -->
	    <div class="my-5 mx-5 d-flex">
	        <!-- 대표페이지 프로필 사진 -->
	        <div class="my-auto" >
	            <div class="border artist-profile-img rounded-circle overflow-hidden">
	                <!-- <img src="https://via.placeholder.com/200x200?text=LOGO"> -->
	                <img :src="artistObj.attachmentNo==null?'https://via.placeholder.com/150x150?text=LOGO':'/download?attachmentNo='+artistObj.attachmentNo">
	            </div>
	        </div>
	
	        <!-- 대표페이지 이름 및 팔로워 -->
	        <div class="col container my-auto" style="text-align:left; padding-left:2em;" >
	            <!-- 대표페이지 이름 -->
	            <div class="row arti_name">
	                    {{fullName}}
	            </div>
	            <!-- 대표페이지 팔로워 -->
	            <div class="row">
	             	   팔로워 {{artistObj.followCnt ?? 0}}명
	            </div>
	        </div>
	
	        <!-- 버튼(팔로우하기, 글쓰기) -->
	        <div class="col container my-auto">
	            <div class="row mb-2 justify-content-end" >
	                <button class="custom-btn btn-round" style="width:150px;" 
	                :class="{'btn-purple1':!isFollowingArtist, 'btn-purple1-secondary': isFollowingArtist}"  v-text="isFollowingArtist?'팔로우취소':'팔로우하기'" @click="followPage">팔로우하기</button>
	                <!-- <button  :class="{'btn-primary':!isFollowMemberList[i], 'btn-secondary': isFollowMemberList[i]}" v-text="isFollowMemberList[i]?'팔로우취소':'팔로우하기'" @click="followMember(member.memberId, i)"></button> -->
	            </div>
	            <div class="row justify-content-end">
	                <button class="custom-btn btn-round btn-gray" style="width:150px;">글쓰기</button>
	            </div>
	        </div>
	    </div>
	
	
	    <hr class="m-0">
	
	
	    <!-- # 지도 -->
	    <div class="row px-5 pt-5 mb-4">
	        <!-- [Component] 지도 -->
	        <div class="col border custom-container mh-300 me-3 p-4">
	            <div class="arti_title">📍지도</div>

				<div id="mapShow" style="width: 100%; height: 300px;"></div>	             
				      
		      	
	        </div>
	        <!-- [Component] 성지순례 목록글 -->
	        <div class="col border custom-container mh-300 p-4">
	            <div class="row">
	                <div class="col">
	                    <div class="arti_title">✨성지순례</div>
	                </div>
	            </div>
	            <div class="row">
	                <div class="col container pt-3 px-4">
	                 	<div v-for="post in postShowDto" :key="post.tagName">
						    <template v-if="post.mapPlace !== null">
						    	<div @click="showMap(post.mapPlace)" data-bs-target="#showMap" data-bs-toggle="modal">
						        <i class="fa-solid fa-location-dot me-1"></i>{{ post.mapName }}
						        </div>
						    </template>
						</div>
		            </div>
		        </div>
		    </div>
		   </div>
		
	    <!-- # 같이가요, 펀딩 -->
	    <div class="row px-5">
	        <!-- [Component] 같이가요 -->
	        <div class="col border custom-container mh-300 me-3 p-4">
	            <div class="row">
	                <div class="col">
	                    <div class="arti_title">👭같이가요</div>
	                </div>
	            </div>
	            <div class="row">
	                <div class="col container pt-3 px-4">
	                    <div v-for="post in postShowDto" :key="post.tagName">
						    <template v-if="post.postType == '같이가요'">
						    	{{ post.postContent }}
						    </template>
						</div>
	                </div>
	            </div>
	        </div>
	        <!-- [Component] 펀딩 -->
	        <div class="col border custom-container mh-300 p-4">
	            <div class="row">
	                <div class="col">
	                    <div class="arti_title">📢후원하기</div>
	                    <!-- 🎉📣📣 -->
	                </div>
	            </div>
	            <div class="row">
	             <div class="col container pt-3 px-4">
	            <div v-for="post in postShowDto" :key="post.tagName">
						    <template v-if="post.fundTitle !== null">
                			<a :href="`${pageContext.request.contextPath}/fund/detail?postNo=${post.postNo}`">
						        {{ post.fundTitle }}
						    </a>
						    </template>
						</div>
	            
	               
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</div>







<!-- 뷰 스크립트 작성 -->
<script>
    Vue.createApp({
      data() {
        return {
        	
        	post: {
        		postNo:"",
        		tagName:"",
        		mapPlace:"",
        		fundTitle:"",
        		mapName:""
        	},
        	postShowDto: {},
        	
        	
            artistObj: {},
            followPageObj: {
                memberId: memberId,
                followTargetType: "",
                followTargetPrimaryKey: "",
            },


            memberFollowObj: {},
            isFollowingArtist: false,
            
            };
      },
      computed: {
        fullName(){
            return this.artistObj.artistName + "(" + this.artistObj.artistEngName + ")";
        },
      },
      methods: {
    	  
    	
	        
	        
	        
        // # 사전 로드(대표페이지 정보, 로그인회원 팔로우 정보)
        // 1. 대표페이지(아티스트) 정보 조회
        async loadArtist(){
            // 대표페이지 이름
            const artistEngNameLower = window.location.pathname.split("/").at(-1);
			// url
            const url = "http://localhost:8080/rest/artist/";
			// 조회
            const resp = await axios.get(url, { params: { artistEngNameLower: artistEngNameLower } });
			// 조회 결과 없을 시 
			if(resp.data)
			this.artistObj = resp.data;
			
			this.loadTags();
        
            // 지도 데이터 가져오기
            const mapResp = await axios.get(url);
            this.mapData = mapResp.data;
	        
	        },
        // 2.로그인 회원 팔로우 정보 로드
        async loadMemberFollowInfo(){
            // 로그인X → 실행 X
            if(memberId==="") return;

            const url = "http://localhost:8080/rest/follow/memberFollowInfo/"

            const resp = await axios.get(url, {params:{memberId: memberId}});

            // 로그인 팔로우 정보 로드
            this.memberFollowObj = resp.data;
            // 팔로우 버튼 동기화
            this.isFollowingArtist = this.checkFollow();
        },


        // 대표페이지 팔로우확인
        checkFollow(){
            // 로그인 안했으면 return false
            if(memberId === "") return false;
            
            // 팔로우 대표페이지 목록
            const followPageList = this.memberFollowObj.followPageList;

            if(this.memberFollowObj.followPageList!==undefined){
                if(followPageList===null) {
                    return false;
                } else {
                    const isFollowing = followPageList.includes(this.artistObj.artistEngNameLower);
                    return isFollowing;
                }
            }
        },




        // 페이지 팔로우 버튼
        async followPage(){
            // 1. 회원 로그인 확인
            if(memberId === ""){
                if(confirm("로그인 한 회원만 사용할 수 있는 기능입니다. 로그인 하시겠습니까?")) {
                    window.location.href = contextPath + "/member/login";
                }
            }

            // 2. toggle 팔로우 삭제, 팔로우 생성
            if(this.isFollowingArtist){
                if(!confirm(this.fullName + "님 팔로우를 취소하시겠습니까?")) return;
                this.setFollowPageObj();
                await this.deleteFollow();
            } else {
                this.setFollowPageObj();
                await this.createFollowPage();
            }

            this.loadArtist();
            this.loadMemberFollowInfo();
        },




        // 대표페이지 팔로우 생성
        async createFollowPage(){
            // 팔로우 생성 url
            const url = "http://localhost:8080/rest/follow/";
            await axios.post(url, this.followPageObj);
            // [develope] 
            console.log(this.followPageObj.memberId + "님의 " + this.followPageObj.followTargetPrimaryKey + "님 팔로우 생성");
        },
        // 대표페이지 팔로우 취소
        async deleteFollow(){
            // 팔로우 생성 url
            const url = "http://localhost:8080/rest/follow/";
            await axios.delete(url, {
                data: this.followPageObj,
            });
            // [develope]
            console.log(this.followPageObj.memberId + "님의 " + this.followPageObj.followTargetPrimaryKey + "님 팔로우 제거");
        },
        // 팔로우 토글
        async toggleFollow(){
            // 1. 회원 로그인 확인
            if(memberId === ""){
                if(confirm("로그인 한 회원만 사용할 수 있는 기능입니다. 로그인 하시겠습니까?")) {
                    window.location.href = contextPath + "/member/login";
                }
            }
            // 팔로우 확인 url
            console.log(this.checkFollow()); 
        },
        


        // 대표페이지 팔로우 대상 설정
        setFollowPageObj (){
            // 아티스트 이름
            const artistName = window.location.pathname.split("/").at(-1);
            // 팔로우 대상 유형
            this.followPageObj.followTargetType = "대표페이지";
            // 팔로우 대상 PK
            this.followPageObj.followTargetPrimaryKey = artistName;
        },


        
        
        /////
        
    	//고정태그 찾기
    	async loadTags() {
			  const tagName = this.artistObj.artistName;
			  console.log("태그:" + tagName);
			  const url = "/rest/post/" + tagName;
			
			  const resp = await axios.get(url);
			  console.log("내놔:" + resp.data);
			  this.postShowDto = resp.data;
			
			},

    		
    	// 모달창 클릭 시 지도 정보 불러오기-------------------------
      	showMap(keyword){
      		this.showMapModalText = keyword;
      		// 마커를 담을 배열입니다
      		var markers = [];

      		// 지도 정보를 담을 변수
      		let mapPlace = "기본";

      		var mapContainer = document.getElementById('mapShow'), // 지도를 표시할 div 
      		    mapOption = {
      		        center: new kakao.maps.LatLng(37.606826, 126.8956567), // 지도의 중심좌표
      		        level: 8 // 지도의 확대 레벨
      		    };  

      		// 지도를 생성합니다    
      		var map = new kakao.maps.Map(mapContainer, mapOption); 

      		// 장소 검색 객체를 생성합니다
      		var ps = new kakao.maps.services.Places();  
	
      		// 키워드 검색 완료 시 호출되는 콜백함수 입니다
      		function showMapPlacesSearchCB (data, status, pagination) {
      		    if (status === kakao.maps.services.Status.OK) {

      		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
      		        // LatLngBounds 객체에 좌표를 추가합니다
      		        var bounds = new kakao.maps.LatLngBounds();

      		        for (var i=0; i<data.length; i++) {
      		            displayMarker(data[i]);    
      		            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
      		        }       

      		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
      		        map.setBounds(bounds);
      		    } 
      		}            		
      		
      		ps.keywordSearch(keyword,showMapPlacesSearchCB);
      		
      		// 지도에 마커를 표시하는 함수입니다
      		function displayMarker(place) {
      		    
      		    // 마커를 생성하고 지도에 표시합니다
      		    var marker = new kakao.maps.Marker({
      		        map: map,
      		        position: new kakao.maps.LatLng(place.y, place.x) 
      		    });

      		    // 마커에 클릭이벤트를 등록합니다
      		    kakao.maps.event.addListener(marker, 'click', function() {
      		        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
      		        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
      		        infowindow.open(map, marker);
      		    });
      		}
      	},
    	  
	        
        

  
      },
      created(){
    	  
    	  

    	// 카카오맵 API 로드
    	  const script = document.createElement('script');
    	  script.type = 'text/javascript';
    	  script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=047888df39ba653ff171c5d03dc23d6a&autoload=false';
    	  script.onload = () => {
    	    kakao.maps.load(() => {
    	      this.loadArtist();
    	      this.loadMemberFollowInfo();
    	    });
    	  };

    	  document.head.appendChild(script);

    	  
    	  
        // 페이지 로드
        // 1. 아티스트 정보 로드
        this.loadArtist();
        // 2. 로그인 한 사람 팔로우 정보 로드
        this.loadMemberFollowInfo();


        // this.followBtn();
        
        
        ///////
        //this.loadTags();
        //this.loadPosts();
  	  


      },
    }).mount('#app')
</script>





<%-- <jsp:include page="/WEB-INF/views/artist/artistFooter.jsp"></jsp:include> --%>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>