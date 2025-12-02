# R Scripts Guide
## R 스크립트 설명 가이드

이 문서는 프로젝트의 각 R 스크립트(00-09)의 목적과 중점을 설명합니다.

---

## 📋 스크립트 개요

### 실행 순서
```
00_run_all.R → 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09
```

---

## 🔢 각 스크립트 상세 설명

### `00_run_all.R`
**목적**: 전체 분석 파이프라인을 순차적으로 실행하는 마스터 스크립트

**주요 기능**:
- 모든 분석 단계를 자동으로 실행
- Step 1부터 Step 9까지 순차 실행
- 최종 결과 요약 출력

**언제 사용**:
- 처음부터 전체 분석을 실행할 때
- 모든 결과를 한 번에 생성하고 싶을 때

**중점**:
- **자동화**: 수동 실행 없이 전체 파이프라인 실행
- **순차성**: 데이터 로드 → 전처리 → 분석 → 시각화 순서 보장

---

### `00_sample_for_handcoding.R`
**목적**: 추가 hand-coding을 위한 샘플 생성

**주요 기능**:
- 기존 hand-coding 제외한 샘플 생성
- Random, Stratified, Key Periods 샘플링 옵션 제공
- CSV 파일로 저장 (코딩용 템플릿)

**언제 사용**:
- Validation을 위해 추가 hand-coding이 필요할 때
- 20개 이상의 hand-coding 샘플이 필요할 때

**중점**:
- **샘플링**: 대표성 있는 샘플 선택
- **템플릿 생성**: 코딩을 위한 CSV 파일 생성

---

### `01_load_and_segment.R`
**목적**: 원본 데이터 로드 및 기본 전처리

**주요 기능**:
- `SOTU_WithText.csv` 로드
- `doc_id` 추가
- (선택적) 문단 분할 (paragraph segmentation)

**언제 사용**:
- 데이터를 처음 로드할 때
- Speech-level vs Paragraph-level 분석 선택 시

**중점**:
- **데이터 로드**: 원본 CSV 파일 읽기
- **ID 생성**: 각 문서에 고유 ID 부여
- **단위 선택**: Speech-level 또는 Paragraph-level 선택

**출력**: `data/sotu_speeches.rds`

---

### `02_preprocess_dfm.R`
**목적**: 텍스트 전처리 및 Document-Feature Matrix (DFM) 생성

**주요 기능**:
- Tokenization (문장부호, 숫자 제거)
- Lowercase 변환
- Stopword 제거 (영어)
- 짧은 토큰 제거 (최소 2자)
- DFM 생성 및 trimming (5% 이상 문서에 나타나는 단어만)

**언제 사용**:
- 텍스트 분석을 위한 전처리가 필요할 때
- LDA 또는 Dictionary 분석 전 필수 단계

**중점**:
- **전처리 파이프라인**: 표준 quanteda 전처리
- **DFM 생성**: 분석 가능한 형태로 변환
- **Feature trimming**: 희소한 단어 제거로 효율성 향상

**출력**: `data/dfm_sotu_trim.rds`, `data/corp_sotu.rds`

---

### `03_lda_exploration.R`
**목적**: LDA 토픽 모델링으로 데이터 탐색

**주요 기능**:
- DFM을 DTM으로 변환
- LDA 모델 학습 (K=10 토픽)
- 각 토픽의 상위 키워드 추출
- 토픽 비율 계산

**언제 사용**:
- 데이터의 주요 주제 구조를 파악하고 싶을 때
- 프레임 정의 전 탐색적 분석

**중점**:
- **탐색적 분석**: 데이터 구조 이해
- **토픽 발견**: 반복되는 주제 패턴 파악
- **프레임 정의 지원**: 5개 프레임 카테고리 정의에 참고

**출력**: `data/lda_model_sotu.rds`, `results/tables/lda_topics_top_terms.csv`

---

### `04_handcoding_join.R`
**목적**: Hand-coded 라벨을 전체 데이터셋에 병합

**주요 기능**:
- PS2 hand-coding 파일 로드 (`ps2_q4_handcoding_sample_labeled.csv`)
- 추가 hand-coding 파일 자동 감지 및 병합
- 중복 제거 및 통계 출력

**언제 사용**:
- Hand-coding 결과를 분석에 활용할 때
- Validation을 위해 hand-coding과 자동 할당 비교 시

**중점**:
- **라벨 병합**: Hand-coding 결과를 메인 데이터셋에 추가
- **자동 감지**: 여러 hand-coding 파일 자동 처리
- **통계 제공**: Hand-coding 샘플 분포 확인

**출력**: `data/sotu_with_handcoded_labels.rds`, `results/tables/handcoded_frames_by_party.csv`

---

### `05_frame_model_or_rules.R`
**목적**: Dictionary 기반 프레임 할당

**주요 기능**:
- 5개 프레임 카테고리별 키워드 사전 정의
- Dictionary lookup으로 각 문서의 프레임 점수 계산
- 가장 높은 점수의 프레임 할당 (tie → NA)
- Hand-coding과 비교하여 정확도 계산

**언제 사용**:
- 전체 데이터셋에 프레임을 자동 할당할 때
- Dictionary 기반 방법의 성능 평가

**중점**:
- **Dictionary 기반**: 키워드 매칭으로 프레임 할당
- **자동화**: 수동 코딩 없이 전체 데이터 처리
- **Validation**: Hand-coding과 비교하여 정확도 확인

**출력**: `data/dfm_sotu_with_frames.rds`, `results/tables/frame_assignment_validation.csv`

---

### `06_descriptive_plots.R`
**목적**: 기본 시각화 생성

**주요 기능**:
- Frame distribution over time (stacked area)
- Economy frame by party (time series)
- Frame distribution by party (bar chart)
- Security vs Economy over time
- Frame heatmap by decade

**언제 사용**:
- 기본적인 시각화가 필요할 때
- 전체 기간의 패턴을 보여주고 싶을 때

**중점**:
- **기본 시각화**: 전체 데이터셋의 주요 패턴 시각화
- **정당 비교**: Democratic vs Republican 차이
- **시간 추세**: 프레임 사용의 시간적 변화

**출력**: `results/figures/` (5개 PNG 파일)

---

### `07_results_analysis.R`
**목적**: 추가 분석 및 통계 생성

**주요 기능**:
- Historical era별 프레임 분포
- 주요 대통령별 프레임 사용 패턴
- 전쟁 시기 vs 평화 시기 비교
- 프레임 강도 분석 (keyword counts)
- 정당별 상세 비교

**언제 사용**:
- 더 깊이 있는 분석이 필요할 때
- 특정 시기나 대통령에 집중할 때

**중점**:
- **시기 분석**: Era별, 전쟁 시기별 패턴
- **대통령 분석**: 개별 대통령의 프레임 사용
- **통계 생성**: 상세 통계 테이블 생성

**출력**: `results/tables/` (5개 CSV 파일)

---

### `08_focused_analyses.R`
**목적**: 특정 시대에 집중한 분석

**주요 기능**:
- Modern Era (1990-2015) 분석
- 주요 대통령 비교 (1980-2015)
- Modern vs Historical 비교

**언제 사용**:
- 최근 시기에 집중하고 싶을 때
- 현대 대통령들을 비교하고 싶을 때

**중점**:
- **Modern Era**: 최근 25년 집중 분석
- **대통령 비교**: 개인 스타일 차이 확인
- **시기 비교**: Modern vs Historical 패턴 차이

**출력**: `results/figures/` (3개 PNG), `results/tables/` (3개 CSV)

---

### `09_strategic_analysis.R`
**목적**: 전략적 분석 (Overview + Focused Era + Case Studies)

**주요 기능**:
- **Overview 플롯**: 전체 기간(1790-2015) smoothed frame shares
- **Focused Era**: Post-WWII (1945-2015) 정당 비교
- **Case Studies**: LBJ vs Reagan, Bush vs Obama

**언제 사용**:
- Memo/Presentation용 주요 시각화 생성
- 전략적 분석 전략 구현

**중점**:
- **Overview**: 200+년 전체 패턴 (전쟁 시기 표시)
- **Focused Era**: 비교 가능한 시대 집중 (1945-2015)
- **Case Studies**: 대표적인 대통령 비교

**출력**: `results/figures/` (6개 PNG), `results/tables/` (4개 CSV)

---

## 🔄 스크립트 간 의존성

```
01_load_and_segment.R
  ↓
02_preprocess_dfm.R
  ↓
03_lda_exploration.R (선택적)
  ↓
04_handcoding_join.R
  ↓
05_frame_model_or_rules.R
  ↓
06_descriptive_plots.R
  ↓
07_results_analysis.R (선택적)
  ↓
08_focused_analyses.R (선택적)
  ↓
09_strategic_analysis.R (선택적)
```

**필수 단계**: 01 → 02 → 04 → 05 → 06  
**선택적 단계**: 03, 07, 08, 09

---

## 💡 사용 가이드

### 처음부터 전체 분석 실행:
```r
source("R/00_run_all.R")
```

### 특정 단계만 실행:
```r
# 데이터만 로드
source("R/01_load_and_segment.R")

# 전처리만
source("R/02_preprocess_dfm.R")

# Strategic analysis만 (이미 데이터 처리됨)
source("R/09_strategic_analysis.R")
```

### Hand-coding 추가:
```r
# 샘플 생성
source("R/00_sample_for_handcoding.R")
# → CSV 파일에 코딩 후
# → 다시 04 실행하여 병합
source("R/04_handcoding_join.R")
```

---

## 📊 출력 파일 요약

| 스크립트 | 주요 출력 |
|---------|---------|
| 01 | `data/sotu_speeches.rds` |
| 02 | `data/dfm_sotu_trim.rds` |
| 03 | `data/lda_model_sotu.rds` |
| 04 | `data/sotu_with_handcoded_labels.rds` |
| 05 | `data/dfm_sotu_with_frames.rds` |
| 06 | 5개 PNG (기본 시각화) |
| 07 | 5개 CSV (추가 통계) |
| 08 | 3개 PNG + 3개 CSV (Modern era) |
| 09 | 6개 PNG + 4개 CSV (Strategic) |

---

## 🎯 각 스크립트의 핵심 목적

- **00-02**: 데이터 준비 (로드, 전처리)
- **03**: 탐색적 분석 (LDA)
- **04-05**: 프레임 할당 (Hand-coding 병합, Dictionary 할당)
- **06**: 기본 시각화
- **07-09**: 심화 분석 (시기별, 대통령별, 전략적)

