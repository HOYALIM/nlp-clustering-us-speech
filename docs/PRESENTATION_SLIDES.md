# Final Project Presentation Slides
## Framing in U.S. State of the Union Speeches (1790-2015)

**5-Minute Presentation Outline**

---

## Slide 1: Research Question and Importance

### Title: How Do U.S. Presidents Frame Policy in State of the Union Speeches?

**Research Questions:**
1. How do U.S. presidents frame the nation's **economy, security, welfare, governance, and values** in SOTU speeches?
2. How does framing differ by **party** (Democrat vs Republican)?
3. How has framing changed **over time** (from Washington to Obama)?

**Why This Matters:**
- **Framing theory**: How issues are framed shapes public perception and policy priorities
- **Agenda-setting**: SOTU speeches set the national agenda for the year
- **Historical perspective**: 200+ years of data reveal long-term patterns
- **Party differences**: Understanding how parties communicate differently

**Key Insight**: Presidents don't just report facts—they **frame** issues to emphasize certain aspects over others.

---

## Slide 2: Data

### Data Source and Characteristics

**Dataset:**
- **236 SOTU speeches** from 1790 to 2015
- **Variables**: president, year, party, sotu_type, text
- **Coverage**: Every U.S. president from Washington to Obama

**Preprocessing:**
- Standard text preprocessing pipeline
- Tokenization, stopword removal, feature trimming
- Final dataset: 236 documents × 6,687 features

**Frame Categories:**
- **Economy**: growth, jobs, taxes, trade
- **Security**: defense, war, terrorism, foreign policy
- **Welfare**: healthcare, education, social programs
- **Governance**: budget, deficit, government performance
- **Values**: democracy, rights, freedom, faith

**Validation:**
- 20 hand-coded speeches from PS2
- Used to validate automated frame assignment

---

## Slide 3: Approach

### Methodology: Dictionary-Based Frame Assignment

**Step 1: Frame Definition**
- Defined 5 frame categories based on political communication theory
- Created keyword dictionaries for each frame (105 keywords total)

**Step 2: Frame Assignment**
- Dictionary lookup using quanteda
- Each speech assigned to frame with highest keyword count
- Ties → NA (ambiguous cases)

**Step 3: Validation**
- Compared automated assignment with 20 hand-coded speeches
- Accuracy: 42.1% (baseline for dictionary-based method)

**Step 4: Analysis Strategy**
- **Overview**: Full period (1790-2015) to show long-term patterns
- **Focused Era**: Post-WWII (1945-2015) for comparable analysis
- **Case Studies**: Key presidents (LBJ vs Reagan, Bush vs Obama)

**Why Dictionary-Based?**
- Transparent and interpretable
- Fast and scalable
- Good baseline for future supervised learning

---

## Slide 4: Results

### Key Findings

**1. Temporal Patterns (1790-2015)**
- **Security frames spike during major wars**: Civil War, WWI, WWII, post-9/11
- **Welfare frames emerge in 20th century**: Predominantly modern phenomenon
- **Governance frames dominate early periods**: Federal institution building

**2. Party Differences (1945-2015)**
- **Republicans**: Emphasize **governance** frames (78.9%)
- **Democrats**: More diverse framing, higher **economy** (20.7%) and **welfare** (6.5%)

**3. Case Studies**
- **LBJ**: Emphasized welfare frames (Great Society programs)
- **Reagan**: Focused on economy and values
- **G.W. Bush**: Security frames dominated (post-9/11)
- **Obama**: Economy frames emphasized (post-2008 crisis)

**Visual Evidence:**
- Overview plots show security spikes during wars
- Party comparison reveals systematic differences
- Case studies show individual presidential styles

---

## Slide 5: Limitations and Next Steps

### Limitations

**1. Dictionary-Based Method**
- Accuracy: 42.1% (room for improvement)
- May miss nuanced framing
- Keyword lists could be refined

**2. Sample Size**
- Only 20 hand-coded speeches for validation
- Small sample limits statistical power

**3. Speech-Level Analysis**
- Each speech assigned single dominant frame
- Many speeches mix multiple frames

**4. Historical Context**
- Early speeches (pre-1900) may have different language patterns
- Dictionary may be biased toward modern terminology

### Next Steps

**1. Expand Hand-Coding**
- Code 50-100 additional speeches
- Better validation and potential for supervised learning

**2. Supervised Classification**
- Train classifier (Naive Bayes, Logistic Regression) on hand-coded data
- Improve accuracy beyond dictionary baseline

**3. Multi-Label Approach**
- Allow multiple frames per speech
- Capture mixed framing strategies

**4. Paragraph-Level Analysis**
- Move from speech-level to paragraph-level
- Finer granularity for frame detection

**5. Refine Dictionary**
- Update keywords based on validation results
- Add domain-specific terms

---

## Presentation Tips

### Timing (5 minutes total)
- **Slide 1**: 45 seconds (Research question)
- **Slide 2**: 45 seconds (Data)
- **Slide 3**: 60 seconds (Approach)
- **Slide 4**: 90 seconds (Results - 가장 중요!)
- **Slide 5**: 60 seconds (Limitations & Next steps)

### Key Points to Emphasize
1. **200+ years of data** - unique historical perspective
2. **Clear party differences** - systematic framing strategies
3. **War-time patterns** - security frames spike during conflicts
4. **Individual styles** - presidents have distinct framing approaches

### Visual Aids
- Use overview plots to show long-term patterns
- Use party comparison charts to highlight differences
- Use case study visuals to show individual styles

---

## Suggested Visuals for Each Slide

**Slide 1**: Title slide with project logo/theme
**Slide 2**: Data overview table or timeline
**Slide 3**: Methodology flowchart
**Slide 4**: 
  - `overview_frame_shares_smoothed.png` (전체 패턴)
  - `focused_era_by_party.png` (정당 차이)
  - `case_study_lbj_reagan.png` 또는 `case_study_bush_obama.png` (Case study)
**Slide 5**: Limitations summary + next steps roadmap

