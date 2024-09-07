# Advanced Quantitative Methods II (API-210) - Harvard University

This repository contains course materials, problem sets, exams, and solutions for the **Advanced Quantitative Methods II (API-210)** course taught by Prof. Will Dobbie at the Harvard Kennedy School. This course focuses on advanced econometric methods for causal inference and policy evaluation, with emphasis on real-world data analysis using R.

## Course Overview

**Course Title**: Advanced Quantitative Methods II (API-210)  
**Instructor**: Prof. Will Dobbie, Harvard Kennedy School  
**Institution**: Harvard University

The course covers a range of econometric techniques aimed at evaluating public policies and understanding causal relationships. Core topics include Regression Discontinuity Design (RDD), Instrumental Variables (IV), Difference-in-Differences (DID), and Randomized Control Trials (RCTs). Each problem set and exam is designed to reinforce theoretical concepts through hands-on data analysis.

## Syllabus

The course is structured around the following key methodologies:

1. **Instrumental Variables (IV)**
   - Addressing endogeneity using IV methods.
   - Applications in labor economics and public policy.
   - Interpreting results and testing instrument validity.

2. **Regression Discontinuity Design (RDD)**
   - Sharp and fuzzy RDD implementations.
   - Identification strategies in program evaluation.
   - Estimating causal effects near cutoff points.

3. **Difference-in-Differences (DID)**
   - Leveraging policy changes to study treatment effects.
   - Addressing potential biases in longitudinal data.
   - Assumptions and robustness checks.

4. **Randomized Control Trials (RCT)**
   - Designing and analyzing RCTs for policy evaluation.
   - Managing randomization, compliance, and attrition.
   - Use cases in education and development economics.

## Problem Sets

### **Problem Set 1: Randomized Control Trials (RCTs)**

- **Research Question**: How does the form of grant provision (cash vs. in-kind) affect the growth of microenterprises in Ghana?
- **Methods**:
  - Analysis of an RCT studying the effect of cash versus in-kind grants.
  - Implementation of ITT and TOT estimation, using clustered standard errors at the firm level.
  - Insights into the "Flypaper Effect," where in-kind grants lead to larger impacts on business outcomes than cash grants.
- **Key Findings**: In-kind transfers have a stronger positive effect on business outcomes, especially for female-owned enterprises.

### **Problem Set 2: Instrumental Variables (IV)**

- **Research Question**: How does compulsory schooling affect earnings in the long term?
- **Methods**:
  - Implementation of an IV approach using the quarter of birth as an instrument for schooling years.
  - Replication of Angrist and Krueger's landmark study on the returns to education.
  - Estimation of the Wald estimator and analysis of instrument relevance and validity.
- **Key Findings**: Compulsory schooling laws significantly raise educational attainment, leading to higher long-term earnings.

### **Problem Set 3: Regression Discontinuity Design (RDD)**

- **Research Question**: What is the impact of participation in the Head Start program on child health and education outcomes?
- **Methods**:
  - Use of sharp and fuzzy RDD to estimate the impact of Head Start participation on child mortality rates and educational outcomes.
  - Implementation of non-parametric methods with optimal bandwidth selection and kernel-weighted regressions.
  - Validation of results through robustness checks.
- **Key Findings**: The Head Start program significantly reduces child mortality and improves educational outcomes, confirming its positive impact.

### **Problem Set 4: Difference-in-Differences (DID)**

- **Research Question**: How do unilateral divorce laws impact domestic violence, suicide, and spousal homicide rates?
- **Methods**:
  - Application of DID methodology to analyze the impact of legal changes across U.S. states.
  - Testing the parallel trends assumption and conducting robustness checks.
  - Estimation of the impact of divorce law changes on key social outcomes.
- **Key Findings**: Unilateral divorce laws lead to a reduction in domestic violence and spousal homicide but have mixed effects on suicide rates.

## Midterm Exam

- **Research Question**: What is the impact of school vouchers on students' math scores in India?
- **Methods**:
  - Analysis of randomized lottery data from a school voucher program in India.
  - Estimation of ITT and TOT using 2SLS to account for selection bias.
  - Examination of the conditional independence assumption and balance testing.
- **Key Findings**: Private school attendance, induced by winning a school voucher lottery, has a positive effect on student math scores, although selection bias must be accounted for.

## Final Exam

- **Research Question**: What are the long-term effects of losing Supplemental Security Income (SSI) on criminal charges and employment outcomes?
- **Methods**:
  - IV analysis of a policy change involving SSI eligibility review.
  - Implementation of RDD to estimate the impact of SSI loss on criminal justice outcomes.
  - Estimation of causal effects through local linear regressions and DID analysis to examine policy-induced changes over time.
- **Key Findings**: The loss of SSI benefits leads to significant increases in criminal charges, highlighting the importance of safety net programs in preventing negative social outcomes.

## Technologies Used

- **Programming Language**: R
- **Key Libraries**: `haven`, `broom`, `lfe`, `tidyverse`, `forcats`, `glue`, `ggplot2`, `rdrobust`

## Contact Information

For any questions or comments regarding this repository, please feel free to contact [Shreya Chaturvedi](https://shreya3296.github.io/).
