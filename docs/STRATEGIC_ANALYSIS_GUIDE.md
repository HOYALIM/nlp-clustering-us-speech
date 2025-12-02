# Strategic Analysis Guide
## 새로운 분석 전략 실행 가이드

---

## 📊 새로운 분석 전략

### 1. Overview 플롯 (1790-2015)
- **전체 200+년 데이터**로 각 프레임의 연도별 비율 (smoothed)
- 주요 전쟁 시기 표시 (Civil War, WWI, WWII, 9/11)
- 해석: "Security frames spike during major wars; welfare frames are mostly a 20th-century phenomenon"

### 2. Focused Era 분석 (1945-2015: Post-WWII)
- **비교 가능한 시대**에 집중
- 정당별 프레임 분포 비교
- Economy vs Security 프레임 시간 추세

### 3. Case Study 대통령
- **LBJ vs Reagan**: Welfare/Values 프레임 비교
- **G.W. Bush vs Obama**: Security 프레임 비교

---

## 🚀 실행 방법

### 방법 1: Strategic Analysis만 실행 (권장)

RStudio 또는 R 콘솔에서:

```r
# 프로젝트 디렉토리로 이동
setwd("/Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech")

# Strategic analysis 실행
source("R/09_strategic_analysis.R")
```

또는:

```r
source("RUN_STRATEGIC_ANALYSIS.R")
```

### 방법 2: 전체 파이프라인 실행

```r
source("R/00_run_all.R")
```

(이미 데이터가 처리되어 있다면 Step 1-5는 스킵하고 Step 9만 실행해도 됩니다)

---

## 📁 생성되는 파일

### Overview 플롯 (2개)
1. **`overview_frame_shares_smoothed.png`**
   - 각 프레임의 연도별 비율 (smoothed line)
   - 주요 전쟁 시기 표시
   - 해석: "Security spikes during wars; welfare emerges in 20th century"

2. **`overview_frame_shares_stacked.png`**
   - Stacked area chart
   - 전체 프레임 분포의 누적 시각화

### Focused Era 분석 (2개)
3. **`focused_era_by_party.png`**
   - 1945-2015 정당별 프레임 분포 (bar chart)

4. **`focused_era_timeseries.png`**
   - 1945-2015 Economy vs Security 프레임 시간 추세 (by party)

### Case Study (2개)
5. **`case_study_lbj_reagan.png`**
   - LBJ vs Reagan 프레임 비교 (stacked bar)

6. **`case_study_bush_obama.png`**
   - G.W. Bush vs Obama 프레임 비교 (stacked bar)

### 테이블 (4개)
- `focused_era_by_party.csv`
- `case_study_lbj_reagan.csv`
- `case_study_bush_obama.csv`
- `case_studies_summary.csv`

---

## 📝 Memo/Presentation 활용 방법

### Overview 플롯 활용:
> "Over 200+ years of SOTU speeches, we observe clear temporal patterns: 
> Security frames spike during major wars (Civil War, WWI, WWII, post-9/11), 
> while welfare frames are predominantly a 20th-century phenomenon, 
> emerging strongly in the post-WWII era."

### Focused Era 분석 활용:
> "To enable more comparable analysis, we focus on the post-WWII era (1945-2015). 
> In this period, we observe clear party differences: 
> Democrats emphasize economy and welfare frames more heavily, 
> while Republicans focus on governance and security."

### Case Study 활용:
> "Case studies of key presidents reveal individual framing strategies. 
> LBJ's speeches emphasized welfare frames (reflecting Great Society programs), 
> while Reagan focused on economy and values. 
> G.W. Bush's speeches were dominated by security frames (post-9/11), 
> while Obama's speeches emphasized economy frames (post-2008 financial crisis)."

---

## ⚠️ 주의사항

- 스크립트 실행 전에 `data/dfm_sotu_with_frames.rds` 파일이 있어야 합니다
- 이 파일은 `R/05_frame_model_or_rules.R` 실행으로 생성됩니다
- 전체 파이프라인을 처음 실행한다면 `R/00_run_all.R`을 사용하세요

---

## ✅ 실행 확인

스크립트가 성공적으로 실행되면:

```
✓ Saved: results/figures/overview_frame_shares_smoothed.png
✓ Saved: results/figures/overview_frame_shares_stacked.png
✓ Saved: results/figures/focused_era_by_party.png
✓ Saved: results/figures/focused_era_timeseries.png
✓ Saved: results/figures/case_study_lbj_reagan.png
✓ Saved: results/figures/case_study_bush_obama.png
```

이런 메시지가 출력됩니다.

