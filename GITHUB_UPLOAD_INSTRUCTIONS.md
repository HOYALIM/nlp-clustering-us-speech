# GitHub 업로드 완전 가이드
## Complete Upload Instructions

현재 GitHub 저장소: https://github.com/HOYALIM/nlp-clustering-us-speech

---

## 🚀 업로드 방법

### 방법 1: GitHub Desktop 사용 (가장 쉬움) ⭐ 권장

1. **GitHub Desktop 다운로드** (없다면): https://desktop.github.com/
2. **GitHub Desktop 열기**
3. **File → Add Local Repository** 클릭
4. **폴더 선택**: `/Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech`
5. **Repository → Publish repository** 클릭
   - Repository name: `nlp-clustering-us-speech` (이미 존재하므로 업데이트됨)
   - Description: "Framing analysis of U.S. State of the Union speeches (1790-2015)"
   - ✅ "Keep this code private" 체크 해제 (Public으로)
6. **Publish** 또는 **Push origin** 클릭

---

### 방법 2: Command Line 사용

터미널에서 다음 명령어를 순서대로 실행:

```bash
# 1. 프로젝트 디렉토리로 이동
cd /Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech

# 2. Git 초기화 (이미 되어있다면 스킵)
git init

# 3. 원격 저장소 추가 (이미 있다면 스킵)
git remote add origin https://github.com/HOYALIM/nlp-clustering-us-speech.git

# 4. 모든 파일 추가
git add .

# 5. 커밋
git commit -m "Complete project: SOTU framing analysis with R Markdown and documentation"

# 6. 메인 브랜치로 설정
git branch -M main

# 7. GitHub에 푸시
git push -u origin main
```

**이미 파일이 있다면** (충돌 발생 시):
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

---

### 방법 3: GitHub 웹사이트에서 직접 업로드

1. https://github.com/HOYALIM/nlp-clustering-us-speech 접속
2. **"uploading an existing file"** 클릭
3. 파일들을 드래그 앤 드롭
4. **Commit changes** 클릭

---

## 📁 업로드될 파일 목록

### 필수 파일들
- ✅ `README.md` - 프로젝트 개요
- ✅ `analysis.Rmd` - R Markdown 분석 문서
- ✅ `.gitignore` - 제외 파일 설정
- ✅ `R/` 폴더 - 모든 R 스크립트 (10개)
- ✅ `data/SOTU_WithText.csv` - 원본 데이터
- ✅ `data/ps2_q4_handcoding_sample_labeled.csv` - Hand-coding 결과
- ✅ `results/figures/` - 모든 시각화 (14개 PNG)
- ✅ `results/tables/` - 모든 통계 테이블 (14개 CSV)

### 문서 파일들
- ✅ `FIGURES_INTERPRETATION.md` - 그래프 해석 가이드
- ✅ `R_SCRIPTS_GUIDE.md` - R 스크립트 설명
- ✅ `STRATEGIC_ANALYSIS_GUIDE.md` - 전략적 분석 가이드
- ✅ `GITHUB_UPLOAD.md` - 업로드 가이드
- ✅ `GITHUB_FINAL_CHECKLIST.md` - 체크리스트

---

## ❌ 제외될 파일들 (.gitignore에 의해)

다음 파일들은 자동으로 제외됩니다:
- `*.rds` 파일들 (너무 큼, 스크립트 실행으로 재생성 가능)
- `*.pdf` 파일들 (개인 제출물)
- `*.Rproj` 파일들
- `.Rhistory` 등 임시 파일들
- `*_cache/` 폴더 (R Markdown 캐시)

---

## ✅ 업로드 후 확인사항

GitHub 저장소에 다음이 보여야 합니다:

1. **README.md** - 프로젝트 설명
2. **analysis.Rmd** - R Markdown 파일
3. **R/** 폴더 - 10개 스크립트
4. **data/** 폴더 - CSV 파일들
5. **results/** 폴더 - 그림과 테이블
6. **문서 파일들** - MD 파일들

---

## 🔍 문제 해결

### "Repository already exists" 오류
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### "Permission denied" 오류
- GitHub 인증 확인 필요
- Personal Access Token 사용 또는 SSH 키 설정

### 파일이 너무 큰 경우
- `.gitignore`에 의해 큰 파일은 자동 제외됨
- RDS 파일들은 제외되고, CSV와 PNG만 업로드됨

---

## 📝 업로드 후 할 일

1. **README.md 확인**: GitHub에서 제대로 보이는지 확인
2. **파일 구조 확인**: 모든 폴더와 파일이 업로드되었는지 확인
3. **analysis.Rmd 확인**: R Markdown 파일이 보이는지 확인
4. **시각화 확인**: `results/figures/` 폴더의 PNG 파일들이 보이는지 확인

---

## 💡 팁

- **GitHub Desktop**을 사용하면 가장 쉽고 안전합니다
- 업로드 전에 `.gitignore` 파일을 확인하여 불필요한 파일이 제외되는지 확인하세요
- 큰 파일(RDS)은 제외되므로, 사용자는 스크립트를 실행하여 재생성할 수 있습니다

