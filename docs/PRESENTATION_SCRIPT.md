# Final Project Presentation Script
## 5-Minute Presentation Script

**Total Time: 5 minutes**

---

## Slide 1: Research Question and Importance (45 seconds)

**[Start]**

"Good [morning/afternoon]. Today I'll present my analysis of framing in U.S. State of the Union speeches over 200 years.

**My research questions are:**

First, how do U.S. presidents frame key policy domains—specifically economy, security, welfare, governance, and values—in their SOTU speeches?

Second, how does framing differ by party—Democrats versus Republicans?

And third, how has framing changed over time, from Washington to Obama?

**Why does this matter?**

Framing theory tells us that how issues are framed shapes public perception and policy priorities. SOTU speeches are particularly important because they set the national agenda for the year. With 200-plus years of data, we can reveal long-term patterns that wouldn't be visible in shorter time periods.

The key insight here is that presidents don't just report facts—they frame issues to emphasize certain aspects over others. Understanding these framing strategies helps us understand how political communication has evolved."

**[Transition: 45 seconds]**

---

## Slide 2: Data (45 seconds)

**[Continue]**

"Let me describe my data.

I analyzed **236 State of the Union speeches** from 1790 to 2015, covering every U.S. president from Washington to Obama.

Each speech includes variables like president, year, party, and the full text.

**For preprocessing**, I used a standard text analysis pipeline: tokenization, stopword removal, and feature trimming. The final dataset has 236 documents with 6,687 features.

**I defined five frame categories:**

- Economy: growth, jobs, taxes, trade
- Security: defense, war, terrorism, foreign policy  
- Welfare: healthcare, education, social programs
- Governance: budget, deficit, government performance
- Values: democracy, rights, freedom, faith

**For validation**, I used 20 hand-coded speeches from Problem Set 2 to validate my automated frame assignment method."

**[Transition: 45 seconds]**

---

## Slide 3: Approach (60 seconds)

**[Continue]**

"My approach uses **dictionary-based frame assignment**.

**Step 1**: I defined five frame categories based on political communication theory and created keyword dictionaries—105 keywords total.

**Step 2**: I used quanteda's dictionary lookup to assign each speech to the frame with the highest keyword count. If there's a tie, I mark it as ambiguous.

**Step 3**: I validated this against 20 hand-coded speeches. The accuracy is 42.1 percent—this is a baseline for a dictionary-based method, and there's room for improvement.

**My analysis strategy has three parts:**

First, an **overview** of the full period from 1790 to 2015 to show long-term patterns.

Second, a **focused era** analysis of the post-World War II period—1945 to 2015—for more comparable analysis.

And third, **case studies** of key presidents: LBJ versus Reagan, and Bush versus Obama.

**Why dictionary-based?** It's transparent, interpretable, fast, and scalable. It provides a good baseline for future supervised learning approaches."

**[Transition: 60 seconds]**

---

## Slide 4: Results (90 seconds) - **MOST IMPORTANT**

**[Continue]**

"Now for my key findings.

**First, temporal patterns over 200-plus years:**

[**Show overview plot**] Security frames spike dramatically during major wars—the Civil War, World War I, World War II, and post-9/11. Welfare frames are predominantly a 20th-century phenomenon, emerging strongly in the modern era. Governance frames dominated early periods, reflecting federal institution building.

**Second, party differences in the post-World War II era:**

[**Show party comparison chart**] Republicans consistently emphasize governance frames—about 79 percent of their speeches. Democrats show more diverse framing strategies, with higher emphasis on economy—about 21 percent—and welfare—about 6.5 percent. This suggests systematic differences in how parties communicate.

**Third, individual presidential styles:**

[**Show case study**] LBJ emphasized welfare frames, reflecting his Great Society programs. Reagan focused on economy and values. G.W. Bush's speeches were dominated by security frames post-9/11. And Obama emphasized economy frames post-2008 financial crisis.

**These results show that framing is not random—it follows clear patterns based on historical context, party affiliation, and individual priorities.**"

**[Transition: 90 seconds]**

---

## Slide 5: Limitations and Next Steps (60 seconds)

**[Continue]**

"Let me acknowledge limitations and outline next steps.

**Limitations:**

First, the dictionary-based method has 42.1 percent accuracy—there's room for improvement. It may miss nuanced framing, and keyword lists could be refined.

Second, I only have 20 hand-coded speeches for validation—a small sample that limits statistical power.

Third, I'm doing speech-level analysis, assigning each speech a single dominant frame, but many speeches mix multiple frames.

Fourth, early speeches may have different language patterns, and my dictionary may be biased toward modern terminology.

**Next steps:**

First, expand hand-coding to 50 to 100 additional speeches for better validation and potential supervised learning.

Second, train a supervised classifier—like Naive Bayes or Logistic Regression—on hand-coded data to improve accuracy.

Third, implement a multi-label approach to allow multiple frames per speech.

Fourth, move to paragraph-level analysis for finer granularity.

And fifth, refine the dictionary based on validation results.

**In conclusion**, this analysis reveals clear patterns in presidential framing over 200-plus years, with systematic differences by party and individual style. Thank you."

**[End: 60 seconds]**

---

## Total Time Breakdown

- Slide 1: 45 seconds
- Slide 2: 45 seconds  
- Slide 3: 60 seconds
- Slide 4: 90 seconds (most important!)
- Slide 5: 60 seconds
- **Total: 5 minutes**

---

## Delivery Tips

### Pace
- **Slide 4 (Results)**에 가장 많은 시간 할당 (90초)
- 명확하고 천천히 말하기
- 중요한 숫자 강조 (79%, 21%, 42.1% 등)

### Visual Aids
- 각 슬라이드에 적절한 그래프 표시
- Slide 4에서 여러 그래프 사용 가능
- 그래프를 가리키며 설명

### Transitions
- 각 슬라이드 사이 자연스러운 전환
- "Let me describe...", "Now for...", "Moving to..." 같은 연결어 사용

### Emphasis Points
- **200+ years** - unique historical perspective
- **Party differences** - systematic patterns
- **War-time patterns** - security spikes
- **Individual styles** - presidential differences

---

## Practice Checklist

- [ ] 5분 안에 맞추기 연습
- [ ] 각 슬라이드의 핵심 포인트 명확히 전달
- [ ] 그래프를 가리키며 설명 연습
- [ ] 자연스러운 전환 구문 사용
- [ ] 질문 대비 (한계점, 방법론 등)

