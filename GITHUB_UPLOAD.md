# GitHub 업로드 가이드
## GitHub Upload Guide

## 방법 1: GitHub Desktop 사용 (가장 쉬움)

1. GitHub Desktop 앱 열기
2. File → Add Local Repository
3. `/Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech` 선택
4. Repository → Publish repository
5. Repository name: `nlp-clustering-us-speech`
6. Description: "Framing analysis of U.S. State of the Union speeches (1790-2015)"
7. Publish 클릭

## 방법 2: Command Line 사용

```bash
cd /Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech

# Git 초기화 (이미 되어있다면 스킵)
git init

# 원격 저장소 추가
git remote add origin https://github.com/HOYALIM/nlp-clustering-us-speech.git

# 모든 파일 추가
git add .

# 커밋
git commit -m "Initial commit: SOTU framing analysis project"

# 메인 브랜치로 푸시
git branch -M main
git push -u origin main
```

## 방법 3: GitHub 웹사이트에서 직접 업로드

1. https://github.com/HOYALIM/nlp-clustering-us-speech 접속
2. "uploading an existing file" 클릭
3. 파일들을 드래그 앤 드롭
4. Commit changes

## 포함된 파일

✅ **포함됨:**
- `R/` 폴더의 모든 스크립트 (10개)
- `data/SOTU_WithText.csv` (원본 데이터)
- `data/ps2_q4_handcoding_sample_labeled.csv` (hand-coding 결과)
- `results/` 폴더 (그림 8개, 테이블 14개)
- `README.md`
- `.gitignore`

❌ **제외됨 (`.gitignore`에 의해):**
- `*.rds` 파일들 (너무 큼, 스크립트 실행으로 재생성 가능)
- `*.pdf` 파일들 (개인 제출물)
- `.Rhistory`, `.Rproj` 등 임시 파일

## 주의사항

- RDS 파일들은 `.gitignore`에 의해 제외됩니다
- 사용자는 `R/00_run_all.R`을 실행하여 필요한 RDS 파일들을 재생성할 수 있습니다
- 원본 데이터 (`SOTU_WithText.csv`)와 hand-coding 결과는 포함됩니다

