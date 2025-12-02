# Figures Interpretation Guide
## 그래프 해석 가이드

이 문서는 프로젝트에서 생성된 모든 시각화 자료의 해석 방법을 설명합니다.

---

## 📊 Overview 플롯 (전체 기간: 1790-2015)

### 1. `overview_frame_shares_smoothed.png`
**제목**: Frame Shares in SOTU Speeches Over Time (1790-2015)

**해석 방법**:
- **Y축**: 각 프레임이 차지하는 연설의 비율 (0-100%)
- **X축**: 연도 (1790-2015)
- **각 선**: 5개 프레임 (economy, security, welfare, governance, values)의 smoothed 추세선

**주요 발견**:
- **Security 프레임**: 주요 전쟁 시기(Civil War, WWI, WWII, 9/11)에 급증
- **Welfare 프레임**: 20세기 중반부터 등장, 주로 현대에 집중
- **Governance 프레임**: 초기 공화국 시기에 가장 높음
- **Economy 프레임**: 현대(1980년대 이후)에 증가

**해석 예시**:
> "Over 200+ years, security frames spike during major wars; welfare frames are mostly a 20th-century phenomenon."

---

### 2. `overview_frame_shares_stacked.png`
**제목**: Frame Distribution Over Time (1790-2015)

**해석 방법**:
- **Stacked area chart**: 각 연도에서 모든 프레임의 비율이 합쳐져 100%를 이룸
- **색상 영역**: 각 프레임이 차지하는 비율
- **세로축**: 누적 비율 (0-100%)

**해석 예시**:
> "Governance frames dominated early periods, while security and economy frames became more prominent in modern times."

---

## 📈 Focused Era 분석 (1945-2015: Post-WWII)

### 3. `focused_era_by_party.png`
**제목**: Frame Distribution by Party: Post-WWII Era (1945-2015)

**해석 방법**:
- **Bar chart**: 정당별 프레임 분포 비교
- **파란색 바**: Democratic
- **빨간색 바**: Republican
- **X축**: 5개 프레임 카테고리
- **Y축**: 각 프레임의 비율

**주요 발견**:
- **Republican**: Governance 프레임이 가장 높음 (약 80%)
- **Democratic**: 더 다양한 프레임 사용 (Economy, Welfare도 상당 비율)

**해석 예시**:
> "In the post-WWII era, Republicans consistently emphasize governance frames, while Democrats show more diverse framing strategies."

---

### 4. `focused_era_timeseries.png`
**제목**: Economy and Security Frames by Party (1945-2015)

**해석 방법**:
- **4개의 선**: 
  - **파란색 실선**: Democratic - Economy
  - **파란색 점선**: Democratic - Security
  - **빨간색 실선**: Republican - Economy
  - **빨간색 점선**: Republican - Security
- **Y축**: 각 프레임의 비율 (0-100%)
- **X축**: 연도 (1945-2015)

**⚠️ 중요 해석**:
이 그래프는 **각 정당의 연설 중에서** Economy 또는 Security 프레임이 차지하는 비율을 보여줍니다.

**예시 해석**:
- **Republican - Economy (빨간색 실선)**: 1945-2015 기간 동안 Republican 연설의 대부분이 Economy 프레임
- **Democratic - Security (파란색 점선)**: 1960년대 이후 Security 프레임이 증가, 2000년대에 다시 증가

**주의사항**:
- 각 연도에 1개 연설만 있는 경우가 많아서 개별 점은 0% 또는 100%로 나타날 수 있음
- **Smoothed line (추세선)에 집중**하여 전체 패턴을 파악해야 함

---

## 🎯 Case Study 대통령 비교

### 5. `case_study_lbj_reagan.png`
**제목**: Case Study: LBJ vs Reagan

**해석 방법**:
- **Stacked bar chart**: 각 대통령의 프레임 분포
- **색상**: 각 프레임 카테고리
- **Y축**: 비율 (0-100%)

**주요 발견**:
- **LBJ**: Welfare 프레임이 높음 (Great Society 프로그램)
- **Reagan**: Economy와 Values 프레임이 높음

**해석 예시**:
> "LBJ's speeches emphasized welfare frames (reflecting Great Society programs), while Reagan focused on economy and values."

---

### 6. `case_study_bush_obama.png`
**제목**: Case Study: G.W. Bush vs Obama

**해석 방법**:
- **Stacked bar chart**: 각 대통령의 프레임 분포
- **색상**: 각 프레임 카테고리

**주요 발견**:
- **G.W. Bush**: Security 프레임이 높음 (9/11 이후)
- **Obama**: Economy 프레임이 높음 (2008 금융위기 이후)

**해석 예시**:
> "G.W. Bush's speeches were dominated by security frames (post-9/11), while Obama's speeches emphasized economy frames (post-2008 financial crisis)."

---

## 📊 기존 그래프들

### 7. `economy_frame_by_party.png`
**제목**: Economy Frame in SOTU Speeches by Party

**⚠️ 해석 주의사항**:
이 그래프는 **각 정당의 연설 중에서 Economy 프레임이 차지하는 비율**을 보여줍니다.

**해석 방법**:
- **파란색 선**: Democratic 연설 중 Economy 프레임 비율
- **빨간색 선**: Republican 연설 중 Economy 프레임 비율
- **Y축**: 비율 (0-100%)
- **개별 점**: 각 연도의 실제 데이터 (대부분 0% 또는 100%)
- **Smoothed line**: 전체 추세 (이것에 집중!)

**중요한 점**:
- 각 연도에 1개 연설만 있는 경우가 많아서:
  - 그 연설이 Economy 프레임이면 → 100%
  - 그 연설이 다른 프레임이면 → 0%
- 따라서 **개별 점은 무시하고 smoothed line에 집중**해야 합니다.

**예시 해석**:
- 1960-1980년대: Democratic의 Economy 프레임 비율이 감소 (다른 프레임 사용 증가)
- 1980년대 이후: Democratic의 Economy 프레임 비율이 다시 증가
- Republican: 전체 기간 동안 Economy 프레임이 높게 유지

---

### 8. `security_vs_economy_over_time.png`
**제목**: Security vs Economy Frames Over Time

**해석 방법**:
- **빨간색 선**: Security 프레임 비율
- **파란색 선**: Economy 프레임 비율
- **Y축**: 전체 연설 중 해당 프레임 비율

**주요 발견**:
- 전쟁 시기: Security 프레임 급증
- 현대: Economy 프레임 증가

---

### 9. `frame_distribution_by_party.png`
**제목**: Frame Distribution by Party

**해석 방법**:
- **Bar chart**: 정당별 프레임 분포
- **파란색**: Democratic
- **빨간색**: Republican

**주요 발견**:
- Republican: Governance 중심
- Democratic: 더 다양한 프레임 사용

---

### 10. `frame_heatmap_by_decade.png`
**제목**: Frame Proportion Heatmap by Decade and Party

**해석 방법**:
- **Heatmap**: 10년 단위 프레임 분포
- **색상 진하기**: 비율이 높을수록 진함
- **행**: 프레임 카테고리
- **열**: 10년 단위

**해석 예시**:
> "Early decades show governance dominance, while modern decades show more diverse frame usage."

---

## 💡 일반적인 해석 팁

### 1. Smoothed Line vs Individual Points
- **Individual points (개별 점)**: 각 연도의 실제 데이터 (노이즈 많음)
- **Smoothed line (추세선)**: 전체 패턴 (이것에 집중!)

### 2. 비율의 의미
- **"Economy 프레임 50%"** = 해당 연도/정당의 연설 중 50%가 Economy 프레임
- **주의**: 각 연도에 1개 연설만 있으면 0% 또는 100%만 가능

### 3. 정당 비교
- **같은 프레임에서 정당 차이** = 정당별 강조 차이
- **예**: Democratic가 Welfare 프레임을 더 많이 사용 = 복지 정책 강조

### 4. 시간 추세
- **증가 추세**: 해당 프레임이 시간이 지나면서 더 중요해짐
- **감소 추세**: 해당 프레임이 시간이 지나면서 덜 중요해짐

---

## 📝 Memo/Presentation 활용 예시

### Overview 플롯:
> "Over 200+ years of SOTU speeches, we observe clear temporal patterns: Security frames spike during major wars, while welfare frames are predominantly a 20th-century phenomenon."

### Focused Era:
> "In the post-WWII era (1945-2015), party differences become more pronounced. Republicans consistently emphasize governance frames, while Democrats show more diverse framing strategies."

### Case Studies:
> "Case studies reveal individual presidential styles: LBJ emphasized welfare (Great Society), Reagan focused on economy and values, G.W. Bush prioritized security (post-9/11), and Obama emphasized economy (post-2008 crisis)."

