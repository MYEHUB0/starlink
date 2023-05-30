<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div id="search-body">
  <!-- 검색단어 -->
  <div class="row">
    <div class="col">
        <h1>검색단어: ${query}</h1>
    </div>
  </div>

  <!-- # 대표페이지 검색결과 -->
  <div class="row mt-5">
    <div class="col">
      <h1>대표페이지 검색결과</h1>
    </div>
  </div>
  <div class="row mt-3">
    <div class="col">
      <table class="table">
        <thead>
          <tr>
            <th scope="col">대표이미지</th>
            <th scope="col">대표페이지 이름</th>
            <th scope="col">팔로우수</th>
            <th scope="col">팔로우하기</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(artistSearch, i) in artistSearchList" :key="i">
            <td>
              <!-- {{artistSearch.attachmentNo ?? "없슈"}} -->
              <img :src="artistSearch.attachmentNo === 0 ? '/static/image/profileDummy.png' : '/download/?attachmentNo=' + artistSearch.attachmentNo" style="width: 100px; height: 100px;">
            </td>
            <td><a :href="'/artist/'+artistSearch.artistEngNameLower">{{fullName(artistSearch.artistName, artistSearch.artistEngName)}}</a></td>
            <td>{{artistSearch.followCnt}}</td>
            <td>
              <button class="btn rounded-pill" :class="{'btn-primary':!artistSearch.isFollowPage, 'btn-secondary': artistSearch.isFollowPage}"  v-text="artistSearch.isFollowPage?'팔로우취소':'팔로우하기'" @click="followPage(artistSearch)">팔로우하기</button>
            </td>
          </tr>
          <tr v-if="artistSearchList.length === 0">
            <td colspan="4">
              <h3 class="my-3">검색 결과가 없습니다</h3>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- 회원 -->
  <!-- # 회원 검색결과 -->
  <div class="row mt-5">
    <div class="col">
      <h1>회원 검색결과</h1>
    </div>
  </div>
  <div class="row mt-3">
    <div class="col">
      <table class="table">
        <thead>
          <tr>
            <th scope="col">대표이미지</th>
            <th scope="col">회원 아이디</th>
            <th scope="col">팔로우하기</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(memberSearch, i) in memberSearchList" :key="i">
            <!-- <td>{{memberSearch.attachmentNo ?? "없슈"}}</td> -->
            <td>
              <img :src="memberSearch.attachmentNo === 0 ? '/static/image/profileDummy.png' : '/download/?attachmentNo=' + memberSearch.attachmentNo" style="height: 100px; width: 100px;">
            </td>
            <td><a :href="'/artist/'+memberSearch.memberId">{{fullName(memberSearch.memberId, memberSearch.memberNick)}}</a></td>
            <td>
              <button class="btn rounded-pill" :class="{'btn-primary':!memberSearch.isFollowMember, 'btn-secondary': memberSearch.isFollowMember}"  v-text="memberSearch.isFollowMember?'팔로우취소':'팔로우하기'" @click="followMember(memberSearch)">팔로우하기</button>
            </td>
          </tr>
          <tr v-if="memberSearchList.length === 0">
            <td colspan="3">
              <h3 class="my-3">검색 결과가 없습니다</h3>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>


<script>
    Vue.createApp({
      data() {
        return {
          // 로그인 회원 팔로우 목록 조회
          memberFollowObj: {
            memberId: "",
            followMemberList: [],
            followPageList: [],
          },
          // 대표페이지 검색목록
          artistSearchList: [],
          // 회원 검색목록
          memberSearchList: [],
          search: true,



          followObj: {
            memberId: memberId,
            followTargetType: "",
            followTargetPrimaryKey: "",
          },
        };
      },
      computed: {
        
      },
      methods: {

        // 로그인 회원 팔로우 정보 로드
        async loadMemberFollowInfo(){
          // 로그인X → 실행 X
          if(memberId==="") return;
          // url
          const url = "http://localhost:8080/rest/follow/memberFollowInfo/"
          // 팔로우 목록 load
          const resp = await axios.get(url, {params:{memberId: memberId}});

          // 로그인 팔로우 정보 로드
          this.memberFollowObj = resp.data;

        },


        // (search) 대표페이지 검색목록 조회
        async loadArtistSearchList(){
          // q
          const params = new URLSearchParams(window.location.search);
          const q = params.get("q")

          // url
          const url = "http://localhost:8080/rest/artist/search";

          // 조회
          const resp = await axios.get(url, { params: {q: q}});

          this.artistSearchList = resp.data;

          // 팔로우 여부 저장
          for(let i = 0; i<this.artistSearchList.length; i++){
            const artistName = this.artistSearchList[i].artistEngNameLower;
            this.artistSearchList[i].isFollowPage = this.memberFollowObj.followPageList.includes(artistName);
          }
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
        async followPage(artistSearch){
            // 1. 회원 로그인 확인
            if(memberId === ""){
                if(confirm("로그인 한 회원만 사용할 수 있는 기능입니다. 로그인 하시겠습니까?")) {
                    window.location.href = contextPath + "/member/login";
                }
            }

            // artistEngNameLower
            // 2. toggle 팔로우 삭제, 팔로우 생성
            const isFollowingArtist = artistSearch.isFollowPage;
            if(isFollowingArtist){
                if(!confirm(this.fullName(artistSearch.artistName, artistSearch.artistEngName) + "님 팔로우를 취소하시겠습니까?")) return;
                this.setFollowPageObj(artistSearch.artistEngNameLower);
                await this.deleteFollow();
            } else {
                this.setFollowPageObj(artistSearch.artistEngNameLower);
                await this.createFollow();
            }

            await this.loadMemberFollowInfo();
            this.loadArtistSearchList();
        },
        // 회원 팔로우 버튼
        async followMember(memberSearch){
            // 1. 회원 로그인 확인
            if(memberId === ""){
                if(confirm("로그인 한 회원만 사용할 수 있는 기능입니다. 로그인 하시겠습니까?")) {
                    window.location.href = contextPath + "/member/login";
                }
            }

            // artistEngNameLower
            // 2. toggle 팔로우 삭제, 팔로우 생성
            const isFollowingMember = memberSearch.isFollowMember;
            if(isFollowingMember){
                if(!confirm(this.fullName(memberSearch.memberId, memberSearch.memberNick) + "님 팔로우를 취소하시겠습니까?")) return;
                this.setFollowMemberObj(memberSearch.memberId);
                await this.deleteFollow();
            } else {
                this.setFollowMemberObj(memberSearch.memberId);
                await this.createFollow();
            }

            await this.loadMemberFollowInfo();
            this.loadMemberSearchList();
        },

        // 대표페이지 팔로우 대상 설정
        setFollowPageObj (artistName){
            // 팔로우 대상 유형
            this.followObj.followTargetType = "대표페이지";
            // 팔로우 대상 PK
            this.followObj.followTargetPrimaryKey = artistName;
        },
        // 회원 팔로우 대상 설정
        setFollowMemberObj (followMemberId){
            // 팔로우 대상 유형
            this.followObj.followTargetType = "회원";
            // 팔로우 대상 PK
            this.followObj.followTargetPrimaryKey = followMemberId;
        },
        // 회원 팔로우 대상 설정
        setFollowMemberObj (followMemberId){
            // 팔로우 대상 유형
            this.followObj.followTargetType = "회원";
            // 팔로우 대상 PK
            this.followObj.followTargetPrimaryKey = followMemberId;
        },

        // 대표페이지 팔로우 생성
        async createFollow(){
            // 팔로우 생성 url
            const url = "http://localhost:8080/rest/follow/";
            await axios.post(url, this.followObj);
            // [develope] 
            console.log(this.followObj.memberId + "님의 " + this.followObj.followTargetPrimaryKey + "님 팔로우 생성");
        },
        // 대표페이지 팔로우 취소
        async deleteFollow(){
            // 팔로우 생성 url
            const url = "http://localhost:8080/rest/follow/";
            await axios.delete(url, {
                data: this.followObj,
            });
            // [develope]
            console.log(this.followObj.memberId + "님의 " + this.followObj.followTargetPrimaryKey + "님 팔로우 제거");
        },


        // (search) 회원 검색목록 조회
        async loadMemberSearchList(){
          // q
          const params = new URLSearchParams(window.location.search);
          const q = params.get("q")

          // url
          const url = "http://localhost:8080/rest/search/member";
          // 조회
          const resp = await axios.get(url, { params: {memberId: q}});
        
          // 데이터 반영
          this.memberSearchList = resp.data;


          // 회원팔로우 여부 저장
          for(let i = 0; i<this.memberSearchList.length; i++){
            const followMemberId = this.memberSearchList[i].memberId;
            console.log(this.memberFollowObj.followMemberList.includes(followMemberId));
            this.memberSearchList[i].isFollowMember = this.memberFollowObj.followMemberList.includes(followMemberId);
          }
          // console.log(resp.data);
        },




        fullName(name, engName){
          return name + "(" + engName + ")";
        }

      },
      watch: {
  
      },
      async created(){
        // 1. 로그인 회원 팔로우 정보 로드
        await this.loadMemberFollowInfo();
        // (search) 대표페이지 검색목록 조회
        this.loadArtistSearchList();
        // (search) 회원 검색목록 조회
        this.loadMemberSearchList();
      },
    }).mount('#search-body')
</script>



<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>


	
